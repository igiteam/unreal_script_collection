class HodGoalEvaluator extends PathGoalEvaluator
	native(TG);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** AI looking for cover */
var TGAI AI;

/** Best valid slot marker and cost that was found */
var NavigationPoint	BestMarker;
var INT				BestRating;

/** maximum number of nodes to rate before picking the best one **/
var() INT				MaxToRate;

/** number of markers tested so far */
var int NumMarkersTested;

/** Actor that we desired to be near */
var Actor			TetherActor;

/** list of constraints used to evaluate cover as we find it */
var instanced array<HodGoalConstraint> GoalConstraints;

final function Init(TGAI GAIC, Actor GoalActor)
{
	local int i;

	if (GAIC.Squad != None && GAIC.MyTGPawn != None)
	{
		BestMarker = None;
		BestRating = class'NavigationPoint'.const.INFINITE_PATH_COST;
		NumMarkersTested = 0;
		AI = GAIC;
		TetherActor = GoalActor;

		for (i = 0; i < GoalConstraints.length; i++)
		{
			GoalConstraints[i].Init(self);
		}
		InitNative();
		GAIC.Pawn.AddGoalEvaluator(self);
	}
	else
	{
		;
	}


}

private native function InitNative();


native final noexport function RateSlotMarker(NavigationPoint Marker, Pawn Pawn, int BaseRating);
event AddGoalConstraint(HodGoalConstraint Constraint)
{
	GoalConstraints[GoalConstraints.length] = Constraint;
}

event String GetDumpString()
{
	local int Idx;
	local String Str;

	if( GoalConstraints.Length == 0 )
	{
		return "Empty Cov Goal Constraints";
	}
	
	for( Idx = 0; Idx < GoalConstraints.length; Idx++ )
	{
		Str = Str@GoalConstraints[Idx].GetDumpString()@"\n";
	}
	return Str;
}

