$targetDir = "c:\Users\troll\OneDrive\Belgeler\DepremApp\izge_app\izge_app_frontend\lib"
$files = Get-ChildItem -Path $targetDir -Filter "*.dart" -Recurse | Where-Object { $_.Name -ne "app_colors.dart" }
$totalFixed = 0

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $original = $content
    
    # Fix const Border with AppColors
    $content = $content -replace 'const Border\(([^)]*?)AppColors\.', 'Border($1AppColors.'
    
    # Fix const BorderSide with AppColors  
    $content = $content -replace 'const BorderSide\(color: AppColors\.', 'BorderSide(color: AppColors.'
    
    # Fix const TextStyle with AppColors
    $content = $content -replace 'const TextStyle\(([^)]*?)AppColors\.', 'TextStyle($1AppColors.'
    
    # Fix const Icon with AppColors
    $content = $content -replace 'const Icon\(([^,]+),\s*color: AppColors\.', 'Icon($1, color: AppColors.'
    
    # Fix const InputDecoration with AppColors
    $content = $content -replace 'const InputDecoration\(([^)]*?)AppColors\.', 'InputDecoration($1AppColors.'
    
    # Fix const EdgeInsets or Container patterns inside const with AppColors
    $content = $content -replace 'const Row\(\s*\n?\s*children: \[([^]]*?)AppColors\.', 'Row( children: [$1AppColors.'
    
    if ($content -ne $original) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $totalFixed++
        Write-Host "Fixed: $($file.Name)"
    }
}

Write-Host "`nTotal files fixed: $totalFixed"
