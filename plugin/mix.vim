" mix.vim - Like rake.vim but for mix.
" Location: plugin/mix.vim
" Author:   Aliou Diallo <code@aliou.me>
" Version:  0.0.1

if exists('g:loaded_mix') || &cp || v:version < 700
  finish
endif

let g:loaded_mix = 1

augroup mix_plugin_detect
  autocmd!

  autocmd VimEnter * call mix#detect(getcwd())
  autocmd FileType * call mix#detect()
augroup END

augroup mix_projections
  autocmd!

  autocmd User ProjectionistDetect call mix#setup_projections()
augroup END
