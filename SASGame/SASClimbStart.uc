//=============================================================================
// SASClimbStart.uc
//
// Type of navigation point that indicates the start of an obstacle climb.
//=============================================================================

class SASClimbStart extends SASClimbPoint
	placeable
	native
	abstract;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars

var(AI) bool	mbAutoWallAdjust;		// If true then point will be moved to correct horizontal offset from wall during path-building. 

var float		mClimbHeight;			// Climb end-point Z offset.
var float		mClimbForwardDist;		// Climb end-point X offset.
var float		mWallOffset;			// Horizontal offset distance from obstacle to climb.


//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mbAutoWallAdjust=true
    mClimbHeight=16.0000000
    mClimbForwardDist=16.0000000
    mWallOffset=44.0000000
}