/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Positive is down.
 */
class NanoPerchPole_Base extends SkeletalMeshActor
	implements(NanoInterface_LaunchTarget,Interface_NavMeshPathObject)
	native
	abstract;

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
										UNavigationHandle* Handle);

	virtual UBOOL GetMeshSplittingPoly( TArray<FVector>& Poly, FLOAT& PolyHeight );

	virtual UBOOL DrawEdge( FDebugRenderSceneProxy* DRSP, FColor C, FVector DrawOffset, FNavMeshPathObjectEdge* Edge );
};

/** Name of socket to attach perch point to */
var()   name            PerchSocketName;

/** Spawned perch point, placed on end of pole */
var     NanoPerchPoint  PerchPoint;

var     float           CurrentLoad;

var     float           CurrentPos;

var     float           CurrentVel;

/** Pole spring stiffness */
var()   float           PoleStiffness;
/** Pole spring damping */
var()   float           PoleDamping;

var()   float           PawnNormalLoad;
var()   float           PawnDenseLoad;

/** If the current person on the pole is 'dense' (pulling pole down */
var()   bool            bDensePawnStanding;
/** The value of bDensePawnStanding last frame, to catch when this changes */
var     bool            bOldDensePawnStanding;

var transient bool      bWaitingToLaunchPawn;

/** If set, Pawn will be thrown to this target */
var()   Actor           PoleThrowTarget;
/** How long to take to reach PoleThrowTarget */
var()   float           PoleThrowTargetTime;

/** If PoleThrowTarget is not set, this is the speed pawn will be launched. */
var()   Vector          PoleThrowPawnVel;

var()	bool			bStabTarget;

var()	SoundCue		BendingCue;
var()	SoundCue		DenseBendingCue;
var()	SoundCue		UnbendCue;

var transient AudioComponent BendAC;

var()   float           PerchJumpBoost;
/** Indexed by internal id to path object edge */

var()   EPerchType      PerchType;

struct native PerchPoleEdgeInfo
{
	/** If True, edge goes from ground to perch, if False, from perch to ground */
	var() bool   bJumpToPerchPoint;

	/** Direction of the jump */
	var() Vector JumpDirection;
	/** Precomputed landing spot */
	var() Vector JumpDestination;

	/** Min required forward/upward velocity to be able to make this jump */
	var() float ReqForwardVel;
	var() float ReqUpwardVel;
};
var()   array<PerchPoleEdgeInfo>    PerchEdgeInfoList;

simulated event PostBeginPlay()
{
	local Vector PerchLoc;
	local Rotator PerchRot;
	local bool bFoundSocket;

	super.PostBeginPlay();

	// Spawn the perchpoint actor if not done so
	if( (PerchPoint == None) && (Role == ROLE_Authority) )
	{
		bFoundSocket = SkeletalMeshComponent.GetSocketWorldLocationAndRotation(PerchSocketName, PerchLoc, PerchRot);
		if(bFoundSocket)
		{
			PerchPoint = Spawn(class'NanoPerchPoint_Spawnable', self,, PerchLoc);
			PerchPoint.SetBase(self);//,, SkeletalMeshComponent, PerchSocketName);
			PerchPoint.PerchJumpBoost = PerchJumpBoost;
		}
	}
	if( PerchPoint != None )
	{
		PerchPoint.EnableStabTarget( bStabTarget );
		PerchPoint.PerchPole = self;
		PerchPoint.PerchType = PerchType;
		PerchPoint.Init();
	}

	// Reset to straight
	SetBendAmount(0.0);
}

/** Called on remote clients to set the location of the perch point */
simulated event InitializeSpawnPoint(NanoPerchPoint BasedPerchPoint)
{
	local Vector PerchLoc;
	local Rotator PerchRot;
	local bool bFoundSocket;

	if( BasedPerchPoint.Base == self )
	{
		PerchPoint = BasedPerchPoint;

		bFoundSocket = SkeletalMeshComponent.GetSocketWorldLocationAndRotation(PerchSocketName, PerchLoc, PerchRot);
		if( bFoundSocket )
		{
			BasedPerchPoint.SetLocation(PerchLoc);
			BasedPerchPoint.SetBase(self);//,, SkeletalMeshComponent, PerchSocketName);
		}

		BasedPerchPoint.PerchPole = self;
	}
}

simulated function SetLoad(float NewLoad)
{
	if (NewLoad != CurrentLoad)
	{
		if (NewLoad > CurrentLoad)
		{
			if (BendAC != None)
			{
				BendAC.FadeOut(0.1f,0.f);
				BendAC = None;
			}
			if (NewLoad == PawnNormalLoad)
			{
				BendAC = CreateAudioComponent(BendingCue,TRUE);
				BendAC.bAutoDestroy = TRUE;
			}
			else if (NewLoad == PawnDenseLoad)
			{
				BendAC = CreateAudioComponent(BendingCue,TRUE);
				BendAC.bAutoDestroy = TRUE;
			}
		}
		else if (NewLoad < CurrentLoad)
		{
			if (BendAC != None)
			{
				BendAC.FadeOut(0.1f,0.f);
				BendAC = None;
			}
			PlaySound(UnbendCue);
		}
		CurrentLoad = NewLoad;
	}
}

/** Implemented in subclasses to actually bend pole  */
simulated function SetBendAmount(float Bend) {}

