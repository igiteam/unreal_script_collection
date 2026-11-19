class OLNavMeshPath_SimilarToLastPath extends NavMeshPathConstraint
	native(AI);

cpptext
{
	// Interface
	virtual UBOOL EvaluatePath( FNavMeshEdgeBase* Edge, FNavMeshEdgeBase* PredecessorEdge, FNavMeshPolyBase* SrcPoly, FNavMeshPolyBase* DestPoly, const FNavMeshPathParams& PathParams, INT& out_PathCost, INT& out_HeuristicCost, const FVector& EdgePoint );
}

var float DifferentDirectionPenalty;

static function bool SimilarToLastPath(NavigationHandle NavHandle)
{
	local OLNavMeshPath_SimilarToLastPath Eval;

	if( NavHandle != None )
	{
		Eval = OLNavMeshPath_SimilarToLastPath(NavHandle.CreatePathConstraint(default.class));
		if (Eval != None)
		{

			NavHandle.AddPathConstraint(Eval);

			return TRUE;
		}
	}

	return FALSE;
}

event Recycle()
{
	Super.Recycle();
}

defaultproperties
{
	DifferentDirectionPenalty=200.0f
}