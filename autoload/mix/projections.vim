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

function! mix#projections#setup() abort
  if !exists('b:mix_root')
    return
  endif

  " Add default projections.
  let l:projections = deepcopy(s:projections)
  call projectionist#append(b:mix_root, l:projections)

  " Add "global" commands for umbrella apps.
  let l:umbrella_apps = mix#umbrella_apps()
  if !empty(l:umbrella_apps)
    call projectionist#append(b:mix_root, s:umbrella_global_projections)
  endif

  " For each app, generate "small" projections for the app.
  for l:app_name in l:umbrella_apps
    let l:app_path = b:mix_root . '/apps/' . l:app_name
    call projectionist#append(l:app_path, s:app_projections)
  endfor
endfunction
