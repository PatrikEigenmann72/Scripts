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
#export PATH="/opt/homebrew/opt/php@8.3/bin:$PATH"
#export PATH="/opt/homebrew/opt/php@8.3/sbin:$PATH"
#export PATH="$HOME/Development/scripts:$PATH"
#export PATH="/opt/homebrew/opt/ncurses/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/Development/Scripts:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/ncurses/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/ncurses/include"
export DYLD_LIBRARY_PATH="/Users/patrik/Development/cpp/mylibs/bin:."

# Alias section A: All global use aliases.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias rld='exec zsh'
alias dir='ls -al'
alias rwww='brew services restart httpd'
alias vimp='cd ~/Documents/Private/Vim'

# Development specific aliases.
alias dev='cd ~/Development'
alias dscript='cd ~/Development/scripts'
alias djava='cd ~/Development/Java'
alias dcpp='cd ~/Development/cpp'
alias src='cd ./src'
alias ppp='cd ~/Development/php'
alias pyt='cd ~/Development/python'
alias tem='cd ~/Development/templates'
alias www='cd ~/Development/www'

# C-Projects
alias cpmk='cd ~/Development/cpp/pmake'
alias cvim='cd ~/Development/cpp/viim'

# Java-Projects
alias jdbg='run-jbuild.sh'
alias jpbl='run-jpublish.sh'

# All Nano Log and Config files.
alias nzsh='nano ~/.zshrc'
alias nhtt='nano /opt/homebrew/etc/httpd/httpd.conf'
alias nvhs='nano /opt/homebrew/etc/httpd/extra/httpd-vhosts.conf'
alias nhst='sudo nano /etc/hosts'
alias ndev='nano ~/Development/Development.code-workspace'
alias nlog='nano ~/Library/Logs/samael/samael.log'
alias nwbs='nano /opt/homebrew/var/log/httpd/wbsrvr-access_log'
alias nwbe='nano /opt/homebrew/var/log/httpd/wbsrvr-error_log'
alias cwlg='echo "" > "/Users/patrik/VirtualBox VMs/Windows11/Logs/VBox.log"'
alias compile='./scripts/compile.sh'
alias run='./scripts/run.sh'
alias pack='./scripts/pack.sh'
alias clrbin='rm -rf ./bin/*'
alias clrbld='rm -rf ./build/*'

export PATH="/usr/local/mysql/bin:$PATH"
