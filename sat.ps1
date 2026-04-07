$ImageUrl = "https://raw.githubusercontent.com/Willsie-Digital/SecurityAwarenessTraining/refs/heads/main/PatrickStar.jpg"
$LocalPath = "$env:USERPROFILE\PatrickStar.jpg"
$WallpaperStyle = "Fill"


# --- DOWNLOAD IMAGE (VALIDATED) ---
try {
    $response = Invoke-WebRequest `
        -Uri $ImageUrl `
        -UseBasicParsing `
        -Headers @{ "Accept" = "image/*" } `
        -ErrorAction Stop

    # Validate content type
    if ($response.Headers["Content-Type"] -notmatch "^image/") {
        throw "Downloaded content is NOT an image. Content-Type: $($response.Headers["Content-Type"])"
    }

    # Save binary
    [System.IO.File]::WriteAllBytes($LocalPath, $response.Content)
}
catch {
    Write-Error "Wallpaper download failed: $($_.Exception.Message)"
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



# --- APPLY WALLPAPER IMMEDIATELY ---
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool SystemParametersInfo(
        int uAction,
        int uParam,
        string lpvParam,
        int fuWinIni
    );
}
"@

[Wallpaper]::SystemParametersInfo(20, 0, $LocalPath, 3) | Out-Null

