---
layout: post
category: [linux]
tags: [linux, installation]
infotext: 'Short guide for basic installation and configuration of linux os'
---
{% include JB/setup %}

For some unfathomable reason, I have to use laptop with OS Win8. Everything breaks and life becomes even harder. I have
to use a virtual OS over Win8 on very restricted hardware as 4G RAM in total and low-voltage CPU. I tried to install
Ubuntu 14.10 but it seems requiring too much. So I choose to install Debian or Arch instead.

<!-- more -->

## Debian Linux

Although it is not declared as light-weight, I've heard Debian for a long time and decide to have a try. Because of the
hardware not competent to run gnome3, I just install the basic Debian system first, and install xfce4 later.

In order to have easy authorization management, let's first install `sudo`:

{% highlight console %}
apt-get install sudo
{% endhighlight %}

And then make our own account as `sudoer` by adding it into the `sudo group`:

{% highlight console %}
usermod -a -G sudo your_account
{% endhighlight %}

In order to show Chinese fonts:

{% highlight console %}
sudo apt-get install ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy
{% endhighlight %}

And now, we can install the x window xfce4:

{% highlight console %}
sudo apt-get install x-window-system
sudo apt-get install xfce4
# installing the theme
# sudo apt-get install xfce4-theme

# installing desktop manager
# sudo apt-get install xdm
{% endhighlight %}

And you can start X with:

{% highlight console %}
startx
{% endhighlight %}

Now, you can use the x-window. Sometimes, you need to install software from the testing environment or unstable
environment. In that case, you may need to edit the **/etc/apt/sources.list** file or add a new file with the
".list" extension to **/etc/apt/sources.list.d/**. Following is an example to add the backports to the
**sources.list** file in Debian 7:

{% highlight console %}
deb http://http.debian.net/debian wheezy-backports main
# deb mirror.url/debian testing main
# deb mirror.url/debian unstable main
{% endhighlight %}

From [http://backports.debian.org/Mirrors](http://backports.debian.org/Mirrors){:target="_blank"}. All
backports are deactivated by default, to install something from it:

{% highlight console %}
apt-get -t wheezy-backports install "package"
aptitude -t wheezy-backports install "package"
{% endhighlight %}

So far, it's the very basic using guide and configuration for Debian.

## Arch Linux

Coming soon...