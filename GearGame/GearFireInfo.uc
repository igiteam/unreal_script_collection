/**
 * A manager object for a single "patch" of fire.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearFireInfo extends Actor
	abstract
	native(Weapon)
	implements(AIObjectAvoidanceInterface);

var protectedwrite transient array<Emit_StickyFire> FireFX;
var protectedwrite transient array<Emit_BouncyFire> FireSpawners;

var protected transient AudioComponent AC_FireLoop;
var protected const SoundCue FireLoopSoundCue;
var protected transient vector FireAudioGoalLocation;
var protected transient vector FireAudioLocation;

var protected PointLightComponent FireLight;
var() const protected float FireLightRadiusMultiplier;
var() const protected float MaxFireLightRadius;

/** these 2 are mapped */
var() protected const vector2d FireLightBrightnessRange;
var() protected const vector2d FireLightBrightnessNumFiresRange;

var protected transient float   LastFireLightBrightness;
var() protected const float     FireLightFlickerIntensity;
var() protected const float     FireLightFlickerInterpSpeed;

var protected transient vector  FireCentroid;
var protected transient vector  FireGoalCentroid;
var() protected const float     FireCentroidInterpSpeed;
/** How far above the surface to place centroid. */
var() protected const float     FireCentroidLoft;

var transient protected bool bMarkedForDeath;

var protected AIAvoidanceCylinder AvoidanceCylinder;

var() class<Emit_BouncyFire> FireSpawnerClass;

var Controller InstigatorController;
/** Tagged victim (world/pawn) if applicable */
var Actor TagVictim;
/** Damage type for ObstacleTag (set by GearProj) if applicable */
var class<GearDamageType> TaggedDamageType;
/** Damage type for Pawn Tagging (set by GearProj) if applicable */
var class<GearDamageType> PawnTaggedDamageType;

// avoidance interface
function bool ShouldAvoid(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	return true;
}
function bool ShouldEvade(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	// only if near the center
	return ( VSize2D(AskingAI.Pawn.Location - AvoidanceCylinder.Location) < AvoidanceCylinder.AvoidanceComp.CollisionRadius * 0.35 &&
		AskingAI.CanEvade(true) );
}
function bool ShouldRoadieRun(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	return true;
}
function CoupleLifetime(Interface_NavMeshPathObstacle PO);
event AIAvoidanceCylinderComponent GetAIAvoidanceCylinderComponent()
{
	return AvoidanceCylinder.GetAIAvoidanceCylinderComponent();
}

function SetupAvoidanceCylinder()
{
	if (AvoidanceCylinder == None && FireSpawners.length > 0)
	{
		AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder', self,, GetBestLocForAvoidanceCyl(),,, true);
		AvoidanceCylinder.SetBase(Base);
		if (AvoidanceCylinder != None)
		{
			AvoidanceCylinder.SetCylinderSize(GetAIFireRadius(), GetAIFireRadius() * 2.0);
			AvoidanceCylinder.SetEnabled(true);
		}
	}
}

function CleanupAvoidanceCylinder()
{
	if (AvoidanceCylinder != None)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = None;
	}
}

simulated event Destroyed()
{
	Super.Destroyed();
	CleanupAvoidanceCylinder();
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SetTimer(5.f, FALSE, nameof(SetOkToDie));
}

simulated protected function SetOkToDie()
{
	GotoState('OKToDie');
}

/** By default, it's 5 second, but if you'd like to change, call this
 *  This will update timer with new time **/
function SetLifeTime(float LifeTime)
{
	SetTimer(LifeTime, FALSE, nameof(SetOkToDie));
}

