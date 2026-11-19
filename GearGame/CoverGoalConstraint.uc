/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class CoverGoalConstraint extends Object
	native
	abstract;

// constraints will be evaluate roughly in the order of their priority, that is cover goal constraints with a lower evaluation priority will
// be executed before constraints with a higher priority.. this is useful for tweaking the order
// that constraints are executed for performance.. e.g. to execute the slowest constraint last
var int ConstraintEvaluationPriority;

var() GearAI_Cover AI;

cpptext
{
	virtual UBOOL EvaluateCover(const FCoverInfo& Info, APawn* SeekingPawn, class AGearAI_Cover* SeekingAI, const FVector& GoalLoc, FLOAT& Rating) {return TRUE;}
	/**
	 * called when this cover constraint is about to be used and verbose debug is on
	 */
	virtual void OnVerboseDebugInit(){}
};

/** called when adding our owning Goal_AtCover to an AI's goal evaluators, giving us a chance to cache stuff */
event Init(GearAI_Cover InAI)
{
	AI = InAI;
}

event String GetDumpString()
{
	return String(self);
}

DefaultProperties
{
	ConstraintEvaluationPriority=5
}
