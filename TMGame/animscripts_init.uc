// Notes about scripts
//=====================
//
// Anim variables
// -------------- 
// Anim variables keep track of what the character is doing with respect to his 
// animations.  They know if he's standing, crouching, kneeling, walking, running, etc, 
// so that he can play appropriate transitions to get to the animation he wants.
// anim_movement - 'stop', 'walk', 'run'
// anim_pose - 'stand', 'crouch', 'prone', some others for pain poses.
// I'm putting functions to do the basic animations to change these variables in 
// SetPoseMovement.gsc, 
//
// Error Reporting
// ---------------
// To report a script error condition (similar to assert(0)), I assign a non-existent variable to 
// the variable homemade_error  I use the name of the non-existent variable to try to explain the 
// error.  For example:
// 		homemade_error = Unexpected_anim_pose_value + self.a.pose;
// I also have a kind of assert, called as follows:
//		[[anim.assertEX(condition, message_string);
// If condition evaluates to 0, the assert fires, prints message_string and stops the server. Since 
// I don't have stack traces of any kind, the message string needs to say from where the assert was 
// called.
class animscripts_init extends Object within HodAI
	dependson(animscripts_utility)
	dependson(general_human);

var array<TGAnimNodeSequence> trans_anim;
//initWeapon(weapon, slot)
//{
//	self.weaponInfo[weapon] = spawnstruct();
//	
//	self.weaponInfo[weapon].position = 'none';
//	self.weaponInfo[weapon].hasClip = true;
//	if (getWeaponClipModel(weapon) != '')
//		self.weaponInfo[weapon].useClip = true;
//	else
//		self.weaponInfo[weapon].useClip = false;
//}

function main()
{
//	prof_begin('animscript_init');
//	self.a = spawnStruct();
//	self.a.laserOn = false;
	primaryweapon = weapon;
	
//	self initWeapon(self.primaryweapon, 'primary');
//	self initWeapon(self.secondaryweapon, 'secondary');
//	self initWeapon(self.sidearm, 'sidearm');
	
	a.weaponPos.Add(4);
	a.weaponPos[WeaponPoseID('left')] = 'none';
	a.weaponPos[WeaponPoseID('right')] = 'none';
	a.weaponPos[WeaponPoseID('chest')] = 'none';
	a.weaponPos[WeaponPoseID('back')] = 'none';

//	self.lastWeapon = self.weapon;
//	self.root_anim = %root;
//	
//	self thread beginGrenadeTracking();
	
	firstInit();
	
	isSniper = animscripts_combat_utility.isSniperRifle(primaryweapon);
	
//	// TODO: proper ammo tracking
//	self.a.rockets = 3;
//	self.a.rocketVisible = true;
//	
//	anim.nonstopFireguy++;
//	if (anim.nonstopFireguy >= 2)
//	{
//		self.a.nonstopFire = true;
//		anim.nonstopFireguy = 0;
//	}
//	else
//		self.a.nonstopFire = false;
//	self.a.nonstopFire = false;
//	
//	anim.reacquireNum--;
//	if (anim.reacquireNum <= 0 && self.team == 'axis')
//	{
//		anim.reacquireNum = 1;
//     	self.a.reacquireGuy = true;
//    }
//	else
//     	self.a.reacquireGuy = false;
//
////	SetWeaponDist();
////	SetAmmoCounts();
		
	// Set initial states for poses
	a.pose = 'stand';
	a.movement = 'stop';
	a.state = 'stop';
	a.special = 'none';
//	self.a.gunHand = 'none';	// Initialize so that PutGunInHand works properly.
//	self.a.PrevPutGunInHandTime = -1;

	animscripts_shared.placeWeaponOn(primaryweapon, 'right');
	if (weaponclass(secondaryweapon) == 'spread')
		animscripts_shared.placeWeaponOn(secondaryweapon, 'back');

//	self.a.needsToRechamber = 0;
	a.combatEndTime = gettime();
	a.script = 'init';
	a.alertness = 'casual'; // casual, alert, aiming
	a.lastEnemyTime = gettime();
	a.forced_cover = 'none';
	a.suppressingEnemy = false;
	a.desired_script = 'none';
	a.current_script = 'none';
	a.disableLongDeath = team != 'axis';
	a.lookangle = 0;
	a.painTime = 0;
	a.lastShootTime = 0;
	a.nextGrenadeTryTime = 0;
	a.magicReloadWhenReachEnemy = false;
	
//	if (self.team == 'allies' && !issubstr(self.classname, 'russian') && weapons_with_ir(self.weapon))
//	{
//		// only select allies have IR laser and beacon
//		self.has_ir = true;	
//	}
	
	a.postScriptFunc = none;
	a.stance = 'stand';
//	//self.a.state = 'idle';
	
//	self._animActive = 0;
//	self._lastAnimTime = 0;
////	self.a.ignoreSuppressionTime = 0;
//	
//	self thread deathNotify();
//	self thread enemyNotify();
	
	baseAccuracy = 1;
	a.missTime = 0;
	
//	self.a.yawTransition = 'none';
	a.nodeath = false;
////	self.baseAccuracy = self.accuracy * 2.5;
	a.missTime = 0;
	a.missTimeDebounce = 0;
//	self.a.disablePain = false;
//
//	self.accuracyStationaryMod = 1;
//	self.chatInitialized = false;
//	self.sightPosTime = 0;
//	self.sightPosLeft = true;
//	self.preCombatRunEnabled = true;
//	self.goodShootPosValid = false;
//	self.needRecalculateGoodShootPos = true;
//	self.a.grenadeFlee = %run_lowready_F;
//	
//	self.a.crouchpain = false; // for dying pain guys
	a.nextStandingHitDying = false;
//	anim_set_next_move_to_new_cover();
//
//	// Makes AI able to throw grenades at other AI.
//	if (!isdefined (self.script_forcegrenade))
//		self.script_forcegrenade = 0;
///#
//	self.a.lastDebugPrint = '';
//#/
	a.StopCowering = DoNothing;
	
	SetupUniqueAnims();

////	thread testLife();
//	thread animscripts\look::lookThread();
///#
//	thread animscripts\utility::UpdateDebugInfo();
//#/
	
	animscripts_weaponList.RefillClip();	// Start with a full clip.

//	// state tracking
//	self.lastEnemySightTime = 0; // last time we saw our current enemy
//	self.combatTime = 0; // how long we've been in/out of combat
//
	suppressed = false; // if we're currently suppressed
//	self.suppressedTime = 0; // how long we've been in/out of suppression

	if (team == 'allies')
		suppressionThreshold = 0.75;
	else
		suppressionThreshold = 0.5;
////	self.groupsightpos = undefined;
//	
//	// Random range makes the grenades less accurate and do less damage, but also makes it difficult to throw back.
//	if (self.team == 'allies')
//		self.randomGrenadeRange = 0;
//	else
//		self.randomGrenadeRange = 128;
//
//   // Things that were in scripts that should be done once, or on weapon switch
//	if (animscripts\weaponList::usingAutomaticWeapon())
//		self.ramboChance = 15;
//	else if (animscripts\weaponList::usingSemiAutoWeapon())
//		self.ramboChance = 7;
//	else
//		self.ramboChance = 0;
//	if (self.team == 'axis')
//		self.ramboChance *= 2;
//
//    self.coverIdleSelectTime = -696969;
//    self.exception = [];
//    
//    self.exception[ 'corner' ] = 1;
//    self.exception[ 'cover_crouch' ] = 1;
//    self.exception[ 'stop' ] = 1;
//    self.exception[ 'stop_immediate' ] = 1;
//    self.exception[ 'move' ] = 1;
//    self.exception[ 'exposed' ] = 1;
//    self.exception[ 'corner_normal' ] = 1;
//
//	keys = getArrayKeys(self.exception);
//	for (i=0; i < keys.size; i++)
//	{
//		clear_exception(keys[ i ]);
//	}
//	
//	self.old = spawnstruct();
	
	reacquire_state = 0;
	
//	self thread setNameAndRank();
//	
//	self thread animscripts\squadManager::addToSquad(); // slooooow
//	
//	self.shouldConserveAmmoTime = 0;
//	
//	/#
//	self thread printEyeOffsetFromNode();
//	self thread showLikelyEnemyPathDir();
//	#/
//	
//	self thread monitorFlash();
	
	onDeath(true);

//	prof_end('animscript_init');
}

