class OLNavigationHandle extends NavigationHandle
	native(AI);

struct native MovePoint
{
	var vector Destination;
	var native array<pointer> RelevantEdges{FNavMeshEdgeBase};
};

var array<MovePoint> MovePoints;

var int LastMovePointIdxForPath;

var() bool bDebugMovePoints;

cpptext
{
	UBOOL AreNewObstaclesOnPath();

	virtual void ClearCrossLevelRefs(ULevel* Level);
	virtual void ClearAllMeshRefs();
	virtual void PostEdgeCleanup(FNavMeshEdgeBase* Edge);
	virtual void BeginDestroy();

	virtual UBOOL PathContainsDoor();

	TArray<FVector> CalculateBezierControlPoints(const TArray<FVector>& SegmentPoints, FLOAT ControlScale);

	FVector2D CatmullRomPointOnCurve(FVector2D P0, FVector2D P1, FVector2D P2, FVector2D P3, FLOAT T);
	FVector2D CatmullRomTangentOnCurve(FVector2D P0, FVector2D P1, FVector2D P2, FVector2D P3, FLOAT T);
	FLOAT CatmullRomGetBestTForPoint(FVector2D Point, const TArray<FVector2D>& TestPoints, FVector2D P0, FVector2D P1, FVector2D P2, FVector2D P3, UBOOL& bPastLastPoint, INT& LastIndex);

private:
	void MovePoints_Remove(INT Idx);

	void GetLeftRightFromEdge(const FNavMeshPolyBase* Poly, FNavMeshEdgeBase* Edge, FVector& Left, FVector& Right);
	void CalculateMovePoints();
	void ModifyMovePoints();

	void TrimPath(INT EndIndex, FVector& NewDestination);
}

native function bool FindPath( optional out Actor out_DestActor, optional out int out_DestItem );

native function bool GetNextMoveLocation( out Vector out_MoveDest, float ArrivalDistance );

native function bool GetNextMovePath( out array<vector> out_MovePath, float ArrivalDistance );

native function PopMoveLocation();

native function ClearPath();

native function bool TrimPathToLastDoor( out vector out_NewDestination );

native function bool TrimPathByDistance( float DistanceToTrim, out vector out_NewDestination, optional bool bStopAtMeshObject );

native function bool PointReachable( Vector Point, optional Vector OverrideStartPoint, optional bool bAllowHitsInEndCollisionBox=true);

defaultproperties
{
}