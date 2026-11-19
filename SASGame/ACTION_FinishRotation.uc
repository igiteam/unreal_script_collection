//=============================================================================
// ACTION_FinishRotation.uc
//
// Latent script action to make script wait until current pawn rotation
// has finished before proceeding with next script action.
//=============================================================================

class ACTION_FinishRotation extends SASLatentScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

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
// CanDoAvoidance
//
function bool CanDoAvoidance()
{
	return false;
}

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Finish Rotation"
}