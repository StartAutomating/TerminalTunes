@{
    ModuleVersion    = '0.1'
    RootModule       = 'TerminalTunes.psm1'
    Description      = 'A Music Player for Terminals'
    TypesToProcess   = 'TerminalTunes.types.ps1xml'
    FormatsToProcess = 'TerminalTunes.format.ps1xml'
    Guid             = '66e51179-3815-4557-b8e9-63309326c45d'
    Author           = 'James Brundage'
    CompanyName      = 'Start-Automating'
    Copyright        = '2022'
    PrivateData      = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/TerminalTunes'
            LicenseURI = 'https://github.com/StartAutomating/TerminalTunes/blob/main/LICENSE'
            ReleaseNotes = @'
## 0.1
* Initial Release of TerminalTunes
  * Get-Tune lists tunes 
  * Start-Tune plays tunes
  * Tunes can either be an escape sequence or a tune generator
* Initial Tunes:

|Title                           |Alias                          |
|--------------------------------|-------------------------------|
|Calvary Charge                  |🎶CalvaryCharge🎶             |
|Happy Birthday                  |🎶HappyBirthday🎶             |
|Harry Potter Theme              |🎶HarryPotterTheme🎶          |
|In the Hall of the Mountain King|🎶IntheHalloftheMountainKing🎶|
|Jingle Bells                    |🎶JingleBells🎶               |
|Ms Pacman Theme                 |🎶MsPacmanTheme🎶             |
|Reveille                        |🎶Reveille🎶                  |
|Star Wars Imperial March        |🎶StarWarsImperialMarch🎶     |

* Initial Tune Generators
|Title         |Alias              |
|--------------|-------------------|
|CircleOfFifths|🎶CircleOfFifths🎶|
|Note          |🎶Note🎶          |
|Scale         |🎶Scale🎶         |          
---
'@
        }
    }
}
