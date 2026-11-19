/**
 * base class of Actors that fall over when hit with damage or by a vehicle
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearKnockableActor extends Actor
	abstract
	placeable;

var() editconst MeshComponent Mesh;
var() editconst LightEnvironmentComponent LightEnvironment;
var() editconst ParticleSystemComponent HitEffect;
var() SoundCue HitSound;
/** played one second after being hit */
var() SoundCue DelayedHitSound;
/** size of impulse to cause in the direction of the hit */
var() float ImpulseStrength;
/** how long to keep around after falling out of sight of the player */
var() float FallenLifetime;
/** whether this object can be knocked over by weapon damage */
var() bool bAffectedByWeapons;
/** whether we should play a camera shake when a human player crashes into this Actor */
var() bool bPlayerCollisionShake;
/** the parameters for any camera shaking */
var() GearCameraShake ShakeParams;

/** knocks down the tree, applying the appropriate starting impulse from the inputs provided */
simulated function KnockDown(vector HitLocation, vector HitDirection)
{
	Velocity = HitDirection * ImpulseStrength;
	GotoState('KnockedDown');
}

simulated event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (bAffectedByWeapons)
	{
		KnockDown(HitLocation, Normal(Momentum));
	}
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local GearPC PC;

	if (Other.Physics == PHYS_RigidBody || Other.IsA('InterpActor') || Other.IsA('SkeletalMeshActor'))
	{
		KnockDown(HitLocation, Normal(Other.Velocity));

		foreach LocalPlayerControllers(class'GearPC', PC)
		{
			if (PC.ViewTarget == Other || PC.ViewTarget.Base == Other)
			{
				PC.ClientPlayCameraShake(ShakeParams,, true);
			}
		}
	}
}

simulated state KnockedDown
{
	simulated event BeginState(name PreviousStateName)
	{
		Mesh.SetBlockRigidBody(true);
		SetPhysics(PHYS_RigidBody);
		SetCollision(false);
		HitEffect.ActivateSystem();
		PlaySound(HitSound, true);
		SetTickIsDisabled(false);
	}

	simulated event Tick(float DeltaTime)
	{
		if (WorldInfo.TimeSeconds - LastRenderTime > FallenLifetime)
		{
			GotoState('Dead');
		}
	}
Begin:
	Sleep(1.0);
	PlaySound(DelayedHitSound, true);
}

state Dead
{
	simulated event BeginState(name PreviousStateName)
	{
		SetPhysics(PHYS_None);
		Mesh.SetBlockRigidBody(false);
		SetHidden(true);
		SetTickIsDisabled(true);
	}
}

defaultproperties
{
	Begin Object Class=ParticleSystemComponent Name=HitFX
		bAutoActivate=false
		SecondsBeforeInactive=0.0
	End Object
	Components.Add(HitFX)
	HitEffect=HitFX

	TickGroup=TG_PostAsyncWork
	bCollideActors=true
	bBlockActors=true
	bCollideWorld=false
	bProjTarget=true
	FallenLifetime=10.0
	ImpulseStrength=1200.0
	bAffectedByWeapons=true
	bNoDelete=true
	bTickIsDisabled=true

	bPlayerCollisionShake=true

	Begin Object Class=GearCameraShake Name=ShakeParams0
		OscillationDuration=0.f
		RotOscillation={(Pitch=(Amplitude=150.f,Frequency=100.f,InitialOffset=EOO_OffsetZero),
						Yaw=(Amplitude=75.f,Frequency=50.f,InitialOffset=EOO_OffsetZero),
						Roll=(Amplitude=5.f,Frequency=10.f,InitialOffset=EOO_OffsetZero))}
		LocOscillation={(X=(Amplitude=2.5f,Frequency=25.f,InitialOffset=EOO_OffsetZero),
						Y=(Amplitude=1.5f,Frequency=10.f,InitialOffset=EOO_OffsetZero),
						Z=(Amplitude=4.f,Frequency=35.f,InitialOffset=EOO_OffsetZero))}
		FOVOscillation=(Amplitude=0.5f,Frequency=0.5f)
		bOverrideTargetingDampening=True
		bSingleInstance=true
	End Object
	ShakeParams=ShakeParams0

}
