//=============================================================================
// Molotov_fire_area
//
// Editable SASFireArea used by Molotov_coctail_weapon.
//=============================================================================

class Molotov_fire_area extends SASFireArea
	placeable;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mRadius=60.0000000
    mFireClass=Class'molotov_fire'
    mBurnMarkClass=Class'Molotov_burn_mark'
    mBlastSpacing=10.0000000
    mAngleIncrementRange=(Min=1.0000000,Max=1.5000000)
    mHeatDamagePerSecond=5.0000000
    mFlameDamagePerSecond=20.0000000
    mDamageDist=(Min=40.0000000,Max=60.0000000)
    LightBrightness=255.0000000
    LightRadius=4.0000000
    bHidden=true
}