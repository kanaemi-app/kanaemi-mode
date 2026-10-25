" The callbacks given to kanaemi_mode#watch_mode(), and the mode last told to
" them, so each is called only when the mode changes.

let s:watchers = {}
let s:next = 0
" The mode last told, and whether one was learned since the last time
" nobody was watching.
let s:mode = v:null
let s:known = 0

function! kanaemi_mode#watcher#add(callback) abort
  let s:next += 1
  let s:watchers[s:next] = a:callback
  return s:next
endfunction

" Returns whether nobody is watching any more.
function! kanaemi_mode#watcher#remove(id) abort
  if has_key(s:watchers, a:id)
    call remove(s:watchers, a:id)
  endif
  return empty(s:watchers)
endfunction

" The mode when a connection started watching. The first is no change, but
" one after the connection came back may be.
function! kanaemi_mode#watcher#start(mode) abort
  if s:known
    call kanaemi_mode#watcher#tell(a:mode)
  else
    let s:mode = a:mode
    let s:known = 1
  endif
endfunction

" The connection ended. Watchers hear the mode is unknown; with nobody to
" hear it, the next watcher starts afresh.
function! kanaemi_mode#watcher#lost() abort
  if empty(s:watchers)
    let s:mode = v:null
    let s:known = 0
  else
    call kanaemi_mode#watcher#tell(v:null)
  endif
endfunction

function! kanaemi_mode#watcher#tell(mode) abort
  let s:known = 1
  if type(a:mode) == type(s:mode) && a:mode ==# s:mode
    return
  endif
  let s:mode = a:mode
  for Callback in values(s:watchers)
    try
      call call(Callback, [a:mode])
    catch
      echohl ErrorMsg
      echomsg printf('kanaemi_mode: a watcher failed: %s', v:exception)
      echohl None
    endtry
  endfor
endfunction
