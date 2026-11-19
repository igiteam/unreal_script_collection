//=============================================================================
// ACTION_DisableDamageResponse.uc
//
// Script action to turn on/off damage sense for the controller runnng the
// script.
//=============================================================================

class ACTION_DisableDamageResponse extends SASScriptAction;


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
		aInterface.mAIController.mbCanFeelDamage = !mbDisable;
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
    mActionString="Disable Damage Response"
}