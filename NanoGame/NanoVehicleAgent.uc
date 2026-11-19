/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoVehicleAgent extends GameCrowdAgent
	implements( NanoInterface_Targetable, NanoInterface_StabMantle, NanoInterface_Attraction, NanoInterface_CanAffectChaos, NanoInterface_BoulderedInto, NanoInterface_Grapple, Interface_NavMeshPathObstacle, Interface_NavMeshPathObject)
	native(Vehicle)
	config(Game);

var transient NanoVehiclePopulationManager MyManager;

/** If TRUE, the vehicle will instantly accelerate to its desired speed, and then resume operation as normal */
var transient bool bAccelToDesiredThisTick;

var() MeshComponent	VehicleMeshComponent;

enum ENanoVehicleTypes
{
	ENVT_Ground,
	ENVT_Flying,
	ENVT_Both
};
var() ENanoVehicleTypes VehicleType;

var transient MaterialInstanceConstant VehicleMatInst;

/** If true, this follows the normal path finding down splines.  If false, the elevator is traveling down the splines in reverse **/
var transient bool	bFollowingPathForward;

var transient NanoVehicleSpline CurrentSpline;
const NUM_TARGET_SPLINE = 6;
var transient NanoVehicleSpline TargetSpline;
var transient float                       CurrentSplinePos;
/** Current Lane that the vehicle is in */
var transient int               CurrentSplineLane;
/** Lane the vehicle is currently trying to merge to.  INDEX_NONE means no desired lane  */
var transient int               DesiredSplineLane;

/** Last time we tried to change lanes */
var transient float             LastLaneChangeTime;

/** When in rigid body and controlled by a player, this stores the spline that the car should attempt to return to */
var transient NanoVehicleSpline AirControl_BestSpline;

/** If the vehicle is player controlled, this is the offset from the spline to use, since they are not bound by lanes */
var transient vector             ControlledVehicleSplineOffset;

/** Array that stores a cached route to another point in the path network */
var transient array<SplineActor>  CachedRoute;

/** If TRUE, show the CachedRoute of this vehicle */
var() bool              bDebugDrawCachedRoute;

/** Vector to offset the vehicle in the plane of the vehicle spline */
var transient vector              SplineOffsetVector;
/** Desired vector to offset the vehicle in addition to the spline offset (in worldspace) */
var transient Vector				DesiredWorldOffsetVector;
/** Current world offset being applied */
var transient Vector				WorldOffsetVector;
/** Interp speed to interp toward desired world offset vector */
var transient float				WorldOffsetInterpSpeed;

// --- Wobble parameters, only applied to flying cars ---
/** Rate at which the wobble offset will rotate around, offsetting the car */
var() float                     WobbleRollRate;
/** Rate at which the wobble offset magnitude will blend to it's new value */
var() float                     WobbleOffsetRate;
/** Maximum magnitude of the wobble offset vector */
var() float                     MaxWobbleOffset;
/** Damping for offsetting the vehicle's roll by the rotation of the wobble vector.  Increase for more angular wobble */
var() float                     WobbleRollDamping;
/** Transients used for blending and updating the wobble */
var transient float             CurrentWobbleOffset;
var transient float             DesiredWobbleOffset;
var transient int               CurrentWobbleRoll;

var() float             CarAcceleration;
var() float             CarBraking;
var() float             CarRotationSpeed;

/** Lateral acceleration when the car is hacked by a player */
var() float             CarLateralAcceleration;

/** This allows us a Max Speed for the car that is car specific (e.g. fast sporty cars > slow older cars) **/
var() float             MaxCarSpeed;
/** This allows us a max speed for lateral movement of the car when hacked by a player */
var() float             MaxCarLateralSpeed;

/** This is how much faster than the Spline's SuggestedSpeed. This will not go faster than the max speed of the car tho **/
var() float             SplineSuggestedSpeedModifier;

var() float             CarBankFactor;
var() float             CarBankMax;

/** Damping factor to apply to player controlled car's lateral velocity to make banking reasonable */
var() float             CarLateralSpeedBankDamping;

var transient float               CarSpeed;
var transient float               CarDesiredSpeed;

/** These vars handle player control of the car's lateral movement, not automated control */
var transient float               CarLateralSpeed;
var transient float               CarDesiredLateralSpeed;

var array<float>        YawSpeedFilter;
var int                 NextYawSpeedFilterSlot;
var() int               YawSpeedFilterSize;

var() float             MinDistanceBetweenVehicles;
var() float             MinDistanceAwayFromPawns;
/** Current distance ahead of the car to check for passing, computed as the road distance covered in the time it takes to change lanes */
var transient float     CurrentPassingDistance;

/** How long it actually takes to change lanes.  For now, this is a set time, since the distances between lanes don't vary that much */
var() float             LaneChangeDuration;

/** How long to wait between considering changing lanes when stuck behind a slow moving vehicle */
var() float             LaneChangeConsiderationInterval;
var   transient float   LastLaneChangeConsiderationTime;

var() Vector            StabAttachPos;

/** Scaling factor for stab mantle checks...1.0 uses standard distance, above 1 increases distance you can stab mantle the car from, below 1 decreases it */
var() float StabTargetDistanceScale;

/** The mass of this vehicle, used for collisions.  If 0, the mass will be automatically calculated as the LxWxH of the static mesh */
var() float             VehicleMass;

/** Maximum velocity that this car can be launched at from a collision */
var() float             MaxCollisionVelocity;
/** Damping factor for velocity transfer from collisions.  < 1.f will tone down collision velocities */
var() float             CollisionTransferDamping;

/** Has there been a recent collision that popped the vehicle off the track? */
var transient bool      bRecentCollision;

/** Camera shake to play when colliding with another car */
var() NanoCameraShake   CollisionCamShake;

/** Half of the width of the vehicle, determined in PBP() by the mesh */
var transient float     HalfWidth;
/** Half of the length of the vehicle, determined in PBP() by the mesh */
var transient float     HalfLength;
/** Half of the height of the vehicle, determined in PBP() by the mesh */
var transient float     FullHeight;

/** NanoPawn that is current riding this vehicle */
var transient NanoPawn            RidingPawn;

/** Offset from the origin that the player should attach to when riding the vehicle perched **/
var()   vector          PerchLocationOffset;
var()   rotator         PerchRotationOffset;

/** Time the last perching pawn left the car */
var transient float     LastPercherLeaveTime;

/** Distance within which to attract the player if flying */
var()   float           AttractDistance;

enum ENanoTurnDirection
{
	ENTD_Random,
	ENTD_Straight,
	ENTD_Left,
	ENTD_Right,
	ENTD_Up,
	ENTD_Down
};

var transient ENanoTurnDirection  CurrentTurnDecision;

var()   ParticleSystem  DamageEffect;
var transient ParticleSystemComponent PSC_DamageEffect;
var()   int             DamageEffectThresh;

var()   ParticleSystem  DeathEffect;
var transient ParticleSystemComponent PSC_DeathEffect;
var() SoundCue DeathExplosionSound;


var() SoundCue StoppedByPawnHornHonkSound;

/** This is the current Chaos Zone this is in **/
var transient NanoVolume_ChaosZone CurrChaosZone;

/** This is the sound to play when a number of cars crash to the ground.  We need to change this up to be N to soundcue  where N is a number of cars crashing to the ground and then the soundcue has the premade layered sound **/
var protected SoundCue CrashToTheGroundCue;

/** This sound is played when the player finishes a mantle up onto the car - thunk */
var protected SoundCue PlayerLandedCue;

/** This is the sound to play when the vehicle is platform jumped on to */
var protected SoundCue PlatformJumpingLandCue;

/** The array for the Engine Sound **/
var protected array<SoundCue> EngineSoundCues;
var transient protected AudioComponent AC_EngineSound;

/** Sound to play when the vehicle is plummeting out of control */
var protected SoundCue  VehicleOutOfControlCue;

/** If the player is pressing forward or pulling backward on the thumstick we will modify the speed by these amounts **/
var config float ThumbstickFowardSpeedModifier;
var config float ThumbstickBackwardSpeedModifier;


var SoundCue PlayerAccelerating;
var transient bool bPlayedAcclerationSound;
var SoundCue PlayerDecelerating;
var transient bool bPlayedDecelerationSound;

var SoundCue PlayerStartup;
var SoundCue PlayerRiding;
var transient protected AudioComponent AC_PlayerRiding;
var name AirCarEnginePitchName;
var transient float AirCarEnginePitchCurr;
var transient float AirCarEnginePitchGoal;

var SoundCue PlayerStoppingEngine;

/** True when the player is overriding the vehicle **/
var transient protected bool    bIsOverriding;

/** Modifier for the consumption rate of nano power when overriding this vehicle */
var() float OverrideNanoRateModifier;

var transient bool bFirstOverride;
var SoundCue PlayerRidingOverride;
var transient protected AudioComponent AC_PlayerRidingOverride;

/** **/
var SoundCue PlayerOverridingControl;
var SoundCue AltitudeDeviationWarning;
var transient bool bLimitMaxUpwardsVelocityDueToPlayerOverridingControl;
var float MaxPhysicsVelocityWhenPlayerOverridingControl;

var transient float CurrAirCarEngineOverridePitch;


var SoundCue PlayerOverridingControl_CarLostControl;
var SoundCue CarLostControlEngineSound;
var transient protected AudioComponent AC_CarLostControlEngineSound;
var transient vector LocationWhenPlayerOverodeControl;
var SoundCue MaxAltitudeWarning;
var float MaxAltitudeChangeAllowWhenOverriden;

/** Whether or not his car has been disabled by traffic control **/
var transient bool bCarDisabledByTrafficControl;

/** Played if you speed for too long. **/
var SoundCue SpeedingWarning;

/** Played when the player slams into an other car. **/
var SoundCue CollisionDetectedWarning;

/** Tick that might be attached to this car **/
var transient NanoPickup_Tick AttachedTick;


/** Enable 'Stay upright' torque, that tries to keep Z axis of KActor pointing along world Z */
var(StayUprightSpring)	bool		bEnableStayUprightSpring;

/** Torque applied to try and keep KActor horizontal. */
var(StayUprightSpring)	float		StayUprightTorqueFactor;

/** Max torque that can be applied to try and keep KActor horizontal */
var(StayUprightSpring)	float		StayUprightMaxTorque;

/** Offset from pure z-up that simulation will try to keep the z-axis pointing towards */
var(StayUprightSpring)  Rotator     StayUprightZOffset;


/** If we were using a blinker.  This is used so we are not constantly setting a material parameter (which ends up being expensive when there are LOTS of cars **/
var transient bool bWasUsingBlinker;

/** Degrees of freedom for the pitch of the car that the camera will be locked into when the player is above the car looking down **/
var() int     CameraDownPitchDegreesOfFreedom;
/** Degrees of freedom for the pitch of the car that the camera will be locked into when the player is below the car looking up **/
var() int     CameraUpPitchDegreesOfFreedom;
/** Default offset for the camera while the pawn is riding the vehicle **/
var() Vector    CameraRidingOffset;
/** Multiplier on the camera distance when the player is overriding the car (flying into the air) **/
var() float     CameraOverridingDistanceMultiplier;

