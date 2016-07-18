

function Get-AADServicePrincipals() {
  $objects = $null
  if($global:aadGPoShAuthResult -ne $null){
    $header = $global:aadGPoShAuthResult.CreateAuthorizationHeader()
    $uri = [string]::Format("https://graph.windows.net/{0}/servicePrincipals?api-version=1.22-preview",$global:aadGPoShAuthResult.TenantId)
    Write-Host HTTP GET $uri -ForegroundColor Cyan
    $result = Invoke-RestMethod -Method Get -Uri $uri -Headers @{"Authorization"=$header} -ContentType "application/json"
    if ($result -ne $null) {
      $objects = $result.Value
    }
  }
  else{
    Write-Host "Not connected to an AAD tenant. First run Connect-AAD." -ForegroundColor Yellow
  }
  return $objects
}

function Get-AADServicePrincipalByObjectId([string]$objectId) {
  $object = $null
  if($global:aadGPoShAuthResult -ne $null){
    $header = $global:aadGPoShAuthResultt.CreateAuthorizationHeader()
    $uri = [string]::Format("https://graph.windows.net/{0}/servicePrincipals/{1}?api-version=1.22-preview",$global:aadGPoShAuthResult.TenantId, $objectId.Trim())
    Write-Host HTTP GET $uri -ForegroundColor Cyan
    $object = Invoke-RestMethod -Method Get -Uri $uri -Headers @{"Authorization"=$header} -ContentType "application/json"
  }
  else{
    Write-Host "Not connected to an AAD tenant. First run Connect-AAD." -ForegroundColor Yellow
  }
  return $object
}