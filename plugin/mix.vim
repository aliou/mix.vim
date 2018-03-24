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

" List the umbrella apps under the mix root.
function! s:umbrella_apps() abort
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

augroup mix
  autocmd!
  autocmd BufNewFile,BufReadPost *
        \ if empty(&filetype) |
        \   call s:Setup(expand('<amatch>:p')) |
        \ endif
  autocmd FileType * call s:Setup(expand('%:p'))
  autocmd User NERDTreeInit,NERDTreeNewRoot call s:Setup(b:NERDTreeRoot.path.str())
  autocmd VimEnter * if expand('<amatch>')==''|call s:Setup(getcwd())|endif
augroup END

" }}}1

" Projectionist {{{
let s:app_projections = {
      \   'config/*.exs': {
      \     'type': 'config',
      \     'template': [
      \       'use Mix.Config'
      \     ]
      \   },
      \   'config/config.exs': {
      \     'type': 'config',
      \     'template': [
      \       'use Mix.Config'
      \     ]
      \   },
      \   'lib/mix/tasks/*.ex': {
      \     'type': 'task',
      \     'template': [
      \       'defmodule Mix.Tasks.{camelcase|capitalize|dot} do',
      \       '  use Mix.Task',
      \       '',
      \       'end'
      \     ]
      \   },
      \   'lib/*.ex': {
      \     'type': 'lib',
      \     'alternate': 'test/{}_test.exs',
      \     'template': [
      \       'defmodule {camelcase|capitalize|dot} do',
      \       '',
      \       'end'
      \     ]
      \   },
      \   'test/test_helper.exs': {
      \     'type': 'test'
      \   },
      \   'test/*_test.exs': {
      \     'type': 'test',
      \     'alternate': 'lib/{}.ex',
      \     'template': [
      \       'defmodule {camelcase|capitalize|dot}Test do',
      \       '  use ExUnit.Case, async: true',
      \       '',
      \       'end'
      \     ]
      \   }
      \ }


let s:projections = extend({
      \   'mix.exs': {
      \     'type': 'mix',
      \     'alternate': 'mix.lock'
      \   },
      \   'mix.lock': {
      \     'alternate': 'mix.exs'
      \   },
      \   '*': {
      \     'make': 'mix compile',
      \     'dispatch': 'mix test',
      \     'console': 'iex -S mix'
      \   }
      \ }, s:app_projections)

let s:umbrella_global_projections = {
      \   'apps/*/mix.exs': {
      \     'type': 'mix',
      \     'alternate': 'apps/{}/mix.lock'
      \   },
      \   'apps/*/mix.lock': {
      \     'alternate': 'apps/{}/mix.exs'
      \   }
      \ }

function! s:ProjectionistDetect() abort
  call s:Detect(get(g:, 'projectionist_file', ''))
  if exists('b:mix_root')
    " Add default projections.
    let l:projections = deepcopy(s:projections)
    call projectionist#append(b:mix_root, l:projections)

    " Add "global" commands for umbrella apps.
    if !empty(s:umbrella_apps())
      call projectionist#append(b:mix_root, s:umbrella_global_projections)
    endif

    " For each app, generate "small" projections for the app.
    for l:app_name in s:umbrella_apps()
      let l:app_path = b:mix_root . '/apps/' . l:app_name
      call projectionist#append(l:app_path, s:app_projections)
    endfor
  endif
endfunction

augroup mix_projectionist
  autocmd!
  autocmd User ProjectionistDetect call s:ProjectionistDetect()
augroup END

" }}}
