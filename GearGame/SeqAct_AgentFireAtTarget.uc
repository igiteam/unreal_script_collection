/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqAct_AgentFireAtTarget extends SeqAct_PlayAgentAnimation
	dependson(GearCrowdAgent);

/** Offset to fire weapon from. */
var() vector FireOffset;
/** Error when firing - in degrees */
var() float AimError;
/** Min delay between each firing of the weapon */
var() float MinWeaponFireDelay;
/** Max delay between each firing of the weapon */
var() float MaxWeaponFireDelay;
/** Number of shots to fire */
var() int ShotsToFire;


function SetCurrentAnimationActionFor(GameCrowdAgentSkeletal Agent)
{
	local GearCrowdBehavior_FireWeapon AnimBehavior;
	local int i;
	
	// init behavior properties
	AnimBehavior = new(Agent) class'GearCrowdBehavior_FireWeapon';
	AnimBehavior.AnimSequence = self;
	AnimBehavior.BlendInTime = BlendInTime;
	AnimBehavior.BlendOutTime = BlendOutTime;
	AnimBehavior.bUseRootMotion = bUseRootMotion;
	AnimBehavior.bFaceActionTargetFirst = bFaceActionTargetFirst;
	AnimBehavior.bLooping = bLooping;
	AnimBehavior.LoopIndex = LoopIndex;
	AnimBehavior.LoopTime = LoopTime;
	AnimBehavior.bBlendBetweenAnims = bBlendBetweenAnims;
	AnimBehavior.CustomActionTarget = ActionTarget;
	AnimBehavior.FireOffset = FireOffset;
	AnimBehavior.AimError = AimError;
	AnimBehavior.MinWeaponFireDelay = MinWeaponFireDelay;
	AnimBehavior.MaxWeaponFireDelay = MaxWeaponFireDelay;
	AnimBehavior.ShotsToFire = ShotsToFire;
	
	for ( i=0; i<AnimationList.Length; i++ )
	{
		AnimBehavior.AnimationList[i] = AnimationList[i];
	}

	// activate behavior
	Agent.ActivateInstancedBehavior(AnimBehavior);
}

defaultproperties
{
	ObjName="Agent Fire At Target"
	ObjCategory="Crowd"

	MinWeaponFireDelay=0.5f
	MaxWeaponFireDelay=1.0f
	ShotsToFire=-1
}
