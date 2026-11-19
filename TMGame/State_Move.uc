class State_Move extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	run (new(outer) class'StateMove_Main', false);
	notify ('state move end');
}
