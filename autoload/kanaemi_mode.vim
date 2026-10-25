function! kanaemi_mode#get_mode() abort
  return kanaemi_mode#connection#request({'op': 'get-mode'}).mode
endfunction

function! kanaemi_mode#set_mode(mode) abort
  if index(['kana', 'abc'], a:mode) < 0
    throw 'kanaemi_mode: mode is kana or abc'
  endif
  return kanaemi_mode#connection#request({'op': 'set-mode', 'mode': a:mode}).mode
endfunction

function! kanaemi_mode#watch_mode(callback) abort
  let id = kanaemi_mode#watcher#add(a:callback)
  try
    call kanaemi_mode#connection#watch()
  catch
    call s:unwatch(id)
    throw v:exception
  endtry
  return function('s:unwatch', [id])
endfunction

function! s:unwatch(id) abort
  if kanaemi_mode#watcher#remove(a:id)
    call kanaemi_mode#connection#unwatch()
  endif
endfunction
