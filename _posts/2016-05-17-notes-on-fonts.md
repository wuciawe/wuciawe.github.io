---
layout: post
category: [tools]
tags: [font]
infotext: 'several issues with fonts, bad encoding after unzip, install new font and convert font to image.'
---
{% include JB/setup %}

### Bad encoding of file name in unzip

Just try to unzip some file that is compressed in Windows, but the extracted files suffer the 
bad encoding. The file name is originally in Chinese and the Windows is in Chinese. The default 
encoding of Chinese Windows os is `cp936`.

Do the following to solve the problem:

{% highlight shell linenos=table %}
env LANG=zh_CN.GBK 7z x <some-file>
convmv -f cp936 -t utf8 -r --notest <extracted-path>
{% endhighlight %}

### Install new fonts in Arch Linux

For information on different approaches in details, see [the arch wiki](https://wiki.archlinux.org/index.php/fonts){:target='_blank'}, 
following is the method to install new fonts not in the repositories for current user manually:

{% highlight shell linenos=table %}
mv <new-font-file> ~/.local/share/fonts
fc-cache
fc-list # to see the newly installed fonts listed
{% endhighlight %}

### Convert font to image

A simple way is to use the functionality provided by `ImageMagick`, for more information, see [usage page](http://www.imagemagick.org/Usage/text/){:target='_blank'}.

{% highlight shell linenos=table %}
convert -font <font-family> -pointsize 72 label:<words> <result-image>
{% endhighlight %}

To see the `<font-family>` that is supported by `ImageMagick`, use the following command:

{% highlight shell linenos=table %}
convert -list font
{% endhighlight %}

It also provides C++ API.