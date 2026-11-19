/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearScout extends Scout
	native
	transient;

cpptext
{
	virtual void InitForPathing( ANavigationPoint* Start, ANavigationPoint* End );
	virtual UClass* GetDefaultReachSpecClass();
	virtual FVector GetSize(FName desc);
	virtual FVector GetDefaultForcedPathSize(UReachSpec* Spec);
	virtual void SetPathColor(UReachSpec* ReachSpec);
	virtual void BuildCombatZones( UBOOL bFromDefinePaths = FALSE );
	UBOOL BuildLeapEdgeInfo( class AJumpPoint* Start, class AJumpPoint* Dest );

	/** pulls mesh/animation data from the default Marcus pawn for testing animation based movement */
	void InitAnimReferences();

	virtual UBOOL CanDoMove( const TCHAR* Str, ANavigationPoint* Nav, INT Item = -1, UBOOL inbSeedPylon = FALSE );
	virtual UBOOL CanMantle( FVector& StartLoc, FRotator& StartRot, INT Dir, ACoverLink* Link = NULL );
	
	/**
	 * will step forward from the point that the animation ends and find a valid place to fall
	 * @param MantleStartLoc - the location the mantle starts (before anim)
	 * @param AnimEndLoc - the location the animation got us
	 * @param out_FallStartLoc - the location that the fall should start
	 * @param out_AddedLateralDistance - the amount we had to step forward to get a valid fall point
	 * @param bMantleUp	- TRUE if we're testing for mantleup
	 * @return FALSE if no valid location was found
	 */
	virtual UBOOL FindFallStartLocation( const FVector& MantleStartLoc, const FVector& AnimEndLoc, FVector& out_FallStartLoc, FLOAT& out_AddedLateralDistance, UBOOL bMantleUp );

	/**
	 * plays out the fall after a good fall spot is found to verify it doesn't hit something then
	 * @param FallStartLoc - the location to start
	 * @param out_SimEndPos - position where sim ended up
	 * @param bMantleOver - should be TRUE if we're testing for mantleover
	 * @param bMantleUp  - should be true if we're testing for mantleup
	 * @return FALSE if no valid location was found
	 */
	virtual UBOOL VerifyFallTrajectory( const FVector& FallStartLoc, FVector& out_SimEndPos, UBOOL bMantleOver, UBOOL bMantleUp );

	/**
	 * will simulate a jump with the given velocity, and return TRUE of we actually make it there
	 * @param StartLoc - location to start the jump
	 * @param StartVelocity - tarting velocity for sim
	 * @param DesiredEndPos - the position we're trying to hit
	 * @param bDraw - draw the trajectory 
	 * @return TRUE If we made it to jump destination
	 */
	virtual UBOOL VerifyJumpTrajectory( const FVector& StartLoc, const FVector& StartVelocity, const FVector& DesiredEndPos, class UJumpLinkRenderingComponent* RenderComp=NULL );

	virtual UBOOL CanCoverSlip( ACoverLink* Link, INT SlotIdx, INT Dir );
	virtual UBOOL CanSwatTurn( ACoverLink* Link, INT SlotIdx, INT Dir );
	UBOOL PrepForMoveSimulation( const TCHAR* AnimName, FVector StartLocation, FRotator StartRotation );

	virtual void CreateMantleEdge( FNavMeshPolyBase* SrcPoly, FVector& EdgeEndPt1, FVector& EdgeEndPt2, FRotator& EdgeEndRot1, FRotator& EdgeEndRot2, INT Dir, AActor* RelActor, INT RelItem );

	virtual UAnimNodeSequence* GetRootMotionNode();
	virtual void OnEditorAnimEnd( UAnimNodeSequence* SeqNode, FLOAT PlayedTime, FLOAT ExcessTime );

#if WITH_EDITOR
	virtual void Exec( const TCHAR* Str );

	virtual INT PrunePathsForNav(ANavigationPoint* Nav);
	// called after PrunePathsForNav is called on all pathnodes
	virtual INT SecondPassPrunePathsForNav(ANavigationPoint* Nav);
#endif
};

var()	AnimNodeSequence RootMotionNode;
var		bool			 bAnimEnded;
var		bool			 bSeedPylon;


//** used for determining coverslip fitness 
var     float            MinSlipForwardClearance;

// distance we should assume the animation is going to make us fall (e.g. the root motion of the anim)
var     float            DefaultMantleLateralDist;
// when we transition to falling, this 
var     float            ForwardFallVelocityMag;


// ** path to anim tree template to use during editor anim simming
var string EditorSim_AnimTreeTemplateName;

// var used to enable debug information related to cover generation (used internally)
var transient bool bCoverGenDebug;

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	Super.OnAnimEnd(SeqNode,PlayedTime,ExcessTime);
	bAnimEnded=TRUE;
}

defaultproperties
{
	Begin Object NAME=CollisionCylinder
		CollisionRadius=+0034.000000
	End Object

	PathSizes.Empty
	PathSizes(0)=(Desc=Common,Radius=34,Height=80)
	PathSizes(1)=(Desc=Boomer,Radius=60,Height=90)
	PathSizes(2)=(Desc=Brumak,Radius=90,Height=120)
	EdgePathColors(0)=(R=0,G=0,B=255)
	EdgePathColors(1)=(R=0,G=255,B=0)
	EdgePathColors(2)=(R=255,G=127,B=39)

	Begin Object Class=SkeletalMeshComponent Name=GearPawnMesh
		BlockZeroExtent=true
		CollideActors=true
		BlockRigidBody=true
		RBChannel=RBCC_Pawn
		RBCollideWithChannels=(Default=true,Pawn=true,DeadPawn=false,BlockingVolume=true,EffectPhysics=true,FracturedMeshPart=true,SoftBody=true)
		bIgnoreControllersWhenNotRendered=true
		MinDistFactorForKinematicUpdate=0.2
		bAcceptsStaticDecals=false
		bAcceptsDynamicDecals=false
		bCullModulatedShadowOnBackfaces=false
		bAllowAmbientOcclusion=false
		MotionBlurScale=0.0
		bHasPhysicsAssetInstance=true	// Needed by PhysicsBodyImpact
		Translation=(Z=-74)

		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel')
		AnimTreeTemplate=AnimTree'COG_MarcusFenix_LD.Animations.AT_EditorSimulation'

	End Object
	Mesh=GearPawnMesh
	Components.Add(GearPawnMesh)


	EditorSim_AnimTreeTemplateName="COG_MarcusFenix_LD.Animations.AT_EditorSimulation"

	MinMantleFallDist=37
	MaxMantleFallDist=196 // anim takes us 100 units above slot loc, so 196 represents 96 units below slot location
	MinMantleLateralDist=16
	MaxMantleLateralDist=300
	DefaultMantleLateralDist=141.0
	ForwardFallVelocityMag=100.0
	MaxMantleFallTime=2.0

	NavMeshGen_MaxDropHeight=140.0

	NavMeshGen_MaxPolyHeight=315.0
	NavMeshGen_EntityHalfHeight=42.0
	NavMeshGen_StartingHeightOffset=42.0
	NavMeshGen_MaxStepHeight=40.0
	NavMeshGen_ExpansionDoObstacleMeshSimplification=FALSE

	MinSlipForwardClearance=24.0

}
