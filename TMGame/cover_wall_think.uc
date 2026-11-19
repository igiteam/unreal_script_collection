class cover_wall_think extends CoreTask within animscripts_cover_wall;

// parameter
var name iCoverType;

// output

// local
var name lTransAnim;
var float lTime;
var cover_behavior_callback behaviorCallbacks;

state main
{
Begin:
	endon('killanimscript');

    coverNode.set(node.data);
    coverType = iCoverType;
    
    if (iCoverType == 'crouch')
    {
		setup_cover_crouch('unknown');
		initCoverCrouchNode(coverNode);
	}
	else
	{
		setup_cover_stand();
	}

	a.standIdleThread = false;

	// face the direction of our covernode
	OrientMode('face angle', coverNode.angles.yaw);	

////	if (isDefined(self.a.arrivalType) && (self.a.arrivalType == 'stand_saw' || self.a.arrivalType == 'crouch_saw'))
//	if ((self.weapon == 'saw' || self.weapon == 'rpd') && isDefined(self.node.turretInfo) && canspawnturret())
//	{
//		assert(isDefined(self.node.turretInfo));
//		assert(self.weapon == 'saw' || self.weapon == 'rpd');
//
////		if (self.a.arrivalType == 'crouch_saw')
//		if (iCoverType == 'crouch')
//			weaponInfo = self.weapon + '_bipod_crouch';
//		else
//			weaponInfo = self.weapon + '_bipod_stand'; 
//			
//		if (self.weapon == 'saw')
//			weaponModel = 'weapon_saw_MG_Setup';
//		else
//			weaponModel = 'weapon_rpd_MG_Setup';
//
//		self useSelfPlacedTurret(weaponInfo, weaponModel);
//	}
//	else if (isDefined(self.node.turret))
//	{
//		self useStationaryTurret();
//	}
	
	animmode('none');
	
	//start in hide position
	if (iCoverType == 'crouch' && a.pose == 'stand')
	{
		lTransAnim = SetCustomAnim(misc_modern, animscripts_utility.animArray('stand_2_hide'));
		lTime = getAnimLength(lTransAnim);
		setAnimKnobAllRestart(lTransAnim, 'body', 1, 0.2);
		animscripts_shared.moveToOriginOverTime(coverNode.origin, lTime, true);
		wait (lTime);
		a.coverMode = 'hide';
	}
	else
	{
		loopHide(0.4); // need to transition to hide here in case we didn't do an approach
		animscripts_shared.moveToOriginOverTime(coverNode.origin, 0.4, true);
		wait (0.2);
		if (iCoverType == 'crouch')
			a.pose = 'crouch';
		wait (0.2);
	}

	animmode('zonly_physics');

	if (iCoverType == 'crouch')
	{
		if (a.pose == 'prone')
			animscripts_utility.ExitProneWrapper(1);
		a.pose = 'crouch'; // in case we only lerped into the pose
	}

	if (coverType == 'stand')
		a.special = 'cover_stand';
	else
		a.special = 'cover_crouch';
	
	behaviorCallbacks.reload				= cover_wall_CBCreload;
	behaviorCallbacks.leaveCoverAndShoot	= cover_wall_CBCleaveCoverAndShoot;
	behaviorCallbacks.look					= cover_wall_CBClook;
	behaviorCallbacks.fastlook				= cover_wall_CBCfastlook;
	behaviorCallbacks.idle					= cover_wall_CBCidle;
	behaviorCallbacks.flinch				= cover_wall_CBCflinch;
	behaviorCallbacks.grenade				= cover_wall_CBCgrenade;
	behaviorCallbacks.grenadehidden			= cover_wall_CBCgrenadehidden;
	behaviorCallbacks.blindfire				= cover_wall_CBCblindfire;
	animscripts_cover_behavior.main(behaviorCallbacks);
}
