class animscripts_combat extends Object within HodAI;

function main(optional bool newThread = false)
{
	run(new(self) class'combat_main', newThread);
}

///#
//testAnims()
//{
//	testanims = [];
//
//	/*testanims[testanims.size] = %exposed_dive_grenade_F;
//	testanims[testanims.size] = %exposed_dive_grenade_B;
//	testanims[testanims.size] = %exposed_squat_down_grenade_F;
//	testanims[testanims.size] = %exposed_squat_idle_grenade_F;
//	testanims[testanims.size] = %exposed_squat_up_grenade_F;
//	testanims[testanims.size] = %cornerR_stand_explosion_divedown;
//	testanims[testanims.size] = %cornerR_stand_explosion_idle;
//	testanims[testanims.size] = %cornerR_stand_explosion_standup;
//	testanims[testanims.size] = %cornerL_stand_explosion;
//	testanims[testanims.size] = %cornerL_stand_explosion_B;
//	
//	testanims[testanims.size] = %coverstand_hide_explosion_F;
//	testanims[testanims.size] = %coverstand_hide_explosion_B;
//	
//	testanims[testanims.size] = %covercrouch_explosion_1;
//	testanims[testanims.size] = %covercrouch_explosion_2;
//	testanims[testanims.size] = %covercrouch_explosion_3;
//	
//	testanims[testanims.size] = %hunted_dive_2_pronehide_v1;
//	testanims[testanims.size] = %hunted_dive_2_pronehide_v2;
//	testanims[testanims.size] = %hunted_dive_2_pronehide_v3;
//	testanims[testanims.size] = %hunted_pronehide_2_stand_v1;
//	testanims[testanims.size] = %hunted_pronehide_2_stand_v2;
//	testanims[testanims.size] = %hunted_pronehide_2_stand_v3;
//	testanims[testanims.size] = %hunted_pronehide_idle_v1;
//	testanims[testanims.size] = %hunted_pronehide_idle_v2;
//	testanims[testanims.size] = %hunted_pronehide_idle_v3;*/
//		
//	/*testanims[testanims.size] = %coverstand_react01;
//	testanims[testanims.size] = %coverstand_react02;
//	testanims[testanims.size] = %coverstand_react03;
//	testanims[testanims.size] = %coverstand_react04;*/
//
//	self animmode('zonly_physics');
//	self orientMode('face current');
//	
//	for (i = 0; i < testanims.size; i++)
//	{
//		println(testanims[i]);
//		self thread printAnimDebugLn(i);
//		//thread lineUntilNotify(self.origin, self.origin + anglesToForward(self.angles)*32);
//		
//		self setFlaggedAnimKnobAllRestart('animtest', testanims[i], %root, 1, 0, 1);
//		self waittillmatch('animtest', 'end');
//		level notify('stopline');
//	}
//}
//
//printAnimDebugLn(text)
//{
//	level endon('stopline');
//	pos = self.origin + (0,0,-20);
//	while(1)
//	{
//		print3d(pos, text);
//		wait .05;
//	}
//}
//
//lineUntilNotify(a,b)
//{
//	level endon('stopline');
//	while(1)
//	{
//		line(a,b);
//		wait .05;
//	}
//}
//#/
//
//
///#
//testGrenadeThrowAnimOffsets()
//{
//	testanims = [];
//	testanims[0] = %exposed_grenadeThrowB;
//	testanims[1] = %exposed_grenadeThrowC;
//	testanims[2] = %cornerL_stand_grenade_A;
//	testanims[3] = %cornerL_stand_grenade_B;
//	testanims[4] = %cornerL_crouch_grenadeA;
//	testanims[5] = %cornerL_crouch_grenadeB;
//	testanims[6] = %cornerR_stand_grenade_A;
//	testanims[7] = %cornerR_stand_grenade_B;
//	testanims[8] = %cornerR_crouch_grenadeA;
//	testanims[9] = %covercrouch_grenadeA;
//	testanims[10] = %covercrouch_grenadeB;
//	testanims[11] = %coverstand_grenadeA;
//	testanims[12] = %coverstand_grenadeB;
//	testanims[13] = %prone_grenade_A;
//	
//	model = getGrenadeModel();
//	
//	self animmode('zonly_physics');
//	for (i = 0; i < testanims.size; i++)
//	{
//		forward = anglestoforward(self.angles);
//		right   = anglestoright(self.angles);
//		startpos = self.origin;
//		
//		tag = 'TAG_INHAND';
//		
//		self setFlaggedAnimKnobAllRestart('grenadetest', testanims[i], %root, 1, 0, 1);
//		for (;;)
//		{
//			self waittill('grenadetest', notetrack);
//			if (notetrack == 'grenade_left' || notetrack == 'grenade_right')
//				self attach (model, tag);
//			if (notetrack == 'grenade_throw' || notetrack == 'grenade throw')
//				break;
//			assert(notetrack != 'end'); // we shouldn't hit 'end' until after we've hit 'grenade_throw'!
//			if (notetrack == 'end') // failsafe
//				break;
//		}
//		
//		pos = self getTagOrigin(tag);
//		baseoffset = pos - startpos;
//		
//		offset = (vectordot(baseoffset, forward), -1 * vectordot(baseoffset, right), baseoffset[2]);
//		
//		// check our answer =)
//		endpos = startpos + forward * offset[0] - right * offset[1] + (0,0,1) * offset[2];
//		thread debugLine(startpos, endpos, (1,1,1), 20);
//		
//		//println('^2Grenade throw anim #' + i + ' (', testanims[i], '): offset = ' + pos);
//		println('else if (throwAnim == %', testanims[i], ') offset = ', offset, ';');
//		
//		self detach(model, tag);
//		
//		wait 1;
//	}
//}
//#/

