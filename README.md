# Dotfiles

Run `./install.sh`

### Homebrew

```
# Create list of installed packages
brew list | xargs -L1 > homebrew/brews.txt

# Install packages
xargs brew install < homebrew/brews.txt
```
