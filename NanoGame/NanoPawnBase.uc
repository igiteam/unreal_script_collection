/**
 * NanoPawnBase
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawnBase extends GamePawn
	implements( NanoInterface_CanAffectChaos, NanoInterface_CanAffectRebelMindShare, NanoInterface_Objective, NanoInterface_OrbitalTarget )
	dependson(NanoDamageType,NanoTypes,NanoCausingChaosValues,NanoMissionManager)
	config(Pawn)
	native(Pawn)
	abstract;

`define attackers_log(msg)	`loginfo('Nano_Attackers',WorldInfo.TimeSeconds@`msg)

cpptext
{
	// Never try to jump over a wall
	virtual UBOOL TryJumpUp(FVector Dir, FVector Destination, DWORD TraceFlags, UBOOL bNoVisibility) { return FALSE; }
private:
	void HeadTrackInterp( const FRotator & AimDeltaRot, const FRotator & HeadTrackDeltaRot, FRotator & OutDeltaRot );
	void UpdateHeadTrackInterp( const FLOAT & DeltaTime );
}

/** ANIMTREE: True when we want to show hammer instead of regular jumping animations */
var transient bool bUseHammerAnim;
/** ANIMTREE: Used to blend in impaled pose */
var transient bool bFlyingBackPose;
/** ANIMTREE: TRUE if you have no weapon out */
var transient bool bEmptyHanded;
/** ANIMTREE: Use the 'holding tackled actor' sprint instead. */
var transient bool bHoldingTackledActor;
/** ANIMTREE: Do we currently have the nano sword of justice active? */
var transient bool	bIsSwordActive;

// needed by camera system
var transient float LastShotAtTime;
/** camera bone motion scale */
var float CameraBoneMotionScale;

/** Configurable health setting */
var() config int DefaultHealth;

/** Should we enable debug damage text for tracking? */
var globalconfig bool bDebugDamageText;

var transient bool bIsFiringWeapon;
var transient float LastWeaponStartFireTime;
var transient float LastWeaponEndFireTime;

/** This is the range that Pawns can MeleeAttack in Unarmed. */
var() config float UnarmedMeleeRange;

/** Scale melee damage for AI driven pawns by this */
var config float AI_MeleeDamageScale;

/** The time we last did a melee attack **/
var transient float LastMeleeAttackTime;

/** Last time we caused crowd members to panic **/
var transient float LastCausedCrowdPanicTime;

/** TRUE for pawns that should not be killed (e.g. NPC quest givers) */
var() bool bPawnInvulnerable;

/** TRUE for pawns that are stunned in some way (ie KnockedDown) */
var transient bool bStunned;
var transient float TimeOfStun;

var transient bool bDoNoHitReaction;
var transient byte NoHitReactionPriority;

// portions of this should be promoted to GameFramework.  (e.g. all of the parts that POIs, objectives, etc. need)

/** Socket names */
var	const Name HeadSocketName;
var	const Name LeftHandSocketName;
var	const Name RightHandSocketName;

/** List of bone names used for validating head/leg shots. And the first will be use to determine the head position for head tracking */
var() config array<Name> HeadBoneNames;
var() config array<Name> LegBoneNames;

/** standard head center offset from head bone for multiplayer */
var(head) vector HeadBoneOffset;

/** Standard head sphere radius for checking headshots */
var(head) float HeadshotRadius;

/** Whether to draw spheres to indicate headshot area */
var globalconfig bool bWeaponDebug_HeadShotLocation;


/** This is the bone to use for melee damage hit location  */
var()	name	MeleeDamageBoneName;

/** Pawn ref used for Pawn to Pawn Interactions */
var	transient NanoPawn				InteractionPawn;
var transient EPawnInteractionType	InteractionType;
var transient bool                  InteractionPawn_AllowShootingOverride;

// this is to just get us up and running.  We probably want some other BaseBase class which has Nano Specific functionality that doesn't really
// change that much

/** Because we do a special move for the DenseBash, we need to store off some variables that the special move doesn't have passed in but needs **/
var transient vector DenseBash_BashDir;

// Weapon debugging
var globalconfig	bool	bWeaponDebug_Accuracy;
var globalconfig	bool	bWeaponDebug_DamageRadius;


// also hopefully we can promote a lot of the variables in here to GameFramework

/** The pawn's light environment */
var() transient DynamicLightEnvironmentComponent LightEnvironment;


/** Object within NanoPawn which handles FX **/
var transient NanoPawnFX NanoPawnFX;
var class<NanoPawnFX> NanoPawnFXClass;

var class<NanoWeapon> DefaultWeaponClass;
var transient NanoWeapon MyNanoWeapon;

var transient float LastWeaponFireTime;

var name NeckBoneName;
var name PelvisBoneName;
var name LeftHandBoneName, RightHandBoneName;
var name LeftKneeBoneName, RightKneeBoneName;
var name LeftFootBoneName, RightFootBoneName;
var name LeftElbowBoneName, RightElbowBoneName;

var bool bActiveReloadBonusActive;


/** Is this pawn in the process of spawning? (ex. crawling out a hole) */
var bool bSpawning;

// end to get compiling

/** Actor to head-track */
var Actor	HeadLookAtActor;
/** Specific bone on the HeadLookAtActor to track */
var Name	HeadLookAtBoneName;
/** HeadTrackTarget that is controlling this pawn's head, if any */
var transient private HeadTrackTarget       CurrentHeadTrackTargetActor;
var transient SkelControlLookAt				HeadTrackSkelControl;
var transient SkelControlLookAt				EyeTrackSkelControl;

/** Bone name of left eye bone. */
var protected const Name					EyeBoneNameLeft;
/** Bone name of right eye bone. */
var protected const Name					EyeBoneNameRight;

var transient float HeadTrackTime;
var config	  float HeadTrackDuration;
var transient float HeadTrackRunInterpTime;
var config	  float	HeadTrackRunInterpDuration;

// below variables are used blending between aimoffset and head tracking
// this is to handle in/out or between
var config		float HeadTrackBlendSpeed;
// this is when no aim/aim during transition or no cover to cover
var config		float HeadTrackBlendSpeedModiferWhenSwitch;

/** vars for controlling headtrack aimoffset interp. */
var protected transient rotator LastHeadTrackDeltaRot;
var protected transient rotator LastHeadTrackRunDeltaRot;
var protected transient bool	bDoingHeadTrackAimOffsetInterpolation;
var protected transient bool	bDoingHeadTrackRunOffsetInterpolation;

/** vars for controlling head tracking blend **/
var protected transient float HeadTrackCurrentBlendSpeed;
// current weight to target
var protected transient	float HeadTrackBlendWeightToTarget;
// target weight (0 : only aimoffset and 1 : only head tracking)
var protected transient	float HeadTrackBlendTargetWeight;
var protected transient bool  WasHeadTracking;


/**
 * This is the replicated version of AimOffsetPct that other clients will interpolate to.
 * Using FRotator compression with roll forced to 0
 */
var rotator		ReplicatedAimOffsetPct;
/** Offset used to offset some animations. For example chainsaw dueling on slopes, to play an animation based on height differences. */
var vector2d	PositionAdjustAimOffsetPct;

/** An aim attractor is a point that the player autoaim code will attempt to target. */
struct native AimAttractor
{
	/** Attraction is scaled from 0 at this radius to 100 at the inner radius. */
	var() float		OuterRadius;

	/** Inside this radius, attraction is 100%. */
	var() float		InnerRadius;

	/** Bone to attach to */
	var() Name		BoneName;
};

/** array of aim attractors attached to this pawn */
var() array<AimAttractor> AimAttractors;
var() globalconfig bool bDebugAimAttractors;


/** Structure used to replicate weapon information to remote clients */
struct native WeaponRepInfo
{
	var		class<NanoWeaponBase>	WeaponClass;
	var		BYTE				BYTE_bHadAPreviousWeapon;
};

/** Current weapon replicated to remote clients. */
var		repnotify	WeaponRepInfo	RemoteWeaponRepInfo;

var protected transient repnotify TakeHitInfo LastTakeHitInfo;
/** LastTakeHitInfo will be checked for replication until this time is reached (so new clients don't get random old effects, etc) */
var protected transient float LastTakeHitTimeout;

/** replicated copy of material in slot 0 */
var repnotify MaterialInterface ReplicatedMaterial;

/** Is Pawn targeting? Used by animations. */
var				bool	bIsTargeting;
var				bool	bIsZoomed;
/** ANIMTREE: Used by anim system to blend in aiming anim */
var				bool	bAimAnim;
var	transient	bool	bForceAimAnim;
/** ANIMTREE: Used by anim system to blend to combat stance */
var				bool	bCombatStanceAnim;
/** How long after firing to blend out aiming anim */
var				float	DelayBeforeUntarget;

/** Last time this pawn took damage **/
var transient float LastTookDamageTime;
var transient float LastPlayedDamageSound;

/** Whether or not to show the fatal death blood effects **/
var bool bShowFatalDeathBlood;
/** Should this AI spawn blood trail decals **/
var() bool bSpawnBloodTrailDecals;

/** ref to the orb we have spawned **/
var transient array<NanoAbsorbOrb> Orbs;

/** Class of Absorb orb this pawn drops **/
var array< class<NanoAbsorbOrb> > DroppedOrbClasses;

/** If TRUE, pawn will be knocked down when they land on the ground */
var transient bool bKnockDownOnLanding;

/** Should we check for falling?  Called at the apex of a jump */
var transient bool bCheckForFalling;

/** This pawn was juggled while in air */
var transient bool bJuggled;
/** If we are going to force this pawn to fall to the ground on landing */
var transient bool bJuggleForceKnockDown;
/** Last time this pawn was juggled by damage taken */
var transient float	LastJuggleTime;
/** Last time this pawn caused a juggle */
var transient float	LastCausedJuggleTime;
/** Last actor that this pawn caused to be juggled */
var transient NanoInterface_JuggleTarget LastCausedJuggleActor;
var config	  float MaxJuggleFallSpeed;	// max speed pawn can land without being knocked down when juggled

/** Tracks when the Pawn died */
var transient float TimeOfDeath;

/** True if switched to Gore Skeleton/Physics Asset */
var transient bool	bIsGore;
/** True if Gore has been setup for Gibs. Sets up some optimizations so Gibs don't kill performance. */
var transient bool	bGoreSetupForDeath;
/** If TRUE we broke at least one constraints off the Gore mesh. */
var transient bool	bHasBrokenConstraints;
/** Whether we have GoreExploded or not.  We only want to play GoreExplode effects once **/
var transient bool bHasGoreExploded;

/** Turn off bNoEncroachCheck when this pawn goes to ragdoll. */
var bool	bEnableEncroachCheckOnRagdoll;


/** Struct indicating how much to scale a particular joint limit upon complete ragdoll death. */
struct native DeadRagdollLimitScale
{
	var()	name	RB_ConstraintName;
	var()	float	Swing1Scale;
	var()	float	Swing2Scale;
	var()	float	TwistScale;
};
/** Information on how to scale limits for a ragdoll upon complete death - to prevent weird positions. */
var() array<DeadRagdollLimitScale>	RagdollLimitScaleTable;
/** Time taken to scale limits to their target. */
var() float							TimeToScaleLimits;
/** How much longer to scale limits to target. */
var	float							ScaleLimitTimeToGo;
/** Time taken to scale motors to zero */
var() float							TimeToScaleMotors;
/** How much longer to scale limits to target. */
var	float							ScaleMotorsTimeToGo;



/** This is to cap the number of "constrain broke" effects we spawn per guy. **/
var() int NumConstraintEffectsSpawnedMax;
var transient int NumConstraintEffectsSpawned;


/** The Gore SkeletalMeh **/
var SkeletalMesh GoreSkeletalMesh;
/** The Gore PhysAsset **/
var PhysicsAsset GorePhysicsAsset;

struct native GoreBreakableJoint
{
	var() name      ConstraintName;
	/** For per-bone tweaking. */
	var() float     ImpulseScale;
	/** if TRUE, the impulse applied to this bone will be a mass-independent velocity impulse */
	var() bool      bVelImpulse;

	structdefaultproperties
	{
		ImpulseScale=1.0f
		bVelImpulse=TRUE
	}
};

/** Array of Breakable bone names to use when gibbing a GoreMesh. */
var() Array<GoreBreakableJoint> GoreBreakableJoints;



/** For a numbr of characters, when the spine breaks we need to break the upper right arm constraint as there is not enough flesh there to look good **/
// list of bones that when broken need to break other bones
struct native DependantBreakInfo
{
	var name ParentBone; // name of the bone to break dependants of
	var array<Name> DependantBones; // list of bones that need to get broken when parent bone does
};
var Array<DependantBreakInfo> JointsWithDependantBreaks;



/**
* whether or not we are switching weapons.	 this is used as yet another check to see if we can fire our weapon
*
* @see NanoPC.CanFireWeapon()
* @see PlayWeaponSwitch()
* @see TurnOffWeaponSwitchingFlag()
**/
var bool bSwitchingWeapons, bEquipTransition;

/** TRUE if Pawn is fully blended into an aiming animation (ready or targeting, i.e. not relaxed or blending from relaxed).  NON-COVER. */
var transient	bool	bTargetingNodeIsInIdleChannel;
var transient	INT		TargetingNodeIsInIdleChannelTickTag;

