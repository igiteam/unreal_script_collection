
class TPInventoryManager extends InventoryManager
									config(Game);

var config bool bAutoSwitchWeaponOnPickup;
var config byte MaxNumGrenades;
var Grenade_Persistent CurrentGrenade;
var SoundCue GrenadeSelectSound;

var byte       MaxWeapons;
var byte       CurrWeapons;
var Weapon     ForceBestWeapon;
var bool		noDrop;

replication
{
	if (Role == ROLE_Authority)
		CurrentGrenade;
}
simulated function bool CancelWeaponChange()
{
//Allow switching to null weapon

//	if ( (Instigator.Weapon == PendingWeapon) || (PendingWeapon == None) )
//	{
//		Instigator.Weapon.Activate();
//		PendingWeapon = None;
//		return true;
//	}
	return false;
}

function bool HandlePickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
	//local Inventory	Inv;

	if( InventoryChain == None )
	{
		return TRUE;
	}

	// Give other Inventory Items a chance to deny this pickup
	//ForEach InventoryActors(class'Inventory', Inv)
	//{
	//	if( Inv.DenyPickupQuery(ItemClass, Pickup) )
	//	{
	//		return FALSE;
	//	}
	//}
	return TRUE;
}

simulated function ChangedWeapon()
{
	super.ChangedWeapon();

	if (Instigator.Weapon != None)
	{
		if (!Instigator.Weapon.IsA('G47SniperVampir'))
		{
			if( TPPlayerController(Instigator.Controller) != None )
			{
				TPPlayerController(Instigator.Controller).TurnOffGogglesIfEnabled();
			}
		}
	}
}

//helper function to throw an item to the ground
function TossItem(Inventory Item)
{
	local vector TossVel;

    CurrWeapons--;

	TossVel = Vector (Instigator.Rotation);
	TossVel = TossVel * ((Instigator.Velocity Dot TossVel) + 15) + Vect(0,0,200);
	Item.DropFrom(Instigator.Location, TossVel);
}

/**
 * Find weapon in inventory that matches a given slot.
 * Network: Local Player and Server
 */
simulated function Weapon GetWeaponInSlot( int Slot )
{
	local Weapon Weap;
	local int    Count;

	Count = 0;
	ForEach InventoryActors( class'Weapon', Weap )
	{
//		if (!Weap.IsA('Grenade_Persistent'))
//		{
			if (Slot == Count)
				return Weap;
			Count++;
//		}
	}
	return None;
}

simulated function byte GetNumGrenades()
{
	local byte NumGrenades;
	local Grenade_Persistent G;

	NumGrenades=0;
	ForEach InventoryActors( class'Grenade_Persistent', G )
	{
		NumGrenades++;
	}

	return NumGrenades;
}

reliable client function SetNumWeaponsInInventory(int numWeapons)
{
	currWeapons = numWeapons;
}

