<#
  .SYNOPSIS
      Configures initial power settings.
  .DESCRIPTION
      Set computer to never sleep/hibernate, disable screen saver, disable hibernation
  .NOTES
      File Name      : 10_power_settings.ps1
      Author         : CM (chris@mindengine.de)
      Prerequisite   : PowerShell V2 over Vista and upper
      Copyright 2019 - CM/mindengine
 #>

# First of all let the user know whats going on
Write-Host "Running script: $(Get-Location)\$($MyInvocation.MyCommand.Name)" -ForegroundColor Magenta

Try {
  # Look for high performance power plan
  $HighPerf = powercfg -l | %{if($_.contains("Höchstleistung")) {$_.split()[3]}}
  If (!$HighPerf) {
    $HighPerf = powercfg -l | %{if($_.contains("High performance")) {$_.split()[3]}}
  }

  # Write some information
  Write-Host "High performance GUID is: $HighPerf - BigBadVoodoo going on..." -ForegroundColor yellow

  # Get current power plan
  $CurrPlan = $(powercfg -getactivescheme).split()[3]

  # Enable high performance plan if it's not already enabled
  If ($CurrPlan -ne $HighPerf) {
    powercfg -setactive $HighPerf
  }

  # Disable all the idle timeouts
  powercfg.exe -x -monitor-timeout-ac 0
	powercfg.exe -x -monitor-timeout-dc 0
	powercfg.exe -x -disk-timeout-ac 0
	powercfg.exe -x -disk-timeout-dc 0
	powercfg.exe -x -standby-timeout-ac 0
	powercfg.exe -x -standby-timeout-dc 0
	powercfg.exe -x -hibernate-timeout-ac 0
	powercfg.exe -x -hibernate-timeout-dc 0

  # Disable Hibernation File
  Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Power\ -name HiberFileSizePercent -value 0
  Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Power\ -name HibernateEnabled -value 0

  # Done
  Write-Host "Success! Power settings have been changed to high performance." -ForegroundColor green
} Catch {
  Write-Error "Could not implement high performance power settings. Exiting."
  Write-Host $_.Exception | format-list -force; Write-Host $_.Exception | format-list -force
  Exit 1
}