/** Get the desired rotation for a pawn on the pole (points to next jump target) */
simulated function rotator GetPerchPawnDir()
{
	local vector X,Y,Z, ThrowDelta;
	local NanoInterface_LaunchTarget LT;

	if(PoleThrowTarget != None)
	{
		LT = NanoInterface_LaunchTarget(PoleThrowTarget);

		ThrowDelta = (LT != None ? LT.GetLandingLocation() : PoleThrowTarget.Location) - PerchPoint.Location;
		ThrowDelta.Z = 0.0;
		return rotator(ThrowDelta);
	}
	else
	{
		GetAxes(Rotation, X, Y, Z);
		return rotator(-Y);
	}
}


/** Called when a pawn perches on the perch point on pole */
simulated function PawnLockedToPerch(NanoPawn NP)
{
}

/** Called when a pawn release from the perch point on pole */
simulated function PawnUnlockedFromPerch(NanoPawn NP)
{
}

/** Update pole spring simulation */
simulated function UpdatePoleSpring(float DeltaTime)
{
	local float Force;

	// Calculate force
	Force = CurrentLoad - (CurrentPos * PoleStiffness) - (PoleDamping * CurrentVel);
	// Integrate for vel
	CurrentVel += (DeltaTime * Force);
	// Integrate for pos
	CurrentPos += (DeltaTime * CurrentVel );
	
	// If too high..
	if(CurrentPos > 1.0)
	{
		// clamp pos, and ensure vel is negative
		CurrentPos = 1.0;
		CurrentVel = FMin(0.0, CurrentVel);
	}
	// If too low..
	else if(CurrentPos < -1.0)
	{
		// clamp pos, and ensure vel is positive
		CurrentPos = -1.0;
		CurrentVel = FMax(0.0, CurrentVel);
	}

	// Update bend
	SetBendAmount(CurrentPos);
}

simulated function BeginPull()
{
	bDensePawnStanding = TRUE;
}

simulated function ReleasePull()
{
	bDensePawnStanding = FALSE;
}

simulated event Tick(float DeltaTime)
{
	local NanoPawn NP;

	super.Tick(DeltaTime);

	// Update pole
	UpdatePoleSpring(DeltaTime);
	
	if( PerchPoint != None && !bWaitingToLaunchPawn )
	{
		NP = PerchPoint.LockedPawn;

		if( NP == None )
		{
			SetLoad(0.0);
		}
		else if( bDensePawnStanding )
		{
			SetLoad(PawnDenseLoad);

			if( !bOldDensePawnStanding )
			{
				NotifyBeginDenseCharge();
			}
		}
		else
		{
			// If someone is standing on pole, they were dense last frame, but are not this frame, throw them up!
			if(bOldDensePawnStanding && !bWaitingToLaunchPawn )
			{
				if( NSM_PerchOnPoint(PerchPoint.LockedPawn.ActiveSpecialMove) != None )
				{
					NSM_PerchOnPoint(PerchPoint.LockedPawn.ActiveSpecialMove).NotifyLaunchPawn();
					bWaitingToLaunchPawn = TRUE;
				}
				else
				{
					// Old functionality...launch instantly!
					ThrowLockedPawn();
					SetLoad(PawnNormalLoad);
				}
			}
		}
	}

	// Update squished state
	bOldDensePawnStanding = bDensePawnStanding;
}

/** Called to have the pawn on this pole drop off (not jumping) */
simulated function Disengage()
{
	local NanoPawn NP;
	if(PerchPoint.LockedPawn != none)
	{
		NP = PerchPoint.LockedPawn;

		NP.LocalEndSpecialMove('NSM_PerchOnPoint');
	}
}


simulated function NotifyBeginDenseCharge()
{
 	local NSM_PerchOnPoint PoPMove;
 
	// Notify the active special move of the pawn that we began a dense charge
 	PoPMove = NSM_PerchOnPoint(PerchPoint.LockedPawn.ActiveSpecialMove);
 	if( PoPMove != None )
 	{
 		PoPMove.NotifyBeginDenseCharge();
 	}
}

simulated function ThrowLockedPawn()
{
	local NanoPawn NP;

	if(PerchPoint.LockedPawn != none)
	{
		NP = PerchPoint.LockedPawn;
		
		// First, unlock from perch
		PerchPoint.UnlockPawnFromPerch();

		// Basic behaviour is throwing with supplied vel
		NP.Velocity = PoleThrowPawnVel;
		
		// If target is specified, cal vel to reach it, and use that 
		if(PoleThrowTarget != None)
		{
			NP.AttemptBigJumpToActor( PoleThrowTarget, PoleThrowTargetTime );
		}	

		bWaitingToLaunchPawn = FALSE;
	}
}

/** By default, the toggle kismet action toggles the perchpoint */
simulated function OnToggle(SeqAct_Toggle inAction)
{
	if( PerchPoint != None )
	{
		if (inAction.InputLinks[0].bHasImpulse)
		{
			PerchPoint.bEnabled = TRUE;
		}
		else if (inAction.InputLinks[1].bHasImpulse)
		{
			PerchPoint.bEnabled = FALSE;
		}
		else
		{
			PerchPoint.bEnabled = !PerchPoint.bEnabled;
		}
	}
}

/** From NanoInterface_LaunchTarget */
event vector GetLandingLocation()
{
	return (PerchPoint != None ? PerchPoint.Location : Location);
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	PawnNormalLoad=1.0
	PawnDenseLoad=5.0
	
	PoleStiffness=10.0
	PoleDamping=1.0
	
	PoleThrowPawnVel=(Z=2000.0)
	PoleThrowTargetTime=2.0

	TickFrequencyDecreaseDistanceStart=1000
	TickFrequencyDecreaseDistanceEnd=4000
	TickFrequencyAtEndDistance=0.1

	PerchJumpBoost=728
}