function IdleThread(optional bool newThread = false)
{
	run (new(self) class'combat_IdleThread', newThread);
}

// SETUP FUNCTIONS
function setup(optional bool newThread = false)
{
	run (new(self) class'combat_setup', newThread);
}

function StopShortly(optional bool newThread = false)
{
	run (new(self) class'combat_StopShortly', newThread);
}

function SetupAim(float transTime)
{
	setAnimKnobLimited(animscripts_utility.AnimArray('add_aim_up'  ), 1, transTime);
	setAnimKnobLimited(animscripts_utility.AnimArray('add_aim_down'), 1, transTime);
	setAnimKnobLimited(animscripts_utility.AnimArray('add_aim_left'), 1, transTime);
	setAnimKnobLimited(animscripts_utility.AnimArray('add_aim_right'), 1, transTime);
}

function set_animarray_standing()
{
	ResetAnimArray();

	if (animscripts_utility.usingSidearm())
	{
	//	self.a.array['add_aim_up'] = %pistol_stand_aim_8_add;
	//	self.a.array['add_aim_down'] = %pistol_stand_aim_2_add;
	//	self.a.array['add_aim_left'] = %pistol_stand_aim_4_add;
	//	self.a.array['add_aim_right'] = %pistol_stand_aim_6_add;  
	//
	//	self.a.array['straight_level'] = %pistol_stand_aim_5;
	//	self.a.array['fire'] = %pistol_stand_fire_A;

	//	self.a.array['single'] = array(%pistol_stand_fire_A);

	//	self.a.array['reload'] = array(%pistol_stand_reload_A);
	//	self.a.array['reload_crouchhide'] = array();

	//	self.a.array['exposed_idle'] = array(%exposed_idle_hide_v1, %exposed_idle_hide_v2, %exposed_idle_hide_v3);
	//	
	//	self.a.array['turn_left_45'] = %pistol_stand_turn45L;
	//	self.a.array['turn_left_90'] = %pistol_stand_turn90L;
	//	self.a.array['turn_left_135'] = %exposed_tracking_turn135L;
	//	self.a.array['turn_left_180'] = %pistol_stand_turn180L;
	//	self.a.array['turn_right_45'] = %pistol_stand_turn45R;
	//	self.a.array['turn_right_90'] = %pistol_stand_turn90R;
	//	self.a.array['turn_right_135'] = %exposed_tracking_turn135R;
	//	self.a.array['turn_right_180'] = %pistol_stand_turn180L;
	//
	//	self.a.array['add_turn_aim_up'] = %pistol_stand_aim_8_alt;
	//	self.a.array['add_turn_aim_down'] = %pistol_stand_aim_2_alt;
	//	self.a.array['add_turn_aim_left'] = %pistol_stand_aim_4_alt;
	//	self.a.array['add_turn_aim_right'] = %pistol_stand_aim_6_alt;
	}
	else if (animscripts_utility.weaponAnims() == 'rocketlauncher')
	{
	//	self.a.array['add_aim_up'] = %RPG_stand_aim_8;
	//	self.a.array['add_aim_down'] = %RPG_stand_aim_2;
	//	self.a.array['add_aim_left'] = %RPG_stand_aim_4;
	//	self.a.array['add_aim_right'] = %RPG_stand_aim_6;  

	//	self.a.array['fire'] = %RPG_stand_fire;
	//	self.a.array['straight_level'] = %RPG_stand_aim_5;
	//	self.a.array['reload'] = array(%RPG_stand_reload);
	//	self.a.array['reload_crouchhide'] = array();

	//	self.a.array['exposed_idle'] = array(%RPG_stand_idle);
	//	
	//	self.a.array['single'] = array(%exposed_shoot_semi1);
	//	
	//	self.a.array['crouch_2_stand'] = %exposed_crouch_2_stand;
	//	self.a.array['crouch_2_prone'] = %crouch_2_prone;
	//	self.a.array['stand_2_crouch'] = %exposed_stand_2_crouch;
	//	self.a.array['stand_2_prone'] = %stand_2_prone;
	//	self.a.array['prone_2_crouch'] = %prone_2_crouch;
	//	self.a.array['prone_2_stand'] = %prone_2_stand;

	//	self.a.array['turn_left_45'] = %exposed_tracking_turn45L;
	//	self.a.array['turn_left_90'] = %exposed_tracking_turn90L;
	//	self.a.array['turn_left_135'] = %exposed_tracking_turn135L;
	//	self.a.array['turn_left_180'] = %exposed_tracking_turn180L;
	//	self.a.array['turn_right_45'] = %exposed_tracking_turn45R;
	//	self.a.array['turn_right_90'] = %exposed_tracking_turn90R;
	//	self.a.array['turn_right_135'] = %exposed_tracking_turn135R;
	//	self.a.array['turn_right_180'] = %exposed_tracking_turn180L;		

	//	self.a.array['add_turn_aim_up'] = %exposed_turn_aim_8;
	//	self.a.array['add_turn_aim_down'] = %exposed_turn_aim_2;
	//	self.a.array['add_turn_aim_left'] = %exposed_turn_aim_4;
	//	self.a.array['add_turn_aim_right'] = %exposed_turn_aim_6;
	}
	else
	{
		// uncomment this once shotgun_aim_4 and shotgun_aim_6 are fixed
	//	if (self usingShotgun())
	//	{
	//		self.a.array['add_aim_up'] = %shotgun_aim_8;
	//		self.a.array['add_aim_down'] = %shotgun_aim_2;
	//		self.a.array['add_aim_left'] = %shotgun_aim_4;
	//		self.a.array['add_aim_right'] = %shotgun_aim_6;
	//		
	//		self.a.array['straight_level'] = %shotgun_aim_5;
	//		self.a.array['reload'] = array(%shotgun_stand_reload_A, %shotgun_stand_reload_B, %shotgun_stand_reload_C, %shotgun_stand_reload_C, %shotgun_stand_reload_C); // (C is standing, want it more often)
	//		self.a.array['reload_crouchhide'] = array(%shotgun_stand_reload_A, %shotgun_stand_reload_B);
	//	}
	//	else if (self isCQBWalking())
	//	{
	//		self.a.array['add_aim_up'] = %CQB_stand_aim8;
	//		self.a.array['add_aim_down'] = %CQB_stand_aim2;
	//		self.a.array['add_aim_left'] = %CQB_stand_aim4;
	//		self.a.array['add_aim_right'] = %CQB_stand_aim6;
	//		
	//		self.a.array['fire'] = %exposed_shoot_auto_v3;
	//		self.a.array['straight_level'] = %CQB_stand_aim5;
	//		self.a.array['reload'] = array(%CQB_stand_reload_steady);
	//		self.a.array['reload_crouchhide'] = array(%CQB_stand_reload_knee);
	//	}
	//	else
	//	{
			SetAnimArray('add_aim_up', 'stand_aim_8');
			SetAnimArray('add_aim_down', 'stand_aim_2');
			SetAnimArray('add_aim_left', 'stand_aim_4');
			SetAnimArray('add_aim_right', 'stand_aim_6');  
	
			SetAnimArray('fire', 'stand_fire_auto');
			SetAnimArray('straight_level', 'stand_aim');
			SetAnimArray('reload', 'stand_reload'); // ha_exposed_reloadb, ha_exposed_reloadc
			SetAnimArray('reload_crouchhide', 'stand_crouch_reload');
	//	}
		
		SetAnimArray('exposed_idle', 'stand_idle_v1');
		SetAnimArray('exposed_idle', 'stand_idle_v2');
		SetAnimArray('exposed_idle', 'stand_idle_v3');
	
		SetAnimArray('idle1', 'stand_idle_v1');
		SetAnimArray('idle2', 'stand_idle_v2');
		SetAnimArray('idle3', 'stand_idle_v3');

		if (weapon != '' && weaponClass(weapon) == 'spread')
		{
			SetAnimArray('single', 'shotgun_stand_fire_1A');
			SetAnimArray('single', 'shotgun_stand_fire_1B');
		}
		else
		{
			SetAnimArray('single', 'stand_fire_single');
		}

		SetAnimArray('burst2', 'stand_fire_burst2'); // (will be stopped after second bullet)
		SetAnimArray('burst3', 'stand_fire_burst3');
		SetAnimArray('burst4', 'stand_fire_burst4');
		SetAnimArray('burst5', 'stand_fire_burst5');
		SetAnimArray('burst6', 'stand_fire_burst6');

		SetAnimArray('semi2', 'stand_fire_semi2');
		SetAnimArray('semi3', 'stand_fire_semi3');
		SetAnimArray('semi4', 'stand_fire_semi4');
		SetAnimArray('semi5', 'stand_fire_semi5');
		
		SetAnimArray('crouch_2_stand', 'crouch_2_stand');
		SetAnimArray('crouch_2_prone', 'crouch_2_prone');
		SetAnimArray('stand_2_crouch', 'stand_2_crouch');
		SetAnimArray('stand_2_prone', 'stand_2_prone');
		SetAnimArray('prone_2_crouch', 'prone_2_crouch');
		SetAnimArray('prone_2_stand', 'prone_2_stand');

		SetAnimArray('turn_left_45', 'stand_turn_45L');
		SetAnimArray('turn_left_90', 'stand_turn_90L');
		SetAnimArray('turn_left_135', 'stand_turn_135L');
		SetAnimArray('turn_left_180', 'stand_turn_B');
		SetAnimArray('turn_right_45', 'stand_turn_45R');
		SetAnimArray('turn_right_90', 'stand_turn_90R');
		SetAnimArray('turn_right_135', 'stand_turn_135R');
		SetAnimArray('turn_right_180', 'stand_turn_B');		

		SetAnimArray('add_turn_aim_up', 'stand_turn_aim_8');
		SetAnimArray('add_turn_aim_down', 'stand_turn_aim_2');
		SetAnimArray('add_turn_aim_left', 'stand_turn_aim_4');
		SetAnimArray('add_turn_aim_right', 'stand_turn_aim_6');
	}

	turnThreshold = 35;
	
	rightAimLimit = 45;
	leftAimLimit = -45;
	upAimLimit = 45;
	downAimLimit = -45;

	turnleft180limit =  -130;
	turnright180limit = 130;
	turnleft90limit = -70;
	turnright90limit = 70;
}

