if (-not $this.IsSafe()) { return }
if ($this.LastParameters) {
    $lp = $this.LastParameters
    & $this @lp
} else {    
    & $this
}