//=============================================================================
// ACTION_IfCondition.uc
//
// Script action to provide conditional execution of a section of the script.
// If condition is not met then then execution of the script will jump to 
// the next end section script action.
//=============================================================================

class ACTION_IfCondition extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action)	export editinline SASScriptCondition	mCondition;	// Condition(s) to evaluate


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
	SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	if ( mCondition != None )
	{
		mCondition.InitScriptInternal( aScript );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ProceedToNextAction
//
function ProceedToNextAction(
	SASScriptInterface	aInterface )
{
	aInterface.mScriptActionNum++;

	// If condition evauates to false then skip to next end section action, 
	// else proceed to next action in the sequence.
	if ( (mCondition == None) || !mCondition.Evaluate( aInterface.mAIController ) )
	{
		ProceedToSectionEnd( aInterface );
	}
}


///////////////////////////////////////////////////////////////////////////////
// StartsSection
//
function bool StartsSection()
{
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mCondition;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="If Condition"
}