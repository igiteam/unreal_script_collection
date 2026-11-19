
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GearPawn_LambentHumanBase extends GearPawn_LocustBase
	native(Pawn)
	abstract;

/** Range of speed modifier for this pawn */
var() config vector2d SpeedModifierRange;
/** Speed modifier to apply to this pawn */
var float PawnSpeedModifier;

var config float TimeBeforeExplosion;

/** Config damage values */
var config float DeathExplosionDamage;
var config float DeathExplosionDamageRadius;

var bool bCrawling;
/** Death explosion template */
var GearExplosion ExplosionTemplate, CrawlExplosionTemplate;
/** Death explosion decal */
var() MaterialInstanceTimeVarying MITV_ScorchDecal;
var() Vector2D ScorchDecalSizeRange;
var() float ScorchDecalLifeSpan;

/** Material variants to randomly apply to the pawn */
var() protected const array<MaterialInstanceConstant> MIC_Variants;

/** Particle system for eyes */
var() protected const ParticleSystem EyeEmitterTemplate;
/** Particle system components for eye effects */
var transient ParticleSystemComponent LeftEyeEffect;
var transient ParticleSystemComponent RightEyeEffect;

/** If true, play AttackAmbientSoundCue instead of CalmAmbientSoundCue */
var transient bool bPlayAttackAmbientSounds;
/** Ambient vocals - calm */
var(Sound) SoundCue CalmAmbientSoundCue;
/** Ambient vocals - attacking */
var(Sound) SoundCue AttackAmbientSoundCue;
/** Vocal for when we notice an enemy */
var(Sound) SoundCue NoticedEnemySoundCue;
/** Footstep sound **/
var(Sound) SoundCue FootstepSound;
/** Vocal to play when damage is taken */
var(Sound) SoundCue PainSound;
/** Vocal to play before explosion */
var(Sound) SoundCue PreExplodeSound;
/** Sound to play when an attack lands */
var(Sound) SoundCue AttackImpactSoundCue;

/** Range of time between playing ambient sounds */
var() config float AmbientNoisePeriodMin;
var() config float AmbientNoisePeriodMax;

/** Scaling to apply to non-lambent explosive damage that we receive */
var() config float ExplosiveDamageScale;

/** When doing GSM_LambentHuman_Emerge, CrawlLoop should be played this number of times */
var transient int NumCrawlLoops;

replication
{
	if (bNetInitial)
		TimeBeforeExplosion;

	if (bNetDirty)
		NumCrawlLoops;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	StartEyeEffects();

	// Set material variant, which will be replicated to clients
	if( Role == ROLE_Authority )
	{
		ReplicatedMaterial = MIC_Variants[Rand(MIC_Variants.length)];
		Mesh.SetMaterial(0, ReplicatedMaterial);
	}

	PawnSpeedModifier = RandRange(SpeedModifierRange.X, SpeedModifierRange.Y);

	SetTimer(RandRange(AmbientNoisePeriodMin,AmbientNoisePeriodMax), FALSE, nameof(AmbientSounds));
}

function AddGroundSpeedVariation()
{
	GroundSpeed = DefaultGroundSpeed * PawnSpeedModifier; 
}

function bool ShouldDealDamageToEnemy(Actor Target)
{
	local Vector VectToEnemy;

	VectToEnemy = Target.Location - Location;

	// Enemy must not be too far
	if( VSize(VectToEnemy) > (5.f * GetCollisionRadius()) + GetAIMeleeAttackRange() )
	{
		return FALSE;
	}

	// Former must be somewhat facing enemy
	if( Normal(VectToEnemy) dot Vector(Rotation) < 0.0f )
	{
		return FALSE;
	}

	// Don't let them melee the target through a wall
	if( !FastTrace(Target.Location, Location) )
	{
		return FALSE;
	}

	return TRUE;
}

