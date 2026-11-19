//================================================================================
// SetPoseMovement - Sets the pose (stand, crouch, prone) and movement (run, walk, 
// crawl, stop) to the specified values.  Accounts for all possible starting poses 
// and movements.
//================================================================================
class animscripts_trans extends Object within HodAI
	dependson(general_human);


function SetPoseMovement(name desiredPose, name desiredMovement)
{
	// Scripts can pass empty strings, meaning they don't want to change that aspect of the state.
	if (desiredPose=='')
	{
		if ((a.pose=='prone') && ((desiredMovement=='walk')||(desiredMovement=='run')))
			desiredPose = 'crouch';
		else
			desiredPose = a.pose;
	}
	if (!IsDefined(desiredMovement) || desiredMovement=='')
	{
		desiredMovement = a.movement;
	}

	// Now call the function.
	//[[anim.SetPoseMovementFnArray[desiredPose][desiredMovement]]]();
	switch (desiredPose)
	{
	case 'stand':
		SetStandMovement(desiredMovement);
		break;
	case 'crouch':
		SetCrouchMovement(desiredMovement);
		break;
	default:
		assert(desiredPose == 'prone');
		SetProneMovement(desiredMovement);
		break;
	}
}

function SetStandMovement(name desiredMovement)
{
	switch (desiredMovement)
	{
	case 'stop':
		BeginStandStop();
		break;

	case 'walk':
		BeginStandWalk();
		break;

	default:
		assert (desiredMovement == 'run');
		BeginStandRun();
		break;
	}
}

function SetCrouchMovement(name desiredMovement)
{
	switch (desiredMovement)
	{
	case 'stop':
		BeginCrouchStop();
		break;

	case 'walk':
		BeginCrouchWalk();
		break;

	default:
		assert (desiredMovement == 'run');
		BeginCrouchRun();
		break;
	}
}

function SetProneMovement(name desiredMovement)
{
	switch (desiredMovement)
	{
	case 'stop':
		BeginProneStop();
		break;

	case 'walk':
		BeginProneWalk();
		break;

	default:
		assert (desiredMovement == 'run');
		BeginProneRun();
		break;
	}
}


//// *****************************
////  All of the following 'Begin' functions ensure that the actor is in the given pose and movement type.
////  They return false if nothing needs to be done, true otherwise.
//// *****************************
//
//InitPoseMovementFunctions()
//{
//	// Make an array of movement and pose changing functions.  
//	// Indices are: 'desired movement', 'desired pose'
//	anim.SetPoseMovementFnArray['stand']['stop'] =	::BeginStandStop;
//	anim.SetPoseMovementFnArray['stand']['walk'] =	::BeginStandWalk;
//	anim.SetPoseMovementFnArray['stand']['run'] =	::BeginStandRun;
//
//	anim.SetPoseMovementFnArray['crouch']['stop'] =	::BeginCrouchStop;
//	anim.SetPoseMovementFnArray['crouch']['walk'] =	::BeginCrouchWalk;
//	anim.SetPoseMovementFnArray['crouch']['run'] =	::BeginCrouchRun;
//
//	anim.SetPoseMovementFnArray['prone']['stop'] =	::BeginProneStop;
//	anim.SetPoseMovementFnArray['prone']['walk'] =	::BeginProneWalk;
//	anim.SetPoseMovementFnArray['prone']['run'] =	::BeginProneRun;
//}


//--------------------------------------------------------------------------------
// Standing poses
//--------------------------------------------------------------------------------

