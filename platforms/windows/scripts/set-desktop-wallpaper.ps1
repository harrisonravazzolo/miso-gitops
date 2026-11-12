# Sets the desktop wallpaper for every user on this Windows device.
#
# Fleet runs scripts as SYSTEM, so this can't change the signed-in
# user's wallpaper directly. Instead it writes the device-wide
# personalization policy in the registry, which Windows applies to
# each user the next time they sign in. While the policy is in place,
# users can't pick a different wallpaper.
#
# The image must already exist on the device's disk. The default
# below ships with Windows 10 and Windows 11.

$ImagePath = 'C:\Windows\Web\Wallpaper\Windows\img0.jpg'

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $ImagePath -PathType Leaf)) {
    Write-Error "Wallpaper image not found: $ImagePath"
    exit 1
}

$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'

try {
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    New-ItemProperty -Path $RegistryPath -Name 'DesktopImagePath' -Value $ImagePath -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $RegistryPath -Name 'DesktopImageUrl' -Value $ImagePath -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $RegistryPath -Name 'DesktopImageStatus' -Value 1 -PropertyType DWord -Force | Out-Null
}
catch {
    Write-Error "Failed to set the wallpaper policy: $_"
    exit 1
}

Write-Output "Desktop wallpaper set to $ImagePath. It appears the next time each user signs in."
exit 0
