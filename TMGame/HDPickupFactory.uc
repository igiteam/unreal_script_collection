//-----------------------------------------------------------
//  ???????PickupFactory????NavigationPoint
//-----------------------------------------------------------
class HDPickupFactory extends DynamicSMActor
placeable;

struct WeaponInfo
{
    var() class<HDWeapon> Type;
    var() int             Ammo;
};

var() array<WeaponInfo> WeaponList;

var() bool  bInfiniteAmmo;


function GiveTo(Pawn P)
{
     local int i;
     local HDWeapon W;
     local int OldAmmo, DiffAmmo;
     local bool bUsed;

     for(i = 0; i < WeaponList.Length; i++)
     {
         W = HDWeapon( P.FindInventoryType(WeaponList[i].Type, true) );
         if( W != none && !W.AmmoMaxed(0) )
         {
             OldAmmo = W.AmmoCount;
             DiffAmmo = W.AddAmmo(WeaponList[i].Ammo) - OldAmmo;

             if(DiffAmmo > 0)
             {
                 bUsed = true;

                 if(!bInfiniteAmmo)
                 {
                    WeaponList[i].Ammo -= DiffAmmo;
                 }
             }

             ;
         }
     }


     if(bUsed && !bInfiniteAmmo)
     {
         GotoState('Disabled');
     }
}

state Disabled
{
    ignores Touch;

    event BeginState(Name PreviousStateName)
	{
		SetHidden(true);
		SetCollision(false, false);
	}
}

auto state Pickup
{
	/*
	 Validate touch (if valid return true to let other pick me up and trigger event).
	*/
	function bool ValidTouch( Pawn Other )
	{
		// make sure its a live player
		if( HDPawn(Other) == None || !Other.bCanPickupInventory )
		{
			return false;
		}
		else if (Other.Controller == None)
		{
			// re-check later in case this Pawn is in the middle of spawning, exiting a vehicle, etc
			// and will have a Controller shortly
			SetTimer( 0.2, false, nameof(RecheckValidTouch) );
			return false;
		}
		// make sure not touching through wall
		//else if ( !FastTrace(Other.Location, Location) )
//		{
//			SetTimer( 0.5, false, nameof(RecheckValidTouch) );
//			return false;
//		}

		return true;
	}

	/**
	Pickup was touched through a wall.  Check to see if touching pawn is no longer obstructed
	*/
	function RecheckValidTouch()
	{
		CheckTouching();
	}

	// When touched by an actor.
	event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
	{
		local Pawn P;

		P = Pawn(Other);
		if( P != None && ValidTouch(P) )
		{
			GiveTo(P);
 		}
	}

	// Make sure no pawn already touching (while touch was disabled in sleep).
	function CheckTouching()
	{
		local HDPawn P;

		ForEach TouchingActors(class'HDPawn', P)
			Touch(P, None, Location, Normal(Location-P.Location) );
	}

Begin:
	CheckTouching();
}


