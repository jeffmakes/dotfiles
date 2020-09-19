# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
#. ~/bin/cdp.sh
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias texttopdf='unoconv'

