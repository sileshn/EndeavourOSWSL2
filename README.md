# Disclaimer

This project is in no way related to or created by the official EndeavourOS team or its members. It is solely a project of mine. Do not go around spamming the EndeavourOS forum if you come across any issues. You certainely won't receive any help. Mention your issues here and I'll try to find a solution.

# EndeavourOS for WSL2

Running minimal EndeavourOS bootstrap on WSL2 (Windows 10 FCU or later) based on [wsldl](https://github.com/yuk7/wsldl). This does not come with all the packages required to run a GUI ootb!!! You can take a look at [this](https://github.com/endeavouros-team/EndeavourOS-ISO/blob/main/packages.x86_64) package list or use the built-in [eos-packagelist](https://github.com/endeavouros-team/EndeavourOS-packages-lists) command to install the required packages if you are interested in implementing GUI support. Even then, success is not guaranteed.

[![Screenshot-2022-07-26-063310.png](https://i.postimg.cc/V6CyJBm0/Screenshot-2022-07-26-063310.png)](https://postimg.cc/qh4DYKtp)
[![Github All Releases](https://img.shields.io/github/downloads/sileshn/EndeavourOSWSL2/total?logo=github&style=flat-square)](https://github.com/sileshn/EndeavourOSWSL2/releases) [![GitHub release (latest by date)](https://img.shields.io/github/v/release/sileshn/EndeavourOSWSL2?display_name=release&label=latest%20release&style=flat-square)](https://github.com/sileshn/EndeavourOSWSL2/releases/latest)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![License](https://img.shields.io/github/license/sileshn/EndeavourOSWSL2.svg?style=flat-square)](https://github.com/sileshn/EndeavourOSWSL2/blob/main/LICENSE)

## Features and important information
EndeavourOSWSL2 has the following features during the installation stage.
* Increase virtual disk size from the default 256GB
* Create a new user and set the user as default
* EndeavourOSWSL2 Supports systemd natively if you are running wsl v0.67.6 (more details here) and above. For earlier versions of wsl, systemd is supported using diddledani's one-script-wsl2-systemd. This is done automatically during initial setup.
* EndeavourOSWSL2 includes a wsl.conf file which only has [section headers](https://i.postimg.cc/MZ4DC1Fw/Screenshot-2022-02-02-071533.png). Users can use this file to configure the distro to their liking. You can read more about wsl.conf and its configuration settings [here](https://docs.microsoft.com/en-us/windows/wsl/wsl-config).

## Requirements
* For x64 systems: Version 1903 or higher, with Build 18362 or higher.
* For ARM64 systems: Version 2004 or higher, with Build 19041 or higher.
* Builds lower than 18362 do not support WSL 2.
* If you are running Windows 10 version 2004 or higher, you can install all components required to run wsl2 with a single command. This will install ubuntu by default. More details are available [here](https://devblogs.microsoft.com/commandline/install-wsl-with-a-single-command-now-available-in-windows-10-version-2004-and-higher/).
	```cmd
	wsl.exe --install
	```
* If you are running Windows 10 lower then version 2004, follow the steps below. For more details, check [this](https://docs.microsoft.com/en-us/windows/wsl/install-manual) microsoft document.
	* Enable Windows Subsystem for Linux feature.
	```cmd
	dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
	```
	* Enable Virtual Machine feature
	```cmd
	dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
	```
	* Download and install the latest Linux kernel update package from [here](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi).

## How to install
* Make sure all the steps mentioned under "Requirements" are completed.
* [Download](https://github.com/sileshn/EndeavourOSWSL2/releases/latest) installer zip
* Extract all files in zip file to same directory
* Set version 2 as default. Note that this step is required only for manual installation.
  ```dos
  wsl --set-default-version 2
  ```
* Run EndeavourOS.exe to extract rootfs and register to WSL

**Note:**
Exe filename is using the instance name to register. If you rename it you can register with a diffrent name and have multiple installs.

## How to setup
EndeavourOSWSL2 will ask you to create a new user during its first run. If you choose to create a new user during the first run, the steps below are not required unless you want to create additional users.

Open EndeavourOS.exe and run the following commands.
```dos
passwd
useradd -m -g users -G wheel -s /bin/bash <username>
echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel
passwd <username>
exit
```

You can set the user you created as default user using 2 methods.

Open EndeavourOS.exe, run the following command (replace username with the actual username you created).
```dos
sed -i '/\[user\]/a default = username' /etc/wsl.conf
```

Shutdown and restart the distro (this step is important).

(or)

Execute the command below in a windows cmd terminal from the directory where EndeavourOS.exe is installed.
```dos
>EndeavourOS.exe config --default-user <username>
```

## How to use installed instance
#### exe Usage
```
Usage :
    <no args>
      - Open a new shell with your default settings.
        Inherit current directory (with exception that %%USERPROFILE%% is changed to $HOME).

    run <command line>
      - Run the given command line in that instance. Inherit current directory.

    runp <command line (includes windows path)>
      - Run the given command line in that instance after converting its path.

    config [setting [value]]
      - `--default-user <user>`: Set the default user of this instance to <user>.
      - `--default-uid <uid>`: Set the default user uid of this instance to <uid>.
      - `--append-path <true|false>`: Switch of Append Windows PATH to $PATH
      - `--mount-drive <true|false>`: Switch of Mount drives
      - `--wsl-version <1|2>`: Set the WSL version of this instance to <1 or 2>
      - `--default-term <default|wt|flute>`: Set default type of terminal window.

    get [setting [value]]
      - `--default-uid`: Get the default user uid in this instance.
      - `--append-path`: Get true/false status of Append Windows PATH to $PATH.
      - `--mount-drive`: Get true/false status of Mount drives.
      - `--wsl-version`: Get the version os the WSL (1/2) of this instance.
      - `--default-term`: Get Default Terminal type of this instance launcher.
      - `--wt-profile-name`: Get Profile Name from Windows Terminal
      - `--lxguid`: Get WSL GUID key for this instance.

    backup [file name]
      - `*.tar`: Output backup tar file.
      - `*.tar.gz`: Output backup tar.gz file.
      - `*.ext4.vhdx`: Output backup ext4.vhdx file. (WSL2 only)
      - `*.ext4.vhdx.gz`: Output backup ext4.vhdx.gz file. (WSL2 only)
      - `*.reg`: Output settings registry file.

    clean
      - Uninstall that instance.

    help
      - Print this usage message.
```

#### Run exe
```cmd
>Endeavour.exe
[root@PC-NAME user]#
```

#### Run with command line
```cmd
>Endeavour.exe run uname -r
4.4.0-43-Microsoft
```

#### Run with command line using path translation
```cmd
>Endeavour.exe runp echo C:\Windows\System32\cmd.exe
/mnt/c/Windows/System32/cmd.exe
```

#### Change default user(id command required)
```cmd
>Endeavour.exe config --default-user user

>Endeavour.exe
[user@PC-NAME dir]$
```

#### Set "Windows Terminal" as default terminal
```cmd
>Endeavour.exe config --default-term wt
```

## How to update
Updating EndeavourOSWSL2 doesn't require you to download and install a newer release everytime. Usually all it takes is to run the command below to update the instance.
```dos
$sudo pacman -Syu
```

Sometimes updates may fail to install. You can try the command below in such a situation.
```dos
$sudo pacman -Syyuu
```

You may need to install a newer release if additional features have been added/removed from the installer.

## How to uninstall instance
```dos
>EndeavourOS.exe clean

```

## How to backup instance
export to backup.tar.gz (WSL1 or 2)
```cmd
>Endeavour.exe backup backup.tar.gz
```
export to backup.ext4.vhdx.gz  (WSL2 only)
```cmd
>Endeavour.exe backup backup.ext4.vhdx.gz
```

## How to restore instance

There are 2 ways to do it. 

Rename the backup to rootfs.tar.gz and run EndeavourOS.exe

(or)

.tar(.gz)
```cmd
>EndeavourOS.exe install backup.tar.gz
```
.ext4.vhdx(.gz)
```cmd
>EndeavourOS.exe install backup.ext4.vhdx.gz
```

You may need to run the command below in some circumstances.
```cmd
>EndeavourOS.exe --default-uid 1000
```

## How to build from source
#### prerequisites
Docker, tar, zip, unzip, bsdtar need to be installed.

```dos
git clone git@gitlab.com:sileshn/EndeavourOSWSL2.git
cd EndeavourOSWSL2
make
```
Copy the EndeavourOSWSL2.zip file to a safe location and run the command below to clean.
```dos
make clean
```

## How to run docker in EndeavourOSWSL2 without using docker desktop
Install docker.
```dos
sudo pacman -S docker
```

Follow [this](https://blog.nillsf.com/index.php/2020/06/29/how-to-automatically-start-the-docker-daemon-on-wsl2/) blog post for further details on how to setup. Alternatively, if using systemd, use the commands below to setup and reboot.
```dos
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER
```
<a href='http://postimg.cc/grYsWc2v' target='_blank'><img src='https://i.postimg.cc/grYsWc2v/Screenshot-2022-05-09-232847.png' border='0' alt='Screenshot-2022-05-09-232847'/></a>
