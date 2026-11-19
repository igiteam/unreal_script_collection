// Shared.gsc - Functions that are shared between animscripts and level scripts.
// Functions in this file can't rely on the animscripts\init function having run, and can't call any
// functions not allowed in level scripts.
class animscripts_shared extends Object within HodAI
	dependson(general_human);

var bool noragdoll;
function PlaceWeaponOn(name iWeapon, name iPosition)
{
//	//prof_begin('placeWeaponOn');
//	// make sure this it one of our weapons
//	assert(AIHasWeapon(iWeapon));
//
//	self notify('weapon_position_change');
//
//	curPosition = self.weaponInfo[iWeapon].position;
//
//	// make sure we're not out of sync
//	assert(curPosition == 'none' || self.a.weaponPos[curPosition] == iWeapon);
//
//	// weapon already in place
//	if (iPosition != 'none' && self.a.weaponPos[iPosition] == iWeapon)
//	{
//		//prof_end('placeWeaponOn');
//		return;
//	}
//
//	self detachAllWeaponModels();
//
//	// detach if we're already in a position
//	if (curPosition != 'none')
//		self detachWeapon(iWeapon);
//
//	// nothing more to do
//	if (iPosition == 'none')
//	{
//		self updateAttachedWeaponModels();
//		//prof_end('placeWeaponOn');
//		return;
//	}

	if (a.weaponPos[WeaponPoseID(iPosition)] != 'none')
		detachWeapon(a.weaponPos[WeaponPoseID(iPosition)]);

	// to ensure that the correct tags for the active weapon are used, we need to make sure it gets attached first
	if (iPosition == 'left' || iPosition == 'right')
	{
		attachWeapon(iWeapon, iPosition);
		weapon = iWeapon;

		aimThresholdYaw = 10;
		aimThresholdPitch = 20;
	}
	else
	{
		attachWeapon(iWeapon, iPosition);
	}

//	self updateAttachedWeaponModels();
//
//	// make sure we don't have a weapon in each hand
//	assert(self.a.weaponPos['left'] == 'none' || self.a.weaponPos['right'] == 'none');
//	//prof_end('placeWeaponOn');
}

function detachWeapon(name iWeapon)
{
	// temp by zhangting
	local int i;
	for (i = 0; i < a.weaponPos.length; ++ i)
	{
		if (a.weaponPos[i] == iWeapon)
			a.weaponPos[i] = 'none';
	}
//	self.a.weaponPos[self.weaponInfo[iWeapon].position] = 'none';
//	self.weaponInfo[iWeapon].position = 'none';
}


function attachWeapon(name iWeapon, name iPosition)
{
//	self.weaponInfo[iWeapon].position = iPosition;
	a.weaponPos[WeaponPoseID(iPosition)] = iWeapon;
}

//detachAllWeaponModels()
//{
//	positions = [];
//	positions[positions.size] = 'right';
//	positions[positions.size] = 'left';
//	positions[positions.size] = 'chest';
//	positions[positions.size] = 'back';
//
//	self laserOff();
//
//	for (index = 0; index < positions.size; index++)
//	{
//		weapon = self.a.weaponPos[positions[index]];
//
//		if (weapon == 'none')
//			continue;
//
//		self detach(getWeaponModel(weapon), getTagForPos(positions[index]));
//	}
//}
//
//updateAttachedWeaponModels()
//{
//	positions = [];
//	positions[positions.size] = 'right';
//	positions[positions.size] = 'left';
//	positions[positions.size] = 'chest';
//	positions[positions.size] = 'back';
//
//	for (index = 0; index < positions.size; index++)
//	{
//		weapon = self.a.weaponPos[positions[index]];
//
//		if (weapon == 'none')
//			continue;
//
//		self attach(getWeaponModel(weapon), getTagForPos(positions[index]));
//
//		if (self.weaponInfo[weapon].useClip && !self.weaponInfo[weapon].hasClip)
//			self hidepart('tag_clip');
//	}
//
//	self updateLaserStatus();
//}

function UpdateLaserStatus()
{
//	// we have no weapon so there's no laser to turn off or on
//	if (self.a.weaponPos['right'] == 'none')
//		return;
//
//	if(canUseLaser())
//		self laserOn();
//	else
//		self laserOff();
}

//canUseLaser()
//{
//	if(!self.a.laserOn)
//		return false;
//
//	// shotguns don't have lasers
//	if (weapon_spread())
//		return false;
//
//	if(!isDefined(level.player.nightVision_Enabled))
//		return false;
//
//	return isAlive(self);
//}
//
//getTagForPos(position)
//{
//	switch (position)
//	{
//		case 'chest':
//			return 'tag_weapon_chest';
//		case 'back':
//			return 'tag_stowed_back';
//		case 'left':
//			return 'tag_weapon_left';
//		case 'right':
//			return 'tag_weapon_right';
//		case 'hand':
//			return 'tag_inhand';
//		default:
//			assertMsg('unknown weapon placement position: ' + position);
//		break;
//	}
//}



//function DropAIWeapon()
//{
//	if (weapon == 'none')
//		return;
//
//	//position = weaponInfo[ weapon ].position;
//
//	//if (getdvarint('scr_physWeaponDrop') != 0)
//	//{
//	//	self dropPhysWeapon();
//	//	self.weapon = 'none';
//	//	return;
//	//}
//
//	//if(self.dropWeapon)
//	//{
//	//	dropWeaponName = self.weapon;
//	//	if (issubstr(tolower(self.weapon), 'rpg'))
//	//		dropWeaponName = 'rpg_player';
//	//	self DropWeapon(dropWeaponName, position, 0);
//	//}
//	placeWeaponOn(weapon, 'none');
//	weapon = 'none';
//}


