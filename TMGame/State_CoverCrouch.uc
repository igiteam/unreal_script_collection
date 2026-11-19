class State_CoverCrouch extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	run (new(outer) class'StateCover_Stand', true);
	animscripts_cover_crouch.main(false);
	notify ('state cover crouch end');
}
