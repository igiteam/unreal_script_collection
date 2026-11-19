/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class JumpLink extends PathNode
	native
	implements(Interface_NavMeshPathObject);

struct native JumpLinkEdgeData
{
	var int Cost;
	var vector StartLocationA, StartLocationB;
	var vector DestLocationA, DestLocationB;
};
var array<JumpLinkEdgeData> EdgeData;

/** Can Locust Drones use? */
var() bool bAllowLocustDrone;
/** Can Bloodmounts use? */
var() bool bAllowBloodmount;
/** Can Lambent Humans use? */
var() bool bAllowLambentHuman;
/** Can Polyps use this? */
var() bool bAllowPolyps;
/** Can Wretches use this? */
var() bool bAllowWretch;
/** Can Shriekers use this? */
var() bool bAllowShrieker;

/** Points specifying the jump lines */
var noimport JumpLinkPoint StartLeft;
var noimport JumpLinkPoint StartRight;
var noimport JumpLinkPoint EndLeft;
var noimport JumpLinkPoint EndRight;

/** Current offsets where JumpLinkPoints are located */
var vector StartLeftOffset;
var vector StartRightOffset;
var vector EndLeftOffset;
var vector EndRightOffset;

/** Should this create two-way edges? */
var() bool bTwoWay;

var() bool bPropagateNavMeshSeeds;

var transient JumpLinkRenderingComponent DebugRenderComp;

/** initial time to shoot for when calculating jump trajectories (seconds) */
var() float JumpTime;
/** when turned ON, all jump trajectories will be drawn, even successful ones */
var() bool bDebugJumpTrajectories;
/** when TRUE all calculated jump trajectories will be drawn */
var() bool bVerboseDebugJumpTrajectories;



cpptext
{
	virtual void PostLoad();

	virtual FBox GetComponentsBoundingBox(UBOOL bNonColliding=0) const;

	virtual void Spawned();
	virtual void PostScriptDestroyed();

	virtual void PostEditImport();
	virtual void PostEditMove(UBOOL bFinished);

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
 
 	virtual UBOOL DrawEdge( FDebugRenderSceneProxy* DRSP, FColor C, FVector DrawOffset, FNavMeshPathObjectEdge* Edge );

	/**
	 * For debugging.  Verifies that this pathobject is still alive and well and not orphaned or deleted
	 * @return - TRUE If this path object is in good working order
	 */
	virtual UBOOL Verify()
	{
		return !IsPendingKill();
	}

	/** Sets current offsets for JumpLinkPoint objects */
	virtual void SetJumpLinkPointOffsets();

	virtual void CheckForErrors();

	UBOOL VerifyJumpTrajectories(UJumpLinkRenderingComponent* RenderComp=NULL);

	UBOOL CalculateJumpVelocity(const FVector& Start, const FVector& Dest, FVector& JumpVelocity, FLOAT GravityZ=-1.0f, ULineBatchComponent* RenderComp=NULL);
}

native function bool GetJumpVelocity(Pawn PawnJumping, vector Dest, out vector JumpVelocity);

defaultproperties
{
	bSpecialMove=TRUE
	bBuildLongPaths=FALSE
	bPropagateNavMeshSeeds=TRUE

	StartLeftOffset=(X=-100,Y=-100)
	StartRightOffset=(X=100,Y=-100)
	EndLeftOffset=(X=-100,Y=100)
	EndRightOffset=(X=100,Y=100)
	
	Begin Object NAME=Sprite
		Sprite=Texture2D'EditorMaterials.JumpLink'
	End Object

	Begin Object Class=JumpLinkRenderingComponent Name=JumpLinkRenderingComponent0_DOIT
	End Object
	Components.Add(JumpLinkRenderingComponent0_DOIT)
	DebugRenderComp=JumpLinkRenderingComponent0_DOIT

	bAllowLambentHuman=true

	JumpTime=0.5
}
