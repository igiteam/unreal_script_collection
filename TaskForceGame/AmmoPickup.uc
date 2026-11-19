//
// AmmoPickup
//
// Ammunition pickup base class.  
// When/after being placed in a level, it must have its AmmunitionClass property 
// set to the right type (e.g. SniperRifleAmmo) to determine what kind of ammo 
// will be picked up from this pickup.
// Obviously it's preferable to just use the specific subclass for a specific 
// type of ammo.
//

class AmmoPickup extends Ammo
	placeable;

var() class<Ammunition> AmmunitionClass;
//var private Ammunition UsersExistingAmmo;
var private byte ActionRequiredByPawn;
var() bool bPickupOnlyIfAlreadyHaveWeapon;
var() float DroppedPickupLifeSpan;

var   float NominalProbability;  // Nominal probability of this type of ammo being dropped

static function string GetLocalString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2
	)
{
	return default.AmmunitionClass.default.ItemName;
}

function InitDroppedPickupFor(Inventory Inv)
{
	SetPhysics(PHYS_Falling);
//	GotoState('FallingPickup');
	Inventory = Inv;
	bAlwaysRelevant = false;
	bOnlyReplicateHidden = false;
	bUpdateSimulatedPosition = true;
    bDropped = true;
    LifeSpan = default.DroppedPickupLifeSpan;
	bIgnoreEncroachers=false; // handles case of dropping stuff on lifts etc
}

// Creates a new copy of ammuntion and gives it to the pawn
//   precondtions: Assumes pawn is valid and doesn't already have this ammo.
function inventory SpawnCopy( Pawn Other )
{
	local Inventory Copy;

	// Create new ammo
	Copy = spawn(AmmunitionClass,Other,,,rot(0,0,0));
	Ammunition(Copy).AmmoAmount = AmmoAmount;

	// Give it to pawn
	Copy.GiveTo( Other );
	
	return Copy;
}

// Adds to an existing ammo item up to its max limit.  
// If it cannot add to the existing ammo (e.g. because the current amount is 
// already at or over the max limit) then it returns false.
function bool RechargeExistingAmmo( actor Other, class<Ammunition> AmmunitionClass, int AmmoAmount )
{
	return ZombiePlayerPawn(Other).RechargeExistingAmmo( AmmunitionClass, AmmoAmount );
}

function AnnouncePickup( Pawn Receiver )
{
	local ZombieWeapon zweap;
	local ZombiePlayerPawn zpawn;

	zpawn = ZombiePlayerPawn(Receiver);

	if( zpawn != None )
	{
		zweap = zpawn.GetWeaponThatUsesThisAmmo( AmmunitionClass, AmmoAmount );
		zpawn.ClientGotAmmo( zweap );
	}
	Super.AnnouncePickup( Receiver );
}

//=============================================================================
// Pickup state: this inventory item is sitting on the ground.

auto state Pickup
{
	// Validate touch (if valid return true to let other pick me up and trigger event).
	function bool ValidTouch( actor Other )
	{
//		UsersExistingAmmo = None;

	//	Log("AmmoPickup.Pickup.ValidTouch  ");
	//	Log("     (Pawn(Other) == None):"$ (Pawn(Other) == None) 
	//		$" !Pawn(Other).bCanPickupInventory:"$ !Pawn(Other).bCanPickupInventory
	//		$" (Pawn(Other).Health <= 0):"$ (Pawn(Other).Health <= 0) );
		// make sure its a live player
		if ( (ZombiePlayerPawn(Other) == None) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).Health <= 0) )
			return false;

	//	Log("AmmoPickup.Pickup.ValidTouch        about to check if not touching through wall");
		// make sure not touching through wall
		if ( !FastTrace(Other.Location, Location) )
			return false;

		ActionRequiredByPawn = ZombiePlayerPawn(Other).ShouldDoWhatWithAmmoPickup(AmmunitionClass);
		if( ActionRequiredByPawn > 0 )
		{
		//	Log("AmmoPickup.Pickup.ValidTouch        return true");
			return true;
		}
		else
		{
		//	Log("AmmoPickup.Pickup.ValidTouch        return false!!!");
			return false;
		}
	}	
	
	// When touched by an actor.
	function Touch( actor Other )
	{
		local Inventory Copy;

	//	Log("AmmoPickup.Pickup.Touch    Other:"$ Other );
		// If required to do so, then check that actor has a weapon that
		// uses this ammo and return if actor does not have said weapon.
	//	if( bPickupOnlyIfAlreadyHaveWeapon )
	//	{
	//		if( !hasWeaponThatUsesThisAmmo( Other ) )
	//			return;
	//	}
	//	Log("    Passed hasWeaponThatUsesThisAmmo! ");

		// If touched by a player pawn, let him pick this up.
		if( ValidTouch(Other) )
		{
		//	Log("    Was a valid touch! ");
			// Send pickup message
		//	Pawn(Other).ReceiveLocalizedMessage(MessageClass,,,,class);
			
		//	if( UsersExistingAmmo != None )  // If actor already has this type ammo
			if( ActionRequiredByPawn == 1 )  // If actor already has this type ammo
			{
				// then just add to the amount of that existing ammo
				// (no need to actually spawn a new copy to give to 
				// the pawn)
			//	if( RechargeExistingAmmo( UsersExistingAmmo ) )
				if( RechargeExistingAmmo( Other, AmmunitionClass, AmmoAmount ) )
				{
					// Recharge was successful, so behave as
					// if item was picked up
					AnnouncePickup(Pawn(Other));

					// If pawn's current weapon uses this ammo, and that weapon is empty, then reload
					if( Pawn(Other).Weapon != None && Pawn(Other).Weapon.AmmoType.class == InventoryType && Pawn(Other).Weapon.NeedsToReload() )
						Pawn(Other).Weapon.ForceReload();

					SetRespawn();						
				}
			}
			else
			{
				// otherwise, have to spawn a new copy of this type of ammo
				Copy = SpawnCopy(Pawn(Other));
				AnnouncePickup(Pawn(Other));

				SetRespawn(); 

				if( Copy != None )
					Copy.PickupFunction(Pawn(Other));
			}
		}
	}
}

//=============================================================================

// Decompiled with UE Explorer.
defaultproperties
{
    bPickupOnlyIfAlreadyHaveWeapon=true
    DroppedPickupLifeSpan=1200.0000000
    NominalProbability=0.5000000
    AmmoAmount=20
    InventoryType=Class'Engine.Ammunition'
    RespawnTime=0.0000000
    PickupSound=Sound'CBW_DYN_interface.HUD.pickup_ammo'
    DrawType=8
    StaticMesh=StaticMesh'CBS_DYN.Pickup.ammocan'
    CollisionRadius=36.0000000
    CollisionHeight=8.0000000
    MessageClass=Class'ZombiePickupMessage'
}