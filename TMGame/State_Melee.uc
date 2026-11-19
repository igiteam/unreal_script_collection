class State_Melee extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	animscripts_melee.MeleeCombat(false);

	notify ('state melee end');
}