function set_animarray_crouching()
{
	assert(!animscripts_utility.usingSidearm());

	ResetAnimArray();

	if (animscripts_utility.weaponAnims() == 'rocketlauncher')
	{
//		self.a.array['add_aim_up'] = %RPG_crouch_aim_8;
//		self.a.array['add_aim_down'] = %RPG_crouch_aim_2;
//		self.a.array['add_aim_left'] = %RPG_crouch_aim_4;
//		self.a.array['add_aim_right'] = %RPG_crouch_aim_6;
//	
//		self.a.array['straight_level'] = %RPG_crouch_aim_5;
//		self.a.array['fire'] = %RPG_crouch_fire;
//		self.a.array['reload'] = array(%RPG_crouch_reload);
//	
//		self.a.array['single'] = array(%RPG_crouch_fire);
//	
//		self.a.array['exposed_idle'] = array(%RPG_crouch_idle);
	}
	else
	{
		SetAnimArray('add_aim_up', 'crouch_aim_8');
		SetAnimArray('add_aim_down', 'crouch_aim_2');
		SetAnimArray('add_aim_left', 'crouch_aim_4');
		SetAnimArray('add_aim_right', 'crouch_aim_6');
	
		SetAnimArray('straight_level', 'crouch_aim');
		SetAnimArray('fire', 'crouch_fire_auto');
	
		if (isdefined(weapon) && weaponClass(weapon) == 'spread')
		{
			SetAnimArray('single', 'shotgun_crouch_fire');
			SetAnimArray('reload', 'shotgun_crouch_reload');
		}
		else
		{
			SetAnimArray('single', 'crouch_fire_single');
			SetAnimArray('reload', 'crouch_reload');
		}

		SetAnimArray('burst2', 'crouch_fire_burst2');
		SetAnimArray('burst3', 'crouch_fire_burst3');
		SetAnimArray('burst4', 'crouch_fire_burst4');
		SetAnimArray('burst5', 'crouch_fire_burst5');
		SetAnimArray('burst6', 'crouch_fire_burst6');
	
		SetAnimArray('semi2', 'crouch_fire_semi2');
		SetAnimArray('semi3', 'crouch_fire_semi3');
		SetAnimArray('semi4', 'crouch_fire_semi4');
		SetAnimArray('semi5', 'crouch_fire_semi5');
	
		SetAnimArray('exposed_idle', 'crouch_idle_v1');
		SetAnimArray('exposed_idle', 'crouch_idle_v2');
		SetAnimArray('exposed_idle', 'crouch_idle_v3');
	}
	
	// we probably need an RPG version of this one
	SetAnimArray('crouch_2_stand', 'crouch_2_stand');
	SetAnimArray('crouch_2_prone', 'crouch_2_prone');
	SetAnimArray('stand_2_crouch', 'stand_2_crouch');
	SetAnimArray('stand_2_prone', 'stand_2_prone');
	SetAnimArray('prone_2_crouch', 'prone_2_crouch');
	SetAnimArray('prone_2_stand', 'prone_2_stand');
	
	// temp: only have 90 degree turns for crouching, will look bad but work
	SetAnimArray('turn_left_45', 'crouch_turn_45L');
	SetAnimArray('turn_left_90', 'crouch_turn_90L');
	SetAnimArray('turn_left_135', 'crouch_turn_90L');
	SetAnimArray('turn_left_180', 'crouch_turn_90L');
	SetAnimArray('turn_right_45', 'crouch_turn_45R');
	SetAnimArray('turn_right_90', 'crouch_turn_90R');
	SetAnimArray('turn_right_135', 'crouch_turn_90R');
	SetAnimArray('turn_right_180', 'crouch_turn_90R');

	SetAnimArray('add_turn_aim_up', 'crouch_turn_aim_8');
	SetAnimArray('add_turn_aim_down', 'crouch_turn_aim_2');
	SetAnimArray('add_turn_aim_left', 'crouch_turn_aim_4');
	SetAnimArray('add_turn_aim_right', 'crouch_turn_aim_6');

	turnThreshold = 45;
	
	rightAimLimit = 45;
	leftAimLimit = -45;
	upAimLimit = 45;
	downAimLimit = -45;

	turnleft180limit =  -130;
	turnright180limit = 130;
	turnleft90limit = -70;
	turnright90limit = 70;
}


