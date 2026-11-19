//=============================================================================
// CONDITION_NumTerroristsCaptured.uc
//
// A triggered script condition which evaluates to true after a specified
// number of terrorists have been captured.
//=============================================================================

class CONDITION_NumTerroristsCaptured extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) int	mNumCaptured;	// Num terrorists to capture to trigger condition


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// NotifyCaptured
//
// Event received when an SASPawn is captured.
event NotifyCaptured (
	SASPawn	aCaptured )
{
	local SASGRI gri;

	gri = SASGRI ( aCaptured.Level.GetLocalPlayerController ().GameReplicationInfo );

	if ( !mbTriggered && ( aCaptured.GetGame() != None ) )
	{
		// Check if num terrorists killed in level meets trigger number.
		if ( gri.mTerroristsCaptured >= mNumCaptured )
		{
			mbTriggered = true;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// NotifyKillCaptured
//
// Event received when a captured SASPawn is killed.
event NotifyCapturedKill (
	SASPawn	aCaptured,
	Actor	aCapturer )
{
	local SASGRI gri;

	gri = SASGRI ( aCaptured.Level.GetLocalPlayerController ().GameReplicationInfo );

	if ( mbTriggered && ( aCaptured.GetGame() != None ) )
	{
		// Check if num terrorists killed in level meets trigger number.
		if ( gri.mTerroristsCaptured < mNumCaptured )
		{
			mbTriggered = false;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// GetProgressString
//
// Returns context sensitive string indicating qualitative success
function string GetProgressString ( SASGRI gri )
{
	return ( " (" $gri.mTerroristsCaptured $"/" $mNumCaptured $")" );
} // getStatusString
