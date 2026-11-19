class animscripts_cover_wall extends Object within HodAI;

function cover_wall_think(name iCoverType, optional bool newThread = false)
{
	local cover_wall_think task;
	task = new(self) class'cover_wall_think';
	task.iCoverType = iCoverType;
	run (task, newThread);
}

function InitCoverCrouchNode(HodNode iNode)
{
	local vector lCrouchHeightOffset;
	local vector lForward;

	if (ternary_isdefined(iNode.crouchingIsOK))
		return;

	// it's only ok to crouch at this node if we can see out from a crouched position.
	lCrouchHeightOffset = vect(0,0,35)*FInch;
	lForward = anglesToForward(iNode.angles);
	iNode.crouchingIsOK = sightTracePassed(iNode.origin + lCrouchHeightOffset, iNode.origin + lCrouchHeightOffset + vectorScale(lForward, 64*FInch), false, none) ? TernaryTrue : TernaryFalse;
}


function setup_cover_crouch(name iExposedAnimSet)
{
	rightAimLimit = 48;
	leftAimLimit = -48;
	upAimLimit = 45;
	downAimLimit = -45;
	setup_crouching_anim_array(iExposedAnimSet);
}


function setup_cover_stand()
{
	rightAimLimit = 45;
	leftAimLimit = -45;
	upAimLimit = 45;
	downAimLimit = -45;
	setup_standing_anim_array();
}


function CoverReload()
{
	run (new(self) class'cover_wall_CoverReload', false);
}


function LeaveCoverAndShoot()
{
	run (new(self) class'cover_wall_LeaveCoverAndShoot', false);
}


function ShootAsTold(optional bool newThread = false)
{
	run (new(self) class'cover_wall_ShootAsTold', newThread);
}

function ShootUntilShootBehaviorChange_coverWall(optional bool newThread = false)
{
	run (new(self) class'cover_wall_ShootUntilShootBehaviorChange', newThread);
}


function Idle()
{
	run (new(self) class'cover_wall_idle', false);
}

function flinch()
{
	run (new(self) class'cover_wall_flinch', false);
}

function playIdleAnimation(name iIdleAnim, bool iNeedsRestart, optional bool newThread = false)
{
	local cover_wall_playIdleAnimation task;
	task = new(self) class'cover_wall_playIdleAnimation';
	task.iIdleAnim = iIdleAnim;
	task.iNeedsRestart = iNeedsRestart;
	run (task, newThread);
}

function look(float iLookTime)
{
	local cover_wall_look task;
	task = new(self) class'cover_wall_look';
	task.iLookTime = iLookTime;
	run (task, false);
}

function peekOut(optional bool newThread = false)
{
	run (new(self) class'cover_wall_peekout', newThread);
}

function fastLook(optional bool newThread = false)
{
	run (new(self) class'cover_wall_fastlook', newThread);
}


function StandIdleThread(optional bool newThread = false)
{
	run (new(self) class'cover_wall_StandIdleThread', newThread);
}

function endStandIdleThread()
{
	a.standIdleThread = false;
	notify('end_stand_idle_thread');
}

// TODO: need new idles for lean and crouch?
function StandIdleThreadInternal(optional bool newThread = false)
{
	run (new(self) class'cover_wall_StandIdleThreadInternal', newThread);
}


function pop_up(optional bool newThread = false)
{
	run (new(self) class'cover_wall_pop_up', newThread);
}

function DoNoteTracksForPopup(name iAnimName, optional bool newThread = false)
{
	local cover_wall_DoNoteTracksForPopup task;
	task = new(self) class'cover_wall_DoNoteTracksForPopup';
	task.iAnimName = iAnimName;
	run (task, newThread);
}


