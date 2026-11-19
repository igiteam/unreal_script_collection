
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class CovGoal_SquadLeaderProximity extends CoverGoalConstraint
	native;

/** cached location of searching AI's squadleader */
var transient vector SquadLeaderLocation;

cpptext
{
	virtual UBOOL EvaluateCover(const FCoverInfo& Info, APawn* SeekingPawn, AGearAI_Cover* SeekingAI, const FVector& GoalLoc, FLOAT& Rating);
};

function Init(GearAI_Cover InAI)
{
	Super.Init( InAI );
	SquadLeaderLocation = AI.Squad.GetSquadLeaderLocation();
}
