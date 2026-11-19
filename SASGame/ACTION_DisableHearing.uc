//=============================================================================
// ACTION_DisableHearing.uc
//
//=============================================================================

class ACTION_DisableHearing extends SASScriptAction;

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
		aInterface.mAIController.mbCanHear = !mbDisable;
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
    mActionString="Disable Hearing"
}