function setup_additive_aim(float iTransTime)
{
	setAnimKnobAll(animscripts_utility.animArray(name(a.coverMode $ "_aim")), 'body', 1, iTransTime);
	if (a.coverMode == 'crouch')
	{
		setanimlimited('covercrouch_aim_2', 1, 0);
		setanimlimited('covercrouch_aim_4', 1, 0);
		setanimlimited('covercrouch_aim_6', 1, 0);
		setanimlimited('covercrouch_aim_8', 1, 0);
	}
	else if (a.coverMode == 'stand')
	{
		setanimlimited('stand_aim_2', 1, 0);
		setanimlimited('stand_aim_4', 1, 0);
		setanimlimited('stand_aim_6', 1, 0);
		setanimlimited('stand_aim_8', 1, 0);
	}
	else if (a.coverMode == 'lean')
	{
		setanimlimited('stand_aim_2', 1, 0);
		setanimlimited('stand_aim_4', 1, 0);
		setanimlimited('stand_aim_6', 1, 0);
		setanimlimited('stand_aim_8', 1, 0);
		// these don't seem to have 45 degree aiming limits,
		// so i'm using the exposed ones instead
		/*self setanimlimited(%covercrouch_lean_aim2_add,1,0);
		self setanimlimited(%covercrouch_lean_aim4_add,1,0);
		self setanimlimited(%covercrouch_lean_aim6_add,1,0);
		self setanimlimited(%covercrouch_lean_aim8_add,1,0);*/
	}
}


function go_to_hide(optional bool newThread = false)
{
	run (new(self) class'cover_wall_go_to_hide', newThread);
}


function TryThrowingGrenadeStayHidden(HodEntity iThrowAt)
{
	// TODO: check suppression and add rambo grenade support
	tryThrowingGrenade(iThrowAt, true);
}


function TryThrowingGrenade(HodEntity iThrowAt, bool iSafe)
{
//	theanim = undefined;
//	if (isdefined(safe) && safe)
//		theanim = animArrayPickRandom("grenade_safe");
//	else
//		theanim = animArrayPickRandom("grenade_exposed");
//
//	self animMode ("zonly_physics"); // Unlatch the feet
//	self.keepClaimedNodeInGoal = true;
//
//	armOffset = (32,20,64); // needs fixing!
//	threwGrenade = TryGrenade(iThrowAt, theanim);
//
//	self.keepClaimedNodeInGoal = false;
//	return threwGrenade;
}

function blindfire()
{
	run (new(self) class'cover_wall_blindfire', false);
}


//createTurret(posEnt, weaponInfo, weaponModel)
//{
//	turret = spawnTurret("misc_turret", posEnt.origin, weaponInfo);
//	turret.angles = posEnt.angles;
//	turret.aiOwner = self;
//	turret setModel(weaponModel);
//	turret makeTurretUsable();
//	turret setDefaultDropPitch(0);
//
//	if (isDefined(posEnt.leftArc))
//		turret.leftArc = posEnt.leftArc;
//	if (isDefined(posEnt.rightArc))
//		turret.rightArc = posEnt.rightArc;
//	if (isDefined(posEnt.topArc))
//		turret.topArc = posEnt.topArc;
//	if (isDefined(posEnt.bottomArc))
//		turret.bottomArc = posEnt.bottomArc;
//
//	return turret;
//}
//
//deleteIfNotUsed(owner)
//{
//	self endon("death");
//	self endon("being_used");
//
//	wait .1;
//
//	if (isdefined(owner))
//	{
//		assert(!isdefined(owner.a.usingTurret) || owner.a.usingTurret != self);
//		owner notify("turret_use_failed");
//	}
//	self delete();
//}
//
//useSelfPlacedTurret(weaponInfo, weaponModel)
//{
//	turret = self createTurret(self.node.turretInfo, weaponInfo, weaponModel);
//
//	if (self useTurret(turret))
//	{
//		turret thread deleteIfNotUsed(self);
//		if (isdefined(self.turret_function))
//			thread [[ self.turret_function ]](turret);
////		self setAnimKnob(%cover, 0, 0);
//		self waittill ("turret_use_failed"); // generally this won't notify, and we'll just not do any more cover_wall for now
//	}
//	else
//	{
//		turret delete();
//	}
//}
//
//
//useStationaryTurret()
//{
//	assert(isdefined(self.node));
//	assert(isdefined(self.node.turret));
//
//	turret = self.node.turret;
//	if (!turret.isSetup)
//		return;
//
////	turret setmode("auto_ai"); // auto, auto_ai, manual, manual_ai
////	turret startFiring(); // seems to be a bug with the turret being in manual mode to start with
////	wait(1);
//	thread maps\_mg_penetration::gunner_think(turret);
//	self waittill("continue_cover_script");
//
////	turret thread maps\_spawner::restorePitch();
////	self useturret(turret); // dude should be near the mg42
//}


