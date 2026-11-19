//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDInventoryManager extends TMInventoryManager;

var array<HDWeapon>         ConventionalWeapons;
var	array<HDWeapon>         SpecialWeapons;
var array<HDWeap_Grenade>   GrenadeWeapons;

var int CurrentConventionalWeapon;
var int CurrentSpecialWeapon;
var int LastConventionalWeapon;


var bool is_grenade_weapon;
var int CurrentGrenade;

enum ECurrentWeaponType
{
	ECWT_CONVENTIONAL,
	ECWT_SPECIAL,
};

var	ECurrentWeaponType		CurrentWeaponType;

var transient bool          bStopPickUp;

struct SHDEquipment
{
	var array< class<HDConventionalWeapon> >    ConventionalWeaponClass;
	var array< class<HDSpecialWeapon> >    SpecialWeaponClass;
	var array< class<HDWeap_Grenade> >     GrenadeClass;
};

delegate    SwitchWeaponFun( byte Type, optional bool bPickUp = False );

function InitializeEquipment(SHDEquipment equip)
{
	local class<HDWeapon> Weapon_Class;
	local int index;

	CurrentConventionalWeapon = 0;
	CurrentSpecialWeapon = 0;
	LastConventionalWeapon = CurrentConventionalWeapon;

    ConventionalWeapons.Length = equip.ConventionalWeaponClass.Length;

	for ( index = 0; index < equip.ConventionalWeaponClass.Length; ++index )
	{
		Weapon_Class = equip.ConventionalWeaponClass[index];
		if ( Weapon_Class != None )
		{
			ConventionalWeapons[index] = HDWeapon(CreateInventory(weapon_class, True));
		}
	};

    SpecialWeapons.Length = equip.SpecialWeaponClass.Length;
	for ( index = 0; index < equip.SpecialWeaponClass.Length; ++index )
	{
		Weapon_Class = equip.SpecialWeaponClass[index];
		if ( Weapon_Class != None )
		{
			SpecialWeapons[index] = HDWeapon(CreateInventory(weapon_class, True));
		}
	};


    GrenadeWeapons.Length = equip.GrenadeClass.Length;
	for ( index = 0; index < equip.GrenadeClass.Length; ++index )
	{
		Weapon_Class = equip.GrenadeClass[index];
		if ( Weapon_Class != None )
		{
			GrenadeWeapons[index] = HDWeap_Grenade(CreateInventory(weapon_class, True));
		}
	};

	// client setting
	ClientSyncHDWeapon(GrenadeWeapons[0], GrenadeWeapons[1], GrenadeWeapons[2]);
}

reliable client function ClientSyncHDWeapon( HDWeap_Grenade Frag, HDWeap_Grenade Smoke, HDWeap_Grenade Flash )
{
    if ( ROLE == ROLE_SimulatedProxy )
    {
        GrenadeWeapons[0] = Frag;
        GrenadeWeapons[1] = Smoke;
        GrenadeWeapons[2] = Flash;
    }
}

final function GetEquipment()
{
    local HDWeapon W;
    local HDConventionalWeapon CW;
    local HDSpecialWeapon SW;

    local int index, SWindex;

	// clear weapon arrays, but not destory weapons
    for(index = 0; index < ConventionalWeapons.Length; index++)
	{
        ConventionalWeapons[index]=None;
	};

	for(index = 0; index < SpecialWeapons.Length; index++)
	{
        SpecialWeapons[index]=None;
	};

    for(index = 0; index < GrenadeWeapons.Length; index++)
	{
        GrenadeWeapons[index]=None;
	};
	CurrentConventionalWeapon = 0;
	CurrentSpecialWeapon = 0;
    LastConventionalWeapon = CurrentConventionalWeapon;
	index = 0;
	SWindex = 0;

    ForEach InventoryActors( class'HDWeapon', W )
	{
       if( HDWeap_Grenade(W) == none) //?????
	   {
           CW = HDConventionalWeapon(W);
           if ( CW != None && index < ConventionalWeapons.Length )
           {
                ConventionalWeapons[index++]=W;
                continue;
           }
           SW = HDSpecialWeapon(W);
           if ( SW != None && SWindex < SpecialWeapons.Length )
           {
                SpecialWeapons[SWindex++]=W;
                continue;
           }
       }

	   if( (index + SWindex) >= ConventionalWeapons.Length + SpecialWeapons.Length)
	      break;
	}

    GrenadeWeapons[0] = HDWeap_Grenade( FindInventoryType(class'HDWeap_FragGrenade', FALSE) );
    GrenadeWeapons[1] = HDWeap_Grenade( FindInventoryType(class'HDWeap_SmokeGrenade', FALSE) );
    GrenadeWeapons[2] = HDWeap_Grenade( FindInventoryType(class'HDWeap_FlashGrenade', FALSE) );
}

