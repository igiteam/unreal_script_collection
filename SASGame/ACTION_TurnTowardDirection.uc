//=============================================================================
// ACTION_TurnTowardDirection.uc
//
// Latent script action to make controlled pawn turn toward a specified
// direction.
//=============================================================================

class ACTION_TurnTowardDirection extends SASLatentScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) Rotator	mFocusDir;		// Direction to face


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// TurnToGoal
//
// Inidicates that this is a latent rotate action.
function bool TurnToGoal()
{
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{	
	aInterface.mScriptFocus = None;
	aInterface.mScriptFocalDir = Vector( mFocusDir );

	return Super.DoAction( aInterface );
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mFocusDir;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Turn Toward Actor"
}