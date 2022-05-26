Git config
==========

Read the [tips][tips].

Aliases
-------

### Install

```sh
curl -L http://bit.do/instal-git-alias | sh
```

### Use

```sh
git it          # init repo

git s           # status
git b           # branch
git rl          # list remotes

git l           # list last 10 commits
git ll          # list all commits
git ln          # list commits with changed files
git lp          # list commits with changes
git lg          # list commits as graph

git co          # checkout
git c <message> # commit with message
git ri          # rebase interactive

git pg .        # list all configs - regular expression can be used instead of dot to filter results
git alias       # list all aliases
```

[tips]: https://github.com/git-tips/tips
