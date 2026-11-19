//=============================================================================
// ACTION_GotoLabel.uc
//
// Script action to jump to a labelled position in the script sequence.
//=============================================================================

class ACTION_GotoLabel extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) name	mLabelName;			// Name of label to jump to

var int				mLabelActionNum;	// Index of action to jump to


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
	SASScriptedSequence	aScript )
{
	local int i;

	Super.Init(aScript);

	// Find action number for label if not already  found
	if (mLabelActionNum == -1)
	{
		for (i = 0; i < mOwnerScript.mActions.Length; i++)
		{
			if (ACTION_Label(mOwnerScript.mActions[i]) != None)
			{
				if (ACTION_Label(mOwnerScript.mActions[i]).mLabel == mLabelName)
				{
					mLabelActionNum = i;
					break;
				}
			}
		}

		if (mLabelActionNum == -1)
		{
			LogHuman ("ACTION_GotoLabel.Init: Could not find label for "$self$" in "$mOwnerScript);
			LogHuman ("Setting goto action num to 0.");
			mLabelActionNum = 0;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// ProceedToNextAction
//
function ProceedToNextAction(
	SASScriptInterface	aInterface )
{
	aInterface.mScriptActionNum = mLabelActionNum;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mLabelName;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mLabelActionNum=-1
    mActionString="Goto Action"
}