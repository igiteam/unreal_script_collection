/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class InterpActor_COGRatTruckBase extends InterpActor_GearBasePlatform
	native
	notplaceable;

/** The truck is a skelmesh. */
var() protected transient SkeletalMeshComponent				TruckMesh;

/** TRUE to suppress all audio for this derrick.  Useful for derricks in the distance. */
var() protected const bool		bNoAudio;

var transient bool				bPlayerAudioIsPlaying;
var transient bool				bNonPlayerAudioIsPlaying;

/** True if the derrick's engine is running. */
var() repnotify protected bool			bEngineRunning;

/** Not actual RPM, but an abstract concept of engine "effort" above the idle baseline, used to control engine audio.  Normalized to be [0..1]. */
var() protected transient float	EngineRPM;

var protected transient float	LastEngineRPM;
var() protected const float		EngineRPMInterpSpeed;

var() protected const vector2d	EngineRPMAccelRange;
var() protected const vector2d	EngineRPMVelRange;

var protected transient vector	LastActualVelocity;

//
// Wheels
//

struct native RatTruckWheel
{
	var() float				WheelRadius;
	var() Name				BoneName;
	var() Name				WheelSkelControlName;
	var SkelControlWheel	WheelControl;

	var matrix				WheelRefPoseTM;

	/** Controls how fast a free-spinning wheel will decelerate. */
	var() float				FreeSpinningFrictionDecel;

	/** Contact information */
	var bool				bHasContact;
	var	bool				bHadContact;
	var vector				LastContactPos;

	/** How fast the wheel is rolling, in deg/sec. */
	var float				RollVel;

	var() float				WheelRoll;

	/** Local space offset from the wheelbone, defines the position from which to derive the raycast endpoints */
	var() vector			WheelRayBaseOffset;

	/** How long since this wheel did a trace */
	var int					FramesSinceLastTrace;

	/** How much to move wheel each frame to achieve desired displacement */
	var float				WheelDispPerFrameAdjust;

	var() bool				bCanSteer;
};
var() array<RatTruckWheel>	Wheels;

/** How many frames between doing traces against the world for each wheel */
var()	int					WheelTraceInterval;

/** Internal.  True to skip any interpolation in the steering/wheel code.  Useful for coming back from a delay in updates. */
var protected transient bool bResetInterpolation;

var() protected const float MaxSteeringAngleDeg;
var protected transient float LastSteeringAngle;
var() protected const float SteeringAngleInterpSpeed;


//
// AUDIO
//

/** Plays only on derricks ridden by a player.  Nonspatialized stereo loops. */
var AudioComponent					PlayerEngineMainLoop;
var() protected transient SoundCue	PlayerEngineMainLoopCue;


cpptext
{
protected:
	void UpdateWheels(FLOAT DeltaTime);
public:
	virtual void TickSpecial(FLOAT DeltaTime);
};


simulated function PostBeginPlay()
{
	local int Idx;

	super.PostBeginPlay();

	CacheWheelRefPoseTMs();

	for (Idx=0; Idx<Wheels.length; ++Idx)
	{
		Wheels[Idx].WheelControl = SkelControlWheel(TruckMesh.FindSkelControl(Wheels[Idx].WheelSkelControlName));
		Wheels[Idx].FramesSinceLastTrace = Rand(WheelTraceInterval-1);
	}

	// oddly, it seems as if the staticmeshcomponent can lose it's DLE when it is placed
	// and then moved to a different sublevel.  This makes sure it is set properly.
	if (StaticMeshComponent != None)
	{
		StaticMeshComponent.SetLightEnvironment(LightEnvironment);
	}

	// so we have just attached a bunch of stuff we need to recheck this and call it again.   Super.PostBeginPlay() could be moved lower
	// but don't want to break anything
	if (bShouldShadowParentAllAttachedActors)
	{
		SetShadowParentOnAllAttachedComponents();
	}

	// turn on flappies
	TruckMesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, TruckMesh);


}

simulated native final function CacheWheelRefPoseTMs();

/** Internal.  Sets up an audiocomponent. */
simulated protected function AudioComponent CreateNonSpatializedComponent(SoundCue Cue, Pawn P)
{
	local AudioComponent AC;

	AC = P.CreateAudioComponent(Cue, FALSE, TRUE);
	if (AC != None)
	{
		AC.bUseOwnerLocation = TRUE;
		AC.bAllowSpatialization = FALSE;
		AC.bAutoDestroy = FALSE;
		AC.bShouldRemainActiveIfDropped = TRUE;
		AC.Play();
	}

	return AC;
}



/** Set up audio to be player, nonplayer, or neither.  Should be rarely called. */
simulated protected event SetupAudio(bool bDoingPlayerAudio, bool bDoingNonPlayerAudio, Pawn LocallyControlledPawn)
{
	if (bDoingPlayerAudio)
	{
		// make sure the stereo loops exist and are playing
		if (PlayerEngineMainLoop == None)
		{
			PlayerEngineMainLoop = CreateNonSpatializedComponent(PlayerEngineMainLoopCue, LocallyControlledPawn);
		}
		if (PlayerEngineMainLoop != None)
		{
			PlayerEngineMainLoop.Play();
		}
	}
	else
	{
		if (PlayerEngineMainLoop != None)
		{
			PlayerEngineMainLoop.Stop();
		}
	}

	bPlayerAudioIsPlaying = bDoingPlayerAudio;
	bNonPlayerAudioIsPlaying = bDoingNonPlayerAudio;
}


/** Overridden to hide the wheels, too. */
simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
	Super.OnToggleHidden(Action);

	if (bHidden)
	{
		SetupAudio(FALSE, FALSE, None);
	}
	else
	{
		// make sure our audio will automatically restart in tick()
		bPlayerAudioIsPlaying = FALSE;
		bNonPlayerAudioIsPlaying = FALSE;
	}
}



defaultproperties
{
	BlockRigidBody=TRUE

	CollisionType=COLLIDE_BlockAll

	bEngineRunning=TRUE

	Begin Object Name=MyLightEnvironment
		bEnabled=TRUE
	End Object

	// this obj is designed solely to provide collision for rigid bodies
// 	Begin Object Class=StaticMeshComponent Name=RBCollision0
// 	End Object
// 	Components.Add(RBCollision0)

	EngineRPMInterpSpeed=0.35f

	EngineRPMAccelRange=(X=30,Y=2500)
	EngineRPMVelRange=(X=100,Y=1400)

//	bTickIsDisabled=TRUE

	bAlwaysConfineToClampedBase=TRUE

	// wheels
	Wheels(0)={(
		BoneName=R_Front_Tire,WheelSkelControlName=R_Front_Tire,
		WheelRadius=42.f,
		FreeSpinningFrictionDecel=50.f,
		bCanSteer=true
		)}
	Wheels(1)={(
		BoneName=L_Front_Tire,WheelSkelControlName=L_Front_Tire,
		WheelRadius=42.f,
		FreeSpinningFrictionDecel=50.f,
		bCanSteer=true
		)}
	Wheels(2)={(
		BoneName=R_Back_Tire,WheelSkelControlName=R_Back_Tire,
		WheelRadius=42.f,
		FreeSpinningFrictionDecel=50.f,
		)}
	Wheels(3)={(
		BoneName=L_Back_Tire,WheelSkelControlName=L_Back_Tire,
		WheelRadius=42.f,
		FreeSpinningFrictionDecel=50.f,
		)}

	WheelTraceInterval=10
	MaxSteeringAngleDeg=45 // radians
	SteeringAngleInterpSpeed=9.f
}
