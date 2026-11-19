//=============================================================================
// ACTION_ActivatePawn.uc
//
// Script action to unhide and activate AI for a specified pawn.
//=============================================================================

class ACTION_ActivatePawn extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) name mPawnTag;	// Tag of pawn(s) to activate


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( mPawnTag != 'None' )
	{
		mOwnerScript.ActivateActorsWithTag( mPawnTag );
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mPawnTag;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Activate Pawn"
}