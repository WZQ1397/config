param($file)
$file
$items = Get-Content $file
$line_number = 1
foreach ($sam in $items)
{
	Write-Progress -activity "AD user password set Started: " -Status $line_number
	if($sam -eq ""){
	   continue
	}
	Write-Host "$line_number  $sam"
	Set-ADAccountPassword -Identity $sam -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "zach.wang" -Force)
	Start-Sleep -Seconds 2
	Get-ADUser -Identity $sam -Properties * |select enabled,lockedout,passwordexpired,passwordLastSet
	Start-Sleep -Seconds 2
	$line_number++
}