function setup_crouching_anim_array(name exposedAnimSet)
{
	ResetAnimArray();

	SetAnimArray('hide_idle', 'covercrouch_hide_idle');
	SetAnimArray('hide_idle_twitch', 'covercrouch_hide_twitch_v1');
	SetAnimArray('hide_idle_twitch', 'covercrouch_hide_twitch_v2');
	SetAnimArray('hide_idle_twitch', 'covercrouch_hide_twitch_v3');
	SetAnimArray('hide_idle_twitch', 'covercrouch_hide_twitch_v4');

//	anim_array["hide_idle_flinch"] = array(
//		/*%covercrouch_explosion_1,
//		%covercrouch_explosion_2,
//		%covercrouch_explosion_3*/ // these just don't look good for flinching
//	);

	SetAnimArray('hide_2_crouch', 'covercrouch_hide_2_aim');
	SetAnimArray('hide_2_stand', 'covercrouch_hide_2_stand');
	SetAnimArray('hide_2_lean', 'covercrouch_hide_2_lean');

	SetAnimArray('crouch_2_hide', 'covercrouch_aim_2_hide');
	SetAnimArray('stand_2_hide', 'covercrouch_stand_2_hide');
	SetAnimArray('lean_2_hide', 'covercrouch_lean_2_hide');

	SetAnimArray('crouch_aim', 'covercrouch_aim');
	SetAnimArray('stand_aim', 'stand_aim');
	SetAnimArray('lean_aim', 'covercrouch_lean');

	SetAnimArray('fire', 'stand_fire_auto');
	SetAnimArray('semi2', 'stand_fire_semi2');
	SetAnimArray('semi3', 'stand_fire_semi3');
	SetAnimArray('semi4', 'stand_fire_semi4');
	SetAnimArray('semi5', 'stand_fire_semi5');

	if (animscripts_utility.usingShotgun())
	{
		if (exposedAnimSet == 'lean' || exposedAnimSet == 'stand')
			SetAnimArray('single', 'shotgun_stand_fire_1A');
		else
			SetAnimArray('single', 'shotgun_crouch_fire');
	}
	else
	{
		SetAnimArray('single', 'stand_fire_single');
	}

	SetAnimArray('burst2', 'stand_fire_burst3'); // (will be limited to 2 shots)
	SetAnimArray('burst3', 'stand_fire_burst3');
	SetAnimArray('burst4', 'stand_fire_burst4');
	SetAnimArray('burst5', 'stand_fire_burst5');
	SetAnimArray('burst6', 'stand_fire_burst6');

	SetAnimArray('blind_fire', 'covercrouch_blindfire_v1');
	SetAnimArray('blind_fire', 'covercrouch_blindfire_v2');
	SetAnimArray('blind_fire', 'covercrouch_blindfire_v3');
	SetAnimArray('blind_fire', 'covercrouch_blindfire_v4');

	SetAnimArray('reload', 'covercrouch_reload');

	SetAnimArray('grenade_safe', 'covercrouch_grenade_v1');
	SetAnimArray('grenade_safe', 'covercrouch_grenade_v2');
	SetAnimArray('grenade_exposed', 'covercrouch_grenade_v1');
	SetAnimArray('grenade_exposed', 'covercrouch_grenade_v2');

	SetAnimArray('exposed_idle', 'stand_idle_v1');
	SetAnimArray('exposed_idle', 'stand_idle_v2');
	SetAnimArray('exposed_idle', 'stand_idle_v3');

	SetAnimArray('look', 'covercrouch_look');
}


