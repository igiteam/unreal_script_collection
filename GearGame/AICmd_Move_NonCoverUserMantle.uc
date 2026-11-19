/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Move_NonCoverUserMantle extends AICmd_Move_Mantle
	within GearAI;

static function bool MantleEdge( GearAI AI, int Dir, Vector MoveStart, Vector MoveDest, CoverInfo Info )
{
	local AICmd_Move_NonCoverUserMantle Cmd;

	if( AI != None && AI.MyGearPawn != None && !AI.MyGearPawn.IsAKidnapper() && ( Info.Link != None || Dir < 0 ) )
	{
		Cmd = new(AI) class'AICmd_Move_NonCoverUserMantle';
		Cmd.MantleDirection = Dir;
		Cmd.MantleStart		= MoveStart;
		Cmd.MantleDest		= MoveDest;
		Cmd.SlotInfo		= Info;

// 		AI.DrawDebugLine(MoveStart,MoveDest,255,0,0,TRUE);
// 		AI.DrawDebugCoordinateSystem(MoveStart,rot(0,0,0),25.0,TRUE);		

		AI.PushCommand( Cmd );
		return TRUE;
	}
	else
	{
		`AILog_Ext("MANTLE FAIL! - "@`showvar(AI.MyGearPawn)@`showvar(AI.MyGearPawn.IsAKidnapper())@`showvar(Info.Link),,AI);
	}

	return FALSE;
}

defaultproperties
{
	// Small because it looks bad for some creatures (like Lambent Human)
	// to stand near a failed mantle start for a while
	FailureSleepTimeSeconds=0.05f
}
