/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_ActivateFortification extends AICommand_SpecialMove;

var GearFortification TargetFort;

static function bool ActivateFortification(GearAI AI, GearFortification InFort)
{
	local AICmd_ActivateFortification Cmd;

	Cmd = new(AI) Default.Class;
	Cmd.TargetFort = InFort;
	AI.PushCommand(Cmd);
	return true;
}

event string GetDumpString()
{
	return Super.GetDumpString() @ "Target:" @ TargetFort;
}

function Pushed()
{
	Super.Pushed();

	// Move to the target first
	SetMoveGoal(TargetFort);
}

function Resumed(name OldCommandName)
{
	Super.Resumed(OldCommandName);

	// If we reached the target successfully
	// and the target can still be activated
	if (ChildStatus == 'Success' && TargetFort != None && TargetFort.CanBeUsedBy(Pawn))
	{
		// do it!
		GotoState('Command_SpecialMove');
	}
	else
	{
		// Otherwise, didn't get there so fail the command
		Status = 'Failure';
		PopCommand(self);
	}
}

state Command_SpecialMove
{
	function BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		// Need to face the target
		SetDesiredRotation(rotator(TargetFort.Location - Pawn.Location));
	}

	// Turn to face the target before doing the special move
	function bool ShouldFinishRotation()
	{
		return true;
	}

	function ESpecialMove GetSpecialMove()
	{
		return SM_PushButton;
	}

	function bool ExecuteSpecialMove()
	{
		TargetFort.UsedBy(Pawn);
		Super.ExecuteSpecialMove();
		return true;
	}
}

defaultproperties
{
	bAllowedToFireWeapon=true
}
