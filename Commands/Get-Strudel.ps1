function Get-Strudel {
    <#
    .SYNOPSIS
        Gets Strudel
    .DESCRIPTION
        Gets an offline definition of Strudel
    .EXAMPLE
        strudel 'note("48 67 63 [62, 58]").sound("piano gm_electric_guitar_muted")'
    #>
    param(
    [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]
    [PSObject]
    $Strudel,

    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Uri
    )

    begin {
        $utf8 = [Text.UTF8Encoding]::new()                    
    }

    process {
        if ($Uri -and -not $Uri.Fragment) {
            Write-Error "Uri fragment expected"
            return
        }


        $strudelBaseObject = [Ordered]@{PSTypeName='Strudel'}
        

        if ($Strudel) {
            if (Test-Path $Strudel -ErrorAction Ignore) {
                $Strudel = Get-Content $Strudel -Raw
            }
            $strudelAsUri = $Strudel -as [uri]
            if (-not $strudelAsUri.Fragment) {
                $strudelBaseObject.Strudel = "$strudel"
            } else {
                $uri = $strudelAsUri
            }            
        }
        
        if ($uri.Fragment) {
            $strudelBaseObject.Strudel = $utf8.GetString([Convert]::FromBase64String(
                [Web.HttpUtility]::UrlDecode($Uri.Fragment -replace '^#')
            ))            
        }
        
        
        [PSCustomObject]$strudelBaseObject
    }


}
