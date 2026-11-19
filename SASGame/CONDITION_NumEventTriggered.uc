//=============================================================================
// CONDITION_NumEventTriggered.uc
//
// Script condition which is enabled on a number of general level events
// occuring.
//=============================================================================

class CONDITION_NumEventTriggered extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) name		mEventTag;			// Tag of event the condition triggers on
var(Conditions) int			mNumToTrigger;		// Num events required to fire to trigger condition
var(Conditions) bool		mInitialState;

var int						mNumTriggered;		// internal count: num events fired so far

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
	mNumTriggered = 0;
	mbTriggered = mInitialState;
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
		mNumTriggered++;

//		Log ( self @aEventName @mNumTriggered );
	}

	if ( mNumTriggered == mNumToTrigger )
	{
		mbTriggered = !mInitialState;
		Log ( self $" --- TRIGGERED");
	}
}

///////////////////////////////////////////////////////////////////////////////
// getCompletionPercentage
//
// Returns completion state of this condition in range 0-1
function float getCompletionPercentage (SASGRI gri)
{
	return FClamp ( float ( mNumTriggered ) / float ( mNumToTrigger ), 0.0, 1.0 );
} // getCompletionPercentage

///////////////////////////////////////////////////////////////////////////////
// getStatusString
//
// Returns context sensitive string indicating qualitative success
function string getStatusString ( SASGRI gri )
{
	return ( " (" $mNumTriggered $"/" $mNumToTrigger $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
// GetProgressString
//
// Returns context sensitive string indicating qualitative success
function string GetProgressString ( SASGRI gri )
{
	return ( " (" $mNumTriggered $"/" $mNumToTrigger $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
