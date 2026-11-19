/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Ticker_LeapToPickup extends AICommand_SpecialMove
	within GearAI_NakedTicker;

/** The pickup the AI wants */
var Actor TargetPickup;
/** Flags to forward to the special move */
var int SpecialMoveFlags;

static function bool LeapToPickup(GearAI_NakedTicker AI, Actor InPickup, int InSpecialMoveFlags)
{
	local AICmd_Ticker_LeapToPickup Cmd;

	if( AI != None && InPickup != None )
	{
		Cmd = new(AI) default.Class;
		Cmd.TargetPickup = InPickup;
		Cmd.SpecialMoveFlags = InSpecialMoveFlags;
		AI.PushCommand(Cmd);
		return true;
	}
	else
	{
		return false;
	}
}

function Pushed()
{
	Super.Pushed();
	ReactionManager.SuppressAll();
}

function Popped()
{
	Super.Popped();
	ReactionManager.UnSuppressAll();
}

auto state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
		SetDesiredRotation(Rotator(TargetPickup.Location - Pawn.Location), true);
	}

	function bool ShouldFinishRotation()
	{
		return true;
	}

	function INT GetSpecialMoveFlags(ESpecialMove InSpecialMove)
	{
		return SpecialMoveFlags;
	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_Ticker_LeapToPickup;
	}
}

