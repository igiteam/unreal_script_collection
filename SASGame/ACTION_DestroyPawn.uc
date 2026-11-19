//=============================================================================
// ACTION_DestroyPawn.uc
//
// Script action to destroy (remove from level) the pawn possessed by the 
// controller running the script.
//=============================================================================

class ACTION_DestroyPawn extends SASScriptAction;


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
	if ( aInterface.mAIController == None )
	{
		return true;
	}

	if ( aInterface.mAIController.Pawn != None )
	{
		aInterface.mAIController.Pawn.Destroy();
		aInterface.mAIController.Destroy();
	}

	return false;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Destroy Pawn"
}