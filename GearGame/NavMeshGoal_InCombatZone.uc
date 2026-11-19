/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoal_InCombatZone extends NavMeshPathGoalEvaluator
	native(AI);

cpptext
{
	// Interface
	virtual UBOOL EvaluateGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal );
}

var GearAI	AI;

static function bool InCombatZone( NavigationHandle Handle, GearAI InAI )
{
	local NavMeshGoal_InCombatZone	Eval;

	if( Handle != None && inAI != none && inAI.CombatZoneList.length > 0)
	{
			Eval = NavMeshGoal_InCombatZone(Handle.CreatePathGoalEvaluator(default.class));

			if( Eval != None )
			{
				Eval.AI = InAI;
				Handle.AddGoalEvaluator(Eval);
				return TRUE;
			}
	}

	return FALSE;
}

function Recycle()
{
	AI = none;
	Super.Recycle();
}

defaultproperties
{
}