var bool bHasShield;
var transient bool bShieldPose;

/** if this is set then the weapon equiping/de equiping / highlighting sounds will not play @see ClientRestart **/
var bool bQuietWeaponEquipping;

var SoundCue HackFootStepCue;
var SoundCue HackFootStepRunCue;


var transient TraceHitInfo HackLastFootStepTraceInfo;

/** List of every attacker currently queued for attacking this target */
var array<NanoInterface_ActiveAttacker> AttackerList;
/** List of attackers actively engaging this target */
var array<NanoInterface_ActiveAttacker> ActiveAttackerList;
/** Number of active attackers allowed at one time */
var int MaxActiveAttackers;


/** The amount of resistance this pawn has to bullets  (1.0f is 100% resistant)**/
var config float ResistenceToBullets;


/** This is the current Chaos Zone this is in **/
var transient NanoVolume_ChaosZone CurrChaosZone;

/** This is the current Chaos Zone this is in **/
var transient NanoVolume_RebelMindShareZone CurrMindShareZone;

/** Cached bIsInCombat flag set by the server via NanoPCBase.IsInCombat() */
var transient bool bIsInCombat;

/** How many touching orbitals are needed for damage to occur **/
var config int NumOrbitalsTouchingForDamage;

/** Whether or not this dead pawn should be destroyed.  We want to keep troopers' bodies around so we can absorb them **/
var bool bShouldDestroyWhenNotSeen;
/** The amount of time which must pass with this pawn's remains not being seen before we destroy it **/
var float DurationBeforeDestroyingDueToNotBeingSeen;
/** How long after this pawn has not been rendered do we want before we actually destroy it **/
var float DurationOfNotBeingRenderedBeforeActualDestroying;
/** Maximum number of Dead RagDoll Pawns allowed. So frame rate doesn't get too bad. */
var config int MaxAllowedDeadRagDollPawns;

/** Whether or not we are scaling to zero **/
var transient protected bool bScalingToZero;


/** These are the rewards that this pawn has.  When they die they will give the reward to the killer. **/
var transient array<NanoProceduralMissionRewardBase> ProceduralMissionRewards;


var ECharacterFootStepType CharacterFootStepType;

/** Effects to play on the broken constraint for child and parent **/
var protected ParticleSystem ConstraintBrokenNotify_LimbChild;
var protected ParticleSystem ConstraintBrokenNotify_LimbParent;

/** Last time this pawn heard a bulletwhip sound */
var transient float LastBulletWhipTime;

/** Whether or not this pawn is immune to the ground pound attack **/
var config bool bImmuneToGroundPoundAttack;


var config vector2d AbleToExecuteAnAttackRange;
var transient float NextAllowedAttackTime;

/** How fast this pawn runs when pursuing **/
var config float NanoPursueGroundspeed;

/** How fast this pawn runs when doing Melee Engage circle fighting **/
var config float NanoMeleeEngagedGroundspeed;

/** Our UIIconComponent for easy access. **/
var UIIconComponent UIComponent;

/**
 * When an enemy is first seen (or after some time of not being seen) we play this effect to show off iris "alerting" you.
 * eventually will have "threat" detection and such.  like terminators do!
 **/
var ParticleSystem PS_IRIS_FirstEncounter;
var transient ParticleSystemComponent PSC_IRIS_FirstEncounter;
var transient float TimeSpawnedFirstEncounterEffect;
var float DurationBeforeSpawningFirstEncounterEffects;
var name IRIS_FirstEncounterBoneName;

/** This overrides boids being active.  No matter what boids are enabled! **/
var transient bool bDisableAllBoids;

/** cheat - when true, can't be affected by effects from damage (e.g. momentum transfer, hit effects, etc.) **/
var bool bAffectedByHitEffects;


//// DBNO -- START
var config bool bCanDBNO;
var				transient bool					bWasDBNO;
var				transient float					TimeOfDBNO;
var				transient Controller				ControllerWhoPutMeDBNO;
var				transient class<DamageType>	DamageTypeThatPutMeDBNO;
var				transient vector				    MomentumThatPutMeDBNO;
//// DBNO -- END


var transient NanoCrowd_PanicRepulsor_DBNOBody DBNORepulsor;

/** Whether or not we are hidden by the crowd we are in or not **/
var transient bool bIsHiddenByCrowd;
var transient int NumNonPanickedCrowdAround;
var transient int NumPanickedCrowdAround;

var config int NumNonPanickedCrowdToHideUs;
var config int NumPanickedCrowdToHideUs;

replication
{
	// Replicated to ALL but Owning Player
	if ((!bNetOwner || bDemoRecording) && Role == ROLE_Authority)
		bIsTargeting, bIsZoomed, ReplicatedAimOffsetPct;

	// replicated to all but owning player unless dead
	if ((!bNetOwner || bDemoRecording) && !bTearOff && Role == ROLE_Authority)
		RemoteWeaponRepInfo;//, AttachSlotClass_Holster, AttachSlotClass_Belt, AttachSlotClass_LeftShoulder, AttachSlotClass_RightShoulder;

	// Replicated to ALL
	if( Role == Role_Authority )
		DefaultHealth, ReplicatedMaterial, bIsInCombat;

	// replicated to ALL only if recently hit
	if (Role == ROLE_Authority && WorldInfo.TimeSeconds < LastTakeHitTimeout)
		LastTakeHitInfo;
}



simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	Health = GetDefaultHealth();

	if( NanoPawnFX == None )
	{
		Assert(NanoPawnFXClass != None);
		NanoPawnFX = new(self) NanoPawnFXClass;
	}

	GroundSpeed = NanoPursueGroundspeed;

	ResetHotSimulusProperties();
}


function ResetHotSimulusProperties()
{
	LastMeleeAttackTime = -9999999;
	LastWeaponFireTime = -9999999;
	LastCausedCrowdPanicTime = -9999999;
	LastTookDamageTime = -9999999;
}


/** replicated event */
simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
	case 'LastTakeHitInfo':
		ReplicatedPlayTakeHitEffects();
		break;

	case 'bIsTargeting' :
		// Notification that targeting mode has been changed.
		//FIXME TargetingModeChanged();
		break;

	case 'InvManager':
		// everyone's InvManager gets replicated into demos so we need to update attachments after receiving it
		if (WorldInfo.IsPlayingDemo() && InvManager != None)
		{
			RefreshRemoteAttachments();
		}
		break;

		// update right hand weapon attachment
	case 'RemoteWeaponRepInfo':
		UpdateRemoteWeapon();
		break;

		// slot attachments
	case 'AttachSlotClass_Holster':
		//SetSlotAttachment( EASlot_Holster, AttachSlotClass_Holster );
		break;

	case 'AttachSlotClass_Belt':
		//SetSlotAttachment( EASlot_Belt, AttachSlotClass_Belt );
		break;

	case 'AttachSlotClass_LeftShoulder':
		//SetSlotAttachment( EASlot_LeftShoulder, AttachSlotClass_LeftShoulder );
		break;

	case 'AttachSlotClass_RightShoulder':
		//SetSlotAttachment( EASlot_RightShoulder, AttachSlotClass_RightShoulder );
		break;


	case nameof(ReplicatedMaterial):
		if (ReplicatedMaterial != None)
		{
			Mesh.SetMaterial(0, ReplicatedMaterial);
		}
		else
		{
			Mesh.SetMaterial(0, default.Mesh.GetMaterial(0));
		}
		break;

	}

	Super.ReplicatedEvent(VarName);
}


/**
 * Returns the default health. Overridden by NanoSkill using classes to have their NanoSkill_Health modify this.
 * Lots of places use DefaultHealth for resetting the pawn.  So we need to modify that by our NanoSkill
 **/
function int GetDefaultHealth()
{
	return DefaultHealth;
}


simulated function UpdateCombatStance()
{
	local bool bOldCombatStanceAnim;
	local NanoWeap_Melee Weap;

	bOldCombatStanceAnim = bCombatStanceAnim;
	bCombatStanceAnim = bIsSwordActive && `TimeSince(LastWeaponStartFireTime) < DelayBeforeUntarget;
	if( bOldCombatStanceAnim != bCombatStanceAnim )
	{
		Weap = NanoWeap_Melee(Weapon);
		if( Weap != None )
		{
			Weap.UpdateByCombatStance( bCombatStanceAnim );
		}
	}
}


simulated event Destroyed()
{
	local NanoAbsorbOrb Orb;

	foreach Orbs( Orb )
	{
		Orb.Destroy();
	}

	Super.Destroyed();
}


simulated event Tick(float DeltaTime)
{
	local bool bWantsToAim;

	Super.Tick(DeltaTime);

	UpdateCombatStance();

	// Update bool that indicates whether to show aiming anim
	//	bWantsToAim = !bEmptyHanded && !bIsSwordActive && (bAimAnim || (bIsTargeting || (WorldInfo.TimeSeconds - LastWeaponFireTime) < DelayBeforeUntarget || bForceAimAnim));
	bWantsToAim = (!bEmptyHanded && !bIsSwordActive) && (bIsTargeting || `TimeSince(LastWeaponFireTime) < DelayBeforeUntarget || bForceAimAnim);
	if (bWantsToAim)
	{
		if (!bAimAnim)
		{
			SetTimer(1.5f,FALSE,nameof(TurnOffAiming));
			bAimAnim = TRUE;
			// update jump anim set for the smg
			if (!bEmptyHanded)
			{
				UpdateJumpAnimSet();
			}
		}
	}

	`if(`notdefined(FINAL_RELEASE))
		if( bDebugAimAttractors )
		{
			DrawDebugAimAttractors();
		}
		`endif

		if( Health > 0 )
		{
			// if this takes too much time, methinks we can distribute load over multiple frames
			// slight delays in start/stop auto headtracks are tolerable
			UpdateAutomaticHeadTracking();
			UpdateMeshBoneControllers(DeltaTime);
		}


		PossiblySpawnIRIS_FirstEncounterEffect();
}




delegate int TargetSort(TargetSortInfo A, TargetSortInfo B)
{
	// bigger is better!
	return (A.Rating < B.Rating ? -1 : 0);
}
delegate int ReverseTargetSort(TargetSortInfo A, TargetSortInfo B)
{
	// smaller is better!
	return (A.Rating > B.Rating ? -1 : 0);
}

simulated function CacheAnimNodes()
{
	HeadTrackSkelControl = SkelControlLookAt(Mesh.FindSkelControl('HeadLook'));
	EyeTrackSkelControl = SkelControlLookAt(Mesh.FindSkelControl('EyeLook'));
}

/** Clear references to anim nodes so AnimTree can be garbage collected. */
simulated function ClearAnimNodes()
{
	HeadTrackSkelControl = None;
	EyeTrackSkelControl = None;
}

/** Event so that native code can tell if we're playing a FaceFX animation */
event bool IsPlayingFaceFXAnim()
{
	return IsActorPlayingFaceFXAnim();
}

/** Util for retuning direction of pawn velocity in 2D plane */
simulated function Vector Get2DVelDir()
{
	local Vector VelDir;

	VelDir = Velocity;
	VelDir.Z = 0.0;
	VelDir = Normal(VelDir);

	return VelDir;
}

/** Register an AI as an attacker against this target, to be notified when an active attack slot is available */
function RegisterAttacker( NanoInterface_ActiveAttacker RequestingAttacker )
{
	local int AttackerIdx;

	AttackerIdx = AttackerList.Find( RequestingAttacker );
	if( AttackerIdx < 0 )
	{
		AttackerList.AddItem(RequestingAttacker);
		if( AllowedToActivelyAttackTarget( RequestingAttacker ) )
		{
			RequestingAttacker.NotifyActiveAttackAvailable(self);
		}
	}
	`attackers_log(`location@`showvar(RequestingAttacker)@`showvar(AttackerIdx));
}

function UnregisterAttacker(NanoInterface_ActiveAttacker RequestingAttacker)
{
	`attackers_log(`location@`showvar(RequestingAttacker));
	AttackerList.RemoveItem(RequestingAttacker);
	ActiveAttackerList.RemoveItem(RequestingAttacker);
}

/** Is the AI allowed to claim an active attacking slot? */
function bool AllowedToActivelyAttackTarget( NanoInterface_ActiveAttacker RequestingAttacker )
{
	local NanoInterface_ActiveAttacker Atk;
	local int NumActiveAttackers;
	foreach ActiveAttackerList(Atk)
	{
		if( Atk != RequestingAttacker && Atk != None )
		{
			NumActiveAttackers += Atk.GetActiveAttackSlots();
		}
	}
	//`log( `showvar(NumActiveAttackers) @ `showvar(MaxActiveAttackers) );
	return NumActiveAttackers < MaxActiveAttackers;
}

/** Register an AI as an active attacker */
function RegisterActiveAttacker( NanoInterface_ActiveAttacker RequestingAttacker )
{
	local int AttackerIdx;

	AttackerIdx = ActiveAttackerList.Find( RequestingAttacker );
	if( AttackerIdx < 0 )
	{
		ActiveAttackerList.AddItem(RequestingAttacker);
		// shuffle the attacker to the end of the queue
		AttackerList.RemoveItem(RequestingAttacker);
	}

	`attackers_log(`location@`showvar(RequestingAttacker)@`showvar(AttackerIdx));
}

