/**
 * Base class for the kryll flock
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class KryllFlockBase extends InterpActor
	config(Pawn)
	abstract;

/** Number of actors to spawn in flock */
var()   int     NumFlockActors;

/** Distance to randomly spawn them */
var()	float	RandomSpawnRadius;

/** Tendency of actors to flock away from each other */
var()   float 	AvoidanceFactorMin;

/** Tendency of actors to flock away from each other */
var()   float 	AvoidanceFactorMax;

/** Multiplier of velocity applied to Kryll when they are hit */
var()	float	KryllHitScatterFactor;

/** Time a hit Kryll will scatter before going into phys_falling */
var()	float	KryllHitScatterDelay;

/** Tendency of actors to flock to Flock location */
var()   float	FlockMigrationFactor;

/** Min speed each actor can move squared */
var()   config float	MaxFlockSpeedSquaredMin;

/** Max speed each actor can move squared */
var()   config float	MaxFlockSpeedSquaredMax;

/** Scale min of the Kryll in flock */
var() 	float	ScaleMin;

/** Scale max of the Kryll in flock */
var() 	float	ScaleMax;

/** How much damage this flock does, per kryll, per second */
var() config float DamagePerKryllPerSecond;

/** Damage type to use for kryll */
var() class<DamageType>		MyDamageType;

/** true if my current target is a "home" location, false otherwise */
var transient bool	bTargetingHomeLoc;

/** Kryll are currently scattered */
var transient bool	bScattered;

/** Cache references to the kryll bats in this flock */
var protected array<KryllBatBase>	FlockArray;

/** Ambient vocal kryll sound */
var protected AudioComponent		FlockSound;

/** Ambient wing flapping kryll sound */
var protected AudioComponent		FlapSound;

/** The kryll's current target */
var	Actor					        CurrentTarget;

/** How much the bats should avoid eachother */
var protected float					AvoidanceMultiplier;

/** How much to adjust the bat speed */
var protected float					SpeedMultiplier;

/** Which class of KryllBats should be spawned */
var protected class<KryllBatBase>	BatClass;

/** Whether the flock has reached its target yet */
var protected bool					bReachedTarget;

/** Whether the kryll are flying back into the air */
var protected bool					bFlyUp;

/** The last time we played the kryll are close to a player sound */
var float						LastPlayedClose;

/** The wings flapping as kryll approach */
var SoundCue WingFlapping;

/** The shriek of kryll approaching */
var SoundCue VocalApproach;

/** Flyby sound cue */
var SoundCue FlybySound;

/** Sound to play when taking damage from kryll */
var SoundCue BiteSound;

/** Alternate sound to play when taking damage from kryll */
var SoundCue AltBiteSound;

/**
 * Target location, replicated for clients.  Clients should not follow the target themselves,
 * since there is a chance the target isn't replicated.
 */
var transient vector		RepTargetLocation;

replication
{
	if (bNetDirty)
		CurrentTarget, AvoidanceFactorMin, AvoidanceFactorMax, FlockMigrationFactor,
		MaxFlockSpeedSquaredMin, MaxFlockSpeedSquaredMax, RandomSpawnRadius, ScaleMin, ScaleMax, bScattered,
		AvoidanceMultiplier, RepTargetLocation;
}

/** Initialize the flock */
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

    InitFlock();

    CurrentTarget = self;
}

/**
 * Spawns a single KryllBat
 * 
 * @return a reference to the new kryll bat
 */
private function KryllBatBase SpawnKryllBat()
{
	local KryllBatBase Bat;
	Bat = Spawn(BatClass, self, '', Location + (RandomSpawnRadius * Normal(VRand())));

	if (Bat != None)
	{
		Bat.AvoidanceFactor = RandRange(AvoidanceFactorMin, AvoidanceFactorMax);
		Bat.AvoidanceFactor *= Bat.AvoidanceFactor;
		Bat.Speed = RandRange(MaxFlockSpeedSquaredMin, MaxFlockSpeedSquaredMax);
		Bat.SetDrawScale(RandRange(ScaleMin, ScaleMax));
		Bat.SetFlockOwner(self);
	}

	return Bat;
}

