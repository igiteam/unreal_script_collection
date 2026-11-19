
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Brumak_RtGunHit extends GSM_Brumak_BasePlaySingleAnim;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearAI_Brumak	BrumakAI;

	Super.SpecialMoveStarted( bForced, PrevMove );

	// Clear Targets, abort attack
	if( Brumak != None )
	{
		Brumak.SetSideGunAimTarget(None, FALSE);
		Brumak.SetSideGunAimTarget(None, TRUE);
		Brumak.SetMainGunAimTarget(None);
	}

	BrumakAI = GearAI_Brumak(PawnOwner.Controller);
	if( BrumakAI != None )
	{
		if( BrumakAI.LeftGunAI  != None ) { BrumakAI.LeftGunAI.GotoState( 'Silent' );	 }
		if( BrumakAI.RightGunAI != None ) { BrumakAI.RightGunAI.GotoState( 'Silent' ); }
		if( BrumakAI.DriverAI   != None ) { BrumakAI.DriverAI.GotoState( 'Silent' );	 }	

		BrumakAI.GotoState('Action_Brumak_Hold', 'Delay');
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearAI_Brumak	BrumakAI;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	BrumakAI = GearAI_Brumak(PawnOwner.Controller);
	if( BrumakAI != None )
	{
		if( BrumakAI.LeftGunAI  != None ) { BrumakAI.LeftGunAI.GotoState( 'Auto' );	}
		if( BrumakAI.RightGunAI != None ) { BrumakAI.RightGunAI.GotoState( 'Auto' );	}
		if( BrumakAI.DriverAI   != None ) { BrumakAI.DriverAI.GotoState( 'Auto' );	}
	}
}

defaultproperties
{
	bLockPawnRotation=TRUE

	BS_Animation=(Stance=((Slot=BS_Std_Up,AnimName="right_gun_hit"),(Slot=BS_Std_Idle_Lower,AnimName="right_gun_hit")))
	BlendInTime=0.33f
	BlendOutTime=0.67f

	NearbyPlayerSynchedCameraAnimName="Rt_Arm_Damage_Brumak"
}