simulated function int NumWeaponsInInventory()
{
	local TPWeapon weapon;

	currWeapons = 0;

	// KMSK
	ForEach InventoryActors(class'TPWeapon', weapon)
	{
		if ( weapon.IsA('Grenade_Persistent') )
			continue;

		currWeapons++;
	}

	//`log("This player has # of weapons:" @ currWeapons );
	return currWeapons;

}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
	local bool bResult;

    local Inventory Inv;
    local Actor NotUsed;
	local TPWeapon newWeap, oldWeap;
	local int newWeapTotalAmmo;
	local bool bWasAiming;


    NotUsed = None;

	NumWeaponsInInventory();

	// Give other Inventory Items a chance to deny this pickup
	ForEach InventoryActors(class'Inventory', Inv)
	{
		if( Inv.DenyPickupQuery(NewItem.class, NotUsed) )
		{
			;
			return FALSE;
		}
	}

	bResult = super.AddInventory(NewItem, bDoNotActivate);

	if (Owner.IsA('PlayerPawn') && WorldInfo.NetMode==NM_Standalone)
	{
		;
		newWeap = TPWeapon(NewItem);
		if (bResult && newWeap != None && !newWeap.IsAGrenade() )
        {
			;
			// The priority of ammo distribution is as follows (for new weapon pickups)
			// 1. Magazine    [ AmmoInMagazine ] 
			// 2. Pool        [ AmmoCount ] 

			// The total amount of bullets we have is the sum of our magazine and our ammo pool.
			newWeapTotalAmmo = newWeap.AmmoInMagazine + newWeap.AmmoCount;
			;
			// Handle having too little or too much overall ammo.
			if ( newWeapTotalAmmo < 0 )
				  newWeapTotalAmmo = 0;

			if ( newWeapTotalAmmo > newWeap.MaxAmmo )
				  newWeapTotalAmmo = newWeap.MaxAmmo;

			// Move the ammo from the pool to the magazine
			// If we have more ammo than our magazine can hold
			if ( newWeapTotalAmmo >= newWeap.GetMagazineSize() )
			{
				  // Give us a full magazine
				  newWeap.AmmoInMagazine  = newWeap.GetMagazineSize();

				  // Put the rest in the pool minus the magazine.
				  newWeap.AmmoCount       = newWeapTotalAmmo - newWeap.GetMagazineSize();
			}
			else
			{
				  // Move all of the remaining ammo into the magazine
				  newWeap.AmmoInMagazine  = newWeapTotalAmmo;

				  // Zero out the pool, as we don't have enough even to load the magazine
				  newWeap.AmmoCount       = 0;
			}
			;
		}
		else
			;

	}
    // Check to see if we have a weapon small or large in our inventory
	if ( bResult && !NewItem.IsA('Grenade_Persistent') )
	{
        CurrWeapons++;
        if (CurrWeapons > MaxWeapons)
        {
			//`Log("Too many weapons");
            OldWeap = TPWeapon(Pawn(Owner).Weapon);
            if (OldWeap != None)
            {
				bWasAiming = OldWeap.IsAimDownSight();
				if (bWasAiming)
					OldWeap.TryToStoreAimDownSight();
			}
            ForceBestWeapon=Weapon(NewItem);
            TossItem(Pawn(Owner).Weapon);	// reliably call server to toss weapon.  Simply delete it on client
        }
	}
	else
	{
		CurrentGrenade = Grenade_Persistent(NewItem);
		ClientSetCurrentGrenade(CurrentGrenade);
	}

	/*if (!Pawn(Owner).IsLocallyControlled())
	{
		SwitchToBestWeapon(false);
	}*/

	//if (TPWeapon(NewItem).bLargeWeapon)
	//	TPWeapon(NewItem).ClientWeaponSet(true);
	if (!bDoNotActivate && TPWeapon(NewItem).bLargeWeapon)
	{
		TPWeapon(NewItem).ClientWeaponSet(true);
	}

	if (NewItem.IsA('G47Sniper'))
	{
		TPGameInfo(WorldInfo.Game).RegisterG47Sniper(TPWeapon(NewItem));

		if (TPGameInfo(WorldInfo.Game).bLastGoggleSetting == true)
		{
			TPWeapon(NewItem).ToggleUVLight(true);
		}
	}
	return bResult;
}

reliable client function ClientSetCurrentGrenade(Grenade_Persistent myGrenade)
{
	CurrentGrenade = myGrenade;
}

/*
	If the current grenade is being removed, cycle it out. Then execute default behavior.
*/
simulated function RemoveFromInventory(Inventory ItemToRemove)
{
// Copy and Paste from Engine:: InventoryManager.uc
// But added an additional guard to prevent calls to ClientSwitchToBestWeapon from Grenade_Persistents that have their own equip/unequip logic.

	local Inventory Item;
	local bool		bFound;

	if( ItemToRemove != None )
	{
		// make sure we don't have other references to the item
		if( ItemToRemove == Instigator.Weapon )
		{
			Instigator.Weapon = None;
		}

		if( InventoryChain == ItemToRemove )
		{
			bFound = TRUE;
			InventoryChain = ItemToRemove.Inventory;
		}
		else
		{
			// If this item is in our inventory chain, unlink it.
			for(Item = InventoryChain; Item != None; Item = Item.Inventory)
			{
				if( Item.Inventory == ItemToRemove )
				{
					bFound = TRUE;
					Item.Inventory = ItemToRemove.Inventory;
					break;
				}
			}
		}

		if( bFound )
		{
			ItemToRemove.ItemRemovedFromInvManager();
			ItemToRemove.SetOwner(None);
			ItemToRemove.Inventory = None;
		}

		// DO NOT switch to best weapon when we are removing the final grenade from inventory.  It uses its own logic to switch to PrevWeaponOnGrenade
		if (Instigator.Health > 0 && Instigator.Weapon == None && Instigator.Controller != None && !ItemToRemove.IsA('Grenade_Persistent'))
		{
			Instigator.Controller.ClientSwitchToBestWeapon(true);
		}
	}

}

