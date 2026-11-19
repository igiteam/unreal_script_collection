/**
 * Share ammo coop interaction
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_ShareAmmo extends GearSpecialMove;

/** The pawn that we are sharing ammo with */
var GearPawn AmmoReceiver;

/** The animation to play */
var() GearPawn.BodyStance BS_Animation;

/**
 * Allow sharing ammo while holding a shield
 * 
 * @param InMove - the move to be overridden
 */
function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	if (InMove == SM_DeployShield)
	{
		return TRUE;
	}

	return FALSE;
}

/**
 * Ammo cannot be shared while in cover or DBNO.
 *
 * @return true if ammo can be shared.
 */
protected function bool InternalCanDoSpecialMove()
{
	if (PawnOwner.IsDBNO() || PawnOwner.IsInCover() || PawnOwner.IsFiring())
	{
		return FALSE;
	}

	// trust remote pawns can do this move
	if (!PawnOwner.IsLocallyControlled())
	{
		return TRUE;
	}

	return CanShareAmmo();
}

/** 
 * Can we share ammo with the targeted pawn?
 *
 * @return true if the targeted pawn is acceptable
 */
private function bool CanShareAmmo()
{
	local GearPawn GP;
	local GearPRI PRI;
	local GearWeapon GPWeapon;

	if (PawnOwner.IsCarryingAHeavyWeapon())
	{
		return FALSE;
	}

	// Ammo share is currently in one magazine chunks
	if (PawnOwner.MyGearWeapon.SpareAmmoCount < PawnOwner.MyGearWeapon.WeaponMagSize)
	{
		return FALSE;
	}

	if (GearPC(PawnOwner.Controller) != None)
	{
		GP = GearPC(PawnOwner.Controller).TargetedPawn;
	}

	if (GP != None && VSize(GP.Location - PawnOwner.Location) < PawnOwner.CoopInteractionDistance)
	{
		PRI = GearPRI(GP.PlayerReplicationInfo);
	
		if (PRI == None && GP.DrivenVehicle != None)
		{
			PRI = GearPRI(GP.DrivenVehicle.PlayerReplicationInfo);
		}

		if (!GP.bCanBeBaseForPawns && PRI != none && !PRI.bBot && PawnOwner.IsSameTeam(GP) && !GP.IsDBNO() && !GP.bPlayedDeath && GP.InvManager != None)
		{
			GPWeapon = GearWeapon(GP.InvManager.FindInventoryType(PawnOwner.Weapon.Class));
			if (GPWeapon != None && GPWeapon.CharacterSlot != EASlot_None)
			{
				return TRUE;
			}
		}
	}

	return FALSE;
}

/**
 * Start the body animation when the special move starts.
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 *
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn GP;
	local GearPRI PRI;
	local float BestGPDot;

	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.InterpolatePawnRotation();

	// Only the server needs to run this logic.
	if (PawnOwner.Role == ROLE_Authority)
	{
		AmmoReceiver = none;

		// Find the best candidate to share with
		foreach PawnOwner.VisibleCollidingActors(class'GearPawn', GP, PawnOwner.CoopInteractionDistance, PawnOwner.Location, TRUE)
		{
			PRI = GearPRI(GP.PlayerReplicationInfo);

			if (PRI == None && GP.DrivenVehicle != None)
			{
				PRI = GearPRI(GP.DrivenVehicle.PlayerReplicationInfo);
			}

			if (!GP.bCanBeBaseForPawns && PRI != none && !PRI.bBot && PawnOwner.IsSameTeam(GP) && !GP.IsDBNO() && !GP.bPlayedDeath)
			{
				if (AmmoReceiver == none || vector(PawnOwner.Rotation) dot Normal(GP.Location - PawnOwner.Location) > BestGPDot)
				{
					AmmoReceiver = GP;
					// The angle between our forward vector and the vector to the candidate can be used to determine fitness of the candidate.
					BestGPDot = vector(PawnOwner.Rotation) dot Normal(GP.Location - PawnOwner.Location);
				}
			}
		}
	}

	AlignToActor = AmmoReceiver;

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE );
	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);
}

/**
 * Remove the end of animation notification that was set in SpecialMoveStarted.
 *
 * @param PrevMove - the previous special move to run
 *
 * @param NextMove - the next special move to run
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local vector ToReceiver;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Only the server needs to run this logic.
	if (PawnOwner.Role == ROLE_Authority && AmmoReceiver != none && !AmmoReceiver.IsDBNO())
	{
		// Make sure that the receiver is still in the right place.
		ToReceiver = AmmoReceiver.Location - PawnOwner.Location;

		// Allow the player to move out of the radius just a bit.
		if (vector(PawnOwner.Rotation) dot Normal(ToReceiver) > 0 && VSize(ToReceiver) <= PawnOwner.CoopInteractionDistance * 1.7f)
		{
			PawnOwner.ShareAmmo(AmmoReceiver);
		}
	}

	PawnOwner.InterpolatePawnRotation();

	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);
}

defaultproperties
{	
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableMovement=TRUE

	BS_Animation=(Stance=((Slot=BS_Std_Up,AnimName="AR_AmmoSplit"),(Slot=BS_Std_Idle_Lower,AnimName="AR_AmmoSplit")))
}