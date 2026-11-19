///////////////////////////////////////////////////////////////////////////////
// ClearRoutePoint.uc - ClearRoutePoint class
// A point that Officer AIs will use when clearing a room.  It is a hint for 
// the route they should take to get to a ClearPoint.

class ClearRoutePoint extends Engine.PathNode
	native
	placeable;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//
// Variables

var()	edfindable ClearPoint	ClearPoint			"The ClearPoint we are associated with";
var()	int						ClearRoutePriority	"The priority of our point out of all ClearRoutePoints to our ClearPoint";

///////////////////////////////////////////////////////////////////////////////

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

///////////////////////////////////////////////////////////////////////////////









// Decompiled with UE Explorer.
defaultproperties
{
    Texture=Texture'SWAT4editorTex.ClearRoutePoint'
}