//=============================================================================
// ACTION_IfRandom.uc
//
// Script action to provide random conditional execution of a section of the 
// script.
//=============================================================================

class ACTION_IfRandom extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) float	mProbability;		// Probability (0.0->1.0) of executing 'if' section


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// ProceedToNextAction
//
function ProceedToNextAction(
	SASScriptInterface	aInterface )
{
	aInterface.mScriptActionNum++;
	if ( FRand() > mProbability )
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
	return mActionString@mProbability;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="If Random"
}