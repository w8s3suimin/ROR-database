$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "      RORDB GitHub Auto-Upload Tool" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location -Path $PSScriptRoot

git add .

$commitMsg = Read-Host "Enter commit message (Press Enter for default: 'Auto-update site')"
if ([string]::IsNullOrWhiteSpace($commitMsg)) {
    $commitMsg = "Auto-update site"
}

Write-Host "`nPacking your changes..." -ForegroundColor Yellow
git commit -m "$commitMsg"

Write-Host "`nPushing to GitHub, please wait..." -ForegroundColor Yellow
git push

Write-Host "`n=========================================" -ForegroundColor Green
Write-Host "Upload Complete!" -ForegroundColor Green
Write-Host "Vercel has been notified and will update your site within 1 minute." -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
