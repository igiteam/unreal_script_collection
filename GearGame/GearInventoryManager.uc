/**
 * GearInventoryManager
 * Gear inventory definition
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearInventoryManager extends InventoryManager
	config(Weapon)
	DependsOn(GearTypes,GearWeapon)
	native(Weapon);

/** Player Accuracy.
 * A modifier (scalar) that defines player accuracy.  Note that this is a value
 * in the range [0..1] denoting "most accurate" to "least accurate" (hence normalized accuracy).
 * Actual accuracy is computed using this in subsequent code.
 * Modifier is defined by several parameters such as player speed, posture, targetting mode etc..
 * Accuracy is then used for weapon firing and other things like affecting recoil.
 */
var	protectedwrite	float			Accuracy;

/** last player view rotation, to affect accuracy */
var	transient	rotator			AccuracyLastViewRot;


/** true if player is in weapon selection interface */
var				bool	bShowWeaponSlots;
/** time out after which the weapon selection screen closes */
var				float	WeapSelHUDTimeOut;
/** counter for the above */
var				float	WeapSelHUDTimeCount;
/** Speed multiplier of how fast the weapon indicators will fade out */
var				float	WeapSelHUDTimeCountSpeedMult;

/** which weapon slot is currently highlighted */
var				GearPawn.EAttachSlot HighlightedWeaponSlot;

/** Reference to the HUD */
var				HUD		TheHUD;

/** The linear order of the inventory slots for weapon switching */
var array<GearPawn.EAttachSlot> LinearSlotOrder;

/** TRUE to allow >4 weapons to be carried at once.  For debug only. */
var				bool	bDebugIgnoreWeaponCountLimit;

/** Weapon we had equipped before the current one. */
var transient GearWeapon PreviousEquippedWeapon;

/** Reference to any shield we're carrying. */
var transient GearShield Shield;

/** At what absolute pitch to toss dropped inventory items. */
var() const int InventoryTossPitch;
/** At what speed to toss dropped inventory items. */
var() const int InventoryTossSpeed;

/** allows pawns that do not require accuracy updates to forego them */
var bool bSkipAccuracyUpdates;

cpptext
{
	virtual void TickSpecial( FLOAT DeltaTime );
	void UpdatePlayerAccuracy( FLOAT DeltaTime );
};

/**
 * We override this so we do not auto switch weapons when we drop a weapon.
 *
 * NOTE:  IF we want this type of functionality we need to pass in a contextObject
 *        with something like:  rangeOfTarget, targetResistences etc.  So we can
 *        decide wether to use a sniper rifle or a shotgun.  A single "goodness" rating
 *        is not enough.
 **/
simulated function SwitchToBestWeapon( optional bool bForceADifferentWeapon );

simulated protected function Weapon DecideWhichWeaponToAutoSwitchTo()
{
	local GearWeapon WeapRight;
	local GearWeapon WeapLeft;
	local GearWeapon WeapBelt;
	local GearPawn GP;

	GP = GearPawn(Owner);

	if (GP.IsCarryingShield())
	{
		// favor one-handed (e.g. pistol)
		WeapBelt = GearWeapon(GetInventoryInSlot( EASlot_Holster ));
		if( (WeapBelt != None) && WeapBelt.HasAnyAmmo() == TRUE )
		{
			return WeapBelt;
		}
	}

	// if currently wielding a heavy or grenade, return to previous weapon
	if( PreviousEquippedWeapon != None &&
		(GP.Weapon == None || GP.MyGearWeapon.WeaponType == WT_Heavy || GP.MyGearWeapon.WeaponType == WT_Item) &&
		PreviousEquippedWeapon.CharacterSlot != EASlot_None &&
		PreviousEquippedWeapon.HasAnyAmmo() &&
		GearWeap_GasTankBase(PreviousEquippedWeapon) == None)
	{
		return PreviousEquippedWeapon;
	}

	// else check the slots in priority order
	WeapRight = GearWeapon(GetInventoryInSlot( EASlot_RightShoulder ));
	if( (WeapRight != None) && WeapRight.HasAnyAmmo() == TRUE && GearWeap_GasTankBase(WeapRight) == None )
	{
		return WeapRight;
	}

	WeapLeft = GearWeapon(GetInventoryInSlot( EASlot_LeftShoulder ));
	if( (WeapLeft != None) && WeapLeft.HasAnyAmmo() == TRUE && GearWeap_GasTankBase(WeapLeft) == None )
	{
		return WeapLeft;
	}

	WeapBelt = GearWeapon(GetInventoryInSlot( EASlot_Holster ));
	if( (WeapBelt != None) && WeapBelt.HasAnyAmmo() == TRUE )
	{
		return WeapBelt;
	}

	if( (WeapRight != None) && WeapRight.HasSpareAmmo() == TRUE && GearWeap_GasTankBase(WeapRight) == None )
	{
		return WeapRight;
	}

	if( (WeapLeft != None) && WeapLeft.HasSpareAmmo() == TRUE && GearWeap_GasTankBase(WeapLeft) == None )
	{
		return WeapLeft;
	}

	if( (WeapBelt != None) && WeapBelt.HasSpareAmmo() == TRUE )
	{
		return WeapBelt;
	}

	// we have failed to find any weapons with ammo or spare ammo so switch to the pistol, because that is the only weapon that cannot be dropped
	return WeapBelt;
}

