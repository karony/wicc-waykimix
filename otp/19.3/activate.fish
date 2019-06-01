# credits to virtualenv
function _kerl_remove_el --description 'remove element from array'
    set -l new_array
    for el in $$argv[1]
        if test $el != $argv[2]
            set new_array $new_array $el
        end
    end
    set -x $argv[1] $new_array
end

function kerl_deactivate --description "deactivate erlang environment"
    if set --query _KERL_PATH_REMOVABLE
        _kerl_remove_el PATH "$_KERL_PATH_REMOVABLE"
        set --erase _KERL_PATH_REMOVABLE
    end
    if set --query _KERL_MANPATH_REMOVABLE
        _kerl_remove_el MANPATH "$_KERL_MANPATH_REMOVABLE"
        set --erase _KERL_MANPATH_REMOVABLE
    end
    if set --query _KERL_SAVED_REBAR_PLT_DIR
        set -x REBAR_PLT_DIR "$_KERL_SAVED_REBAR_PLT_DIR"
        set --erase _KERL_SAVED_REBAR_PLT_DIR
    end
    if set --query _KERL_ACTIVE_DIR
        set --erase _KERL_ACTIVE_DIR
    end
    if functions --query _kerl_saved_prompt
        functions --erase fish_prompt
        # functions --copy complains about about fish_prompt already being defined
        # so we take a page from virtualenv's book
        . ( begin
                printf "function fish_prompt\n\t#"
                functions _kerl_saved_prompt
            end | psub )
        functions --erase _kerl_saved_prompt
    end
    if test "$argv[1]" != "nondestructive"
        functions --erase kerl_deactivate
        functions --erase _kerl_remove_el
    end
end
kerl_deactivate nondestructive

set -x _KERL_SAVED_REBAR_PLT_DIR "$REBAR_PLT_DIR"
set -x _KERL_PATH_REMOVABLE "/home/travis/otp/19.3/bin"
set -x PATH "$_KERL_PATH_REMOVABLE" $PATH
set -x _KERL_MANPATH_REMOVABLE "/home/travis/otp/19.3/lib/erlang/man" "/home/travis/otp/19.3/man"
set -x MANPATH $MANPATH "$_KERL_MANPATH_REMOVABLE"
set -x REBAR_PLT_DIR "/home/travis/otp/19.3"
set -x _KERL_ACTIVE_DIR "/home/travis/otp/19.3"
if test -f "/home/travis/.kerlrc.fish"
    source "/home/travis/.kerlrc.fish"
end
if set --query KERL_ENABLE_PROMPT
    functions --copy fish_prompt _kerl_saved_prompt
    function fish_prompt
        echo -n "(19.3)"
        _kerl_saved_prompt
    end
end
