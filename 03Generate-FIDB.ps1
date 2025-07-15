param (
    [Parameter(Mandatory = $true)]
    [string]$ExtractedLibDir,   # Directory name for extracted object files

    [Parameter(Mandatory = $true)]
    [string]$FidbName,          # Desired name of the fidb file (e.g., openssl-fidb)

    [Parameter(Mandatory = $true)]
    [string]$GhidraDir          # Path to Ghidra installation
)

# Validate Ghidra path
if (-not (Test-Path $GhidraDir)) {
    Write-Error "Ghidra directory not found: $GhidraDir"
    exit 1
}

# Validate extracted library directory
if (-not (Test-Path $ExtractedLibDir)) {
    Write-Error "Extracted library directory not found: $ExtractedLibDir"
    exit 2
}

# Construct path to analyzeHeadless.bat
$analyzeHeadless = Join-Path -Path $GhidraDir -ChildPath "support\analyzeHeadless.bat"

if (-not (Test-Path $analyzeHeadless)) {
    Write-Error "analyzeHeadless.bat not found in: $analyzeHeadless"
    exit 3
}

# Prepare required files and output directory
New-Item -ItemType File -Path "common.txt" -Force | Out-Null
New-Item -ItemType File -Path "duplicate_results.txt" -Force | Out-Null
New-Item -ItemType Directory -Path "fidb" -Force | Out-Null

# Run Ghidra headless analysis for fidb generation
& "$analyzeHeadless" `
    "project" `
    "$FidbName" `
    -noanalysis `
    -scriptPath "ghidra_scripts" `
    -preScript "AutoCreateMultipleLibraries.java" `
    "duplicate_results.txt" `
    "true" `
    "fidb" `
    "$FidbName.fidb" `
    "$ExtractedLibDir" `
    "common.txt" `
    "x86:LE:64:default"