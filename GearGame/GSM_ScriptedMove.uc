
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_ScriptedMove extends GearSpecialMove
	native(SpecialMoves);


/** Whether we've already started the "end" animation or not */
var bool bStartedEndAnim;

/** Whether the pawn is in place to start engaging */
var bool bHasReachedDestination;

/** Last anim played name */
var Name LastAnimPlayed;

/** The current destination for playing the anim */
var vector AnimStartLocation;


// C++ functions
cpptext
{
	virtual void PrePerformPhysics(FLOAT DeltaTime);
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

/** See if we can start the move */
protected function bool InternalCanDoSpecialMove()
{
	return TRUE;
}

/** Determine the destination location for the animation to start at */
function CalculateStartingLocation()
{
	local Vector DestinationTest, HitLocation, HitNormal, Extent, Dir, OrthoDir, StartTest;
	local Actor HitActor;

	if (PawnOwner != None &&
		PawnOwner.ScriptTrigger != None &&
		PawnOwner.ScriptTrigger.ScriptedActor != None)
	{
		// Use the location of the scripted actor for our destination
		AnimStartLocation = PawnOwner.ScriptTrigger.ScriptedActor.Location;

		// If we expect to move through the world let's make sure we can actually move forward
		if (PawnOwner.ScriptTrigger.RootBoneMotion_Start == RBA_Translate &&
			PawnOwner.CylinderComponent != None)
		{
			Dir = Normal(Vector(PawnOwner.ScriptTrigger.ScriptedActor.Rotation));
			StartTest = AnimStartLocation;
			StartTest.Z -= PawnOwner.CylinderComponent.CollisionHeight * 0.5f;
			DestinationTest = StartTest + Dir * 128.0f;
			Extent = PawnOwner.CylinderComponent.CollisionRadius * vect(1,1,0);
			Extent.Z = PawnOwner.CylinderComponent.CollisionHeight;
			HitActor = PawnOwner.Trace(HitLocation, HitNormal, DestinationTest, StartTest, false, Extent);

			// If the trace fails move it over and try again
			if (HitActor != None)
			{
				OrthoDir = Dir cross vect(0,0,1);
				StartTest += OrthoDir * 12.0f;
				DestinationTest += OrthoDir * 12.0f;
				HitActor = PawnOwner.Trace(HitLocation, HitNormal, DestinationTest, StartTest, false, Extent);

				// If the trace still fails move it over the other way and try again
				if (HitActor != None)
				{
					StartTest -= OrthoDir * 24.0f;
					DestinationTest -= OrthoDir * 24.0f;
					HitActor = PawnOwner.Trace(HitLocation, HitNormal, DestinationTest, StartTest, false, Extent);

					// If the last trace fails just fall back on the location of the script actor
					if (HitActor != None)
					{
						return;
					}
				}
			}

			AnimStartLocation.X = StartTest.X;
			AnimStartLocation.Y = StartTest.Y;
		}
	}
	else
	{
		// Don't have reference to the script trigger so just use the current location
		AnimStartLocation = PawnOwner.Location;
	}
}

/** Move started so clear the destination flag */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local Array<AnimSet> AnimSetsToAdd;

	// See if Heavy Weapon should be dropped first.
	if( PawnOwner.ScriptTrigger.bShouldAutoDropHeavyWeapon && PawnOwner.IsCarryingAHeavyWeapon() )
	{
		PawnOwner.ThrowActiveWeapon();
	}

	Super.SpecialMoveStarted(bForced,PrevMove);

	CalculateStartingLocation();

	// init flags
	bHasReachedDestination = false;

	bStartedEndAnim = false;
	LastAnimPlayed = '';

	// Add the anim set to the pawn
	if (PawnOwner.ScriptTrigger.AnimSet_Base != None)
	{
		AnimSetsToAdd.AddItem(PawnOwner.ScriptTrigger.AnimSet_Base);
		PawnOwner.AddLocalCustomAnimSets(AnimSetsToAdd);
	}

	// Tell the trigger that it is being used
	PawnOwner.ScriptTrigger.TriggerUsedNotify();

	if (PawnOwner.ScriptTrigger.ScriptedActor != None)
	{
		PawnOwner.SetTimer(3.0, FALSE, nameof(TeleportToLocation), self);
	}
	else
	{
		StartAnim();
	}
}

