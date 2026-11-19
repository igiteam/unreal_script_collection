/**
 *
 *
 * Copyright ? 1998-2006 Epic Games, Inc. All Rights Reserved.
 **/

class TPCheckpoint extends PathNode
    placeable
	native;
























































































































 



#linenumber 11

/**
 * Possible values for level load flag
 */
enum ELevelLoadOverride
{
	LLO_NoChange,
	LLO_ForceLoaded,
	LLO_ForceUnloaded
};

/**
 * Possible values for level visibility flag
 */
enum ELevelVisibilityOverride
{
	LVO_NoChange,
	LVO_ForceVisible,
	LVO_ForceNonVisible
};

/**
 * Possible values for level load flag
 */
enum EStreamingVolumeOverride
{
	SVO_NoChange,
	SVO_ForceEnabled,
	SVO_ForceDisabled
};

/**
 * Helper struct to hold information for overriding level loaded/visible
 * state as well as steaming volume enabled/disabled state
 */
struct native CheckpointOverride
{
	/** Name of level to override values for */
	var() name LevelName;

	/** Level load control */
	var() ELevelLoadOverride LevelLoadOverride;

	/** Level load control */
	var() ELevelVisibilityOverride LevelVisibilityOverride;

	/** Level load control */
	var() EStreamingVolumeOverride StreamingVolumeOverride;

	structdefaultproperties
	{
		LevelLoadOverride=LLO_ForceLoaded
		LevelVisibilityOverride=LVO_ForceVisible
	}
};

/** the map name this checkpoint is from.  The combination of these should result in uniqueness **/
var string MapName;

/** This is the name of the checkpoint.  This must be unique across all checkpoints **/
var() string CheckpointName;

// This is the chapter point number for this checkpoint.  This must be unique for all checkpoints; -1
// should be used to indicate that this checkpoint is NOT a chapter point.
var() int ChapterPointIndex; 

/** Should be marked to true for the first checkpoint in the map. WHen this checkpoint is loaded, it will trigger the LevelBeginning event, but not for other checkpoints */
var() bool bIsLevelBeginning;

var() float TeleportDistance;
var() float TeleportZDistance;

/** List of all LD-assigned overrides */
var() array<CheckpointOverride> Overrides;

var() array<NavigationPoint> PlayerTeleportSpots;

/** Amount of time to pause game (behind movie) when loading chapter to get textures streamed in. */
var() float	ChapterLoadTextureWarmupPause;

/** Amount of time to pause game (behind movie) when loading checkpoint to get textures streamed in. */
var() float	CheckpointLoadTextureWarmupPause;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/**
 * Whether or not the checkpoint should be received.
 * Checks for any dead human players.
 **/
function bool ShouldDoCheckpoint()
{
	local TPPlayerController TPPC;
	local int NumControllers;

	foreach WorldInfo.AllControllers(class'TPPlayerController', TPPC)
	{
		if (TPPC.IsInState('Dead'))
		{
			;
			return false;
		}

		// we only care about controllers with pawns
		if ( TPPC.Pawn != None )
		{
			// if any pawns are dead there will be no checkpoint
			if ( TPPC.Pawn.bTearOff || TPPC.Pawn.Health <= 0)
			{
				return false;
			}

			// keep track of the number of controllers with pawns
			NumControllers++;
		}
	}

	// if all of the controllers with pawns are in the revive state, no checkpoint
	return (NumControllers != 0);
}

/**
 * Kismet hook.
 *
 *
 * As there can only ever by one "active" checkpoint we only need to handle Set Activate Checkpoint
 * events.  When we received one of those we then tell the CheckpointManager that we are the new
 * checkpoint.  The manager just replaces us and more than likely persists
 *
 *
 **/
