//=============================================================================
// ACTION_WaitForAnimEnd.uc
//
// Latent script action to wait until current animation has completed before
// proceeding to next action. If animation is being played using the scripted
// play anim action and has a number of iterations then this action will 
// wait until all iterations have completed.
//=============================================================================

class ACTION_WaitForAnimEnd extends SASLatentScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) int		mChannel;		// Animation channel to monitor


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// CompleteOnAnimEnd
//
// Called when AnimEnd event occurs during scripting. Returns True if the anim 
// channel that has reached the end is the one that the action is monitoring.
function bool CompleteOnAnimEnd(
	int	aChannel )
{
	return ( mChannel == aChannel );
}


///////////////////////////////////////////////////////////////////////////////
// CanDoAvoidance
//
function bool CanDoAvoidance()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// ShouldSkipOnScriptResume
//
function bool ShouldSkipOnScriptResume()
{
	return true;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Wait for AnimEnd"
}