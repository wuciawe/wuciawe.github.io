---
layout: post
category: [tools]
tags: [git]
infotext: 'notes on using git'
---
{% include JB/setup %}

`Git`, usually you have multiple remote git repos and multiple local git repos (on different machines). For local repos, there are three phases for the local files: working directory, staging area, and git directory (repo).

In the working directory, files could be untracked, unstaged, or deleted. Once the file is staged, it's in the staging area. The staged files are those ready to be commited to the local repo.

## Configuration

### git config

`/etc/gitconfig` every user on the system ~ git config --system

`~/.gitconfig` or `~/.config/git/config` specific to your user ~ git config --global

`.git/config` the current repository ~ git config

Each level overrides values in the previous level.

#### identity

    git config --global user.name "XXX"
    git config --global user.email XXX@email.org

#### default editor

    git config --global core.editor emacs

#### check settings

    git config --list

#### set aliases

    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
    git config --global pull.rebase true # make --rebase the default in git pull
    git config --global credential.helper cache

## Initialization

### git init

    git init <dir> # initialize empty repository in <dir>
    git init # initialize a repository in an existing directory
    git init --bare --shared # initialize an empty remote repository (no working directory) and give the group write permissions to this repository properly

### git clone

    git clone <url> [<dir>] # clone a repository in <dir> from <url>
    git clone --bare <proj> <proj.git> # clone the <proj> repository to create a new bare repository
    git clone <bundle> <repo> # unbundle
    git clone --recursive <url> # automatically initialize and update each submodule

`How to retrieve all remote branches`: Once you `git clone` a remote repo, it will sync the `master` branch by default. To see how to retrieve all remote branches, click [here]( #syncbranches )

## Saving changes (staging and committing)

### git add

    git add <file>|<dir> # track and stage new file or whole directory
    git add -i # interactive staging
    git add -p # interactively partial staging
    git add -A # add every file

### git commit

    git commit -m <message> # commit the staged snapshot with <message>
    git commit -am <message> # commit all changes of the staged area, with those deleted files

## Inspecting

### git status

    git status # list status of files that are staged, unstaged, and untracked.

git status works on working directory and staging area.

### git log

    git log # display entire commit history, press `space` to scroll, and press `q` to exit.
    git log -n <limit> # display limited number of history
    git log --oneline # display condensed history
    git log --stat # display commit history with simple status
    git log -p # display commmit history with very detailed status
    git log --author=<pattern> # commits by a particular author
    git log --grep=<pattern> # search commits by <pattern>
    git log <since>..<until> # commit history between revision references
    git log <file> # commit history on a particular file

`special syntax`

 `..` syntax: compare between branches

 `~` syntax: make relative reference, i.e. HEAD~1 refers to the parent of current commit

### git diff

    git diff HEAD # HEAD points to the most recent commit
    git diff --staged # see the difference of just staged
    git diff <b1>..<b2> -- path # see difference of path between <b1> and <b2>, that are revision references, default is current branch
    git diff --name-status ... # show condensed info

Actually, with `urxvt` and `zsh`, `<Tab>` helps a lot.

## Checkout

    git checkout <branch> # recover <branch>
    git checkout <commit> # recover <commit>
    git checkout [[<branch>|<commit>] --] <file> # recover particular file

## Undoing

### git checkout

syntax same as [above]( #checkout )

### git revert

    git revert <commit> # generate a new commit that undoes all the changes introduced in <commit>, then apply it to current branch

`git revert` doesn't change the project history, it's safe for commits that have been pushed to a shared repository.
`git revert` is able to target an individual commit at an arbitrary point in the history.

### git reset

    git reset <file> # move <file> from staged area back to the working directory
    git reset [--mixed] # reset the staged area as the most recent commit, --mixed flag is default
    git reset --hard # reset the staged area and working directory as the most recent commit
    git reset --soft # the staged area and working directory are not altered
    git reset [--hard] <commit> # reset the staged area [and working directory] as the snapshot of <commit>

`git reset <commit>` will abort commits after <commit>.

`ACTUALLY` `git revert` and `git reset` both do not affect the untracked files, both are like an operation of moving pointer between snapshots.

### git clean

    git clean # remove untracked files from working directory
    git clean -n # dry run of git clean
    git clean -f # with force flag
    git clean -f <path> # remove untracked files in specific <path>
    git clean -df # remove untracked files and directories in current directory
    git clean -xf # remove untracked files and ignored files

## History manipulating

### git commit

    git commit --amand [--no-edit] # combine the staged area change with the previous commit and replace the previous commit, --no-edit flag for not changing the commit message.

A very convenient way to fix up the most recent commit. Better to avoid amending public commit.

### git rebase

    git rebase <base> # rebase the current branch onto <base>, which is a revision reference
    git rebase -i <base> # interactive one, pick and squash

The primary reason for rebasing is to maintain a linear project history.

### git reflog

    git reflog # show the reflog of the local repo
    git reflog --relative-date # show the relative date information

## Synchronization

### git remote

    git remote [-v] # list the remote repos, -v flag for displaying remote repo address
    git remote add <name> <url> # create a new remote connection
    git remote rm <name> # remove remote connection to <name>
    git remote rename <oldName> <newName> # rename the remote repo

`git clone` will create the remote repo as `origin`.

### git fetch

    git fetch <remote> # fetch all the branches from <remote>
    git fetch <remote> <branch> # fetch specific <branch> from <remote>

Fetched content is represented as a remote branch, no effect on local working.

    git branch -r # view remote branches

### git pull

    git pull <remote> # fetch the <remote>'s copy of current branch and merge it into local copy
    git pull --rebase <remote> # use rebase

#### syncBranches

Following codes show how to create local branches for all remote tracking branches:

    # sol 1
    for b in `git branch -r | grep -v -- '->'`; do git branch --track ${b##origin/} $b; done
    
    # sol 2, ?, not tested yet, seems more robust?
    git branch -r | grep -v -- ' -> ' | while read remote; do git branch --track "${remote#origin/}" "$remote" 2>&1 | grep -v ' already exists'; done

### git stash

    git stash # temporary save uncommited stuff
    git stash apply # restore stashed stuff

By default, `git stash` will only stash those indexed files, which means you need to `git add` untracked files first to make them into staged area, then stash them.

Since version `1.7.7`, you could use following flag to include stashing untracked files:

    git stash -u

### git push

    git push <remote> <branch> # push specific <branch> to <remote>
    git push <remote> --all # push all the local branches to <remote>
    git push <remote> --tags # --tags flag sends local tags to <remote>

## Branch

### git branch

    git branch # list all branches
    git branch <branch> # create a <branch> branch
    git branch -d <branch> # delete <branch>, it prevents deleting the branch that has unmerged changes
    git branch -D <branch> # force delete <branch>
    git branch -m <branch> # rename current branch to <branch>

    git checkout -b <newBranch> [<oneBranch>] # create and checkout <newBranch>, based on current branch or <oneBranch>

### git merge

    git merge <branch> # merge <branch> into current branch
    git merge --no-ff <branch> # always generate a merge commit

`fast-forward merge` occurs when there is linear from current branch to target branch.

`3-way merge` is of two branch tips and their common ancestor. It may encounter conflicts.

### git rebase

Also, `git rebase` can be used for merging branches. Syntax see [above]( #git-rebase )

## git help

    git help <verb>