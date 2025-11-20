<#
.SYNOPSIS
    Gets the text of a tune
.DESCRIPTION
    Gets a tune represented in human readable text.
#>
if ($this.'.Text') {
    return $this.'.Text'
}
elseif ($this.Tune -match '\e') {
    return ($this.FromDECPS($this.Tune) -join ' ')
}
elseif ($this.Voices -is [Collections.IDictionary]) {
    foreach ($voiceName in $this.Voices.Keys) {
        "`$${voiceName}:$($this.Voices[$voiceName])"
    }
    
}