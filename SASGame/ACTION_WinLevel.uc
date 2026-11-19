//=============================================================================
// ACTION_WinLevel.uc
//
// Script action to mark the level as won 
//=============================================================================

class ACTION_WinLevel extends SASScriptAction;


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
	LogHuman ( "Winlevel called from script" @mOwnerScript @"OBSOLETE ?" );

//	mOwnerScript.GetGame ().WinLevel ();

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Win Level"
}