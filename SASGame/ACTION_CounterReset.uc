//=============================================================================
// ACTION_CounterReset.uc
//
// Script action to reset a counter to its initial value. 
//=============================================================================

class ACTION_CounterReset extends ACTION_CounterAction;


//-----------------------------------------------------------------------------
// Member Vars


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction (
	SASScriptInterface	aInterface )
{
	if ( mCounter != None )
	{
		mCounter.Reset();
	}
	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString$mCounter;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Counter Reset"
}