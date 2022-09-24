<#
.SYNOPSIS
    Plays a note
.DESCRIPTION
    Plays one or more notes in a limited range, for a specified duration (rounded to the nearest 32nd of a second)
#>
[Alias('Notes')]
param(
# One or more notes.
[Alias('Notes')]
[ValidateSet('REST', 'C5', 'C#5', 'D5', 'D#5', 'E5', 'F5', 'F#5', 'G5','G#5','A5', 'A#5', 'B5', 
    'C6', 'C#6','D6','D#6','E6','F6','F#6','G6','G#6','A6','A#6', 'B6', 'C7')]
[string[]]
$Note = 'C5',

# The duration to play the note.
[Alias('NoteTiming')]
[timespan]
$Duration = $([Timespan]::FromMilliseconds(1000  * 8/32 )),

# The volume of the note (default 3)
[Alias('NoteVolume')]
[ValidateRange(0,7)]
[int]
$Volume = 3
)

$duration32nds = [Math]::Round($Duration.TotalMilliseconds / (1/32 * 1000))
$noteValues = $MyInvocation.MyCommand.Parameters.Note.Attributes.ValidValues
$notes = @(
    foreach ($n in $note) {
        $noteValues.IndexOf($n.ToUpper())
    }
) -join ';'

"`e[$volume;$duration32nds;$notes,~"