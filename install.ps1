$ErrorActionPreference = "Stop"

$REPO_DIR = (Get-Item -Path $PSScriptRoot).FullName
$CLAUDE_DIR = "$env:USERPROFILE\.claude"

Write-Host "Installing Claude Code configuration from $REPO_DIR..."
Write-Host ""

# Create .claude directory if it doesn't exist
if (-not (Test-Path $CLAUDE_DIR)) {
    New-Item -ItemType Directory -Path $CLAUDE_DIR -Force | Out-Null
}

# Install each directory
$dirs = @("agents", "commands", "skills")
foreach ($dir in $dirs) {
    $source = Join-Path $REPO_DIR $dir

    # Skip if source directory doesn't exist
    if (-not (Test-Path $source)) {
        continue
    }

    $target = Join-Path $CLAUDE_DIR $dir

    # Handle existing symlink
    if ((Get-Item $target -ErrorAction SilentlyContinue) -is [System.IO.DirectoryInfo]) {
        $linkTarget = (Get-Item $target).LinkTarget
        if ($linkTarget) {
            Write-Host "  Replacing existing symlink: $dir"
            Remove-Item $target -Force
        }
        # Handle existing directory (not a symlink)
        elseif (Test-Path $target) {
            $timestamp = Get-Date -Format "yyyyMMddHHmmss"
            $backup = "$target.bak.$timestamp"
            Write-Host "  Backing up existing $dir → $backup"
            Move-Item $target $backup
        }
    }

    # Create new junction (doesn't require admin)
    New-Item -ItemType Junction -Path $target -Target $source -Force | Out-Null
    Write-Host "  Linked: ~/.claude/$dir → $source"
}

# Install individual files as hardlinks (no admin required, same drive)
$files = @("settings.json", "CLAUDE.md")
foreach ($file in $files) {
    $source = Join-Path $REPO_DIR $file

    if (-not (Test-Path $source)) {
        continue
    }

    $target = Join-Path $CLAUDE_DIR $file

    if (Test-Path $target) {
        $existing = Get-Item $target -Force
        if ($existing.LinkType -eq "HardLink") {
            Write-Host "  Replacing existing hardlink: $file"
        } else {
            $timestamp = Get-Date -Format "yyyyMMddHHmmss"
            $backup = "$target.bak.$timestamp"
            Write-Host "  Backing up existing $file → $backup"
            Move-Item $target $backup
        }
        Remove-Item $target -Force
    }

    New-Item -ItemType HardLink -Path $target -Target $source | Out-Null
    Write-Host "  Linked: ~/.claude/$file → $source"
}

Write-Host ""
Write-Host "Done. Run 'git pull' in $REPO_DIR to update."
