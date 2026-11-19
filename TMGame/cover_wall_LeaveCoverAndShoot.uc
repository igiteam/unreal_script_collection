class cover_wall_LeaveCoverAndShoot extends BoolTask within animscripts_cover_wall;

// parameter

// output

// local
var float lDistSqToShootPos;

var bool lBoolReturn;

function OnReturn(CoreTask task)
{
	if (task.isa('BoolTask'))
		lBoolReturn = true;
}

state main
{
Begin:
	keepClaimedNodeInGoal = true;
	
	lBoolReturn = false;
	pop_up();
	if (!lBoolReturn)
		_return (false);
	
	shootAsTold();
	
	notify('kill_idle_thread');

	if (vec_isDefined(shootPos))
	{
		lDistSqToShootPos = lengthsquared(origin - shootPos);
		// too close for RPG or out of ammo
		if (animscripts_utility.weaponAnims() == 'rocketlauncher' && (lDistSqToShootPos < squared(512)*FInchSq || a.rockets < 1))
		{
			if (coverType == 'stand')
				animscripts_shared.throwDownWeapon('RPG_stand_throw');
			else
				animscripts_shared.throwDownWeapon('RPG_crouch_throw');
		}
	}

	go_to_hide();

	keepClaimedNodeInGoal = false;
	
	_return (true);
}
