class HodAI_LastSightUpdater extends CoreTask within HodAI;

state main
{
Begin:
	endon ('death');

	while (true)
	{
		waittill ('enemy');

		if (isalive(enemy))
		{
			lastEnemySightPos = enemy.GetEye();
			lastEnemyOrigin = enemy.origin;
		}
		else
			lastEnemyOrigin = vec_undefined;

		run (new(outer) class'HodAI_UpdateLastSight', true);
	}
}
