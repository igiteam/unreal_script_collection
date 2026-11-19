/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GearPawn_SecurityBotFlyingBase extends GearPawn_LocustCreatureBase
	native(Pawn)
	config(Pawn)
	abstract;


/** death explosion vars */
var() instanced editinline GearExplosion PreExplosionTemplate;
var() instanced editinline GearExplosion ExplosionTemplate;
var() config float ExploDamage;
var() config float ExploDamageRadius;
var() config float ExploDamageFalloffExp;

/** Mommy, Where do bullets come from? */
var name PhysicalFireLocBoneName;

/** Whether damage effect is active or not */
var() repnotify float DamageTakenPct;
/** Whether bot is in angry mode - update colors */
var() repnotify bool bAngryBot;

/** Used to tell clients to begin the death spiral */
var transient repnotify bool bDeathSpiral;
/** Used to save the controller of the killer before the death explosion */
var transient Controller SavedKiller;

/** Percentage of default health take before damage effect shows up */
var() config float	DamageEffectPct;

/** Number of gibs to spawn upon explosion */
var() int NumGibsToSpawn;
/** Number of gibs spawned so far */
var transient int NumGibsSpawned;

/** Maximum pitch adjustment when flying */
var() config float MaxPitchAdjust;
/** Maximum roll adjustment when flying */
var() config float MaxRollAdjust;
/** Acceleration applied toward target when falling upon death */
var transient vector FallAccel;
/** Radius to check for targets to charge upon death */
var() config float KamikazeCheckRadius;
/** Acceleration to apply towards kamikaze target upon death */
var() config float KamikazeMaxSpeed;
/** Acceleration to apply towards kamikaze target upon death */
var() config float KamikazeAirAccel;

/** How much acceleration to apply when adjusting vertical climb */
var() config float VerticalClimbAccel;

/** How much friction we should have while flying */
var() config float FlyingFriction;

/** Modifies the frequency of the sin wave for bobbing */
var() config float BobbingRate;
/** Velocity at which bobbing movements occur */
var() config float MaxBobbingVelocity;

/** Used to blend in/out of attack anims */
var transient AnimNodeBlend AttackBlendNode;

/** True if the hover loop is playing */
var transient bool bPlayingHoverLoop;
/** Last time descent sound was played */
var transient float LastDescentSoundTime;
/** Last time acceleration sound was played */
var transient float LastAccelSoundTime;
/** Last time deceleration sound was played */
var transient float LastDecelSoundTime;

/** Looping sound when stationary */
var(Sound) SoundCue HoverLoopCue;
var AudioComponent HoverLoopComponent;
/** Sound to play when movement begins */
var(Sound) SoundCue FlyStartCue;
/** Looping sound when moving */
var(Sound) SoundCue FlyLoopCue;
var AudioComponent FlyLoopComponent;
/** Sound to play when movement stops */
var(Sound) SoundCue FlyStopCue;
/** Sound to play during major accelerations */
var(Sound) SoundCue FlyAccelerateCue;
/** Sound to play when decelerating to a stop */
var(Sound) SoundCue FlyApproachStopCue;
/** Sound to play when descending */
var(Sound) SoundCue FlyDropDownCue;
/** Sound to play when charging enemy */
var(Sound) SoundCue FlyPastCue;
/** Sound to play when charging enemy at low health */
var(Sound) SoundCue FlyPastAggressiveCue;
/** Sputtering sound */
var(Sound) SoundCue SputterCue;
/** Looping ound for spinning crash */
var(Sound) SoundCue SpinningCrashLoopCue;
var AudioComponent SpinningCrashLoopComponent;


/** Ambient vocal for outside of combat */
var(Sound) SoundCue AmbientVocal;
/** Ambient vocal while in combat */
var(Sound) SoundCue AmbientAttackVocal;
/** Vocal for when combat begins */
var(Sound) SoundCue AttackStartVocal;
/** Vocal for frustration */
var(Sound) SoundCue FrustrationVocal;
/** Vocal for anger */
var(Sound) SoundCue AngerVocal;
/** Looping breathing sound */
var(Sound) SoundCue BreathLoopVocal;
var AudioComponent BreathLoopComponent;
/** Vocal for when kamikaze dive begins */
var(Sound) SoundCue PreDeathVocal;
/** Vocal for death explosion */
var(Sound) SoundCue DeathVocal;
/** Vocal to play right before firing */
var(Sound) SoundCue PreAttackVocal;


