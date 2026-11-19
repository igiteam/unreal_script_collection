/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/
class GearPawn_LambentPolypBase extends GearPawn_LocustCreatureBase
	abstract
	native(Pawn)
	config(Pawn);

/** Random variation to add to draw scale */
var float DrawScaleVariance;

var config float DeathExplosionDamageRadius;
var config float DeathExplosionDamage;

var() config float LinearFlipImpulseStrength;
var() config float StrongLinearFlipImpulseStrength;
var() config vector AngularFlipImpulse;

var bool bAllowFlipOver;

/** If true, play AttackAmbientSoundCue instead of CalmAmbientSoundCue */
var transient bool bPlayAttackAmbientSounds;
/** Ambient vocals - calm */
var(Sound) SoundCue CalmAmbientSoundCue;
/** Ambient vocals - attacking */
var(Sound) SoundCue AttackAmbientSoundCue;
/** Vocal for when we notice an enemy */
var(Sound) SoundCue NoticedEnemySoundCue;
/** Footstep sound **/
var(Sound) SoundCue FootstepLoop;
/** Vocal to play when damage is taken */
var(Sound) SoundCue PainSound;
/** Death sound */
var(Sound) SoundCue DeathSound;
/** Ambient sound for a large group of polyps */
var(Sound) SoundCue GroupAmbientSoundLoop;

/** Audio component used to play footstep audio **/
var AudioComponent FootstepComp;
/** Audio component used to play footstep audio **/
var AudioComponent GroupAmbientComp;

/** Death explosion template */
var instanced GearExplosion ExplosionTemplate;

/** Large gas emitter */
var transient ParticleSystemComponent LargeGasEffect;
var() protected const ParticleSystem LargeGasEmitterTemplate;
/** Small gas emitters */
var transient array<ParticleSystemComponent> SmallGasEffects;
var() array<Name> SmallGasSocketNames;
var() protected const ParticleSystem SmallGasEmitterTemplate;

/** Spit effects */
var ParticleSystemComponent PSC_Spit;
var ParticleSystem SpitBuildupParticleSystem;
var ParticleSystem SpitParticleSystem;
/** Spit buildup percent */
var transient float SpitBuildupPct;

var BodyStance	BS_HitReaction;

/** Controller that instigated the last melee attack against us */
var transient Controller MeleeAttacker;

// set random weight to run offset
var GearAnim_AdditiveBlending PolypRunOffset;

/** Scaling to apply to non-lambent explosive damage that we receive */
var() config float ExplosiveDamageScale;

/** MIC for polyp spit material */
var MaterialInstanceConstant Spit_MIC;

/** Index of first gib in HeadChunks array that should stick */
var int StickyGibIdx;
/** Number of gibs to spawn upon explosion */
var() int NumGibsToSpawn;
/** Number of gibs spawned so far */
var transient int NumGibsSpawned;
/** Location at which to spawn polyp gibs */
var transient vector GibSpawnLocation;

simulated function PostBeginPlay()
{
	local GearInventoryManager Inv;
	Super.PostBeginPlay();

	if( Role == ROLE_Authority )
	{
		// Add random variation to draw scale
		SetDrawScale(DrawScale + RandRange(-DrawScaleVariance, DrawScaleVariance));
	}

	StartGasEffects();
	SetTimer(1.0, TRUE, nameof(PlaySquadSounds));
	SetTimer(RandRange(2,5), FALSE, nameof(AmbientSounds));
	SetTimer( 0.25f, TRUE, nameof(PlayFootStepSounds) );
	// find PolyRunOffset
	PolypRunOffset = GearAnim_AdditiveBlending(Mesh.FindAnimNode('PolypRunOffset'));
	if (PolypRunOffset != none)
	{
		SetTimer(RandRange(3,6), TRUE, nameof(TryRunOffsetAnimation));
	}

	Spit_MIC = Mesh.CreateAndSetMaterialInstanceConstant(0);

	// we don't need accuracy updates every frame, thanks
	Inv = GearInventoryManager(InvManager);
	if( Inv != none )
	{
		Inv.bSkipAccuracyUpdates = true;
	}
}