/**
 * Discard full inventory, generally because the owner died
 */
simulated function DiscardInventory()
{
	local int index;
    if (Role == ROLE_Authority)
    {
        Super.DiscardInventory();
        // clear all weapons array
    	for ( index = 0; index < ConventionalWeapons.Length; ++index )
    	{
    		RemoveFromInventory(ConventionalWeapons[index]);
            ConventionalWeapons[index]=None;
    	}
        for ( index = 0; index < SpecialWeapons.Length; ++index )
    	{
    		RemoveFromInventory(SpecialWeapons[index]);
            SpecialWeapons[index]=None;
    	}
        for ( index = 0; index < GrenadeWeapons.Length; ++index )
    	{
    		RemoveFromInventory(GrenadeWeapons[index]);
            GrenadeWeapons[index]=None;
    	}
    }
}

function bool InternalPickupItem( HDDroppedPickup DP, out Array<HDWeapon> outWeapons, int CurrentIndex, delegate<SwitchWeaponFun> SwitchDelegate, bool bMatching )
{
	local int idx, index;
	local HDDroppedPickup NewDP;
	local HDWeapon outWeapon;
    local HDPickupObject    OldDP;

    if ( CurrentIndex >= outWeapons.Length ) return false;

    if ( DP == None || DP.bDeleteMe ) return False;

    OldDP = HDPickupObject(DP);

    if ( !bMatching )
    {
        idx = CurrentIndex;

        // weapon switching, using pawn current weapon to switch
        if ( outWeapons[idx] != Instigator.Weapon )
    	{
    	   for ( index = 0; index < outWeapons.Length; ++index )
    	   {
    	       if ( Instigator.Weapon == outWeapons[index] )
    	       {
    	           idx = index;
    	           break;
    	       }
    	   }
    	}
    	// find none slot or unarmed weapon
        for ( index = 0; index < outWeapons.Length; ++index )
    	{
            if( outWeapons[index] == none || outWeapons[index].Class == class'HDWeap_Unarmed' )
    		{
    			idx = index;
    			break;
    		}
    	}
    }
    else
    {
        idx = -1;
        for ( index = 0; index < outWeapons.Length; ++index )
        {
            if ( outWeapons[index] != none && outWeapons[index].HDWeaponType == HDWeapon(DP.Inventory).HDWeaponType )
            {
                idx = index;
                break;
            }
        }
        if ( idx == -1 ) return false;
    }

    if ( outWeapons[idx] != None && outWeapons[idx].bConstHoldWeapon ) return false;

    if ( outWeapons[idx] != none )
    {
        if ( (outWeapons[idx].Class == class'HDWeap_Unarmed') || (!outWeapons[idx].CanThrow()) || (OldDP != None && OldDP.bInfinit == TRUE) )
        {
            outWeapons[idx].Drop();
            outWeapons[idx].Destroy();
        }
        else
        {
            NewDP = outWeapons[idx].DropAndCreateItem(DP.Location, Vect(0,0,0));
            ;
        }
    }

    outWeapons[idx] = None;

	DP.PickupItem(Instigator, outWeapon);
	outWeapons[idx] = outWeapon;
	SwitchDelegate(idx, TRUE);
	if ( OldDP != None && OldDP.bInfinit == TRUE )
	   return FALSE;
	return TRUE;
}

