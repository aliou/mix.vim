function! s:task_list() abort
  return split(system('mix help --names'), "\n")
endfunction

function! mix#cmd#tasks(argument_lead, cmd_line, cursor_position) abort
  return projectionist#completion_filter(s:task_list(), a:argument_lead, '.')
endfunction

" TODO: Dispatch, makeprg, compiler, etc
function! mix#cmd#run(bang, argument)
  execute 'make' . a:bang . ' ' . a:argument
  " execute '!mix ' . a:argument
endfunction