//weapons_with_ir(weapon)
//{
//	weapons[0] = 'm4_grenadier';
//	weapons[1] = 'm4_grunt';
//	weapons[2] = 'm4_silencer';
//	weapons[3] = 'm4m203';
//
//	if (!isdefined(weapon))
//		return false;
//
//	for(i = 0 ; i < weapons.size ; i ++)
//	{
//		if (issubstr(weapon, weapons[i]))
//			return true;
//	}
//	return false;
//}
//
///#
//printEyeOffsetFromNode()
//{
//	self endon('death');
//	while(1)
//	{
//		if (getdvarint('scr_eyeoffset') == self getentnum())
//		{
//			if (isdefined(self.coverNode))
//			{
//				offset = self geteye() - self.coverNode.origin;
//				forward = anglestoforward(self.coverNode.angles);
//				right = anglestoright(self.coverNode.angles);
//				trueoffset = (vectordot(right, offset), vectordot(forward, offset), offset[2]);
//				println(trueoffset);
//			}
//		}
//		else
//			wait 2;
//		wait .1;
//	}
//}
//
//showLikelyEnemyPathDir()
//{
//	self endon('death');
//	if (getdvar('scr_showlikelyenemypathdir') == '')
//		setdvar('scr_showlikelyenemypathdir', '-1');
//	while(1)
//	{
//		if (getdvarint('scr_showlikelyenemypathdir') == self getentnum())
//		{
//			yaw = self.angles[1];
//			dir = self getAnglesToLikelyEnemyPath();
//			if (isdefined(dir))
//				yaw = dir[1];
//			printpos = self.origin + (0,0,60) + anglestoforward((0,yaw,0)) * 100;
//			line(self.origin + (0,0,60), printpos);
//			if (isdefined(dir))
//				print3d(printpos, 'likelyEnemyPathDir: ' + yaw, (1,1,1), 1, 0.5);
//			else
//				print3d(printpos, 'likelyEnemyPathDir: undefined', (1,1,1), 1, 0.5);
//			
//			wait .05;
//		}
//		else
//			wait 2;
//	}
//}
//#/
//
//setNameAndRank()
//{
//	self endon ('death');
//	if (!isdefined (level.loadoutComplete))
//		level waittill ('loadout complete');
//		
//	self maps\_names::get_name();
//}
//
//SetWeaponDist()
//{
//	// changed to pathenemyFightdist and pathenemyLookahead and engagementMinDist etc
//	self.fightDist = WeaponFightDist(self.weapon);
//	if (animscripts\weaponList::usingAutomaticWeapon())
//	{
//		self.minDist = 64;
//		self.maxDist = 512;
//	}
//	else if (animscripts\weaponList::usingSemiAutoWeapon())
//	{
//		self.minDist = 128;
//		self.maxDist = 700;
//	}
//	else if (animscripts\utility::usingBoltActionWeapon())
//	{
//		self.minDist = 768;
//		self.maxDist = 1500;
//	}
//	else if (animscripts\weaponList::usingShotgunWeapon())
//	{
//		self.minDist = 16; 
//		self.maxDist = 256;	
//	}
//}
//
//
//SetAmmoCounts()
//{
////	self.ammoCounts[self.weapon] = getAIMaxAmmo(self.weapon);
////	self.ammoCounts[self.secondaryweapon] = getAIMaxAmmo(self.secondaryweapon);
////	self.ammoCounts[self.sidearm] = getAIMaxAmmo(self.sidearm);
//}
//
//
//DoNothing()
//{
//}
//
//// Debug thread to see when stances are being allowed
//PollAllowedStancesThread()
//{
//	for (;;)
//	{
//		if (self isStanceAllowed('stand'))
//		{
//			line[0] = 'stand allowed';
//			color[0] = (0,1,0);
//		}
//		else
//		{
//			line[0] = 'stand not allowed';
//			color[0] = (1,0,0);
//		}
//		if (self isStanceAllowed('crouch'))
//		{
//			line[1] = 'crouch allowed';
//			color[1] = (0,1,0);
//		}
//		else
//		{
//			line[1] = 'crouch not allowed';
//			color[1] = (1,0,0);
//		}
//		if (self isStanceAllowed('prone'))
//		{
//			line[2] = 'prone allowed';
//			color[2] = (0,1,0);
//		}
//		else
//		{
//			line[2] = 'prone not allowed';
//			color[2] = (1,0,0);
//		}
//
//
//		aboveHead = self getshootatpos() + (0,0,30);
//		offset = (0,0,-10);
//		for (i=0 ; i<line.size ; i++)
//		{
//			textPos = (aboveHead[0]+(offset[0]*i), aboveHead[1]+(offset[1]*i), aboveHead[2]+(offset[2]*i));
//			print3d (textPos, line[i], color[i], 1, 0.75);	// origin, text, RGB, alpha, scale
//		}
//		wait 0.05;
//	}
//}

function SetupUniqueAnims()
{
	//if (!isDefined(self.animplaybackrate) || !isDefined(self.moveplaybackrate))
	//{
		set_anim_playback_rate();
	//}
}

function set_anim_playback_rate()
{
	animplaybackrate = 0.9 + randomfloat(0.2);
	moveplaybackrate = 1; 
}


