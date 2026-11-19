
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Wretch_PounceAttack extends GearSpecialMove;

var protected ERootBoneAxis RootBoneAxis_X;
var protected ERootBoneAxis RootBoneAxis_Y;
var protected ERootBoneAxis RootBoneAxis_Z;

/** Mantle over animation */
var()	GearPawn.BodyStance	BS_Animation;
var()	float				RootMotionScaleFactor;

var() const float AttackRange;

var transient float AnimDuration;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearAI AI;

	Super.SpecialMoveStarted(bForced,PrevMove);

	GearPawn_LocustWretchBase(PawnOwner).PlayLeapSound();
	GearPawn_LocustWretchBase(PawnOwner).PlaySwipeAttackSound();

	// reset animation mirroring
	PawnOwner.SetMirroredSide(FALSE);

	// Play body stance animation.
	AnimDuration = PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);

	// Turn on Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RootBoneAxis_X, RootBoneAxis_Y, RootBoneAxis_Z);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
	// Scale root motion translation by ScaleFactor, except for Z component.
	PawnOwner.Mesh.RootMotionAccelScale.X = RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale.Y = RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale.Z = 1.f;


	AI = GearAI(PawnOwner.Controller);
	if( AI != None )
	{
		// Tell AI to wait for attack to finish
		class'AICmd_WaitingForEvent'.static.Wait(AI, 'EndSwipeAttack');
	}
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearAI AI;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.Mesh.RootMotionAccelScale = PawnOwner.default.Mesh.RootMotionAccelScale;

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);

	// Disable end of animation notification.
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	AI = GearAI(PawnOwner.Controller);
	if( AI != None )
	{
		// Tell AI attack is finished
		AI.ReceiveEvent('EndSwipeAttack');
	}

}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Jump_Swipe")))

	bLockPawnRotation=true
	bBreakFromCover=true
	bDisableMovement=true
	bCanFireWeapon=false
	RootMotionScaleFactor=0.5f

	RootBoneAxis_X=RBA_Translate
	RootBoneAxis_Y=RBA_Translate
	RootBoneAxis_Z=RBA_Translate

	AttackRange=512
}