/** Desired FOV multiplier when the pawn is slowing down */
var() float     PawnSlowingFOVModifier;
/** Desired FOV multiplier when the pawn is speeding up */
var() float     PawnSpeedingFOVModifier;

/** Camera shake to play when the pawn is riding a dead vehicle */
var() NanoCameraShake   DeadVehicleCameraShake;

// --- Air Control Params - Govern behavior when pawn pulls a car off the tracks ---
/** Percentage of MaxCarSpeed to use as full forward thrust when car is in the air */
var(AirControl) float   Air_ThrustPercentage;
/** Turn rate (yaw) when car is in the air in deg/sec*/
var(AirControl) float   Air_TurnRate;
/** Yaw damping when car is in the air */
var(AirControl) float   Air_TurnDamping;

/** Controls scaling from the desired yaw turn into torque */
var(AirControl) float   Air_TurnTorqueFactor;
/** Maximum torque allowed for turn yaw */
var(AirControl) float   Air_TurnTorqueMax;

/** Controls scaling from the desired pitch into torque */
var(AirControl) float   Air_PitchTorqueFactor;
/** Maximum torque allowed for pitching */
var(AirControl) float   Air_PitchTorqueMax;
/** Damping to apply to pitching torque at the end */
var(AirControl) float   Air_PitchDamping;

/** Scaling for roll due to turning of the vehicle */
var(AirControl) float   Air_RollTorqueTurnFactor;
/** Scaling for roll due to player turning input */
var(AirControl) float   Air_RollTorqueStrafeFactor;
/** Maximum torque allowed for rolling */
var(AirControl) float   Air_RollTorqueMax;
/** Damping to apply to rolling torque at the end */
var(AirControl) float   Air_RollDamping;

/** Momentum to throw the car upwards with when overdriving */
var(AirControl) float   OverrideUpwardMomentum;

/** Momentum to pull the car down with when overdrive charging */
var(AirControl) float   OverrideDownwardMomentum;


/** Rate at which the car will be attracted back into the spline when landing */
var(AirControl) float   Air_LandingAttraction;

// --- Car Death Params ---
/** Records the time the pawn landed on and destroyed this car */
var transient   float   CarDestroyedByPawnTime;

/** How much to scale gravity up and down when doing a "pillow" attach */
var()           float   PillowGravityAmplitudeScale;

/** At this velocity, the pawn will max out the duration of the pillowing */
var()           float   PillowMaxAttachVelocity;

/** Maximum length of time that the player will ride the vehicle in pillow physics */
var()           float   PillowMaxDuration;
/** Pillow duration, scaled by the pawn's velocity */
var transient   float   PillowDuration;

/** Gravity scale factor for after the vehicle pillows */
var()           float   PillowPostGravityScale;

/** How far, in rotators, to rock the car when it is dead with a pawn riding */
var()           int     DeadWobbleExtent;
/** Period of the above wobble */
var()           float   DeadWobbleDuration;

// --- Pawn Launching Params:  For when pawn is on a dead vehicle and it hits geometry ---
/** Velocity required to detach the car from the road when landing on it */
var() float             CarDetachLandingVelocity;

/** Speed at which to launch the vehicle forward from the player when they are ejected */
var() float             EjectionCollisionVelocity;
/** Speed at which to launch the vehicle up when the player is ejected */
var() float             EjectionCollisionVerticalVelocity;
/** How much random torque to add to the vehicle when the pawn is ejected */
var() float             EjectionCollisionTorque;
/** How much yaw torque to add to the vehicle when the pawn is ejected (for slide-out spins) */
var() float             EjectionCollisionYawTorque;
/** How long after the vehicle has impacted before the vehicle will no longer try to stay upright */
var() float             EjectionCollisionStayUprightDuration;


/** Played when the car has a geometry collision and launches the player off **/
var() ParticleSystem    DeadVehicleExplosion;

/** Minimum velocity to launch the pawn off the vehicle with when ejected */
var() float             MinPawnLaunchVelocity;
/** Maximum velocity to launch the pawn off the vehicle with when ejected */
var() float             MaxPawnLaunchVelocity;

// --- Dense bashing parameters ---
/** How fast this object moves after collision. 1.0 is same speed as player, >1.0 will move it faster than player */
var()	float	DenseShoveResultSpeed;
/** How far a target must be to have car try and hit them */
var()	float	MaxBoulderTargetDist;
/** How high the arc will go when flying at target (fraction of 2d distance) */
var()	float	BoulderLaunchHeightFactor;
/** Avoid getting multiple impulses  */
var		float	MinTimeBetweenBoulderImpulse;
/** Last time we added an impulse to this from bouldering */
var		transient float	LastBoulderImpulseTime;

// --- Grapple parameters ---
/** If true, this car can be grappled */
var()   bool    bCanGrapple;

/** Interact action icon */
var() ActionInfo InteractAction;


/** Whether or not this crowd should spawn an AI when it is shot. **/
var(AI) bool bShouldSpawnAnAIWhenShot;

/** This is the class that should be spawned when this crowd agent is shot. **/
var(AI) class<NanoPawnBase> ClassToSpawnWhenShot;
var private transient bool bSpawnedAnAI;

/** When the AI turned into an AI, it will say this line **/
var() SoundCue SoundToPlayWhenTransformingToAI;

/** 
 * When an enemy is first seen (or after some time of not being seen) we play this effect to show off iris "alerting" you.
 * eventually will have "threat" detection and such.  like terminators do!
 **/
var ParticleSystem PS_IRIS_FirstEncounter;
var transient ParticleSystemComponent PSC_IRIS_FirstEncounter;
var transient float TimeSpawnedFirstEncounterEffect;
var float DurationBeforeSpawningFirstEncounterEffects;
var name IRIS_FirstEncounterBoneName;



cpptext
{
	virtual void performPhysics(FLOAT DeltaTime);
	virtual void setPhysics(BYTE NewPhysics, AActor *NewFloor, FVector NewFloorV);
	virtual void physRigidBody(FLOAT DeltaTime);

	virtual void TickSpecial( FLOAT DeltaSeconds );

	/** Helper function to determine the best candidate spline for rejoining the road */
	virtual void DetermineBestSplinesForLanding();
	/** Determines if we are close enough to attempt to land on splines, and if so, begin sucking us into location */
	virtual void AttemptToLandOnRoad();
	/** Perform driver control on the car when it is in PHYS_RigidBody */
	virtual void PerformAirControl(FLOAT DeltaTime);

	virtual UBOOL CanCauseFractureOnTouch()
	{
		return TRUE;
	}


	//// START Interface_NavMeshPathObstacle

	/**
	 * Make a hole in the NavMesh so AI paths around the Siegebeast
	 * 
	 * @param out_PolyShape - output array which holds the vertex buffer for this obstacle's bounding polyshape
	 * 
	 * @return TRUE if this object should block things right now (FALSE means this obstacle shouldn't affect the mesh)
	 */
	virtual UBOOL GetBoundingShape(TArray<FVector>& out_PolyShape);

	/**
	 * We want polys inside of our obstacle registration.  This allows for the mechs to smash into them as they
	 * don't "appear" to be there.  We then use the edges this obstacle creates to tell Other Non-Mechs that they can't path through
	 * 
	 * @return FALSE to get rid of the polys
	 */
	virtual UBOOL PreserveInternalPolys() { return TRUE; }

	virtual void BeginDestroy()
	{
		Super::BeginDestroy();
		UnRegisterObstacle();
	}

	/**
	 * For debugging.  Verifies that this pathobject is still alive and well and not orphaned or deleted
	 * @return - TRUE If this path object is in good working order
	 */
	virtual UBOOL VerifyObstacle()
	{
		return !IsPendingKill();
	}

	//// END Interface_NavMeshPathObstacle


	//// START Interface_NavMeshPathObject

	/**
	 * This function is called when an edge is going to be added connecting a polygon internal to this obstacle to another polygon which is not
	 * Default behavior just a normal edge, override to add special costs or behavior (e.g. link a pathobject to the obstacle)
	 * @param Status - current status of edges (e.g. what still needs adding)	 
	 * @param inV1 - vertex location of first vert in the edge
	 * @param inV2 - vertex location of second vert in the edge
	 * @param ConnectedPolys - the polys this edge links
	 * @param bEdgesNeedToBeDynamic - whether or not added edges need to be dynamic (e.g. we're adding edges between meshes)
	 * @param PolyAssocatedWithThisPO - the index into the connected polys array parmaeter which tells us which poly from that array is associated with this path object
	 * @(optional) param SupportedEdgeWidth - width of unit that this edge supports, defaults to -1.0f meaning the length of the edge itself will be used
	 * @(optional) param EdgeGroupID - ID of the edgegroup this edge is a part of (defaults to no group)
	 * @return returns an enum describing what just happened (what actions did we take) - used to determien what accompanying actions need to be taken 
	 *         by other obstacles and calling code
	 */
	virtual EEdgeHandlingStatus AddObstacleEdge( EEdgeHandlingStatus Status, const FVector& inV1, const FVector& inV2, TArray<FNavMeshPolyBase*>& ConnectedPolys, UBOOL bEdgesNeedToBeDynamic, INT PolyAssocatedWithThisPO, FLOAT SupportedEdgeWidth=-1.0f, BYTE EdgeGroupID=MAXBYTE);


	/**
	 * passthru function from edge to determine if the passed searcher supports this pathobject's movement
	 * @param Interface - the interface of the searcher
	 * @param CurPoly   - the poly being checked for support
	 * @param Edge      - the edge linked to this path object which is being considered
	 * @return TRUE if this path object supports the searcher
	 */
	virtual UBOOL Supports( const FNavMeshPathParams& PathParams,
							FNavMeshPolyBase* CurPoly,
							FNavMeshPathObjectEdge* Edge );


	//// END Interface_NavMeshPathObject



}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	NanoGRI(WorldInfo.GRI).RegisterTargetableActor(self);
	NanoGRI(WorldInfo.GRI).RegisterGrappleActor(self);

	YawSpeedFilter.Length = 0;
	YawSpeedFilter.Length = YawSpeedFilterSize;

	// Pick a random starting point for the wobble, so that all cars aren't in synch
	CurrentWobbleRoll = Rand(65536);
		
	// create mat inst
	CreateMaterialInstances();

	AC_EngineSound = new(self) class'AudioComponent';
	if( AC_EngineSound != None )
	{
		AC_EngineSound.SoundCue = ChooseRandomEngineSound();
		AttachComponent( AC_EngineSound );
		AC_EngineSound.FadeIn( 0.100f, 1.0f );
	}

	//PossiblySpawnATick();

	// Determine the half width / lengths of the vehicle, to be used by collision checking
	SetVehicleDimensions();

	NanoGRI(WorldInfo.GRI).ActorsToAvoid.AddItem(self);
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( bShouldSpawnAnAIWhenShot == TRUE )
	{
		PossiblySpawnIRIS_FirstEncounterEffect();
	}
}

