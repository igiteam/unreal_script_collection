//=============================================================================
// ACTION_DestroyActor.uc
//
// Script action to destroy (remove from level) a specified actor. 
//=============================================================================

class ACTION_DestroyActor extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action)	name	mActorTag;		// Tag of actor(s) to destroy


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local Actor act;

	if ( mActorTag != 'None' )
	{
		foreach mOwnerScript.AllActors( class'Actor', act, mActorTag )
		{
			act.Destroy();
		}
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mActorTag;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Destroy Actor"
}