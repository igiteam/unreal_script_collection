class pain_main extends CoreTask within animscripts_pain;

// parameter

// output

// local

state main
{
Begin:
	setflashbanged(false);
	
	if (longDeathStarting)
	{
		// important that we don't run any other animscripts.
		waittill('killanimscript');
		_return();
	}

	if (anim.pain_test.execute(outer.outer))
		_return();	
	if (a.disablePain)
		_return();
	
	notify('kill_long_death');
	
	a.painTime = gettime();
	
	if (a.nextStandingHitDying)
		health = 1;

//	dead = false;
//	stumble = false;
	
//	ratio = self.health / self.maxHealth;
	
////	println ('hit at ' + self.damagelocation);
	
    trackScriptState('Pain Main', "code");
    notify ('anim entered pain');
	endon('killanimscript');

	// Two pain animations are played.  One is a longer, detailed animation with little to do with the actual 
	// location and direction of the shot, but depends on what pose the character starts in.  The other is a 
	// 'hit' animation that is very location-specific, but is just a single pose for the affected bones so it 
	// can be played easily whichever position the character is in.
    animscripts_utility.initialize('pain');
    
    animmode('gravity');
	
	//thread [[anim.println]] ('Shot in '+self.damageLocation+' from '+self.damageYaw+' for '+self.damageTaken+' hit points');#/
	
//	self animscripts\face::SayGenericDialogue('pain');
	
//	if (damageLocation == 'helmet')
//		animscripts_death.helmetPop();
//	else if (wasDamagedByExplosive() && randomint(2) == 0)
//		animscripts_death.helmetPop();

//	// corner grenade death takes priority over crawling pain
//	/#
//	if (getDvarInt('scr_forceCornerGrenadeDeath') == 1)
//	{
//		if (self TryCornerRightGrenadeDeath())
//			return;
//	}
//	#/
//	if (self.a.special == 'corner_right_mode_b' && TryCornerRightGrenadeDeath())
//		return;
//	
//	if (crawlingPain())
//		return;
	
	if (specialPain(a.special))
		_return();
	// if we didn't handle self.a.special, we can't rely on it being accurate after the pain animation we're about to play.
	a.special = 'none';

	//self thread PlayHitAnimation();

	playPainAnim(getPainAnim());
}
