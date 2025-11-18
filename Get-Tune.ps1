function Get-Tune {

    <#
    .SYNOPSIS
        Gets tunes
    .DESCRIPTION
        Gets musical tunes that can be played.

        Tunes can be stored in:

        |Format                    |Extension                |
        |--------------------------|-------------------------|
        |Tune Clixml               |```.tune.clixml```       |
        |Tune JSON                 |```.tune.json```         |    
        |Tune PowerShell Data file |```.tune.psd1```         |
        |Tune Generator            |```.tune.ps1```          |
        |Tune Text                 |```.tune.txt```          |
    .EXAMPLE
        Get-Tune
    #>    
    param(
    # The path to tune files or directories.
    # If not provided, will default to looking for tunes beneath TerminalTunes and any modules that tag TerminalTunes.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string[]]
    $TunePath,

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
    $Title,

    # If set, will invalidate the cache of tunes and reload any tunes.
    [switch]
    $Force
    )

    begin {
        # If we do not have a tune cache, create one.
        if (-not $script:TuneCache) {
            $script:TuneCache = [Ordered]@{}
        }
        # Tune files can be .clixml, .json, .ps1, .psd1, or .txt
        $tuneExtensions = '.clixml','.json','.ps1', '.psd1', '.txt'
        # create a regex that will match any of them.
        $tuneFilePattern = "\.tune\.(?>$($tuneExtensions -replace '^\.' -join '|'))"
    }

    process {
        # If a -TunePath was not provided
        if (-not $TunePath) {            
            $MyModuleInfo = $MyInvocation.MyCommand.Module
            # We will use the TerminalTunes module path
            $myModulePath = $MyModuleInfo | Split-Path
            # Any the module paths of any modules that Tag 'TerminalTunes'
            $relatedModulePaths = @(
                
                
                @(
                
                $MyModuleName, $myModule = 
                    if ($MyModuleInfo -is [string]) {
                        $MyModuleInfo, (Get-Module $MyModuleInfo)
                    } elseif ($MyModuleInfo -is [Management.Automation.PSModuleInfo]) {
                        $MyModuleInfo.Name, $MyModuleInfo
                    } else {
                        Write-Error "$MyModuleInfo must be a [string] or [Management.Automation.PSModuleInfo]"    
                    }
                
                
                #region Search for Module Relationships
                if ($myModule -and $MyModuleName) {
                    foreach ($loadedModule in Get-Module) { # Walk over all modules.
                        if ( # If the module has PrivateData keyed to this module
                            $loadedModule.PrivateData.$myModuleName
                        ) {
                            # Determine the root of the module with private data.            
                            $relationshipData = $loadedModule.PrivateData.$myModuleName
                            [PSCustomObject][Ordered]@{
                                PSTypeName     = 'Module.Relationship'
                                Module        = $myModule
                                RelatedModule = $loadedModule
                                PrivateData   = $loadedModule.PrivateData.$myModuleName
                            }
                        }
                        elseif ($loadedModule.PrivateData.PSData.Tags -contains $myModuleName) {
                            [PSCustomObject][Ordered]@{
                                PSTypeName     = 'Module.Relationship'
                                Module        = $myModule
                                RelatedModule = $loadedModule
                                PrivateData   = @{}
                            }
                        }
                    }
                }
                #endregion Search for Module Relationships
                
                )
                
                
            ) | 
                Select-Object -ExpandProperty RelatedModule | 
                Split-Path

            $TunePath = @($myModulePath) + @($relatedModulePaths)
        }
        
        # Now, create the tune list by walking thru each tune path
        $tunelist = @(foreach ($tp in $TunePath) {
            # get the path item
            $pathItem = Get-Item -Path $tp -ErrorAction Ignore
            if ($pathItem -is [IO.DirectoryInfo]) {
                # If it's a directory, call yourself recursively and cache it.
                if (-not $script:TuneCache.Contains($pathItem.FullName) -or $Force) {
                    $script:TuneCache[$pathItem.FullName] = @(
                        Get-ChildItem -Path $TunePath.Fullname -Recurse -Filter *.tune.* |
                            Where-Object Extension -In $tuneExtensions |
                            Get-Tune
                    )
                }
                if ($script:TuneCache.Contains($pathItem.FullName)) {
                    $script:TuneCache[$pathItem.FullName]
                }
            }
            elseif ($pathItem -is [IO.FileInfo]) {
                # If the path was a file
                # skip it if it doesn't match our pattern.
                if ($pathItem.Name -notmatch $tuneFilePattern) { continue }
                if (-not $script:TuneCache.Contains($pathItem.FullName) -or $Force) {
                    $tuneData = 
                    switch ($pathItem.Extension) {
                        # If it was .clixml, just import-clixml
                        '.clixml' {
                            Import-Clixml -Path $pathItem.FullName
                        }
                        # If it was .json
                        '.json' {                            
                            Get-Content -Path $pathItem.FullName -Raw | 
                                ConvertFrom-Json | # convert from json
                                ForEach-Object {
                                    if ($_.Tune) { # and fix escape sequences
                                        $_.Tune = $_.Tune -replace '[`\\]e', "`e"
                                    }
                                    $_
                                }
                        }
                        # If it was a .ps1
                        '.ps1' {
                            # get the script.
                            $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')                                
                        }
                        # If it was a .PSD1
                        '.psd1' {
                            # read the file as data language.
                            [PSCustomObject](& ([ScriptBlock]::Create("data {$($(Get-Content -Path $pathItem.FullName -Raw)) }")))
                        }
                        # If it was a .TXT file
                        '.txt' {
                            # Replace the file title and include the tune.
                            [PSCustomObject][Ordered]@{
                                Title = $pathItem.Name -replace '\.tune\.txt$' -replace '[_-]', ' '
                                Tune  = (Get-Content -Path $pathItem.FullName -Raw) -replace '[`\\]e', "`e"
                            }
                        }
                    }
                    
                    # If we had no tune data, clear the cache at this point
                    if (-not $tuneData) {
                        $script:TuneCache[$pathItem.FullName] = $null
                        continue
                    }
                    
                    # Decorate all tune data as a 'TerminalTunes.Tune'
                    $tuneData.pstypenames.clear()
                    $tuneData.pstypenames.add('TerminalTunes.Tune')
                    # If it was a script, 
                    if ($tuneData -is [Management.Automation.ExternalScriptInfo]) {
                        # also decorate it to be a 'TerminalTunes.Generator'
                        $tuneData.pstypenames.add('TerminalTunes.Generator')
                    }
                    $script:TuneCache[$pathItem.FullName] = $tuneData
                }
                $tuneData = $script:TuneCache[$pathItem.FullName]
                if ($tuneData) {
                    $tuneData
                }
            }
        })

        # If -Title was provided
        if ($Title) {
            # filter the tunes by title
            $tuneList | Where-Object Title -Like $title
        }
        else {
            # otherwise, output all tunes.
            $tuneList
        }
    }   

}

