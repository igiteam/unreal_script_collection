//=============================================================================
// SASClimbEnd.uc
//
// Navigation point which marks the end-point of a climb. SASClimbStart type
// nav-points automatically add these at the correct offset location during
// path-building.
//=============================================================================

class SASClimbEnd extends SASClimbPoint
	notplaceable
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars

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
    mbUseAsEndPoint=true
    Texture=Texture'EditorTx.S_ClimbEnd'
    DrawScale=0.2500000
}