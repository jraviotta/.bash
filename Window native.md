# Windows native configuration

## [Make Powershell Useful](http://jbeckwith.com/2012/11/28/5-steps-to-a-better-windows-command-line/)  

See also https://mathieubuisson.github.io/powershell-linux-bash/

### Allow PowerShell to [run scripts](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6)   

* Open PowerShell as an administrator:  

```Powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser  
```

### Install [chocolatey](http://chocolatey.org/) package manager  

* Install to default location using Administrative PowerShell with this command

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

* OR Install to modified location using Non-Administrative PowerShell with this command

```powershell
$InstallDir=$env:systemdrive + '\ProgramData\chocoportable'; $env:ChocolateyInstall="$InstallDir"; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

* Install useful packages  

```powershell
# Linux-y stuff  
cinst -y git.install  
cinst -y git-credential-manager-for-windows  
cinst -y poshgit --pre  
cinst -y 7zip.install  
cinst -y composer  
cinst -y make  
cinst -y nodejs.install  

# Favorite development tools  
cinst -y docker-for-windows  
cinst -y sublimetext3  
cinst -y sublimetext3.packagecontrol  
cinst -y sublimetext3.powershellalias  
cinst -y sourcetree  

# Analysis tools
cinst -y anaconda3  
cinst -y r.project  
```

### Modify PowerShell profile

Improve [posh-git prompt](https://github.com/dahlbyk/posh-git/wiki/Customizing-Your-PowerShell-Prompt)

```powershell
Add-Content -Path $profile -Value '$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true'
Add-Content -Path $profile -Value ('$GitPromptSettings.DefaultPromptSuffix =' + "'" + '`n$(">" * ($nestedPromptLevel + 1))' + "'")
& $profile
```  

Add aliases

```powershell
Add-Content -Path $profile -Value ('function idea { &"${Env:ProgramFiles}\JetBrains\IntelliJ IDEA64*\bin\idea.exe" $args }')
Copy-Item "docker_aliases" -Destination (get-item $profile ).Directory  -Recurse
Add-Content -Path $profile -Value 'Import-Module (Join-Path $PSScriptRoot  \\docker_aliases\docker_aliases.psm1)'
Unblock-File -Path (Join-Path (Split-Path -Path $Profile)  \\docker_aliases\docker_aliases.psm1)
Copy-Item "bash_aliases" -Destination (get-item $profile ).Directory -Recurse
Add-Content -Path $profile -Value 'Import-Module (Join-Path $PSScriptRoot \\bash_aliases\bash_aliases.psm1)'
Unblock-File -Path (Join-Path (Split-Path -Path $Profile)  \\bash_aliases\bash_aliases.psm1)
```

Configure [GIT authentication](https://github.com/Microsoft/Git-Credential-Manager-for-Windows)  
`git config --global credential.helper manager`  
Set ssh as the default connection for GitHub & Bitbucket. Tokens are [here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) & [here](https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html)

```
git config --global url.ssh://git@github.com/.insteadOf https://github.com/  
git config --global url.ssh://git@bitbucket.org/.insteadOf https://bitbucket.org/  
```

### [Symlinks on Windows with Git Bash](https://www.joshkel.com/2018/01/18/symlinks-in-windows/)

1. Grant permissions to user to [create symlinks](https://github.com/git-for-windows/git/wiki/Symbolic-Links#allowing-non-administrators-to-create-symbolic-links)  
    1. Local Group Policy Editor: Launch gpedit.msc, navigate to Computer configuration - Windows Setting - Security Settings - Local Policies - User Rights Assignment and add the account(s) to the list named Create symbolic links.
1. Add environemnt variable MSYS=winsymlinks:nativestrict  
1. Set `git config core.symlinks true` see [this link.](https://stackoverflow.com/questions/32847697/windows-specific-git-configuration-settings-where-are-they-set/32849199#32849199)  

### Executing bash scripts
A default install of Git provides git-bash at `C:\Program Files (x86)\Git\git-bash.exe`. This should make bash scripts executable in 
PowerShell. Verify with `.\hello.sh` from the repo directory. Otherwise check the Windows path environment variable or
[install WSL](https://www.howtogeek.com/261591/how-to-create-and-run-bash-shell-scripts-on-windows-10/).  