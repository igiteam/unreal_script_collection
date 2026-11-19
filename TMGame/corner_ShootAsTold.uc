class corner_ShootAsTold extends CoreTask within animscripts_corner;

// local
var bool lBoolReturn;

function OnReturn(CoreTask task)
{
	if (task.isa('BoolTask'))
		lBoolReturn = true;
}

state main
{
Begin:
	maps__gameskill.didSomethingOtherThanShooting();
	
	while (true)
	{
		while (true)
		{
			if (shouldReturnToCover)
				break;
			
			if (!vec_isdefined(shootPos)) {
				assert(!obj_isdefined(shootEnt));
				// give shoot_behavior a chance to iterate
				wait (0.05);
//				waittillframeend;
				wait (0);
				if (vec_isdefined(shootPos))
					continue;
				break;
			}
			
			if (bulletsInClip == 0)
				break;
			
			if (ShootPosOutsideLegalYawRange())
			{
				lBoolReturn = false;
				changeStepOutPos();
				if (!lBoolReturn)
				{
					// if we failed because there's no better step out pos, give up
					if (getBestStepOutPos() == a.cornerMode)
						break;
					
					// couldn't change position, shoot for a short bit and we'll try again
					ShootUntilShootBehaviorChangeForTime(0.2);
					continue;
				}
				
				// if they're moving back and forth too fast for us to respond intelligently to them,
				// give up on firing at them for the moment
				if (shootPosOutsideLegalYawRange())
					break;
				
				continue;
			}
			
			shootUntilShootBehaviorChange_corner(true);
			
			clearAnim('add_fire', 0.2);
		}
		
		if (canReturnToCover(a.cornerMode != 'lean'))
			break;

		// couldn't return to cover. keep shooting and try again
		
		// (change step out pos if necessary and possible)
		if (shootPosOutsideLegalYawRange())
		{
			lBoolReturn = false;
			changeStepOutPos();
			if (lBoolReturn)
				continue;
		}
		
		shootUntilShootBehaviorChangeForTime(0.2);
	}
}
