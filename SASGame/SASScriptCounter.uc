//=============================================================================
// SASScriptCounter.uc
//
// Counters store an integer value which can be modified by scripts.
// They provide condition execution of scripts and actions within scripts
// with the CONDITION_CounterValue script condition type.
// The counters for a level are defined in the level data object.
//=============================================================================

class SASScriptCounter extends Object
	hidecategories(Object)
	collapsecategories
	editinlinenew;


//-----------------------------------------------------------------------------
// Member Vars

var() name		mTag;				// Counter tag ID
var() int		mInitialValue;		// Initial value of counter, also value that counter when it is reset.

var int			mValue;				// Counter value


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Reset
//
function Reset()
{
	mValue = mInitialValue;
}


///////////////////////////////////////////////////////////////////////////////
// GetValue
//
function int GetValue()
{
	return mValue;
}


///////////////////////////////////////////////////////////////////////////////
// SetValue
//
function SetValue(
	int aNewVal)
{
	mValue = aNewVal;
}


///////////////////////////////////////////////////////////////////////////////
// Add
//
function Add(
	int aNumToAdd)
{
	mValue += aNumToAdd;
}


///////////////////////////////////////////////////////////////////////////////
// Subtract
//
function Subtract(
	int aNumToSubtract)
{
	mValue -= aNumToSubtract;
}
