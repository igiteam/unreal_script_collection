/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Move_Run2Cover extends AICommand_SpecialMove
	within GearAI_Cover;

/** GoW global macros */

/** Slot AI is running to */
var CoverInfo Run2CoverInfo;
/** Spot to slide to */
var Vector			Run2Dest;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Run2Cover( GearAI_Cover AI, CoverInfo Info, Vector Dest )
{
	local AICmd_Move_Run2Cover Cmd;

	if( AI != None &&
		Info.Link != None )
	{
		Cmd = new(AI) class'AICmd_Move_Run2Cover';
		if( Cmd != None )
		{
			Cmd.Run2CoverInfo = Info;
			Cmd.Run2Dest	  = Dest;

			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"CoverInfo:"@Run2CoverInfo.Link$"/"$Run2CoverInfo.SlotIdx;
}

function Pushed()
{
	Super.Pushed();

	// don't allow interruptions!
	ReactionManager.SuppressAll();

	// Go right to doing the slide
	GotoState( 'Command_SpecialMove' );
}
function Popped()
{
	Super.Popped();

	// restore
	ReactionManager.UnSuppressAll();
}

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		// Set rotation toward the slot rotation
		SetDesiredRotation( Run2CoverInfo.Link.GetSlotRotation(Run2CoverInfo.SlotIdx));

		// stop roadie running if necessary
		if (IsRoadieRunning())
		{
			DictateSpecialMove(SM_None);
		}
	}

	function bool ShouldFinishPostRotation() { return TRUE; }

	function bool ExecuteSpecialMove()
	{
		local CovPosInfo	CoverPosInfo;

		//debug
		`AILog( GetFuncName()@Run2CoverInfo.Link@Run2CoverInfo.SlotIdx );

		if( Run2CoverInfo.Link == None )
		{
			return FALSE;
		}

		// clear the run2cover flag
		bShouldRun2Cover = FALSE;
		// note the last time we tried, so if there's an error we don't get stuck trying to run2cover
		LastRun2CoverTime = WorldInfo.TimeSeconds;

		//debug
		`AILog( "Attempting to run2cover:"@Run2CoverInfo.Link@Run2CoverInfo.SlotIdx);

		if( Run2CoverInfo.Link != None &&
			Run2CoverInfo.Link.IsValidClaim( MyGearPawn, Run2CoverInfo.SlotIdx ) )
		{
			// Acquire cover, this will take care of playing the run2cover acquisition animation
			// And triggering the special move.
			MyGearPawn.FillCoverPosInfo( Run2CoverInfo.Link, Run2CoverInfo.SlotIdx, Run2CoverInfo.Link.GetSlotIdxToRight( Run2CoverInfo.SlotIdx ), MyGearPawn.Location, Normal(Run2Dest - MyGearPawn.Location), 256.f, CoverPosInfo );
			MyGearPawn.CoverAcquired( CoverPosInfo );

			return TRUE;
		}
		else
		{
			//debug
			`AILog("- failed to run2cover, invalid slot/claim Link disabled?"@Run2CoverInfo.Link.bDisabled@"Slot enabled?"@Run2CoverInfo.Link.Slots[Run2CoverInfo.SlotIdx].bEnabled);

			return FALSE;
		}
	}

	function FinishedSpecialMove()
	{
		//debug
		`AILog( "Finished run2cover"@MyGearPawn.CurrentLink@Cover.Link@MyGearPawn.CurrentSlotIdx@Cover.SlotIdx );

		if( MyGearPawn != None &&
			MyGearPawn.CurrentLink		!= none &&
			(MyGearPawn.CurrentLink		!= Cover.Link ||
			 MyGearPawn.CurrentSlotIdx	!= Cover.SlotIdx) )
		{
			//debug
			`AILog( "Release cover claim after run2cover" );

			// Let go of the cover after sliding in if this isn't our final cover destination
			MyGearPawn.CurrentLink.Unclaim( MyGearPawn, MyGearPawn.CurrentSlotIdx, TRUE );
		}
	}
}

defaultproperties
{
}
