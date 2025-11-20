<#
.SYNOPSIS
    Converts from MusicXML into friendly format.
.DESCRIPTION
    Converts any notes found in music XML input into any number of friendly note sequences
#>
$allArgsAndInput = @($input) + $args

$allNoteNodes = $allArgsAndInput |
    Select-Xml -ErrorAction Ignore -XPath //note

if (-not $allNoteNodes) { return }

$voices = [Ordered]@{}

foreach ($noteNode in $allNoteNodes) {
    $note = $noteNode.Node
    
    if (-not $note.voice) {
        continue
    }
    $voiceName = "$($note.voice)"
    if (-not $voices[$voiceName]) {
        $voices[$voiceName] = @()
    }

    $noteText = if ($note.rest) {
        "~"
    } else {
        $note.pitch.step + $(
            switch ($note.pitch.alter) {
                -1 { 'b' }
                1 { '#' }
            }
        ) + $note.pitch.octave 
    }
    

    $noteText = switch ($note.type) {
        half {
            "$noteText@$(1/2)"
        }
        quarter {
            "$noteText@$(1/4)"
        }
        eighth {
            "$noteText@$(1/8)"
        }
        16th {
            "$noteText@$(1/16)"
        }
        32nd {
            "$noteText@$(1/32)"
        }
        64th {
            "$noteText@$(1/64)"
        }
        128th {
            "$noteText@$(1/128)"
        }
        default {
            $noteText
        }
    }        
    $voices[$voiceName] += $noteText
}

return $voices