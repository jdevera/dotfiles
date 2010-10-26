# The local Directory

This directory contains two subdirectories, `before` and `after`, that are
intended bash configuration files that are specific for the local machine.

All the files within these directories are sourced by bash upon start up in
this order:

 * The files in the *before* subdirectory
 * The files directly under the parent directory (`.bash.d`)
 * The files in the *after* subdirectory

No files under any of the two subdirectories are tracked by git, except the
empty `.empty`, which is there as workaround to force git to include empty
directories in the repository (See [1] for more information about this
"feature").

These specific configuration files can be used for configurations that depend
on a particular piece of hardware being available, or to have a different shell
prompt for different machines, etc. I use it to store all my work-specific
configuration so that I can keep a common base environment in all my home and
work computers.

Since the local directory is ignored, you can also initialise a different git
repository in it.

[1] http://stackoverflow.com/questions/115983

<!--
vim: filetype=markdown :
-->
