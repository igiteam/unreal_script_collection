/** 
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class Goal_SquadFormation extends PathGoalEvaluator
	native(TGAI);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

struct native FormationEvalInfo
{
	var int		PosIdx;
	var Actor	QueryActor;
	var native	Map{AActor*,FLOAT} ActorList;
};
var private const native array<FormationEvalInfo> PositionList; 

/** AI that is asking for squad formation search */
var TGAI	SeekerAI;
/** Position index of the squad we are looking for */
var int	PositionIdx;
/** Squad formation that is being searched */
var TGSquadFormation Formation;


private native function ClearPositionList();

static function bool SquadFormation( Pawn P, TGAI inSeekerAI, TGSquadFormation inFormation, optional int inPositionIdx = -1 )
{
	local Goal_SquadFormation Eval;

	if( P != None && inFormation != None && inSeekerAI != None )
	{
		Eval = Goal_SquadFormation(P.CreatePathGoalEvaluator(default.class));

		if( Eval != None )
		{
			Eval.SeekerAI	 = inSeekerAI;
			Eval.PositionIdx = inPositionIdx;
			Eval.Formation	 = inFormation;
			P.AddGoalEvaluator( Eval );
			return TRUE;
		}
	}

	return FALSE;
}

function Recycle()
{
	SeekerAI=none;
	PositionIdx=default.PositionIdx;
	Formation=none;
	ClearPositionList();
	Super.Recycle();
}

