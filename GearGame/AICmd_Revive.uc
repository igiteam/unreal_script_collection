/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Revive extends AICommand_SpecialMove
	within GearAI;

/** GoW global macros */

/** Pawn that this AI should go over and attempt to revive */
var GearPawn ReviveTarget;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Revive( GearAI AI, GearPawn NewReviveTarget )
{
	local AICmd_Revive OtherCmd, Cmd;

	if( AI != None &&
		AI.bAllowCombatTransitions &&
		NewReviveTarget != None &&
		AI.CanRevivePawn( NewReviveTarget ) )
	{
		OtherCmd = AI.FindCommandOfClass(class'AICmd_Revive');
		if (OtherCmd == None || OtherCmd.ReviveTarget != NewReviveTarget)
		{
			// if we're switching to a new revive target, abort the current command
			if(OtherCmd != none)
			{
				AI.AbortCommand(OtherCmd);
			}

			Cmd = new(AI) class'AICmd_Revive';
			if( Cmd != None )
			{
			    Cmd.ReviveTarget = NewReviveTarget;
			    AI.PushCommand(Cmd);
			    return TRUE;
			}
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Target:"@ReviveTarget;
}

/** see if we're close enough to start the special move; if not, moves toward the target */
final function PerformNextAction()
{
	if (VSize(ReviveTarget.Location - Pawn.Location) < class'GSM_ReviveTeammate'.default.ReviveSearchRadius + ReviveTarget.GetCollisionRadius())
	{
		`Log("ALREADY IN RANGE");
		GotoState('Command_SpecialMove');
	}
	else
	{
		// Move to the target first
		SetMoveGoal(ReviveTarget,, true);
	}
}

function Pushed()
{
	Super.Pushed();

	//debug
	`AILog("... ReviveTarget" @ ReviveTarget);

	PerformNextAction();
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// If we reached the target successfully
	// and the target can still be revived
	if (ChildStatus == 'Success' && ReviveTarget != None && CanRevivePawn(ReviveTarget))
	{
		// leave Silverback at this point
		if (GearPawn_SilverbackBase(MyGearPawn) != None)
		{
			GearPawn_SilverbackBase(MyGearPawn).DriverLeave(false);
			// might need to move again depending on exit loc
			PerformNextAction();
		}
		// Revive them
		GotoState('Command_SpecialMove');
	}
	else
	{
		// Otherwise, didn't get there so fail the command
		Status = 'Failure';
		PopCommand( self );
	}
}

function bool IsAllowedToFireWeapon()
{
	// allow firing at enemies until we get close to target
	return (ChildCommand != None && MoveTarget != ReviveTarget && Super.IsAllowedToFireWeapon());
}

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		StopFiring();

		// Need to face the target
		SetDesiredRotation(Rotator(ReviveTarget.Location-Pawn.Location));
	}

	// Turn to face the target before doing the special move
	function bool ShouldFinishRotation() { return TRUE; }

	function ESpecialMove GetSpecialMove()
	{
		return SM_ReviveTeammate;
	}
}

defaultproperties
{
	bShouldCheckSpecialMove=true
	bAllowedToFireWeapon=true
}
