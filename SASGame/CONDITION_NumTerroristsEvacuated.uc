//=============================================================================
// CONDITION_NumTerroristsEvacuatad.uc
//
// A triggered script condition which evaluates to true after a specified
// number of terrorists have been evacuated.
//=============================================================================

class CONDITION_NumTerroristsEvacuated extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) int		mNumEvacuated;		// Num terrorists to evacuate to trigger condition


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
		// Check if num hostages killed in level meets trigger number.
		if ( gri.mTerroristsEvacuated >= mNumEvacuated )
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
	return FClamp ( float ( gri.mTerroristsEvacuated ) / float ( gri.mTerrorists ), 0.0, 1.0 );
} // getCompletionPercentage

///////////////////////////////////////////////////////////////////////////////
// getStatusString
//
// Returns context sensitive string indicating qualitative success
function string getStatusString ( SASGRI gri )
{
	return ( " (" $gri.mTerroristsEvacuated $"/" $gri.mTerrorists $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
// GetProgressString
//
// Returns context sensitive string indicating qualitative success
function string GetProgressString ( SASGRI gri )
{
	return ( " (" $gri.mTerroristsEvacuated $"/" $mNumEvacuated $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
