// This class represents a start point for a player in a multiplayer game. It
// is explicitly NOT a subclass of PlayerStart because we don't want it to
// interfere with the single-player navigation and awareness code.
class SwatMPStartPoint extends Engine.Actor 

	native;

var editconst float LastSpawnCampTime; 
var() editconst SwatMPStartCluster Cluster "This is the start cluster with which this start point is associated";
var	const bool	bNotBased;		// used by path builder - if true, no error reported if node doesn't have a valid base

///////////////////////////////////////////////////////////////////////////////

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

///////////////////////////////////////////////////////////////////////////////























// Decompiled with UE Explorer.
defaultproperties
{
    bHidden=true
    bNoDelete=true
    bStasis=true
    Texture=Texture'EditorSprites.SwatMPStartPoint'
    bCollideWhenPlacing=true
    CollisionRadius=24.0000000
    CollisionHeight=68.0000000
    bCollideActors=true
    bBlockZeroExtentTraces=false
    bDirectional=true
}