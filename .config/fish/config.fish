set fish_function_path $fish_function_path "/usr/share/powerline/fish"
source /usr/share/powerline/fish/powerline-setup.fish
powerline-setup

function config
	command /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end

set --export PATH $HOME/.local/bin $HOME/bin /var/lib/snapd/snap/bin /opt/ti/msp430/gcc/bin $PATH
set --export PYTHONPATH /usr/lib64/kicad-nightly/lib64/python3.10/site-packages $PYTHONPATH
set --export LD_LIBRARY_PATH /usr/lib64/kicad-nightly/lib64 $LD_LIBRARY_PATH
set --export EDITOR nvim
set --export DO_NOT_TRACK 1

alias ding='aplay ~/tools/soft/win95-sounds/DING.WAV >/dev/null 2>&1'
alias tada='aplay ~/tools/soft/win95-sounds/TADA.WAV >/dev/null 2>&1'
