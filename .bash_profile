# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/.local/bin:$HOME/bin:$HOME/exec:$HOME/.atom/packages/platformio-ide/penv/bin/:$PATH
KSDK_PATH=/home/jeff/store/installs/eda/freescale/KSDK_1.1.0
export PATH
export KSDK_PATH

