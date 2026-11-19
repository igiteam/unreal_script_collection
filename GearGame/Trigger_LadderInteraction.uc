/*
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Trigger_LadderInteraction extends Trigger
	native
	placeable
	implements(Interface_NavMeshPathObject)
	implements(EditorLinkSelectionInterface);

cpptext
{
	// >>>>>>> Pathobject interface
	virtual INT CostFor( const FNavMeshPathParams& PathParams, const FVector& PreviousPoint, FVector& out_PathEdgePoint, FNavMeshPathObjectEdge* Edge, FNavMeshPolyBase* SourcePoly );
	
	virtual UBOOL Supports( const FNavMeshPathParams& PathParams,
							FNavMeshPolyBase* CurPoly,
							FNavMeshPathObjectEdge* Edge );

	virtual UBOOL PrepareMoveThru( class IInterface_NavigationHandle* Interface,
									FVector& out_MovePt,
									FNavMeshPathObjectEdge* Edge );
	virtual void AddAuxSeedPoints( APylon* Py );

	virtual FGuid* GetGuid() { return &NavGuid; }

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

/** Pointer to Ladder StaticMesh Actor */
var()	StaticMeshActor	LadderSMActor;
var()   Trigger_LadderInteraction OtherEndOfLadder;

var	vector			BottomLocOffset;
var	Rotator			BottomRotOffset;

var	vector			TopLocOffset;
var	Rotator			TopRotOffset;

/** Option to override the animation used */
var Name ClimbDownAnim, ClimbUpAnim;

/** list of override anims to choose from for up/down  (will pick one at random from list, or use default if none supplied) */
var() array<name> ClimbDownAnims, ClimbUpAnims;
/** list of animsets to add to the pawn using this ladder temporarily */
var() array<AnimSet> AdditionalAnimsets;

/** GUID used for linking paths across levels */
var() editconst const duplicatetransient guid NavGuid;

/** Set by special move start/end */
var transient GearPawn  LadderUser;
var transient float     LastTimeUserGotOff;
var() float             DelayBeforeReuseTime;

simulated function OnToggle(SeqAct_Toggle Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		SetCollision(true, false);
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		SetCollision(false, false);
	}
	else
	{
		SetCollision(!bCollideActors, false);
	}
	ForceNetRelevant();

	// force replicate flags if necessary
	if (RemoteRole != ROLE_None)
	{
		SetForcedInitialReplicatedProperty(Property'Engine.Actor.bCollideActors', (bCollideActors == default.bCollideActors));
	}
}

`if(`notdefined(FINAL_RELEASE))
simulated function Tick(float DeltaTime)
{
	local Vector	EntryLoc;
	local Rotator	EntryRot;

	Super.Tick(DeltaTime);

	if( LadderSMActor != None && bDebug )
	{
		// Debug for entry points
		if( IsTopOfLadder() )
		{
			GetTopEntryPoint(EntryLoc, EntryRot);
			DrawDebugCoordinateSystem(EntryLoc, EntryRot, 100.f, FALSE);
		}
		else
		{
			GetBottomEntryPoint(EntryLoc, EntryRot);
			DrawDebugCoordinateSystem(EntryLoc, EntryRot, 100.f, FALSE);
		}
	}
}
`endif

simulated native function bool IsTopOfLadder();
simulated native function GetTopEntryPoint( out vector out_Loc, out rotator out_Rot );
simulated native function GetBottomEntryPoint( out vector out_Loc, out rotator out_Rot );

event bool AIEnteredLinkedEdge(GearAI AI)
{
	return AI.UseLadder(self);
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=128.f
		CollisionHeight=128.f
	End Object

	Begin Object Class=LadderMeshComponent Name=LadderMesh
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		bUsePrecomputedShadows=False
	End Object
	Components.Add(LadderMesh)

	// Magic numbers to align player animation with ladder
	BottomLocOffset=(X=-73,Z=5)
	BottomRotOffset=(Yaw=-16384)
	TopLocOffset=(X=-62,Z=500.f)
	TopRotOffset=(Yaw=16384)

	DelayBeforeReuseTime=1.f

	bDebug=FALSE
}
