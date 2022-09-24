<#
.SYNOPSIS
    Generates a scale of notes
.DESCRIPTION
    Generates a scale of musical notes.
#>
param(
# The starting point of the scale. By default, C5.
[ValidateSet('REST', 'C5', 'C#5', 'D5', 'D#5', 'E5', 'F5', 'F#5', 'G5','G#5','A5', 'A#5', 'B5', 
    'C6', 'C#6','D6','D#6','E6','F6','F#6','G6','G#6','A6','A#6', 'B6', 'C7')]
[string]
$StartPoint = 'C5',

# The number of notes to play.  By default, 5.
[int]
$NoteCount = 5,

# The timing for each note.  By default, .2 seconds.
[Alias('Duration')]
[timespan]
$NoteTiming = 200,

# The scale step.  By default, 2.
[int]
$ScaleStep = 2,

# The volume [0-7].  By default, 3.
[ValidateRange(0,7)]
[int]
$Volume = 3
)

$NoteList = $MyInvocation.MyCommand.Parameters.StartPoint.Attributes.ValidValues
$actualTiming = [Math]::Round($NoteTiming.TotalMilliseconds / (1/32 * 1000))
$NoteListIndex = $NoteList.IndexOf($StartPoint)

for ($NoteNumber = 0; $NoteNumber -lt $NoteCount; $NoteNumber++) {
    "`e[$volume;$actualTiming;$NoteListIndex,~"
    $NoteListIndex += $ScaleStep
    if ($NoteListIndex -le 0) { break }
    if ($NoteListIndex -gt 25) { break }
}



