class State_CombatBreaker extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	run (new(outer) class'StateCombatBreaker_Main', false);
	notify ('state combat breaker end');
}
