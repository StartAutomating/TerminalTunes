foreach ($match in [Regex]::Matches("$($this.Strudel)", "/\*(?<comment>[\s\S]+?)\*/")) {
    $match.Groups['comment'].Value
}