//=============================================================================
// Smoke_Grenade_Projectile.uc
//
//=============================================================================

class Smoke_Grenade_Projectile extends SASGrenadeProjectile;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=3
    mTimeToExplode=0.5000000
    mExplosionClass=Class'SASEffects.Explosion_Smoke_Grenade'
    mTimeBetweenExplosions=(Min=0.0000000,Max=0.0000000)
    mbAttachExplosions=true
    mLifetimeAfterExplosions=10.0000000
    Mesh=SkeletalMesh'WpAn.SmokeGren_projectile'
    DrawScale=0.0400000
}