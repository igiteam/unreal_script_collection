/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearChainedTicker extends Actor
	abstract
	placeable;

/** mesh for the chain */
var SkeletalMeshComponent ChainMesh;
/** mesh for the ticker (detect damage on this component to blow it up) */
var SkeletalMeshComponent TickerMesh;
/** list of bones in the chain mesh that should be set to fixed at startup */
var array<name> FixedChainBoneNames;
/** swap skeletal mesh in ChainMesh to this after the ticker blows up */
var SkeletalMesh DamagedChainMesh;

/** one of these sounds is chosen at random when shooting something other than the ticker (knocking it around) */
var array<SoundCue> TickerChatterSounds;
/** next time we can play a chatter sound (wait until currently playing one is done) */
var float NextChatterSoundTime;
/** sound played when ticker first gets shot */
var SoundCue TickerAngrySound;
/** sound played when ticker is about to explode */
var SoundCue TickerPreExplodeSound;

var SoundCue AmbientSoundCue;
var() float MinAmbientChatterReplayTime;
var() float MaxAmbientChatterReplayTime;

/** ticker explosion effect */
var GearExplosion ExplosionTemplate;

/** current speed of ticker when falling */
var float TickerFallSpeed;
/** current speed of ticker rotation when falling */
var rotator TickerFallRotation;

/** state of the ticker on the end of the chain */
enum EChainedTickerState
{
	CTS_Normal,
	CTS_Exploding,
	CTS_Dead
};
var repnotify EChainedTickerState TickerState;
/** used to force reset on clients even when state hasn't changed */
var repnotify bool bReset;

var int ChainHealth;

replication
{
	if (bNetDirty)
		TickerState, bReset;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	ChainMesh.AttachComponentToSocket(TickerMesh, 'Attach');
	TickerMesh.PlayAnim('hanging_idle',, true);

	ChainMesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
	ChainMesh.PhysicsAssetInstance.SetNamedBodiesFixed(true, FixedChainBoneNames, ChainMesh);
	ChainMesh.WakeRigidBody();

	PlayChatterSound();
}

/** applies changes to the TickerState variable (triggers effects, etc) */
simulated final function ApplyTickerState()
{
	switch (TickerState)
	{
		case CTS_Normal:
			TickerMesh.SetTranslation(default.TickerMesh.Translation);
			TickerMesh.SetRotation(default.TickerMesh.Rotation);
			TickerMesh.SetAbsolute(false, false);
			TickerMesh.SetHidden(false);
			ClearTimer(nameof(PlayExplodeAnimPart2));
			ClearTimer(nameof(TickerExplode));
			ChainMesh.SetSkeletalMesh(default.ChainMesh.SkeletalMesh);
			ChainMesh.PhysicsWeight = 0.0;
			ChainMesh.ForceSkelUpdate();
			ChainMesh.UpdateRBBonesFromSpaceBases(true, true);
			ChainMesh.SetRBLinearVelocity(vect(0,0,0), false);
			ChainMesh.PhysicsWeight = 1.0;
			break;
		case CTS_Exploding:
			TickerFallSpeed = 0.0;
			TickerFallRotation.Pitch = RandRange(-8192, 8192);
			TickerFallRotation.Pitch += (TickerFallRotation.Pitch < 0) ? -4096 : 4096;
			TickerFallRotation.Yaw = RandRange(-8192, 8192);
			TickerFallRotation.Yaw += (TickerFallRotation.Yaw < 0) ? -4096 : 4096;
			TickerFallRotation.Roll = RandRange(-8192, 8192);
			TickerFallRotation.Roll += (TickerFallRotation.Roll < 0) ? -4096 : 4096;
			TickerMesh.SetTranslation(TickerMesh.GetPosition());
			TickerMesh.SetRotation(TickerMesh.GetRotation());
			TickerMesh.SetAbsolute(true, true);
			TickerMesh.SetHidden(false);
			TickerMesh.PlayAnim('charge_fwd');
			PlaySound(TickerAngrySound, true);
			SetTimer(AnimNodeSequence(TickerMesh.Animations).GetAnimPlaybackLength(), false, nameof(PlayExplodeAnimPart2));
			break;
		case CTS_Dead:
			ClearTimer(nameof(PlayExplodeAnimPart2)); // if we're already in the second part, allow the client to do the explosion
			TickerMesh.SetHidden(true);
			ChainMesh.SetSkeletalMesh(DamagedChainMesh);
			break;
	}
}

