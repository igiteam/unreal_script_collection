/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/
class GearPawn_LocustIthycusBase extends GearPawn_LocustCreatureBase
	implements(Interface_AIAimLocationOverride)
	implements(Interface_AIVehicleWeaponTarget)
	abstract
	config(Pawn)
	native(Pawn);


/** Information from the submarine so the fish can deal damage after the move is finished */
/** Index of pod to do damage on */
var int PodIndex;
/** The submarine pawn to give damage to */
var Vehicle_Submarine_Base SubmarinePawn;
/** Amount of damage to deal to the pod/sub */
var float Damage;

/** The sound cue for the attack */
var(Sound) SoundCue AttackSoundCue;
/** The sound cue for when the creature dies */
var(Sound) SoundCue DeathSoundCue;

/** Defines the explosion for fish death gibbing */
var() instanced editinline GearExplosion DeathExplosionTemplate;


/**
 * Get gravity currently affecting this actor
 */
native function float GetGravityZ();

/** Play death effects: animation, sounds, physics... */
simulated function PlayDeath(class<GearDamageType> GearDamageType, vector HitLoc)
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearExplosionActor ExplosionActor;
	local Actor OldBase;

	// Spawn explosion archetype
	DeathExplosionTemplate.InitFromContentTemplate();
	SpawnLocation = Mesh.GetBoneLocation('b_Tail02');
	SpawnRotation = Rotation;

	ExplosionActor = Spawn(class'GearExplosionActor',,, SpawnLocation, SpawnRotation);
	ExplosionActor.Explode(DeathExplosionTemplate);

	// Play death sound
	PlaySound(DeathSoundCue);

	// Hide mesh and stop effects
	AnimTree(Mesh.Animations).SetUseSavedPose(TRUE);
	HideMesh();
	OldBase = Base;
	SetPhysics(PHYS_None);
	SetBase(OldBase);
	SetCollision(FALSE, FALSE);
	if (TaccomMesh != None)
	{
		DetachComponent(TaccomMesh);
	}
}

function SetMovementPhysics()
{
	if( Health > 0 )
	{
		SetPhysics( PHYS_Interpolating );
	}
	else
	{
		Super.SetMovementPhysics();
	}
}

/** Handles doing the attack special move and dealing damage to the submarine/pods */
function AttackSubmarine(Vehicle_Submarine_Base Submarine, int PodIdx, float DamageAmount)
{
	PodIndex = PodIdx;
	SubmarinePawn = Submarine;
	Damage = DamageAmount;
	DoSpecialMove(GSM_IthycusAttack, true);

	// Apply damage
	if (Role == ROLE_Authority &&
		SubmarinePawn != None &&
		Health > 0)
	{
		SubmarinePawn.DoSubmarineDamage(self, PodIndex, Damage, class'GDT_IthycusAttack');
	}
}

/** Plays the attack sound */
function PlayAttackSound()
{
	PlaySound(AttackSoundCue, true, false, true, Location);
}

function bool OverrideAimLocation(out vector AimLoc, vector StartLoc, GearAI ShooterAI)
{
	// override to point at tail
	AimLoc = Mesh.GetBoneLocation('b_Head');
	return true;
}

/** Adjust aim friction extent to match size more closely */
simulated function GetAimFrictionExtent(out float Width, out float Height, out vector Center)
{
	Super.GetAimFrictionExtent(Width, Height, Center);
	Center = Mesh.GetBoneLocation('b_Tail02');
	Height *= 0.5;
	Width *= 0.8;
}
/** Adjust aim adhesion extent to match size more closely */
simulated function GetAimAdhesionExtent(out float Width, out float Height, out vector Center)
{
	Super.GetAimAdhesionExtent(Width, Height, Center);
	Center = Mesh.GetBoneLocation('b_Tail02');
	Height *= 0.5;
	Width *= 0.8;
}

/** Returns a base AI rating for this target */
function float GetVehicleWeaponAIRating()
{
	if( Health <= 0 )
	{
		return -1.0f;
	}
	return 2.0f;
}

defaultproperties
{
	ControllerClass=class'GearGame.GearAI_Ithycus'

	SpecialMoveClasses(GSM_IthycusAttack)=class'GSM_IthycusAttack'

	Physics=PHYS_Interpolating

	Begin Object Name=CollisionCylinder
		CollisionRadius=60.000000
		CollisionHeight=60.000000
	End Object

	SightBoneName=none
	PelvisBoneName=none

	bCanDoRun2Cover=FALSE
	bCanDBNO=FALSE
	bRespondToExplosions=FALSE

	HearingThreshold=6000.f

	bPlayDeathAnimations=TRUE
	DeathAnimHighFwd=("dead")
	DeathAnimHighBwd=("dead")
	DeathAnimStdFwd=("dead")
	DeathAnimStdBwd=("dead")
	DeathAnimStdLt=("dead")
	DeathAnimStdRt=("dead")

	bNoDeathGUDSEvent=TRUE

	AimAttractors(0)=(OuterRadius=196.f,InnerRadius=32.f,BoneName="b_BodyRoot")
	AimAttractors(1)=(OuterRadius=128.f,InnerRadius=32.f,BoneName="b_Head")
	AimAttractors(2)=(OuterRadius=128.f,InnerRadius=32.f,BoneName="b_Tail02")
}