function bool InternalPickupGrenade( HDDroppedPickup DP, out Array<HDWeap_Grenade> outWeapons, int CurrentIndex )
{
	local int idx;
	local HDWeapon   outGrenade;
    local HDPickupObject    OldDP;

    if ( CurrentIndex >= outWeapons.Length ) return false;

    idx = CurrentIndex;
    OldDP = HDPickupObject(DP);
    outWeapons[idx] = None;
	DP.PickupItem(Instigator, outGrenade);
	outWeapons[idx] = HDWeap_Grenade(outGrenade);
	if ( OldDP != None && OldDP.bInfinit == TRUE )
	   return FALSE;
	return TRUE;
}


function bool PickupItem(HDDroppedPickup DP, optional bool bConventional = TRUE )
{
	local HDWeapon HDW;
    local bool ret;
    local int grenadeindex;
    ret = false;
    if ( bStopPickUp )
        return ret;

    HDW = HDWeapon(DP.Inventory);

	if (HDW == none)
		return ret;

    //  handle grenade firstly
    if ( HDWeap_Grenade(HDW) != None )
    {
        grenadeindex = (HDWeap_FragGrenade(HDW)!=None) ? 0 : (HDWeap_SmokeGrenade(HDW) != None ? 1 : 2);
        ret = InternalPickupGrenade(DP, GrenadeWeapons, grenadeindex );
    }
	// pick up special weapon
    else if ( HDW.HDWeaponType == EWEAPON_SPECIAL && ConventionalWeapons.Length != 1 )
    {
        ret = InternalPickupItem(DP, SpecialWeapons, CurrentSpecialWeapon, SwitchSpecialWeapon, false );
    }
    else
    {
        ret = InternalPickupItem(DP, ConventionalWeapons, CurrentConventionalWeapon, SwitchConventionalWeapon, HDBaseGame(WorldInfo.Game).bMatchingWeaponSwitch );
    }
    return ret;
}

simulated function ClearPendingFire(Weapon InWeapon, int InFiringMode)
{
    super.ClearPendingFire(InWeapon, InFiringMode);
}

simulated function ThrowGrenade( byte Type )
{
	ServerThrowGrenade( Type );
}

reliable server function ServerThrowGrenade( byte Type )
{
	if (is_grenade_weapon && Type == CurrentGrenade )
	{
		GrenadeWeapons[Type].ThrowGrenade();
	}
}

simulated function FinishThrowGrenade()
{
	is_grenade_weapon = false;
	SetCurrentWeaponInternal( CurrentWeaponType, CurrentWeaponType == ECWT_CONVENTIONAL ? CurrentConventionalWeapon : CurrentSpecialWeapon, CurrentWeaponType == ECWT_CONVENTIONAL? ConventionalWeapons[CurrentConventionalWeapon].CurrentFireModeType : 0 );
}


//---------------------------------------------------------
// switch weapon
//---------------------------------------------------------

simulated function SwitchWeapon(byte NewGroup);
reliable server function ServerSwitchWeapon(byte NewGroup);

simulated function SwitchGrenadeWeapon( byte Type )
{
    ServerSwitchGrenadeWeapon( Type );
}


simulated function SwitchConventionalWeaponSroll( byte Value )
{
    ServerSwitchConventionalWeaponSroll( Value );
}

simulated function SwitchConventionalWeapon( byte Type, optional bool bPickUp = False )
{
    ServerSwitchConventionalWeapon( Type, bPickUp );
}


simulated function SwitchSpecialWeapon( byte Type, optional bool bPickUp = False )
{
	ServerSwitchSpecialWeapon( Type, bPickUp );
}


simulated function SwitchWeaponFireMode( byte Type )
{
    ServerSwitchWeaponFireMode( Type );
}


simulated function SwitchToLastConventionalWeapon()
{
    ServerSwitchToLastConventionalWeapon();
}


