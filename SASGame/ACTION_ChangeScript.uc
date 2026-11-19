//=============================================================================
// ACTION_ChangeScript.uc
//
// Script action to change to a new script.
//=============================================================================

class ACTION_ChangeScript extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) name			mNextScriptTag;		// Tag of script to change to

var SASScriptedSequence		mNextScript;		// Reference to next script


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called when the script is initialised at the start of the level.
function Init(
	SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	// Get reference to script to change to if not already found.
	if ( mNextScript == None )
	{
		if ( mNextScriptTag != 'None' )
		{
			foreach mOwnerScript.AllActors( class'SASScriptedSequence', mNextScript, mNextScriptTag )
			{
				break;
			}
		}

		if ( mNextScript == None )
		{
			LogHuman( "ACTION_ChangeScript.Init: No script found for "$self$" in "$mOwnerScript );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetScript
//
function SASScriptedSequence GetScript(
	SASScriptedSequence aScript )
{
	return mNextScript;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Change Script"
}