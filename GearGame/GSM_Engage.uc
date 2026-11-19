/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GSM_Engage extends GearSpecialMove
	native(SpecialMoves);


// C++ functions
cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
}

/** get PawnOwner's target placement to engage the trigger correctly */
native final function vector GetTargetPosition();

/**
* Can the special move be chained after the current one finishes?
*/
function bool CanChainMove(ESpecialMove NextMove)
{
	return TRUE;
}

/** Checks to see if the engage is finished, and if so will stop the move and return true */
simulated function bool CheckForFinishEngage( optional bool bPlayIdleIfUnfinished )
{
	local GearPC PC;
	local array<SequenceEvent> EngageEvents;
	local SeqEvt_Engage	EngageEvent;
	local bool bIsFinished;

	bIsFinished = TRUE;

	if ( (PawnOwner.Controller != None) && (PawnOwner.Controller.Role == ROLE_Authority) && (PawnOwner.EngageTrigger != None) )
	{
		if ( PawnOwner.EngageTrigger.FindEventsOfClass(class'SeqEvt_Engage', EngageEvents) )
		{
			EngageEvent = SeqEvt_Engage(EngageEvents[0]);

			if ( EngageEvent != None && EngageEvent.bEnabled &&
				 ((PawnOwner.EngageTrigger.ENGAGE_AnimName_Loop == '') || !PawnOwner.EngageTrigger.bIsEngagable) )
			{
				// don't check fov since the camera could be anywhere
				EngageEvent.bCheckInteractFOV = false;

				// fire the "released" event too, since we're disabling it and it won't fire later
				PawnOwner.EngageTrigger.TriggerEventClass( class'SeqEvt_Engage', PawnOwner, eENGAGEOUT_Stopped );

				// all turns done, disable event
				EngageEvent.bEnabled = FALSE;

				// Reset the counter so we can do the engage again if reenabled
				PawnOwner.EngageTrigger.ResetLoopCounter();

				PC = GearPC(PawnOwner.Controller);
				if(PC != none)
				{
					PC.ClientGotoState('PlayerWalking');
					PC.GotoState('PlayerWalking');
				}

				// reset the fov check
				EngageEvent.bCheckInteractFOV = TRUE;
			}
			else
			{
				bIsFinished = false;
			}
		}

		if (!bIsFinished &&
			bPlayIdleIfUnfinished &&
			!PawnOwner.IsDoingSpecialMove(SM_Engage_End) &&
			!PawnOwner.IsDoingSpecialMove(SM_Engage_ForceOff))
		{
			PawnOwner.ServerDoSpecialMove(SM_Engage_Idle, false,,,SM_Engage_Idle);
		}
	}

	return bIsFinished;
}

/** Called when there is no animation to play to prevent from being stuck */
function EndInteraction()
{
	if (PCOwner != None)
	{
		PCOwner.ClientGotoState('PlayerWalking');
		PCOwner.GotoState('PlayerWalking');
	}
	PawnOwner.EndSpecialMove();
}

/**
 * Use the bDisableLook value from the engage trigger
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 *
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	if (PCOwner != None && PawnOwner.EngageTrigger.ENGAGE_bDisableLook)
	{
		PCOwner.IgnoreLookInput(TRUE);
	}
}

/**
 * Use the bDisableLook value from the engage trigger
 *
 * @param PrevMove - the previous special move to run
 *
 * @param NextMove - the next special move to run
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local Array<AnimSet> AnimSetsToAdd;

 	if (NextMove == SM_None && PawnOwner.EngageTrigger != None)
	{
		// Unholster the weapon
		if (PawnOwner.EngageTrigger.ENGAGE_bShouldHolsterWeaponFirst)
		{
			PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(FALSE);
		}

		// Clear the added animsets
		if (PawnOwner.EngageTrigger.ENGAGE_AnimSet_Base != None)
		{
			AnimSetsToAdd.AddItem(PawnOwner.EngageTrigger.ENGAGE_AnimSet_Base);
			PawnOwner.RemoveLocalCustomAnimSets(AnimSetsToAdd);
		}

		PawnOwner.BS_StopAll(0.1f);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);

	if (PCOwner != None && PawnOwner.EngageTrigger.ENGAGE_bDisableLook)
	{
		PCOwner.IgnoreLookInput(FALSE);
	}
}

defaultproperties
{
	bShouldAbortWeaponReload=TRUE
	bDisableMovement=TRUE
	bLockPawnRotation=TRUE
	bDisableLook=FALSE
	bCanSwitchWeapons=FALSE
	bCanFireWeapon=FALSE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE
	bUseUnsynchedServerMove=TRUE
}
