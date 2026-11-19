/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/
class Goal_OutsideAvoidanceVolumes extends PathGoalEvaluator
	native(TGAI);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var TGAI	AI;

static function bool OutsideAvoidanceVolumes( Pawn P )
{
	local Goal_OutsideAvoidanceVolumes	Eval;
	local TGAI C;

	if( P != None )
	{
		C = TGAI(P.Controller);
		if( C != None )
		{
			Eval = Goal_OutsideAvoidanceVolumes(P.CreatePathGoalEvaluator(default.class));

			if( Eval != None )
			{
				Eval.AI = C;
				P.AddGoalEvaluator( Eval );
				return TRUE;
			}
		}
	}

	return FALSE;
}

function Recycle()
{
	AI=none;
	Super.Recycle();
}

