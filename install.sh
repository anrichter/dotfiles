#!/bin/sh

for file in *; do
  if [ "$file" != "install.sh" ]; then
    destination="$HOME/.$file"
    if [ -e "$destination" ]; then
      echo "Dotfile $destination already exists. Leave it untouched"
    else
      echo "Create dotfile $destination"
      cp "$PWD/$file" "$destination"
    fi
  fi
done

