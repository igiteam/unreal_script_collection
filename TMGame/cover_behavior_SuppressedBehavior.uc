class cover_behavior_SuppressedBehavior extends BoolTask within animscripts_cover_behavior;

// parameter
var cover_behavior_callback behaviorCallbacks;

// output

// local
var float lNextAllowedBlindfireTime;
var bool lJustLooked;
var bool lCanThrowGrenade;
var array<int> lPermutation;
var bool lDone;
var int i;

var bool lBoolReturn;

function OnReturn(CoreTask Task)
{
	if (Task.IsA('BoolTask'))
		lBoolReturn = true;
}

state main
{
Begin:
	if (!animscripts_utility.isSuppressedWrapper())
		_return (false);
	
	lNextAllowedBlindfireTime = gettime();
	
	lJustLooked = true;
	
	//prof_begin('suppressedBehavior');
	
	while (animscripts_utility.isSuppressedWrapper())
	{
		lJustLooked = false;

		teleport(coverNode.origin);
		
		if (tryToGetOutOfDangerousSituation())
		{
			notify('killanimscript');
			//prof_end('suppressedBehavior');
			_return (true);
		}
		
		lCanThrowGrenade = isEnemyVisibleFromExposed() || animscripts_utility.canSuppressEnemyFromExposed();
		
		
		// if we're only at a concealment node, and it's not providing cover, we shouldn't try to use the cover to keep us safe!
		if (a.atConcealmentNode && animscripts_utility.canSeeEnemy())
		{
			//prof_end('suppressedBehavior');
			_return (false);
		}
		
		
		if (lCanThrowGrenade && anim.throwGrenadeAtPlayerASAP && team == 'axis' && isAlive(level.player))
		{
			lBoolReturn = false;
			tryThrowingGrenade(behaviorCallbacks, level.player);
			if (lBoolReturn)
				continue;
		}


		lBoolReturn = false;
		coverReload(behaviorCallbacks, 0);
		if (lBoolReturn)
			continue;
		
		
		// randomize the order of trying the following options
		getPermutation(2, lPermutation);
		lDone = false;
		for (i = 0; i < lPermutation.length && !lDone; i++)
		{
			switch(i)
			{
			case 0:
				if (team != 'allies' && gettime() >= lNextAllowedBlindfireTime)
				{
					lBoolReturn = false;
					blindfire(behaviorCallbacks);
					if (lBoolReturn)
					{
						lNextAllowedBlindfireTime = gettime() + randomintrange(3000, 12000);
						lDone = true;
					}
				}
				break;
				
			case 1:
				if (lCanThrowGrenade)
				{
					lBoolReturn = false;
					tryThrowingGrenade(behaviorCallbacks, enemy);
					if (lBoolReturn)
					{
						lJustLooked = true;
						lDone = true;
					}
				}
				break;
			}
		}
		if (lDone)
			continue;
		
		
		lBoolReturn = false;
		coverReload(behaviorCallbacks, 0.1);
		if (lBoolReturn)
			continue;
		
		//prof_end('suppressedBehavior');
		idle(behaviorCallbacks);
	}
	
	if (!lJustLooked && randomint(2) == 0)
		lookfast(behaviorCallbacks);
	
	//prof_end('suppressedBehavior');
	_return (true);
}
