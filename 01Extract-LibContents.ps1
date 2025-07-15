param (
    [Parameter(Mandatory = $true)]
    [string]$LibFile
)

if (-not (Test-Path $LibFile)) {
    Write-Error "File not found: $LibFile"
    exit 1
}

$libBaseName = [System.IO.Path]::GetFileNameWithoutExtension($LibFile)
$libOutputRoot = Join-Path -Path (Get-Location) -ChildPath $libBaseName

# Step 1: Get list of object names (skip first 3 lines)
$objectList = & lib.exe /list $LibFile 2>&1
$objectList = $objectList | Select-Object -Skip 3

foreach ($objPath in $objectList) {
    $objPathTrimmed = $objPath.Trim()
    if ($objPathTrimmed -eq "") { continue }

    # Parse path parts
    $objFileName = [System.IO.Path]::GetFileName($objPathTrimmed)
    $objParentPath = [System.IO.Path]::GetDirectoryName($objPathTrimmed)

    # Convert slashes to underscores in path
    $safeDirName = $objParentPath -replace '[\\/]', '_'
	$safeDirName += "\1\0"

    # Final destination folder: libbasename/safeDirName/
    $targetDir = Join-Path -Path $libOutputRoot -ChildPath $safeDirName
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

    # Extract the file
    Write-Host "Extracting: $objPathTrimmed -> $targetDir" 
	& lib.exe "/extract:$objPathTrimmed" $LibFile 2>&1 | Out-Null

    # Move extracted file to target dir
    if (Test-Path $objFileName) {
        Move-Item -Force $objFileName -Destination $targetDir
    } else {
        Write-Warning "Failed to extract: $objPathTrimmed"
    }
}