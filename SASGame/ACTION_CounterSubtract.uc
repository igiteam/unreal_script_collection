//=============================================================================
// ACTION_CounterSubtract.uc
//
// Script action to subtract a specified value to a counter. 
//=============================================================================

class ACTION_CounterSubtract extends ACTION_CounterAction;


//-----------------------------------------------------------------------------
// Member Vars

var() int	mNumToSubtract;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( mCounter != None )
	{
		mCounter.Subtract( mNumToSubtract );
	}
	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString$mCounter$mNumToSubtract;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mNumToSubtract=1
    mActionString="Counter Subtract"
}