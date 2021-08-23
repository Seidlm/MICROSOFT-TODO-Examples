$clientID = "your APP ID"
$User = "your User"
$PW = "your Password"
$resource = "https://graph.microsoft.com"



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



#Get all List
$URLGetToDoLists = "https://graph.microsoft.com/v1.0/me/todo/lists"
$Return = Invoke-RestMethod -Method GET -Headers $headers -Uri $URLGetToDoLists
$Lists = $Return.value




foreach ($List in $Lists) {

    # Get Task List
    $URLGetTasks = "https://graph.microsoft.com/v1.0/me/todo/lists/$($List.id)/tasks?`$filter=status eq 'completed'&`$top=1000"
    $ComplReturn = Invoke-RestMethod -Method GET -Headers $headers -Uri $URLGetTasks


    $List.displayName
    $ComplReturn.value.count

    #Delete all completed
    foreach ($entry in $ComplReturn.value) {

       $URLDelete = "https://graph.microsoft.com/v1.0/me/todo/lists/$($List.id)/tasks/$($Entry.id)"
       Invoke-RestMethod -Method DELETE -Headers $headers -Uri $URLDelete
    }
}


