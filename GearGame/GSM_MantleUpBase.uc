
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MantleUpBase extends GearSpecialMove
	native(SpecialMoves)
	config(Pawn)
	abstract;

/** GoW global macros */

/** Mantle up animation */
var()	GearPawn.BodyStance	BS_MantleUp, BS_MantleUpMirrored;

/** This is the angle for which we scan for cover nodes to then check for mantling up capability **/
var config float CheckForAutoMantleUpFOV;

// offset from starting position to do landing verification checks
var vector LandCheckOffset;


protected function bool InternalCanDoSpecialMove()
{
	local GearPC		PC;

	local bool bLeftCapable,bRightCapable;
	local float SlotPctThresh;

	local bool bSlotsCapable;

	SlotPctThresh = 0.075;

	if( PawnOwner.CurrentLink == None ||
		PawnOwner.LeftSlotIdx == -1 ||
		PawnOwner.RightSlotIdx == -1 )
	{
		return FALSE;
	}


	if( PawnOwner.IsDoingSpecialMove(SM_MantleUpLowCover) || (PCOwner != none && PCOwner.bBreakFromCover))
	{
		return FALSE;
	}

	PC = GearPC(PawnOwner.Controller);
	if (!PawnOwner.bIsPendingMove && PC != None && PC.IsLocalPlayerController())
	{
		if( Abs(PC.RemappedJoyUp) < Abs(PC.RemappedJoyRight) || PC.RemappedJoyUp <= PC.DeadZoneThreshold )
		{
			return FALSE;
		}
	}


	// On a single slot
	if( PawnOwner.IsOnACoverSlot() )
	{
		bSlotsCapable =	PawnOwner.CurrentSlotIdx <= PawnOwner.CurrentLink.Slots.Length &&
				PawnOwner.CurrentLink.Slots[PawnOwner.CurrentSlotIdx].bCanClimbUp &&
				PawnOwner.CurrentLink.Slots[PawnOwner.CurrentSlotIdx].bCanPopUp &&
				!PawnOwner.CurrentLink.Slots[PawnOwner.CurrentSlotIdx].bCanMantle;
	}
	else
	{
		bLeftCapable = PawnOwner.CurrentLink.Slots.Length >= PawnOwner.LeftSlotIdx
						&& PawnOwner.CurrentLink.Slots[PawnOwner.LeftSlotIdx].bCanClimbUp
						&& PawnOwner.CurrentLink.Slots[PawnOwner.LeftSlotIdx].bCanPopUp
						&& !PawnOwner.CurrentLink.Slots[PawnOwner.LeftSlotIdx].bCanMantle;

		bRightCapable = PawnOwner.CurrentLink.Slots.Length >= PawnOwner.RightSlotIdx
						&& PawnOwner.CurrentLink.Slots[PawnOwner.RightSlotIdx].bCanClimbUp
						&& PawnOwner.CurrentLink.Slots[PawnOwner.RightSlotIdx].bCanPopUp
						&& !PawnOwner.CurrentLink.Slots[PawnOwner.RightSlotIdx].bCanMantle;

		// if we're in between two slots, and they're both capable, let it through!
		if ( bLeftCapable && bRightCapable )
		{
			bSlotsCapable = true;
		}
		else if(bLeftCapable && PawnOwner.CurrentSlotPct < SlotPctThresh)
		{
			bSlotsCapable = true;
		}
		else if(bRightCapable && PawnOwner.CurrentSlotPct > 1.0 - SlotPctThresh)
		{
			bSlotsCapable = true;
		}
	}
	
	if( !bSlotsCapable )
	{
		return false;
	}

	return VerifyLandingClear(PawnOwner.Location + (LandCheckOffset >> PawnOwner.Rotation));
}

protected function bool HandleHitActor(Actor HitActor)
{
	local Gearpawn GP;
	if (HitActor != None)
	{
		if (HitActor.bBlockActors && !HitActor.bTearOff )
		{
			// skip dead guys
			GP=Gearpawn(HitActor);
			if(GP != none && GP.Health <= 0 && !GP.IsDBNO())
			{
				return true;
			}

			
			return false;
		}
	}
	return true;
}

function bool VerifyLandingClear(vector CheckLoc)
{
	local Actor HitActor;
	local float CollisionRadius;


	
	CollisionRadius = 2.0*PawnOwner.GetCollisionRadius();

	foreach PawnOwner.CollidingActors(class'Actor',HitActor,CollisionRadius,CheckLoc)
	{
		if( !HandleHitActor(HitActor))
		{

			return false;
		}
	}

	return true;
}

