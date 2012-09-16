#!/bin/sh

for file in *; do
  destination="$HOME/.$file"
  install=0;
  if [ $file != 'install.sh' ]; then

    if [ -e "$destination" ]; then
      if [ "$MSYSTEM" = "MINGW32" ]; then
        echo -n "Dotfile $destination already exists. Overwrite it? [Y/n] "
        read x
        if [ "$x" = "y" ] || [ "$x" = "Y" ] || [ "$x" = "" ]; then
          install=1
          echo "Overwrite dotfile $destination"
        fi
      fi
    else
      echo "Create dotfile $destination"
      install=1
    fi

    if [ $install = 1 ]; then
      if [ "$MSYSTEM" = "MINGW32" ]; then
        cp -a "$PWD/$file" "$destination"
        if [ $file == 'vim' ]; then
          cp -a $destination $HOME/vimfiles
        fi
      else
        ln -s "$PWD/$file" "$destination"
      fi
    fi
  fi
done
