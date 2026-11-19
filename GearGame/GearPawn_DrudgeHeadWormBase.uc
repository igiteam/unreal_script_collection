//=============================================================================
// DrudgeHeadWormBase
//
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class GearPawn_DrudgeHeadWormBase extends GearPawn
	abstract
	native(Pawn)
	config(Pawn);

/** cached reference to the tail skel control */
var transient GearSkelCtrl_DrudgeHeadWorm TailSkelCtrl;
/** period (in world units) of the lateral sway as we move */
var() float MovementLateralSwayPeriod;
/** distance to move laterally during lateral sway */
var() float MovementLateralSwayLatOffset;

var() int RotationClamp;

/** Death explosion template */
var GearExplosion ExplosionTemplate;
/** Config damage values */
var config float DeathExplosionDamage;
var config float DeathExplosionDamageRadius;
/** Time delay between death and explosion */
var config float TimeBeforeExplosion;
/** Avoidance cylinder for explosion */
var protected AIAvoidanceCylinder AvoidanceCylinder;

/** Last time this creature took damage */
var transient float LastDamageTime;

/** Vocal for detaching from drudge body (Plays on spawn) */
var() SoundCue DetachVocal;
/** Pain vocal */
var() SoundCue PainVocal;
/** Ambient vocals */
var() SoundCue AmbientVocal;
var() SoundCue AngerVocal;
var() SoundCue ScreamVocal;
/** Death Vocal */
var() SoundCue DeathVocal;

/** Death sound */
var() SoundCue DeathSound;
/** Slithering sound loop */
var() SoundCue SlitherLoop;
/** Audio component used to play slither audio **/
var AudioComponent SlitherComp;
/** Impact sound */
var() SoundCue ImpactSound;

/** Flamethrower breath */
var protected const class<FlameThrowerSprayBase> FlameSprayClass;
var protected transient FlameThrowerSprayBase FlameThrower;
var repnotify transient bool bFireSprayOn;

/** Death explosion decal */
var() MaterialInstanceTimeVarying MITV_ScorchDecal;
var() Vector2D ScorchDecalSizeRange;
var() float ScorchDecalLifeSpan;

/** Goo Emitters */
var transient array<ParticleSystemComponent> GooEffects;
var() protected const ParticleSystem GooEmitterTemplate;

/** Name of headbone **/
var name HeadBoneName;
/** Move Speed Modifier during fire **/
var config float FiringMoveSpeedModifier;

/** Look At Control to Head_Creature_Head **/
var transient SkelControlLookAt LookAtControl;

/** Client didn't have target info. Now replicate **/
var repnotify transient GearPawn HeadWormTarget;

/** Head worm dies before even reaching floor turning them to rigidbody and disappear
 *  So prevent damage during that stage. Thought of checking Flying state, but flying state can happen not only that time. **/
var transient bool bSpawnedAndLanded;

/** related to hit ramp values **/
var transient float CurrentProjectileHeatRampValue;
var transient float HeatRampIncrement;
var() config float  HeatRampMaxValue;
var() config float  HeatRampMinValue;

var	class<Projectile> 	MouthProjectile;
/** Min/Max pitch for camera when displaying the grenade aiming arc. */
var() const vector2d			GrenadeAimingCameraPitchLimit;

cpptext
{
	virtual UBOOL GetMoveDelta(FVector& out_Delta, const FVector& Dest);
	virtual FLOAT MaxSpeedModifier();
};

replication
{
	if (bNetInitial)
		TimeBeforeExplosion;
	if (Role == ROLE_Authority)
		bFireSprayOn, HeadWormTarget;
}

/** replicated event */
simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
	case 'bFireSprayOn':
		if( bFireSprayOn )
		{
			StartFireSpray();
		}
		else
		{
			StopFireSpray();
		}
		break;
	}
	Super.ReplicatedEvent(VarName);
}


