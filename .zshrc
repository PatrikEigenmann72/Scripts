# ------------------------------------------------------------------------------------
# .zshrc - Configuration file for Z shell (zsh)
# This file is executed whenever a new zsh session is started.
# Customize your shell environment by setting variables, aliases, functions, and more.
# Enhance productivity with personalized settings, plugins, and themes.
# Explore and modify to suit your workflow and preferences.
#
# Author:	Patrik Eigenman
# EMail:	p.eigenmann@gmx.net
# ------------------------------------------------------------------------------------

# In this section I have extended my $PATH variable with the homebrew specific paths
# and the path of my own binaries from my C/C++ programming. Copy and paste is here
# my friend if I ever want to add more sprecific path to the $PATH variable.
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/Development/Scripts:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export DYLD_LIBRARY_PATH="/Users/patrik/Development/cpp/mylibs/bin:."

# Alias section A: All global use aliases.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias rld='exec zsh'
alias dir='ls -al'
alias vimp='cd ~/Documents/Private/Vim'

# Development specific aliases.
alias dev='cd ~/Development'
alias dscript='cd ~/Development/scripts'
alias djava='cd ~/Development/Java'
alias ppp='cd ~/Development/php'
alias pyt='cd ~/Development/python'
alias tem='cd ~/Development/templates'
alias www='cd ~/Development/www'

# C-Projects
alias dcpp='cd ~/Development/cpp'
alias install='~/Development/Scripts/install.sh'
compile() {
/Users/patrik/Development/Scripts/compile.sh "$@"
}

cget() {
/Users/patrik/Development/Scripts/get-ccomponent.sh "$@"
}

# Java-Projects
alias jdbg='run-jbuild.sh'
alias jpbl='run-jpublish.sh'

# This function will copy an existing file from the HelloJWorld project.
jget() {
/Users/patrik/Development/Scripts/jget.sh "$@"
}

# This function will copy a new file from one of the templates.
jnew() {
/Users/patrik/Development/Scripts/jnew.sh "$@"
}

# All Nano Log and Config files.
alias nzsh='nano ~/.zshrc'
alias nhst='sudo nano /etc/hosts'
alias ndev='nano ~/Development/Development.code-workspace'
alias nlog='nano ~/Library/Logs/samael/samael.log'
alias cwlg='echo "" > "/Users/patrik/VirtualBox VMs/Windows11/Logs/VBox.log"'
alias clrbin='rm -rf ./bin/*'
alias clrbld='rm -rf ./build/*'
