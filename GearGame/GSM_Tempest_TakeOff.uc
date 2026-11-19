
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_TakeOff extends GSM_BasePlaySingleAnim;

var	GearPawn.BodyStance	BS_TakeOff;
var	GearPawn.BodyStance	BS_BalconyTakeOff;

var GearPawn_LocustTempestBase Tempest;

function SetupAnimation()
{
	if ( Tempest.bBalconyMode )
	{
		BS_Animation = BS_BalconyTakeOff;
	}
	else
	{
		BS_Animation = BS_TakeOff;
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


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	// switching to air mode now. It's safe to do that before playing fullbody, so that when it comes out, it will be already there. 
	Tempest = GearPawn_LocustTempestBase(PawnOwner);		
	Tempest.ActivateGroundMode(FALSE);
	// Start fading out the face goo
	Tempest.StartFadingOutFaceGoo();

	Super.SpecialMoveStarted(bForced,PrevMove);
}

//NOTE: Is ended by an outside call to end the move, does not end itself!
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// unset root motion
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	// rest idle, so that it doesn't pop from last pose of TakeOff
	GearPawn_LocustTempestBase(PawnOwner).ResetIdle();

	GearPawn_LocustTempestBase(PawnOwner).ResetMouthDamage();

	Super.SpecialMoveEnded(PrevMove, NextMove);

	Tempest.TriggerEventClass(class'SeqEvt_TempestAnimFinished', Tempest, 0);
}

defaultproperties
{
	BS_TakeOff=(Stance=((Slot=BS_FullBody,AnimName="DropOff_1")))
	BS_BalconyTakeOff=(Stance=((Slot=BS_FullBody,AnimName="TakeOff_Balcony")))
	bRestoreMovementAfterMove=TRUE
	bDisableAI=true
	bLockPawnRotation=true
}
