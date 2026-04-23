param(
    [string]$ExamplesRoot = (Join-Path $PSScriptRoot "..\Validator\examples"),
    [string]$DraftsRoot = (Join-Path $PSScriptRoot "..\Validator\drafts\IDMEFv2"),
    [string]$ExamplesOutputPath = (Join-Path $PSScriptRoot "..\Validator\examples-manifest.json"),
    [string]$DraftsOutputPath = (Join-Path $PSScriptRoot "..\Validator\drafts-manifest.json")
)

function Write-Utf8NoBomFile {
    param(
        [string]$Path,
        [string]$Content
    )

    $resolvedOutputPath = [System.IO.Path]::GetFullPath($Path)
    $resolvedOutputDir = [System.IO.Path]::GetDirectoryName($resolvedOutputPath)
    if (-not (Test-Path -Path $resolvedOutputDir -PathType Container)) {
        New-Item -ItemType Directory -Path $resolvedOutputDir | Out-Null
    }

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($resolvedOutputPath, $Content + [Environment]::NewLine, $utf8NoBom)
}

if (-not (Test-Path -Path $ExamplesRoot -PathType Container)) {
    throw "Examples directory not found: $ExamplesRoot"
}

if (-not (Test-Path -Path $DraftsRoot -PathType Container)) {
    throw "Drafts directory not found: $DraftsRoot"
}

$examplesManifest = [ordered]@{}

$exampleVersionFolders = Get-ChildItem -Path $ExamplesRoot -Directory |
    Where-Object { $_.Name -eq "latest" -or $_.Name -match "^V\d+$" } |
    Sort-Object @{ Expression = {
        if ($_.Name -eq "latest") { return -1 }
        return [int]($_.Name -replace "^V", "")
    } }

foreach ($folder in $exampleVersionFolders) {
    $files = Get-ChildItem -Path $folder.FullName -File -Filter "*.json" |
        Sort-Object -Property Name |
        ForEach-Object { $_.Name }

    $examplesManifest[$folder.Name] = $files
}

$draftFolders = Get-ChildItem -Path $DraftsRoot -Directory |
    Where-Object { $_.Name -eq "latest-stable" -or $_.Name -eq "latest-dev" -or $_.Name -match "^\d+$" -or $_.Name -match "^\d+-Dev$" } |
    Sort-Object @{ Expression = {
        if ($_.Name -eq "latest-stable") { return -1 }
        if ($_.Name -eq "latest-dev") { return 0 }
        if ($_.Name -match "^(\d+)-Dev$") { return ([int]$Matches[1] * 10) + 1 }
        if ($_.Name -match "^\d+$") { return [int]$_.Name * 10 }
        return 9999
    } }, @{ Expression = { $_.Name } } |
    ForEach-Object { $_.Name }

$draftsManifest = [ordered]@{
    folders = $draftFolders
}

Write-Utf8NoBomFile -Path $ExamplesOutputPath -Content ($examplesManifest | ConvertTo-Json -Depth 10)
Write-Utf8NoBomFile -Path $DraftsOutputPath -Content ($draftsManifest | ConvertTo-Json -Depth 10)

Write-Output "examples-manifest generated at: $([System.IO.Path]::GetFullPath($ExamplesOutputPath))"
Write-Output "drafts-manifest generated at: $([System.IO.Path]::GetFullPath($DraftsOutputPath))"