function set_animarray_prone()
{
	assert(!animscripts_utility.usingSidearm());

	ResetAnimArray();

	SetAnimArray('add_aim_up', 'prone_aim_8');
	SetAnimArray('add_aim_down', 'prone_aim_2');
	SetAnimArray('add_aim_left', 'prone_aim_4');
	SetAnimArray('add_aim_right', 'prone_aim_6');

	SetAnimArray('straight_level', 'prone_aim');
	SetAnimArray('fire', 'prone_fire_auto');

	SetAnimArray('single', 'prone_fire_single');
	SetAnimArray('reload', 'prone_reload');

	SetAnimArray('burst2', 'prone_fire_burst2');
	SetAnimArray('burst3', 'prone_fire_burst3');
	SetAnimArray('burst4', 'prone_fire_burst4');
	SetAnimArray('burst5', 'prone_fire_burst5');
	SetAnimArray('burst6', 'prone_fire_burst6');

	SetAnimArray('semi2', 'prone_fire_semi2');
	SetAnimArray('semi3', 'prone_fire_semi3');
	SetAnimArray('semi4', 'prone_fire_semi4');
	SetAnimArray('semi5', 'prone_fire_semi5');

	SetAnimArray('exposed_idle', 'prone_idle');
	SetAnimArray('exposed_idle', 'prone_idle');
	SetAnimArray('exposed_idle', 'prone_idle');
		
	SetAnimArray('crouch_2_stand', 'crouch_2_stand');
	SetAnimArray('crouch_2_prone', 'crouch_2_prone');
	SetAnimArray('stand_2_crouch', 'stand_2_crouch');
	SetAnimArray('stand_2_prone', 'stand_2_prone');
	SetAnimArray('prone_2_crouch', 'prone_2_crouch');
	SetAnimArray('prone_2_stand', 'prone_2_stand');	

	turnThreshold = 45;
	
	rightAimLimit = 45;
	leftAimLimit = -45;
	upAimLimit = 45;
	downAimLimit = -45;

	turnleft180limit =  -130;
	turnright180limit = 130;
	turnleft90limit = -70;
	turnright90limit = 70;
}


