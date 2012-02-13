# Add auto-completion and a stored history file of commands to your Python
# interactive interpreter. Requires Python 2.0+, readline. Autocomplete is
# bound to the Esc key by default (you can change it - see readline docs).
#
# Store the file in ~/.pystartup, and set an environment variable to point
# to it:  "export PYTHONSTARTUP=~/.pystartup" in bash.

import atexit
import os
import readline
import rlcompleter

# This binds the Tab key to the completion function, so hitting the Tab key
# twice suggests completions; it looks at Python statement names, the current
# local variables, and the available module names. For dotted expressions such
# as string.a, it will evaluate the expression up to the final '.' and then
# suggest completions from the attributes of the resulting object. Note that
# this may execute application-defined code if an object with a __getattr__()
# method is part of the expression.
readline.parse_and_bind('tab: complete')


historyPath = os.path.expanduser("~/.pyhistory")

def save_history(historyPath=historyPath):
    import readline
    readline.write_history_file(historyPath)

if os.path.exists(historyPath):
    readline.read_history_file(historyPath)

atexit.register(save_history)
del os, atexit, readline, rlcompleter, save_history, historyPath

# vim:ft=python:sw=4:ts=4:et:
