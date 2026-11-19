//=============================================================================
// CONDITION_VolumeCleared.uc
//
// A triggered script condition which evaluates to true after a specified
// terrorist has been captured.
//=============================================================================

class CONDITION_VolumeCleared extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) SASAssaultVolume	mVolume;				// Volume to clear to trigger condition


//-----------------------------------------------------------------------------
// Functions
//

///////////////////////////////////////////////////////////////////////////////
// NotifyVolumeCleared
//
// Event received when a volume is cleared
event NotifyVolumeCleared (
	SASAssaultVolume	aVolume)
{
	// Check if volume cleared is trigger.
	if ( !mbTriggered && ( aVolume == mVolume ) )
	{
		mbTriggered = true;
	}
}
