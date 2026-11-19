//=============================================================================
// CONDITION_NamedNPCDead.uc
//
// A triggered script condition which evaluates to true after a named NPC 
// has died.
//=============================================================================

class CONDITION_NamedNPCDead extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) name		mNPCTag;			// Tag of NPC 
var(Conditions) name		mKilledByTag;		// Optional tag of actor which killed the NPC  


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// NotifyKill
//
// Event received when an SASPawn is killed.
event NotifyKill (
	SASPawn	aKilled,
	Actor	aKiller )
{
	// Trigger condition to true if killed pawn is the one we are monitoring.
	if (	(aKilled.Tag == mNPCTag) &&
			((mKilledByTag == 'None') || (aKiller.Tag == mKilledByTag)) )
	{
		mbTriggered = true;
	}
}

///////////////////////////////////////////////////////////////////////////////
// NotifyIncapacitated
//
// Event received when an SASPawn is incapacitated.
event NotifyIncapacitated (
	SASPawn	aIncap)
{
	// Trigger condition to true if killed pawn is the one we are monitoring.
	//***************************
	// FIXME - this ignores the mKilledByTag since the actor who incapacitated this
	// pawn isn't recorded
	// TF 01/12/04
	//***************************

	if (aIncap.Tag == mNPCTag)
	{
		mbTriggered = true;
	} // if
} // NotifyIncapacitated