function bool BeginStandStop()
{
	switch (a.pose)
	{
	case 'stand':
		switch (a.movement)
		{
		case 'stop':
			return false;

		case 'walk':
			StandWalkToStand();
			break;

		default:
			assert(a.movement == 'run');
			StandRunToStand();
			break;
		}
		break;

	case 'crouch':
		switch (a.movement)
		{
		case 'stop':
			CrouchToStand();
			break;

		case 'walk':
			CrouchWalkToStand();
			break;

		default:
			assert(a.movement == 'run');
			CrouchRunToStand();
			break;
		}
		break;

	default:
		assert(a.pose == 'prone');
		switch (a.movement)
		{
		case 'stop':
			ProneToStand();
			break;

		default:
			assert(a.movement == 'walk' || a.movement == 'run');
			ProneToStand();	// Do I need to stop crawling first?  Hope not.
			break;
		}
		break;
	}
	
	return true;
}

function bool BeginStandWalk()
{
	switch (a.pose)
	{
	case 'stand':
		switch (a.movement)
		{
		case 'stop':
			BlendIntoStandWalk();
			break;

		case 'walk':
			return false;

		default:
			assert(a.movement == 'run');
			BlendIntoStandWalk();
			break;
		}
		break;

	case 'crouch':
		switch (a.movement)
		{
		case 'stop':
			CrouchToStandWalk();
			break;

		case 'walk':
			BlendIntoStandWalk();
			break;

		default:
			assert(a.movement == 'run');
			BlendIntoStandWalk();
			break;
		}
		break;

	default:
		assert(a.pose == 'prone');
		ProneToStandWalk();
		break;
	}
	
	return true;
}

function bool BeginStandRun()
{
	switch (a.pose)
	{
	case 'stand':
		switch (a.movement)
		{
		case 'stop':
			BlendIntoStandRun();
			break;

		case 'walk':
			BlendIntoStandRun();
			break;

		default:
			assert(a.movement == 'run');
			return false;
		}
		break;

	case 'crouch':
		switch (a.movement)
		{
		case 'stop':
			CrouchToStandRun();
			break;

		default:
			assert(a.movement == 'run' || a.movement == 'walk');
			BlendIntoStandRun();
			break;
		}
		break;

	default:
		assert(a.pose == 'prone');
		ProneToStandRun();
		break;
	}
	
	return true;
}

//--------------------------------------------------------------------------------
// Crouching functions
//--------------------------------------------------------------------------------
function BeginCrouchStop()
{
	switch (a.pose)
	{
	case 'stand':
		switch (a.movement)
		{
		case 'stop':
			StandToCrouch();
			break;
		case 'walk':
			StandWalkToCrouch();
			break;
		case 'run':
			StandRunToCrouch();
			break;
		default:
			assert (false);
			//assertEX(0, 'SetPoseMovement::BeginCrouchStop '+self.a.pose+' '+self.a.movement);
		}
		break;
	case 'crouch':
		switch (a.movement)
		{
		case 'stop':
			// Do nothing
			break;
		case 'walk':
			CrouchWalkToCrouch();
			break;
		case 'run':
			CrouchRunToCrouch();
			break;
		default:
			assert (false);
			//assertEX(0, 'SetPoseMovement::BeginCrouchStop '+self.a.pose+' '+self.a.movement);
		}
		break;
	case 'prone':
		ProneToCrouch();
		break;
	default:
		assert (false);
//		assertEX(0, 'SetPoseMovement::BeginCrouchStop '+self.a.pose+' '+self.a.movement);
	}
}

function bool BeginCrouchWalk()
{
	switch (a.pose)
	{
	case 'stand':
		switch (a.movement)
		{
		case 'stop':
			run (new(self) class'trans_StandToCrouchWalk', false);
			break;

		case 'walk':
			BlendIntoCrouchWalk();
			break;

		default:
			assert(a.movement == 'run');
			BlendIntoCrouchWalk();
			break;
		}
		break;

	case 'crouch':
		switch (a.movement)
		{
		case 'stop':
			CrouchToCrouchWalk();
			break;
			
		case 'walk':
			return false;

		default:
			assert(a.movement == 'run');
			BlendIntoCrouchWalk();
			break;
		}
		break;

	default:
		assert(a.pose == 'prone');
		// Let's try going straight to the run and then blending back to see what it looks like.
		ProneToCrouchWalk();
		break;
	}
	
	return true;
}

