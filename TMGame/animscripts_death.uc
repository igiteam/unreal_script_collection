class animscripts_death extends Object within HodAI;

//
//		 Damage Yaw
//
//           front
//        /----|----\
//       /    180    \
//      /\     |     /\
//     / -135  |  135  \
//     |     \ | /     |
// left|-90----+----90-|right
//     |     / | \     |
//     \  -45  |  45   /
//      \/     |     \/
//       \     0     /
//        \----|----/
//           back

function main(optional bool newThread = false)
{
	run (new(self) class'death_main', newThread);
}


function WaitForRagdoll(float time, optional bool newThread = false)
{
	local death_WaitForRagdoll task;
	task = new(self) class'death_WaitForRagdoll';
	task.time = time;
	run (task, newThread);
}

function PlayDeathAnim(name iDeathAnim, optional bool newThread = false)
{
	local death_PlayDeathAnim task;
	task = new(self) class'death_PlayDeathAnim';
	task.iDeathAnim = iDeathAnim;
	run (task, newThread);
}


//testPrediction()
//{
//	self BeginPrediction();
//
//	self animscripts\predict::start();
//
//	self animscripts\predict::_setAnim(%balcony_stumble_forward, 1, .05, 1);
//	if (self animscripts\predict::stumbleWall(1))
//	{
//		self animMode('nogravity');
//
//		self animscripts\predict::_setFlaggedAnimKnobAll('deathanim', %balcony_tumble_railing36_forward, %root, 1, 0.05, 1);
//		if (self animscripts\predict::tumbleWall('deathanim'))
//		{
//			self EndPrediction();
//			return true;
//		}
//	}
//
//	self EndPrediction();
//	self BeginPrediction();
//
//	self animscripts\predict::start();
//
//	self animscripts\predict::_setAnim(%balcony_stumble_forward, 1, .05, 1);
//	if (self animscripts\predict::stumbleWall(1))
//	{
//		self animMode('nogravity');
//
//		self animscripts\predict::_setFlaggedAnimKnobAll('deathanim', %balcony_tumble_railing44_forward, %root, 1, 0.05, 1);
//		if (self animscripts\predict::tumbleWall('deathanim'))
//		{
//			self EndPrediction();
//			return true;
//		}
//	}
//
//	self EndPrediction();
//
//	self animscripts\predict::end();
//
//	return false;
//}


// Special death is for corners, rambo behavior, mg42's, anything out of the ordinary stand, crouch and prone.
// It returns true if it handles the death for the special animation state, or false if it wants the regular
// death function to handle it.
function bool SpecialDeath()
{
	local array<name> deathArray;

	if (a.special == 'none')
		return false;

	switch (a.special)
	{
	case 'cover_right':
		if (a.pose == 'stand')
		{
			//deathArray = [];
			deathArray[0] = 'cornerR_stand_death_v1';
			deathArray[1] = 'cornerR_stand_death_v2';
			DoDeathFromArray(deathArray);
		}
		else
		{
			assert(a.pose == 'crouch');
			return false;
		}
		return true;

	case 'cover_left':
		if (a.pose == 'stand')
		{
			//deathArray = [];
			deathArray[0] = 'cornerL_stand_death_v1';
			deathArray[1] = 'cornerL_stand_death_v2';
			DoDeathFromArray(deathArray);
		}
		else
		{
			assert(a.pose == 'crouch');
			return false;
		}
		return true;

	case 'cover_stand':
		deathArray[0] = 'coverstand_death_left';
		deathArray[1] = 'coverstand_death_right';
		DoDeathFromArray(deathArray);
		return true;

	case 'cover_crouch':
		//deathArray = [];
		if (animscripts_utility.damageLocationIsAny('head', 'neck') && (damageyaw > 135 || damageyaw <=-45))	// Front/Left quadrant
			deathArray[deathArray.length] = 'covercrouch_death_v1';

		if ((damageyaw > -45) && (damageyaw <= 45))	// Back quadrant
			deathArray[deathArray.length] = 'covercrouch_death_v3';

		deathArray[deathArray.length] = 'covercrouch_death_v2';

		DoDeathFromArray(deathArray);
		return true;

//	case 'saw':
//		if (self.a.pose == 'stand')
//			DoDeathFromArray(array(%saw_gunner_death));
//		else if (self.a.pose == 'crouch')
//			DoDeathFromArray(array(%saw_gunner_lowwall_death));
//		else
//			DoDeathFromArray(array(%saw_gunner_prone_death));
//		return true;
//
//	case 'dying_crawl':
//		if (self.a.pose == 'back')
//		{
//			deathArray = array(%dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4);
//			DoDeathFromArray(deathArray);
//		}
//		else
//		{
//			assertex(self.a.pose == 'prone', self.a.pose);
//			deathArray = array(%dying_crawl_death_v1, %dying_crawl_death_v2);
//			DoDeathFromArray(deathArray);
//		}
//		return true;
	}
	return false;
}


