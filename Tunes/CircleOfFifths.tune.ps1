<#
.SYNOPSIS
    Generates the Circle of Fifths
.DESCRIPTION
    Generates a note sequence using the Circle of Fifths
.LINK
    https://en.wikipedia.org/wiki/Circle_of_fifths
#>
param(
# The starting point along the circle of fifths
[ValidateSet('C','G','D','A','E','B','F#', 'C#','A','E','B')]
[string]
$StartPoint = 'C',

# The note count (by default, 5)
[int]
$NoteCount = 5,

# The note timing
[timespan]
$NoteTiming = 200,

# The note volume [0-7].  By default, 3.
[ValidateRange(0,7)]
[int]
$Volume = 3
)

$actualTiming = [Math]::Ceiling($NoteTiming.TotalMilliseconds / (1/32 * 1000))

$noteSequence = @($MyInvocation.MyCommand.Parameters.StartPoint.Attributes.ValidValues)
$startIndex = $noteSequence.IndexOf($StartPoint)

for ($index = $startIndex; $index -lt ($startIndex + $NoteCount); $index++) {
    $noteIndex =  $index % $noteSequence.Length
    "`e[$volume;$actualTiming;" + $(
        switch ($noteSequence[$noteIndex]) {
            'C' {
                13
            }
            'G' {
                20
            }
            'D' {
                15
            }
            'A' {
                22
            }
            'E' {
                17
            }
            'B' {
                12
            }
            'F#' {
                19
            }
            'C#' {
                14
            }            
        }
    ) + ",~"
}




