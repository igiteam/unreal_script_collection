//=============================================================================
// SASCoverPoint.uc
//
//=============================================================================

class SASAIMapObj extends KeyPoint
	abstract
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

const MAX_EP_GUARDING_RANGE		= 500.0;


//-----------------------------------------------------------------------------
// Member Vars

var(TacticalPoint) ESASStance						meStance;			// Stance to be taken by a pawn at this point
var(TacticalPoint) const editconst NavigationPoint	mNavAnchor;	// Anchor nav point found during path-build process.
var(TacticalPoint) const edfindable NavigationPoint	mAdditionalAnchors[2];	// Manually selected anchors.

var const array<SASEntryPoint>	mVisibleEPs;		// List of EPs in our AV which are relevant for guarding from this point.
var	vector						mDirection2D;		// XY direction vector of point.
var const SASAssaultVolume		mAssaultVol;		// Assault volume point resides in.
var	Pawn						mOwner;				// Current owner of the point.


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
event PostBeginPlay()
{
	// Calculate and store 2D direction vector
	mDirection2D = Vector( Rotation );
	mDirection2D.Z = 0.0;
	mDirection2D = Normal( mDirection2D );

	memRegister ();
}


///////////////////////////////////////////////////////////////////////////////
// Acquire
//
function bool Acquire(
	Pawn	aTaker )
{
	if ( (aTaker == None) || (mOwner != None) )
	{
		return false;
	}
	
	mOwner = aTaker;
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// Relinquish
//
event Relinquish(
	Pawn	aRelinquisher )
{
	if ( aRelinquisher != mOwner)
	{
		Warn( "Non-owner pawn "$aRelinquisher$" tryed to relinquish point "$self );
		return;
	}

	mOwner = None;
}


//-----------------------------------------------------------------------------
// Default Properties



// Decompiled with UE Explorer.
defaultproperties
{
    CollisionHeight=32.0000000
}