# === CONFIG ===
$repoUser = "HussienX123"
$repoName = "EDSIMZ-TIMER-BUILD"
$branch = "main"  # or "master"
$downloadUrl = "https://github.com/$repoUser/$repoName/archive/refs/heads/$branch.zip"
$tempZip = "$env:TEMP\UpdatePackage.zip"
$extractTo = "$env:TEMP\UpdateExtracted"

# === Download ZIP ===
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip

# === Extract ZIP ===
if (Test-Path $extractTo) { Remove-Item $extractTo -Recurse -Force }
Expand-Archive -Path $tempZip -DestinationPath $extractTo

# === Replace current files (optional cleanup first) ===
$currentAppPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$newAppPath = Get-ChildItem $extractTo | Where-Object { $_.PSIsContainer } | Select-Object -First 1

# === Delete everything except this script ===
Get-ChildItem $currentAppPath | Where-Object {
    $_.Name -ne "UpdateApp.ps1"
} | Remove-Item -Recurse -Force

# === Copy new files ===
Copy-Item "$($newAppPath.FullName)\*" $currentAppPath -Recurse -Force

# === Start updated app ===
Start-Process "$currentAppPath\YourApp.exe"

# Done
exit
