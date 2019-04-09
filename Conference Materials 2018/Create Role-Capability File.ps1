# Set location for creating modules and create appropriate folder
Set-Location 'C:\Program Files\WindowsPowerShell\Modules'
New-Item -Name HelpDeskJEA -ItemType Directory
Set-Location .\HelpDeskJEA

# Creating new module manifest
New-ModuleManifest .\HelpDeskJEA.psd1

# Create folder and new empty role capability file
New-Item -Name RoleCapabilities -ItemType Directory
Set-Location .\RoleCapabilities
New-PSRoleCapabilityFile -Path .\HelpDeskJEA.psrc

# Edit Role Capability file
ISE HelpDeskJEA.psrc

# Create session configuration file
New-PSSessionConfigurationFile -Path .\HelpDeskJEA.pssc -Full

# Edit session configuration file
ISE HelpDeskJEA.pssc

# Create JEA endpoint
Register-PSSessionConfiguration -Name HelpDeskJEA -Path .\HelpDeskJEA.pssc
Restart-Service WinRM

# Check PS Session Configuration
Get-PSSessionConfiguration