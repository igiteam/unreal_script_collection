//=============================================================================
// ACTION_SetViewFocus.uc
//
// Script action to set the view focus of the controlled pawn to a specified
// actor.
//=============================================================================

class ACTION_SetViewFocus extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mViewFocusTag;		// Tag of view focus actor

var Actor			mViewFocus;			// Reference to view focus actor


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
   SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	// Get reference to the view focus actor if not already done
	if ( mViewFocus == None )
	{
		GetViewFocusActor( false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetViewFocusActor
//
function GetViewFocusActor(
	bool	abRequireNow )
{
	if ( mViewFocusTag == 'Enemy' )
	{
		return;
	}

	if ( mViewFocusTag != 'None' )
	{
		foreach mOwnerScript.AllActors ( class'Actor', mViewFocus, mViewFocusTag )
		{
			break;
		}
	}

	// The designers want to be able to 'unset' view focus by using None, so this is not an error
	//if ( (mViewFocus == None) && abRequireNow )
	//{
	//	LogHuman( "ACTION_SetViewFocus: No view focus found for "$self$" in "$mOwnerScript );
	//}
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

	if (mViewFocusTag == 'Enemy')
	{
		aInterface.mScriptFocus = aInterface.mAIController.Enemy;
	}
	else
	{
		if ( mViewFocus == None )
		{
			GetViewFocusActor( true );
		}
		aInterface.mScriptFocus = mViewFocus;
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function String GetActionString()
{
	return mActionString@mViewFocusTag;
}


//-----------------------------------------------------------------------------
// Default Properties

	

// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Set View Focus"
}