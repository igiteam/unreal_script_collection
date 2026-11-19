
/**
 * GearPawn_LocustDroneSavageUndergroundBase
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustDroneSavageUndergroundBase extends GearPawn_LocustCreatureBase
	abstract;

/** Savage drone pawn class to spawn */
var() class<GearPawn> SpawnPawnClass;
/** Savage drone controller class to spawn */
var() class<GearAI> SpawnControllerClass;
/** Number of pawns to spawn to favor melee attacks */
var() config int NumToSpawnMelee;
/** Number of pawns to spawn to favor guns */
var() config int NumToSpawnRanged;
/** Number of pawns to spawn to favor smoke grenades */
var() config int NumToSpawnSmoke;
/** Number of pawns to spawn with default settings*/
var() config int NumToSpawnDefault;
/** Total number of pawns to spawn */
var transient int NumToSpawnTotal;
/** Number of pawns spawned so far */
var transient int NumSpawned;
/** Time delay between spawns */
var() config float DelayBetweenSpawns;

/** Keep track of the AI Factory and spawn set that spawned me */
var transient SeqAct_AIFactory MySpawningFactory;
var transient int MySpawnSetIdx;

/** Ground trail particle system component */
var() protected ParticleSystemComponent PSC_GroundTrail;
/** Distance within which to do camera shake for nearby players */
var() config float BurrowCameraShakeDistance;
/** Camera shake for burrowing near players */
var() protected const GearCameraShake BurrowCameraShake;

/** Audio component for burrowing sound loop */
var AudioComponent BurrowLoopSound;
/** Sound to play when done burrowing, before spawning pawns */
var() SoundCue BurrowStopSound;
/** Sounds to play when pawn emerges */
var() SoundCue EmergeSoundA, EmergeSoundB;

