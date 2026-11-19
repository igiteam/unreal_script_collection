//=============================================================================
// L2A2_Grenade_Projectile.uc
//
//=============================================================================

class L2A2_TerrGrenade_Projectile extends SASGrenadeProjectile;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=0
    mBounceDamping=0.5800000
    mTimeToExplode=2.5000000
    mExplosionClass=Class'SASEffects.Explosion_L2A2_Grenade'
    mTimeBetweenExplosions=(Min=0.0000000,Max=0.0000000)
    mImpactSounds=/* Array type was not detected. */
    mImpactSoundsSoft=/* Array type was not detected. */
    Speed=750.0000000
    MaxSpeed=1200.0000000
    TossZ=120.0000000
    Mesh=SkeletalMesh'WpAn.Grenade_Projectile'
}