//=============================================================================
// ACTION_DisableAllSenses.uc
//
// Script action to turn on/off all senses (sight, hearing and damage) for 
// the controller running the script.
//=============================================================================

class ACTION_DisableAllSenses extends SASScriptAction;

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
		aInterface.mAIController.DisableAllSenses( mbDisable );
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
    mActionString="Disable All Senses"
}