function setup_standing_anim_array()
{
	ResetAnimArray();

	SetAnimArray('hide_idle', 'coverstand_hide_idle');
	SetAnimArray('hide_idle_twitch', 'coverstand_hide_twitch_v1');
	SetAnimArray('hide_idle_twitch', 'coverstand_hide_twitch_v2');
	SetAnimArray('hide_idle_twitch', 'coverstand_hide_twitch_v3');
	SetAnimArray('hide_idle_twitch', 'coverstand_hide_twitch_v4');
	SetAnimArray('hide_idle_twitch', 'coverstand_hide_twitch_v5');

	SetAnimArray('hide_idle_flinch', 'coverstand_hide_flinch_v1');
	SetAnimArray('hide_idle_flinch', 'coverstand_hide_flinch_v2');
	SetAnimArray('hide_idle_flinch', 'coverstand_hide_flinch_v3');
	SetAnimArray('hide_idle_flinch', 'coverstand_hide_flinch_v4');

	SetAnimArray('hide_2_stand', 'coverstand_hide_2_aim');
	SetAnimArray('stand_2_hide', 'coverstand_aim_2_hide');

	SetAnimArray('stand_aim', 'stand_aim');

	SetAnimArray('fire', 'stand_fire_auto');
	SetAnimArray('semi2', 'stand_fire_semi2');
	SetAnimArray('semi3', 'stand_fire_semi3');
	SetAnimArray('semi4', 'stand_fire_semi4');
	SetAnimArray('semi5', 'stand_fire_semi5');

//	if (self usingShotgun())
//		SetAnimArray('single', 'shotgun_stand_fire_1A'));
//	else
	SetAnimArray('single', 'stand_fire_single');

	SetAnimArray('burst2', 'stand_fire_burst3'); // (will be limited to 2 shots)
	SetAnimArray('burst3', 'stand_fire_burst3');
	SetAnimArray('burst4', 'stand_fire_burst4');
	SetAnimArray('burst5', 'stand_fire_burst5');
	SetAnimArray('burst6', 'stand_fire_burst6');

	SetAnimArray('blind_fire', 'coverstand_blindfire_v1'); // #3 looks silly
	SetAnimArray('blind_fire', 'coverstand_blindfire_v2'); // #3 looks silly

	SetAnimArray('reload', 'coverstand_reload');

	SetAnimArray('look', 'coverstand_look_v1');
	SetAnimArray('look', 'coverstand_look_v2');

	SetAnimArray('grenade_safe', 'coverstand_grenadeA');
	SetAnimArray('grenade_safe', 'coverstand_grenadeB');
	SetAnimArray('grenade_exposed', 'coverstand_grenadeA');
	SetAnimArray('grenade_exposed', 'coverstand_grenadeB');

	SetAnimArray('exposed_idle', 'stand_idle_v1');
	SetAnimArray('exposed_idle', 'stand_idle_v2');
	SetAnimArray('exposed_idle', 'stand_idle_v3');

	SetAnimArray('hide_to_look', 'coverstand_hide_2_look');
	SetAnimArray('look_idle', 'coverstand_look_idle');
	SetAnimArray('look_to_hide', 'coverstand_look_2_hide');
	SetAnimArray('look_to_hide_fast', 'coverstand_look_2_hide_fast');
}


function LoopHide(optional float iTransTime = 0.1)
{
	//if (!isdefined(iTransTime))
	//	iTransTime = .1;

	setanimknoballrestart(SetCustomAnim(misc_modern, animscripts_utility.animArray('hide_idle')), 'body', 1, iTransTime);
	a.coverMode = 'hide';
}


function AngleRangeThread(optional bool newThread = false)
{
	run (new(self) class'cover_wall_AngleRangeThread', newThread);
}


function bool NeedToChangeCoverMode()
{
	local float lPitch;

	if (coverType != 'crouch')
		return false;

	lPitch = getShootPosPitch(getEye());

	if (a.coverMode == 'lean')
	{
		return lPitch < 10;
	}
	else
	{
		return abs(lPitch) > 45;
	}
}


function name GetBestCoverMode()
{
	local float lPitch;

	if (coverType != 'crouch')
		return 'stand';

	lPitch = getShootPosPitch(coverNode.origin + animscripts_utility.getNodeOffset(coverNode));

	if (a.atConcealmentNode)
	{
		if (lPitch > 30)
			return 'lean';
		if (lPitch > 10 || coverNode.crouchingIsOK == TernaryFalse)
			return 'stand';
		return 'crouch';
	}
	else
	{
		if (lPitch > 20)
			return 'lean';
		if (lPitch > 0 || coverNode.crouchingIsOK == TernaryFalse)
			return 'stand';
		return 'crouch';
	}
}

function float GetShootPosPitch(vector iFromPos)
{
	local vector lShootPos;
	lShootPos = animscripts_utility.getEnemyEyePos();

	return AngleClamp180(vectorToAngles(lShootPos - iFromPos).pitch);
}
