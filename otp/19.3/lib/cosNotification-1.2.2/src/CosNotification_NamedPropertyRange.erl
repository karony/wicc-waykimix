%%  coding: latin-1
%%------------------------------------------------------------
%%
%% Implementation stub file
%% 
%% Target: CosNotification_NamedPropertyRange
%% Source: /home/travis/.kerl/builds/19.3/otp_src_19.3/lib/cosNotification/src/CosNotification.idl
%% IC vsn: 4.4.2
%% 
%% This file is automatically generated. DO NOT EDIT IT.
%%
%%------------------------------------------------------------

-module('CosNotification_NamedPropertyRange').
-ic_compiled("4_4_2").


-include("CosNotification.hrl").

-export([tc/0,id/0,name/0]).



%% returns type code
tc() -> {tk_struct,"IDL:omg.org/CosNotification/NamedPropertyRange:1.0",
                   "NamedPropertyRange",
                   [{"name",{tk_string,0}},
                    {"range",
                     {tk_struct,"IDL:omg.org/CosNotification/PropertyRange:1.0",
                                "PropertyRange",
                                [{"low_val",tk_any},{"high_val",tk_any}]}}]}.

%% returns id
id() -> "IDL:omg.org/CosNotification/NamedPropertyRange:1.0".

%% returns name
name() -> "CosNotification_NamedPropertyRange".



