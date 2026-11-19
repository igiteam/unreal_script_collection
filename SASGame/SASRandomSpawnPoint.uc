//=============================================================================
// Player start location.
//=============================================================================
class SASRandomSpawnPoint extends NavigationPoint
	placeable
	native;

//#exec Texture Import File=Textures\S_Random.pcx Name=S_Terrorist Mips=Off MASKED=1

//-----------------------------------------------------------------------------
// Includes

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

var() bool		bEnabled;

var() float		mOccupationDistance;	// Distance within which a pawn is considered
										// to occupy this spawn point
var() int		mSide;
var() bool		mbMultiplayerOnly;		// In single player, only primary points are considered.
										// Secondary points are used for finding a spawn point
										// Out of players views in multiplayer.

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default Propeerties


// Decompiled with UE Explorer.
defaultproperties
{
    bEnabled=true
    mOccupationDistance=118.0000000
    mSide=-1
    Texture=Texture'Engine.S_Player'
    CollisionRadius=28.0000000
    CollisionHeight=32.0000000
    bDirectional=true
}