//=============================================================================
// CONDITION_EventTriggered.uc
//
// Script condition which is enabled/disabled on a general level event occuring.
// Condition can be set to toggle to evaluating true/false on repeated 
// occurances of event. 
// User can also specify the initial evaluation state of the condition.
//=============================================================================

class CONDITION_EventTriggeredEventScored extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) name		mEventTag;			// Tag of event the condition triggers on
var(Conditions) bool		mbInitialState;		// Initial evaluation state
var(Conditions)	bool		mbCanBeUntriggered;	// If true then condition can be reset by untrigger event
var(Conditions) bool		mbTogglable;		// Flags if condition can be toggled

struct ScoreEvent
{
	var()	Array<Name>	mEvent;
	var()	float		mAffect;
	var		bool		mbTriggered;
};

var(Scoring) editinline Array<ScoreEvent>		mScoreEvent;

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called on script initialisation at start of level.
function Init(
	SASScriptedSequence	aOwnerScript )
{
	local int i;

	Super.Init( aOwnerScript );

	// Set initial condition evaluation state
	mbTriggered = mbInitialState;

	for ( i = 0; i < mScoreEvent.Length; i++ )
	{
		mScoreEvent[i].mbTriggered = false;
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyEventTriggered
//
// Event received when a general level event is triggered.
event NotifyEventTriggered(
	name aEventName )
{
	local int i;
	local int j;

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
	else
	{
		for ( i = 0; i < mScoreEvent.Length; i++ )
		{
			for ( j = 0; j < mScoreEvent[i].mEvent.Length; j++ )
			{
				if ( aEventName == mScoreEvent[i].mEvent[j] )
				{
					mScoreEvent[i].mbTriggered = true;
//					Log ( self $".NotifyScoreEventTriggered:" @aEventName );
				}
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyEventUntriggered
//
// Event received when a general level event is untriggered.
event NotifyEventUnTriggered(
	name aEventName )
{	
	local int i;
	local int j;

	if ( mbCanBeUnTriggered && ( aEventName == mEventTag ) )
	{
		mbTriggered = mbInitialState;
//		Log ( self $".NotifyEventUntriggered:" @aEventName @mbTriggered );
	}
	else if ( mbTriggered == mbInitialState )	// don't mess about once this has been triggered
	{
		for ( i = 0; i < mScoreEvent.Length; i++ )
		{
			for ( j = 0; j < mScoreEvent[i].mEvent.Length; j++ )
			{
				if ( aEventName == mScoreEvent[i].mEvent[j] )
				{
					mScoreEvent[i].mbTriggered = false;
//					Log ( self $".NotifyScoreEventUntriggered:" @aEventName );
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// getCompletionPercentage
//
// Returns completion state of this condition in range 0-n
// used as a multiplier for final score
function float getCompletionPercentage ( SASGRI gri )
{
	local float affector;
	local int i;

	affector = 0;

	for ( i = 0; i < mScoreEvent.Length; i++ )
	{
		if ( mScoreEvent[i].mbTriggered )
		{
			affector += mScoreEvent[i].mAffect;
			Log ( self $".getCompletionPercentage: #" @i @"is" @mScoreEvent[i].mAffect );
		}
	}

	Log ( self $".getCompletionPercentage: total" @affector );

	return affector;
} // getCompletionPercentage
