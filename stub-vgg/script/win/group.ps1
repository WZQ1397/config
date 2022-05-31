# dev: $PSDefaultParameterValues = @{"*-AD*:Server"='usee01dcs001.shdev.Zachcorp.com'}
#$PSDefaultParameterValues = @{"*-AD*:Server"='uswp00dcs001.Zachcorp.com'}
Import-Module PnP.PowerShell
#$siteUrl = 'https://zachcorp.sharepoint.com/sites/ITAutomation/'
$siteUrl = 'https://zachcorp.sharepoint.com/sites/ITAutomation-DEV'
$listTitle = 'GroupProvisioning'
$domain = 'zachcorp.com'
#user creds
$username = "admin@zachcorp.onmicrosoft.com"
$password = "zach.wang" | ConvertTo-SecureString -AsPlainText -Force
$credential = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password


$Script:LogFile= "C:\Program Files\ZachCorp User Provison\Logs\Group-Provison.log"
$Script:UserOutputFile = "C:\Program Files\ZachCorp User Provison\Logs\Group-User.csv"
$GroupMappingFile = "C:\Program Files\ZachCorp User Provison\map.yml"






function Write-Log
{
    Param ([string]$Text,
        $ErrorRecord )

    ##  Note: Assumes $LogFile has been set in a parent scope.
    #  Prepend date time to entry

    $Entry = (Get-Date).ToString( 'yyyy-MM-dd HH:mm:ss,' ) + $Text

    try
        {
        #  Write entry to log file
        $Entry | Out-File -FilePath $Script:LogFile -Encoding ascii -Append -Force
        }
    catch
        {
        Write-Warning -Message "Error writing to log file [$($LogFile)]" -Verbose
        }

    #  Write entry to console

    Write-Verbose -Message $Entry -Verbose

}


Function Assign-ZachGroup 
{
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory=$False,
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true)]
        $Samaccountname,
        [Parameter(Mandatory=$False,
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true)]
        $GroupName,
        [Parameter(Mandatory=$False,
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true)]
        $itemID

    )

    Process
    {
        Import-Module powershell-yaml
        # Do this before Install-Module -Name powershell-yaml
        $rawdata = Get-Content -Path  $GroupMappingFile |Out-String
        $mapping = ConvertFrom-Yaml $rawdata
        #foreach ($content in $mapping.ITR_zach_BPM_Fraud_L1.Entitlements)
        #{
        #Write-Host $content
        #}
        Write-Host Adding user to $GroupName
        try {

        foreach($Group in $GroupName){

        foreach ($content in $mapping.($Group).Entitlements)
        {
        Write-Host adding user to Group $content
        Add-ADGroupMember -Identity $content -Members $Samaccountname -Verbose
        
        }
        }
        }
        catch {
        Write-Host "Exception:$($PSItem.Exception.Message) `n Stack:$($_.ScriptStackTrace)" -ForegroundColor RED
        Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationStatus" = $StatusCodes.'ZachCorp Permission Error'; "AutomationLog" = "Exception:$($PSItem.Exception.Message) Stack:$($_.ScriptStackTrace)"}
        Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationLog" = "Exception:$($PSItem.Exception.Message) Stack:$($_.ScriptStackTrace)"}
        }


        Write-Log "$Samaccountname|$GroupName"

        "$Samaccountname|$GroupName" | Out-File -FilePath $Script:UserOutputFile -Encoding ascii -Append -Force

    }
}


$StatusCodes = @{
'New Request' = '00-New Request'
'Provisioning Queue' = '10-Provisioning Queue'
'Provisioning SHCorp AD Queue' = '11-Provisioning SHCorp AD Queue'
'Provisioning AD Inprocess' = '20-Provisioning AD Inprocess'
'Provisioning AD Complete' = '21-Provisioning AD Complete'
'Provisioning M365 Inprocess' = '22-Provisioning M365 Inprocess'
'Provisioning M365 Complete' = '23-Provisioning M365 Complete'
'Provisioning SHCorp AD InProcess' = '24-Provisioning SHCorp AD InProcess'
'Provisioning SHCorp AD Complete' = '25-Provisioning SHCorp AD Complete'
'Manager Notified' = '40-Manager Notified'
'Manager Approved' = '41-Manager Approved'
'TA Coordinator Notified' = '49-TA Coordinator Notified'
'UKG to AD Sync Queue' = '50-UKG to AD Sync Queue'
'Deactivate User Queue' = '60-Deactivate User Queue'
'Deactivate User Email Queue' = '61-Deactivate User Email Queue'
'User Mgmt Process Complete' = '99-User Mgmt Process Complete'
'User Deactivated' = '99-User Deactivated'
'Provisioning AD Error' = '91-Provisioning AD Error'
'Provisioning M365 Error' = '92-Provisioning M365 Error'
'Notification Error' = '94-Notification Error'
'UKG Sync Error' = '95-UKG Sync Error'
'Deactivate User Error' = '96-Deactivate User Error'
'Password Reset Error' = '97-Password Reset Error'
'Provisioning SHCorp AD Error' = '98-Provisioning SHCorp AD Error'
'ZachCorp Permission Que' = '27-ZachCorp Permission Que'
'ZachCorp Permission Inprogress' = '28-ZachCorp Permission Inprogress'
'ZachCorp Permission Success' = '29-ZachCorp Permission Success'
'ZachCorp Permission Error' = '30-ZachCorp Permission Error'



}

