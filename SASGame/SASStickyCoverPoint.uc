//=============================================================================
// SASStickyCoverPoint.uc
//
// A cover point which calls for nearby terrorists to occupy it when unoccupied.
//=============================================================================

class SASStickyCoverPoint extends SASCoverPoint
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

var() float	mRange;					// Range to search for terrorists when unoccupied
var() bool	mbStartActive;			// Start in sticky mode?
var() int	mPriority;				// Priority over other sticky CPs
var() float	mMinExposedDistToEnemy;	// Min distance from enemy that CP is exposed to for which CP will call terrorists 

//-----------------------------------------------------------------------------
// Member Vars

//-----------------------------------------------------------------------------
// Native Functions

///////////////////////////////////////////////////////////////////////////////
// SearchForOccupier
//
// Search for best terrorist in range to occupy this point and call them to it.
native final function SearchForOccupier();


//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
// 
event PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( mbStartActive )
	{
		Trigger( None, None );
	}
}


///////////////////////////////////////////////////////////////////////////////
// Trigger
// 
// Activates the sticky CP to start searching for occupiers.
function Trigger(
	Actor	aOther,
	Pawn	aEventInstigator )
{
	SetTimer( 0.4 + (FRand() * 0.2), true );
}


///////////////////////////////////////////////////////////////////////////////
// Timer
// 
event Timer()
{
	if ( mOwner == None )
	{
		SearchForOccupier();
	}
}


//-----------------------------------------------------------------------------
// States

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mRange=255.0000000
    mbStartActive=true
    mMinExposedDistToEnemy=512.0000000
    Texture=Texture'EditorTx.S_StickyCover'
    bStatic=false
}