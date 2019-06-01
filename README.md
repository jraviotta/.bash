# Bash config files

Clone to ~/.bash and install

```bash
git clone git@github.com:jraviotta/.bash.git ~/
source ~/.bash/.bash_profile
```

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
