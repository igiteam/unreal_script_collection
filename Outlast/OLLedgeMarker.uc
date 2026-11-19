class OLLedgeMarker extends OLGameplayMarker
	native
	placeable
	implements(Interface_NavMeshPathObject);

var() OLLedgeMarker Next;
var transient OLLedgeMarker Prev;

var() float PathOffset;
var() bool AICanVault;
var() int NonChaseCostMultiplier;
var() OLWaitPointComponent WaitPointComponent;

var vector WaitPointStartOffset;
var vector WaitPointAdditionalOffset;

var() bool bCanLedgeWalk;
var() bool bCanLedgeHang;

/** Can climb up this ledge (from ledge hang) */
var() bool bCanClimbUp;

/** Can drop from Ledge Walk OR from Ledge Hang */
var() bool bCanDropDown;

/** Whether slide is allowed over this obstacle */
var() bool bCanSlide;

var vector TopPoint;
var vector BottomPoint;

var OLBot ActiveBot;
var array<OLBot> Bots;

cpptext
{
	virtual void PostLoad();
	virtual void PostEditMove(UBOOL bFinished);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual UBOOL Tick( FLOAT DeltaSeconds, ELevelTick TickType );
	
	//Interface_NavMeshPathObject
	virtual void PostSubMeshUpdateForOwningPoly(FNavMeshPathObjectEdge* Edge, FNavMeshPolyBase* Poly, UNavigationMeshBase* New_SubMesh);
	virtual INT CostFor( const FNavMeshPathParams& PathParams, const FVector& PreviousPoint, FVector& out_PathEdgePoint, FNavMeshPathObjectEdge* Edge, FNavMeshPolyBase* SourcePoly );
	virtual UBOOL Supports( const FNavMeshPathParams& PathParams, FNavMeshPolyBase* CurPoly, FNavMeshPathObjectEdge* Edge, FNavMeshEdgeBase* PredecessorEdge);
	virtual UBOOL PrepareMoveThru( class IInterface_NavigationHandle* Interface, FVector& out_MovePt, FNavMeshPathObjectEdge* Edge );
	virtual UBOOL GetEdgeDestination( const FNavMeshPathParams& PathParams, FLOAT EntityRadius, const FVector& InfluencePosition, const FVector& EntityPosition, FVector& out_EdgeDest,	FNavMeshPathObjectEdge* Edge, UNavigationHandle* Handle);
	virtual UBOOL GetFinalEdgeDestination( FVector& out_EdgeDest, FNavMeshPathObjectEdge* Edge );
	virtual UBOOL DrawEdge( FDebugRenderSceneProxy* DRSP, FColor C, FVector DrawOffset, FNavMeshPathObjectEdge* Edge );
	virtual UBOOL AllowMoveToNextEdge(FNavMeshPathParams& PathParams, UBOOL bInPoly0, UBOOL bInPoly1) { return FALSE; }
	virtual void CreateEdgesForPathObject( APylon* Py );
	virtual void AddAuxSeedPoints( APylon* Py );
	virtual UBOOL Verify();

private:
	FMatrix GetLocalToWorldForLedge();
}

defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'Utility.LedgeMarker-01_D'
		Scale=0.10
	End Object

	PathOffset=60.0f
	AICanVault=false
	NonChaseCostMultiplier=20

	WaitPointStartOffset=(X=90.0f,Y=0.0f,Z=0.0f)
	WaitPointAdditionalOffset=(X=40.0f,Y=0.0f,Z=0.0f)

	bCanLedgeWalk=true
	bCanLedgeHang=true
	bCanClimbUp=true
	bCanDropDown=true
	bEnabled=true
}