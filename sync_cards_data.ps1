$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "      RORDB Card Data Sync Tool" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Switch to script directory
Set-Location -Path $PSScriptRoot

Write-Host "`n[ Wait ] Fetching the latest card data from Google Apps Script..." -ForegroundColor Yellow

$apiUrl = "https://script.google.com/macros/s/AKfycbw5xG6Xf7QZr_1pCF_hP4UF_c2OFtLQQdTcOWfL_6XbtiLx9iWas77CP0-OUgcmbDta/exec?action=getCardDataV2"
$response = Invoke-RestMethod -Uri $apiUrl

if ($null -ne $response -and $null -ne $response.map) {
    # Create directory if it does not exist
    $dataDir = Join-Path -Path $PSScriptRoot -ChildPath "public\data"
    if (-not (Test-Path -Path $dataDir)) {
        New-Item -ItemType Directory -Force -Path $dataDir | Out-Null
    }

    $jsonPath = Join-Path -Path $dataDir -ChildPath "cards.json"
    $response.map | ConvertTo-Json | Out-File -FilePath $jsonPath -Encoding UTF8
    
    Write-Host "`n=========================================" -ForegroundColor Green
    Write-Host "[ OK ] Data sync complete! Updated public/data/cards.json" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
} else {
    Write-Host "`n[ ERROR ] Sync failed. Could not fetch valid card data from Google." -ForegroundColor Red
}

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
