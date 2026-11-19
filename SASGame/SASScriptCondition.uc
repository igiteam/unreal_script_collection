//=============================================================================
// SASScriptCondition.uc
//
// Abtract base class of script conditions. Conditions may be used as script
// triggering conditions or as conditions in 'if' statements within a script.
//=============================================================================

class SASScriptCondition extends Object
	native
	abstract
	hidecategories(Object)
	collapsecategories
	editinlinenew;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.
 

//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) export bool	mbNotCondition;	// Flags that the condition has a NOT operator

// Flags to indicate the type of condition this is and (in the case of group conditions)
// the types of all conditions below it in the hierarchy.
//var const int			mTypeFlags;

var SASScriptedSequence	mOwnerScript;

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called when script is initialised at start of level.
function Init(
	SASScriptedSequence	aOwnerScript )
{
	mOwnerScript = aOwnerScript;
}

function InitScriptExternal(
	SASScriptTrigger	aOwnerTrigger )
{
	Init( aOwnerTrigger.mScript );
}

function InitScriptInternal(
	SASScriptedSequence	aOwnerScript )
{
	Init( aOwnerScript );
}


///////////////////////////////////////////////////////////////////////////////
// Evaluate
//
// Evaluate the condition.
event bool Evaluate(
	SASAIController	aController )
{
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// setStartTime
//
// Sets the level time when this condition was activated
event setStartTime (float time)
{
} // setStartTime


///////////////////////////////////////////////////////////////////////////////
// CheckNotOperator
//
// Applies the NOT operator to an evaluated condition result if required.
// Should be called by all conditions Evaluate functions before returning.
function bool CheckNotOperator(	
	bool abConditionEval )
{
	if ( abConditionEval )
	{
		return !mbNotCondition;
	}
	else
	{
		return mbNotCondition;
	}
}
