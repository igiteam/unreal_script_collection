/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * JumpPoint has been replaced by JumpLink for Gears 3.
 * However they are a great example of Interface_NavMeshPathObject, 
 * so we are keeping the class around for that purpose.
 */
class JumpPoint extends PathNode
	native
	implements(Interface_NavMeshPathObject)
	implements(EditorLinkSelectionInterface)
	notplaceable;

cpptext
{
	// >>>>>>> Pathobject interface
	virtual INT CostFor( const FNavMeshPathParams& PathParams, const FVector& PreviousPoint, FVector& out_PathEdgePoint, FNavMeshPathObjectEdge* Edge, FNavMeshPolyBase* SourcePoly );
	
	virtual UBOOL Supports( const FNavMeshPathParams& PathParams,
							FNavMeshPolyBase* CurPoly,
							FNavMeshPathObjectEdge* Edge );

	virtual UBOOL PrepareMoveThru( IInterface_NavigationHandle* Interface,
									FVector& out_MovePt,
									FNavMeshPathObjectEdge* Edge );

	virtual void AddAuxSeedPoints( APylon* Py );

	virtual void CreateEdgesForPathObject( APylon* Py );

	virtual UBOOL GetEdgeDestination( const FNavMeshPathParams& PathParams,
										FLOAT EntityRadius,
										const FVector& InfluencePosition,
										const FVector& EntityPosition,
										FVector& out_EdgeDest,
										FNavMeshPathObjectEdge* Edge,
										UNavigationHandle* Handle)
	{
		out_EdgeDest = Edge->GetEdgeCenter()+PathParams.Interface->GetEdgeZAdjust(Edge);
		return TRUE;
	}

	virtual UBOOL DrawEdge( FDebugRenderSceneProxy* DRSP, FColor C, FVector DrawOffset, FNavMeshPathObjectEdge* Edge );


	// >>>>>> EditorLinkSelectionInterface
	virtual void LinkSelection(USelection* SelectedObjects);

	/**
	 * For debugging.  Verifies that this pathobject is still alive and well and not orphaned or deleted
	 * @return - TRUE If this path object is in good working order
	 */
	virtual UBOOL Verify()
	{
		return !IsPendingKill();
	}
	
}

struct native JumpInfo
{
	var() Actor Dest;
	var() vector CachedVelocity;
};
/** List of destinations this node should try to create a jump spec to */
var() array<JumpInfo> JumpDests;

defaultproperties
{
	bSpecialMove=TRUE
	bBuildLongPaths=FALSE
	
	Begin Object NAME=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
	End Object
}
