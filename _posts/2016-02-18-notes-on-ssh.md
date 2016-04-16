---
layout: post
category: [tools]
tags: [ssh, error code]
infotext: 'notes on using ssh, make life easier with remote access'
---
{% include JB/setup %}

## scp and ssh

When we need to login a remote machine via `ssh`, we will do something like

{% highlight shell linenos=table %}
ssh <user>@<host> [-p<port>]
{% endhighlight %}
    
where `<port>` is required if the remote machine's `ssh` listens on non-default 
port number `22`, and then type `<password>` in the prompt.

And sometimes you may need to transfer files between remote machines and local 
machine, you will do

{% highlight shell linenos=table %}
scp [-P<port>] [-r] <user>@<host>:<path-to-copy> <local-path-to-save>
scp [-P<port>] [-r] <local-path-to-copy> <user>@<host>:<path-to-save>
{% endhighlight %}

where `-r` flag is needed if you are going to copy a directory, and then 
type `<password>` in the prompt.

In order to not to type `<password>` every time you start a ssh connection, we can 
use ssh keys. First, generate the ssh key in a local path, like

{% highlight shell linenos=table %}
ssh-keygen -t rsa -b 4096 -N <passphrase> -C <comment> -f <keyfile>
{% endhighlight %}

where `-t` flag is for key type, such as `rsa`, `dsa`, etc, and `-b` flag is for key 
bit length, such as `2048`, `4096`, etc, and `-C` flag is for `<comment>`, can be viewed 
as an identity of the keyfile, and `-f` is for `<keyfile>` whose default value 
is like `id_rsa` and generate a file in path `~/.ssh/id_rsa` with a public key file in path
`~/.ssh/id_rsa.pub`. And in this case, we will omit `<passphrase>`.
 
If we generate the keyfile with no passphrase and with default path, and copy the content 
of `~/.ssh/<keyfile>.pub` into the `~/.ssh/authorized_keys` manually or via

{% highlight shell linenos=table %}
# ??? if no specific configuration, following command only works
#     when <path-to-keyfile> is default value
ssh-copy-id <user>@<host> -p<port>
{% endhighlight %}

And now, we can access remote machine without typing `<password>`.

What if I want to use different sshkey with different remote machine?

What if `<host>` of remote machine is hard to remember (like ip addresses) or 
to type (to long to type)?

What if `<post>` of remote machine is hard to remember?

To make life easier, we can make some configurations of `ssh`.

Create a configuration file `config` in `~/.ssh`, with something like

{% highlight conf linenos=table %}
Host                <easy-to-remember-host-name>
    HostName        <host>
    IdentityFile    ~/.ssh/<keyfile>
    User            <user>
    Port            <port>
    *LocalForward    <local port>    <remote host>:<remote port>
    *RemoteForward   <remote port>   <local host>:<local port>
Host                <another easy-to-remember-host-name>
    HostName        <another host>
    IdentityFile    ~/.ssh/<another keyfile>
    User            <another user>
{% endhighlight %}

Then,

{% highlight shell linenos=table %}
ssh <easy-to-remember-host-name>
{% endhighlight %}

is equivalent to

{% highlight shell linenos=table %}
ssh <user>@<host> -p<port>
{% endhighlight %}

And,

{% highlight shell linenos=table %}
ssh <another easy-to-remember-host-name>
{% endhighlight %}

is equivalent to

{% highlight shell linenos=table %}
ssh <another user>@<another host>
{% endhighlight %}

Note that, you can also specify `Local Forward` and `Remote Forward` in the `config` file. And 
in order to avoid allocating a `tty` when forwarding, `-nNT` is useful.

Besides that we can assign other `option`s to both `scp` and `ssh` via `-o` flag. When the first try 
to connect to a remote end takes place, the message asking for something like remembering new key 
will prompt. We can use `-o "StrictHostKeyChecking no"` to avoid prompting of the message.

## pscp and pssh

Sometimes you will need to transfer the same files with multiple remote ends or take the same actions 
on multiple remote ends, repeatedly doing the same work with different hosts is quite cumbersome. Use 
`pscp` and `pssh` will save much efforts.

{% highlight shell linenos=table %}
pscp -h <hosts> -l <user> -O <ssh options> <local-path-to-copy> <remote-path-to-save>
{% endhighlight %}

The above line shows how to use `pscp` to transfer local file to multiple remote ends, where `<hosts>` 
points to the file containing a list of remote hosts, `-l` is an option to set login user whose default 
value is `root`, and `-O` flag corresponds to `-o` of command `scp`.

Similarly, usage of `pssh` is as follows:

{% highlight shell linenos=table %}
pssh -h <hosts> -l <user> -O <ssh options> <command>
{% endhighlight %}

When you try to login in remote ends for the first time, by default you will be asked to confirm new 
host key and with `pscp` and `pssh` you have no chance to confirm it which will finally result in 
failure. At this point, `-O` flag is very useful, so that you can use `-O "StrictHostKeyChecking no"` to login 
remote ends successfully.

When using `pssh` you may also meet with following error code caused by wrong `<command>`:

| exit code number | meaning | comment |
| 1 | catchall for general errors | miscellaneous errors |
| 2 | misuse of shell builtins | missing keyword or command or permission problems |
| 126 | command invoked cannot execute | permission problem or command is not an executable |
| 127 | command not found | command not found |
| 128 | invalid arugment to exit | exit only takes integer arguments in the range 0 ~ 255 |
| 128 + n | fatal error signal n | |
| 130 | script terminated by `Ctrl + C` | `Ctrl + C` is fatal error signal 2 |
| 255* | exit status out of range | exit takes only integer arguments in the range 0 ~ 255 |

## change user

If you want to execute some commands on remote end with some other user account other than the 
login account, then you will need to change user via `su` command as following:

{% highlight shell linenos=table %}
ssh <user>@<host> -p <port> -o <ssh options> "su - <another user> -c \"<command>\""
{% endhighlight %}