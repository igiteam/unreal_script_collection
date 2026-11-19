//=============================================================================
// ACTION_WaitForTimer.uc
//
// Latent script action to wait for a specified time before proceeding to 
// next action.
//=============================================================================

class ACTION_WaitForTimer extends SASLatentScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) float	mPauseTime;		// Time to wait
var(Action) byte	mWhichTimer;	// and which concept of time is this.


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	Super.DoAction( aInterface );
	
	aInterface.SetInterfaceActorTimer( mPauseTime, mWhichTimer );
	
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// CompleteWhenTimer
//
function bool CompleteWhenTimer()
{
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mPauseTime;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Wait for Timer"
}