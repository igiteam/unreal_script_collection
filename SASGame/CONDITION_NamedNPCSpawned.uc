//=============================================================================
// CONDITION_NamedNPCSpawned.uc
//
// A triggered script condition which evaluates to true after a named NPC 
// has been spawned.
//=============================================================================

class CONDITION_NamedNPCSpawned extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) name	mNPCTag;		// Tag of NPC 


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// NotifySpawned
//
// Event received when an SASPawn is spawned.
event NotifySpawned(
	SASPawn		aSpawned )
{
	// Trigger condition to true if spawned pawn is the one we are monitoring.
	if ( aSpawned.Tag == mNPCTag )
	{
		mbTriggered = true;
	}
}
