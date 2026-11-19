//=============================================================================
// ACTION_WaitUntilLevelTime.uc
//
// Latent script action to wait until a specified level time has passed before
// proceeding to next action.
//=============================================================================

class ACTION_WaitUntilLevelTime extends SASLatentScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) float	mLevelTime;		// Level time to complete action
var(Action) byte	mWhichTimer; // which of the timers this means


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local float pauseTime;
	local float	elapsedTime;

	elapsedTime = mOwnerScript.Level.TimeSeconds - mOwnerScript.Level.Game.StartTime;

	pauseTime = mLevelTime - elapsedTime;
	if ( pauseTime > 0.0 )
	{
		Super.DoAction( aInterface );

		aInterface.SetInterfaceActorTimer( mLevelTime, mWhichTimer );

		return false; 
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// CompleteWhenTimer
//
function bool CompleteWhenTimer ()
{
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mLevelTime@mWhichTimer;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Wait until Level Time"
}