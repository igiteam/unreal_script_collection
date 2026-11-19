//=============================================================================
// CONDITION_NumHostagesDead.uc
//
// A triggered script condition which evaluates to true after a specified
// number of hostages have died.
//=============================================================================

class CONDITION_NumHostagesDead extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) int		mNumDead;		// Num hostages to die to trigger condition


//-----------------------------------------------------------------------------
// Functions

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
		Log ("CONDITION_NumHostagesDead; mNumDead" @mNumDead @"- Killed" @gri.mHostagesKilled @"- Num" @gri.mHostages );
		if (gri.mHostagesKilled >= mNumDead)
		{
			mbTriggered = true;
			Log (" --- TRIGGERED");
		}
		else
		{
			Log (" --- NOT TRIGGERED");
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// getCompletionPercentage
//
// Returns completion state of this condition in range 0-1
function float getCompletionPercentage ( SASGRI gri )
{
	// dead hostages are a bad thing so invert this ... (1 - n)
	return FClamp ( 1.0 - float ( gri.mHostagesKilled ) / float ( gri.mHostages ), 0.0, 1.0 );
} // getCompletionPercentage

///////////////////////////////////////////////////////////////////////////////
// getStatusString
//
// Returns context sensitive string indicating qualitative success
function string getStatusString ( SASGRI gri )
{
	return ( " (" $gri.mHostagesKilled $"/" $gri.mHostages $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
// GetProgressString
//
// Returns context sensitive string indicating qualitative success
function string GetProgressString ( SASGRI gri )
{
	return ( " (" $gri.mHostagesKilled $"/" $mNumDead $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