function ANIM_NOTIFY_DoMeleeDamage()
{
	local GearWeap_LambentHumanMelee Wpn;
	local GearMeleeTarget Target;

	Wpn = GearWeap_LambentHumanMelee(Weapon);
	if( Wpn != None && IsDoingSpecialMove(GSM_SwipeAttack) )
	{
		if( Controller.Enemy != None )
		{
			if( ShouldDealDamageToEnemy(Controller.Enemy) )
			{
				PlaySound(AttackImpactSoundCue);
				Wpn.DoMeleeDamage(Controller.Enemy, Controller.Enemy.Location, 1.f);
			}
		}
		else
		{
			foreach CollidingActors(class'GearMeleeTarget', Target, 5.f * GetCollisionRadius() + GetAIMeleeAttackRange())
			{
				if( ShouldDealDamageToEnemy(Target) )
				{
					PlaySound(AttackImpactSoundCue);
					Wpn.DoMeleeDamage(Target, Target.Location, 1.f);
				}
			}
		}
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
	if( ClassIsChildOf(DamageType, class'GDT_LambentExplosion') )
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

simulated function PlayEnemyAcquiredSound()
{
	if( !bPlayAttackAmbientSounds )
	{
		bPlayAttackAmbientSounds = true;
		PlaySound(NoticedEnemySoundCue);
	}
}

simulated function StartEyeEffects()
{
	if( WorldInfo.NetMode != NM_DedicatedServer &&
		EyeEmitterTemplate != None )
	{
		// If we never instanced the effect, create it and activate it
		if( LeftEyeEffect == None )
		{
			LeftEyeEffect = new(self) class'ParticleSystemComponent';
			if (LeftEyeEffect != None)
			{
				Mesh.AttachComponentToSocket(LeftEyeEffect, 'L_Eye');
				LeftEyeEffect.SetTemplate(EyeEmitterTemplate);
				LeftEyeEffect.ActivateSystem(FALSE);
			}
		}
		// If we never instanced the effect, create it and activate it
		if( RightEyeEffect == None )
		{
			RightEyeEffect = new(self) class'ParticleSystemComponent';
			if (RightEyeEffect != None)
			{
				Mesh.AttachComponentToSocket(RightEyeEffect, 'R_Eye');
				RightEyeEffect.SetTemplate(EyeEmitterTemplate);
				RightEyeEffect.ActivateSystem(FALSE);
			}
		}
	}
}

simulated function DestroyEyeEffects()
{
	if (LeftEyeEffect != None)
	{
		LeftEyeEffect.KillParticlesForced();
		LeftEyeEffect.DeactivateSystem();
		LeftEyeEffect = None;
	}
	if (RightEyeEffect != None)
	{
		RightEyeEffect.KillParticlesForced();
		RightEyeEffect.DeactivateSystem();
		RightEyeEffect = None;
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
	SetTimer(RandRange(AmbientNoisePeriodMin,AmbientNoisePeriodMax),FALSE,nameof(AmbientSounds));
}

simulated event PlayFootStepSound( int FootDown )
{
	local float Loudness;

	if( bPlayedDeath )
	{
		return;
	}

	if( Role == ROLE_Authority )
	{
		// Noise loudness based on movement speed
		Loudness = (VSize(Velocity) / GroundSpeed);
		MakeNoise( Loudness*Loudness*Loudness, 'NOISETYPE_FootStep' );
	}

	PlaySound( FootStepSound );
}

function bool HasArrivedAtMantleStart(Vector MoveStart)
{
	local float ArrivalDist;
	ArrivalDist = CylinderComponent.CollisionRadius;
	return ( VSizeSq2D(MoveStart-Location) < ArrivalDist*ArrivalDist );
}

function bool DoMantle(GearAI AI, INT Dir, vector MoveStart, vector MoveDest, CoverInfo Info)
{
	return class'AICmd_Move_NonCoverUserMantle'.static.MantleEdge( MyGearAI, Dir, MoveStart, MoveDest, Info );
}

function bool DoPreMantle(GearAI AI, INT Dir, vector MoveStart, vector MoveDest, CoverInfo Info)
{
	if( AI.FindCommandOfClass(class'AICmd_Move_PrepareMantle') == None )
	{
		return class'AICmd_Move_PrepareMantle'.static.PrepareMantle( MyGearAI, 2.0f * CylinderComponent.CollisionRadius, Dir, MoveStart, MoveDest, Info );
	}
	return false;
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	ClearTimer(nameof(AmbientSounds));
	return Super.Died(Killer,DamageType,HitLocation);
}

/** Don't initialize a ragdoll, since we're exploding */
simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore)
{
	SetCollision(FALSE, FALSE);
}

simulated function ReadyPawnForRagdoll();

simulated function DeathExplosion()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearExplosionActor ExplosionActor;
	local GearExplosion Template;

	if (Mesh != None)
	{
		if( bCrawling )
		{
			Template = CrawlExplosionTemplate;
		}
		else
		{
			Template = ExplosionTemplate;
		}

		Template.InitFromContentTemplate();
		Template.Damage = DeathExplosionDamage;
		Template.DamageRadius = DeathExplosionDamageRadius;
		//Mesh.GetSocketWorldLocationAndRotation('CenterLoc', BoneLoc, BoneRot);
		SpawnLocation = MatrixGetOrigin(Mesh.GetBoneMatrix(0));
		SpawnLocation.Z = Location.Z;
		SpawnRotation = Rotation;

		// Explosion effect wants Z pointed in direction of pawn, with X pointing up
		SpawnRotation.Pitch += 16384;
		SpawnRotation.Roll += 32768;
		//DrawDebugCoordinateSystem(Location, SpawnRotation, 25.f, TRUE);

		ExplosionActor = Spawn(class'GearExplosionActor',,, SpawnLocation, SpawnRotation);
		ExplosionActor.InstigatorController = Controller;
		if (ExplosionActor.InstigatorController != None)
		{
			ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
		}
		ExplosionActor.Explode(Template);

		Mesh.SetHidden(true);
		ExtinguishPawn();
		DestroyEyeEffects();
	}
}

simulated state Dying
{
	// Overridden to get around PlayerCanSeeMe() check, since mesh is already hidden after explosion
	event Timer()
	{
		Destroy();
	}

	simulated function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		PlaySound(PreExplodeSound);
		if( TimeBeforeExplosion > 0.f )
		{
			SetTimer( TimeBeforeExplosion, false, nameof(DeathExplosion) );
		}
		else
		{
			DeathExplosion();
		}
	}
}

