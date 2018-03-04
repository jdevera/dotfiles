# ANSI colours {{{
# ---------------------------------------------------------------------------
__complete_ansi_color()
{
   echo "black red green brown blue purple cyan light_gray dark_gray light_red light_green yellow light_blue light_purple light_cyan white none" | 
   tr ' ' '\n' | grep "^$2.*"
}
link_complete_function ansi_color
link_complete_function ansi_color set_prompt_color
# ---------------------------------------------------------------------------
# }}}
# New program template {{{
# ---------------------------------------------------------------------------
__complete_new()
{
   (builtin cd $SOURCE_TEMPLATES && ls) | grep "^$2.*"
}

link_complete_function new
# ---------------------------------------------------------------------------
# }}}
# Load all completions from linuxbrew {{{
# ---------------------------------------------------------------------------
source_dir /home/linuxbrew/.linuxbrew/etc/bash_completion.d/
source_dir ~/.linuxbrew/etc/bash_completion.d/
# ---------------------------------------------------------------------------
# }}}

# vim: fdm=marker
