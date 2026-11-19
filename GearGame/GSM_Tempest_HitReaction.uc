
/**
 * Play a full body hit reaction, takes over control for a little bit.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_HitReaction extends GSM_BasePlaySingleAnim;

var Array<BodyStance> HitReactionBSList;

protected function bool InternalCanDoSpecialMove()
{
	// if it's doing any special move, don't allow
	if( PawnOwner.SpecialMove != SM_None )
	{
		return FALSE;
	}

	return TRUE;
}

static function INT PickHitReactionAnim(GearPawn Victim, class<GearDamageType> DamageType, TraceHitInfo HitInfo, vector Momentum, vector HitLocation)
{
	return 0;
}

function PlayAnimation()
{
	// Assign proper animation.
	BS_Animation = HitReactionBSList[PawnOwner.SpecialMoveFlags];

	Super.PlayAnimation();

	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate, RBA_Translate);
	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;

	// Use root rotation to rotate the actor.
	PawnOwner.BS_SetRootRotationOption(BS_Animation, RRO_Extract);
	PawnOwner.Mesh.RootMotionRotationMode = RMRM_RotateActor;

	PawnOwner.BS_SetEarlyAnimEndNotify(BS_Animation, FALSE);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Reset root rotation
	PawnOwner.BS_SetRootRotationOption(BS_Animation, RRO_Discard);
	PawnOwner.Mesh.RootMotionRotationMode = RMRM_Ignore;

	// Restore default root motion mode
	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);

	// Make sure animation is stopped if aborted
	if( PawnOwner.BS_IsPlaying(BS_Animation) )
	{
		PawnOwner.BS_Stop(BS_Animation, BlendOutTime);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	HitReactionBSList(0)=(Stance=((Slot=BS_Additive,AnimName="ADD_HitReaction_Head")))
	BlendInTime=0.2f
	BlendOutTime=0.42f

	//DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bBreakFromCover=TRUE
	bDisableTurnInPlace=TRUE
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableMovement=TRUE
	bLockPawnRotation=TRUE
	bDisableAI=TRUE
	bRestoreMovementAfterMove=TRUE
}
