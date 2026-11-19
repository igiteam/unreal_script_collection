/** 
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class InterpActor_MovableCover extends InterpActor
	native
	implements(Interface_NavMeshPathObstacle)
	placeable;


/** Pushable cover links */
var transient array<CoverLink_Movable> CoverLinks;
/** Time of last successful push */
var transient float LastMoveTime;
/** Pawns currently pushing this object */
var transient array<GearPawn> PushingPawns;

/** Minimum seconds between consecutive pushes */
var() float MovementTimeInterval;
/** Maximum time buffer between different players' pushes */
var() float PushFailDelay;
/** Number of pawns required to push this object */
var() int NumRequiredPushers;

/** Whether this cover is currently movable or not */
var bool bIsMovable;

/** Whether we should not show the "you can push" crosshair icon */
var() bool bHidePushableIcon;

/** TRUE when obstacle has been registered with the navmesh */
var bool bObstacleRegistered;
var vector LastObstacleCheckLoc;


replication
{
	if (Role == ROLE_Authority)
		bIsMovable;
}


cpptext
{
	virtual UBOOL GetBoundingShape(TArray<FVector>& out_PolyShape);
	virtual UBOOL PreserveInternalPolys() { return FALSE; }
	/**
	 * For debugging.  Verifies that this pathobject is still alive and well and not orphaned or deleted
	 * @return - TRUE If this path object is in good working order
	 */
	virtual UBOOL VerifyObstacle()
	{
		return !IsPendingKill();
	}

	virtual void BeginDestroy()
	{
		Super::BeginDestroy();
		UnRegisterObstacle();
	}
};

native function RegisterObstacle();
native function UnRegisterObstacle();
native function UpdateCoverLinks();

simulated function PostBeginPlay()
{
	local CoverLink_Movable Link;

	Super.PostBeginPlay();

	RegisterObstacle();

	// Store references to associated cover links
	foreach BasedActors( class'CoverLink_Movable', Link )
	{
		CoverLinks[CoverLinks.Length] = Link;
	}
}

/** Enables / disables cover links attached to this object */
simulated event SetCoverEnabled(bool bEnabled)
{	
	local int LinkIdx;

	for( LinkIdx = 0; LinkIdx < CoverLinks.length; ++LinkIdx )
	{
		CoverLinks[LinkIdx].SetDisabled(!bEnabled);
	}
}

function ClearPusherList()
{
	PushingPawns.length = 0;
}

/** Triggers CoverPush events associated with this actor */
function ApplyMovement(GearPawn InPusher)
{
	local int Idx;

	SetTimer(PushFailDelay, false, 'ClearPusherList');

	Idx = PushingPawns.Find(InPusher);
	if (Idx == INDEX_NONE)
	{
		PushingPawns.AddItem(InPusher);
	}

	if( PushingPawns.length >= NumRequiredPushers && 
		`TimeSince(LastMoveTime) > MovementTimeInterval )
	{
		LastMoveTime = WorldInfo.TimeSeconds;
		UnRegisterObstacle();
		TriggerEventClass(class'SeqEvt_CoverPush', InPusher);
		LastObstacleCheckLoc=Location;
		SetTimer(1.0, false, nameof(CheckForObstacleRegister));		
	}
}

function CheckForObstacleRegister()
{
	if( VSize2D(LastObstacleCheckLoc - Location) < 1.f )
	{
		RegisterObstacle();
	}
	else
	{
		LastObstacleCheckLoc=Location;
		SetTimer(1.0, false, nameof(CheckForObstacleRegister));
	}
}

defaultproperties
{
	bCollideActors=true
	bBlockActors=true
	bCollideWorld=false
	bPathColliding=false

	NumRequiredPushers=1
	MovementTimeInterval=0.5f
	PushFailDelay=1.f

	SupportedEvents.Add(class'SeqEvt_CoverPush')
	RemoteRole=ROLE_SimulatedProxy
	bIsMovable=true

	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'DP_Discoverables_Assets.BasicCubeModel'
		bAllowApproximateOcclusion=TRUE
		bCastDynamicShadow=FALSE
		bForceDirectLightMap=TRUE
		bUsePrecomputedShadows=TRUE
	End Object
	CollisionComponent=StaticMeshComponent0
}
