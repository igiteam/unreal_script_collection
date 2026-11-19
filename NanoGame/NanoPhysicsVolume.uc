/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPhysicsVolume extends PhysicsVolume
	config(Game)
	native;

var() bool bAffectsNormal;

var() bool bAffectsDusted;
var() float DustVelocityScale;

var() bool bAffectsDensed;
var() float DenseVelocityScale;

/** This is the acceleration curve for this volume **/
var() config InterpCurveFloat DesiredUpwardVelocity;

/** Particle effect that will play on the SocketToAttachEffectTo **/
var(VolumeEffect) ParticleSystem PS_EffectToPlay;
var(VolumeEffect) name SocketToAttachEffectTo;

/** Camera Lens effect to play **/
var(VolumeEffect) class<Emit_NanoCameraLensEffectBase> ScreenEffect;

/** Sound that will play on the pawn while in the volume **/
var(VolumeEffect) SoundCue SoundToPlayWhileInVolume;


native function vector GetZoneVelocityForActor(Actor TheActor);


simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local NanoPawn NP;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	NP = NanoPawn(Other);

	if( NP != none )
	{
		if( ( NP.PSC_InVolumeEffect == None ) && ( PS_EffectToPlay != None ) )
		{
			NP.PSC_InVolumeEffect = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_EffectToPlay, NP.Mesh, SocketToAttachEffectTo, TRUE );
		}

		if( ( NP.AC_InVolumeSound == None ) && ( SoundToPlayWhileInVolume != None ) )
		{
			NP.AC_InVolumeSound = new(NP) class'AudioComponent';
			if( NP.AC_InVolumeSound != none )
			{
				NP.AC_InVolumeSound.SoundCue = SoundToPlayWhileInVolume;
				NP.AttachComponent( NP.AC_InVolumeSound );
				NP.AC_InVolumeSound.FadeIn( 0.100f, 1.0f );
			}
		}

		if( ScreenEffect != None )
		{
			if( NanoPC(NP.Controller) != none )
			{
				NanoPC(NP.Controller).ClientSpawnCameraLensEffect( ScreenEffect );
			}
		}
	}
}



defaultproperties
{
	Physics=PHYS_Interpolating
	bStatic=false

	bAlwaysRelevant=true
	bReplicateMovement=true
	bOnlyDirtyReplication=true
	RemoteRole=ROLE_None

	bColored=true
	BrushColor=(R=100,G=255,B=255,A=255)

	bAffectsNormal=TRUE

	bAffectsDusted=TRUE
	DustVelocityScale=0.5

	bAffectsDensed=FALSE
	DenseVelocityScale=0.25
}
