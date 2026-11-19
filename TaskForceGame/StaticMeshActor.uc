//=============================================================================
// StaticMeshActor.
// An actor that is drawn using a static mesh(a mesh that never changes, and
// can be cached in video memory, resulting in a speed boost).
//=============================================================================

class StaticMeshActor extends Actor
	native
	placeable;

var() bool bExactProjectileCollision;		// nonzero extent projectiles should shrink to zero when hitting this actor

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    bExactProjectileCollision=true
    DrawType=8
    bStatic=true
    bWorldGeometry=true
    bAcceptsProjectors=false
    bShowBulletHoles=true
    bShadowCast=true
    bStaticLighting=true
    CollisionRadius=1.0000000
    CollisionHeight=1.0000000
    bCollideActors=true
    bBlockActors=true
    bBlockPlayers=true
    bBlockKarma=true
    bEdShouldSnap=true
}