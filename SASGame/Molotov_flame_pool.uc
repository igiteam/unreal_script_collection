//=============================================================================
// Molotov_flame_pool
//
// Fire circle, which spreads out over the fuel (see Molotov_dark_pool) 
// scattered by a burst Molotov cocktail projectile.
//=============================================================================

class Molotov_flame_pool extends SASExpandingProjector;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mGrowRate=2.5000000
    mEndScale=1.2000000
    mInitialDrawScale=0.0010000
    MaterialBlendingOp=3
    FrameBufferBlendingOp=2
    ProjTexture=Texture'SFXTx.Fire.FxF_Ring'
}