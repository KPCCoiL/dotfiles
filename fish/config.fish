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

fish_config prompt choose arrow
fish_default_key_bindings

if set -q INSIDE_EMACS
   source $EMACS_VTERM_PATH/etc/emacs-vterm.fish
end

thefuck --alias | source