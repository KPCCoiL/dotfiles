switch (uname)
case Darwin
  set -gx CAML_LD_LIBRARY_PATH "/Users/akifumi/.opam/system/lib/stublibs:/usr/local/lib/ocaml/stublibs";
  set -gx OPAMUTF8MSGS "1";
  set -gx MANPATH "/Users/akifumi/.opam/system/man" "";
  set -gx PERL5LIB "/Users/akifumi/.opam/system/lib/perl5";
  set -gx OCAML_TOPLEVEL_PATH "/Users/akifumi/.opam/system/lib/toplevel";
  set -x LSCOLORS "gxfxcxdxbxegedabagacad"
  source ~/.iterm2_shell_integration.fish
end

alias eit=exit
alias :q=exit
alias awk=gawk

fish_vi_key_bindings
bind -M insert \cl "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
bind -M visual \cl "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"

function fish_right_prompt
  set_color green
  printf '%s' (prompt_pwd)
  set_color normal
end

function fish_prompt
end

function fish_mode_prompt
  switch $fish_bind_mode
  case default
    set_color --bold bryellow
    printf '⟂'
  case insert
    set_color --bold brcyan
    printf '⁁'
  case visual
    set_color  brred
    printf '◉'
  case replace_one
    set_color --bold brgreen
    printf '⟲'
  case paste
    set_color brblack
    printf '⬇'
end
printf ' ∞ '
set_color normal
end

thefuck --alias | source