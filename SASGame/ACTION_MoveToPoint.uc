//=============================================================================
// ACTION_MoveToPoint.uc
//
// Latent script action to instruct pawn to move location of a specified actor.
//=============================================================================

class ACTION_MoveToPoint extends SASLatentScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) name		mDestTag;		// Tag of destination
var(Action) rotator		mOffsetRot;		// 
var(Action) float		mOffsetDist;	//
var(Action) bool		mbEngageWhileMoving;

var Actor				mDestActor;		// Destination object
var vector				mDestOffsetPos;	// Local offset position from dest actor


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called from ScriptedSequence which action belongs to at start of level to
// intialise action member data.
function Init(
	SASScriptedSequence		aScript )
{
	Super.Init( aScript );

	// Init reference to destination object
	if( mDestActor == None )
	{
		GetDestinationActor( false );
	}

	// Store dest offset as a vector
	if( mOffsetDist > 0.0)
	{
		mDestOffsetPos = Vector( mOffsetRot ) * mOffsetDist;
	}
	else
	{
		mDestOffsetPos = vect(0,0,0);
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetDestinationActor
//
function GetDestinationActor(
	bool	abRequireNow )
{
	if ( mDestTag != 'None' )
	{
		foreach mOwnerScript.AllActors( class'Actor', mDestActor, mDestTag )
		{
			break;
		}
	}

	if ( (mDestActor == None) && abRequireNow )
	{
		LogHuman ( "ACTION_MoveToPoint: No move target found for "$self$" in "$mOwnerScript );
	}
}


///////////////////////////////////////////////////////////////////////////////
// MoveToGoal
//
// Inidicates that this is a latent move action.
function bool MoveToGoal()
{
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( aInterface.mAIController != None )
	{
		if ( mDestActor == None )
		{
			GetDestinationActor( true );
		}

		if ( mDestActor != None )
		{
			aInterface.mScriptMoveTarget		= mDestActor;
			aInterface.mScriptMoveTargetOfs		= mDestOffsetPos;
			aInterface.mbEngageWhileScripting	= mbEngageWhileMoving;

			return Super.DoAction( aInterface );
		}
	}

	// Skip action if something went wrong.
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mDestTag;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Move to Point"
}