simulated function PossiblySpawnIRIS_FirstEncounterEffect()
{
	if( bShouldSpawnAnAIWhenShot == FALSE )
	{
		return;
	}

	if( ( `TimeSince(LastRenderTime) < 0.200f )
		&& ( TimeSpawnedFirstEncounterEffect == 0.0f ) // for now
		//&& ( `TimeSince(TimeSpawnedFirstEncounterEffect) > DurationBeforeSpawningFirstEncounterEffects )
		)
	{
		SpawnIRIS_FirstEncounterEffect();
	}
}

simulated protected function SpawnIRIS_FirstEncounterEffect()
{
	PSC_IRIS_FirstEncounter = WorldInfo.MyEmitterPool.SpawnEmitter( PS_IRIS_FirstEncounter, Location+vect(0,0,96),, self );
	PSC_IRIS_FirstEncounter.SetDepthPriorityGroup( SDPG_Foreground );
	TimeSpawnedFirstEncounterEffect = WorldInfo.TimeSeconds;
}


simulated native function vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc) const;


/** Optimization function that throttles the tick rate of the vehicle based on its visibility and distance, returns TRUE if we can do a cheap physics update this frame */
native function bool ThrottleTickRate();

/** Native function to grab the dimensions of the car from the static mesh, since StaticMesh bounds aren't accessible in script.  Also calculates VehicleMass if none is specified */
native function SetVehicleDimensions();