/** Unregister AI from the active attacker list */
function UnregisterActiveAttacker( NanoInterface_ActiveAttacker RequestingAttacker )
{
	local int AttackerIdx;
	local array<TargetSortInfo> Ratings;
	local TargetSortInfo NewAttacker;
	local array<NanoInterface_ActiveAttacker> PotentialList;
	local float BestRating;

	AttackerIdx = ActiveAttackerList.RemoveItem(RequestingAttacker);

	`attackers_log(`location@`showvar(RequestingAttacker)@AttackerIdx );
	if( AttackerIdx >= 0 )
	{
		for( AttackerIdx = 0; AttackerIdx < AttackerList.Length; AttackerIdx++ )
		{
			if( AttackerList[AttackerIdx] == None )
				continue;

			NewAttacker.Target = AttackerList[AttackerIdx];
			if( AllowedToActivelyAttackTarget(AttackerList[AttackerIdx]) )
			{
				NewAttacker.Rating = AttackerList[AttackerIdx].RateAttacker( self, TRUE );
				`attackers_log(">>>>"@`showvar(AttackerIdx)@"Rating"@NewAttacker.Target@NewAttacker.Rating);
			}
			else
			{
				NewAttacker.Rating = -1.f;
			}
			Ratings.AddItem( NewAttacker );
		}
		Ratings.Sort(TargetSort);

		BestRating = -1.f;
		for( AttackerIdx = 0; AttackerIdx < Ratings.Length; AttackerIdx++ )
		{
			`attackers_log(">> Check:"@`showvar(AttackerIdx)@Ratings[AttackerIdx].Target@Ratings[AttackerIdx].Rating@NanoInterface_ActiveAttacker(Ratings[AttackerIdx].Target).NotifyActiveAttackAvailable(self));
			if( BestRating < 0 )
			{
				BestRating = Ratings[AttackerIdx].Rating;
			}

			if( Ratings[AttackerIdx].Rating > 0.f &&
				Ratings[AttackerIdx].Rating >= BestRating &&
				NanoInterface_ActiveAttacker(Ratings[AttackerIdx].Target).NotifyActiveAttackAvailable(self) )
			{
				`attackers_log("> Accepted:"@`showvar(AttackerIdx)@Ratings[AttackerIdx].Target);
				PotentialList[PotentialList.Length] = NanoInterface_ActiveAttacker(Ratings[AttackerIdx].Target);
			}
			else
			{
				break;
			}
		}

		if( PotentialList.Length > 0 )
		{
			AttackerIdx = Rand(PotentialList.Length);
			RegisterActiveAttacker( PotentialList[AttackerIdx] );

			`attackers_log("> Chose:"@`showvar(AttackerIdx)@PotentialList[AttackerIdx]@PotentialList.Length);
		}

		AttackerList.AddItem(RequestingAttacker);
	}
}

simulated final function NanoGRI GetGRI()
{
	return NanoGRI(WorldInfo.GRI);
}

function bool InGodMode()
{
	local NanoPCBase PC;

	PC = NanoPCBase(Controller);

	return (Super.InGodMode() || (PC != None && (PC.bCameraGodMode || PC.bCinematicMode)));
}

simulated function bool AffectedByHitEffects()
{
	return bAffectedByHitEffects;
}

function OnNanoToggleAffectedByHitEffects( SeqAct_NanoToggleAffectedByHitEffects inAction )
{
	if (inAction.InputLinks[0].bHasImpulse)
	{
		bAffectedByHitEffects = TRUE;
	}
	else if (inAction.InputLinks[1].bHasImpulse)
	{
		bAffectedByHitEffects = FALSE;
	}
	else
	{
		bAffectedByHitEffects = !bAffectedByHitEffects;
	}
}


function OnResetHotStimulusValues( SeqAct_ResetHotStimulusValues inAction )
{
	ResetHotSimulusProperties();
}



simulated function TurnOffAiming()
{
	bAimAnim = FALSE;
	UpdateJumpAnimSet();
}



simulated function UpdateJumpAnimSet(optional Name OverrideSet);


/** Returns a NanoPC if available, handles any special cases (like vehicles) */
simulated function NanoPC GetPC()
{
	local NanoPC PC;

	PC = NanoPC(Controller);

	if (PC == None && DrivenVehicle != None)
	{
		PC = NanoPC(DrivenVehicle.Controller);
	}

	return PC;
}


/** Returns TRUE of this hit corresponds to a head shot. */
simulated event bool TookHeadShot( Name BoneName, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet )
{
	local vector HeadLocation;
	local bool bBoneHitHead;

	if( HeadBoneNames.length > 0 )
	{
		HeadLocation = GetHeadshotLocation();

		// Find distance from head location to bullet vector
		//`log( "HeadshotRadius" @ PointDistToLine(HeadLocation, Normal(Momentum), HitLocation) @ `showvar(BoneName) );
		bBoneHitHead = ( PointDistToLine(HeadLocation, Normal(Momentum), HitLocation) < HeadshotRadius );

		`if(`notdefined(FINAL_RELEASE))
			if( bWeaponDebug_HeadShotLocation )
			{
				FlushPersistentDebugLines();

				if( bBoneHitHead == TRUE )
				{
					DrawDebugSphere(HeadLocation, HeadshotRadius, 10, 0, 255, 0, TRUE);
				}
				else
				{
					DrawDebugSphere(HeadLocation, HeadshotRadius, 10, 255, 0, 0, TRUE);
				}
			}
			`endif
	}


	if( bBoneHitHead == TRUE )
	{
		// if we have a helmet then note that so that damage is negated, helmet popped off, etc
		if( HasHelmetOn() )
		{
			out_bHasHelmet = 1;
		}
		else
		{
			out_bHasHelmet = 0;
		}
	}

	return bBoneHitHead;
}


simulated function bool HasHelmetOn()
{
	return FALSE;
}


/** @return location used as origin for headshot hit detection */
simulated final function vector GetHeadshotLocation()
{
	if( HeadBoneNames.length > 0 )
	{
		return Mesh.GetBoneLocation(HeadBoneNames[0])
			+ HeadBoneOffset.X * Mesh.GetBoneAxis(HeadBoneNames[0], AXIS_X)
			+ HeadBoneOffset.Y * Mesh.GetBoneAxis(HeadBoneNames[0], AXIS_Y)
			+ HeadBoneOffset.Z * Mesh.GetBoneAxis(HeadBoneNames[0], AXIS_Z);
	}
	else
	{
		return vect(0,0,0);
	}
}


/** Native implementation of base AimDir update. */
simulated native function UpdateMeshBoneControllersNative(float DeltaTime);

/**
 * Calculate AimDir 2d vector, used by all Aim AnimNodes.
 * Network: ALL
 */
simulated function UpdateMeshBoneControllers(float DeltaTime)
{
	UpdateMeshBoneControllersNative(DeltaTime);
}

/** Origin used for AimOffset calculation. */
simulated event Vector GetAimOffsetOrigin()
{
	local Vector				VectorLoc, SocketLoc, X, Y, Z;
	local Rotator				SocketRot;
	local quat					BoneQuat;

	if( Mesh == None  )
	{
		return Location;
	}

	// Use weapon location as aimoffset origin, for better alignment.
	if( IsHumanControlled() && MyNanoWeapon != None )
	{
		if( RightHandSocketName != '' )
		{
			// Try as a socket first
			if( Mesh.GetSocketWorldLocationAndRotation(RightHandSocketName, SocketLoc, SocketRot) )
			{
				GetAxes(SocketRot, X, Y, Z);
				return SocketLoc + Z * 12.f;
			}

			// try as a bone reference next;
			if( Mesh.MatchRefBone(RightHandSocketName) != INDEX_NONE )
			{
				BoneQuat = Mesh.GetBoneQuaternion(RightHandSocketName);
				SocketRot = QuatToRotator(BoneQuat);
				GetAxes(SocketRot, X, Y, Z);
				return Mesh.GetBoneLocation(RightHandSocketName) + Z * 12.f;
			}
		}
	}

	if( PelvisBoneName != '' && Mesh.MatchRefBone(PelvisBoneName) != INDEX_NONE )
	{
		VectorLoc = Mesh.GetBoneLocation(PelvisBoneName);
		VectorLoc.Z = GetPawnViewLocation().Z;

		return VectorLoc;
	}

	// Otherwise take default view location
	return Location;
}

/** This will destroy the currently wield weapon. **/
simulated function DestroyCurrentWeapon()
{
	ServerDestroyCurrentWeapon( MyNanoWeapon );

	if( MyNanoWeapon != none )
	{
		MyNanoWeapon.ClientWeaponThrown();
		MyNanoWeapon = None;
	}
}

protected simulated function ServerDestroyCurrentWeapon( NanoWeapon TheWeapToDestroy )
{
	InvManager.RemoveFromInventory(TheWeapToDestroy); // remove current item
}

// all of this attachment functionality could be moved to GameFramework or some helper "object" as it is pretty game agnostic
// and is just using the SimsObject model where the object contains all of the anims and such and then we mount it on our pawn from that

simulated function AttachWeapon()
{
	`LogInv("MyNanoWeapon:" @ MyNanoWeapon);

	if( MyNanoWeapon != None )
	{
		// detach from attachment slots, to attach to hand!
		//DetachWeaponFromSlot( MyNanoWeapon );

		// attach to hand
		AttachWeaponToHand( MyNanoWeapon );

		// Update the animation sets related to the current weapon
		// Adding or removing weapon specific sets.
		//UpdateAnimSetList();

		// Force Pawn mesh to be updated.
		Mesh.ForceSkelUpdate();

		// Set a timer to reupdate animations next frame. Sometimes during transitions, things get confused.
		SetTimer(0.01f, FALSE, nameof(UpdateAnimations));
	}
	else
	{
		`LogInv(WorldInfo.TimeSeconds @ GetFuncName() @ "Weapon == None for" @ Self @ "LocallyControlled:" @ IsLocallyControlled() @ "Weapon:" @ MyNanoWeapon @ "RemoteWeaponRepInfo:" ) ;// @ RemoteWeaponRepInfo.WeaponClass);
	}
}


/**
* Attach specified Weapon to Pawn's hand.
* Supplied weapon Actor is usually Pawn.Weapon.
* this function sets up the replication for remote clients,
* and attaches the weapon components to the right socket.
*/
simulated function AttachWeaponToHand(NanoWeapon Weap)
{
	// attach to right hand socket
	`LogInv("attach" @ Weap @ "to" @ RightHandSocketName);
	if( Weap != none )
	{
		Weap.AttachWeaponTo(Mesh, RightHandSocketName);

		if( Weap.Mesh != none )
		{
			//Weap.SetMaterialBasedOnTeam( Weap.Mesh, GetTeamNum() );

			// turn off dynamic casting shadows on AI weapons
			//if( MyNanoAI != none )
			//{
			//	Weap.Mesh.bCastDynamicShadow=FALSE;
			//}
		}
	}
}


simulated function DetachWeapon( NanoWeapon Weap )
{
	if( Weap != None )
	{
		Weap.DetachWeapon();
		Weap.Destroy();
	}
}

/**
 * Returns true if this pawn is in an "aiming pose".  As in, is in a state
 * such that the weapon is up and ready.
 */
final simulated event bool IsInAimingPose()
{
	local NanoWeaponBase NanoWeap;

	NanoWeap = NanoWeaponBase(Weapon);
	if( NanoWeap != None && !NanoWeap.IsReloading() )
	{
		return TRUE;
	}

	return FALSE;
}

simulated exec function UpdateAnimations()
{
	//FIXME UpdateAnimSetList();
}


/**
* Forward FlashLocation updates to weapon.
*/
simulated function FlashLocationUpdated(Weapon InWeapon, Vector InFlashLocation, bool bViaReplication)
{
//	`LogInv( "NanoPawn FlashLocationUpdated" @ MyNanoWeapon @ bViaReplication );

	if( MyNanoWeapon != None )
	{
		MyNanoWeapon.FlashLocationUpdated(GetWeaponFiringMode(InWeapon), InFlashLocation, bViaReplication );
	}
}


/**
* Forward FlashCount updates to weapon.
*/

simulated function FlashCountUpdated(Weapon InWeapon, Byte InFlashCount, bool bViaReplication)
{
	if( MyNanoWeapon != None )
	{
		MyNanoWeapon.FlashCountUpdated(InFlashCount, GetWeaponFiringMode(InWeapon), bViaReplication);
	}
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional vector HitLocation)
{
	Super.WeaponFired(InWeapon, bViaReplication, HitLocation);

	LastWeaponFireTime = WorldInfo.TimeSeconds;
}

/** plays clientside hit effects using the data in LastTakeHitInfo */
simulated function ReplicatedPlayTakeHitEffects()
{
	local ImpactInfo			Impact;
	local NanoWeapon			WW;
	local bool					bPlayMeleeImpactEffects, bWillShowFatalDeathBlood, bShowGore, bPlayExplosiveRadialDamageEffects;
	local class<NanoDamageType>	NanoDmgType;
	//local Vector				Impulse;

	// call the damage type specific FX handler
	NanoDmgType = class<NanoDamageType>(LastTakeHitInfo.DamageType);
	if (NanoDmgType != None)
	{
	//FIXME	NanoDmgType.static.HandleDamageFX(self, LastTakeHitInfo);
	}

	if( LastTakeHitInfo.InstigatedBy == None )
	{
		return;
	}

	WW = NanoWeapon(LastTakeHitInfo.InstigatedBy.Weapon);

	// Should we show gore effects?
	bShowGore = WorldInfo.GRI.ShouldShowGore();

	// mark the last take damage time for client simulation
	LastTookDamageTime = WorldInfo.TimeSeconds;

	// fill impactinfo
	Impact.HitActor				= Self;
	Impact.HitLocation			= LastTakeHitInfo.HitLocation;
	Impact.HitNormal			= IsZero(LastTakeHitInfo.Momentum) ? Normal(Impact.HitLocation - Location) : -1.f * Normal(LastTakeHitInfo.Momentum);
	Impact.RayDir				= -1.0 * Impact.HitNormal;
	Impact.HitInfo.PhysMaterial = LastTakeHitInfo.PhysicalMaterial;
	Impact.HitInfo.BoneName		= (LastTakeHitInfo.HitBoneIndex != 255) ? Mesh.GetBoneName(LastTakeHitInfo.HitBoneIndex) : 'None';
	Impact.HitInfo.HitComponent = Mesh;

	// check for non-directional impact fx (@fixme - rename this and make it a property of NanoDamageType?)
	if( ClassIsChildOf(LastTakeHitInfo.DamageType, class'NDT_Melee') )
	{
		bPlayMeleeImpactEffects = TRUE;
	}
	else if( ClassIsChildOf(LastTakeHitInfo.DamageType, class'NDT_Explosive' ) )
	{
		// unless we are playing death and then we do not need to spawn the radial damage effect
		if( bPlayedDeath == FALSE )
		{
			bPlayExplosiveRadialDamageEffects = TRUE;
			Impact.HitInfo.BoneName = PelvisBoneName;
		}
	}

	if (WW != None)
	{
		// Are we going to show fatal death blood?
		bWillShowFatalDeathBlood = (Health <= 0) && bShowFatalDeathBlood;
		// Spawn the impact FX
		WW.SpawnImpactFX(NanoDmgType,Impact,bWillShowFatalDeathBlood,bPlayMeleeImpactEffects,bPlayExplosiveRadialDamageEffects);
		// if we are really hurt spawn some small blood drops
		if( ( Health < (0.40f * DefaultHealth) )
			&& ( NanoDmgType.default.bSuppressBloodDecals == FALSE )
			&& bSpawnBloodTrailDecals
			)
		{
			//FIXME SpawnABloodTrail_PawnIsReallyHurt();
		}
		// and disable fatal blood
		if( bWillShowFatalDeathBlood )
		{
			bShowFatalDeathBlood = FALSE;
		}
	}

	// 	`log(WorldInfo.TimeSeconds @ Self @ GetStateName() $ "::" $ GetFuncName() @ "IsAHostage:" @ IsAHostage() @ "bPlayedDeath:" @ bPlayedDeath);


	// Otherwise gib when dead
	// Check if this is a gibbing damage type ad we're allowed to show gory stuffs!
	// Gore is not compatible with HeadShot deaths
	// Wait at least a second after time of death to gib. This is to keep head shot death from gibbing right away.
	// Do not gore while doing death animation as this won't work well, because skeleton is setup to use motors.
	else if( bPlayedDeath )
	{
		//`log(" bPlayedDeath:" @ bPlayedDeath @ "bShowGore:" @ bShowGore @ "ShouldGib1:" @ NanoDmgType.static.ShouldGib(self,LastTakeHitInfo.InstigatedBy) @ "ShouldGib2:" @ ShouldGib(NanoDmgType,LastTakeHitInfo.InstigatedBy) );

		// Handle gibbing
		if( bShowGore
			&& NanoDmgType.static.ShouldGib(self,LastTakeHitInfo.InstigatedBy)
			&& ShouldGib(NanoDmgType,LastTakeHitInfo.InstigatedBy)
			&& (WorldInfo.TimeSeconds - TimeOfDeath > 1.f)
			//&& !IsDoingDeathAnimSpecialMove()
			)
		{
			//`log(" bPlayedDeath - ShouldGib");
			// See if we need to switch to a gore skeleton, if we haven't already
			if( !bIsGore && GoreSkeletalMesh != None && GorePhysicsAsset != None )
			{
				//`log(" bPlayedDeath - ShouldGib - CreateGoreSkeleton");
				CreateGoreSkeleton(GoreSkeletalMesh, GorePhysicsAsset);
			}

			// If we're in Gore Skeleton and we have some breakable joints to gib, then do so!
			if( bIsGore && GoreBreakableJoints.Length > 0 )
			{
				GoreExplosion(LastTakeHitInfo.Momentum, LastTakeHitInfo.HitLocation, NanoDmgType);
			}
		}

		// Add an impulse if in rag doll
		if (Physics == PHYS_RigidBody)
		{
			//FIXME Impulse = GetImpactPhysicsImpulse(NanoDmgType, LastTakeHitInfo.HitLocation, LastTakeHitInfo.Momentum, Impact.HitInfo);
			//FIXME Mesh.AddImpulse(Impulse, LastTakeHitInfo.HitLocation, Impact.HitInfo.BoneName);
		}
	}
	// Otherwise play standard 'alive' hit reactions
	else
	{
		// Try to play a hit reaction animation. Otherwise fallback to physics hit reactions.
		if( (NanoDmgType == None || !NanoDmgType.default.bSuppressImpactFX)
			//FIXME && !TryPlayHitReactionAnimation(Impact)
			)
		{
			// Play Physics Body Impact.
			//FIXME PlayPhysicsBodyImpact(Impact.HitLocation, LastTakeHitInfo.Momentum, LastTakeHitInfo.DamageType, Impact.HitInfo);
		}
	}
}


/** Give the pawn a chance to override whether it should Gib or not */
function bool ShouldGib(class<NanoDamageType> NanoDmgType, Pawn InstigatedBy)
{
	return TRUE;
}

/**
* This will create the gore skeleton which will be constructed to break apart.
*/
simulated final function CreateGoreSkeleton(SkeletalMesh TheSkeletalMesh, PhysicsAsset ThePhysicsAsset)
{
	local Array<Attachment> PreviousAttachments;
	local int				Idx;

	// Need proper physics asset and mesh
	if( TheSkeletalMesh == None || ThePhysicsAsset == None || WorldInfo.GRI.ShouldShowGore() == FALSE )
	{
		return;
	}

	// Do this if we haven't switched to the gore skeleton yet
	if( !bIsGore )
	{
		PreviousAttachments = Mesh.Attachments;

		// so only if the phys asset is different shall we change it out
		if( ThePhysicsAsset != Mesh.PhysicsAsset )
		{
			Mesh.SetPhysicsAsset(None);
		}

		SetMainBodyMaterialToNoneToClearItForGoreMaterial();


		Mesh.bDisableWarningWhenAnimNotFound = TRUE;
		Mesh.SetSkeletalMesh( TheSkeletalMesh, TRUE );
		// Old "gore" was always LOD 0 of the new mesh
		Mesh.ToggleInstanceVertexWeights( TRUE, 0 );
		Mesh.bDisableWarningWhenAnimNotFound = FALSE;


		// so only if the phys asset is different shall we change it out
		if( ThePhysicsAsset != Mesh.PhysicsAsset )
		{
			Mesh.SetPhysicsAsset(ThePhysicsAsset);
		}

		Mesh.MotionBlurScale = 0.0f;

		for( Idx = 0; Idx < PreviousAttachments.length; ++Idx )
		{
			//`log( "reattaching: " $ PreviousAttachments[Idx].Component );
			Mesh.AttachComponent( PreviousAttachments[Idx].Component
				, PreviousAttachments[Idx].BoneName
				, PreviousAttachments[Idx].RelativeLocation
				, PreviousAttachments[Idx].RelativeRotation
				, PreviousAttachments[Idx].RelativeScale
				);
		}

		// now the mesh has been changed to the GoreSkeleton so we want to tell them to be resident for 15 seconds
		for( Idx = 0; Idx < Mesh.SkeletalMesh.Materials.Length; ++Idx )
		{
			Mesh.SkeletalMesh.Materials[Idx].SetForceMipLevelsToBeResident( false, false, 15.0f );
		}

		if( bEnableEncroachCheckOnRagdoll )
		{
			// If we are checking encroachment (ie looking for physics volumes) and we are gibbed - need to do a bit more checking
			// This is to handle just one gib going into a volume.
			Mesh.bPerBoneVolumeEffects = TRUE;
			bAlwaysEncroachCheck = TRUE;
		}

		/*		`log(WorldInfo.TimeSeconds @ Self @ GetStateName() $ "::" $ GetFuncName() @ "Created gore skeleton!");*/


		// Make sure all bodies are unfixed
		if( Mesh.PhysicsAssetInstance != none )
		{
			Mesh.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);

			// Turn off motors
			Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(FALSE, FALSE, Mesh, TRUE);
		}

		bIsGore = TRUE;
	}
}


/** This will do what ever is needed to reset materials to allow the gore overlay material to show up **/
simulated function SetMainBodyMaterialToNoneToClearItForGoreMaterial()
{
	local int idx;

	for( Idx = 0; Idx < Mesh.Materials.Length; ++Idx )
	{
		//`log( "clearing material to make gore work" @ Mesh.Materials[Idx] );
		Mesh.SetMaterial( Idx, None ); // this is needed as we have to "clear" the material instance on the mesh to make the gore material which is affecting the same verts can be seen.
	}
}


/**
* This will cause the mob to blow up into little pieces.
*
* NOTE: this is called from ReplicatedPlayTakeHitEffects on bodies that have been gored.  This plays the big bloody particle effect and additionally
* will break off bones based on the hit location.
*
*/
simulated function GoreExplosion( Vector Momentum, Vector HitLocation, class<NanoDamageType> NanoDamageType, optional bool bRandomizeGibImpulse )
{
	local int i;
	local Vector ConstraintLoc;

	// TODO:  we want to defer these so we don't pay the cost all at once in a single frame
	for( i = 0; i < GoreBreakableJoints.Length; ++i )
	{
		ConstraintLoc = Mesh.GetBoneLocation( GoreBreakableJoints[i].ConstraintName );
		BreakConstraint( Momentum, ConstraintLoc, GoreBreakableJoints[i].ConstraintName, GoreBreakableJoints[i].bVelImpulse );
	}

}


// some constraints need to be broken when another bone's constraint is.. check for such bones and break them accordingly
simulated final function BreakDependantBones(Vector Impulse, Vector HitLocation, Name InBoneName, optional bool bVelChange)
{
	local int i,j;

	for(i=0;i<JointsWithDependantBreaks.length;i++)
	{
		if(JointsWithDependantBreaks[i].ParentBone == InBoneName)
		{
			for(j=0;j<JointsWithDependantBreaks[i].DependantBones.length;j++)
			{
				//`log(GetFuncName()@"Breaking "@JointsWithDependantBreaks[i].DependantBones[j]@"because"@InBoneName@"was broken!");
				BreakConstraint(Impulse,HitLocation,JointsWithDependantBreaks[i].DependantBones[j],bVelChange);
			}
		}
	}
}

simulated final function BreakConstraint(Vector Impulse, Vector HitLocation, Name InBoneName, optional bool bVelChange)
{
	if( Mesh == None )
	{
		`if(`notdefined(FINAL_RELEASE))
			`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "Tried to gib with not gore skeleton!!");
		     ScriptTrace();
		`endif
		return;
	}

	Mesh.BreakConstraint(Impulse,HitLocation,InBoneName,bVelChange);

	BreakDependantBones(Impulse,HitLocation,InBoneName);

	// Keep track that broke at least one constraint off this gore mesh.
	if( !bHasBrokenConstraints )
	{
		bHasBrokenConstraints = TRUE;

		// only want to call this if we're actually dead (could be hostage, in which case we don't want to call this yet)
		if(bPlayedDeath)
		{
			// This will turn on optimizations for Gibs.
			SetupDeathGibsOptimizations();
		}
	}
}

/**
 * Setup Gore Skeleton to be gibbed.
 * This turns on some optimizations so Gibs don't kill performance.
 */
simulated final function SetupDeathGibsOptimizations()
{
	// Do this only once for Gore Skeletons
	// Don't setup those for non dead characters. (ie Hostages)
	if( bGoreSetupForDeath || !bIsGore || !bPlayedDeath )
	{
		return;
	}

	bGoreSetupForDeath = TRUE;

	// When you gore the skeleton, the bounding box can get very large, so the pawn can be considered 'always seen'
	// This forces it to be cleaned up after a certain period.
	SetTimer( 60.0, FALSE, nameof(GoreAroundTooLong) );

	// Freeze the light environment state at the state when the pawn was gibbed; this prevents the light environment being computed
	// for the large aggregate bounds of the gibs, which usually doesn't give good results.
	// we need to wait a number of seconds here so we do not capture the explosion light
	// NOTE: this can look bad when the gib is near a bright colored light and then is kicked out away from it into darkness
	SetTimer( 5.0f, FALSE, nameof(SetLightEnvironmentToNotBeDynamic) );

	// turn off shadows and SH lights
	LightEnvironment.bCastShadows = FALSE;
	LightEnvironment.bSynthesizeSHLight = FALSE;
}

/** Called after a gored pawn has been around too long. */
final simulated private function GoreAroundTooLong()
{
	bScalingToZero = TRUE;
}

/** This will turn "off" the light environment so it will no longer update **/
final simulated function SetLightEnvironmentToNotBeDynamic()
{
	LightEnvironment.bDynamic = FALSE;
}


simulated event ConstraintBrokenNotify( Actor ConOwner, RB_ConstraintSetup ConSetup, RB_ConstraintInstance ConInstance	)
{
	local ParticleSystemComponent BloodSpray;
	local ParticleSystemComponent BloodSpray2;
	local SkeletalMeshComponent SMC;

	// make sure we should bother spawning an effect
	if(( NumConstraintEffectsSpawned > NumConstraintEffectsSpawnedMax )
		|| ( NanoGRI(WorldInfo.GRI).IsEffectRelevant( Instigator, Location, 2048, FALSE, NanoGRI(WorldInfo.GRI).CheckEffectDistance_SpawnWithinCullDistanceAndInFront ) == FALSE )
		)
	{
		return;
	}


	if( ( ConInstance != None ) && ( WorldInfo.GRI.ShouldShowGore() ) )
	{
		NumConstraintEffectsSpawned++;

		// use this to spawn the "breaking of the constraint effect"
		SMC = SkeletalMeshComponent(ConInstance.OwnerComponent);

		// now spawn the persistent spraying of blood effects

		// CHILD
		BloodSpray = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ConstraintBrokenNotify_LimbChild, SMC, ConSetup.ConstraintBone1,
			false, ConSetup.Pos1 * 50.0, rotator((ConSetup.Pos1 * 50.0) * vect(-1,0,0)) );
		BloodSpray.SetLODLevel(NanoGRI(WorldInfo.GRI).GetLODLevelToUse(BloodSpray.Template, ConInstance.GetConstraintLocation()));

		// PARENT
		// don't spawn the constrain breaking effect if we are gore exploding
		// bHasGoreExploded is set AFTER the various constraint breaking has occurred.  So at that point you can spawn the break
		// as that means someone is playing with the gore.  The same is for bPlayedDeath.  Means he died and you want to be able to break stuff off
		if( bPlayedDeath == FALSE )
		{
			BloodSpray2 = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ConstraintBrokenNotify_LimbParent, SMC, ConSetup.ConstraintBone2,
				false, ConSetup.Pos2, rotator((ConSetup.Pos2 * 1.0f) ) );
			BloodSpray2.SetLODLevel(NanoGRI(WorldInfo.GRI).GetLODLevelToUse(BloodSpray2.Template, ConInstance.GetConstraintLocation()));


			if( bSpawnBloodTrailDecals  )
			{
				// when limbs break we need to spawn some blood on the ground
				SpawnABloodTrail_LimbBreak( ConInstance.GetConstraintLocation() );
			}
		}

		// reset the count so when you go and shoot limbs later you will get correct effects
		SetTimer( 1.0f, FALSE, nameof(ResetNumConstraintEffectsSpawned) );
	}
}

