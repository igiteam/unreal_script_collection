
/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class CovGoal_GoalProximity extends CoverGoalConstraint
	native(TGAI);

var() float BestGoalDist;
var() float MinGoalDist;
var() float MaxGoalDist;
/** if set markers are completely rejected if they are outside the min and max distance */
var() bool bHardLimits;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
