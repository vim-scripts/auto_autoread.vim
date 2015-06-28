Automatically read files when they've changed. This does what 'autoread'
promises to do but doesn't do. This plugin requires `+python` or `+python3`.

This is different from the built-in `'autoread'` option in that it periodically
checks if the file on the disk has changed, which is _not_ what `'autoread'`
does. `'autoread'` only checks if the file is changed on when certain events
occur.

Use `:Autoread` to start checking, and `:AutoreadStop` to stop.

See `:help :Autoread` (or [the help file][help]) for more information.

[help]: http://code.arp242.net/auto_autoread.vim/raw/tip/doc/auto_autoread.txt
