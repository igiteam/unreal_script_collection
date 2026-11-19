class TPPickupFactory extends PickupFactory
	config(Game);

var() config float TPRespawnTime;
var() int AmmoAmount;

simulated function name GetPickupName ( )
{
    local string PickupName;

    PickupName = "Take";
    PickupName @= class<TPWeapon>(InventoryType).default.WeapName;

    return name(PickupName);
}

function SpawnCopyFor( Pawn P )
{
	local Inventory Inv;

	Inv = spawn(InventoryType);

	if ( Inv != None && AmmoAmount > 0)
	{
		TPWeapon(Inv).AmmoCount = AmmoAmount;

		if(AmmoAmount > TPWeapon(Inv).AmmoInMagazine)
			TPWeapon(Inv).AmmoInMagazine = TPWeapon(Inv).MagazineSize;
		else
			TPWeapon(Inv).AmmoInMagazine = AmmoAmount;

		TPWeapon(Inv).AmmoCount -= TPWeapon(Inv).AmmoInMagazine;
		
		Inv.GiveTo(P);
		Inv.AnnouncePickup(P);
	}
	else if (Inv != None)
	{
		Inv.GiveTo(P);
		Inv.AnnouncePickup(P);
	}
}


//=============================================================================
// Pickup state: this inventory item is sitting on the ground.

auto state Pickup
{
	/* DetourWeight()
	value of this path to take a quick detour (usually 0, used when on route to distant objective, but want to grab inventory for example)
	*/
	event float DetourWeight(Pawn Other,float PathWeight)
	{
		return InventoryType.static.DetourWeight(Other,PathWeight);
	}

	function bool ReadyToPickup(float MaxWait)
	{
		return true;
	}

	/*
	 Validate touch (if valid return true to let other pick me up and trigger event).
	*/
	function bool ValidTouch( Pawn Other )
	{
		// make sure its a live player
		if ( (Other == None) || !Other.bCanPickupInventory || (Other.DrivenVehicle == None && Other.Controller == None) )
			return false;

		// make sure not touching through wall
		if ( !FastTrace(Other.Location, Location) )
		{
			SetTimer(0.5, false, 'RecheckValidTouch');
			return false;
		}

		// make sure game will let player pick me up
		if (WorldInfo.Game.PickupQuery(Other, InventoryType, self))
		{
			return true;
		}
		return false;
	}

	/**
	Pickup was touched through a wall.  Check to see if touching pawn is no longer obstructed
	*/
	event RecheckValidTouch()
	{
		CheckTouching();
	}

	// When touched by an actor.
	event Touch( Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal )
	{
		local Pawn P;
		
		// If touched by a player pawn, let him pick this up.
		P = Pawn(Other);

		/*if( P != None && ValidTouch(P) )
		{
			GiveTo(P);
 		}*/
		if( P != None && ValidTouch(P) )
		{
			//GiveTo(P);
			if (bPickupHidden == false)
				PlayerPawn(P).PendingPickupFactory = self;
		}
	}

	// Make sure no pawn already touching (while touch was disabled in sleep).
	function CheckTouching()
	{
		local Pawn P;

		ForEach TouchingActors(class'Pawn', P)
			Touch(P, None, Location, Normal(Location-P.Location) );
	}

	event BeginState(name PreviousStateName)
	{
		TriggerEventClass(class'SeqEvent_PickupStatusChange', None, 0);
	}

Begin:
	CheckTouching();
}

function float GetRespawnTime()
{
	return TPRespawnTime;
}
