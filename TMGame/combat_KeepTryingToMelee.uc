class combat_KeepTryingToMelee extends CoreTask within animscripts_combat;

state main
{
Begin:
	endon('killanimscript');
	endon('stop_trying_to_melee');
	endon('done turning');
	endon('need_to_turn');
	endon('shoot_behavior_change');
	
	while (true)
	{
		wait (0.2 + randomfloat(0.3));
		
		// this function is running when we're doing something like shooting or reloading.
		// we only want to melee if we would look really stupid by continuing to do what we're trying to get done.
		// only melee if our enemy is very close.
		if (obj_isdefined(enemy) && (distanceSquared(enemy.origin, origin) < 100*100*FInchSq) && TryMelee())
			_return();
	}
}
