<#
.SYNOPSIS
    Gets the Strudel Url
.DESCRIPTION
    Gets the Strudel as a Url
#>
return "https://strudel.cc/#" + (
    [Web.HttpUtility]::UrlEncode(
        [Convert]::ToBase64String(
            $utf8.GetBytes("$($this.Strudel)")
        )
    ) -replace '\+', '%20'
)