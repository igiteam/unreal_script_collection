class animscripts_stop extends Object within HodAI;

// 'Stop' makes the character not walk, run or fight.  He can be standing, crouching or lying 
// prone; he can be alert or idle. 

function main(optional bool newThread = false)
{
	run (new(self) class'stop_main', newThread);
}

function SetLastStoppedTime(optional bool newThread = false)
{
	run (new(self) class'stop_SetLastStoppedTime', newThread);
}

function name GetDesiredIdlePose()
{
	local HodNode myNode;
	local name myNodeType;
	local name desiredPose;
	//local float myNodeAngle;

	myNode = animscripts_utility.GetClaimedNode();
	if (obj_isdefined(myNode))
	{
		//myNodeAngle = myNode.angles.yaw;
		myNodeType = myNode.type;
	}
	else
	{
		//myNodeAngle = self.desiredAngle;
		myNodeType = 'node was undefined';
	}
	
//	self animscripts\face::SetIdleFace(anim.alertface);

	// Find out if we should be standing, crouched or prone
	desiredPose = animscripts_utility.choosePose();

	if (myNodeType == 'Cover Stand' || myNodeType == 'Conceal Stand')
	{
		// At cover_stand nodes, we don't want to crouch since it'll most likely make our gun go through the wall.
		desiredPose = animscripts_utility.choosePose('stand');
	}
	else if (myNodeType == 'Cover Crouch' || myNodeType == 'Conceal Crouch')
	{
		// We should crouch at concealment crouch nodes.
		desiredPose = animscripts_utility.choosePose('crouch');
	}
	else if (myNodeType == 'Cover Prone' || myNodeType == 'Conceal Prone')
	{
		// We should go prone at prone nodes.
		desiredPose = animscripts_utility.choosePose('prone');
	}
	
	return desiredPose;
}

function TransitionToIdle(name ipose, int idleSet)
{
	local name idleAnim;
	local int id;

	id = PoseID(ipose);
//	if (self isCQBWalking() && self.a.pose == 'stand' && self IsInCombat())
//		ipose = 'stand_cqb';
	
	if (id < anim.idleAnimTransitionIn.length &&
		anim.idleAnimTransitionIn[id] != '')
	{
//		assert(isdefined(anim.idleAnimTransition[ipose]['in']));
		
		idleAnim = SetCustomAnim(stand_and_crouch, anim.idleAnimTransitionIn[id]);
		setFlaggedAnimKnobAllRestart('idle_transition', idleAnim, 'body', 1, 0.3, animplaybackrate);
		animscripts_shared.DoNoteTracks ('idle_transition');
	}
}

function PlayIdle(name ipose, int idleSet)
{
	local int id;
	local float transTime;
	local name idleAnim;
//	if (self isCQBWalking() && self.a.pose == 'stand' && self IsInCombat())
//		ipose = 'stand_cqb';
	id = PoseID(ipose);
	
	idleSet = idleSet % anim.idleAnimArray[id].data.length;
	
	idleAnim = SetCustomAnim(stand_and_crouch, animscripts_utility.anim_array(anim.idleAnimArray[id].data[idleSet], anim.idleAnimWeights[id].data[idleSet]));
	
	transTime = 0.2;
	if (gettime() == a.scriptStartTime)
		transTime = 0.5;
	
	setFlaggedAnimKnobAllRestart('idle', idleAnim, 'body', 1, transTime, animplaybackrate);
	animscripts_shared.DoNoteTracks('idle');
}

function ProneStill(optional bool newThread = false)
{
	run (new(self) class'stop_ProneStill', newThread);
}

function UpdateProneThread(optional bool newThread = false)
{
	run (new(self) class'stop_UpdateProneThread', newThread);
}

//delayedException()
//{
//	self endon('killanimscript');
//	wait (0.05);
//	[[ self.exception[ 'stop' ] ]]();
//}