function ExposedCombatMainLoop(optional bool newThread = false)
{
	run (new(self) class'combat_ExposedCombatMainLoop', newThread);
}

function ExposedWait(optional bool newThread = false)
{
	run (new(self) class'combat_ExposedWait', newThread);
}

function bool StandIfMakesEnemyVisible()
{
	assert(a.pose != 'stand');
	assert(isStanceAllowed('stand'));
	if (obj_isdefined(enemy) && 
		(!cansee(enemy) || !canShoot(enemy.getShootAtPos())) && 
		sightTracePassed(origin + vect(0,0,64)*FInch, enemy.getShootAtPos(), false, none))
	{
		a.dontCrouchTime = gettime() + 3000;
		transitionTo('stand');
		return true;
	}
	return false;
}

function bool NeedToTurn()
{
	local vector lPoint;
	local float lYaw;
	local float lDistSq;
	local float lDist;
	// Old way, slower
	/*
	yawToShootEntOrPos = getAimYawToShootEntOrPos(); // yaw to where we think our enemy will be in x seconds
	
	return (abs(yawToShootEntOrPos) > self.turnThreshold);
	*/
	
	// New way
	lPoint = shootPos;
	if (!vec_isdefined(lPoint))
		return false;
	
	lYaw = angles.yaw - VectorToAngles(lPoint - origin).yaw;
	
	// need to have fudge factor because the gun's origin is different than our origin,
	// the closer our distance, the more we need to fudge. 
	lDistSq = distanceSquared(origin, lPoint);
	if (lDistSq < 256*256*FInchSq)
	{
		lDist = sqrt(lDistSq);
		if (lDist > 3*FInch)
			lYaw += asin(-3*FInch/lDist);
	}
	return AbsAngleClamp180(lYaw) > turnThreshold;
}

function bool EnsureStanceIsAllowed()
{
	local name lCurStance;
	local name lOtherStance;

	lCurStance = a.pose;
	
	if (!isStanceAllowed(lCurStance))
	{
		assert(lCurStance == 'stand' || lCurStance == 'crouch' || lCurStance == 'prone');
		
		lOtherStance = 'crouch';
		if (lCurStance == 'crouch')
			lOtherStance = 'stand';
		
		if (isStanceAllowed(lOtherStance))
		{
			if (lCurStance == 'stand' && animscripts_utility.usingSidearm())
			{
				switchToLastWeapon('pistol_stand_switch');
				return true;
			}
			
			transitionTo(lOtherStance);
			return true;
		}
	}

	return false;
}

function CantSeeEnemyBehavior(optional bool newThread = false)
{
	run (new(self) class'combat_CantSeeEnemyBehavior', newThread);
}

function CantSeeEnemyWait(optional bool newThread = false)
{
	run (new(self) class'combat_CantSeeEnemyWait', newThread);
}

function ResetGiveUpOnEnemyTime()
{
	a.nextGiveUpOnEnemyTime = gettime() + randomintrange(2000, 4000);
}

function TurnToFaceRelativeYaw(float iFaceYaw, optional bool newThread = false)
{
	local combat_TurnToFaceRelativeYaw task;
	task = new(self) class'combat_TurnToFaceRelativeYaw';
	task.iFaceYaw = iFaceYaw;
	run (task, newThread);
}

function WatchShootEntVelocity(optional bool newThread = false)
{
	run (new(self) class'combat_WatchShootEntVelocity', newThread);
}

//shouldSwapShotgun()
//{
//	return false; // anims aren't set up yet
//	
//	/*
//	if (self.a.pose != 'stand')
//		return false;
//	
//	if (self usingSidearm())
//		return false;
//	
//	usingShotgun = (weaponclass(self.primaryweapon) == 'spread');
//	wantShotgun = isdefined(self.wantShotgun) && self.wantShotgun);
//	
//	if (wantShotgun == usingShotgun)
//		return false;
//	
//	if (!wantShotgun) // there is no standing shotgun putaway animation
//		return false;
//	
//	return true;*/
//}
//
///*swapShotgun()
//{
//	assert(self shouldSwapShotgun());
//	assert(isdefined(self.wantShotgun));
//	
//	if (self.wantShotgun)
//	{
//		self setFlaggedAnimKnobAllRestart('weapon_swap', %shotgun_stand_pullout, %body, 1, .2, 1);
//		
//		self thread DoNoteTracksWithEndon('weapon_swap');
//		
//		self waittill('weapon_swap', '');
//		self waittill('weapon_swap', 'end');
//	}
//	else
//	{
//		assert(false); // we don't have a standing shotgun putaway animation
//	}
//}*/
//
//DoNoteTracksWithEndon(animname)
//{
//	self endon('killanimscript');
//	self animscripts\shared::DoNoteTracks(animname);
//}
//
//endtwitch()
//{
//	self endon('killanimscript');
//	wait(10);
//	self.twitchallowed = true;	
//}

