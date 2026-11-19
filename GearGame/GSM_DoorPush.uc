
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_DoorPush extends GSM_BasePlaySingleAnim
	native(SpecialMoves)
	DependsOn(GearPawn);

/** GoW global macros */

/** The special move ID for this move.  Used by GearPawn::OnDoorPush. */
var ESpecialMove SpecialMoveID;

/** Cache the door trigger */
var Trigger_DoorInteraction Door;

/** Cache whether we are overriding the animation */
var bool bAnimationOverridden;

/** Whether the pawn is in place to start engaging */
var bool bHasReachedDestination;

var bool bWeaponWasAlreadyHolstered;

// C++ functions
cpptext
{
	virtual void PrePerformPhysics(FLOAT DeltaTime);
}


/** get PawnOwner's target placement to engage the trigger correctly */
native final function vector GetTargetPosition();

protected function bool InternalCanDoSpecialMove()
{
	local GearPawn TouchingGP;

	// Don't allow the special move if another pawn is already opening the door
	if (PawnOwner.DoorTrigger != None)
	{   
		foreach PawnOwner.DoorTrigger.TouchingActors(class'GearPawn', TouchingGP)
		{
			if (TouchingGP.IsDoingSpecialMove(SM_DoorKick) || TouchingGP.IsDoingSpecialMove(SM_DoorPush))
			{
				return false;
			}
		}
	}
	return true;
}

/** Whether the animation was overriden in the trigger data */
function bool IsUsingAnimOverride()
{
	if (PawnOwner.DoorTrigger != None &&
		PawnOwner.DoorTrigger.AnimSet_Base != None &&
		PawnOwner.DoorTrigger.AnimName != '')
	{
		return true;
	}

	return false;
}

/** Move started so clear the destination flag */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local Array<AnimSet> AnimSetsToAdd;

	// Restore that to default in case it's been changed.
	SpecialMoveCameraBoneAnims = default.SpecialMoveCameraBoneAnims;
	// Make sure we use default animation
	BS_Animation = default.BS_Animation;

	bAnimationOverridden = IsUsingAnimOverride();

	// Cache the door trigger and get the move ready for animating
	if (PawnOwner.DoorTrigger != None)
	{
		Door = PawnOwner.DoorTrigger;

		if( Door.bDisableCollision )
		{
			TogglePawnCollision(FALSE);
		}

		// See if Heavy Weapon should be dropped first.
		if (Door.bShouldAutoDropHeavyWeapon && PawnOwner.IsCarryingAHeavyWeapon() )
		{
			PawnOwner.ThrowActiveWeapon();
		}

		// Add the anim set to the pawn
		if (Door.AnimSet_Base != None)
		{
			AnimSetsToAdd.AddItem(Door.AnimSet_Base);
			PawnOwner.AddLocalCustomAnimSets(AnimSetsToAdd);
		}

		// Kill camera anims if we need to.
		if( Door.bDisableCameraAnim )
		{
			SpecialMoveCameraBoneAnims.Length = 0;
		}
	}

	Super(GearSpecialMove).SpecialMoveStarted(bForced,PrevMove);

	// init the flag
	bHasReachedDestination = false;
	bWeaponWasAlreadyHolstered = PawnOwner.MyGearWeapon.bTemporaryHolster;

	// Only align the PawnOwner to the alignment actor before playing the animation if forced to
	if( AlignBeforePlayingAnim() )
	{
		// Setup failsafe teleport in case we can't reach the destination.
		PawnOwner.SetTimer(3.0, FALSE, nameof(TeleportToLocation), self);
	}
	else
	{
		// Otherwise, startup animation now!
		StartAnim();
	}
}

/** Tells us if we have to align the Pawn before triggering the animation. 
 *  If we're using Root Motion, then we need to align first, as we can't do both at the same time.
 *  */
event bool AlignBeforePlayingAnim()
{
	return (Door.AlignToObj != None && (Door.RootBoneMotion == RBA_Translate || Door.bForceAlignment));
}

/** teleports the player to the proper location if it's taking too long */
function TeleportToLocation()
{
	local vector TeleportLoc;

// 	`log(GetFuncName() @ PawnOwner);

	TeleportLoc = GetTargetPosition();
	TeleportLoc.Z = PawnOwner.Location.Z;
	PawnOwner.SetLocation(TeleportLoc);

	PawnOwner.Velocity = vect(0,0,0);
	PawnOwner.Acceleration = vect(0,0,0);

	bHasReachedDestination = TRUE;
	StartAnim();
}

