/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_Pacifier_Rocket extends NanoProj_ExplosiveBase
	config(Weapon);

/** Location we want to arc to after launch */
var Vector	TargetLocation;
/** Speed to accelerate toward target location */
var float	AccelToTargetMag;
/** Rocket has ignited toward target */
var bool	bIgnited;
/** Time before rocket ignites and heads toward target */
var float	IgniteTime;

var NanoDecal_PacifierRocketArea DecalActor;

var protected SoundCue LaunchedCue;


var StaticMeshComponent	StaticMeshComp;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer( IgniteTime, FALSE, nameof(Ignite) );

	PlaySound( LaunchedCue );
}

simulated function Destroyed()
{
	Super.Destroyed();

	if( DecalActor != None )
	{
		DecalActor.Destroy();
		DecalActor = None;
	}
}

function NanoProjInit( Vector Direction, optional Actor TargetActor )
{
	local NanoWeap_Pacifier_RocketPack Weap;
	local float CollisionHeight, CollisionRadius;

	Init( Direction );

	Weap = NanoWeap_Pacifier_RocketPack(Owner);
	if( Weap != None && Weap.DecalActors.Length > 0 )
	{
		DecalActor = Weap.DecalActors[0];
		Weap.DecalActors.Remove( 0, 1 );
		if( DecalActor != None )
		{
			DecalActor.Target.GetBoundingCylinder(CollisionRadius, CollisionHeight);
			TargetLocation	 = DecalActor.Location;
			TargetLocation.Z = DecalActor.Target.Location.Z - CollisionHeight;
		}
	}
}

function DropRocket()
{
	Init( vect(0,0,-1) );

	SetPhysics( PHYS_RigidBody );
	StaticMeshComp.SetBlockRigidBody( TRUE );
	StaticMeshComp.WakeRigidBody();
	StaticMeshComp.SetRBLinearVelocity( (vect(0,0,-1) + VRand()) * 32.f );

	bRotationFollowsVelocity = FALSE;
}

simulated function Ignite()
{
	StartInFlightAudio();

	if( NanoWeap_Pacifier_RocketPack(Owner) != None )
	{
		if( !bIgnited )
		{
			bIgnited = TRUE;
			if( DecalActor != None )
			{
				DecalActor.SetPhysics( PHYS_None );
				DecalActor.SetBase( None );
			}
			GotoState( 'HomeOnTarget' );
		}
	}
}

simulated state HomeOnTarget
{
	simulated function BeginState( Name PreviousStateName )
	{
		local Vector VectToTarget;

		VectToTarget = Normal(TargetLocation-Location);
		Velocity = VectToTarget * Speed * 2.f;
		Acceleration = VectToTarget * AccelToTargetMag;
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if( Physics != PHYS_RigidBody )
	{
		Super.ProcessTouch( Other, HitLocation, HitNormal );
	}
}


simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	if( Physics != PHYS_RigidBody )
	{
		Super.HitWall( HitNormal, Wall, WallComp );
	}
}

simulated function Landed( vector HitNormal, actor FloorActor )
{
	if( Physics != PHYS_RigidBody )
	{
		Super.Landed( HitNormal, FloorActor );
	}
}

event TakeDamage( int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	if( Physics == PHYS_RigidBody )
	{
		Instigator = EventInstigator.Pawn;
		TriggerExplosion( Location, vect(0,0,1), None );
	}
}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=RocketStaticMesh0
    	StaticMesh=StaticMesh'MET_PacifierMechProto.SM.S_Proto_PacifierMech_Rocket'
		HiddenGame=FALSE
        CastShadow=FALSE
		CollideActors=TRUE
		BlockActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		BlockRigidBody=FALSE
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE)
        Scale3D=(X=1.0,Y=1.0,Z=1.0)
		Rotation=(Pitch=-16384,Yaw=0,Roll=0)
    End Object
	Components.Add(RocketStaticMesh0)
	StaticMeshComp=RocketStaticMesh0
	CollisionComponent=RocketStaticMesh0

	// explosion point light
	Begin Object Class=PointLightComponent Name=ExploLight0
		Radius=400.000000
		Brightness=500.000000
		LightColor=(B=35,G=185,R=255,A=255)
		Translation=(X=16)
		CastShadows=FALSE
		CastStaticShadows=FALSE
		CastDynamicShadows=FALSE
		bForceDynamicLight=FALSE
		bEnabled=FALSE
	End Object

	// explosion
	Begin Object Class=NanoExplosion Name=ExploTemplate0
		ParticleEmitterTemplate=ParticleSystem'Nano_WeaponFX.Missile.Effects.P_FX_MissileExplosion_01'
		ExplosionSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Rocket_Explode_Cue'

		MyDamageType=class'NDT_Bomb'
		MomentumTransferScale=1.f	// Scale momentum defined in DamageType

		ExploLight=ExploLight0
		ExploLightFadeOutTime=0.17f

		bDoExploCameraAnimShake=TRUE
		ExploShakeInnerRadius=650
		ExploShakeOuterRadius=1500

		FractureMeshRadius=100.0
		FracturePartVel=300.0

		bAllowPerMaterialFX=TRUE

		bUsePerMaterialFogVolume=TRUE
	End Object
	ExplosionTemplate=ExploTemplate0

	TrailTemplate=ParticleSystem'Nano_WeaponFX.Missile.Effects.P_FX_MissileContrail_01_Cheap'
	LaunchedCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Rocket_Fire_Cue'
	InFlightSoundTemplate=SoundCue'Vehicle_PacBot.PacBot.PacBot_Rocket_InAirLoop_Cue'
	bAutoStartInFlightAudio=FALSE

	Speed=2000
	MaxSpeed=8000
	AccelToTargetMag=4000
	IgniteTime=0.2f

	MyDamageType=class'NDT_Bomb'
	bRotationFollowsVelocity=TRUE
	bBlockedByInstigator=FALSE
	bProjTarget=TRUE
}