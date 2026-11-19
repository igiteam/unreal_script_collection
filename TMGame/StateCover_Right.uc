class StateCover_Right extends CoreTask within HodAI;

state main
{
Begin:
	endon('killanimscript');

	wait (0);
	while (true)
	{
		if (animscripts_utility.IsValidEnemy(enemy) && CanSee(enemy))
		{
			if (CheckExposed_Right(coverNode))
			{
				goto_state('exposed');
				break;
			}
		}

		wait (0.05);
	}
}
