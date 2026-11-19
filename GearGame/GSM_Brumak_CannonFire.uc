
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Brumak_CannonFire extends GSM_Brumak_BasePlaySingleAnim;

function SpecialMoveStarted( bool bForced, ESpecialMove PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	PawnOwner.ZeroMovementVariables();
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_Std_Up,AnimName="big_cannon_fire"),(Slot=BS_Std_Idle_Lower,AnimName="big_cannon_fire")))
	BlendInTime=0.45f
	BlendOutTime=0.67f

	NearbyPlayerSynchedCameraAnimName="Cannon_Fire_Brumak"

	bLockPawnRotation=TRUE
}