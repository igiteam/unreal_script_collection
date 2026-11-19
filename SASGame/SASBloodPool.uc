//=============================================================================
// BloodPool
//
// Expanding BloodPool
//=============================================================================

class SASBloodPool extends SASExpandingProjector;

simulated event PostBeginPlay ()
{
	mGrowRateAccel -= FRand()*0.0035;
	Super.PostBeginPlay();  
}

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mGrowRate=0.0500000
    mGrowRateAccel=-0.0035000
    mGrowRateAccelStart=0.2000000
    mEndScale=0.4000000
    mInitialDrawScale=0.0050000
    mStayAlive=true
    ProjTexture=Texture'SFXTx.Wound.FxW_projblood01'
    MaxTraceDistance=50
    bGradient=false
    DrawScale=0.0050000
}