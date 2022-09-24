[Regex]::new(@'
(?<ANSI_Note>
\e                          # An Escape
\[                          # Followed by a bracket
(?>
  (?<Volume>(?<VolumeOff>0) # 0 is no volume
    |
    (?<VolumeLow>[1-3])     # 1-3 is low volume
    |
    (?<VolumeHigh>[4-7])    # 4-7 is high volume
))\;                        # A semicolon separated the volume from the duration
# Duration is measured in 1/32 of a second
(?<Duration>\d+)\;          # A semicolon separates the duration from the note
# One or more notes will follow
(?<Notes>(?:(?>
  (?<C5>25)                 # 25 is C in the 6th octave (MIDI 96)
  |
  (?<B5>24)                 # 24 is B in the 5th octave (MIDI 95)
  |
  (?<ASharp5>23)            # 23 is A Sharp in the 5th octave (MIDI 94)
  |
  (?<A5>22)                 # 22 is A in the 5th octave (MIDI 93)
  |
  (?<GSharp5>21)            # 21 is G Sharp in the 5th octave (MIDI 92)
  |
  (?<G5>20)                 # 20 is G in the 5th octave (MIDI 91)
  |
  (?<FSharp5>19)            # 19 is F Sharp in the 5th octave (MIDI 90)
  |
  (?<F5>18)                 # 18 is F in the 5th octave (MIDI 89)
  |
  (?<E5>17)                 # 17 is F in the 5th octave (MIDI 88)
  |
  (?<DSharp5>16)            # 16 is D Sharp in the 5th octave (MIDI 87)
  |
  (?<D5>15)                 # 15 is D in the 5th octave (MIDI 86)
  |
  (?<CSharp5>14)            # 14 is C Sharp in the 5th octave (MIDI 85)
  |
  (?<C5>13)                 # 13 is C in the 5th octave (MIDI 84)
  |
  (?<B4>12)                 # 12 is B in the 4th octave (MIDI 83)
  |
  (?<ASharp4>11)            # 11 is A Sharp in the 4th octave (MIDI 82)
  |
  (?<A4>10)                 # 10 is A in the 4th octave (MIDI 81)
  |
  (?<GSharp4>9)             # 9 is G Sharp in the 4th octave (MIDI 80)
  |
  (?<G4>8)                  # 8 is G in the 4th octave (MIDI 79)
  |
  (?<FSharp4>7)             # 7 is F Sharp in the 4th octave (MIDI 78)
  |
  (?<F4>6)                  # 6 is F in the 4th octave (MIDI 77)
  |
  (?<E4>5)                  # 5 is E in the 4th octave (MIDI 76)
  |
  (?<DSharp4>4)             # 4 is D Sharp in the 4th octave (MIDI 75)
  |
  (?<D4>3)                  # 3 is D in the 4th octave (MIDI 74)
  |
  (?<CSharp4>2)             # 2 is C Sharp in the 4th octave (MIDI 73)
  |
  (?<C4>1)                  # 1 is C in the 4th octave (MIDI 72)
)\;?){0,}),~                # A command and a tilda end the sequence
)
'@, 'IgnoreCase,IgnorePatternWhitespace')
