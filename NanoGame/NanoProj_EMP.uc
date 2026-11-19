/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_EMP extends NanoProjectile
	config(Weapon);


var SoundCue FireSound;

var SoundCue EMPImpactSound;

/** The effect to play when this proj hits a wall**/
var ParticleSystem HitWallImpactEffect;

enum EFlightState
{
	Normal,
	Pausing,
	Accelerating,
};
var EFlightState FlightState;

var config int DamagePerHit;
var config int NanoDamagePerHit;

function Init( Vector Direction )
{
	Super.Init(Direction);
	SetTimer(0.1f,false,nameof(PauseFlight));
	PlaySound( FireSound );
}

function PauseFlight()
{
	FlightState = Pausing;
	SetTimer(0.3f,FALSE,nameof(AccelerateFlight));
}

function AccelerateFlight()
{
	FlightState = Accelerating;
	SetTimer(0.5f,FALSE,nameof(StopTrailEmitter));
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	if (FlightState == Pausing)
	{
		Velocity *= 0.9f;
	}
	else if (FlightState == Accelerating)
	{
		Velocity *= 1.2f;
	}
}

simulated function HandleReflectRatio( out ReflectData Data )
{
	Super.HandleReflectRatio( Data );

	DamagePerHit *= Lerp( Data.DamageScale.X, Data.DamageScale.Y, ReflectRatio );
	NanoDamagePerHit *= Lerp( Data.DamageScale.X, Data.DamageScale.Y, ReflectRatio );
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local NanoPawn NP;
	NP = NanoPawn(Other);
	if (NP != None)
	{
		NP.PlaySound( EMPImpactSound );
		if( ProximitySoundAC != None )
		{
			ProximitySoundAC.FadeOut( 0.100f, 0.0f );
			ProximitySoundAC = none;
		}
		NP.TakeDamage(DamagePerHit,Instigator.Controller,HitLocation,vect(0,0,0),MyDamageType);
        NP.ConsumeNanoPower(NanoDamagePerHit,TRUE,0.f,TRUE);
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	WorldInfo.MyEmitterPool.SpawnEmitter( HitWallImpactEffect, HitLocation );

	Super.Explode( HitLocation, HitNormal );
}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=EMPStaticMesh0
    	StaticMesh=StaticMesh'MET_PacifierMechProto.SM.S_Proto_PacifierMech_Rocket'
		HiddenGame=TRUE
        CastShadow=FALSE
		CollideActors=TRUE
		BlockActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		BlockRigidBody=FALSE
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE)
        Scale=0.3f
		Rotation=(Pitch=-16384,Yaw=0,Roll=0)
    End Object
	CollisionComponent=EMPStaticMesh0
	Components.Add(EMPStaticMesh0)

	TrailTemplate=ParticleSystem'Nano_WeaponFX.Missile.Effects.P_FX_MissileContrail_Green_Cheap'

	Speed=1000
	MaxSpeed=3000
	MyDamageType=class'NDT_EMP'
	bRotationFollowsVelocity=TRUE
	bBlockedByInstigator=FALSE
	bAddBaseVelocity=FALSE
	bProjTarget=FALSE


	ProximitySoundDistance=768.0f
	ProximitySound=SoundCue'Weapon_MetaRocket.MetaRocket.MetaRocket_EMP_WhizByCue'
	InFlightSoundTemplate=SoundCue'Weapon_MetaRocket.MetaRocket.MetaRocket_EMP_InAir_LoopCue'
	EMPImpactSound=SoundCue'Weapon_MetaRocket.MetaRocket.MetaRocket_EMP_Impact_StereoCue'
	FireSound=SoundCue'Weapon_MetaRocket.MetaRocket.MetaRocket_EMP_FireCue'
	HitWallImpactEffect=ParticleSystem'Nano_WeaponFX.EMP.Effects.P_Nano_FX_EMPImpact_Wall' 
	// dirt impact ParticleSystem'Nano_WeaponFX.EMP.Effects.P_Nano_FX_EMPImpact_Dirt' 
}
