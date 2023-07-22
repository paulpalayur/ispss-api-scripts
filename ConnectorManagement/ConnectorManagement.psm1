Import-Module "$($PSScriptRoot)\..\Common\Common.psm1"
function Get-Connectors {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage='Please provide the Subdomain')]
        [ValidateNotNullOrEmpty()]
        [string]$Subdomain,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the OAuth Token')]
        [ValidateNotNullOrEmpty()]
        [string]$BearerToken
    )

    begin {
        $uri = "https://$($Subdomain)-component_manager.cyberark.cloud/api/connectors"
        $header = Get-OAuthHeader -BearerToken $BearerToken
    }

    process {
        try {
            return Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        }
        catch {
            if($_.ErrorDetails.Message) {
                Write-Error $_.ErrorDetails.Message
            } else {
                Write-Error $_
            }
        }
    }
}
