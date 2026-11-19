class cover_wall_ShootAsTold extends CoreTask within animscripts_cover_wall;

state main
{
Begin:
	endon('return_to_cover');

	maps__gameskill.didSomethingOtherThanShooting();

	while (true)
	{
		if (shouldReturnToCover)
			break;
		
		if (!vec_isdefined(shootPos)) {
			assert(!obj_isdefined(shootEnt));
			// give shoot_behavior a chance to iterate
			wait (0.05);
			wait (0);
			if (vec_isdefined(shootPos))
				continue;
			break;
		}
		
		if (bulletsInClip == 0)
			break;
		
		// crouch only
		if (coverType == 'crouch' && needToChangeCoverMode())
		{
			break;
			
			// TODO: if changing between stances without returning to cover is implemented, 
			// we can't just endon('return_to_cover') because it will cause problems when it
			// happens while changing stance.
			// see corner's implementation of this idea for a better implementation.

			// NYI
			/*changeCoverMode();
			
			// if they're moving too fast for us to respond intelligently to them,
			// give up on firing at them for the moment
			if (needToChangeCoverMode())
				break;
			
			continue;*/
		}
		
		shootUntilShootBehaviorChange_coverWall();		
		clearAnim('add_fire', 0.2);
	}
}
