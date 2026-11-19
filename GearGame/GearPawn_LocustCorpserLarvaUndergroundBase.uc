
/**
 * GearPawn_LocustCorpserLarvaUndergroundBase
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustCorpserLarvaUndergroundBase extends GearPawn_LocustCreatureBase
	implements(Interface_AIAimLocationOverride)
	native(Pawn)
	config(Pawn)
	abstract;

//
// Config Variables
//
/** Number of attacks performed underground, before deciding to emerge to the surface. */
var() config const INT NumUndergroundAttacksBeforeEmerging;
/** List of bone names providing shielding against bullets */
var() config const array<Name> ShieldBoneNames;
/** Default Health amount of Head. A separate health bucket, to trigger "open arms" hit reaction. */
var() config const FLOAT	HeadDefaultHealth;
/** HealthBucketForRegularDamageTriggeringShield */
var() config const FLOAT    RegDMGShieldHealthBucket;
/** Time stun hit reaction is played, before creature goes to shielded position */
var() config const FLOAT	StunTime;
/** Minimum required stun time when creature is shot at with regular weapon */
var() config const FLOAT    MinStunTimeWhenShot;
/** Time creature stays in shielded position */
var() config const FLOAT	ShieldedTime;
/** Time Min time between two shield states. To prevent the creature from being always shielded and slow in COOP. */
var() config const FLOAT	TimeBetweenShieldState;
/** Speed creature moves at when shielded */
var() config const FLOAT	ShieldedGroundSpeed;
/** Damage taken by a chainsaw attack */
var() config const FLOAT	ChainsawAttackDamageTaken;
/** Time between two consecutive bugs bunny attacks. */
var() config const FLOAT    TimeBetweenUndergroundAttacks;
/** Tries to enforce a minimum of underground attack passes. By looking at how much damage the creature took, and forcing it underground. */
var() config const INT      TargetNumUndergroundAttackPasses;

/** Bones used to determine if the corpser should take damage */
var() config const array<Name> DamageBoneNames;

var() config float CringePushRadius;

//
// RepNotify Variables
//
/** Flag specifying if the Corpser is underground. */
var repnotify bool bIsUnderground;
/** Toggles Shielded mode */
var repnotify transient bool bIsShielded;

//
// Transient variables
//
/** Number of times creature went from stun to underground */
var transient INT NumTimesWentUnderground;
/** Number of underground attack attempts. */
var transient INT NumUndergroundAttackAttempts;
/** Time when creature last started its stunned state */
var transient FLOAT StartStunTime;
/** When Charging underground, was it successful or not? */
var transient bool bUndergroundChargeReachedTarget, bUndergroundChargeTimedOut;
/** If Corpser should push away players near him */
var transient bool bPushAwayPlayers;
/** Last Time Corpser exited his chainsaw victim special move. To add a delay before going underground */
var transient float LastChainsawVictimTime;

//
// Variables
//
/** Blend Node controlling Shielding */
var AnimNodeBlend ShieldBlendNode;
/** Health for Head */
var FLOAT HeadHealth;
/** Health to trigger shield when taking regular damage, and not stunned. */
var FLOAT RegDMGShieldHealth;
/** Last Time Shield State was triggered */
var transient FLOAT	LastShieldTime;

/** DestructibleObject targeted by this Corpser */
var transient GearDestructibleObject TargetDestructible;
/** Fortification targeted by this Corpser */
var transient GearFortification TargetFortification;

/** Sounds */
var Array<SoundCue> PreTunnelingSoundCueArray;

/** Body Armor attachments */
var StaticMeshComponent	BodyArmorSM, ButtArmorSM;
/** Corpser allowed to emerge from underground. If FALSE, just attack underground... */
var bool bAllowedToEmerge;
/** Flag set to notify this corpser should do his emergence once he has a controller. */
var protected transient bool bEmergeOnPossess;


/** Whether this is minicorpser is naked (had no armor) */
var bool bIsNaked;
/** Array of hit reaction animations */
var Array<Name> HitReactionAnims;
/** Index of last hit reaction animation played */
var transient INT LastHitReactionAnimIndex;
/** Timings for hit reaction animations. */
var transient FLOAT LastHitReactionAnimTime;

/** Quick EHole class to use for emerging */
var class<GearSpawner_QuickEHoleBase> CorpserQuickEHoleClass;

/** Class of projectile used to attack the player */
var class<GearProj_BabyCorpserTeleporter> TeleporterProjectileClass;
/** Class of projectile used to charge player */
var class<GearProj_BabyCorpserUndergroundBase> ChargeProjectileClass;
/** Projectile used to charge player */
var	GearProj_BabyCorpserUndergroundBase	ChargeProjectile;
/** Defines the explosion for above ground melee attack */
var() instanced editinline GearExplosion	ExplosionTemplate;
var() protected ParticleSystem CorpserEmergePS;

/* Material used to control the material params for emerging */
var transient MaterialInstanceConstant EmergeMaterial;

/** Foot Placement SkelControls for the front 4 legs */
var() GearSkelCtrl_FootPlacement FrontLegFootPlacementSkelControls[4];
/** Skel Control Names */
var const Name FrontLegFootPlacementSkelControlNames[4];
/** Mesh Translation Adjustment for leg adjustments */
var transient Vector MeshTranslationLegAdjust;

/** Sound to play during melee attack */
var SoundCue MeleeSound;

/** The last time we played a melee sound */
var transient float LastMeleeSoundTime;

/** The minimum time between melee sound plays */
var const config float MinTimeBetweenMeleeSound;

/** Enum of the kinds of damage the corpser received */
enum ECorpserDamageType
{
	ECORPSERDAMAGE_None,
	ECORPSERDAMAGE_Front,
	ECORPSERDAMAGE_Body,
};

/** List of encroachment actors attached to leg tips */
var array<LarvaCorpser_Encroacher> Encroachers;

