//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDAnimBlendByJump extends TMAnimBlendBase
	native(Animation);

enum EBlendJumpTypes
{
	FBJ_Up,				// jump
	FBJ_Down,
	FBJ_Land,
	FBJ_None
};

/** Time before predicted landing to trigger pre-land animation. */
var() float					PreLandTime;

/** The current state this node believes the pawn to be in */
var const EBlendJumpTypes 	FallState;

/** Set internally, this variable holds the size of the velocity at the last tick */
var const float				LastFallingVelocity;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


