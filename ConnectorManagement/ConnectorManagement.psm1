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

function Get-Components {
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
        $uri = "https://$($Subdomain)-component_manager.cyberark.cloud/api/components"
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

function Get-Connector {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage='Please provide the Subdomain')]
        [ValidateNotNullOrEmpty()]
        [string]$Subdomain,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the OAuth Token')]
        [ValidateNotNullOrEmpty()]
        [string]$BearerToken,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the Connector Id')]
        [ValidateNotNullOrEmpty()]
        [string]$ConnectorId
    )

    begin {
        $uri = "https://$($Subdomain)-component_manager.cyberark.cloud/api/connectors/$($ConnectorId)/"
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

function Get-SetupScript {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage='Please provide the Subdomain')]
        [ValidateNotNullOrEmpty()]
        [string]$Subdomain,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the OAuth Token')]
        [ValidateNotNullOrEmpty()]
        [string]$BearerToken,

        [Parameter(Mandatory=$false, HelpMessage='Please provide the OS type. Default is windows')]
        [ValidateNotNullOrEmpty()]
        [string]$OSType = "windows"
    )

    begin {
        $uri = "https://$($Subdomain)-component_manager.cyberark.cloud/api/setup-script"
        $header = Get-OAuthHeader -BearerToken $BearerToken
        $header.Add("Content-Type", "application/json")
        $body = @{
            osType = $OSType
        }|ConvertTo-Json
    }

    process {
        try {
            return Invoke-RestMethod -Uri $uri -Method Post -Headers $header -Body $body
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