/** teleports the player to the proper location if it's taking too long */
function TeleportToLocation()
{
	local vector TeleportLoc;

	TeleportLoc = GetTargetPosition();
	TeleportLoc.Z = PawnOwner.Location.Z;
	PawnOwner.SetLocation(TeleportLoc);

	PawnOwner.Velocity = vect(0,0,0);
	PawnOwner.Acceleration = vect(0,0,0);

	bHasReachedDestination = TRUE;
	StartAnim();
}

/** Holster weapon and fire kismet event */
simulated event StartAnim()
{
	local array<SequenceEvent>	ScriptedEvents;
	local SeqEvt_ScriptedMove	ScriptedEvent;
	local BodyStance StartStance;
	local float TotalAnimTime;

	PawnOwner.ClearTimer(nameof(TeleportToLocation), self);

	if (PawnOwner.ScriptTrigger != None)
	{
		PawnOwner.ScriptTrigger.LoopCounter = 0;

		// holster the weapon
		 if (PawnOwner.ScriptTrigger.bShouldHolsterWeaponFirst)
		 {
			 PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(TRUE);
		 }
	}

	// Stop the holstering animations
	PawnOwner.MyGearWeapon.StopHolsterAnims();

	if( PawnOwner.ScriptTrigger != None && PawnOwner.ScriptTrigger.AnimName_Start != '' &&
		(PawnOwner.ScriptTrigger.bPlayAnimationForHeavyWeapons || PawnOwner.MyGearWeapon.WeaponType != WT_Heavy) )
	{
		// Create the stance struct
		StartStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
		StartStance.Stance[0].Slot = BS_FullBody;
		StartStance.Stance[0].AnimName = PawnOwner.ScriptTrigger.AnimName_Start;

		// Play body stance animation.
		TotalAnimTime = PawnOwner.BS_Play(StartStance, SpeedModifier, 0.33f/SpeedModifier, -1, FALSE, TRUE);
		LastAnimPlayed = PawnOwner.ScriptTrigger.AnimName_Start;
		// Set callback for when anim is finished
		PawnOwner.SetTimer(TotalAnimTime, FALSE, nameof(FinishedAnim), self);

		// Setup the animation to be mirrored if the trigger has that flag set
		if (PawnOwner.ScriptTrigger.bMirrorAnimation)
		{
			PawnOwner.BS_SetMirrorOptions(StartStance, false, true, true);

			// This is a super hack to not trigger the mirror transition blend out just now.
			// We want to play 3 animations in a row. ugh!
			if (PawnOwner.MirrorNode != None)
			{
				PawnOwner.MirrorNode.bLockBlendOut = true;
			}

		}

		// Set Root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(StartStance, PawnOwner.ScriptTrigger.RootBoneMotion_Start, PawnOwner.ScriptTrigger.RootBoneMotion_Start, PawnOwner.ScriptTrigger.RootBoneMotion_Start);
		if (PawnOwner.ScriptTrigger.RootBoneMotion_Start == RBA_Translate)
		{
			// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
			PawnOwner.Mesh.RootMotionMode = RMM_Accel;
		}

		// fire proper kismet event
		if( PawnOwner.ScriptTrigger != None && PawnOwner.ScriptTrigger.FindEventsOfClass(class'SeqEvt_ScriptedMove', ScriptedEvents) )
		{
			ScriptedEvent = SeqEvt_ScriptedMove(ScriptedEvents[0]);
			if( (ScriptedEvent != None) && ScriptedEvent.bEnabled )
			{
				// don't check fov since the camera could be anywhere
				ScriptedEvent.bCheckInteractFOV = FALSE;
				// fire the event
				PawnOwner.ScriptTrigger.TriggerEventClass( class'SeqEvt_ScriptedMove', PawnOwner, eSCRIPTOUT_Started );
			}
		}
	}
	else
	{
		PawnOwner.SetTimer(0.1f, FALSE, nameof(EndInteraction), Self);
	}
}

