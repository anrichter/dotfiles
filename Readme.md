# My personal DotFiles

My dotfiles are for zsh on Linux and PowerShell on Windows.

## Linux

First install zsh and set it as default shell

```shell
sudo apt install zsh
chsh -s $(which zsh)   
```

Now it's time to install dotfiles to your system.
Simple run the install script

```shell
./install.sh
```

## Windows

To install it on Windows open a PowerShell and start

```shell
.\install.ps1
```

In order to run this script you have to set the ExecutionPolicy as an Administrator like this

```shell
Set-ExecutionPolicy RemoteSigned
```

To create symlinks on Windows you have to activate Developer Mode

After installation from my dotfiles and oh-my-posh, install a Nerd Font with special Icons

```shell
oh-my-posh font install CascadiaCode
```

Set ```CaskaydiaCove Nerd Font``` as default font in Terminal and Editor
