"##########################################################
" Initialize some stuff
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

	let b:auto_autoread = a:0 > 0 ? a:1 : 5
	setlocal autoread

	if has('python') || has('python3')
		"let b:auto_autoread_method = 'python'
		call s:python()
	"elseif has('unix')
	"	let b:auto_autoread_method = 'shell'
	"	call s:shell()
	else
		echoerr "Sorry, but auto_autoread doesn't seem supported on your platform (yet)."
	endif
endfun

" Poll the file every n seconds.
" Note this is not very fast; we want to use gamin or some such, and this only
" method only as a fallback...
fun! s:python()
python << EOF
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


" The MIT License (MIT)
"
" Copyright © 2015 Martin Tournoij
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" The software is provided "as is", without warranty of any kind, express or
" implied, including but not limited to the warranties of merchantability,
" fitness for a particular purpose and noninfringement. In no event shall the
" authors or copyright holders be liable for any claim, damages or other
" liability, whether in an action of contract, tort or otherwise, arising
" from, out of or in connection with the software or the use or other dealings
" in the software.
