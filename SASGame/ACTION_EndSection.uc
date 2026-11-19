//=============================================================================
// ACTION_EndSection.uc
//
// Script action to mark end of an if section within a script.
//=============================================================================

class ACTION_EndSection extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// EndsSection
//
function bool EndsSection()
{
	return true;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="End Section"
}