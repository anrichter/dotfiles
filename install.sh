#!/bin/sh

YES=1
NO=2

yes_to_all=$NO

can_install () {
  dest=$1

  if [ $yes_to_all = $NO ] && [ -e "$dest" ]
  then
    echo -n "Dotfile $dest already exists. Overwrite it? [Y/n/a] "
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
  rm "$dest"
  ln -sf "$PWD/$source" "$dest"
}

install_dotfiles_in () {
  for file in $( find $1 -mindepth 1 -maxdepth 1 -name '*')
  do
    destination=$HOME/.${file#*/}
    can_install $destination
    if [ $? = $YES ]
    then
      install $file $destination
    fi
  done
}

install_dotfiles_in "bash"
install_dotfiles_in "independent"
