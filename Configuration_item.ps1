<#
.NOTES
===========================================================================
       
Created on:        29/07/2019
Created by:        Kajal Sacheti [kajal.sacheti@wipro.com]
Organization:      Wipro
Filename:          Add an Attachment to a record in Service now
Version:           1.0
===========================================================================

.SYNOPSIS
    
     This Script will create the Configuration item in Service Now.


.INPUTS

    We need to pass a few parameters like UserName, InstanceName, Parent, type.


.OUTPUTS
    
    The script will create a CI in the Service Now and build its relationship with the cmdb_rel_ci.
   
#>
try{
    cls
    # Eg. User name="admin", Password="admin" for this code sample.
    $user = "admin"
    $pass = "Wipro@123"

    # Build auth header
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

    #Instance name
    $instnace_name = "https://dev50379.service-now.com"

    # Set proper headers
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
    $headers.Add('Accept','application/json')
    $headers.Add('Content-Type','application/json')

    # Specify endpoint uri
    $uri = "$instnace_name/api/now/table/cmdb_ci"

    # Specify HTTP method
    $method = "post"

    # Specify request body
    $body = "{
    ""name"":""new123"",
    ""Status"":""Absent"",
    ""asset_tag"":""fqdn"",
    ""assigned_to"":""test_user""
    }"

    # Send HTTP request
    $response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -Body $body -ContentType 'application/json'

    # Print response
    $response_content = $response.Content | ConvertFrom-Json
    $child_sysid = $response_content.result.sys_id
    Write-Host "The Configuration sys_id is $($child_sysid)"
        
    # Specify endpoint uri
    $uri_cmdb_rel = "$instnace_name/api/now/table/cmdb_rel_ci"
    
    # Specify HTTP method
    $method = "post"

    # Specify request body
    $body_cmdb = "{""child"":""$child_sysid"",""parent"":""win-ru0hqfvi3ah"",""type"":""Depends on::Used by""}"
    
        # Send HTTP request
    $response_cmdb = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri_cmdb_rel -Body $body_cmdb

    # Print response
    $content_cmdb_rel = $response_cmdb.Content | ConvertFrom-Json
    $content_cmdb_rel.result.sys_id
    Write-Host "The relationship sys_id is $($content_cmdb_rel.result.sys_id)"
}
catch{
    $_
}