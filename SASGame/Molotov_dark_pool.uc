//=============================================================================
// Molotov_dark_pool
//
// Dark pool of fuel spreading out from a burst Molotov cocktail projectile.
//=============================================================================

class Molotov_dark_pool extends SASExpandingProjector;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mGrowRate=10.0000000
    mEndScale=0.6000000
    mInitialDrawScale=0.2000000
    mStayAlive=true
    ProjTexture=Texture'SFXTx.Damage.FxDm_blast01'
    bProjectActor=true
    bProjectOnUnlit=true
    bProjectOnBackfaces=true
    bProjectOnAlpha=true
    bProjectOnParallelBSP=true
    bDynamicAttach=true
}