function DropAllAIWeapons()
{
	pawn.ThrowActiveWeapon();

//	positions = [];
//	positions[positions.size] = 'left';
//	positions[positions.size] = 'right';
//	positions[positions.size] = 'chest';
//	positions[positions.size] = 'back';
//
//	self detachAllWeaponModels();
//
//	for (index = 0; index < positions.size; index++)
//	{
//		weapon = self.a.weaponPos[ positions[ index ] ];
//
//		if (weapon == 'none')
//			continue;
//
//		self.weaponInfo[ weapon ].position = 'none';
//		self.a.weaponPos[ positions[ index ] ] = 'none';
//
//		if (getdvarint('scr_physWeaponDrop') != 0)
//		{
//			self dropPhysWeapon(positions[index]);
//		}
//		else
//		{
//			if (issubstr(tolower(weapon), 'rpg'))
//				weapon = 'rpg_player';
//			self DropWeapon(weapon, positions[ index ], 0);
//		}
//	}
//
//	self.weapon = 'none';
}


//dropPhysWeapon(pos)
//{
//	//prof_begin('dropPhysWeapon');
//
//	tagName = self getTagForPos(pos);
//	tagOrigin = self getTagOrigin(tagName);
//	tagAngles = self getTagAngles(tagName);
//
//	physWeapon = spawn('script_model', tagOrigin);
//	physWeapon.angles = tagAngles;
//	physWeapon setModel(getWeaponModel(self.a.weaponPos[pos]));
//	physWeapon thread addPhysWeapon();
//
//	animscripts\shared::placeWeaponOn(self.a.weaponPos[pos], 'none');
//
//	physWeapon physicsLaunch(tagOrigin + (randomFloat(6),randomFloat(6),randomFloat(6)), (randomFloat(500)-250,randomFloat(500)-250,randomFloat(50)));
//
//	//prof_end('dropPhysWeapon');
//}
//
//
//addPhysWeapon()
//{
//	self thread deleteAtLimit();
//}
//
//
//deleteAtLimit()
//{
//	wait 30.0;
//
//	self delete();
//}
//
//
//LookAtEntity(lookTargetEntity, lookDuration, lookSpeed, eyesOnly, interruptOthers)
//{
//	return;
///*
//	assertEX(isAI(self), 'Can only call this function on an AI character');
//	assert]](self.a.targetLookInitilized == true, 'LookAtEntity called on AI that lookThread was not called on');	#/
//	assert]](isDefined(lookTargetEntity), 'lookTargetEntity is not defined');											#/
//	assert]]((lookSpeed == 'casual') || (lookSpeed == 'alert'), 'lookSpeed must be casual or alert');					#/
//	assert]](!isDefined(interruptOthers) || (interruptOthers=='interrupt') || (interruptOthers=='don't interrupt'));	#/
//	// If interruptOthers is set, and there is another lookAt playing, then don't do anything.  InterruptOthers defaults to 'interrupt'.
//	if (!isDefined(interruptOthers) || (interruptOthers=='interrupt') || (GetTime() > self.a.lookEndTime))
//	{
//		if(isSentient(lookTargetEntity))
//			self.a.lookTargetType = 'sentient';
//		else
//			self.a.lookTargetType = 'entity';
//		self.a.lookTargetEntity = lookTargetEntity;
//		self.a.lookEndTime = GetTime() + (lookDuration*1000);
//		if(lookSpeed == 'casual')
//			self.a.lookTargetSpeed = 800;
//		else // alert
//			self.a.lookTargetSpeed = 1600;
//		if (isDefined(eyesOnly) && (eyesOnly=='eyes only'))
//		{
//			self notify('eyes look now');
//		}
//		else
//		{
//			self notify('look now');
//		}
//	}
//*/
//}
//
//LookAtPosition(lookTargetPos, lookDuration, lookSpeed, eyesOnly, interruptOthers)
//{
//	assertEX(isAI(self), 'Can only call this function on an AI character');
//	assertEX(self.a.targetLookInitilized == true, 'LookAtPosition called on AI that lookThread was not called on');
//	assertEX((lookSpeed == 'casual') || (lookSpeed == 'alert'), 'lookSpeed must be casual or alert');
//	// If interruptOthers is true, and there is another lookAt playing, then don't do anything.  InterruptOthers defaults to true.
//	if (!isDefined(interruptOthers) || (interruptOthers=='interrupt others') || (GetTime() > self.a.lookEndTime))
//	{
//		self.a.lookTargetPos = lookTargetPos;
//		self.a.lookEndTime = GetTime() + (lookDuration*1000);
//		if(lookSpeed == 'casual')
//			self.a.lookTargetSpeed = 800;
//		else // alert
//			self.a.lookTargetSpeed = 1600;
//		if (isDefined(eyesOnly) && (eyesOnly=='eyes only'))
//		{
//			self notify('eyes look now');
//		}
//		else
//		{
//			self notify('look now');
//		}
//	}
//
//}
//
//LookAtStop()
//{
//	assertEX(isAI(self), 'Can only call this function on an AI character');
//	assertEX(self.a.targetLookInitilized == true, 'LookAtStop called on AI that lookThread was not called on');
//
//	animscripts\look::finishLookAt();
//}
//
//LookAtAnimations(leftanim, rightanim)
//{
//	self.a.LookAnimationLeft = leftanim;
//	self.a.LookAnimationRight = rightanim;
//}
//
//
///#
//showNoteTrack(note)
//{
//	if (getdebugdvar('scr_shownotetracks') != 'on' && getdebugdvarint('scr_shownotetracks') != self getentnum())
//		return;
//
//	self endon('death');
//
//	anim.showNotetrackSpeed = 30; // units/sec
//	anim.showNotetrackDuration = 30; // frames
//
//	if (!isdefined(self.a.shownotetrackoffset))
//	{
//		thisoffset = 0;
//		self.a.shownotetrackoffset = 10;
//		self thread reduceShowNotetrackOffset();
//	}
//	else
//	{
//		thisoffset = self.a.shownotetrackoffset;
//		self.a.shownotetrackoffset += 10;
//	}
//
//	duration = anim.showNotetrackDuration + int(20.0 * thisoffset / anim.showNotetrackSpeed);
//
//	color = (.5,.75,1);
//	if (note == 'end' || note == 'finish')
//		color = (.25,.4,.5);
//	else if (note == 'undefined')
//		color = (1,.5,.5);
//
//	for (i = 0; i < duration; i++)
//	{
//		if (duration - i <= anim.showNotetrackDuration)
//			amnt = 1.0 * (i - (duration - anim.showNotetrackDuration)) / anim.showNotetrackDuration;
//		else
//			amnt = 0.0;
//		time = 1.0 * i / 20;
//
//		alpha = 1.0 - amnt*amnt;
//		pos = self geteye() + (0, 0, 20 + anim.showNotetrackSpeed * time - thisoffset);
//
//		print3d(pos, note, color, alpha);
//
//		wait .05;
//	}
//}
//reduceShowNotetrackOffset()
//{
//	self endon('death');
//	while(self.a.shownotetrackoffset > 0)
//	{
//		wait .05;
//		self.a.shownotetrackoffset -= anim.showNotetrackSpeed * .05;
//	}
//	self.a.shownotetrackoffset = undefined;
//}
//#/
//
//HandleDogSoundNoteTracks(note)
//{
//	if (note == 'sound_dogstep_run_default')
//	{
//		self playsound('dogstep_run_default');
//		return true;
//	}
//
//	prefix = getsubstr(note, 0, 5);
//
//	if (prefix != 'sound')
//		return false;
//
//	alias = 'anml' + getsubstr(note, 5);
//
////	if (growling() && !issubstr(alias, 'growl'))
////		return false;
//
//	if (isalive(self))
//		self thread play_sound_on_tag_endon_death(alias, 'tag_eye');
//	else
//		self thread play_sound_in_space(alias, self gettagorigin('tag_eye'));
//	return true;
//}
//
//growling()
//{
//	return isdefined(self.script_growl);
//}
//
//registerNoteTracks()
//{
//	anim.notetracks['anim_pose = \'stand\''] = ::noteTrackPoseStand;
//	anim.notetracks['anim_pose = \'crouch\''] = ::noteTrackPoseCrouch;
//	anim.notetracks['anim_pose = \'prone\''] = ::noteTrackPoseProne;
//	anim.notetracks['anim_pose = \'crawl\''] = ::noteTrackPoseCrawl;
//	anim.notetracks['anim_pose = \'back\''] = ::noteTrackPoseBack;
//
//	anim.notetracks['anim_movement = \'stop\''] = ::noteTrackMovementStop;
//	anim.notetracks['anim_movement = \'walk\''] = ::noteTrackMovementWalk;
//	anim.notetracks['anim_movement = \'run\''] = ::noteTrackMovementRun;
//
//	anim.notetracks['anim_aiming = 1'] = ::noteTrackAlertnessAiming;
//	anim.notetracks['anim_aiming = 0'] = ::noteTrackAlertnessAlert;
//	anim.notetracks['anim_alertness = causal'] = ::noteTrackAlertnessCasual;
//	anim.notetracks['anim_alertness = alert'] = ::noteTrackAlertnessAlert;
//	anim.notetracks['anim_alertness = aiming'] = ::noteTrackAlertnessAiming;
//
//	anim.notetracks['gunhand = (gunhand)_left'] = ::noteTrackGunhand;
//	anim.notetracks['anim_gunhand = \'left\''] = ::noteTrackGunhand;
//	anim.notetracks['gunhand = (gunhand)_right'] = ::noteTrackGunhand;
//	anim.notetracks['anim_gunhand = \'right\''] = ::noteTrackGunhand;
//	anim.notetracks['anim_gunhand = \'none\''] = ::noteTrackGunhand;
//	anim.notetracks['gun drop'] = ::noteTrackGunDrop;
//	anim.notetracks['dropgun'] = ::noteTrackGunDrop;
//
//	anim.notetracks['gun_2_chest'] = ::noteTrackGunToChest;
//	anim.notetracks['gun_2_back'] = ::noteTrackGunToBack;
//	anim.notetracks['pistol_pickup'] = ::noteTrackPistolPickup;
//	anim.notetracks['pistol_putaway'] = ::noteTrackPistolPutaway;
//	anim.notetracks['drop clip'] = ::noteTrackDropClip;
//	anim.notetracks['refill clip'] = ::noteTrackRefillClip;
//	anim.notetracks['reload done'] = ::noteTrackRefillClip;
//	anim.notetracks['load_shell'] = ::noteTrackLoadShell;
//	anim.notetracks['pistol_rechamber'] = ::noteTrackPistolRechamber;
//
//	anim.notetracks['gravity on'] = ::noteTrackGravity;
//	anim.notetracks['gravity off'] = ::noteTrackGravity;
//
//	anim.notetracks['bodyfall large'] = ::noteTrackBodyFall;
//	anim.notetracks['bodyfall small'] = ::noteTrackBodyFall;
//
//	anim.notetracks['footstep'] = ::noteTrackFootStep;
//	anim.notetracks['step'] = ::noteTrackFootStep;
//	anim.notetracks['footstep_right_large'] = ::noteTrackFootStep;
//	anim.notetracks['footstep_right_small'] = ::noteTrackFootStep;
//	anim.notetracks['footstep_left_large'] = ::noteTrackFootStep;
//	anim.notetracks['footstep_left_small'] = ::noteTrackFootStep;
//	anim.notetracks['footscrape'] = ::noteTrackFootScrape;
//	anim.notetracks['land'] = ::noteTrackLand;
//
//	anim.notetracks['laser_on'] = ::noteTrackLaser;
//	anim.notetracks['laser_off'] = ::noteTrackLaser;
//
//	anim.notetracks['start_ragdoll'] = ::noteTrackStartRagdoll;
//
//	anim.notetracks['fire'] = ::noteTrackFire;
//	anim.notetracks['fire_spray'] = ::noteTrackFireSpray;
//}
//
//noteTrackFire(note, flagName)
//{
//	if (isdefined(anim.fire_notetrack_functions[ self.a.script ]))
//		thread [[ anim.fire_notetrack_functions[ self.a.script ] ]]();
//	else
//		thread [[ animscripts\shared::shootNotetrack ]]();
//}
//
//noteTrackLaser(note, flagName)
//{
//	if (isSubStr(note, 'on'))
//		self.a.laserOn = true;
//	else
//		self.a.laserOn = false;
//	self animscripts\shared::updateLaserStatus();
//}
//
//
//noteTrackStopAnim(note, flagName)
//{
//}

