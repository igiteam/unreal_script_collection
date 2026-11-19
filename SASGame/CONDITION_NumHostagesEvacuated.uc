//=============================================================================
// CONDITION_NumHostagesEvacuatad.uc
//
// A triggered script condition which evaluates to true after a specified
// number of hostages have been evacuated.
//=============================================================================

class CONDITION_NumHostagesEvacuated extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) int		mNumEvacuated;		// Num hostages to evacuate to trigger condition


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
		if ( gri.mHostagesEvacuated >= mNumEvacuated )
		{
			mbTriggered = true;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// getCompletionPercentage
//
// Returns completion state of this condition in range 0-1
function float getCompletionPercentage (SASGRI gri)
{
	return FClamp ( float ( gri.mHostagesEvacuated ) / float ( gri.mHostages ), 0.0, 1.0 );
} // getCompletionPercentage

///////////////////////////////////////////////////////////////////////////////
// getStatusString
//
// Returns context sensitive string indicating qualitative success
function string getStatusString (SASGRI gri)
{
	return ( " (" $gri.mHostagesEvacuated $"/" $gri.mHostages $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
// GetProgressString
//
// Returns context sensitive string indicating qualitative success
function string GetProgressString (SASGRI gri)
{
	return ( " (" $gri.mHostagesEvacuated $"/" $mNumEvacuated $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
