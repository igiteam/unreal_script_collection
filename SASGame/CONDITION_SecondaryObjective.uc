//=============================================================================
// CONDITION_SecondaryObjective.uc
//
// Secondary objective, starts as incomplete then can be completed by player
// using action menu command
//=============================================================================

class CONDITION_SecondaryObjective extends SASTriggeredScriptCondition;

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars

var(Conditions)	SASSecondaryObjective		mObjective;	// Objective object

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Secondary Objective
//
// Event received when a Secondary objective is completed
event NotifySecondaryObjectiveCompleted (
	SASSecondaryObjective	aCompleted )
{
	if (aCompleted == mObjective)
	{
		mbTriggered = true;
	} // if
} // NotifySecondaryObjectiveCompleted


///////////////////////////////////////////////////////////////////////////////
// Evaluate
//
// Evaluate the condition.
function bool Evaluate (
	SASAIController	aController )
{
	local bool result;

	if (mObjective == None)
	{
		LogHuman ("Secondary objective condition " $self$ " has no objective object");
		return false;
	} // if

	if (mObjective.isCompleted ())
	{
		result = true;
	} // if

	return CheckNotOperator (result);
} // Evaluate