/** This will reset the counter for the constraint effects spawned. **/
final simulated function ResetNumConstraintEffectsSpawned()
{
	NumConstraintEffectsSpawned = 0;
}


/** makes sure all attachments for a nonlocal client pawn are correct */
simulated final function RefreshRemoteAttachments()
{
	if( WorldInfo.NetMode == NM_Client && !IsLocallyControlled() )
	{
		UpdateRemoteWeapon();

		//SetSlotAttachment(EASlot_Holster, AttachSlotClass_Holster);
		//SetSlotAttachment(EASlot_Belt, AttachSlotClass_Belt);
		//SetSlotAttachment(EASlot_LeftShoulder, AttachSlotClass_LeftShoulder);
		//SetSlotAttachment(EASlot_RightShoulder, AttachSlotClass_RightShoulder);
	}
}


/**
* Spawn a slave weapon for remote clients.
*/
simulated protected function UpdateRemoteWeapon()
{
	local NanoWeapon Weap;

	`LogInv("Class:" @ RemoteWeaponRepInfo.WeaponClass @ "bHadAPreviousWeapon:" @ RemoteWeaponRepInfo.BYTE_bHadAPreviousWeapon);

	// If we got same weapon, do nothing.
	if( MyNanoWeapon != None && !MyNanoWeapon.bDeleteMe && RemoteWeaponRepInfo.WeaponClass == MyNanoWeapon.class )
	{
		`LogInv("Got same weapon, do nothing");
		return;
	}

	// If we didn't have a previous weapon, then get rid of the one we have now.
	if (RemoteWeaponRepInfo.BYTE_bHadAPreviousWeapon == 0 && MyNanoWeapon != None && !MyNanoWeapon.bDeleteMe)
	{
		MyNanoWeapon.ClientWeaponThrown();
	}

	// See if we can find the weapon in the Pawn's inventory
	if( RemoteWeaponRepInfo.WeaponClass != None )
	{
		Weap = NanoWeapon(RemoteClientGetInventoryByClass(RemoteWeaponRepInfo.WeaponClass));
		if( Weap != None )
		{
			InvManager.SetCurrentWeapon(Weap);
		}
		else
		{
			if( WorldInfo.IsPlayingDemo() )
			{
				// nonlocal inventory is replicated for demos, wait for it
				SetTimer( 0.1, false, nameof(RefreshRemoteAttachments) );
			}
			else
			{
				`DLog("Couldn't switch to new weapon class!!!" @ RemoteWeaponRepInfo.WeaponClass @ "Weap == None");
			}
		}
	}
	else
	{
		if( MyNanoWeapon != None )
		{
			MyNanoWeapon.ClientWeaponThrown();
		}
	}
}



/**
* Tries to find an inventory item (e.g. a weapon) in the remote's pawn inventory.
* it if doesn't exist, it is spawned.
*/
simulated function Inventory RemoteClientGetInventoryByClass(class<Inventory> InvClass)
{
	local Inventory Inv;
	local NanoWeapon Weap;

	// Make sure we have an inventory manager
	if( InvManager == None )
	{
		`LogInv("InvManager == None, calling RemoteClientSetupInvManager");
		RemoteClientSetupInvManager();
	}

	// First see if we're already carrying this weapon
	Inv = InvManager.FindInventoryType(InvClass);
	// if not, let's see if we can create it
	if( Inv == None )
	{
		if( !IsLocallyControlled() && !WorldInfo.IsPlayingDemo()  )
		{
			Inv = InvManager.CreateInventory(InvClass, TRUE);
			if (Inv != None)
			{
				// if it's a weapon, set up some extra data
				Weap = NanoWeapon(Inv);
				if( Weap != None )
				{
					// Set this weapon as being a Slave.
					Weap.bSlaveWeapon	= TRUE;
					Weap.RemoteRole		= Role_None;
				}
			}
			else
			{
				`log(WorldInfo.TimeSeconds @ GetFuncName() @ "Couldn't Spawn new inventory class!!!" @ InvClass);
			}
		}
		else
		{
			`LogInv("Not allowed to Spawn inventory!! Inv:" @ Inv @ "LocallyControlled:" @ IsLocallyControlled() @ "PlayingDemo:" @ WorldInfo.IsPlayingDemo());
		}
	}

	return Inv;
}



/** This takes care of Spawning an Inventory Manager for remote clients if needed */
simulated final function RemoteClientSetupInvManager()
{
	// Need an inventory manager for remote Pawns...
	// but not for demo playback because it gets replicated in that case
	if (InvManager == None && !WorldInfo.IsPlayingDemo() && !IsLocallyControlled())
	{
		InvManager = Spawn(InventoryManagerClass, Self);
		if( InvManager == None )
		{
			`log("Warning! Couldn't spawn InventoryManager" @ InventoryManagerClass @ "for" @ Self @ GetHumanReadableName());
		}
		else
		{
			InvManager.RemoteRole = ROLE_None;
			InvManager.SetupFor(Self);
		}
	}
}

/** gets called at point where weapon should attach/detach */
simulated function SetWeaponTemporarilyHolstered(bool bHolstered)
{
	if( MyNanoWeapon != None )
	{
		if( bHolstered )
		{
			// Detah weapon from hand
			MyNanoWeapon.DetachWeapon();

			// attach weapon to inventory slot
			AttachWeaponToSlot(MyNanoWeapon);

// 			if( IsDoingMeleeHoldSpecialMove() )
// 			{
// 				EndSpecialMove();
// 			}

			// Notify current Special Move that weapon has been holstered.
// 			if( SpecialMove != SM_None )
// 			{
// 				SpecialMoves[SpecialMove].WeaponTemporarilyHolstered();
// 			}
		}
		else
		{
			AttachWeapon();
		}
	}
}

/** Attach weapon to character inventory slot */
simulated function AttachWeaponToSlot(NanoWeapon W)
{
	// we don't have body attachments yet

	//FIXME
	// current weapon is attached via AttachWeaponToHand()
	// Don't attach grenades on character
// 	if (W != None && (W != Weapon || W.bTemporaryHolster) && W.CharacterSlot != EASlot_Belt)
// 	{
// 		`LogInv("Attach" @ W @ "to slot" @ W.CharacterSlot);
// 		SetSlotAttachment(W.CharacterSlot, W.Class);
// 	}
}


/**
* Player just changed weapon
* Network: Local Player and Server
*
* @param	OldWeapon	Old weapon held by Pawn.
* @param	NewWeapon	New weapon held by Pawn.
*/
simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
	local NanoWeapon	OldWeap; //, NewWeap;

	`LogInv("OldWeapon:" @ OldWeapon @ "NewWeapon:" @ NewWeapon);

	//`log(WorldInfo.TimeSeconds @ "OldWeapon:" @ OldWeapon @ "NewWeapon:" @ NewWeapon);

	OldWeap = NanoWeapon(OldWeapon);

	// detach old weapon from hand
	if( OldWeap != None )
	{
		OldWeap.DetachWeapon();
	}

	// attach old weapon to inventory slot
	AttachWeaponToSlot(OldWeap);

	// Save a reference to carried NanoWeapon, so we don't cast all over the place.
	MyNanoWeapon = NanoWeapon(Weapon);
}


/**
*	Event from c++ land that tells us to play a footstep
**/
simulated event PlayFootStepSound( int FootDown )
{
	local float Loudness;
	local PlayerController PC;


	// this actually accounts for 5ms + when you have 30 ai guys all around each other
	// fighting.  So:
	// don't play this if chaos is up and this pawn is an ai
	// NOTE:  we probably want to still play if we are the only AI near the player
	if( ( AIController(Controller) != None )
		&& ( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
		)
	{
		return;
	}


	if( Role == ROLE_Authority )
	{
		// Noise loudness based on movement speed
		Loudness = (VSize(Velocity) / GroundSpeed);
		MakeNoise( Loudness*Loudness*Loudness, 'NOISETYPE_FootStep' );
	}

	// for each local player we want to see if they are relevant for hearing footsteps and seeing particle effects
	ForEach LocalPlayerControllers( class'PlayerController', PC )
	{
		// 300.0f is from the SoundCue DiststanceCrossFade/Attenuation node
		if( (PC.ViewTarget != None) && (VSize(PC.ViewTarget.Location - Location) < 3000.0f) )
		{
			//`log( (VSize(PC.ViewTarget.Location - Location) ));
			ActuallyPlayFootstepSound( FootDown );
			break;
		}
	}
}

/**
* Handles actual playing of sound.  Separated from PlayFootstepSound so we can LOD / distance code
* determine if we should be playing FootSteps
*/
simulated function ActuallyPlayFootstepSound( int FootDown )
{
	local Actor TraceActor;
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local vector TraceExtent;

	local SoundCue SC;
	local bool bIsRunning;

	// kk here we need to do a tracez0r down down into the ground baby!
	// NOTE: this will eventually be moved to c++ land
	TraceStart = Location;
	TraceDest = TraceStart - ( Vect(0, 0, 1 ) * GetCollisionHeight() ) - Vect(0, 0, 32 );

// 	if( FootDown == 0 )
// 	{
// 		TraceStart = Mesh.GetBoneLocation( LeftKneeBoneName, 0 );
// 		TraceDest = Mesh.GetBoneLocation( LeftFootBoneName, 0 );
// 	}
// 	else
// 	{
// 		TraceStart = Mesh.GetBoneLocation( RightKneeBoneName, 0 );
// 		TraceDest = Mesh.GetBoneLocation( RightFootBoneName, 0 );
// 	}

    // lyrik's footsteps are when the heel hits and the stride is a lot longer than than the gears stride so we end up with a parallelish line to the group
	//TraceDest = TraceDest + ( ( TraceDest - TraceStart ) * 32.0f); // push the dest lower than the foot so we hit something
	//DrawDebugCoordinateSystem( TraceStart, rot(0,0,0), 3.0f, TRUE );
	//DrawDebugCoordinateSystem( Mesh.GetBoneLocation( 'b_MF_Foot_L', 0 ), rot(0,0,0), 3.0f, TRUE );

	// trace down and see what we are standing on
	TraceActor = Trace( out_HitLocation, out_HitNormal, TraceDest, TraceStart, TRUE, TraceExtent, HackLastFootStepTraceInfo, TRACEFLAG_Bullet|TRACEFLAG_PhysicsVolumes );

	//DrawDebugLine( TraceStart, TraceDest, 255, 0, 0, TRUE);
	//`log( TraceActor  );

	if( TraceActor != none )
	{
		// check to see if this is a water volume and use that special WaterPhysMaterials
// 		if( GearWaterVolume(TraceActor) != None )
// 		{
// 			HackLastFootStepTraceInfo.PhysMaterial = GearWaterVolume(TraceActor).WaterPhysMaterial;
// 		}

		// play the actual sound now

		if( HackGetDashPip() >= 0 )
		{
			//`log( "runnnnniinnningingingig" );
			bIsRunning = TRUE;
		}
		else
		{
			//`log( "walking walking" );
			bIsRunning = FALSE;
		}

		SC = class'NanoPhysicalMaterialProperty'.static.DetermineFootStepSound( class'NanoPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( HackLastFootStepTraceInfo ), CharacterFootStepType, WorldInfo, bIsRunning );
		//`log( "ActuallyPlayFootstepSound" @ SC @ self @ HackGetDashPip());

		if (SC != None)
		{
			PlaySound( SC, TRUE, TRUE, FALSE, out_HitLocation, TRUE );
		}


		if( WorldInfo.NetMode != NM_DedicatedServer )
		{
			// TODO: this needs to be updated with a  Determine_______ in the GearPhysMat
			//ActuallyPlayFootParticleEffect( FootDown, LastFootStepTraceInfo, out_HitLocation );
		}

	}
	// otherwise we hit nothing and are in the air
	//else
	//{
	//	`log( " We are in the air" );
	//}
}

// hack hack
simulated function int HackGetDashPip();

/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.GenericPawnDeath;
}

/** Finds all 'nanopawn died' events in Kismet and fires them */
simulated function FireAllNanoPawnDiedEvents(Controller Killer)
{
	local array<Sequence> AllRootSeqs;
	local int LevelIdx, EvtIdx;
	local array<SequenceObject> DiedEvts;
	local SeqEvt_NanoPawnDied DiedEvt;

	// Get all root sequences, from all loaded levels
	AllRootSeqs = WorldInfo.GetAllRootSequences();

	//`log( "FireAllNanoPawnDiedEvents" @ AllRootSeqs.Length );

	// Then for each one, search for 'nano pawn died' event
	for(LevelIdx=0; LevelIdx<AllRootSeqs.Length; LevelIdx++)
	{
		 AllRootSeqs[LevelIdx].FindSeqObjectsByClass(class'SeqEvt_NanoPawnDied', true, DiedEvts);

		 //`log( "FireAllNanoPawnDiedEvents" @ LevelIdx @ AllRootSeqs[LevelIdx] @ DiedEvts.Length );

		 // Then go over each event
		 for(EvtIdx=0; EvtIdx<DiedEvts.Length; EvtIdx++)
		 {
			DiedEvt = SeqEvt_NanoPawnDied(DiedEvts[EvtIdx]);

			// See if it is interested in our class
			if(ClassIsChildOf(Class, DiedEvt.DiedPawnClass))
			{
			   //`log( "FireAllNanoPawnDiedEvents" @ AllRootSeqs[LevelIdx] @ AllRootSeqs[LevelIdx].Outer.Outer.Outer @ DiedEvt @ DiedEvt.Outer @ self );
				DiedEvt.CheckActivate(self, Killer.Pawn);
			}
		 }

		 DiedEvts.Length = 0; // reset the array for the next RootSeq

		 // so this is tricky.  When you do GetAllRootSequences() you will get the _p level and all of the sub levels.
		 // _p levels include ALL of the other levels so you just need to look at that one.
		 // if this ever turns out to not be the case then we want to change the above to
		 // AddUniqueItem to a list and then after this loop iterate over that loop
		 break;
	}
}

/** Find and remove self from the various mission objectives lists **/
final function RemoveSelfFromMissionObjectives()
{
	local MissionInfo Mission;
	local NanoGRI NGRI;

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);

	foreach NGRI.TheMissionManager.Missions( Mission )
	{
		//`log( `showvar(Mission.RadarObjectives.Find( NanoInterface_Objective(self) ) ) );
		//`log( `showvar(Mission.RadarObjectives.Find( self ) ) );
		Mission.RadarObjectives.RemoveItem( NanoInterface_Objective(self) );
	}

	//`log( `showvar(NGRI.TheMissionManager.AdditionalRadarObjectives.Find( NanoInterface_Objective(self) ) ) );
	//`log( `showvar(NGRI.TheMissionManager.AdditionalRadarObjectives.Find( self ) ) );

	NGRI.TheMissionManager.AdditionalRadarObjectives.RemoveItem( NanoInterface_Objective(self) );
}


event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int actualDamage;
    local PlayerController PC;
	local Controller Killer;

	`if(`notdefined(FINAL_RELEASE))
		if (bDebugDamageText || class'NanoGRI'.default.bDebugShowDamage)
		{
			foreach WorldInfo.AllControllers( class'PlayerController', PC )
			{
				PC.AddDebugText( string(Damage), self, 5.f, vect(0,0,64.f), vect(64.f,64.f,256.f) * VRand(), class'HUD'.default.RedColor, TRUE, FALSE, FALSE );
			}
		}
	`endif


    // so here we check to see if we are on the same team and then do NOT do damage to same team
	if( GetTeamNum() == InstigatedBy.GetTeamNum() )
	{
		//`log( "SAME TEAM!! NO DAMAGE!!!!!" @ self @ `showvar(InstigatedBy));
		Damage = 0.0f;
	}


	///////////////////////////////////////////////////////
	///////////////////////////////////////////////////////
	// copied from Pawn.uc as the "died" function is so embedded in everything
	// need a separate  "died from take damage" or something.  (i.e. another layer of indirection to override) UGHH
	///////////////////////////////////////////////////////
	///////////////////////////////////////////////////////


	if ( (Role < ROLE_Authority) || (Health <= 0) )
	{
		return;
	}

	if ( damagetype == None )
	{
		if ( InstigatedBy == None )
			`warn("No damagetype for damage with no instigator");
		else
			`warn("No damagetype for damage by "$instigatedby.pawn$" with weapon "$InstigatedBy.Pawn.Weapon);
		//scripttrace();
		DamageType = class'DamageType';
	}
	Damage = Max(Damage, 0);

	if (Physics == PHYS_None && DrivenVehicle == None)
	{
		SetMovementPhysics();
	}
	if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
	{
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	}
	momentum = momentum/Mass;

	if ( DrivenVehicle != None )
	{
		DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	}

	ActualDamage = Damage;
	WorldInfo.Game.ReduceDamage(ActualDamage, self, instigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
	AdjustDamage(ActualDamage, Momentum, instigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);

	// call Actor's version to handle any SeqEvent_TakeDamage for scripting
	Super(Actor).TakeDamage(ActualDamage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	if( ActualDamage > 0 )
	{
		LastTookDamageTime = WorldInfo.TimeSeconds;
	}

	Health -= actualDamage;
	if (HitLocation == vect(0,0,0))
	{
		HitLocation = Location;
	}

	if ( Health <= 0 )
	{
		PC = PlayerController(Controller);
		// play force feedback for death
		if (PC != None)
		{
			PC.ClientPlayForceFeedbackWaveform(damageType.default.KilledFFWaveform);
		}

		//// So here we want to determine if we should kill the pawn or make it go to DBNO
		// if we we can go into DBNO
		// NOTE: Eventually we probably want the same set up as Gears to have damage type specified and forced DBNO capability
		if( AllowedToDBNO() == TRUE )
		{
			// Send Pawn to DBNO
			EnterDBNO(InstigatedBy, DamageType, Momentum);
		}
		// pawn died
		else
		{
			Killer = SetKillInstigator(InstigatedBy, DamageType);
			TearOffMomentum = momentum;
			Died(Killer, damageType, HitLocation);
		}
	}
	else
	{
		HandleMomentum( momentum, HitLocation, DamageType, HitInfo );
		NotifyTakeHit(InstigatedBy, HitLocation, ActualDamage, DamageType, Momentum);
		if (DrivenVehicle != None)
		{
			DrivenVehicle.NotifyDriverTakeHit(InstigatedBy, HitLocation, actualDamage, DamageType, Momentum);
		}
		if ( instigatedBy != None && instigatedBy != controller )
		{
			LastHitBy = instigatedBy;
		}
	}
	PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum, HitInfo);
	MakeNoise(1.0);

}


function bool AllowedToDBNO()
{
	return bCanDBNO;
}

/** Get a Pawn to enter DBNO state. */
function EnterDBNO(Controller InControllerWhoPutMeDBNO, class<DamageType> InDamageTypeThatPutMeDBNO, vector InMomentumThatPutMeDBNO)
{
	// Save controller for future use (if we bleed out to death)
	ControllerWhoPutMeDBNO = InControllerWhoPutMeDBNO;
	DamageTypeThatPutMeDBNO	= InDamageTypeThatPutMeDBNO;
	MomentumThatPutMeDBNO = Normal(InMomentumThatPutMeDBNO);

	TimeOfDBNO = WorldInfo.TimeSeconds;

	bWasDBNO = TRUE;

	GotoState( 'DBNO' );
}


//
state DBNO
{
	event BeginState(Name PrevStateName)
	{
		`warn( "Should never be in DBNO STATE for the NanoPawnBase class" );
	}
}

function DrawDBNOCountdownTimer( NanoHUD_Base H );


function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local NanoGRI NGRI;

	// Fire all NanoPawnDied events anywhere
	FireAllNanoPawnDiedEvents(Killer);

	RemoveSelfFromMissionObjectives();

	if (Super.Died(Killer,DamageType,HitLocation))
	{
		NGRI = GetGRI();

		// if the NPES kills off the pawn then don't modify the chaos level
		if( class'NDT_KilledByProceduralSpawner' != DamageType )
		{
			NGRI.ModifyChaosLevel( GetChaosZone(), Killer, GetDeathChaosValue() );
		}

		NGRI.NPES.NotifyANewAIHasDied( NanoAI(Controller), DamageType );
		NGRI.AIP.NotifyANewAIHasDied( NanoAI(Controller), DamageType );
		NGRI.NGM.NotifyANewAIHasDied( NanoAI(Controller), DamageType );

		// check killer and see if it is player
		if( NanoPC(Killer) != None )
		{
			if( NanoPC(Killer).CanGainEXP() == TRUE )
			{
				NGRI.MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumKills, 1 );
				NanoGRI(WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_KilledAMetaCorp );
			}
		}

		// if we are destroying thie then do not return TRUE as otherwise all of the Died() code will be run for subclasses
		if( class'NDT_KilledByProceduralSpawner' == DamageType )
		{
			LifeSpan = 0.001f;
			return FALSE;
		}

		return TRUE;
	}
	return FALSE;
}


