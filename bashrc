# Load Aliases
if [ -f "$HOME/.aliases" ]; then
  . "$HOME/.aliases"
fi

# Load Aliases for MingW32 - MSysGit System
if [ "$MSYSTEM" = "MINGW32" -a -f "$HOME/.aliases.mingw32" ]; then
  . "$HOME/.aliases.mingw32"
fi

# Load local aliases
if [ -f "$HOME/.aliases.local" ]; then
  . "$HOME/.aliases.local"
fi
