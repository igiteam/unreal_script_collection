class combat_utility_TryToAttackFlashedEnemy extends CoreTask within animscripts_combat_utility;

state main
{
Begin:
	if (enemy.flashingTeam != team )
		_return();
	
	if (distanceSquared(origin, enemy.origin ) > 1024*1024*FInchSq)
		_return();
	
	while ( gettime() < enemy.flashendtime - 500 )
	{
		if (!cansee(enemy) && distanceSquared(origin, enemy.origin ) < 800*800*FInchSq)
			tryRunningToEnemy( true );
		
		wait(0.05);
	}
}
