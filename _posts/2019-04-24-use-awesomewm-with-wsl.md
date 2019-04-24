---
layout: post
category: [tools]
tags: [wsl]
infotext: 'finally get the way to awesome-wm in wsl.'
---
{% include JB/setup %}

# Install softwares

- install the WSL (Windows Subsystem for Linux) in Windows
- install the VcXsrv Windows X Server in Windows
- install awesome-wm with `sudo apt install awesome` in WSL

# Prepare scripts

- awesome launch shell in WSL

```
export DISPLAY=:0.0
awesome >/dev/null 2>&1
```

- WSL lauch batch script in Windows

```
start "ubuntu" "<path_to_VcXsrv_>\vcxsrv.exe" :0 -clipboard -wgl -keyhook -nodecoration

sleep 2

powershell.exe -WindowStyle Hidden -c "bash -i -c <path_to_awesome_launch_shell>"
```
