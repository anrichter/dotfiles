#!/bin/sh

for file in *; do
  destination="$HOME/.$file"
  if [ -e "$destination" ]; then
    echo "Dotfile $destination already exists. Leave it untouched"
  else
    if [ $file != 'install.sh' ]; then
      echo "Create dotfile $destination"
      if [ "$MSYSTEM" = "MINGW32" ]; then
        cp -a "$PWD/$file" "$destination"
      else
        ln -s "$PWD/$file" "$destination"
      fi
    fi
  fi
done
