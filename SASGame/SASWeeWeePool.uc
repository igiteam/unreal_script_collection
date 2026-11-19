//=============================================================================
// SASWeeWeePool
//
//=============================================================================

class SASWeeWeePool extends SASExpandingProjector;

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
    mEndScale=1.0000000
    mInitialDrawScale=0.0100000
    mStayAlive=true
    ProjTexture=Texture'SFXTx.Slash.Fx_urine'
    MaxTraceDistance=16
    DrawScale=0.0100000
}