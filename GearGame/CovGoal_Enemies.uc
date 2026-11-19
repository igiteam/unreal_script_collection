
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class CovGoal_Enemies extends CoverGoalConstraint
	native;

struct native ValidEnemyCacheDatum
{
	var GearPawn EnemyPawn;
	var CoverInfo EnemyCover;
	var GearTurret EnemyTurret;
};

var array<ValidEnemyCacheDatum> ValidEnemyCache;

cpptext
{
	virtual UBOOL EvaluateCover(const FCoverInfo& Info, APawn* SeekingPawn, AGearAI_Cover* SeekingAI, const FVector& GoalLoc, FLOAT& Rating);

	/**
	 * called when this cover constraint is about to be used and verbose debug is on
	 */
	virtual void OnVerboseDebugInit();
};

// overidden to cache the valid enemy list
event native Init(GearAI_Cover InAI);

DefaultProperties
{
	// expensive, do this last
	ConstraintEvaluationPriority=10
}