/** Particle systems for gas */
var ParticleSystem PS_Gas;
var ParticleSystemComponent PSC_Gas;
/** Particle system for damaged bot */
var ParticleSystem			PS_Damage;
var ParticleSystemComponent PSC_Damage;

/** Particle system for fire */
var ParticleSystem PS_Fire;
/** Particle system component for fire */
var transient ParticleSystemComponent PSC_Fire;

/** Material instance used to glow the gunshrimp before explosion */
var MaterialInstanceConstant GlowMaterialInstance;
/** Value for Burn parameter to ramp up from pre-explode to death */
var transient float GlowValue;

/** Whether or not the bot is currently being launched */
var transient bool bIsLaunching;


cpptext
{
	virtual FLOAT GetGravityZ();
	virtual FVector NewFallVelocity(FVector OldVelocity, FVector OldAcceleration, FLOAT timeTick);
	virtual void CalcVelocity(FVector &AccelDir, FLOAT DeltaTime, FLOAT MaxSpeed, FLOAT Friction, INT bFluid, INT bBrake, INT bBuoyant);

	/** Updates movement-based sounds for gunshrimp */
	void AdjustSoundsByVelocity(const FVector& DeltaVelocity);

	UBOOL IgnoreBlockingBy( const AActor *Other ) const;
}

replication
{
	// Replicated to ALL but Owning Player
	if (Role == ROLE_Authority)
		bDeathSpiral, bAngryBot, DamageTakenPct;
}

simulated native event Vector GetPhysicalFireStartLoc( vector FireOffset );

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	AttackBlendNode = AnimNodeBlend(Mesh.FindAnimNode('AttackBlendNode'));

	StartAmbientSounds();

	PSC_Gas = new(self) class'ParticleSystemComponent';
	PSC_Gas.SetTemplate( PS_Gas );
	PSC_Gas.SetHidden( FALSE );
	PSC_Gas.ActivateSystem();
	Mesh.AttachComponentToSocket( PSC_Gas, 'Gas' );
}

simulated event ReplicatedEvent( name VarName )
{
	Super.ReplicatedEvent( VarName );

	switch( VarName )
	{
		case 'DamageTakenPct':
			PlayDamageEffect();
			break;
		case 'bAngryBot':
			if( bAngryBot )
			{
				OnAcquireEnemy();
			}
			else
			{
				OnLostEnemy();
			}
			break;
		case 'bDeathSpiral':
			GotoState('Dying');
			break;
	}
}

simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	SetDesiredRotation(MakeRotator(0, DesiredRotation.Yaw, DesiredRotation.Roll));

	if( GlowMaterialInstance != None && GlowValue < 1.0f )
	{
		// Ramp up glow over the course of 2 seconds after preexplode
		GlowValue += (DeltaTime / 2.0f);
		GlowMaterialInstance.SetScalarParameterValue('Burn', GlowValue);
	}
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional vector HitLocation)
{
	Super.WeaponFired(InWeapon, bViaReplication, HitLocation);

	// Alternate tracer between the two gun muzzles
	if( PhysicalFireLocBoneName == 'RightMuzzle' )
	{
		PhysicalFireLocBoneName = 'LeftMuzzle';
	}
	else
	{
		PhysicalFireLocBoneName = 'RightMuzzle';
	}
}

singular function BaseChange();
function AddVelocity(vector NewVelocity, vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo );
function SetMovementPhysics()
{
	if( bDeathSpiral )
	{
		SetPhysics(PHYS_Falling);
	}
	else
	{
		SetPhysics(PHYS_Flying);
	}
}

simulated function AttachWeaponToSlot(GearWeapon W);
simulated function AdjustWeaponDueToMirror();


