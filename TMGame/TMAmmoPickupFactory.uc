/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// Ammo.
//=============================================================================
class TMAmmoPickupFactory extends TMItemPickupFactory
	native
	abstract;

/** The amount of ammo to give */
var int AmmoAmount;
/** The class of the weapon this ammo is for. */
var class<TMWeapon> TargetWeapon;

/** set when TransformAmmoType() has been called on this ammo pickup to transform it into a different kind, to notify clients */
var repnotify class<TMAmmoPickupFactory> TransformedClass;

replication
{
	if (bNetInitial)
		TransformedClass;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'TransformedClass')
	{
		TransformAmmoType(TransformedClass);
		if (bPickupHidden )
		{
			SetPickupHidden();
		}
		else
		{
			SetPickupVisible();
		}
		InitPickupMeshEffects();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

function SpawnCopyFor( Pawn Recipient )
{
	if ( TMInventoryManager(Recipient.InvManager) != none )
	{
		TMInventoryManager(Recipient.InvManager).AddAmmoToWeapon(AmmoAmount, TargetWeapon);
	}

	Recipient.PlaySound(PickupSound);
	Recipient.MakeNoise(0.2);

	if (PlayerController(Recipient.Controller) != None)
	{
		PlayerController(Recipient.Controller).ReceiveLocalizedMessage(MessageClass,,,,TransformedClass != None ? TransformedClass : Class);
	}
}

simulated static function UpdateHUD(TMHUD H)
{
	local Weapon CurrentWeapon;

	Super.UpdateHUD(H);

	if ( H.PawnOwner != None )
	{
		CurrentWeapon = H.PawnOwner.Weapon;
		if ( CurrentWeapon == None )
			return;
	}

	if ( Default.TargetWeapon == CurrentWeapon.Class )
		H.LastAmmoPickupTime = H.LastPickupTime;
}

auto state Pickup
{
	/* ValidTouch()
	 Validate touch (if valid return true to let other pick me up and trigger event).
	*/
	function bool ValidTouch( Pawn Other )
	{
		if ( !Super.ValidTouch(Other) )
		{
			return false;
		}

		if ( TMInventoryManager(Other.InvManager) != none)
		  return TMInventoryManager(Other.InvManager).NeedsAmmo(TargetWeapon);

		return true;
	}

	/* DetourWeight()
	value of this path to take a quick detour (usually 0, used when on route to distant objective, but want to grab inventory for example)
	*/
	function float DetourWeight(Pawn P,float PathWeight)
	{
		local TMWeapon W;

		W = TMWeapon(P.FindInventoryType(TargetWeapon));
		if ( W != None )
		{
			return W.DesireAmmo(true) * MaxDesireability / PathWeight;
		}
		return 0;
	}
}

function float BotDesireability(Pawn P, Controller C)
{
	local TMWeapon W;
	local TMBot Bot;
	local float Result;

	Bot = TMBot(C);
	if (Bot != None && !Bot.bHuntPlayer)
	{
		W = TMWeapon(P.FindInventoryType(TargetWeapon));
		if ( W != None )
		{
			Result = W.DesireAmmo(false) * MaxDesireability;
			// increase desireability for the bot's favorite weapon
			if (ClassIsChildOf(TargetWeapon, Bot.FavoriteWeapon))
			{
				Result *= 1.5;
			}
		}
	}
	return Result;
}

/** transforms this ammo into the specified kind of ammo
 * the native implementation copies pickup related properties from NewAmmoClass
 * but if an ammo class implements special code functionality, that might not work
 * so you can override this and simply spawn a new pickup factory instead
 * @param NewAmmoClass - the kind of ammo to emulate
 */
native function TransformAmmoType(class<TMAmmoPickupFactory> NewAmmoClass);

