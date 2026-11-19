
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class CovGoal_EnemyProximity extends CoverGoalConstraint
	native;

cpptext
{
	virtual UBOOL EvaluateCover(const FCoverInfo& Info, APawn* SeekingPawn, AGearAI_Cover* SeekingAI, const FVector& GoalLoc, FLOAT& Rating);
};
