/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_MoveToCover extends AICommand
	within TGAI_Cover;

/** GoW global macros */

/** Cover we are attempting to move to */
var CoverInfo		CoverGoal;
/** Slot marker for the cover goal */
var CoverSlotMarker	SlotMarker;
/** Current RouteCache for controller is valid, no need to path find again */
var bool			bValidRouteCache;

/** whether this is a non-interruptable (scripted) move */
var bool			bInterruptable;

var bool			bClearMoveActionOnFailure;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToCover( TGAI AI, CoverInfo NewCoverGoal, optional bool bIsValidCache, optional bool bInInterruptable=TRUE, optional bool bInClearmoveActionOnFailure=FALSE)
{
    local AICmd_MoveToCover Cmd;
	local TGAI_Cover		CoverAI;

	CoverAI = TGAI_Cover(AI);
	if( CoverAI != None &&
		NewCoverGoal.Link != None &&
		NewCoverGoal.SlotIdx >= 0 )
	{
		Cmd = new(CoverAI) class'AICmd_MoveToCover';
		if( Cmd != None )
		{
			Cmd.CoverGoal		 = NewCoverGoal;
			Cmd.SlotMarker		 = NewCoverGoal.Link.Slots[NewCoverGoal.SlotIdx].SlotMarker;
			Cmd.bValidRouteCache = bIsValidCache;
			Cmd.bInterruptable   = bInInterruptable;
			Cmd.bClearMoveActionOnFailure = bInClearMoveActionOnFailure;
			CoverAI.PushCommand( Cmd );
			return TRUE;
		}
	}
    return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Cover:"@CoverGoal.Link$"/"$CoverGoal.SlotIdx@"Marker:"@SlotMarker;
}

function Pushed()
{
	Super.Pushed();

	if( CoverGoal != Cover )
	{
		ClaimCover( CoverGoal );
	}

	DoMove();
}

function DoMove()
{
	// Set all move goal flags
	bReachedMoveGoal = FALSE;
	SetAcquireCover( ACT_None );

	//debug
	;


	if( !HasValidCover() )
	{
		//debug
		;

		GotoState( 'DelayFailure' );
	}
	else
	if( IsAtCover() )
	{
		//debug
		;
		// make sure CoverGoal is still correct
		Outer.CoverGoal = CoverGoal;

		GotoState( 'DelaySuccess' );
	}
	else
	{
		LastChangeCoverTime = WorldInfo.TimeSeconds;

		// Set flag that says we are moving to cover
		bMovingToCover	 = TRUE;
		Outer.CoverGoal = CoverGoal;

		if( MyTGPawn != None && MyTGPawn.bCanRoadieRun )
		{
			if( (Enemy == None && FRand() > 0.5f) ||
				(Enemy != None && FRand() > 0.8f) )
			{
				bShouldRoadieRun = TRUE;
			}
		}

		//debug
		;

		// Move to the slot marker
		// If already moving to tether, go right to goal
		if( bMovingToTether )
		{
			SetMoveGoal( SlotMarker,, bInterruptable,, bValidRouteCache );
		}
		else
		{
			// Otherwise, set tether and give AI a chance to move using cover
			SetTether( SlotMarker, FMin(VSize2D(SlotMarker.Location - Pawn.Location) - 1.0, Pawn.GetCollisionRadius()),,, bInterruptable, bValidRouteCache );
		}
	}
}

function Popped()
{
	Super.Popped();

	// No longer moving to cover
	bMovingToCover = FALSE;

	// Assume that we should be alert temporarily if we've moved to cover
	TimeLastHadContactWithEnemy = WorldInfo.TimeSeconds - 10.f;

	// Set time we successfully entered cover
	if( Status == 'Success' )
	{
		EnterCoverTime = WorldInfo.TimeSeconds;
	}
	else
	{
		UnClaimCover();
		ClearCoverGoal();
	}
}

