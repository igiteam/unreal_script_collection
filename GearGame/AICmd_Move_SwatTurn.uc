/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Move_SwatTurn extends AICommand_SpecialMove
	within GearAI_Cover;

/** GoW global macros */

/** Start and End markers for the swat turn */
var CoverInfo		StartInfo, EndInfo;
var byte Direction;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool SwatTurn( GearAI_Cover AI, CoverLink inLink, INT Start, INT End, INT Dir )
{
	local AICmd_Move_SwatTurn Cmd;
	
	if( AI != None && inLink != None )
	{
		Cmd = new(AI) class'AICmd_Move_SwatTurn';
		if( Cmd != None )
		{
			Cmd.StartInfo.Link		= inLink;
			Cmd.StartInfo.SlotIdx	= Start;
			Cmd.EndInfo.Link		= inLink;
			Cmd.EndInfo.SlotIdx		= Start;
			Cmd.Direction			= Dir;

			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@StartInfo.Link@"Start:"@StartInfo.SlotIdx@"End:"@EndInfo.SlotIdx;
}

/** Should the AI run to cover before performing the turn? */
final private function bool ShouldRun2Cover()
{
	if( CoverOwner == None )
	{
		return FALSE;
	}

	//debug
	`AILog( GetFuncName()@AIOwner@MyGearPawn.CoverType@MyGearPawn.CurrentLink@StartInfo.Link@MyGearPawn.Anchor );

	return (MyGearPawn.CoverType == CT_None || MyGearPawn.CurrentLink != StartInfo.Link);
}

final private function bool ShouldChangeMirrorDirection()
{
	//debug
	`AILog( GetFuncName()@Direction@MyGearPawn.bIsMirrored@MyGearPawn.bWantsToBeMirrored );

	if( (Direction == CD_Right &&  AIOwner.MyGearPawn.bIsMirrored) ||
		(Direction == CD_Left  && !AIOwner.MyGearPawn.bIsMirrored) )
	{
		return TRUE;
	}

	return FALSE;
}


function Pushed()
{
	Super.Pushed();

	// If AI should slide into cover
	if( ShouldRun2Cover() )
	{
		//debug
		`AILog("Running to cover before mantling"@StartInfo.Link@StartInfo.SlotIdx);

		// Do run2cover first
		class'AICmd_Move_Run2Cover'.static.Run2Cover( CoverOwner, StartInfo, StartInfo.Link.GetSlotLocation(StartInfo.SlotIdx) );
	}
	else
	if( ShouldChangeMirrorDirection() )
	{
		//debug
		`AILog( "Update mirror direction first" );

		GotoState( 'ChangeMirrorDirection' );
	}
	else
	{
		// Otherwise, go right into the turn
		GotoState( 'Command_SpecialMove' );
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// Resumed swatturn command after sliding into cover
	// If successfully got into cover
	if( ChildStatus == 'Success' )
	{
		if( ShouldChangeMirrorDirection() )
		{
			//debug
			`AILog( "Update mirror direction first" );

			GotoState( 'ChangeMirrorDirection' );
		}
		else
		{
			// Do the turn
			GotoState( 'Command_SpecialMove' );
		}
	}
	else
	{
		// Otherwise, failure :(
		Status = 'Failure';
		PopCommand( self );
	}
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_StdLvlSwatTurn;
	}
}

defaultproperties
{
	bShouldCheckSpecialMove=true
}