simulated function AutoSwitchWeapon()
{
	local Weapon W;

	if (WorldInfo.NetMode != NM_Client || (Instigator != None && Instigator.IsLocallyControlled()))
	{
		W = DecideWhichWeaponToAutoSwitchTo();
		`LogInv("Found Weapon:" @ W @ "CurrentWeapon:" @ Instigator.Weapon );
		if (W != None)
		{
			SetCurrentWeapon(W);
		}
		else
		{
			NextWeapon();
		}
	}
}


/**
 * Switches to Previous weapon
 * Network: Client
 */
simulated function PrevWeapon()
{
	if( GearWeapon(Pawn(Owner).Weapon) != None && GearWeapon(Pawn(Owner).Weapon).DoOverridePrevWeapon() )
	{
		return;
	}

	super.PrevWeapon();
}

/**
 *	Switches to Next weapon
 *	Network: Client
 */
simulated function NextWeapon()
{
	if( GearWeapon(Pawn(Owner).Weapon) != None && GearWeapon(Pawn(Owner).Weapon).DoOverrideNextWeapon() )
	{
		return;
	}

	super.NextWeapon();
}

/** Get the next slot for weapon switching */
simulated function GearPawn.EAttachSlot GetNextSlot( GearPawn.EAttachSlot CurSlot )
{
	return GetAdjacentSlot( CurSlot, 1 );
}

/** Get the previous slot for weapon switching */
simulated function GearPawn.EAttachSlot GetPrevSlot( GearPawn.EAttachSlot CurSlot )
{
	return GetAdjacentSlot( CurSlot, -1 );
}

/** Finds the next or previous slot for weapon switching without wrapping */
simulated function GearPawn.EAttachSlot GetAdjacentSlot( GearPawn.EAttachSlot CurSlot, int Dir )
{
	local int CurIdx, Idx;

	CurIdx = Max( LinearSlotOrder.Find( CurSlot ), 0);
	Idx = CurIdx;

	do
	{
		// Don't wrap to other side of the menu
		Idx += Dir;
		if( (Idx < 0) || (Idx >= LinearSlotOrder.Length) )
		{
			return LinearSlotOrder[CurIdx];
		}

		if( GetInventoryInSlot(LinearSlotOrder[Idx]) != None )
		{
			return LinearSlotOrder[Idx];
		}
	}
	until ( Idx == CurIdx );


	return LinearSlotOrder[CurIdx];
}

/** Hook called from HUD actor. Gives access to HUD and Canvas */
simulated function DrawHUD( HUD H )
{
	local GearPawnRidable_Base RidablePawn;

	// do not draw inventory HUD if we're not viewing our character.
	if (Owner == None ||
		PlayerController(Pawn(Owner).Controller) == None ||
		Owner != PlayerController(Pawn(Owner).Controller).ViewTarget)
	{
		// If the driver of a ridable pawn is the viewtarget don't return
		RidablePawn = Owner != None ? GearPawnRidable_Base(Owner.Base) : None;
		if (RidablePawn == None ||
			RidablePawn.Driver == None ||
			RidablePawn.Driver != PlayerController(RidablePawn.Controller).ViewTarget)
		{
			return;
		}
	}

	//H.Canvas.SetPos( 200, 200 );
	//H.Canvas.DrawText( "Recoil"@WeaponRecoilOffset@"AutoCorrect"@AutoCorrectWeaponRecoilOffset );

	super.DrawHUD( H );
	DrawWeaponSlots( H );
	TheHUD = H;
}


/** Draw Weapon Slots during selection */
simulated function DrawWeaponSlots( HUD H )
{
	local GearHUD_Base	wfHUD;
	local float		AlphaPct;

	// update fade out timer
	if (!bShowWeaponSlots)
	{
		// already faded out
		if (WeapSelHUDTimeCount == -1)
		{
			// don't bother rendering
			return;
		}
		// otherwise increment the counter
		WeapSelHUDTimeCount += H.RenderDelta * WeapSelHUDTimeCountSpeedMult;
		if( WeapSelHUDTimeCount >= WeapSelHUDTimeOut )
		{
			WeapSelHUDTimeCount	= -1;
		}
	}
	AlphaPct = (WeapSelHUDTimeCount / WeapSelHUDTimeOut);
	AlphaPct = 1.f - AlphaPct * AlphaPct;
	wfHUD = GearHUD_Base(H);

	DrawCircularWeaponSlots( wfHUD, AlphaPct );
}

/** Draw the keyboard/mouse straight vertical line selection UI */
simulated function DrawLinearWeaponSlots( GearHUD_Base wfHUD, float AlphaPct )
{
	local GearPC	PC;
	local GearPawn	WP;
	local GearWeapon Weap;
	local byte 		Alpha;
	local bool		bHighlight;
	local float		DrawX, DrawY, FrameSizeY;
	local float		WeaponCenterX, WeaponCenterY, WeaponScale;
	local int		Idx;

	if( wfHUD == None )
		return;

	WeaponScale = 0.85f;
	PC = GearPC(Instigator.Controller);
	WP = GearPawn(Instigator);

	CalculateWeaponSlotCenter( WeaponCenterX, WeaponCenterY, wfHUD, WeaponScale );

	FrameSizeY = (wfHUD.WeaponInfoFrame.VL/2)*WeaponScale;
	DrawY = WeaponCenterY - FrameSizeY ;
	DrawX = 16.f;

	for( Idx = 0; Idx < LinearSlotOrder.length; Idx++ )
	{
		Weap = GearWeapon(GetInventoryInSlot(LinearSlotOrder[Idx]));
		if (Weap != None)
		{
			bHighlight = (HighlightedWeaponSlot == LinearSlotOrder[Idx]) ? TRUE : FALSE;
			Alpha = 255 * AlphaPct * (Weap.HasAnyAmmo() ? 1.f : 0.5f);
			wfHUD.DrawWeaponInfo(PC, WP, Weap, DrawX, DrawY, Alpha, WeaponScale, 1.2f, bHighlight);
		}
		else
		{
			Alpha = 255 * AlphaPct * 0.3f;
			wfHUD.DrawWeaponInfo(PC, WP, None, DrawX, DrawY, Alpha, WeaponScale, 1.2f, false,false, true);
		}

		DrawY += (FrameSizeY * 2.f) + 16.f;
	}

}

simulated function byte CalculateSlotAlpha(GearWeapon Weap, float AlphaPct)
{
	if (Weap != none)
	{
		return 	255 * AlphaPct * ((Weap.HasAnyAmmo() && GearWeap_GasTankBase(Weap) == None) ? 1.f : 0.5f);
	}
	else
	{
		return 255 * AlphaPct * 0.3f;
	}
}

/** Draw the console circular weapon selection UI */
simulated function DrawCircularWeaponSlots( GearHUD_Base wfHUD, float AlphaPct )
{
	local GearPC		PC;
	local GearPawn	WP;
	local GearWeapon Weap;
	local byte 		Alpha;
	local bool		bHighlight;
	local float		WeaponCenterX, WeaponCenterY, WeaponScale, FrameScale;
	local float     FontCalcX, FontCalcY;
	local float     DrawX, DrawY;

	if( wfHUD == None )
		return;

	WeaponScale = 0.85f;
	FrameScale = 1.2f;
	PC = GearPC(Instigator.Controller);
	WP = GearPawn(Instigator);


	wfHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
	wfHUD.Canvas.TextSize( "W", FontCalcX, FontCalcY );

	CalculateWeaponSlotCenter( WeaponCenterX, WeaponCenterY, wfHUD, WeaponScale*FrameScale );

	Weap = GearWeapon(GetInventoryInSlot(EASlot_Belt));
	Alpha = CalculateSlotAlpha(Weap,AlphaPct);
	DrawX = WeaponCenterX - (wfHUD.WeaponInfoFrame.UL/2)*WeaponScale*FrameScale;
	DrawY = WeaponCenterY - 8.f - (wfHUD.WeaponInfoFrame.VL*1.5f)*WeaponScale*FrameScale;
	DrawY -= FontCalcY;
	if (Weap != None)
	{
		bHighlight = (HighlightedWeaponSlot == EASlot_Belt) ? TRUE : FALSE;
		wfHUD.DrawWeaponInfo(PC, WP, Weap, DrawX, DrawY, Alpha, WeaponScale, FrameScale, bHighlight);

		wfHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		`SetHUDDrawColorExt(wfHUD,wfHUD.HudColors[eWARHUDCOLOR_WHITE],Alpha);
		wfHUD.DrawCenteredText( WeaponCenterX, DrawY-FontCalcY, Weap.ItemName );
	}
	else
	{
		wfHUD.DrawWeaponInfo(PC, WP ,None, DrawX, DrawY, Alpha, WeaponScale, FrameScale, false, false, true);
	}

	Weap = GearWeapon(GetInventoryInSlot(EASlot_Holster));
	Alpha = CalculateSlotAlpha(Weap,AlphaPct);
	DrawX = WeaponCenterX - (wfHUD.WeaponInfoFrame.UL/2)*WeaponScale*FrameScale;
	DrawY = WeaponCenterY + 8.f + (wfHUD.WeaponInfoFrame.VL/2)*WeaponScale*FrameScale;
	DrawY += FontCalcY;
	if (Weap != None)
	{
		bHighlight = (HighlightedWeaponSlot == EASlot_Holster) ? TRUE : FALSE;
		wfHUD.DrawWeaponInfo(PC, WP, Weap, DrawX, DrawY, Alpha, WeaponScale, FrameScale, bHighlight);

		wfHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		`SetHUDDrawColorExt(wfHUD,wfHUD.HudColors[eWARHUDCOLOR_WHITE],Alpha);
		wfHUD.DrawCenteredText( WeaponCenterX, DrawY-FontCalcY, Weap.ItemName );
	}
	else
	{
		wfHUD.DrawWeaponInfo(PC, WP ,None, DrawX, DrawY, Alpha, WeaponScale, FrameScale, false, false, true);
	}

	Weap = GearWeapon(GetInventoryInSlot(EASlot_LeftShoulder));
	Alpha = CalculateSlotAlpha(Weap,AlphaPct);
	DrawX = WeaponCenterX - (wfHUD.WeaponInfoFrame.UL*1.25f)*WeaponScale*FrameScale;
	DrawY = WeaponCenterY - (wfHUD.WeaponInfoFrame.VL/2)*WeaponScale*FrameScale;
	if (Weap != None)
	{
		bHighlight = (HighlightedWeaponSlot == EASlot_LeftShoulder) ? TRUE : FALSE;
		wfHUD.DrawWeaponInfo(PC, WP, Weap, DrawX, DrawY, Alpha, WeaponScale, FrameScale, bHighlight);

		wfHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		`SetHUDDrawColorExt(wfHUD,wfHUD.HudColors[eWARHUDCOLOR_WHITE],Alpha);
		wfHUD.DrawCenteredText( DrawX + (wfHUD.WeaponInfoFrame.UL/2)*WeaponScale*FrameScale, DrawY-FontCalcY, Weap.ItemName );
	}
	else
	{
		wfHUD.DrawWeaponInfo(PC, WP ,None, DrawX, DrawY, Alpha, WeaponScale, FrameScale, false, false, true);
	}

	Weap = GearWeapon(GetInventoryInSlot(EASlot_RightShoulder));
	Alpha = CalculateSlotAlpha(Weap,AlphaPct);
	DrawX = WeaponCenterX + (wfHUD.WeaponInfoFrame.UL*0.25)*WeaponScale*FrameScale;
	DrawY = WeaponCenterY - (wfHUD.WeaponInfoFrame.VL/2)*WeaponScale*FrameScale;
	if (Weap != None)
	{
		bHighlight = (HighlightedWeaponSlot == EASlot_RightShoulder) ? TRUE : FALSE;
		wfHUD.DrawWeaponInfo(PC, WP, Weap, DrawX, DrawY, Alpha, WeaponScale, FrameScale, bHighlight);

		wfHUD.Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro20);
		`SetHUDDrawColorExt(wfHUD,wfHUD.HudColors[eWARHUDCOLOR_WHITE],Alpha);
		wfHUD.DrawCenteredText( DrawX + (wfHUD.WeaponInfoFrame.UL/2)*WeaponScale*FrameScale, DrawY-FontCalcY, Weap.ItemName );
	}
	else
	{
		wfHUD.DrawWeaponInfo(PC, WP ,None, DrawX, DrawY, Alpha, WeaponScale, FrameScale, false, false, true);
	}
}

/**
 * Calculate the center point of where the 4 weapon indicators should draw.
 */
simulated function CalculateWeaponSlotCenter( out float WeaponCenterX, out float WeaponCenterY, GearHUD_Base wfHUD, float WeaponScale )
{
	local GameViewportClient VPClient;
	local int LocalPlayerIndex;

	VPClient = LocalPlayer(wfHUD.PlayerOwner.Player).ViewportClient;
	WeaponCenterX = wfHUD.SafeZoneFriendlyCenterX;
	WeaponCenterY = wfHUD.SafeZoneFriendlyCenterY;
	LocalPlayerIndex = VPClient.ConvertLocalPlayerToGamePlayerIndex( LocalPlayer(wfHUD.PlayerOwner.Player) );

	if ( LocalPlayerIndex != -1 )
	{
		switch ( VPClient.GetSplitscreenConfiguration() )
		{
			case eSST_2P_HORIZONTAL:
			case eSST_3P_FAVOR_TOP:
			case eSST_3P_FAVOR_BOTTOM:
			case eSST_4P:
				WeaponCenterX = wfHUD.SafeZoneFriendlyCenterX + wfHUD.WeaponInfoFrame.UL*1.25f*WeaponScale;
				WeaponCenterY = wfHUD.SafeZoneFriendlyCenterY + wfHUD.WeaponInfoFrame.VL*WeaponScale;
				break;

			case eSST_2P_VERTICAL:
				if ( LocalPlayerIndex == 0 )
				{
					WeaponCenterX = wfHUD.Canvas.ClipX - wfHUD.WeaponInfoFrame.UL*1.25f*WeaponScale - 5;
				}
				else
				{
					WeaponCenterX = wfHUD.WeaponInfoFrame.UL*1.25f*WeaponScale + 5;
				}
				WeaponCenterY = wfHUD.SafeZoneFriendlyCenterY + wfHUD.WeaponInfoFrame.VL*WeaponScale;
				break;
		}
	}
}

/**
 * Updates which weapon slot is the "highlighted" one.
 */
simulated function SetHighlightedWeaponSlot( GearPawn.EAttachSlot Slot )
{
	local GearHUD_Base wfHUD;

	if (Slot != HighlightedWeaponSlot && GetInventoryInSlot(Slot) != none)
	{
		wfHUD = GearHUD_Base(TheHUD);
		if( wfHUD != None )
		{
			wfHUD.ClearWeaponSelectData();
		}

		if( (!GearPawn(Owner).bQuietWeaponEquipping)
			&& (!GearPC(GearPawn(Owner).Controller).bCinematicMode)
			&& ((WorldInfo.Game == None) || !WorldInfo.Game.bWaitingToStartMatch)
			)
		{
			//`log( "highlight bQuietWeaponEquipping: " $ GearPawn(Owner).bQuietWeaponEquipping );
			PlaySound(SoundCue'Interface_Audio.Interface.WeaponSelectHighlightCue', true);
		}

		HighlightedWeaponSlot = Slot;
	}
}


