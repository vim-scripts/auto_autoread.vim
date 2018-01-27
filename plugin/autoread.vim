"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check whether python is supported
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('python') && !has('python3')
    echo "Error: autoread.vim is required vim compiled with pythonx"
    finish
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialize variables
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf-8
if exists('g:loaded_auto_autoread') | finish | endif
let g:loaded_auto_autoread = 1
let s:save_cpo = &cpo
set cpo&vim


"##########################################################
" Commands
command! -nargs=* Autoread     call s:start(<args>)
command!          AutoreadStop let b:auto_autoread = 0


"##########################################################
" Functions
fun! s:start(...)
	if expand('%') == ''
		echohl ErrorMsg | echomsg 'E32: No file name' | echohl None
		return
	endif

	let b:auto_autoread = a:0 > 0 ? a:1 : 1
	setlocal autoread

	"if has('python') || has('python3')
		"let b:auto_autoread_method = 'python'
	"	call s:python()
	if has('python')
  		command! -nargs=* Py python <args>
  		call s:python()
	elseif has('python3')
  		command! -nargs=* Py python3 <args>
  		call s:python()
	"elseif has('unix')
	"	let b:auto_autoread_method = 'shell'
	"	call s:shell()
	else
		echoerr "Sorry, autoread.vim doesn't seem supported on your platform."
	endif
endfun


" Poll the file every n seconds.
" Note this is not very fast; we want to use gamin or some such, and this only
" method only as a fallback...
fun! s:python()
Py << EOF
import time, vim
try: import thread
except ImportError: import _thread as thread # Py3

def autoread():
	vim.command('checktime')
	vim.command('redraw')

def autoread_loop():
	buf = vim.current.buffer.number
	while True:
		zzz = vim.buffers[buf].vars['auto_autoread']
		if zzz == 0:
			thread.exit()
		time.sleep(zzz)
		autoread()

thread.start_new_thread(autoread_loop, ())
EOF
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
"	" TODO: Modifying the b:auto_autoread has no effect
"	call system('while :; do sleep ' . b:auto_autoread . '; ' . l:cmd . '; done &')  " Note the & at the end
"	let &shell = l:oldshell
"endfun

let &cpo = s:save_cpo
unlet s:save_cpo
