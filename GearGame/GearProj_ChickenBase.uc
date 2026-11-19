/**
 * Chicken Launcher Projectile
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_ChickenBase extends GearProj_ExplosiveBase
	config(Weapon);

/** Mesh used for rendering */
var() SkeletalMeshComponent Mesh;

var Material MegaChickenSkin;

/** How many bomblets to spawn when I explode */
var() config int				NumBombletsToSpawn;
/** How many bomblets to spawn when I explode from an AR shot */
var() config int				NumBombletsToSpawnActiveReload;
var() config array<vector2d>	BombletMinMaxLifespans;

/** Essentially just an .ini-exposed version of the Speed var.*/
var() config const float		RocketLaunchSpeed;

var repnotify bool bDelayedArc;

var transient Actor	ImpactActor;

var protected const class<GearProj_ChickenBombletBase> BombletClass;


replication
{
	if (bNetInitial)
		bDelayedArc;
}

simulated function PreBeginPlay()
{
	// location is important as this needs to be set before AI warning code in base implementation
	Speed = RocketLaunchSpeed;

	Super.PreBeginPlay();
}

function Init(vector Direction)
{
	Super.Init(Direction);
	if (Role == ROLE_Authority && Instigator != None && Instigator.IsHumanControlled())
	{
		DelayArc();
	}
}

simulated function DelayArc()
{
	bDelayedArc = true;
	Acceleration = vect(0,0,0);
	SetTimer(0.25f, false, nameof(StartArcing));
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(bDelayedArc))
	{
		if (bDelayedArc)
		{
			DelayArc();
		}
		else if (IsTimerActive(nameof(StartArcing)))
		{
			ClearTimer(nameof(StartArcing));
			StartArcing();
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function StartArcing()
{
	Acceleration.Z = GetGravityZ() * GravityScale;
	bDelayedArc = false;
}


simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	// ignore hits to self and/or dead people
	if ( Other != Instigator && !Other.bTearOff && (!Other.IsA('Projectile') || Other.bProjTarget) )
	{
		TriggerExplosion(HitLocation, HitNormal, Other);
	}
}


simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	// This is called when projectiles hit vehicles - ignore projectiles launched from yourself
	if(Wall != Instigator)
	{
		TriggerExplosion(Location, HitNormal, Wall);
	}
}

simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local vector					    BombletDir, SpawnLocation;
	local GearProj_ChickenBombletBase	SpawnedBomblet;
	local float						    ImpactActorDamage;
	local int						    Idx;
	local GearPawn					    HitGP;
	local GearVehicle				    HitGV;
	local GearExplosionActor            GEA;
	local TraceHitInfo                  HitInfo;
	local Vector                        HL, HN;
	local Actor                         HA;

	// If we hit a hostage, then don't do anything special, he's going to die.
	// Otherwise spare that actor, and do special processing below.
	HitGP = GearPawn(HitActor);
	HitGV = GearVehicle(HitActor);
	if ((HitGP != None && !HitGP.IsAHostage()) || HitGV != None)
	{
		ImpactActor = HitActor;
	}

	//`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "HitActor:" @ HitActor @ "ImpactActor:" @ ImpactActor);
	//ScriptTrace();

	// do normal explosion
	GEA = Super.TriggerExplosion(HitLocation, HitNormal, HitActor);

	// now do extra stuff
	if( Role == ROLE_Authority )
	{
		SpawnLocation = HitLocation + (HitNormal * 15.f);

		// spawn the bomblets
		for (Idx=0; Idx<NumBombletsToSpawn; ++Idx)
		{
			SpawnedBomblet = Spawn(BombletClass, Instigator,, SpawnLocation,,,true);
			if (SpawnedBomblet != None)
			{
				SpawnedBomblet.Instigator = Instigator;
				SpawnedBomblet.InstigatorController = InstigatorController;
				SpawnedBomblet.bSuppressAudio = bSuppressAudio;

				SpawnedBomblet.LifeSpan = RandRange(BombletMinMaxLifespans[Idx].X, BombletMinMaxLifespans[Idx].Y);
				SpawnedBomblet.TimeTilExplosion = SpawnedBomblet.LifeSpan;


				BombletDir = ( vect(1,0,0) * ( (FRand() * 2.f) - 1.f) ) + ( vect(0,1,0) * ( (FRand() * 2.f) -1.0f) ) + vect(0,0,1);
				BombletDir = Normal(BombletDir);

				SpawnedBomblet.Init(BombletDir);
			}
		}

		// For the actor that was hit, apply damage directly (he was ignored in the radial damage) - unless it was a kidnapper (meatshield absorbed the damage). Use the post-scaled damage
		ImpactActorDamage = ExplosionTemplate.Damage;

		HA = Trace( HL, HN, Location + Vector(Rotation) * 32.f, Location, TRUE,, HitInfo, TRACEFLAG_Bullet );
		if( HA == ImpactActor )
		{
			ImpactActor.TakeDamage(ImpactActorDamage, InstigatorController, HitLocation, vector(Rotation), ExplosionTemplate.MyDamageType, HitInfo, self);
		}
		else
		{
			ImpactActor.TakeDamage(ImpactActorDamage, InstigatorController, HitLocation, vector(Rotation), ExplosionTemplate.MyDamageType,, self);
		}
	}

	return GEA;
}

static simulated function float StaticGetTimeToLocation(vector TargetLoc, vector StartLoc, Controller RequestedBy)
{
	return (VSize(TargetLoc - StartLoc) / default.RocketLaunchSpeed);
}

defaultproperties
{
	GravityScale=0.2

	Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
		BlockActors=false
		bCastDynamicShadow=false
		BlockZeroExtent=true
		BlockNonZeroExtent=false
		CollideActors=true
		BlockRigidBody=true
		RBCollideWithChannels=(Default=true,Untitled2=true)
		Scale=1.5
		LightEnvironment=MyLightEnvironment
		bAcceptsDynamicDecals=false
    End Object
	Mesh=SkeletalMeshComponent0
	Components.Add(SkeletalMeshComponent0)


	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_ChickenProjectile'
		MomentumTransferScale=1.0
		FractureMeshRadius=100.0
		FracturePartVel=300.0
		bAllowPerMaterialFX=FALSE
		bUsePerMaterialFogVolume=TRUE
		ExplosionEmitterScale=3.f
	End Object
	ExplosionTemplate=ExploTemplate0
}


