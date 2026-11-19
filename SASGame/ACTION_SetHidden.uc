//=============================================================================
// ACTION_SetHidden.uc
//
// Script action to hide/unhide specified actor(s) within the level.
//=============================================================================

class ACTION_SetHidden extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) bool	mbHidden;		// Hide or unhide
var(Action) name	mHideActorTag;	// Tag of actor(s) to hide/unhide. If undefined then hide pawn being scripted.


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local Actor lActor;

	// If mHideActorTag is defined then turn on/off all actors
	// in level with that tag, else turn on/off the pawn being scripted.
	if ( mHideActorTag != 'None' )
	{
		foreach mOwnerScript.AllActors ( class'Actor', lActor, mHideActorTag )
		{
			lActor.bHidden = mbHidden;
		}
	}
	else
	{
		if ( (aInterface.mAIController != None) && (aInterface.mAIController.Pawn != None) )
		{
			aInterface.mAIController.Pawn.bHidden = mbHidden;
		}
	}

	return true;	
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Set Hidden"
}