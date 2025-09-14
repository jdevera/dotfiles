# Jacobo de Vera's Dot Files

These are the configuration files I want to have in every Linux box I use.

## Installation

Installation instructions come first because it is what I need most of the
time, but if you are not me, please read on :) 

    git clone git://github.com/jdevera/dotfiles ~/.dotfiles
    cd ~/.dotfiles
    bash install


## Contents

Most files handle Bash or Vim configuration, but I also share my settings for
GNU Screen, Tmux, Git, Emacs, the Python interpreter, and others.

My git configuration file is actually a generator (more on this below).

My Vim configuration will install all the plug-ins I have installed.

### Configuration file generators

There are some configuration files, such as _.gitconfig_ that might contain
sensitive data or that have contents that vary across different machines. For
these cases, I don't directly store the configuration file, but a generator
for it.

These generators very are simple bash scripts that contain a template for the
file they generate. The values for variable fields are requested during
execution or they can be provided with environment variables for unattended
installation.

### Bash configuration

My bash configuration files live in the _.bash.d_ directory.

My _.bashrc_ sources configuration files in this order:

 * Every file under _.bash.d/local/before_
 * Every file under _.bash.d_
 * Every file under _.bash.d/local/after_

Contents of _.bash.d/local_ are not tracked by git, so this is the place to
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

I use [el-get](https://github.com/dimitri/el-get) to manage all the Emacs
packages that I want installed.

With the right configuration, I simply have to open Emacs and the packages
will be installed if they are not already.

<!--
vim:linebreak:textwidth=78:spell:
-->
