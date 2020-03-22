set fish_function_path $fish_function_path "/usr/share/powerline/fish"
source /usr/share/powerline/fish/powerline-setup.fish
powerline-setup

function config
	command /usr/bin/git --git-dir=/home/jeff/.cfg/ --work-tree=/home/jeff $argv
end

set --export PATH $HOME/.local/bin $HOME/bin $PATH