/** Spawn the bats and start up the sounds */
simulated function InitFlock()
{
	local int i;

    for (i=0; i<NumFlockActors; i++)
    {
		SpawnKryllBat();
    }

 	FlapSound.Play();
    FlockSound.Play();
    Enable('Tick');
}

/** Clean up the stored refs and stop the sounds */
simulated function DestroyFlock()
{
	local int i;

    for (i=0; i<FlockArray.Length; i++)
	{
    	FlockArray[i].Destroy();
	}
	FlockArray.Length = 0;

	NumFlockActors = 0;
 	FlapSound.FadeOut(2.0f, 0.0f);
    FlockSound.FadeOut(2.0f, 0.0f);
    Disable('Tick');
}

/** Add a bat to the cached ref array */
simulated function RegisterBat(KryllBatBase B)
{
	FlockArray[FlockArray.Length] = B;
}

/**
 * Changes the number of Kryll in the flock.
 * 
 * @param NumKryll - how many kryll should be in the flock
 */
function SetNumKryll(int NumKryll)
{
	local int Idx;

	if (NumKryll > NumFlockActors)
	{
		// spawn extra to get us up to the desired number
		for (Idx=FlockArray.Length; Idx<NumKryll; ++Idx)
		{
			SpawnKryllBat();
		}
	}
	else if (NumKryll < NumFlockActors)
	{
		// delete some to get us down to desired number
		for (Idx=FlockArray.Length-1; Idx>=NumKryll; --Idx)
		{
			FlockArray[Idx].Destroy();
		}
		FlockArray.Length = NumKryll;
	}

	NumFlockActors = NumKryll;
}

/** Regen kryll flock, useful for when parameters get changed */
simulated function RespawnKryll()
{
	DestroyFlock();
	InitFlock();
}

/**
 * Warp the kryll to a location
 * 
 * @param NewLocation - where the kryll should warp to
 */
simulated function WarpTo(vector NewLocation)
{
	local int Idx;
	local vector NewKryllLoc;

	for (Idx=0; Idx<NumFlockActors; ++Idx)
	{
		if (FlockArray[Idx] != None)
		{
			NewKryllLoc = (FlockArray[Idx].Location - Location) + NewLocation;
			FlockArray[Idx].SetLocation(NewKryllLoc);
		}
	}

	SetLocation(NewLocation);
}

/**
 * Start an attack run
 * 
 * @param Target - the pawn to attack
 * 
 * @param StartOffset - how far offset from the target we should start
 */
simulated function BeginAttackRun(GearPawn Target, const out vector StartOffset)
{
	SetHidden(FALSE);

	// warp to above target
	WarpTo(Target.Location + StartOffset);

	// scream!
	PlaySound(WingFlapping);
	PlaySound(VocalApproach);

	// start swoopin!
	SetTarget(Target);
}

/** Stop an attack run */
simulated function AbortAttackRun()
{
	// sound?
	PlaySound(VocalApproach);

	// scatter
	Scatter(1.f, 500.f);

	// clear target
	SetTarget(None);

	SetTimer( 1.f, FALSE, nameof(AbortAttackRun_ScatterFinished) );
}

/** Start flying upwards */
simulated function AbortAttackRun_ScatterFinished()
{
	bFlyUp = TRUE;

	// set timer for hiding
	SetTimer( 2.f, false, nameof(AbortAttackRun_DestroyTimer) );
}

/** Destroy the flock */
simulated function AbortAttackRun_DestroyTimer()
{
	Destroy();
}

/**
 * Retrieve the target location to fly to
 * 
 * @return the location to fly to
 */
simulated function vector GetCurrentTargetLocation()
{
	local GearPawn WP;
	WP = GearPawn(CurrentTarget);
	if (WP != None)
	{
		return WP.GetBaseTargetLocation();
	}
	else if (bFlyUp)
	{
		// fly up to the sky!
		return CurrentTarget.Location + vect(0,0,5000);
	}
	else
	{
		return CurrentTarget.Location;
	}
}

