//=============================================================================
// SASGrenadePoint.uc
//
// A target grenade throwing point for NPCs
//=============================================================================

class SASGrenadePoint extends Keypoint
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.


//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars

var() float		mEnemyRange;
var() bool		mbHitOnFirstBounce;	// NPCs should throw grenades to hit GP on first bounce,
									// rather than compensate for bounce by throwing them short.

var SASAssaultVolume	mAssaultVol;	// Assault volume situated in.

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// States

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mEnemyRange=100.0000000
    Texture=Texture'EditorTx.S_GrenadePoint'
    DrawScale=0.2500000
}