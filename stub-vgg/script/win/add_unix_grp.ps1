﻿$NewGroupname = $Args[0]
New-ADGroup -Name "$NewGroupname" -SamAccountName "$NewGroupname" -GroupCategory Security -GroupScope DomainLocal -Path "OU=prodaccess,OU=Local,OU=Groups,OU=UNIX,DC=zach,DC=com" -Server "uswp00dcs001.zach.com"