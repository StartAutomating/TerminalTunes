if (-not $this.CachedNoteCount) {
    $notes = @($this.GetNotes())    
    [Timespan]$duration = 0
    $noteCount = 0 
    foreach ($note in $notes) {
        $duration += ($note.Duration * ($note.Notes.Length))
        $noteCount += $note.Notes.Length
    }
    $this | Add-Member NoteProperty CachedDuration $duration -Force
    $this | Add-Member NoteProperty CachedNoteCount $noteCount -Force
}
if ($this.CachedDuration) {
    $this.CachedDuration
} else {
    $duration
}
