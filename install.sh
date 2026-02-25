#!/bin/sh

YES=1
NO=2

yes_to_all=$NO

can_install () {
  question=$1

  if [ $yes_to_all = $NO ]
  then
    echo -n "$question [Y/n/a] "
    read x

    if [ "$x" = "a" ]
    then
      yes_to_all=$YES
    fi

    if [ "$x" = "y" ] || [ "$x" = "Y" ] || [ "$x" = "" ] || [ "$x" = "a" ]
    then
      return $YES
    else
      return $NO
    fi
  else
    return $YES
  fi
}

install () {
  source=$1
  dest=$2
  echo "Install $source to $dest"

  if [ -e $dest ] && [ ! -L $dest ]
  then
    mv $dest "$dest.dotfile_save"
  fi

  ln -sf "$PWD/$source" "$dest"
}

install_dotfiles_in () {
  for file in $( find $1 -mindepth 1 -maxdepth 1 -name '*')
  do
    destination=$HOME/.${file#*/}
    
    if [ -e $destination ]
    then
      can_install "Dotfile $destination already exists. Overwrite it?"
      installdest=$?
    else
      installdest=$YES
    fi

    if [ $installdest = $YES ]
    then
      install $file $destination
    fi
  done
}

install_dependencies() {
  echo "In order to use dotfiles in zsh you need to install some dependencies\n"
  
  can_install "Install Oh My Posh?"
  if [ $? = $YES ]
  then
    curl -s https://ohmyposh.dev/install.sh | bash -s
  fi
}

install_dependencies
install_dotfiles_in "zsh"
install_dotfiles_in "independent"
