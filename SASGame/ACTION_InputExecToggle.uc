//=============================================================================
// ACTION_InputExecToggle.uc
//
// Script action to turn on/off controller input.
//=============================================================================

class ACTION_InputExecToggle extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars
var() name	mInputExecName;	// Name of input exec to enable/disable.
var() bool	mbEnable;		// Whether we want to enable or disable the exec
							// (1/true == renable, 0/false ==disable).

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( mInputExecName != 'None' )
	{
		return mOwnerScript.EditBlockedExecCommand( mInputExecName, mbEnable );
	}

	return false;
}

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="InputExecToggle"
}