function bool BeginCrouchRun()
{
	switch (a.pose)
	{
	case 'stand':
		switch (a.movement)
		{
		case 'stop':
			StandToCrouchRun();
			break;

		default:
			assert(a.movement == 'run' || a.movement == 'walk');
			BlendIntoCrouchRun();
			break;
		}
		break;

	case 'crouch':
		switch (a.movement)
		{
		case 'stop':
			CrouchToCrouchRun();
			break;

		case 'walk':
			BlendIntoCrouchRun();
			break;

		default:
			assert(a.movement == 'run');
			return false;
		}
		break;

	default:
		assert(a.pose == 'prone');
		ProneToCrouchRun();
		break;
	}
	
	return true;
}

//--------------------------------------------------------------------------------
// Prone Functions
//--------------------------------------------------------------------------------

function BeginProneStop()
{
	switch (a.pose)
	{
	case 'stand':
		switch (a.movement)
		{
		case 'stop':
			StandToProne();
			break;
		case 'walk':
			StandToProne();
			break;
		case 'run':
			CrouchRunToProne();
			break;
		default:
			assert (false);
//			assertEX(0, 'SetPoseMovement::BeginCrouchRun '+self.a.pose+' '+self.a.movement);
		}
		break;
	case 'crouch':
		switch (a.movement)
		{
		case 'stop':
			CrouchToProne();	
			break;
		case 'walk':
			CrouchToProne();
			break;
		case 'run':
			CrouchRunToProne();
			break;
		default:
			assert (false);
			//assertEX(0, 'SetPoseMovement::BeginCrouchRun '+self.a.pose+' '+self.a.movement);
		}
		break;
	case 'prone':
		switch (a.movement)
		{
		case 'stop':
			// Do nothing
			break;
		case 'walk':
		case 'run':
			ProneCrawlToProne();
			break;
		default:
			assert (false);
			//assertEX(0, 'SetPoseMovement::BeginCrouchRun '+self.a.pose+' '+self.a.movement);
		}
		break;
	default:
		assert (false);
		//assertEX(0, 'SetPoseMovement::BeginCrouchRun '+self.a.pose+' '+self.a.movement);
	}
}

function bool BeginProneWalk()
{
	switch (a.pose)
	{
	case 'stand':
		switch (a.movement)
		{
		case 'stop':
			StandToProneWalk();
			break;

		default:
			assert(a.movement == 'run' || a.movement == 'walk');
			CrouchRunToProneWalk();
			break;
		}
		break;

	case 'crouch':
		switch (a.movement)
		{
		case 'stop':
			CrouchToProneWalk();
			break;

		default:
			assert(a.movement == 'run' || a.movement == 'walk');
			CrouchRunToProneWalk();
			break;
		}
		break;

	default:
		assert(a.pose == 'prone');
		switch (a.movement)
		{
		case 'stop':
			ProneToProneRun();
			break;

		default:
			assert(a.movement == 'run' || a.movement == 'walk');
			a.movement = 'walk';
			return false;
		}
		break;
	}
	
	return true;
}

function bool BeginProneRun()
{
	switch (a.pose)
	{
	case 'stand':
		switch (a.movement)
		{
		case 'stop':
			StandToProneRun();
			break;

		default:
			assert(a.movement == 'run' || a.movement == 'walk');
			StandRunToProneRun();
			break;
		}
		break;

	case 'crouch':
		switch (a.movement)
		{
		case 'stop':
			CrouchToProneRun();
			break;

		default:
			assert(a.movement == 'run' || a.movement == 'walk');
			CrouchRunToProneRun();
			break;
		}
		break;

	default:
		assert(a.pose == 'prone');
		switch (a.movement)
		{
		case 'stop':
			assert(a.movement == 'stop');
			ProneToProneRun();
			break;

		default:
			assert(a.movement == 'run' || a.movement == 'walk');
			a.movement = 'run';
			return false;
		}
		break;
	}
	
	return true;
}


