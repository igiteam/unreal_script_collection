class StateCombatBreaker_Main extends CoreTask within HodAI;

state main
{
Begin:
	endon ('killanimscript');
	animscripts_combat.main(true);
	
	while (animscripts_utility.IsValidEnemy(enemy) && node_isdefined(node) && canSee(enemy))
	{
		if (distancesquared(enemy.origin, origin) > 350 * 350 * FInchSq)
			break;

		wait (0.05);
	}
}
