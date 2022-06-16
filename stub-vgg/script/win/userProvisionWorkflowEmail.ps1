$ukgusername = "zach.wang" | ConvertTo-SecureString -AsPlainText -Force
$ukgcredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $ukgusername, $ukgpassword
$headers =  @{'us-customer-api-key' = 'apikey'}

$a=0
do {
    $a++
    $tempObj = $null
    $URL = "https://zach.service.com"
    $tempObj = Invoke-RestMethod -Method 'Get' -Uri $url -Credential $ukgcredential -headers $headers
    
    If ($tempObj.Count -ne 0)
    {$employees += $tempObj}
    else
    {$LoopStopCount = "end"}

    ####    DEV CODE   #####
    #$LoopStopCount = "end" #forces a single loop
    ####

    #Write-output "UKG employees returned in this ws call:$($employees.count)"

} until ($LoopStopCount -eq "end")




		$EmailAddress =$user.FieldValues["EmailAddress"]
        $OfficeName = $user.FieldValues["OfficeName"]
        $City = $user.FieldValues["City"]
        $email="xyu1@Zach.com"
        $content=""

        if (-not [string]::IsNullOrEmpty($OfficeName)){

            $targetlocation=("nyc","los angeles", "shanghai")

            if ($targetlocation.Contains($OfficeName.ToLower()) -or $targetlocation.Contains($City.ToLower())){
			
			foreach( $ukgEmployee in $employees){
	        if ($ukgEmployee.emailAddress -eq $EmailAddress) {
    $firstName = $ukgEmployee.firstName 
    $lastName = $ukgEmployee.lastName
    $department = $ukgEmployee.orgLevel2Code
    $ukgHireDate = $ukgEmployee.hireDate 
    $employeeAddress1=$ukgEmployee.employeeAddress1
    $employeeAddress2=$ukgEmployee.employeeAddress2
    $city = $ukgEmployee.city
    $state = $ukgEmployee.state
    $country = $ukgEmployee.countryCode
    $ManagerName = $ukgEmployee.supervisorName
    $content= "Hi IT Services,

A new user has been created from system. Please find the user info below.

        DisplayName: $DisplayName
        SamAccountName: $SamAccountName
        FirstName: $firstName
        LastName: $lastName
        EmailAddress: $EmailAddress
        Department: $department
        HireDate: $ukgHireDate
        EmployeeAddress1: $employeeAddress1
        EmployeeAddress2: $employeeAddress2
        City: $city
        State: $state
        Country: $country
        Manager: $ManagerName


Regards,
IT Services
        "
                }
		}
            Send-MailMessage -From 'Zach IT Services<DL-SH-ITSS@Zach.com>' -To $email -Subject $title -Body $content -Priority High -DeliveryNotificationOption OnSuccess, OnFailure -SmtpServer 'smtp.usws00.com' -verbose
            }
        }
