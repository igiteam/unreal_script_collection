class shoot_DecideWhatAndHowToShoot extends CoreTask within animscripts_shoot_behavior;

// parameter
var name objective;

// output

// local
var bool atCover;
var HodEntity prevShootEnt;
var vector prevShootPos;
var name prevShootStyle;
var name result;

state main
{
Begin:
	endon('killanimscript');
	notify('stop_deciding_how_to_shoot'); // just in case...
	endon('stop_deciding_how_to_shoot');
	endon('death');
	
	assert(isdefined(objective)); // just use 'normal' if you don't know what to use
	
	maps__gameskill.resetMissTime();
	shootObjective = objective;
	// self.shootObjective is always 'normal', 'suppress', or 'ambush'
	
	shootEnt = none;
	shootPos = invalid_vector;
	shootStyle = 'none';
	fastBurst = false;
	shouldReturnToCover = false;
	
//	if (!isdefined(self.changingCoverPos))
//		self.changingCoverPos = false;
	
	atCover = node_isdefined(coverNode) && coverNode.type != 'Cover Prone' && coverNode.type != 'Conceal Prone';
	
	if (atCover)
	{
		// it's not safe to do some things until the next frame,
		// such as canSuppressEnemy(), which may change the state of
		// self.goodShootPosValid, which will screw up cover_behavior::main
		// when this is called but then stopped immediately.
		wait (0.05);
	}
	
	prevShootEnt = shootEnt;
	prevShootPos = shootPos;
	prevShootStyle = shootStyle;
	
//	if (isdefined(self.has_ir))
//	{
//		self.a.laserOn = true;
//		self animscripts\shared::updateLaserStatus();
//	}
	
	if (animscripts_combat_utility.isSniper())
		resetSniperAim(true);
	
	// only watch for incoming fire if it will be beneficial for us to return to cover when shot at.
	if (atCover && (!a.atConcealmentNode || !animscripts_utility.canSeeEnemy()))
		watchForIncomingFire(true);
	runOnShootBehaviorEnd(true);

	ambushEndTime = invalid_time;
	
//	prof_begin('decideWhatAndHowToShoot');

	while (true)
	{
		assert(shootObjective == 'normal' || shootObjective == 'suppress' || shootObjective == 'ambush');
//		assert(!isdefined(self.shootEnt) || isdefined(self.shootPos)); // shootPos must be shootEnt's shootAtPos if shootEnt is defined, for convenience elsewhere
		
		result = '';
		if (weapon == 'none')
			noGunShoot();
		else if (animscripts_utility.weaponAnims() == 'rocketlauncher')
			result = rpgShoot();
		else if (animscripts_utility.usingSidearm())
			result = pistolShoot();
		else if (animscripts_combat_utility.IsSniperRifle(weapon))
			result = SniperShoot();
		else
			result = rifleShoot();
		
		
		//if (checkChanged(prevShootEnt, self.shootEnt) || (!isdefined(self.shootEnt) && checkChanged(prevShootPos, self.shootPos)) || checkChanged(prevShootStyle, self.shootStyle))
		if ((obj_isdefined(prevShootEnt) != obj_isdefined(shootEnt) || (obj_isdefined(shootEnt) && shootEnt != prevShootEnt)) ||
			(!obj_isdefined(shootEnt) && (vec_isdefined(prevShootPos) != vec_isdefined(shootPos) || (vec_isdefined(shootPos) && shootPos != prevShootPos))) ||
			(isdefined(prevShootStyle) != isdefined(shootStyle) || (isdefined(shootStyle) && shootStyle != prevShootStyle))
			)
			notify('shoot_behavior_change');
		prevShootEnt = shootEnt;
		prevShootPos = shootPos;
		prevShootStyle = shootStyle;
		
		
		// (trying to prevent many AI from doing lots of work on the same frame)
		if (!isdefined(result))
			WaitABit();
	}
	
//	prof_end('decideWhatAndHowToShoot');
}
