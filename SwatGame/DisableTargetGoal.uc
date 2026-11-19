///////////////////////////////////////////////////////////////////////////////

class DisableTargetGoal extends SwatCharacterGoal;

///////////////////////////////////////////////////////////////////////////////
//
// Variables

var(parameters) Actor  Target;
var(parameters) vector DisableFromPoint;
var(parameters) bool   bUseMoveToThreshold;

///////////////////////////////////////////////////////////////////////////////
//
// Constructor

overloaded function construct(AI_Resource r, Actor inTarget, vector inDisableFromPoint, bool inUseMoveToThreshold)
{
	super.construct( r );

	assert(inTarget != None);
	Target = inTarget;
    DisableFromPoint = inDisableFromPoint;
	bUseMoveToThreshold = inUseMoveToThreshold;
}

///////////////////////////////////////////////////////////////////////////////






///////////////////////////////////////////////////////////////////////////////

// Decompiled with UE Explorer.
defaultproperties
{
    Priority=80
    goalName="DisableTarget"
}