# Bash config files

Clone to ~/.bash  
Create symlinks in ~
### PowerShell as admin  
```
New-Item -Path $ENV:USERPROFILE\.bash_profile -ItemType SymbolicLink -Value $ENV:USERPROFILE\.bash\.bash_profile
New-Item -Path $ENV:USERPROFILE\.bashrc -ItemType SymbolicLink -Value $ENV:USERPROFILE\.bash\.bashrc
New-Item -Path $ENV:USERPROFILE\.bash_aliases -ItemType SymbolicLink -Value $ENV:USERPROFILE\.bash\.bash_aliases
```
### Bash
```bash
ln -s ~/.bash/.bash_profile ~/.bash_profile
ln -s ~/.bash/.bashrc ~/.bashrc
ln -s ~/.bash/.bash_aliases ~/.bash_aliases
```

# I've given up on windows
install
`choco install sudo`

# Configuring a Windows machine for cross-platform development

Choose whether to install WSL and work from Linnux or Stay Windows native. Then follow the instructions in the repo.

## Platform agnostic customizations

### Docker customizations
[create aliases](https://4sysops.com/archives/how-to-create-a-powershell-alias/)

https://nickjanetakis.com/blog/docker-tip-26-alias-and-function-shortcuts-for-common-commands

### Fix chrome app shortcuts on Start screen  

https://superuser.com/questions/1143974/how-to-get-chrome-favicons-to-appear-in-windows-10-start-menu?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa  

tl;dr - run this as admin in powershell

```Powershell
param (
  $PATH = (Join-Path -Path (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').Path -ChildPath "chrome.VisualElementsManifest.xml")
  )

if (Test-Path $PATH) {
 $newName="$(Split-Path -Leaf $PATH).bkup)"
 Rename-Item -Path $PATH -newName $newName
}
```
