
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class HeadTrackTarget extends Keypoint
	placeable
	native;

/** Headtracking zone is spherical, this is the sphere radius. */
var() float		Radius;
/** True if this target is currently active, false otherwise. */
var() bool		bEnabled;
/** Optionally look at this actor, instead of the HeadTrackTarget itself. */
var() Actor		AlternateLookatActor;
/** Which bone to look at in the AlternateLookatActor, assuming it has bones */
var() Name		AlternateLookAtActorBoneName;
/** Range of time (min, max) that Pawn can look at this Target. 0 = Can look at forever */
var() Vector2D  LookAtTime;
/** Delay between 2 look at for the same Pawn */
var() FLOAT     DelayBetweenLookAtSamePawn;
/** Delay between the pawn looking at any head track target */
var() FLOAT     DelayBeforeNextTarget;
/** Max Pawns allowed to look at Target at one time. 0 == no limit. */
var() INT       MaxPawnsLookingAtTheSameTime;
/** Max times Pawns can look at this Target before disabling it. 0 == no limit */
var() INT       MaxLookAtCountBeforeDisable;
/** True if we've registered with the GRI, false otherwise */
var private transient bool bRegistered;
var private transient INT LookAtCount;

enum EHeadTrackPawnFilter
{
	HT_PlayersOnly,
	HT_PlayerTeamOnly,
	HT_AllPawns,
};

/** Specify which pawns this should affect */
var() EHeadTrackPawnFilter PawnFilter;

var	private DrawSphereComponent SphereRenderComponent;

struct native LookedAtPawn
{
	/** Pawn Looked At us */
	var() GearPawn      Pawn;
	/** Time at which Pawn looked at us */
	var() FLOAT         Time;
};

/** List of Pawns that looked at us */
var transient Array<LookedAtPawn> LookedAtPawnList;
/** Pawns Looking at me right now */
var transient Array<GearPawn> PawnsLookingAtMe;

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
#if WITH_EDITOR
	virtual void EditorApplyScale(const FVector& DeltaScale, const FMatrix& ScaleMatrix, const FVector* PivotLocation, UBOOL bAltDown, UBOOL bShiftDown, UBOOL bCtrlDown);
#endif
}

simulated function PostBeginPlay()
{
	if (WorldInfo.GRI != None)
	{
		GearGRI(WorldInfo.GRI).RegisterHeadTrackTarget(self);
		bRegistered = TRUE;
	}
	else
	{
		SetTimer(0.1, false, nameof(RegisterSelf));
	}
	super.PostBeginPlay();
}

simulated function Destroyed()
{
	local int i;

	// Go through list of pawn looking at us, and tell them to stop.
	for(i=PawnsLookingAtMe.Length; i>=0; i--)
	{
		PawnsLookingAtMe[i].StopHeadTrackTarget();
	}

	// Remove us from GRI list.
	if( WorldInfo.GRI != None )
	{
		GearGRI(WorldInfo.GRI).UnRegisterHeadTrackTarget(Self);
	}

	// Clear those arrays
	LookedAtPawnList.Length = 0;
	PawnsLookingAtMe.Length = 0;

	Super.Destroyed();
}

/** Handle kismet Toggle action */
simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if( Action.InputLinks[0].bHasImpulse )
	{
		bEnabled = TRUE;
	}
	// Turn OFF
	else if( Action.InputLinks[1].bHasImpulse )
	{
		bEnabled = FALSE;
	}
	// Toggle
	else if( Action.InputLinks[2].bHasImpulse )
	{
		bEnabled = !bEnabled;
	}
}

simulated function SetRadius(float NewRadius)
{
	Radius = NewRadius;
	SphereRenderComponent.SphereRadius = NewRadius;
}

/** Returns true if TestLoc is inside the repulsor, false otherwise. */
simulated function bool Encompasses(vector TestLoc)
{
	local float DistSq;
	DistSq = VSizeSq(TestLoc - Location);
	return (DistSq < (Radius*Radius));
}

simulated function RegisterSelf()
{
	if (!bRegistered)
	{
		if (WorldInfo.GRI != None)
		{
			GearGRI(WorldInfo.GRI).RegisterHeadTrackTarget(self);
			bRegistered = TRUE;
		}
		else
		{
			SetTimer(0.1, false, nameof(RegisterSelf));
		}
	}
}

/** Called via timer. */
simulated protected final function DisableSelf()
{
	bEnabled = FALSE;
}

/** Returns true if this HeadTrackTarget can be used by the passed in pawn 
 *  @param  LookAtPawn      What Pawn to see if we can affect
 *  @param  bInitialLook    If true, we're checking to see if this is good for an initial look. If false this is a continued check
 *  @param  out_Score       Heuristic score for this head track target
 */
simulated protected native final function bool CanAffectPawn(GearPawn LookAtPawn, bool bInitialLook, out float out_Score);

defaultproperties
{
	bEnabled=TRUE
	Radius=512
	LookAtTime=(X=2,Y=3)
	DelayBetweenLookAtSamePawn=10.f
	DelayBeforeNextTarget=5.0f
	MaxPawnsLookingAtTheSameTime=0
	MaxLookAtCountBeforeDisable=1
	PawnFilter=HT_PlayerTeamOnly

	RemoteRole=ROLE_SimulatedProxy

	bMovable=TRUE
	bNoDelete=TRUE

	Begin Object Class=DrawSphereComponent Name=DrawSphere0
		SphereColor=(R=200,G=70,B=255,A=255)
		SphereRadius=512.f
		bDrawOnlyIfSelected=TRUE
	//	HiddenGame=FALSE
	End Object
	SphereRenderComponent=DrawSphere0
	Components.Add(DrawSphere0)

	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.S_Actor'
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
}


