---
layout: post
category: [gpg]
tags: [gpg]
infotext: 'First taste with gpg, some instructions about using gpg.'
---
{% include JB/setup %}

Finally managed to use gpg, automatically encrypting git repo files gives life more freedom.

## Install gpg

It seems that gpg is included in the base installation of arch linux, or I have installed it before as a dependence of some other program.

## Create a key

Use following command to generate key with full featured generation dialog:

{% highlight console %}
gpg2 --full-gen-key
{% endhighlight %}

You will be asked to fill some fields such as the key type, the key size larger and safer, expire time, the name and email for identity, and the passphrase.

It takes some time to generate the key.

After the generation, you can use following commands to view the keys managed on your computer. The keys are most likely generated in `~/.gnupg/`, don't let others touch it.

{% highlight console %}
gpg --fingerprint your.email
gpg --list-keys # list all keys, public and private
gpg --list-secret-keys # list only private keys
# --fingerprint option for print fingerprint
{% endhighlight %}

If you like,

{% highlight console %}
gpg --gen-revoke user.id
{% endhighlight %}

to create a revoke cert, also don't let others touch this, or your key can be revoked by others.

## Send your keys to the key server

{% highlight console %}
gpg --send-keys user.id
{% endhighlight %}

Most key servers will mirror each other, but it will take time for keys to propagate across all servers.

## Copy your key

{% highlight console %}
gpg --output pubkey.gpg --export user.id # export your public key to pubkey.gpg

# export your private key and add temporary encryption to keys.asc
gpg --output - --export-secret-key user.id | cat pubkey.gpg - | gpg --armor --output keys.asc --symmetric --cipher-algo AES256

# copy the keys.asc to the destination machine, better not via internet.

shred -zu keys.asc # delete the key file, normal deletion may not be sufficient.

gpg --no-use-agent --output - keys.asc | gpg --import # import the keys into the destination machine
{% endhighlight %}

## e

Above are the commands I used today.

## Encrypt a file

{% highlight console %}
# --armor, optional to get ascii-armored file
# -o specifies the out put filename, optional
# --sign adds the signature, theoretically optional
# -r specifies the recipient of the encrypted file
gpg -o filename.out --encrypt --sign -r user.id filename.in
{% endhighlight %}

## Decrypt a file

After the recipient receives the encrypted file, decrypt the file with:
{% highlight console %}
gpg --decrypt filename.out -o filename
{% endhighlight %}

## More on signs

{% highlight console %}
# wrap the message in ascii-armored signature as filename.asc
# leave the content unchanged
gpg --clearsign filename

# verify the signature, to ensure the creator
gpg --verify filename.asc

# generate a separate signature file filename.sig
gpg --detach-sign filename
gpg --verify filename.sig
{% endhighlight %}

## Symmetric Encryption/Decryption

{% highlight console %}
# encrypt file with AES256 algorithm, prompt for passphrase
gpg --symmetric --cipher-algo AES256 filename
# decrypt the file, same passphrase required
gpg filename.gpg

# view all supported algo
gpg --version
{% endhighlight %}

## Refresh keys

{% highlight console %}
# update keys to public key server, including signatures
gpg --refresh-keys
{% endhighlight %}

## List whom signed your keys

{% highlight console %}
gpg --list-sigs user.id
{% endhighlight %}

Above are the most common used commands, for more usage, check this [link](https://futureboy.us/pgp.html){:target="_blank"}.