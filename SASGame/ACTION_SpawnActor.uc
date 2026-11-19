//=============================================================================
// ACTION_SpawnActor.uc
//
// Script action to spawn a new actor of a specified tpye into the level.
//=============================================================================

class ACTION_SpawnActor extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action)		class<Actor>	mActorClass;		// Class of actor to spawn
var(Action)		name			mActorTag;			// Tag to give spawned actor
var(Action)		name			mDestTag;			// Optional tag of actor to spawn at
var(Action)		vector			mSpawnLocOffset;	// Spawn location (dest actor offset if mDestTag defined)
var(Action)		rotator			mSpawnRotOffset;	// Spawn rotation (dest actor offset if mDestTag defined)

var Actor						mDestActor;

//-----------------------------------------------------------------------------
// Functions


///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
   SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	if ( (mDestTag != 'None') && (mDestActor == None) )
	{
		foreach mOwnerScript.AllActors ( class'Actor', mDestActor, mDestTag )
		{
			break;
		}

		if ( mDestActor == None )
		{
			LogHuman( "ACTION_SpawnActor.Init: No dest actor found for "$self$" in "$mOwnerScript );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local Actor		spawned;
	local Vector	spawnLoc;
	local Rotator	spawnRot;

	if ( (mDestTag != 'None') && (mDestActor == None) )
	{
		return true;
	}

	spawnLoc = mSpawnLocOffset;
	spawnRot = mSpawnRotOffset;
	if ( mDestActor != None )
	{
		spawnLoc += mDestActor.Location;
		spawnRot += mDestActor.Rotation;
	}

	spawned = mOwnerScript.Spawn( mActorClass,,, spawnLoc, spawnRot );
	if ( aInterface.mAIController != None )
	{
		spawned.Instigator = aInterface.mAIController.Pawn;
	}
	if ( mActorTag != 'None' )
	{
		spawned.Tag = mActorTag;
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mActorClass;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Spawn Actor"
}