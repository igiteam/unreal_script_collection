//=============================================================================
// ACTION_CounterSet.uc
//
// Script action to set a counter to a specified value. 
//=============================================================================

class ACTION_CounterSet extends ACTION_CounterAction;


//-----------------------------------------------------------------------------
// Member Vars

var() int	mValue;


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
		mCounter.SetValue( mValue );
	}
	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString$mCounter$mValue;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Counter Set"
}