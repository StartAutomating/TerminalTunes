[Include('*-*')]$psScriptRoot

$Script:TuneShortTitleToLongTitle = [Ordered]@{}
$script:TuneLongtitleToShortTitle = [Ordered]@{}
Get-Tune | 
    ForEach-Object {
        $shortTitle = $_.Title -replace '\W'
        $script:TuneLongtitleToShortTitle[$_.Title] = $shortTitle
        $Script:TuneShortTitleToLongTitle[$shortTitle] = $_.Title
        if ($_.IsGenerator) {
            $tuneGenerator = $_
            foreach ($tuneAlias in $tuneGenerator.ScriptBlock.Attributes.AliasNames) {
                if ($tuneAlias -and $tuneAlias -ne $shortTitle) { 
                    $Script:TuneShortTitleToLongTitle[$tuneAlias] = $_.Title
                    Set-Alias "🎶$($tuneAlias)🎶" Start-Tune
                }    
            }
        }
        Set-Alias "🎶$($shortTitle)🎶" Start-Tune
    }

Export-ModuleMember -Function * -Alias *