//--------------------------------------------------------------------------------
// Standing support functions
//--------------------------------------------------------------------------------

function PlayBlendTransition(name iTransAnim, float iCrossblendTime, name iEndPose, name iEndMovement, bool iEndAiming, optional bool newThread = false)
{
	local trans_PlayBlendTransition task;
	task = new(self) class'trans_PlayBlendTransition';
	task.iTransAnim = iTransAnim;
	task.iCrossblendTime = iCrossblendTime;
	task.iEndPose = iEndPose;
	task.iEndMovement = iEndMovement;
	task.iEndAiming = iEndAiming;
	run(task, newThread);
}

//PlayTransitionStandWalk(itransAnim, finalAnim)
//{
//	PlayTransitionAnimation(itransAnim, 'stand', 'walk', 1, finalAnim);
//}

function StandWalkToStand()
{
	//assertEX(self.a.pose == 'stand', 'SetPoseMovement::StandWalkToStand '+self.a.pose);
	//assertEX(self.a.movement == 'walk', 'SetPoseMovement::StandWalkToStand '+self.a.movement);
	
	// no transition animations.
	
	a.movement = 'stop';
}


function StandWalkToCrouch(optional bool newThread = false)
{
	run (new(self) class'trans_StandWalkToCrouch', newThread);
}


function StandRunToStand()
{
	//assertEX(self.a.pose == 'stand', 'SetPoseMovement::StandRunToStand '+self.a.pose);
	//assertEX(self.a.movement == 'run', 'SetPoseMovement::StandRunToStand '+self.a.movement);
	
	// Do nothing, just blend straight in
	a.movement = 'stop';
}

function StandRunToCrouch()
{
	a.movement = 'stop';
	a.pose = 'crouch';
}

function StandRunToProneRun(optional bool newThread = false)
{
	run (new(self) class'trans_StandRunToProneRun', newThread);
}

function PlayBlendTransitionStandRun(name animname, optional bool newThread = false)
{
	local trans_PlayBlendTransitionStandRun task;
	task = new(self) class'trans_PlayBlendTransitionStandRun';
	task.animname = animname;
	run(task, newThread);
}

function BlendIntoStandRun()
{
	local trans_BlendIntoStandRun task;
	task = new(self) class'trans_BlendIntoStandRun';
	run(task, false);
}

function PlayBlendTransitionStandWalk(name iAnimName, optional bool newThread = false)
{
	local trans_PlayBlendTransitionStandWalk task;
	task = new(self) class'trans_PlayBlendTransitionStandWalk';
	task.iAnimName = iAnimName;
	run (task, newThread);
}

function BlendIntoStandWalk()
{
	local name lAnim;
	local float lRate;
	animscripts_walk.GetStandWalkAnim(lAnim, lRate);
	PlayBlendTransitionStandWalk(SetCustomAnim(combatrun_forward, lAnim, lRate, true));
}

function CrouchToStand(optional bool newThread = false)
{
	run (new(self) class'trans_CrouchToStand', newThread);
	//a.movement = 'stop';
	//a.pose = 'stand';
}

function StandToCrouchRun(optional bool newThread = false)
{
	run (new(self) class'trans_StandToCrouchRun', newThread);
}

//--------------------------------------------------------------------------------
// Crouched Support Functions
//--------------------------------------------------------------------------------


function CrouchToCrouchWalk()
{
	//assertEX(self.a.pose == 'crouch', 'SetPoseMovement::CrouchToCrouchWalk '+self.a.pose);
	//assertEX(self.a.movement == 'stop', 'SetPoseMovement::CrouchToCrouchWalk '+self.a.movement);

	BlendIntoCrouchWalk();
}

function CrouchToStandWalk(optional bool newThread = false)
{
	run (new(self) class'trans_CrouchToStandWalk', newThread);
}

