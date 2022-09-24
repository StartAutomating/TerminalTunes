param(
[Collections.IDictionary]
$Parameter
)

if ($this.IsGenerator) {
    $this | Add-Member LastParameters $Parameter -Force
}

if (-not $this.Tune) {
    return
}

[Console]::Write([Regex]::Replace($this.Tune, '[`\\]e', {"`e"}))