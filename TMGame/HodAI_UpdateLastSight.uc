class HodAI_UpdateLastSight extends CoreTask within HodAI; 

state main
{
Begin:
	endon ('death');
	endon ('enemy');

	while (true)
	{
		if (isalive(enemy))
		{
			if (animscripts_utility.CanSeeEnemy())
			{
				lastEnemySightPos = enemy.GetEye();
				lastEnemyOrigin = enemy.origin;
			}
		}
		else
			lastEnemySightPos = vec_undefined;

		wait (0.05);
	}

}