function DoDeathFromArray(array<name> iDeathArray, optional bool newThread = false)
{
	local death_DoDeathFromArray task;
	task = new(self) class'death_DoDeathFromArray';
	task.iDeathArray = iDeathArray;
	run (task, newThread);
}


//PlayDeathSound()
//{
////	if (self.team == 'allies')
////		self playsound('allied_death');
////	else
////		self playsound('german_death');
//	self animscripts\face::SayGenericDialogue('death');
//}
//
//print3dfortime(place, text, time)
//{
//	numframes = time * 20;
//	for (i = 0; i < numframes; i++)
//	{
//		print3d(place, text);
//		wait .05;
//	}
//}
//
//helmetPop()
//{
//	if (!isdefined(self))
//		return;
//	if (!isdefined(self.hatModel))
//		return;
//	// used to check self removableHat() in cod2... probably not necessary though
//
//	partName = GetPartName(self.hatModel, 0);
//	model = spawn('script_model', self.origin + (0,0,64));
//	model setmodel(self.hatModel );
//	model.origin = self GetTagOrigin(partName); //self . origin + (0,0,64);
//	model.angles = self GetTagAngles(partName); //(-90,0 + randomint(90),0 + randomint(90));
//	model thread helmetLaunch(self.damageDir);
//
//	hatModel = self.hatModel;
//	self.hatModel = undefined;
//
//	wait 0.05;
//
//	if (!isdefined(self))
//		return;
//	self detach(hatModel, '');
//}
//
//helmetLaunch(damageDir)
//{
//    launchForce = damageDir;
//	launchForce = launchForce * randomFloatRange(1100, 4000);
//
//	forcex = launchForce[0];
//	forcey = launchForce[1];
//	forcez = randomFloatRange(800, 3000);
//
//	contactPoint = self.origin + (randomfloatrange(-1,1), randomfloatrange(-1,1), randomfloatrange(-1,1)) * 5;
//
//	self physicsLaunch(contactPoint, (forcex, forcey, forcez));
//
//	wait 60;
//
//	while(1)
//	{
//		if (!isdefined(self))
//			return;
//
//		if (distanceSquared(self.origin, level.player.origin) > 512*512)
//			break;
//
//		wait 30;
//	}
//
//	self delete();
//}
//
//
//removeSelfFrom_SquadLastSeenEnemyPos(org)
//{
//	for (i=0;i<anim.squadIndex.length;i++)
//		anim.squadIndex[i] clearSightPosNear(org);
//}
//
//
//clearSightPosNear(org)
//{
//	if (!isdefined(self.sightPos))
//		return;
//
//	if (distance (org, self.sightPos) < 80)
//	{
//		self.sightPos = undefined;
//		self.sightTime = gettime();
//	}
//}


function bool ShouldDoRunningForwardDeath()
{
	if (a.movement != 'run')
		return false;

	if (getMotionAngle() > 60 || getMotionAngle() < -60)
		return false;

	if ((damageyaw >= 135) || (damageyaw <=-135)) // Front quadrant
		return true;

	if ((damageyaw >= -45) && (damageyaw <= 45)) // Back quadrant
		return true;

	return false;
}


function name GetDeathAnim()
{
	if (a.pose == 'stand')
	{
		if (shouldDoRunningForwardDeath())
			return getRunningForwardDeathAnim();

		return getStandDeathAnim();
	}
	else if (a.pose == 'crouch')
	{
		return getCrouchDeathAnim();
	}
	else if (a.pose == 'prone')
	{
		return getProneDeathAnim();
	}
	else
	{
		assert(a.pose == 'back');
		return getBackDeathAnim();
	}
}


function name GetRunningForwardDeathAnim()
{
	local array<name> deathArray;
	deathArray[deathArray.length] = tryAddDeathAnim('death_run_facedown');
	deathArray[deathArray.length] = tryAddDeathAnim('death_run_roll');

	if ((damageyaw >= 135) || (damageyaw <=-135)) // Front quadrant
	{
		deathArray[deathArray.length] = tryAddDeathAnim('death_run_fallonback_v1');
		deathArray[deathArray.length] = tryAddDeathAnim('death_run_fallonback_v2');
	}
	else if ((damageyaw >= -45) && (damageyaw <= 45)) // Back quadrant
	{
		deathArray[deathArray.length] = tryAddDeathAnim('death_run_roll');
		deathArray[deathArray.length] = tryAddDeathAnim('death_run_facedown');
	}

	deathArray = tempClean(deathArray);
	deathArray = animscripts_pain.removeBlockedAnims(deathArray);

	if (deathArray.length == 0)
		return getStandDeathAnim();

	return deathArray[randomint(deathArray.length)];
}

