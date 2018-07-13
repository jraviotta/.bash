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
<<<<<<< HEAD
```
=======
```

# I've given up on windows
install
`choco install sudo`
>>>>>>> acd73f747331b1d1ae779d678eef943e635752b4
