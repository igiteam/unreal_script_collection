//=============================================================================
// SASScriptAction.uc
//
// Abstract base class of actions which can be executed within a scripted 
// sequence.
//=============================================================================

class SASScriptAction extends Object
	native
	abstract
	hidecategories(Object)
	collapsecategories
	editinlinenew;


//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

var localized string		mActionString;
var	SASScriptedSequence		mOwnerScript;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
	SASScriptedSequence		aScript )
{
	// Store reference to script we belong to
	mOwnerScript = aScript;
}

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
// Returns True if action completes immediately (is not a latent action)
function bool DoAction(
	SASScriptInterface	aInterface )
{
	return true;
}

// putting a HUD message up based on a wav filename
// returns an index into the voicetotext class if it found anything.
// else -1
native function ShowSoundMessage(Name name, Actor who, out float volume, out float radius);

///////////////////////////////////////////////////////////////////////////////
// GetScript
//
function SASScriptedSequence GetScript(
	SASScriptedSequence	aScriptedSequence )
{
	return aScriptedSequence;
}


///////////////////////////////////////////////////////////////////////////////
// ProceedToNextAction
//
function ProceedToNextAction(
	SASScriptInterface	aInterface )
{
	aInterface.mScriptActionNum++;
}


///////////////////////////////////////////////////////////////////////////////
// RepeatAction
//
// Returns true if action should be repeated before proceeding to next action.
function bool RepeatAction(
	SASScriptInterface	aInterface )
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// StartsSection
//
// Returns true if action marks the start of an 'if' section
function bool StartsSection()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// EndsSection
//
// Returns true if action marks the end of an 'if' section.
function bool EndsSection()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// ProceedToSectionEnd
//
// Move to the end of the current 'if' section of the script.
function ProceedToSectionEnd(
	SASScriptInterface	aInterface )
{
	local int				nesting;
	local SASScriptAction	action;

	while ( aInterface.mScriptActionNum < aInterface.mScript.mActions.Length )
	{
		action = aInterface.mScript.mActions[ aInterface.mScriptActionNum ];
		if ( action.StartsSection() )
		{
			nesting++;
		}
		else if ( action.EndsSection() )
		{
			nesting--;
			if ( nesting < 0 )
			{
				return;
			}
		}

		aInterface.mScriptActionNum++;
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Unspecified Action"
}