var protected transient float LastBeastStompAttackTime;
var() protected config float MinTimeBetweenBeastModeStompAttacks;

replication
{
	// Server -> Clients
	if( Role == ROLE_Authority )
		bIsUnderground, TargetDestructible, TargetFortification, bUndergroundChargeReachedTarget;

	// !bIsUnderground && Server -> Clients
	if( !bIsUnderground && Role == ROLE_Authority )
		bIsShielded;
}

cpptext
{
	virtual UBOOL IsValidEnemyTargetFor(const APlayerReplicationInfo* OtherPRI, UBOOL bNoPRIIsEnemy)
	{
		return !bIsUnderground && Super::IsValidEnemyTargetFor(OtherPRI, bNoPRIIsEnemy);
	}

	/** Update the mesh component to make it match the Floor surface normal better */
	virtual void UpdateFloorConform(FLOAT DeltaSeconds);
}

/** Cache Foot Placement nodes for front legs. */
native simulated event CacheAnimNodes();

/** Clear references to anim nodes so AnimTree can be garbage collected. */
simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();

	FrontLegFootPlacementSkelControls[0] = None;
	FrontLegFootPlacementSkelControls[1] = None;
	FrontLegFootPlacementSkelControls[2] = None;
	FrontLegFootPlacementSkelControls[3] = None;

	ShieldBlendNode = None;
}

simulated function bool ShouldTurnCursorRedFor(GearPC PC, vector HitLocation, Name HitBone, PrimitiveComponent HitComponent)
{
	if( bIsUnderground && !IsDoingASpecialMove() )
	{
		return FALSE;
	}
	return Super.ShouldTurnCursorRedFor( PC, HitLocation, HitBone, HitComponent );
}

/**
 * Reticle plus for weak spots. The face & belly when the creature opens up.
 */
simulated function bool ShouldDisplayCrosshairPlus(GearPC PC, vector HitLocation, Name HitBone, PrimitiveComponent HitComponent)
{
	if( ShouldCorpserTakeDamage(HitLocation, None, HitBone, PC.Pawn) == ECORPSERDAMAGE_Front )
	{
		return TRUE;
	}

	return Super.ShouldDisplayCrosshairPlus(PC, HitLocation, HitBone, HitComponent);
}

function bool OverrideAimLocation(out vector AimLoc, vector StartLoc, GearAI ShooterAI)
{
	local float DotProd;

	if (!bIsNaked)
	{
		DotProd = vector(Rotation) dot Normal(StartLoc - Location);
		if (DotProd > 0.5f)     // 60 deg
		{
			// in front, aim at head
			AimLoc = Mesh.GetBoneLocation('head');
		}
		else
		{
			// on side and behind, aim at soft body part
			AimLoc = Mesh.GetBoneLocation('Lower_Spine_2');
		}

		return TRUE;
	}

	return FALSE;
}

/** Tells us if we can charge at an enemy.
 * #1 we can only be charging in one place at a time.
 */
function bool CanChargeAtEnemy()
{
	return !IsCharging();
}

/** Pre Tunneling sound. Corpser is underground, and about to burrow. */
function PlayPreTunnelingSound()
{
	if( PreTunnelingSoundCueArray.Length > 0 )
	{
		PlaySound(PreTunnelingSoundCueArray[Rand(PreTunnelingSoundCueArray.Length)]);
	}
}

/** Play the melee sound when the animation tells us to */
function ANIMNOTIFY_PlayMeleeSound()
{
	//`log(`showvar(`TimeSince(LastMeleeSoundTime)));

	if (`TimeSince(LastMeleeSoundTime) > MinTimeBetweenMeleeSound)
	{
		PlaySound(MeleeSound);
		LastMeleeSoundTime = WorldInfo.TimeSeconds;
	}
}

simulated event Destroyed()
{
	local int Idx;

	// Clear references.
	TargetDestructible = None;
	TargetFortification = None;

	for( Idx = 0; Idx < Encroachers.Length; Idx++ )
	{
		Encroachers[Idx].Destroy();
	}
	Encroachers.Length = 0;

	Super.Destroyed();
}

simulated event PostBeginPlay()
{
	local LarvaCorpser_Encroacher E;

	Super.PostBeginPlay();

	// Set default Head Health
	HeadHealth = HeadDefaultHealth;
	RegDMGShieldHealth = RegDMGShieldHealthBucket;

	// Set up Attachments
	if( Mesh != None )
	{
		if( BodyArmorSM != None )
		{
			Mesh.AttachComponentToSocket(BodyArmorSM, 'Spine2');
			BodyArmorSM.SetLightEnvironment( LightEnvironment );
			BodyArmorSM.SetShadowParent( Mesh );
		}
		if( ButtArmorSM != None )
		{
			Mesh.AttachComponentToSocket(ButtArmorSM, 'Butt');
			ButtArmorSM.SetLightEnvironment( LightEnvironment );
			ButtArmorSM.SetShadowParent( Mesh );
		}

		// ORDER OF ENCROACHERS MATTERS! DO NOT CHANGE
		E = Spawn( class'LarvaCorpser_Encroacher', Self );
		E.SetBase( self,, Mesh, 'L_Low_Hand' );
		E.SetRelativeLocation( vect(0,0,0) );
		E.LegIdx = 0;
		Encroachers[Encroachers.Length] = E;

		E = Spawn( class'LarvaCorpser_Encroacher', Self );
		E.SetBase( self,, Mesh, 'L_Up_Hand' );
		E.SetRelativeLocation( vect(0,0,0) );
		E.LegIdx = 1;
		Encroachers[Encroachers.Length] = E;

		E = Spawn( class'LarvaCorpser_Encroacher', Self );
		E.SetBase( self,, Mesh, 'R_Up_Hand' );
		E.SetRelativeLocation( vect(0,0,0) );
		E.LegIdx = 2;
		Encroachers[Encroachers.Length] = E;

		E = Spawn( class'LarvaCorpser_Encroacher', Self );
		E.SetBase( self,, Mesh, 'R_Low_Hand' );
		E.SetRelativeLocation( vect(0,0,0) );
		E.LegIdx = 3;
		Encroachers[Encroachers.Length] = E;
	}

	InitEmergeMaterials();
}

simulated function InitEmergeMaterials();

// hack to prevent encroachers from getting stuck on stuff in the level
function ResetEncroachers()
{
	local int Idx;

	for( Idx = 0; Idx < Encroachers.Length; Idx++ )
	{
		Encroachers[Idx].SetRelativeLocation(vect(0,0,0));
	}
}

/** Overriden, to start creature in its proper state */
simulated event SetInitialState()
{
	bScriptInitialized = TRUE;

	// If starting underground, setup creature that way.
	if( bIsUnderground )
	{
		SetupForUnderground();
	}
	else
	{
		SetupForUnderground();
		bIsUnderground = TRUE;
		if (Controller == None)
		{
			bEmergeOnPossess = TRUE;
		}
		else
		{
			SetIsUnderground(FALSE);
		}
	}

	SetPhysics(WalkingPhysics);

// 	`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "bIsUnderground:" @ bIsUnderground @ GetStateName());
}

