param (
    [Parameter(Mandatory = $true)]
    [string]$ExtractedLibDir,

    [Parameter(Mandatory = $true)]
    [string]$FidbName,

    [Parameter(Mandatory = $true)]
    [string]$GhidraDir
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

# Path to analyzeHeadless.bat
$analyzeHeadless = Join-Path -Path $GhidraDir -ChildPath "support\analyzeHeadless.bat"

if (-not (Test-Path $analyzeHeadless)) {
    Write-Error "analyzeHeadless.bat not found in: $analyzeHeadless"
    exit 3
}

# Create the Ghidra project directory
New-Item -ItemType Directory -Path "project" -Force | Out-Null

# Run the Ghidra headless analysis
& "$analyzeHeadless" `
    "project" `
    "$FidbName" `
    -import "$ExtractedLibDir" `
    -recursive `
    -scriptPath "ghidra_scripts" `
    -preScript "FunctionIDHeadlessPrescriptMinimal.java" `
    -postScript "FunctionIDHeadlessPostscript.java"