function CrouchWalkToCrouch()
{
	//assertEX(self.a.pose == 'crouch', 'SetPoseMovement::CrouchWalkToCrouch '+self.a.pose);
	//assertEX(self.a.movement == 'walk', 'SetPoseMovement::CrouchWalkToCrouch '+self.a.movement);
	
	// Do nothing, just blend straight in
	a.movement = 'stop';
}

function CrouchWalkToStand(optional bool newThread = false)
{
	run (new(self) class'trans_CrouchWalkToStand', newThread);
}

function CrouchRunToCrouch()
{
	//assertEX(self.a.pose == 'crouch', 'SetPoseMovement::CrouchRunToCrouch '+self.a.pose);
	//assertEX(self.a.movement == 'run', 'SetPoseMovement::CrouchRunToCrouch '+self.a.movement);
	
	// Do nothing, just blend straight in
	a.movement = 'stop';
}

function CrouchRunToStand(optional bool newThread = false)
{
	run (new(self) class'trans_CrouchRunToStand', newThread);
}

function CrouchToCrouchRun()
{
//	assertEX(self.a.pose == 'crouch', 'SetPoseMovement::CrouchToCrouchRun '+self.a.pose);
//	assertEX(self.a.movement == 'stop', 'SetPoseMovement::CrouchToCrouchRun '+self.a.movement);
	
	BlendIntoCrouchRun();
}

function CrouchToStandRun()
{
	BlendIntoStandRun();
}

function BlendIntoCrouchRun(optional bool newThread = false)
{
	run (new(self) class'trans_BlendIntoCrouchRun', newThread);
}

function ProneToCrouchRun(optional bool newThread = false)
{
	run (new(self) class'trans_ProneToCrouchRun', newThread);
}

function ProneToStandRun(optional bool newThread = false)
{
	run (new(self) class'trans_ProneToStandRun', newThread);
}

function ProneToCrouchWalk(optional bool newThread = false)
{
	run (new(self) class'trans_ProneToCrouchWalk', newThread);
}

function BlendIntoCrouchWalk(optional bool newThread = false)
{
	run (new(self) class'trans_BlendIntoCrouchWalk', newThread);
}

function StandToCrouch(optional bool newThread = false)
{
	run (new(self) class'trans_StandToCrouch', newThread);
}

function ProneToCrouch(optional bool newThread = false)
{
	run (new(self) class'trans_ProneToCrouch', newThread);
}

function ProneToStand(optional bool newThread = false)
{
	run (new(self) class'trans_ProneToStand', newThread);
}

function ProneToStandWalk(optional bool newThread = false)
{
	run (new(self) class'trans_ProneToStandWalk', newThread);
}

//--------------------------------------------------------------------------------
// Prone Support Functions
//--------------------------------------------------------------------------------

function ProneToProneMove(name iMovement, optional bool newThread = false)
{
	local trans_ProneToProneMove task;
	task = new(self) class'trans_ProneToProneMove';
	task.iMovement = iMovement;
	run (task, newThread);
}


function ProneToProneRun()
{
	ProneToProneMove('run');
}

function ProneCrawlToProne(optional bool newThread = false)
{
	run (new(self) class'trans_ProneCrawlToProne', newThread);
}

function CrouchToProne(optional bool newThread = false)
{
	run (new(self) class'trans_CrouchToProne', newThread);
}

function CrouchToProneWalk(optional bool newThread = false)
{
	run (new(self) class'trans_CrouchToProneWalk', newThread);
}

function CrouchToProneRun(optional bool newThread = false)
{
	run (new(self) class'trans_CrouchToProneRun', newThread);
}

function StandToProne(optional bool newThread = false)
{
	run (new(self) class'trans_StandToProne', newThread);
}

function StandToProneWalk(optional bool newThread = false)
{
	run (new(self) class'trans_StandToProneWalk', newThread);
}

function StandToProneRun(optional bool newThread = false)
{
	run (new(self) class'trans_StandToProneRun', newThread);
}

