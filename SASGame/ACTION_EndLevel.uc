//=============================================================================
// ACTION_EndLevel.uc
//
//=============================================================================

class ACTION_EndLevel extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	LogHuman ( "EndMission called from script" @mOwnerScript );

	mOwnerScript.GetGame ().EndMission ();

	return true;
}

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="End Level"
}