simulated event PostBeginPlay()
{
	local vector FireStartLocation;
	local rotator FireStartRotation;

	Super.PostBeginPlay();

	FireStartLocation = Mesh.GetBoneLocation(HeadBoneName);
	FireStartRotation = QuatToRotator(Mesh.GetBoneQuaternion(HeadBoneName));
	FlameThrower = Spawn(FlameSprayClass, Controller,, FireStartLocation, FireStartRotation );
	FlameThrower.SetBase(self,, Mesh, HeadBoneName);

	PlaySound(DetachVocal);
	PlaySlitherSounds();
	SetTimer(RandRange(2.f, 5.f), false, 'PlayAmbientVocals');

	StartGooEffects();
	// Start Timer for trail
	SetTimer(0.25f, true, 'SpawnTrail');

	// set min value
	StopHeatRamp();
}

// Spawn movement trail
simulated function SpawnTrail()
{
	if ( VSizeSq(Velocity) > 0 )
	{
		GearPawnFX.SpawnAHeadwormTrail();
	}
}

// Face head to target (head worm target)
 simulated function FaceFireToTarget()
 {
 	local Rotator TargetRotation;
 	local Vector BoneLocation;
	local int BoneIdx;
	local Matrix BoneMatrix;
	local Quat DeltaQuat, TargetQuat, BoneQuat;

	if( HeadWormTarget != None )
	{
		BoneIdx = Mesh.MatchRefBone(HeadBoneName);
		// The way relative rotation works is
		// based on the bones, not socket
		// So I changed based to bone and use relative to be target - bone
		// FIXME: I think this code can be cleared a lot better - i.e. do it in native
		BoneMatrix = Mesh.GetBoneMatrix(BoneIdx);
		BoneLocation = MatrixGetOrigin(BoneMatrix);
		BoneQuat = QuatFromRotator(MatrixGetRotator(BoneMatrix));

		// aim for 30 below of pawn
		if (FastTrace(HeadWormTarget.Location + vect(0, 0, -30), BoneLocation))
		{
  			TargetRotation = Rotator(HeadWormTarget.Location + vect(0, 0, -30) - BoneLocation);
		}
		else
		{
			TargetRotation = Rotator(HeadWormTarget.Location - BoneLocation);
		}

		TargetQuat = QuatFromRotator(TargetRotation);
		DeltaQuat = QuatProduct(QuatInvert(BoneQuat), TargetQuat);

 		FlameThrower.SetRelativeRotation(QuatToRotator(DeltaQuat));

		//FlushPersistentDebugLines();
		//DrawDebugLine(BoneLocation, HeadWormTarget.Location, 255, 0, 0, TRUE);
		//DrawDebugCoordinateSystem(BoneLocation, TargetRotation, 200, TRUE);
	}
}

simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return FALSE;
}

function SpawnFire( vector FireLoc )
{
	local GearFireInfo_Wedge GFI;
	local vector LastVel, HitLoc, HitNormal, StartLoc;

	StartLoc = FlameThrower.Location;

	// trace down from fireloc
	if ( Trace( HitLoc, HitNormal, FireLoc, FireLoc+vect(0, 0, -100) ) == none )
	{
		HitLoc = FireLoc;
		HitNormal = vect(0, 0, 1);
		LastVel = (Location-StartLoc);
	}
	else
	{
		LastVel = (HitLoc-StartLoc);
	}

	GFI = Spawn(class'GearFireInfo_Wedge');
	if (GFI != None)
	{
		GFI.SetLifeTime(1.f);
		GFI.InstigatorController = Controller;
		GFI.SpawnFire(HitLoc, HitNormal, LastVel);
		//DrawDebugSphere(HitLoc, 30.f, 5, 255, 0, 0, TRUE );
	}
}

event Landed( vector HitNormal, actor FloorActor )
{
	Super.Landed(HitNormal, FloorActor);
	SetPhysics(WalkingPhysics);
	PlaySound(ImpactSound);

	bSpawnedAndLanded = TRUE;
}

