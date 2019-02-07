function Convert-FromJavaScriptTicks {
    param([long]$source)

    $base = New-Object -TypeName System.DateTime -ArgumentList @(1970, 1, 1)
    $ticks = $source * 1000 * 10 + $base.Ticks
    $utc = New-Object -TypeName System.DateTime -ArgumentList @($ticks, [System.DateTimeKind]::Utc)
    return $utc.ToLocalTime()
}
