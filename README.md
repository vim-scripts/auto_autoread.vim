# autoread.vim
Enchanced autoread command, automatically reads file when it has been modified. 

## Requirements
This plugin requires `+python` or `+python3`.

This is different from the built-in `'autoread'` option in that it periodically
checks if the file on the disk has changed, which is _not_ what `'autoread'`
does. `'autoread'` only checks if the file is changed on when certain events
occur.

## Usage
Use `:AutoreadStart` to start checking, and `:AutoreadStop` to stop.
Or use `Autoread` to toggle start/stop mode.

See `:help :Autoread` (or [the help file][help]) for more information.

[help]: http://code.arp242.net/auto_autoread.vim/raw/tip/doc/auto_autoread.txt
