---
layout: post
category: [tools]
tags: [git]
infotext: 'notes on using git, changing the history of git repository.'
---
{% include JB/setup %}

Sometimes, after several pieces of committing, you realized that some of that commits need to be modified. 
Following is how to change the history of git repository.

## Change specific commit

### Change the last commit

{% highlight shell linenos=table %}
git commit --amend
{% endhighlight %}

The above command will modify the previous commit.

### Split apart the last commit

In order to split apart the most recently commited commit, use following command:

{% highlight shell linenos=table %}
git reset HEAD~
{% endhighlight %}

As illustrated in [notes on git part 1]({% post_url 2015-10-26-notes-on-git-part-1 %}#git-reset), the above 
command will reset the staged area as the commit ahead of the last commit. Now use `git add/rm` to stage files, 
and make commits.

### Use the old commit message

Sometimes you need to reuse the commit message from some commits, i.e. keep the Change-ID. Then use 
following command:

{% highlight shell linenos=table %}
git commit --reuse-message=HEAD@{1} # reuse the commit message of HEAD@{1} directly
git commit -C <commit> # short version of above command

git commit --reedit-message=<commit> # reuse and edit the commit message of <commit>
git commit -c <commit> # short version of above command

git commit --reset-author -c <commit> # change author only
{% endhighlight %}

`NOTICE:` `HEAD@{}` is a notation for capturing the history of `HEAD` movement, and `HEAD@{1}` references 
the place from where you jumped to the new commit location. SEE [notes on git part 1]({% post_url 2015-10-26-notes-on-git-part-1 %}#git-reflog).

In order to reuse the original commit message for a certain commit, as in the process splitting apart commits, 
use following command:

{% highlight shell linenos=table %}
git commit -c ORIG_HEAD
{% endhighlight %}

### Modify specific commits

What if the commit I want to rework is not the last commit? Use `git rebase -i` as:

{% highlight shell linenos=table %}
git rebase -i HEAD~n
{% endhighlight %}

where, `n` denotes how many commits back it is. And in the prompt, reorder the commits and select proper flags. 
For example, if you want to modify the third last commit, use `git rebase -i HEAD~3`, pick `edit` option on 
that commit.

And if you want to split apart that commit, do `git reset HEAD~`, and make new commits as you want.

And if you want to test what you're committing, use `git stash` to hide away the part that hasn't been 
committed (or `git stash --keep-index` before committing it), test, then `git stash pop` to return 
the rest to the work tree.

After you managed each history commits that need a rework, having a clean work tree on each commit point, 
use the following command to proceed rebasing:

{% highlight shell linenos=table %}
git rebase --continue
{% endhighlight %}

After you managed all the to-be-edit commits, the history has been rewrote.

`NOTICE:` explanation on `HEAD~n` and `HEAD^n`.

`HEAD^` means the first parent of the tip of the current branch, as git commits can have more than one 
parent.

`HEAD~` is for moving back through generations, favoring the first parent in cases of ambiguity.

These specifiers can be chained arbitrarily , e.g., topic~3^2.

So, `~` is fuzzy while `^` is precise.

## Change a branch of commits in a common way

This part is mostly copied from [https://git-scm.com](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History#The-Nuclear-Option:-filter-branch){:target="_blank"}

### Remove a file from every commit

{% highlight shell linenos=table %}
git filter-branch --tree-filter 'rm -f <to-be-removed-file>' HEAD
{% endhighlight %}

To run `filter-branch` on all branches, pass `--all` to the command.

### Make a subdirectory as the new `Root`

{% highlight shell linenos=table %}
git filter-branch --subdirectory-filter <sub-directory> HEAD
{% endhighlight %}

Now the new project root is what was in the `<sub-directory>` each time. Git will also automatically 
remove commits that did not affect the `<sub-directory>`.

### Change Email address globally

{% highlight shell linenos=table %}
git filter-branch --commit-filter 'if [ "$GIT_AUTHOR_EMAIL" = "<old-email-addr>" ]; then GIT_AUTHOR_NAME="<author-name>"; GIT_AUTHOR_EMAIL="<email-addr>"; git commit-tree "$@"; else git commit-tree "$@"; fi' HEAD
{% endhighlight %}

This goes through and rewrites every commit to have the new `<email-addr>`. Because commits contain 
the SHA-1 values of their parents, this command changes every commit SHA-1 in history, not just 
those that have the matching email address.