function bool noteTrackStartRagdoll(name note, name flagName)
{
	if(noragdoll)
		return false; // Nate - hack for armless zakhaev who doesn't do ragdoll
	//self unlink();
	startRagdoll();

	return false;
}

function bool noteTrackMovementStop(name note, name flagName)
{
	a.movement = 'stop';
	return false;
}

function bool noteTrackMovementWalk(name note, name flagName)
{
	a.movement = 'walk';
	return false;
}

function bool noteTrackMovementRun(name note, name flagName)
{
	a.movement = 'run';
	return false;
}


//noteTrackAlertnessAiming(note, flagName)
//{
//	self.a.alertness = 'aiming';
//}
//
//noteTrackAlertnessCasual(note, flagName)
//{
//	self.a.alertness = 'casual';
//}
//
//noteTrackAlertnessAlert(note, flagName)
//{
//	self.a.alertness = 'alert';
//}


function bool noteTrackPoseStand(name note, name flagName)
{
	if (a.pose == 'prone')
	{
//		OrientMode ('face default');	// We were most likely in 'face current' while we were prone.
//		animscripts_utility.ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	}
	a.pose = 'stand';
	notify (name("entered_pose" $ "stand"));
	return false;
}

function bool noteTrackPoseCrouch(name note, name flagName)
{
	if (a.pose == 'prone')
	{
//		self OrientMode ('face default');	// We were most likely in 'face current' while we were prone.
//		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
////		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	}
	a.pose = 'crouch';
	notify (name("entered_pose" $ "crouch"));
//	if (a.crouchPain)
//	{
//		// for dying pain
//		a.crouchPain = false;
//		health = 150;
//	}
	return false;
}

function bool noteTrackPoseProne(name note, name flagName)
{
	setProneAnimNodes(-45, 45, 'prone_legs_down', 'exposed_aiming', 'prone_legs_up');
	animscripts_utility.EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
	a.pose = 'prone';
	notify (name("entered_pose" $ "prone"));
	return false;
}


function bool noteTrackPoseCrawl(name note, name flagName)
{
	setProneAnimNodes(-45, 45, 'prone_legs_down', 'exposed_aiming', 'prone_legs_up');
	animscripts_utility.EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
	a.pose = 'prone';
	notify (name("entered_pose" $ "prone"));
	return false;
}


//noteTrackPoseBack(note, flagName)
//{
//	if (self.a.pose == 'prone')
//	{
//		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
////		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
//	}
//	self.a.pose = 'back';
//	self notify ('entered_pose' + 'back');
//	self.a.movement = 'stop';
//}
//
//
//noteTrackGunHand(note, flagName)
//{
//	if (isSubStr(note, 'left'))
//		animscripts\shared::placeWeaponOn(self.weapon, 'left');
//	else if (isSubStr(note, 'right'))
//		animscripts\shared::placeWeaponOn(self.weapon, 'right');
//	else if (isSubStr(note, 'none'))
//		animscripts\shared::placeWeaponOn(self.weapon, 'none');
//}


function bool noteTrackGunDrop(name note, name flagName)
{
	pawn.ThrowActiveWeapon();

	//DropAIWeapon();

	//if (weapon == primaryweapon)
	//	weapon = secondaryweapon;
	//else if (weapon == secondaryweapon)
	//	weapon = primaryweapon;

	//lastWeapon = weapon;

	return false;
}


//noteTrackGunToChest(note, flagName)
//{
//	//assert(!usingSidearm());
//	animscripts\shared::placeWeaponOn(self.weapon, 'chest');
//}
//
//
//noteTrackGunToBack(note, flagName)
//{
//	animscripts\shared::placeWeaponOn(self.weapon, 'back');
//	// TODO: more asserts and elegant handling of weapon switching here
//	self.weapon = self getPreferredWeapon();
//	self.bulletsInClip = weaponClipSize(self.weapon);
//}
//
//
//noteTrackPistolPickup(note, flagName)
//{
//	animscripts\shared::placeWeaponOn(self.sidearm, 'right');
//	self.bulletsInClip = weaponClipSize(self.weapon);
//	self notify ('weapon_switch_done');
//}
//
//
//noteTrackPistolPutaway(note, flagName)
//{
//	animscripts\shared::placeWeaponOn(self.weapon, 'none');
//	// TODO: more asserts and elegant handling of weapon switching here
//	self.weapon = self getPreferredWeapon();
//	self.bulletsInClip = weaponClipSize(self.weapon);
//}
//
//
//noteTrackDropClip(note, flagName)
//{
//	self thread handleDropClip(flagName);
//}


function bool noteTrackRefillClip(name note, name flagName)
{
	if (weaponClass(weapon) == 'rocketlauncher')
		animscripts_combat_utility.showRocket();
	animscripts_weaponList.RefillClip();
	a.needsToRechamber = 0;
	return false;
}

//noteTrackLoadShell(note, flagName)
//{
//	self playSound('weap_reload_shotgun_loop_npc');
//}
//
//noteTrackPistolRechamber(note, flagName)
//{
//	self playSound('weap_reload_pistol_chamber_npc');
//}
//
//noteTrackGravity(note, flagName)
//{
//	if (isSubStr(note, 'on'))
//        self animMode('gravity');
//	else if (isSubStr(note, 'off'))
//		self animMode('nogravity');
//}
//
//
//noteTrackBodyFall(note, flagName)
//{
//	if (isDefined(self.groundType))
//		groundType = self.groundType;
//	else
//		groundType = 'dirt';
//
//	if (isSubStr(note, 'large'))
//		self playsound ('bodyfall_' + groundType + '_large');
//	else if (isSubStr(note, 'small'))
//		self playsound ('bodyfall_' + groundType + '_small');
//}
//
//
//noteTrackFootStep(note, flagName)
//{
//	if (isSubStr(note, 'left'))
//		playFootStep('J_Ball_LE');
//	else
//		playFootStep('J_BALL_RI');
//
//	self playSound('gear_rattle_run');
//}
//
//
//noteTrackFootScrape(note, flagName)
//{
//	if (isDefined(self.groundType))
//		groundType = self.groundType;
//	else
//		groundType = 'dirt';
//
//	self playsound ('step_scrape_' + groundType);
//}
//
//
//noteTrackLand(note, flagName)
//{
//	if (isDefined(self.groundType))
//		groundType = self.groundType;
//	else
//		groundType = 'dirt';
//
//	self playsound ('land_' + groundType);
//}



function bool HandleNoteTrack(name note, name flagName, optional DelegateHandleNoteTracks customFunction = none)
{
	//if (isAI(self) && self.type == 'dog')
	//	if (HandleDogSoundNoteTracks(note))
	//		return;

	if (anim.HandleNoteTrack(note, flagName))
		return true;

	if (_HandleNoteTrack(note, flagName))
		return true;

	switch (note)
	{
	case 'end':
	case 'finish':
	case 'undefined':
		return true;
//
//
//	case 'swish small':
//		self thread play_sound_in_space ('melee_swing_small', self gettagorigin ('TAG_WEAPON_RIGHT'));
//		break;
////		case 'melee':
//	case 'swish large':
//		self thread play_sound_in_space ('melee_swing_large', self gettagorigin ('TAG_WEAPON_RIGHT'));
//		//self thread play_sound_in_space ('melee_swing_large', self gettagorigin ('TAG_WEAPON_RIGHT'));
//		break;
//// SOUNDS END
//
//	case 'rechamber':
//		if (self usingShotgun())
//			self playSound('weap_reload_shotgun_pump_npc');
//		self.a.needsToRechamber = 0;
//		break;
//	case 'no death':
//		// does not play a death anim when he dies
//		self.a.nodeath = true;
//		break;
//	case 'no pain':
//		self.allowpain = false;
//		break;
//	case 'allow pain':
//		self.allowpain = true;
//		break;
//	case 'anim_melee = right':
//	case 'anim_melee = \'right\'':
//		self.a.meleeState = 'right';
//		break;
//	case 'anim_melee = left':
//	case 'anim_melee = \'left\'':
//		self.a.meleeState = 'left';
//		break;
//	case 'weapon_retrieve':
//	/*
//		assertEx(isdefined(self.oldWeapon), 'Tried to do notetrack weapon_retrieve but pistol_pickup had never been used');
//		self.secondaryWeapon = self.weapon;
//		self.weapon = self.oldWeapon;
//		self animscripts\shared::PutGunInHand('right');
//		*/
//		break;
//	case 'swap taghelmet to tagleft':
//		if (isDefined (self.hatModel))
//		{
//			if (isdefined(self.helmetSideModel))
//			{
//				self detach(self.helmetSideModel, 'TAG_HELMETSIDE');
//				self.helmetSideModel = undefined;
//			}
//			self detach (self.hatModel, '');
//			self attach (self.hatModel, 'TAG_WEAPON_LEFT');
//			self.hatModel = undefined;
//		}
//		break;
//	case 'stop anim':
//		anim_stopanimscripted();
//		return note;
////		break;
	default:
		if (customFunction != none)
			return customFunction.execute(note);
	}
	return false;
}

// DoNoteTracks waits for and responds to standard noteTracks on the animation, returning when it gets an 'end' or a 'finish'
// For level scripts, a pointer to a custom function should be passed as the second argument, which handles notetracks not
// already handled by the generic function. This call should take the form DoNoteTracks(flagName, ::customFunction);
// The custom function will be called for each notetrack not recognized, and will pass the notetrack name. Note that this
// function could be called multiple times for a single animation.
function DoNoteTracks(name flagName, optional DelegateHandleNoteTracks customFunction = none, optional bool newThread = false)/*, customFunction, debugIdentifier) */ // debugIdentifier isn't even used. we should get rid of it.
{
	local shared_DoNoteTracks task;
	task = new(self) class'shared_DoNoteTracks';
	task.iFlagName = flagName;
	task.iCustomFunction = customFunction;
	run(task, newThread);
}


//DoNoteTracksIntercept(flagName, interceptFunction, debugIdentifier) // debugIdentifier isn't even used. we should get rid of it.
//{
//	assert(isDefined(interceptFunction));
//
//	for (;;)
//	{
//		self waittill (flagName, note);
//
//		if (!isDefined(note))
//			note = 'undefined';
//
//		intercepted = [[interceptFunction]](note);
//		if (isDefined(intercepted) && intercepted)
//			continue;
//
//		//prof_begin('HandleNoteTrack');
//		val = self HandleNoteTrack(note, flagName);
//		//prof_end('HandleNoteTrack');
//
//		if (isDefined(val))
//			return val;
//	}
//}


function DoNoteTracksPostCallback(name flagName, DelegateNoteTracksPostCallback postFunction, optional bool newThread = false)
{
	local shared_DoNoteTracksPostCallback task;
	task = new(self) class'shared_DoNoteTracksPostCallback';
	task.iFlagName = flagName;
	task.iPostFunction = postFunction;
	run (task, newThread);
}

// Don't call this function except as a thread you're going to kill - it lasts forever.
function DoNoteTracksForever(name flagName, name killString, optional bool newThread = false)
{
	local shared_DoNoteTracksForever task;
	task = new(self) class'shared_DoNoteTracksForever';
	task.flagName = flagName;
	task.killString = killString;
	run (task, newThread);
}

//DoNoteTracksForeverIntercept(flagName, killString, interceptFunction, debugIdentifier)
//{
//	DoNoteTracksForeverProc(::DoNoteTracksIntercept, flagName, killString, interceptFunction, debugIdentifier);
//}
//
//DoNoteTracksForeverProc(notetracksFunc, flagName, killString, customFunction, debugIdentifier)
//{
//	if (isdefined (killString))
//		self endon (killString);
//	self endon ('killanimscript');
//	if (!isDefined(debugIdentifier))
//		debugIdentifier = 'undefined';
//
//	for (;;)
//	{
//		//prof_begin('DoNoteTracksForeverProc');
//		time = GetTime();
//		//prof_begin('notetracksFunc');
//		returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
//		//prof_end('notetracksFunc');
//		timetaken = GetTime() - time;
//		if (timetaken < 0.05)
//		{
//			time = GetTime();
//			//prof_begin('notetracksFunc');
//			returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
//			//prof_end('notetracksFunc');
//			timetaken = GetTime() - time;
//			if (timetaken < 0.05)
//			{
//				println (GetTime()+' '+debugIdentifier+' animscripts\shared::DoNoteTracksForever is trying to cause an infinite loop on anim '+flagName+', returned '+returnedNote+'.');
//				wait (0.05 - timetaken);
//			}
//		}
//		//(GetTime()+' '+debugIdentifier+' DoNoteTracksForever returned in '+timetaken+' ms.');#/
//		//prof_end('DoNoteTracksForeverProc');
//	}
//}

// Designed for using DoNoteTracks on looping animations, so you can wait for a time instead of the 'end' parameter
function DoNoteTracksForTime(float time, name flagName, optional bool newThread = false)
{
	local shared_DoNoteTracksForTime task;
	task = new(self) class'shared_DoNoteTracksForTime';
	task.time = time;
	task.flagName = flagName;
	run(task, newThread);
}

//DoNoteTracksForTimeIntercept(time, flagName, interceptFunction, debugIdentifier)
//{
//	ent = spawnstruct();
//	ent thread doNoteTracksForTimeEndNotify(time);
//	DoNoteTracksForTimeProc(::DoNoteTracksForeverIntercept, time, flagName, interceptFunction, debugIdentifier, ent);
//}
//
//DoNoteTracksForTimeProc(doNoteTracksForeverFunc, time, flagName, customFunction, debugIdentifier, ent)
//{
//	ent endon ('stop_notetracks');
//	[[doNoteTracksForeverFunc]](flagName, undefined, customFunction, debugIdentifier);
//}

//playFootStep(foot)
//{
//	if (! isAI(self))
//	{
//		self playsound ('step_run_dirt');
//		return;
//	}
//
//	groundType = undefined;
//	// gotta record the groundtype in case it goes undefined on us
//	if (!isdefined(self.groundtype))
//	{
//		if (!isdefined(self.lastGroundtype))
//		{
//			self playsound ('step_run_dirt');
//			return;
//		}
//
//		groundtype = self.lastGroundtype;
//	}
//	else
//	{
//		groundtype = self.groundtype;
//		self.lastGroundtype = self.groundType;
//	}
//
//	self playsound ('step_run_' + groundType);
//	[[anim.optionalStepEffectFunction]](foot, groundType);
//}
//
//
//playFootStepEffect(foot, groundType)
//{
//	for (i=0;i<anim.optionalStepEffects.size;i++)
//	{
//		if (groundType != anim.optionalStepEffects[i])
//			continue;
//		org = self gettagorigin(foot);
//		playfx(level._effect['step_' + anim.optionalStepEffects[i]], org, org + (0,0,100));
//		return;
//	}
//}
//
//shootNotetrack()
//{
//	waittillframeend; // this gives a chance for anything else waiting on 'fire' to shoot
//	if (gettime() > self.a.lastShootTime)
//	{
//		self shootEnemyWrapper();
//		self decrementBulletsInClip();
//		if (weaponClass(self.weapon) == 'rocketlauncher')
//			self.a.rockets--;
//	}
//}
//
//fire_straight()
//{
//	if (self.a.weaponPos[ 'right' ] == 'none')
//		return;
//
//	if (isdefined(self.dontShootStraight))
//	{
//		shootNotetrack();
//		return;
//	}
//
//	weaporig = self gettagorigin('tag_weapon');
//	dir = anglestoforward(self gettagangles('tag_weapon'));
//	pos = weaporig + vectorScale(dir, 1000);
//	// note, shootwrapper is not called because shootwrapper applies a random spread, and shots
//	// fired in a scripted sequence need to go perfectly straight so they get the same result each time.
//	self shoot(1, pos);
//	self decrementBulletsInClip();
//}

function bool NoteTrackFireSpray(name note, name flagName)
{
	local vector lWeapOrig;
	local vector lDir;
	local bool lHitEnemy;
	local vector lEnmeyDir;
	local vector lPos;
//	// TODO: make AI not use anims with this notetrack if they don't have a weapon
//	if (self.a.weaponPos['right'] == 'none')
//		return;

	//prof_begin('noteTrackFireSpray');

	lWeapOrig = gettagorigin('tag_weapon');
	lDir = anglestoforward(gettagangles('tag_weapon'));

	lHitEnemy = false;
	// check if we're aiming closish to our enemy
	if (issentient(enemy) && isalive(enemy) && canShoot(enemy.getShootAtPos()))
	{
		lEnmeyDir = vectornormalize(enemy.geteye() - lWeapOrig);
		if (vectordot(lDir, lEnmeyDir) > cos(10 * 3.14159 / 180))
		{
			lHitEnemy = true;
		}
	}

	if (lHitEnemy)
	{
		animscripts_utility.shootEnemyWrapper();
	}
	else
	{
		lDir.x += (randomfloat(2)-1) * 0.1;
		lDir.y += (randomfloat(2)-1) * 0.1;
		lDir.z += (randomfloat(2)-1) * 0.1;
		lPos = lWeapOrig + vectorScale(lDir, 1000);

		animscripts_utility.shootPosWrapper(lPos);
	}

	animscripts_combat_utility.decrementBulletsInClip();

	//prof_end('noteTrackFireSpray');
	return false;
}


function float GetPredictedAimYawToShootEntOrPos(float iTime)
{
	local vector lPredictedPos;
	if (!obj_isdefined(shootEnt))
	{
		if (!vec_isdefined(shootPos))
			return 0;

		return getAimYawToPoint(shootPos);
	}

	lPredictedPos = shootEnt.origin + vectorScale(shootEntVelocity, iTime);
	return getAimYawToPoint(lPredictedPos);
}

function float GetAimYawToShootEntOrPos()
{
	// make use of the fact that shootPos = shootEnt getShootAtPos() if shootEnt is defined
	if (shootEnt == none)
	{
		if (shootPos == invalid_vector)
			return 0;

		return getAimYawToPoint(shootPos);
	}

	return getAimYawToPoint(shootEnt.getShootAtPos());
}

//getAimPitchToShootEntOrPos()
//{
//	pitch = getPitchToShootEntOrPos();
//	if (self.a.script == 'cover_crouch' && isdefined(self.a.coverMode) && self.a.coverMode == 'lean')
//		pitch -= anim.coverCrouchLeanPitch;
//	return pitch;
//}
//
//getPitchToShootEntOrPos()
//{
//	if (!isdefined(self.shootEnt))
//	{
//		// make use of the fact that shootPos = shootEnt getShootAtPos() if shootEnt is defined
//		if (!isdefined(self.shootPos))
//			return 0;
//
//		return animscripts\combat_utility::getPitchToSpot(self.shootPos);
//	}
//
//	return animscripts\combat_utility::getPitchToSpot(self.shootEnt getShootAtPos());
//}

function float GetAimYawToPoint(vector point)
{
	local float yaw;
	local float dist;
	local float angleFudge;

	yaw = animscripts_utility.GetYawToSpot(point);

	// need to have fudge factor because the gun's origin is different than our origin,
	// the closer our distance, the more we need to fudge.
	dist = distance(origin, point);
	if(dist > 3)
	{
		angleFudge = asin(-3/dist);
		yaw += angleFudge;
	}
	yaw = AngleClamp180(yaw);
	return yaw;
}

function TrackShootEntOrPos(optional bool newThread = false)
{
	run (new(self) class'shared_TrackShootEntOrPos', newThread);
}

function TrackLoop(name aim2, name aim4, name aim6, name aim8, optional bool newThread = false)
{
	local shared_TrackLoop task;
	task = new(self) class'shared_TrackLoop';
	task.aim2 = aim2;
	task.aim4 = aim4;
	task.aim6 = aim6;
	task.aim8 = aim8;
	run (task, newThread);

}

//setAnimAimWeight works just like setanimlimited on an imaginary anim node that affects the four aiming directions.
function setAnimAimWeight(float goalweight, optional float goaltime = -1)
{
	if (goaltime <= 0)
	{
		a.aimweight = goalweight;
		a.aimweight_start = goalweight;
		a.aimweight_end = goalweight;
		a.aimweight_transframes = 0;
	}
	else
	{
		a.aimweight = goalweight;
		a.aimweight_start = a.aimweight;
		a.aimweight_end = goalweight;
		a.aimweight_transframes = int(goaltime * 20);
	}
	a.aimweight_t = 0;
}

function IncrAnimAimWeight()
{
	local float t;

	if (a.aimweight_t < a.aimweight_transframes)
	{
		a.aimweight_t += 1;
		t = 1.0 * a.aimweight_t / a.aimweight_transframes;
		a.aimweight = a.aimweight_start * (1 - t) + a.aimweight_end * t;
	}
}

function int DefaultNumShots()
{
	local int lNumShots;
	local int lRandomInt;
	local int lCount;

	lCount = 5;
	lNumShots = 0;
	if (UseFireNumShots)
	{
		lRandomInt = randomint(FireNumShots[lCount - 1]);
		for (lNumShots = 0; lNumShots < lCount; lNumShots ++)
		{
			if (lRandomInt < FireNumShots[lNumShots])
				break;
		}

		lNumShots += 1;
	}
	else
		lNumShots = 1;

	if (lNumShots <= bulletsInClip)
		return lNumShots;

	//assertex(self.bulletsInClip >= 0, self.bulletsInClip);

	if (bulletsInClip <= 0)
		return 1;

	return bulletsInClip;
}

// decides on the number of shots to do in a burst.
function int DecideNumShotsForBurst()
{
	local int lNumShots;
	local int lRandomInt;
	local int lCount;

	lCount = 5;
	lNumShots = 0;
	if (UseFireNumShots)
	{
		lRandomInt = randomint(FireNumShots[lCount - 1]);
		for (lNumShots = 0; lNumShots < lCount; lNumShots ++)
		{
			if (lRandomInt < FireNumShots[lNumShots])
				break;
		}

		lNumShots += 1;
	}
	else
	{
		if (animscripts_weaponList.usingSemiAutoWeapon())
		{
			lNumShots = anim.semiFireNumShots[ randomint(anim.semiFireNumShots.length) ];
		}
		else if (fastBurst)
		{
			lNumShots = anim.fastBurstFireNumShots[ randomint(anim.fastBurstFireNumShots.length) ];
		}
		else
		{
			lNumShots = anim.burstFireNumShots[ randomint(anim.burstFireNumShots.length) ];
		}
	}

	if (lNumShots <= bulletsInClip)
		return lNumShots;

	//assertex(self.bulletsInClip >= 0, self.bulletsInClip);

	if (bulletsInClip <= 0)
		return 1;

	return bulletsInClip;
}

function int DecideNumShotsForFull()
{
	local int lNumShots;
	local float lChoice;

	lNumShots = bulletsInClip;
	if (weaponClass(weapon) == 'mg')
	{
		lChoice = randomfloat(10);
		if (lChoice < 3)
			lNumShots = randomIntRange(2, 6);
		else if (lChoice < 8)
			lNumShots = randomIntRange(6, 12);
		else
			lNumShots = randomIntRange(12, 20);
	}

	return lNumShots;
}

//handleDropClip(flagName)
//{
//	self endon ('killanimscript');
//	self endon ('abort_reload');
//
//	//prof_begin('handleDropClip');
//
//	clipModel = undefined;
//
//	if (self.weaponInfo[self.weapon].useClip)
//	{
//		clipModel = getWeaponClipModel(self.weapon);
//
//		if (!isDefined(level.weaponClipModelsLoaded) || !isDefined(anim._effect[ clipModel ]))
//		{
//			println('^1Warning: Couldn't drop clip model ' + clipModel + ' because it is not in level.weaponClipModels so it probably wasn't precached.');
//			println('^1Set dvar scr_generateClipModels to 1 and map_restart, then follow instructions in console.');
//
//			clipModel = undefined;
//		}
//	}
//
//	if (self.weaponInfo[self.weapon].hasClip)
//	{
//		if (animscripts_utility.weaponAnims() == 'pistol')
//			self playsound('weap_reload_pistol_clipout_npc');
//		else
//			self playsound('weap_reload_smg_clipout_npc');
//
//		if (isDefined(clipModel))
//		{
//			self hidepart('tag_clip');
//			assert(isDefined(anim._effect[clipModel]));
//			playFxOnTag(anim._effect[clipModel], self, 'tag_clip');
//			self.weaponInfo[self.weapon].hasClip = false;
//
//			self thread resetClipOnAbort(clipModel);
//		}
//	}
//
//	//prof_end('handleDropClip');
//
//	for (;;)
//	{
//		self waittill(flagName, noteTrack);
//
//		switch (noteTrack)
//		{
// 		case 'attach clip left':
// 		case 'attach clip right':
// 			if (isdefined(clipModel))
// 			{
//				self attach(clipModel, 'tag_inhand');
//				self hidepart('tag_clip'); // attach() resets hidden parts, so we must re-hide the clip
//				self thread resetClipOnAbort(clipModel, 'tag_inhand');
//			}
//
//			// if we abort the reload after this point, we don't want to have to do it again
//			self animscripts\weaponList::RefillClip();
//
// 			break;
////		case 'end':
////		case 'finish':
////		case 'undefined':
// 		case 'detach clip right':
// 		case 'detach clip left':
//  			if (isdefined(clipModel))
// 			{
//				self detach(clipModel, 'tag_inhand');
//				self showpart('tag_clip');
// 				self notify ('clip_detached');
//				self.weaponInfo[self.weapon].hasClip = true;
//			}
//
//			if (animscripts_utility.weaponAnims() == 'pistol')
//				self playsound('weap_reload_pistol_clipin_npc');
//			else
//				self playsound('weap_reload_smg_clipin_npc');
//
//			self.a.needsToRechamber = 0;
//
// 			return;
//		}
//	}
//}
//
//
//resetClipOnAbort(clipModel, currentTag)
//{
//	self notify ('clip_detached');
//	self endon ('clip_detached');
//	//self endon ('death'); // don't end on death or we won't delete the clip when we die!
//
//	self waittill_any('killanimscript', 'abort_reload');
//
//	// we can be dead but still defined. if we're undefined we got deleted.
//	if (!isDefined(self))
//		return;
//
//	if (isDefined(currentTag))
//		self detach(clipModel, currentTag);
//
//	if (isAlive(self))
//	{
//		self showpart('tag_clip');
//		self.weaponInfo[self.weapon].hasClip = true;
//	}
//	else
//	{
//		if (isDefined(currentTag) && isDefined(anim._effect[clipModel]))
//			playFxOnTag(anim._effect[clipModel], self, currentTag);
//	}
//}


function MoveToOriginOverTime(vector iOrigin, float iTime, optional bool newThread = false)
{
	local shared_MoveToOriginOverTime task;

	task = new(self) class'shared_MoveToOriginOverTime';
	task.iOrigin = iOrigin;
	task.iTime = iTime;
	run (task, newThread);
}

function bool ReturnTrue() { return true; }

function PlayLookAnimation(name iLookAnim, float iLookTime, optional DelegateCanStop iCanStopCallback, optional bool newThread = false)
{
	local shared_PlayLookAnimation task;
	task = new(self) class'shared_PlayLookAnimation';
	task.iLookAnim = iLookAnim;
	task.iLookTime = iLookTime;
	task.iCanStopCallback = iCanStopCallback;

	run (task, newThread);
}


function ThrowDownWeapon(name iswapAnim)
{
//	self endon ('killanimscript');
//
//	// Too many issues right now
////	self animMode('angle deltas');
////	self setFlaggedAnimKnobAllRestart('weapon swap', iswapAnim, %body, 1, .1, 1);
////	self DoNoteTracks('weapon swap');
//
//	self animscripts\shared::placeWeaponOn(self.secondaryweapon, 'right');
//
//	self maps\_gameskill::didSomethingOtherThanShooting();
}
