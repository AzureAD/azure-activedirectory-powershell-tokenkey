# this PS1 script will update a Service Princpal's preferredTokenSigningKeyThumbprint value
# Supply the application (also known as client id) of the service princpal.
# install AAD Graph Module if needed, authenticate the user, then prompt the user for the Application ID (aka clientId)
# that we would like to set the tokenSigningKeyThumbprint to the old value.
#
Param($tenant = "common", $env="prod")

$notInstalled = $true;
foreach($module in (get-module))
{
  if ($module.name -ilike "*AADGraph*")
  {
    $notInstalled = $false;
    break;
  }
}
if ($notInstalled){
  .\install-aadGraphModule.ps1
}

connect-aad -Tenant $tenant -Env $env
$content = @{preferredTokenSigningKeyThumbprint = "3270bf5597004df339a4e62224731b6bd82810a6"}
$appId = read-host "Enter the Application ID (Client ID)"

$global:aadGPoShGraphVer = "1.5"
$sp = Get-AADObject -Type servicePrincipals -Query "`&`$filter=appId eq '$appId'"

if ($sp -ne $null)
{
 write-host "Service principal found"
 $sp
 write-host "Updating service princpal..."
 $global:aadGPoShGraphVer = "1.22-preview"
 Set-aadObject -id $sp.objectId -type servicePrincipals -object $content 
 start-sleep 5
 get-aadObjectById -type servicePrincipals -id $sp.objectId | select objectId, appId, displayName, preferredTokenSigningKeyThumbprint | fl
}
else
{
  write-host "Service principal was not found - please check the Client (Application) ID"
}
