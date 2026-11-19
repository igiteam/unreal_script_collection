class State_CoverStand extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	run (new(outer) class'StateCover_Stand', true);
	animscripts_cover_stand.main(false);
	notify ('state cover stand end');
}
