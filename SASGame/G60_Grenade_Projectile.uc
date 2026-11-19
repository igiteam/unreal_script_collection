//=============================================================================
// G60_Grenade_Projectile.uc
//
//=============================================================================

class G60_Grenade_Projectile extends SASGrenadeProjectile;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=1
    mBounceDamping=0.5800000
    mTimeToExplode=0.7000000
    mExplosionClass=Class'SASEffects.Explosion_G60_Grenade'
    mNumExplosions=7
    mTimeBetweenExplosions=(Min=0.2500000,Max=0.3500000)
    mImpactSounds=/* Array type was not detected. */
    mImpactSoundsSoft=/* Array type was not detected. */
    Speed=750.0000000
    MaxSpeed=1200.0000000
    TossZ=120.0000000
    Mesh=SkeletalMesh'WpAn.FlashBang_Projectile'
    DrawScale=0.8000000
}