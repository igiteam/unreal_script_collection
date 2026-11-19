//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDNegotiationAgent extends Actor
native(HDNegotiation)
placeable;

enum ENegoType
{
    NT_None,
    NT_Over,
    NT_Jump,
    NT_Climb,
    NT_ClimbOver,
};

var() bool bAutoAdjustHeight;
var() duplicatetransient ENegoType Type;
var() duplicatetransient editconst HDNegotiationPoint NegoPoints[2]; //slot 0 & 1
var() const /*editconst*/ editfixedsize array<vector> PointOffset;

var   StaticMeshComponent RefMesh;

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
// (cpptext)

