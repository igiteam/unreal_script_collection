class cover_behavior_BreakOutOfShootingIfWantToMoveUp extends CoreTask within animscripts_cover_behavior;

state main
{
Begin:
	endon('killanimscript');
	endon('stop_deciding_how_to_shoot');

	while (true)
	{
		if (fixedNode)
			_return();

		wait (0.5 + randomfloat(0.75));

		if (!animscripts_utility.isValidEnemy(enemy))
			continue;

		if (enemyIsHiding())
		{
			if (advanceOnHidingEnemy())
				_return();
		}

		if (!animscripts_utility.canSeeEnemy() && !animscripts_utility.canSuppressEnemy())
		{
			if (gettime() > a.getBoredOfThisNodeTime)
			{
				if (cantFindAnythingToDo())
					_return();
			}
		}
	}
}