/** Cache additional animation nodes. */
simulated function CacheAnimNodes()
{
	Super(GearPawn).CacheAnimNodes();
	TailSkelCtrl = GearSkelCtrl_DrudgeHeadWorm(Mesh.FindSkelControl('tail_control'));
	TailSkelCtrl.SetSkelControlStrength(1.f, 0.f);
	LookAtControl = SkelControlLookAt(Mesh.FindSkelControl('LookAt'));
	LookatControl.SetSkelControlActive(FALSE);
}

// at the end of fire start animation, play this
simulated function StartFireSpray()
{
	if (MyGearAI!=none)
	{
		HeadWormTarget = GearPawn(MyGearAI.Enemy);
	}

	bFireSprayOn = true;

	StartHeatRamp();
	SetTimer(0.4f, false, 'StartFlame');
}

// now start flame
simulated function StartFlame()
{
	FaceFireToTarget();
//	FlameThrower.BeginSpray();
//	SetTimer(0.5f, false, 'SpawnFireOnGround');
	SpawnProjectile();
}

/** We vary toss velocity somewhat, based on the pitch of the throw. */
simulated protected function vector GetGrenadeTossVelocity(vector Start, vector TossDir, GearProj_Grenade NadeProj)
{
	local float Pct;
	local vector Vel, TargetLoc;
	local vector2d VelRange;
	local GearPawn GP;
	local GearAI AI;
	local vector2d			GrenadeVelRange;
	
	GrenadeVelRange.X = 500;
	GrenadeVelRange.Y = 1750;

	AI = GearAI(Controller);
	if (AI != None)
	{
		TargetLoc = (AI.Focus == AI.FireTarget || AI.Focus == None) ? AI.GetFocalPoint() : AI.GetFireTargetLocation();
		if (AI.Enemy != None)
		{
			// aim at feet, unless enemy is in low cover; in that case we need to aim higher to get over the cover
			GP = GearPawn(AI.Enemy);
			if (GP == None || !GP.IsInCover() || GP.CoverType != CT_MidLevel)
			{
				TargetLoc.Z -= AI.Enemy.GetCollisionHeight();
			}
		}

		AI.SuggestTossVelocity(Vel, TargetLoc, Start, (GrenadeVelRange.Y) * 1.2, Instigator.Velocity.Z, 0.45);
	}
	else
	{
		VelRange = GrenadeVelRange;

		Pct = FClamp(GetRangePctByValue(GrenadeAimingCameraPitchLimit, rotator(TossDir).Pitch), 0.f, 1.f);
		//Pct = Pct**GrenadeVelRangePow;
		Vel = Normal(TossDir) * GetRangeValueByPct(VelRange, Pct);

		if ( (NadeProj != None) && NadeProj.bAddBaseVelocity)
		{
			Vel += NadeProj.InitialFrameOfRefVelocity;
		}
	}

	return Vel;
}
function SpawnProjectile()
{
	local GearProj_Grenade NadeProj;
	local vector SpawnLoc;
	local vector SimulationDir;

//	SimulationDir = Normal(GetGrenadeTossDirection(SimulationStart));
	SimulationDir = Normal(HeadWormTarget.Location - Location);

	SpawnLoc = Mesh.GetBoneLocation(HeadBoneName);
	NadeProj = GearProj_Grenade(Spawn(MouthProjectile,,, SpawnLoc));

	if (NadeProj != None && !NadeProj.bDeleteMe)
	{
		NadeProj.Init(SimulationDir);
		NadeProj.Velocity = GetGrenadeTossVelocity(NadeProj.Location, SimulationDir, NadeProj);
//		NotifyWeaponFired(CurrentFireMode);
	}

}
function SpawnFireOnGround()
{
	local vector FireLoc;
	FireLoc = (FlameThrower.Location) +  200.f*vector(FlameThrower.Rotation);
	// match Z with target location, so that it doesn't try to spawn fire under the ground
	FireLoc.Z += 100.f;
	SpawnFire(FireLoc);
}