simulated function SetCurrentWeaponInternal( ECurrentWeaponType type, int index, optional ECurrentFireModeType firemode = ECFMT_PRIMARY )
{
	local HDWeapon weapon;
	switch( type )
	{
	case ECWT_CONVENTIONAL:
	    if ( index >= ConventionalWeapons.Length )
            return;
		weapon = ConventionalWeapons[index];
		if ( weapon == None )
		  return;
		LastConventionalWeapon = CurrentConventionalWeapon;
		CurrentConventionalWeapon = index;
		weapon.SetCurrentFireModeType( firemode );
		break;
	case ECWT_SPECIAL:
		if ( index >= SpecialWeapons.Length )
            return;
        weapon = SpecialWeapons[index];
		if ( weapon == None )
            return;
		CurrentSpecialWeapon = index;
		weapon.SetCurrentFireModeType( firemode );
		break;
	}
	if ( weapon != none && weapon != Instigator.Weapon )
	{
		CurrentWeaponType = type;
		SetCurrentWeapon(weapon);
	}
}
reliable server function ServerSwitchGrenadeWeapon( byte Type )
{
    if ( GrenadeWeapons[Type] != none && GrenadeWeapons[Type].HasAmmo(0,1) )
    {
        SetCurrentWeapon(GrenadeWeapons[Type]);
        is_grenade_weapon = true;
        CurrentGrenade = Type;
    }
}

reliable server function ServerSwitchConventionalWeaponSroll( byte Value )
{
	local int index;

    if ( is_grenade_weapon == true ) return;
	index = CurrentConventionalWeapon;
    index += (Value==1)? 1 : -1;
    index = Clamp( index, 0, ConventionalWeapons.Length-1);
    SetCurrentWeaponInternal( ECWT_CONVENTIONAL, index );
}

reliable server function ServerSwitchConventionalWeapon( byte Type, optional bool bPickUp = FALSE )
{
	if ( is_grenade_weapon == true ) return;
	if ( !bPickUp && CurrentWeaponType == ECWT_CONVENTIONAL && Type == CurrentConventionalWeapon )
	{
	    SetCurrentWeaponInternal( ECWT_CONVENTIONAL, Type, ConventionalWeapons[CurrentConventionalWeapon].CurrentFireModeType == ECFMT_PRIMARY? ECFMT_SECONDARY : ECFMT_PRIMARY );
	    return;
	}

	SetCurrentWeaponInternal( ECWT_CONVENTIONAL, Type );
}

reliable server function ServerSwitchSpecialWeapon( byte Type, optional bool bPickUp = False )
{
	if ( is_grenade_weapon == true ) return;

	if ( !bPickUp && CurrentWeaponType == ECWT_SPECIAL && CurrentSpecialWeapon == Type )
	{
		ServerSwitchConventionalWeapon( CurrentConventionalWeapon );
		return;
	}
	SetCurrentWeaponInternal( ECWT_SPECIAL, Type );
}


reliable server function ServerSwitchWeaponFireMode( byte Type )
{
}

reliable server function ServerSwitchToLastConventionalWeapon()
{
    if ( CurrentWeaponType == ECWT_CONVENTIONAL && CurrentConventionalWeapon != LastConventionalWeapon )
    {
        SetCurrentWeaponInternal( ECWT_CONVENTIONAL, LastConventionalWeapon );
        return;
    }
    if ( CurrentWeaponType == ECWT_SPECIAL )
    {
        SetCurrentWeaponInternal( ECWT_CONVENTIONAL, CurrentConventionalWeapon );
        return;
    }

}

simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
	local Inventory	Inv;

	if( NewInventoryItemClass != None )
	{
		inv = Spawn(NewInventoryItemClass, Owner);
		if( inv != None )
		{
			if( !AddInventory(Inv, bDoNotActivate) )
			{
				;
				Inv.Destroy();
				Inv = None;
			}
		}
		else
		{
			;
		}
	}

	return Inv;
}

