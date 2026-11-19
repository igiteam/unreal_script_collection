//=============================================================================
// ACTION_TeleportToPoint.uc
//
// Script action to teleport the controlled pawn to the location/rotation of 
// a specified actor in the level.
//=============================================================================

class ACTION_TeleportToPoint extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mDestinationTag;	// Tag of destination
var Actor			mDestActor;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
	SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	// Get reference to destination actor if not already found
	if ( mDestActor == None )
	{
		if ( mDestinationTag != 'None' )
		{
			foreach mOwnerScript.AllActors ( class'Actor', mDestActor, mDestinationTag )
			{
				break;
			}
		}

		if ( mDestActor == None )
		{
			LogHuman( "ACTION_TeleportToPoint.Init: No dest actor found for "$self$" in "$mOwnerScript );
		}
	}
}


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

	if ( (aInterface.mAIController.Pawn != None) && (mDestActor != None) )
	{
		aInterface.mAIController.Pawn.SetLocation( mDestActor.Location );
		aInterface.mAIController.Pawn.SetRotation( mDestActor.Rotation );
		aInterface.mAIController.Pawn.OldRotYaw = aInterface.mAIController.Pawn.Rotation.Yaw;
	}

	return true;	
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Teleport to Point"
}