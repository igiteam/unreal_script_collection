//=============================================================================
// SAS3PMuzzleFlash.uc
//
// Abstract base class of third person muzzle flashes in SAS
//=============================================================================

class SAS3PMuzzleFlash extends InventoryAttachment
	abstract;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member variables

var(MuzzleFlash) int			mTickCount;			// How long to display it
var(MuzzleFlash) ELightType		mFlashLightType;
var(MuzzleFlash) ELightEffect	mFlashLightEffect;

var int							mTicksSoFar;		// internal tick count

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

simulated event PostNetBeginplay()
{
	Super.PostNetBeginPlay();

	if (SASWeaponAttachment(Owner) != None)
	{
		SASWeaponAttachment(Owner).mMuzzleFlash = Self;
		SASWeaponAttachment(Owner).HandleAttachment();
	}

}


///////////////////////////////////////////////////////////////////////////////
// Flash
//
// Called on firing a round to turn the flash on
simulated function Flash ()
{
	GotoState ('Visible');
}


//-----------------------------------------------------------------------------
// States

///////////////////////////////////////////////////////////////////////////////
// Visible state
//
// In this state after firing until timer expires.
simulated state Visible
{
	simulated event Tick(
		float		aDelta )
	{
		mTicksSoFar++;

		// Exit state after mTickCount ticks
		if ( mTicksSoFar > mTickCount )
		{
			GotoState( '' );
		}
	}

	simulated function EndState()
	{
		bHidden			= true;
		LightEffect		= LE_None;
		LightType		= LT_None;
	}

	simulated function BeginState()
	{
		local rotator	R;
		local vector	V;
	
		mTicksSoFar	= 0;
		bHidden		= false;

		// Random flash rotation
		R = RelativeRotation;
		R.Roll = Rand( 65535 );
		SetRelativeRotation( R );
	
		// Random flash scaling
		V = Default.DrawScale3D;
		V.X += (frand() * 0.6) - 0.3;
		V.Y += (frand() * 0.6) - 0.3;
		SetDrawScale3D( v );

		LightEffect = mFlashLightEffect;
		LightType	= mFlashLightType;
	}
}		


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mTickCount=1
    bLightAffectsDynamic=true
    bHidden=true
    bDynamicLight=true
    bAcceptsProjectors=false
}