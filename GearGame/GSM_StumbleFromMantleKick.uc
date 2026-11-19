
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_StumbleFromMantleKick extends GearSpecialMove;

/** Mantle kick animation */
var() GearPawn.BodyStance BS_MantleKickAnim;
/** Mirrored over animation */
var() GearPawn.BodyStance BS_MirroredMantleKickAnim;
/** Mantle kick animation */
var() GearPawn.BodyStance BS_MantleKickTransitionAnim;
/** Mirrored over animation */
var() GearPawn.BodyStance BS_MirroredMantleKickTransitionAnim;
/** Scale factor for root motion */
var	float RootMotionScaleFactor;
/** Are we using the mirrored version of the animations? */
var	bool bUsingMirroredVersion;

protected function bool InternalCanDoSpecialMove()
{
	if( PawnOwner.IsDoingSpecialMove(SM_StumbleFromMantleKick) || 
		PawnOwner.IsDoingSpecialMove(SM_MidLvlJumpOver) ||
		PawnOwner.IsAKidnapper() ||
		( PawnOwner.Base != None && PawnOwner.Base.IsA('GearPawnRidable_Base') ) )
	{
		return FALSE;
	}
	return TRUE;
}


/** This special move can override pretty much any other special moves. */
function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPC PC;
	local float AnimTime;

	PawnOwner.Mesh.RootMotionAccelScale.X = RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale.Y = RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale.Z = 1.f;

	// If we are carrying a heavy weapon, drop it
	if( PawnOwner.IsCarryingAHeavyWeapon() )
	{
		PawnOwner.ThrowActiveWeapon();
	}

	Super.SpecialMoveStarted(bForced,PrevMove);

	PC = GearPC(PawnOwner.Controller);
	if( PC != None )
	{
		PC.LeaveCover();
	}

	if( PawnOwner.InteractionPawn != None && PawnOwner.SpecialMoveFlags == 1 )
	{
		SetFacePreciseRotation(rotator(PawnOwner.InteractionPawn.Location - PawnOwner.Location),0.0f);
	}

	if( PawnOwner.bIsMirrored )
	{
		bUsingMirroredVersion = true;
		// Play body stance animation.
		AnimTime = PawnOwner.BS_Play(BS_MirroredMantleKickTransitionAnim, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);
		// Turn on root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(BS_MirroredMantleKickTransitionAnim, RBA_Translate, RBA_Translate );
		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_MirroredMantleKickTransitionAnim, TRUE);
	}
	else
	{
		bUsingMirroredVersion = false;
		// Play body stance animation.
		AnimTime = PawnOwner.BS_Play(BS_MantleKickTransitionAnim, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);
		// Turn on root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(BS_MantleKickTransitionAnim, RBA_Translate, RBA_Translate );
		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_MantleKickTransitionAnim, TRUE);
	}

	// if no anim was played, just play reaction
	if (AnimTime <= 0.f)
	{
		PlayReactionAnim();
	}

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	// if finished kick transition, play reaction
	if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_MantleKickTransitionAnim) ||
		PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_MirroredMantleKickTransitionAnim))
	{
		PlayReactionAnim();
		return;
	}

	Super.BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
}

// Play Reaction Animation
simulated function PlayReactionAnim()
{
	if( bUsingMirroredVersion )
	{
		// Play body stance animation.
		PawnOwner.BS_Play(BS_MirroredMantleKickAnim, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);
		// Turn on root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(BS_MirroredMantleKickAnim, RBA_Translate, RBA_Translate );
		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_MirroredMantleKickAnim, TRUE);
	}
	else
	{
		// Play body stance animation.
		PawnOwner.BS_Play(BS_MantleKickAnim, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);
		// Turn on root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(BS_MantleKickAnim, RBA_Translate, RBA_Translate );
		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_MantleKickAnim, TRUE);
	}

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	if( bUsingMirroredVersion )
	{
		// Turn off Root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(BS_MirroredMantleKickAnim, RBA_Discard, RBA_Discard, RBA_Discard );
		PawnOwner.BS_SetAnimEndNotify(BS_MirroredMantleKickAnim, FALSE);
		PawnOwner.BS_Stop(BS_MirroredMantleKickAnim, 0.2f/SpeedModifier);
	}
	else
	{
		// Turn off Root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(BS_MantleKickAnim, RBA_Discard, RBA_Discard, RBA_Discard );
		PawnOwner.BS_SetAnimEndNotify(BS_MantleKickAnim, FALSE);
		PawnOwner.BS_Stop(BS_MantleKickAnim, 0.2f/SpeedModifier);
	}

	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
	PawnOwner.Mesh.RootMotionAccelScale.X = 1.f;
	PawnOwner.Mesh.RootMotionAccelScale.Y = 1.f;
	PawnOwner.Mesh.RootMotionAccelScale.Z = 1.f;
}


defaultproperties
{
	RootMotionScaleFactor=1.f
	BS_MantleKickAnim=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Kick_React")))
	BS_MirroredMantleKickAnim=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Kick_React_Mirrored")))
	BS_MantleKickTransitionAnim=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Kick_React_Transition")))
	BS_MirroredMantleKickTransitionAnim=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Kick_React_Mirrored_Transition")))

	bForcePrecisePosition=true
	bShouldAbortWeaponReload=true
	bCanFireWeapon=false
	bCameraFocusOnPawn=true
	bLockPawnRotation=true
	bBreakFromCover=true
	bDisableMovement=true
	bUseUnsynchedServerMove=true
}
