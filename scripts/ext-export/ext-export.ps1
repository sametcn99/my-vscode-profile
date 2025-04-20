# PowerShell Script: vscode-extensions.ps1

$action = Read-Host "Do you want to export or import VSCode extensions? (export/import)"

if ($action -eq "export") {
    Write-Host "Exporting VSCode extensions..."
      # Create markdown file with header
    $date = Get-Date -Format "yyyy-MM-dd"
    $filename = "vscode-extensions-$date.md"
    $mdContent = "# VS Code Extensions`n`n"
    $mdContent += "Exported on: $date`n`n"
    $mdContent += "## Installed Extensions`n`n"
    
    # Get extensions and add them to markdown content
    $extensions = code --list-extensions
    foreach ($ext in $extensions) {
        $mdContent += "- $ext`n"
    }
    
    # Save to markdown file
    $mdContent | Out-File -FilePath $filename -Encoding utf8
    Write-Host "Extensions have been exported to $filename"
}
elseif ($action -eq "import") {
    Write-Host "Importing VSCode extensions..."
    
    # Find the most recent extensions file
    $latestFile = Get-ChildItem -Path "vscode-extensions*.md" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    if ($null -eq $latestFile) {
        Write-Host "Error: No extensions file found."
        return
    }
    
    $filePath = $latestFile.FullName
    Write-Host "Using file: $($latestFile.Name)"
    
    if (Test-Path $filePath) {
        # Extract extension IDs from markdown file (lines starting with "- ")
        Get-Content $filePath | Where-Object { $_ -match '^- (.+)$' } | ForEach-Object {
            $extension = $_ -replace '^- (.+)$', '$1'
            Write-Host "Installing extension: $extension"
            code --install-extension $extension
        }
        Write-Host "Extensions have been imported from $($latestFile.Name)"
    }
    else {
        Write-Host "Error: Extensions file not found."
    }
}
else {
    Write-Host "Invalid action. Please choose 'export' or 'import'."
}
