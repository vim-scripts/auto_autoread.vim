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
  set cursorline
  hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
  set syntax=logtalk
endfun


" Start Autoread
fun! autoread#Start(...)
	if expand('%') == ''
		echohl ErrorMsg | echomsg 'E32: No file name' | echohl None
		return
	endif

	let b:autoread_flag = a:0 > 0 ? a:1 : 1
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

  echom "autoread is started."
  let b:autoread_flag = 1
  call autoread#Init()
endfun

fun! autoread#Stop()
  let b:autoread_flag = 0
  echom "autoread is stopped."
endfun

" Use Autoread command with default setting to toggle start/stop.
fun! autoread#Toggle()
  if exists('b:autoread_flag') && b:autoread_flag == 1
    let b:autoread_flag = 0
    call autoread#Stop()
  else
    let b:autoread_flag = 1
    call autoread#Start()
  endif
endfun


" Call python script and update file changes
fun! s:python()
  let s:pyfile = s:installdir . '/python/main.py'
  execute s:pyfile_command . s:pyfile
endfun



" This is too dysfunctional...
"fun! s:shell()
"	if v:servername ==# ''
"		echoerr 'v:servername is empty; we need a servername for this.'
"	endif
"
"	let l:oldshell = &shell " For maximum compatibility (fish/csh users)
"	let &shell = '/bin/sh'
"	let l:cmd = 'vim --servername ' . v:servername . 
"		\ ' --remote-send "<C-\><C-n>:checktime<CR>" --remote-send "<C-\><C-n>:redraw<CR>"'
"
"	" TODO: This doesn't get killed if we quit Vim
"	" TODO: This also makes us exit insert mode
"	" TODO: Modifying the b:autoread_flag has no effect
"	call system('while :; do sleep ' . b:autoread_flag . '; ' . l:cmd . '; done &')  " Note the & at the end
"	let &shell = l:oldshell
"endfun

let &cpo = s:save_cpo
unlet s:save_cpo
