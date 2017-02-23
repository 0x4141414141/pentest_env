# ==============================================================================
#
# Fervent Coder Copyright 2011 - Present - Released under the Apache 2.0 License
#
# Copyright 2007-2008 The Apache Software Foundation.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use
# this file except in compliance with the License. You may obtain a copy of the
# License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
# ==============================================================================

# variables
#$url = "https://chocolatey.org/packages/chocolatey/DownloadPackage"
$url = "https://chocolatey.org/api/v2/package/chocolatey/"
#$url = "https://chocolatey.org/api/v1/package/chocolatey"
$chocTempDir = Join-Path $env:TEMP "chocolatey"
$tempDir = Join-Path $chocTempDir "chocInstall"
if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "chocolatey.zip"

# download the package
Write-Host "Downloading $url to $file"
$downloader = new-object System.Net.WebClient
$downloader.DownloadFile($url, $file)

# unzip the package
Write-Host "Extracting $file to $destination..."
$shellApplication = new-object -com shell.application
$zipPackage = $shellApplication.NameSpace($file)
$destinationFolder = $shellApplication.NameSpace($tempDir)
$destinationFolder.CopyHere($zipPackage.Items(),0x10)

# call chocolatey install
Write-Host "Installing chocolatey on this machine"
$toolsFolder = Join-Path $tempDir "tools"
$chocInstallPS1 = Join-Path $toolsFolder "chocolateyInstall.ps1"

& $chocInstallPS1

write-host 'Ensuring chocolatey commands are on the path'
$chocInstallVariableName = "ChocolateyInstall"
$nuGetPath = [Environment]::GetEnvironmentVariable($chocInstallVariableName, [System.EnvironmentVariableTarget]::User)
$nugetExePath = 'C:\ProgramData\Chocolatey\bin'
if ($nuGetPath -ne $null) {
  $nugetExePath = Join-Path $nuGetPath 'bin'
}

if ($($env:Path).ToLower().Contains($($nugetExePath).ToLower()) -eq $false) {
  $env:Path = [Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::Machine);
}
Write-Host "THIS IS DEPRECATED. Please use the install from https://chocolatey.org/install.ps1"
# update chocolatey to the latest version
#Write-Host "Updating chocolatey to the latest version"
#cup chocolatey
