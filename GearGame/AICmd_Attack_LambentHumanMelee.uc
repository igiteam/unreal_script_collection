/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_LambentHumanMelee extends AICommand_SpecialMove
	within GearAI_LambentHuman;

var Actor MeleeTarget;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Melee( GearAI_LambentHuman AI, optional Actor InTarget )
{
	local AICmd_Attack_LambentHumanMelee Cmd;

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
	Super.Pushed();

	bWantsLedgeCheck = true;

	// Move to the target first
	if( VSizeSq( MyGearPawn.Location - MeleeTarget.Location ) < EnemyDistance_Melee*EnemyDistance_Melee )
	{	
		GotoState( 'Command_SpecialMove' );
	}
	else if( MeleeTarget == Enemy )
	{
		SetEnemyMoveGoal(true, EnemyDistance_Melee,, false);
	}
	else
	{
		SetMoveGoal(MeleeTarget, MeleeTarget, false,,,,,false);
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// If we reached the target successfully
	if( ChildStatus == 'Success' && MeleeTarget != None )
	{	
		if( VSizeSq( MyGearPawn.Location - MeleeTarget.Location ) < (EnemyDistance_Melee*EnemyDistance_Melee*MyGearPawn.CylinderComponent.CollisionRadius*MyGearPawn.CylinderComponent.CollisionRadius) )
		{
			GotoState( 'Command_SpecialMove' );
		}
		else if( MeleeTarget == Enemy )
		{
			SetEnemyMoveGoal(true, EnemyDistance_Melee,, false);
		}
		else
		{
			SetMoveGoal(MeleeTarget, MeleeTarget, false,,,,,false);
		}
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

	bWantsLedgeCheck = false;

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

		SetDesiredRotation(Rotator(MeleeTarget.Location - Pawn.Location));
		LockdownAI();
	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_SwipeAttack;
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
	bAllowedToFireWeapon=true
}