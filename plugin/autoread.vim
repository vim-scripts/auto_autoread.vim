" Default configuration


" Commands
command! -nargs=* AutoreadStart     call autoread#Start(<args>)
command!          AutoreadStop 		call autoread#Stop()
command!          Autoread 			call autoread#Toggle()
