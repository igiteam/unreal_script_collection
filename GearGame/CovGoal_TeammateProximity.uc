
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class CovGoal_TeammateProximity extends CoverGoalConstraint
	native;

cpptext
{
	virtual UBOOL EvaluateCover(const FCoverInfo& Info, APawn* SeekingPawn, AGearAI_Cover* SeekingAI, const FVector& GoalLoc, FLOAT& Rating);
};

/** optimal minimum distance from teammates; cover closer will receive a penalty */
var float DesiredMinDist;
var float RatingBoost;


defaultproperties
{
	DesiredMinDist=512.0
	RatingBoost=6.f
}