//infiniteLoop(one, two, three, whatever)
//{
//	anim waittill('new exceptions');
//}
//
//empty(one, two, three, whatever)
//{
//}
//
//
//removeFirstArrayIndex(array)
//{
//	newArray = [];
//	for (i=1;i<array.size;i++)
//		newArray[newArray.size] = array[i];
//	return newArray;
//}
//
//
//// Changes the AI's aim based on how recently they saw their enemy
//lastSightUpdater()
//{
//	self endon ('death');
//	self.personalSightTime = -1;
//	personalSightPos = self.origin;
//	
//	reacquireTime = 3000;
//	thread trackVelocity();
//	
//	thread previewSightPos();
//	thread previewAccuracy();
//
//	lastEnemy = undefined;
//	hasLastEnemySightPos = false;
//	for (;;)
//	{
//		if (!isdefined (self.squad))
//		{
//			wait (0.2);
//			continue;
//		}
//		
//		if (isdefined (lastEnemy) && isalive (self.enemy) && lastEnemy != self.enemy)
//		{
//			personalSightPos = self.origin;
//			self.personalSightTime = -1;
//		}
//		
//		lastEnemy = self.enemy;
//		
//		/*
//		if (isdefined(self.squad.sightpos))
//		{
//			if (!isdefined (lastGroupSightSpot))
//			{
//				self.goodShootPos = undefined;
//				thread resetAccuracy();
//			}
//			else
//			{
//				if (distance (lastGroupSightSpot, self.squad.sightpos) > 80)
//				{
//					self.goodShootPos = undefined;
//					thread resetAccuracy();
//				}
//			}
//		}
//		*/
//		
//	
//		if (isdefined (self.lastEnemySightPos) && isalive (self.enemy))
//		{
//			// If you have no personalSightPos or the enemy position has changed or
//			// the enemy is near the last place you saw him, then refresh it
//			if (distance(self.enemy.origin, self.lastEnemySightPos) < 100)
//			{
//				personalSightPos = self.lastEnemySightPos;
//				self.personalSightTime = gettime();
//
//				hasLastEnemySightPos = true;
//			}
//			else
//			if (self.enemy == level.player)
//			{
//				hasLastEnemySightPos = false;
//			}
//		}
//		else
//			hasLastEnemySightPos = false;
//
////				if (newtime - personalSightTime > reacquireTime)
////					thread resetAccuracy();
//
//		/*	
//		if (!isdefined (self.squad.sightpos))
//		{
// 			if (isdefined (personalSightPos))
// 			{
//				self.squad.sightpos = personalSightPos;
//				self.squad.sightTime = personalSightTime;
//			}
//			wait (0.05);
//			continue;
//		}
//		*/
//
//		/*
//		if (self.personalSightTime > self.squad.sightTime && isalive (self.enemy))
//		{
//			self.squad.sightpos = personalSightPos;
//			self.squad.sightTime = self.personalSightTime;
//			self.squad.sightEnemy = self.enemy;
//			self.squad thread clearEnemy();
//		}
//		else
//		{
//			personalSightPos = self.squad.sightpos;
//			personalSightTime = self.squad.sightTime;
//		}
//		*/
//		
//		wait (0.05);
//	}
//}
//
//clearEnemy()
//{
//	self notify ('stop waiting for enemy to die');
//	self endon ('stop waiting for enemy to die');
//	self.sightEnemy waittill ('death');
//	self.sightpos = undefined;
//	self.sightTime = 0;
//	self.sightEnemy = undefined;
//}
//
//previewSightPos()
//{
//	/#
//	self endon ('death');
//	for (;;)
//	{
//		if (getdebugdvar ('debug_lastsightpos') != 'on')
//		{
//			wait (1);
//			continue;
//		}
//		
//		wait (0.05);
//		if (!isdefined(self.lastEnemySightPos))
//			continue;
//
//		print3d (self.lastEnemySightPos, 'X', (0.2,0.5,1.0), 1, 1.0);	// origin, text, RGB, alpha, scale
////		print3d (getEnemySightPos(), 'X ' + self.squad.members.size, (0.2,0.5,1.0), 1, 1.0);	// origin, text, RGB, alpha, scale
//		
//	}
//	#/
//}
//
//previewAccuracy()
//{
//	/#
//	if (!isdefined (level.offsetNum))
//		level.offsetNum = 0;
//		
////	offset = level.offsetNum;
//	offset = 1;
//	level.offsetNum++;
//	if (level.offsetNum > 5)
//		level.offsetNum = 1;
//	self endon ('death');
//	for (;;)
//	{
//		if (getdebugdvar ('debug_accuracypreview') != 'on')
//		{
//			wait (1);
//			continue;
//		}
//		
//		wait (0.05);
//		print3d (self.origin + (0,0,70 + 25*offset), self.accuracy, (0.2,0.5,1.0), 1, 1.15);
//			// origin, text, RGB, alpha, scale
//	}
//	#/
//}
//
//trackVelocity()
//{
//	self endon ('death');
//
//	for (;;)
//	{
////		println ('keep claimed node: ' + self.keepClaimedNode);
//		self.oldOrigin = self.origin;
//		wait (0.2);
//	}
//}
//
//enemyNotify()
//{
//	self endon ('death');
//	if (1) return;
//	for (;;)
//	{
//		self waittill ('enemy');
//		if (!isalive(self.enemy))
//			continue;
//		while (self.enemy == level.player)
//		{
//			if (hasEnemySightPos())
//				level.lastPlayerSighted = gettime();
//			wait (2);
//		}
//	}
//}
//
//
//// Cleans up scripts on death
//deathNotify()
//{
//	self waittill('death', other);
//	self notify(anim.scriptChange);
//}
//
//testLife()
//{
//	for (;;)
//	{
//		if (!isalive(self))
//			break;
//		thread testLifeThink();
//		wait (0.05);
//	}
//}
//
//testLifeThink()
//{
//	self notify ('new test');
//	self endon ('new test');
//	
//	self endon ('killanimscript');
//	assert (isalive(self));
//	for (;;)
//	{
//		assertEX (isalive(self), 'This should never be hittable due to endon killanimscript. Make your peace and prepare to die.');
//		if (isalive(self))
//			wait (0.05);
//	}
//}
//
//
//setupHats()
//{
//	anim.noHat = []; // tracks which models arent meant to have detachable hats.		
//	addNoHat('character_british_africa_price');
//	addNoHat('character_british_normandy_price');
//	addNoHat('character_british_normandy_price');
//	addNoHat('character_german_winter_masked_dark');
//	addNoHat('character_russian_trench_d');
//
//	anim.noHatClassname = []; // tracks which models arent meant to have detachable hats.		
//	addNoHatClassname('actor_ally_rus_volsky');
//
//	anim.metalHat = []; // tracks which models arent meant to have detachable hats.		
//	addMetalHat('character_british_duhoc_driver');
//	addMetalHat('character_us_ranger_cpl_a');
//	addMetalHat('character_us_ranger_lt_coffey');
//	addMetalHat('character_us_ranger_medic_wells');
//	addMetalHat('character_us_ranger_pvt_a');
//	addMetalHat('character_us_ranger_pvt_a_low');
//	addMetalHat('character_us_ranger_pvt_a_wounded');
//	addMetalHat('character_us_ranger_pvt_b');
//	addMetalHat('character_us_ranger_pvt_b_low');
//	addMetalHat('character_us_ranger_pvt_b_wounded');
//	addMetalHat('character_us_ranger_pvt_braeburn');
//	addMetalHat('character_us_ranger_pvt_c');
//	addMetalHat('character_us_ranger_pvt_c_low');
//	addMetalHat('character_us_ranger_pvt_d');
//	addMetalHat('character_us_ranger_pvt_d_low');
//	addMetalHat('character_us_ranger_pvt_mccloskey');
//	addMetalHat('character_us_ranger_radio');
//	addMetalHat('character_us_ranger_sgt_randall');
//	addMetalHat('character_us_wet_ranger_cpl_a');
//	addMetalHat('character_us_wet_ranger_lt_coffey');
//	addMetalHat('character_us_wet_ranger_medic_wells');
//	addMetalHat('character_us_wet_ranger_pvt_a');
//	addMetalHat('character_us_wet_ranger_pvt_a_low');
//	addMetalHat('character_us_wet_ranger_pvt_a_wounded');
//	addMetalHat('character_us_wet_ranger_pvt_b');
//	addMetalHat('character_us_wet_ranger_pvt_b_low');
//	addMetalHat('character_us_wet_ranger_pvt_b_wounded');
//	addMetalHat('character_us_wet_ranger_pvt_braeburn');
//	addMetalHat('character_us_wet_ranger_pvt_c');
//	addMetalHat('character_us_wet_ranger_pvt_c_low');
//	addMetalHat('character_us_wet_ranger_pvt_d');
//	addMetalHat('character_us_wet_ranger_pvt_d_low');
//	addMetalHat('character_us_wet_ranger_pvt_mccloskey');
//	addMetalHat('character_us_wet_ranger_radio');
//	addMetalHat('character_us_wet_ranger_sgt_randall');
//	addMetalHat('character_british_afrca_body');
//	addMetalHat('character_british_afrca_body_low');
//	addMetalHat('character_british_afrca_mac_body');
//	addMetalHat('character_british_afrca_mac_radio');
//	addMetalHat('character_british_afrca_mcgregor_low');
//	addMetalHat('character_british_afrca_shortsleeve_body');
//	addMetalHat('character_british_normandy_a');
//	addMetalHat('character_british_normandy_b');
//	addMetalHat('character_british_normandy_c');
//	addMetalHat('character_british_normandy_mac_body');
//	addMetalHat('character_german_afrca_body');
//	addMetalHat('character_german_afrca_casualbody');
//	addMetalHat('character_german_camo_fat');
//	addMetalHat('character_german_normandy_coat_dark');
//	addMetalHat('character_german_normandy_fat');
//	addMetalHat('character_german_normandy_fat_injured');
//	addMetalHat('character_german_normandy_officer');
//	addMetalHat('character_german_normandy_thin');
//	addMetalHat('character_german_normandy_thin_injured');
//	addMetalHat('character_german_winter_light');
//	addMetalHat('character_german_winter_masked_dark');
//	addMetalHat('character_german_winter_mg42_low');
//	addMetalHat('character_russian_padded_b');
//	addMetalHat('character_russian_trench_b');
//	
//	anim.fatGuy = []; // fat models
//	addFatGuy('character_german_camo_fat');
//	addFatGuy('character_german_normandy_fat');
//	addFatGuy('character_russian_trench_a');
//	addFatGuy('character_german_normandy_fat_injured');
//}	
//
//addNoHat(model)
//{
//	anim.noHat[model] = 1;
//}
//
//addNoHatClassname(model)
//{
//	anim.noHatClassname[model] = 1;
//}
//
//addMetalHat(model)
//{
//	anim.metalHat[model] = 1;
//}
//
//addFatGuy(model)
//{
//	anim.fatGuy[model] = 1;
//}
//
//
//
//initWindowTraverse()
//{
//	// used to blend the traverse window_down smoothly at the end
//	level.window_down_height[0] = -36.8552;
//	level.window_down_height[1] = -27.0095;
//	level.window_down_height[2] = -15.5981;
//	level.window_down_height[3] = -4.37769;
//	level.window_down_height[4] = 17.7776;
//	level.window_down_height[5] = 59.8499;
//	level.window_down_height[6] = 104.808;
//	level.window_down_height[7] = 152.325;
//	level.window_down_height[8] = 201.052;
//	level.window_down_height[9] = 250.244;
//	level.window_down_height[10] = 298.971;
//	level.window_down_height[11] = 330.681;
//}

function AddApproachType(name nodeType, name standing, name crouching)
{
	local int id;
	id = NodeTypeID(nodeType);
	if (id < 0)
		return;
	if (id >= anim.approach_types.length)
		anim.approach_types.Add(id + 1 - anim.approach_types.length);

	anim.approach_types[id].data[0] = standing;
	anim.approach_types[id].data[1] = crouching;
}

