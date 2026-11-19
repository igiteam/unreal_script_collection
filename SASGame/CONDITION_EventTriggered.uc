//=============================================================================
// CONDITION_EventTriggered.uc
//
// Script condition which is enabled/disabled on a general level event occuring.
// Condition can be set to toggle to evaluating true/false on repeated 
// occurances of event. 
// User can also specify the initial evaluation state of the condition.
//=============================================================================

class CONDITION_EventTriggered extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) name		mEventTag;			// Tag of event the condition triggers on
var(Conditions) bool		mbInitialState;		// Initial evaluation state
var(Conditions)	bool		mbCanBeUntriggered;	// If true then condition can be reset by untrigger event
var(Conditions) bool		mbTogglable;		// Flags if condition can be toggled


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called on script initialisation at start of level.
function Init(
	SASScriptedSequence	aOwnerScript )
{
	Super.Init( aOwnerScript );

	// Set initial condition evaluation state
	mbTriggered = mbInitialState;
}


///////////////////////////////////////////////////////////////////////////////
// NotifyEventTriggered
//
// Event received when a general level event is triggered.
event NotifyEventTriggered(
	name aEventName )
{
	if ( aEventName == mEventTag )
	{
		if ( mbTogglable )
		{
			mbTriggered = !mbTriggered;
		}
		else
		{
			mbTriggered = !mbInitialState;
		}

//		Log ( self $".NotifyEventTriggered:" @aEventName @mbTriggered );
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyEventUntriggered
//
// Event received when a general level event is untriggered.
event NotifyEventUnTriggered(
	name aEventName )
{	
	if ( mbCanBeUnTriggered && (aEventName == mEventTag) )
	{
		mbTriggered = mbInitialState;
//		Log ( self $".NotifyEventUntriggered:" @aEventName @mbTriggered );
	}
}
