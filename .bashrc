bind 'TAB:menu-complete'
bind '"\e[Z": menu-complete-backward'
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
bind -s 'set completion-ignore-case on'
alias ls='ls --color=auto'
alias l='ls -la'
alias la='ls -a'
alias ll='ls -la'

set_bash_prompt () {
    local last_status="$?"
    if [[ $last_status -eq 0 ]]; then
        local status="\[\e[1;32m\]"
    else
        local status="\[\e[1;31m\]$last_status "
    fi
    PS1="${status}→ \[\e[1;36m\]\W \[\e[0m\]"
}

export PROMPT_COMMAND=set_bash_prompt
export LSCOLORS=gxfxcxdxbxegedabagacad

command -v thefuck > /dev/null && eval "$(thefuck --alias)"

n () {
    # Block nesting of nnn in subshells
    if [[ "${NNNLVL:-0}" -ge 1 ]]; then
        echo "nnn is already running"
        return
    fi

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The backslash allows one to alias n to nnn if desired without making an
    # infinitely recursive alias
    \nnn -A "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

LOCAL_BASHRC="$HOME/.bashrc_$(cat ~/.machine-name)"
[[ -f "$LOCAL_BASHRC" ]] && . "$LOCAL_BASHRC"
