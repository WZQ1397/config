

#Pre-steps:
#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#Install-Module -Name PnP.PowerShell


#$siteUrl = 'https://zach.sharepoint.com/sites/ITAutomation/'
$siteUrl = 'https://zach.sharepoint.com/sites/ITAutomation'
$listTitle = 'UserProvisioning'
$domain = 'zachcorp.com'
#user creds
$username = "admin@zach.onmicrosoft.com"
$password = "zach.wang" | ConvertTo-SecureString -AsPlainText -Force
$credential = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password


$Script:LogFile= "C:\Program Files\Zachcorp User Provison\Logs\User-Creation.log"
$Script:UserOutputFile = "C:\Program Files\Zachcorp User Provison\Logs\User-CreationOutput.csv"



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

Function New-zachcorpUser 
{
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory=$False,
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true)]
        $ItemID, 


        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        $DisplayName,


        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        $FirstName,

        [Parameter(Mandatory=$False,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        $LastName,
        [Parameter(Mandatory=$True,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        $SamAccountName,
        [Parameter(Mandatory=$False,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        $EmailAddress,
        [Parameter(Mandatory=$False,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        $OneTimePassword

    )

    Process
    {
        $ADDom = Get-ADDomain
        $Dom = '@'+$ADDom.DnsRoot
        $Server = $ADDom.PDCEmulator

        #region Check parameters and variables
        if($SamAccountName -eq '')
        {
            Write-Host " [WARNING]: Cannot continue. Username required!" -ForegroundColor White -BackgroundColor DarkMagenta
            Write-Host " $DisplayName " -ForegroundColor White -BackgroundColor DarkMagenta
            $DisplayName | Out-File $home\desktop\Error_NoSAM.csv
            Write-Host ""
            return
        }

        $OUpath = "OU=ProvisionedUser,OU=UserAccts,DC=zachcorp,DC=com"


        $UPN = $SamAccountName + '@' + $domain

        #endregion

        if(@(Get-ADUser -Filter { SamAccountName -eq $SamAccountName }).Count -eq 0) 
        {                       
            Write-Host "Creating user account: $SamAccountName" -ForegroundColor Yellow -BackgroundColor DarkCyan

            New-ADUser -Name "$DisplayName" -DisplayName:"$DisplayName" -GivenName:"$FirstName" -Path:"$OUPath" -SamAccountName:"$SamAccountName"  -Surname:"$LastName" -Type:"user" -EmailAddress $EmailAddress -UserPrincipalName $UPN -Enabled $True -PasswordNotRequired $True


        }
        else
        {
            Write-Host " [WARNING]: $SamAccountName -User already exists. " -ForegroundColor Yellow -BackgroundColor DarkGray
            Write-Log " [WARNING]: $SamAccountName -User already exists. "
            Write-Host ""
        }       

        $ADUser = Get-ADUser -Identity $SamAccountName
        $DN = $ADUser.DistinguishedName

        #Set-ADUser $DN -add @{ProxyAddresses="SMTP:$SamAccountName@zachcorp.com,smtp:$SamAccountName@zach.com " -split ","}

        Add-Type -AssemblyName System.Web
        $password = $OneTimePassword
        Write-Host Password for $SamAccountName $Password -ForegroundColor Yellow -BackgroundColor Black

        Set-ADAccountPassword -Identity:$DN -NewPassword:(ConvertTo-SecureString -AsPlainText "$Password" -Force) -Reset:$true 

        Set-PnPListItem -List $listTitle -Identity $ItemID -Values @{"OneTimePassword" = $Password} | Out-Null
    
        if($status -eq 'Active')
        {
            Enable-ADAccount -Identity:$DN 
           # Enable-ADAccount -Identity:$DN -Server:$Server
        }



        $UserProperties = Get-ADUser -Identity:$DN -Properties DisplayName,EmployeeId
        #Add-ADGroupMember -Identity Technology -Members $UserProperties.samaccountname -Verbose

   


        Write-Log "$($UserProperties.displayName),$($UserProperties.samaccountname),$($UserProperties.UserprincipalName),$password"

        "$($UserProperties.displayName)|$($UserProperties.samaccountname)|$EmailAddress|$($UserProperties.UserprincipalName)|$password" | Out-File -FilePath $Script:UserOutputFile -Encoding ascii -Append -Force

    }
}



$StatusCodes = @{
'Provisioning SHCorp AD Queue' = '24-Provisioning SHCorp AD Queue'
'Provisioning SHCorp AD InProcess' = '25-Provisioning SHCorp AD InProcess'
'Provisioning SHCorp AD Complete' = '26-Provisioning SHCorp AD Complete'
'Provisioning SHCorp Error' = '93-Provisioning SHCorp Error'

}


Connect-PnPOnline -Url $siteUrl -Credentials $credential

#region Provision User

#Get items from a list that have no automation run status
$qry = "<View><Query><Where><And>
        <Eq><FieldRef Name='AutomationStatus'></FieldRef><Value Type='Text'>$($StatusCodes.'Provisioning SHCorp AD Queue')</Value></Eq>
        <IsNotNull><FieldRef Name='SamAccountName' /></IsNotNull>
        </And></Where></Query></View>"

$openListItems = Get-PnPListItem -List $listTitle -Query $qry
Write-Log "*Provision Users*"
Write-Log "Users to Create: $($openListItems.Length)"
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
        $DisplayName = $user.FieldValues["Title"]
        $SamAccountName =$user.FieldValues["SamAccountName"]
        $FirstName= $user.FieldValues["FirstName"]
        $LastName =$user.FieldValues["LastName"]
        $EmailAddress =$user.FieldValues["EmailAddress"]
        $AutomationStatus = $user.FieldValues["AutomationStatus"]
        $OneTimePassword = $user.FieldValues["OneTimePassword"]

        Write-Host "Calling User Functions for User with Values: ID:$itemID|DisplayName:$DisplayName|Manager:$Manager
                    SamAccountName:$SamAccountName|FirstName:$FirstName|LastName:$LastName|EmailAddress:$EmailAddress
                    UserType:$UserType|AutomationStatus:$AutomationStatus|Location:$Location|AdMaster:$Admaster|Stubtex:$Stubtex"

  
        
        #endregion

        #Update row to Inprocess
        Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationStatus" = $StatusCodes.'Provisioning SHCorp AD InProcess' ; "AutomationLog" = "Creating SHCorp AD User"} | Out-Null
    
        <#        #>
        New-zachcorpUser -ItemID $itemID -DisplayName $DisplayName -FirstName $FirstName -LastName $LastName -SamAccountName $SamAccountName -EmailAddress $EmailAddress -OneTimePassword $OneTimePassword

 
        #Update row to Inprocess and update Log
        $endString = (Get-Date).ToString('yyyy-MM-dd.HH.mm.ss')
        Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationStatus" = $StatusCodes.'Provisioning SHCorp AD Complete'; "AutomationLog" = "SHCorp AD User Created"} | Out-Null
        
    }
    catch{
        Write-Host "Exception:$($PSItem.Exception.Message) `n Stack:$($_.ScriptStackTrace)" -ForegroundColor RED
        Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationStatus" = $StatusCodes.'Provisioning SHCorp Error'; "AutomationLog" = "Exception:$($PSItem.Exception.Message) Stack:$($_.ScriptStackTrace)"}
        Set-PnPListItem -List $listTitle -Identity $itemID -Values @{"AutomationLog" = "Exception:$($PSItem.Exception.Message) Stack:$($_.ScriptStackTrace)"}
    }
}

Disconnect-PnPOnline