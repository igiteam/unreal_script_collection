class melee_MeleeCombat extends CoreTask within animscripts_melee;

// parameter

// output

// local
var bool lPrepareToMelee;
var name lNote;
var bool lRealMelee;
var float lOldhealth;

function OnNotify(name note, CoreNotify data)
{
	switch (note)
	{
	case 'meleeanim':
		lNote = CoreAnimNotify(data).data;
		break;

	default: break;
	}
}

function OnReturn(CoreTask task)
{
	if (task.IsA('melee_PrepareToMelee'))
		lPrepareToMelee = true;
}

state main
{
Begin:
////  self trackScriptState('melee', changeReason);
	//notify('killanimscript');
	endon('killanimscript');
	notify('melee');
////	self endon(anim.scriptChange);

	assert(CanMeleeAnyRange());
	
//	// AI vs AI melee disabled for now.
//	//doingAiMelee = (isAI(self.enemy) && self.enemy.type == 'human');
//	doingAiMelee = false;
//	
//	if (doingAiMelee)
//	{
//		assert(animscripts\utility::okToMelee(self.enemy));
//		animscripts\utility::IAmMeleeing(self.enemy);
//		
//		AiVsAiMeleeCombat();
//		
//		animscripts\utility::ImNotMeleeing(self.enemy);
//		
//		scriptChange();
//		return;
//	}
	
	lRealMelee = true;

	if (animscripts_utility.okToMelee(enemy))
		animscripts_utility.IAmMeleeing(enemy);
	else
		lRealMelee = false;

//	self thread EyesAtEnemy();
	OrientMode('face enemy');
	
//	MeleeDebugPrint('Melee begin');
	
	animMode('zonly_physics');
	
	resetGiveUpTime();
	
	while (true)
    {
		// first, charge forward if we need to; get into place to play the melee animation
		lPrepareToMelee = false;
		PrepareToMelee();
		if (!lPrepareToMelee)
		{
			// if we couldn't get in place to melee, don't melee.
			// remember that we couldn't get in place so that we don't try again for a while.
			lastMeleeGiveUpTime = gettime();
			break;
		}
		assert(a.pose == 'stand');
		
//		MeleeDebugPrint('Melee main loop' + randomint(100));
		
		// we should now be close enough to melee.
		
		// If no one else is meleeing this person, tell the system that I am, so no one else will charge him.
		if (!lRealMelee && animscripts_utility.okToMelee(enemy))
		{
			lRealMelee = true;
			animscripts_utility.IAmMeleeing(enemy);
		}

//		self thread EyesAtEnemy();
//		
//		self animscripts\battleChatter_ai::evaluateMeleeEvent();

		// TODO: we should use enemypose to play crouching melee anims when necessary.
		/*player = anim.player;
		if (self.enemy == player)
		{
			enemypose = player getstance();
		}
		else
		{
			enemypose = self.enemy.a.pose;
		}*/
		
		OrientMode('face current');
		
		setflaggedanimknoballrestart('meleeanim', SetCustomAnim(misc_modern, 'melee', 1.5), 'body', 1, 0.2, 1);
		
		while (true)
		{
			waittill('meleeanim');
			if (lNote == 'end')
				break;
			else if (lNote == 'fire')
			{
				lOldhealth = enemy.health;
				melee();
				if (enemy.health < lOldhealth)
					resetGiveUpTime();
			}
			else if (lNote == 'stop')
			{
				// check if it's worth continuing with another melee.
				if (!CanContinueToMelee()) // 'if we can't melee without charging'
					break;
			}
		}
		
		OrientMode('face enemy');
    }
	
	if (lRealMelee)
	{
		animscripts_utility.ImNotMeleeing(enemy);
	}
	
	animMode('none');
	
	goto_state('exposed');
	//animscripts_combat.main(true);
	notify ('stop EyesAtEnemy');
	notify ('stop_melee_debug_print');
	animscripts_utility.scriptChange();
}
