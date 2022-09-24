## TerminalTunes

TerminalTunes is a music player for terminals.

Did you know that some terminals can play tunes?

Since 1.15, Windows Terminal has been able to play a limited range of notes using DECPS escape sequences.

TerminalTunes provides a little library of known tunes and a few tune generators to let you make your own music.

Go ahead and give it a try:

~~~PowerShell
Install-Module TerminalTunes -Scope CurrentUser -Force
Import-Module TerminalTunes
🎶StarWarsImperialMarch🎶
~~~

### List of Tunes

You can get the list of tunes in TerminalTunes with Get-Tune.

~~~PipeScript {
    Import-Module ./TerminalTunes.psd1 -Global
    [PSCustomObject]@{
        Table = Get-Tune | Where-Object -not IsGenerator 
            .Title .Alias {
                "🎶$($_.Title -replace '\W')🎶"
            } .IsGenerator
    }
}
~~~

### Tune Generators

TerminalTunes also includes a few small scripts to make your own music.

~~~PipeScript {    
    [PSCustomObject]@{
        Table = Get-Tune | Where-Object IsGenerator 
            .Title .Alias {
                "🎶$($_.Title -replace '\W')🎶"
            } .IsGenerator
    }
}
~~~




