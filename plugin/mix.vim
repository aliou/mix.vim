" mix.vim - Like rake.vim but for mix.
" Location: plugin/mix.vim
" Author:   Aliou Diallo <code@aliou.me>
" Version:  0.2.0

if exists('g:loaded_mix') || &compatible || v:version < 700
  finish
endif

let g:loaded_mix = 1

" Initialization {{{1

" Find the root of the application.
" For now, the root is defined as the closest parent folder with a mix.exs file
" and that is not an umbrella app.
function! s:find_root(path) abort
  let l:root = simplify(fnamemodify(a:path, ':p:s?[\/]$??'))
  let l:previous = ''

  " Loop on the folder until you find the root folder.
  " The root folder is the one with the mix file.
  " TODO: Use `findfile` ?
  while l:root !=# l:previous && l:root !=# '/'
    let l:parent = fnamemodify(l:root, ':h:t')

    " Handle umbrella apps by manually checking if the proposed root directory
    " is in the `apps` directory.
    " TODO: Hmmm, make this better ?
    if filereadable(l:root . '/mix.exs') && l:parent !=# 'apps'
      return l:root
    endif
    let l:previous = l:root
    let l:root = fnamemodify(l:root, ':h')
  endwhile
endfunction

function! s:Detect(path) abort
  if !exists('b:mix_root')
    let l:dir = s:find_root(a:path)
    if l:dir !=# ''
      let b:mix_root = l:dir
    endif
  endif
endfunction

function! s:Setup(path) abort
  call s:Detect(a:path)
  if exists('b:mix_root')
    " Send the Mix autocommand to add the Mix command.
    silent doautocmd User Mix
  endif
endfunction

" }}}1

" Projectionist {{{

function! s:ProjectionistDetect() abort
  call s:Setup(get(g:, 'projectionist_file', ''))
  if exists('b:mix_root')
    call mix#projections#setup()
  endif
endfunction

function! s:define_mix_cmd() abort
  command! -buffer -bar -bang -nargs=? -complete=customlist,mix#cmd#tasks Mix
        \ call mix#cmd#run('<bang>', <q-args>)
endfunction

augroup mix_projectionist
  autocmd!
  autocmd User ProjectionistDetect call s:ProjectionistDetect()
  autocmd User Mix call s:define_mix_cmd()
augroup END

" }}}
