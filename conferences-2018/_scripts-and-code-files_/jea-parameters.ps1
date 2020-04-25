VisibleCmdlets = 'Restart-Computer', 'Get-NetIPAddress'

VisibleCmdlets = @{ Name = 'Restart-Computer'; Parameters = @{ Name = 'Name' }}

VisibleCmdlets = @{ Name = 'Restart-Service'; Parameters = @{ Name = 'Name'; ValidateSet = 'Dns', 'Spooler' }},
                 @{ Name = 'Start-Website'; Parameters = @{ Name = 'Name'; ValidatePattern = 'HR_*' }}

VisibleExternalCommands = 'C:\Windows\System32\whoami.exe'


SessionType = ‘RestrictedRemoteServer’

RoleDefinitions = @{ ‘Tech-Trainer\Help Desk’ = @{ RoleCapabilities = ‘HelpDeskJEA’ };}