simulated event FillOutTargetSplines()
{
	local NanoVehicleSpline NVS;
	local int i;
	local NanoVehicleSpline Curr;
	local NanoVehicleSpline Target;

	//`log( self @ "FillOutTargetSplines" );
	CachedRoute.Remove( 0, CachedRoute.Length );
	if( CurrentSpline != none )
	{
		// fill in the CachedRoute
		NVS = NanoVehicleSpline(CurrentSpline.GetRandomConnection(!bFollowingPathForward));

		if( NVS != none )
		{
			CachedRoute.AddItem( NVS );
		}
		// if the spline is null we didn't find a connection
		else
		{
			return;
		}

		//`log( "    Curr:" @ NanoVehicleSpline(CurrentSpline.GetRandomConnection()) );
		for( i = 1; i < NUM_TARGET_SPLINE; ++i )
		{
			//this is all fucked up it seems
			// get the previous spline and then choose a random connection from it
			Curr = NanoVehicleSpline(CachedRoute[i-1]);
			if( Curr != none )
			{
				Target = NanoVehicleSpline(Curr.GetRandomConnection(!bFollowingPathForward));
				//`log( "    Connections: " @ Curr @ Target @ Curr.FindSplineComponentTo( Target ) );
			}
			// we didn't find a connection
			else
			{
				break;
			}

			if( Target != none )
			{
				//`log( self @ Curr @ "adding target:" @ Target @ Curr.IsConnectedTo(Target) );
				CachedRoute.AddItem( Target );
			}
			else
			{
				break;
			}

			Target = none;
		}
		//`log( "TargetSplines.Length" @ TargetSplines.Length );
		//ScriptTrace();
	}
	else
	{
		`log( self @ " no CurrentSpline " );
	}


	TargetSpline = NanoVehicleSpline(ChooseNextSpline());
	//`log( self @ TargetSpline );
}


simulated event Destroyed()
{
	super.Destroyed();

	NanoGRI(WorldInfo.GRI).ActorsToAvoid.RemoveItem(self);

	RemoveParticleEffects();

	if( AC_EngineSound != none )
	{
		AC_EngineSound.FadeOut( 0.250f, 0.0f );
	}

	if( AC_PlayerRidingOverride != None )
	{
		AC_PlayerRidingOverride.FadeOut( 0.250f, 0.0f );
	}

	if( AttachedTick != none )
	{
		AttachedTick.Destroy();
	}

	if( MyManager != None )
	{
		MyManager.AgentDestroyed(self);
	}
}

event KillAgent()
{
	RemoveParticleEffects();

	if( bIsInSpawnPool )
	{
		return;
	}

	if ( (MyManager != None) && MyManager.AddToAgentPool(self) )
	{
		bIsInSpawnPool = TRUE;
		// added to pool, so turn agent off
		SetHidden(true);
		Health = -1; // to prevent ticking
		TimeSinceLastTick = -1000.0;
		ClearAllTimers();
		CarSpeed = 0.0;
		LifeSpan = 0.0;

		SetCollision(FALSE, FALSE, FALSE);

		if( CurrentSpline != None )
		{
			// Remove vehicle from spline, such that we don't interfere with traffic
			CurrentSpline.RemoveVehicleFromSpline(self);
		}
	}
	else
	{
		LifeSpan = -0.1;

		// make sure to tick right away to destroy
		TimeSinceLastTick = 1000.0;
	}
}

function ResetPooledAgent()
{
	bIsInSpawnPool = false;
	SetHidden(false);

	RemoveParticleEffects();

	SetPhysics(PHYS_Interpolating);
 	
	TargetSpline = None;
	if( CurrentSpline != None )
	{
		CurrentSpline.RemoveVehicleFromSpline(self);
	}

	bAccelToDesiredThisTick = TRUE;

	CurrentSplinePos = 0.f;
	DesiredSplineLane = INDEX_NONE;

 	LifeSpan = 0.0;
 	Health = default.Health;
 	TimeSinceLastTick = 0.0;
 	LastKnownGoodPosition = Location;
 	ForceUpdateTime = WorldInfo.TimeSeconds;
}

function RemoveParticleEffects()
{
	if( PSC_DeathEffect != none )
	{
		PSC_DeathEffect.DeactivateSystem();
	}

	if( PSC_DamageEffect != none )
	{
		PSC_DamageEffect.DeactivateSystem();
	}
}


function PossiblySpawnATick()
{
	local NanoGRI NGRI;

	NGRI = NanoGRI(WorldInfo.GRI);

	if( ( NGRI.CurrTicksOnCars < NGRI.TotalTicksAllowedOnCars ) && ( FRand() < 0.10f ) ) 
	{
		AttachedTick = Spawn( class'NanoPickup_Tick',,, Location,,, TRUE );

		if( AttachedTick != none )
		{
			AttachedTick.SetHardAttach( TRUE );
			AttachedTick.SetBase( self );
			if( FRand() > 0.50f )
			{
				// on top
				AttachedTick.SetRelativeLocation( vect(128,0,96) );
			}
			else
			{
				// on bottom
				AttachedTick.SetRelativeLocation( vect(128,0,0) );
				AttachedTick.SetRelativeRotation( rot(0,0,-32768) );
			}

			AttachedTick.PSC_Cloak.DeactivateSystem();
			NGRI.TotalTicksAllowedOnCars++;
		}
	}
}


/** return a random engine cue sound **/
simulated function SoundCue ChooseRandomEngineSound()
{
	return EngineSoundCues[ Rand( EngineSoundCues.Length ) ];
}


simulated function CreateMaterialInstances()
{
	local int i;

	// Clear all applied material instances
	for(i=0; i<VehicleMeshComponent.Materials.Length; i++)
	{
		VehicleMeshComponent.SetMaterial(i, none);
	}
		
	// Create new one
	VehicleMatInst = VehicleMeshComponent.CreateAndSetMaterialInstanceConstant(0);
}


/** Stop agent moving and pay death anim */
function PlayDeath(vector KillMomentum)
{

	//`log( "PLAY DEATH!!!" @ self );
	SetPhysics(PHYS_RigidBody);
	
 	if(DeathEffect != none)
 	{
 		PSC_DeathEffect = WorldInfo.MyEmitterPool.SpawnEmitter( DeathEffect, Location, Rotation, self );
 	}

	if( DeathExplosionSound != None )
	{
		PlaySound( DeathExplosionSound );
	}

	//NanoGRI(WorldInfo.GRI).SpawnANanoOrb( class'NanoAbsorbOrb_Car', self, TRUE );
	
	// Fire any kismet events
	FireDeathEvent();
}


function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int PreHealth;
	local NanoGRI NGRI;
	local NanoPC NPC;

	// we are already dead from the previous TakeDamage call so don't take anymore damage / die again
	if( Health <= 0 )
	{
		return;
	}

	if( bShouldSpawnAnAIWhenShot == TRUE )
	{
		//FIXMEMP:  Assumes there is only one player!
		foreach WorldInfo.AllControllers( class'NanoPC', NPC )
		{
			break;
		}

		NanoGRI(WorldInfo.GRI).ModifyChaosLevel( NanoPawn(NPC.Pawn).GetChaosZone(), none, class'NanoCausingChaosValues'.default.CrowdCopAttacked );

		PossiblySpawnAIFromCrowd();
	}

	PreHealth = Health;

	Health -= DamageAmount;

	//`log( `showvar(PreHealth) @ `showvar(DamageAmount) @ `showvar(Health) );

 	if((DamageEffect != None) && (Health < DamageEffectThresh) && (PreHealth >= DamageEffectThresh) )
 	{
 		PSC_DamageEffect = WorldInfo.MyEmitterPool.SpawnEmitter( DamageEffect, Location, Rotation, self );
 	}

	if(Health <= 0)
	{

		//`log( self @ "DEADDDDD" @ Health );
		NanoGRI(WorldInfo.GRI).ModifyChaosLevel( GetChaosZone(), DamageCauser, class'NanoCausingChaosValues'.default.CarDestroyed );
		PlayDeath(Momentum);

		// When the player rides a dead car, hide the roads
		NGRI = NanoGRI(WorldInfo.GRI);
		if( NGRI != None && RidingPawn != None)
		{
			NGRI.NRM.SetRoadMeshVisibility(FALSE);
		}
	}
	
	// Call actor TakeDamage so events are called
	Super(Actor).TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

function PossiblySpawnAIFromCrowd()
{
	if( bSpawnedAnAI == FALSE )
	{
		if( SoundToPlayWhenTransformingToAI != None )
		{
			PlaySound( SoundToPlayWhenTransformingToAI );
		}

		//we will have the class here: ClassToSpawnWhenShot   so we need to parse that

		// tell the NPES to attempt to spawn a trooper here immediately
		NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_PoliceCar', ESM_CrowdMemberTransformation, TRUE, Location+vect(0,0,256), None ); // hard code the name for now

		KillAgent();
		
		bSpawnedAnAI = TRUE;
	}
}




/** Look at NanoPawn and decide which way it wants to turn. */
simulated event ENanoTurnDirection DecidePawnTurnDesire(NanoPawn NP)
{
	local NanoPC NPC;
	local NanoPlayerInput NPI;
	
	NPC = NanoPC(NP.Controller);
	if(NPC != none)
	{
		NPI = NanoPlayerInput(NPC.PlayerInput);
		if( NPI != None )
		{
			if( NPI.IsButtonActive(GB_LeftStick_Right) )
			{
				return ENTD_Right;
			}
			else if( NPI.IsButtonActive(GB_LeftStick_Left) )
			{
				return ENTD_Left;
			}
			else if( NPI.IsButtonActive(GB_LeftStick_Up) )
			{
				return ENTD_Up;
			}
			else if( NPI.IsButtonActive(GB_LeftStick_Down) )
			{
				return ENTD_Down;
			}
		}
	}
	
	return ENTD_Straight;
}


function PlaySpeedWarning()
{
	if( RidingPawn != none )
	{
		RidingPawn.PlaySound( SpeedingWarning );
	}
}

event SetRoadStatus(ENanoRoadStatus NewStatus)
{
	local NanoGRI NGRI;

	NGRI = NanoGRI(WorldInfo.GRI);
	if( NGRI != None )
	{
		NGRI.NRM.SetRoadStatus(NewStatus);
	}
}

/** Fly up into the air alll crazzyyyyyyyy **/
function FlyIntoTheAir( vector KillMomentum )
{
	if( Physics != PHYS_RigidBody )
	{
		SetRoadStatus(ENRS_OffRoad);
	}

	//`log( "FLY THAT CAR UP" @ Velocity );
	SetPhysics( PHYS_RigidBody );

	VehicleMeshComponent.AddForce( KillMomentum );
}

function ResetDipPhysics()
{
	ClearTimer( nameof(ResetDipPhysics) );
	WorldOffsetInterpSpeed   = default.WorldOffsetInterpSpeed;
	DesiredWorldOffsetVector = default.DesiredWorldOffsetVector;
}

/** Helper function so we can modify the vehicle's acceleration easily in subclasses */
native function float GetVehicleAcceleration();

function PerchedOnBy( NanoPawn NP )
{
	SetTickGroup( TG_PreAsyncWork );

	if( IsZero(DesiredWorldOffsetVector) )
	{
		// Do a small dip by changing to RigidBody physics for a moment
		WorldOffsetInterpSpeed = 20.f;
		DesiredWorldOffsetVector = (NP.CurrNanoState == ENS_Dense) ? vect(0,0,-350) : vect(0,0,-150);
		SetTimer( 0.25f, FALSE, nameof(ResetDipPhysics) );
	}
	
	PlaySound( PlayerLandedCue );
}

simulated function GetVehiclePerchOffsets( out vector LocOffset, out rotator RotOffset )
{
	LocOffset = PerchLocationOffset;
	RotOffset = PerchRotationOffset;
}

/** Called when a NanoPawn attaches - to track our rider */
event Attach(Actor Other)
{
	local NanoPawn NP;
	local NanoGRI NGRI;

	NP = NanoPawn(Other);
	if( (NP != none) && NP.bHardAttach )
	{
		// Check if there is already someone riding
		if(RidingPawn != None)
		{
			// TODO: Handle this better - kick of old pawn? Don't allow new attachment?
			`log("NanoVehicleAgent.Attach - Already a RidingPawn!");
		}		
	
		// Stop the pawn from dashing, since they're stuck
		NP.ForceDashStop();

 		RidingPawn = NP;

  		CachedRoute.Remove( 0, CachedRoute.Length );
 
 		// Player is now controlling, car doesn't have a lane!  Set the offset to the current lane offset
 		ControlledVehicleSplineOffset = CurrentSpline != None ? CurrentSpline.LaneOffsets[CurrentSplineLane] : vect(0.f, 0.f, 0.f);
 		CurrentSplineLane = -1;
 
 		SetTickGroup( TG_PreAsyncWork );
 
 		if( CarSpeed == 0.0f )
 		{
 			PlaySound( PlayerStartup );
 		}
 
 		AC_PlayerRiding = new(self) class'AudioComponent';
 		if( AC_PlayerRiding != None )
 		{
 			AC_PlayerRiding.SoundCue = PlayerRiding;
 			AC_PlayerRiding.SetFloatParameter( AirCarEnginePitchName, 1.0f );
 			AttachComponent( AC_PlayerRiding );
 			AC_PlayerRiding.FadeIn( 0.100f, 1.0f );
 		}
 
 		// When the player is riding the car, reveal the roads!
 		NGRI = NanoGRI(WorldInfo.GRI);
 		if( (NGRI != None) && (Health > 0) )
 		{
 			NGRI.NRM.SetRoadMeshVisibility(TRUE);
 			NGRI.NRM.SetRoadStatus(ENRS_OnRoad);
 		}
	}
}

/** Called when pawn stops being attached to the car */
event Detach(Actor Other)
{
	local NanoGRI NGRI;
	local NanoSkill_VehicleOverride OverrideSkill;

	if( Other != None && Other == RidingPawn )
	{
		if( bIsOverriding )
		{
			OverrideSkill = RidingPawn.GetSkill(class'NanoSkill_VehicleOverride');

			// If the pawn is overdriving, deactivate that when they detach
			if( OverrideSkill != None )
			{
				OverrideSkill.DeactivateSkill();
			}
		}

		// Stop shaking the player's camera
		NanoPC(RidingPawn.Controller).ClientStopCameraShake(DeadVehicleCameraShake);

		RidingPawn = none;
		LastPercherLeaveTime = WorldInfo.TimeSeconds;

		// No longer player controlled, so move back into the traffic flow
		CurrentSplineLane = ChooseClosestLane();

		if( Role == ROLE_Authority )
		{
			FillOutTargetSplines();
		}

		SetTickGroup( TG_PostAsyncWork );

		if( AC_PlayerRiding != None )
		{
			AC_PlayerRiding.FadeIn( 0.100f, 0.0f );
		}

		// When the player leaves the car, hide the roads
		NGRI = NanoGRI(WorldInfo.GRI);
		if( NGRI != None )
		{
			NGRI.NRM.SetRoadMeshVisibility(FALSE);
		}
	}
}

simulated function bool ValidPlatformJumpTarget(NanoPawn NP)
{
	local vector ToVehicle;
	local float ToVehicleDist;

	ToVehicle = Location - NP.Location;
	ToVehicleDist = VSizeSq2D(ToVehicle);

	return /*(NP.Physics == PHYS_Walking) && */(CarSpeed < 256.f) && (ToVehicleDist <= 3000.f*3000.f) && (ToVehicleDist >= 256.f * 256.f) && (vector(NP.Rotation) dot Normal(ToVehicle) >= 0.2f);
}

simulated function int ChooseClosestLane()
{
	local float LastDistance, CurrDistance;
	local int i;

	// Trivial case:  no spline, or only one lane!
	if( (CurrentSpline == None) || CurrentSpline.NumLanes <= 1 )
	{
		return 0;
	}

	// Step over the list of lanes, right to left, looking for the closest
	i = 0;
	LastDistance = 99999999.f;
	while( i < CurrentSpline.NumLanes )
	{
		CurrDistance = VSizeSq(ControlledVehicleSplineOffset - CurrentSpline.LaneOffsets[i]);
		// If the distance is bigger than last time, we've passed the smallest distance, so break
		if( CurrDistance > LastDistance )
		{
			i = i - 1;
			break;
		}
		LastDistance = CurrDistance;
		++i;
	}
	
	// Return a bounded result (in case the closest was the last lane)
	return Min(i, CurrentSpline.NumLanes-1);
}

/** Called from C++ code */
simulated event SplineActor ChooseNextSpline()
{
	local Vector LocalDesiredDir, WorldDesiredDir;
	local NanoVehicleSpline NextSpline;
	local NanoVehicleSpline NewReplacementSpline;
	local bool bValidConnection;

	// If we have a cached route, follow that
	if(CachedRoute.Length > 0)
	{
		// This should always be true
		NextSpline = NanoVehicleSpline( CachedRoute[0] );

		if( NextSpline != None )
		{
			// Determine if the next spline from the route is a valid connection to / from this spline
			if( bFollowingPathForward )
			{
				bValidConnection = CurrentSpline.IsConnectedTo(NextSpline, TRUE);
			}
			else
			{
				bValidConnection = NextSpline.IsConnectedTo(CurrentSpline, TRUE);
			}

			if( bValidConnection )
			{
				// replace the node we are just about to remove
				NewReplacementSpline = NanoVehicleSpline(CachedRoute[CachedRoute.Length-1].GetRandomConnection());
				if( NewReplacementSpline != none )
				{
					CachedRoute.AddItem( NewReplacementSpline );
				}

				// Remove from head of list and go there.
				CachedRoute.Remove(0, 1);

				return NextSpline;
			}
		}
		// If its not, warn and give up on route
		else
		{
			`log( self @ "Cached Route Not Possible."@CurrentSpline@"not connected to"@NextSpline@" Cached Len: " @ CachedRoute.Length );
			CachedRoute.length = 0;
			return none;
		}
	}
	
	if(CurrentTurnDecision == ENTD_Random)
	{
		if( bFollowingPathForward )
		{
			// Return a random connection from the target spline forward
			NextSpline = NanoVehicleSpline(TargetSpline.GetRandomConnection());
		}
		else
		{
			// Return a random connection to the current spline when traveling backwards 
			NextSpline = NanoVehicleSpline(CurrentSpline.GetRandomConnection(TRUE));
		}

		if( NextSpline == None )
		{
			// If we have nowhere to go, destroy the vehicle!
			KillAgent();
		}

		return NextSpline;
	}
	else
	{
		// Turn direction enum into local space direction vector
		if(CurrentTurnDecision == ENTD_Straight)
		{
			LocalDesiredDir = vect(1,0,0);
		}
		else if(CurrentTurnDecision == ENTD_Left)
		{
			LocalDesiredDir = vect(0,-1,0);
		}
		else if(CurrentTurnDecision == ENTD_Right)
		{
			LocalDesiredDir = vect(0,1,0);
		}
		else if(CurrentTurnDecision == ENTD_Up)
		{
			LocalDesiredDir = vect(0,0,1);
		}
		else if(CurrentTurnDecision == ENTD_Down)
		{
			LocalDesiredDir = vect(0,0,-1);
		}
		
		// Transform into world space
		WorldDesiredDir = LocalDesiredDir >> Rotation;
		
		// Then use function to choose best direction
		return CurrentSpline.GetBestConnectionInDirection(WorldDesiredDir, !bFollowingPathForward);		
	}
}

/** Util that looks ahead for any vehicle closer than MinDistanceBetweenVehicles along this road or next segment, and returns it */
simulated native function NanoVehicleAgent LookAheadForVehicle( out float DistanceCarIsInFront );

// @todo:  might need to also check for crowd members?
/** Util that looks ahead for any pawn closer than MinDistanceAwayFromPawns and returns it */
simulated native function Pawn LookAheadForPawn( out float DistancePawnIsInFront );

/** Util to determine if this vehicle should consider TestVehicle for collision detection */
simulated native function bool ShouldConsiderVehicleForCollision( NanoVehicleAgent TestV );

/** Util that determines if we can change to the specified lane (within range, and is it clear of other cars) */
native function bool TryChangeToLane( int NewLane );

simulated event ENanoTurnDirection PlayRidingCarSounds( float DeltaTime )
{
	local ENanoTurnDirection SpeedDir;
	local NanoPC NPC;
	local NanoPlayerInput NPI;

	NPC = NanoPC(RidingPawn.Controller);
	NPI = NanoPlayerInput(NPC.PlayerInput);

	if( NPI.RawJoyUp > 0.3f )
	{
		CarDesiredSpeed += NPI.RawJoyUp * ThumbstickFowardSpeedModifier;
		SpeedDir = ENTD_Up;

		if( bPlayedAcclerationSound == FALSE )
		{
			bPlayedAcclerationSound = TRUE;

			AirCarEnginePitchGoal = 1.6f;
			PlaySound( PlayerAccelerating );
			SetTimer( 3.0f, FALSE, nameof(PlaySpeedWarning) );
		}

		bPlayedDecelerationSound = FALSE;
	}
	else if( NPI.RawJoyUp < -0.3f )
	{
		CarDesiredSpeed += -NPI.RawJoyUp * ThumbstickBackwardSpeedModifier;
		SpeedDir = ENTD_Down;

		if( bPlayedDecelerationSound == FALSE )
		{
			bPlayedDecelerationSound = TRUE;

			AirCarEnginePitchGoal = 0.5f;
			PlaySound( PlayerDecelerating );
			ClearTimer( nameof(PlaySpeedWarning) );
		}

		bPlayedAcclerationSound = FALSE;
	}
	else
	{
		bPlayedAcclerationSound = FALSE;
		bPlayedDecelerationSound = FALSE;

		ClearTimer( nameof(PlaySpeedWarning) );
		AirCarEnginePitchGoal = 1.0f;
	}

	if( ( AirCarEnginePitchCurr != AirCarEnginePitchGoal ) && ( AC_PlayerRiding != none ) )
	{
		AirCarEnginePitchCurr = FInterpTo( AirCarEnginePitchCurr, AirCarEnginePitchGoal, DeltaTime, 10 );
		AC_PlayerRiding.SetFloatParameter( AirCarEnginePitchName, AirCarEnginePitchCurr );
	}

	return SpeedDir;
}

simulated function SetVehicleOverride( bool bNewOverride )
{
	bIsOverriding = bNewOverride;
}

simulated function AttemptToOverride( bool bOverrideUp )
{
	local NanoSkill_VehicleOverride OverrideSkill;

	OverrideSkill = RidingPawn.GetSkill(class'NanoSkill_VehicleOverride');

	// Player's can't override dead vehicles
	if( Health <= 0 )
	{
		// If the player is overriding and the car dies, stop the override
		if( OverrideSkill != None )
		{
			OverrideSkill.DeactivateSkill();
		}

		// Abort!
		return;
	}

	if( OverrideSkill != None )
	{
		if( !OverrideSkill.bActive )
		{
			// Activate the skill if it hasn't been
			OverrideSkill.ActivateSkill();
		}

		// Set whether or not this is a gravity charge regardless of new activation
		OverrideSkill.SetGravityCharging(!bOverrideUp);
	}
}

simulated function StopOverride()
{
	local NanoSkill_VehicleOverride OverrideSkill;

	OverrideSkill = RidingPawn.GetSkill(class'NanoSkill_VehicleOverride');
	if( OverrideSkill != None )
	{
		OverrideSkill.DeactivateSkill();
	}
}

simulated event PossiblyPlayerOverride()
{
	local float CurrDistanceFromStartingAltitude;
	local NanoPawn SavedPawn;
	local NanoSkill_VehicleOverride OverrideSkill;
	local vector OverrideMomentum;
	
	OverrideSkill = RidingPawn.GetSkill(class'NanoSkill_VehicleOverride');

	if( Health <= 0 )
	{
		OverrideSkill.DeactivateSkill();
	}

	if( bIsOverriding && OverrideSkill != None )
	{
		if( bFirstOverride == FALSE )
		{
			PlaySound( AltitudeDeviationWarning );
			PlaySound( PlayerOverridingControl );
			bLimitMaxUpwardsVelocityDueToPlayerOverridingControl = TRUE;

			bEnableStayUprightSpring = TRUE;

			AC_PlayerRidingOverride = new(self) class'AudioComponent';
			if( AC_PlayerRidingOverride != none )
			{
				AC_PlayerRidingOverride.SoundCue = PlayerRidingOverride;
				AttachComponent( AC_PlayerRidingOverride );
				AC_PlayerRidingOverride.FadeIn( 0.100f, 1.0f );
			}

			bFirstOverride = TRUE;
		}

		// Update the location where we left from if needed
		if( Physics != PHYS_RigidBody )
		{
			LocationWhenPlayerOverodeControl = Location;
		}

		CurrDistanceFromStartingAltitude = VSize(LocationWhenPlayerOverodeControl - Location);
		if( AC_PlayerRidingOverride != none )
		{
			AC_PlayerRidingOverride.SetFloatParameter( AirCarEnginePitchName, (CurrDistanceFromStartingAltitude/MaxAltitudeChangeAllowWhenOverriden)  );
		}

		OverrideMomentum = vect(0.f,0.f,0.f);
		if( !OverrideSkill.bIsCharging )
		{
			// If we're not trying to charge, fly up!
			OverrideMomentum.Z = OverrideUpwardMomentum;
		}
		else
		{
			// If we are trying to charge, fly down!
			OverrideMomentum.Z = -OverrideDownwardMomentum;
		}

		FlyIntoTheAir(OverrideMomentum);

		// if we have flown up too high
		//`log( "VSize(LocationWhenPlayerOverodeControl - Location)" @ VSize(LocationWhenPlayerOverodeControl - Location) );
		//`log( (CurrDistanceFromStartingAltitude/MaxAltitudeChangeAllowWhenOverriden) );

		// disable the car!
		if( CurrDistanceFromStartingAltitude > MaxAltitudeChangeAllowWhenOverriden )
		{
			RidingPawn.PlaySound( MaxAltitudeWarning );
			PlaySound( PlayerOverridingControl_CarLostControl );

			SavedPawn = RidingPawn;
			SavedPawn.SetPhysics( PHYS_Falling );
			SavedPawn.SetHardAttach(FALSE);
			SavedPawn.Velocity = vect(0,0,500.f);
			SavedPawn.SetBase( none ); // should kick off the pawn from the car which will call NanoPawn.DetachedFromCarPerch

			//TakeDamage( 10000, RidingPawn.Controller, vect(0,0,0), vect(0,0,0), class'NDT_VehicleAboveAllowableFlightDeck' );
			bLimitMaxUpwardsVelocityDueToPlayerOverridingControl = FALSE;
			bEnableStayUprightSpring = FALSE;

			bCarDisabledByTrafficControl = TRUE;
		}
	}
}



/** Need special handling for teleport, to attach to road. Can only teleport to another NanoVehicleSpline. */
simulated function OnTeleport(SeqAct_Teleport Action)
{
	local array<Object> ObjVars;
	local int i;
	local NanoVehicleSpline DestSpline;

	// find the first supplied actor
	Action.GetObjectVars(ObjVars, "Destination");
	for(i = 0; i < ObjVars.Length; i++)
	{
		DestSpline = NanoVehicleSpline(objVars[i]);
		if(DestSpline != none)
		{
			break;
		}
	}
	
	// and set to that actor's location
	if (DestSpline != None && DestSpline.IsValidSplineForVehicle(self) && SetLocation(DestSpline.Location))
	{
		PlayTeleportEffect(false, true);
		if (Action.bUpdateRotation)
		{
			SetRotation(DestSpline.Rotation);
		}
		
		// Attach to new spline
		DestSpline.AddVehicleToSpline(self, DestSpline.GetBestLaneForVehicle());
		//TargetSplines[0] = NanoVehicleSpline(CurrentSpline.GetRandomConnection());
		FillOutTargetSplines();

		// Clear any cached route
		CachedRoute.Length = 0;
	}
	else
	{
		`warn("Unable to teleport to"@DestSpline);
	}
}

/** Handle being told to move to new destination */
simulated function OnSetVehicleDestination(SeqAct_SetVehicleDestination Action)
{
	local bool bSuccess;

	if((TargetSpline != None) && (Action.Destination != none))
	{
		bSuccess = TargetSpline.FindSplinePathTo(Action.Destination, CachedRoute);
		
		if(bSuccess)
		{
			// First element will be TargetSpline, so we remove it, to only contain paths after that
			CachedRoute.Remove(0, 1);
		}
		else
		{
			`log("Failed to path from"@self@"to"@Action.Destination);
		}
	}
}

