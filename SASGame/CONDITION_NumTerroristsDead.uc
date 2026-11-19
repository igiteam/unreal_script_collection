//=============================================================================
// CONDITION_NumTerroristsDead.uc
//
// A triggered script condition which evaluates to true after a specified
// number of terrorists have died.
//=============================================================================

class CONDITION_NumTerroristsDead extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) int		mNumDead;		// Num hostages to die to trigger condition


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// isTriggered
//
// Returns true if this condition has been triggered
function bool isTriggered ( Actor refActor )
{
	local SASGRI gri;

	gri = SASGRI ( refActor.Level.GetLocalPlayerController ().GameReplicationInfo );

	// KW: possible fix for captured terrorists not triggering EOM ...
	return ( gri.mTerroristsKilled + gri.mTerroristsIncapacitated + gri.mTerroristsCaptured ) >= mNumDead;
} // isTriggered

///////////////////////////////////////////////////////////////////////////////
// NotifyKill
//
// Event received when an SASPawn is killed.
event NotifyKill (
	SASPawn	aKilled,
	Actor	aKiller)
{
	local SASGRI gri;

	gri = SASGRI ( aKilled.Level.GetLocalPlayerController ().GameReplicationInfo );

	if ( !mbTriggered && ( aKilled.GetGame () != None ) )
	{
		// Check if num terrorists killed in level meets trigger number.
		// Incapacitated terrorists count as dead for this purpose
		Log ( "CONDITION_NumTerroristsDead; mNumDead " $mNumDead$ ", Out of action" @gri.mTerroristsKilled @"+" @gri.mTerroristsIncapacitated @"+" @gri.mTerroristsCaptured );
		if ( isTriggered ( aKilled ) == true )
		{
			mbTriggered = true;
			Log (" --- TRIGGERED");
		} // if
	}
}

///////////////////////////////////////////////////////////////////////////////
// NotifyIncapacitated
//
// Event received when an SASPawn is incapacitated.
event NotifyIncapacitated (
	SASPawn	aIncap)
{
	if ( !mbTriggered && isTriggered ( aIncap ) == true)
	{
		mbTriggered = true;
		Log ( " --- TRIGGERED" );
	} // if
} // NotifyIncapacitated


///////////////////////////////////////////////////////////////////////////////
// NotifyCaptured
//
// Event received when an SASPawn is captured.
event NotifyCaptured (
	SASPawn	aCaptured )
{
	if ( !mbTriggered && isTriggered( aCaptured ) )
	{
		mbTriggered = true;
	}
}


///////////////////////////////////////////////////////////////////////////////
// getCompletionPercentage
//
// Returns completion state of this condition in range 0-1
function float getCompletionPercentage ( SASGRI gri )
{
	local int num;

	num = gri.mTerroristsKilled + gri.mTerroristsIncapacitated + gri.mTerroristsCaptured;

	return FClamp ( float ( num ) / float ( gri.mTerrorists ), 0.0, 1.0 );
} // getCompletionPercentage

///////////////////////////////////////////////////////////////////////////////
// getStatusString
//
// Returns context sensitive string indicating qualitative success
function string getStatusString ( SASGRI gri )
{
	local int num;

	num = gri.mTerroristsKilled + gri.mTerroristsIncapacitated + gri.mTerroristsCaptured;

	return ( " (" $num $"/" $gri.mTerrorists $")" );
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
// GetProgressString
//
function String GetProgressString ( SASGRI gri )
{
	local int num;

	num = gri.mTerroristsKilled + gri.mTerroristsIncapacitated + gri.mTerroristsCaptured;

	return ( " (" $num $"/" $mNumDead $") K:[" $gri.mTerroristsKilled $"] I:[" $gri.mTerroristsIncapacitated $"] C:[" $gri.mTerroristsCaptured $"]" );
}

///////////////////////////////////////////////////////////////////////////////
