/**
 * Offer up a weapon for other players to take
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_TradeWeapons extends GearSpecialMove;

enum TradeOfferStage
{
	ETOS_Start,
	ETOS_Loop,
};
/** The animation to play */
var() GearPawn.BodyStance BS_Animations[3];

/** Action icon for cancelling a coop interaction offer */
var ActionInfo ActionCancelCoopInteractionOffer;

/**
 * Can't trade weapons if in cover or DBNO
 *
 * @return true if can interact
 */
protected function bool InternalCanDoSpecialMove()
{
	if (PawnOwner.IsInCover() || PawnOwner.IsDBNO() || PawnOwner.IsFiring() || PawnOwner.IsDoingASpecialMove())
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

	return CanTradeWeapons();
}

/**
 * Determine if a pawn has a given weapon and verify it's not a stale slave weapon
 * 
 * @param GP - the pawn to inspect
 * 
 * @param GW - the weapon we're looking for
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
 * Check if GP has two shoulder weapons
 * 
 * @param GP - the pawn to check
 * 
 * @return TRUE if GP has two shoulder weapons
 */
function bool PawnHasTwoShoulderWeapons(GearPawn GP)
{
	return (GearInventoryManager(GP.InvManager).GetInventoryInSlot(EASlot_RightShoulder) != None && GearInventoryManager(GP.InvManager).GetInventoryInSlot(EASlot_LeftShoulder) != None);
}

/** 
 * Can we traded with the targeted pawn?
 *
 * @return TRUE if the targeted pawn is acceptable
 */
private function bool CanTradeWeapons()
{
	local GearPawn GP;
	local GearPRI PRI;

	if (PawnOwner.IsCarryingAHeavyWeapon())
	{
		return FALSE;
	}

	if (PawnOwner.MyGearWeapon.CharacterSlot != EASlot_RightShoulder && PawnOwner.MyGearWeapon.CharacterSlot != EASlot_LeftShoulder)
	{
		return FALSE;
	}

	if (GearPC(PawnOwner.Controller) != None)
	{
		GP = GearPC(PawnOwner.Controller).TargetedPawn;
	}

	if (GP != None && !GP.IsDoingASpecialMove() && GP.MyGearWeapon != None && VSize(GP.Location - PawnOwner.Location) < PawnOwner.CoopInteractionDistance)
	{
		if (GP.bWeaponHolstered)
		{
			return FALSE;
		}

		if (!GP.CanDoSpecialMove(SM_TradeWeapons_Follower))
		{
			return FALSE;
		}

		if (GP.MyGearWeapon.CharacterSlot != EASlot_RightShoulder && GP.MyGearWeapon.CharacterSlot != EASlot_LeftShoulder)
		{
			return FALSE;
		}

		if (!GP.bCanBeBaseForPawns && PawnOwner.IsSameTeam(GP) && !GP.IsDBNO() && !GP.bPlayedDeath)
		{
			if (!PawnHasWeapon(GP, PawnOwner.MyGearWeapon.Class) && !PawnHasWeapon(PawnOwner, GP.MyGearWeapon.Class))
			{
				return TRUE;
			}
		}

		// If we have the weapon the bot is trading, we just get their ammo
		// The bot needs to have two shoulder weapons
		PRI = GearPRI(GP.PlayerReplicationInfo);
		if (PRI != None && PRI.bBot && PawnHasWeapon(PawnOwner, GP.MyGearWeapon.Class) && PawnHasTwoShoulderWeapons(GP))
		{
			return TRUE;
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
	Super.SpecialMoveStarted(bForced,PrevMove);

	PlayAnimation(ETOS_Start);
	
	if (PawnOwner.IsLocallyControlled() && PCOwner != None)
	{
		PCOwner.MyGearHud.ClearActionInfoByType(AT_Player);
		PCOwner.MyGearHud.SetActionInfo(AT_SpecialMove, ActionCancelCoopInteractionOffer);
	}
	
	PlayGUD();
}

simulated function PlayGUD()
{
	// notify guds
	if (PawnOwner.WorldInfo.Game != None)
	{
		GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_SwapWeaponsAnnounce, PawnOwner);
	}

	PawnOwner.SetTimer(RandRange(3, 5), FALSE, 'PlayGUD', self);
}
/** 
 * Loop the animation or play the ending animation as necessary
 * 
 * @param SeqNode - the animation that just ended
 * 
 * @param PlayedTime - the length of the animation that just ended
 * 
 * @param ExcessTime - the amount of time passed the animation length
 */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	PlayAnimation(ETOS_Loop);
}

