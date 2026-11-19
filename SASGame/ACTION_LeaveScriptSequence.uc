//=============================================================================
// ACTION_LeaveScriptSequence.uc
//
// Script action to stop running script immediately.
//=============================================================================

class ACTION_LeaveScriptSequence extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// GetScript
//
function SASScriptedSequence GetScript(
	SASScriptedSequence		aCurScript )
{
	return None;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Leave Sequence"
}