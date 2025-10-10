# Jacobo de Vera's Dot Files

These are the configuration files I want to have in every Linux box I use.

## Installation

Installation instructions come first because it is what I need most of the
time, but if you are not me, please read on :) 

    sh -c "$(curl -fsLS jdevera.casa/install)"

## If you are not me

You probably do not want to clone this repo and run it. You probably don't want
to do that with anybody's dotfile repo. It's in this type of repos' own nature
to be highly opnionated and tailored to the needs of the individual keeping it.

But there is a lot to learn from exploring. So please, explore away! And if you
have questions, open an issue.

## Management

I use [chezmoi](https://www.chezmoi.io/) to manage my dotfiles.

This repository is a mix of configuration files, templates to generate
configuration files, and script to setup things in a new machine.


### Bash configuration

My bash configuration files live in the _.bash.d_ directory.

My _.bashrc_ sources configuration files in this order:

 * Every file under _.bash.d/local/before_
 * Every file under _.bash.d_
 * Every file under _.bash.d/local/after_

Contents of _.bash.d/local_ are not tracked by `chezmoi`, so this is the place to
add configuration files that are specific for the current machine.

### Vim configuration

I am using [Junegunn Choi's Vim-Plug](https://github.com/junegunn/vim-plug) to
manage my Vim plug-ins and keep them up to date.

With Vim-Plug, I only have to point, in my _.vimrc_ file, to the git
repositories of all the Vim add-ons I want to have installed and it takes care
or the rest. Vim-Plug clones each add-on under its own directory and adds it
to Vim's runtime path.

All add-ons in the official Vim's website are actively mirrored in github by
the [Vim-Scripts.org](http://vim-scripts.org/) project. This means Vim-Plug
can be used to install any add-on published in the official site.

### Emacs configuration

> [!NOTE]
> I have not used Emacs in years, this config is probably broken.

I use [el-get](https://github.com/dimitri/el-get) to manage all the Emacs
packages that I want installed.

With the right configuration, I simply have to open Emacs and the packages
will be installed if they are not already.

<!--
vim:linebreak:textwidth=78:spell:
-->
