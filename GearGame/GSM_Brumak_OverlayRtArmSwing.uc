
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Brumak_OverlayRtArmSwing extends GSM_Brumak_OverlayLftArmSwing;

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
	BS_Animation=(Stance=((Slot=BS_Additive,AnimName="Upper_Arm_Swing_Rt")))
	BlendInTime=0.25f
	BlendOutTime=0.45f

	NearbyPlayerSynchedCameraAnimName="Right_Arm_Swing_Upperbody"
	NearbyPlayerSynchedCameraAnimRadius=(X=1280,Y=2560)
}
