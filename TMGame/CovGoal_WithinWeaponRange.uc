
/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class CovGoal_WithinWeaponRange extends CoverGoalConstraint
	native(TGAI);

/** if this is ON and the cover is outside the envelope it will be thrown the eph out */
var() bool bHardConstraint;

/** cached value indicating whether the searching AI is a leader (affects distance bias) */
var transient bool bIsLeader;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function Init(Goal_AtCover GoalEvaluator)
{
	bIsLeader = TGPRI(GoalEvaluator.AI.PlayerReplicationInfo).bIsLeader;
}