function OnTPCheckpoint( SeqAct_TPCheckpoint InAction )
{
	local PlayerController PC;
	local TPPlayerController TPPC;
	local TPCheckpointManager TPCM;
	local Pawn Pawn;
	local TPPawn TP;
	local bool bNeedsTeleport;
	local Vehicle Vehicle;

	// Activate Checkpoint
	if( InAction.InputLinks[0].bHasImpulse == TRUE )
	{
		// see if we should prevent the checkpoint from happening due to a gameover situation.
		if ( !ShouldDoCheckpoint() )
		{
			;
			return;
		}

		;
		;

		// find the global TPCM
		ForEach LocalPlayerControllers(class'PlayerController', PC)
		{
			TPPC = TPPlayerController(PC);
			TPCM = TPPC.TPCM;
			Pawn = PC.Pawn;
			
			break;
		}

		// if this is already the active checkpoint, do nothing
		if (TPCM.CurrCheckpoint == self )
		{
			return;
		}

		// @hack workaround whatever
		// if we get here, and the player controller pawns have no weapons, then give them defaults
		// (should never happen, but just in case)
		foreach WorldInfo.AllControllers(class'TPPlayerController',TPPC)
		{
			// Update our stats
			TPPC.WriteProfile();
			
			TP = TPPawn(TPPC.Pawn);
			if (TP == none)
			{
				Vehicle = Vehicle(TPPC.Pawn);
				if (Vehicle != none)
				{
					TP = TPPawn(Vehicle.Driver);
				}
			}

			// make sure the pawn, if we found one, has default inventory if he had no other weapons
			if (TP != none)
			{
				if (TP.InvManager.InventoryChain == None)
				{
					;
					TP.AddDefaultInventory();
				}
			}
		}

		// set the checkopint
		TPCM.SetNewCheckpoint( self, !InAction.bShouldSave );

		// fire event if desired
		if( InAction.bFireCheckPointActivedEvent == TRUE )
		{
			// trigger events waiting on this
			TriggerEventClass( class'SeqEvt_CheckpointActivated', Pawn );
		}

		// tell the hud to draw informative text about hitting the checkpoint
		// only to the host though
		if (InAction.bDisplayCheckpointingText)
		{
			ForEach LocalPlayerControllers(class'PlayerController', PC)
			{
				TPPlayerController(PC).ClientDisplayCheckpointText();
				break;
			}
		}

		// teleport players as well
		if( Role == ROLE_Authority )
		{
			if (TeleportDistance > 0.f || TeleportZDistance > 0.f)
			{
				foreach WorldInfo.AllControllers(class'TPPlayerController',TPPC)
				{
					bNeedsTeleport = ((TeleportDistance > 0.f && VSize2D(TPPC.Pawn.Location - Location) > TeleportDistance) ||
									 (TeleportZDistance > 0.f && Abs(Location.Z - TPPC.Pawn.Location.Z) > TeleportZDistance));

					// check to see if the pawn is a vehicle (which doesn't want to teleport)
					if (bNeedsTeleport)
					{
						Vehicle = Vehicle(TPPC.Pawn);
						if (Vehicle != none)
						{
							Vehicle.DriverLeave(true);
						}
					}

					TP = TPPawn(TPPC.Pawn);
					if (TP == None)
					{
						continue;
					}

					if (bNeedsTeleport)
					{
						HandlePawnTeleport(TP,TPPC);
					}
				}
			}
		}
	}
	else
	{
		;
	}
}

function OnTPChapterpoint( SeqAct_TPChapterpoint InAction )
{
	local PlayerController PC;
	local TPPlayerController TPPC;
	local TPCheckpointManager TPCM;

	// Activate Checkpoint
	if( InAction.InputLinks[0].bHasImpulse == TRUE )
	{
		// Find the global TPCM
		ForEach LocalPlayerControllers(class'PlayerController', PC)
		{
			TPPC = TPPlayerController(PC);
			TPCM = TPPC.TPCM;
			
			break;
		}
	}
	
	TPGameReplicationInfo(WorldInfo.GRI).SetCurrentChapterPoint(InAction.ChapterPointIndex);
	// set the checkpoint
	TPCM.SetNewCheckpoint( self, true, true);
	TPCM.CreateChapterpoint(InAction.ChapterPointIndex);
	
	ForEach LocalPlayerControllers(class'PlayerController', PC)
	{
		TPPlayerController(PC).ClientDisplayChapterpointText();
		break;
	}
}

simulated event HandlePawnTeleport(TPPawn TP, TPPlayerController TPPC)
{
//	local int Idx;
//	local bool bTeleported;
	// make sure to kill special move and cover first
//	TPPC.ServerDictateSpecialMove(SM_None);
//	TPPC.ClientBreakFromCover();
//	bTeleported = FALSE;

	// Look for a valid teleport spot
//	for (Idx = 0; Idx < PlayerTeleportSpots.Length; Idx++)
//	{
//		if (PlayerTeleportSpots[Idx] != None &&
//			TPPC.FindAvailableTeleportSpot(TP,PlayerTeleportSpots[Idx],TRUE))
//		{
//			bTeleported = TRUE;
//			break;
//		}
//	}
	
	// We couldn't use any of the teleport spots, so just use the checkpoint position
//	if (!bTeleported && !TPPC.FindAvailableTeleportSpot(TP,self))
//	{	
        // SLIN - Force the player to the checkpoint position.
        TP.SetLocation(Location);
        TP.SetRotation(Rotation);
        TPPC.SetRotation(Rotation);
		TP.SetPhysics(PHYS_Falling);	
//	}
}