/** Check if we've reached our target */
function UpdateReachedTarget()
{
	 bReachedTarget = bReachedTarget || CurrentTarget == None || VSize(CurrentTarget.Location - Location) < 256.f;
}

/**
 * Fly towards the target, cause damage and stay in formation
 * 
 * @param DeltaTime - the length of the last frame
 */
simulated function Tick(FLOAT DeltaTime)
{
	local int i, j;
	local float OtherDist, CurrentBatAvoidance;
	local vector AverageCenter, TargetLocation, OtherBatToCurrentBat, NewCurrentBatVel;
	local KryllBatBase CurrentBat, OtherBat;

	Super.Tick(DeltaTime);

	NumFlockActors = FlockArray.Length;

	// close enough to do damage?
	if (Role == ROLE_Authority)
	{
		ApplyDamage(DeltaTime);
		// check to see if we've reached the target yet
		UpdateReachedTarget();
	}

	if (Role == ROLE_Authority)
	{
		TargetLocation = GetCurrentTargetLocation();

		// this will replicate out to clients
		RepTargetLocation = TargetLocation;
	}
	else
	{
		TargetLocation = RepTargetLocation;
	}


	for (i=0; i<NumFlockActors; i++)
	{
		CurrentBat = FlockArray[i];
		if ( CurrentBat == None )
		{
			NumFlockActors--;
			FlockArray.Remove(i--,1);
			continue;
		}

		CurrentBatAvoidance = CurrentBat.AvoidanceFactor * AvoidanceMultiplier;
		NewCurrentBatVel = CurrentBat.Velocity;

		// Avoid others
		for (j=0; j<NumFlockActors; j++)
		{
			if (j != i)
			{	
				OtherBat = FlockArray[j];

				OtherBatToCurrentBat = CurrentBat.Location - OtherBat.Location;

				// Avoidance
				OtherDist = VSizeSq(OtherBatToCurrentBat);
				if (OtherDist != 0)
				{
					NewCurrentBatVel += Normal(OtherBatToCurrentBat) * (CurrentBatAvoidance / OtherDist);
				}
			}
		}

		// Migrate toward TargetLocation
		NewCurrentBatVel += (TargetLocation - CurrentBat.Location) * FlockMigrationFactor;

		// Velocity capping
		//if (VSizeSq(FlockArray[i].Velocity) > (FlockArray[i].Speed * SpeedMultiplier))
		NewCurrentBatVel = Normal(NewCurrentBatVel) * (CurrentBat.Speed * SpeedMultiplier);

		CurrentBat.SetRotation(Rotator(NewCurrentBatVel));

		AverageCenter += CurrentBat.Location;

		CurrentBat.Velocity = NewCurrentBatVel;
	}

	// Locate ourself to the center of the flock as best we can
	if (Role == ROLE_Authority)
	{
		UpdateCenter(AverageCenter);
	}
}

/** Move towards the center of the flock */
function UpdateCenter(vector AverageCenter)
{
	if (NumFlockActors != 0)
	{
		AverageCenter = AverageCenter / NumFlockActors;
		if (CurrentTarget != self && !bFlyUp)
		{
	    	SetLocation(AverageCenter);
		}
	}
}

/**
 * Scatter the flock by changing the avoidance multiplier
 * 
 * @param ScatterTime - how long to scatter for
 * 
 * @param ScatterMagniture - how much to scatter
 */
simulated function Scatter(float ScatterTime, float ScatterMagnitude)
{
	bScattered = TRUE;
	AvoidanceMultiplier = ScatterMagnitude;
	SetTimer(ScatterTime, false);
}

/** Clear the scatter order and get back in a tight flock */
simulated function Timer()
{
	AvoidanceMultiplier = 1.0f;
	bScattered = FALSE;
}

/**
 * Handle kismet destroy
 * 
 * @param Action - the kismet action that destroyed us
 */
simulated function OnDestroy(SeqAct_Destroy Action)
{
    DestroyFlock();

    Super.OnDestroy(Action);
}

