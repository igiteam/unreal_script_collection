//=============================================================================
// CONDITION_NumHostagesDeadOrEvacuated.uc
//
// A triggered script condition which evaluates to true when the specified number of
// hostages in the level are dead or evacuated.
//=============================================================================

class CONDITION_NumHostagesDeadOrEvacuated extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) int		mNumDeadOrEvac;		// Num hostages dead/to evacuate to trigger condition


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// NotifyEvacuated
//
// Event received when an SASPawn is evacuated.
event NotifyEvacuated (
	SASPawn	aEvacuated )
{
	local SASGRI gri;

	gri = SASGRI ( aEvacuated.Level.GetLocalPlayerController ().GameReplicationInfo );

	if ( !mbTriggered && ( aEvacuated.GetGame () != None ) )
	{
		// Check if num hostages evacuated in level meets trigger number.
		if ( (gri.mHostagesKilled + gri.mHostagesEvacuated) >= mNumDeadOrEvac ) 
		{
			mbTriggered = true;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyKill
//
// Event received when an SASPawn is killed.
event NotifyKill(
	SASPawn	aKilled,
	Actor	aKiller )
{
	local SASGRI gri;

	gri = SASGRI(aKilled.Level.GetLocalPlayerController().GameReplicationInfo);

	if (!mbTriggered && (aKilled.GetGame() != None))
	{
		// Check if num hostages killed in level meets trigger number.
		if ( (gri.mHostagesKilled + gri.mHostagesEvacuated) >= mNumDeadOrEvac ) 
		{
			mbTriggered = true;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// getCompletionPercentage
//
// Returns completion state of this condition in range 0-1
function float getCompletionPercentage ( SASGRI gri )
{
//	return FClamp ( float ( gri.mHostagesKilled + gri.mHostagesEvacuated ) / float ( gri.mHostages ), 0.0, 1.0 );

	// cheat slightly here as we're only really interested in evacuated hostages ...
	return FClamp ( float ( gri.mHostagesEvacuated ) / float ( mNumDeadOrEvac ), 0.0, 1.0 );
} // getCompletionPercentage

///////////////////////////////////////////////////////////////////////////////
// getStatusString
//
// Returns context sensitive string indicating qualitative success
function string getStatusString ( SASGRI gri )
{
//	return ( " (" $( gri.mHostagesKilled + gri.mHostagesEvacuated ) $"/" $gri.mHostages$ ")" );
	return ( " (" $gri.mHostagesEvacuated $"/" $mNumDeadOrEvac $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
// GetProgressString
//
// Returns context sensitive string indicating qualitative success
function string GetProgressString ( SASGRI gri )
{
	return ( " (" $( gri.mHostagesKilled + gri.mHostagesEvacuated ) $"/" $mNumDeadOrEvac $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
