" List the umbrella apps under the mix root.
function! mix#umbrella_apps() abort
  if !exists('b:mix_root')
    return []
  endif

  let l:app_path = b:mix_root . '/apps'

  " XXX: why does `!isdirectory(l:app_path)` does not work?
  if isdirectory(l:app_path) == v:false
    return []
  endif

  " TODO: Will this work on windows ?
  let l:app_directories = split(globpath(b:mix_root . '/apps', '*'), '\n')
  let l:apps = map(l:app_directories, "fnamemodify(v:val, ':t')")

  return l:apps
endfunction