simulated function RemoveFromInventory(Inventory ItemToRemove)
{
	local Inventory Item;
	local bool		bFound;

	if( ItemToRemove != none )
	{
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
			;
			ItemToRemove.ItemRemovedFromInvManager();
			ItemToRemove.SetOwner(None);
			ItemToRemove.Inventory = None;
		}

		// make sure we don't have other references to the item
		if( ItemToRemove == Instigator.Weapon )
		{
			Instigator.Weapon = None;
		}

		if( Instigator.Health > 0 && Instigator.Weapon == none && Instigator.Controller != none )
		{
			;
			//Instigator.Controller.ClientSwitchToBestWeapon(TRUE);
		}
	}
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
	local Inventory Item, LastItem;

	// The item should not have been destroyed if we get here.
	if( (NewItem != None) && !NewItem.bDeleteMe )
	{
		// if we don't have an inventory list, start here
		if( InventoryChain == none )
		{
			InventoryChain = newItem;
		}
		else
		{
			// Skip if already in the inventory.
			for (Item = InventoryChain; Item != None; Item = Item.Inventory)
			{
				if( Item == NewItem )
				{
					return FALSE;
				}
				LastItem = Item;
			}
			LastItem.Inventory = NewItem;
		}

		;

		NewItem.SetOwner( Instigator );
		NewItem.Instigator = Instigator;
		NewItem.InvManager = Self;
		NewItem.GivenTo( Instigator, bDoNotActivate);

		// Trigger inventory event
		Instigator.TriggerEventClass(class'SeqEvent_GetInventory', NewItem);
		return TRUE;
	}

	return FALSE;
}


/**
 * Cut and pasted here except call ClientWeaponSet on the weapon instead of forcing it.
 * This causes all of the "should I put down" logic to occur
 */

simulated function SwitchToBestWeapon( optional bool bForceADifferentWeapon )
{
	local HDWeapon BestWeapon;
	local int index;

//	if (Instigator.IsLocallyControlled())
//	{
		// if we don't already have a pending weapon,
		if( bForceADifferentWeapon ||
			PendingWeapon == None ||
			(AIController(Instigator.Controller) != None) )
		{
			// figure out the new weapon to bring up
			BestWeapon = HDWeapon(GetBestWeapon( bForceADifferentWeapon ));

			// if it matches our current weapon then don't bother switching
			if( BestWeapon == HDWeapon(Instigator.Weapon) && BestWeapon.CurrentFireModeType == ECFMT_PRIMARY )
			{
				BestWeapon = None;
				PendingWeapon = None;
				if (Instigator.Weapon != None)
				{
					Instigator.Weapon.Activate();
				}
			}
		}

		if (BestWeapon != None)
		{
			for ( index = 0; index < ConventionalWeapons.Length; ++index )
			{
				if ( BestWeapon == ConventionalWeapons[index] )
				{
					SetCurrentWeaponInternal( ECWT_CONVENTIONAL, index );
					return;
				}
			}
		}
//	}
}

/**
 * returns the best weapon for this Pawn in loadout
 */
simulated function Weapon GetBestWeapon( optional bool bForceADifferentWeapon  )
{
	local Weapon	W, BestWeapon;
	local HDWeapon  CurrentWeapon;
	local int		index;

	// get best weapon from primary weapon array
	// switch to primary fire mode
    if ( BestWeapon == None )
    {
        CurrentWeapon = HDWeapon(Instigator.Weapon);
        if ( CurrentWeapon != None && CurrentWeapon.CurrentFireModeType == ECFMT_SECONDARY )
            BestWeapon = CurrentWeapon;
    }
	if ( BestWeapon == None )
	{
		for ( index = 0; index < ConventionalWeapons.Length; ++index )
		{
			W = ConventionalWeapons[index];
			if ( W != none && W.HasAmmo(0) )
			{
				if ( BestWeapon == None )
				{
					BestWeapon = W;
				}
			}
		}
	}

	if ( BestWeapon == None )
	{
		BestWeapon = (CurrentWeaponType == ECWT_CONVENTIONAL)? Instigator.Weapon : W;
	}
	return BestWeapon;
}