function bool NeedMirror()
{
	local array<ECoverAction> Actions;
	local int i;
	CoverGoal.Link.GetSlotActions(CoverGoal.SlotIdx, Actions);

	for (i = 0; i < Actions.Length; ++ i)
	{
		switch (Actions[i])
		{
		case CA_PeekRight:
		case CA_BlindRight:
		case CA_LeanRight:
			return false;
		}
	}

	return true;
}

function Resumed( Name OldCommandName )
{
	local int IdxDelta;

	Super.Resumed( OldCommandName );

	// make sure pawn can still take cover
	if (MyTGPawn == None || MyTGPawn.IsAKidnapper() || MyTGPawn.IsDBNO())
	{
		;
		Status = 'Failure';
		if (bClearMoveActionOnFailure)
		{
			ClearMoveAction();
		}
		PopCommand(self);
	}
	// if this is dynamic cover and it's moved since we started the command then try again
	//`Log(GetFUncName()@MyTGPawn@ChildStatus@CoverGoal.Link.bDynamicCover@Pawn.ReachedDestination(SlotMarker));
	else if (ChildStatus == 'Success' && CoverGoal.Link.bDynamicCover && !Pawn.ReachedDestination( SlotMarker ))
	{
		;
		DoMove();
	}
	// see if we made it to the cover and are able to enter it
	// reclaim cover if necessary (and able) in case it was invalidated but it's valid now
	else if (ChildStatus == 'Success' && (Cover.Link != None || ClaimCover(CoverGoal)) && SetCoverType())
	{

		//debug
		;

		//DrawDebugCoordinateSystem(SlotMarker.Location,rot(0,0,0),100.f,TRUE);
		//DrawDebugLine(SlotMarker.Location,SlotMarker.OwningSlot.Link.GetSlotLocation(SlotMarker.OwningSlot.SlotIdx),255,0,0,TRUE);

		if(SlotMarker.OwningSlot.Link.Slots[SlotMarker.OwningSlot.SlotIdx].SlotOwner != MyTGPawn && !SlotMarker.OwningSlot.Link.Claim(MyTGPawn,SlotMarker.OwningSlot.SlotIdx))
		{
			;
			AbortCommand(self);
			NotifyCoverDisabled(CoverGoal.Link,SlotMarker.OwningSlot.SlotIdx);
			return;
		}

		// Once slot reached, force the anchor and link info
		Pawn.SetAnchor( SlotMarker );

		MyTGPawn.CurrentLink	  = SlotMarker.OwningSlot.Link;
		MyTGPawn.CurrentSlotIdx = SlotMarker.OwningSlot.SlotIdx;

		IdxDelta = MyTGPawn.CurrentSlotIdx - CoverGoal.SlotIdx;
		//`log("Movetocover just finished slotmarker:"@SlotMarker@SlotMarker.OwningSlot.SlotIdx@SlotMarker.OwningSlot.Link.Slots[SlotMarker.OwningSlot.SlotIdx].SlotOwner@WorldInfo.TimeSeconds@MyTGPawn.LeftSlotIdx@MyTGPawn.RightSlotIdx@"Delta"@IdxDelta);


		MyTGPawn.LeftSlotIdx = Clamp(MyTGPawn.LeftSlotIdx+IdxDelta,0,MyTGPawn.CurrentLink.Slots.length-1);
		MyTGPawn.RightSlotIdx = Clamp(MyTGPawn.RightSlotIdx+IdxDelta,0,MyTGPawn.CurrentLink.Slots.length-1);

		// Set flags for reaching cover
		NotifyReachedCover();


		if (NeedMirror())
			MyTGPawn.SetMirroredSide(TRUE);

		Status = 'Success';
		PopCommand( self );
	}
	else
	{
		Status = 'Failure';
		if(bClearMoveActionOnFailure)
		{
			ClearMoveAction();
		}
		PopCommand( self );
	}
}

/** ignore Resumed() logic if our outcome has already been determined */
state DelaySuccess
{
	function Resumed(name OldCommandName)
	{
		Super(AICommand).Resumed(OldCommandName);
	}
}
state DelayFailure
{
	function Resumed(name OldCommandName)
	{
		Super(AICommand).Resumed(OldCommandName);
	}
}


