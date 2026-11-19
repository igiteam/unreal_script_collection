class animscripts_cover_behavior extends Object within HodAI;

/*
This file contains the overall behavior for all "whack-a-mole" cover nodes.

Callbacks which must be defined:

 All callbacks should return true or false depending on whether they succeeded in doing something.
 If functionality for a callback isn't available, just don't define it.

mainLoopStart()
	optional
reload()
	plays a reload animation in a hidden position
leaveCoverAndShoot()
	does the main attacking; steps out or stands up and fires, goes back to hiding.
	should obey orders from decideWhatAndHowToShoot in shoot_behavior.gsc.
look(maxtime)
	looks for up to maxtime, stopping and returning if enemy becomes visible or if suppressed
fastlook()
	looks quickly
idle()
	idles until the "end_idle" notify.
flinch()
	flinches briefly (1-2 seconds), doesn't need to return true or false.
grenade(throwAt)
	steps out and throws a grenade at the given player / ai
grenadehidden(throwAt)
	throws a grenade at the given player / ai without leaving cover
blindfire()
	blindfires from cover

example:
behaviorCallbacks = spawnstruct();
behaviorCallbacks.reload = ::reload;
...
animscripts\cover_behavior::main(behaviorCallbacks);

*/

function main(cover_behavior_callback behaviorCallbacks, optional bool newThread = false)
{
	local cover_behavior_main task;
	task = new(self) class'cover_behavior_main';
	task.behaviorCallbacks = behaviorCallbacks;
	run (task, newThread);
}

function bool IsEnemyVisibleFromExposed()
{
	if (!obj_isdefined(enemy))
		return false;

	// if we couldn't see our enemy last time we stepped out, and they haven't moved, assume we still can't see them.
	if (distanceSquared(enemy.origin, couldntSeeEnemyPos) < 16*16*FInchSq)
		return false;
	else
		return animscripts_utility.canSeeEnemyFromExposed();
}

function SuppressedBehavior(cover_behavior_callback behaviorCallbacks, optional bool newThread = false)
{
	local cover_behavior_SuppressedBehavior task;
	task = new(self) class'cover_behavior_SuppressedBehavior';
	task.behaviorCallbacks = behaviorCallbacks;
	run (task, newThread);
}

// returns array of integers 0 through n-1, in random order
function getPermutation(int n, out array<int> permutation)
{
	local int i;
	local int switchIndex;
	local int temp;

	assert(n > 0);
	permutation.Remove(0, permutation.length);
	permutation.Add(n);
	if (n == 1)
	{
		permutation[0] = 0;
	}
	else if (n == 2)
	{
		permutation[0] = randomint(2);
		permutation[1] = 1 - permutation[0];
	}
	else
	{
		for (i = 0; i < n; i++)
			permutation[i] = i;
		for (i = 0; i < n; i++)
		{
			switchIndex = i + randomint(n - i);
			temp = permutation[switchIndex];
			permutation[SwitchIndex] = permutation[i];
			permutation[i] = temp;
		}
	}
}

function WatchSuppression(optional bool newThread = false)
{
	run (new(self) class'cover_behavior_WatchSuppression', newThread);
}

function CoverReload(cover_behavior_callback behaviorCallbacks, float threshold, optional bool newThread = false)
{
	local cover_behavior_CoverReload task;
	task = new(self) class'cover_behavior_CoverReload';
	task.iCallback = behaviorCallbacks.reload;
	task.iThreshold = threshold;
	run (task, newThread);
}

// initialGoal can be either "normal", "suppress", or "ambush".
function LeaveCoverAndShoot(cover_behavior_callback behaviorCallbacks, name iInitialGoal, optional bool newThread = false)
{
	local cover_behavior_LeaveCoverAndShoot task;
	task = new(self) class'cover_behavior_LeaveCoverAndShoot';
	task.iCallback = behaviorCallbacks.leaveCoverAndShoot;
	task.iInitialGoal = iInitialGoal;
	run (task, newThread);
}

function LookForEnemy(cover_behavior_callback behaviorCallbacks, optional bool newThread = false)
{
	local cover_behavior_LookForEnemy task;
	task = new(self) class'cover_behavior_LookForEnemy';
	task.behaviorCallbacks = behaviorCallbacks;
	run (task, newThread);
}

function lookfast(cover_behavior_callback behaviorCallbacks, optional bool newThread = false)
{
	local cover_behavior_lookfast task;
	task = new(self) class'cover_behavior_lookfast';
	task.iFastlook = behaviorCallbacks.fastlook;
	task.iLook = behaviorCallbacks.look;
	run (task, newThread);
}

function idle(cover_behavior_callback behaviorCallbacks, optional float howLong = -1, optional bool newThread = false)
{
	local cover_behavior_idle task;
	task = new(self) class'cover_behavior_idle';
	task.behaviorCallbacks = behaviorCallbacks;
	task.howLong = howLong;
	run (task, newThread);
}

