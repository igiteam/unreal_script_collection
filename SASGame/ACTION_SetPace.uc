//=============================================================================
// ACTION_SetPace.uc
//
// Script action to set the movement pace of the controlled pawn.
//=============================================================================

class ACTION_SetPace extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) bool	mbWalking;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	aInterface.mbScriptWalking = mbWalking;
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mbWalking;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Set Pace"
}