//=============================================================================
// CONDITION_GroupCondition.uc
//
// A script condition which evaluates a group of child conditions by applying a
// single AND/OR operator across the group.
//=============================================================================

class CONDITION_GroupCondition extends SASScriptCondition;

//-----------------------------------------------------------------------------
// Enums

// Operator types to apply to a group
enum eOperator
{
	OPERATOR_AND,
	OPERATOR_OR
};


//-----------------------------------------------------------------------------
// Member Vars

var(Conditions)	eOperator	meGroupOperator;	// Operator to apply to the group of child conditions 
var(Conditions) export editinline array<SASScriptCondition>	mConditions;	// Child conditions list


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called when script is initialised at start of level.
function InitScriptInternal (
	SASScriptedSequence	aOwnerScript)
{
	local int i;

	Super.InitScriptInternal(aOwnerScript);

	for (i = 0; i < mConditions.Length; ++i)
	{
		mConditions[i].InitScriptInternal(aOwnerScript);
	}
}


function InitScriptExternal (	
	SASScriptTrigger	aOwnerTrigger)
{
	local int i;

	Super.InitScriptExternal(aOwnerTrigger);

	for (i = 0; i < mConditions.Length; ++i)
	{
		mConditions[i].InitScriptExternal(aOwnerTrigger);
	}
}


///////////////////////////////////////////////////////////////////////////////
// Evaluate
//
// Evaluate the group of child conditions.
function bool Evaluate(
	SASAIController	aController )
{
	local int	i;
	local bool	conditionResult;
	local bool	groupResult;

	// Set group evaluation result initially to true if group operator is AND,
	// then turn it off as soon as a child condition is false.
	if ( meGroupOperator == OPERATOR_AND )
	{
		groupResult = true;
	}

	// Evaluate each child condition
	for ( i = 0; i < mConditions.Length; ++i )
	{
		conditionResult = mConditions[i].Evaluate( aController );

		if ( meGroupOperator == OPERATOR_AND )
		{
			if ( !conditionResult )
			{
				// If a single result is false when applying AND operator then
				// final result is false.
				groupResult = false;
				break;
			}
		}
		else	// meGroupOperator == OPERATOR_OR
		{
			if ( conditionResult )
			{
				// If a single result is true when applying OR operator then
				// final result is true.
				groupResult = true;
				break;
			}
		}
	}

	// Apply NOT operator if specified and return final result  
	return CheckNotOperator( groupResult );
}


	