function IdleWait(float howLong, optional bool newThread = false)
{
	local cover_behavior_IdleWait task;
	task = new(self) class'cover_behavior_IdleWait';
	task.howLong = howLong;
	run (task, newThread);
}

function IdleWaitAbit(optional bool newThread = false)
{
	run (new(self) class'cover_behavior_IdleWaitAbit', newThread);
}

function IdleThread(CBCIdle iIdleCallBack, optional bool newThread = false)
{
	local cover_behavior_IdleThread task;
	task = new(self) class'cover_behavior_IdleThread';
	task.iIdleCallBack = iIdleCallBack;
	run (task, newThread);
}

function FlinchWhenSuppressed(cover_behavior_callback behaviorCallbacks, optional bool newThread = false)
{
	local cover_behavior_FlinchWhenSuppressed task;
	task = new(self) class'cover_behavior_FlinchWhenSuppressed';
	task.behaviorCallbacks = behaviorCallbacks;
	run (task, newThread);
}

function endIdleAtFrameEnd(optional bool newThread = false)
{
	run (new(self) class'cover_behavior_EndIdleAtFrameEnd', newThread);
}

function TryThrowingGrenade(cover_behavior_callback behaviorCallbacks, HodEntity throwAt, optional bool newThread = false)
{
	local cover_behavior_TryThrowingGrenade task;
	task = new(self) class'cover_behavior_TryThrowingGrenade';
	if (animscripts_utility.isPartiallySuppressedWrapper())
	{
		task.iCallback = behaviorCallbacks.grenadehidden;
	}
	else
	{
		task.iCallback = behaviorCallbacks.grenade;
	}
	task.iThrowAt = throwAt;
	run (task, newThread);
}

function blindfire(cover_behavior_callback behaviorCallbacks, optional bool newThread = false)
{
	local cover_behavior_blindfire task;
	task = new(self) class'cover_behavior_blindfire';
	task.iCallback = behaviorCallbacks.blindfire;
	run (task, newThread);
}

function BreakOutOfShootingIfWantToMoveUp(optional bool newThread = false)
{
	run (new(self) class'cover_behavior_BreakOutOfShootingIfWantToMoveUp', newThread);
}

function bool EnemyIsHiding()
{
	// if this function is called, we already know that our enemy is not visible from exposed.
	// check to see if they're doing anything hiding-like.

	if (!obj_isdefined(enemy))
		return false;

	if (enemy.isFlashed())
		return true;

	if (isplayer(enemy))
	{
		return true;
		if (enemy.health < enemy.maxhealth)
			return true;
	}
	else
	{
		if (issentient(enemy) && HodAI(enemy).animscripts_utility.isSuppressedWrapper())
			return true;
	}

	if (enemy.isreloading)
		return true;

	return false;
}

function bool WouldBeSmartForMyAITypeToSeekOutEnemy()
{
	if (animscripts_utility.weaponAnims() == 'rocketlauncher')
		return false;
	if (animscripts_combat_utility.isSniper())
		return false;
	return true;
}

function ResetSeekOutEnemyTime()
{
	// we'll be willing to actually run right up to our enemy in order to find them if we haven't seen them by this time.
	// however, we'll try to find better cover before seeking them out
	seekOutEnemyTime = gettime() + randomintrange(3000, 5000);
}

// these next functions are "look for better cover" functions.
// they don't always need to cause the actor to leave the node immediately,
// but if they keep being called over and over they need to become more and more likely to do so,
// as this indicates that new cover is strongly needed.
function bool CantFindAnythingToDo()
{
	return advanceOnHidingEnemy();
}

function bool AdvanceOnHidingEnemy()
{
	local bool lFoundBetterCover;

	lFoundBetterCover = false;
	if (!animscripts_utility.isValidEnemy(enemy) || !enemy.isFlashed())
		lFoundBetterCover = animscripts_combat_utility.lookForBetterCover();

	if (!lFoundBetterCover && animscripts_utility.isValidEnemy(enemy) && wouldBeSmartForMyAITypeToSeekOutEnemy() && !animscripts_utility.canSeeEnemyFromExposed())
	{
		if (gettime() >= seekOutEnemyTime || enemy.isFlashed())
		{
			return animscripts_combat_utility.tryRunningToEnemy(false);
		}
	}

	// maybe at this point we could look for someone who's suppressing our enemy,
	// and if someone is, we can say "cover me!" and have them say "i got you covered" or something.

	return lFoundBetterCover;
}

function bool TryToGetOutOfDangerousSituation()
{
	// maybe later we can do something more sophisticated here
	return animscripts_combat_utility.lookForBetterCover();
}
