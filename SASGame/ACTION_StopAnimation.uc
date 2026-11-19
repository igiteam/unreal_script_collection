//=============================================================================
// ACTION_StopAnimation.uc
//
// Script action to stop the animation playing on the controlled pawn.
//=============================================================================

class ACTION_StopAnimation extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action)	bool	mbImmediate;		// Stop immediately or at end of animation


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	aInterface.ClearScriptAnim( mbImmediate );
	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mbImmediate;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Stop Animation"
}