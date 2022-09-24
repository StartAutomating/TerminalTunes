foreach ($file in (Get-ChildItem -Path "$psScriptRoot" -Filter "*-*" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    if ($file.Name -match '\.[^\.]+\.ps1$') { continue }  # Skip if the file is an unrelated file.
    . $file.FullName
}

$Script:TuneShortTitleToLongTitle = [Ordered]@{}
$script:TuneLongtitleToShortTitle = [Ordered]@{}
Get-Tune -TunePath $psScriptRoot | 
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
