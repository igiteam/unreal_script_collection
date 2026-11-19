//=============================================================================
// ACTION_CounterAdd.uc
//
// Script action to add a specified value to a counter. 
//=============================================================================

class ACTION_CounterAdd extends ACTION_CounterAction;


//-----------------------------------------------------------------------------
// Member Vars

var() int	mNumToAdd;


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
		mCounter.Add( mNumToAdd );
	}
	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString$mCounter$mNumToAdd;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mNumToAdd=1
    mActionString="Counter Add"
}