/*
	If a non-grenade is currently equipped, switches to the current grenade
	If a grenade is equipped, it switches to the next grenade
*/
// DEPRECATED
simulated function CycleGrenade()
{
}

/**
 * Switches to Previous weapon
 * Network: Client
 */
simulated function PrevWeapon()
{
	local Weapon	CandidateWeapon, StartWeapon, W;

	TPPlayerController(Instigator.Controller).PrevWeaponOnGrenade = none;

	StartWeapon = Instigator.Weapon;
	if ( PendingWeapon != None )
	{
		StartWeapon = PendingWeapon;
	}

	// Get previous
	ForEach InventoryActors( class'Weapon', W )
	{
		if ( W == StartWeapon )
		{
			break;
		}
		// Added check for Grenades so we dont switch to them even though they are in our inventory
		if ( !W.IsA('Grenade_Persistent') )
			CandidateWeapon = W;
	}

	// if none found, get last
	if ( CandidateWeapon == None )
		{
		ForEach InventoryActors( class'Weapon', W )
		{
			// Added check for Grenades so we dont switch to them even though they are in our inventory
			if ( !W.IsA('Grenade_Persistent') )
				CandidateWeapon = W;
		}
	}

	// If same weapon, do not change
	if ( CandidateWeapon == Instigator.Weapon )
	{
		return;
	}

//`log(self @ "setting weapon to" @ CandidateWeapon);
//	if (!CandidateWeapon.IsA('G47Sniper'))
//		TPPlayerController(Instigator.Controller).TurnOffGogglesIfEnabled();
	SetCurrentWeapon(CandidateWeapon);
}


/**
 * Switches to Next weapon
 * Network: Client
 */
simulated function NextWeapon()
{
	local Weapon CandidateWeapon;

	TPPlayerController(Instigator.Controller).PrevWeaponOnGrenade = none;

	CandidateWeapon = GetNextWeapon();

	if (CandidateWeapon != None)
	{
//		`log(self @ "setting weapon to" @ CandidateWeapon);
//		if (!CandidateWeapon.IsA('G47Sniper'))
//			TPPlayerController(Instigator.Controller).TurnOffGogglesIfEnabled();
		SetCurrentWeapon(CandidateWeapon);
	}
}

simulated function Weapon GetNextWeapon()
{
	local Weapon	StartWeapon, CandidateWeapon, W;
	local bool		bBreakNext;

	StartWeapon = Instigator.Weapon;
	if( PendingWeapon != None )
	{
		StartWeapon = PendingWeapon;
	}

	ForEach InventoryActors( class'Weapon', W )
	{
		// Added check for Grenades so we dont switch to them even though they are in our inventory
		if( (bBreakNext || (StartWeapon == None)) && !W.IsA('Grenade_Persistent') )
		{
			CandidateWeapon = W;
			break;
		}
		if( W == StartWeapon )
		{
			bBreakNext = true;
		}
	}

	if( CandidateWeapon == None )
	{
		ForEach InventoryActors( class'Weapon', W )
		{
			// Added check for Grenades so we dont switch to them even though they are in our inventory
			if ( !W.IsA('Grenade_Persistent') )
			{
				CandidateWeapon = W;
				break;
			}
		}
	}
	// If same weapon, do not change
	if( CandidateWeapon == Instigator.Weapon )
	{
		return None;
	}

	return CandidateWeapon;
}

/**
 * Weapon just given to a player, check if player should switch to this weapon
 * Network: LocalPlayer
 * Called from Weapon.ClientWeaponSet()
 */
simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet)
{
	local Weapon OldWeapon;

	OldWeapon = Instigator.Weapon;

	// If no current weapon, then set this one. Or, if grenades are the only item in our inventory then set this one.
	if( OldWeapon == None || OldWeapon.bDeleteMe || OldWeapon.IsInState('Inactive') || OldWeapon.IsA('Grenade_Persistent') )
	{
		SetCurrentWeapon(NewWeapon);
		return;
	}

	if( OldWeapon == NewWeapon )
	{
		return;
	}

	if( bOptionalSet )
	{
		if( OldWeapon.DenyClientWeaponSet() ||
			(Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup) )
				{

			LastAttemptedSwitchToWeapon = NewWeapon;
			return;
				}
			}

	if( PendingWeapon == None || !PendingWeapon.HasAnyAmmo() || PendingWeapon.GetWeaponRating() < NewWeapon.GetWeaponRating() )
	{
		// Compare switch priority and decide if we should switch to new weapon
		if( (!Instigator.Weapon.HasAnyAmmo() || Instigator.Weapon.GetWeaponRating() < NewWeapon.GetWeaponRating() ) && !NewWeapon.IsA('Grenade_Persistent'))
		{
			SetCurrentWeapon(NewWeapon);
			return;
		}
	}

	NewWeapon.GotoState('Inactive');
}