function InitMoveStartStopTransitions()
{
	//local int standing;
	//local int crouching;

	local int left;
	local int right;
	local int left_crouch;
	local int right_crouch;
	local int crouch;
	local int stand;
	local int exposed;
	local int exposed_crouch;
	local int stand_saw;
	local int prone_saw;
	local int crouch_saw;
	local int wall_over_40;

	local array<int> transTypes;
	local array<int> exposedTransTypes;

	local int trans;
	local int i, j;
	local float len;

	left = TransTypeId('left');
	right = TransTypeId('right');
	left_crouch = TransTypeId('left_crouch');
	right_crouch = TransTypeId('right_crouch');
	crouch = TransTypeId('crouch');
	stand = TransTypeId('stand');
	exposed = TransTypeId('exposed');
	exposed_crouch = TransTypeId('exposed_crouch');
	stand_saw = TransTypeId('stand_saw');
	prone_saw = TransTypeId('prone_saw');
	crouch_saw = TransTypeId('crouch_saw');
	wall_over_40 = TransTypeId('wall_over_40');

	transTypes[0] = left;
	transTypes[1] = right;
	transTypes[2] = left_crouch;
	transTypes[3] = right_crouch;
	transTypes[4] = crouch;
	transTypes[5] = stand;
	transTypes[6] = exposed;
	transTypes[7] = exposed_crouch;
	transTypes[8] = stand_saw;
	transTypes[9] = prone_saw;
	transTypes[10] = crouch_saw;
	transTypes[11] = wall_over_40;
	
	
	anim.approach_types.remove(0, anim.approach_types.length);
	//standing = 0;
	//crouching = 1;
	
	//				node type				standing		crouching
	AddApproachType('Cover Left',			'left',			'left_crouch'	);
	AddApproachType('Cover Left Wide',		'left',			'left_crouch'	);
	
	AddApproachType('Cover Right',			'right',		'right_crouch'	);
	AddApproachType('Cover Right Wide',		'right',		'right_crouch'	);
	
	AddApproachType('Cover Crouch',			'crouch',		'crouch'		);
	AddApproachType('Conceal Crouch',		'crouch',		'crouch'		);
	AddApproachType('Cover Crouch Window',	'crouch',		'crouch'		);
	
	AddApproachType('Cover Stand',			'stand',		'stand'			);
	AddApproachType('Conceal Stand',		'stand',		'stand'			);
	
	AddApproachType('Cover Prone',			'exposed',		'exposed'		);
	AddApproachType('Conceal Prone',		'exposed',		'exposed'		);
	
	AddApproachType('Path',					'exposed',		'exposed_crouch');
	AddApproachType('Guard',				'exposed',		'exposed_crouch');
	
//	// CORNER TRANSITIONS ANIMS
	anim.coverTrans.Add(transTypes.length);
	anim.coverExit.Add(transTypes.length);
	
//	anim.traverseInfo = [];
	// indicies indicate the keyboard numpad directions (8 is forward)
	// 7  8  9
	// 4     6	 <- 5 is invalid
	// 1  2  3

	/*************************************************
	*    Entrance Animations
	*************************************************/
	anim.coverTrans[right       ].data[1] = 'cornerR_stand_trans_IN_1';
	anim.coverTrans[right       ].data[2] = 'cornerR_stand_trans_IN_2';
	anim.coverTrans[right       ].data[3] = 'cornerR_stand_trans_IN_3';
	anim.coverTrans[right       ].data[4] = 'cornerR_stand_trans_IN_4';
	anim.coverTrans[right       ].data[6] = 'cornerR_stand_trans_IN_6';
	//im.coverTrans[right       ].data[7] = can't approach from this direction;
	anim.coverTrans[right       ].data[8] = 'cornerR_stand_trans_IN_8';
	anim.coverTrans[right       ].data[9] = 'cornerR_stand_trans_IN_9';

	anim.coverTrans[right_crouch].data[1] = 'cornerR_crouch_trans_IN_1';
	anim.coverTrans[right_crouch].data[2] = 'cornerR_crouch_trans_IN_2';
	anim.coverTrans[right_crouch].data[3] = 'cornerR_crouch_trans_IN_3';
	anim.coverTrans[right_crouch].data[4] = 'cornerR_crouch_trans_IN_4';
	anim.coverTrans[right_crouch].data[6] = 'cornerR_crouch_trans_IN_6';
	//im.coverTrans[right_crouch].data[7] = can't approach from this direction;
	anim.coverTrans[right_crouch].data[8] = 'cornerR_crouch_trans_IN_8';
	anim.coverTrans[right_crouch].data[9] = 'cornerR_crouch_trans_IN_9';

	anim.coverTrans[left        ].data[1] = 'cornerL_stand_trans_IN_1';
	anim.coverTrans[left        ].data[2] = 'cornerL_stand_trans_IN_2';
	anim.coverTrans[left        ].data[3] = 'cornerL_stand_trans_IN_3';
	anim.coverTrans[left        ].data[4] = 'cornerL_stand_trans_IN_4';
	anim.coverTrans[left        ].data[6] = 'cornerL_stand_trans_IN_6';
	anim.coverTrans[left        ].data[7] = 'cornerL_stand_trans_IN_7';
	anim.coverTrans[left        ].data[8] = 'cornerL_stand_trans_IN_8';
	//im.coverTrans[left        ].data[9] = can't approach from this direction;
	
	anim.coverTrans[left_crouch ].data[1] = 'cornerL_crouch_trans_IN_1';
	anim.coverTrans[left_crouch ].data[2] = 'cornerL_crouch_trans_IN_2';
	anim.coverTrans[left_crouch ].data[3] = 'cornerL_crouch_trans_IN_3';
	anim.coverTrans[left_crouch ].data[4] = 'cornerL_crouch_trans_IN_4';
	anim.coverTrans[left_crouch ].data[6] = 'cornerL_crouch_trans_IN_6';
	anim.coverTrans[left_crouch ].data[7] = 'cornerL_crouch_trans_IN_7';
	anim.coverTrans[left_crouch ].data[8] = 'cornerL_crouch_trans_IN_8';
	//im.coverTrans[left_crouch ].data[9] = can't approach from this direction;
	
	anim.coverTrans[crouch      ].data[1] = 'covercrouch_trans_in_1';
	anim.coverTrans[crouch      ].data[2] = 'covercrouch_trans_in_2';
	anim.coverTrans[crouch      ].data[3] = 'covercrouch_trans_in_3';
	anim.coverTrans[crouch      ].data[4] = 'covercrouch_trans_in_4';
	anim.coverTrans[crouch      ].data[6] = 'covercrouch_trans_in_6';
	//im.coverTrans[crouch      ][7] = can't approach from this direction;
	//im.coverTrans[crouch      ][8] = can't approach from this direction;
	//im.coverTrans[crouch      ][9] = can't approach from this direction;
	
	anim.coverTrans[stand       ].data[1] = 'coverstand_trans_in_1';
	anim.coverTrans[stand       ].data[2] = 'coverstand_trans_in_2';
	anim.coverTrans[stand       ].data[3] = 'coverstand_trans_in_3';
	anim.coverTrans[stand       ].data[4] = 'coverstand_trans_in_4';
	anim.coverTrans[stand       ].data[6] = 'coverstand_trans_in_6';
	//im.coverTrans[stand       ][7] = can't approach from this direction;
	//im.coverTrans[stand       ][8] = can't approach from this direction;
	//im.coverTrans[stand       ][9] = can't approach from this direction;

//	anim.coverTrans[stand_saw   ][1] = %saw_gunner_runin_ML;
//	anim.coverTrans[stand_saw   ][2] = %saw_gunner_runin_M;
//	anim.coverTrans[stand_saw   ][3] = %saw_gunner_runin_MR;
//	anim.coverTrans[stand_saw   ][4] = %saw_gunner_runin_L;
//	anim.coverTrans[stand_saw   ][6] = %saw_gunner_runin_R;
//
//	anim.coverTrans[crouch_saw   ][1] = %saw_gunner_lowwall_runin_ML;
//	anim.coverTrans[crouch_saw   ][2] = %saw_gunner_lowwall_runin_M;
//	anim.coverTrans[crouch_saw   ][3] = %saw_gunner_lowwall_runin_MR;
//	anim.coverTrans[crouch_saw   ][4] = %saw_gunner_lowwall_runin_L;
//	anim.coverTrans[crouch_saw   ][6] = %saw_gunner_lowwall_runin_R;
//
//	anim.coverTrans[prone_saw   ][1] = %saw_gunner_prone_runin_ML;
//	anim.coverTrans[prone_saw   ][2] = %saw_gunner_prone_runin_M;
//	anim.coverTrans[prone_saw   ][3] = %saw_gunner_prone_runin_MR;
	
	// we need 45 degree angle approaches for exposed...
	//anim.coverTrans['exposed'     ] = []; // need this or it chokes on the next line due to assigning undefined...
	anim.coverTrans[exposed     ].data[1] = '';
	anim.coverTrans[exposed     ].data[2] = 'run_2_stand_F';
	anim.coverTrans[exposed     ].data[3] = '';
	anim.coverTrans[exposed     ].data[4] = 'run_2_stand_L';
	anim.coverTrans[exposed     ].data[6] = 'run_2_stand_R';
	anim.coverTrans[exposed     ].data[7] = '';
	anim.coverTrans[exposed     ].data[8] = 'run_2_stand_B';
	anim.coverTrans[exposed     ].data[9] = '';

	//anim.coverTrans[exposed_crouch] = []; // need this or it chokes on the next line due to assigning undefined...
	anim.coverTrans[exposed_crouch].data[1] = '';
	anim.coverTrans[exposed_crouch].data[2] = 'run_2_crouch_F';
	anim.coverTrans[exposed_crouch].data[3] = '';
	anim.coverTrans[exposed_crouch].data[4] = 'run_2_crouch_L';
	anim.coverTrans[exposed_crouch].data[6] = 'run_2_crouch_R';
	anim.coverTrans[exposed_crouch].data[7] = '';
	anim.coverTrans[exposed_crouch].data[8] = 'run_2_crouch_B';
	anim.coverTrans[exposed_crouch].data[9] = '';
	
	
//	/*************************************************
//	*    Traverse Animations
//	*************************************************/
//
//	anim.coverTrans['wall_over_96'][1] = %traverse90_IN_ML;
//	anim.coverTrans['wall_over_96'][2] = %traverse90_IN_M;
//	anim.coverTrans['wall_over_96'][3] = %traverse90_IN_MR;
//	anim.traverseInfo['wall_over_96']['height'] = 96;
//	
//	anim.coverTrans['wall_over_40'][1] = %traverse_window_M_2_run;
//	anim.coverTrans['wall_over_40'][2] = %traverse_window_M_2_run;
//	anim.coverTrans['wall_over_40'][3] = %traverse_window_M_2_run;
//	
//	/*
//	anim.coverTrans['wall_over_40'][1] = %traverse40_IN_ML;
//	anim.coverTrans['wall_over_40'][2] = %traverse40_IN_M;
//	anim.coverTrans['wall_over_40'][3] = %traverse40_IN_MR;
//	*/
	
	
	
	
	/*************************************************
	*    Exit Animations
	*************************************************/

	anim.coverExit[right       ].data[1] = 'cornerR_stand_trans_OUT_1';
	anim.coverExit[right       ].data[2] = 'cornerR_stand_trans_OUT_2';
	anim.coverExit[right       ].data[3] = 'cornerR_stand_trans_OUT_3';
	anim.coverExit[right       ].data[4] = 'cornerR_stand_trans_OUT_4';
	anim.coverExit[right       ].data[6] = 'cornerR_stand_trans_OUT_6';
	//im.coverExit[right       ].data[7] = can't approach from this direction;
	anim.coverExit[right       ].data[8] = 'cornerR_stand_trans_OUT_8';
	anim.coverExit[right       ].data[9] = 'cornerR_stand_trans_OUT_9';
	
	anim.coverExit[right_crouch].data[1] = 'cornerR_crouch_trans_OUT_1';
	anim.coverExit[right_crouch].data[2] = 'cornerR_crouch_trans_OUT_2';
	anim.coverExit[right_crouch].data[3] = 'cornerR_crouch_trans_OUT_3';
	anim.coverExit[right_crouch].data[4] = 'cornerR_crouch_trans_OUT_4';
	anim.coverExit[right_crouch].data[6] = 'cornerR_crouch_trans_OUT_6';
	//im.coverExit[right_crouch].data[7] = can't approach from this direction;
	anim.coverExit[right_crouch].data[8] = 'cornerR_crouch_trans_OUT_8';
	anim.coverExit[right_crouch].data[9] = 'cornerR_crouch_trans_OUT_9';
	
	anim.coverExit[left        ].data[1] = 'cornerL_stand_trans_OUT_1';
	anim.coverExit[left        ].data[2] = 'cornerL_stand_trans_OUT_2';
	anim.coverExit[left        ].data[3] = 'cornerL_stand_trans_OUT_3';
	anim.coverExit[left        ].data[4] = 'cornerL_stand_trans_OUT_4';
	anim.coverExit[left        ].data[6] = 'cornerL_stand_trans_OUT_6';
	anim.coverExit[left        ].data[7] = 'cornerL_stand_trans_OUT_7';
	anim.coverExit[left        ].data[8] = 'cornerL_stand_trans_OUT_8';
	//im.coverExit[left        ].data[9] = can't approach from this direction;
	
	anim.coverExit[left_crouch ].data[1] = 'cornerL_crouch_trans_OUT_1';
	anim.coverExit[left_crouch ].data[2] = 'cornerL_crouch_trans_OUT_2';
	anim.coverExit[left_crouch ].data[3] = 'cornerL_crouch_trans_OUT_3';
	anim.coverExit[left_crouch ].data[4] = 'cornerL_crouch_trans_OUT_4';
	anim.coverExit[left_crouch ].data[6] = 'cornerL_crouch_trans_OUT_6';
	anim.coverExit[left_crouch ].data[7] = 'cornerL_crouch_trans_OUT_7';
	anim.coverExit[left_crouch ].data[8] = 'cornerL_crouch_trans_OUT_8';
	//im.coverExit[left_crouch ].data[9] = can't approach from this direction;
	
	anim.coverExit[crouch      ].data[1] = 'covercrouch_trans_out_1';
	anim.coverExit[crouch      ].data[2] = 'covercrouch_trans_out_2';
	anim.coverExit[crouch      ].data[3] = 'covercrouch_trans_out_3';
	anim.coverExit[crouch      ].data[4] = 'covercrouch_trans_out_4';
	anim.coverExit[crouch      ].data[6] = 'covercrouch_trans_out_6';
	//im.coverExit[crouch      ][7] = can't approach from this direction;
	//im.coverExit[crouch      ][8] = can't approach from this direction;
	//im.coverExit[crouch      ][9] = can't approach from this direction;
	
	anim.coverExit[stand       ].data[1] = 'coverstand_trans_out_1';
	anim.coverExit[stand       ].data[2] = 'coverstand_trans_out_2';
	anim.coverExit[stand       ].data[3] = 'coverstand_trans_out_3';
	anim.coverExit[stand       ].data[4] = 'coverstand_trans_out_4';
	anim.coverExit[stand       ].data[6] = 'coverstand_trans_out_6';
	//im.coverExit[stand       ][7] = can't approach from this direction;
	//im.coverExit[stand       ][8] = can't approach from this direction;
	//im.coverExit[stand       ][9] = can't approach from this direction;
//	anim.coverExit[stand_saw   ][1] = %saw_gunner_runout_ML;
//	anim.coverExit[stand_saw   ][2] = %saw_gunner_runout_M;
//	anim.coverExit[stand_saw   ][3] = %saw_gunner_runout_MR;
//	anim.coverExit[stand_saw   ][4] = %saw_gunner_runout_L;
//	anim.coverExit[stand_saw   ][6] = %saw_gunner_runout_R;
//
////	anim.coverExit['prone_saw'	 ][1] = %saw_gunner_prone_runout_ML;
//	anim.coverExit['prone_saw'	 ][2] = %saw_gunner_prone_runout_M;
////	anim.coverExit['prone_saw'	 ][3] = %saw_gunner_prone_runout_MR;
//	anim.coverExit['prone_saw'	 ][4] = %saw_gunner_prone_runout_L;
//	anim.coverExit['prone_saw'	 ][6] = %saw_gunner_prone_runout_R;
////	anim.coverExit['prone_saw'	 ][7] = %saw_gunner_prone_runout_F; // need this anim or a way to exclude it
//	anim.coverExit['prone_saw'	 ][8] = %saw_gunner_prone_runout_F;
//	
//	anim.coverExit['crouch_saw'	 ][1] = %saw_gunner_lowwall_runout_ML;
//	anim.coverExit['crouch_saw'	 ][2] = %saw_gunner_lowwall_runout_M;
//	anim.coverExit['crouch_saw'	 ][3] = %saw_gunner_lowwall_runout_MR;
//	anim.coverExit['crouch_saw'	 ][4] = %saw_gunner_lowwall_runout_L;
//	anim.coverExit['crouch_saw'	 ][6] = %saw_gunner_lowwall_runout_R;

	// we need 45 degree angle exits for exposed...
	//anim.coverExit[exposed     ] = []; // need this or it chokes on the next line due to assigning undefined...
	anim.coverExit[exposed     ].data[1] = '';
	anim.coverExit[exposed     ].data[2] = 'stand_2_run_B'; // there is also _short, doesn't look as good
	anim.coverExit[exposed     ].data[3] = '';
	anim.coverExit[exposed     ].data[4] = 'stand_2_run_L';
	anim.coverExit[exposed     ].data[6] = 'stand_2_run_R';
	anim.coverExit[exposed     ].data[7] = '';
	anim.coverExit[exposed     ].data[8] = 'stand_2_run_F';
	anim.coverExit[exposed     ].data[9] = '';

	//anim.coverExit[exposed_crouch] = []; // need this or it chokes on the next line due to assigning undefined...
	anim.coverExit[exposed_crouch].data[1] = '';
	anim.coverExit[exposed_crouch].data[2] = 'crouch_2_run_B';
	anim.coverExit[exposed_crouch].data[3] = '';
	anim.coverExit[exposed_crouch].data[4] = 'crouch_2_run_L';
	anim.coverExit[exposed_crouch].data[6] = 'crouch_2_run_R';
	anim.coverExit[exposed_crouch].data[7] = '';
	anim.coverExit[exposed_crouch].data[8] = 'crouch_2_run_F';
	anim.coverExit[exposed_crouch].data[9] = '';
	

	anim.coverTransDist.Add(transTypes.length);
	anim.coverExitDist.Add(transTypes.length);

	anim.coverExitPostDist.Add(transTypes.length);
	
	anim.coverTransPreDist.Add(transTypes.length);

	anim.coverTransAngles.Add(transTypes.length);
	anim.coverExitAngles.Add(transTypes.length);

	for (i = 1; i <= 6; i++)
	{
		if (i == 5)
			continue;
		
		for (j = 0; j < transTypes.length; j++)
		{
			trans = transTypes[j];
			
			if (anim.coverTrans[trans].data[i] != '')
			{
				SetCustomAnim(trans_anim, anim.coverTrans[ trans ].data[i]);
				anim.coverTransDist  [ trans ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1);
				anim.coverTransAngles[ trans ].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);
			}
			else
			{
				anim.coverTransDist  [ trans ].data[i] = invalid_vector;
				anim.coverTransAngles[ trans ].data[i] = invalid_float;
			}
			
			if (anim.coverExit[trans].data[i] != '')
			{
				SetCustomAnim(trans_anim, anim.coverExit [ trans ].data[i]);
				anim.coverExitDist   [ trans ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1);
				anim.coverExitAngles [ trans ].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);
			}
			else
			{
				anim.coverExitDist  [ trans ].data[i] = invalid_vector;
				anim.coverExitAngles[ trans ].data[i] = invalid_float;
			}
		}
	}
	
