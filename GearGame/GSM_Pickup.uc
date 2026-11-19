
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Pickup extends GSM_BasePlaySingleAnim;

// Animations
var BodyStance BS_PickupWeapon, BS_KickUpWeapon, BS_PickupHeavyWeapon, BS_LockerGrabWeapon;
var CameraAnim PickupCameraAnim, KickupCameraAnim;
// Actor to pickup.
var Actor PickupActor;

enum EPickupType
{
	ePT_Pickup,
	ePT_KickUp,
	ePT_PickupHeavyWeapon,
	ePT_LockerGrab,
};
var EPickupType PickupType;

protected function bool InternalCanDoSpecialMove()
{
	local bool bHolstering;

	bHolstering = PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.bTemporaryHolster;

	return ( PawnOwner.InvManager != None && (PawnOwner.InvManager.PendingWeapon == None || bHolstering) &&
		!PawnOwner.bDoingMeleeAttack && PawnOwner.Physics != PHYS_RigidBody && !PawnOwner.bUsingCommLink &&
		(PawnOwner.MyGearWeapon == None || PawnOwner.MyGearWeapon.AllowPickupMove()) &&
		(!PawnOwner.bSwitchingWeapons || bHolstering));
}

static function int PackSpecialMoveFlags(EPickupType InPickupType)
{
	local int Flags;

	Flags = int(InPickupType);
	return Flags;
}

function UnPackSpecialMoveFlags()
{
	PickupType = EPickupType(PawnOwner.SpecialMoveFlags);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	UnPackSpecialMoveFlags();

	Super.SpecialMoveStarted(bForced, PrevMove);

	// Trigger the pickup delegates in the GearPC
	if (PCOwner != None)
	{
		PCOwner.TriggerGearEventDelegates(eGED_Pickup);
	}

	if (PickupType != ePT_PickupHeavyWeapon || !PawnOwner.HolsterWeapon())
	{
		PlayPickupAnimation();
	}
}

// Disable call from Special Move started
function PlayAnimation();

/** Play pickup animation when we're ready to do so. */
function PlayPickupAnimation()
{
	switch( PickupType )
	{
		case ePT_LockerGrab :
			BS_Animation = BS_LockerGrabWeapon;
			PlayCameraAnim(PawnOwner, PickupCameraAnim,,, 0.25f, 0.25f);
			PawnOwner.SetTimer( 0.42f, FALSE, nameof(DoPickUp), Self );
			break;

		case ePT_Pickup :
			BS_Animation = BS_PickupWeapon;
			PlayCameraAnim(PawnOwner, PickupCameraAnim,,, 0.25f, 0.25f);
			PawnOwner.SetTimer( 0.42f, FALSE, nameof(DoPickUp), Self );
			break;

		case ePT_KickUp :
			BS_Animation = BS_KickUpWeapon;
			PlayCameraAnim(PawnOwner, KickupCameraAnim,,, 0.25f, 0.25f);
			PawnOwner.IKBoneCtrl_LeftHand.SetSkelControlActive(FALSE);
			PawnOwner.IKBoneCtrl_RightHand.SetSkelControlActive(FALSE);
			PawnOwner.SetTimer( 0.11f, FALSE, nameof(DoPickUp), Self );
			break;

		case ePT_PickupHeavyWeapon :
			BS_Animation = BS_PickupHeavyWeapon;
			PlayCameraAnim(PawnOwner, PickupCameraAnim,,, 0.25f, 0.25f);
			PawnOwner.SetTimer( 0.52f, FALSE, nameof(DoPickUp), Self );
			PawnOwner.SoundGroup.PlayEffort(PawnOwner, GearEffort_LiftHeavyWeaponEffort);
			break;
	}

	Super.PlayAnimation();

	// failsafe in case the pickup gets destroyed out from under us or other unexpected failures
	PawnOwner.SetTimer(3.0, false, nameof(EndThisSpecialMove), self);
}

function WeaponTemporarilyHolstered()
{
	PlayPickupAnimation();
}

function DoPickUp()
{
	PawnOwner.GrabPickup(PickupActor);
}

function TryToPutDownNotify()
{
	if (PickupType == ePT_PickupHeavyWeapon)
	{
		HeavyWeaponCancelTemporaryHolster();
	}
}

function HeavyWeaponCancelTemporaryHolster()
{
	local GearWeapon PendingWeapon;

	// Little hack to have the Pawn switch to his new weapon.
	// Make this temporaty holster a permanent one!
	if (PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.bTemporaryHolster)
	{
		PendingWeapon = GearWeapon(PawnOwner.InvManager.PendingWeapon);
		if (PendingWeapon != None && PendingWeapon.WeaponType == WT_Heavy)
		{
			PawnOwner.MyGearWeapon.bTemporaryHolster = FALSE;
			if (PawnOwner.MyGearWeapon.IsInState('WeaponPuttingDown'))
			{
				PawnOwner.MyGearWeapon.WeaponIsDown();
			}
		}
		else
		{
			PawnOwner.UnHolsterWeapon();
		}
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	if (PawnOwner.IsTimerActive('DoPickUp', self))
	{
		PawnOwner.ClearTimer('DoPickUp', self);
		DoPickUp();
	}

	// If we've been aborted, and we were holstering our weapon, unholster it.
	if (PickupType == ePT_PickupHeavyWeapon)
	{
		HeavyWeaponCancelTemporaryHolster();
	}

	PawnOwner.IKBoneCtrl_LeftHand.SetSkelControlActive(true);
	PawnOwner.IKBoneCtrl_RightHand.SetSkelControlActive(true);

	Super.SpecialMoveEnded(PrevMove, NextMove);

	PickupActor = None;

	// check for rr transition for clifford
	if( PCOwner != None && PCOwner.IsHoldingRoadieRunButton() &&
		PawnOwner != None && PawnOwner.PendingSpecialMoveStruct.SpecialMove == SM_None )
	{
		if (PCOwner.CanDoSpecialMove(SM_RoadieRun))
		{
			PawnOwner.QueueRoadieRunMove(false);
		}
	}
}

function bool CanChainMove(ESpecialMove NextMove)
{
	return NextMove == SM_RoadieRun;
}

/**
 * Block DBNO if we're picking up a heavy weapon
 *
 * @return true if DBNO should be delayed
 */
function bool CanDelayDBNO()
{
	return (PickupType == ePT_PickupHeavyWeapon || Super.CanDelayDBNO());
}

defaultproperties
{
	bShouldAbortWeaponReload=false
	bCanFireWeapon=false
	bDisableMovement=true
	bLockPawnRotation=true
	bDeferWeaponSwitch=true

	BS_PickupWeapon=(Stance=((Slot=BS_FullBody,AnimName="AR_Idle_Ready_Pickup")))
	BS_KickUpWeapon=(Stance=((Slot=BS_FullBody,AnimName="AR_Idle_Ready_Kickup")))
	BS_PickupHeavyWeapon=(Stance=((Slot=BS_FullBody,AnimName="AR_Idle_Ready_Pickup_HW")))
	BS_LockerGrabWeapon=(Stance=((Slot=BS_FullBody,AnimName="AR_Idle_Ready_LockerGrabLow")))

	PickupCameraAnim=CameraAnim'COG_MarcusFenix.Camera_Anims.Pickup'
	KickupCameraAnim=CameraAnim'COG_MarcusFenix.Camera_Anims.Kickup'
}

