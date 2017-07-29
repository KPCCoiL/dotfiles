# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
case ${OSTYPE} in
	darwin*)
        export PATH="/Users/akifumi/.local/bin:/Users/akifumi/.cabal/bin:/Users/akifumi/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/texlive/2015/bin/x86_64-darwin:/Users/akifumi/.vim/bundle/neobundle.vim/bin:/Users/akifumi/Documents/programs/Haskell/bins/.cabal-sandbox/bin:/Users/akifumi/.opam/system/bin"
		export XMODIFIERS="@im=anthy"
		export GTK_IM_MODULE="anthy"
        export GOPATH='/Users/akifumi/.go'
		alias ql='qlmanage -p "$@" >& /dev/null'
		alias gvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim  -g "$@"'
		alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
		alias nicodl='ruby ~/Documents/programs/ruby/nicodl.rb'
		alias trash='mv "$@" ~/.Trash/'
		alias ls="ls -G"
		export CPLUS_INCLUDE_PATH=/usr/local/Cellar/boost/1.55.0/include:${HOME}/Documents/Sprout
		zstyle ':completion:*' list-colors 'di=36:ln=31:so=35:pi=33:ex=32:bd=34:cd=34' ${(s.:.)LS_COLORS}
		export LSCOLORS=gxbxfxdxcxegedabagacad
		export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
		# --------------------------------------
		# Google search from terminal
		# --------------------------------------
		google(){
			if [ $(echo $1 | egrep "^-[cfs]$") ]; then
				local opt="$1"
				shift
			fi
			local url="https://www.google.co.jp/search?q=${*// /+}"
			local app="/Applications"
			local c="${app}/Chromium.app"
			local s="${app}/Safari.app"
			case ${opt} in
				"-c")   open "${url}" -a "$c";;
				"-s")   open "${url}" -a "$s";;
				"-w")	w3m "${url}";;
				*)      open "${url}";;
			esac
		}
		;;
	linux*)
		export PATH=${HOME}/.cabal/bin:${HOME}/.gem/ruby/2.1.0/bin:$PATH
		#ibus-daemon -drx
		alias chromium_tether='chromium --proxy-server="socks5://10.0.0.10:8888"'
		alias vi='vim'
		export LSCOLORS=gxbxfxdxcxegedabagacad
		export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
		alias -g C='|xsel --input --clipboard'
		alias tetherset='sudo ifconfig wlp2s0 10.0.0.1 netmask 255.255.255.0'
		alias tetherstart='sudo hostapd /etc/hostapd/hostapd.conf'
		alias ls='ls --color=auto'
		export CPLUS_INCLUDE_PATH=/usr/include
		;;
esac
alias goprog='cd ~/Documents/programs/'
alias eit='exit'
alias :q='exit'
alias exity='exit'
alias -g awk='gawk'
alias la='ls -A'
alias ll='ls -la'

PROMPT="%n:%. > "
RPROMPT="%{$fg[cyan]%}--INSERT--%{$reset_color%}"
bindkey -v

autoload -U compinit
compinit
setopt correct
zstyle ':completion:*' list-colors 'di=36:ln=31:so=35:pi=33:ex=32:bd=34:cd=34' ${(s.:.)LS_COLORS}
export LSCOLORS=gxbxfxdxcxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
setopt auto_cd
setopt nolistbeep
setopt auto_pushd
setopt list_packed

#commands
#--------------------------------------
#run c++ program
#--------------------------------------
runcpp(){
	local path="${*// /+}"
	g++ ${path} -std=c++11 -o ${path}.out
	./${path}.out
}
alias reload='source ~/.zshrc'

function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
    RPROMPT="%{$fg[green]%}--NORMAL--%{$reset_color%}"
    ;;
    main|viins)
    RPROMPT="%{$fg[cyan]%}--INSERT--%{$reset_color%}"
    ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

export FPATH="$FPATH:/opt/local/share/zsh/site-functions/"
if [ -f /opt/local/etc/profile.d/autojump.zsh ]; then
    . /opt/local/etc/profile.d/autojump.zsh
fi
