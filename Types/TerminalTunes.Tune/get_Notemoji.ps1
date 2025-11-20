$fromDecps = $this.FromDECPS($this.Tune)

foreach ($note in $fromDecps) {
    $fraction = @($note -split '@')[1] -as [double]    
    $timelessNote = $note -replace '@.+?$'
    $timelessNote = $timelessNote -replace '\#', '♯'    
    switch ($fraction) {
        (1/4) {
            $timelessNote + " `u{1D15F}"
        }
        (1/2) {
            $timelessNote + " `u{1D1E3}"
        }
        (1/16) {
            $timelessNote + " `u{1D161}"
        }
        (1/8) {
            $timelessNote + " `u{1D160}" 
        }
        (1/64) {
            $timelessNote + " `u{1d163}"
        }
        (1/128) {
            $timelessNote + " `u{1d164}"
        }
        default { 
            $note
        }
    }    
}