// does turntable movement to face the enemy;
// should be used sparingly because turn animations look better.
function FaceEnemyImmediately(optional bool newThread = false)
{
	run (new(self) class'combat_FaceEnemyImmediately', newThread);
}

function bool IsDeltaAllowed(name theanim)
{
	local vector lDelta;
	local vector lEndPoint;

	lDelta = getMoveDelta(theanim, 0, 1);
	lEndPoint = localToWorldCoords(lDelta);
	
	return isInGoal(lEndPoint) && mayMoveToPoint(lEndPoint);
}

function turn(name iDirection, float iAmount, optional bool newThread = false)
{
	local combat_turn task;
	task = new(self) class'combat_turn';
	task.iDirection = iDirection;
	task.iAmount = iAmount;
	run (task, newThread);
}

function DoTurnNotetracks()
{
	run (new(self) class'combat_DoTurnNotetracks', false);
}

function MakeSureTurnWorks(optional bool newThread = false)
{
	run (new(self) class'combat_MakeSureTurnWorks', newThread);
}

function _TurningAimingOn(float transTime)
{
	setAnimLimited(animscripts_utility.animarray('straight_level'), 0, transTime);
	
	/*self setanimlimited(animarray('add_aim_up'  )     , 0, transTime);
	self setanimlimited(animarray('add_aim_down')     , 0, transTime);
	self setanimlimited(animarray('add_aim_left')     , 0, transTime);
	self setanimlimited(animarray('add_aim_right')     , 0, transTime);*/
	
	/*self setAnimKnobLimited(animarray('add_turn_aim_up'  ), 1, transTime);
	self setAnimKnobLimited(animarray('add_turn_aim_down'), 1, transTime);
	self setAnimKnobLimited(animarray('add_turn_aim_left'), 1, transTime);
	self setAnimKnobLimited(animarray('add_turn_aim_right'), 1, transTime);*/
	
	setAnim('add_idle', 0, transTime);
}

function _TurningAimingOff(float iTransTime)
{
	setAnimLimited(animscripts_utility.animarray('straight_level'), 1, iTransTime);
	
	/*self setAnimKnobLimited(animarray('add_aim_up'  )     , 1, iTransTime);
	self setAnimKnobLimited(animarray('add_aim_down')     , 1, iTransTime);
	self setAnimKnobLimited(animarray('add_aim_left')     , 1, iTransTime);
	self setAnimKnobLimited(animarray('add_aim_right')     , 1, iTransTime);*/
	
	/*self setanimlimited(animarray('add_turn_aim_up'  ), 0, iTransTime);
	self setanimlimited(animarray('add_turn_aim_down'), 0, iTransTime);
	self setanimlimited(animarray('add_turn_aim_left'), 0, iTransTime);
	self setanimlimited(animarray('add_turn_aim_right'), 0, iTransTime);*/
	
	setAnim('add_idle', 1, iTransTime);
}

function ShootWhileTurning(optional bool newThread = false)
{
	run (new(self) class'combat_ShootWhileTurning', newThread);
}

function ShootUntilNeedToTurn(optional bool newThread = false)
{
	run (new(self) class'combat_ShootUntilNeedToTurn', newThread);
}

function WatchForNeedToTurnOrTimeout(optional bool newThread = false)
{
	run (new(self) class'combat_WatchForNeedToTurnOrTimeout', newThread);
}

//considerThrowGrenade()
//{
//	if (!myGrenadeCoolDownElapsed()) // early out for efficiency
//		return false;
//	
//	self.a.nextGrenadeTryTime = gettime() + 300; // don't try this too often
//	
//	if (isdefined(anim.throwGrenadeAtPlayerASAP) && isAlive(level.player))
//	{
//		if (tryThrowGrenade(level.player, 200))
//			return true;
//	}
//	
//	if (isdefined(self.enemy))
//		return tryThrowGrenade(self.enemy, 850);
//	
//	return false;
//}
//
//tryThrowGrenade(throwAt, minDist)
//{
//	threw = false;
//
//	throwSpot = throwAt.origin;
//	if (!self canSee(throwAt))
//	{
//		if (isdefined(self.enemy) && throwAt == self.enemy && isdefined(self.shootPos))
//			throwSpot = self.shootPos;
//	}
//	
//	if (!self canSee(throwAt))
//		minDist = 100;
//	
//	if (distanceSquared(self.origin, throwSpot) > minDist*minDist && self.a.pose == 'stand')
//	{
//		yaw = GetYawToSpot(throwSpot);
//		if (abs(yaw) < 60)
//		{
//			throwAnims = [];
//			if (isDeltaAllowed(%exposed_grenadeThrowB))
//				throwAnims[throwAnims.size] = %exposed_grenadeThrowB;
//			if (isDeltaAllowed(%exposed_grenadeThrowC))
//				throwAnims[throwAnims.size] = %exposed_grenadeThrowC;
//			
//			if (throwAnims.size > 0)
//			{
//				self setanim(%exposed_aiming, 0, .1);
//				self animMode('zonly_physics');
//				
//				setAnimAimWeight(0, 0);
//				
//				threw = TryGrenade(throwAt, throwAnims[randomint(throwAnims.size)]);
//				
//				self setanim(%exposed_aiming, 1, .1);
//				
//				if (threw)
//					setAnimAimWeight(1, .5); // ease into aiming
//				else
//					setAnimAimWeight(1, 0);
//			}
//		}
//	}
//	
//	if (threw)
//		self maps\_gameskill::didSomethingOtherThanShooting();
//	
//	return threw;
//}

