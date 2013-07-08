My personal DotFiles
====================

My dotfiles are for bash and PowerShell environments.
To install it in a bash environment simple start

    ./install.sh

If you like the PowerShell you can install the dofiles there with

    .\install.ps1

In order to run this script you have to set the ExecutionPolicy as an Administrator like this

    Set-ExecutionPolicy RemoteSigned


Update subtrees
===============

    git subtree pull --prefix independent/vim/bundle/vim-rails https://github.com/tpope/vim-rails.git master --squash
    git subtree pull --prefix independent/vim/bundle/vim-rvm https://github.com/tpope/vim-rvm.git master --squash
    git subtree pull --prefix independent/vim/bundle/vim-ps1 https://github.com/PProvost/vim-ps1.git master --squash
    git subtree pull --prefix powershell/Modules/posh-git https://github.com/dahlbyk/posh-git.git master --squash
    git subtree pull --prefix powershell/Modules/posh-svn https://github.com/anrichter/posh-svn.git master --squash

