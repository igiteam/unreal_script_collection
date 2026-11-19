//=============================================================================
// ACTION_WaitForEvent.uc
//
// Latent script action to wait until a specified event has triggered before
// proceeding to next action.
//=============================================================================

class ACTION_WaitForEvent extends SASTriggeredScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) name			mEventTag;				// Name of event
	

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// NotifyEventTriggered
//
// Event received when a general level event is triggered.
event NotifyEventTriggered(
	name	aEventTag )
{
	if ( aEventTag == mEventTag )
	{
		mbTriggered = true;
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	// If event has already triggered then action is complete.
	if ( mbTriggered )
	{
		return true;
	}
	
	// Action not complete, set interface tag to the event tag so it is 
	// notified of the event when it occurs.
	Super.DoAction( aInterface );

	aInterface.SetInterfaceActorTag( mEventTag );

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// CompleteWhenTriggered
//
function bool CompleteWhenTriggered()
{
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
    mActionString="Wait for Event"
}