simulated function PlayDying( class<DamageType> DamageType, vector HitLoc )
{
	// play death and gore only on viewports
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// make room for the new ragdoll
		ManageRagdolls();
	}

	Super.PlayDying( DamageType, HitLoc );
}


State Dying
{
	event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);


	event BeginState( Name NextStateName )
	{
		local NanoCrowd_PanicRepulsor_DeadBody DeadBodyRepulsor;

		Super.BeginState( NextStateName );

		LifeSpan = 0.0f; // don't let the super class "set this failsafe"
		// So here we set how long the corpse should stick around before we start looking every 2.0f seconds to see if we should destroy it	@see Pawn State Dying
		SetTimer( DurationBeforeDestroyingDueToNotBeingSeen, FALSE );


		if( DBNORepulsor != None )
		{
			DBNORepulsor.LifeSpan = 0.001f;
		}

		DeadBodyRepulsor = Spawn( class'NanoCrowd_PanicRepulsor_DeadBody', self,, Location, Rotation,, TRUE );
		DeadBodyRepulsor.SetBase( self );
	}


	// overridden so we can have bShouldDestroyWhenNotSeen check
	event Timer()
	{
		if ( bShouldDestroyWhenNotSeen
			&& `TimeSince(Mesh.LastRenderTime) > DurationOfNotBeingRenderedBeforeActualDestroying
			&& !PlayerCanSeeMe()
			)
		{
			//`log( "Destroy The Dead Pawn!!" @ `showvar(bShouldDestroyWhenNotSeen) @ `showvar(`TimeSince(Mesh.LastRenderTime)) @ `showvar(PlayerCanSeeMe()) );
			Destroy();
		}
		else
		{
			SetTimer( 2.0f, FALSE );
		}
	}


	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );

		// if frame rate is really bad and Pawn hasn't been rendered since last second, then turn off shadow casting
		if( WorldInfo.bDropDetail )
		{
			UpdateShadowSettings( FALSE );
		}

		// if we are scaling to zero then do so
		if( ( bScalingToZero )  )
		{
			SetDrawScale( DrawScale - DeltaTime );
			if( DrawScale < 0.4f )
			{
				// start falling through the floor as scaling byitself looks pretty lame
				SetCollision( FALSE, FALSE, FALSE );
				Mesh.SetRBChannel(RBCC_Nothing);
				Mesh.SetRBCollidesWithChannel(RBCC_Nothing, FALSE);
				Mesh.SetRBCollidesWithChannel(RBCC_Default, FALSE);
				Mesh.SetRBCollidesWithChannel(RBCC_DeadPawn, FALSE);
				Mesh.SetRBCollidesWithChannel(RBCC_BlockingVolume, FALSE);
				if( DrawScale < 0.02f )
				{
					bScalingToZero = FALSE;
					if( bDeleteMe == FALSE )
					{
						Destroy();
					}
				}
			}
		}
	}
}


