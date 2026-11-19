
//=============================================================================
// Molotov_Cocktail_Projectile.uc
//
//=============================================================================

class Molotov_Cocktail_Projectile extends SASMolotov_Cocktail_Projectile
	placeable;		// ICHACK - allow molotov's to trigger in the editor

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mPoolOfFireClass=Class'SASEffects.Molotov_fire_area'
    mFuelBurstEffectClass=Class'SASEffects.Molotov_dark_pool'
    mFlameBurstEffectClass=Class'SASEffects.Molotov_flame_pool'
    mScatterRange=(Min=40.0000000,Max=40.0000000)
    mCategory=4
    mExplosionClass=Class'SASEffects.Explosion_Molotov_Cocktail'
    TossZ=36.0000000
    CollisionRadius=1.0000000
    CollisionHeight=1.0000000
}