/**
 * Find inventory that matches a given slot.
 * Network: Local Player and Server
 */
simulated function Inventory GetInventoryInSlot( GearPawn.EAttachSlot Slot )
{
	local Inventory	Inv;
	local GearWeapon Weap;

	ForEach InventoryActors( class'Inventory', Inv )
	{
		Weap = GearWeapon(Inv);
		if ( (Weap != None) && (Weap.CharacterSlot == Slot) )
		{
			return Inv;
		}
	}
	return None;
}

/**
 * Sets weapon from a specified inventory slot, as the active one.
 * Network: Local Player
 */
simulated function SetWeaponFromSlot(GearPawn.EAttachSlot Slot)
{
	local GearWeapon	Weap;

	Weap = GearWeapon(GetInventoryInSlot(Slot));
	if (Weap != None)
	{
		// check to see if we have any ammo in the slot we are about to switch to
		// @note WorldInfo.Game == None on clients.
		if (WorldInfo.Game != None && !Weap.HasAnyAmmo() && !Weap.bInfiniteSpareAmmo)
		{
			Weap.PlayNeedsAmmoChatter();
		}

		// bring up the weapon if its not a gas tank
		if ((Weap.HasAnyAmmo() || Weap.bCanSelectWithoutAmmo) && GearWeap_GasTankBase(Weap) == None)
		{
			SetCurrentWeapon(Weap);
		}
	}
}

