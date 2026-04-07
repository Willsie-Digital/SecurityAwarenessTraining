$ImageUrl = "https://github.com/Willsie-Digital/SecurityAwarenessTraining/blob/main/PatrickStar.jpg"
$LocalPath = "$env:USERPROFILE\Pictures\PatrickStar.jpg"
$WallpaperStyle = "Fill"

# --- DOWNLOAD IMAGE ---
try {
    Invoke-WebRequest -Uri $ImageUrl -OutFile $LocalPath -UseBasicParsing
}
catch {
    Write-Error "Failed to download wallpaper: $_"
    exit 1
}


$StyleMap = @{
    "Fill"    = @{ Style = 10; Tile = 0 }
    "Fit"     = @{ Style = 6;  Tile = 0 }
    "Stretch" = @{ Style = 2;  Tile = 0 }
    "Tile"    = @{ Style = 0;  Tile = 1 }
    "Center"  = @{ Style = 0;  Tile = 0 }
    "Span"    = @{ Style = 22; Tile = 0 }
}

$Style = $StyleMap[$WallpaperStyle]


# --- SET REGISTRY VALUES ---
$RegPath = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $RegPath -Name WallpaperStyle -Value $Style.Style
Set-ItemProperty -Path $RegPath -Name TileWallpaper   -Value $Style.Tile
Set-ItemProperty -Path $RegPath -Name Wallpaper       -Value $LocalPath


# --- REFRESH WALLPAPER ---
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class NativeMethods {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# Apply immediately
:SystemParametersInfo(20, 0, $LocalPath, 3)
