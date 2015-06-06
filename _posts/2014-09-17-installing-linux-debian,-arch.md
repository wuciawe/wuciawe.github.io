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

So far, I setup dual boot of win7 and Arch Linux on another laptop. I think Arch is really great with its `pacman` and 
its `wiki`.

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

In this part, I will show the way I followed to setup the dual booting of win7 and Arch Linux, with laptop already installed 
the Win7.

First of all, I shrink the disk space occupied by win7 and use `GParted` to reformat the remaining disk space for Arch Linux. 
And I only created one ex4 for `/`, one swap and one vfat for sharing files between win7 and arch.

Then, boot up from the installation media, and choose **Boot Arch Linux**.

After booting, check the internet connection with

{% highlight console %}
ping -c 3 www.google.com
{% endhighlight %}

If it fails with `Network is unreachable`, try following:

{% highlight console %}
ip link
dhcpcd ???{current device name}
{% endhighlight %}

Then we will create the disk partitions ( Since I have already created disk partitions with GParted, this step is no longer necessary here. ):

{% highlight console %}
fdisk -l # list the drivers and partitions
cgdisk /dev/sda # create partitions on /dev/sda
cfdisk /dev/sda # another tool for partition
{% endhighlight %}

For cgdisk, the Hex code 8300 is for Linux Filesystem, and 8200 is for swap.

I choose first partition with 512M for boot, and second one with 30G and 8300 Hex code for `/`, and third one with 4G and 8200 Hex code for `swap`, and 
remaining disk space with 8300 Hex code for `/home`.

After that, format these partitions with:

{% highlight console %}
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda4
mkswap /dev/sda3
swapon /dev/sda3
{% endhighlight %}

`Notice`: even with GParted, the above command `swapon /dev/sdax` is still necessary to plug swap on. 

And mount them:

{% highlight console %}
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir -p /mnt/home
mount /dev/sda4 /mnt/home
{% endhighlight %}

Adjusting mirrorlist:

{% highlight console %}
nano /etc/pacman.d/mirrorlist
{% endhighlight %}

Here is a list of nano shortcuts:

{% highlight console %}
Alt + 6 copy line
Ctrl + K cut line
Ctrl + U paste line
Ctrl + W search word
Ctrl + O save
Ctrl + X exit
{% endhighlight %}

or, you can rank mirrorlist automatically:

{%highlight console %}
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
rankmirrors -n 50 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
{% endhighlight %}

After that, install the base system:

{% highlight console %}
pacstrap -i /mnt base base-devel
{% endhighlight %}

And generate fastab:

{% highlight console %}
genfstab -U -p /mnt >> /mnt/etc/fstab
{% endhighlight %}

Run **chroot** check in to the newly installed system

{% highlight console %}
arch-chroot /mnt
passwd # set the root password
{% endhighlight %}

Some configurations:

{% highlight console %}
echo arch > /etc/hostname
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
pacman -S ntp
... # edit ntp.conf
systemctl enable ntpd.service
date
nano /etc/locale.gen
locale-gen
hwclock --systohc --utc

ip link # to list the interfacenames
system enable dhcpcd@interfacename.service
{% endhighlight %}

And for UEFI:

{% highlight console%}
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
{% endhighlight %}


and old one:

{% highlight console %}
mkinitcpio -p linux # create initial ramdisk environment
pacman -S gptfdisk # install and set syslinux
pacman -S syslinux
syslinux-install_update -i -a -m
nano /boot/syslinux/syslinux.cfg
{% endhighlight %}

Replace the line **APPEND root=/dev/sda3 rw** with **APPEND root=/dev/sda1 rw**.

After that, we will need to install grub to make the dual booting.

{% highlight console %}
pacman -S grub
grub-install --recheck /dev/sda
{% endhighlight %}

`Notice`: do not use sdax.

Then,

{% highlight console %}
pacman -S os-prober
grub-mkconfig -o /boot/grub/grub.cfg
{% endhighlight %}

{% highlight console %}
exit
umount -R /mnt
reboot
{% endhighlight %}

At this point, we have installed the Arch Linux with Win7. Now let's add a new user account:

{% highlight console %}
useradd -m -g users -G wheel -s /bin/bash newUser
{% endhighlight %}

Enjoy Arch Linux.

In the version of Arch Linux I installed, it uses `systemctl` for system and service management, it's great. But at the 
same time, I found that most online tutorial is out of date, which does not cover `systemctl` at all. While the `ArchWiki` is 
really marvelous, as it is always updated. You can find solutions for most problems you meet at `ArchWiki`.


Install yaourt & packer

edit /etc/pacman.conf by appending:

{% highlight console %}
[multilib]
Include = /etc/pacman.d/mirrorlist

[archlinuxfr]
SigLevel = Optional TrustAll 
Server = http://repo.archlinux.fr/$arch
{% endhighlight %}

{% highlight console %}
pacman -Syy
pacman -S yaourt customizepkg rsync
yaourt packer
{% endhighlight %}

Sound, X, Login screen and window manager

{% highlight console %}
yaourt -S alsa-utils
pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils
pacman -S xorg-twm xorg-xclock xterm
yaourt -S slim slim-themes archlinux-themes-slim
yaourt -S awesome rlwrap vicious dex feh xscreensaver
systemctl enable slim.service
{% endhighlight %}

`/etc/slim.conf` and `xinitrc`


{% highlight console %}
useradd -m -G users,audio,lp,optical,storage,video,wheel,power -s /bin/bash username
{% endhighlight %}