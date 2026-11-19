
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_EngageStart extends GSM_Engage
	native(SpecialMoves);

// Whether the pawn is in place to start engaging
var bool bHasReachedDestination;

// C++ functions
cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
}

/** See if we can start the move */
protected function bool InternalCanDoSpecialMove()
{
	local Pawn HitPawn;
	local vector HitL, HitN;
	local vector Start, End;

	// make sure we have a valid engage trigger and nothing is in the way
	if( PawnOwner.EngageTrigger != None && PawnOwner.EngageTrigger.ENGAGE_Actor != None )
	{
		// Don't allow player to engage a trigger that another pawn is already engaging
		if( PawnOwner.EngageTrigger.EngagedPawn != None )
		{
			return FALSE;
		}

		Start = PawnOwner.Location;
		End = PawnOwner.EngageTrigger.ENGAGE_Actor.Location + (PawnOwner.EngageTrigger.ENGAGE_OffsetFromActor >> PawnOwner.EngageTrigger.ENGAGE_Actor.Rotation);
		foreach PawnOwner.EngageTrigger.ENGAGE_Actor.TraceActors(class'Pawn',HitPawn,HitL,HitN,End,Start,vect(32,32,32))
		{
			return (HitPawn == PawnOwner);
		}
	}
	return TRUE;
}

/** Move started so clear the destination flag */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local Array<AnimSet> AnimSetsToAdd;

	// See if Heavy Weapon should be dropped first.
	if( PawnOwner.EngageTrigger.ENGAGE_bShouldAutoDropHeavyWeapon && PawnOwner.IsCarryingAHeavyWeapon() )
	{
		PawnOwner.ThrowActiveWeapon();
	}

	Super.SpecialMoveStarted(bForced,PrevMove);

	// init the flag
	bHasReachedDestination = FALSE;

	PawnOwner.EngageTrigger.EngagedPawn = PawnOwner;

	PawnOwner.SetTimer(3.0, FALSE, nameof(TeleportToGrab), self);

	// Add the anim set to the pawn
	if (PawnOwner.EngageTrigger.ENGAGE_AnimSet_Base != None)
	{
		AnimSetsToAdd.AddItem(PawnOwner.EngageTrigger.ENGAGE_AnimSet_Base);
		PawnOwner.AddLocalCustomAnimSets(AnimSetsToAdd);
	}
}

/** teleports the player to the proper location if it's taking too long */
function TeleportToGrab()
{
	local vector TeleportLoc;

	// If we got here because we don't have an ENGAGE_Actor, output a warning
	if( PawnOwner.EngageTrigger != None || PawnOwner.EngageTrigger.ENGAGE_Actor == None )
	{
		`warn(GetFuncName() @ PawnOwner.WorldInfo.TimeSeconds @ "Engage Trigger"@PawnOwner.EngageTrigger@"doesn't have ENGAGE_Actor set! Starting Engage anyway");
	}

	if( PawnOwner.Role == ROLE_Authority )
	{
		TeleportLoc = GetTargetPosition();
		TeleportLoc.Z = PawnOwner.Location.Z;
		PawnOwner.SetLocation(TeleportLoc);
	}

	PawnOwner.Velocity = vect(0,0,0);
	PawnOwner.Acceleration = vect(0,0,0);

	bHasReachedDestination = TRUE;
	StartGrabAnim();
}

/** Holster weapon and fire kismet event */
simulated event StartGrabAnim()
{
	local array<SequenceEvent>	EngageEvents;
	local SeqEvt_Engage			EngageEvent;

	PawnOwner.ClearTimer(nameof(TeleportToGrab), self);

	if( PawnOwner.EngageTrigger != None && PawnOwner.EngageTrigger.ENGAGE_bShouldHolsterWeaponFirst )
	{
		// holster the weapon
		PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(TRUE);
	}

	// Set at a fixed time to offset matinee induced delay.
	// Proper fix would be to trigger eENGAGEOUT_Started when Pawn animation plays, but it's too risky to do this two weeks before ZBR.
	PawnOwner.SetTimer(0.5f, FALSE, nameof(ContinueStartAnim), Self);

	// fire proper kismet event
	if( PawnOwner.EngageTrigger != None && PawnOwner.EngageTrigger.FindEventsOfClass(class'SeqEvt_Engage', EngageEvents) )
	{
		EngageEvent = SeqEvt_Engage(EngageEvents[0]);
		if( (EngageEvent != None) && EngageEvent.bEnabled )
		{
			// don't check fov since the camera could be anywhere
			EngageEvent.bCheckInteractFOV = FALSE;
			// fire the event
			PawnOwner.EngageTrigger.TriggerEventClass( class'SeqEvt_Engage', PawnOwner, eENGAGEOUT_Started );
		}
	}
}

/** Play the START animation which is stored in the engage-trigger */
simulated function ContinueStartAnim()
{
	local BodyStance StartStance;

	// Stop the holstering animations
	PawnOwner.MyGearWeapon.StopHolsterAnims();

	if( PawnOwner.EngageTrigger != None && PawnOwner.EngageTrigger.ENGAGE_AnimName_Start != '' &&
		(PawnOwner.EngageTrigger.ENGAGE_bPlayAnimationForHeavyWeapons || PawnOwner.MyGearWeapon.WeaponType != WT_Heavy) )
	{
		// Create the stance struct
		StartStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
		StartStance.Stance[0].Slot = BS_FullBody;
		StartStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_Start;

		// Play body stance animation.
		PawnOwner.BS_Play(StartStance, SpeedModifier, 0.2f/SpeedModifier, -1.f, FALSE, TRUE);

		// Set Root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(StartStance, PawnOwner.EngageTrigger.RootBoneMotion_Start, PawnOwner.EngageTrigger.RootBoneMotion_Start, PawnOwner.EngageTrigger.RootBoneMotion_Start);

		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(StartStance, TRUE);
	}
	else
	{
		PawnOwner.SetTimer(0.1f, FALSE, 'EndInteraction', Self);
	}
}


/**
 * Notification called when body stance animation finished playing.
 * @param	SeqNode		- Node that finished playing. You can get to the SkeletalMeshComponent by looking at SeqNode->SkelComponent
 * @param	PlayedTime	- Time played on this animation. (play rate independant).
 * @param	ExcessTime	- how much time overlapped beyond end of animation. (play rate independant).
 */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	// See if we're finished and play the idle if not
	if( CheckForFinishEngage(true) && PawnOwner.Role == ROLE_Authority )
	{
		PawnOwner.ServerEndSpecialMove();
	}
}


/** Stop the START animation and call the IDLE special move if there is one, else call the END move */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local BodyStance StartStance;

	PawnOwner.ClearTimer(nameof(TeleportToGrab), Self);
	if( PawnOwner.IsTimerActive(nameof(ContinueStartAnim), Self) )
	{
		ContinueStartAnim();
		PawnOwner.ClearTimer(nameof(ContinueStartAnim), Self);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);

	if ( PawnOwner.EngageTrigger != None )
	{
		// Create the stance struct
		StartStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
		StartStance.Stance[0].Slot = BS_FullBody;
		StartStance.Stance[0].AnimName = PawnOwner.EngageTrigger.ENGAGE_AnimName_Start;

		PawnOwner.BS_SetAnimEndNotify(StartStance, FALSE);

		// Turn off Root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(StartStance, RBA_Discard, RBA_Discard, RBA_Discard);
	}
}