simulated function StopFireSpray()
{
	// clear timer
	ClearTimer('StopFireSpray');
	bFireSprayOn = false;
	FlameThrower.DetachAndFinish();

	StopHeatRamp();
	ClearTimer('StartFlame');
	ClearTimer('SpawnFireOnGround');
}

simulated function StartHeatRamp()
{
	// start heat ramp
	HeatRampIncrement = 0.3f;
	SetTimer(0.1f, true, 'UpdateProjectileHeatRamp');
}

simulated function StopHeatRamp()
{
	// stop heat ramp
	HeatRampIncrement = -0.2f;
	SetTimer(0.1f, true, 'UpdateProjectileHeatRamp');
}

/** Tick to move head to enemy if firing**/
simulated function Tick(float DeltaTime)
{
	// if head fire is on, continue facing
 	if (bFireSprayOn && FlameThrower != None)
 	{
 		FaceFireToTarget();
 	}

	// for now disable lookat control. It's not workig great now. 
	// will need to debug and see why
	//  	if (HeadWormTarget!=none)
// 	{
// 		// if headworm target exists, just activate
// 		if (LookAtControl.ControlStrength <= 0.f)
// 		{
// 			LookAtControl.SetSkelControlStrength(1.f, 0.25f);
// 		}
// 
// 		LookAtControl.SetTargetLocation(HeadWormTarget.Location);
// 	}
// 	else if (LookAtControl.ControlStrength > 0.f)
// 	{
// 		LookAtControl.SetSkelControlStrength(0.f, 0.25f);
// 	}

	Super.Tick(DeltaTime);
}

simulated function PlayAmbientVocals()
{
	local int RandNum;

	RandNum = Rand(3);
	switch( RandNum )
	{
	case 0:
		PlaySound(AmbientVocal, true);
		break;
	case 1:
		PlaySound(ScreamVocal, true);
		break;
	default:
		PlaySound(AngerVocal, true);
		break;
	}
	SetTimer(RandRange(2.f, 5.f), false, 'PlayAmbientVocals');
}

