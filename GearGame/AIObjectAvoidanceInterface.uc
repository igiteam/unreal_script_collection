/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

interface AIObjectAvoidanceInterface extends Interface_NavMeshPathObject
	native(AI);

cpptext
{
	//////////////////////////////////////////////////////////////////////////
	// Interface_NavMeshPathObject
	/** 
	 *  Called from edges linked to this PO
	 *  @param Interface     - the navhandle interface of the entity pathing 
	 *  @param PreviousPoint - the previous point in the path search (e.g. the point along the predecessor edge)
	 *  @param out_PathEdgePoint - the point we used along this edge to determine the cost 
	 *  @param Edge - the edge linked to this PO which needs to compute cost	 
	 *  @return     - the cost for traversing this edge
	 */
	virtual INT CostFor( const FNavMeshPathParams& PathParams, const FVector& PreviousPoint, FVector& out_PathEdgePoint, FNavMeshPathObjectEdge* Edge, FNavMeshPolyBase* SourcePoly );
	
	/**
	 * called to allow this PO to draw custom stuff for edges linked to it
	 * @param DRSP          - the sceneproxy we're drawing for
	 * @param DrawOffset    - offset from the actual location we should be drawing 
	 * @param Edge          - the edge we're drawing
	 * @return - whether this PO is doing custom drawing for the passed edge (FALSE indicates the default edge drawing functionality should be used)
	 */
	virtual UBOOL DrawEdge( FDebugRenderSceneProxy* DRSP, FColor C, FVector DrawOffset, FNavMeshPathObjectEdge* Edge );
	// END path object interface
	//////////////////////////////////////////////////////////////////////////

	
	// default is to return event.. but can be overidden to allow quick returns on native classes
	virtual UAIAvoidanceCylinderComponent* GetAIAvoidanceCylinderComponent()
	{
		return	eventGetAIAvoidanceCylinderComponent();
	}

	/**
	 * For debugging.  Verifies that this pathobject is still alive and well and not orphaned or deleted
	 * @return - TRUE If this path object is in good working order
	 */
	virtual UBOOL Verify(){ return TRUE; }
};

event AIAvoidanceCylinderComponent GetAIAvoidanceCylinderComponent();

function bool ShouldAvoid(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
function bool ShouldEvade(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
function bool ShouldRoadieRun(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
// allows the owning object to setup a couple between an AutoNavMeshPathObstacleUnregister object and the pathobstacles registration (e.g. when the AutoNavMeshPathObstacleUnregister is GC'd unregister the obstacle)
function CoupleLifetime(Interface_NavMeshPathObstacle PO);


