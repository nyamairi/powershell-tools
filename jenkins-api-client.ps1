. ".\basic-auth.ps1"

function Build-Headers {
    param([string]$user, [string]$pass)

    $basic = Build-BasicAuthHeader -user $user -pass $pass

    return @{
        Authorization = $basic
    }
}

function Get-Json {
    param([string]$uri, [string]$user, [string]$token)

    $headers = Build-Headers -user $user -pass $token

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    return Invoke-RestMethod -Uri "$uri/api/json" -Headers $headers
}
