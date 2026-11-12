# Installs Kairo for the current Windows user. No administrator rights are needed.
#
#   irm https://raw.githubusercontent.com/NikhilDendeti/kairo-releases/main/install.ps1 | iex
#
# It downloads the newest installer, checks it against the checksum published with that
# release, installs it quietly and starts Kairo. Kairo keeps itself up to date afterwards.

& {
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'   # the progress bar makes downloads many times slower
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $base = 'https://github.com/NikhilDendeti/kairo-releases/releases/latest/download'

    if (-not [Environment]::Is64BitOperatingSystem) { throw 'Kairo needs 64-bit Windows.' }

    $work = Join-Path ([IO.Path]::GetTempPath()) ("kairo-install-" + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $work | Out-Null
    try {
        Write-Host 'Kairo: finding the latest version...'
        $manifestFile = Join-Path $work 'latest.yml'
        Invoke-WebRequest -UseBasicParsing -Uri "$base/latest.yml" -OutFile $manifestFile
        $manifest = Get-Content -Raw -Path $manifestFile
        $version = [regex]::Match($manifest, '(?m)^version:\s*(\S+)').Groups[1].Value
        $name = [regex]::Match($manifest, '(?m)^path:\s*(\S+)').Groups[1].Value
        $expected = [regex]::Match($manifest, '(?m)^sha512:\s*(\S+)').Groups[1].Value
        if (-not $version -or -not $name -or -not $expected) { throw 'The release information could not be read.' }
        if ($name -notmatch '^[A-Za-z0-9._-]+\.exe$') { throw "Unexpected installer name: $name" }

        Write-Host "Kairo: downloading version $version..."
        $installer = Join-Path $work $name
        Invoke-WebRequest -UseBasicParsing -Uri "$base/$name" -OutFile $installer

        $hex = (Get-FileHash -Algorithm SHA512 -Path $installer).Hash
        $bytes = [byte[]]::new($hex.Length / 2)
        for ($i = 0; $i -lt $bytes.Length; $i++) { $bytes[$i] = [Convert]::ToByte($hex.Substring($i * 2, 2), 16) }
        if ([Convert]::ToBase64String($bytes) -ne $expected) {
            throw 'The download does not match its published checksum, so it was not installed. Try again.'
        }

        Write-Host 'Kairo: installing...'
        $setup = Start-Process -FilePath $installer -ArgumentList '/S' -Wait -PassThru
        if ($setup.ExitCode -ne 0) { throw "The installer stopped with code $($setup.ExitCode)." }

        $programs = Join-Path $env:LOCALAPPDATA 'Programs'
        $app = @('Kairo', 'parot-desktop') |
            ForEach-Object { Join-Path (Join-Path $programs $_) 'Kairo.exe' } |
            Where-Object { Test-Path $_ } |
            Select-Object -First 1
        if ($app) {
            Start-Process -FilePath $app
            Write-Host "Kairo $version is installed and starting. You can also open it from the Start menu."
        } else {
            Write-Host "Kairo $version is installed. Open it from the Start menu."
        }
    } finally {
        Remove-Item -Recurse -Force -Path $work -ErrorAction SilentlyContinue
    }
}
