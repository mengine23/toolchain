<#
  .SYNOPSIS
      WinRM settings
  .DESCRIPTION
      Set some firewall rules for WinRM and allow unencrypted powershell script files.
  .NOTES
      File Name      : 10_winrm.ps1
      Author         : CM (chris@mindengine.de)
      Prerequisite   : PowerShell V2 over Vista and upper
      Copyright 2019 - CM/mindengine
 #>

netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
netsh advfirewall firewall add rule name="WinRM-HTTPS" dir=in localport=5986 protocol=TCP action=allow
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