simulated function TriggerVehicleMountedEvents(NanoPawn Rider)
{
	local array<int> ActivateIndices;
	local array<SequenceEvent> ActivatedEvents;
	local SequenceEvent it;
	local SeqEvt_VehicleMounted Evt;

	// Handle notifying kismet VehicleMounted events
	ActivateIndices[0] = 0;
	// Activate VehicleMounted event on the vehicle
	ActivateEventClass(class'SeqEvt_VehicleMounted', Rider, GeneratedEvents, ActivateIndices, FALSE, ActivatedEvents);
	foreach ActivatedEvents(it)
	{
		Evt = SeqEvt_VehicleMounted(it);
		if( Evt != None )
		{
			Evt.Vehicle = self;
		}
	}

	// Activate VehicleMounted event on the rider
	ActivatedEvents.length = 0;
	Rider.ActivateEventClass(class'SeqEvt_VehicleMounted', Rider, Rider.GeneratedEvents, ActivateIndices, FALSE, ActivatedEvents);
	foreach ActivatedEvents(it)
	{
		Evt = SeqEvt_VehicleMounted(it);
		if( Evt != None )
		{
			Evt.Vehicle = self;
		}
	}
}

/** Iterates down a list of cars a max number of iterations, and kills the car at the head if it hasn't been rendered in a while */
simulated function TryToClearJam( int IterationsLeft )
{
	local NanoVehicleAgent NVA;
	local float Distance;

	// See if we can kill this car to clear the jam
	if( `TimeSince(LastRenderTime) >= 1.f )
	{
		KillAgent();
	}
	else
	{
		// Otherwise, iterate up the list and try to kill cars ahead of us
		NVA = LookAheadForVehicle( Distance );
		IterationsLeft--;

		// Iterate down the list, if we can
		if( NVA != None && IterationsLeft > 0 )
		{
			NVA.TryToClearJam(IterationsLeft);
		}
	}
}

/////////// NanoInterface_Targetable ///////

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	//return (`TimeSince(LastRenderTime) < 1.f) && (Physics != PHYS_RigidBody) && (RidingPawn == None) && (`TimeSince(LastPercherLeaveTime) > 5.f);
	return FALSE;
}

/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}


simulated function bool ShouldRateTarget()
{
	 // if we have not seen this actor for 2 second then don't allow targeting of it
	return ((WorldInfo.TimeSeconds - LastRenderTime) < 2.0f);
}

simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	// if we are throwing a moon out we want to have the lowest possible priorty as it should not hit
	// the cars first as it destroys the moon
	if( Askee != none && Askee.ThrownMoon != none )
	{
		return 1.f;
	}

	return 10.f;
}

simulated event vector GetTargetedLocation()
{
	return (VehicleMeshComponent != None ? VehicleMeshComponent.Bounds.Origin : Location);
}

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );

simulated event BoxSphereBounds GetTargetableBounds()
{
	return VehicleMeshComponent.Bounds;
}


simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}

///////// NanoInterface_StabMantle //////////

simulated function float GetTargetDistanceScaling()
{
	return StabTargetDistanceScale;
}

simulated function vector GetStabAttachOffset()
{
	return StabAttachPos;
}

simulated function NotifyFinishedStabMantle( NanoPawn Rider, optional bool bViaLanding )
{
	local NanoPC NPC;
	local rotator PCRot;
	local vector PerchLoc;
	local rotator PerchRot;

	Rider.SetBase(self);

	// If we didn't land on the car, attach us for driving
	if( !bViaLanding )
	{
		Rider.SetPhysics(PHYS_Interpolating);
		Rider.SetHardAttach(TRUE);

		NPC = NanoPC(Rider.Controller);
		if(NPC != None)
		{
			PCRot = Rotation;
			PCRot.Roll = 0;
			NPC.SetRotation(PCRot);
		}

		GetVehiclePerchOffsets(PerchLoc, PerchRot);

		Rider.SetRelativeRotation(PerchRot);
		Rider.SetRelativeLocation(PerchLoc - Rider.Mesh.Translation);

		PerchedOnBy( Rider );
	}

	TriggerVehicleMountedEvents( Rider );
}

simulated function NotifyFinishedCarHop( NanoPawn Rider )
{
	local NanoPC NPC;
	local rotator PCRot;
	local vector PerchLoc;
	local rotator PerchRot;

	Rider.SetPhysics(PHYS_Interpolating);
	Rider.SetHardAttach(TRUE);
	Rider.SetBase(self);

	NPC = NanoPC(Rider.Controller);
	if(NPC != None)
	{
		PCRot = Rotation;
		PCRot.Roll = 0;
		NPC.SetRotation(PCRot);
	}

	GetVehiclePerchOffsets(PerchLoc, PerchRot);
		
	Rider.SetRelativeRotation(PerchRot);
	Rider.SetRelativeLocation(PerchLoc - Rider.Mesh.Translation);

	PerchedOnBy( Rider );

	TriggerVehicleMountedEvents( Rider );

	// Do attaching damage with a fraction of the max velocity
	DoAttachingDamage(Rider, 0.25f * PillowMaxAttachVelocity * vect(0,0,-1));
}

simulated function NotifySomeoneAttached( NanoPawn Rider );

simulated function bool IsValidStabMantleTarget(optional bool bIsLandingCheck)
{
	if( CurrentSpline != None && !CurrentSpline.bFlyingVehiclesOnly )
	{
		// Ground cars are never valid landing targets, as not to interfere with traversal
		return FALSE;
	}
	else
	{
		// All others are valid
		return (Health > 0) && (bCarDisabledByTrafficControl == FALSE);
	}
}

simulated function name GetStabMantleApproachAnim()
{
	return 'Car_Stab_Mantle_Fly';
}

simulated function name GetStabMantleAnim( bool bRightSide )
{
	return bRightSide ? 'Car_Stab_Mantle_Up_B' : 'Car_Stab_Mantle_Up';
}

simulated function float GetStabMantleAnimRate()
{
	return 1.5f;
}

simulated function NanoVolume_ChaosZone GetChaosZone()
{
	return CurrChaosZone;
}

simulated function SetChaosZone( const NanoVolume_ChaosZone InChaosZone )
{
	//`log( InChaosZone );
	//ScriptTrace();

	CurrChaosZone = InChaosZone;
}

/**  When car hits the ground play a sound and then turn off the RB collision notifications **/
event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
						 const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	local NanoVehicleAgent NVA;
	local NanoPawn SavedPawn;
	local float LaunchVelocityMag;
	local vector TmpVector;

	PlaySound( CrashToTheGroundCue, TRUE, TRUE, TRUE, Location );

	if( Health <= 0 )
 	{
		if( RidingPawn != None )
		{
			// Play an explosion!
			WorldInfo.MyEmitterPool.SpawnEmitter( DeadVehicleExplosion, Location, rot(0,0,1) );

 			SavedPawn = RidingPawn;
 			SavedPawn.SetBase(None);
 			SavedPawn.SetHardAttach(FALSE);
 			SavedPawn.SetPhysics(PHYS_Falling);
	 	
 			SavedPawn.Velocity = 2 * RigidCollisionData.TotalNormalForceVector / SavedPawn.Mass;

			// Make sure the launch velocity is within range
			LaunchVelocityMag = VSize(SavedPawn.Velocity);
			if( LaunchVelocityMag < MinPawnLaunchVelocity )
			{
				SavedPawn.Velocity *= MinPawnLaunchVelocity / LaunchVelocityMag;
			}
			else if( LaunchVelocityMag > MaxPawnLaunchVelocity )
			{
				SavedPawn.Velocity *= MaxPawnLaunchVelocity / LaunchVelocityMag;
			}
	 
			// Ensure that the pawn is always popped up
 			if( SavedPawn.Velocity dot vect(0.f,0.f,1.f) < 0.f )
 			{
 				SavedPawn.Velocity.Z *= -1.f;
 			}
	 
			// Stop shaking the player's camera
			NanoPC(SavedPawn.Controller).ClientStopCameraShake(DeadVehicleCameraShake);

			// TEMP:  Give them the sprint flailing animation for style points
 			SavedPawn.BlendFallNode.CopyAnimsFromSetByName( 'Sprint_Jump' );

			bEnableStayUprightSpring = TRUE;

			// Add some velocity in the direction of the pawn to keep things interesting
			TmpVector = EjectionCollisionVelocity * vector(SavedPawn.Rotation);
			TmpVector.Z = EjectionCollisionVerticalVelocity * FRand();
			VehicleMeshComponent.SetRBLinearVelocity(TmpVector, FALSE);

			// Add some torque to make the impact interesting!
			TmpVector = EjectionCollisionTorque * VRand();
			TmpVector.Z = EjectionCollisionYawTorque;
			VehicleMeshComponent.AddTorque(TmpVector);

			// Force the vehicle to stay upright for a few seconds after launching the pawn
			SetTimer(EjectionCollisionStayUprightDuration, FALSE, nameof(ForceStayUpright));
		}
		else
		{
			// Determine if the thing we hit is a car
			if( OtherComponent != none )
			{
				NVA = NanoVehicleAgent(OtherComponent.Owner);
			}

			// Do smashing damage.  If the other was a car, it'll be in NVA.  Otherwise, NVA will be None from the above cast and the collision will be treated as world
			DoCarDamageFromSmashingIntoEachOther(NVA);

			if( !IsTimerActive(nameof(ForceStayUpright)) )
			{
				// Turn off the stay upright spring to allow for some tumble
				bEnableStayUprightSpring = FALSE;

				// No more need to notify rigid body if the pawn is already gone
				VehicleMeshComponent.SetNotifyRigidBodyCollision( FALSE );
			}
		}

		// Fade out the engine sound, which is either the out of control sound, or the normal engine sound.  Either way, we don't need it anymore
		if( AC_EngineSound != None )
		{
			AC_EngineSound.FadeOut(0.25f, 0.f);
		}
 	}
}

