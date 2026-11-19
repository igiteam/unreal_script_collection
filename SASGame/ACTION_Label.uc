//=============================================================================
// ACTION_Label.uc
//
// Script action to mark a point in the script sequence that can be jumped to
// using the got label action.
//=============================================================================

class ACTION_Label extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mLabel;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mLabel;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Label"
}