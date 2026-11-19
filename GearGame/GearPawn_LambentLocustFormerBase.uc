/**
 * Base class for lambent non-mutatable drones
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LambentLocustFormerBase extends GearPawn_LocustBase
	abstract
	config(Pawn);

/** Death explosion template */
var instanced GearExplosion ExplosionTemplate;
/** Config damage values */
var config float DeathExplosionDamage;
var config float DeathExplosionDamageRadius;
var config float DeathExplosionDamageFalloff;

/** Particle systems for eyes */
var transient ParticleSystemComponent L_EyePSC;
var transient ParticleSystemComponent R_EyePSC;
/** Names for where to attach particle systems */
var() name R_EyeSocketName;
var() name L_EyeSocketName;
/** Templates */
var() ParticleSystem L_EyePSTemplate;
var() ParticleSystem R_EyePSTemplate;

/** last controller to do damage to us (used for saving instigator of explosions) */
var Controller	LastDamageInstigator;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	StartEyeEffect();
}

simulated function vector GetWeaponAimIKPositionFix()
{
	return Super.GetWeaponAimIKPositionFix() + vect(0,4,-2);
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
	LastDamageInstigator = InstigatedBy;
	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}

/** Starts the eye PSCs */
simulated function StartEyeEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if( L_EyePSTemplate != None )
		{
			L_EyePSC = new(self) class'ParticleSystemComponent';

			Mesh.AttachComponentToSocket(L_EyePSC,L_EyeSocketName);
			L_EyePSC.SetTemplate(L_EyePSTemplate);
			L_EyePSC.ActivateSystem();
		}

		if( R_EyePSTemplate != None )
		{
			R_EyePSC = new(self) class'ParticleSystemComponent';

			Mesh.AttachComponentToSocket(R_EyePSC,R_EyeSocketName);
			R_EyePSC.SetTemplate(R_EyePSTemplate);
			R_EyePSC.ActivateSystem();
		}
	}
}

simulated function DestroyEyeEffect()
{
	if( L_EyePSC != None )
	{
		L_EyePSC.DetachFromAny();
		L_EyePSC = None;
	}

	if( R_EyePSC != None )
	{
		R_EyePSC.DetachFromAny();
		R_EyePSC = None;
	}
}

simulated function Explode()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearExplosionActor ExplosionActor;
	local GearProj_Grenade AttachedGrenade;
	local int AttachIdx;

	// Detonate attached grenades
	for( AttachIdx = 0; AttachIdx < Attached.length; ++AttachIdx )
	{
		AttachedGrenade = GearProj_Grenade(Attached[AttachIdx]);
		if( AttachedGrenade != None && !AttachedGrenade.bDeleteMe )
		{
			AttachedGrenade.DoExplosion();
		}
	}

	// Stop blood trails, if we are being chainsawed
	StopBloodTrail('SpawnABloodTrail_ChainsawSpray_Ground');
	StopBloodTrail('SpawnABloodTrail_ChainsawSpray_Wall');

	ExplosionTemplate.InitFromContentTemplate();
	ExplosionTemplate.Damage = DeathExplosionDamage;
	ExplosionTemplate.DamageRadius = DeathExplosionDamageRadius;
	Mesh.GetSocketWorldLocationAndRotation('Explo', SpawnLocation, SpawnRotation);
	ExplosionActor = Spawn(class'GearExplosionActor',,, SpawnLocation, SpawnRotation);

	if (LastDamageInstigator != None)
	{
		ExplosionActor.Instigator = LastDamageInstigator.Pawn;
		ExplosionActor.InstigatorController = LastDamageInstigator;
	}
	else
	{
		ExplosionActor.InstigatorController = Controller;
		if (ExplosionActor.InstigatorController != None)
		{
			ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
		}
	}
	ExplosionActor.Explode(ExplosionTemplate);

	if (Mesh != None)
	{
		// Hide mesh and stop effects
		AnimTree(Mesh.Animations).SetUseSavedPose(TRUE);
		Mesh.SetHidden(true);
		ExtinguishPawn();
	}	
	DestroyEyeEffect();
}

