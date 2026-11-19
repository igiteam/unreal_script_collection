//=============================================================================
// ACTION_TriggerEvent.uc
//
// Script action to trigger an event.
//=============================================================================

class ACTION_TriggerEvent extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mEventTag;			// Name of event to trigger
var(Action) bool	mbUntriggerEvent;	// Untrigger rather than trigger the event.

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local Pawn instigatorPawn;

	if ( mEventTag != 'None' )
	{
		if ( aInterface.mAIController != None )
		{
			instigatorPawn = aInterface.mAIController.Pawn;
		}

		if ( !mbUntriggerEvent )
		{
			mOwnerScript.TriggerEvent( mEventTag, mOwnerScript, instigatorPawn );
		}
		else
		{
			mOwnerScript.UntriggerEvent( mEventTag, mOwnerScript, instigatorPawn );
		}
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mEventTag;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Trigger Event"
}