// temp fix for arrays containing undefined
function array<name> tempClean(array<name> iArray)
{
	local array<name> newArray;
	local int index;

	for (index = 0; index < iArray.length; index++)
	{
		if (!isDefined(iArray[index]))
			continue;

		newArray[newArray.length] = iArray[index];
	}
	return newArray;
}

// TODO: proper location damage tracking
function name GetStandDeathAnim()
{
	local array<name> deathArray;

	//if (weaponAnims() == 'pistol')
	//{
	//	if (abs(self.damageYaw) < 50)
	//	{
	//		deathArray[deathArray.length] = %pistol_death_2; // falls forwards
	//	}
	//	else
	//	{
	//		if (abs(self.damageYaw) < 110)
	//			deathArray[deathArray.length] = %pistol_death_2; // falls forwards
	//
	//		if (animscripts_utility.damageLocationIsAny('torso_lower', 'torso_upper', 'left_leg_upper', 'left_leg_lower', 'right_leg_upper', 'right_leg_lower'))
	//		{
	//			deathArray[deathArray.length] = %pistol_death_3; // hit in groin from front
	//			if (!animscripts_utility.damageLocationIsAny('torso_upper'))
	//				deathArray[deathArray.length] = %pistol_death_3; // (twice as likely)
	//		}
	//
	//		if (!animscripts_utility.damageLocationIsAny('head', 'neck', 'helmet', 'left_foot', 'right_foot', 'left_hand', 'right_hand', 'gun') && randomint(2) == 0)
	//			deathArray[deathArray.length] = %pistol_death_4; // hit at top and falls backwards, but more dragged out
	//
	//		if (deathArray.length == 0 || animscripts_utility.damageLocationIsAny('torso_lower', 'torso_upper', 'neck', 'head', 'helmet', 'right_arm_upper', 'left_arm_upper'))
	//			deathArray[deathArray.length] = %pistol_death_1; // falls backwards
	//	}
	//}
	//else
	//{
		// common ones
		if (randomint(3) < 2)
			deathArray[deathArray.length] = tryAddDeathAnim('death_stand_v1');
		if (randomint(3) < 2)
		{
			if (EnableShootWhenDied)
				deathArray[deathArray.length] = tryAddDeathAnim('death_stand_firing_v2');
			else
				deathArray[deathArray.length] = tryAddDeathAnim('death_stand_v2');
		}

		// torso or legs
		if (animscripts_utility.damageLocationIsAny('torso_lower', 'left_leg_upper', 'left_leg_lower', 'right_leg_lower', 'right_leg_lower')	)
			deathArray[deathArray.length] = tryAddDeathAnim('death_stand_groin');

		if (animscripts_utility.damageLocationIsAny('head', 'neck', 'helmet'))
		{
			deathArray[deathArray.length] = tryAddDeathAnim('death_stand_headshot');
			deathArray[deathArray.length] = tryAddDeathAnim('death_stand_headtwist');
		}

		// neck torso
		if (animscripts_utility.damageLocationIsAny('torso_upper', 'neck'))
		{
			deathArray[deathArray.length] = tryAddDeathAnim('death_stand_nerve');
			if (damageTaken <= 70) // lots of damage means it probably wasn't just a bullet
				deathArray[deathArray.length] = tryAddDeathAnim('death_stand_neckgrab');
		}

		if ((damageyaw > 135) || (damageyaw <=-135)) // Front quadrant
		{
			deathArray[deathArray.length] = tryAddDeathAnim('death_stand_v2');
			if (animscripts_utility.damageLocationIsAny('torso_upper', 'left_arm_upper', 'right_arm_upper'))
			{
				if (EnableShootWhenDied)
					deathArray[deathArray.length] = tryAddDeathAnim('death_stand_firing_v1');
				else
					deathArray[deathArray.length] = tryAddDeathAnim('death_stand_v1');
			}
			if (animscripts_utility.damageLocationIsAny('torso_upper', 'neck', 'head', 'helmet'))
				deathArray[deathArray.length] = tryAddDeathAnim('death_stand_falltoknees_v2');
		}
		else if ((damageyaw > 45) && (damageyaw <= 135)) // Right quadrant
		{
			deathArray[deathArray.length] = tryAddDeathAnim('death_stand_falltoknees_v2');
		}
		else if ((damageyaw > -45) && (damageyaw <= 45)) // Back quadrant
		{
			deathArray[deathArray.length] = tryAddDeathAnim('death_stand_falltoknees_v1');
			deathArray[deathArray.length] = tryAddDeathAnim('death_stand_falltoknees_v2');
		}
		else // Left quadrant
		{
			if (animscripts_utility.damageLocationIsAny('torso_upper', 'left_arm_upper', 'head'))
				deathArray[deathArray.length] = tryAddDeathAnim('death_stand_twist');

			deathArray[deathArray.length] = tryAddDeathAnim('death_stand_falltoknees_v2');
		}

		//assertex(deathArray.length > 0, deathArray.length);
	//}

	deathArray = tempClean(deathArray);

	if (deathArray.length == 0)
		deathArray[deathArray.length] = 'death_stand_v1';

	return deathArray[randomint(deathArray.length)];
}


