///////////////////////////////////////////////////////////////////////////////
// StackedUpGoal.uc - StackedUpGoal class
// this goal is used only by Officers who are stacked up

class StackedUpGoal extends SwatCharacterGoal;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// 
// StackUpGoal variables

var private StackupPoint StackUpPoint;


///////////////////////////////////////////////////////////////////////////////
// 
// Constructors

overloaded function construct( AI_Resource r )
{
    // don't use this constructor
	assert(false);
}

overloaded function construct( AI_Resource r, StackupPoint inStackUpPoint )
{
    Super.construct(r);

    assert(inStackUpPoint != None);
    StackUpPoint = inStackUpPoint;
}


///////////////////////////////////////////////////////////////////////////////
// 
// Accessors

function StackUpPoint GetStackUpPoint()
{
	return StackUpPoint;
}

///////////////////////////////////////////////////////////////////////////////






// Decompiled with UE Explorer.
defaultproperties
{
    Priority=39
    goalName="StackedUp"
}