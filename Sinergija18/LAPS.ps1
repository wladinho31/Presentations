# Import LAPS PowerShell module and update schema
Import-Module AdmPwd.PS
Update-AdmPwdADSchema

# Set OU of computers which needed LAPS
Set-AdmPwdComputerSelfPermission -Identity Servers

# Set AD group which has read permissions
Set-AdmPwdReadPasswordPermission -OrgUnit Servers -AllowedPrincipals LAPSAdmins

# Set AD group which has reset password permissions
Set-AdmPwdResetPasswordPermission -OrgUnit Servers -AllowedPrincipals LAPSAdmins

# Check local admin password
Get-AdmPwdPassword -ComputerName SRV-01
Get-AdmPwdPassword -ComputerName SRV-01 | Out-GridView