/** Switch equipped weapon to a one-hander. */
simulated function SwitchToOneHandedWeapon()
{
	local GearWeapon GW;
	local GearWeapon BestOneHandedWeapon;

	// selection criteria: pistols are preferable to grenades
	ForEach InventoryActors(class'GearWeapon', GW)
	{
		// Slave weapons are stale if they're in EASlot_None
		if (GW.bCanEquipWithShield && GW.CharacterSlot != EASlot_None)
		{
			if (BestOneHandedWeapon == None)
			{
				BestOneHandedWeapon = GW;
			}
			else if (GearWeap_GrenadeBase(BestOneHandedWeapon) != None)
			{
				if ( (GearWeap_PistolBase(GW) != None) && GW.HasAnyAmmo() )
				{
					BestOneHandedWeapon = GW;
				}
			}
		}
	}

	if (BestOneHandedWeapon != None)
	{
		SetCurrentWeapon(BestOneHandedWeapon);
	}
}

simulated final function GearPawn.EAttachSlot GetSlotFromType(class<GearWeapon> WeapClass)
{
	if (WeapClass != None)
	{
		switch( WeapClass.default.WeaponType )
		{
		case WT_Item :
			return EASlot_Belt;

		case WT_Holster :
			return EASlot_Holster;

		case WT_Normal :
			if( GetInventoryInSlot(EASlot_RightShoulder) == None )
			{
				return EASlot_RightShoulder;
			}
			return EASlot_LeftShoulder;
		}
	}
	return EASlot_None;
}


