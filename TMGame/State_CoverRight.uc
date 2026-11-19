class State_CoverRight extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	run (new(outer) class'StateCover_Right', true);
	animscripts_cover_right.main(false);
	notify ('state cover right end');
}