simulated event PreBeginPlay()
{
	Super.PreBeginPlay();

	// Destroy if Spawned in an Area where burrowing is not allowed
	if( !class'GearPawn_LocustCorpserLarvaUndergroundBase'.static.IsLocationBabyCorpserSafe(WorldInfo, Location) )
	{
		`Warn("Savage Underground Spawner" @ Self @ "destroyed because spawned in a GearEnvironmentVolume with bNoBabyCorpserBurrowing");
		Destroy();
	}
}

event PostAIFactorySpawned(SeqAct_AIFactory SpawningFactory, INT SpawnSetIdx)
{
	MySpawningFactory = SpawningFactory;
	MySpawnSetIdx = SpawnSetIdx;
	Super.PostAIFactorySpawned(SpawningFactory, SpawnSetIdx);
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	NumToSpawnTotal = NumToSpawnMelee + NumToSpawnRanged + NumToSpawnSmoke + NumToSpawnDefault;
	SetTimer(0.2, true, nameof(DoBurrowShake));
}

/** Sends controller rumble to nearby players */
simulated final function DoBurrowShake()
{
	local PlayerController PC;
	local float Distance;

	foreach LocalPlayerControllers(class'PlayerController', PC)
	{
		Distance = VSize(PC.ViewTarget.Location - Location);
		if (PC.ViewTarget != None && Distance < BurrowCameraShakeDistance)
		{
			PC.ClientPlayCameraShake(BurrowCameraShake, (BurrowCameraShakeDistance - Distance) / BurrowCameraShakeDistance);
			PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.CameraShakeMediumShort);
		}
	}
}

function SetMovementPhysics()
{
	SetPhysics(WalkingPhysics);
}

/** Damage disabled */
function TakeDamage
(
				int					Damage,
				Controller			InstigatedBy,
				Vector				HitLocation,
				Vector				Momentum,
				class<DamageType>	DamageType,
	optional	TraceHitInfo		HitInfo,
	optional	Actor				DamageCauser
);

simulated exec function IgnitePawn(PawnOnFireState NewState, optional Controller FireInstigator, optional class<GearDamageType> DamageType, optional float Duration);

simulated function bool CanBeSpecialMeleeAttacked(GearPawn Attacker)
{
	return FALSE;
}

/** Don't initialize a ragdoll, since we're exploding */
simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore)
{
	SetCollision(FALSE, FALSE);
}

/**
 *  Test a location in the World to see if the Corpser is allowed there.
 *  GearEnvironmentVolumes can prevent that.
 */
final simulated static function bool IsLocationBabyCorpserSafe(WorldInfo WI, vector TestLocation)
{
	local GearEnvironmentVolume EnvVolume;

	EnvVolume = GearEnvironmentVolume(WI.FindEnvironmentVolume(TestLocation));
	if( EnvVolume != None && EnvVolume.bNoBabyCorpserBurrowing )
	{
		return FALSE;
	}

	return TRUE;
}

simulated event Destroyed()
{
	ClearTimer(nameof(DoBurrowShake));
	PSC_GroundTrail.DeactivateSystem();
	Super.Destroyed();
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	ClearTimer(nameof(DoBurrowShake));
	PSC_GroundTrail.DeactivateSystem();
	return Super.Died(Killer,DamageType,HitLocation);
}

function BeginEmerge()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearPawn CurrentSpawnPawn;
	local GearAI CurrentSpawnAI;

	if( NumSpawned < NumToSpawnTotal )
	{
		SpawnLocation = Location;
		SpawnRotation = Rotation;

		// Add some random variation to where we are throwing dudes
		SpawnRotation.Yaw += RandRange(-16000, 16000);

		// Spawn pawn
		CurrentSpawnPawn = Spawn(SpawnPawnClass,,,SpawnLocation, SpawnRotation,,true);
		CurrentSpawnAI = Spawn(SpawnControllerClass,,,SpawnLocation,SpawnRotation);

		// Initialize variables
		GearPRI(CurrentSpawnAI.PlayerReplicationInfo).ScaleScoringValues(float(CurrentSpawnPawn.ArcadeBasePointValue) / GearGame(WorldInfo.Game).PointsFor_DamagePct);
		CurrentSpawnAI.bFriendlyToLocustAndLambent = (MyGearAI != None && MyGearAI.bFriendlyToLocustAndLambent);
		CurrentSpawnAI.SetTeam(GetTeamNum());
		CurrentSpawnPawn.bCanRechargeHealth = false;
		CurrentSpawnAI.Possess(CurrentSpawnPawn, false);
//		CurrentSpawnAI.SetSquadName('SavageSquad');
		CurrentSpawnAI.AutoAcquireEnemy();
		CurrentSpawnPawn.AI_AddDefaultInventory();

		// Apply custom settings
		ApplyCustomSettingsToSpawned(CurrentSpawnAI);

		// Launch the pawn
		CurrentSpawnAI.DoEmerge(GSM_SavageDrone_EmergeFromUnderground);
		PlaySound(EmergeSoundA);
		PlaySound(EmergeSoundB);
		//SpawnEffects();

		// Add pawn to AI Factory's WatchList
		if( MySpawningFactory != None && CurrentSpawnPawn != None )
		{
			MySpawningFactory.AddPawnToSetWatchListByIndex(MySpawnSetIdx, CurrentSpawnPawn);
		}

		++NumSpawned;
		if( NumSpawned < NumToSpawnTotal )
		{
			SetTimer(DelayBetweenSpawns, false, 'BeginEmerge');
		}
		else
		{
			Destroy();
		}
	}
}

function ApplyCustomSettingsToSpawned(GearAI NewAI)
{
	if( NumSpawned < NumToSpawnMelee )
	{
		NewAI.SetCombatMood(AICM_Aggressive);
		NewAI.GrenadeChanceScale = 0.0f;
		NewAI.EnemyDistance_MeleeCharge = 2048.f;
	}
	else if( NumSpawned < NumToSpawnMelee + NumToSpawnRanged )
	{
		NewAI.SetCombatMood(AICM_Normal);
		NewAI.GrenadeChanceScale = 0.8f;
		NewAI.EnemyDistance_MeleeCharge = 512.f;
	}
	else if( NumSpawned < NumToSpawnMelee + NumToSpawnRanged + NumToSpawnSmoke )
	{
		NewAI.SetCombatMood(AICM_Passive);
		NewAI.GrenadeChanceScale = 10.0f;
		NewAI.EnemyDistance_MeleeCharge = 512.f;
	}
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionHeight=40
		CollisionRadius=10  
	End Object

	DurationBeforeDestroyingDueToNotBeingSeen=0.f

	bCollideActors=false
	bBlockActors=false

	ControllerClass=class'GearAI_SavageDroneUnderground'

	bInvalidMeleeTarget=TRUE
	bInvalidFireTarget=TRUE

	bUseSimplePhysicalFireStartLoc=TRUE
	bAllowInventoryDrops=FALSE
	bCanPlayPhysicsHitReactions=FALSE
	bCanDo360AimingInCover=FALSE
	bCanDoRun2Cover=FALSE
	bShouldChainsawAttackInstantKillMe=FALSE

	WalkingPhysics=PHYS_NavMeshWalking
	bDoIKFloorConformCOM=FALSE
	bDoFootPlacement=FALSE

	SpecialMoveClasses.Empty

	PelvisBoneName=None
	PickupFocusBoneName=None
	PickupFocusBoneNameKickup=None
	FullBodyNodeName=None
	
//	NoticedGUDSEvent=GUDEvent_NoticedMiniCorpser

	Begin Object Class=GearCameraShake Name=BurrowCameraShake0
		OscillationDuration=0.4f
		LocOscillation={(Y=(Amplitude=2.f,Frequency=3.f),
		Z=(Amplitude=10.f,Frequency=30.f))}
	End Object
	BurrowCameraShake=BurrowCameraShake0
}
