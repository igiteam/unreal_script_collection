class move_ShootWhileMoving extends CoreTask within animscripts_move;

state main
{
Begin:
	endon('killanimscript');
	
	// it's possible for this to be called by CQB while it's already running from run.gsc,
	// even though run.gsc will kill it on the next frame. We can't let it run twice at once.
	notify('doing_shootWhileMoving');
	endon('doing_shootWhileMoving');
	
	SetAnimArrayE('fire', 'stand_fire_auto');
	
	if (isdefined(weapon) && weaponClass(weapon) == 'spread')
	{
		SetAnimArrayE('single', 'shotgun_stand_fire_1A');
		SetAnimArray('single', 'shotgun_stand_fire_1B');
	}
	else
		SetAnimArrayE('single', 'stand_fire_single');
	
	SetAnimArrayE('burst2', 'stand_fire_burst2');
	SetAnimArrayE('burst3', 'stand_fire_burst3');
	SetAnimArrayE('burst4', 'stand_fire_burst4');
	SetAnimArrayE('burst5', 'stand_fire_burst5');
	SetAnimArrayE('burst6', 'stand_fire_burst6');
	
	SetAnimArrayE('semi2', 'stand_fire_semi2');
	SetAnimArrayE('semi3', 'stand_fire_semi3');
	SetAnimArrayE('semi4', 'stand_fire_semi4');
	SetAnimArrayE('semi5', 'stand_fire_semi5');
	
	while (true)
	{
		if (bulletsInClip == 0)
		{
//			if (self isCQBWalking())
//				cheatAmmoIfNecessary();

			if (bulletsInClip == 0)
			{
				wait (0.5);
				continue;
			}
		}
		
		animscripts_combat_utility.ShootUntilShootBehaviorChange();
		// can't clear %exposed_modern because there are transition animations within it that we might play when going to prone
		clearAnim('exposed_aiming', 0.2);
	}
}