function TakeDamage
(
	int					Damage,
	Controller			InstigatedBy,
	Vector				HitLocation,
	Vector				Momentum,
	class<DamageType>	DamageType,
	optional	TraceHitInfo		HitInfo,
	optional	Actor				DamageCauser
)
{
	if( InstigatedBy != Controller &&
		!ClassIsChildOf(DamageType,class'GDT_Silverback_Footstep') &&
		!ClassIsChildOf(DamageType,class'GDT_Silverback_SuperCurbstomp') &&
		ClassIsChildOf(DamageType,class'GDT_Melee') )
	{
		if (Health > 1)
		{
			FlipMeOver(InstigatedBy);
			// make sure we survive the hit
			Damage = Min(Health-1,Damage);
		}
		else if (`TimeSince(KnockDownStartTime) < 0.5)
		{
			// Ignore knockdown damage for a bit so it doesn't double trigger
			Damage = 0;
		}
	}
	else if( ClassIsChildOf(DamageType, class'GDT_LambentExplosion') || ClassIsChildOf(DamageType, class'GDT_PolypSpit') )
	{
		Damage = 0;
	}
	// Scale up damage from other types of explosives
	else if( ClassIsChildOf(DamageType, class'GDT_Explosive') )
	{
		Damage *= ExplosiveDamageScale;
	}

	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );

	if( Health > 0 )
	{
		PlaySound(PainSound);
	}
}

simulated function bool ShouldTorqueBowArrowGoThroughMe(GearProjectile Proj, TraceHitInfo HitInfo, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet)
{
	// Kill it and keep flying
	TakeDamage(99999.f, Proj.InstigatorController, HitLocation, vect(0,0,0), class'GDT_TorqueBow_Impact', HitInfo);
	return true;
}

simulated function PlayEnemyAcquiredSound()
{
	if( !bPlayAttackAmbientSounds )
	{
		bPlayAttackAmbientSounds = true;
		PlaySound(NoticedEnemySoundCue);
	}
}

simulated function AmbientSounds()
{
	if( bPlayAttackAmbientSounds )
	{
		PlaySound(AttackAmbientSoundCue);
	}
	else
	{
		PlaySound(CalmAmbientSoundCue);
	}
	SetTimer(RandRange(2,5),FALSE,nameof(AmbientSounds));
}

simulated function PlaySquadSounds()
{
	local GearAI_LambentPolyp PolypAI;

	PolypAI = GearAI_LambentPolyp(MyGearAI);

	if( PolypAI != None && PolypAI.bSquadLeader && PolypAI.Squad.SquadMembers.length >= 8 )
	{
		if( GroupAmbientComp == None )
		{
			GroupAmbientComp = CreateAudioComponent( GroupAmbientSoundLoop );
			if( GroupAmbientComp != None )
			{
				GroupAmbientComp.Location = Location;
				AttachComponent( GroupAmbientComp );
			}
		}

		if( GroupAmbientComp != None )
		{
			GroupAmbientComp.FadeIn(2.f, 1.f);
		}
	}
	else if( GroupAmbientComp != none )
	{
		GroupAmbientComp.FadeOut(0.5f, 0.f);
	}
}

/** Sets up ambient footstep sounds */
simulated function PlayFootStepSounds()
{
	if( (FootstepLoop != None) && (WorldInfo.NetMode != NM_DedicatedServer) )
	{
		if( VSizeSq(Velocity) > 16*16 )
		{
			if( FootstepComp == None )
			{
				FootstepComp = CreateAudioComponent( FootstepLoop );
				if ( FootstepComp != None )
				{
					FootstepComp.bAutoDestroy = TRUE;
					FootstepComp.Location = Location;
					AttachComponent( FootstepComp );
				}
			}

			if( FootstepComp != None )
			{
				FootstepComp.FadeIn(0.3f, 1.f);
			}
		}
		else if( FootstepComp != none )
		{
			FootstepComp.FadeOut(0.1f, 0.f);
		}
	}
}


/** Starts the gas effects */
simulated function StartGasEffects()
{
	local int EffectIdx, SocketIdx1, SocketIdx2;

	if (WorldInfo.NetMode != NM_DedicatedServer &&
		SmallGasEmitterTemplate != None)
	{
		// If we have a valid large gas effect, activate it
		if (LargeGasEffect != None)
		{
			LargeGasEffect.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			LargeGasEffect = new(self) class'ParticleSystemComponent';
			if (LargeGasEffect != None)
			{
				Mesh.AttachComponentToSocket(LargeGasEffect, 'Gas_Body');
				LargeGasEffect.SetTemplate(LargeGasEmitterTemplate);
				LargeGasEffect.ActivateSystem(FALSE);
			}
		}

		// If we have valid small gas effects, activate them
		if( SmallGasEffects.length > 0 )
		{
			for( EffectIdx = 0; EffectIdx < SmallGasEffects.length; ++EffectIdx )
			{
				SmallGasEffects[EffectIdx].ActivateSystem(FALSE);
			}
		}
		// If we never instanced the effects, create and activate them
		else
		{
			// Select 2 random sockets from the list to add effects to
			SocketIdx1 = Rand(SmallGasSocketNames.length);
			SocketIdx2 = Rand(SmallGasSocketNames.length - 1);
			if( SocketIdx2 >= SocketIdx1 )
			{
				++SocketIdx2;
			}

			SmallGasEffects.AddItem(new(self) class'ParticleSystemComponent');
			Mesh.AttachComponentToSocket(SmallGasEffects[SmallGasEffects.length - 1], SmallGasSocketNames[SocketIdx1]);
			SmallGasEffects[SmallGasEffects.length - 1].SetTemplate(SmallGasEmitterTemplate);
			SmallGasEffects[SmallGasEffects.length - 1].ActivateSystem(FALSE);

			SmallGasEffects.AddItem(new(self) class'ParticleSystemComponent');
			Mesh.AttachComponentToSocket(SmallGasEffects[SmallGasEffects.length - 1], SmallGasSocketNames[SocketIdx2]);
			SmallGasEffects[SmallGasEffects.length - 1].SetTemplate(SmallGasEmitterTemplate);
			SmallGasEffects[SmallGasEffects.length - 1].ActivateSystem(FALSE);
		}
	}
}

/** Destroys the gas effects */
simulated function DestroyGasEffects()
{
	local int EffectIdx;

	LargeGasEffect.DeactivateSystem();
	for( EffectIdx = 0; EffectIdx < SmallGasEffects.length; ++EffectIdx )
	{
		SmallGasEffects[EffectIdx].DeactivateSystem();
		Mesh.DetachComponent(SmallGasEffects[EffectIdx]);
		SmallGasEffects[EffectIdx] = None;
	}
	SmallGasEffects.length = 0;
}

simulated event Destroyed()
{
	DestroyGasEffects();
	Super.Destroyed();
	if( FootstepComp != none )
	{
		FootstepComp.FadeOut(0.1f,0.f);
	}
}

// Set random weight to 0-1 for every 3-6 seconds for a variety
simulated function TryRunOffsetAnimation()
{
	local float Chance;

	if ( FRand() > 0.3 )
	{
		Chance = FClamp(FRand(), 0.3f, 1.f);
	}
	else
	{
		Chance = 1.f;
	}

	PolypRunOffset.SetBlendTarget(Chance, PolypRunOffset.BlendInTime);

	//`log("TryRunOffsetAnimation: Called"@Chance);
}

simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return false;
}

function Knockdown( optional vector RBLinearVelocity, optional vector RBAngularVelocity, optional vector RadialOrigin,
			optional float RadialRadius, optional float RadialStrength, optional vector PointImpulse,
			optional vector PointImpulsePosition, optional name PointImpulseBoneName );

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	ClearTimer(nameof(AmbientSounds));
	return Super.Died(Killer,DamageType,HitLocation);
}

