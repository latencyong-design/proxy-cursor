$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot

Get-ChildItem -LiteralPath $repoRoot -Recurse -Filter "*.ps1" |
    Where-Object { $_.FullName -notmatch "\\.git\\" } |
    ForEach-Object {
        $tokens = $null
        $errors = $null
        [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$errors) | Out-Null
        if ($errors.Count -gt 0) {
            throw "PowerShell parse failed for $($_.FullName): $($errors[0].Message)"
        }
        Write-Host "OK $($_.FullName)"
    }
