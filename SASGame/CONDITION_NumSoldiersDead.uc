//=============================================================================
// CONDITION_NumSoldiersDead.uc
//
// A triggered script condition which evaluates to true after a specified
// number of squad members have died.
//=============================================================================

class CONDITION_NumSoldiersDead extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) int		mNumDead;		// Num hostages to die to trigger condition


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// NotifyKill
//
// Event received when an SASPawn is killed.
event NotifyKill (
	SASPawn	aKilled,
	Actor	aKiller)
{
	local SASGRI gri;

	gri = SASGRI ( aKilled.Level.GetLocalPlayerController ().GameReplicationInfo );

	if ( !mbTriggered && ( aKilled.GetGame () != None ) )
	{
		// Check if num squad members killed in level meets trigger number.
		if ( gri.mSquadMembersKilled >= mNumDead )
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
	// dead squaddies are a bad thing so invert this ... (1 - n)
	return FClamp ( 1.0 - float ( gri.mSquadMembersKilled ) / float ( gri.mSquadMembers ), 0.0, 1.0 );
} // getCompletionPercentage

///////////////////////////////////////////////////////////////////////////////
// getStatusString
//
// Returns context sensitive string indicating qualitative success
function string getStatusString ( SASGRI gri )
{
	return ( " (" $gri.mSquadMembersKilled $"/" $gri.mSquadMembers $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
// GetProgressString
//
// Returns context sensitive string indicating qualitative success
function string GetProgressString ( SASGRI gri )
{
	return ( " (" $gri.mSquadMembersKilled $"/" $mNumDead $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
