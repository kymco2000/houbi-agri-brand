[CmdletBinding()]
param(
    [string]$VaultPath = (Join-Path $PSScriptRoot 'local-vault'),
    [switch]$OpenObsidian,
    [switch]$ConnectNotebookLM,
    [guid]$NotebookId,
    [switch]$SkipSkill
)
$ErrorActionPreference = 'Stop'
$env:PYTHONIOENCODING = 'utf-8'

function Invoke-Checked {
    param([string]$Command, [string[]]$Arguments)
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Command failed ($LASTEXITCODE)." }
}

function Find-Obsidian {
    $protocol = Get-Item 'HKCR:\obsidian\shell\open\command' -ErrorAction SilentlyContinue
    if (!$protocol) {
        $protocol = Get-Item 'Registry::HKEY_CLASSES_ROOT\obsidian\shell\open\command' -ErrorAction SilentlyContinue
    }
    if ($protocol -and $protocol.GetValue('') -match '^"([^"]+)"' -and (Test-Path -LiteralPath $Matches[1])) {
        return $Matches[1]
    }
    foreach ($candidate in @("$env:ProgramFiles\Obsidian\Obsidian.exe", "$env:LOCALAPPDATA\Obsidian\Obsidian.exe", "$env:LOCALAPPDATA\Programs\Obsidian\Obsidian.exe")) {
        if (Test-Path -LiteralPath $candidate) { return $candidate }
    }
}

if (!$SkipSkill) {
    Invoke-Checked 'gh' @('skill','install',$PSScriptRoot,'houbi-agri-market','--from-local','--agent','codex','--scope','user')
}
$obsidian = Find-Obsidian
if (!$obsidian) {
    Invoke-Checked 'winget' @('install','--id','Obsidian.Obsidian','--exact','--source','winget','--accept-package-agreements','--accept-source-agreements')
    $obsidian = Find-Obsidian
    if (!$obsidian) { throw 'Obsidian executable was not found after installation.' }
}
Write-Host "Obsidian: $obsidian"
$refs = Join-Path $PSScriptRoot 'skills/houbi-agri-market/references'
$notes = Get-ChildItem -LiteralPath $refs -File -Filter '*.md'
$destination = Join-Path $VaultPath '後壁農產品牌開發'
[void][IO.Directory]::CreateDirectory($destination)
foreach ($note in $notes) {
    $target = Join-Path $destination $note.Name
    if (!(Test-Path -LiteralPath $target)) { [IO.File]::Copy($note.FullName, $target) }
}
Write-Host "Vault: $VaultPath"
if ($OpenObsidian) {
    Start-Process -FilePath $obsidian
}
if (!$ConnectNotebookLM -and !$NotebookId) { return }

$uvHome = Join-Path $env:USERPROFILE '.local\bin'
$env:Path = "$uvHome;$env:Path"
if (!(Get-Command nlm -ErrorAction SilentlyContinue)) {
    if (!(Get-Command uv -ErrorAction SilentlyContinue)) {
        Invoke-Checked 'winget' @('install','--id','astral-sh.uv','--exact','--source','winget','--accept-package-agreements','--accept-source-agreements')
        $env:Path += ';' + [Environment]::GetEnvironmentVariable('Path','User')
        $env:Path += ';' + (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links')
    }
    Invoke-Checked 'uv' @('tool','install','notebooklm-mcp-cli')
    $bin = Invoke-Checked 'uv' @('tool','dir','--bin')
    $env:Path = "$bin;$env:Path"
}
if ($ConnectNotebookLM) {
    $null = & nlm notebook list --json
    if ($LASTEXITCODE -ne 0) { Invoke-Checked 'nlm' @('login') }
    $null = Invoke-Checked 'nlm' @('notebook','list','--json')
    $server = (Get-Command notebooklm-mcp -ErrorAction Stop).Source
    $configured = (Invoke-Checked 'codex' @('mcp','list')) -join "`n"
    if ($configured -notmatch '(?im)^(gemini-notebook|notebooklm|houbi-notebooklm)\s+.*notebooklm-mcp.*\benabled\b') {
        Invoke-Checked 'codex' @('mcp','add','houbi-notebooklm','--',$server)
    }
    Write-Host 'NotebookLM access verified. Restart Codex to load MCP configuration.'
}
if ($NotebookId) {
    $existing = (Invoke-Checked 'nlm' @('source','list',"$NotebookId",'--json')) -join "`n" | ConvertFrom-Json
    foreach ($note in $notes) {
        $canonical = [IO.File]::ReadAllText($note.FullName).TrimEnd() -replace "\r\n", "`n"
        $sha = [Security.Cryptography.SHA256]::Create()
        try { $hash = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($canonical)) } finally { $sha.Dispose() }
        $digest = [BitConverter]::ToString($hash).Replace("-", "").Substring(0,12).ToLowerInvariant()
        $title = "$($note.BaseName) [$digest]"
        if (@($existing | Where-Object { $_.title -eq $title }).Count -gt 0) {
            Write-Host "Already present: $title"
            continue
        }
        $source = Invoke-Checked 'nlm' @('source','add',"$NotebookId",'--file',$note.FullName,'--title',$title,'--wait','--json')
        $source
    }
    Invoke-Checked 'nlm' @('source','list',"$NotebookId")
}
