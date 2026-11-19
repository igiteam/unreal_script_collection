/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_TradeWeaponsSecondaryAI extends GSM_InteractionPawnLeader_Base;

/**
 * Determine if a pawn has a given weapon and verify it's not a stale slave weapon
 * 
 * @param GP - the pawn to inspect
 * 
 * @param GWC - the weapon we're looking for
 * 
 * @return TRUE if the weapon is in the pawn's inventory
 */
function bool PawnHasWeapon(GearPawn GP, class<GearWeapon> GWC)
{
	local GearWeapon GW;

	GW = GearWeapon(GP.InvManager.FindInventoryType(GWC));

	// A stale slave weapon will be in EASlot_None
	if (GW != None && GW.CharacterSlot != EASlot_None)
	{
		return TRUE;
	}

	return FALSE;
}

/**
 * Do we have out an acceptable weapon and is there a nearby AI
 *
 * @return true if there is
 */
protected function bool InternalCanDoSpecialMove()
{
	local GearPawn GP;
	local GearWeapon SecondaryWeaponToSwap;

	if (PawnOwner.IsInCover() || PawnOwner.IsDBNO() || PawnOwner.IsFiring())
	{
		return FALSE;
	}

	if (PawnOwner.bSwitchingWeapons)
	{
		return FALSE;
	}
	
	if (PawnOwner.InvManager != None && PawnOwner.InvManager.PendingWeapon != None)
	{
		return FALSE;
	}

	// trust remote pawns can do this move
	if (!PawnOwner.IsLocallyControlled())
	{
		return TRUE;
	}

	if (PawnOwner.IsCarryingAHeavyWeapon())
	{
		return FALSE;
	}

	if (PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.CharacterSlot != EASlot_RightShoulder && PawnOwner.MyGearWeapon.CharacterSlot != EASlot_LeftShoulder)
	{
		return FALSE;
	}

	if (GearPC(PawnOwner.Controller) != None)
	{
		GP = GearPC(PawnOwner.Controller).TargetedPawn;
	}

	if (GP != None && GP.PlayerReplicationInfo.bBot && VSize(GP.Location - PawnOwner.Location) < PawnOwner.CoopInteractionDistance)
	{
		if (GP.MyGearWeapon == None || GP.IsDoingASpecialMove())
		{
			return FALSE;
		}

		if (GP.bWeaponHolstered)
		{
			return FALSE;
		}

		if (!GP.CanDoSpecialMove(SM_TradeWeapons_Follower))
		{
			return FALSE;
		}

		if (GP.MyGearWeapon.CharacterSlot == EASlot_RightShoulder)
		{
			SecondaryWeaponToSwap = GearWeapon(GearInventoryManager(GP.InvManager).GetInventoryInSlot(EASlot_LeftShoulder));
		}
		else if (GP.MyGearWeapon.CharacterSlot == EASlot_LeftShoulder)
		{
			SecondaryWeaponToSwap = GearWeapon(GearInventoryManager(GP.InvManager).GetInventoryInSlot(EASlot_RightShoulder));
		}

		if (SecondaryWeaponToSwap != None && !GP.bCanBeBaseForPawns && PawnOwner.IsSameTeam(GP) && !GP.IsDBNO() && !GP.bPlayedDeath)
		{
			if (!PawnHasWeapon(GP, PawnOwner.MyGearWeapon.Class) && !PawnHasWeapon(PawnOwner, SecondaryWeaponToSwap.Class))
			{
				return TRUE;
			}
			
			// If we have the weapon the bot is trading, we just get their ammo
			if (PawnHasWeapon(PawnOwner, SecondaryWeaponToSwap.Class))
			{
				return TRUE;
			}
		}
	}

	return FALSE;
}

/**
 * Make the AI switch weapons and set a timer to move to the next special move
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 *
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{	
	Super.SpecialMoveStarted(bForced,PrevMove);
	
	if (PawnOwner.Role == ROLE_Authority)
	{
		if (Follower.MyGearWeapon.CharacterSlot == EASlot_RightShoulder)
		{
			GearInventoryManager(Follower.InvManager).SetWeaponFromSlot(EASlot_LeftShoulder);
		}
		else if (Follower.MyGearWeapon.CharacterSlot == EASlot_LeftShoulder)
		{
			GearInventoryManager(Follower.InvManager).SetWeaponFromSlot(EASlot_RightShoulder);
		}
		
		PawnOwner.SetTimer(0.75f, FALSE, nameof(SwapWeapons), Self);
	}
}

/** Set the align distance */
function StartInteraction()
{
	if (PawnOwner.SpecialMoveFlags == 2)
	{
		AlignDistance = VSize(PawnOwner.Location-Follower.Location);
	}
	else
	{
		AlignDistance = 75;
	}
}

/** Switch to the actual swap special move */
function SwapWeapons()
{	
	Follower.WeaponForWeaponSwap = Follower.MyGearWeapon;
	PawnOwner.ServerDoSpecialMove(SM_TradeWeapons_Leader, TRUE, Follower, PawnOwner.SpecialMoveFlags);
}

defaultproperties
{
	bAlignPawns=TRUE

	FollowerSpecialMove=SM_TradeWeapons_Follower
}