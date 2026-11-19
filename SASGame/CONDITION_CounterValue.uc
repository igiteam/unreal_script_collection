//=============================================================================
// CONDITION_CounterValue.uc
//
// A script condition which evaluates the value of a counter.
//=============================================================================

class CONDITION_CounterValue extends SASScriptCondition;


//-----------------------------------------------------------------------------
// Enums

// Comparison operations for evaluating counter value with.
enum eCounterComparisonOp
{
	CC_EqualTo,
	CC_LessThan,
	CC_GreaterThan
};


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions) eCounterComparisonOp	mComparisonOp;	// Comparison operation to use
var(Conditions) int						mValue;			// Comparison value
var(Conditions) name					mCounterTag;	// Tag ID of counter to evaluate

var SASScriptCounter					mCounter;		// Reference to counter to evaluate


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// InitScriptExternal
//
function InitScriptExternal (
	SASScriptTrigger	aOwnerTrigger)
{
	Super.InitScriptExternal(aOwnerTrigger);

	FindCounter(aOwnerTrigger.mScript);
}


///////////////////////////////////////////////////////////////////////////////
// InitScriptInternal
//
function InitScriptInternal (
	SASScriptedSequence	aOwnerScript)
{
	Super.InitScriptInternal(aOwnerScript);

	FindCounter(aOwnerScript);
}


///////////////////////////////////////////////////////////////////////////////
// FindCounter
//
// Search within the level's SASLevelData object for the counter to be
// evaluated.
function FindCounter (
	SASScriptedSequence	aOwnerScript)
{
	local int			i;
	local SASLevelData	levelData;

	if ((aOwnerScript != None) && (mCounterTag != 'None'))
	{
		levelData = SASGRI( aOwnerScript.Level.Game.GameReplicationInfo ).mLevelData;
		if (levelData != None)
		{
			for (i = 0; i < levelData.mScriptCounters.Length; ++i)
			{
				if ((levelData.mScriptCounters[i] != None)
					&& (levelData.mScriptCounters[i].mTag == mCounterTag))
				{
					mCounter = levelData.mScriptCounters[i];
					break;
				}
			}
		}
	}

	if (mCounter == None)
	{
		LogHuman("CONDITION_CounterValue: Could not find counter "$mCounterTag$" for "$self);
	}
}


///////////////////////////////////////////////////////////////////////////////
// Evaluate
//
// Evaluate the condition.
function bool Evaluate(
	SASAIController	aController )
{
	local bool result;

	if ( mCounter == None )
	{
		return false;
	}

	switch ( mComparisonOp )
	{
	case CC_EqualTo:
		if (mCounter.GetValue() == mValue)
		{
			result = true;
		}
		break;

	case CC_LessThan:
		if (mCounter.GetValue() < mValue)
		{
			result = true;
		}
		break;

	case CC_GreaterThan:
		if (mCounter.GetValue() > mValue)
		{
			result = true;
		}
		break;
	}

	return CheckNotOperator( result );
}
