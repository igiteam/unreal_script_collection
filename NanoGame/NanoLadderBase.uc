/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoLadderBase extends Actor
	native(AI)
	placeable
	implements(Interface_NavMeshPathObject)
	abstract;

var int ClassVersion;
var int InstanceVersion;

/** Height of ladder to build */
var() int LadderHeight;

var() bool bAddExtraBottomMesh;

var float DistToClimb;

var StaticMesh TopMesh, BottomMesh, LoopingMesh;
var const int LadderInterval;

var array<StaticMeshComponent> LadderComps;
var StaticMeshComponent TopMeshComp;

var vector TopQueueLocation, BottomQueueLocation;

var transient NanoPawn CurrentClimber;

var CylinderComponent CollisionCylinder;

/** Set on the specific ladder to debug its path building **/
var() bool bDebugPathBuild;

cpptext
{
	void UpdateLadder();
	
	UBOOL ShouldQueueClimber(APawn *Pawn, FNavMeshPathObjectEdge* Edge);

	virtual UBOOL PrepareMoveThru( class IInterface_NavigationHandle* Interface,
									FVector& out_MovePt,
									FNavMeshPathObjectEdge* Edge );
	virtual UBOOL Supports( const FNavMeshPathParams& PathParams,
							FNavMeshPolyBase* CurPoly,
							FNavMeshPathObjectEdge* Edge );
	virtual UBOOL GetEdgeDestination( const FNavMeshPathParams& PathParams,
										FLOAT EntityRadius,
										const FVector& InfluencePosition,
										const FVector& EntityPosition,
										FVector& out_EdgeDest,
										FNavMeshPathObjectEdge* Edge,
										UNavigationHandle* Handle);

	virtual void CreateEdgesForPathObject( APylon* Py );

	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostLoad();	

	virtual INT CostFor( const FNavMeshPathParams& PathParams, const FVector& PreviousPoint, FVector& out_PathEdgePoint, FNavMeshPathObjectEdge* Edge, FNavMeshPolyBase* SourcePoly );

	virtual UBOOL AllowMoveToNextEdge(FNavMeshPathParams& PathParams, UBOOL bInPoly0, UBOOL bInPoly1);
}



defaultproperties
{

}
