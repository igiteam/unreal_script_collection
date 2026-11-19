class State_Stop extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	run (new(outer) class'StateExposed_Stop', true);
	animscripts_stop.main();
	notify ('state stop end');
}
