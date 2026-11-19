//=============================================================================
// Molotov_burn_mark
//
// Burn mark which spreads out under SASFire.
//=============================================================================

class Molotov_burn_mark extends SASExpandingProjector;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mGrowRate=0.5000000
    mEndScale=0.5000000
    mInitialDrawScale=0.5000000
    mStayAlive=true
    ProjTexture=Texture'SFXTx.Damage.FxDm_blast02'
    MaxTraceDistance=50
    FadeInTime=10.0000000
}