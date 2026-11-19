//=============================================================================
// ACTION_ShakeView.uc
//
//=============================================================================

class ACTION_ShakeView extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) float mViewRollTime;			// how long to roll the instigator's view
var(Action) float mRollMag;					// how far to roll view
var(Action) float mRollRate;				// how fast to roll view
var(Action) float mOffsetMagVertical;		// max view offset vertically
var(Action) float mOffsetRateVertical;		// how fast to offset view vertically
var(Action) float mOffsetMagHorizontal;		// max view offset horizontally
var(Action) float mOffsetRateHorizontal;	// how fast to offset view horizontally
var(Action) float mOffsetIterations;		// how many iterations to offset view


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction (
	SASScriptInterface	aInterface )
{
	local Controller	C;
	local vector		offsetMag;
	local vector		offsetRate;

	offsetMag	= mOffsetMagHorizontal * vect(1,1,0) + mOffsetMagVertical * vect(0,0,1);
	offsetRate	= mOffsetRateHorizontal * vect(1,1,0) + mOffsetRateVertical * vect(0,0,1);

	for ( C = mOwnerScript.Level.ControllerList; C != None; C = C.NextController )
	{
		if ( PlayerController(C) != None )	
		{
			C.ShakeView( mViewRollTime, mRollMag, offsetMag, mRollRate, offsetRate, mOffsetIterations );
		}
	}

	return true;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mOffsetMagVertical=1.0000000
    mOffsetRateVertical=400.0000000
    mOffsetMagHorizontal=1.0000000
    mOffsetRateHorizontal=353.0000000
    mOffsetIterations=10.0000000
    mActionString="Shake view"
}