/** Sets up ambient footstep sounds */
simulated function PlaySlitherSounds()
{
	if( (SlitherLoop != None) && (WorldInfo.NetMode != NM_DedicatedServer) )
	{
		if( SlitherComp == None )
		{
			SlitherComp = CreateAudioComponent( SlitherLoop );
		}

		if( SlitherComp != None )
		{
			SlitherComp.bAutoDestroy = TRUE;
			SlitherComp.Location = Location;
			AttachComponent( SlitherComp );
			SlitherComp.FadeIn(0.3f, 1.f);
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
	if ( bSpawnedAndLanded == FALSE )
	{
		// still falling, do not damage
		Damage = 0;
	}
	// Take no damage from lambent explosions
	else if( ClassIsChildOf(DamageType, class'GDT_LambentExplosion') )
	{
		Damage = 0;
	}
	else if( `TimeSince(LastDamageTime) > 2.f )
	{
		PlaySound(PainVocal);
	}
	LastDamageTime = WorldInfo.TimeSeconds;

	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );
}

simulated function DeathExplosion()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearExplosionActor ExplosionActor;

	ClearTimer(nameof(DeathExplosion));

	if( FlameThrower != None )
	{
		// make sure to clean up spray effects
		StopFireSpray();
		Flamethrower.Destroy();
		FlameThrower = None;
	}

	if (Mesh != None)
	{
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionTemplate.Damage = DeathExplosionDamage;
		ExplosionTemplate.DamageRadius = DeathExplosionDamageRadius;
		SpawnLocation = Mesh.GetBoneLocation('Drudge_HeadWorm_Spine_4');
		SpawnRotation = Rotator(vect(0,0,1));

		ExplosionActor = Spawn(class'GearExplosionActor',,, SpawnLocation, SpawnRotation);
		ExplosionActor.InstigatorController = Controller;
		if (ExplosionActor.InstigatorController != None)
		{
			ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
		}
		ExplosionActor.Explode(ExplosionTemplate);
		Mesh.SetHidden(true);
		ExtinguishPawn();
	}
}

function SetupAvoidanceCylinder()
{
	local float AvoidRadius;

	if( !bDeleteMe && AvoidanceCylinder == None )
	{
		AvoidRadius = DeathExplosionDamageRadius * 0.65;
		AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder',self,,Location,,,TRUE);
		if( AvoidanceCylinder != None )
		{
			AvoidanceCylinder.SetBase(self);
			AvoidanceCylinder.SetCylinderSize(AvoidRadius, AvoidRadius * 2.0f);
			AvoidanceCylinder.SetDontAffectMesh(true);
			AvoidanceCylinder.SetEnabled(true);
		}
		//DrawDebugSphere(Location,AvoidRadius,16,255,0,0,TRUE);
	}
}

simulated event Destroyed()
{
	ClearTimer('SpawnTrail');
	ClearTimer('FaceFireToTarget');
	ClearTimer('UpdateProjectileHeatRamp');

	if( AvoidanceCylinder != none )
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = none;
	}

	if( FlameThrower != None)
	{
		FlameThrower.Destroy();
		FlameThrower = None;
	}

	DestroyGooEffects();

	Super.Destroyed();
}

//////////////////////////////////////////////////////////////////////////
// AIobjectAvoidanceInterface
event AIAvoidanceCylinderComponent GetAIAvoidanceCylinderComponent()
{
	if( AvoidanceCylinder == None )
	{
		return None;
	}
	return AvoidanceCylinder.GetAIAvoidanceCylinderComponent();
}

function bool ShouldAvoid(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	if( AskingAI != Controller && FastTrace(Location, AskingAI.Pawn.Location,,true) )
	{
		return true;
	}

	return false;
}

function bool ShouldEvade(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	local float Thresh;

	Thresh = DeathExplosionDamageRadius * 0.75f;
	Thresh *= Thresh;
	// evade if it's really close
	if( VSizeSq(AskingAI.Pawn.Location - Location) < Thresh )
	{
		return true;
	}
	return false;
}

simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore)
{
	local vector ToHitLoc, ApplyImpulse;

	Super.PlayRagDollDeath(GearDamageType, HitLoc, bShowGore);

	if (GearDamageType != None &&
		!ClassIsChildOf(GearDamageType, class'GDT_Explosive') &&
		GearDamageType.default.bHighKickDeathAnimation)
	{
		ToHitLoc = HitLoc - Location;
		ToHitLoc.Z = 0.0f;
		ToHitLoc = Normal(ToHitLoc);

		ApplyImpulse = -ToHitLoc * 200.f + vect(0.0f, 0.0f, 10.f);

		Mesh.AddImpulse(ApplyImpulse, HitLoc,,TRUE);
		Mesh.SetRBLinearVelocity(ApplyImpulse * 2.f, TRUE);

//  		FlushPersistentDebugLines();
//  		DrawDebugLine(Location, Location + ApplyImpulse, 0, 255, 0, TRUE);
//  		DrawDebugSphere(HitLoc, 10, 10, 255, 0, 0, TRUE);
//  		DrawDebugSphere(Location, 10, 10, 0, 255, 0, TRUE);
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Super.PlayDying(DamageType,HitLoc);
	FadeOutAudioComponent(SlitherComp, 0.5f);
	ClearTimer('PlayAmbientVocals');
	PlaySound(DeathSound, true);
	PlaySound(DeathVocal, true);
	if( TimeBeforeExplosion > 0.f )
	{
		SetupAvoidanceCylinder();

		// make sure to clean up spray effects
		if( FlameThrower != None )
		{
			StopFireSpray();
		}

		SetTimer( TimeBeforeExplosion, false, nameof(DeathExplosion) );
	}
	else
	{
		DeathExplosion();
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

/** Starts the goo effect */
simulated function ParticleSystemComponent SpawnGooEffect(name SocketName)
{
	local ParticleSystemComponent GooEffect;
	GooEffect = new(self) class'ParticleSystemComponent';
	if (GooEffect != None)
	{
		Mesh.AttachComponentToSocket(GooEffect, SocketName);
		GooEffect.SetTemplate(GooEmitterTemplate);
		GooEffect.ActivateSystem(FALSE);
	}

	return GooEffect;
}

simulated function StartGooEffects()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		GooEmitterTemplate != None)
	{
		GooEffects.AddItem(SpawnGooEffect('1'));
		GooEffects.AddItem(SpawnGooEffect('2'));
		GooEffects.AddItem(SpawnGooEffect('3'));
		GooEffects.AddItem(SpawnGooEffect('4'));
		GooEffects.AddItem(SpawnGooEffect('5'));
		GooEffects.AddItem(SpawnGooEffect('6'));
	}
}

/** Destroys the stomach effect */
simulated function DestroyGooEffects()
{
	local int ID;
	local ParticleSystemComponent GooEffect;

	for (ID=0; ID<GooEffects.Length; ++ID)
	{
		GooEffect = GooEffects[ID];
		if (GooEffect != None)
		{
			GooEffect.DeactivateSystem();
			Mesh.DetachComponent(GooEffect);
			// remove all from index
		}
	}
}

// FIXME: This doesn't look good - so disabled it. If you'd like to enable it again, bCanMantle = TRUE
function bool DoMantle(GearAI AI, INT Dir, vector MoveStart, vector MoveDest, CoverInfo Info)
{
	return class'AICmd_Serapede_Move_Mantle'.static.MantleEdge( MyGearAI, MoveStart, MoveDest, Info );
}

/** Timer driven function **/
simulated function UpdateProjectileHeatRamp()
{
	CurrentProjectileHeatRampValue += HeatRampIncrement;	
	CurrentProjectileHeatRampValue = FClamp(CurrentProjectileHeatRampValue, HeatRampMinValue, HeatRampMaxValue);

	MIC_PawnMat.SetScalarParameterValue('ProjectileHeatRamp', CurrentProjectileHeatRampValue);

	// currently incrementing
	if ( HeatRampIncrement > HeatRampMinValue )
	{
		// we reached max
		if (CurrentProjectileHeatRampValue == HeatRampMaxValue)
		{
			ClearTimer('UpdateProjectileHeatRamp');
		}
	}
	else
	{
		if (CurrentProjectileHeatRampValue == HeatRampMinValue)
		{
			ClearTimer('UpdateProjectileHeatRamp');
		}
	}
}

defaultproperties
{
	ControllerClass=class'GearAI_DrudgeHeadWorm'
	GearPawnFXClass=class'GearPawnFX_Lambent'

	bCanDBNO=false
	bPlayDeathAnimations=false

	Begin Object Name=CollisionCylinder
		CollisionHeight=+0040.000000
		CollisionRadius=+0040.000000
	End Object

	EyeHeight=0
	BaseEyeHeight=0

	PelvisBoneName=none
	bRespondToExplosions=false
	bTranslateMeshByCollisionHeight=false
	RotationRate = (Pitch=32768, Roll=32768, Yaw=32768)
	LedgeCheckThreshold=0

	bSpawnBloodTrailDecals=false
	bShowFatalDeathBlood=false

	ScorchDecalSizeRange=(X=400,Y=500)
	ScorchDecalLifeSpan=60.f

	DurationBeforeDestroyingDueToNotBeingSeen=4.0f

	WalkableFloorZ=-1
	bCrawler=true

	MovementLateralSwayPeriod=100
	MovementLateralSwayLatOffset=100

	//SightBoneName="LookingDirection"
	SightBoneName=none
	//NeckBoneName="Segment_headoffset"

	RotationClamp=12740

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_LambentExplosion'
		MomentumTransferScale=1.f
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		DamageFalloffExponent=0.75
	End Object
	ExplosionTemplate=ExploTemplate0

	HeadBoneName=Tongue_1

	KismetDeathDelayTime=1.f

	GrenadeAimingCameraPitchLimit=(X=-10000,Y=7000)
}
