//=============================================================================
// CONDITION_PawnProximity.uc
//
// A script condition which evaluates to true if the scripting controller's
// is within a specified volume.
//=============================================================================

class CONDITION_PawnProximity extends SASScriptCondition;

//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) name			mVolumeTag;

var Volume						mVolume;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// InitScriptExternal
//
// Called at level start when condition belongs to a script action (internal
// to script).
function InitScriptInternal (
	SASScriptedSequence	aOwnerScript)
{
	Super.InitScriptInternal(aOwnerScript);

	FindVolume (aOwnerScript);
}


///////////////////////////////////////////////////////////////////////////////
// InitScriptExternal
//
// Called at level start when condition belongs to a script trigger (external
// to script).
function InitScriptExternal (	
	SASScriptTrigger	aOwnerTrigger)
{
	Super.InitScriptExternal(aOwnerTrigger);
	
	FindVolume (aOwnerTrigger.mScript);
}


///////////////////////////////////////////////////////////////////////////////
// FindVolume
//
function FindVolume (
	SASScriptedSequence	aScript)
{
	// Find volume to test against
	if ((aScript != None) && (mVolumeTag != 'None'))
	{
		foreach aScript.AllActors (class'Volume', mVolume, mVolumeTag)
		{
			break;
		}
	}

	if (mVolume == None)
	{
		warn ("Condition_PawnProximity: No test volume found for "$self$" in "$aScript);
	}
}


///////////////////////////////////////////////////////////////////////////////
// Evaluate
//
// Evaluate the condition.
function bool Evaluate(
	SASAIController	aController )
{
	local bool		result;

	if ( (mVolume == None) 
		|| (aController == None) 
		|| (aController.Pawn == None) )
	{
		result = false;
	}
	else
	{
		result = mVolume.Encompasses( aController.Pawn );
	}

	return CheckNotOperator( result );
}
