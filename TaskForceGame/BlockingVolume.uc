//=============================================================================
// BlockingVolume:  a bounding volume
// used to block certain classes of actors
// primary use is to provide collision for non-zero extent traces around static meshes 

//=============================================================================

class BlockingVolume extends Volume
	native;

var() bool bClampFluid;
var() bool ActAsWorld;

function PreBeginPlay()
{
	bWorldGeometry = ActAsWorld;
}


// Decompiled with UE Explorer.
defaultproperties
{
    bClampFluid=true
    ActAsWorld=true
    bWorldGeometry=true
    bBlockActors=true
    bBlockPlayers=true
    bBlockZeroExtentTraces=false
    bBlockKarma=true
}