describe TerminalTunes {
    it 'Has a library of tunes' {
        $tunes = Get-Tune
        $tunes.Title | Should -Not -Be $null
    }
    it 'Can carry a tune' {
        🎶StarWarsImperialMarch🎶
    }
}
