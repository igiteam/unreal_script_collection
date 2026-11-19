//=============================================================================
// CONDITION_TerroristCaptured.uc
//
// A triggered script condition which evaluates to true after a specified
// terrorist has been captured.
//=============================================================================

class CONDITION_TerroristCaptured extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) SASTerrorist	mCaptured;	// Terrorist to capture to trigger condition


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// NotifyCapture
//
// Event received when an SASPawn is captured.
event NotifyCaptured (
	SASPawn	aCaptured )
{
	// Check if terrorist captured is trigger.
	if ( !mbTriggered && ( aCaptured == mCaptured ) )
	{
		mbTriggered = true;
	}
}

///////////////////////////////////////////////////////////////////////////////
// NotifyKillCaptured
//
// Event received when a captured SASPawn is killed.
event NotifyCapturedKill(
	SASPawn	aKilled,
	Actor	aKiller )
{
	// Check if terrorist killed is trigger.
	if ( mbTriggered && ( aKilled == mCaptured ) )
	{
		mbTriggered = false;
	}
}
