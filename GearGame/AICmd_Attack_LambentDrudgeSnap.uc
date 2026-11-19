/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_LambentDrudgeSnap extends AICommand_SpecialMove
	within GearAI_LambentDrudge;

function Pushed()
{
	Super.Pushed();

	// Make sure we have ammo, since it doesn't make sense to reload a spit attack
	GearWeapon(Pawn.Weapon).AmmoUsedCount = 0;

	bWantsLedgeCheck = TRUE;
	GotoState( 'Command_SpecialMove' );
}

function Popped()
{
	Super.Popped();
	bWantsLedgeCheck = FALSE;

	// Allow normal rotation again
	if( Pawn != None )
	{
		UnlockAI();
	}
}

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		SetDesiredRotation(Rotator(Enemy.Location - Pawn.Location));

		Pawn.ZeroMovementVariables();
	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_Drudge_SnapAttack;
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
	bAllowedToFireWeapon=true
}