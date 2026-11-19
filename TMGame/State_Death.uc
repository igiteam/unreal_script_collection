class State_Death extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	AnimMode('gravity');
	OrientMode('face current');
	animscripts_death.main(false);

	notify ('state death end');
}
