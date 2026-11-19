
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class CovGoal_WithinWeaponRange extends CoverGoalConstraint
	native;

/** if this is ON and the cover is outside the envelope it will be thrown the eph out */
var() bool bHardConstraint;

/** cached value indicating whether the searching AI is a leader (affects distance bias) */
var transient bool bIsLeader;

cpptext
{
	virtual UBOOL EvaluateCover(const FCoverInfo& Info, APawn* SeekingPawn, AGearAI_Cover* SeekingAI, const FVector& GoalLoc, FLOAT& Rating);
};

function Init(GearAI_Cover InAI)
{
	Super.Init( InAI );
	bIsLeader = GearPRI(AI.PlayerReplicationInfo).bIsLeader;
}
