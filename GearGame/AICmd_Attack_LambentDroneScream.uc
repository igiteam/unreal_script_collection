/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_LambentDroneScream extends AICommand_SpecialMove
	within GearAI_LambentDrone;

function Popped()
{
	Super.Popped();

	// Allow normal rotation again
	if( Pawn != None )
	{
		UnlockAI();
	}
}

auto state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
		Outer.StartFiring(1);
		SetDesiredRotation(Rotator(Enemy.Location - Pawn.Location));
		LockdownAI();
	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_Drudge_Scream;
	}
}

defaultproperties
{
	bAllowedToFireWeapon=true
}