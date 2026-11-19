/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_Chicken_Base extends GearPawn;

/** Amount of remaining health where the chicken will begin a chicken attack */
var() int FreakoutHealthThreshold;

/** Max freakout speed */
var() float FreakoutSpeed;
var() float MaxWalkingSpeed;
var() float MaxRunningSpeed;

/** Set to true if this chicken has freaked out */
var transient bool bFreakedOut, bIsPanicked;


/** Sound to play when attack begins */
var() SoundCue AttackVocal;
/** Sound to play when taking damage from chicken */
var() SoundCue BiteSound;
/** Alternate sound to play when taking damage from chicken */
var() SoundCue AltBiteSound;
/** Vocal to play before explosion */
var() SoundCue PreExplodeSound;

var GearExplosion ExplosionTemplate;

var transient   repnotify bool    bIsAttackChicken;
var transient   bool    bIsAttacking;
var             float   AttackChickenCollisionRadius, AttackChickenCollisionHeight;
var config      float   AttackChickenDrawScale;
var config      int     AttackChickenHealth;
var             Name    FlameMuzzleSocketName;
var ParticleSystemComponent PSC_Grow;

replication
{
	if( Role == Role_Authority )
		bFreakedOut, bIsPanicked, bIsAttackChicken, bIsAttacking;
}


/** replicated event */
simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
		case 'bIsAttackChicken' : 
			GrowAndAttack();
			break;
	}

	Super.ReplicatedEvent( VarName );
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	DefaultGroundSpeed = MaxWalkingSpeed;
	UpdateGroundSpeed();
}

function TossInventory(Inventory Inv, optional vector ForceVelocity);

/** Kills thee chicken if it was stepped on by a GearPawn_Infantry */
simulated event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	local GearPawn_Infantry OtherPawn;

	Super.Bump(Other, OtherComp, HitNormal);

	OtherPawn = GearPawn_Infantry(Other);
	if( OtherPawn != None && 
		HitNormal dot vect(0,0,1) > 0.95f )
	{
		TakeDamage(Health, OtherPawn.Controller, Location, -HitNormal, class'GDT_CurbStomp');
	}
}

function bool IsValidEnemyTargetFor(const PlayerReplicationInfo PRI, bool bNoPRIisEnemy)
{
	if( !bIsAttackChicken )
	{
		return FALSE;
	}

	return Super.IsValidEnemyTargetFor( PRI, bNoPRIisEnemy );
}

simulated function UpdateGroundSpeed()
{
	if( bIsAttackChicken )
	{
		GroundSpeed = MaxRunningSpeed;
	}
	else if( bFreakedOut )
	{
		GroundSpeed = FreakoutSpeed;
	}
	else if( bIsPanicked )
	{
		GroundSpeed = MaxRunningSpeed;
	}
	else
	{
		GroundSpeed = MaxWalkingSpeed;
	}
	
}

function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if( EventInstigator != None && EventInstigator.Pawn == self )
	{
		return;
	}

	// Don't take damage from lambent explosions, or we'll freakout almost immediately
	if( ClassIsChildOf(DamageType, class'GDT_LambentExplosion') )
	{
		DamageAmount = 0;
	}

	if( !bFreakedOut && !bIsAttackChicken && DamageAmount > Health && FreakoutHealthThreshold > 0 )
	{
		DamageAmount = Min( FreakoutHealthThreshold, DamageAmount );
	}

	Super.TakeDamage( DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );

	if( !bFreakedOut && EventInstigator.Pawn != None && 
		FreakoutHealthThreshold > 0 && Health < FreakoutHealthThreshold )
	{
		SetFreakout(EventInstigator.Pawn);
	}
	else
	{
		SetPanic( EventInstigator.Pawn );
	}
}

function SetPanic( Pawn Enemy ) 
{
	local GearAI_Chicken AI;

	AI = GearAI_Chicken(Controller);
	if( AI != None && Enemy != self )
	{
		AI.SetEnemy( Enemy );
		if( bIsAttackChicken )
		{
			AI.FireTarget = Enemy;
			AI.Focus      = Enemy;
		}
	}

	if( !bFreakedOut && !bIsPanicked && !bIsAttackChicken )
	{
		bIsPanicked = TRUE;
		UpdateGroundSpeed();

		SetTimer( 5.f, FALSE, nameof(UnPanic) );

		if( AI != None )
		{
			AI.NotifyPanic();
		}
	}
}

