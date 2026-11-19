//=============================================================================
// ACTION_WaitForActorToSpawn.uc
//
// Latent script action to make controller running the script wait until a 
// specified Actor is spawned before proceeding with script.
//=============================================================================

class ACTION_WaitForActorToSpawn extends SASTriggeredScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mSpawnedTag;		// Tag of spawned actor


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// NotifySpawned
//
// Event received when an SASPawn is spawned.
event NotifySpawned (
	SASPawn	aSpawned)
{
	if (aSpawned.Tag == mSpawnedTag)
	{
		mbTriggered = true;
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( mbTriggered )
	{
		return true;
	}

	return Super.DoAction( aInterface );
}


///////////////////////////////////////////////////////////////////////////////
// CompleteOnActorSpawned
//
// Called when controller running the script receives a spawned notification.
// Returns true if spawned actor is the one the action is waiting on.
function bool CompleteOnActorSpawned(
	Actor	aSpawned )
{
	return ( mSpawnedTag == aSpawned.Tag );
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mSpawnedTag;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Wait For Actor To Spawn"
}