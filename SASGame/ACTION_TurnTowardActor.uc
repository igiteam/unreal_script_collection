//=============================================================================
// ACTION_TurnTowardActor.uc
//
// Latent script action to make controlled pawn turn to face a specified
// actor.
//=============================================================================

class ACTION_TurnTowardActor extends SASLatentScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mFocusTag;		// Name of object to turn toward
var Actor			mFocus;			// Reference of object to turn toward


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called from ScriptedSequence which action belongs to at start of level to
// intialise action member data.
function Init(
	SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	// Init reference to focus object
	if ( mFocus == None )
	{
		GetFocusActor( false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetFocusActor
//
function GetFocusActor(
	bool	abRequireNow )
{
	if ( mFocusTag != 'None' )
	{
		foreach mOwnerScript.AllActors( class'Actor', mFocus, mFocusTag )
		{
			break;
		}
	}
	
	if ( (mFocus == None) && abRequireNow )
	{
		LogHuman( "ACTION_TurnTowardActor: No actor found for "$self$" in "$mOwnerScript );
	}
}	


///////////////////////////////////////////////////////////////////////////////
// TurnToGoal
//
// Inidicates that this is a latent move action.
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
	if (mFocus == None)
	{
		GetFocusActor (true);
	}

	aInterface.mScriptFocus = mFocus;
	aInterface.mScriptFocalDir = vect(0,0,0);

	return Super.DoAction( aInterface );
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mFocusTag;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Turn Toward Actor"
}