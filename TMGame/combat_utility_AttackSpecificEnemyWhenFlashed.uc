class combat_utility_AttackSpecificEnemyWhenFlashed extends CoreTask within animscripts_combat_utility;

state main
{
Begin:
	endon('enemy');
	enemy.endon('death');
	
	if (gettime() < enemy.flashendtime)
		tryToAttackFlashedEnemy();
	
	while (true)
	{
		enemy.waittill('flashed');
		
		tryToAttackFlashedEnemy();
	}
}