// Do nothing, callback to make sure the car stays upright after ejecting the pawn for a short time
simulated function ForceStayUpright();

simulated function DoAttachingDamage( NanoPawn Rider, vector AttachVelocity )
{
	local float VelocityMag;

	// Don't do damage if we're just car hopping on the car
	if( Rider.bIsPlatformJumping )
	{
		// Dip the car slightly to make it feel like you've landed
		WorldOffsetInterpSpeed = 15.f;
		DesiredWorldOffsetVector = vect(0,0,-30);
		SetTimer( 0.25f, FALSE, nameof(ResetDipPhysics) );

		// Play the platform landing sound cue when we platform onto the car
		PlaySound(PlatformJumpingLandCue);
		return;
	}

	// Limit the attach velocity of the pawn
	VelocityMag = VSize(AttachVelocity);
	if( VelocityMag > PillowMaxAttachVelocity )
	{
		VelocityMag = PillowMaxAttachVelocity;
	}

	// Deal the damage to the car
	TakeDamage( Health, Rider.Controller, Rider.Location, AttachVelocity, class'NanoGame.NDT_CarSmashInto',,);
	
	// Record the time we got killed
	CarDestroyedByPawnTime = WorldInfo.TimeSeconds;

	// Disable the car if we killed it by attaching, and make sure it tries to stay upright
 	bEnableStayUprightSpring = TRUE;
 	bCarDisabledByTrafficControl = TRUE; 
	
	// Start shaking the player's camera!
	NanoPC(Rider.Controller).ClientPlayCameraShake(DeadVehicleCameraShake);

	NanoGRI(WorldInfo.GRI).NRM.SetRoadStatus(ENRS_OffRoad);
		
	// Set to rigid body physics
	SetPhysics(PHYS_RigidBody);
	bRecentCollision = true;

	// Add the jostling velocity
	VehicleMeshComponent.SetNotifyRigidBodyCollision( TRUE );

	if( VehicleType != ENVT_Ground )
	{
		// Determine the pillowing time, based on the impact velocity
		if( PillowMaxAttachVelocity == 0.f )
		{
			PillowDuration = PillowMaxDuration;
		}
		else
		{
			PillowDuration = (VelocityMag / PillowMaxAttachVelocity) * PillowMaxDuration;
		}

		// Play the dipping sound!
		if( AC_EngineSound != None )
		{
			if( PillowDuration > 0.35f )
			{
				// Long drop, play the dipping, and fade it out before the end to transition to the out of control sound
				AC_EngineSound.SoundCue = PlayerOverridingControl_CarLostControl;
				AC_EngineSound.FadeIn( 0.100f, 1.0f );

				// Fade out pre-emptively to transition to the out of control sound
				SetTimer(PillowDuration - 0.35f, FALSE, nameof(FadeOutPillowingSound));
			}
			else
			{
				// Short drop, just immediately play the out of control sound
				AC_EngineSound.SoundCue = CarLostControlEngineSound;
				AC_EngineSound.FadeIn( 0.100f, 1.0f );
			}
		}
	}
}