simulated event HitWall( vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	if( bDeathSpiral )
	{
		Died(SavedKiller, class'GDT_Explosive', Location);
	}
	else if( Role == ROLE_Authority )
	{
		Super.HitWall(HitNormal,Wall,WallComp);

		SetPhysics(PHYS_Falling);
		SetTimer(0.5, false, nameof(SetMovementPhysics));
		Velocity -= (2) * HitNormal * (Velocity Dot HitNormal);

		Controller.HandlePathObstruction(Wall);
	}
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);
	if( bDeathSpiral )
	{
		if( GearPawn(Other) != None )
		{
			Died(SavedKiller, class'GDT_Explosive', Location);
		}
	}
}

simulated event Landed(vector HitNormal, Actor FloorActor)
{
	if( bDeathSpiral )
	{
		Died(SavedKiller, class'GDT_Explosive', Location);
	}
	else
	{
		Super.Landed(HitNormal, FloorActor);
	}
}

simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	Super.Bump(Other, OtherComp, HitNormal);
	if( bDeathSpiral )
	{
		Died(SavedKiller, class'GDT_Explosive', Location);
	}
}

event BumpLevel(Vector HitLocation, Vector HitNormal)
{
	Super.BumpLevel(HitLocation, HitNormal);
	if( bDeathSpiral )
	{
		Died(SavedKiller, class'GDT_Explosive', Location);
	}
}

simulated function StartAmbientSounds()
{
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		if( HoverLoopCue != None )
		{
			if( HoverLoopComponent == None )
			{
				HoverLoopComponent = CreateAudioComponent(HoverLoopCue);
				if( HoverLoopComponent != None )
				{
					HoverLoopComponent.bUseOwnerLocation = TRUE;
					AttachComponent( HoverLoopComponent );
				}
			}
			if( HoverLoopComponent != None )
			{
				HoverLoopComponent.FadeIn(0.3f, 1.f);
				bPlayingHoverLoop = TRUE;
			}
		}

		if( FlyLoopCue != None )
		{
			if( FlyLoopComponent == None )
			{
				FlyLoopComponent = CreateAudioComponent(FlyLoopCue);
				if( FlyLoopComponent != None )
				{
					FlyLoopComponent.bUseOwnerLocation = TRUE;
					AttachComponent( FlyLoopComponent );
				}
			}
		}


		if( BreathLoopVocal != None )
		{
			if( BreathLoopComponent == None )
			{
				BreathLoopComponent = CreateAudioComponent( BreathLoopVocal );
				if( BreathLoopComponent != None )
				{
					BreathLoopComponent.bUseOwnerLocation = TRUE;
					AttachComponent( BreathLoopComponent );
				}
			}
			if( BreathLoopComponent != None )
			{
				BreathLoopComponent.FadeIn(0.3f, 1.f);
			}
		}

		// Start playing ambient vocals
		//SetTimer(RandRange(5.f, 8.f), false, 'PlayAmbientVocals');
	}
}

// simulated function PlayAmbientVocals()
// {
// 	if( !bAngryBot && AmbientVocal != None )
// 	{
// 		PlaySound(AmbientVocal, true);
// 	}
// 	else
// 	if( bAngryBot && AmbientAttackVocal != None )
// 	{
// 		PlaySound(AmbientAttackVocal, true);
// 	}
// 	SetTimer(RandRange(5.f, 8.f), false, 'PlayAmbientVocals');
// }

simulated function DestroyAmbientSounds()
{
	if( HoverLoopComponent != None )
	{
		HoverLoopComponent.FadeOut(0.1f, 0.f);
	}
	if( FlyLoopComponent != None )
	{
		FlyLoopComponent.FadeOut(0.1f, 0.f);
	}
	if( BreathLoopComponent != None )
	{
		BreathLoopComponent.FadeOut(0.1f, 0.f);
	}
	if( SpinningCrashLoopComponent != None )
	{
		SpinningCrashLoopComponent.FadeOut(0.1f, 0.f);
	}
	ClearTimer('PlayAmbientVocals');
}

