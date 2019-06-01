% This is an -*- erlang -*- file.

{application, typer,
 [{description, "TYPe annotator for ERlang programs, version 0.9.12"},
  {vsn, "0.9.12"},
  {modules, [typer]},
  {registered, []},
  {applications, [compiler, dialyzer, hipe, kernel, stdlib]},
  {env, []},
  {runtime_dependencies, ["stdlib-3.0","kernel-5.0","hipe-3.15.4","erts-8.0",
			  "dialyzer-3.1","compiler-7.0"]}]}.