protected function Emit_BouncyFire SpawnFireSpawner(vector Loc, rotator Rot, vector InitialVel, vector InitialSurfaceNormal)
{
	local Emit_BouncyFire BF;

	BF = Spawn(FireSpawnerClass,,, Loc, Rot,, TRUE);
	if (BF != None)
	{
		// keep track of fires we spawned so we can set siblings later
		FireSpawners.AddItem(BF);

		// store ref to parent
		BF.ParentFireInfo = self;

		// jitter doesn't look good on round pattern
		BF.SurfaceTraceJitterAngleDeg = 0.f;

		// setup initial motion
		BF.InitVelocity(InitialVel, InitialSurfaceNormal);

		// debug rendering
		if (FireSpawnerClass.default.bDrawDebug)
		{
			DrawDebugLine(Loc, Loc + InitialVel, 255, 255, 0, TRUE);
		}
	}

	return BF;
}

simulated protected native function UpdateCoalescedFireEffects(float DeltaTime);


function float GetAIFireRadius()
{
	local vector ctr;
	local float radius;
	local Emit_BouncyFire BF;

	ctr = GetBestLocForAvoidanceCyl();

	foreach FireSpawners(BF)
	{
		if (BF != None)
		{
			radius = Max(radius,VSize(BF.Location-ctr));
		}
	}

	return radius*1.2f;
}

function vector GetBestLocForAvoidanceCyl()
{
	local vector Avg;
	local int NumSpawners;
	local Emit_BouncyFire BF;

	foreach FireSpawners(BF)
	{
		if (BF != None)
		{
			Avg += BF.Location;
			++NumSpawners;
		}
	}

	Avg /= NumSpawners;
	return Avg;
}

simulated function SpawnFire(vector HitLocation, vector HitNormal, vector InitialVelocity)
{
	if(Role == ROLE_Authority)
	{
		SetTimer(1.0f,FALSE,nameof(SetupAvoidanceCylinder));
	}
}

simulated final function AddStickyFire(Emit_StickyFire SF)
{
	SF.InstigatorController = InstigatorController;
	FireFX.AddItem(SF);
}

simulated final function RemoveStickyFire(Emit_StickyFire SF)
{
	FireFX.RemoveItem(SF);
}

simulated state OKToDie
{
	simulated function Tick( float DeltaTime )
	{
		//DrawDebugCylinder(GetBestLocForAvoidanceCyl(),GetBestLocForAvoidanceCyl(),GetAIFireRadius(),8,255,0,0);
		// update audio component

		// update light
		UpdateCoalescedFireEffects(DeltaTime);

		if (FireFX.Length == 0 && !bMarkedForDeath)
		{
			if (AC_FireLoop != None)
			{
				AC_FireLoop.FadeOut(0.3f, 0.f);
			}
			LifeSpan = 0.5f;
			bMarkedForDeath = TRUE;
			CleanupAvoidanceCylinder();
		}
	}
}

/**
 * Update the fire effects
 *
 * @param DeltaTime - the length of the last frame
 */
simulated function Tick(float DeltaTime)
{
	UpdateCoalescedFireEffects(DeltaTime);
}

defaultproperties
{
	FireCentroidLoft=32.f
	FireCentroidInterpSpeed=1.f
	FireLightRadiusMultiplier=1.5f
	MaxFireLightRadius=600

	Begin Object Class=PointLightComponent Name=FireLight0
		LightColor=(R=237,G=114,B=22,A=255)
		CastShadows=FALSE
		CastStaticShadows=FALSE
		CastDynamicShadows=FALSE
		bForceDynamicLight=FALSE
		bCastCompositeShadow=FALSE
		bEnabled=TRUE
	End Object
	Components.Add(FireLight0)
	FireLight=FireLight0

	FireLoopSoundCue=SoundCue'Weapon_Grenade.IncendiaryGrenade.IncendiaryGrenade_FireGroundLoop_Cue'

	LifeSpan=60.f   // upper bound

	FireLightBrightnessRange=(X=0.f,Y=5.f)
	FireLightBrightnessNumFiresRange=(X=0.f,Y=30.f)
	FireLightFlickerIntensity=3
	FireLightFlickerInterpSpeed=15

	FireSpawnerClass=class'Emit_BouncyFire'
}