simulated function OnAcquireEnemy()
{
	bAngryBot = true;
	if( AttackBlendNode != None )
	{
		AttackBlendNode.SetBlendTarget(1, 0.2f);
	}
	PlaySound(AttackStartVocal);
}

simulated function OnLostEnemy()
{
	bAngryBot = false;
	if( AttackBlendNode != None )
	{
		AttackBlendNode.SetBlendTarget(0, 0.2f);
	}
	PlaySound(AngerVocal);
}

simulated function OnCharge()
{
	if( DamageTakenPct >= DamageEffectPct )
	{
		PlaySound(FlyPastAggressiveCue);
	}
	else
	{
		PlaySound(FlyPastCue);
	}
}

simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return FALSE;
}

function DoDamageEffects(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, const out TraceHitInfo HitInfo)
{
	Super.DoDamageEffects( Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo );

	DamageTakenPct = (1.f - (Health/float(DefaultHealth)));
	PlayDamageEffect();
}

simulated function PlayDamageEffect()
{
	if( DamageTakenPct >= DamageEffectPct )
	{
		if( PSC_Damage == None )
		{
			PSC_Damage = new(self) class'ParticleSystemComponent';
			PSC_Damage.SetTemplate( PS_Damage );
			Mesh.AttachComponentToSocket( PSC_Damage, 'Gas' );
			PSC_Damage.SetHidden( FALSE );
			PSC_Damage.ActivateSystem();

			PlaySound(SputterCue);
			PlaySound(FrustrationVocal);
		}
	}
}

simulated function PlayAngryEffect();

event bool EncroachingOn(Actor Other)
{
	if ( !bScriptInitialized )
	{
		return false;
	}
	return Super.EncroachingOn(Other);
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	if( !bDeathSpiral )
	{
		bDeathSpiral = true;
		SavedKiller = Killer;
		EndSpecialMove();
		DestroyAmbientSounds();
		PreDeathExplosion();
		SetPhysics(PHYS_Falling);
		class'AIcmd_Attack_Sentry_Explode'.static.InitCommand(MyGearAI);

		// Failsafe in case we are doing a death spiral and don't hit anything
		SetTimer(3.0f, false, 'DeathExplosionFailsafe');

		return false;
	}

	if( SavedKiller != None )
	{
		Killer = SavedKiller;
	}
	return Super.Died(Killer, DamageType, HitLocation);
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	PlaySound(DeathVocal);
	DeathExplosion();
	Super.PlayDying(DamageType, HitLoc);
}

/** Failsafe in case we are doing a death spiral and don't hit anything */
function DeathExplosionFailsafe()
{
	if( bDeathSpiral )
	{
		Died(SavedKiller, class'GDT_Explosive', Location);
	}
}

simulated function PreDeathExplosion()
{
	local GearExplosionActor PreExplosionActor;

	// Turn on fire trail effects
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		PSC_Fire = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(PS_Fire, Mesh, 'fire', true);
	}

	// Start the pre-death glow
	if( GlowMaterialInstance == None )
	{
		GlowValue = 0.0f;
		GlowMaterialInstance = Mesh.CreateAndSetMaterialInstanceConstant(0);
		GlowMaterialInstance.SetScalarParameterValue('Heat', 1.0f);
		GlowMaterialInstance.SetScalarParameterValue('Burn', GlowValue);
	}

	// Start pre-death sounds
	PlaySound(PreDeathVocal);
	if( SpinningCrashLoopCue != None )
	{
		if( SpinningCrashLoopComponent == None )
		{
			SpinningCrashLoopComponent = CreateAudioComponent( SpinningCrashLoopCue );
		}
		if( SpinningCrashLoopComponent != None )
		{
			SpinningCrashLoopComponent.bUseOwnerLocation = TRUE;
			AttachComponent( SpinningCrashLoopComponent );
			SpinningCrashLoopComponent.FadeIn(0.1f, 1.f);
		}
	}

	// Do the initial explosion
	PreExplosionTemplate.InitFromContentTemplate();
	PreExplosionActor = Spawn(class'GearExplosionActor', self,, Location, Rotation);
	PreExplosionActor.Explode(PreExplosionTemplate);
}

