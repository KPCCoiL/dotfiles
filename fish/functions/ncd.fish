function ncd
  set next (ls -a | peco --prompt 'cd to > ' --on-cancel error)
  if test $status = 0
    cd $next
    ncd
  end
end
