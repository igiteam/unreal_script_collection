
/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class CovGoal_Enemies extends CoverGoalConstraint
	native(TGAI);

struct native ValidEnemyCacheDatum
{
	var HDBasePawn EnemyPawn;
	var CoverInfo EnemyCover;
};

var array<ValidEnemyCacheDatum> ValidEnemyCache;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// overidden to cache the valid enemy list
event native Init(Goal_AtCover GoalEvaluator);

