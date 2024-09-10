# Create list of installed packages
brew list | xargs -L1 > homebrew/brews.txt
