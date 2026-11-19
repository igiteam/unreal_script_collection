/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoProj_DropPod extends NanoProjectile;


var ParticleSystem PS_PodExplosion;

var string  SpawnClass;
var DecalActorMovable DecalActor;

/** When this drop pod blows up we spawn some debris. **/
var StaticMesh DebrisMesh;

simulated function Destroyed()
{
	Super.Destroyed();

	if( DecalActor != None )
	{
		DecalActor.Destroy();
		DecalActor = None;
	}
}

simulated protected function SpawnTrail()
{
	Super.SpawnTrail();

	if( TrailEmitter != None )
	{
		TrailEmitter.SetDrawScale( 6.f );
	}
}
simulated function SpawnDecalActor( Vector DisplayLocation )
{
	DecalActor = Spawn( class'NanoDecal_DropPodLandingZone', self,, DisplayLocation, Rotator(vect(0,0,-1)) );
}

simulated event Landed( vector HitNormal, actor FloorActor )
{
	Explode( Location, HitNormal );
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local Nano_KActor NKA;

	if( Other != Instigator )
	{
		NKA = Nano_KActor(Other);
		if( NKA != None )
		{
//			NKA.SetPhysics(PHYS_RigidBody);
		}

		Explode( HitLocation, HitNormal );
	}
}


simulated function Explode(vector HitLocation, vector HitNormal)
{
	local NanoPawnBase NP;
	local Vector SpawnLoc;
	local Rotator SpawnRot;
	local Emitter ExplodeEmitter;
	local Vector HitLoc, HitNorm;
	local Actor HitActor;
	local DynamicSMActor_Spawnable SMActor_Spawnable;
	local class<NanoPawnBase>   ClassToSpawn;

	Super.Explode( HitLocation, HitNormal );

	PlaySound( ImpactSound );
	ExplodeEmitter = NanoGRI(WorldInfo.GRI).NOP.GetImpactEmitter(PS_PodExplosion, HitLocation, rotator(vect(0,0,1)));
	ExplodeEmitter.SetDrawScale( 4.f );
	ExplodeEmitter.ParticleSystemComponent.ActivateSystem();

	if( Role == ROLE_Authority )
	{
		HitActor = Trace( HitLoc, HitNorm, HitLocation - vect(0,0,512), HitLocation );
		if( HitActor != None )
		{
			SpawnLoc = HitLoc + vect(0,0,32);
			SpawnRot.Yaw = Rotation.Yaw;
			if( class'NavigationHandle'.static.GetPylonFromPos( SpawnLoc ) != None )
			{
				ClassToSpawn = class<NanoPawnBase>(DynamicLoadObject(SpawnClass,class'class'));
				NP = Spawn( ClassToSpawn,,, SpawnLoc, SpawnRot );
				if( NP != None )
				{
					NP.SpawnDefaultController();
					NanoGRI(WorldInfo.GRI).AIBlackboard.AddAISpawnedFromADropPod( NanoAI(NP.Controller) );
					`log( "DROP POD SPAWNED"@NP );
				}

				// need to spawn some debris and and then attach this orb to that debris
				SMActor_Spawnable = Spawn( class'DynamicSMActor_Spawnable', WorldInfo,, HitLoc+vect(64,0,0),,, TRUE );
				SMActor_Spawnable.SetStaticMesh( DebrisMesh );
				SMActor_Spawnable.LifeSpan = 0.0f;
				NanoGRI(WorldInfo.GRI).SpawnANanoOrb( class'NanoAbsorbOrb_Car', SMActor_Spawnable, TRUE );
			}
		}
	}
}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=PodStaticMesh0
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
        Scale=8.0f
		Rotation=(Pitch=-16384,Yaw=0,Roll=0)
    End Object
	CollisionComponent=PodStaticMesh0
	Components.Add(PodStaticMesh0)

	TrailTemplate=ParticleSystem'Nano_WeaponFX.Missile.Effects.P_FX_MissileContrail_White_Cheap'

	Speed=1000
	MaxSpeed=30000
	MyDamageType=class'NDT_EMP'
	bRotationFollowsVelocity=TRUE
	bBlockedByInstigator=FALSE
	bAddBaseVelocity=FALSE
	bProjTarget=FALSE

	InFlightSoundTemplate=SoundCue'Weapon_MetaRocket.MetaRocket.MetaRocket_EMP_InAir_LoopCue'
	ImpactSound=SoundCue'Weapon_MetaRocket.MetaRocket.MetaRocket_EMP_Impact_StereoCue'
	PS_PodExplosion=ParticleSystem'MET_FlyingCar01.Effects.P_Nano_FlyingCar_Destruction'

	SpawnClass="NanoGameContent.NanoPawn_MetaCorp_RiotCop"
	DebrisMesh=StaticMesh'MET_Deco_Exterior_01.SM.Mesh.S_MET_Deco_Exterior_01_StrutBase01'
}