/**
* Called after spawning from a factory.
*/
event PostAIFactorySpawned(SeqAct_AIFactory SpawningFactory, INT SpawnSetIdx)
{
	if (NanoAI(Controller) != None)
	{
		NanoAI(Controller).PostAIFactorySpawned(SpawningFactory,SpawnSetIdx);
	}
}


/**
* Draw debug information for AimAttractors
*/
simulated function DrawDebugAimAttractors()
{
	local int AttractorIdx, NumAttractors;
	local AimAttractor Attr;
	local vector AttrPos;

	if ( (Health > 0) && ( (Controller == None) || !Controller.IsLocalPlayerController() ) )		// @fixme work in multi?
	{
		NumAttractors = AimAttractors.Length;

		// loop over array, draw the spheres
		for (AttractorIdx=0; AttractorIdx<NumAttractors; ++AttractorIdx)
		{
			Attr = AimAttractors[AttractorIdx];
			AttrPos = Mesh.GetBoneLocation(Attr.BoneName);
			DrawDebugSphere(AttrPos, Attr.InnerRadius, 8, 255, 16, 16, FALSE);
			DrawDebugSphere(AttrPos, Attr.OuterRadius, 8, 255, 255, 16, FALSE);
		}
	}
}


/**
 * Called from PlayerController UpdateRotation() -> ProcessViewRotation() to (pre)process player ViewRotation
 * adds delta rot (player input), applies any limits and post-processing
 * returns the final ViewRotation set on PlayerController
 *
 * @param	DeltaTime, time since last frame
 * @param	ViewRotation, actual PlayerController view rotation
 * @input	out_DeltaRot, delta rotation to be applied on ViewRotation. Represents player's input.
 * @return	processed ViewRotation to be set on PlayerController.
 */
simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	// Give Inventory Manager a chance to affect player's view rotation
	if( NanoInventoryManagerBase(InvManager) != None )
	{
		NanoInventoryManagerBase(InvManager).ProcessViewRotation( DeltaTime, out_ViewRotation, out_DeltaRot );
	}

	Super.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
}


/**
* Returns TRUE if this pawn is in a valid state to engage in a melee attack.
*/
simulated function bool CanEngageMelee()
{
	return TRUE;
}

/**
* Returns location to use when testing if this pawn was hit by a melee attack.  Useful to override, e.g., for
* small creatures close to the ground.
*/
simulated function vector GetMeleeHitTestLocation()
{
	return Location;
}


/**
* Returns true if given target is a valid melee target for this GearPawn, false otherwise.
*/
simulated function bool TargetIsValidMeleeTarget(NanoPawnBase TestGP, bool bLookForPawnsInStateRevival)
{
	local vector ToTargetNorm;
	local float DistToTarget;
	//local NanoGRI GRI;

	// can't target self or fully dead/deleted pawns
	if ( (TestGP == Self) || TestGP.bDeleteMe || TestGP.bPlayedDeath ) // || TestGP.bInvalidMeleeTarget )
	{
		return FALSE;
	}

// 	// prevent attacking a teammate's meatshield
// 	GRI = GearGRI(WorldInfo.GRI);
// 	if( TestGP.IsAHostage() && !GRI.bAllowFriendlyFire && GRI.OnSameTeam(TestGP.InteractionPawn,self) )
// 	{
// 		return FALSE;
// 	}

// 	// can't target dead guys unless specifically looking for DBNO guys
// 	if( (TestGP.Health <= 0) && (!bLookForPawnsInStateRevival || (!TestGP.IsDBNO() && !TestGP.IsAHostage())) )
// 	{
// 		return FALSE;
// 	}

// 	// can't target teammates (unless they're hostages)
// 	if( !TestGP.IsAHostage() && !GRI.bAllowFriendlyFire && GRI.OnSameTeam(TestGP, Self) )
// 	{
// 			return FALSE;
// 	}

	ToTargetNorm = TestGP.Location - Location;
	DistToTarget = VSize(ToTargetNorm);
	ToTargetNorm /= DistToTarget;

	// can't target outside of melee attack range
	if (DistToTarget > GetMeleeAttackRange())
	{
		return FALSE;
	}

// 	// can't target guys protected by cover
// 	if (TestGP.IsProtectedByCover(ToTargetNorm, TRUE))
// 	{
// 		return FALSE;
// 	}
//
// 	// can't target guys protected by shields
// 	if (TestGP.IsDeployingShield() && TestGP.IsProtectedByShield(ToTargetNorm))
// 	{
// 			return FALSE;
// 	}

	// We can target him!
	return TRUE;
}

/** Returns melee attack range, taking current state of the pawn into account (weapon, stance, whatever). */
simulated final function float GetMeleeAttackRange()
{
	return (MyNanoWeapon != None) ? MyNanoWeapon.MeleeAttackRange : UnarmedMeleeRange;
}


/**
*	Gives pawn a chance to override weapon melee damage
*	Return TRUE if overridden & out_Damage updated
*		   FALSE if should use default weapon damage
*/
simulated function bool GetMeleeDamageOverride( out float out_Damage );




/**
* Event called when melee attack begins.
* This means when weapon is enterring melee attacking state on local player and server.
* When Pawn.FiringMode == MELEE_ATTACK_FIREMODE is replicated on remote clients.
*/
simulated function MeleeAttackStarted(NanoWeaponBase Weap)
{
}

/**
* Event called when melee attack ends.
* This means when weapon leaves melee attacking state on local player and server.
* When Pawn.FiringMode != MELEE_ATTACK_FIREMODE is replicated on remote clients, and previous firing mode was MELEE_ATTACK_FIREMODE.
*/
simulated function MeleeAttackEnded(NanoWeaponBase Weap)
{
	local NanoPCBase	PC;

	LastMeleeAttackTime = WorldInfo.TimeSeconds;

	PC = NanoPCBase(Controller);
	if( PC != None )
	{
		//PC.StopMeleeAdhesion();
	}
}


simulated function NanoVolume_ChaosZone GetChaosZone()
{
	return CurrChaosZone;
}

simulated function SetChaosZone( const NanoVolume_ChaosZone InChaosZone )
{
	CurrChaosZone = InChaosZone;
}


simulated function NanoVolume_RebelMindShareZone GetRebelMindShareZone()
{
	return CurrMindShareZone;
}

simulated function SetRebelMindShareZone( const NanoVolume_RebelMindShareZone InMindShareZone )
{
	CurrMindShareZone = InMindShareZone;
}



/** This will activate orbital attractors on this target. **/
simulated function ActivateOrbitalAttractors();

/** This will deactivate orbital attractors on this target. **/
simulated function DeactivateOrbitalAttractors();

/** This is needed to find the location of this OrbitalTarget **/
simulated event vector GetOrbitalTargetLocation()
{
	return Location;
}

/** Each Orbital target will have different valid damage distances. **/
simulated event float GetDistanceForDamage()
{
	return 128.0f;
}

simulated event int GetNumOrbitalsTouchingForDamage()
{
	return NumOrbitalsTouchingForDamage;
}

function Knockback( vector Dir, bool InbKnockDownOnLanding, optional name StunDesc );


/** Whether this target is a valid juggle target */
simulated function bool IsValidJuggleTarget()
{
	return (Health > 0 && !bDeleteMe);
}


simulated function bool CanBeJuggled();


simulated function ResolveJuggleVars( Controller InstigatedBy, out float out_JuggleMag, out float out_JuggleZ, out Vector out_JuggleDir, bool bSkipInputChecks )
{
	local NanoPC PC;
	local Vector HitDir;
	local Actor A;
	local Actor BestJuggleTarget;
	local float BestDistSq, DistSq, DirDotBestTarg;
	local Vector DirToBestTarg;
	local float ThumbStickThreshold;

	// If shot by a player -- give them a chance to steer the juggle if it is active
	PC = NanoPC(InstigatedBy);
	if( PC != None )
	{
		HitDir = out_JuggleDir;

		if( !bSkipInputChecks )
		{
			out_JuggleDir = vect(0,0,0);

			// so if shooting from above it is really hard to make vertical movements without going off the target so
			// we reduce the threshold
			// NOTE: this probably needs some distance scaling also as when guys are far away slight movements on the thumbstick
			// will push the recticle relatively more than if they are closer to the juggler
			ThumbStickThreshold = 0.5f;

			// check to see if we are attempting a juggle first
			// pushing forward
			if( (PC.PlayerInput.RawJoyLookUp) < -ThumbStickThreshold )
			{
				out_JuggleDir.X -= PC.PlayerInput.RawJoyLookUp;
			}
			// pulling back
			else if( (PC.PlayerInput.RawJoyLookUp) > ThumbStickThreshold )
			{
				out_JuggleDir.X = 0;  // this should make it not move and allow us to later just push him upwards when pulling stick back
			}

			if( Abs(PC.PlayerInput.RawJoyLookRight) > 0.5f )
			{
				out_JuggleDir.Y += PC.PlayerInput.RawJoyLookRight;
			}
		}

		out_JuggleDir = Normal(out_JuggleDir);
		if( !IsZero( out_JuggleDir ) )
		{
		    if( !bSkipInputChecks )
		    {
				if( PC.GetActivelyJuggledActor() != self )
				{
					out_JuggleMag = 0.f;
					return;
				}

		    	out_JuggleDir = out_JuggleDir >> Rotator(HitDir);
			}

			foreach VisibleCollidingActors ( class'Actor', A, 2048.f, Location, TRUE, vect(0,0,0), TRUE, class'NanoInterface_JuggleCollision' )
			{
				if( A != self && A != PC.Pawn )
				{
					DistSq = VSizeSq(A.Location-Location);
					if( BestJuggleTarget == None || DistSq < BestDistSq )
					{
						BestDistSq = DistSq;
						BestJuggleTarget = A;
					}
				}
			}
			if( BestJuggleTarget != None )
			{
				DirToBestTarg = Normal(BestJuggleTarget.Location-Location);
				DirDotBestTarg = out_JuggleDir DOT DirToBestTarg;
				if( DirDotBestTarg >= 0.6f )
				{
					out_JuggleDir = DirToBestTarg;
					if( (vect(0,0,1)*out_JuggleZ) DOT (vect(0,0,1)*DirToBestTarg.Z) < 0 )
					{
						out_JuggleZ *= 0.75f;
					}
				}
			}
			else
			{
				out_JuggleZ *= 0.85f;
			}
		}
		else
		{
			// if we are moving the stick then leave our JuggleZ
			if( (PC.PlayerInput.RawJoyLookUp) > ThumbStickThreshold )
			{
			}
			// so if we are not moving the stick do nothing
			else
			{
				out_JuggleZ = 0.0f;
			}
			out_JuggleMag = 0.f;
		}
	}

}


