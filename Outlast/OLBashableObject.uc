class OLBashableObject extends Actor
	ClassGroup(OL,Ingredient)
	native
	placeable
	implements(Interface_NavMeshPathObject);

var() enum EOLBashableType
{
	EOLBT_Wall,
	EOLBT_Table,
} BashableType;

var() StaticMeshComponent PreBashCollision;
var() StaticMeshComponent PostBashCollision;
var() SkeletalMeshComponent Mesh;

var() DynamicLightEnvironmentComponent LightEnvironment;

var() name BashAnimation;

var() float PathPointOffset;
var() float BashYOffset;

var() bool bEnabled;

var bool bBroken;

var vector Edge0Dest;
var vector Edge1Dest;

var transient bool bInitiallyEnabled; 

cpptext
{
	virtual void PostLoad()
	{
		Super::PostLoad();

		if (GIsGame)
		{
			bInitiallyEnabled = bEnabled;
		}
	}

	virtual void Reset()
	{
		bEnabled = bInitiallyEnabled;
		bBroken = FALSE;

		SetCollisionType(COLLIDE_NoCollision);
		CollisionComponent = PreBashCollision;
		SetCollisionType(COLLIDE_BlockAll);
	}

	// Interface_NavMeshPathObject
	virtual void PostSubMeshUpdateForOwningPoly(FNavMeshPathObjectEdge* Edge, FNavMeshPolyBase* Poly, UNavigationMeshBase* New_SubMesh);
	virtual INT CostFor( const FNavMeshPathParams& PathParams, const FVector& PreviousPoint, FVector& out_PathEdgePoint, FNavMeshPathObjectEdge* Edge, FNavMeshPolyBase* SourcePoly );
	virtual UBOOL Supports( const FNavMeshPathParams& PathParams, FNavMeshPolyBase* CurPoly, FNavMeshPathObjectEdge* Edge, FNavMeshEdgeBase* PredecessorEdge);
	virtual UBOOL PrepareMoveThru( class IInterface_NavigationHandle* Interface, FVector& out_MovePt, FNavMeshPathObjectEdge* Edge );
	virtual UBOOL GetEdgeDestination( const FNavMeshPathParams& PathParams, FLOAT EntityRadius, const FVector& InfluencePosition, const FVector& EntityPosition, FVector& out_EdgeDest,	FNavMeshPathObjectEdge* Edge, UNavigationHandle* Handle);
	virtual UBOOL GetFinalEdgeDestination( FVector& out_EdgeDest, FNavMeshPathObjectEdge* Edge );
	virtual UBOOL DrawEdge( FDebugRenderSceneProxy* DRSP, FColor C, FVector DrawOffset, FNavMeshPathObjectEdge* Edge );
	virtual UBOOL AllowMoveToNextEdge(FNavMeshPathParams& PathParams, UBOOL bInPoly0, UBOOL bInPoly1);
	virtual UBOOL GetMeshSplittingPoly( TArray<FVector>& Poly, FLOAT& PolyHeight );
	virtual void AddAuxSeedPoints( APylon* Py );
	virtual void CreateEdgesForPathObject( APylon* Py );
	virtual EEdgeHandlingStatus AddStaticEdgeIntoThisPO( EEdgeHandlingStatus Status, const FVector& inV1, const FVector& inV2, TArray<FNavMeshPolyBase*>& ConnectedPolys, INT PolyAssocatedWithThisPO, FLOAT SupportedEdgeWidth=-1.0f, BYTE EdgeGroupID=MAXBYTE);
	virtual UBOOL Verify();
}

function Break()
{
	bBroken = true;

	SetCollisionType(COLLIDE_NoCollision);
	CollisionComponent = PostBashCollision;
	SetCollisionType(COLLIDE_BlockAll);

	Mesh.PlayAnim(BashAnimation);
}

function TriggerBreakTimer( float Time )
{
	SetTimer(Time, false, 'Break');
}

function ClearBreakTimer()
{
	ClearTimer('Break');
}

function OnToggle(SeqAct_Toggle Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		// turn on
		bEnabled = true;
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		// turn off
		bEnabled = false;
	}
	else if (Action.InputLinks[2].bHasImpulse)
	{
		// toggle
		bEnabled = !bEnabled;
	}
}

defaultproperties
{
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		StaticMesh=StaticMesh'Interactive_Objects.DynEnv.BasementWallBashCol-01'
		HiddenGame=true
	End Object
	CollisionComponent=StaticMeshComponent0
	PreBashCollision=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent1
		StaticMesh=StaticMesh'Interactive_Objects.DynEnv.BasementWallBashCol-02'
		HiddenGame=true
	End Object
	PostBashCollision=StaticMeshComponent1
	Components.Add(StaticMeshComponent1)

	BashAnimation=BasementWallBash-01

	Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
		Begin Object Class=AnimNodeSequence Name=BashSequence
			Name="BashSequence"
		End Object
		Animations=BashSequence
		SkeletalMesh=SkeletalMesh'Interactive_Objects.DynEnv.BasementWallBash-01'
		ReplacementPrimitive=None
		LightEnvironment=MyLightEnvironment
		RBChannel=RBCC_GameplayPhysics
		bUpdateSkelWhenNotRendered=False
		LightingChannels=(bInitialized=True,Dynamic=True)
		RBCollideWithChannels=(Default=True,GameplayPhysics=True,EffectPhysics=True,BlockingVolume=True)
		AnimSets(0)=AnimSet'Interactive_Objects.DynEnv.BasementWallBash-01_AS'
	End Object
	Mesh=SkeletalMeshComponent0
	Components.Add(SkeletalMeshComponent0)

	bStatic=false
	bCollideActors=true
	bBlockActors=true
	Physics=PHYS_None

	BashableType=EOLBT_Wall
	PathPointOffset=100.0
	BashYOffset=0.0
	bEnabled=true
}