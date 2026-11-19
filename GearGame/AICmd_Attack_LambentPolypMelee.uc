/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_LambentPolypMelee extends AICommand_SpecialMove
	within GearAI_LambentPolyp;

var Actor MeleeTarget;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Melee( GearAI_LambentPolyp AI, optional Actor InTarget )
{
	local AICmd_Attack_LambentPolypMelee Cmd;

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

	bWantsLedgeCheck = TRUE;

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
		SetMoveGoal(MeleeTarget, MeleeTarget, false, EnemyDistance_Melee,,,,false);
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// If we reached the target successfully
	if( ChildStatus == 'Success' && MeleeTarget != None )
	{	
		GotoState( 'Command_SpecialMove' );
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
		if( VSizeSq( MyGearPawn.Location - MeleeTarget.Location ) < Outer.MeleePounceRange*Outer.MeleePounceRange )
		{	
			return GSM_SwipeAttack;
		}
		else
		{
			return GSM_PounceAttack;
		}
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
	bAllowedToFireWeapon=true
}