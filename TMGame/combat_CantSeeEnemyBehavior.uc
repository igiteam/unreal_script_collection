class combat_CantSeeEnemyBehavior extends CoreTask within animscripts_combat;

// parameter

// output

// local
var int lTime;
var float lRelYaw;
var Angle lLikelyEnemyDir;
var bool lGivenUpOnEnemy;
var float lThreshold;

var bool lReturn;

function OnReturn(CoreTask task)
{
	local combat_TurnToFaceRelativeYaw TurnToFaceRelativeYawTask;
	TurnToFaceRelativeYawTask = combat_TurnToFaceRelativeYaw(task);
	if (TurnToFaceRelativeYawTask != none)
	{
		lReturn = TurnToFaceRelativeYawTask.oResult;
		return;
	}
}

state main
{
Begin:
	//prof_begin('combat_cantSeeEnemyBehavior');

	if (a.pose != 'stand' && isStanceAllowed('stand') && standIfMakesEnemyVisible())
		_return();

	lTime = gettime();

	a.dontCrouchTime = lTime + 1500;

	if (node_isdefined(node) && node.type == 'Guard')
	{
		lRelYaw = AngleClamp180(angles.yaw - node.angles.yaw);
		TurnToFaceRelativeYaw(lRelYaw);
		if (lReturn)
			_return();
	}
	else if (lTime > a.scriptStartTime + 1200)
	{
		if (getAnglesToLikelyEnemyPath(lLikelyEnemyDir))
		{
			lRelYaw = AngleClamp180(angles.yaw - lLikelyEnemyDir.yaw);
			TurnToFaceRelativeYaw(-lRelYaw);
			if (lReturn)
				_return();
		}
	}

//	if (considerThrowGrenade())
//		_return();

	lGivenUpOnEnemy = (a.nextGiveUpOnEnemyTime < lTime);

	lThreshold = 0;
	if (lGivenUpOnEnemy)
		lThreshold = 0.99999;

	if (exposedReload(lThreshold))
		_return();

	if (lGivenUpOnEnemy && animscripts_utility.usingSidearm())
	{
		// switch back to main weapon so we can reload it too before another enemy appears
		switchToLastWeapon('pistol_stand_switch');
		_return();
	}

	/*if (shouldSwapShotgun())
	{
		self swapShotgun();
		_return();
	}*/

	cantSeeEnemyWait();
}
