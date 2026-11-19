//=============================================================================
// SASWeaponModule.uc
//
// Abstract base class for attachment modules for weapons (scopes, laser sights,
// tactical lights).
//=============================================================================

class SASWeaponModule extends InventoryAttachment
	native
	abstract;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member variables

var bool		mbActive;					// Module in use
var Vector		mAttachRelativeLocation;	// Module's location offset
var Rotator		mAttachRelativeRotation;	// Module's rotation offset

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// InitFor
//
// Called when attachment is spawned to attach to weapon.
function InitFor(
	Inventory	aInv)
{
	if (aInv == None)
	{
		return;
	}

	Super.InitFor(aInv);

	bHardAttach = true;
	SetBase(aInv);
	SetRelativeLocation(mAttachRelativeLocation);
	SetRelativeRotation(mAttachRelativeRotation);
}


///////////////////////////////////////////////////////////////////////////////
// Activate
//
simulated event Activate()
{
	mbActive = true;
}


///////////////////////////////////////////////////////////////////////////////
// Activate
//
simulated event DeActivate()
{
	mbActive = false;
}


//-----------------------------------------------------------------------------
// Default Properties

