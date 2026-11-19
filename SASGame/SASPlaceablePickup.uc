////////////////////////////////////////////////////////////////////////////////
// SASPlaceablePickup.uc
//
// Interface an SASPickup to weapon pickup data:
// mesh type & class data stored in SASPickupWeapon
////////////////////////////////////////////////////////////////////////////////

class SASPlaceablePickup extends SASPickup;

////////////////////////////////////////////////////////////////////////////////
// variables 
//
var Inventory			mWeapon;
var SASPickupWeapon		mWeaponType;

////////////////////////////////////////////////////////////////////////////////
// PreBeginPlay 
//
function PreBeginPlay ()
{
	Super.PreBeginPlay ();

	mWeaponType = SASPickupWeapon ( Owner );
	mInventoryClass = class<Inventory>( DynamicLoadObject ( mWeaponType.mWeaponClassName, class'Class' ) );
	mWeapon = Spawn ( mInventoryClass,,, mWeaponType.Location, mWeaponType.Rotation );

	if ( mWeapon != None )
	{
		InitDroppedPickupFor ( mWeapon, true );
	}
}

////////////////////////////////////////////////////////////////////////////////
// DoPickup 
//
// SAS - Do whatever we do when picking up weapon
function doPickup ( SASPawn p )
{
	Super.doPickup ( p );

	if ( mWeaponType != None )
	{
		mWeaponType.DoPickup ();
	}

	Destroy ();
} // doPickup

////////////////////////////////////////////////////////////////////////////////
// Resting state
//
auto state Resting
{
	event Touch ( Actor aOther )
	{
		Super.Touch ( aOther );
	}
}

////////////////////////////////////////////////////////////////////////////////
// defaultproperties 
//