function name getCrouchDeathAnim()
{
	local array<name> deathArray;

	if (animscripts_utility.damageLocationIsAny('head', 'neck'))	// Front/Left quadrant
		deathArray[deathArray.length] = tryAddDeathAnim('death_crouch_fetal');

	if (animscripts_utility.damageLocationIsAny('torso_upper', 'torso_lower', 'left_arm_upper', 'right_arm_upper', 'neck'))
		deathArray[deathArray.length] = tryAddDeathAnim('death_crouch_flip');

	if (deathArray.length < 2)
		deathArray[deathArray.length] = tryAddDeathAnim('death_crouch_twist');
	if (deathArray.length < 2)
		deathArray[deathArray.length] = tryAddDeathAnim('death_crouch_flip');

	deathArray = tempClean(deathArray);
	//assertex(deathArray.length > 0, deathArray.length);
	return deathArray[randomint(deathArray.length)];
}


function name getProneDeathAnim()
{
	return 'death_prone_quickdeath';
}


function name GetBackDeathAnim()
{
	assert(false);
	return '';
//	deathArray = array(%dying_back_death_v1, %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4);
//	return deathArray[randomint(deathArray.length)];
}


function name TryAddDeathAnim(name animName)
{
	local name lAnim;
	lAnim = SetCustomAnim(animscripts_init.trans_anim, animname);
	if (!animHasNoteTrack(lAnim, 'fire') && !animHasNoteTrack(lAnim, 'fire_spray'))
		return animName;

	if (a.weaponPos[WeaponPoseID('right')] == 'none')
		return '';

	if (weaponIsSemiAuto(weapon))
		return '';

	if (animscripts_utility.WeaponAnims() != 'rifle')
		return '';

	if (dieQuietly)
		return '';

	return animName;
}


function bool PlayExplodeDeathAnim()
{
	local array<name> deathArray;
	local name lDeathAnim;

	//if (damageLocation != 'none')
	//	return false;

	if (a.movement != 'run')
	{
		if (mayDoUpwardsDeath && (getTime() > anim.lastUpwardsDeathTime + 6000))
		{
			deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_UP_v1');
			deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_UP_v2');
			anim.lastUpwardsDeathTime = getTime();
		}
		else
		{
			if ((damageyaw > 135) || (damageyaw <=-135))	// Front quadrant
			{
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_B_v1');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_B_v2');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_B_v3');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_B_v4');
			}
			else if ((damageyaw > 45) && (damageyaw <= 135))		// Right quadrant
			{
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_L_v1');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_L_v2');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_L_v3');
			}
			else if ((damageyaw > -45) && (damageyaw <= 45))		// Back quadrant
			{
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_F_v1');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_F_v2');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_F_v3');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_F_v4');
			}
			else
			{															// Left quadrant
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_R_v1');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_R_v2');
			}
		}
	}
	else
	{
		if (mayDoUpwardsDeath && (getTime() > anim.lastUpwardsDeathTime + 2000))
		{
			deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_UP_v1');
			deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_stand_UP_v2');
			anim.lastUpwardsDeathTime = getTime();
		}
		else
		{
			if ((damageyaw > 135) || (damageyaw <=-135))	// Front quadrant
			{
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_run_B_v1');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_run_B_v2');
			}
			else if ((damageyaw > 45) && (damageyaw <= 135))		// Right quadrant
			{
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_run_L_v1');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_run_L_v2');
			}
			else if ((damageyaw > -45) && (damageyaw <= 45))		// Back quadrant
			{
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_run_F_v1');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_run_F_v2');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_run_F_v3');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_run_F_v4');
			}
			else
			{															// Left quadrant
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_run_R_v1');
				deathArray[deathArray.length] = tryAddDeathAnim('death_explosion_run_R_v2');
			}
		}
	}

	lDeathAnim = deathArray[randomint(deathArray.length)];

//	if (getdvar('scr_expDeathMayMoveCheck') == 'on')
//	{
//		localDeltaVector = getMoveDelta (lDeathAnim, 0, 1);
//		endPoint = self localToWorldCoords(localDeltaVector);
//
//		if (!self mayMoveToPoint(endPoint, false))
//			return false;
//	}

	// this should really be in the notetracks
	animMode ('nogravity');

	playDeathAnim(lDeathAnim);
	return true;
}