//	exposedTransTypes = [];
	exposedTransTypes[0] = exposed;
	exposedTransTypes[1] = exposed_crouch;
	
	anim.longestExposedApproachDist = 0;

	for (j = 0; j < exposedTransTypes.length; j++)
	{
		trans = exposedTransTypes[j];
		for (i = 7; i <= 9; i++)
		{
			if (anim.coverTrans[ trans ].data[i] != '')
			{
				SetCustomAnim(trans_anim, anim.coverTrans[ trans ].data[i]);
				anim.coverTransDist  [ trans ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1);
				anim.coverTransAngles[ trans ].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);
			}
			else
			{
				anim.coverTransDist  [ trans ].data[i] = invalid_vector;
				anim.coverTransAngles[ trans ].data[i] = invalid_float;
			}
			
			if (anim.coverExit [ trans ].data[i] != '')
			{
				SetCustomAnim(trans_anim, anim.coverExit [ trans ].data[i]);
				anim.coverExitDist   [ trans ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1);
				anim.coverExitAngles [ trans ].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);
			}
			else
			{
				anim.coverExitDist  [ trans ].data[i] = invalid_vector;
				anim.coverExitAngles[ trans ].data[i] = invalid_float;
			}
		}
		
		for (i = 1; i <= 9; i++)
		{
			if (anim.coverTrans[trans].data[i] == '')
				continue;
			
			len = length(anim.coverTransDist[trans].data[i]);
			if (len > anim.longestExposedApproachDist)
				anim.longestExposedApproachDist = len;
		}
	}
	

