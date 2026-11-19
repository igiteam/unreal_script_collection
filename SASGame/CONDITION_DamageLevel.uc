//=============================================================================
// CONDITION_DamageLevel.uc
//
// A script condition which evaluates to true if an SASPawn with a specified
// tag falls below a specified health level.
//=============================================================================

class CONDITION_DamageLevel extends SASTriggeredScriptCondition;


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) int		mTriggerDamageLevel;
var(Conditions) name	mActorTag;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// InitScriptExternal
//
function InitScriptExternal(
	SASScriptTrigger	aScriptTrigger )
{
	Super.InitScriptExternal( aScriptTrigger );

	FlagMonitoredPawns( aScriptTrigger.mScript );
}


///////////////////////////////////////////////////////////////////////////////
// InitScriptInternal
//
function InitScriptInternal(
	SASScriptedSequence	aScript )
{
	Super.InitScriptInternal( aScript );

	FlagMonitoredPawns( aScript );
}


///////////////////////////////////////////////////////////////////////////////
// FlagMonitoredPawns 
//
function FlagMonitoredPawns(
	SASScriptedSequence	aScript )
{
	local SASPawn	P;

	if ( mActorTag != 'None' )
	{
		foreach aScript.DynamicActors( class'SASPawn', P, mActorTag )
		{	
			P.mbNotifyScriptsOfDamage = true;	
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyDamaged 
//
// Event recieved when an SASPawn is damaged. Only occurs on SASPawns which
// have 'damage level' script conditions relating to them.
event NotifyDamaged(
	SASPawn	aDamaged )
{
	if ( (aDamaged.Tag == mActorTag) && (aDamaged.Health <= mTriggerDamageLevel) )
	{
		mbTriggered = true;
	}
}
