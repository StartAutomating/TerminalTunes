<#
.SYNOPSIS
    Extracts notes from DECPS
.DESCRIPTION
    Extracts notes from DECPS
.LINK
    https://web.mit.edu/dosathena/doc/www/ek-vt520-rm.pdf
.LINK
    https://tightloop.io/terminal-decps/
.NOTES
    DECPS is a format originally supported by the [DEC VT250](https://en.wikipedia.org/wiki/VT520).
    
    It is also supported in some moderns Terminal (Windows Terminal, Contour)

    DECPS notes have a limited two octave range (between C5 and C7)

    This script converts DECPS notes into a simple friendly notation that is compatible with Strudel.    

    Notes in this format should match the pattern:

    `(?<letter>[~abcdef])(?<sharp>\#?)(?<octave>\d)?(?:@(?<duration>[\d\.]+))?`

    Which is a very long way of saying:

    a-f # <any number> @ <any decimal>    
#>
param()

$inputAndArgs = @($input) + $args

foreach ($match in [Regex]::Matches(($inputAndArgs -join ' '), '\e\[.+?,~')) {    
    $notes = @()
    $volume, $time, $notes = $match -replace '^\e\[' -replace ',~$' -split ';'
    if (-not $notes) { continue }
    $fraction = $time / 32
    $friendlyNotes = switch ($notes) {
        0 { "~" }
        1 { "c5" }
        2 { "c#5" }
        3 { "d5" }
        4 { "d#5" }
        5 { "e5" }
        6 { "f5" }
        7 { "f#5" }
        8 { "g5" }
        9 { "g#5" }
        10 { "a5" }
        11 { "a#5" }
        12 { "b5" }
        13 { "c6" }
        14 { "c#6" }
        15 { "d6" }
        16 { "d#6" }
        17 { "e6" }
        18 { "f6" }
        19 { "f#6" }
        20 { "g6" }
        21 { "g#6" }
        22 { "a6" }
        23 { "a#6" }
        24 { "b6" }
        25 { "c7" }
    }
    
    foreach ($note in $friendlyNotes) {
        "$($note)@$($fraction)"
    }
}