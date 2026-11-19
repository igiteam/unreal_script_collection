//=============================================================================
// CONDITION_VolumeCleared.uc
//
// A triggered script condition which evaluates to true after a specified
// terrorist has been captured.
//=============================================================================

class CONDITION_VolumeClearedEventEnabled extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) SASAssaultVolume	mVolume;				// Volume to clear to trigger condition
var(Conditions) name				mClearEnableEvent;		// Tag of event the condition enables on
var(Conditions) bool				mbInitialState;			// Initial evaluation state
var(Conditions) bool				mbTogglable;			// Flags if condition can be toggled

var bool							mbEnabled;


//-----------------------------------------------------------------------------
// Functions
//

///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called on script initialisation at start of level.
function Init(
	SASScriptedSequence	aOwnerScript )
{
	Super.Init( aOwnerScript );

	// Set initial condition evaluation state
	mbEnabled = mbInitialState;
}


///////////////////////////////////////////////////////////////////////////////
// NotifyEventTriggered
//
// Event received when a general level event is triggered.
event NotifyEventTriggered(
	name aEventName )
{
	if ( aEventName == mClearEnableEvent )
	{
		if ( mbTogglable )
		{
			mbEnabled = !mbEnabled;

			// flip status if necessary
			if ( !mbEnabled && mbTriggered )
			{
				mbTriggered = false;
			}
		}
		else
		{
			mbEnabled = !mbInitialState;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyVolumeCleared
//
// Event received when a volume is cleared
event NotifyVolumeCleared (
	SASAssaultVolume	aVolume)
{
	// Check if volume cleared is trigger.
	if ( !mbTriggered && ( aVolume == mVolume ) && mbEnabled )
	{
		mbTriggered = true;
	}
}


///////////////////////////////////////////////////////////////////////////////
// defaultproperties
//