/**
* Weapon just given to a player, check if player should switch to this weapon
* Network: LocalPlayer
* Called from Weapon.ClientWeaponSet()
*/
simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet, optional bool bDoNotActivate)
{
	local Weapon OldWeapon;
	local HDWeap_Grenade Grenade;

	OldWeapon = Instigator.Weapon;

    // especially for grenade weapon, do early out
    Grenade = HDWeap_Grenade(NewWeapon);
    if ( Grenade != None )
    {
        Grenade.GotoState('Inactive');
        SetBackAttachWeapon(NewWeapon);
        return;
    }

    if ( OldWeapon == NewWeapon )
	{
		return;
	}

	// If no current weapon, then set this one
	if ( OldWeapon == None || OldWeapon.bDeleteMe || OldWeapon.IsInState('Inactive') )
	{
		SetCurrentWeapon(NewWeapon);
		return;
	}



/*	if (!bOptionalSet)
	{
		SetCurrentWeapon(NewWeapon);
		return;
	}

	if (Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
	{
		NewWeapon.GotoState('Inactive');
		return;
	}

	if ( OldWeapon.IsFiring() || OldWeapon.DenyClientWeaponSet() && (TMWeapon(NewWeapon) != None) )
	{
		NewWeapon.GotoState('Inactive');
		RetrySwitchTo(TMWeapon(NewWeapon));
		return;
	}
*/
	NewWeapon.GotoState('Inactive');
	SetBackAttachWeapon(NewWeapon);
}

/**
 * SetCurrentWeapon starts a weapon change.  It calls SetPendingWeapon and then if it's called
 * on a remote client, tells the server to begin the process.
 *
 * @param	DesiredWeapon		The Weapon to switch to
 */

reliable client function SetBackAttachWeapon( Weapon DesiredWeapon )
{
	SetAttachingWeapon(DesiredWeapon);

	// If we are a remote client, make sure the Server Set's its pending weapon

	if( Role < Role_Authority )
	{
		ServerSetAttachingWeapon(DesiredWeapon);
	}

}

/**
 * Accessor for the server to begin a weapon switch on the client.
 *
 * @param	DesiredWeapon		The Weapon to switch to
 */

reliable client function ClientSetAttachingWeapon(Weapon DesiredWeapon)
{
	SetAttachingWeapon(DesiredWeapon);
}

/**
 * When a client-switch begins on a remote-client, the server needs to be told to
 * start the process as well.  SetCurrentWeapon() makes that call.
 *
 * NETWORK - This function should *ONLY* be called from a remote client's SetCurrentWeapon()
 * function.
 *
 * @param	DesiredWeapon		The Weapon to switch to
 */

reliable server function ServerSetAttachingWeapon(Weapon DesiredWeapon)
{
	SetAttachingWeapon(DesiredWeapon);
}

/**
 * This is the work-horse of the weapon switch.  It will set a new pending weapon
 * and tell the weapon to begin the switch.  If the call to Weapon.TryPutdown() returns
 * false, it means that the weapon can't switch at the moment and has deferred it until later
 *
 * @param	DesiredWeapon		The Weapon to switch to
 */

simulated function SetAttachingWeapon( Weapon DesiredWeapon )
{
    local HDWeapon HDW;
    HDW = HDWeapon(DesiredWeapon);
    if ( HDW != None )
        HDW.WeaponEquipToBack();
}


/**
 * SetCurrentWeapon starts a weapon change.  It calls SetPendingWeapon and then if it's called
 * on a remote client, tells the server to begin the process.
 *
 * @param	DesiredWeapon		The Weapon to switch to
 */

reliable client function SetCurrentWeapon( Weapon DesiredWeapon )
{
    bStopPickUp = TRUE;
    super.SetCurrentWeapon(DesiredWeapon);
}


// get constHold Weapon
simulated function HDWeapon GetConstHoldWeapon()
{
    local int index;
    for ( index = 0; index < SpecialWeapons.Length; ++index )
    {
        if ( SpecialWeapons[index] != None && SpecialWeapons[index].bConstHoldWeapon )
            return SpecialWeapons[index];
    }
    return None;
}


