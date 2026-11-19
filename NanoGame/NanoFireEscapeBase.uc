/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoFireEscapeBase extends Actor
	implements(NanoInterface_LaunchTarget)
	placeable
	abstract
	native;

/** Mesh to be used at each floor */
var()   StaticMesh      FloorMesh;

/** Mesh to be used to connect each */
var()   StaticMesh      LadderMesh;

/** Number of floors to create (updated in PostEditChange()) */
var()   int             NumFloors;
var()   float           FloorSpacing;

var    array<StaticMeshComponent>             FloorMeshComps;
var()  StaticMeshComponent                    LadderSpringMesh;

/** Ladder straining sound */
var()                   SoundCue              LadderStrainSound;
/** Ladder launching sound */
var()                   SoundCue              LadderLaunchSound;

/** Level perching grab sound (tang!) */
var()                   SoundCue              ActiveMantleBeginSound;
var()                   SoundCue              ActiveMantleSuccessSound;
var()                   SoundCue              ActiveMantleFlubSound;

/** Level perching camera shake */
var()                   NanoCameraShake       ActiveMantleCameraShake;

/** The perch point for the pawn at the end of the spring ladder */
var private transient   NanoPerchPoint        LadderSpringPoint;

/** Offset, relative to the pivot of the ladder (IN LADDER MESH SPACE) for the perch point */
var() private           vector                SpringPointRelativeLoc;

/** Maximum deflection, in rotators, when a pawn is densed on the ladder */
var() private           int                   MaxLadderDeflection;

/** Current target for deflection of the ladder, based on load */
var transient private   Rotator               CurrentDeflectionTarget;

/** RInterpTo speeds for the ladder when loaded and unloaded */
var() private           float                 DenseLadderRotSpeed, ReturnLadderRotSpeed;

/** Indicates the pawn is ready to be launched */
var private transient   bool                  bReadyToLaunch;

/** Number of stories to throw the pawn up on a successful active mantle */
var()                   int                   ActiveMantleStories;
/** Number of stories to throw the pawn up on a normal active mantle */
var()                   int                   NormalMantleStories;

/** Offsets to use when creating the per-level perch points.  These are relative to the FloorMesh's origin */
var() private           vector                FrontPerchPointOffset, RearPerchPointOffset, LeftPerchPointOffset, RightPerchPointOffset;

/** Target to launch the player to if they do an active mantle at the top floor */
var()                   Actor                 DismountTarget;

/** Struct containing info related to branches if the player does an active mantle at a specified floor */
struct native FMantleBranchInfo
{
	/** Floor which this branch should trigger on if there is an active mantle */
	var() int   Floor;
	/** Actor to launch to */
	var() Actor Target;
	/** Travel time to the target actor */
	var() float TravelTime;
	/** Direction this branch is valid for (ladder side == UP) */
	var() EDirection ValidDirection;

	structdefaultproperties
	{
		TravelTime=1.f
		ValidDirection=DIR_Up;
	}
};
/** Array of branches and targets for active mantles.  If a player does an active mantle at one of the floors specified, they will be shot to the target point */
var() array<FMantleBranchInfo>    ActiveMantleBranches;

cpptext
{
	virtual void PostLoad();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostEditMove(UBOOL bFinished);
};

/** Util to get bounds of all floor meshes */
native function BoxSphereBounds GetFloorMeshBounds();


