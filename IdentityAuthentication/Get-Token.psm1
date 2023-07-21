function Get-APIServiceUserToken {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage='Please provide your tenant subdomain')]
        [ValidateNotNullOrEmpty()]
        [string]$Subdomain,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the API user')]
        [ValidateNotNullOrEmpty()]
        [string]$APIUserName,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the API user')]
        [ValidateNotNullOrEmpty()]
        [string]$Password
    )

    begin {
        $tenantURL = "https://$($Subdomain).cyberark.cloud/api/idadmin/oauth2/platformtoken"

        $body=@{
            client_id = $APIUserName
            client_secret = $Password
            grant_type = "client_credentials"
        }
    }

    process {
        try {
            Write-Verbose "Tenant url: $($tenantURL)"
            $response = Invoke-RestMethod -Uri $tenantURL -Method Post -Body $body
            return @{"Authorization" = "Bearer $($response.access_token)"}
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