/** Called via a timer to fade out the pillowing sound right before the vehicle crests */
simulated function FadeOutPillowingSound()
{
	if( AC_EngineSound != None )
	{
		AC_EngineSound.FadeOut(0.35f, 0.f);
	}
}

/** Called when the car has completed absorbing the impact from a player landing on it, and begins to drop out of the air */
simulated event NotifyPillowingFinished()
{
	// Play the car out of control crashing sound!
	if( (AC_EngineSound != None) && (AC_EngineSound.SoundCue != CarLostControlEngineSound) )
	{
		AC_EngineSound.SoundCue = CarLostControlEngineSound;
		AC_EngineSound.bAutoDestroy = TRUE;
		AC_EngineSound.Play();
	}
}

simulated event DoCarDamageFromSmashingIntoEachOther( NanoVehicleAgent OtherVehicle )
{
	local vector RelativeVel, PostVel;
	local float MassRatio;
	local float Damage;
	local float PostVelMag;

	if( OtherVehicle != None )
	{
		// Compute the relative velocity of the two vehicles to simplify momentum transfer calculations
		RelativeVel = OtherVehicle.Velocity - Velocity;

		MassRatio = OtherVehicle.VehicleMass / VehicleMass;
		if( MassRatio >= 1.f )
		{
			LocationWhenPlayerOverodeControl = Location;

			// Rock the car a bit so that the collision feels "real"
			SetPhysics(PHYS_RigidBody);

			// Transfer velocity to the other car being hit
			PostVel = CollisionTransferDamping * MassRatio * RelativeVel;
			PostVelMag = VSize(PostVel);
			if( PostVelMag > MaxCollisionVelocity )
			{
				// If the final velocity is over the limit, normalize and scale to the limit
				PostVel = MaxCollisionVelocity * PostVel / PostVelMag;
				PostVelMag = MaxCollisionVelocity;
			}
			VehicleMeshComponent.SetRBLinearVelocity(PostVel + vect(0,0,1000.f), FALSE);
			
			// Add a little spin, scaled by the final velocity transferred
			VehicleMeshComponent.SetRBAngularVelocity(35.f * (PostVelMag / MaxCollisionVelocity) * VRand(), TRUE);
			
			// Prevent the car from reconnecting to the track for 3 seconds
			bRecentCollision = TRUE;
			SetTimer(3.f, FALSE, nameof(ResetCollisionPhysics));
		}
		else
		{
			// This car is the heavier car, so don't detach it from the road, just slow it down
			CarSpeed = MassRatio * VSize(Velocity);
		}

		// Base Damage is the ratio of the velocity of impact over the maximum speed of the car
		Damage = VSize(RelativeVel) / MaxCarSpeed * 100;
		// Factor in the difference in masses of the car
		Damage *= MassRatio;

		if( RidingPawn != None )
		{
			// If we were knocked free, then change the road color
			if( Physics == PHYS_RigidBody )
			{
				NanoGRI(WorldInfo.GRI).NRM.SetRoadStatus(ENRS_OffRoad);
			}

			RidingPawn.PlaySound( CollisionDetectedWarning );

			// Shake the camera to add to the effect
 			if( (CollisionCamShake != None) && (MassRatio > 1.f) )
 			{
  				NanoPC(RidingPawn.Controller).ClientPlayCameraShake(CollisionCamShake);
 			}

			// Reduce the damage done to pawn vehicles
			Damage *= 0.85f;
		}

		TakeDamage(Damage, OtherVehicle.RidingPawn != None ? OtherVehicle.RidingPawn.Controller : None, Location, vect(0,0,0), class'NanoGame.NDT_CarSmashInto',,);
	}
	else
	{
		// This was a collision with something non-vehicular...
		TakeDamage(100, None, Location, vect(0,0,0), class'NanoGame.NDT_CarSmashInto',,);
	}
}

/** Called a few seconds after a collision to let us join roads again */
simulated function ResetCollisionPhysics()
{
	bRecentCollision = FALSE;
	return;
}

simulated protected event DestroySelfDueToBadPathNetwork()
{
	TakeDamage( 10000, none, vect(0,0,0), vect(0,0,0), class'NanoGame.NDT_CarSmashInto',,);
}


/** Util to draw the cached route for this vehicle. */
simulated event DebugDrawCachedRoute()
{
	local int StepIdx;

	DrawDebugLine(Location, TargetSpline.Location, 30, 255, 30, FALSE);
	
	if(CachedRoute.Length > 0)
	{
		DrawDebugLine(TargetSpline.Location, CachedRoute[0].Location, 30, 255, 30, FALSE);		
	
		for(StepIdx=1; StepIdx<CachedRoute.Length; StepIdx++)
		{
			DrawDebugLine(CachedRoute[StepIdx-1].Location, CachedRoute[StepIdx].Location, 30, 255, 30, FALSE);
		}
	}
}

simulated function bool ShouldShowActionInfo()
{
	return (InteractAction.ActionName != '');
}


//========================================================
// NanoInterface_Attraction
//
simulated function bool ShouldAttractActor(Actor TestActor)
{
	local NanoPawn NP;

	return FALSE;

	NP = NanoPawn(TestActor);
	if( NP != None && NP.IsDusted() )
	{
		// Never attract a ghosted pawn
		return FALSE;
	}

	return (CurrentSpline != None) && CurrentSpline.bFlyingVehiclesOnly && (VSizeSq(TestActor.Location - Location) <= Square(AttractDistance));
}

simulated function Actor GetAttractionActor()
{
	return self;
}

simulated event vector GetAttractionLocationOffset()
{
	return PerchLocationOffset;
}

/** Called each frame that a Pawn is being attracted to this object */
simulated function bool AttractingPawn(NanoPawn NP);

//========================================================
// NanoInterface_BoulderedInto
//

simulated function BoulderedIntoBy(NanoPawn NP)
{
	local Vector LaunchVel;
	
	// update our stats for car bashing only once no matter how many times we bash it
	if( Health > 0 )
	{
		NanoGRI(WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumCarsDenseSmashed, 1 );
	}


	// if we are really running at the kactor, and its been long enough since last impulse
	if( (WorldInfo.TimeSeconds - LastBoulderImpulseTime) > MinTimeBetweenBoulderImpulse )
	{
		SetPhysics(PHYS_RigidBody);

		// Let the kactor calc its launch vel
		LaunchVel = CalcBoulderedLaunchVel(NP);
		VehicleMeshComponent.AddImpulse(LaunchVel, Location, '', TRUE);
		DenseBashFireOffKismetNotifies(NP);
		
		// Update last boulder time
		LastBoulderImpulseTime = WorldInfo.TimeSeconds;

		// Kill the car!
		TakeDamage(Health, NP.Controller, Location, vect(0,0,0), class'NDT_BoulderedInto');
	}
}

/** This is just a click way to fire off any kismet notifies that need occur from when things are dense bashed**/
simulated event DenseBashFireOffKismetNotifies( NanoPawn ThePawn )
{
	// fire off event for kismet usage
	TriggerEventClass( class'SeqEvt_DenseBash', ThePawn, 0 );
}


simulated function vector CalcGoodLaunchVel(vector TargetPos)
{
	local float Grav, Dist2D, TossHeight, Launch2DVel, FlightTime;
	local vector LaunchVel, ToTarget2D;

	Grav = GetGravityZ();

	ToTarget2D = (TargetPos - Location);
	ToTarget2D.Z = 0.0;

	Dist2D = VSize(ToTarget2D);

	// Desired height to toss (with a min)
	TossHeight = FMax(Dist2D * BoulderLaunchHeightFactor, 100.0);

	// Based on conservation of energy - mv^2 (at launch) -> mgh (at apex), so v = sqrt(gh)
	LaunchVel.Z = sqrt(Abs(Grav) * TossHeight);
	// Calc time for vel to drop to zero, and double it (for down part as well)
	FlightTime = 2.0 * (LaunchVel.Z/Abs(Grav));
	// Figure out vel to reach target in that time along ground
	Launch2DVel = Dist2D/FlightTime;
	LaunchVel += (Normal(ToTarget2D) * Launch2DVel);
	
	return LaunchVel;
}

/** Find the best target  */
simulated function actor BestTargetInDir(NanoPawn LaunchingPawn, vector TargetDir)
{
	local NanoPC NPC;
	local Actor A, Best;
	local float Weight, BestWeight, ViewDot, Dist, Priority;
	local vector ToA;
	local array<Actor> TargetableWithinMaxRange;


	NPC = NanoPC(LaunchingPawn.Controller);

	if(NPC != None)
	{
		TargetableWithinMaxRange = NanoGRI(WorldInfo.GRI).FindAllNanoInterface_TargetableAroundPlayerPawn( NPC.MyNP, 4096 );

		// Iterate over potential targets
		foreach TargetableWithinMaxRange(A)
		{
			// If its not me..
			if (A != None && (A != LaunchingPawn) && (A != self))
			{
				Weight = -1.0;

				// Get base priority..
				Priority = NanoInterface_Targetable(A).GetBasePriority(NPC, LaunchingPawn);

				// If it has some priority and is visible..
				if(Priority > 0.0)
				{
					ToA = (A.Location - Location);
					Dist = VSize(ToA);
					ViewDot = (ToA/Dist) dot TargetDir;
					// If its fairly ahead and within range..
					if((Dist < MaxBoulderTargetDist) && (ViewDot > 0.3))
					{
						// ..set its priority based on this
						Weight = (Priority * ViewDot) + (Priority * (1.f - Dist/MaxBoulderTargetDist) * 0.5);
					}
				}

				// If this is best so far - remember it
				if ((Weight > 0.f) && (Weight > BestWeight))
				{
					Best = A;
					BestWeight = Weight;
				}
			}
		}
	}

	return Best;
}

simulated event vector CalcBoulderedLaunchVel(NanoPawn LaunchingPawn)
{
	local NanoGRI GRI;
	local Vector TargetDir;
	local Actor Best;

	GRI = NanoGRI(WorldInfo.GRI);

	// Increase chaos level on boulder launch
	GRI.ModifyChaosLevel( GetChaosZone(), LaunchingPawn, class'NanoCausingChaosValues'.default.KActorBoulderBashed );

	// Find something to target in the direction we (launching pawn) is moving
	TargetDir = Normal(LaunchingPawn.Velocity);
	Best = BestTargetInDir(LaunchingPawn, TargetDir);
	if(Best != None)
	{
		return CalcGoodLaunchVel(Best.Location);
	}

	return LaunchingPawn.Velocity * DenseShoveResultSpeed;
}

//========================================================
// NanoInterface_Grapple
//

/** Is this actor currently able to be grappled? */
simulated function bool	IsGrapplable()
{
	return bCanGrapple && !bIsInSpawnPool && (Health > 0);
}

simulated function vector GetGrappleLocation( NanoPawn Grappler )
{
	return Location;
}

/** If this returns TRUE, then NewRotation will be the target's desired rotation for the pawn */
simulated function bool ShouldOverrideDesiredRotation( NanoPawn Grappler, out rotator NewRotation, float DistanceToTarget );

