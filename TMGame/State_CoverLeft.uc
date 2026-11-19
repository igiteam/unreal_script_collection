class State_CoverLeft extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	run (new(outer) class'StateCover_Left', true);
	animscripts_cover_left.main(false);
	notify ('state cover left end');
}