simulated function DeathExplosion()
{
	local GearExplosionActor ExplosionActor;

	ExplosionActor = Spawn(class'GearExplosionActor', self,, Location, Rotation);
	ExplosionTemplate.InitFromContentTemplate();
	ExplosionTemplate.Damage = ExploDamage;
	ExplosionTemplate.DamageRadius = ExploDamageRadius;
	ExplosionTemplate.DamageFalloffExponent = ExploDamageFalloffExp;
	ExplosionTemplate.CamShakeOuterRadius = ExploDamageRadius;

	if (SavedKiller != None)
	{
		ExplosionActor.InstigatorController = SavedKiller;
	}
	else
	{
		ExplosionActor.InstigatorController = Controller;
	}

	if (ExplosionActor.InstigatorController != None)
	{
		ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
	}
	ExplosionActor.Explode(ExplosionTemplate);

	SetTimer(WorldInfo.DeltaSeconds + 0.01, false, nameof(SpawnABloodTrail_GibExplode_360));
	SetTimer(0.01f, false, 'SpawnAGunshrimpChunk');

	Mesh.SetHidden(true);
	ExtinguishPawn();
	if( PSC_Gas != None )
	{
		PSC_Gas.DeactivateSystem();
	}
	if( PSC_Damage != None )
	{
		PSC_Damage.DeactivateSystem();
	}
	if( PSC_Fire != None )
	{
		PSC_Fire.DeactivateSystem();
	}
}

simulated state Dying
{
	// Overridden to get around PlayerCanSeeMe() check, since mesh is already hidden after explosion
	event Timer()
	{
		Destroy();
	}
}

/** Spawns gunshimp gibs, spread over several frames */
simulated function SpawnAGunshrimpChunk()
{
	local int ChunkIdx;
	local GearKActorSpawnableEffect HeadChunk;
	local vector RandDir;

	// Spawn several physics Head Chunks
	if( HeadChunks.Length > 0 )
	{
		if( NumGibsSpawned == 0 )
		{
			ChunkIdx = 0;
		}
		else
		{
			ChunkIdx = Max(1, Rand(HeadChunks.Length));
		}

		RandDir = ( vect(1,0,0) * ( (FRand() * 2.f) - 1.f) ) + ( vect(0,1,0) * ( (FRand() * 2.f) -1.0f) ) + vect(0,0,1);

		HeadChunk = Spawn(class'GearKActorSpawnableEffect',,, Location + RandDir * 10.f, Rotation);
		HeadChunk.StaticMeshComponent.SetStaticMesh(HeadChunks[ChunkIdx]);
		HeadChunk.StaticMeshComponent.WakeRigidBody();
		HeadChunk.StaticMeshComponent.SetRBCollidesWithChannel(RBCC_Pawn, TRUE);

		HeadChunk.ApplyImpulse(RandDir, 2.f + 5.f * FRand(), Location);

		HeadChunk.LifeSpan = 15.0;

		// turn off updating the DLE after a second
		HeadChunk.SetTimer(1.0f, false, nameof(HeadChunk.SetLightEnvironmentToNotBeDynamic));

		// Update NumGibsSpawned
		++NumGibsSpawned;

		// If we haven't spawned all gibs, set a timer to spawn another next frame
		if( NumGibsSpawned < NumGibsToSpawn )
		{
			SetTimer(0.01f, false, 'SpawnAGunshrimpChunk');
		}
	}
}

//Function to launch a bot into the air, used to deploy from tempest
function DoLaunch()
{
	//local GearAI_SecurityBotFlying SecBotAI;

	//SecBotAI = GearAI_SecurityBotFlying(Controller);

	//if (SecBotAI != None)
	//{
		bIsLaunching = true;
		SetCollision(FALSE,FALSE);
		//SecBotAI.CirclingHeight=500;
		Velocity.Z = 1000;
		Velocity.X = 1000;
		SetTimer(1.0,false,nameof(FinishLaunch));
	//}
}

