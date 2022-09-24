$ansiNote = $this.GetANSINoteRegex()

if ($this.Tune) {
    foreach ($match in $ansiNote.Matches($this.Tune)) {
        $matchOut = [Ordered]@{}
        $noteStart = 0
        foreach ($group in $match.Groups) {
            if ($group.Name -eq 'Volume') {
                $matchOut[$group.Name] = $group.Value -as [int]
            }
            elseif ($group.Name -eq 'Duration') {
                $matchOut[$group.Name] = 
                    [TimeSpan]::FromMilliseconds(($group.Value -as [int]) * (1/32) * 1000)
            }
            elseif ($group.Name -eq 'Notes') {
                $matchOut[$group.Name] = @() 
                $noteStart = $group.Index
            }
            elseif ($noteStart -and $group.Success) {
                $matchOut.Notes += $group.Name -replace 'Sharp','#'
            }            
        }
        $matchOut.Tune = $match.Value
        [PSCustomObject]$matchOut
    }
}