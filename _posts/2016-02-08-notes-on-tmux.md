---
layout: post
category: [tools]
tags: [tmux]
infotext: 'notes on using tmux'
---
{% include JB/setup %}

`tmux` is a `t`erminal `mu`ltiple`x`r. As most (I mean all) people around me use `vim`, and I failed to install `awesome wm` (dependency issues, manully compiling `xcb` simply crashes my x11 env) and I didn't want to try to exchange `Caps` with `Ctrl` for the virtual machine, I decide to use `tmux` with `vim`, where `tmux` for tiling windows mangement.

Following is the configuration and explanations:

Usually commands of `tmux` is leaded by a `PREFIX` so as to reduce conflicts with other applications. Reduce means there still exists many conflicts, so rebind default `PREFIX` `C-b` with the other key:

    # bind PREFIX with 'C-\'
    set -g prefix 'C-\'
    
    # unbind default one
    unbind C-b

The `set` is a short version of `set-option`. The `-g` flag denotes that this configuration is global, it takes effect for all sessions.

There are sessions, windows and panes in `tmux`. For each session, it contains many windows, which is like tabs. For each window, it contains many panes, where panes work like tiling windows.

Let's first make above configuration effect. To enter the command mode, press `PREFIX` `:`, then type `source-file <path to config file>`. Or we make following config to easy it:

    bind r source-file <path to config file> \; display "Reloaded"

The `bind` is short for `bind-key`.

### Sessions

Create sessions:

    tmux # create annonymous session
    tmux new-session -s <s-name> # create named session
    tmux new -s <s-name> # create named session
    tmux new [-s <s-name>] -d # create a session and then detach

Detach and Attach sessions:

To detach the current session, use command `PREFIX` `d`.

To attach a session:

    # list existing sessions
    tmux list-sessions | ls
    
    # if there is only one session
    tmux attach # attach the session
    
    # attach a particular session
    tmux attach -t <s-name>

    e enable utf-8 on status bar
    set -g status on
    set -g status-utf8 on

To rename a session:

    tmux rename-session -t <s-name> <n-s-name>

To kill a session:

    tmux kill-session -t <s-name>

### Windows

To create a window in current session, use `PREFIX` `c`.

    # create a named session with a named window
    tmux -new -s <s-name> -n <w-name>

To rename current window, use `PREFIX` `,`, or use:

    tmux rename-window -t <w-id>|<w-name> <n-w-name>

Movement between windows:

- Press `PREFIX` `n` for moving to next window.
- Press `PREFIX` `p` for moving to previous window.
- Press `PREFIX` `f` to find a window by its name
- Press `PREFIX` `w` to show a visual menu to select window
- Press `PREFIX` `<num>` for moving to \<num>-th window.

By default, windows and panes are indexed based on 0, following configuration make it to 1:

    set -g base-index 1
    setw -g pane-base 1
    
    # and also enable the renumbering function
    set -g renumber-windows on

To close a window, type `exit` into the prompt of the window, or press `PREFIX` `&` to confirm and exit the current window, or press `Ctrl-d` to send the `EOF`, or type `kill-window [-t <w-name> | -a]` in the prompt to kill the current or particular or all window(s).

To move window between different sessions:

    tmux move-window -s <s-name>:<w-name> -t <t-s-name>

To share window between different sessions, type `link-window -t <t-s-name>:<t-w-name>` in the prompt.

### Panes

To split the window vertically, press `PREFIX` `%`. And to split the window horizantually, press `PREFIX` `"`.

    # set new split key combination
    bind \ split-window -h
    bind - split-window -v

To focus the panes cyclically, press `PREFIX` `o`. `PREFIX` with `UP`, `DOWN`, `LEFT`, and `RIGHT` is to move to the pane in certain direction.

    # use C-h and C-l to cycle through panes
    bind -r C-h select-window -t :-
    bind -r C-l select-window -t :+

    # map vi-like movement
    bind -r h select-pane -L
    bind -r j select-pane -D
    bind -r k select-pane -U
    bind -r l select-pane -R

The `-r` flat is to denote that this key can take effect repeatedly with first `PREFIX`.

To move directly to a specific pane, press `PREFIX` `q` then press proper number.

To resize the pane:

    # resize pane
    bind H resize-pane -L 5
    bind J resize-pane -D 5
    bind K resize-pane -U 5
    bind L resize-pane -R 5

To max the pane, press `PREFIX` `z`.

To rotate the panes, press `PREFIX` `}` to rotate clockwise, and press `PREFIX` `{` to rotate counterclockwise.

To change the pane layout, press `PREFIX` `Space`.

To close the current pane, type `exit` or press `PREIFX` `x`.

To synchronize the pane input or not, type `setw synchronize-panes [on|off]` in the prompt.

### Transfer between Window and Pane

To break the pane into a seperate window, press `PREFIX` `!`.

To convert a window into a pane in another window, type `join-pane -s <source-window> -t <target-window>` in the prompt. (It looks like only the single pane window work???)

### Buffer

That presented in `tmux` is actually the viewport, farmed off to stdout.

To scroll buffer, we need first enter the `copy mode`. Either type `copy-mode` to the prompt (following pressing `PREFIX` `:`), or press `PREFIX` `[` will send us to the `copy mode`.

Once enter the `copy mode`, move as in `vim`.

### Copy and Paste

First, we need enter the `copy mode`.

To begin making a selection, press `Space`.

To make the selection in paste buffer, press `Enter`.

To show paste buffer, press `PREFIX` `#` or type `list-buffers` in prompt.

To copy current buffer entirely, type `capture-pane` in prompt.

To show the last copied buffer, type `show-buffer` in prompt.

To paste the last copied buffer into the current buffer, press `PREFIX` `]` or type `paste-buffer` in prompt.

To save the last copied buffer to a file, type `save-buffer <path to file>` in prompt.

To paste specific copied buffer to the current buffer, press `PREFIX` `=` or type `choose-buffer` in promt and then select one by its id number.

To paste between programs, `xclip` is required. And add following into the configuration (not tested yet):

    bind -t vi-copy 'v' begin-selection
    bind -t vi-copy 'y' copy-pipe 'xclip'

Other configurations:

    # enable utf-8 on status bar
    set -g status on
    set -g status-utf8 on

    # set Zsh as default tmux shell
    set -g default-shell /bin/zsh

    # set history limit to 30000
    set -g history-limit 30000

    # use utf8
    set -g utf8
    setw -g utf8 on

    # use 256 color
    set -g default-terminal "screen-256color"

    # short command delay
    set -sg escape-time 1

    # long display time
    set -g display-time 2000

    # make the current window the first wiindow
    bind T swap-window -t 1

    # automatically rename window
    setw -g automatic-rename on

    # enable mouse
    set -g mouse on

    # set command prompt vi-like
    set -g status-key vi
