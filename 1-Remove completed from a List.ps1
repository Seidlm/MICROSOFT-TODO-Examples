$clientID = "your APP ID"
$User = "your User"
$PW = "your Password"
$resource = "https://graph.microsoft.com"


$MicrosoftToDoListName = "My Tasks"



#Connect to GRAPH API
$tokenBody = @{  
    Grant_Type = "password"  
    Scope      = "user.read%20openid%20profile%20offline_access"  
    Client_Id  = $clientId  
    username   = $User
    password   = $pw
    resource   = $resource
}   

$tokenResponse = Invoke-RestMethod "https://login.microsoftonline.com/common/oauth2/token" -Method Post -ContentType "application/x-www-form-urlencoded" -Body $tokenBody -ErrorAction STOP
$headers = @{
    "Authorization" = "Bearer $($tokenResponse.access_token)"
    "Content-type"  = "application/json"
}



#Get ID of List
$URLGetToDoLists = "https://graph.microsoft.com/v1.0/me/todo/lists?`$filter=displayName eq '$($MicrosoftToDoListName)'"
$Return = Invoke-RestMethod -Method GET -Headers $headers -Uri $URLGetToDoLists
$ListID = $Return.value.id



# Get Task List
$URLGetTasks="https://graph.microsoft.com/v1.0/me/todo/lists/$ListID/tasks?`$filter=status eq 'completed'"
$ComplReturn = Invoke-RestMethod -Method GET -Headers $headers -Uri $URLGetTasks

$ComplReturn.value

#Delete all completed
foreach ($entry in $ComplReturn.value)
{

    $URLDelete="https://graph.microsoft.com/v1.0/me/todo/lists/$ListID/tasks/$($Entry.id)"
    Invoke-RestMethod -Method DELETE -Headers $headers -Uri $URLDelete


}