/** Turn off gibs on lambent, since we don't have gore yet, and this currently causes stray lambent effects after they explode */
function bool ShouldGib(class<GearDamageType> GearDmgType, Pawn InstigatedBy)
{
	return FALSE;
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local class<GearDamageType> GearDamageType;

	Super.PlayDying(DamageType,HitLoc);

	GearDamageType = class<GearDamageType>(DamageType);
	if (GearDamageType == None || bHasPlayedHeadShotDeath || (GearDamageType != class'GDT_Bayonet' && !GearDamageType.static.ShouldGib(Self, KilledByPawn)))
	{
		SetTimer(0.5, false, nameof(Explode));
	}
	else
	{
		Explode();
	}
}

// we explode on death, not equipped to play rangdolls!
simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore);

function bool AllowedToDBNO()
{
	return false;
}

/** dark drones are immune to cringe */
event Cringe(optional float Duration = -1.0);

defaultproperties
{
	DefaultInventory.Empty

	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_LambentExplosion'
		MomentumTransferScale=1.f
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		DamageFalloffExponent=0.75
	End Object
	ExplosionTemplate=ExploTemplate0

 	Begin Object Name=GearPawnMesh
		PhysMaterialOverride=PhysicalMaterial'GearPhysMats.Lambent_Flesh'
	End Object

	DefaultInventory.Empty()

	ControllerClass=class'GearAI_Locust'
	SoundGroup=GearSoundGroup'GearSoundGroupArchetypes.GSG_LocustDrone'
	MasterGUDBankClassNames(0)="GearGameContent.GUDData_LocustGrenadier"
	FAS_ChatterNames.Add("Locust_Grunt.FaceFX.Chatter")
	FAS_ChatterNames.Add("Locust_Grunt.FaceFX.Chatter_Dup")
	FAS_Efforts(0)=FaceFXAnimSet'Locust_Grunt.FaceFX.Drone_Efforts'
	GearPawnFXClass=class'GearPawnFX_Former'

	bWantChainsawKick=false
	ChainsawOverrideDeathTime=1.5
	bSpawnBloodTrailDecals=false
	bShowFatalDeathBlood=false

	DefaultBloodEffectTemplate=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_Lambent_Blood_Full_LOD'
	BloodLowHitTemplate=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_Lambent_Blood_Full_LOD_Low_Hit'
	BloodGoreExplosionTemplate=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_Lambent_Blood_Full_LOD_Death'
	BloodGoreConstraintBrokenTemplate=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_Lambent_Blood_flying_bodypart'
	ShotgunCameraLensEffectTemplate=None
	PS_MeleeImpactEffect=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_Lambent_Blood_Full_LOD_Med_Hit'
	PS_RadialDamageEffect=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_Lambent_Blood_Full_LOD_Med_Hit'

	PhysHRMotorStrength=(X=5000,Y=0)

	Begin Object Name=CollisionCylinder
	    CollisionRadius=+0030.000000
		CollisionHeight=+0072.000000
	End Object

	SpecialMoveClasses(SM_MidLvlJumpOver)	        =class'GSM_MantleOverLocust'
	SpecialMoveClasses(SM_EvadeFwd)			        =None
	SpecialMoveClasses(SM_EvadeBwd)			        =None
	SpecialMoveClasses(SM_EvadeLt)			        =None
	SpecialMoveClasses(SM_EvadeRt)			        =None
	SpecialMoveClasses(SM_EvadeFromCoverCrouching)  =None
	SpecialMoveClasses(SM_EvadeFromCoverStanding)   =None

	NoticedGUDSPriority=40
	NoticedGUDSEvent=GUDEvent_NoticedLambentDrone

	MeatShieldMorphTargetName="Meatshield_Morph"

	bCanPlayHeadShotDeath=true
	GoreSettings=GearPawnGoreSettings'GearGoreSettings.GearPawn_LambentLocustFormer'

	KismetDeathDelayTime=1.2f
}
