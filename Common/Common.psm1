function Get-OAuthHeader {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage='Please provide the OAuth Token')]
        [ValidateNotNullOrEmpty()]
        [string]$BearerToken
    )
    process {
        return @{"Authorization" = "Bearer $($BearerToken)"}
    }
}