/** After beginning play, spawn a new perch point! */
simulated function PostBeginPlay()
{
	local CylinderComponent CylCmpt;
	local float Radius;
	local vector CylTranslation;
	local BoxSphereBounds MeshBounds;

	Super.PostBeginPlay();

	// Attempt to spawn a spring point, so that we can have a place to mount the ladder
	LadderSpringPoint = Spawn(class'NanoPerchPoint_Spawnable', self);
	if( LadderSpringPoint != None )
	{
		LadderSpringPoint.SetBase(self);
		LadderSpringPoint.FireEscape = self;
		LadderSpringPoint.CamOffset = vect(-64.f,0.f,-128.f);
		//LadderSpringPoint.bLockPlayerLook = true;
		UpdateSpringPerchPosition();
	}
	else
	{
		`log("LadderSpringPoint could not be spawned, please investigate!");
	}

	// Size the cylinder component based on the widest axis
	CylCmpt = CylinderComponent(CollisionComponent);
	if( CylCmpt != None )
	{
		MeshBounds = GetFloorMeshBounds();

		Radius = FMax(MeshBounds.BoxExtent.X, MeshBounds.BoxExtent.Y);
		CylCmpt.SetCylinderSize(Radius, MeshBounds.BoxExtent.Z);
		
		CylTranslation.X = Radius;
		CylTranslation.Y = Radius/2.f;
		CylTranslation.Z = MeshBounds.BoxExtent.Z;
		CylCmpt.SetTranslation(CylTranslation);
	}
}

/** Figure out which floor we should attach to, based on the world height (for attaching pawns that jump to the fire escape) */
simulated function int GetFloorFromHeight( float ZHeight )
{
	local int RetVal;

	RetVal = FFloor((ZHeight - Location.Z) / FloorSpacing) + 1;

	return Clamp(RetVal, 1, NumFloors-1);
}


simulated function vector GetFloorTargetLocation( int Floor, vector PawnLocation )
{
	local vector OffsetToUse;

	// Clamp to make sure we're not requesting a floor that's higher than the fire escape
	if( Floor > NumFloors )
	{
		Floor = NumFloors;
	}

	switch( GetDirectionFromLocation(PawnLocation) )
	{
		case DIR_Left:
			OffsetToUse = LeftPerchPointOffset;
			break;
		case DIR_Right:
			OffsetToUse = RightPerchPointOffset;
			break;
		case DIR_Down:
			OffsetToUse = RearPerchPointOffset;
			break;
		case DIR_Up:
		default:
			OffsetToUse = FrontPerchPointOffset;
			break;
	}

	// If needed, invert the offsets because of the drawscale flipping
	OffsetToUse *= DrawScale3D;

	return Location + ((OffsetToUse + (Floor-1) * FloorSpacing * vect(0.f,0.f,1.f)) >> Rotation);
}

/** Returns a relative direction based on the test location's position relative to the fire escape center.  Up is considered to be the side with the ladder mount point */
simulated function EDirection GetDirectionFromLocation( vector TestLocation )
{
	local vector TargetToSelf;
	local float ApproachDot;
	local bool bInvertX, bInvertY;

	// Figure out our vector of approach to the fire escape
	TargetToSelf = GetFloorMeshBounds().Origin - TestLocation;
	TargetToSelf.Z = 0.f;
	TargetToSelf = Normal(TargetToSelf);

	// Figure out the angle of approach to the fire escape
	ApproachDot = vector(Rotation) dot TargetToSelf;

	// See if we need to invert our calculations due to drawscale flipping
	bInvertX = DrawScale3D.X < 0.f;
	bInvertY = DrawScale3D.Y < 0.f;

	// Determine which offset to use, based on angle of approach
	if( ApproachDot <= -0.7071f )
	{
		return (!bInvertX) ? DIR_Up : DIR_Down;
	}
	else if( ApproachDot >= 0.7071f )
	{
		return (!bInvertX) ? DIR_Down : DIR_Up;
	}
	else
	{
		if( TargetToSelf dot (vect(0.f,1.f,0.f) >> Rotation) < 0.f )
		{
			return (!bInvertY) ? DIR_Right : DIR_Left;
		}
		else
		{
			return (!bInvertY) ? DIR_Left : DIR_Right;
		}
	}
}

/** Returns TRUE if an active mantle at the floor should branch to another location.  If TRUE, TargetLocation has the location of the actor to branch to */
simulated function bool HasActiveMantleBranch(int Floor, vector PawnLocation, out vector TargetLocation, out float TravelTime)
{
	local FMantleBranchInfo BranchInfo;
	local NanoInterface_LaunchTarget LT;

	// Iterate over the branch infos, looking for a match
	foreach ActiveMantleBranches(BranchInfo)
	{
		if( Floor == BranchInfo.Floor && BranchInfo.Target != None && BranchInfo.ValidDirection == GetDirectionFromLocation(PawnLocation) )
		{
			LT = NanoInterface_LaunchTarget(BranchInfo.Target);
			TargetLocation = LT != None ? LT.GetLandingLocation() : BranchInfo.Target.Location;
			TravelTime = BranchInfo.TravelTime;

			return TRUE;
		}
	}

	return FALSE;
}

simulated event Tick( float DeltaTime )
{
	local rotator NewRot;
	local bool    bIsDensed;
	local NanoPawn NP;

	Super.Tick(DeltaTime);

	if( LadderSpringPoint != None )
	{
		// If we have a spring point, check to see what our deflection should be, based on our load
		if( LadderSpringPoint.LockedPawn != None )
		{
			bIsDensed = LadderSpringPoint.LockedPawn.CurrNanoState == ENS_Dense;
			CurrentDeflectionTarget = default.LadderSpringMesh.Rotation - (bIsDensed ?  MakeRotator(0,0,MaxLadderDeflection) : rot(0,0,-500));
		}
		else
		{
			CurrentDeflectionTarget = default.LadderSpringMesh.Rotation;
		}
	}

	// Update the ladder position, if necessary
	if( LadderSpringMesh.Rotation != CurrentDeflectionTarget )
	{
		NewRot = RInterpTo( LadderSpringMesh.Rotation, CurrentDeflectionTarget, DeltaTime, bIsDensed ? DenseLadderRotSpeed : ReturnLadderRotSpeed );
		LadderSpringMesh.SetRotation(NewRot);

		// Make sure the spring point stays at the end of the ladder
		UpdateSpringPerchPosition();

		if( bIsDensed && !bReadyToLaunch )
		{
			bReadyToLaunch = TRUE;
		}

		if( !bIsDensed && bReadyToLaunch )
		{
			NP = LadderSpringPoint.LockedPawn;

			LadderSpringPoint.UnlockPawnFromPerch();
			NP.DoSpecialMove('NSM_FireEscape', TRUE, None, self, 3);

			if( LadderLaunchSound != None )
			{
				PlaySound(LadderLaunchSound);
			}

			bReadyToLaunch = FALSE;
		}
	}
}

/** Keeps the perch point stationed at the end of the ladder */
simulated function UpdateSpringPerchPosition()
{
	if( LadderSpringPoint != None )
	{
		SpringPointRelativeLoc = LadderSpringMesh.Translation + (vect(0.f, 0.f, 480.f) >> LadderSpringMesh.Rotation);
		LadderSpringPoint.SetRelativeLocation(DrawScale3D * SpringPointRelativeLoc);
	}
}

/** Callback when the number of floors changes.  Lazy, destroys all instanced meshes and perch points, and recreates them */
native function UpdatedFloorCount();

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local NanoPawn NP;
	local int FloorToAttachTo;
	local vector Displacement;
	local bool bIsWithinBounds;
	local BoxSphereBounds MeshBounds;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	// Determine if the touch was within vertical bounds of the static mesh
	MeshBounds = GetFloorMeshBounds();
	Displacement = MeshBounds.Origin - Other.Location; // Just taking bottom mesh, don't care about Z, assume stacked vertically...
	bIsWithinBounds = (abs(Displacement.X) < MeshBounds.BoxExtent.X) && (abs(Displacement.Y) < MeshBounds.BoxExtent.Y);
	
	// If the pawn isn't doing anything else, clamp on when it touches the cylinder!
	NP = NanoPawn(Other);
	if( NP != None && NP.ActiveSpecialMove == None && !bIsWithinBounds )
	{
		FloorToAttachTo = GetFloorFromHeight(NP.Location.Z);

		// If we have a valid floor to attach to, attach!
		if( FloorToAttachTo != INDEX_NONE )
		{
			NP.DoSpecialMove( 'NSM_FireEscape', TRUE, None, self, GetFloorFromHeight(NP.Location.Z) );
		}
	}
}


/** Should return a vector (in world space) where the pawn should land for big jumps */
simulated event vector GetLandingLocation()
{
	return LadderSpringPoint.Location;
}


defaultproperties
{
	bEdShouldSnap=true

	bNoDelete=true
	bMovable=false

	bCollideActors=true
	bBlockActors=true

	FloorSpacing=384.f
	NumFloors=1

	MaxLadderDeflection=3500
	DenseLadderRotSpeed=4.f
	ReturnLadderRotSpeed=10.f

	ActiveMantleStories=4
	NormalMantleStories=2

	FrontPerchPointOffset=(X=384+32,Y=96,Z=88)
	RearPerchPointOffset=(X=-32,Y=96,Z=88)
	LeftPerchPointOffset=(X=190,Y=0,Z=88)
	RightPerchPointOffset=(X=190,Y=192,Z=88)
}