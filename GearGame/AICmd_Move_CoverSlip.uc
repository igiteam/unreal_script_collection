/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Move_CoverSlip extends AICommand_SpecialMove
	within GearAI_Cover;

/** Direction to slip... 1 == right, -1 == left */
var int SlipDirection;
/** Position to run to when starting the slip */
var Vector SlipStart;
/** Landing position of the slip */
var Vector SlipDest;
/** Slot to claim */
var CoverInfo SlotInfo;

/** used in FakeCoverSlip code */
var vector SidewaysDest;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool CoverSlipEdge( GearAI_Cover AI, int Dir, Vector MoveStart, Vector MoveEnd, CoverInfo Info )
{
	local AICmd_Move_CoverSlip Cmd;

	if( AI != None && AI.MyGearPawn != None && !AI.MyGearPawn.IsAKidnapper() && Info.Link != None )
	{
		Cmd = new(AI) class'AICmd_Move_CoverSlip';
		if( Cmd != None )
		{
			Cmd.SlipStart		= MoveStart;
			Cmd.SlipDest		= MoveEnd;
			Cmd.SlipDirection	= Dir;
			Cmd.SlotInfo		= Info;

			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Start:"@SlipStart@"End:"@SlipDest@"Dir:"@SlipDirection;
}

/** Should the AI run to cover before performing the slip? */
final private function bool ShouldRun2Cover()
{
	if( CoverOwner == None )
	{
		return FALSE;
	}

	//debug
	`AILog( GetFuncName()@AIOwner@MyGearPawn.CoverType@MyGearPawn.CurrentLink@SlotInfo.Link );

	return (MyGearPawn.CoverType == CT_None || MyGearPawn.CurrentLink != SlotInfo.Link);
}

final private function bool ShouldChangeMirrorDirection()
{
	//debug
	`AILog( GetFuncName()@SlipDirection@MyGearPawn.bIsMirrored@MyGearPawn.bWantsToBeMirrored );

	if( (SlipDirection > 0 &&  MyGearPawn.bIsMirrored) ||
		(SlipDirection < 0 && !MyGearPawn.bIsMirrored) )
	{
		return TRUE;
	}

	return FALSE;
}

/** checks if AI isn't in the correct slot to do the cover slip */
final private function bool ShouldAdjustToSlot()
{
	return (MyGearPawn != None && 
			MyGearPawn.CurrentLink != None && 
			(MyGearPawn.bIsMirrored ? 
				!MyGearPawn.CurrentLink.IsLeftEdgeSlot(MyGearPawn.CurrentSlotIdx, TRUE) : 
				!MyGearPawn.CurrentLink.IsRightEdgeSlot(MyGearPawn.CurrentSlotIdx, TRUE)));
}

function Fail()
{
	`AILog("Failing from coverslip");
	ResetCoverType();
	GotoState('SlipFailed');
	ForcePauseAndRepath(outer);
}

function Pushed()
{
	Super.Pushed();

	// if we don't support the special move or can't execute it, simulate through normal movement
	if (!bCanUseCoverSlipMove || !MyGearPawn.IsInCover() || !MyGearPawn.bCanCoverSlip || MyGearPawn.IsCarryingAHeavyWeapon())
	{
		`AILog("Entered coverslip, but we can't coverslip! bailing from coverslip command"@`showvar(bCanUseCoverSlipMove)@`showvar(MyGearPawn.IsInCover())@`showvar(MyGearpawn.bCanCoverSlip)@`showvar(MyGearpawn.IsCarryingAHeavyWeapon()));
		Fail();
	}
	// If AI should slide into cover
	else if( ShouldRun2Cover() )
	{
		//debug
		`AILog("FAILING from coverslip because we should not have to run2cover when we enter a coverslip");

		Fail();
	}
	else if( ShouldChangeMirrorDirection() )
	{
		//debug
		`AILog( "Update mirror direction first" );

		GotoState( 'ChangeMirrorDirection' );
	}
	else if( ShouldAdjustToSlot() )
	{
		`AILog("Not in correct slot, adjusting");
		GotoState('AdjustToCorrectSlot');
	}
	else
	{
		// Otherwise, go right into the slip
		GotoState( 'Command_SpecialMove' );
	}
}

function Popped()
{
	Super.Popped();

	if (MyGearPawn != None)
	{
		MyGearPawn.CurrentSlotDirection = CD_Default;
		MyGearPawn.Velocity = vect(0,0,0);
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// Resumed slip command after sliding into cover
	// If successfully got into cover
	if( ChildStatus == 'Success' )
	{
		if( ShouldChangeMirrorDirection() )
		{
			//debug
			`AILog( "Update mirror direction first" );

			GotoState( 'ChangeMirrorDirection' );
		}
		else if (ShouldAdjustToSlot())
		{
			`AILog("Not in correct slot, adjusting");
			GotoState('AdjustToCorrectSlot');
		}
		else
		{
			// Do the slip
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
	function BeginState(Name PrevStateName)
	{
		Super.BeginState(PrevStateName);

		// remove the coverslip edge from the cache so we move on
		NavigationHandle.PathCache_RemoveIndex(0,1);
	}

	function ESpecialMove GetSpecialMove()
	{
		return SM_CoverSlip;
	}
}

state ChangeMirrorDirection
{
	function FinishedMirroringChange()
	{
		if (ShouldAdjustToSlot())
		{
			`AILog("Not in correct slot, adjusting");
			GotoState('AdjustToCorrectSlot');
		}
		else
		{
			// Do the slip
			GotoState( 'Command_SpecialMove' );
		}
	}
}

state AdjustToCorrectSlot
{
Begin:
	if( !class'AICmd_Move_SlotToSlot'.static.SlotToSlot( outer, MyGearPawn.CurrentLink, MyGearPawn.CurrentSlotIdx, SlotInfo.SlotIdx ) )
	{
		Fail();
	}
	else
	{
		`AILog("Finished adjusting");
		GotoState('Command_SpecialMove');
	}

}

state SlipFailed `DEBUGSTATE
{
	function Resumed( Name OldCommandName )
	{
		// mark as success so we just path again instead of aborting the whole move
		Status = 'Success';
		PopCommand(self);
	}

Begin:
	Sleep(0.25);
	Status = 'Success';
	PopCommand(self);
}

	

defaultproperties
{
	bShouldCheckSpecialMove=true
	bAllowedToFireWeapon=true
}