function TransitionTo(name newPose, optional bool newThread = false)
{
	local combat_TransitionTo task;
	task = new(self) class'combat_TransitionTo';
	task.iNewPose = newPose;
	run (task, newThread);
}

function KeepTryingToMelee(optional bool newThread = false)
{
	run (new(self) class'combat_KeepTryingToMelee', newThread);
}

function bool TryMelee()
{
	if (kCombatMood == HCM_Ambush)
		return false;

	if (!obj_isdefined(enemy))
		return false;
	
	// early out
	if (distanceSquared(origin, enemy.origin) > 512*512*FInchSq)
		return false;
	
	if (a.pose == 'prone')
		return false;
		
	// can't melee while sidearm is out. need animations for this.
	// we rely on main loop to put away sidearm if necessary.
	if (animscripts_utility.usingSidearm())
		return false;
	
	if (!animscripts_utility.usingSidearm() || !animscripts_combat_utility.NeedToReload(0))
	{
		// we have other options, so don't melee unless we're really close
		if (distanceSquared(enemy.origin, origin) > 200*200*FInchSq)
			return false;
	}

	if (!animscripts_melee.CanMeleeDesperate())
		return false;

	// TODO: this is dangerous. during a weapon switch, our enemy might die/change or the situation might change in other ways.
	// TryMelee needs to return false if it's not possible to *immediately* start a melee,
	// so the global logic function needs to be the one to do the weapon switch if it's necessary.
	//switchToLastWeapon(%pistol_stand_switch_F);
	
	//animscripts_melee.MeleeCombat(true);
	goto_state('melee');
	notify('melee');

	return true;
}

function bool ExposedReload(float iThreshold, optional bool newThread = false)
{
	local combat_ExposedReload task;
	if (animscripts_combat_utility.NeedToReload(iThreshold))
	{
		task = new(self) class'combat_ExposedReload';
		task.iThreshold = iThreshold;
		run (task, newThread);
		
		return true;
	}
	
	return false;
}

function DoReloadAnim(name iReloadAnim, bool iStopWhenCanShoot, optional bool newThread = false)
{
	local combat_DoReloadAnim task;
	task = new(self) class'combat_DoReloadAnim';
	task.iReloadAnim = iReloadAnim;
	task.iStopWhenCanShoot = iStopWhenCanShoot;
	run (task, newThread);
}

function AbortReloadWhenCanShoot(optional bool newThread = false)
{
	run (new(self) class'combat_AbortReloadWhenCanShoot', newThread);
}

function NotifyOnStartAim(name iEndonStr, name iFlagName, optional bool newThread = false)
{
	local combat_NotifyOnStartAim task;
	task = new(self) class'combat_NotifyOnStartAim';
	task.iEndonStr = iEndonStr;
	task.iFlagName = iFlagName;
	run (task, newThread);
}

//finishNoteTracks(animname)
//{
//	self endon('killanimscript');
//	animscripts\shared::DoNoteTracks(animname);
//}
//
//drop_turret()
//{
//	maps\_mgturret::dropTurret();
////	level.theturret = turret;
////	throwVel = 75 + randomInt(50);
//
////	self animscripts\shared::PutGunInHand('right');
//	self animscripts\weaponList::RefillClip();
//	self.a.needsToRechamber = 0;
//	self notify ('dropped_gun');
//	maps\_mgturret::restoreDefaults();
//}
//
//exception_exposed_mg42_portable()
//{
//	drop_turret();
//}


function bool TryUsingSidearm()
{
	if (!isdefined(sidearm))
		return false;

	// temp fix! we run out of bones on a particular friendly model with a shotgun who tries to pull out his pistol.
	if (isdefined(secondaryWeapon) && weaponClass(secondaryweapon) == 'spread')
		return false;
	
	switchToSidearm('pistol_stand_pullout');
	return true;
}


function SwitchToSidearm(name iSwapAnim, optional bool newThread = false)
{
	local combat_SwitchToSidearm task;
	task = new(self) class'combat_SwitchToSidearm';
	task.iSwapAnim = iSwapAnim;
	run (task, newThread);
}

function DoNoteTracksPostCallbackWithEndon(name iFlagName, DelegateNoteTracksPostCallback iInterceptFunction, name iEndonMsg, optional bool newThread = false)
{
	local combat_DoNoteTracksPostCallbackWithEndon task;
	task = new(self) class'combat_DoNoteTracksPostCallbackWithEndon';
	task.iFlagName = iFlagName;
	task.iInterceptFunction = iInterceptFunction;
	task.iEndonMsg = iEndonMsg;
	run (task, newThread);
}

function FaceEnemyDelay(float iDelay, optional bool newThread = false)
{
	local combat_FaceEnemyDelay task;
	task = new(self) class'combat_FaceEnemyDelay';
	task.iDelay = iDelay;
	run (task, newThread);
}

function HandlePickup(name iNoteTrack)
{
	if (iNoteTrack == 'pistol_pickup')
	{
		clearAnim(animscripts_utility.animarray('straight_level'), 0);
		set_animarray_standing();
		
		faceEnemyDelay(0.25, true);
	}
	else if (iNoteTrack == 'start_aim')
	{
		if (needToTurn())
		{
			notify('end_weapon_swap');
		}
		else
		{
			setAnimLimited(animscripts_utility.animarray('straight_level'), 1, 0);
			setupAim(0);
			setAnim('exposed_aiming', 1, 0.2);
		}
	}
}


