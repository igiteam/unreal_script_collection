//=============================================================================
// SASScriptedSequence.uc
//
// Class to store a sequence of scripted actions to be executed by 
// SASAIControllers.
//=============================================================================

class SASScriptedSequence extends Keypoint
	native
	hidecategories(Collision,Force,Karma,LightColor,Lighting);

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

var(Actions) export editinline array<SASScriptAction>	mActions;

var const SASScriptedSequence	mNextScript;	// Linked list of scripts in the level
var const bool					mbLatent;		// True if script contains latent actions

// Linked list of all triggered conditions used within this script be they part of 
// the script trigger conditions or part of an 'if' action's conditions.
// These are stored here so that they can be evaluated whenever a triggering
// event occurs without having to go through the entire scripts to find them.
var const SASTriggeredScriptCondition	mTriggeredConditionList;	

// Linked list of triggered script actions. These actions are generally wait
// actions which wait on an event to be triggered. 
// These are stored here so that they can be notified if relevant events occurs
// before the script action is executed in which case they are set to be 
// triggered (meaning the latent action is in effect skipped on execution).
var const SASTriggeredScriptAction		mTriggeredActionList;


//-----------------------------------------------------------------------------
// Native Functions

native function AddTriggeredCondition (
	SASTriggeredScriptCondition	aNewTriggeredCondition);

native function AddTriggeredLatentAction (
	SASTriggeredScriptAction	aNewTriggeredAction);

cleannative function bool EditBlockedExecCommand (
	name	inputExecName,
	bool	bEnable );


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
simulated event PostBeginPlay()
{
	local int i;

	// Initialise the actions for this script
	for ( i = 0; i < mActions.Length; ++i )
	{
		if ( mActions[i] != None )
		{
			mActions[i].Init( self );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// RunScriptOnAIController
//
// Called when this scripted sequence is to run on a given SAS AI Controller.
// The controller will switch to scripting state immediately.
//
// TODO: If script does not have latent actions (mbLatent == false) then
// don't switch controller to scripting state but just run all actions
// immediately.
event RunScriptOnAIController(
	SASAIController	aController )
{
	if ( (aController != None) && aController.SetNewScript( self ) )
	{
		// Only need to put controller into scripting state if script contains latent
		// actions, otherwise whole script would have been executed in call to SetNewScript().
		if ( mbLatent )
		{
			aController.StartScripting();
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetGame
//
// Return the current levels GameInfo object cast to an SASGameInfo.
function SASGameInfo GetGame()
{
	if (SASGameInfo( Level.Game ) == None)
	{
		Warn( "SASPawn.GetGame(): Game is not an SASGameInfo!" ); 
		return None;
	}

	return SASGameInfo( Level.Game );
}


///////////////////////////////////////////////////////////////////////////////
// ExecuteActions
//
function ExecuteActions(
	SASScriptInterface	aInterface )
{
	local SASScriptedSequence	newScript;
	local bool					bActionCompleted;

	bActionCompleted = true;
	while ( bActionCompleted )
	{
		if ( aInterface.mScriptActionNum < mActions.Length )
		{
			// Check to see if action changes the scripted sequence to run
			newScript = mActions[aInterface.mScriptActionNum].GetScript( self );

			// Leave this sequence if new script is not this script
			if ( newScript != self )
			{
				if ( newScript == None )
				{
					// Just stop scripting if new script is None
					aInterface.mCurLatentScriptAction = None;
				}
				else
				{
					// Switch to new scripted sequence
					aInterface.SetNewScript( newScript );
				}
				return;
			}
		}
		else 
		{
			// Reached end of sequence
			aInterface.mCurLatentScriptAction = None;
			return;
		}

		if ( mActions[aInterface.mScriptActionNum] == None )
		{
			Warn( self$" no action "$aInterface.mScriptActionNum$"!!!" );
			aInterface.mCurLatentScriptAction = None;
			return;
		}

		bActionCompleted = mActions[aInterface.mScriptActionNum].DoAction( aInterface );

		if ( bActionCompleted )
		{
			mActions[aInterface.mScriptActionNum].ProceedToNextAction( aInterface );
		}
	}
}


//-----------------------------------------------------------------------------
// States

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    Texture=Texture'Engine.S_AIScript'
    DrawScale=0.3000000
}