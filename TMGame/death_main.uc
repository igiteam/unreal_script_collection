class death_main extends CoreTask within animscripts_death;


// parameter

// output

// local
var bool lExplosiveDamage;

state main
{
Begin:
	trackScriptState('Death Main', "code");
	endon('killanimscript');
//	self stopsounds();
	// don't abort at this point unless you're going to play another animation!
	// just playing ragdoll isn't sufficient because sometimes ragdoll fails, and then
	// you'll just have a corpse standing around in limbo.

	if (a.nodeath == true)
		_return();

	if (deathFunction != none)
	{
		deathFunction.Execute();
		_return();
	}

	// make sure the guy doesn't keep doing facial animation after death
//	changeTime = 0.3;
//	self clearanim('scripted_look_straight',		changeTime);
//	self clearanim('scripted_talking',				changeTime);

	animscripts_utility.initialize('death');

	// Stop any lookats that are happening and make sure no new ones occur while death animation is playing.
	notify ('never look at anything again');

	// should move this to squad manager somewhere...
//	removeSelfFrom_SquadLastSeenEnemyPos(self.origin);

	anim.numDeathsUntilCrawlingPain--;
	anim.numDeathsUntilCornerGrenadeDeath--;

	if (isDefined(deathanim))
	{
		//thread [[anim.println]]('Playing special death as set by self.deathanim');#/
		SetFlaggedAnimKnobAll('deathanim', SetCustomAnim(misc_modern, deathanim), 'root', 1, 0.05, 1);
		animscripts_shared.DoNoteTracks('deathanim');
		if (isDefined(deathanimloop))
		{
			// 'Playing special dead/wounded loop animation as set by self.deathanimloop');#/
			SetFlaggedAnimKnobAll('deathanim', SetCustomAnim(misc_modern, deathanimloop), 'root', 1, 0.05, 1);
			while (true)
			{
				animscripts_shared.DoNoteTracks('deathanim');
			}
		}

		// Added so that I can do special stuff in Level scripts on an ai
		if (deathanimscript != none)
			deathanimscript.Execute();
		_return();
	}

	lExplosiveDamage = animscripts_pain.wasDamagedByExplosive();

//	if (self.damageLocation == 'helmet')
//		self helmetPop();
//	else if (lExplosiveDamage && randomint(3) == 0)
//		self helmetPop();

	clearanim('root', 0.3);
	//self thread animscripts\pain::PlayHitAnimation();

	if (!animscripts_utility.damageLocationIsAny('head', 'helmet'))
	{
		if (dieQuietly)
		{
			// replace with actual die quietly gurglesque sound
////			if (randomint(3) < 2)
////				self animscripts\face::SayGenericDialogue('pain');
		}
		else
		{
//			PlayDeathSound();
		}
	}
//	//deathFace = animscripts\face::ChooseAnimFromSet(anim.deathFace);
//	//self animscripts\face::SaySpecificDialogue(deathFace, undefined, 1.0);

	if (lExplosiveDamage && damageTaken > 240 && playExplodeDeathAnim())
		_return();

	if (specialDeath())
		_return();

	playDeathAnim(getDeathAnim());
}
