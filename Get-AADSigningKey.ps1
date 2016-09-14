# this PS1 script will update a Service Princpal's preferredTokenSigningKeyThumbprint value
# Supply the application (also known as client id) of the service princpal.
# install AAD Graph Module if needed, authenticate the user, then prompt the user for the Application ID (aka clientId)
# that we would like to set the tokenSigningKeyThumbprint.
#
Param(
    $Tenant = "common",
    $Environment="prod",

    [switch]$Latest,
    [string]$DownloadPath
)

if (!(get-module -ListAvailable | Where Name -Match AADGraph)){
  .\Install-AADGraphModule.ps1
}

$authority = "https://login.microsoftonline.com/"
if($Environment.ToLower() -eq "china"){ $authority = "https://login.chinacloudapi.cn/" }

$keysUrl = "$authority$Tenant/discovery/keys";
$keysJson = ConvertFrom-Json (Invoke-WebRequest $keysUrl).Content

$certs = @()
foreach ($key in $keysJson.keys) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($key.x5c)
    $cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @(,$bytes)

    $certs += new-object PSObject -Property @{ 'Kid'=$key.kid; 'Thumbprint'=$cert.Thumbprint; 'NotAfter'=$cert.NotAfter; 'NotBefore'=$cert.NotBefore; 'Cert'=$cert }
}

if ($Latest) {
    $certs = $certs | sort -Descending {$_.NotBefore} | Select -First 1
}

if ($DownloadPath) {
    foreach ($cert in $certs) {
        $path = Join-Path $DownloadPath ($cert.Thumbprint.ToLower() + ".cer")
        [System.IO.File]::WriteAllBytes($path, $cert.Cert.Export("Cert"));
        Write-Host "Certificate successfully exported to $path"
    }
}

$certs
