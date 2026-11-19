class SASPlayerClimbVolume extends Volume
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

// Offset distances from climb obstacle for pawn to start at before playing climb anim.
const CLIMBOFFSET_Small			= -32.0;
const CLIMBOFFSET_Large			= -18.0;
const CLIMBOFFSET_OverWall		= -32.0;
const CLIMBOFFSET_ThruWindow	= -32.0;

const CLIMB_OVER_WALL_THICKNESS	= 16.0;

var() rotator		mWallDir;
var() EClimbType	meClimbType;

var const Vector	mCentre;		// Centre of volume - calculated on loading. TODO: Ideally calc during level save.
var const Vector	mVecWallDir;	// mWallDir converted to direction vector.

native function Vector GetClimbStartPoint(
	SASPawn	aPawn );


// Decompiled with UE Explorer.
defaultproperties
{
    meClimbType=1
    BrushColor=(R=0,G=255,B=0,A=255)
}