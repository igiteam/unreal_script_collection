/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_LambentPolypSpit extends AICommand_SpecialMove
	within GearAI_LambentPolyp;

/** Used to update the desired rotation during the spit special move */
var transient Rotator AimRot;

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

	Outer.NextSpitTime = WorldInfo.TimeSeconds + RandRange(Outer.SpitDelayRangeMin, Outer.SpitDelayRangeMax);

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

		AimRot.Yaw = Rotator(Enemy.Location - Pawn.Location).Yaw;
		AimRot.Pitch = Pawn.Rotation.Pitch;
		AimRot.Roll = Pawn.Rotation.Roll;

		SetDesiredRotation(AimRot);

		Pawn.ZeroMovementVariables();
	}

	function Tick( float DeltaTime )
	{
		Super.Tick(DeltaTime);

		AimRot.Yaw = Rotator(Enemy.Location - Pawn.Location).Yaw;
		AimRot.Pitch = Pawn.Rotation.Pitch;
		AimRot.Roll = Pawn.Rotation.Roll;

		SetDesiredRotation(AimRot);
	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_LambentPolyp_Spit;
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
	bAllowedToFireWeapon=true
}