// 'pistol_stand_switch'
function SwitchToLastWeapon(name swapAnim, optional bool newThread = false)
{
	local combat_SwitchToLastWeapon task;
	task = new(self) class'combat_SwitchToLastWeapon';
	task.iSwapAnim = swapAnim;
	run (task, newThread);
}

function bool handlePutaway(name iNoteTrack)
{
	if (iNoteTrack == 'pistol_putaway')
	{
		clearAnim(animscripts_utility.AnimArray('straight_level'), 0);
		set_animarray_standing();
	}
	else if (iNoteTrack == 'start_aim')
	{
		if (needToTurn())
		{
			notify('end_weapon_swap');
		}
		else
		{
			setAnimLimited(animscripts_utility.animarray('straight_level'), 1, 0);
			setupAim(0);
			setAnim('exposed_aiming', 1, 0.2);
		}
	}
	return false;
}

function RPGDeath(optional bool newThread = false)
{
	run (new(self) class'combat_RPGDeath', newThread);
}

function ReacquireWhenNecessary(optional bool newThread = false)
{
	run (new(self) class'combat_ReacquireWhenNecessary', newThread);
}

function bool ShouldFindCoverNearSelf()
{
	// don't look for cover right after starting exposed behavior
	if (gettime() < a.lookForNewCoverTime)
		return false;
	
	if (canSee(enemy))
	{
		// try to finish off the player if damaged
		if (isPlayer(enemy) && enemy.health < enemy.maxHealth * 0.8)
			return false;
		
		// stand and fight unless we need to reload soon
		return animscripts_combat_utility.NeedToReload(0.5);
	}
	else
	{
		// try sidestepping first
		if (reacquire_state <= 2)
			return false;
		
		if (a.exposedReloading)
			return false;
		
		return true;
	}
}

// this function is meant to be called many times in succession.
// each time it tries another option, until eventually it finds something it can do.
function TryExposedReacquire()
{
	local HodNode n;
	local bool oldKeepNodeInGoal;
	local bool oldKeepNode;


	//prof_begin('TryExposedReacquire');
	if (!animscripts_utility.isValidEnemy(enemy))
	{
		reacquire_state = 0;
		return;
	}
	
	if (ShouldFindCoverNearSelf())
	{
		if (animscripts_combat_utility.FindCoverNearSelf())
		{
			reacquire_state = 0;
			return;
		}
	}
	
	if (canSee(enemy))
	{
		reacquire_state = 0;
		return;
	}
	
	if (a.exposedReloading && animscripts_combat_utility.NeedToReload(0.25) && enemy.health > enemy.maxhealth * 0.5)
	{
		reacquire_state = 0;
		return;
	}
	
	switch (reacquire_state)
	{
	case 0:
		if (ReacquireStep(32*FInch))
		{
			assert(reacquire_state == 0);
			return;
		}
		break;

	case 1:
		if (ReacquireStep(64*FInch))
		{
			reacquire_state = 0;
			return;
		}
		break;

	case 2:
		if (ReacquireStep(96*FInch))
		{
			reacquire_state = 0;
			return;
		}
		break;

	case 3:
		if (a.script != 'combat')
		{
			reacquire_state = 0;
			return;
		}

		FindReacquireNode();
		reacquire_state++;
		// fall through

	case 4:
		n = GetReacquireNode();
		if (node_isdefined(n))
		{			
			oldKeepNodeInGoal = keepClaimedNodeInGoal;
			oldKeepNode = keepClaimedNode;
			keepClaimedNodeInGoal = false;
			keepClaimedNode = false;

			if (UseReacquireNode(n))
			{
				reacquire_state = 0;
			}
			else
			{
				keepClaimedNodeInGoal = oldKeepNodeInGoal;
				keepClaimedNode = oldKeepNode;
			}
			
			return;
		}
		break;

	case 5:
		if (animscripts_combat_utility.tryRunningToEnemy(false))
		{
			reacquire_state = 0;
			return;
		}
		
		break;

	default:
		assert(reacquire_state == 6);
		reacquire_state = 0;
		if (!(canSee(enemy)))
			FlagEnemyUnattackable();
		return;
	}
	
	reacquire_state++;
}

function bool ShouldGoToNode(HodNode n)
{
	// This function used to prevent us from turning our back to our enemy.
	// This isn't necessary now that we can shoot while running away.
	return true;
	
	/*
	// if we're close to our enemy, and we can see them,
	// don't run away from them.
	
	if (!isValidEnemy(self.enemy))
		return true;
	
	if (!isSentient(self.enemy))
		return true;
	
	if (!self cansee(self.enemy))
		return true;
	
	// we're in our enemy's line of sight.
	
	enemyAngles = undefined;
	if (isplayer(self.enemy)) {
		enemyAngles = self.enemy getPlayerAngles();
	}
	else {
		// would like to use tag_weapon, but no way to tell if they have one or not
		enemyAngles = self.enemy.angles;
	}
	
	angleToEnemyLook = vectordot(anglesToForward(enemyAngles), vectornormalize(self.origin - self.enemy.origin));
	
	// if we're far away and our enemy isn't looking at us, it's ok to move
	if (distanceSquared(self.origin, self.enemy.origin) > 400 * 400 && angleToEnemyLook < cos(10))
		return true;
	
	// if the cover is between us and our enemy, it's ok to move
	enemyDist = distance(self.origin, self.enemy.origin);
	if (distance(self.enemy.origin, n.origin) < enemyDist * .8 && distance(self.origin, n.origin) < enemyDist * .8)
		return true;
	
	// don't turn our back.
	return false;
	*/
}
