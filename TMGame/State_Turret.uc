class State_Turret extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	run (new(outer) class'turret_main', false);
	notify ('state turret end');
}
