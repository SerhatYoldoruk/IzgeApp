$targetDir = "c:\Users\troll\OneDrive\Belgeler\DepremApp\izge_app\izge_app_frontend\lib"
$errorFiles = @(
    "my_events_screen.dart",
    "help_center_screen.dart",
    "event_success_screen.dart",
    "donation_success_screen.dart",
    "live_support_screen.dart",
    "share_certificate_screen.dart",
    "membership_cancellation_screen.dart",
    "rights_obligations_screen.dart",
    "email_verification_support_screen.dart"
)

$files = Get-ChildItem -Path $targetDir -Filter "*.dart" -Recurse | Where-Object { $_.Name -ne "app_colors.dart" }
$totalFixed = 0

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $original = $content
    
    # Remove const from any widget/object that contains AppColors reference
    # Pattern: const SomeWidget(...AppColors...) -> SomeWidget(...AppColors...)
    
    # Fix const TextStyle with AppColors
    $content = $content -replace 'const TextStyle\(([^;]*?)AppColors\.', 'TextStyle($1AppColors.'
    
    # Fix const BoxDecoration with AppColors
    $content = $content -replace 'const BoxDecoration\(([^;]*?)AppColors\.', 'BoxDecoration($1AppColors.'
    
    # Fix const Border with AppColors
    $content = $content -replace 'const Border\(([^;]*?)AppColors\.', 'Border($1AppColors.'
    
    # Fix const BorderSide with AppColors
    $content = $content -replace 'const BorderSide\(([^;]*?)AppColors\.', 'BorderSide($1AppColors.'
    
    # Fix const Icon with AppColors
    $content = $content -replace 'const Icon\(([^;]*?)AppColors\.', 'Icon($1AppColors.'
    
    # Fix const InputDecoration with AppColors
    $content = $content -replace 'const InputDecoration\(([^;]*?)AppColors\.', 'InputDecoration($1AppColors.'
    
    # Fix const Row/Column children with AppColors
    $content = $content -replace 'const Row\(([^;]*?)AppColors\.', 'Row($1AppColors.'
    $content = $content -replace 'const Column\(([^;]*?)AppColors\.', 'Column($1AppColors.'
    
    # Fix const Container with AppColors
    $content = $content -replace 'const Container\(([^;]*?)AppColors\.', 'Container($1AppColors.'
    
    # Fix const Padding with AppColors
    $content = $content -replace 'const Padding\(([^;]*?)AppColors\.', 'Padding($1AppColors.'
    
    # Fix const SizedBox with AppColors
    $content = $content -replace 'const SizedBox\(([^;]*?)AppColors\.', 'SizedBox($1AppColors.'
    
    # Fix const CircularProgressIndicator with AppColors
    $content = $content -replace 'const CircularProgressIndicator\(([^;]*?)AppColors\.', 'CircularProgressIndicator($1AppColors.'
    
    # Fix const Divider with AppColors
    $content = $content -replace 'const Divider\(([^;]*?)AppColors\.', 'Divider($1AppColors.'
    
    # Fix const SnackBar with AppColors
    $content = $content -replace 'const SnackBar\(([^;]*?)AppColors\.', 'SnackBar($1AppColors.'
    
    # Fix const AlertDialog with AppColors
    $content = $content -replace 'const AlertDialog\(([^;]*?)AppColors\.', 'AlertDialog($1AppColors.'
    
    if ($content -ne $original) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $totalFixed++
        Write-Host "Fixed: $($file.Name)"
    }
}

Write-Host "`nTotal files fixed: $totalFixed"
