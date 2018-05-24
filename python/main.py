#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time, vim
import signal
try: import thread
except ImportError: import _thread as thread # Py3

def signal_handler(signal, frame):
    global interrupted
    interrupted = True

signal.signal(signal.SIGINT, signal_handler)
interrupted = False
buf = vim.current.buffer.number

def autoread_loop():
	buf = vim.current.buffer.number
	while True:
		if interrupted:
			thread.exit()
			break
		zzz = vim.buffers[buf].vars['autoread_interval']
		if zzz == 0:
			thread.exit()
		time.sleep(1)
		autoread()

def autoread():
	vim.command('checktime')
	vim.command('redraw')
	
	try:
		refresh_line_count = vim.buffers[buf].vars['autoread_line_count']
		# scroll down count of lines for each refresh	
		vim.command('+%d' % refresh_line_count)
	except Exception as e:
		print("cannot refresh lines: " + refresh_line_count + str(e))


if __name__ == '__main__':
    thread.start_new_thread(autoread_loop, ())
