/**
 * Play the Silverback kick animation
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_Land extends GSM_BasePlaySingleAnim;

var GearPawn.BodyStance BS_Landing;
var GearPawn.BodyStance BS_Landing2;
var GearPawn.BodyStance BS_BalconyLanding;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local Rotator Rot;

	Rot = PawnOwner.Rotation;
	Rot.Pitch = 0;
	PawnOwner.SetDesiredRotation(Rot, true, , 0.25f);
// 	PawnOwner.LockDesiredRotation(true);

	Super.SpecialMoveStarted(bForced, PrevMove);
}

function SetupAnimation()
{
	local GearPawn_LocustTempestBase Tempest;
	Tempest = GearPawn_LocustTempestBase(PawnOwner);

	if ( Tempest.bBalconyMode )
	{
		BS_Animation = BS_BalconyLanding;
	}
	else
	{
		BS_Animation = (Rand(2) == 0) ? BS_Landing : BS_Landing2;
	}
}
/** Overwrite playmyanim to add root motion **/
function float PlayMyAnim()
{
	local float AnimTime;

	// set up which one to play first
	SetupAnimation();

	AnimTime = Super.PlayMyAnim();

	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.BS_SetEarlyAnimEndNotify(BS_Animation, FALSE);
	PawnOwner.Mesh.RootMotionMode = RMM_Translate;

	return AnimTime;
}

/** When ended, unset root motion **/
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPawn_LocustTempestBase Tempest;

	// turn off root motion
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
	
	Tempest = GearPawn_LocustTempestBase(PawnOwner);
	// reset idle 
	Tempest.ActivateGroundMode(TRUE);	
	Tempest.ResetIdle();

	Super.SpecialMoveEnded(PrevMove, NextMove);

	Tempest.DoSpecialMove(SM_Tempest_Thrash);
}

/**
 * Can the special move be chained after the current one finishes?
 */
function bool CanChainMove(ESpecialMove NextMove)
{
	return NextMove == SM_Tempest_Thrash;
}

defaultproperties
{
	BS_Landing=(Stance=((Slot=BS_FullBody,AnimName="Land_Crash_1")))
	BS_Landing2=(Stance=((Slot=BS_FullBody,AnimName="Land_Crash_2")))
	BS_BalconyLanding=(Stance=((Slot=BS_FullBody,AnimName="Land_Balcony")))

	// if not, root motion will be still active (root distance) while playing next one
	BlendOutTime=0.f
	bDisableAI=TRUE
// 	bLockPawnRotation=true
}