//	// the FindBestSplitTime calls below are used to find these values.
//	// all of this is for corner nodes.
	anim.coverTransSplit.Add(transTypes.length);
	anim.coverExitSplit.Add(transTypes.length);

	anim.coverTransSplit[left].data[7] = 0.369369; // delta of (35.5356, 3.27114, 0)
	anim.coverTransSplit[left_crouch].data[7] = 0.277277; // delta of (38.5093, 6.37286, 0)
	anim.coverExitSplit[left].data[7] = 0.646647; // delta of (36.3768, 4.37581, 0)
	anim.coverExitSplit[left_crouch].data[7] = 0.764765; // delta of (36.7695, 4.82297, 0)
	anim.coverTransSplit[left].data[8] = 0.463463; // delta of (32.9564, 0.950555, 0)
	anim.coverTransSplit[left_crouch].data[8] = 0.339339; // delta of (35.0497, 3.12251, 0)
	anim.coverExitSplit[left].data[8] = 0.677678; // delta of (34.3012, 2.25822, 0)
	anim.coverExitSplit[left_crouch].data[8] = 0.58959; // delta of (36.3154, 4.34119, 0)
	anim.coverTransSplit[right].data[8] = 0.458458; // delta of (35.6571, 3.63511, 0)
	//anim.coverTransSplit[right_crouch].data[8] = 0.329329; // delta of (36.398, 4.45949, 0)
	anim.coverTransSplit[right_crouch].data[8] = 0.542097; // delta of (36.398, 4.45949, 0)
	anim.coverExitSplit[right].data[8] = 0.457457; // delta of (36.3085, 4.34586, 0)
	anim.coverExitSplit[right_crouch].data[8] = 0.636637; // delta of (40.441, 8.59943, -0.0001)
	anim.coverTransSplit[right].data[9] = 0.546547; // delta of (37.7732, 5.76641, 0)
	anim.coverTransSplit[right_crouch].data[9] = 0.349349; // delta of (36.0788, 3.95538, 0)
	anim.coverExitSplit[right].data[9] = 0.521522; // delta of (35.3195, 3.24431, 0)
	anim.coverExitSplit[right_crouch].data[9] = 0.664665; // delta of (33.4424, 1.40398, -0.0001)
	
	for (i = 7; i <= 8; i++)
	{
		SetCustomAnim(trans_anim, anim.coverTrans[left].data[i]);
		anim.coverTransPreDist[left        ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, getTransSplitTime('left', i));
		anim.coverTransDist   [left        ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1) - anim.coverTransPreDist[left].data[i];
		anim.coverTransAngles [left        ].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);
		SetCustomAnim(trans_anim, anim.coverTrans[left_crouch ].data[i]);
		anim.coverTransPreDist[left_crouch ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, getTransSplitTime('left_crouch', i));
		anim.coverTransDist   [left_crouch ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1) - anim.coverTransPreDist[left_crouch].data[i];
		anim.coverTransAngles [left_crouch ].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);

		SetCustomAnim(trans_anim, anim.coverExit [left].data[i]);
		anim.coverExitDist    [left        ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, getExitSplitTime('left', i));
		anim.coverExitPostDist[left        ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1) - anim.coverExitDist[left].data[i];
		anim.coverExitAngles  [left        ].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);
		SetCustomAnim(trans_anim, anim.coverExit [left_crouch ].data[i]);
		anim.coverExitDist    [left_crouch ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, getExitSplitTime('left_crouch', i));
		anim.coverExitPostDist[left_crouch ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1) - anim.coverExitDist[left_crouch].data[i];
		anim.coverExitAngles  [left_crouch ].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);
	}

	for (i = 8; i <= 9; i++)
	{
		SetCustomAnim(trans_anim, anim.coverTrans[right       ].data[i]);
		anim.coverTransPreDist[right       ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, getTransSplitTime('right', i));
		anim.coverTransDist   [right       ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1) - anim.coverTransPreDist[right].data[i];
		anim.coverTransAngles [right       ].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);
		SetCustomAnim(trans_anim, anim.coverTrans[right_crouch].data[i]);
		anim.coverTransPreDist[right_crouch].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, getTransSplitTime('right_crouch', i));
		anim.coverTransDist   [right_crouch].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1) - anim.coverTransPreDist[right_crouch].data[i];
		anim.coverTransAngles [right_crouch].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);

		SetCustomAnim(trans_anim, anim.coverExit [right       ].data[i]);
		anim.coverExitDist    [right       ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, getExitSplitTime('right', i));
		anim.coverExitPostDist[right       ].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1) - anim.coverExitDist[right].data[i];
		anim.coverExitAngles  [right       ].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);
		SetCustomAnim(trans_anim, anim.coverExit [right_crouch].data[i]);
		anim.coverExitDist    [right_crouch].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, getExitSplitTime('right_crouch', i));
		anim.coverExitPostDist[right_crouch].data[i] = getMoveDelta (trans_anim[0].NodeName, 0, 1) - anim.coverExitDist[right_crouch].data[i];
		anim.coverExitAngles  [right_crouch].data[i] = getAngleDelta(trans_anim[0].NodeName, 0, 1);
	}
}

