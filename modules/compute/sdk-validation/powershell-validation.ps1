try {
    Import-Module OCI.PSModules.Identity
    Get-OCIIdentityRegionsList > $null
}
catch [Exception]{
    Write-Host "OCI Powershell Modules may not be Installed: $_"
    return
}

Write-Host "OCI Powershell Modules Install Validation Success"
