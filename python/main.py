#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time, vim
try: import thread
except ImportError: import _thread as thread # Py3

# Poll the file every n seconds.
# Note this is not very fast; we want to use gamin or some such, and this only
#  method only as a fallback...
def autoread():
	vim.command('checktime')
	vim.command('redraw')
	# scroll down 10 lines for each refresh
	vim.command('+10')

def autoread_loop():
	buf = vim.current.buffer.number
	while True:
		zzz = vim.buffers[buf].vars['autoread_flag']
		if zzz == 0:
			thread.exit()
		time.sleep(zzz)
		autoread()

if __name__ == '__main__':
    thread.start_new_thread(autoread_loop, ())