simulated function FinishSpecialMove()
{
	// Clear any leftover timer so we don't re-enter
	PawnOwner.ClearTimer('FinishSpecialMove', self);

	if (PawnOwner.IsLocallyControlled())
	{
		// The special move MUST be specified here, failure to do so may cause the server to not end the move
		PawnOwner.LocalEndSpecialMove(SM_TradeWeapons);
	}
}
/**
 * Remove the end of animation notification and force all clients to end this special move.
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 *
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.ClearTimer('PlayGUD', self);

	PawnOwner.BS_Stop(BS_Animations[ETOS_Start], 0.2f);
	PawnOwner.BS_Stop(BS_Animations[ETOS_Loop], 0.2f);
	PawnOwner.BS_SetAnimEndNotify(BS_Animations[ETOS_Start], FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_Animations[ETOS_Loop], FALSE);

	// Because we don't end until the user hits a button, the server and other clients don't always get notified that we're done.
	FinishSpecialMove();
	
	if (PawnOwner.IsLocallyControlled() && PCOwner != None)
	{
		PCOwner.MyGearHUD.ClearActionInfoByType(AT_SpecialMove);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

// Start = 0, Loop = 1, End = 2
simulated function float PlayAnimation(TradeOfferStage ETOS)
{
	local float AnimTime;

	if (ETOS==ETOS_Loop)
	{
		// Play body stance animation.
		AnimTime = PawnOwner.BS_Play(BS_Animations[ETOS], SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, TRUE, TRUE);
	}
	else
	{
		if ( ETOS == ETOS_Start )
		{
			PawnOwner.SoundGroup.PlayFoleySound(PawnOwner, GearFoley_Body_Aim);
		}
		else
		{
			PawnOwner.SoundGroup.PlayFoleySound(PawnOwner, GearFoley_ArmLower);
		}

		// Play body stance animation.
		AnimTime = PawnOwner.BS_Play(BS_Animations[ETOS], SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);
		// Enable end of animation notification.
		PawnOwner.BS_SetAnimEndNotify(BS_Animations[ETOS], TRUE);
	}

	return AnimTime;
}

/** 
 * Allow the player to exit out of the offer
 * 
 * @param ButtonName - the button pushed
 * 
 * @return true if we processed the button
 */
function bool ButtonPress(name ButtonName)
{
	if (ButtonName == 'B')
	{
		FinishSpecialMove();
		return true;
	}
	else
	{
		return Super.ButtonPress(ButtonName);
	}
}

defaultproperties
{
	bDisableMovement=TRUE
	bCanFireWeapon=FALSE
	bShouldAbortWeaponReload=TRUE
	bLockPawnRotation=TRUE
	
	BS_Animations(ETOS_Start)=(Stance=((Slot=BS_FullBody,AnimName="AR_TradeWeapons_Offer_Start")))
	BS_Animations(ETOS_Loop)=(Stance=((Slot=BS_FullBody,AnimName="AR_TradeWeapons_Offer_Loop")))

	ActionCancelCoopInteractionOffer={(
		ActionName=CancelCoopInteractionOffer,
		ActionIconDatas=(   (ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=0,UL=45,VL=32))),     // B button
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=411,V=342,UL=49,VL=49))),       // No entry
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=242,V=0,UL=58,VL=55)))   ),  // Swap arrows
		)}
}
