function Build-BasicAuthHeader {
    param([string]$user, [string]$pass)

    $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($user):$($pass)"))
    return "Basic $base64"
}
