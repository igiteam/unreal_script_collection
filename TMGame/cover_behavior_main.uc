class cover_behavior_main extends CoreTask within animscripts_cover_behavior;

// parameter
var cover_behavior_callback behaviorCallbacks;

// output

// local
var float lTime;
var float lNextAllowedLookTime;
var float lNextAllowedSuppressTime;
var bool lDesynched;
var Angle lCorrectAngles;
var float lStartTime;
var bool lVisibleEnemy;
var bool lSuppressableEnemy;
var array<int> lPermutation;
var bool lDone;
var name lPreferredActivity;
var int i;

var bool lBoolReturn;

function OnReturn(CoreTask task)
{
	if (task.isa('BoolTask'))
		lBoolReturn = true;
}

state main
{
Begin:
	//prof_begin('cover_main');
	
	couldntSeeEnemyPos = origin; // (set couldntSeeEnemyPos to a place the enemy can't be while we're in corner behavior)
	
	lTime = gettime();
	lNextAllowedLookTime = lTime - 1;
	lNextAllowedSuppressTime = lTime - 1;
	
	// we won't look for better cover purely out of boredom until this time
	a.getBoredOfThisNodeTime = gettime() + randomintrange(2000, 6000);
	resetSeekOutEnemyTime();
	a.lastEncounterTime = lTime;
	
	a.idlingAtCover = false;
	a.movement = 'stop';
	
	watchSuppression(true);
	animscripts_combat_utility.attackEnemyWhenFlashed(true);
	
	lDesynched = (gettime() > 2500);
	
	lCorrectAngles = coverNode.angles;
	if (coverNode.type == 'Cover Left' || coverNode.type == 'Cover Left Wide')
		lCorrectAngles.yaw = lCorrectAngles.yaw - 90;
	else if (coverNode.type == 'Cover Right' || coverNode.type == 'Cover Right Wide')
		lCorrectAngles.yaw = lCorrectAngles.yaw + 90;
	
	//prof_end('cover_main');
	
	while (true)
	{
		//prof_begin('cover_main_A');
		if (obj_isdefined(behaviorCallbacks.mainLoopStart))
		{
			lStartTime = gettime();
			endIdleAtFrameEnd(true);
			
			//prof_end('cover_main_A');
			behaviorCallbacks.mainLoopStart.Execute();
			
			if (gettime() == lStartTime)
				notify('dont_end_idle');
		}
		
		teleport(covernode.origin, lCorrectAngles);
		
		if (coverNode.script_onlyidle)
		{
			assert(coverNode.script_onlyidle); // true or undefined
			//prof_end('cover_main_A');
			idle(behaviorCallbacks);
			continue;
		}
		
		if (!lDesynched)
		{
			//prof_end('cover_main_A');
			idle(behaviorCallbacks, 0.05 + randomfloat(1.5));
			lDesynched = true;
			continue;
		}

		if (kCombatMood == HCM_Ambush)
		{
			idle(behaviorCallbacks);
			continue;
		}
		//prof_end('cover_main_A');
		
		//prof_begin('cover_main_B');
		
		// if we're suppressed, we do other things.
		lBoolReturn = false;
		suppressedBehavior(behaviorCallbacks);
		if (lBoolReturn)
		{
			if (isEnemyVisibleFromExposed())
				resetSeekOutEnemyTime();
			a.lastEncounterTime = gettime();
			//prof_end('cover_main_B');
			continue;
		}
		
		//prof_end('cover_main_B');
		
		//prof_begin('cover_main_C');
		
		// reload if we need to; everything in this loop involves shooting.
		lBoolReturn = false;
		coverReload(behaviorCallbacks, 0);
		if (lBoolReturn)
		{
			//prof_end('cover_main_C');
			continue;
		}
		
		// determine visibility and suppressability of enemy.
		lVisibleEnemy = false;
		lSuppressableEnemy = false;
		if (isalive(enemy))
		{
			lVisibleEnemy = isEnemyVisibleFromExposed();
			lSuppressableEnemy = animscripts_utility.canSuppressEnemyFromExposed();
		}
		
		if (anim.throwGrenadeAtPlayerASAP && team == 'axis' && isAlive(level.player))
		{
			lBoolReturn = false;
			tryThrowingGrenade(behaviorCallbacks, level.player);
			if (lBoolReturn)
			{
				//prof_end('cover_main_C');
				continue;
			}
		}
		
		//prof_end('cover_main_C');

		// decide what to do.
		if (lVisibleEnemy)
		{
			//prof_begin('cover_visible_enemy');
			if (distanceSquared(origin, enemy.origin) > 750 * 750 * FInchSq)
			{
				lBoolReturn = false;
				tryThrowingGrenade(behaviorCallbacks, enemy);
				if (lBoolReturn)
				{
					//prof_end('cover_visible_enemy');
					continue;
				}
			}
			
			lBoolReturn = false;
			leaveCoverAndShoot(behaviorCallbacks, 'normal');
			if (lBoolReturn)
			{
				resetSeekOutEnemyTime();
				a.lastEncounterTime = gettime();
			}
			else
			{
				//prof_end('cover_visible_enemy');
				idle(behaviorCallbacks);
			}
			
			//prof_end('cover_visible_enemy');
		}
		else
		{
			//prof_begin('cover_notvisible_enemy');
			if (!lVisibleEnemy && enemyIsHiding() && !fixedNode)
			{
				if (advanceOnHidingEnemy())
				{
					//prof_end('cover_notvisible_enemy');
					_return();
				}
			}
			
			if (lSuppressableEnemy)
			{
				// randomize the order of trying the following options
				getPermutation(2, lPermutation);
				lDone = false;
				for (i = 0; i < lPermutation.length && !lDone; i++)
				{
					switch(i)
					{
					case 0:
						if (provideCoveringFire || gettime() >= lNextAllowedSuppressTime)
						{
							lPreferredActivity = 'suppress';
							if (!provideCoveringFire && (gettime() - lastSuppressionTime) > 5000 && randomint(3) < 2)
								lPreferredActivity = 'ambush';
							if (!animscripts_shoot_behavior.shouldSuppress())
								lPreferredActivity = 'ambush';
							
							lBoolReturn = false;
							leaveCoverAndShoot(behaviorCallbacks, lPreferredActivity);
							if(lBoolReturn)
							{
								lNextAllowedSuppressTime = gettime() + randomintrange(3000, 20000);
								// if they're there, we've seen them
								if (isEnemyVisibleFromExposed())
									a.lastEncounterTime = gettime();
								lDone = true;
							}
						}
						break;
					
					case 1:
						lBoolReturn = false;
						tryThrowingGrenade(behaviorCallbacks, enemy);
						if (lBoolReturn)
						{
							lDone = true;
						}
						break;
					}
				}
				if (lDone)
					continue;
				
				//prof_end('cover_notvisible_enemy');
				idle(behaviorCallbacks);
			}
			else
			{
				// nothing to do!
				
				lBoolReturn = false;
				coverReload(behaviorCallbacks, 0.1);
				if (lBoolReturn)
				{
					//prof_end('cover_notvisible_enemy');
					continue;
				}
				
				if (animscripts_utility.isValidEnemy(enemy))
				{
					lBoolReturn = false;
					tryThrowingGrenade(behaviorCallbacks, enemy);
					if (lBoolReturn)
					{
						//prof_end('cover_notvisible_enemy');
						continue;
					}
				}
				
				if (team == 'axis' && animscripts_utility.weaponAnims() != 'rocketlauncher')
				{
					lBoolReturn = false;
					leaveCoverAndShoot(behaviorCallbacks, 'ambush');
					if (lBoolReturn)
					{
						lNextAllowedSuppressTime = gettime() + randomintrange(3000, 20000);
						// if they're there, we've seen them
						if (isEnemyVisibleFromExposed())
							a.lastEncounterTime = gettime();
							
						//prof_end('cover_notvisible_enemy');
						continue;
					}
				}
				
				if (gettime() >= lNextAllowedLookTime)
				{
					lBoolReturn = false;
					lookForEnemy(behaviorCallbacks);
					if (lBoolReturn)
					{
						lNextAllowedLookTime = gettime() + randomintrange(4000, 15000);
						
						// if they're there, we've seen them
						//prof_end('cover_notvisible_enemy');
						continue;
					}
				}
				
				// we're *really* bored right now
				if (gettime() > a.getBoredOfThisNodeTime)
				{
					if (cantFindAnythingToDo())
					{
						//prof_end('cover_notvisible_enemy');
						_return();
					}
				}
				
				if (gettime() >= lNextAllowedSuppressTime && animscripts_utility.isValidEnemy(enemy))
				{
					// be ready to ambush them if they happen to show up
					lBoolReturn = false;
					leaveCoverAndShoot(behaviorCallbacks, 'ambush');
					if (lBoolReturn)
					{
						if (isEnemyVisibleFromExposed())
							resetSeekOutEnemyTime();
						a.lastEncounterTime = gettime();
						lNextAllowedSuppressTime = gettime() + randomintrange(6000, 20000);
						//prof_end('cover_notvisible_enemy');
						continue;
					}
				}
				
				//prof_end('cover_notvisible_enemy');
				idle(behaviorCallbacks);
			}
		}
	}
}