/** Clean up on destroy */
simulated event Destroyed()
{
	DestroyFlock();

    super.Destroyed();
}

/**
 * Sets target for flock to attack. 
 * 
 * @param NewTarget - the new target to fly to, use None for no target (flock will return to "home" location).
 */
simulated function SetTarget(Actor NewTarget)
{
	bReachedTarget = FALSE;
	if (NewTarget == None)
	{
		CurrentTarget = self;
	}
	else
	{
		CurrentTarget = NewTarget;
	}
}

/**
 * Cause damage to the target
 * 
 * @param DeltaTime - the length of the last frame
 */
function ApplyDamage(float DeltaTime)
{
	local GearPawn TargetWP;
	local int NumDamagingKryll;
	local bool CloseBy;
	local int Idx;

	local Vector EndTrace;
	local ImpactInfo Impact;
	local float DistanceFromFlock;

	TargetWP = GearPawn(CurrentTarget);

	if ((TargetWP != None) && (CurrentTarget != Self))
	{
		for (Idx=0; Idx<NumFlockActors; ++Idx)
		{
			if ( FlockArray[Idx] != None )
			{
				DistanceFromFlock = VSizeSq(FlockArray[Idx].Location  - CurrentTarget.Location);
				if ( DistanceFromFlock < 122500.f )
				{
					if ( DistanceFromFlock < 50000.f )
					{
						++NumDamagingKryll;
					}
					else if(  NumDamagingKryll == 0 )
					{
						// getting close
						CloseBy=true;
					}
				}
			}
		}

		if(NumDamagingKryll == 0 && CloseBy && (LastPlayedClose + 5.0f < WorldInfo.TimeSeconds))
		{ 
			PlaySound(FlybySound);
			LastPlayedClose = WorldInfo.TimeSeconds;
		}
		else if (NumDamagingKryll > 0)
		{
			if(LastPlayedClose+0.33f < WorldInfo.TimeSeconds)
			{ 
				if(frand() > 0.5f)
				{
					PlaySound(BiteSound);
				}
				else
				{
					PlaySound(AltBiteSound);
				}

				LastPlayedClose = WorldInfo.TimeSeconds;
			}

			// Trace to neck for maximum blood in your face
			EndTrace = TargetWP.Mesh.GetBoneLocation(TargetWP.MeleeDamageBoneName);

			// Do a trace to get HitInfo
			TraceComponent(Impact.HitLocation, Impact.HitNormal, TargetWP.Mesh, EndTrace, Location, Vect(0,0,0), Impact.HitInfo);

			//MomentumScale   = Impact.HitNormal * -1.f;
			Impact.HitActor = TargetWP;
			Impact.RayDir   = Normal(Impact.HitLocation - Location);

			TargetWP.TakeDamage(DamagePerKryllPerSecond*NumDamagingKryll*DeltaTime, None, Impact.HitLocation, Normal(VRand()) * RandRange(-128,128), MyDamageType, Impact.HitInfo, self);

			// cover head!
			if( TargetWP.CanCoverHead() )
			{
				TargetWP.PlayHeadCoverAnim(1.5f,TRUE);
			}
		}
	}
}

defaultproperties
{
	bKillDuringLevelTransition=TRUE

    NumFlockActors=0
    AvoidanceFactorMin=100.0f
    AvoidanceFactorMax=500.0f
    AvoidanceMultiplier=1.0f
    FlockMigrationFactor=1.0f
    SpeedMultiplier=1.0f
    RandomSpawnRadius=1000.0f
    ScaleMin=1.0f
    ScaleMax=1.0f
	KryllHitScatterFactor=1.2f
	KryllHitScatterDelay=0.5f

	RemoteRole=ROLE_SimulatedProxy
	NetUpdateFrequency=1.0
	bAlwaysRelevant=true
	bUpdateSimulatedPosition=true

	bStatic=false
	bNoDelete=false
    DrawScale=0.1f
    bCollideActors=false
    bCollideWorld=false
    bBlockActors=false
}