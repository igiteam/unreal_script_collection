/** 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoal_SquadFormation extends NavMeshPathGoalEvaluator
	native;

cpptext
{

	virtual UBOOL EvaluateGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal );

	virtual UBOOL DetermineFinalGoal( FNavMeshPolyBase*& out_GenGoal, class AActor** out_DestActor, INT* out_DestItem );

	/**
	 *  This will pick an actual (as in actually pathable) world position to each ideal squad formation position
	 */
	void AssignActualLocationsToFormationPositions();

	/**
	 * this will loop through the weight maps in ActualFPosWeightMap and select the actualposition/formation position pair
	 * which is closest to each other, and whose actual position is not in use already
	 */
	UBOOL GetBestPosition( TArray<FVector> &UsedList, INT& out_PosIdx, FVector& BestActualPosition, FLOAT EntityRadius );

	/** 
	 * sets up internal vars for path searching, and will early out if something fails
	 * @param Handle - handle we're initializing for
	 * @param PathParams - pathfinding parameter packet
	 * @return - whether or not we should early out form this search
	 */
	virtual UBOOL InitializeSearch( UNavigationHandle* Handle,
									const FNavMeshPathParams& PathParams );
}

struct native NavMeshFormationEvalInfo
{
	var int		PosIdx;
	var native	Map{FVector,FLOAT} ActualLocationWeights;
};

// each formation position gets a list of weighted potential real locations (vectors), used to determine which real location to use for each position
var private const native array<NavMeshFormationEvalInfo> ActualFPosWeightMap; 

/** AI that is asking for squad formation search */
var GearAI	SeekerAI;
/** Squad formation that is being searched */
var GearSquadFormation Formation;


private native function ClearPositionList();

static function bool SquadFormation( NavigationHandle NavHandle, GearAI inSeekerAI, GearSquadFormation inFormation)
{
	local NavMeshGoal_SquadFormation Eval;

	if( NavHandle != None && inFormation != None && inSeekerAI != None )
	{
		Eval = NavMeshGoal_SquadFormation(NavHandle.CreatePathGoalEvaluator(default.class));

		if( Eval != None )
		{
			Eval.SeekerAI	 = inSeekerAI;
			Eval.Formation	 = inFormation;
			NavHandle.AddGoalEvaluator( Eval );
			return TRUE;
		}
	}

	return FALSE;
}

function Recycle()
{
	SeekerAI=none;
	Formation=none;
	ClearPositionList();
	Super.Recycle();
}

defaultproperties
{
}
