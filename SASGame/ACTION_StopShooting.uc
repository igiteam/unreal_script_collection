//=============================================================================
// ACTION_StopShooting.uc
//
// Script action to stop the controlled pawn shooting.
//=============================================================================

class ACTION_StopShooting extends SASScriptAction;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction (
	SASScriptInterface	aInterface )
{
	aInterface.ClearScriptFiring();
	return true;	
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Stop Shooting"
}