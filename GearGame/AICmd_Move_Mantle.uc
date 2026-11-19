/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Move_Mantle extends AICommand_SpecialMove
	within GearAI;

/** Direction to mantle... 1 == climb up, 0 == mantle over, -1 == jump down */
var int MantleDirection;
/** Position to run to when starting the mantle */
var Vector MantleStart;
/** Landing position of the mantle */
var Vector MantleDest;
/** Slot to claim */
var CoverInfo	SlotInfo;

var bool bUsingRun2Cover;

var bool bFailedSpecialMove;

static function bool MantleEdge( GearAI AI, int Dir, Vector MoveStart, Vector MoveDest, CoverInfo Info )
{
	local AICmd_Move_Mantle Cmd;

	if( AI != None && AI.MyGearPawn != None && !AI.MyGearPawn.IsAKidnapper() && ( Info.Link != None || Dir < 0 ) )
	{
		Cmd = new(AI) class'AICmd_Move_Mantle';
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

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Start:"@MantleStart@"Dest:"@MantleDest@"Dir"@MantleDirection;
}

/** Should the AI run to cover before performing the mantle? */
final private function bool ShouldRun2Cover()
{
	if( CoverOwner == None || SlotInfo.Link == None )
	{
		return FALSE;
	}

	//debug
	`AILog( GetFuncName()@AIOwner@MyGearPawn.CoverType@MyGearPawn.CurrentLink@SlotInfo.Link );

	return (MyGearPawn.CoverType == CT_None || MyGearPawn.CurrentLink != SlotInfo.Link);
}

function Pushed()
{
	Super.Pushed();

	// If AI should slide into cover
	if( ShouldRun2Cover() )
	{
		//debug
		`AILog("Running to cover before mantling"@SlotInfo.Link@SlotInfo.SlotIdx);

		bUsingRun2Cover = TRUE;
		// Do run2cover first
		class'AICmd_Move_Run2Cover'.static.Run2Cover( CoverOwner, SlotInfo, MantleStart );
	}
	else
	{
		// Otherwise, go right into the mantle
		GotoState( 'Command_SpecialMove' );
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// Resumed mantle command after sliding into cover
	// If successfully got into cover
	if( ChildStatus == 'Success' && ! bFailedSpecialMove)
	{
		// Do the mantle
		GotoState( 'Command_SpecialMove' );
	}
	else if( ! bFailedSpecialMove && bUsingRun2Cover && SlotInfo.Link != None && CoverOwner != None && SlotInfo.Link.IsValidClaim(MyGearPawn,SlotInfo.SlotIdx)  )
	{
		// if we tried run2cover and it didn't work, walk there
		bUsingRun2Cover = FALSE;
		CoverOwner.SetCoverGoal( SlotInfo, FALSE );
	}
	else
	{
		//otherwise, failure :(
		Status = 'Failure';
		PopCommand( self );
	}
}


state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		// Face mantle target slot
		//DrawDebugLine(Pawn.Location, MantleDest, 255,255,0,TRUE);
		//DrawDebugCoordinateSystem(MantleDest,rot(0,0,0),25.f,TRUE);

	    // FIRST YE MUST LOCK THE ROTATION WITH THY HOLY FALSE GRENADE 'FORE THy DESIRED ROTATION WILL WORK
		SetDesiredRotation(rotator(MantleDest-Pawn.Location), TRUE, FALSE);
		bIgnoreNotifies = TRUE; // don't interrupt mantles, we might get stuck!
	}

	function bool IsReady() 
	{ 
		if( !Pawn.ReachedDesiredRotation() )
		{
			`log(Pawn.WorldInfo.TimeSeconds @ GetFuncName() @ "Waiting for Desired Rotation...");
			return FALSE;
		}

		// Make sure rotation is locked.
		Pawn.LockDesiredRotation(TRUE, FALSE);
		return TRUE; 
	}

	function EndState(Name NextStateName)
	{
		Pawn.LockDesiredRotation(FALSE, FALSE);
		Super.EndState(NextStateName);
	}

	function ESpecialMove GetSpecialMove()
	{
		// Climb Up
		if( MantleDirection > 0 )
		{
			return SM_MantleUpLowCover;
		}
		else
		// Climb Down
		if( MantleDirection < 0 )
		{
			return SM_MantleDown;
		}

		// Default mantle over
		return SM_MidLvlJumpOver;
	}

	function INT GetSpecialMoveFlags(ESpecialMove InSpecialMove)
	{
		local GearSpecialMove USpecialMove;

		if( InSpecialMove == SM_MidLvlJumpOver )
		{
			MyGearPawn.VerifySMHasBeenInstanced(InSpecialMove);
			USpecialMove = MyGearPawn.SpecialMoves[InSpecialMove];
			if( USpecialMove.IsA('GSM_MidLvlJumpOver') )
			{
				return GSM_MidLvlJumpOver(USpecialMove).PackSpecialMoveFlags();
			}
		}
		return 0;
	}

	// Make sure AI is facing the correct way
	function bool ShouldFinishRotation()	{ return TRUE; }

	function OnFailedToDoSpecialMove()
	{
		//debug
		`AILog( "Failed to do mantle special move" @ SlotInfo.Link @ SlotInfo.SlotIdx );

		bFailedSpecialMove=true;
		// disable the slot for a bit so we don't immediately try and use it again like a doofus
		SlotInfo.Link.SetInvalidUntil(SlotInfo.SlotIdx,WorldInfo.TimeSeconds+1);
	}

	function bool SetupMoveToEndDest()
	{
		// If mantling up, move to destination the edge expected us to go
		if( MantleDirection == 1 )
		{
			EndDest = MantleDest;
			return TRUE;
		}

		return FALSE;
	}
}

defaultproperties
{
	bShouldCheckSpecialMove=TRUE
	bFailedSpecialMove=FALSE
}
