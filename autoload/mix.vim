" Location: autoload/mix.vim
" Author:   Aliou Diallo <code@aliou.me>

if exists('g:autoloaded_mix')
  finish
endif
let g:autoloaded_mix = 1

function! mix#detect(...) abort
  if exists('b:mix_root')
    return 1
  endif

  let fn = fnamemodify(a:0 ? a:1 : expand('%'), ':p')
  if fn =~# ':[\/]\{2\}'
    return 0
  endif

  if !isdirectory(fn)
    let fn = fnamemodify(fn, ':h')
  endif

  let file = findfile('mix.exs', escape(fn, ', ').';')

  if !empty(file)
    let b:mix_root = fnamemodify(file, ':p:h')
  endif
endfunction

function! mix#setup_projections() abort
  if exists('b:mix_root')
    call projectionist#append(b:mix_root, mix#projections())
  endif
endfunction

function! mix#projections() abort
  return {
        \   "config/*.exs": {
        \     "type": "config"
        \   },
        \   "config/config.exs": {
        \     "type": "config"
        \   },
        \   "lib/*.ex": {
        \     "type": "lib",
        \     "alternate": "test/{}_test.exs"
        \   },
        \   "mix.exs": {
        \     "type": "lib"
        \   },
        \   "test/*_test.exs": {
        \     "type": "test",
        \     "alternate": "lib/{}.ex"
        \   }
        \ }
endfunction