function bool ShouldDealDamageToEnemy()
{
	local Vector VectToEnemy;

	VectToEnemy = Controller.Enemy.Location - Location;

	// Enemy must not be too far
	if( VSize(VectToEnemy) > (CylinderComponent.CollisionRadius + Controller.Enemy.CylinderComponent.CollisionRadius) * 2.5f )
	{
		return FALSE;
	}

	// Polyp must be somewhat facing enemy
	if( Normal(VectToEnemy) dot Vector(Rotation) < 0.0f )
	{
		return FALSE;
	}

	return TRUE;
}

function ANIM_NOTIFY_DoMeleeDamage()
{
	local GearWeap_LambentPolypAttackBase Wpn;

	if( ( IsDoingSpecialMove(GSM_SwipeAttack) || IsDoingSpecialMove(GSM_PounceAttack) ) && ShouldDealDamageToEnemy() )
	{
		Wpn = GearWeap_LambentPolypAttackBase(Weapon);
		if( Wpn != None )
		{
			Wpn.DoMeleeDamage( Controller.Enemy, Controller.Enemy.Location, 1.f );
		}
	}
}

simulated function StartSpitBuildup()
{
	SpitBuildupPct = 0.f;
	if( PSC_Spit == None )
	{
		PSC_Spit = new(self) class'ParticleSystemComponent';
		PSC_Spit.SetTemplate(SpitBuildupParticleSystem);
		PSC_Spit.ActivateSystem(TRUE);
		Mesh.AttachComponentToSocket(PSC_Spit, 'Spit');
	}
	if( PSC_Spit != None )
	{
		PSC_Spit.ActivateSystem(FALSE);
	}
}

