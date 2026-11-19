/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Brumak_Move_Mantle extends AICommand
	within GearAI;

var Vector MantleStart;
/** Landing position of the mantle */
var Vector MantleDest;
/** Slot to claim */
var CoverInfo	SlotInfo;

var int NumAttempts;

static function bool MantleEdge( GearAI AI, Vector MoveStart, Vector MoveDest, CoverInfo Info )
{
	local AICmd_Brumak_Move_Mantle Cmd;

	if( AI != None && AI.MyGearPawn != None && !AI.MyGearPawn.IsAKidnapper() && Info.Link != None )
	{
		Cmd = new(AI) class'AICmd_Brumak_Move_Mantle';
		Cmd.MantleStart		= MoveStart;
		Cmd.MantleDest		= MoveDest;
		Cmd.SlotInfo		= Info;

		AI.PushCommand( Cmd );
		return TRUE;
	}

	return FALSE;
}
function Pushed()
{
	Super.Pushed();


	GotoState( 'WalkOverMantle' );
}


state WalkOverMantle
{
Begin:
	while(!Pawn.ReachedPoint(MantleDest,none))
	{
		if(++NumAttempts >= 5)
		{
			`AILog("Failed to reach mantle destination");
			AbortCommand(self);
		}
		else
		{
			MoveToDirectNonPathPos(MantleDest);
		}
	}

	Status='Success';
	PopCommand(Self);
}

defaultproperties
{
}