/** Whether or not this location can be grapple to from above */
simulated function bool CanGrappleFromAbove()
{
	return TRUE;
}

simulated function GetGrappleAnims(bool bAboveTargetPoint, out name StartAnim, out name LoopAnim, out name EndAnim);

/** Called when someone begins grappling this actor */
simulated function NotifyBeginGrappled( NanoPawn Grappler );

/** Called when someone finishes grappling this actor */
simulated function NotifyEndGrappled( NanoPawn Grappler );

simulated function bool SupportsActiveGrapple()
{
	return FALSE;
}

simulated function vector GetActiveGrappleVelocity();

simulated function float GetMinimumGrappleDistance()
{
	return 1024.f;
}


/** Register the Siegebeast as an obstacle with NavMesh */
native function RegisterObstacle();

/** Unregister the Siegebeast as an obstacle with NavMesh */
native function UnRegisterObstacle();

event PlayStoppedByPawnHornHonkSound()
{
	// only play when chaos is 0 otherwise just too many crazy sounds occurring
	if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() == 0 )
	{
		PlaySound( StoppedByPawnHornHonkSound );
	}
}


/** Helper function to smash those pesky cars **/
function SmashNanoVehicleAgent( vector HitNormal, float RammingVel, float RammingVelUp, Controller DamageCauser, class<NanoDamageType> InDamageType  )
{
	local vector DirToThrow;

	DirToThrow = (-HitNormal*RammingVel) + (vect(0,0,1)*RammingVelUp);

	DirToThrow *= 2.0f;

	TakeDamage( Health+10, DamageCauser, vect(0,0,0), DirToThrow, InDamageType );

	VehicleMeshComponent.AddForce( DirToThrow );

	VehicleMeshComponent.SetRBCollidesWithChannel( RBCC_Pawn, FALSE );
}



defaultproperties
{
	Health=8000

	ConformType=CFM_None
	bCheckForObstacles=FALSE
	bUseNavMeshPathing=FALSE

	bDebugDrawCachedRoute=FALSE

	DamageEffectThresh=50

	VehicleType=ENVT_Both
	DesiredSplineLane=INDEX_NONE
	LaneChangeDuration=2.f
	LaneChangeConsiderationInterval=1.f
	
	MaxCarSpeed=1000.0
	SplineSuggestedSpeedModifier=1.0f
	CarBraking=6.0
	CarAcceleration=1.0
	CarRotationSpeed=6.0
	MaxCarLateralSpeed=1000.f
	CarLateralAcceleration=250.f
	CarLateralSpeedBankDamping=0.75f
	
	CarBankFactor=5000.0
	CarBankMax=4000.0
	
	MinDistanceBetweenVehicles=800.0
	MinDistanceAwayFromPawns=800.0

	StabTargetDistanceScale=1.f
	StabAttachPos=(X=0.0,Y=0.0,Z=100.0)

	YawSpeedFilterSize=15

	Begin Object Class=StaticMeshComponent Name=VehicleMeshComponent0
		// this should be set by the VehicleSpawner KismetAction via CrowdAgentList
		//StaticMesh=StaticMesh'MET_FlyingCar01.SM.Mesh.MET_FlyingCar01'
		Rotation=(Yaw=-16384)
		
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE,Untitled2=TRUE,Untitled3=TRUE)
	    BlockRigidBody=TRUE
	    
		LightEnvironment=MyLightEnvironment
		bUsePrecomputedShadows=FALSE
		TickGroup=TG_PostAsyncWork
		
		CollideActors=TRUE
		BlockActors=TRUE
		BlockNonZeroExtent=TRUE
		BlockZeroExtent=TRUE
		CastShadow=FALSE

		bNotifyRigidBodyCollision=TRUE
		ScriptRigidBodyCollisionThreshold=100.0
	End Object
	CollisionComponent=VehicleMeshComponent0
	VehicleMeshComponent=VehicleMeshComponent0
	Components.Add(VehicleMeshComponent0)

	Begin Object Class=NanoCameraShake Name=CollisionCameraShake
		OscillationDuration=0.3f
		RotOscillation={(Yaw=(Amplitude=35.f,Frequency=125.f),
						Roll=(Amplitude=35.f,Frequency=125.f))}
	End Object
	CollisionCamShake=CollisionCameraShake

	Begin Object Class=NanoCameraShake Name=DeadCameraShake
		OscillationDuration=10.f
		RotOscillation={(Yaw=(Amplitude=125.f,Frequency=65.f),
						Roll=(Amplitude=125.f,Frequency=65.f))}
	End Object
	DeadVehicleCameraShake=DeadCameraShake
	
	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)


	bBlockActors=TRUE
	
	TickGroup=TG_PostAsyncWork

	CrashToTheGroundCue=SoundCue'Vehicle_AirCar.Impacts.CarImpact_Mix_Cue'

	EngineSoundCues.Add( SoundCue'Vehicle_AirCar.AirCar.Aircar_FlyConstant_LoopRandom_Cue' )

	SupportedEvents.Add(class'SeqEvt_VehicleMounted')

	PlayerStartup=SoundCue'Vehicle_AirCar.AirCar.AirCar_Start_Stereo_01Cue'
	PlayerRiding=SoundCue'Vehicle_AirCar.AirCar.AirCar_Running_01Cue'
	PlayerRidingOverride=SoundCue'Vehicle_AirCar.AirCar.AirCar_RunningAltitude_01Cue'
	PlayerStoppingEngine=SoundCue'Vehicle_AirCar.AirCar.AirCar_Stop_Stereo_01Cue'

	PlayerAccelerating=SoundCue'Vehicle_AirCar.AirCar.AirCar_Accelerate_Stereo_01Cue'
	PlayerDecelerating=SoundCue'Vehicle_AirCar.AirCar.AirCar_Decelerate_Stereo_01Cue'

	AirCarEnginePitchName="AirCarEnginePitch"

	PlayerLandedCue=SoundCue'Vehicle_AirCar.Impacts.CarImpact_PlayerLand_01_Cue'
	PlatformJumpingLandCue=SoundCue'Vehicle_AirCar.AirCar.AirCar_LandOnFromJump_Stereo_Cue'

	PlayerOverridingControl=SoundCue'Vehicle_AirCar.AirCar.AirCar_Ascend_Stereo_01'
	AltitudeDeviationWarning=SoundCue'Dialog_City_Chatter.Traffic.City_WarnAltitudeLevel_01Cue'

	PlayerOverridingControl_CarLostControl=SoundCue'Vehicle_AirCar.AirCar.AirCar_LandOn_UpDownUp_Stereo_Cue'
	CarLostControlEngineSound=SoundCue'Vehicle_AirCar.AirCar.AirCar_LandOn_FallToGround_Stereo_Cue'

	MaxPhysicsVelocityWhenPlayerOverridingControl=2000.0f
	MaxAltitudeChangeAllowWhenOverriden=25000.0f

	DamageEffect=ParticleSystem'Nano_Effects_Cine.CHL_P_End.P_Fire_Trail_1'
	DeathEffect=ParticleSystem'Nano_Effects_Cine.CHL_P_End.P_Car_Explosion'
	DeathExplosionSound=SoundCue'Vehicle_RatTruck.RatTruck_Mono.RatTruck_BodyExplodes_Cue'

    StoppedByPawnHornHonkSound=SoundCue'Ambient_Audio.VehicleHorns.HornC_Honk02Cue'

	MaxAltitudeWarning=SoundCue'Dialog_City_Chatter.Traffic.City_WarnMaxAltitude_01Cue'
	SpeedingWarning=SoundCue'Dialog_City_Chatter.Traffic.City_WarnSpeeding_01Cue'
	CollisionDetectedWarning=SoundCue'Dialog_City_Chatter.Traffic.City_TrafficAccident_01Cue'

	CarDetachLandingVelocity=4000.f
	DeadVehicleExplosion=ParticleSystem'COG_Mortar.Effects.P_Mortar_Ground_Explosion_Stone'
	MinPawnLaunchVelocity=1000.f
	MaxPawnLaunchVelocity=2500.f

	StayUprightTorqueFactor=4000.0
	StayUprightMaxTorque=4500.0

	MaxCollisionVelocity=10000.f
	CollisionTransferDamping=0.6f

	PerchLocationOffset=(Z=168.f)

	WorldOffsetInterpSpeed=4.f

	WobbleRollRate=30000.f
	WobbleOffsetRate=64.f
	MaxWobbleOffset=32.f
	WobbleRollDamping=0.05f

	//TickFrequencyDecreaseDistanceStart=12000
	//TickFrequencyDecreaseDistanceEnd=16000
	//TickFrequencyAtEndDistance=0.1

	CameraDownPitchDegreesOfFreedom=11800
	CameraUpPitchDegreesOfFreedom=3640
	CameraRidingOffset=(X=-250.f,Y=0.f,Z=0.f)
	CameraOverridingDistanceMultiplier=3.f

	PawnSlowingFOVModifier=0.6f
	PawnSpeedingFOVModifier=1.25f

	bFollowingPathForward=TRUE

	OverrideNanoRateModifier=1.f

	PillowGravityAmplitudeScale=7.5f
	PillowMaxAttachVelocity=4000.f
	PillowMaxDuration=4.f
	PillowPostGravityScale=0.65f

	DeadWobbleExtent=2000
	DeadWobbleDuration=4.f

	EjectionCollisionVelocity=2500.f
	EjectionCollisionVerticalVelocity=300.f
	EjectionCollisionTorque=500.f
	EjectionCollisionYawTorque=5000.f
	EjectionCollisionStayUprightDuration=2.f

	// Air control parameters
	Air_ThrustPercentage=0.25f
	Air_TurnRate = 45.f
	Air_TurnDamping = 1.2f

	Air_TurnTorqueFactor = 7000.f
	Air_TurnTorqueMax = 10000.f

	Air_PitchTorqueFactor = 450.f
	Air_PitchTorqueMax = 60.f
	Air_PitchDamping = 0.3f
	
	Air_RollTorqueTurnFactor = 700.f
	Air_RollTorqueStrafeFactor = 100.f
	Air_RollTorqueMax = 300.f
	Air_RollDamping=0.1f

	Air_LandingAttraction=1.f

	OverrideUpwardMomentum=5000.f
	OverrideDownwardMomentum=5000.f

	DenseShoveResultSpeed=2.f
	MaxBoulderTargetDist=2500.0
	BoulderLaunchHeightFactor=0.2
	MinTimeBetweenBoulderImpulse=0.5

	AttractDistance=400.f

	SupportedEvents.Add(class'SeqEvt_DenseBash')

	DurationBeforeSpawningFirstEncounterEffects=10.0f
	PS_IRIS_FirstEncounter=ParticleSystem'Nano_Iris_Proto.Effects.P_IrisTargeting_Initiate'
	IRIS_FirstEncounterBoneName="b_MF_Spine_03"

}

