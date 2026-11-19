//=============================================================================
// ACTION_FadeView.uc
//
//=============================================================================

class ACTION_FadeView extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) float	mFadeTime;
var(Action) Color	mFadeColour;	
var(Action) bool	mbFadeUp;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local Controller	C;
	
	// Fade screen on all player controllers
	for ( C = mOwnerScript.Level.ControllerList; C != None; C = C.nextController )
	{
		if ( SASPlayerController( C ) != None )
		{
			SASPlayerController( C ).FadeScreen( mFadeColour, mFadeTime, mbFadeUp );
		}
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mFadeTime;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mFadeTime=5.0000000
    mActionString="Fade view"
}