simulated function SpitAnimNotify()
{
	local GearWeap_LambentPolypAttackBase Wpn;

	if( IsDoingSpecialMove(GSM_LambentPolyp_Spit) )
	{
		Wpn = GearWeap_LambentPolypAttackBase(Weapon);
		if( Wpn != None )
		{
			if( WorldInfo.NetMode != NM_DedicatedServer )
			{
				WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(SpitParticleSystem, Mesh, 'Spit', true);
			}
			if( Controller != None )
			{
				GearAI_LambentPolyp(Controller).StartFiring(1);
			}
		}

		if( PSC_Spit != None )
		{
			SpitBuildupPct = 0.f;
			PSC_Spit.DeactivateSystem();
		}

		Spit_MIC.SetScalarParameterValue('Explo',0);
	}
}

simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore)
{
	if( GearDamageType != None &&
 		!ClassIsChildOf(GearDamageType, class'GDT_Explosive') &&
 		GearDamageType.default.bHighKickDeathAnimation )
	{
		Super.PlayRagDollDeath(GearDamageType, HitLoc, bShowGore);
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Super.PlayDying(DamageType,HitLoc);
	SetTimer( 0.01f, false, nameof(ExplodeAfterDeath) );
}


simulated function ExplodeAfterDeath()
{
	local rotator SpawnRotation;
	local GearExplosionActor ExplosionActor;

	DestroyGasEffects();

	if (Mesh != None)
	{
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionTemplate.Damage = DeathExplosionDamage * (1.f + SpitBuildupPct);
		ExplosionTemplate.DamageRadius = DeathExplosionDamageRadius * (1.f + SpitBuildupPct);
		ExplosionTemplate.ExplosionEmitterScale = 1.f + SpitBuildupPct;

		Mesh.GetSocketWorldLocationAndRotation('explo', GibSpawnLocation, SpawnRotation);

		ExplosionActor = Spawn(class'GearExplosionActor',,, GibSpawnLocation, SpawnRotation);
		ExplosionActor.InstigatorController = Controller;
		if (ExplosionActor.InstigatorController != None)
		{
			ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
		}
		ExplosionActor.Explode(ExplosionTemplate);

		SetTimer(0.01f, false, 'SpawnAPolypChunk');

		Mesh.SetHidden( TRUE );
		ExtinguishPawn();
	}
}

simulated function SpawnAPolypChunk()
{
	local Item_PolypGib PolypChunk;
	local vector RandDir;
	local int GibIdx;

	// Spawn several physics Head Chunks
	if( HeadChunks.Length > 0 &&
		NumGibsSpawned < NumGibsToSpawn )
	{
		//GibIdx = Max(1, Rand(HeadChunks.Length));
		GibIdx = RandRange(StickyGibIdx, HeadChunks.Length);
		RandDir = ( vect(1,0,0) * ( (FRand() * 2.f) - 1.f) ) + ( vect(0,1,0) * ( (FRand() * 2.f) -1.0f) ) + FRand() * vect(0,0,1);

		PolypChunk = Spawn(class'Item_PolypGib',,,GibSpawnLocation + RandDir * 30.f + vect(0,0,30), Rotation);
		if( PolypChunk != None )
		{
			PolypChunk.StaticMeshComponent.SetStaticMesh(HeadChunks[GibIdx]);

			if( GibIdx >= StickyGibIdx )
			{
				PolypChunk.bStickOnCollision = true;
			}

			PolypChunk.Velocity = RandDir * (1500.f + 200.0 * FRand());

			// turn off updating the DLE after a second
			PolypChunk.SetTimer(1.0f, false, nameof(PolypChunk.SetLightEnvironmentToNotBeDynamic));

			// Update NumGibsSpawned
			++NumGibsSpawned;

			// If we haven't spawned all gibs, set a timer to spawn another next frame
			if( NumGibsSpawned < NumGibsToSpawn )
			{
				SetTimer(0.01f, false, 'SpawnAPolypChunk');
			}
		}
	}
}

function float GetAIAccuracyModWhenTargetingMe(GearAI GuyTargetingMe)
{
	return 0.5f;
}

simulated function vector GetMeleeHitTestLocation()
{
	return Location + vect(0,0,40);
}

function bool HasArrivedAtMantleStart(Vector MoveStart)
{
	local float ArrivalDist;
	ArrivalDist = 3.0f * CylinderComponent.CollisionRadius;
	return ( VSizeSq2D(MoveStart-Location) < ArrivalDist*ArrivalDist );
}


function bool DoMantle(GearAI AI, INT Dir, vector MoveStart, vector MoveDest, CoverInfo Info)
{
	return class'AICmd_Move_NonCoverUserMantle'.static.MantleEdge( MyGearAI, Dir, MoveStart, MoveDest, Info );
}

function bool DoPreMantle(GearAI AI, INT Dir, vector MoveStart, vector MoveDest, CoverInfo Info)
{
	local vector MantleStart, MantleEnd, OffsetDir;
	if( AI.FindCommandOfClass(class'AICmd_Move_PrepareMantle') == None )
	{
		OffsetDir = Normal(MoveStart - MoveDest);
		OffsetDir.Z = 0.0f;
 		MantleStart = MoveStart + OffsetDir * 0.5f * CylinderComponent.CollisionRadius;
		MantleEnd = MoveDest - OffsetDir * 0.5f * CylinderComponent.CollisionRadius;

 		if( MyGearAI.NavigationHandle.ComputeValidFinalDestination(MantleStart) &&
 			MyGearAI.NavigationHandle.ComputeValidFinalDestination(MantleEnd) )
 		{
			MantleStart.Z += CylinderComponent.CollisionHeight;
//  		DrawDebugCoordinateSystem(MoveStart, rotator(MantleEnd-MantleStart), 25.f, true);
// 			DrawDebugSphere(MantleStart, CylinderComponent.CollisionRadius, 10, 0, 255, 0, true);
//  		DrawDebugSphere(MantleEnd, CylinderComponent.CollisionRadius, 10, 0, 255, 0, true);
		}
		if( Dir > 0 )
		{
			return class'AICmd_Move_PrepareMantle'.static.PrepareMantle( MyGearAI, 60.0f, Dir, MantleStart, MantleEnd, Info );
		}

		return class'AICmd_Move_PrepareMantle'.static.PrepareMantle( MyGearAI, 0.0f, Dir, MantleStart, MantleEnd, Info );
	}
	return false;
}

function FlipMeOver(Controller Inst)
{
	local vector Impulse;
	if( bAllowFlipOver )
	{
		MeleeAttacker = Inst;
		if(Inst != none)
		{
			Impulse = Normal((Location+vect(0,0,200))-Inst.Pawn.Location);
		}
		else
		{
			Impulse = Vector(Inst.Pawn.Rotation + rot(10,0,0));
		}

		// Use a stronger inpulse if hit during a pounce attack
		if( IsDoingSpecialMove(GSM_PounceAttack) )
		{
			Super.Knockdown(Impulse * StrongLinearFlipImpulseStrength, AngularFlipImpulse >> rotator(Impulse));
		}
		else
		{
			Super.Knockdown(Impulse * LinearFlipImpulseStrength, AngularFlipImpulse >> rotator(Impulse));
		}
	}
}

function SetMovementPhysics()
{
	SetPhysics(WalkingPhysics);
}

simulated state Dying
{
	// Overridden to get around PlayerCanSeeMe() check, since mesh is already hidden after explosion
	event Timer()
	{
		Destroy();
	}
}

state KnockedDown
{
Begin:
	// apply the impulse
	ApplyKnockdownImpulse();
	do
	{
		// delay
		Sleep(0.35f);
		// until we're snapped out of physics, stopped moving, or the physics has gone to sleep
	} until (Physics != PHYS_RigidBody || VSize(Velocity) < 32.f || !Mesh.RigidBodyIsAwake());

	// if we're still alive at this point
	if (Health > 0)
	{
		TakeDamage(Health, MeleeAttacker, Location, vect(0,0,1), class'GDT_Melee');
	}
}


defaultproperties
{
	JumpZ=3500.0
	ControllerClass=class'GearGame.GearAI_LambentPolyp'
	GearPawnFXClass=class'GearPawnFX_Lambent'

	DrawScale=0.575f
	DrawScaleVariance=0.1f

	WalkingPhysics=PHYS_Walking
	WalkableFloorZ=-1
	bCrawler=true
	LedgeCheckThreshold=60.f

	Begin Object Name=CollisionCylinder
		CollisionRadius=34.0
		CollisionHeight=44.0
	End Object

	Health=50

	bCanDoRun2Cover=false
	bCanDBNO=false
	bRespondToExplosions=false
	bAllowFlipOver=true
	bProjectilesPassThrough=true

	bSpawnBloodTrailDecals=false
	bShowFatalDeathBlood=false

	HearingThreshold=6000.f

	DurationBeforeDestroyingDueToNotBeingSeen=3.0f

	RightHandSocketName=""
	LeftHandSocketName=""

	SpecialMoveClasses(SM_Emerge_Type1)=class'GSM_Emerge'
	SpecialMoveClasses(SM_Emerge_Type2)=class'GSM_Polyp_DropEmerge'
	SpecialMoveClasses(SM_Emerge_Type3)=class'GSM_Polyp_Emerge'
	SpecialMoveClasses(SM_Emerge_Pod)=class'GSM_Polyp_Emerge'
	SpecialMoveClasses(SM_MidLvlJumpOver)=class'GSM_LambentPolyp_MantleOverCover'
	SpecialMoveClasses(SM_MantleDown)=class'GSM_LambentPolyp_MantleDown'
	SpecialMoveClasses(SM_MantleUpLowCover)=class'GSM_LambentPolyp_MantleUpLowCover'
	SpecialMoveClasses(GSM_SwipeAttack)=class'GSM_LambentPolyp_Melee'
	SpecialMoveClasses(GSM_PounceAttack)=class'GSM_LambentPolyp_PounceAttack'
	SpecialMoveClasses(GSM_LambentPolyp_Spit)=class'GSM_LambentPolyp_Spit'
	SpecialMoveClasses(GSM_Leap)=class'GSM_LambentPolyp_Leap'

	DeathAnimHighFwd=("explode_a","explode_b", "explode_down")
	DeathAnimHighBwd=("death_back")
	DeathAnimStdFwd=("explode_a","explode_b", "explode_down")
	DeathAnimStdBwd=("death_back")
	DeathAnimStdLt=("explode_left")
	DeathAnimStdRt=("explode_right")

	SmallGasSocketNames.Add(Gas_L1)
	SmallGasSocketNames.Add(Gas_L2)
	SmallGasSocketNames.Add(Gas_R1)
	SmallGasSocketNames.Add(Gas_R2)

	bNoDeathGUDSEvent=TRUE
	bForceSpecificNoticedGUDSEvent=TRUE

	BaseEyeHeight=10
	EyeHeight=10

	//NumGibsToSpawn=4

	//bPlayDeathAnimations=TRUE
	RotationRate = (Pitch=65536, Roll=65536, Yaw=65536)

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_LambentExplosion'
		MomentumTransferScale=1.f
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		DamageFalloffExponent=0.75
	End Object
	ExplosionTemplate=ExploTemplate0

	NoticedGUDSPriority=105
	NoticedGUDSEvent=GUDEvent_NoticedPolyps

	KismetDeathDelayTime=0.5f
}