function bool CanChainMove(ESpecialMove NextMove)
{
	return (NextMove == SM_RoadieRun || NextMove == SM_Run2MidCov || NextMove == SM_Run2StdCov);
}

/** Called when ready to break from cover. Might be delayed because doing a mirror transition. */
/** Notification called when we're mirror transition safe. */
function OnMirrorTransitionSafeNotify()
{
	// Start with jump animation
	PlayJumpUp();
}

/** Play JumpUp. */
/** This sets right physics mode and root motion setups and all effect comes with it - sound, notifiers **/
function PlayJumpUp()
{
	// Disable steps smoothing
	PawnOwner.bCanDoStepsSmoothing = FALSE;


	// Play body stance animation.
	if( PawnOwner.bIsMirrored )
	{
		PawnOwner.BS_Play(BS_MantleUpMirrored, SpeedModifier, 0.1f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);

		// Play animation mirrored
		PawnOwner.BS_SetMirrorOptions(BS_MantleUpMirrored, FALSE, TRUE, TRUE);

		// Don't trigger the notification early, as we want the IK to be switched back on after the transition animation has disapeared.
		// Heavy Weapons use a different IK setup, and we can't have them on during the transition animation.
		if( PawnOwner.MyGearWeapon.WeaponType == WT_Heavy )
		{
			PawnOwner.BS_SetEarlyAnimEndNotify(BS_MantleUpMirrored, FALSE);
		}
	}
	else
	{
		PawnOwner.BS_Play(BS_MantleUp, SpeedModifier, 0.1f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);
	}

	// Turn on Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_MantleUp, RBA_Translate, RBA_Translate, RBA_Translate);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_MantleUp, TRUE);

	// Turn off collision for flappy bits when mantling up
	if( PawnOwner.Mesh.PhysicsAssetInstance != None )
	{
		PawnOwner.Mesh.PhysicsAssetInstance.SetFullAnimWeightBlockRigidBody(FALSE, PawnOwner.Mesh);
	}

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
	PawnOwner.SetPhysics(PHYS_Flying);
	PawnOwner.SetBase( PawnOwner.ClampedBase );

	PawnOwner.SoundGroup.PlayEffort(PawnOwner, GearEffort_MantleEffort, true);
	PawnOwner.SoundGroup.PlayFoleySound(PawnOwner, GearFoley_Body_ClimbUp);
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Re-enable steps smoothing
	PawnOwner.bCanDoStepsSmoothing = PawnOwner.default.bCanDoStepsSmoothing;

	// Turn off mirroring
	PawnOwner.BS_SetMirrorOptions(BS_MantleUpMirrored, FALSE, FALSE, FALSE);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_MantleUpMirrored, RBA_Discard, RBA_Discard, RBA_Discard);

	PawnOwner.BS_SetAnimEndNotify(BS_MantleUp, FALSE);

	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;
	PawnOwner.SetPhysics(Phys_Falling);
	PawnOwner.SetBase( PawnOwner.ClampedBase );

	// Turn on collision again for flappy bits when mantling up
	if( PawnOwner.Mesh.PhysicsAssetInstance != None )
	{
		PawnOwner.Mesh.PhysicsAssetInstance.SetFullAnimWeightBlockRigidBody(TRUE, PawnOwner.Mesh);
	}

	// check for a transition to roadie run
	if (PCOwner != None && NextMove == SM_None)
	{
		if (PCOwner.IsHoldingRoadieRunButton() && PCOwner.CanDoSpecialMove(SM_RoadieRun))
		{
			PawnOwner.QueueRoadieRunMove(false);
		}
	}
}

defaultproperties
{
	BS_MantleUp=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Up")))
	BS_MantleUpMirrored=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Up_Mirrored")))

	bCoverExitMirrorTransition=TRUE
	bCanFireWeapon=FALSE
	bLockPawnRotation=TRUE
	bBreakFromCoverOnEnd=TRUE
	bDisableCollision=TRUE
	bDisableMovement=TRUE
	bUseUnsynchedServerMove=true

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE

	Action={(
			 ActionName=MantleUp,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43))), // A Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=380,V=140,UL=131,VL=98)))	),
			)}

	bMirrorTransitionSafeNotify=TRUE

	LandCheckOffset=(X=47.52,Y=15.64,Z=93.85)
}
