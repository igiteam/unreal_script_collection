//=============================================================================
// SASScriptTrigger.uc
//
// A set of script activation conditions associated an SASPawn .
//=============================================================================

class SASScriptTrigger extends Object
	native
	hidecategories(Object)
	collapsecategories
	editinlinenew;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

var() export int							mPriority;			// Trigger priority for selecting script to activate when more than one trigger is activated
var() export bool							mbCanUntrigger;		// Trigger can reset after being activated
var() export float							mActivationDelay;	// Delay on running the associated script after triggering
var() export editinline SASScriptCondition	mCondition;			// Set of trigger conditions
var() edfindable SASScriptedSequence	mScript;			// Script to activate on trigger conditions being met

var const bool		mbTriggered;								// True if trigger has been activated
//var const int		mUncheckedEventFlags;

var const SASTriggeredScriptCondition		mTriggeredConditionList;	// Linked list of the conditions which are activated on events occuring in the game


//-----------------------------------------------------------------------------
// Native Functions

native final function AddTriggeredCondition (
	SASTriggeredScriptCondition	aNewTriggeredCondition);


//-----------------------------------------------------------------------------
// Functions

function Init ()
{
	if ( mCondition != None )
	{
		mCondition.InitScriptExternal(self);
	}
}


//-----------------------------------------------------------------------------
// Default Properties



