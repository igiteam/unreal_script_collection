//=============================================================================
// CONDITION_PawnCuffed.uc
//
// A triggered script condition which evaluates to true after a named NPC 
// has been handcuffed.
//=============================================================================

class CONDITION_PawnCuffed extends SASTriggeredScriptCondition;

//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) name	mNPCTag;		// Tag of NPC 


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// NotifyCaptured
//
// Event received when an SASPawn is cuffed.
event NotifyCaptured(	
	SASPawn	aCuffed )
{
	// Trigger condition to true if cuffed pawn is the one we are monitoring.
	if ( aCuffed.Tag == mNPCTag )
	{
		mbTriggered = true;
	}
}
