//=============================================================================
// ACTION_DisableSight.uc
//
// Script action to turn on/off sight detection for controller running the
// script.
//=============================================================================

class ACTION_DisableSight extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) bool	mbDisable;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( aInterface.mAIController != None )
	{
		aInterface.mAIController.mbCanSee = !mbDisable;
	}
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mbDisable;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Disable Sight"
}