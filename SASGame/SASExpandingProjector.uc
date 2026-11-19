//=============================================================================
// SASExpandingProjector.
//=============================================================================
class SASExpandingProjector extends Projector
	native
	placeable;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

#exec OBJ LOAD FILE=..\Textures\SFXTx.utx PACKAGE=SFXTx

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

var() float		mGrowRate;
var() float		mGrowRateAccel;
var() float		mGrowRateAccelStart;
var() float		mEndScale;
var() float		mInitialDrawScale;	// ICHACK - make editor changes easier
var() float		mTime;
var() bool		mStayAlive;
var() bool		mDone;
var() bool		mStopWhenNoVel;


//-----------------------------------------------------------------------------
// UC functions
//

//-----------------------------------------------------------------------------
//
//
// ICHACK - allow molotov's to trigger in the editor
event PreBeginPlay()
{
	// override Actor.PreBeginPlay -> otherwise class is Destroy()'d on construction in editor
	if(ProjTexture==None)
	{
		Destroy();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Reset
//
// Destroy on restarting level.
simulated function Reset()
{
	Destroy();
}

//-----------------------------------------------------------------------------
//
//
function Stop ()
{
	mEndScale = DrawScale;
}

//-----------------------------------------------------------------------------
//
//

// Decompiled with UE Explorer.
defaultproperties
{
    mGrowRate=0.2500000
    mGrowRateAccelStart=10000.0000000
    mEndScale=3.0000000
    mInitialDrawScale=1.0000000
    mStopWhenNoVel=true
    FOV=1
    bProjectActor=false
    bGradient=true
    bStatic=false
}