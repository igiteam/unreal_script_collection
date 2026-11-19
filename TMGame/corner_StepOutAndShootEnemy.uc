class corner_StepOutAndShootEnemy extends BoolTask within animscripts_corner;

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
	/*
	// rambo disabled.
	ramboChance = 10;
	if (isdefined(self.lastSuppressionTime) && gettime() - self.lastSuppressionTime < 3000)
		ramboChance = 30;
	
	if (self.shootObjective == 'normal' && canDoRambo() && randomint(100) < ramboChance && haventRamboedWithinTime(7))
	{
		return ramboStepOut();
	}*/

	lBoolReturn = false;
	StepOut();
	if (!lBoolReturn) // may not be room to step out
		_return (false);
	
	shootAsTold();

	if (vec_isDefined(shootPos))
	{
		lDistSqToShootPos = lengthsquared(origin - shootPos);
		// too close for RPG or out of ammo
//		if (animscripts_utility.weaponAnims() == 'rocketlauncher' && (lDistSqToShootPos < squared(512)*FInchSq || a.rockets < 1))
//		{
//			if (self.a.pose == 'stand')
//				animscripts\shared::throwDownWeapon(%RPG_stand_throw);
//			else
//				animscripts\shared::throwDownWeapon(%RPG_crouch_throw);
//
//			self thread runCombat();
//			return;
//		}
	}
	
	returnToCover();
	
	_return (true);
}