/** Called when the start animation is finished playing so we can try and kick off another animation */
function FinishedAnim()
{
	local array<SequenceEvent>	ScriptedEvents;
	local SeqEvt_ScriptedMove	ScriptedEvent;
	local BodyStance AnimStance;
	local BodyStance StartStance;
	local float TotalAnimTime;

	// Make sure we have a reference to the trigger
	if (PawnOwner.ScriptTrigger != None)
	{
		// See if there is a loop animation to play
		if (PawnOwner.ScriptTrigger.AnimName_Loop != '' &&
			PawnOwner.ScriptTrigger.TurnsToComplete > 0 &&
			PawnOwner.ScriptTrigger.LoopCounter < PawnOwner.ScriptTrigger.TurnsToComplete)
		{
			// If the previous animation was the start anim, stop it first
			if (PawnOwner.ScriptTrigger.LoopCounter <= 0)
			{
				// Create the stance struct
				StartStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
				StartStance.Stance[0].Slot = BS_FullBody;
				StartStance.Stance[0].AnimName = PawnOwner.ScriptTrigger.AnimName_Start;

				// Turn off Root motion on animation node
				PawnOwner.BS_SetRootBoneAxisOptions(StartStance, RBA_Discard, RBA_Discard, RBA_Discard);
				PawnOwner.Mesh.RootMotionMode = RMM_Ignore;

				// Turn off mirroring
				if (PawnOwner.ScriptTrigger.bMirrorAnimation)
				{
					PawnOwner.BS_SetMirrorOptions(StartStance, false, false, false);
				}
			}

			PawnOwner.ScriptTrigger.LoopCounter++;

			// Create the stance struct
			AnimStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
			AnimStance.Stance[0].Slot = BS_FullBody;
			AnimStance.Stance[0].AnimName = PawnOwner.ScriptTrigger.AnimName_Loop;

			// Play body stance animation.
			TotalAnimTime = PawnOwner.BS_Play(AnimStance, SpeedModifier, 0.2f/SpeedModifier, -1, FALSE, TRUE);
			LastAnimPlayed = PawnOwner.ScriptTrigger.AnimName_Loop;

			// Set callback for when anim is finished
			PawnOwner.SetTimer(TotalAnimTime, FALSE, nameof(FinishedAnim), self);

			// Setup the animation to be mirrored if the trigger has that flag set
			if (PawnOwner.ScriptTrigger.bMirrorAnimation)
			{
				PawnOwner.BS_SetMirrorOptions(AnimStance, false, true, true);
			}

			// Set Root motion on animation node
			PawnOwner.BS_SetRootBoneAxisOptions(AnimStance, PawnOwner.ScriptTrigger.RootBoneMotion_Loop, PawnOwner.ScriptTrigger.RootBoneMotion_Loop, PawnOwner.ScriptTrigger.RootBoneMotion_Loop);
			if (PawnOwner.ScriptTrigger.RootBoneMotion_Loop == RBA_Translate)
			{
				// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
				PawnOwner.Mesh.RootMotionMode = RMM_Accel;
			}

			// fire proper kismet event
			if (PawnOwner.ScriptTrigger != None &&
				PawnOwner.ScriptTrigger.FindEventsOfClass(class'SeqEvt_ScriptedMove', ScriptedEvents))
			{
				ScriptedEvent = SeqEvt_ScriptedMove(ScriptedEvents[0]);
				if (ScriptedEvent != None && ScriptedEvent.bEnabled)
				{
					// don't check fov since the camera could be anywhere
					ScriptedEvent.bCheckInteractFOV = FALSE;
					// fire the event
					PawnOwner.ScriptTrigger.TriggerEventClass(class'SeqEvt_ScriptedMove', PawnOwner, eSCRIPTOUT_LoopStart);
				}
			}
		}
		// See if we need to play the end animation
		else if (!bStartedEndAnim &&
				 PawnOwner.ScriptTrigger.AnimName_End != '')
		{
			bStartedEndAnim = true;

			// If the previous animation was the start anim, stop it first
			if (PawnOwner.ScriptTrigger.LoopCounter <= 0 &&
				PawnOwner.ScriptTrigger.AnimName_Start != '')
			{
				// Create the stance struct
				StartStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
				StartStance.Stance[0].Slot = BS_FullBody;
				StartStance.Stance[0].AnimName = PawnOwner.ScriptTrigger.AnimName_Start;

				// Turn off Root motion on animation node
				PawnOwner.BS_SetRootBoneAxisOptions(StartStance, RBA_Discard, RBA_Discard, RBA_Discard);
				PawnOwner.Mesh.RootMotionMode = RMM_Ignore;

				// Stop mirroring
				if (PawnOwner.ScriptTrigger.bMirrorAnimation)
				{
					PawnOwner.BS_SetMirrorOptions(StartStance, false, false, false);
				}
			}
			// else if the previous animation was the loop animation
			else if (PawnOwner.ScriptTrigger.LoopCounter > 0 &&
					 PawnOwner.ScriptTrigger.AnimName_Loop != '')
			{
				// Create the stance struct
				StartStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
				StartStance.Stance[0].Slot = BS_FullBody;
				StartStance.Stance[0].AnimName = PawnOwner.ScriptTrigger.AnimName_Loop;

				// Turn off Root motion on animation node
				PawnOwner.BS_SetRootBoneAxisOptions(StartStance, RBA_Discard, RBA_Discard, RBA_Discard);
				PawnOwner.Mesh.RootMotionMode = RMM_Ignore;

				// Stop mirroring
				if (PawnOwner.ScriptTrigger.bMirrorAnimation)
				{
					PawnOwner.BS_SetMirrorOptions(StartStance, false, false, false);
				}
			}

			// Create the stance struct
			AnimStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
			AnimStance.Stance[0].Slot = BS_FullBody;
			AnimStance.Stance[0].AnimName = PawnOwner.ScriptTrigger.AnimName_End;

			// Play body stance animation.
			PawnOwner.BS_Play(AnimStance, SpeedModifier, 0.2f/SpeedModifier, -1.0f, FALSE, TRUE);
			LastAnimPlayed = PawnOwner.ScriptTrigger.AnimName_End;

			// Set Root motion on animation node
			PawnOwner.BS_SetRootBoneAxisOptions(AnimStance, PawnOwner.ScriptTrigger.RootBoneMotion_End, PawnOwner.ScriptTrigger.RootBoneMotion_End, PawnOwner.ScriptTrigger.RootBoneMotion_End);
			if (PawnOwner.ScriptTrigger.RootBoneMotion_End == RBA_Translate)
			{
				// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
				PawnOwner.Mesh.RootMotionMode = RMM_Accel;
			}

			// Enable end of animation notification. This is going to call SpecialMoveEnded()
			PawnOwner.BS_SetAnimEndNotify(AnimStance, TRUE);

			// Setup the animation to be mirrored if the trigger has that flag set
			if (PawnOwner.ScriptTrigger.bMirrorAnimation)
			{
				PawnOwner.BS_SetMirrorOptions(AnimStance, false, true, true);
			}

			// fire proper kismet event
			if (PawnOwner.ScriptTrigger != None &&
				PawnOwner.ScriptTrigger.FindEventsOfClass(class'SeqEvt_ScriptedMove', ScriptedEvents))
			{
				ScriptedEvent = SeqEvt_ScriptedMove(ScriptedEvents[0]);
				if (ScriptedEvent != None && ScriptedEvent.bEnabled)
				{
					// don't check fov since the camera could be anywhere
					ScriptedEvent.bCheckInteractFOV = FALSE;
					// fire the event
					PawnOwner.ScriptTrigger.TriggerEventClass(class'SeqEvt_ScriptedMove', PawnOwner, eSCRIPTOUT_Ending);
				}
			}
		}
		// No more anims to play so end special move
		else
		{
			if (LastAnimPlayed != '')
			{
				// Create the stance struct
				StartStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
				StartStance.Stance[0].Slot = BS_FullBody;
				StartStance.Stance[0].AnimName = LastAnimPlayed;

				// Turn off Root motion on animation node
				PawnOwner.BS_SetRootBoneAxisOptions(StartStance, RBA_Discard, RBA_Discard, RBA_Discard);
				PawnOwner.Mesh.RootMotionMode = RMM_Ignore;

				// Stop mirroring
				if (PawnOwner.ScriptTrigger.bMirrorAnimation)
				{
					PawnOwner.BS_SetMirrorOptions(StartStance, false, false, false);
				}
			}

 			PawnOwner.SetTimer(0.01f, FALSE, nameof(EndInteraction), Self);
		}
	}
}

