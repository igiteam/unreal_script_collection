class State_Combat extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	run (new(outer) class'StateExposed_Combat', true);
	animscripts_combat.main();
	notify ('state combat end');
}
