export NNN_COLORS=#a2a2a2a2
LOCAL_BASH_PROFILE="$HOME/.bash_profile_$(cat ~/.machine-name)"
[[ -f "$LOCAL_BASH_PROFILE" ]] && . "$LOCAL_BASH_PROFILE"
[[ -f ~/.bashrc ]] && . ~/.bashrc