/** Stop the special move */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local array<SequenceEvent>	ScriptedEvents;
	local SeqEvt_ScriptedMove	ScriptedEvent;
	local BodyStance AnimStance;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	if (PawnOwner.ScriptTrigger != None &&
		PawnOwner.ScriptTrigger.FindEventsOfClass(class'SeqEvt_ScriptedMove', ScriptedEvents))
	{
		ScriptedEvent = SeqEvt_ScriptedMove(ScriptedEvents[0]);
		if (ScriptedEvent != None && ScriptedEvent.bEnabled)
		{
			// don't check fov since the camera could be anywhere
			ScriptedEvent.bCheckInteractFOV = FALSE;
			// fire the event
			PawnOwner.ScriptTrigger.TriggerEventClass(class'SeqEvt_ScriptedMove', PawnOwner, eSCRIPTOUT_Finished);
		}
	}

	// Make sure the animation is cleared of bone axis changes
	if (PawnOwner.ScriptTrigger != None)
	{
		if (LastAnimPlayed != '')
		{
			AnimStance.Stance.Length = 1; // Array of struct needs to be pre-sized.
			AnimStance.Stance[0].Slot = BS_FullBody;
			AnimStance.Stance[0].AnimName = LastAnimPlayed;
			PawnOwner.BS_SetRootBoneAxisOptions(AnimStance, RBA_Discard, RBA_Discard, RBA_Discard);
			PawnOwner.Mesh.RootMotionMode = RMM_Ignore;
			PawnOwner.BS_Stop(AnimStance, 0.45f);

			// Stop mirroring
			if (PawnOwner.ScriptTrigger.bMirrorAnimation)
			{
				PawnOwner.BS_SetMirrorOptions(AnimStance, false, false, false);
			}
		}

		// Unlock blending if we mirrored the animation
		if (PawnOwner.ScriptTrigger.bMirrorAnimation)
		{
			// This is a super hack to not trigger the mirror transition blend out just now.
			// We want to play 3 animations in a row. ugh!
			if (PawnOwner.MirrorNode != None)
			{
				PawnOwner.MirrorNode.bLockBlendOut = false;
			}
		}
	}

	// unholster the weapon
	if( PawnOwner.ScriptTrigger.bShouldHolsterWeaponFirst )
	{
		PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(FALSE);
	}

	PawnOwner.SetTimer(0.3f, false, nameof(CleanupMove), self);

	PawnOwner.Velocity = vect(0,0,0);
	PawnOwner.Acceleration = vect(0,0,0);
}

/** Called after animation is completed to remove the anim set (done in a callback so it's not on the same frame) */
function CleanupMove()
{
	local Array<AnimSet> AnimSetsToAdd;

	// Clear the anim set from the pawn
	if (PawnOwner.ScriptTrigger != None &&
		PawnOwner.ScriptTrigger.AnimSet_Base != None)
	{
		AnimSetsToAdd.AddItem(PawnOwner.ScriptTrigger.AnimSet_Base);
		PawnOwner.RemoveLocalCustomAnimSets(AnimSetsToAdd);
	}

	PawnOwner.ScriptTrigger = None;
}

/** Called when there is no animation to play to prevent from being stuck */
function EndInteraction()
{
	PawnOwner.EndSpecialMove();
}

defaultproperties
{
	bShouldAbortWeaponReload=TRUE
	bDisableMovement=TRUE
	bLockPawnRotation=TRUE
	bDisableLook=FALSE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE
	bUseUnsynchedServerMove=TRUE
}