function UnPanic()
{
	ClearTimer( nameof(UnPanic) );

	if( !bFreakedOut && bIsPanicked )
	{
		bIsPanicked = FALSE;
		UpdateGroundSpeed();
	}
}

function SetFreakout( Pawn Enemy )
{
	if( !bFreakedOut && !bIsAttackChicken )
	{
		SetPanic( Enemy );

		ClearTimer( nameof(UnPanic) );
		bFreakedOut = TRUE;
		UpdateGroundSpeed();
	}
}

simulated function GrowAndAttack()
{
	local GearAI_Chicken AI;

	bNeverAValidEnemy = FALSE;

	bFreakedOut = FALSE;
	bIsPanicked = FALSE;
	bIsAttackChicken = TRUE;
			
	Health = AttackChickenHealth;
	SetCollisionSize( AttackChickenCollisionRadius, AttackChickenCollisionHeight );
	Mesh.SetTranslation( vect(0,0,-16) );
	FitCollision();

	SetDrawScale( AttackChickenDrawScale );

	UpdateGroundSpeed();

	if( PSC_Grow != None )
	{
		AttachComponent( PSC_Grow );
		PSC_Grow.ActivateSystem();
	}

	AI = GearAI_Chicken(Controller);
	if( AI != None )
	{
		AI.SetTeam(3);
		AI.NotifyAttack();
	}
}

simulated function DeathExplosion()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearExplosionActor ExplosionActor;
	local GearExplosion Template;

	if (Mesh != None)
	{
		Template = ExplosionTemplate;
		Template.InitFromContentTemplate();
		Template.Damage = 0;
		Template.DamageRadius = 0;
		SpawnLocation = MatrixGetOrigin(Mesh.GetBoneMatrix(0));
		SpawnLocation.Z = Location.Z;
		SpawnRotation = Rotation;

		// Explosion effect wants Z pointed in direction of pawn, with X pointing up
		SpawnRotation.Pitch += 16384;
		SpawnRotation.Roll += 32768;

//		DrawDebugCoordinateSystem(Location, SpawnRotation, 25.f, TRUE);

		ExplosionActor = Spawn(class'GearExplosionActor',,, SpawnLocation, SpawnRotation);
		ExplosionActor.InstigatorController = Controller;
		if( ExplosionActor.InstigatorController != None )
		{
			ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
		}
		ExplosionActor.Explode(Template);

		Mesh.SetHidden(TRUE);
		ExtinguishPawn();
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
		DeathExplosion();
	}
}

simulated function bool CanBeSpecialMeleeAttacked(GearPawn Attacker);
simulated function bool CanBeChainsawAttacked();
simulated function bool CanBeBayonetAttacked();

defaultproperties
{
	bNeverAValidEnemy=TRUE

	bBlockCamera=FALSE
	bCanDoFloorConform=FALSE
	bDoFullMeshFloorConform=FALSE
	bDoIKFloorConformTorsoBending=FALSE
	bDoIKFloorConformCOM=FALSE
	bDoFootPlacement=FALSE
	bTranslateMeshByCollisionHeight=FALSE
	bCanDoStepsSmoothing=FALSE
	bAllowAccelSmoothing=FALSE
	bAllowTurnSmoothing=FALSE
	bCanDo360AimingInCover=FALSE

	bSuppressNoticedGUDSEvents=TRUE

	Health=100
	FreakoutHealthThreshold=70

	WalkingPhysics=PHYS_NavMeshWalking

	MaxWalkingSpeed=50.0
	MaxRunningSpeed=250.0
	FreakoutSpeed=500.0

	AttackChickenCollisionRadius=96.f
	AttackChickenCollisionHeight=128.f
	FlameMuzzleSocketName=Flame

// 	RotateToTargetSpeed=20000.0
// 	MaxYawRate=20000.0

//	MeshMinScale3D=(X=1.3,Y=1.3,Z=1.3)
//	MeshMaxScale3D=(X=1.7,Y=1.7,Z=1.7)
//	bUniformScale=TRUE
}

