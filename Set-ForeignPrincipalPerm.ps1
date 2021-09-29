

function Set-ForeignPrincipalPerm {
    param (

        [string] $VitFGID,
        [string] $SubscriptionID 

    )
    
    $SubscriptionDetails = Select-AzSubscription -SubscriptionId $SubscriptionID

    #$Role = Get-AZRoleAssignment -Scope /subscriptions/$SubscriptionID | where ObjectId -like $VitFGID | fl DisplayName, ObjectID
     
   
    try {
        Write-Host "Now trying to add VIT FG to " $SubscriptionDetails.Name -ForegroundColor Green
        New-AZRoleAssignment -ObjectId $VitFGID -Scope "/subscriptions/$SubscriptionID" -RoleDefinitionName Owner  -ObjectType ForeignGroup -ErrorAction Stop
        
        
    }
    catch {
        Write-Host "Issue trying add the FG to" $SubscriptionDetails.Name -ForegroundColor Yellow
        Write-Warning $_.Exception.Message 
    }
        
}

$VitFGID = "Your Object ID" #This is the Foreigng principal for VIT , is the object ID from the Group AdminAgents listed in the MSP's AAD 
$Subscriptions = Get-AzSubscription | where State -like Enabled 


foreach ($item in $Subscriptions) {
    
    $SubscriptionID = $item.Id
    Write-Host "This is the sub I'll be working on" $item.Name ":"  $SubscriptionID 
    Set-ForeignPrincipalPerm -VitFGID $VitFGID -SubscriptionID $SubscriptionID
    
}



