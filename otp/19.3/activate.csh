# This file must be used with "source bin/activate.csh" *from csh*.
# You cannot run it directly.

alias kerl_deactivate 'test $?_KERL_SAVED_PATH != 0 && setenv PATH "$_KERL_SAVED_PATH" && unset _KERL_SAVED_PATH; rehash; test $?_KERL_SAVED_MANPATH != 0 && setenv MANPATH "$_KERL_SAVED_MANPATH" && unset _KERL_SAVED_MANPATH; test $?_KERL_SAVED_REBAR_PLT_DIR != 0 && setenv REBAR_PLT_DIR "$_KERL_SAVED_REBAR_PLT_DIR" && unset _KERL_SAVED_REBAR_PLT_DIR; test $?_KERL_ACTIVE_DIR != 0 && unset _KERL_ACTIVE_DIR; test $?_KERL_SAVED_PROMP != 0 && set prompt="$_KERL_SAVED_PROMP" && unset _KERL_SAVED_PROMP; test "\!:*" != "nondestructive" && unalias deactivate'

# Unset irrelevant variables.
kerl_deactivate nondestructive

if ( $?REBAR_PLT_DIR ) then
    set _KERL_SAVED_REBAR_PLT_DIR = "$REBAR_PLT_DIR"
else
    set _KERL_SAVED_REBAR_PLT_DIR=""
endif

set _KERL_PATH_REMOVABLE = "/home/travis/otp/19.3/bin"
set _KERL_SAVED_PATH = "$PATH"
setenv PATH "${_KERL_PATH_REMOVABLE}:$PATH"

if ( ! $?MANPATH ) then
    set MANPATH = ""
endif
set _KERL_MANPATH_REMOVABLE = "/home/travis/otp/19.3/lib/erlang/man:/home/travis/otp/19.3/man"
set _KERL_SAVED_MANPATH = "$MANPATH"
setenv MANPATH "${_KERL_MANPATH_REMOVABLE}:$MANPATH"

setenv REBAR_PLT_DIR "/home/travis/otp/19.3"

set _KERL_ACTIVE_DIR = "/home/travis/otp/19.3"

if ( -f "/home/travis/.kerlrc.csh" ) then
    source "/home/travis/.kerlrc.csh"
endif

if ( $?KERL_ENABLE_PROMPT ) then
    set _KERL_SAVED_PROMPT = "$prompt"

    if ( $?KERL_PROMPT_FORMAT ) then
        set FRMT = "$KERL_PROMPT_FORMAT"
    else
        set FRMT = "(%BUILDNAME%)"
    endif

    set PROMPT = `echo "$FRMT" | sed 's^%RELEASE%^19.3^;s^%BUILDNAME%^19.3^'`
    set prompt = "$PROMPT$prompt"
endif

rehash