simulated function float GetWeaponRatingFor( Weapon W )
{
	local float Rating;

	if (!W.IsA('Grenade_Persistent'))
	{
		Rating = super.GetWeaponRatingFor(W);

		if (TPWeapon(W).bLargeWeapon && bAutoSwitchWeaponOnPickup)
			Rating += 0.21;
	}
	else
	{
		Rating = -5;
	}

	return Rating;
}

/**
 * Damage modifier. Is Pawn carrying items that can modify taken damage?
 * Called from GameInfo.ReduceDamage()
 */
function int ModifyDamage( out int Damage, Controller instigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	//if (WorldInfo.NetMode != NM_Standalone)
	//	Damage *= 3;

	return Damage;
}

/**
 * Discard full inventory, generally because the owner died
 */
simulated event DiscardInventory()
{
	local Inventory	Inv;
	local vector	TossVelocity;
	local bool		bBelowKillZ;
	local TPPawn	TP;

	// don't drop any inventory if below KillZ or out of world
	bBelowKillZ = (Instigator == None) || (Instigator.Location.Z < WorldInfo.KillZ) || noDrop;

	TP = TPPawn(Instigator);

	ForEach InventoryActors(class'Inventory', Inv)
	{
		if ((TP == None || TP.bAllowInventoryDrops) && Inv.bDropOnDeath && !bBelowKillZ )
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

	// Remember that we have no weapons
	CurrWeapons = 0;

	// Clear reference to PendingWeapon
	PendingWeapon = None;
}

/**
 * Switch to best weapon available in loadout
 * Network: LocalPlayer
 */
simulated function SwitchToBestWeapon( optional bool bForceADifferentWeapon )
{
	local Weapon BestWeapon;

	BestWeapon = PendingWeapon;

	// if we don't already have a pending weapon,
	if( bForceADifferentWeapon ||
		PendingWeapon == None ||
		(AIController(Instigator.Controller) != None) )
	{
		// figure out the new weapon to bring up
        if (ForceBestWeapon != None)
        {
            BestWeapon = ForceBestWeapon;
            ForceBestWeapon = None;
        }
        else
		    BestWeapon = GetBestWeapon( bForceADifferentWeapon );

		//
		// Don't try to change to the weapon you already have.
		// Without this if, the if below will set BestWeapon to None and SetCurrentWeapon disarms you.
		//
		if ( BestWeapon == Instigator.Weapon )
			return;

		// if it matches our current weapon then don't bother switching
		if( Instigator.Weapon != None && BestWeapon == Instigator.Weapon )
		{
			BestWeapon = None;
			PendingWeapon = None;
			Instigator.Weapon.Activate();
		}
	}

	// stop any current weapon fire
	Instigator.Controller.StopFiring();

	// and activate the new pending weapon
	SetCurrentWeapon(BestWeapon);
}

// Return TRUE if we don't have any weapons
function BOOL IsInventoryEmpty()
{
	return (Instigator.Weapon == None && InventoryChain == None);
}

// Return whether we can use the indicated item.
// For weapons, the item is useful if we are currently unarmed or if we already have the weapon
// but could use some more ammo
function BOOL IsItemUseful(Inventory Item)
{
	local TPWeapon OldWeapon;

	if (Item.IsA('Weapon'))
	{
		if (IsInventoryEmpty() || CurrWeapons < MaxWeapons)
			return TRUE;

		// Grenades are always useful; the actual pickup code worries about whether we have too many.
		if (Item.IsA('Grenade_Persistent'))
			return TRUE;

		if (Instigator.Weapon != None && Instigator.Weapon == Item.Class)
			OldWeapon = TPWeapon(Instigator.Weapon);
		else
			OldWeapon = TPWeapon(FindInventoryType(Item.Class));

		return (OldWeapon != None && !OldWeapon.AmmoCountFull());
	}

	return FALSE;
}

// Useful for TPWeapons that have been separated out into TPGameContent package
simulated function TPWeapon FindWeaponByClassName(name className)
{
	local TPWeapon		weapon;

	ForEach InventoryActors(class'TPWeapon', weapon)
	{
		if (weapon.IsA(className))
			return weapon;
	}

	return None;
}

