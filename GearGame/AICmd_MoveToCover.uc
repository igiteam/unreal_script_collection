/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_MoveToCover extends AICommand
	within GearAI_Cover;

/** GoW global macros */

/** Cover we are attempting to move to */
var CoverInfo		CoverGoal;
/** Current RouteCache for controller is valid, no need to path find again */
var bool			bValidRouteCache;

/** whether this is a non-interruptable (scripted) move */
var bool			bInterruptable;

var bool			bClearMoveActionOnFailure;


/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToCover( GearAI AI, CoverInfo NewCoverGoal, optional bool bIsValidCache, optional bool bInInterruptable=TRUE, optional bool bInClearmoveActionOnFailure=FALSE)
{
    local AICmd_MoveToCover Cmd;
	local GearAI_Cover		CoverAI;

	CoverAI = GearAI_Cover(AI);
	if( CoverAI != None &&
		NewCoverGoal.Link != None &&
		NewCoverGoal.SlotIdx >= 0 )
	{
		Cmd = new(CoverAI) class'AICmd_MoveToCover';
		if( Cmd != None )
		{
			Cmd.CoverGoal		 = NewCoverGoal;
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
	return Super.GetDumpString()@"Cover:"@CoverGoal.Link$"/"$CoverGoal.SlotIdx;
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
	local Vector SlotLocation;

	// Set all move goal flags
	bReachedMoveGoal = FALSE;
	SetAcquireCover( ACT_None );

	//debug
	`AILog( "DoMove..."@bReachedCover@"-"@CoverGoal.Link$"/"$CoverGoal.SlotIdx@Cover.Link$"/"$Cover.SlotIdx );


	if( !HasValidCover() )
	{
		//debug
		`AILog("WARNING: Invalid cover in"@GetFuncName()@"goal:"@CoverGoal.Link@CoverGoal.SlotIdx);

		GotoState( 'DelayFailure' );
	}
	else
	if( IsAtCover() )
	{
		//debug
		`AILog("- skipping move to cover since already at it");
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

		if( MyGearPawn != None && MyGearPawn.bCanRoadieRun )
		{
			if( (Enemy == None && FRand() > 0.5f) ||
				(Enemy != None && FRand() > 0.8f) )
			{
				bShouldRoadieRun = TRUE;
			}
		}

		//debug
		`AILog( "Moving to cover:"@CoverGoal.Link@CoverGoal.SlotIdx@"cur"@MyGearPawn.CurrentLink@MyGearPawn.CurrentSlotIdx@MyGearPawn.CoverType@bShouldRoadieRun, 'Cover' );

		// Move to the slot
		// If already moving to tether, go right to goal
		SlotLocation = CoverGoal.Link.GetSlotLocation(CoverGoal.SlotIdx);
		if( bMovingToTether )
		{
			SetMovePoint( SlotLocation,, bInterruptable,, bValidRouteCache );
		}
		else
		{
			// Otherwise, set tether and give AI a chance to move using cover
			class'AICmd_MoveToTether'.static.MoveToTether( AIOwner, SlotLocation, None, Pawn.GetCollisionRadius()*1.414f,,, bInterruptable, bValidRouteCache );
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

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// make sure pawn can still take cover
	if (MyGearPawn == None || MyGearPawn.IsAKidnapper() || MyGearPawn.IsCarryingShield() || MyGearPawn.IsDBNO() || GearWeap_HeavyCoopMGBase(MyGearPawn.Weapon) != None)
	{
		`AILog("Pawn can no longer take cover, aborting");
		Status = 'Failure';
		if (bClearMoveActionOnFailure)
		{
			ClearMoveAction();
		}
		PopCommand(self);
	}
	// if this is dynamic cover and it's moved since we started the command then try again
	//`Log(GetFUncName()@MyGearPawn@ChildStatus@CoverGoal.Link.bDynamicCover@Pawn.ReachedPoint( CoverGoal.Link.GetSlotLocation( CoverGoal.SlotIdx ), None ));
	else if( ChildStatus == 'Success' && CoverGoal.Link.bDynamicCover && !Pawn.ReachedPoint( CoverGoal.Link.GetSlotLocation( CoverGoal.SlotIdx ), None ) )
	{
		`AILog("Cover moved while we were running.. trying again!");
		DoMove();
	}
	// see if we made it to the cover and are able to enter it
	// reclaim cover if necessary (and able) in case it was invalidated but it's valid now
	else if (ChildStatus == 'Success' && (Cover.Link != None || ClaimCover(CoverGoal)) && SetCoverType())
	{
		//debug
		`AILog( "Reached slot"@CoverGoal.Link@CoverGoal.SlotIdx@Cover.Link@Cover.SlotIdx, 'Move' );

		//DrawDebugCoordinateSystem(CoverGoal.Link.GetSlotLocation( CoverGoal.SlotIdx ),rot(0,0,0),100.f,TRUE);
		if(CoverGoal.Link.Slots[CoverGoal.SlotIdx].SlotOwner != MyGearPawn && !CoverGoal.Link.Claim(MyGearPawn,CoverGoal.SlotIdx))
		{
			`AILog("got to cover but I don't have it claimed, and I can't claim it now!");
			AbortCommand(self);
			InvalidateCover();
			if (MoveAction != None && MoveAction.TetherDistance == 0)
			{
				OnAIMove(MoveAction);
			}
			else
			{
				ClearTether();
			}
			return;
		}

		MyGearPawn.CurrentLink	  = CoverGoal.Link;
		MyGearPawn.CurrentSlotIdx = CoverGoal.SlotIdx;

		//`log("Movetocover just finished slot:"@CoverGoal.Link@CoverGoal.SlotIdx@CoverGoal.Link.Slots[CoverGoal.SlotIdx].SlotOwner@WorldInfo.TimeSeconds@MyGearPawn.LeftSlotIdx@MyGearPawn.RightSlotIdx@"Delta"@IdxDelta);

		MyGearPawn.LeftSlotIdx = Clamp(MyGearPawn.LeftSlotIdx, 0, MyGearPawn.CurrentLink.Slots.length-1);
		MyGearPawn.RightSlotIdx = Clamp(MyGearPawn.RightSlotIdx, 0, MyGearPawn.CurrentLink.Slots.length-1);

		// Set flags for reaching cover
		NotifyReachedCover();

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


defaultproperties
{
}
