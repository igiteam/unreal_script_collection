
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_DeathAnimCleaver extends GSM_DeathAnimBase;

var BodyStance	BS_FrontHit, BS_BackHit;
var transient BodyStance BS_Animation;

/** Restrictions for doing Death Animation. */
protected function bool InternalCanDoSpecialMove()
{
	// We need a mesh to do any of this.
	if( PawnOwner.Mesh == None || PawnOwner.SpecialMoveWhenDead == SM_MidLvlJumpOver || PawnOwner.SpecialMoveWhenDead == SM_MantleKick )
	{
		return FALSE;
	}
	
	// Pawn has to be burning to do this type of death
	if( PawnOwner.GetLastTakeHitInfo().DamageType == class'GDT_Cleaver' )
	{
		return TRUE;
	}

	return FALSE;
}

/** This special move can override pretty much any other special moves. */
function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	// if momentum was coming from front
	if (Normal(PawnOwner.GetLastTakeHitInfo().Momentum) dot (vector(PawnOwner.Rotation)) > 0.f)
	{
		BS_Animation = BS_BackHit;
	}
	else
	{
		BS_Animation = BS_FrontHit;
	}

	PlayHitReaction();
}

function PlayHitReaction()
{
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.33f/SpeedModifier, 0.33f/SpeedModifier);
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate, RBA_Translate);
	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);
	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Ignore;
	DeathAnimRagDoll();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);
	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Ignore;

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function DeathAnimBlendToMotors_Writhing()
{
	// Setup a bunch of springs to have physics match animation (as long as we are standing on non-moving thing)
	// Don't do it if we have broken constraints. We could figure out which ones are broken... For now, just do nothing.
	if( PawnOwner.Base != None && !PawnOwner.Base.bMovable && !PawnOwner.bHasBrokenConstraints )
	{
		SetSpringForBone(PawnOwner.PelvisBoneName, TRUE);
		SetSpringForBone(PawnOwner.RightHandBoneName, TRUE);
		SetSpringForBone(PawnOwner.LeftHandBoneName, TRUE);
// 		SetSpringForBone(PawnOwner.LeftFootBoneName, TRUE);
// 		SetSpringForBone(PawnOwner.RightFootBoneName, TRUE);
	}

	Super.DeathAnimBlendToMotors();
}

function DeathAnimRagDoll()
{
	// Turn off bone springs
	SetSpringForBone(PawnOwner.PelvisBoneName, FALSE);
	SetSpringForBone(PawnOwner.RightHandBoneName, FALSE);
	SetSpringForBone(PawnOwner.LeftHandBoneName, FALSE);
	SetSpringForBone(PawnOwner.LeftFootBoneName, FALSE);
	SetSpringForBone(PawnOwner.RightFootBoneName, FALSE);

	Super.DeathAnimRagDoll();

	PawnOwner.EndSpecialMove();
}

/** Notification forwarded from RB_BodyInstance, when a spring is over extended and disabled. */
function OnRigidBodySpringOverextension(RB_BodyInstance BodyInstance)
{
	local Name				PelvisBoneName;
	local RB_BodyInstance	PelvisBodyInstance;

	// Make sure we have correct bone name if this is a socket.
	PelvisBoneName = PawnOwner.Mesh.GetSocketBoneName(PawnOwner.PelvisBoneName);
	PelvisBodyInstance = PawnOwner.Mesh.FindBodyInstanceNamed(PelvisBoneName);

	// If Pelvis spring was broken, we can't keep the other limbs (hands & legs) under spring influence, it would look too bad.
	// So we just turn them off and force the Pawn into rag doll.
	if( PelvisBodyInstance == BodyInstance )
	{
		DeathAnimRagDoll();
	}
}

defaultproperties
{
	BS_FrontHit=(Stance=((Slot=BS_FullBody,AnimName="Death_Gut_001")))
	BS_BackHit=(Stance=((Slot=BS_FullBody,AnimName="Death_Back_001")))
}