defaultproperties
{
	ControllerClass=class'GearAI_LambentHuman'
	GearPawnFXClass=class'GearPawnFX_Former'

	RotationRate=(Pitch=45000,Yaw=100000,Roll=45000)

	bCanClimbLadders=FALSE
	bPassThroughDamage=true
	bCanDBNO=false
	bCanPlayHeadShotDeath=false
	bPlayDeathAnimations=false
	bWantChainsawKick=false
	ChainsawOverrideDeathTime=1.5

	JumpZ=3500.f

	bSpawnBloodTrailDecals=false
	bShowFatalDeathBlood=false

	DurationBeforeDestroyingDueToNotBeingSeen=4.0f

	ScorchDecalSizeRange=(X=400,Y=500)
	ScorchDecalLifeSpan=120.f

	bForceSpecificNoticedGUDSEvent=TRUE

	SpecialMoveClasses(SM_StumbleFromMelee)=class'GSM_LambentHuman_StumbleFromMelee'
	SpecialMoveClasses(SM_StumbleFromMelee2)=class'GSM_LambentHuman_StumbleFromMelee'
	SpecialMoveClasses(SM_MidLvlJumpOver)=class'GSM_LambentHuman_MantleOverCover'
	SpecialMoveClasses(SM_MantleDown)=class'GSM_LambentHuman_MantleDown'
	SpecialMoveClasses(SM_MantleUpLowCover)=class'GSM_LambentHuman_MantleUpLowCover'
	SpecialMoveClasses(SM_Emerge_Type1)=class'GSM_LambentHuman_Emerge'
	SpecialMoveClasses(GSM_SwipeAttack)=class'GSM_LambentHuman_Melee'
	SpecialMoveClasses(GSM_Leap)=class'GSM_LambentHuman_Leap'
	SpecialMoveClasses(GSM_Former_Prowl)=class'GSM_LambentHuman_Prowl'
	SpecialMoveClasses(GSM_Former_Pounce)=class'GSM_LambentHuman_Pounce'
		
	SpecialMoveClasses(SM_PushOutOfCover)=None
	SpecialMoveClasses(SM_CoverRun)=None
	SpecialMoveClasses(SM_CoverSlip)=None
	SpecialMoveClasses(GSM_CoverDestroyed)=None
	SpecialMoveClasses(SM_StdLvlSwatTurn)=None
	SpecialMoveClasses(SM_EvadeFwd)=None
	SpecialMoveClasses(SM_EvadeBwd)=None
	SpecialMoveClasses(SM_EvadeLt)=None
	SpecialMoveClasses(SM_EvadeRt)=None
	SpecialMoveClasses(SM_EvadeFromCoverCrouching)=None
	SpecialMoveClasses(SM_EvadeFromCoverStanding)=None

	SpecialMoveClasses(SM_ReviveTeammate)=None
	SpecialMoveClasses(SM_MantleKick)=None

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_LambentExplosion'
		MomentumTransferScale=1.f
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		DamageFalloffExponent=0.75
	End Object
	ExplosionTemplate=ExploTemplate0

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate1
		MyDamageType=class'GDT_LambentExplosion'
		MomentumTransferScale=1.f
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		DamageFalloffExponent=0.75
	End Object
	CrawlExplosionTemplate=ExploTemplate1

	Begin Object Name=CollisionCylinder
	    CollisionRadius=+0036.000000
		CollisionHeight=+0070.000000
	End Object

	
	KismetDeathDelayTime=0.5f
}
