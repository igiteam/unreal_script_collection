/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Move_SlotToSlot extends AICommand
	within GearAI_Cover;

/** GoW global macros */

/** Start and End slots for the adjustment in cover */
var CoverInfo StartInfo, EndInfo;

var array<int> ClaimedSlotList;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool SlotToSlot( GearAI_Cover AI, CoverLink inLink, int Start, int End )
{
	local AICmd_Move_SlotToSlot Cmd;

	if( AI != None && inLink != None && (inLink == AI.Cover.Link || inLink == AI.MyGearPawn.CurrentLink) && Start != End )
	{
		if( inLink.IsValidClaimBetween( AI.Pawn, Start, End ) )
		{
			Cmd = new(AI) class'AICmd_Move_SlotToSlot';
			if( Cmd != None )
			{
				Cmd.StartInfo.Link		= inLink;
				Cmd.StartInfo.SlotIdx	= Start;
				Cmd.EndInfo.Link		= inLink;
				Cmd.EndInfo.SlotIdx		= End;
			
				AI.PushCommand( Cmd );
				return TRUE;
			}
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@StartInfo.Link@"Start:"@StartInfo.SlotIdx@"End:"@EndInfo.SlotIdx;
}

function Pushed()
{
	Super.Pushed();

	if( !ClaimAllSlots() )
	{
		//debug
		`AILog( "Failed to claim all slots" );

		UnClaimAllSlots( TRUE );
		GotoState( 'DelayFailure' );
	}
	else
	{
		GotoState( 'AdjustingToSlot' );
	}
}

function Popped()
{
	Super.Popped();

	UnClaimAllSlots( !bReachedCover );
	
	if( MyGearPawn != None )
	{
		MyGearPawn.CurrentSlotDirection = CD_Default;
	}
}

function bool ClaimAllSlots()
{
	local int SlotIdx, Dir;

	ClaimCover( EndInfo );

	Dir = (StartInfo.SlotIdx < EndInfo.SlotIdx) ? 1 : -1;
	SlotIdx = StartInfo.SlotIdx + Dir;
	while( SlotIdx != EndInfo.SlotIdx )
	{
		if( !MyGearPawn.ClaimCover( StartInfo.Link, SlotIdx ) )
		{
			//debug
			`AILog( "Failed to claim cover"@StartInfo.Link@SlotIdx );

			return FALSE;
		}
		ClaimedSlotList[ClaimedSlotList.Length] = SlotIdx;
		
		SlotIdx += Dir;
	}

	return TRUE;
}

function UnClaimAllSlots( optional bool bIncludeLast )
{
	local int Idx;

	//debug
	`AILog( GetFuncName()@`showvar(bIncludeLast) );

	if( bIncludeLast )
	{
		UnClaimCover();
	}
	else
	{
		for( Idx = 0; Idx < ClaimedSlotList.Length; Idx++ )
		{
			if( bIncludeLast || ClaimedSlotList[Idx] != EndInfo.SlotIdx )
			{
				MyGearPawn.UnClaimCover( StartInfo.Link, ClaimedSlotList[Idx], FALSE );
			}
		}
	}
}

state AdjustingToSlot
{
	function SetupCoverInfo()
	{
		local CovPosInfo	CoverPosInfo;

		// if the indices are the 
		if(MyGearpawn.LeftSlotIdx == MyGearPawn.RightSlotidx)
		{
			CoverPosInfo = MyGearPawn.CoverInfoToCovPosInfo(StartInfo);

			if(StartInfo.SlotIdx < EndInfo.SlotIdx)
			{
				CoverPosInfo.LtToRtPct = 0;
				CoverPosInfo.LtSlotIdx = StartInfo.SlotIdx;
				CoverPosInfo.RtSlotIdx = EndInfo.SlotIdx;
			}
			else
			{
				CoverPosInfo.LtToRtPct = 1;
				CoverPosInfo.LtSlotIdx = EndInfo.SlotIdx;
				CoverPosInfo.RtSlotIdx = StartInfo.SlotIdx;
			}
			`AILog(GetFuncName()@"WARNING! Adjusting cover indices because we're trying to slot-to-slot and both left and right indices are the same!"@CoverPosInfo.LtSlotIdx@CoverPosInfo.RtSlotIdx@CoverPosInfo.LtToRtPct);

			MyGearPawn.CoverAcquired( CoverPosInfo );
		}

		ResetCoverAction();
	}
Begin:
	//debug
	`AILog( "Adjust to slot..."@StartInfo.Link.GetDebugString(StartInfo.SlotIdx)@EndInfo.Link.GetDebugString(EndInfo.SlotIdx), 'Move' );

	SetupCoverInfo();
	// Latent adjust to cover - will return when pawn reaches given slot or move times out
	AdjustToSlot( EndInfo );

	// Reached the target slot successfully
	if( bReachedCover )
	{
		// Set the current cover info
		MyGearPawn.CurrentLink	  = EndInfo.Link;
		MyGearPawn.CurrentSlotIdx = EndInfo.SlotIdx;

		// Return success
		Status = 'Success';
		PopCommand( self );
	}
	else
	{
		// Otherwise, failed to reach the target slot
		Status = 'Failure';
		PopCommand( self );
	}
}

defaultproperties
{
}