class OLAIVaultMarker extends OLGameplayMarker
	native
	placeable
	implements(Interface_NavMeshPathObject);

var() float VaultWidth;
var() int NonChaseCostMultiplier;
var() OLWaitPointComponent WaitPointComponent;

var vector EndPointOne;
var vector EndPointTwo;

var OLBot ActiveBot;
var array<OLBot> Bots;

cpptext
{
	virtual void PostLoad();
	virtual void PostEditMove(UBOOL bFinished);
	virtual UBOOL Tick( FLOAT DeltaSeconds, ELevelTick TickType );

	virtual UBOOL IsValid() const { return TRUE; }

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
}

defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'Utility.VaultOver-01_D'
		Scale=0.1
		Translation=(X=0.0,Y=0.0,Z=5.0)
	End Object

	Begin Object Class=OLWaitPointComponent Name=WPC
		StartOffset=(X=140.0f,Y=0.0f,Z=0.0f)
		AdditionalOffset=(X=40.0f,Y=0.0f,Z=0.0f)
	End Object
	WaitPointComponent=WPC
	Components.Add(WPC)

	VaultWidth=200.0f
	NonChaseCostMultiplier=20
}