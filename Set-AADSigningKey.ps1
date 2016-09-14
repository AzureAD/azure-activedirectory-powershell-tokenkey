# this PS1 script will update a Service Princpal's preferredTokenSigningKeyThumbprint value
# Supply the application (also known as client id) of the service princpal.
# install AAD Graph Module if needed, authenticate the user, then prompt the user for the Application ID (aka clientId)
# that we would like to set the tokenSigningKeyThumbprint.
#
Param(
    $Tenant = "common",
    $Environment="prod",

    [parameter(mandatory=$true)]
    [string]$ApplicationId,

    [parameter(parametersetname="SpecificCert")]
    [string]$KeyThumbprint,

    [parameter(parametersetname="Latest")]
    [switch]$Latest,

    [parameter(parametersetname="Default")]
    [switch]$Default
)

if (!(get-module -ListAvailable | Where Name -Match AADGraph)){
  .\Install-AADGraphModule.ps1
}

if ($Default) { $KeyThumbprint = "unused" }
elseif ($Latest) { $KeyThumbprint = .\Get-AADSigningKey.ps1 -Latest | Select -ExpandProperty Thumbprint }

connect-aad -Tenant $Tenant -Env $Environment
$KeyThumbprint = $KeyThumbprint.Replace(" ","").ToLower()
$content = @{preferredTokenSigningKeyThumbprint = $KeyThumbprint}

$global:aadGPoShGraphVer = "1.5"
$sp = Get-AADObject -Type servicePrincipals -Query "`&`$filter=appId eq '$ApplicationId'"

if ($sp -ne $null)
{
 write-host "Service principal found"
 $sp
 write-host "Updating service principal..."
 $global:aadGPoShGraphVer = "1.22-preview"
 Set-aadObject -id $sp.objectId -type servicePrincipals -object $content
 start-sleep 5
 get-aadObjectById -type servicePrincipals -id $sp.objectId | select objectId, appId, displayName, preferredTokenSigningKeyThumbprint | fl
}
else
{
  write-host "Service principal was not found - Please check the Client (Application) ID"
}