/**
 * Find available attachment slot for weapon in inventory
 */
simulated final function GearPawn.EAttachSlot FindFreeSlotForInventoryClass( class<Inventory> InvClass )
{
	local class<GearWeapon> WeapClass;

	WeapClass = class<GearWeapon>(InvClass);
	if (WeapClass != None)
	{
		switch( WeapClass.default.WeaponType )
		{
		case WT_Item :
			if( GetInventoryInSlot(EASlot_Belt) == None )
			{
				return EASlot_Belt;
			}
			break;

		case WT_Holster :
			if( GetInventoryInSlot(EASlot_Holster) == None )
			{
				return EASlot_Holster;
			}
			break;

		case WT_Normal :
			if( GetInventoryInSlot(EASlot_RightShoulder) == None )
			{
				return EASlot_RightShoulder;
			}
			else if( GetInventoryInSlot(EASlot_LeftShoulder) == None )
			{
				return EASlot_LeftShoulder;
			}
			break;
		}
	}


	return EASlot_None;
}


/**
 * If Server in a network game, then replicate CurrentWeapon changes.
 * Do this only when we actually switch weapons
 * As on local player or server, setting PendingWeapon is no guarantee that the weapon will switch right away.
 * So we replicate changes only when the player actually switches to a new weapon.
 */
simulated function ReplicateCurrentWeaponToRemoteClients(Weapon CurrentWeapon, optional bool bHadAPreviousWeapon)
{
	local GearPawn			P;
	local class<GearWeapon>	CurrentWeaponClass;

	P = GearPawn(Owner);
	if( P != None && P.Role == ROLE_Authority )
	{
		if( CurrentWeapon != None )
		{
			CurrentWeaponClass = class<GearWeapon>(CurrentWeapon.class);
		}

		if( P.RemoteWeaponRepInfo.WeaponClass != CurrentWeaponClass )
		{
			// Set up weapon slave replication to remote clients.
			P.RemoteWeaponRepInfo.WeaponClass				= CurrentWeaponClass;
			P.RemoteWeaponRepInfo.BYTE_bHadAPreviousWeapon	= BYTE(bHadAPreviousWeapon);
			P.bForceNetUpdate = TRUE;

			`LogInv("Weapon Class set for replication to remote clients." @ CurrentWeaponClass @ "bHadAPreviousWeapon:" @ bHadAPreviousWeapon);
		}
	}
}


/**
 * Notification called from GearWeapon when the current weapon is being put down.
 */
simulated function PuttingWeaponDown()
{
	local GearPawn P;

	P = GearPawn(Owner);
	// If we're putting our weapon down and we have a PendingWeapon, then replicate this
	// So remote clients can start switching as well.
	// We anticipate the switch, so there is no delay on remote clients.
	// If the switch didn't go as planned, we fix this in ChangedWeapon().
	if( PendingWeapon != None )
	{
		ReplicateCurrentWeaponToRemoteClients(PendingWeapon, (P != None && P.MyGearWeapon != None));
	}
}

/** Player has equipped a new weapon, make sure all clients are synched */
simulated function WeaponEquipped()
{
	if( Instigator.Weapon != None )
	{
		ReplicateCurrentWeaponToRemoteClients(Instigator.Weapon, FALSE);
	}
}

/** @see InventoryManager::ServerChangedWeapon */
simulated function ChangedWeapon()
{
	local GearWeapon				CurrentWeapon;
	local GearPawn.EAttachSlot	DesiredSlot;
	local Weapon				OldWeapon;
	local GearPlayerCamera		GPCam;
	local GearPC				PC;
	local GearPawn				P;

	P	= GearPawn(Owner);
	if(P != none)
	{
		PC	= GearPC(P.Controller);
	}


	// indicate we should draw the weapon indicator
	if( P != None && PC != None )
	{
		PC.SetLastWeaponInfoTime(WorldInfo.TimeSeconds);
	}

	// Save current weapon as old weapon
	OldWeapon = Instigator.Weapon;
	if (GearWeap_HeavyBase(OldWeapon) == None)
	{
		// only save if not a heavy, since heavy's get tossed
		PreviousEquippedWeapon = GearWeapon(OldWeapon);
	}

	// Equip PendingWeapon
	Super.ChangedWeapon();

	// We have now equipped a new weapon so replicate this change to remote clients, to make sure they're in synch
	ReplicateCurrentWeaponToRemoteClients(Instigator.Weapon, (OldWeapon != None));

	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ "Instigator:" @ Instigator @ "Weapon:" @ Instigator.Weapon @ "OldWeapon:" @ OldWeapon);

	if( Role == ROLE_Authority && P != None )
	{
		// if we're switching to a weapon that wasn't assigned a slot, fix it up
		CurrentWeapon = GearWeapon(P.Weapon);
		if( CurrentWeapon != None &&
			CurrentWeapon != OldWeapon &&
			CurrentWeapon.CharacterSlot == EASlot_None )
		{
			//`log( GetFuncName() @ "weapon had no slot, fix it up!!" $ " Pawn: " $ Pawn(Owner) $ " CurrentWeapon: " $ CurrentWeapon $ " OldWeapon: " $ OldWeapon );
			DesiredSlot = FindFreeSlotForInventoryClass(CurrentWeapon.class);
			CurrentWeapon.AssignToSlot(DesiredSlot);
		}

		if (P.IsAKidnapper() && CurrentWeapon != None && CurrentWeapon.CharacterSlot != EASlot_Holster)
		{
			GSM_Kidnapper(P.SpecialMoves[P.SpecialMove]).bEndedByWeaponSwitch = true;
			P.ServerEndSpecialMove();
		}
	}

	if( PC != None )
	{
		GPCam = GearPlayerCamera(PC.PlayerCamera);
		if ( (GPCam != None) && (GPCam.CurrentCamera == GPCam.GameplayCam) )
		{
			GearGameplayCameraMode(GPCam.GameplayCam.CurrentCamMode).WeaponChanged(PC, OldWeapon, Instigator.Weapon);
		}
	}
}