simulated event ReplicatedEvent( name VarName )
{
	if( VarName == 'bIsShielded' )
	{
		ShieldStatusUpdated();
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
}

function bool SetIsUnderground(bool bNewValue)
{
	local int Idx;

	// if we want to dive underground, but the location does not allow it. Do a melee attack as a fallback action.
	if( bNewValue && (GearAI(Controller) != None) && !IsLocationBabyCorpserSafe(WorldInfo, Location) )
	{
		// Consider Corpser went underground for a number of gameplay things
		HeadHealth = HeadDefaultHealth;
		RegDMGShieldHealth = RegDMGShieldHealthBucket;
		NumTimesWentUnderground++;
		SetShieldStatus(FALSE);

		// End the Stunned special move if it's still playing.
		ServerEndSpecialMove(GSM_CorpserLarva_DanceIntro);

		// Do a melee attack instead of digging underground.
		GearAI(Controller).DoMeleeAttack();

		return FALSE;
	}

	// no going underground in Beast
	if ( (bIsUnderground != bNewValue) && ( bNewValue == FALSE || GearPC_Siege(Controller) == None) )
	{
		bIsUnderground = bNewValue;
		bForceNetUpdate = TRUE;

		// Have AI reset it's movement when switching underground/above ground states
		// Doing this before special moves, so it doesn't abort special move ai commands.
		GearAI_CorpserLarvaUnderground(Controller).IsUndergroundChangeNotify();
		// Set default Head Health
		HeadHealth = HeadDefaultHealth;
		RegDMGShieldHealth = RegDMGShieldHealthBucket;

		// Start special moves for transitions.
		if( bIsUnderground )
		{
			// Clear Shielded Status
			NumTimesWentUnderground++;
			SetShieldStatus(FALSE);
			ServerDoSpecialMove(GSM_CorpserLarva_GoUnderground, TRUE);

			SetTimer(2.f, FALSE, 'SpawnEHole');
		}
		else
		{
			// Clear variables that only matter when underground
			TargetDestructible = None;
			TargetFortification = None;

			// Emerge Special Move
			ServerDoSpecialMove(SM_Emerge_Type1, TRUE);

			SetTimer(0.25f, FALSE, 'SpawnEHole');
		}

		for( Idx = 0; Idx < Encroachers.Length; Idx++ )
		{
			Encroachers[Idx].SetCollision( !bIsUnderground, !bIsUnderground );
		}

		WarnAttackIncoming();

		return TRUE;
	}

	return FALSE;
}

function SpawnEHole()
{
	local GearSpawner_QuickEHoleBase EHole;
	local Vector SpawnLoc;
	local Rotator SpawnRotation;
	local GearAI AI;

	SpawnLoc = Location - (Floor * (GetCollisionHeight() + 32.f));
	SpawnRotation = Rotator(Floor);
	SpawnRotation.Pitch -= 16384;

	AI = GearAI(Controller);
	if( AI != None )
	{
		SpawnLoc = AI.NavigationHandle.MoveToDesiredHeightAboveMesh(Location + vect(0,0,64), 0.f);
	}

	EHole = Spawn(CorpserQuickEHoleClass,,, SpawnLoc, SpawnRotation,, TRUE);
	EHole.Instigator = self;
	EHole.StartOpening();
}

/** Setup Corpser for Underground */
simulated function SetupForUnderground()
{
	local int Idx;

	GotoState('Underground');

	Mesh.SetHidden(TRUE);
	Mesh.SetTraceBlocking(FALSE, FALSE);
	Mesh.SetBlockRigidBody(FALSE);
	if( BodyArmorSM != None )
	{
		BodyArmorSM.SetHidden(TRUE);
	}
	if( ButtArmorSM != None )
	{
		ButtArmorSM.SetHidden(TRUE);
	}

	// Remove blocking collision when going underground.
	// We don't want players to be blocked by invisible Corpser.
	SetCollision(FALSE, FALSE, bIgnoreEncroachers);

	if( Role == ROLE_Authority )
	{
		// Reset our number of attempts.
		NumUndergroundAttackAttempts = 0;
	}

	for( Idx = 0; Idx < Encroachers.Length; Idx++ )
	{
		Encroachers[Idx].SetCollision( FALSE, FALSE );
	}
}

simulated function SetupForAboveGround()
{
	GotoState('AboveGround');
	Mesh.SetHidden(FALSE);
	Mesh.SetTraceBlocking(default.Mesh.BlockZeroExtent, default.Mesh.BlockNonZeroExtent);
	Mesh.SetBlockRigidBody(default.Mesh.BlockRigidBody);
	if( BodyArmorSM != None )
	{
		BodyArmorSM.SetHidden(FALSE);
	}
	if( ButtArmorSM != None )
	{
		ButtArmorSM.SetHidden(FALSE);
	}

	// Restore blocking collision when emerging.
	SetCollision(TRUE, TRUE, bIgnoreEncroachers);
	if( !FitCollision() )
	{
		`warn("AHHHHHHHH - corpser turned collision back on, and something bad happened. :(");
	}
}

/** State the Pawn is in when he is Underground. */
state Underground
{
	/** Damage disabled when underground. Can't kill creature. */
	ignores TakeDamage;

	/** Cannot be special melee attack when underground. **/
	simulated function bool CanBeSpecialMeleeAttacked(GearPawn Attacker)
	{
		return false;
	}

	/** TRUE if is currently charging at an enemy. */
	function bool IsCharging()
	{
		return (ChargeProjectile != None && !ChargeProjectile.bPendingDelete);
	}

	function bool ChargeAtEnemy(Pawn Enemy)
	{
		if( !CanChargeAtEnemy() )
		{
			return FALSE;
		}

		// Spawn our projectile
		ChargeProjectile = Spawn(ChargeProjectileClass, Self,, Location, Rotation,, TRUE);

		// Initialize it - Aim for our enemy
		ChargeProjectile.Init( Normal(Enemy.Location - Location) );

		return TRUE;
	}

	function bool ChargeEmergeAt(Pawn Enemy)
	{
		if( !CanChargeAtEnemy() )
		{
			return FALSE;
		}

		// Spawn our projectile
		ChargeProjectile = Spawn(TeleporterProjectileClass, Self,, Location, Rotation,, TRUE);

		// Initialize it - Aim for our enemy
		ChargeProjectile.Init( Normal(Enemy.Location - Location) );

		return TRUE;
	}

	function bool ChargeAtDestructible()
	{
		if( IsCharging() || !IsValidDestructibleTarget(TargetDestructible) )
		{
			return FALSE;
		}

		// Spawn our projectile
		ChargeProjectile = Spawn(ChargeProjectileClass, Self,, Location, Rotation,, TRUE);

		// Initialize it - Aim for our target
		ChargeProjectile.InitForDestructible( Normal(TargetDestructible.Location - Location), TargetDestructible );

		return TRUE;
	}

	function bool ChargeAtFortification()
	{
		// Make sure we have a valid fortification to attack.
		if( IsCharging() || !IsValidFortificationTarget(TargetFortification) )
		{
			return FALSE;
		}

		// Spawn our projectile
		ChargeProjectile = Spawn(ChargeProjectileClass, Self,, Location, Rotation,, TRUE);

		// Initialize it - Aim for our target
		ChargeProjectile.InitForFortification( Normal(TargetFortification.Location - Location), TargetFortification );

		return TRUE;
	}
}

/** Cannot be special melee attack when underground. **/
simulated function bool CanBeSpecialMeleeAttacked(GearPawn Attacker)
{
	if( !Attacker.IsHumanControlled() )
	{
		return FALSE;
	}
	return Super.CanBeSpecialMeleeAttacked( Attacker );
}

/** Instruct Pawn to charge at given enemy.
 * What this will do is fire a projectile that simulates the Corpser charging UnderGround.
 */
function bool ChargeAtEnemy(Pawn Enemy)
{
	return FALSE;
}

/** Charge, with goal to emerge from underground */
function bool ChargeEmergeAt(Pawn Enemy)
{
	return FALSE;
}
/** Charge at destructible */
function bool ChargeAtDestructible()
{
	return FALSE;
}
/** Charge at fortification */
function bool ChargeAtFortification()
{
	return FALSE;
}
/** Tells us if we're tracking a valid destructible object */
function bool IsValidDestructibleTarget(GearDestructibleObject InDestructible)
{
	return InDestructible != None && InDestructible.IsAlive();
}
/** Tells us if we're tracking a valid fortification object */
function bool IsValidFortificationTarget(GearFortification InFortification)
{
	return InFortification != None && InFortification.Health > 0;
}

/** TRUE if is currently charging at an enemy. */
function bool IsCharging()
{
	return FALSE;
}

function FoundSpotToEmerge(vector EmergeLocation, rotator EmergeRotation)
{
	// Success!
	bUndergroundChargeReachedTarget = TRUE;
	// Teleport to found location
	GearAI(Controller).TeleportToLocation(EmergeLocation, EmergeRotation);
	// Emerge!!
	SetIsUnderground(FALSE);
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

/** Tests based on hit information if Corpser should take damage or not.
 *  Chainsaw is valid, otherwise it has to hit either the head or the belly from the front.
 */
simulated function ECorpserDamageType ShouldCorpserTakeDamage(vector HitLocation, class<DamageType> InDamageType, Name HitBoneName, Pawn InstigatedBy, optional vector RayDir)
{
	local vector HitDir, CheckHitLoc;
	local ECorpserDamageType TakingDamage;
	local Class<GearDamageType>    GDT;
	local TraceHitInfo HitInfo;

	GDT = Class<GearDamageType>(InDamageType);
	if ((InDamageType == class'GDT_EmergenceHoleOpening' && IsDoingSpecialMove(SM_Emerge_Type1)) || InstigatedBy == self)
	{
		// ignore damage from my own ehole opening
		return ECORPSERDAMAGE_None;
	}

	// Besides chainsaw damage, make sure it hits the head and belly, from the front.
	TakingDamage = ECORPSERDAMAGE_Body;

	if (HitBoneName == '')
	{
		// try to find a hit bone
		if (IsZero(RayDir))
		{
			// assume dir is from hit loc to center of the corpser
			HitDir = Normal(Location - HitLocation);
		}
		else
		{
			HitDir = Normal(RayDir);
		}

		CheckHitLoc = HitLocation;          // let's not change HitLocation
		CheckHitInfo(HitInfo, Mesh, HitDir, CheckHitLoc);

		// use this bone
		HitBoneName = HitInfo.BoneName;

//		`log("CheckHitInfo got bonename"@HitBoneName);
//		DrawDebugLine(HitLocation-HitDir*128, HitLocation+HitDir*128, 255, 88, 88, TRUE);
	}

	if( InDamageType == class'GDT_HeavySniperRifle' || (GDT != None && GDT.default.bDamagesBabyCorpser) )
	{
		// Heavy sniper damage should not be nerfed
		TakingDamage = ECORPSERDAMAGE_Front;
	}
	else if( InDamageType != class'GDT_Chainsaw' )
	{
		// If we have a hit bone, use that information for precise hit location.
		if( HitBoneName != '' )
		{
			// If they didn't hit any of the damageable bones
			if( DamageBoneNames.Find(HitBoneName) == INDEX_NONE && !bIsNaked )
			{
// 				`log("	failed to hit head/belly :(");
				TakingDamage = ECORPSERDAMAGE_None;
			}
			// If they hit the head/belly we are going to  make sure it was from the front
			else if ( HeadBoneNames.Find(HitBoneName) != INDEX_NONE )
			{
				TakingDamage = ECORPSERDAMAGE_Front;
			}
		}
		// If we couldn't find a a bone, go by shielded status
		else
		{
			// If shielded when radial damage, just protect ourselves against any kind of damage from the front
			if( bIsShielded && !bIsNaked )
			{
// 		        `log("	radial damage, shielded. :(");
				TakingDamage = ECORPSERDAMAGE_None;
			}
		}
	}

// 	`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ InDamageType @ HitBoneName @ InstigatedBy @ TakingDamage);

	return TakingDamage;
}

/** MiniCorpser should always have damage modifier functions called. */
simulated function SetDontModifyDamage( bool NewValue );

/** Corpser cannot be chainsawed from behind */
simulated function bool CanBeChainsawedFromBehind()
{
	return FALSE;
}

/** State the Pawn is in when he is above ground. */
state AboveGround
{
	/**
	 *  Impact Effects are handled in TakeDamage->DoDamageEffects. But only if there damage done.
	 *  If there is no damage done, but you still want an impact effect to be played, return TRUE here.
	 */
	simulated function bool ShouldPlayNonDamageHitEffects(const out ImpactInfo Impact, Pawn InstigatedBy, class<DamageType> InDamageType)
	{
		// Mirror of AdjustPawnDamage...
		if( IsDoingSpecialMove(GSM_CorpserLarva_GoUnderground) )
		{
			return TRUE;
		}

		// If damage is blocked, then we need to play impact effects here instead...
		if( ShouldCorpserTakeDamage(Impact.HitLocation, InDamageType, Impact.HitInfo.BoneName, InstigatedBy, Impact.RayDir) == ECORPSERDAMAGE_None )
		{
			return TRUE;
		}

		return Super.ShouldPlayNonDamageHitEffects(Impact, InstigatedBy, InDamageType);
	}

	/** Modify Pawn Damage. Shielded Legs will block damage */
	function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
					class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
	{
		local ECorpserDamageType TakingDamage;

		// If this is not a damage type that the Corpser is sensible to, reduce by half.
		if( !GearDamageType.default.bDamagesBabyCorpser )
		{
			//`log("does not have bDamagesBabyCorpser, so reduce damage:" @ Damage);
			Damage /= 2;
		}

		Super.AdjustPawnDamage(Damage, InstigatedBy, HitLocation, Momentum, GearDamageType, DamageCauser, HitInfo);

		// Don't care about self inflicted damage
		if( Damage == 0 || InstigatedBy == Self )
		{
// 			`log("  Damage == 0 || InstigatedBy == Self" @ Damage @ InstigatedBy);

			Damage = 0;
			return;
		}

		// Don't take damage when going underground. Wait until Corpser comes back out again.
		if( IsDoingSpecialMove(GSM_CorpserLarva_GoUnderground) )
		{
// 			`log("	IsDoingSpecialMove(GSM_CorpserLarva_GoUnderground)");
			Damage = 0;
			return;
		}

		// Figure out if Corpser should take damage or not.
		// (can only be shot in the face and belly, from the front) (shot in the lobster tail had been added).
		TakingDamage = ShouldCorpserTakeDamage(HitLocation, GearDamageType, HitInfo.BoneName, InstigatedBy, Momentum);

		// If not stunned and not taking damage, then look at triggering shield phase
		if( TakingDamage == ECORPSERDAMAGE_None && !IsStunned() && !IsDoingSpecialMove(SM_ChainSawVictim)
			&& `TimeSince(LastShieldTime) > TimeBetweenShieldState && !IsHumanControlled())
		{
			// don't auto-shield in Beast, user controls this
			RegDMGShieldHealth -= Damage;
			if( RegDMGShieldHealth <= 0 )
			{
				RegDMGShieldHealth = RegDMGShieldHealthBucket;
				ShieldCorpser(ShieldedTime);
			}
		}

		// If not taking damage, then block it!
		if( TakingDamage == ECORPSERDAMAGE_None )
		{
			Damage = 0;
			return;
		}
		// Damage to body is 1/2 of what the front takes
		// human controlled Corpsers don't get into the vulnerable state so this ends up being overkill
		else if (TakingDamage == ECORPSERDAMAGE_Body && !IsHumanControlled())
		{
			Damage *= 0.5f;
		}

		// If grenade tagged, then cap the damage made to a full damage bucket.
		// This is to prevent killing the creature instantly
		if( ClassIsChildOf(GearDamageType, class'GDT_FragTag') )
		{
			Damage = Min(Damage, DefaultHealth / (TargetNumUndergroundAttackPasses + 1));
		}

// 		`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "took damage!" @ GearDamageType @ Damage @ HitInfo.BoneName @ "InstigatedBy:" @ InstigatedBy);
	}

	/**
	 * Creates any damage effects, sounds, anims, etc.
	 * Called from TakeDamage(), so only called on ROLE_Authority.
	 * Extended to take into account head specific damage
	 */
	function DoDamageEffects(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, const out TraceHitInfo HitInfo)
	{
		local INT HealthTarget;

 		// Don't care about self inflicted damage
		if( InstigatedBy != Self && Health > 0 )
		{
			// Stunned / Vulnerable State
			if( IsStunned() || (IsDoingSpecialMove(SM_ChainSawVictim) && DamageType == class'GDT_Chainsaw') )
			{
				// If Corpser is sensible to this damage type, then send underground right away
				if( DamageType == class'GDT_Chainsaw' )
				{
// 					`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "send underground because stunned and shot by super weapon:" @ DamageType);
					EndStun();
					SetIsUnderground(TRUE);
				}
				else
				{
					HealthTarget = float(DefaultHealth) * (float(TargetNumUndergroundAttackPasses - NumTimesWentUnderground) / float(TargetNumUndergroundAttackPasses + 1));
					if( Health < HealthTarget )
					{
						// Only end stun after the intro anim is done playing
						if( !BS_IsPlaying(GSM_CorpserLarva_DanceIntro(SpecialMoves[GSM_CorpserLarva_DanceIntro]).BS_Intro) )
						{
	// 						`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "send underground because below HealthTarget" @ HealthTarget @ "for TargetNumUndergroundAttackPasses.");
							EndStun();
							// And send Corpser underground
							SetIsUnderground(TRUE);
						}
					}
				}
			}
			// not Stunned
			else
			{
				// Damage taken in the head has a special bucket
				// Head damage disabled when shielded, or when doing "open legs" head hit reaction.
				if( !IsDoingSpecialMove(SM_ChainSawVictim) && !IsDoingSpecialMove(GSM_CorpserLarva_DanceOutro) && !IsDoingSpecialMove(GSM_CorpserLarva_Melee) )
				{
					HeadHealth -= Damage;

					// See if we should trigger hit reaction to head damage
					if( HeadHealth <= 0 && Health > 0 )
					{
						// Reset Health for Head for next time
						HeadHealth = HeadDefaultHealth;
						// Stun creature
						StartStun();
					}
				}
			}
		}

		Super.DoDamageEffects(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
	}

	simulated function ReplicatedPlayTakeHitEffects()
	{
		// Temp hit reaction overlay while doing the arms up thing.
		if( IsDoingSpecialMove(GSM_CorpserLarva_DanceIntro) || !IsDoingASpecialMove() )
		{
			PlayCorpserHitReactionAnimation();
		}

		Super.ReplicatedPlayTakeHitEffects();
	}

	/** Can only be chainsawed during head hit reaction */
	simulated function bool CanBeChainsawAttacked()
	{
		return IsDoingSpecialMove(GSM_CorpserLarva_DanceIntro);
	}
}

/** Play Hit Reaction animation */
simulated function bool PlayCorpserHitReactionAnimation()
{
	local BodyStance	BS_HitReaction;
	local INT			AnimIndex;
	local Name			AnimName;

	// Don't play hit reaction animations too often.
	if( `TimeSince(NextHitReactionAnimTime) < 0 )
	{
		return FALSE;
	}

	// Play a random animation
	AnimIndex = Rand(HitReactionAnims.Length);

	// Make sure we play two different animations in a row if hit less and a second ago.
	if( LastHitReactionAnimIndex == AnimIndex && `TimeSince(LastHitReactionAnimTime) < 2.f )
	{
		AnimIndex += FRand() < 0.5 ? +1 : -1;
		if( AnimIndex >= HitReactionAnims.Length )
		{
			AnimIndex = 0;
		}
		else if( AnimIndex < 0 )
		{
			AnimIndex = HitReactionAnims.Length - 1;
		}
	}

	//`DLog("Picked Index:" @ AnimIndex @ HitReactionAnims[AnimIndex] @ "Last Index:" @ LastHitReactionAnimIndex @ "TimeSinceLast:" @ `TimeSince(LastHitReactionAnimTime));
	AnimName = HitReactionAnims[AnimIndex];
	LastHitReactionAnimIndex = AnimIndex;
	LastHitReactionAnimTime = WorldInfo.TimeSeconds;
	if( AnimName != '' )
	{
		BS_HitReaction.Stance.Length = 1; // Array of struct needs to be pre-sized.
		BS_HitReaction.Stance[0].Slot = BS_Additive;
		BS_HitReaction.Stance[0].AnimName = AnimName;

		NextHitReactionAnimTime = WorldInfo.TimeSeconds + RandRange(0.45f, 0.67f);

		return (BS_Play(BS_HitReaction, 1.f, 0.2f, 0.33f) > 0.f);
	}

	return FALSE;
}

/** Play death effects: animation, sounds, physics... */
simulated function PlayDeath(class<GearDamageType> GearDamageType, vector HitLoc)
{
	local BodyStance    BS_DeathAnim;

	BS_DeathAnim.Stance.Length = 1; // Array of struct needs to be pre-sized.
	BS_DeathAnim.Stance[0].Slot = BS_FullBody;
	BS_DeathAnim.Stance[0].AnimName = 'death_back';

	BS_Play(BS_DeathAnim, 1.f, 0.33f, -1.f);
	SetDrawScale(0.75f);
}

/** Notification called when Chainsaw Attack towards this Pawn has ended */
function ChainsawAttackedEndedNotification(GearPawn InstigatedBy)
{
	// if our chainsaw attack is going to leave the corpser with little health left, just finish him off.
	// We want to avoid the "one bullet kills huge creature" syndrome.
	// Want death to happen with a bang.
	if( (Health - ChainsawAttackDamageTaken) > HeadDefaultHealth )
	{
		TakeDamage(ChainsawAttackDamageTaken, InstigatedBy.Controller, Location, Vect(0,0,0), class'GDT_Chainsaw');
	}
	else
	{
		// Score execution
		GearPRI(InstigatedBy.PlayerReplicationInfo).ScoreExecution(GearPRI(Self.PlayerReplicationInfo), class'GDT_Chainsaw', GDT_NORMAL);
		// Kill
		TakeDamage(Health * 2.f, InstigatedBy.Controller, Location, Vect(0,0,0), class'GDT_Chainsaw');
	}

	// Send underground after a successful chainsaw attack.
	if( Health > 0 )
	{
		SetIsUnderground(TRUE);
	}
}

/** Is Corpser Stunned? */
function bool IsStunned()
{
	return IsDoingSpecialMove(GSM_CorpserLarva_DanceIntro);
}

function StartStun()
{
	// no stun in Beast
	if (GearPC_Siege(Controller) == None)
	{
		// Start the special move.
		ServerDoSpecialMove(GSM_CorpserLarva_DanceIntro, TRUE);
		StartStunTime = WorldInfo.TimeSeconds;
		`log(WorldInfo.TimeSeconds @ Self @ GetFuncName());
		// It will loop indefinitely, so setup a timer to end this special move, if Corpser hasn't been chainsawed.
		SetTimer(StunTime, FALSE, 'EndStun');

		if (MyGearAI!=none)
		{
			MyGearAI.ClearMovementInfo();
		}
	// 	// Set the Corpser to be shielded. Unshield after a little while
	// 	ShieldCorpser(StunTime+ShieldedTime);
	}
}

/** Check to see if Corpser is still doing the head hit reaction, and if so, end it */
function EndStun()
{
	// If we're still doing the hit reaction, now it's time to end it.
	if( IsDoingSpecialMove(GSM_CorpserLarva_DanceIntro) )
	{
		ClearTimer('EndStun');
		// Send underground after being stunned.
		if( Health > 0 )
		{
			SetIsUnderground(TRUE);
		}
// 		ServerDoSpecialMove(GSM_CorpserLarva_DanceOutro, TRUE);
// 		`log(WorldInfo.TimeSeconds @ Self @ GetFuncName());
	}
}

reliable server function ServerShieldCorpser(float Duration)
{
	ShieldCorpser(Duration);
}
reliable server function ServerUnshieldCorpser()
{
	UnShieldCorpser();
}

function ShieldCorpser(FLOAT Duration)
{
	// If not already shielded, shield!
	if( !bIsShielded )
	{
		SetShieldStatus(TRUE);
		SetTimer(Duration, FALSE, 'UnShieldCorpser');
	}
	else
	{
		// Otherwise update timer to which ever is longest (previous or new call).
		SetTimer(FMax(Duration, GetTimerRate('UnShieldCorpser')), FALSE, 'UnShieldCorpser');
	}
}

/** Called from timer to unshield corpser */
function UnShieldCorpser()
{
	SetShieldStatus(FALSE);
}

function SetShieldStatus(bool bNewShieldStatus)
{
	if( bIsShielded != bNewShieldStatus )
	{
		bIsShielded = bNewShieldStatus;
		bForceNetUpdate = TRUE;

		// Clear timer if it was set.
		ClearTimer('UnShieldCorpser');

		ShieldStatusUpdated();
	}
}

/** Event called when bIsShielded changes status */
simulated function ShieldStatusUpdated()
{
	if( bIsShielded )
	{
		LastShieldTime = WorldInfo.TimeSeconds;
		// Toggle animation branch in AnimTree
		ShieldBlendNode.SetBlendTarget(1.f, 0.42f);
		// Set ground speed based on shielded state
		GroundSpeed = ShieldedGroundSpeed;
	}
	else
	{
		// Toggle animation branch in AnimTree
		ShieldBlendNode.SetBlendTarget(0.f, 0.42f);
		// Set ground speed based on shielded state
		GroundSpeed = DefaultGroundSpeed;
	}
}

/** Override this as we don't want the Corpser to take fire damage over time. */
simulated exec function IgnitePawn(PawnOnFireState NewState, optional Controller FireInstigator, optional class<GearDamageType> DamageType, optional float Duration);

final function StartPushAwayPlayers()
{
	// Set flag now, we'll let players be put in that state in the tick function.
	bPushAwayPlayers = TRUE;
}

final function StopPushAwayPlayers()
{
	local GearPawn_Infantry InfantryPawn;

	bPushAwayPlayers = FALSE;

	// Force all Pawns in that special move to stop it.
	foreach WorldInfo.AllPawns(class'GearPawn_Infantry', InfantryPawn)
	{
		// If Pawn is doing SM_CoverHeadPushed special move instigated by us, release him now.
		if( InfantryPawn.IsDoingSpecialMove(SM_CoverHeadPushed) && InfantryPawn.InteractionPawn == self )
		{
			InfantryPawn.ServerEndSpecialMove(SM_CoverHeadPushed);
		}
	}
}

simulated function Tick(float DeltaTime)
{
	local GearPawn_Infantry InfantryPawn;

	Super.Tick(DeltaTime);

	if (bPushAwayPlayers && Role == ROLE_Authority)
	{
		// Push Away players
		foreach WorldInfo.AllPawns(class'GearPawn_Infantry', InfantryPawn)
		{
			// Within Radius, Push
			if ( VSize(InfantryPawn.Location - Location) <= CringePushRadius &&
				(GearGameSiege_Base(WorldInfo.Game) == None || !WorldInfo.GRI.OnSameTeam(InfantryPawn, self)) )
			{
				// If Pawn is already doing the special move, skip
				if (!InfantryPawn.IsDoingSpecialMove(SM_CoverHeadPushed) && (IsDoingSpecialMove(SM_CoverHead) || InfantryPawn.CanCoverHead()) )
				{
					// Quick check for world obstructions
					if (FastTrace(InfantryPawn.Location, Location,, true))
					{
						// Send Pawn into special move.
						InfantryPawn.ServerDoSpecialMove(SM_CoverHeadPushed, false, self);
					}
				}
			}
			// Outside of boundaries, release
			else
			{
				// If Pawn is doing SM_CoverHeadPushed special move instigated by us, release him now.
				if (InfantryPawn.IsDoingSpecialMove(SM_CoverHeadPushed) && InfantryPawn.InteractionPawn == self)
				{
					InfantryPawn.ServerEndSpecialMove(SM_CoverHeadPushed);
				}
			}
		}
	}
}

function WarnAttackIncoming()
{
	local GearAI AI;

	foreach WorldInfo.AllControllers( class'GearAI', AI )
	{
		AI.ReactionManager.NudgeChannel( self, 'WarnProjExplode' );
	}
}

function bool ShouldOtherEvadeMeInsteadOfMeleeing(GearPawn Other)
{
	return true;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	super.PossessedBy(C, bVehicleTransition);

	// once we've got a controller, go ahead and emerge if we're supposed to
	if (bEmergeOnPossess)
	{
		SetIsUnderground(FALSE);
	}
}

/** Trigger melee damage and effect */
simulated function DoMeleeImpact()
{
	local vector Out_HitLocation, Out_HitNormal, StartTrace, EndTrace;
	local Actor HitActor;

	// test forward to finger location (they can clip, so make sure not punching through wall)
	StartTrace = Location;
	StartTrace.Z += CylinderComponent.CollisionHeight;
	EndTrace = StartTrace + Vector(Rotation) * 190.0;
	if (Trace(Out_HitLocation, Out_HitNormal, EndTrace, StartTrace, false, vect(1,1,1)) != None)
	{
		StartTrace = Out_HitLocation;
		EndTrace = StartTrace;
	}
	else
	{
		StartTrace = EndTrace;
	}

	// test down, place explosion on the ground
	EndTrace.Z -= CylinderComponent.CollisionHeight * 3.0;
	HitActor = Trace(Out_HitLocation, Out_HitNormal, EndTrace, StartTrace, false, vect(1,1,1));
	if (HitActor != None)
	{
		TriggerExplosion(Out_HitLocation, Out_HitNormal, HitActor);
	}
}

/**
 * Trigger explosion.
 */
simulated function TriggerExplosion(Vector HitLocation, Vector HitNormal, Actor HitActor)
{
	local GearExplosionActor ExplosionActor;

	if (ExplosionTemplate != None)
	{
		// using a hitlocation slightly away from the impact point is nice for certain things
		HitLocation += (HitNormal * 32.0);

		ExplosionActor = Spawn(class'GearExplosionActor',,, HitLocation, Rotation);
		if (ExplosionActor != None)
		{
			ExplosionActor.Instigator = self;
			ExplosionActor.InstigatorController = Controller;

			ExplosionTemplate.InitFromContentTemplate();
			// these are needed for the decal tracing later in GearExplosionActor.Explode()
			ExplosionTemplate.HitActor = HitActor;
			ExplosionTemplate.HitLocation = HitLocation;
			ExplosionTemplate.HitNormal = HitNormal;

			// If desired, attach to mover if we hit one
			if (InterpActor(HitActor) != None)
			{
				ExplosionActor.Attachee = HitActor;
				ExplosionTemplate.bAttachExplosionEmitterToAttachee = true;
				ExplosionActor.SetBase(HitActor);
			}

			ExplosionActor.Explode(ExplosionTemplate, vector(Rotation));		// go bewm
		}
	}
}

function OnUnlockCorpserLarvaUnderground(SeqAct_UnlockCorpserLarvaUnderground Action)
{
	// Allow Corpser to emerge now. :)
	bAllowedToEmerge = TRUE;
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local int Idx;

	for (Idx = 0; Idx < Encroachers.Length; Idx++)
	{
		Encroachers[Idx].Destroy();
	}
	Encroachers.Length = 0;

	Super.PlayDying(DamageType, HitLoc);
}

simulated function BeastModeStompAttack()
{
	if (`TimeSince(LastBeastStompAttackTime) > MinTimeBetweenBeastModeStompAttacks)
	{
		LocalDoSpecialMove(GSM_CorpserLarva_Melee);
		LastBeastStompAttackTime = WorldInfo.TimeSeconds;
	}
}

defaultproperties
{
	bAllowedToEmerge=TRUE
	bIsUnderground=FALSE

	HitReactionAnims(0)="ADD_hit_react_head"
	HitReactionAnims(1)="ADD_hit_react_left"
	HitReactionAnims(2)="ADD_hit_react_right"

	FrontLegFootPlacementSkelControlNames(0)="Left_Up"
	FrontLegFootPlacementSkelControlNames(1)="Right_Up"
	FrontLegFootPlacementSkelControlNames(2)="Left_Low"
	FrontLegFootPlacementSkelControlNames(3)="Right_Low"

	Begin Object Name=CollisionCylinder
		CollisionHeight=90
		CollisionRadius=72
	End Object

	ControllerClass=class'GearAI_CorpserLarvaUnderground'

	bUseSimplePhysicalFireStartLoc=TRUE
	bAllowInventoryDrops=FALSE
	bCanPlayPhysicsHitReactions=FALSE
	bCanDo360AimingInCover=FALSE
	bCanDoRun2Cover=FALSE
	bShouldChainsawAttackInstantKillMe=FALSE
	bCanBeHealed=false

	bCanDoFloorConform=TRUE
	bDoFloorConform=TRUE
	bDoFullMeshFloorConform=TRUE
	bDoIKFloorConformCOM=FALSE
	bDoFootPlacement=FALSE

	SpecialMoveClasses.Empty

	NoticedGUDSEvent=GUDEvent_NoticedMiniCorpser
	SiegeTutorialType=GEARTUT_SIEGE_MiniCorpser

	ViewPitchMin=-12000
	ViewPitchMax=6000
}
