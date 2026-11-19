
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Brumak_Roar extends GSM_Brumak_OverlayBite;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	if( Brumak != None )
	{
		Brumak.SetTimer( 0.25f, TRUE, nameof(Brumak.NotifyBrumakRoar) );
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);
	
	if( Brumak != None )
	{
		Brumak.ClearTimer( 'NotifyBrumakRoar' );
	}
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="roar")))
	BlendInTime=0.45f
	BlendOutTime=0.67f

	NearbyPlayerSynchedCameraAnimName="Roar_Brumak"
	NearbyPlayerSynchedCameraAnimScale=2.f
	NearbyPlayerSynchedCameraAnimRadius=(X=1280,Y=5120)

	bCheckForGlobalInterrupts=TRUE
	bLockPawnRotation=TRUE
}