simulated event StartAnim()
{
// 	local float YawDiff, CameraTurnTime, Pct;
// 	local GearGameplayCamera Cam;
	local rotator NewPlayerRot;
	local GearPC PC;
	local FLOAT TimeToTriggerDoor;
	local float AnimTime;

// 	`log(GetFuncName() @ PawnOwner);

	PC = GearPC(PawnOwner.Controller);
	PawnOwner.ClearTimer(nameof(TeleportToLocation), self);

	// for players, turn to face direction of the door
	if (Door != None)
	{
		// use the align object if possible
		if (Door.AlignToObj != None)
		{
			NewPlayerRot = Door.AlignToObj.Rotation;
			NewPlayerRot.Pitch = 0;
		}
		else
		{
			if (PC != None)
			{
`if(`notdefined(FINAL_RELEASE))
				PC.ClientMessage("WARNING: DOOR DOES NOT HAVE ALIGNTOOBJ SET PROPERLY");
`endif
				NewPlayerRot = Rotator(PawnOwner.DoorTrigger.Location - PawnOwner.Location);
				NewPlayerRot.Pitch = 0;
				// turn the player
				PC.SetRotation(NewPlayerRot);
			}
		}
	}

	// Set weapon up
	PawnOwner.SetWeaponAlert(PawnOwner.AimTimeAfterFiring*2.f);

	// Trigger the door kick delegates in the GearPC
	if( PCOwner != None )
	{
		PCOwner.TriggerGearEventDelegates( eGED_KickDoor );
	}

	PlayAnimation();

	if (PawnOwner.Role == ROLE_Authority &&
		PC != None)
	{
		// Determines how far into the animation the kismet event should fire to tell the level that the door should open
		if (PawnOwner.DoorTrigger != None &&
			PawnOwner.DoorTrigger.AnimSet_Base != None &&
			PawnOwner.DoorTrigger.AnimName != '')
		{
			AnimTime = PawnOwner.DoorTrigger.TimeForDoorOpen;
		}
		else
		{
			AnimTime = 0.95f;
		}
		TimeToTriggerDoor = AnimTime * PawnOwner.SpecialMoveClasses[SM_DoorKick].default.SpeedModifier;

		// set the timer to actually trigger the door open event
		PC.SetTimer( TimeToTriggerDoor , FALSE, 'DoDoorOpenCallback', PC );
	}
}

function float PlayMyAnim()
{
	local float AnimTime;

	// holster the weapon
	if( Door.bShouldHolsterWeaponFirst && !bWeaponWasAlreadyHolstered )
	{
		PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(TRUE);
	}

	// Stop the holstering animations
	PawnOwner.MyGearWeapon.StopHolsterAnims();

	if (bAnimationOverridden &&
		(Door.bPlayAnimationForHeavyWeapons || PawnOwner.MyGearWeapon.WeaponType != WT_Heavy))
	{
		BS_Animation.Stance.Length = 1; // Array of struct needs to be pre-sized.
		BS_Animation.Stance[0].Slot = BS_FullBody;
		BS_Animation.Stance[0].AnimName = Door.AnimName;
		AnimTime = PawnOwner.BS_Play(BS_Animation, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE, true);

		// Disable early AnimEnd Notify. So we can notified when the animation is done blending out.
		// At this point we can safely remove the AnimSet from the Pawn.
		PawnOwner.BS_SetEarlyAnimEndNotify(BS_Animation, FALSE);

		// Set Root motion on animation node
		PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, Door.RootBoneMotion, Door.RootBoneMotion, Door.RootBoneMotion);
		if (Door.RootBoneMotion == RBA_Translate)
		{
			// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
			PawnOwner.Mesh.RootMotionMode = RMM_Accel;
		}

		return AnimTime;
	}
	else
	{
		return Super.PlayMyAnim();
	}
}

function PlayAnimation()
{
	if( PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.WeaponType == WT_Heavy )
	{
		PawnOwner.SetTimer(0.25, FALSE, 'EndSpecialMove', Self);
	}
	else
	{
		Super.PlayAnimation();
	}
}

function EndSpecialMove()
{
	PawnOwner.EndSpecialMove();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local Array<AnimSet> AnimSetsToAdd;

	// Clear the anim set from the pawn
	if( Door != None && Door.AnimSet_Base != None )
	{
		AnimSetsToAdd.AddItem(Door.AnimSet_Base);
		PawnOwner.RemoveLocalCustomAnimSets(AnimSetsToAdd);
	}

	// Turn off Root motion
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;

	if( PawnOwner.Controller != None )
	{
		// kismet action may have turned this on via AlignTo parameter
		PawnOwner.Controller.bPreciseDestination = FALSE;
		PawnOwner.Velocity = vect(0,0,0);
	}

	// unholster the weapon
	if( Door != None )
	{
		if( Door.bDisableCollision )
		{
			TogglePawnCollision(TRUE);
		}

		if( Door.bShouldHolsterWeaponFirst && !bWeaponWasAlreadyHolstered )
		{
			PawnOwner.MyGearWeapon.HolsterWeaponTemporarily(FALSE);
		}
	}

	Door = None;

// 	PawnOwner.SetTimer(0.3f, false, nameof(CleanupMove), self);

	// Call super class version.
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

// /** Called after animation is completed to remove the anim set (done in a callback so it's not on the same frame) */
// function CleanupMove()
// {
// 	local Array<AnimSet> AnimSetsToAdd;
// 
// 	// Clear the anim set from the pawn
// 	if( Door != None && Door.AnimSet_Base != None )
// 	{
// 		AnimSetsToAdd.AddItem(Door.AnimSet_Base);
// 		PawnOwner.RemoveLocalCustomAnimSets(AnimSetsToAdd);
// 	}
// 
// 	Door = None;
// }

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="door_nudge")))
	BlendInTime=0.33
	BlendOutTime=0.45

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	bDisableLook=FALSE

	SpecialMoveID=SM_DoorPush

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE

 	bUseUnsynchedServerMove=TRUE
}
