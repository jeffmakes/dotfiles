set fish_function_path $fish_function_path "/usr/share/powerline/fish"
source /usr/share/powerline/fish/powerline-setup.fish
powerline-setup

function config
	command /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end

set --export PATH $HOME/.local/bin $HOME/bin /var/lib/snapd/snap/bin /opt/ti/msp430/gcc/bin $PATH