///#
//FindBestSplitTime(exitanim, isapproach, isright, arrayname, debugname)
//{
//	angleDelta = getAngleDelta(exitanim, 0, 1);
//	fullDelta = getMoveDelta(exitanim, 0, 1);
//	numiter = 1000;
//	
//	bestsplit = -1;
//	bestvalue = -100000000;
//	bestdelta = (0,0,0);
//
//	for (i = 0; i < numiter; i++)
//	{
//		splitTime = 1.0 * i / (numiter - 1);
//		
//		delta = getMoveDelta(exitanim, 0, splitTime);
//		if (isapproach)
//			delta = DeltaRotate(fullDelta - delta, 180 - angleDelta);
//		if (isright)
//			delta = (delta[0], 0 - delta[1], delta[2]);
//		
//		val = min(delta[0] - 32, delta[1]);
//		
//		if (val > bestvalue || bestsplit < 0)
//		{
//			bestvalue = val;
//			bestsplit = splitTime;
//			bestdelta = delta;
//		}
//	}
//	
//	if (bestdelta[0] < 32 || bestdelta[1] < 0)
//	{
//		println('^0 ^1' + debugname + ' has no valid split time available! Best was at ' + bestsplit + ', delta of ' + bestdelta);
//		return;
//	}
//	//println('^0 ^2' + debugname + ' has best split time at ' + bestsplit + ', delta of ' + bestdelta);
//	println('^0 ^2' + arrayname + ' = ' + bestsplit + '; // delta of ' + bestdelta);
//}
//
//
//DeltaRotate(delta, yaw)
//{
//	cosine = cos(yaw);
//	sine = sin(yaw);
//	return (delta[0] * cosine - delta[1] * sine, delta[1] * cosine + delta[0] * sine, 0);
//}
//
//AssertIsValidLeftSplitDelta(delta, debugname)
//{
//	// in a delta, x is forward and y is left
//	
//	// assert the delta goes out far enough from the node
//	if (delta[0] < 32)
//		println('^0 ^1' + debugname + ' doesn't go out from the node far enough in the given split time (delta = ' + delta + ')');
//	
//	// assert the delta doesn't go into the wall
//	if (delta[1] < 0)
//		println('^0 ^1' + debugname + ' goes into the wall during the given split time (delta = ' + delta + ')');
//}
//
//AssertIsValidRightSplitDelta(delta, debugname)
//{
//	delta = (delta[0], 0 - delta[1], delta[2]);
//	return AssertIsValidLeftSplitDelta(delta, debugname);
//}
//
//checkApproachAngles(transTypes)
//{
//	idealTransAngles[1] = 45;
//	idealTransAngles[2] = 0;
//	idealTransAngles[3] = -45;
//	idealTransAngles[4] = 90;
//	idealTransAngles[6] = -90;
//	idealTransAngles[7] = 135;
//	idealTransAngles[8] = 180;
//	idealTransAngles[9] = -135;
//	
//	wait .05;
//	
//	for (i = 1; i <= 9; i++)
//	{
//		for (j = 0; j < transTypes.size; j++)
//		{
//			trans = transTypes[j];
//			
//			idealAdd = 0;
//			if (trans == 'left' || trans == 'left_crouch')
//				idealAdd = 90;
//			else if (trans == 'right' || trans == 'right_crouch')
//				idealAdd = -90;
//			
//			if (isdefined(anim.coverTransAngles[ trans ][i]))
//			{
//				correctAngle = AngleClamp180(idealTransAngles[i] + idealAdd);
//				actualAngle = AngleClamp180(anim.coverTransAngles[ trans ][i]);
//				if (AbsAngleClamp180(actualAngle - correctAngle) > 7)
//				{
//					println('^1Cover approach animation has bad yaw delta: anim.coverTrans[\'' + trans + '\'][' + i + ']; is ^2' + actualAngle + '^1, should be closer to ^2' + correctAngle + '^1.');
//				}
//			}
//		}
//	}
//
//	for (i = 1; i <= 9; i++)
//	{
//		for (j = 0; j < transTypes.size; j++)
//		{
//			trans = transTypes[j];
//			
//			idealAdd = 0;
//			if (trans == 'left' || trans == 'left_crouch')
//				idealAdd = 90;
//			else if (trans == 'right' || trans == 'right_crouch')
//				idealAdd = -90;
//
//			if (isdefined(anim.coverExitAngles[ trans ][i]))
//			{
//				correctAngle = AngleClamp180(-1 * (idealTransAngles[i] + idealAdd + 180));
//				actualAngle = AngleClamp180(anim.coverExitAngles[ trans ][i]);
//				if (AbsAngleClamp180(actualAngle - correctAngle) > 7)
//				{
//					println('^1Cover exit animation has bad yaw delta: anim.coverTrans[\'' + trans + '\'][' + i + ']; is ^2' + actualAngle + '^1, should be closer to ^2' + correctAngle + '^1.');
//				}
//			}
//		}
//	}
//}
//#/

function float GetExitSplitTime(name iapproachType, int dir)
{
	return anim.coverExitSplit[TransTypeId(iapproachType)].data[dir];
	
	/*exitAnim = anim.coverExit[ iapproachType ][ dir ];
	exitAlignTimes = getNotetrackTimes(exitAnim, 'exit_align');
	
	assert(exitAlignTimes.size == 1);
	if (exitAlignTimes.size == 0)
		return .5;
	
	return exitAlignTimes[0];*/
}

function float GetTransSplitTime(name iapproachType, int dir)
{
	return anim.coverTransSplit[TransTypeId(iapproachType)].data[dir];
}


//frameFraction(startFrame, endFrame, middleFrame)
//{
//	assert(startFrame < endFrame);
//	assert(startFrame <= middleFrame);
//	assert(middleFrame <= endFrame);
//	return (middleFrame - startFrame) / (endFrame - startFrame);
//}