simulated function SetPendingWeapon(Weapon DesiredWeapon)
{
	local GearPawn GP;

	// allow the pawn to be notified that they are receiving inventory
	GP = GearPawn(Instigator);
	if (GP != None)
	{
		GP.EquipingWeaponNotify(GearWeapon(DesiredWeapon));
	}

	super.SetPendingWeapon(DesiredWeapon);
}

/**
 * Tries to find weapon of class ClassName, and switches to it
 *
 * @param	ClassName, class of weapon to switch to
 */
exec simulated function SwitchToWeaponClass( String ClassName, optional bool bCreate )
{
	local Weapon		CandidateWeapon;
	local class<Weapon>	WeapClass;

	WeapClass = class<Weapon>(DynamicLoadObject(ClassName, class'Class'));

	if ( WeapClass != None )
	{
		CandidateWeapon = Weapon(FindInventoryType( WeapClass ));
		if (bCreate && CandidateWeapon == None)
		{
			CandidateWeapon = Weapon(CreateInventory(WeapClass,TRUE));
		}
		if ( CandidateWeapon != None )
		{
			SetCurrentWeapon( CandidateWeapon );
		}
		else
		{
			`log("SwitchToWeaponClass weapon not found in inventory" @ String(WeapClass) );
		}
	}
	else
	{
		`log("SwitchToWeaponClass weapon class not found" @ ClassName );
	}
}

/**
 * This will find the weapon which can use this ammo type and return it;
 *
 * returns none if there are no weapons that can use this ammo type
 */
simulated function GearWeapon FindWeaponThatCanUseThisAmmoType(class<GearAmmoType> AmmoTypeClass)
{
	local GearWeapon Weap;

	ForEach InventoryActors(class'GearWeapon', Weap)
	{
		if( Weap.AmmoTypeClass == AmmoTypeClass )
		{
			return Weap;
		}
	}

	return None;
}


/** Find a carried weapon of weapon type WeaponType */
simulated function GearWeapon FindWeaponOfType(GearWeapon.EWeaponType WeaponType)
{
	local GearWeapon Weap;

	ForEach InventoryActors(class'GearWeapon', Weap)
	{
		if( Weap.WeaponType == WeaponType )
		{
			return Weap;
		}
	}

	return None;
}


/**
 * Returns TRUE if Pawn P can pick up ammo of this AmmoType
 * bExcludeChecks - TRUE = could you have?
 *                - FALSE = you actually can
 */
simulated function bool CanPickUpAmmoType(class<GearAmmoType> AmmoTypeClass, bool bExcludeChecks)
{
	local GearWeapon	Weap;

	// See if we can find this weapon in our inventory
	Weap = FindWeaponThatCanUseThisAmmoType(AmmoTypeClass);
	if( Weap != None && (bExcludeChecks || Weap.CanPickupAmmo()) )
	{
		return TRUE;
	}

	return FALSE;
}


/**
 * Finds out if player is carrying weapon, and adds ammunition if so.
 * Returns TRUE if successful
 */
function bool AddAmmoFromAmmoType(class<GearAmmoType> AmmoTypeClass, float NumMagazines)
{
	local GearWeapon	Weap;
	local int AmmoAmount;

	Weap = FindWeaponThatCanUseThisAmmoType(AmmoTypeClass);
	if( Weap != None &&
		Weap.WeaponMaxSpareAmmo > 0 &&
		Weap.SpareAmmoCount < Weap.WeaponMaxSpareAmmo )
	{
		AmmoAmount = Weap.AddAmmo(Weap.WeaponMagSize * NumMagazines);
		Weap.AddAmmoMessage( AmmoAmount );
		return TRUE;
	}

	return FALSE;
}

/**
 * Finds out if player is carrying weapon, and adds ammunition if so.
 * @param WeaponClass - class of weapon to find
 * @param SpecifiedAmount - amount to add: 0 to add default, > 0 to add absolute, < 0 to add default + extra
 * @param bWasAmmoShare - whether the ammo source is another player sharing ammo
 * @return true if successful
 */
function bool AddAmmoFromWeaponClass(class<GearWeapon> WeaponClass, optional int SpecifiedAmount, optional bool bWasAmmoShare)
{
	local GearWeapon Weap;
	local int AmmoAmount;

	Weap = GearWeapon(FindInventoryType(WeaponClass, true));
	if (Weap != None && Weap.CanPickupAmmo())
	{
		if (SpecifiedAmount == 0)
		{
			SpecifiedAmount = Weap.GetDefaultAmmoAmount();
		}
		else if (SpecifiedAmount < 0)
		{
			SpecifiedAmount = Weap.GetDefaultAmmoAmount() - SpecifiedAmount;
		}

		AmmoAmount = Weap.AddAmmo(SpecifiedAmount);
		Weap.AddAmmoMessage(AmmoAmount, bWasAmmoShare);
		return true;
	}

	return false;
}

/**
 * Finds out if player is carrying weapon, and removes ammunition if so.
 * @return TRUE if successful
 */
function bool RemoveAmmoFromWeaponClass(class<GearWeapon> WeaponClass, int SpecifiedAmount, optional bool bWasAmmoShare)
{
	local GearWeapon Weap;
	local int AmmoAmount;

	Weap = GearWeapon(FindInventoryType(WeaponClass, TRUE));
	if (Weap != None)
	{
		AmmoAmount = Weap.RemoveAmmo(SpecifiedAmount);
		Weap.AddAmmoMessage(-AmmoAmount, bWasAmmoShare);
	}

	return FALSE;
}

/**
 * Returns TRUE is weapon class can be swapped with currently held weapon.
 */
simulated function bool CanSwapWeaponClassWithCurrent(class<GearWeapon> WeaponClass)
{
	// if the weapon is swappable and if weapons are the same type, then no problem
	if( GearWeapon(Instigator.Weapon).bSwappable && GearWeapon(Instigator.Weapon).WeaponType == WeaponClass.default.WeaponType )
	{
		return TRUE;
	}

	return FALSE;
}


/** Make sure Player doesn't carry more than 4 weapons! */
simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
	local int			WeapCount;
	local int			HeavyWeapCount;
	local GearWeapon	Weap;
	local bool			bCreatingHeavyWeap;

	local bool			bDoNotCreate;
	local Inventory		NewInvItem;

	local GearAI		AI;
	local class<GearWeapon> GWClass;

	GWClass = class<GearWeapon>(NewInventoryItemClass);

	// if this is an idea give them a chance to reject it (creatures, etc)
	AI = GearAI(Pawn(Owner).Controller);
	if (AI != None &&
		!AI.AllowWeaponInInventory(GWClass))
	{
		return None;
	}


	// enforce max weapons limits
	if (!bDebugIgnoreWeaponCountLimit)
	{
		// Disable max 4 inventory check for remote clients. As these will carry in their inventory all weapons they've ever switched to.
		if( WorldInfo.NetMode != NM_Client || Instigator.IsLocallyControlled() )
		{
			if (GWClass != None)
			{
				ForEach InventoryActors(class'GearWeapon', Weap)
				{
					if (Weap.WeaponType == WT_Heavy)
					{
						HeavyWeapCount++;
					}
					else
					{
						WeapCount++;
					}
				}

				// can have 4 non-heavy weapons and 1 heavy weapon
				bCreatingHeavyWeap = (GWClass.default.WeaponType == WT_Heavy);
				if (bCreatingHeavyWeap)
				{
					if (HeavyWeapCount >= 1)
					{
						bDoNotCreate = TRUE;
`if(`notdefined(FINAL_RELEASE))
						`log(Instigator @ "already has a heavy weapon!!!!! Aborting Creation of" @ NewInventoryItemClass);
						ScriptTrace();
						`log("Likely coming from USeqAct_AIFactory::UpdateSpawnSets, Set.LoadoutClasses[] ?");
`endif
					}
				}
				else
				{
					if (WeapCount >= 4)
					{
						bDoNotCreate = TRUE;
`if(`notdefined(FINAL_RELEASE))
						`log(Instigator @ "already has 4 weapons!!!!! Aborting Creation of" @ NewInventoryItemClass);
						ScriptTrace();
						`log("Likely coming from USeqAct_AIFactory::UpdateSpawnSets, Set.LoadoutClasses[] ?");
`endif
					}
				}
			}
		}
	}


	if (!bDoNotCreate)
	{
		// create it
		NewInvItem = Super.CreateInventory(NewInventoryItemClass, bDoNotActivate);
	}


	return NewInvItem;
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
	if (Super.AddInventory(NewItem, bDoNotActivate))
	{
		if (NewItem.IsA('GearShield'))
		{
			Shield = GearShield(NewItem);
			`LogInv("Shield set to" @ Shield);
		}
		return true;
	}
	else
	{
		return false;
	}
}

simulated function DiscardClientSideInventory()
{
	local Inventory	Inv;

	if( WorldInfo.NetMode == NM_Client && !bDeleteMe && Instigator != None)
	{
		`LogInv("");

		ForEach InventoryActors(class'Inventory', Inv)
		{
			if( Inv.Role == ROLE_Authority )
			{
				Inv.Destroy();
			}
		}

		// Clear reference to Weapon
		Instigator.Weapon = None;

		// Clear reference to PendingWeapon
		PendingWeapon = None;

		Shield = None;

		Instigator.InvManager = None;

		Instigator = None;

		// destroy locally since this is most likely from a map change and the inv manager is about to be nuked
		// and the client will recreate if needed ttp 113128
		Destroy();
	}
}

/**
 * Overridden to check for GearPawn.bAllowInventoryDrops.
 */
simulated function DiscardInventory()
{
	local Inventory	Inv;
	local vector	TossVelocity;
	local GearPawn GP;

	`LogInv("");

	if (WorldInfo.NetMode != NM_Client)
	{
		GP = GearPawn(Instigator);
		ForEach InventoryActors(class'Inventory', Inv)
		{
			if( (GP == None || GP.bAllowInventoryDrops) && Inv.bDropOnDeath && Instigator != None )
			{
				TossVelocity = vector(Instigator.GetViewRotation());
				TossVelocity = TossVelocity * ((Instigator.Velocity dot TossVelocity) + 500.f) + 250.f * VRand() + vect(0,0,250);
				Inv.DropFrom(Instigator.Location, TossVelocity);
			}
			else
			{
				Inv.Destroy();
			}
		}

		// Clear reference to Weapon
		Instigator.Weapon = None;

		// Clear reference to PendingWeapon
		PendingWeapon = None;

		Shield = None;
	}
	else
	{
		DiscardClientSideInventory();
	}
}

function OwnerDied()
{
	// don't destroy yet as we want to delay for CSHD purposes, @see GearPawn::DelayedDeathDiscardInventory()
}

simulated function float GetWeaponRatingFor(Weapon W)
{
	local GearWeapon GearWeap;

	if (Role < ROLE_Authority && Instigator.Controller == None)
	{
		`Warn("Called on" @ W @ "with Instigator" @ Instigator @ "but no Instigator.Controller!");
	}

	// for human players, prefer weapons based on slot so that autoselect on spawn, etc. is consistent
	GearWeap = GearWeapon(W);
	if (GearWeap != None && Instigator.IsHumanControlled())
	{
		if (!GearWeap.HasAnyAmmo())
		{
			return -1;
		}
		else
		{
			if (GearWeap.WeaponType == WT_Heavy)
			{
				return 5.0;
			}
			switch (GearWeap.CharacterSlot)
			{
				case EASlot_RightShoulder:
					return 4.0;
				case EASlot_LeftShoulder:
					return 3.0;
				case EASlot_Holster:
					return 2.0;
				default:
					return 1.0;
			}
		}
	}
	else
	{
		//debug
		`AILog_Ext( self@GetFuncName()@W@Super.GetWeaponRatingFor(W), 'Weapon', GearAI(Instigator.Controller));

		return Super.GetWeaponRatingFor(W);
	}
}

reliable client function ClientRemoveShieldFromInventory()
{
	Shield = None;
}

simulated function RemoveFromInventory(Inventory ItemToRemove)
{
	local GearPawn P;

	P = GearPawn(Owner);

	if( ItemToRemove == Shield )
	{
		Shield = None;
		ClientRemoveShieldFromInventory();
	}

	// If getting rid of our weapon, then clear reference to it.
	if( P != None && P.MyGearWeapon == ItemToRemove )
	{
		P.MyGearWeapon = None;
		P.Weapon = None;
		// Replicate the weapon thrown, so it clears on clients as well.
		ReplicateCurrentWeaponToRemoteClients(None, FALSE);
	}

	Super.RemoveFromInventory(ItemToRemove);
}

simulated function Inventory FindInventoryByClass(Name ClassName)
{
	local Inventory		Inv;

	ForEach InventoryActors(class'Inventory', Inv)
	{
		if ( Inv.IsA(ClassName) )
		{
			return Inv;
		}
	}

	return None;
}

simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet, optional bool bDoNotActivate)
{
	if (WorldInfo.NetMode != NM_Client || (Instigator != None && Instigator.IsLocallyControlled()))
	{
		Super.ClientWeaponSet(NewWeapon, bOptionalSet, bDoNotActivate);
	}

	// Make sure weapon doesn't get stuck in PendingClientWeaponSet state.
	if( NewWeapon.IsInState('PendingClientWeaponSet') )
	{
		NewWeapon.GotoState('Inactive');
	}
}

defaultproperties
{
	WeapSelHUDTimeOut=1
	PendingFire(0)=0
	PendingFire(1)=0
	PendingFire(2)=0
	PendingFire(3)=0
	PendingFire(4)=0
	PendingFire(5)=0
	WeapSelHUDTimeCount=-1
	WeapSelHUDTimeCountSpeedMult=1.0f

	LinearSlotOrder(0)=EASlot_RightShoulder
	LinearSlotOrder(1)=EASlot_LeftShoulder
	LinearSlotOrder(2)=EASlot_Holster
	LinearSlotOrder(3)=EASlot_Belt

	InventoryTossPitch=-4000
	InventoryTossSpeed=400
}
