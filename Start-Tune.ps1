function Start-Tune {

    <#
    .SYNOPSIS
        Starts a Tune
    .DESCRIPTION
        Starts a Tune.

        If the Tune contains escape sequences, will attempt to play the tune at the terminal.
    .EXAMPLE
        # You can start any tune by title
        Start-Tune -Title "Ms PacMan Theme"

        # You can also use the emoji for notes surrounding any title (minus whitespace)
        🎶MsPacmanTheme🎶
    #>
    [Alias('Play-Tune')]
    param(
    # The title of a tune.  Can include wildcards.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ArgumentCompleter({
        param ( $commandName,$parameterName,$wordToComplete,$commandAst,$fakeBoundParameters )    
                                
        $tuneList = @(if ($wordToComplete) {
            $toComplete = $wordToComplete -replace "^['`"]" -replace "['`"]$"
            Get-Tune -Title "$toComplete*"
        } else {
            Get-Tune
        })
        @(foreach ($tune in $tunelist) {
            if ($tune.Title) {
                $tune.Title
            }
        }) -replace '^', "'" -replace '$',"'"
    })]
    [string]
    $Title
    )

    dynamicParam {
        # If we were called with an alias
        if ($MyInvocation.InvocationName -like '🎶*🎶') {
            # Find the real long title
            $title = $script:TuneShortTitleToLongTitle[$MyInvocation.InvocationName -replace '🎶']
            # and get the tune
            $tuneList = Get-Tune -Title $Title
            # If there were no tunes, there are no dynamic parameters.
            if (-not $tuneList) { return }
            # If there was not a generator, there are no dynamic parameters.
            if (-not $tuneList.IsGenerator) { return }

            # Return dynamic parameters for every parameter in the generator.
            $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()            
            :nextInputParameter foreach ($in in ([Management.Automation.CommandMetaData]$tuneList).Parameters.Keys) {
                $DynamicParameters.Add($in, [Management.Automation.RuntimeDefinedParameter]::new(
                    $tuneList.Parameters[$in].Name,
                    $tuneList.Parameters[$in].ParameterType,
                    $tuneList.Parameters[$in].Attributes
                ))
            }
        
            $DynamicParameters
        }
    }

    process {
        # Check to see that a title was provided or inferred
        if (-not $title) {
            if ($MyInvocation.InvocationName -like '🎶*🎶') {
                $title = $script:TuneShortTitleToLongTitle[$MyInvocation.InvocationName -replace '🎶']
            }
            # If it was neither, 
            if (-not $title) {
                # error out.
                Write-Error "Must provide -Title or use an alias, for example 🎶MsPacMan🎶"
                return
            }
        }
        elseif ($script:TuneShortTitleToLongTitle[$title]) {
            $Title = $script:TuneShortTitleToLongTitle[$title]
        }

        # Get a list of tunes with that title.
        $tuneList = Get-Tune -Title $Title

        # If there were none, return
        if (-not $tuneList) { 
            return
        }
        # Walk over each tune in the list
        foreach ($tune in $tuneList) {
            # If it was a generator
            if ($tune.IsGenerator) {
                $isSafe = $tune.IsSafe()
                $paramCopy = @{} + $PSBoundParameters
                $paramCopy.Remove('Title')
                $tune.Play($paramCopy) # play the tune with the parameters provided.
            } else {
                # otherwise, just Play the tune.
                $tune.Play()
            }            
        }
    }

}

