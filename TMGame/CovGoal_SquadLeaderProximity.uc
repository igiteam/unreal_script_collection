
/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class CovGoal_SquadLeaderProximity extends CoverGoalConstraint
	native(TGAI);

/** cached location of searching AI's squadleader */
var transient vector SquadLeaderLocation;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function Init(Goal_AtCover GoalEvaluator)
{
	SquadLeaderLocation = GoalEvaluator.AI.Squad.GetSquadLeaderLocation();
}