//Recover from launch
function FinishLaunch()
{
	//local GearAI_SecurityBotFlying SecBotAI;

	//SecBotAI = GearAI_SecurityBotFlying(Controller);
	//if (SecBotAI != None)
	//{
		SetCollision(TRUE, TRUE);
		bIsLaunching = false;
	//	SecBotAI.CirclingHeight = SecBotAI.default.CirclingHeight;
	//}
}

simulated function StartBloodTrail( name TrailFuncName, optional float SpawnRate );

/** This will leave a trail of blood when you are DBNO **/
simulated function SpawnABloodTrail_DBNO();

/** This will leave a trail of blood when you are MeatBagging **/
simulated function SpawnABloodTrail_MeatBag();

/** This will leave a trail of blood when you are in cover **/
simulated function SpawnABloodTrail_Wall();

/** This will leave a trail of blood on the ground when you chainsaw someone **/
simulated function SpawnABloodTrail_ChainsawSpray_Ground();

/** This will leave a trail of blood on the wall when you chainsaw someone **/
simulated function SpawnABloodTrail_ChainsawSpray_Wall();

/** This will leave a trail of blood on the wall when you chainsaw someone **/
simulated function SpawnABloodTrail_GibImpact( vector HitLoc );

/** This will leave a trail of blood from your headshot stump **/
simulated function SpawnABloodTrail_HeadShot();

/** This will leave a small splat of blood **/
simulated function SpawnABloodTrail_HitByABullet();

/** This will leave some blood as we are really hurt **/
simulated function SpawnABloodTrail_PawnIsReallyHurt();

/** This will leave some blood when one of our limbs brealks **/
simulated function SpawnABloodTrail_LimbBreak( vector InStartLocation );

/** Allow pawns to tweak their acceleration while flying */
function AdjustFlyingAcceleration()
{
	local GearPC GPC;
	local GearPlayerInput GPI;

	if (!bDeathSpiral)
	{
		GPC = GearPC(Controller);
		GPI = GearPlayerInput(GPC.PlayerInput);
		if (GPI != None)
		{
			if (GPI.IsButtonActive(GB_A))
			{
				Acceleration.Z -= VerticalClimbAccel;
			}
			else if (GPI.IsButtonActive(GB_B))
			{
				Acceleration.Z += VerticalClimbAccel;
			}
		}
	}
}

/** @return FALSE bc we cannot melee */
simulated function bool CanEngageMelee()
{
	return FALSE;
}

defaultProperties
{
	AccelRate=1024.f
	bCanDoRun2Cover=false
	AirSpeed=500.f
	bLimitFallAccel=false
	RotationRate=(Pitch=20000,Yaw=20000,Roll=20000)
	HearingThreshold=6000.f
	bCanFly=true
	bCanDBNO=false

	AirControl=+0.5

	DurationBeforeDestroyingDueToNotBeingSeen=4.0f
	
	NumGibsToSpawn=4

	SpecialMoveClasses(SM_StumbleBackOutOfCover)=class'GSM_Sentry_HitReact'
	SpecialMoveClasses(SM_DeathAnim)=class'GSM_Sentry_Kamikaze'

	/*
	bPlayDeathAnimations=true
	DeathAnimHighFwd=("Explode_Up")
	DeathAnimHighBwd=("Explode_down")
	DeathAnimStdFwd=("Explode_Out")
	DeathAnimStdBwd=("Explode_down")
	DeathAnimStdLt=("Explode_left")
	DeathAnimStdRt=("Explode_right")
	*/

	// Initial explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_ShriekerExplosion'
		MomentumTransferScale=1.0
		FractureMeshRadius=120.0
		FracturePartVel=500.0
	End Object
	PreExplosionTemplate=ExploTemplate0

	// Destoy explosion
	Begin Object Class=GearExplosion Name=ExploTemplate1
		MyDamageType=class'GDT_ShriekerExplosion'
		MomentumTransferScale=1.0
		FractureMeshRadius=120.0
		FracturePartVel=500.0
	End Object
	ExplosionTemplate=ExploTemplate1

	BaseEyeHeight=20
	EyeHeight=20
}