#https://docs.microsoft.com/en-us/answers/questions/499551/unable-to-connect-to-pnp-powershell-for-sharepoint.html

#Connect-PnPOnline -Url $siteUrl -Credentials $credential -UseWebLogin
#Connect-PnPOnline -Url $siteUrl  -PnPManagementShell
Connect-PnPOnline -Url $siteUrl -Credentials $credential

#region Provision User

#Get items from a list that have no automation run status
$qry = "<View><Query><Where><And>
        <Eq><FieldRef Name='AutomationStatus'></FieldRef><Value Type='Text'>$($StatusCodes.'ZachCorp Permission Que')</Value></Eq>
        <IsNotNull><FieldRef Name='SamAccountName' /></IsNotNull>
        </And></Where></Query></View>"

$openListItems = Get-PnPListItem -List $listTitle -Query $qry
Write-Log "*Provision User Group*"
Write-Log "User to assign group: $($openListItems.Length)"
$openListItems | Format-Table
if($openListItems.Length -gt 0){
Write-Log ""
Write-Log "Create ADUsers"
Write-Log "DisplayName,UserName,Email,UPN,Password" 

"DisplayName|UserName|Email|UPN|Password" | Out-File -FilePath $HOME\writelog.csv  -Encoding ascii -Append -Force

}

#loop over each row returned and create AD record
foreach($user in $openListItems)
{
    try{
        $startString = (Get-Date).ToString( 'yyyy-MM-dd.HH.mm.ss' )
        #region Get Column Values
       
        $itemID = $user.FieldValues["ID"]
        $GroupName = $user.FieldValues["GroupName"]
        #$SamAccountName =$user.FieldValues["SamAccountName"]
        $UserPrincipalName = $user.FieldValues["UserPrincipalName"]

        if ($UserPrincipalName -eq $null){
        $SamAccountName =$user.FieldValues["SamAccountName"]
        $SamAccountName= $SamAccountName.split("@")[0]
        }
        else{
        $SamAccountName = $UserPrincipalName.split("@")[0]
        }
        


        Write-Host "Calling Group Functions for User with Values: ID:$itemID|GroupName:$GroupName|SamAccountName:$SamAccountName"

        if ($GroupName -eq $null)
        {Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationStatus" = $StatusCodes.'ZachCorp Permission Error'; "AutomationLog" = "GroupName not selected"}
        }
        else{

        #endregion

        #Update row to Inprocess
        Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationStatus" = $StatusCodes.'ZachCorp Permission Inprogress' ; "AutomationLog" = "Assigning ZachCorp Group to AD User"} | Out-Null
    
        <#        #>
        
        Assign-ZachGroup -Samaccountname $SamAccountName -GroupName  $GroupName  -itemID $itemID
        #New-zachUser -ItemID $itemID -DisplayName $DisplayName -FirstName $FirstName -LastName $LastName -SamAccountName $SamAccountName -EmailAddress $EmailAddress -Manager $Manager  -Location $Location -Admaster $Admaster
        #New-ADUser -Name $DisplayName -DisplayName:$DisplayName2 -GivenName:$FirstName -Path:$OUPath -SamAccountName:$SamAccountName -Surname:$LastName -Type:"user" `
        #        -EmailAddress $EmailAddress -UserPrincipalName $UPN -Enabled $True -PasswordNotRequired $True
        #New-zachUser -ItemID $itemID -DisplayName $DisplayName -EmployeeID $null -Type $UserType -Department $Department -JobTitle $JobTitle  -OU $OU -FirstName $FirstName -Initials $MiddleInitial -LastName $LastName `
        #                -SamAccountName $SamAccountName -Status $Status -EmailAddress $EmailAddress `
        #                -OfficeStreetAddress $OfficeStreetAddress -City $City -ZipCode $ZipCode -State $State -Country $Country -OfficeName $OfficeName -Telephone $Telephone `
        #                -Company $Company -Manager $Manager  -Location $Location
 
        #Update row to Inprocess and update Log
        $endString = (Get-Date).ToString('yyyy-MM-dd.HH.mm.ss')
        Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationStatus" = $StatusCodes.'ZachCorp Permission Success'; "AutomationLog" = "ZachCorp Group has been assigned"} | Out-Null
        
    }}
    catch{
        Write-Host "Exception:$($PSItem.Exception.Message) `n Stack:$($_.ScriptStackTrace)" -ForegroundColor RED
        Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationStatus" = $StatusCodes.'ZachCorp Permission Error'; "AutomationLog" = "Exception:$($PSItem.Exception.Message) Stack:$($_.ScriptStackTrace)"}
        Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationLog" = "Exception:$($PSItem.Exception.Message) Stack:$($_.ScriptStackTrace)"}
    }
    
}

Disconnect-PnPOnline