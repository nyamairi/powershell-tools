$basePath = "."

function Set-LogBasePath {
    param([string]$path = ".")

    if ($path -eq "") {
        $script:basePath = "."
        return
    }

    $script:basePath = $path
}

function Create-Dir {
    param([string]$path)

    if (Test-Path $path) {
        return
    }

    Create-Dir ([System.IO.Path]::GetDirectoryName($path))
    New-Item -Path $path -ItemType Directory >$null
}

function Get-Destination {
    param([string]$base)

    $destination = $base
    $suffix = 1
    while (Test-Path $destination) {
        $destination = "$base.$suffix"
        $suffix++
    }

    return $destination
}

function Rotate {
    param([string]$path, [System.DateTime]$now)

    if (-not (Test-Path $path)) {
        return
    }

    $file = Get-ItemProperty -Path $path
    if ($file.LastWriteTime.Date -ge $now.Date) {
        return
    }

    $destination = Get-Destination "$basePath.$($file.LastWriteTime.Date.ToString('yyyyMMdd')).log"
    Create-Dir ([System.IO.Path]::GetDirectoryName($destination))
    Move-Item -Path $path -Destination $destination
}

function Log {
    param([string]$level, [string]$message)

    $now = [System.DateTime]::Now

    $path = "$basePath.log"

    Rotate -path $path -now $now

    $singleLineMessage = $message.Replace([System.Environment]::NewLine, '\n')
    $value = "$($now.ToString('yyyy/MM/dd HH:mm:ss')) $level $singleLineMessage"
    $value

    Create-Dir ([System.IO.Path]::GetDirectoryName($path))

    $values = New-Object System.Collections.Generic.List[string]
    $values.Add($value)
    $utf8 = New-Object System.Text.UTF8Encoding($False)
    [System.IO.File]::AppendAllLines($path, $values, $utf8)
}

function Log-Info {
    param([string]$message)

    Log -level "INFO" -message $message
}

function Log-Warn {
    param([string]$message)

    Log -level "WARN" -message $message
}

function Log-Error {
    param([string]$message)

    Log -level "ERROR" -message $message
}
