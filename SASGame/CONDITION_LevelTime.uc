//=============================================================================
// CONDITION_GroupCondition.uc
//
// A script condition which evaluates to true after a specified level time
// has passed.
//=============================================================================

class CONDITION_LevelTime extends SASScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) float		mTime;			// Level time to pass before condition is met

var (Conditions) float		mMinTime;		// Used for scoring - this is the time at which maximum points are scored
var float					mStartTime;		// Time at which this condition was kicked off


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Evaluate
//
// Evaluate the condition.
function bool Evaluate(
	SASAIController	aController )
{
	local bool	result;
	local float	elapsedTime;

	elapsedTime = mOwnerScript.Level.TimeSeconds - mOwnerScript.Level.Game.StartTime;
	if ( elapsedTime > mTime )
	{
		result = true;
	}

	return CheckNotOperator( result );
}

///////////////////////////////////////////////////////////////////////////////
// setStartTime
//
// Sets the level time when this condition was activated
event setStartTime (float time)
{
	mStartTime = time;
} // setStartTime

///////////////////////////////////////////////////////////////////////////////
// getCompletionPercentage
//
// Returns completion state of this condition in range 0-1
//::function float getCompletionPercentage (SASGRI gri)
//::{
//::	// If minimum time is -1, this becomes a binary condition
//::	if (mMinTime == -1.0)
//::	{
//::		if ((mOwnerScript.Level.TimeSeconds - mStartTime) > mTime)
//::		{
//::			return 0.0;
//::		} // if
//::		else
//::		{
//::			return 1.0;
//::		} // else
//::	} // if
//::	else
//::	{
//::		if ((mOwnerScript.Level.TimeSeconds - mStartTime) <= mMinTime)
//::		{
//::			return 1.0;
//::		} // if
//::		else if ((mOwnerScript.Level.TimeSeconds - mStartTime) < mTime)
//::		{
//::			return (mOwnerScript.Level.TimeSeconds - mStartTime) / mTime;
//::		} // else if
//::		else
//::		{
//::			return 0.0;
//::		} // else
//::	} // else
//::
//::	return 0.0;
//::} // getCompletionPercentage

//------------------------------------------------------------------------------
// defaultproperties
//

// Decompiled with UE Explorer.
defaultproperties
{
    mMinTime=-1.0000000
}