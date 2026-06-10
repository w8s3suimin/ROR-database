$srcDir = Join-Path $PSScriptRoot "src"
$imgDir = Join-Path $PSScriptRoot "public\images"

if (!(Test-Path -Path $imgDir)) {
    New-Item -ItemType Directory -Force -Path $imgDir | Out-Null
}

$htmlFiles = Get-ChildItem -Path $srcDir -Filter "*.html"

foreach ($file in $htmlFiles) {
    Write-Host "Processing $($file.Name)..."
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Regex to find <img ... src="url" ...>
    $pattern = '(?i)<img[^>]+src=["''](https?://[^"''\s]+)["'']'
    $matches = [regex]::Matches($content, $pattern)
    
    $i = 1
    foreach ($m in $matches) {
        $url = $m.Groups[1].Value
        
        # Skip if it's already a local path
        if ($url -match "^/") { continue }

        # Generate a clean filename
        $ext = ".png" # Google sites images usually don't have extensions in url, we default to .png
        if ($url -match "\.(jpg|jpeg|gif|png|webp|svg)(?:[?#]|$)") {
            $ext = "." + $matches[1]
        }
        
        $basename = $file.BaseName
        $newFilename = "${basename}_img_${i}${ext}"
        $localImgPath = Join-Path $imgDir $newFilename
        
        Write-Host "  Downloading: $url -> $newFilename"
        try {
            Invoke-WebRequest -Uri $url -OutFile $localImgPath -UseBasicParsing -TimeoutSec 15
            
            # Replace the URL in the content
            # Using relative path for local viewing or absolute for server
            $newUrl = "../public/images/$newFilename"
            $content = $content.Replace($url, $newUrl)
        } catch {
            Write-Host "  Failed to download: $url"
        }
        
        $i++
    }
    
    # Also look for CSS background-image: url(...)
    $bgPattern = '(?i)url\([''"]?(https?://[^)''"]+)[''"]?\)'
    $bgMatches = [regex]::Matches($content, $bgPattern)
    foreach ($m in $bgMatches) {
        $url = $m.Groups[1].Value
        $newFilename = "${basename}_bg_${i}.png"
        $localImgPath = Join-Path $imgDir $newFilename
        
        Write-Host "  Downloading BG: $url -> $newFilename"
        try {
            Invoke-WebRequest -Uri $url -OutFile $localImgPath -UseBasicParsing -TimeoutSec 15
            $newUrl = "../public/images/$newFilename"
            $content = $content.Replace($url, $newUrl)
        } catch {
            Write-Host "  Failed to download BG: $url"
        }
        $i++
    }

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Host "Done!"