/** called after the first explode anim on the ticker has played, start the second one to complete the explosion sequence */
simulated final function PlayExplodeAnimPart2()
{
	TickerMesh.PlayAnim('Explode');
	PlaySound(TickerPreExplodeSound, true);
	SetTimer(AnimNodeSequence(TickerMesh.Animations).GetAnimPlaybackLength(), false, nameof(TickerExplode));
}

/** called after the ticker has played its explosion anim and should blow up */
simulated final function TickerExplode()
{
	local GearExplosionActor ExplosionActor;

	// spawn explosion
	ExplosionTemplate.InitFromContentTemplate();
	ExplosionActor = Spawn(class'GearExplosionActor', self,, TickerMesh.GetPosition(), TickerMesh.GetRotation());
	ExplosionActor.Explode(ExplosionTemplate);

	ClearTimer(nameof(TickerExplode));
	TickerState = CTS_Dead;
	ApplyTickerState();
}

/** resets the ticker to the idle animation after playing the hit reaction */
simulated final function ReturnToIdleAnim()
{
	if (TickerState == CTS_Normal)
	{
		TickerMesh.PlayAnim('hanging_idle',, true);
	}
}

simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local vector ApplyImpulse;
	local SoundCue ChatterSound;
	local bool bDrop;

	// call Actor's version to handle any SeqEvent_TakeDamage for scripting
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	if( Damage > 0 )
	{
		bDrop = HitInfo.HitComponent == TickerMesh || ClassIsChildOf(DamageType, class'GDT_Explosive');
		if( !bDrop )
		{
			ChainHealth -= Damage;
			bDrop = ChainHealth <= 0;
		}

		if( bDrop )
		{
			if (Role == ROLE_Authority && TickerState == CTS_Normal)
			{
				TickerState = CTS_Exploding;
				bForceNetUpdate = true;
				ApplyTickerState();
			}
			// redirect to chain so it also has a physics effect
			HitInfo.HitComponent = ChainMesh;
			HitInfo.BoneName = 'Ticker_Chain_16';
		}

		if (DamageType.default.KDamageImpulse > 0 && !IsZero(Momentum))
		{
			// Make sure we have a valid TraceHitInfo with our SkeletalMesh
			// we need a bone to apply proper impulse
			CheckHitInfo(HitInfo, ChainMesh, Normal(Momentum), HitLocation);

			ApplyImpulse = Normal(Momentum) * DamageType.default.KDamageImpulse;
			if (HitInfo.HitComponent != None)
			{
				HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);
			}

			if (TickerState == CTS_Normal)
			{
				TickerMesh.PlayAnim('hanging_react');
				if (WorldInfo.TimeSeconds > NextChatterSoundTime)
				{
					ChatterSound = TickerChatterSounds[Rand(TickerChatterSounds.length)];
					PlaySound(ChatterSound, true);
					NextChatterSoundTime = WorldInfo.TimeSeconds + ChatterSound.GetCueDuration();
				}
				SetTimer(AnimNodeSequence(TickerMesh.Animations).GetAnimPlaybackLength(), false, nameof(ReturnToIdleAnim));
			}
		}
	}
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(TickerState) || VarName == nameof(bReset))
	{
		ApplyTickerState();
	}
}

simulated event Tick(float DeltaTime)
{
	local vector PosChange, HitLocation, HitNormal;

	if (TickerState == CTS_Exploding)
	{
		// very simple falling physics for ticker mesh
		TickerFallSpeed += GetGravityZ() * DeltaTime;
		PosChange.Z = TickerFallSpeed * DeltaTime;
		if (Trace(HitLocation, HitNormal, TickerMesh.GetPosition() + PosChange, TickerMesh.GetPosition(), false, vect(20,20,20)) != None)
		{
			TickerExplode();
		}
		else
		{
			TickerMesh.SetTranslation(TickerMesh.Translation + PosChange);
			TickerMesh.SetRotation(TickerMesh.Rotation + TickerFallRotation * DeltaTime);
		}
	}
}

function OnResetChainedTicker(SeqAct_ResetChainedTicker Action)
{
	if (TickerState != CTS_Normal)
	{
		TickerState = CTS_Normal;
	}
	else
	{
		// use the flag to force a reset on clients
		bReset = !bReset;
	}
	ApplyTickerState();
}



simulated function PlayChatterSound()
{
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		PlaySound(AmbientSoundCue, true);

		SetTimer( RandRange(MinAmbientChatterReplayTime,MaxAmbientChatterReplayTime), FALSE, nameof(PlayChatterSound) );
	}
}


defaultproperties
{
	Physics=PHYS_Interpolating
	RemoteRole=ROLE_SimulatedProxy
	NetUpdateFrequency=1.0
	bNoDelete=true
	bCollideActors=true
	bBlockActors=true
	bProjTarget=true
}