/** Handle this pawn being juggled by damage while falling */
function ApplyJuggle( float JuggleMag, float JuggleZ, Vector Dir, optional NanoPawn Juggler, optional bool bDoKnockBack )
{
	local NanoAI AI;
	local float VelZ, VelDotDir;
	local Vector VDir;

	`loginfo( 'Nano_Locomotion', `location@`showvar(JuggleMag)@`showvar(JuggleZ)@`showvar(Dir));

	if( JuggleZ == 0.f || !CanBeJuggled() )
	{
		return;
	}

	VelZ = Velocity.Z;
	if( !IsZero(Dir) )
	{
		Dir.Z = 0;
		Dir = Normal(Dir);
	}

	// Project Vel onto Dir and then check mag (or if it's goign the wrong way)
	// If not moving away from juggler by at least the desired magnitude
	VDir = ProjectOnTo( Velocity, Dir );
	VelDotDir = VDir DOT Dir;

/*
	if( Physics == Phys_Walking )
	{
		FlushPersistentDebugLines();
		DrawDebugLine( Location, Location + Dir * 128.f, 255, 0, 0, TRUE );
		DrawDebugLine( Location, Location + Normal(Velocity) * 128.f, 0, 255, 0, TRUE );
		DrawDebugLine( Location, Location + Normal(VDir) * 128.f, 0, 0, 255, TRUE );
	}
*/

	if( JuggleMag == 0.f || VelDotDir <= 0 || VSize2D(VDir) < JuggleMag )
	{
		// Increase velocity in that direction
		Velocity = JuggleMag * Dir;
		Velocity.Z = VelZ;
	}

	// If falling, bump full juggle amount
	if( Velocity.Z <= 0 )
	{
		Velocity.Z = JuggleZ;
	}
	else
	{
		// Otherwise, only bump half the juggle amount
		Velocity.Z += (JuggleZ / 2);
	}

	bCheckForFalling = TRUE;
	bJuggled = TRUE;
	LastJuggleTime = WorldInfo.TimeSeconds;

	SetPhysics(PHYS_Falling);

	if( bDoKnockBack )
	{
		// Knock them down when they land
		bKnockDownOnLanding = TRUE;
		// Stun AI until they land from the juggle
		AI = NanoAI(Controller);
		if( AI != None )
		{
			AI.StunAI( 0.f, 'Knockback' );
		}
	}
}


simulated function AddProceduralMisisonReward( const NanoProceduralMissionRewardBase InReward )
{
	ProceduralMissionRewards.AddItem( InReward );
}

simulated function int GetLookAtPriority( NanoPCBase PC, int DefaultPriority )
{
	if ( (PC.Pawn != self) && !bPlayedDeath && WorldInfo.GRI.OnSameTeam(PC.Pawn, self) )
	{
		if ( IsPlayerOwned() )
		{
			return class'NanoPointOfInterest'.Default.POIPriority_ComradeHuman;
		}
		return class'NanoPointOfInterest'.Default.POIPriority_Comrade;
	}

	return DefaultPriority;
}

function bool IsHeadTrackingEnabled()
{
	return (HeadTrackSkelControl != None) && (HeadTrackSkelControl.ControlStrength != 0.f);
}

/** Returns world position that the head bone should look at. This is an adjusted location due to the head bone offset from the eyes. */
simulated native function vector GetHeadLookTargetLocation() const;
/** Returns world position that the eye bones should look at. */
simulated native function vector GetEyeLookTargetLocation() const;

final native simulated protected function UpdateAutomaticHeadTracking();

/**
 * Control headtracking for this pawn.
 *
 * @param ActorToTrack Who you want to look at, or None to look at nothing
 * @param LookatBoneName Bone to lookat on target, if it has bones that is
 * @param bOverride if FALSE, will only set new lookat actor if currently None
 * @Return TRUE if tracking new object, FALSE if request ignored
 */
final simulated native function bool SetHeadTrackActor(Actor ActorToTrack, optional Name LookatBoneName, optional bool bOverride);

final simulated function DisableHeadTrack()
{
	SetHeadTrackActor(None);
}

/////// NanoInterface_Objective
/** Return location of objective, used by radar */
function vector GetObjectiveLocation()
{
	return Location;
}
/////// End NanoInterface_Objective


/**
 * Return world location to start a weapon fire trace from.
 *
 * @return	World location where to start weapon fire traces from
 */
simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	if( NanoPC(Controller) != None )
	{
		return Super.GetWeaponStartTraceLocation();
	}
	// for AI we will use their GetPawnViewLocation
	else
	{
		return GetPawnViewLocation();
	}
}


simulated function NanoGib SpawnGib( class<NanoGib> GibClass, name BoneName, class<DamageType> NanoDamageType, vector HitLocation, bool bSpinGib )
{
	local NanoGib Gib;
	local rotator SpawnRot;
	local int SavedPitch;
	local float GibPerterbation;
	local rotator VelRotation;
	local vector X, Y, Z;

	SpawnRot = QuatToRotator(Mesh.GetBoneQuaternion(BoneName));

	SavedPitch = SpawnRot.Pitch;
	SpawnRot.Pitch = SpawnRot.Yaw;
	SpawnRot.Yaw = SavedPitch;
	Gib = Spawn(GibClass, self,, Mesh.GetBoneLocation(BoneName), SpawnRot);

	if ( Gib != None )
	{
		// add initial impulse
		//GibPerterbation = NanoDamageType.default.GibPerterbation * 32768.0;
		VelRotation = rotator(Gib.Location - HitLocation);
		VelRotation.Pitch += (FRand() * 2.0 * GibPerterbation) - GibPerterbation;
		VelRotation.Yaw += (FRand() * 2.0 * GibPerterbation) - GibPerterbation;
		VelRotation.Roll += (FRand() * 2.0 * GibPerterbation) - GibPerterbation;
		GetAxes(VelRotation, X, Y, Z);

		Gib.Velocity = Velocity + Z * ( FRand() * 50 ) ;
		Gib.GibMeshComp.WakeRigidBody();
		Gib.GibMeshComp.SetRBLinearVelocity(Gib.Velocity, false);
		if ( bSpinGib )
		{
			Gib.GibMeshComp.SetRBAngularVelocity(VRand() * 50, false);
		}

		// let damagetype spawn any additional effects
		//NanoDamageType.static.SpawnGibEffects(Gib);
		Gib.LifeSpan = Gib.LifeSpan + (2.0 * FRand());
	}

	return Gib;
}

final simulated function Name GetCurrHandSocketName()
{
	// we have inverted sockets because of animation mirroring
//	if( bIsMirrored )
//	{
//		return RightHandSocketName;
//	}
	return LeftHandSocketName;
}



/** notification fired from weapon animation when clip is released from weapon. */
simulated function Notify_AmmoRelease()
{
	MyNanoWeapon.Notify_AmmoRelease();
}

/** Notify called when ammo is thrown by player */
simulated function Notify_AmmoThrow()
{
	MyNanoWeapon.Notify_AmmoThrow();
}

/** notification fired from weapon animation when player grabs another magazine. */
simulated function Notify_AmmoGrab()
{
	MyNanoWeapon.Notify_AmmoGrab();
}

/** notification fired from weapon animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload()
{
	MyNanoWeapon.Notify_AmmoReload();
}


/**
 * Handles eliminating old/nonvisible ragdolls to keep performance in check.
 */
final function ManageRagdolls()
{
	local float				OldestTimeOfDeath;
	local NanoPawn			P, OldestDeadPawn;
	local int				NumDeadPawns;
	//@fixme - refactor this to delete farthest/nonvisible ragdolls first, also to ignore inactive (sleeping) ragdolls
	// Check how many Rag Dolled Pawns we have around us.
	// It can get slow if we have too many, so we start killing the oldest one if we get beyond MaxAllowedDeadRagDollPawns.
	foreach WorldInfo.AllPawns(class'NanoPawn', P)
	{
		// Disregard us, pending delete and hidden pawns.
		if( P != Self && !P.bDeleteMe && !P.bScalingToZero && !P.bHidden && !P.Mesh.HiddenGame && P.bPlayedDeath && P.Physics == PHYS_RigidBody )
		{
			NumDeadPawns++;

			if( OldestTimeOfDeath == 0.f || P.TimeOfDeath < OldestTimeOfDeath )
			{
				OldestTimeOfDeath	= P.TimeOfDeath;
				OldestDeadPawn		= P;
			}
		}
	}

	// Kill Oldest Gore Pawn.
	if( NumDeadPawns >= MaxAllowedDeadRagDollPawns && OldestDeadPawn != None )
	{
		//`log( " OldestDeadPawn.bScalingToZero " @ OldestDeadPawn );
		OldestDeadPawn.bScalingToZero = TRUE;
	}
}


/** This will leave some blood when one of our limbs breaks **/
simulated function SpawnABloodTrail_LimbBreak( vector InStartLocation )
{
	if (WorldInfo.GRI != None && NanoGRI(WorldInfo.GRI).IsEffectRelevant(Instigator, InStartLocation, 1000, false, NanoGRI(WorldInfo.GRI).CheckEffectDistance_SpawnWithinCullDistanceAndInFront))
	{
		NanoPawnFX.SpawnABloodTrail_LimbBreak( InStartLocation );
	}
}

delegate OnReleaseInteractionPawn();

simulated function LinkInteractionPawn( NanoPawn InPawn, EPawnInteractionType InType, optional delegate<OnReleaseInteractionPawn> MyDelegateToCallOnRelease, optional delegate<OnReleaseInteractionPawn> OtherDelegateToCallOnRelease )
{
	ClearInteractionPawn();

	if( InPawn != None )
	{
		OnReleaseInteractionPawn = MyDelegateToCallOnRelease;
		InPawn.OnReleaseInteractionPawn = OtherDelegateToCallOnRelease;

		InteractionPawn = InPawn;
		InteractionType = InType;

		InteractionPawn.InteractionPawn = NanoPawn(self);
		InteractionPawn.InteractionType = InType;
	}
}

simulated function ClearInteractionPawn()
{
	if( OnReleaseInteractionPawn != None )
	{
		OnReleaseInteractionPawn();
	}
	OnReleaseInteractionPawn = None;
	ClearTimer(nameof(ClearInteractionPawn));

	if( InteractionPawn != None )
	{
		if( InteractionPawn.OnReleaseInteractionPawn != None )
		{
			InteractionPawn.OnReleaseInteractionPawn();
		}
		InteractionPawn.OnReleaseInteractionPawn = None;
		InteractionPawn.ClearTimer(nameof(ClearInteractionPawn));

		InteractionPawn.InteractionPawn = None;
		InteractionPawn.InteractionType = PAWNINTER_None;
	}
	InteractionPawn = None;
	InteractionType = PAWNINTER_None;
}

/** Hook for Kismet instigated player death. */
final event ScriptedDeath()
{
	LastTakeHitInfo.Momentum = vect(0,0,-1);
	Died( Controller, class'NDT_ScriptedGib', Location+vect(0,0,32) );
}

/**
 * Returns TRUE if relevant for gameplay. That is not hidden, pending destruction or dead.
 * DBNO players are considered gameplay relevant.
 */
final simulated function bool IsGameplayRelevant()
{
	return !bHidden && !bDeleteMe && !bPlayedDeath;
}


/** Returns the UI component which we will then act upon. **/
function UIIconComponent GetUIIconComponent()
{
	return UIComponent;
}


/** This will add any pawn class based path constraints that are wanted when path finding **/
function AddPawnBasedPathConstraints();

function ModifyPawnBasedBoidRules_AvoidTeamaates( bool bShoudAvoid );

simulated function bool ShouldRateTarget()
{
	 // if we have not seen this actor for 2 second then don't allow targeting of it
	return ((WorldInfo.TimeSeconds - LastRenderTime) < 2.0f);
}

// Notification from AI of change in confrontation type
simulated function NotifyConfrontationTypeChanged( EConfrontationType CT, EConfrontationType LastCT );


simulated function PossiblySpawnIRIS_FirstEncounterEffect();

simulated protected function SpawnIRIS_FirstEncounterEffect()
{
	if( PS_IRIS_FirstEncounter != None )
	{
		PSC_IRIS_FirstEncounter = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_IRIS_FirstEncounter, Mesh, IRIS_FirstEncounterBoneName );
		PSC_IRIS_FirstEncounter.SetDepthPriorityGroup( SDPG_Foreground );
		TimeSpawnedFirstEncounterEffect = WorldInfo.TimeSeconds;
	}
}

function bool HasImpactOverride();

function ParticleSystem GetImpactOverrideParticleSystem();

/** Will set a material param on the pawn based off a string color (from mobile world) **/
function SetMaterialSkinColorFromMobile( String InColor );



/**
 * This is an organ removal sequence; think of Marston's gutting an animal in Red Dead.  Camera cut, quick surgery, organ removal, organ goes into plastic bag and is put in jacket pocket.  Plastic gloves for Owen?
 **/
simulated function DBNO_Harvest();

/**
 * this is a QUICK pocket search, to get the contents of pocket.  Owen should find something, and pocket it.
 **/
simulated function DBNO_Patdown();

/**
 * this is a COLLAR GRAB animation, where Owen grabs the enemy; there's a hostile relationship.  Owen will (for argument's sake) THREATEN/SHAKE the enemy to interrogate him.  INTERROGATEE can take beats, and either TALK or NOT TALK.  This will need some squirm room, but ideally we can mock some stuff up with this and see how it works in gameplay.  (Note: This might seem dumb right now, Aaron, but the idea is to create scenarios where injured enemies must be talked to before they bleed out, and while the co-op buddy is covering them.)
 **/
simulated function DBNO_Interrogate();

/**
 * The DBNO'd pawn can be revived by a teammate.
 **/
simulated function DBNO_Revival();

/**
 * The DBNO'd pawn can actually be killed when this function is called.  Usually from some set of fulfilled constraints in DBNO's TakeDamage()
 **/
simulated function DBNO_Execute();



defaultproperties
{
	Components.Remove(Sprite)

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
	InvisibleUpdateTime=5.0
		TickGroup=TG_DuringAsyncWork
		LightShadowMode=LightShadow_Modulate
		bSynthesizeSHLight=TRUE
		bUseBooleanEnvironmentShadowing=FALSE
		ModShadowFadeoutTime=0.75f
		bIsCharacterLightEnvironment=TRUE
		bAllowDynamicShadowsOnTranslucency=TRUE
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)


	Begin Object Class=AudioComponent Name=FaceAudioComponent
	End Object
	FacialAudioComp=FaceAudioComponent
	Components.Add(FaceAudioComponent)

	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)

	Begin Object Class=UIIconComponent Name=UIIconComponent0
	End Object
	UIComponent=UIIconComponent0
	Components.Add(UIIconComponent0)

	bAffectedByHitEffects=TRUE

	bCanStrafe=TRUE

	NanoPawnFXClass=class'NanoPawnFX'

	DelayBeforeUntarget=3.0

	MaxActiveAttackers=100

	bShouldDestroyWhenNotSeen=TRUE
	DurationBeforeDestroyingDueToNotBeingSeen=30.0f
	DurationOfNotBeingRenderedBeforeActualDestroying=30.0f

	NumConstraintEffectsSpawnedMax=10
	bSpawnBloodTrailDecals=TRUE

	HeadBoneOffset=(X=0,Y=0,Z=0)
	HeadshotRadius=20


	DurationBeforeSpawningFirstEncounterEffects=10.0f
	PS_IRIS_FirstEncounter=None
	IRIS_FirstEncounterBoneName="b_MF_Spine_03"
}
