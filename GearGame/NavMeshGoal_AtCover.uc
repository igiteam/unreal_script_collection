/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoal_AtCover extends NavMeshPathGoalEvaluator
	native(AI);

cpptext
{
	// Interface
	void RateSlot(const FCoverInfo& Info, INT BaseRating, INT BestRatingThreshold = 0 );
	UBOOL IsValid(const FCoverInfo& Info);

	virtual UBOOL EvaluateGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal );

	virtual UBOOL DetermineFinalGoal( FNavMeshPolyBase*& out_GenGoal, class AActor** out_DestActor, INT* out_DestItem );
	virtual void  NotifyExceededMaxPathVisits( FNavMeshPolyBase* BestGuess, FNavMeshPolyBase*& out_GenGoal );
}

/** AI looking for cover */
var GearAI_Cover AI;

/** Best valid slot and cost that was found */
var CoverInfo		BestCover;
var INT				BestRating;
var INT             BestRatingTheshold;

/** maximum number of nodes to rate before picking the best one **/
var() INT				MaxToRate;

/** number of slots tested so far */
var int NumTested;

/** location that we desired to be near/away from/etc */
var vector GoalLoc;

/** list of constraints used to evaluate cover as we find it */
var instanced array<CoverGoalConstraint> CoverGoalConstraints;

final function Init(GearAI_Cover GAIC, vector InGoalLoc)
{
	local int i;

	if (GAIC.Squad != None && GAIC.MyGearPawn != None)
	{
		BestCover.Link = None;
		BestCover.SlotIdx = -1;
		BestRating = class'NavigationPoint'.const.INFINITE_PATH_COST;
		NumTested = 0;
		AI = GAIC;
		GoalLoc = InGoalLoc;
		BestRatingTheshold = 0;

		for (i = 0; i < CoverGoalConstraints.length; i++)
		{
			CoverGoalConstraints[i].Init(GAIC);
		}
		InitNative();
		GAIC.NavigationHandle.AddGoalEvaluator(self);
	}
	else
	{
		`Warn("Invalid AI - Squad" @ GAIC.Squad @ "GearPawn" @ GAIC.MyGearPawn);
	}


}

private native function InitNative();


native final noexport function RateSlot( CoverInfo Info, int BaseRating, optional int BestRatingThreshold );

event String GetDumpString()
{
	local int Idx;
	local String Str;

	if( CoverGoalConstraints.Length == 0 )
	{
		return "Empty Cov Goal Constraints";
	}

	for( Idx = 0; Idx < CoverGoalConstraints.length; Idx++ )
	{
		Str = Str@CoverGoalConstraints[Idx].GetDumpString()@"\n";
	}
	return Str;
}

defaultproperties
{
	MaxToRate=40
	MaxPathVisits=500
}
