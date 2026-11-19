/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_LambentDrudgeSpew extends AICommand_SpecialMove
	within GearAI_LambentDrone;

var Actor MeleeTarget;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Spew( GearAI_LambentDrone AI, optional Actor InTarget )
{
	local AICmd_Attack_LambentDrudgeSpew Cmd;

	if( AI != None )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			if(InTarget != none)
			{
				Cmd.MeleeTarget = InTarget;
			}
			else
			{
				Cmd.MeleeTarget = AI.Enemy;
			}
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	local GearWeapon MyGearWeapon;

	Super.Pushed();

	// Make sure we have ammo, since it doesn't make sense to reload a spit attack
	MyGearWeapon = GearWeapon(Pawn.Weapon);
	if( MyGearWeapon != None )
	{
		MyGearWeapon.AmmoUsedCount = 0;
	}

	InvalidateCover();

	bWantsLedgeCheck = TRUE;

	SetDesiredRotation(Rotator(MeleeTarget.Location - Pawn.Location));

	// Move to the target first
	if( VSizeSq( MyGearPawn.Location - MeleeTarget.Location ) < EnemyDistance_Melee*EnemyDistance_Melee )
	{	
		GotoState( 'FaceEnemy' );
	}
	else if( MeleeTarget == Enemy )
	{
		SetEnemyMoveGoal(true, EnemyDistance_Melee,, false);
	}
	else
	{
		SetMoveGoal(MeleeTarget, MeleeTarget, false, EnemyDistance_Melee,,,,false);
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// If we reached the target successfully
	if( ChildStatus == 'Success' && MeleeTarget != None )
	{	
		GotoState( 'FaceEnemy' );
	}
	else
	{
		// Otherwise, didn't get there so fail the command
		Status = 'Failure';
		PopCommand( self );
	}
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

// SM state somehow faces to the other direction. I'm overriding it 
state FaceEnemy
{
Begin:
	SetDesiredRotation(Rotator(MeleeTarget.Location - Pawn.Location));

	while(Pawn.ReachedDesiredRotation() == FALSE)
	{
		FinishRotation();
	}

	GotoState( 'Command_SpecialMove' );
};

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		// update LastSpewTime
		LastSpewTime = WorldInfo.TimeSeconds;

		Pawn.ZeroMovementVariables();
	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_Drudge_SpewAttack;
	}

	function bool ShouldFinishRotation() { return FALSE; }
}

defaultproperties
{
	bAllowedToFireWeapon=FALSE
}