function FirstInit()
{
	// Initialization that should happen once per level
	if (anim.NotFirstTime) // Use this to trigger the first init
		return;
	anim.NotFirstTime = true;
	
//	anim.useFacialAnims = false; // remove me when facial anims are fixed
//
//	if (!isdefined(anim.dog_health))
//		anim.dog_health = 1;
//		
//	if (!isdefined(anim.dog_presstime))
//		anim.dog_presstime = 350;
//		
//	if (!isdefined(anim.dog_hits_before_kill))
//		anim.dog_hits_before_kill = 1;
//		
//	/#
//	if (getdvar('scr_forceshotgun') == 'on')
//		precacheItem('winchester1200');
//	#/
//
//	level.player = getent('player','classname');
//	level.player.invul = false;
//	level.nextGrenadeDrop = randomint(3);
//	level.lastPlayerSighted = 100;
//	anim.defaultException = animscripts\init::empty;
//	/#
//	if (getdebugdvar('debug_noanimscripts') == '')
//		setdvar('debug_noanimscripts', 'off');
//	else
//	if (getdebugdvar('debug_noanimscripts') == 'on')
//		anim.defaultException = animscripts\init::infiniteLoop;
//
//	if (getdebugdvar('debug_grenadehand') == '')
//		setdvar('debug_grenadehand', 'off');
//		
//	if (getdebugdvar('anim_trace') == '')
//		setdvar('anim_trace', '-1');
//	if (getdebugdvar('anim_dotshow') == '')
//		setdvar('anim_dotshow', '-1');
//	if (getdebugdvar('anim_debug') == '')
//		setdvar('anim_debug', '');
//	if (getdebugdvar('debug_misstime') == '')
//		setdvar('debug_misstime', '');
//	if (getdvar('modern') == '')
//		setdvar('modern', 'on');
//	#/
//	
//	anim.sniperRifles = [];
//	anim.sniperRifles['aw50'] = 1;
//	anim.sniperRifles['dragunov'] = 1;
//	anim.sniperRifles['m14_scoped'] = 1;
//	anim.sniperRifles['m14_scoped_ghil'] = 1;
//	anim.sniperRifles['m14_scoped_silencer'] = 1;
//	anim.sniperRifles['m14_scoped_silencer_woodland'] = 1;
//	anim.sniperRifles['m14_scoped_woodland'] = 1;
//	anim.sniperRifles['m40a3'] = 1;
//	anim.sniperRifles['remington700'] = 1;
//	anim.sniperRifles['barrett'] = 1;
//	
//	if (getdvar('scr_ai_auto_fire_rate') == '')
//		setdvar('scr_ai_auto_fire_rate', '1.0');
	scr_ai_auto_fire_rate = 1.0;

//		
//	setdvar('scr_expDeathMayMoveCheck', 'on');
//	
//	maps\_names::setup_names();
//
//	// Global constants
//    anim.CoverStandShots = 0;
//    anim.lastSideStepAnim = 0;
    anim.meleeRange = 64*FInch;
	anim.meleeRangeSq = anim.meleeRange * anim.meleeRange;
////		anim.standRangeSq = 503.06*503.06;  // was .25 normalize from melee to prone
	anim.standRangeSq = 512*512*FInchSq;  // was .25 normalize from melee to prone
////		anim.chargeRangeSq = 200*200;
	anim.chargeRangeSq = 200*200*FInchSq;
	anim.chargeLongRangeSq = 512*512*FInchSq;
//	anim.aiVsAiMeleeRangeSq = 400*400;
//	
//	anim.animFlagNameIndex = 0;
//	
//	if (!isdefined (level.squadEnt))
//		level.squadEnt = [];
//	anim.masterGroup['axis'] = spawnstruct();
//	anim.masterGroup['axis'].sightTime = 0;
//	anim.masterGroup['allies'] = spawnstruct();
//	anim.masterGroup['allies'].sightTime = 0;
//	anim.scriptSquadGroup = [];

	initMoveStartStopTransitions();

//	thread setupHats();
	
	anim.lastUpwardsDeathTime = 0;
//	anim.backpedalRangeSq = 60*60;
//	anim.proneRangeSq = 512*512;
//	anim.dodgeRangeSq = 300*300;			// Guys only dodge when inside this range.
//	anim.blindAccuracyMult['allies'] = 0.5;
//	anim.blindAccuracyMult['axis'] = 0.1;
//	anim.ramboAccuracyMult = 1.0;
//	anim.runAccuracyMult = 0.5;
	anim.combatMemoryTimeConst = 10000;
	anim.combatMemoryTimeRand = 6000;
	anim.scriptChange = 'script_change';
	
//	anim.grenadeTimers['player_fraggrenade'] = randomIntRange(1000, 20000);
//	anim.grenadeTimers['player_flash_grenade'] = randomIntRange(1000, 20000);
//	anim.grenadeTimers['player_double_grenade'] = randomIntRange(10000, 60000);
//	anim.grenadeTimers['AI_fraggrenade'] = randomIntRange(0, 20000);
//	anim.grenadeTimers['AI_flash_grenade'] = randomIntRange(0, 20000);
	anim.numGrenadesInProgressTowardsPlayer = 0;
//	anim.lastGrenadeLandedNearPlayerTime = -1000000;
//	anim.lastFragGrenadeToPlayerStart    = -1000000;
//	thread setNextPlayerGrenadeTime();
//	/#
//	thread animscripts\combat_utility::grenadeTimerDebug();
//	#/
//		
	animscripts_utility.setEnv('none');
//	anim.noWeaponToss = false;
//	anim.corner_straight_yaw_limit = 36;
//	if (!isdefined(anim.optionalStepEffectFunction))
//	{
//		anim.optionalStepEffects = [];
//		anim.optionalStepEffectFunction = ::empty;
//	}
//	
//	
//	// scripted mode uses a special function. Faster to use a function pointer based on script than use an if statement in a popular loop.
//	anim.fire_notetrack_functions = [];
//	anim.fire_notetrack_functions[ 'scripted' ] = animscripts\shared::fire_straight;
//	anim.fire_notetrack_functions[ 'cover_right' ] = animscripts\shared::shootNotetrack;
//	anim.fire_notetrack_functions[ 'cover_left' ] = animscripts\shared::shootNotetrack;
//	anim.fire_notetrack_functions[ 'cover_crouch' ] = animscripts\shared::shootNotetrack;
//	anim.fire_notetrack_functions[ 'cover_stand' ] = animscripts\shared::shootNotetrack;
//	anim.fire_notetrack_functions[ 'move' ] = animscripts\shared::shootNotetrack;
	
	anim.shootEnemyWrapper_func = gShootEnemyWrapper_normal;
	
//	// string based array for notetracks
//	anim.notetracks = [];
//	animscripts\shared::registerNoteTracks();
//	
//	/#
//	if (getdvar('debug_delta') == '')
//		setdvar('debug_delta', 'off');
//	#/
//	if (!isdefined(level.flag))
//	{
//		level.flag = [];
//		level.flags_lock = [];
//	}

	maps__gameskill.setSkill();
//	level.painAI = undefined;
//	
//	
//	animscripts\SetPoseMovement::InitPoseMovementFunctions();
//	animscripts\face::InitLevelFace();
//	
//	anim.set_a_b[0] = 'a';
//	anim.set_a_b[1] = 'b';
//
//	anim.set_a_b_c[0] = 'a';
//	anim.set_a_b_c[1] = 'b';
//	anim.set_a_b_c[2] = 'c';
//
//	anim.set_a_c[0] = 'a';
//	anim.set_a_c[1] = 'c';
//	
//	anim.num_to_letter[1] = 'a';
//	anim.num_to_letter[2] = 'b';
//	anim.num_to_letter[3] = 'c';
//	anim.num_to_letter[4] = 'd';
//	anim.num_to_letter[5] = 'e';
//	anim.num_to_letter[6] = 'f';
//	anim.num_to_letter[7] = 'g';
//	anim.num_to_letter[8] = 'h';
//	anim.num_to_letter[9] = 'i';
//	anim.num_to_letter[10] = 'j';
//	
////	anim.set_array_exposed['stand'] = animscripts\exposed_modern::set_animarray_standing;
////	anim.set_array_exposed['crouch'] = animscripts\exposed_modern::set_animarray_standing;
	
	// probabilities of burst fire shots
	anim.burstFireNumShots =     class'HodAnim'.default.burstFireNumShots;
	anim.fastBurstFireNumShots = class'HodAnim'.default.fastBurstFireNumShots;
	anim.semiFireNumShots =      class'HodAnim'.default.semiFireNumShots;
	
//	anim.startSuppressionDelay = 1.4;
	anim.maymoveCheckEnabled = true; // corner_axis doesnt do the check if this is false, for credits

//	anim.badPlaces = []; // queue for animscript badplaces
//	anim.badPlaceInt = 0; // assigns unique names to animscript badplaces since we cant save a badplace as an entity
//	anim.player = getent('player', 'classname');
//
//	animscripts\squadmanager::init_squadManager();
//	anim.player thread animscripts\squadManager::addPlayerToSquad();
//
//	animscripts\battleChatter::init_battleChatter();
//	anim.player thread animscripts\battleChatter_ai::addToSystem();
//
//	anim thread animscripts\battleChatter::bcsDebugWaiter();
//	anim.reacquireNum = 0;
//	anim.nonstopFireguy = 0;
//	initWindowTraverse();
//	
//	animscripts\flashed::initFlashed();
//	
//	animscripts\cqb::setupCQBPointsOfInterest();
	
	anim.coverCrouchLeanPitch = -55;
	
	anim.numDeathsUntilCrawlingPain = randomintrange(0, 15);
	anim.numDeathsUntilCornerGrenadeDeath = randomintrange(0, 10);
//	anim.nextCrawlingPainTime = gettime() + randomintrange(0, 20000);
//	anim.nextCrawlingPainTimeFromLegDamage = gettime() + randomintrange(0, 10000);
//	anim.nextCornerGrenadeDeathTime = gettime() + randomintrange(0, 15000);
	
	anim.lastCarExplosionTime = -100000;

//	setupRandomTable();
//	
//	level.player thread watchReloading();
	
	AITurnNotifies(true);
}

function AITurnNotifies(optional bool newThread = false)
{
	run (new(anim) class'init_AITurnNotifies', newThread);
}

//setNextPlayerGrenadeTime()
//{
//	waittillframeend;
//	// might not be defined if maps\_load::main() wasn't called
//	if (isdefined(anim.playerGrenadeRangeTime))
//	{
//		maxTime = int(anim.playerGrenadeRangeTime * 0.7);
//		if (maxTime < 1)
//			maxTime = 1;
//		anim.grenadeTimers['player_fraggrenade'] = randomIntRange(0, maxTime);
//		anim.grenadeTimers['player_flash_grenade'] = randomIntRange(0, maxTime);
//	}
//	if (isdefined(anim.playerDoubleGrenadeTime))
//	{
//		maxTime = int(anim.playerDoubleGrenadeTime);
//		minTime = int(maxTime / 2);
//		if (maxTime <= minTime)
//			maxTime = minTime + 1;
//		anim.grenadeTimers['player_double_grenade'] = randomIntRange(minTime, maxTime);
//	}
//}
//
//beginGrenadeTracking()
//{
//	self endon ('death');
//	
//	for (;;)
//	{
//		self waittill ('grenade_fire', grenade, weaponName);
//		grenade thread grenade_earthQuake();
//	}
//}
//
//setupRandomTable()
//{
//	// 60 is chosen because it is divisible by 1,2,3,4,5, and 6,
//	// and it's also high enough to get some good randomness over different seed values
//	anim.randomIntTableSize = 60;
//	
//	// anim.randomIntTable is a permutation of integers 0 through anim.randomIntTableSize - 1
//	anim.randomIntTable = [];
//	for (i = 0; i < anim.randomIntTableSize; i++)
//		anim.randomIntTable[i] = i;
//	
//	for (i = 0; i < anim.randomIntTableSize; i++)
//	{
//		switchwith = randomint(anim.randomIntTableSize);
//		temp = anim.randomIntTable[i];
//		anim.randomIntTable[i] = anim.randomIntTable[switchwith];
//		anim.randomIntTable[switchwith] = temp;
//	}
//}
//
//endOnDeath()
//{
//	self waittill('death');
//	waittillframeend;
//	self notify ('end_explode');
//}
//
//
//grenade_earthQuake()
//{
//	self thread endOnDeath();
//	self endon('end_explode');
//	self waittill('explode', position);
//	PlayRumbleOnPosition('grenade_rumble', position);
//	earthquake(0.3, 0.5, position, 400);
//}

function OnDeath(optional bool newThread = false)
{
	local init_OnDeath task;
	task = new(self) class'init_OnDeath';
	run(task, newThread);
}
