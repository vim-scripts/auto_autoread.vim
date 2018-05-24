" Check whether python is supported
" Return -1 if python not found
function! s:UsingPython3()
  if has('python3')
    return 1
  elseif has('python')
    return 0
  endif
  return -1
endfunction


let s:using_python3 = s:UsingPython3()
let s:python_until_eof = s:using_python3 ? "python3 << EOF" : "python << EOF"
let s:pyfile_command = s:using_python3 ? "py3file " : "pyfile "
let s:curfile = expand("<sfile>")
let s:installdir = fnamemodify(s:curfile, ":h:h")


" Check whether environment is supported
"
"
" Check whether python is supported
" Currently force to use python, disable this if found alternative solution
if s:using_python3 == -1
    echo "Error: autoread.vim is required vim compiled with pythonx"
    finish
endif


" Initialize variables
scriptencoding utf-8
if exists('g:loaded_autoread_flag') | finish | endif
let g:loaded_autoread_flag = 1
let s:save_cpo = &cpo
set cpo&vim

" Enter log monitor mode
fun! autoread#Init()
  let b:autoread_cursorline=&cursorline
  let b:autoread_syntax=&syntax

  "let b:saved_buff = bufnr("%")
  set cursorline
  hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white
  set syntax=logtalk
endfun

func! autoread#Destory()
  "execute 'buffer ' . b:saved_buff
  "unlet b:saved_buff
  let &cursorline = b:autoread_cursorline
  let &syntax = b:autoread_syntax
  unlet b:autoread_cursorline
  unlet b:autoread_syntax
endfun


" Start Autoread, with a param to update the count of lines each time
fun! autoread#Start(...)
	if expand('%') == ''
		echohl ErrorMsg | echomsg 'E32: No file name' | echohl None
		return
	endif

	let b:autoread_line_count = ( a:0 > 0 && type( a:1 ) == type(0) ) ? a:1 : 10
	setlocal autoread

	if has('python') || has('python3')
		let b:autoread_method = 'python'
		call s:python()
	"elseif has('unix')
	"	let b:autoread_method = 'shell'
	"	call s:shell()
	else
		echoerr "Oops, autoread.vim doesn't seem supported on your platform."
	endif

  let b:autoread_interval = 1
  echom "autoread is started."
endfun

" Stop Autoread
fun! autoread#Stop()
  let b:autoread_interval = 0
  echom "autoread is stopped."
endfun

" Use Autoread command with default setting to toggle start/stop.
fun! autoread#Toggle(...)
  if exists('b:autoread_interval') && b:autoread_interval == 1
    let b:autoread_interval = 0
    call autoread#Destory()
    call autoread#Stop()
  else
    let b:autoread_interval = 1
    call autoread#Init()
    call call("autoread#Start", a:000) 
  endif
endfun


" Call python script and update file changes
fun! s:python()
  let s:pyfile = s:installdir . '/python/main.py'
  execute s:pyfile_command . s:pyfile
endfun


let &cpo = s:save_cpo
unlet s:save_cpo