function CrouchRunToProne(optional bool newThread = false)
{
	run (new(self) class'trans_CrouchRunToProne', newThread);
}

function CrouchRunToProneWalk(optional bool newThread = false)
{
	run (new(self) class'trans_CrouchRunToProneWalk', newThread);
}

function CrouchRunToProneRun(optional bool newThread = false)
{
	run (new(self) class'trans_CrouchRunToProneRun', newThread);
}

////--------------------------------------------------------------------------------
//// General support functions
////--------------------------------------------------------------------------------
//
//// PlayTransitionAnimation2 is superceding PlayTransitionAnimation, gradually.  Right now it doesn't set pose 
//// and movement (since they should be in notetracks).  Eventually it will take a struct instead of individual 
//// parameters for anim state variables.
//PlayTransitionAnimation2(itransAnim, endPose, endMovement, endAiming, finalAnim)
//{
//	// Play the anim
//	self setflaggedanimknoball('transAnimDone1', itransAnim, %body, 1, .05, 1);
//	if (!isDefined(self.a.pose))
//		self.pose = 'undefined';
//	if (!isDefined(self.a.movement))
//		self.movement = 'undefined';
//	debugIdentifier = self.a.pose+' to '+endPose+', '+self.a.movement+' to '+endMovement;
//	self animscripts\shared::DoNoteTracks('transAnimDone1', undefined, debugIdentifier);
//
//	// Set state variables in case anything went wrong (like the anim was already halfway through, or the 
//	// framerate was so low that the 'end' note came before a change pose note.
//	self.a.pose = endPose;
//	self.a.movement = endMovement;
//	if (endAiming)
//		self.a.alertness = 'aiming';
//	else
//		self.a.alertness = 'casual';
//
//	if (isDefined(finalAnim))
//	{
//		self setanimknoball(finalAnim, %body, 1, 0, 1);	// Set the animation instantly
//	}
//}


function PlayTransitionAnimationThread_WithoutWaitSetStates(name itransAnim, name endPose, name endMovement, bool endAiming, optional name finalAnim = '', optional float rate = 1, optional bool newThread = false)
{
	local trans_PlayTransitionAnimationThread_WithoutWaitSetStates task;
	task = new(self) class'trans_PlayTransitionAnimationThread_WithoutWaitSetStates';
	task.itransAnim = itransAnim;
	task.endPose = endPose;
	task.endMovement = endMovement;
	task.endAiming = endAiming;
	task.finalAnim = finalAnim;
	task.rate = rate;
	run (task, newThread);
}

function PlayTransitionAnimation(name itransAnim, name endPose, name endMovement, optional bool endAiming = false, optional name finalAnim = '', optional float rate = 1)
{
	PlayTransitionAnimationFunc(itransAnim, endPose, endMovement, endAiming, finalAnim, rate, true);
}


function PlayTransitionAnimationFunc(name itransAnim, name endPose, name endMovement, bool endAiming, name finalAnim, float rate, bool waitSetStatesEnabled, optional bool newThread = false)
{
	local trans_PlayTransitionAnimationFunc task;
	task = new(self) class'trans_PlayTransitionAnimationFunc';
	task.itransAnim = itransAnim;
	task.endPose = endPose;
	task.endMovement = endMovement;
	task.endAiming = endAiming;
	task.finalAnim = finalAnim;
	task.rate = rate;
	task.waitSetStatesEnabled = waitSetStatesEnabled;
	run (task, newThread);
}


function WaitSetStates(float timetowait, name killmestring, name endPose, optional bool newThread = false)
{
	local trans_WaitSetStates task;
	task = new(self) class'trans_WaitSetStates';
	task.timetowait = timetowait;
	task.killmestring = killmestring;
	task.endPose = endPose;
	run (task, newThread);
}


function ProneLegsStraightTree(float blendtime)
{
	//self setanimknoball(%prone_legsstraight, %body, 1, blendtime, 1);
}
