/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Move_PrepareMantle extends AICommand
	within GearAI;

/** Destination offset to use in MoveTo call */
var float DestinationOffset;
/** Direction to mantle... 1 == climb up, 0 == mantle over, -1 == jump down */
var int MantleDirection;
/** Position to run to when starting the mantle */
var Vector MantleStart;
/** Landing position of the mantle */
var Vector MantleDest;
/** Slot to claim */
var CoverInfo	SlotInfo;

static function bool PrepareMantle( GearAI AI, float DestOffset, int Dir, Vector MoveStart, Vector MoveDest, CoverInfo Info )
{
	local AICmd_Move_PrepareMantle Cmd;

	if( AI != None && AI.MyGearPawn != None && Info.Link != None )
	{
		Cmd = new(AI) class'AICmd_Move_PrepareMantle';
		Cmd.DestinationOffset   = DestOffset;
		Cmd.MantleDirection     = Dir;
		Cmd.MantleStart		    = MoveStart;
		Cmd.MantleDest		    = MoveDest;
		Cmd.SlotInfo		    = Info;

		AI.PushCommand( Cmd );
		return TRUE;
	}
	else
	{
		`AILog_Ext("MANTLE FAIL! - "@`showvar(AI.MyGearPawn)@`showvar(AI.MyGearPawn.IsAKidnapper())@`showvar(Info.Link),,AI);
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	if( MyGearPawn.HasArrivedAtMantleStart(MantleStart) )
	{
		// Go right into the mantle
		MyGearPawn.DoMantle(Outer, MantleDirection, MantleStart, MantleDest, SlotInfo);
	}
	else
	{
		`AILog("Moving closer to MantleStart before mantling"@MantleStart);
		GoToState('MovingToMantle');
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// Resumed mantle command after moving to MantleStart
	if( ChildStatus == 'Success' )
	{
		if( OldCommandName == 'AICmd_Move_Mantle' || OldCommandName == 'AICmd_Move_NonCoverUserMantle' )
		{
			Status = 'Success';
			PopCommand( self );
		}
		else
		{
			// Do the mantle
			MyGearPawn.DoMantle(Outer, MantleDirection, MantleStart, MantleDest, SlotInfo);
		}
	}
	else
	{
		//otherwise, failure :(
		Status = 'Failure';
		PopCommand( self );
	}
}

state MovingToMantle
{
Begin:
	//DrawDebugSphere(MantleStart + Normal(MantleStart - MantleDest) * DestinationOffset, IntermediatePointArrivalDist, 16.0f, 0, 0, 255, TRUE);
	MoveTo(MantleStart + Normal(MantleStart - MantleDest) * DestinationOffset,,-IntermediatePointArrivalDist);
	MyGearPawn.DoMantle(Outer, MantleDirection, MantleStart, MantleDest, SlotInfo);
};

defaultproperties
{
}
