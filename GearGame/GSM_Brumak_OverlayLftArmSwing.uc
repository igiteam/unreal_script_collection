
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Brumak_OverlayLftArmSwing extends GSM_Brumak_MeleeAttack;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	GearPawn_LocustBrumakBase(PawnOwner).bDisableSideGunAimControllers=TRUE;
	

	Super.SpecialMoveStarted( bForced, PrevMove );
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	GearPawn_LocustBrumakBase(PawnOwner).bDisableSideGunAimControllers=FALSE;


	Super.SpecialMoveEnded(PrevMove,NextMove);
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_Additive,AnimName="Upper_Arm_Swing_Lft")))
	BlendInTime=0.33f
	BlendOutTime=0.67f

	NearbyPlayerSynchedCameraAnimName="Left_Arm_Swing_Upperbody"
	NearbyPlayerSynchedCameraAnimRadius=(X=1280,Y=2560)

	bCheckForGlobalInterrupts=FALSE

	bLockPawnRotation=FALSE
	bDisablePhysics=FALSE
	bDisableMovement=FALSE
}