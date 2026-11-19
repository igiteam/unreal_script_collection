class combat_utility_AttackEnemyWhenFlashed extends CoreTask within animscripts_combat_utility;

state main
{
Begin:
	endon('killanimscript');
	
	while (true)
	{
		if (!obj_isdefined(enemy) || !isalive(enemy) || !isSentient(enemy))
		{
			waittill('enemy');
			continue;
		}
		
		attackSpecificEnemyWhenFlashed();
	}
}
