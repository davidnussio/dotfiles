# Alt+/ opens dothelp and inserts the picked command at the cursor
status is-interactive; or return

function __dothelp_widget
    dothelp --widget
    commandline -f repaint
end

bind \e/ __dothelp_widget
if test "$fish_key_bindings" != fish_default_key_bindings
    bind -M insert \e/ __dothelp_widget
end
