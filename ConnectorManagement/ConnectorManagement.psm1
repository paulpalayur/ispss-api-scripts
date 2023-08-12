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
        [string]$OSType = "windows",

        [Parameter(Mandatory=$false, HelpMessage='Please provide the installation Path for the agent. Default is set to C:\Program Files')]
        [ValidateNotNullOrEmpty()]
        [string]$InstallationPath = "C:\Program Files"
    )

    begin {
        $uri = "https://$($Subdomain)-component_manager.cyberark.cloud/api/setup-script"
        $header = Get-OAuthHeader -BearerToken $BearerToken
        $header.Add("Content-Type", "application/json")
        $body = @{
            osType = $OSType
            installationPath = $InstallationPath
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

function Install-CPM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage='Please provide the Subdomain')]
        [ValidateNotNullOrEmpty()]
        [string]$ConnectorId,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the Subdomain')]
        [ValidateNotNullOrEmpty()]
        [string]$Subdomain,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the OAuth Token')]
        [ValidateNotNullOrEmpty()]
        [string]$BearerToken,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the Component Name')]        
        [string]$ComponentName="CPM",

        [Parameter(Mandatory=$true, HelpMessage='Please provide the CPM User Name')]
        [ValidateNotNullOrEmpty()]
        [string]$CPMUserName,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the Installation Path')]
        [ValidateNotNullOrEmpty()]
        [string]$InstallPath,

        [Parameter(Mandatory=$true, HelpMessage='Is CPM Inactive? Default set to false')]
        [ValidateNotNullOrEmpty()]
        [bool]$CPMInactive=$false,

        [Parameter(Mandatory=$false, HelpMessage='Is POC Mode?')]
        [ValidateNotNullOrEmpty()]
        [bool]$PoCMode=$false,

        [Parameter(Mandatory=$true, HelpMessage='Provide the installer user name')]
        [ValidateNotNullOrEmpty()]
        [string]$InstallerUserName,

        [Parameter(Mandatory=$true, HelpMessage='Provide the installer User Password')]
        [ValidateNotNullOrEmpty()]
        [string]$InstallerUserPassword,

        [Parameter(Mandatory=$true, HelpMessage='Provide the Vault IP or FQDN')]
        [ValidateNotNullOrEmpty()]
        [string]$VaultIP,

        [Parameter(Mandatory=$false, HelpMessage='Is PSM installed')]
        [ValidateNotNullOrEmpty()]
        [bool]$isPSMInstalled=$true,

        [Parameter(Mandatory=$false, HelpMessage='Label')]
        [ValidateNotNullOrEmpty()]
        [string]$label="CPM",

        [Parameter(Mandatory=$false, HelpMessage='Component Information')]
        [ValidateNotNullOrEmpty()]
        [string]$ComponentInformation="Central Policy Manager (CPM) is a password management component that generates new random passwords and replaces existing passwords on remote machines. The new passwords are then stored in the EPV where they benefit from all accessibility and security features of the EPV.",

        [Parameter(Mandatory=$false, HelpMessage='Is Checked')]
        [ValidateNotNullOrEmpty()]
        [bool]$checked=$true,

        [Parameter(Mandatory=$false, HelpMessage='Is disabled')]
        [ValidateNotNullOrEmpty()]
        [bool]$disabled=$false

    )
    
    begin {

                
        $uri = "https://$($Subdomain)-component_manager.cyberark.cloud/api/connectors/$($ConnectorId)/components"
        $header = Get-OAuthHeader -BearerToken $BearerToken
        $header.Add("Content-Type", "application/json")
        $body = @{
            componentName = $ComponentName
            label = $label
            componentInformation = $ComponentInformation
            checked = $checked
            disabled = $disabled
            extraVars = @{
                cpmUserName = $CPMUserName
                installPath = $InstallPath
                cpmInactive = $CPMInactive
                pocMode = $PoCMode
                vaultUser = $InstallerUserName
                vaultPassword = $InstallerUserPassword
                vaultIP = $VaultIP
                isPSMInstalled = $isPSMInstalled
            }
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

function Install-PSM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage='Please provide the Subdomain')]
        [ValidateNotNullOrEmpty()]
        [string]$ConnectorId,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the Subdomain')]
        [ValidateNotNullOrEmpty()]
        [string]$Subdomain,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the OAuth Token')]
        [ValidateNotNullOrEmpty()]
        [string]$BearerToken,

        [Parameter(Mandatory=$true, HelpMessage='Please provide the Component Name')]        
        [string]$ComponentName="psm",


        [Parameter(Mandatory=$true, HelpMessage='Please provide the Installation Path')]
        [ValidateNotNullOrEmpty()]
        [string]$InstallPath,

        [Parameter(Mandatory=$false, HelpMessage='Is POC Mode?')]
        [ValidateNotNullOrEmpty()]
        [bool]$PoCMode=$false,

        [Parameter(Mandatory=$true, HelpMessage='Provide the installer user name')]
        [ValidateNotNullOrEmpty()]
        [string]$InstallerUserName,

        [Parameter(Mandatory=$true, HelpMessage='Provide the installer User Password')]
        [ValidateNotNullOrEmpty()]
        [string]$InstallerUserPassword,

        [Parameter(Mandatory=$true, HelpMessage='Provide the Vault IP or FQDN')]
        [ValidateNotNullOrEmpty()]
        [string]$VaultIP,

        [Parameter(Mandatory=$true, HelpMessage='Provide the Administrator user domain')]
        [ValidateNotNullOrEmpty()]
        [bool]$PSMIsDomain=$true,

        [Parameter(Mandatory=$true, HelpMessage='Provide the Administrator user domain')]
        [ValidateNotNullOrEmpty()]
        [string]$Domain,

        [Parameter(Mandatory=$true, HelpMessage='Provide the Administrator Domain User Name')]
        [ValidateNotNullOrEmpty()]
        [string]$DomainUserName,

        [Parameter(Mandatory=$true, HelpMessage='Provide the Administrator Domain User Password')]
        [ValidateNotNullOrEmpty()]
        [string]$DomainUserPassword,

        [Parameter(Mandatory=$false, HelpMessage='Label')]
        [ValidateNotNullOrEmpty()]
        [string]$label="PSM",

        [Parameter(Mandatory=$false, HelpMessage='Component Information')]
        [ValidateNotNullOrEmpty()]
        [string]$ComponentInformation="Privileged Session Manager (PSM) enables organizations to secure, control and monitor privileged access to network devices. ",

        [Parameter(Mandatory=$false, HelpMessage='Is Checked')]
        [ValidateNotNullOrEmpty()]
        [bool]$checked=$true,

        [Parameter(Mandatory=$false, HelpMessage='Is disabled')]
        [ValidateNotNullOrEmpty()]
        [bool]$disabled=$false

    )
    
    begin {

                
        $uri = "https://$($Subdomain)-component_manager.cyberark.cloud/api/connectors/$($ConnectorId)/components"
        $header = Get-OAuthHeader -BearerToken $BearerToken
        $header.Add("Content-Type", "application/json")
        $body = @{
            componentName = $ComponentName
            label = $label
            componentInformation = $ComponentInformation
            checked = $checked
            disabled = $disabled
            extraVars = @{
                domain = $Domain
                domainUserName = $DomainUserName
                domainUserPassword = $DomainUserPassword                
                installPath = $CPMInstallPath
                pocMode = $PoCMode
                vaultUser = $InstallerUserName
                vaultPassword = $InstallerUserPassword
                vaultIP = $VaultIP
                psmIsDomain = $PSMIsDomain
            }
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
