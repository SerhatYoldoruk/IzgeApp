$targetDir = "c:\Users\troll\OneDrive\Belgeler\DepremApp\izge_app\izge_app_frontend\lib"

# Get all dart files with hardcoded colors (excluding app_colors.dart itself)
$files = Get-ChildItem -Path $targetDir -Filter "*.dart" -Recurse | Where-Object { $_.Name -ne "app_colors.dart" }

$totalReplacements = 0

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $original = $content
    
    # Replace background colors
    $content = $content -replace "const Color\(0xFF131313\)", "AppColors.background"
    $content = $content -replace "Color\(0xFF131313\)", "AppColors.background"
    
    # Replace surface colors
    $content = $content -replace "const Color\(0xFF1F2020\)", "AppColors.surface"
    $content = $content -replace "Color\(0xFF1F2020\)", "AppColors.surface"
    
    # Replace surfaceElevated colors
    $content = $content -replace "const Color\(0xFF1B1C1C\)", "AppColors.surfaceElevated"
    $content = $content -replace "Color\(0xFF1B1C1C\)", "AppColors.surfaceElevated"
    $content = $content -replace "const Color\(0xFF2A2A2A\)", "AppColors.surfaceElevated"
    $content = $content -replace "Color\(0xFF2A2A2A\)", "AppColors.surfaceElevated"
    $content = $content -replace "const Color\(0xFF454747\)", "AppColors.surfaceElevated"
    $content = $content -replace "Color\(0xFF454747\)", "AppColors.surfaceElevated"
    
    # Replace border colors
    $content = $content -replace "const Color\(0xFF353535\)", "AppColors.border"
    $content = $content -replace "Color\(0xFF353535\)", "AppColors.border"
    $content = $content -replace "const Color\(0xFF3F4A3C\)", "AppColors.border"
    $content = $content -replace "Color\(0xFF3F4A3C\)", "AppColors.border"
    
    # Replace text colors
    $content = $content -replace "const Color\(0xFFE5E2E1\)", "AppColors.textPrimary"
    $content = $content -replace "Color\(0xFFE5E2E1\)", "AppColors.textPrimary"
    $content = $content -replace "const Color\(0xFFC6C6C7\)", "AppColors.textSecondary"
    $content = $content -replace "Color\(0xFFC6C6C7\)", "AppColors.textSecondary"
    $content = $content -replace "const Color\(0xFFBECAB8\)", "AppColors.textSecondary"
    $content = $content -replace "Color\(0xFFBECAB8\)", "AppColors.textSecondary"
    $content = $content -replace "const Color\(0xFFC6C6C6\)", "AppColors.textSecondary"
    $content = $content -replace "Color\(0xFFC6C6C6\)", "AppColors.textSecondary"
    $content = $content -replace "const Color\(0xFF6E6F6F\)", "AppColors.textSecondary"
    $content = $content -replace "Color\(0xFF6E6F6F\)", "AppColors.textSecondary"
    
    if ($content -ne $original) {
        # Add import if not present
        if ($content -notmatch "import.*app_colors\.dart") {
            $content = "import 'package:izge_app_frontend/core/constants/app_colors.dart';`n" + $content
        }
        
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $totalReplacements++
        Write-Host "Fixed: $($file.Name)"
    }
}

Write-Host "`nTotal files fixed: $totalReplacements"
