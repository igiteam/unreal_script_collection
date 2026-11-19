/**
* ExamplePawn
 * Demo pawn demonstrating animating character.
 *
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */

//class TPPawn extends GamePawn
class TPPawn extends KynapseGamePawn
	notplaceable
	native
    dependson(TPGear)
	dependson(TPSinglePlayerGameInfo)
    dependson(TPAnimNotify_BulletHit)
    dependson(TPTuneData)
	config(Game);

//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 22

//***********************************************************************
// DEFINES
//***********************************************************************




//***********************************************************************
// struct DECLARATION
//***********************************************************************

enum ELadder
{
	LA_None,
	LA_IdleL,
	LA_IdleR,
	LA_EnterBottom,
	LA_ExitBottom,
	LA_EnterTop,
	LA_ExitTop,
    LA_ExitSewer,
	LA_MoveUpL,
	LA_MoveUpR,
	LA_MoveDownL,
	LA_MoveDownR,
	LA_Slide,
	LA_JumpOff,
	LA_Transition
};

enum EObstacle
{
	OB_Nothing,
	OB_Vaultable,
	OB_VaultMantleable,
	OB_MantleableLow,
	OB_MantleableMedium,
	OB_MantleableHigh,
	OB_Hangable,
	OB_Hoppable,
	OB_Dropping,
	OB_Falling,
	OB_Landed,
	OB_Climbable,
	OB_Catchable,
	OB_VaultableMedium,
	OB_VaultableHigh,
	OB_JumpOff,
	OB_JumpDown,
	OB_JumpLand
};

enum EShimmy
{
	SH_None,
	SH_Left,
	SH_Right,
	SH_LeftIn,
	SH_LeftOut,
	SH_RightIn,
	SH_RightOut
};



enum eHitZone
{
	HZ_None,
	HZ_Head,
	HZ_Chest,
	HZ_Leg,
	HZ_Arm,
};

enum eUniform
{
	//Keep these in order of rank
	Uniform_Peon,
	Uniform_Soldier,
	Uniform_Officer,
	Uniform_Commandant
};

struct native HeightInfo
{
	var float CollisionHeight;
	var vector CollisionTranslation;
	var float CollisionRadius;
	var vector PrePivot;
};

/** view shake information */
struct native ShakeInfo
{
	/** how far to offset view */
	var() vector OffsetMag;
	/** how fast to offset view */
	var() vector OffsetRate;
	/** total duration of view offset shaking */
	var() float OffsetTime;
	/** @note: the rotation data is in vectors instead of rotators so the same function can be used to manipulate them as the offsets above
		X = Pitch, Y = Yaw, Z = Roll
	*/
	/** how far to rotate view */
	var() vector RotMag;
	/** how fast to rotate view */
	var() vector RotRate;
	/** total duration of view rotation shaking */
	var() float RotTime;
};

enum eKillAnimIntensity
{
	KillAnim_Power,
	KillAnim_Medium,
	KillAnim_Weak
};

enum eFFXCharType
{
	FFXCharType_AutoAssign,
	FFXCharType_Angelo,
	FFXCharType_Callahan,
	FFXCharType_GermanA,
	FFXCharType_GermanB,
	FFXCharType_GermanC,
	FFXCharType_GermanD,
	FFXCharType_NationalGuardA,
	FFXCharType_NationalGuardB,
	FFXCharType_NationalGuardC,
	FFXCharType_NationalGuardD,
	FFXCharType_NationalGuardE
};

// enum eOpenFieldPostureSwitchingState
// {
// 	OpenFieldPostureSwitchingState_NotSwitching,
// 	OpenFieldPostureSwitchingState_GoingToStanding,
// 	OpenFieldPostureSwitchingState_GoingToCrouching,
// 	OpenFieldPostureSwitchingState_GoingToStanding_Panic,
// 	OpenFieldPostureSwitchingState_GoingToMountLowMG
// };

//***********************************************************************
// VARIABLE DECLARATION
//***********************************************************************

var() eFFXCharType	FFXCharType;
var() eUniform Uniform;

//var TPAnimBlendByWeapon		WeaponBlend;
//var TPAnimBlendByWeapon		WeaponBlend_FPS;

var bool TriggeredDeathAchievement;

var bool m_bUseAIForAnimation;	// AI vs. Scene control for animation

var(Mesh) SkeletalMeshComponent 	HeadMesh;

// AI object of this Pawn
//var(SparkAI) Agent AIObject;
//var Agent AIObject;

var SpriteComponent RankIcon;




//From the standards map
var config float MinDamageHeight;
var config float MaxDamageHeight;
var config float MaxPlayerHealth;

// Targetting
var(AI) bool bTargettable;

//Defend Area
var(AI) float AttackDistWhileDefendingArea;



var	AudioComponent	FacialAudioComp;



var HeightInfo OriginalHeightInfo; //Save height info in case we scale later
var float CurrentScale;

var float MaxHealth;
var vector LastStandingLocation;

var Name                     StartStateName;
var transient TPLadderVolume Ladder;
var native EObstacle         Obstacle;
var native EObstacle		 m_CurrentObstacle;
var native bool              IsInLadderVolume;
var native float             FallTime;
var native EShimmy           Shimmy;
var native bool              ShimmyToggle;
var native config float		 LadderAnimRateSP;   // Used for singleplayer
var native config float		 LadderAnimRateMP;   // Used for multiplayer

var const float              LadderAngle;
var transient ELadder        LadderAction;
var transient vector         LadderDirection;
var transient float          LadderDistance;
var transient float          LadderTime;
var transient bool           LadderToggle;
var transient bool           LadderRight;

var float                    LastTestMantleZ;

var vector                   KillHitMomentum;
var vector                   KillHitLocation;
var name                     KillHitBoneName;

var array<TPPlayerMovementVolume> MovementVolumes;

// Reference to a blimp if was spawned from one, and last action performed on the blimp
//Kelly changed this to be a TPBaseVehicle type.  This was causing the blimp assets to be in memory all the time!
//var TPAssaultBlimp           Blimp;
var TPBaseVehicle			Blimp;
var AB_Action                BlimpAction;

var bool					m_bNPC_IsVehicleTurretGunner;

// Team management
var ETPSinglePlayerTeam TeamAssignment;		/** Team this pawn belongs to **/

// AI Disability
var(AI) bool bDisableAIOnStart;				// Specifies whether AI should be disabled at start

var		int		MaxLeanRoll;		/** how much pawn should lean into turns */ //SPARK added because Epic deprecated


var SoundCue DefaultFootStepSound;
var SoundCue DefaultFootScuffSound;
var SoundCue DefaultFootRunSound;
var SoundCue DefaultFootSprintSound;
var SoundCue DefaultJumpInitSound;
var SoundCue DefaultJumpLandSound;
var SoundCue DefaultBodyFallSound;
var SoundCue DefaultFallSoftSound;
var SoundCue DefaultCrouchDownSound;
var SoundCue DefaultCrouchStepSound;
var SoundCue DefaultCrouchUpSound;

var     float       FootstepTraceDistance; //number of units to trace below the pawn's origin for footsteps
var bool bInAir;        // True if the pawn is in the middle of a jump

var SeqAct_PlayPerformance performanceAction;

var TPPhysicalMaterial DefaultBloodMaterial;

/** Names of bones that make up the 'lower half' of this actor. */
var()	array<name>		LowerBoneNames;
var()	array<name>		LinearBoneSpringNames;
var()	array<name>		AngularBoneSpringNames;

// HitZone Variables
var() array<name> HeadBoneNames;
var() array<name> ChestBoneNames;
var() array<name> LegBoneNames;
var() array<name> ArmBoneNames;

// If bTakeHeadShots = true, then HeadDamageMul isnt used
var() config bool bTakeHeadShots;

// Hit Zone Modifiers
var() config float DamageMultiplierHead;
var() config float DamageMultiplierChest;
var() config float DamageMultiplierArms;
var() config float DamageMultiplierLegs;

var PhysicsGrenade      PhyGrenade;     // Used only because SetTimer with function parameter seems broken
var PhysicsSmokeGrenade PhySmokeGrenade;
var SeqAct_TossGrenade  SeqTossGrenade; // Used only because SetTimer with function parameter seems broken

enum EPATAState
{
	PATA_FixedAll,
	PATA_FixedLower,
	PATA_MotorRagdoll,
	PATA_Floppy,
	PATA_Recover
};

var     EPATAState      CurrentState;
var     float           BlendBackStartTime;
var     float           BlendAllowTime;
var	    bool            bBlendingBack;
var     float           PokePauseTime;
var     float           PokeBlendTime;
var     float           PokeGraceTime;

var     byte            DestroyTime;
var     byte            FreezeTime;  // Must be less than DestroyTime. If is 0, disables freezing

//Static mesh gear
//var array<StaticMeshComponent>	GearComponents;

var array<TPGear.GearInfoType> GearInfo;
var array<TPGear>              Gear;

var eKillAnimIntensity			KillAnimIntensity;

var bool bIsTPPlayer;           // Since TPAIController has bIsPlayer=true

var Actor MyParachute;

var() const editconst LightEnvironmentComponent LightEnvironment;

var bool bUseAimOffset; //controls whether or not the aim offset anim node is used or bypassed

/** Holds the class type of the current weapon attachment.  Replicated to all clients. */
var	repnotify	class<TPWeaponAttachment>	CurrentWeaponAttachmentClass;
/** This holds the local copy of the current attachment.  This "attachment" actor will exist
  * on all versions of the client. */
var				TPWeaponAttachment			CurrentWeaponAttachment;
var				bool						bIsReloading;		// Whether or not the weapon we are holding is reloading
var				bool						bIsAimDownSight;
var				bool						bIsSprinting;
var				bool						bIsEquipping;
var				bool						bIsPuttingDown;

//var				bool						bToSprint;
//var				bool						bToWalk;
var bool bMeleeAttacking;		// Temp for Multiplayer Melee if we have no weapon.

var() bool m_bAllowUseOfCover; // Flag for turning the use of cover on and off

// var bool	m_bHotTossingThePotato; // throwing back a gren that was thrown at you
// var bool	m_bReactingToGrenadeOut; //
// var bool	m_bCoweringFromGrenade; //
// 
// var bool	m_bThrowingGrenade;
// 
// var int		m_MaxNuberOfPeopleThatCanMeleeMeAtOnce;
// var int		m_CurrentNumberOfPeopleMeleeingMeRightNow;
// 
// var bool	m_bPerformingMeleeRifleHorizontalButtstroke;
// 
// var bool	m_bGoingLowAtHighCornerCover;
// 
// var eOpenFieldPostureSwitchingState	m_OpenFieldPostureSwitchingState;

// AUDIO Sensory

var (Audio_Sensory)	float m_SmallArmsBulletImpactRangeOfInterest;
var (Audio_Sensory)	float m_SmallArmsFiringRangeOfInterest;
var (Audio_Sensory)	float m_GrenadeExplodingRangeOfInterest;
var (Audio_Sensory)	float m_NormalExplodingRangeOfInterest;
var (Audio_Sensory)	float m_NormalExplodingDefaultRangeOfInterest;
var (Audio_Sensory)	float m_WalkingFootFallsRangeOfInterest;
var (Audio_Sensory)	float m_RunningFootFallsRangeOfInterest;
var (Audio_Sensory)	float m_CrouchingFootFallsRangeOfInterest;
var (Audio_Sensory)	float m_FeetScuffiingRangeOfInterest;
var (Audio_Sensory)	float m_HumanJumpingRangeOfInterest;
var (Audio_Sensory)	float m_HumanLandingFromJumpRangeOfInterest;
var (Audio_Sensory)	float m_NormalHumanBodyFallRangeOfInterest;
var (Audio_Sensory)	float m_SoftHumanBodyFallRangeOfInterest;
var (Audio_Sensory)	float m_HumanCrouchingRangeOfInterest;
var (Audio_Sensory)	float m_HumanTakingDamageRangeOfInterest;
var (Audio_Sensory)	float m_ChangedWeaponRangeOfInterest;

var (Audio_Sensory)	bool m_bDisplayAudioSensingRangesAny;
var (Audio_Sensory)	bool m_bDisplayAudioSensingRangesAll;
var (Audio_Sensory)	bool m_bDisplaySmallArmsBulletImpactRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplaySmallArmsFiringRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayGrenadeExplodingRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayNormalExplodingRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayNormalExplodingDefaultRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayWalkingFootFallsRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayRunningFootFallsRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayCrouchingFootFallsRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayFeetScuffiingRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayHumanJumpingRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayHumanLandingFromJumpRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayNormalHumanBodyFallRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplaySoftHumanBodyFallRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayHumanCrouchingRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayHumanTakingDamageRangeOfInterest;
var (Audio_Sensory)	bool m_bDisplayChangedWeaponRangeOfInterest;

var	(Audio_Sensory) color m_DisplaySmallArmsBulletImpactRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplaySmallArmsFiringRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayGrenadeExplodingRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayNormalExplodingRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayNormalExplodingDefaultRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayWalkingFootFallsRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayRunningFootFallsRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayCrouchingFootFallsRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayFeetScuffiingRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayHumanJumpingRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayHumanLandingFromJumpRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayNormalHumanBodyFallRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplaySoftHumanBodyFallRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayHumanCrouchingRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayHumanTakingDamageRangeOfInterestColor;
var (Audio_Sensory)	color m_DisplayChangedWeaponRangeOfInterestColor;

var (Audio_Sensory) SoundCue m_IHeardSomethingSoundCue;


var (AI_AudioEvents)	float	m_WALKING_FOOT_FALLS_Loudness;
var (AI_AudioEvents)	float	m_RUNNING_FOOT_FALLS_Loudness;
var (AI_AudioEvents)	float	m_CROUCHING_FOOT_FALLS_Loudness;
var (AI_AudioEvents)	float	m_FEET_SCUFFIING_Loudness;
var (AI_AudioEvents)	float	m_HUMAN_JUMPING_Loudness;
var (AI_AudioEvents)	float	m_HUMAN_LANDING_FROM_JUMP_Loudness;
var (AI_AudioEvents)	float	m_NORMAL_HUMAN_BODY_FALL_Loudness;
var (AI_AudioEvents)	float	m_SOFT_HUMAN_BODY_FALL_Loudness;
var (AI_AudioEvents)	float	m_HUMAN_CROUCHING_Loudness;
var (AI_AudioEvents)	float	m_HUMAN_TAKING_DAMAGE_Loudness;




//
// UTPAnimNodeBlendByPostureOneShot need to look at the type of cover the pawn was in when he
// died to figure out what type of animation to play.  However, all of this information is
// currently stored in the controller (TPAIController), which get detached as soon as the
// player goes into the dying state, and so it not available to use to determine what type of
// animation to play.  So, I am simply going to maintain a copy of necessary cover information
// in the pawn so it will be available.  Probably, the cover information should be in the Pawn,
// though this is not something that I am going to investigate at this point.
//
var CoverLink.ECoverAction	m_currentCoverActionCopy;	// the current cover action we are currently performing

var bool bAllowInventoryDrops;

// Added for multiple collision cylinders that block bullets
var CylinderComponent HeadCollisionCylinder;
var CylinderComponent TorsoCollisionCylinder;
var CylinderComponent LegsCollisionCylinder;

// Material variation stuff
struct native MaterialVariation
{
	var array<MaterialInterface> MaterialList;
};

var() array<MaterialVariation> MaterialVariations;

var() color AIDebugColor;

var	int	turnZRotStart;	// Use when we start a turn animation, to know how much we have turned so far.
var float turnPlayRate;


var bool				m_bDeadAndDoesNotKnowItYet;
var bool				m_bNeedsToPlowIn;
var Controller			m_DeadAndDoesNotKnowItYetInstigatedBy;
var Vector				m_DeadAndDoesNotKnowItYetHitlocation;
var Vector				m_DeadAndDoesNotKnowItYetMomentum;
var class<DamageType>	m_DeadAndDoesNotKnowItYetDamageType;

var () float			m_HeroDmgPlus;

// Character Image to use in the MP Character selection UI
var Texture2D CharacterImage;

//***********************************************************************
// CPP TEXT
//***********************************************************************

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

replication
{
	if (bNetDirty && !bNetOwner && Role == ROLE_Authority)
		CurrentWeaponAttachmentClass, bIsReloading, bMeleeAttacking,
		bIsAimDownSight, bIsEquipping, bIsPuttingDown, bIsSprinting,// bToSprint, bToWalk,
		Obstacle, LadderToggle, Ladder, LadderAction, LadderRight;
}

//***********************************************************************
// NATIVE FUNCTION DECLARATION
//***********************************************************************

native function AssignFaceFXAsset(FaceFXAsset FaceFXAsset);

// Check through the Arms, Legs, Chest, and Head Bones that you specify in defaults
// return the HitZone you hit
native function eHitZone GetHitZone(name BoneName);

native noexport function bool ReachedDestinationPointOrActor( Vector loc, Actor goalActor);

native noexport function AddAnimSets( array<AnimSet> AnimSets);
native noexport function AddAnimSetsNotUnique(array<AnimSet> AnimSets);
native noexport function RemoveAnimSets( array<AnimSet> AnimSets);
native noexport function RemoveAnimSetFirstOccurrence( array<AnimSet> AnimSets);

//native function AISystem GetAISystem();

native noexport function SetAIAnimControl(bool b);
native noexport function bool GetAIAnimControl();
native noexport function IndividualSceneAnimFinished(SeqAct_Latent action, BOOL bAnimFinished);
native noexport function IndividualPerformanceFinished(SeqAct_Latent action, BOOL bAnimFinished);
native function bool HasAnimTrack();
native function	SnapToFloor();
native function	ScaleBone(Name boneName, float newScale);
native function EObstacle TestMantle (vector HitNormal, out float JumpDistance, optional float StartHeight = -1.f);
native function EObstacle TestVault  (vector HitNormal, out float JumpDistance);
native function bool      CheckMove  (const out vector Delta, vector CurrentPosition);

native function bool TestClimbUp();
native function bool TestLedgeDistance(vector Normal, out float Distance);
native function bool TestLedgeFall(vector Dir, float OutDistance, float DownDistance = 25.0f);
native function EShimmy TestShimmyDirection (float Strafe, out vector ShimmyDirection, out float ManualDistance);
native function SnapToWall (vector Normal, float ZOffset);
native function ELadder TestLadder (float Forward, TPLadderVolume TPLadder);
native function DrawHangDebug ( );


native final function TPAILog(INT LogDetailLevel, Name logCategory, string logText);
//native final static function WorldInfo GetWorldInfo();

native function bool IsTooCloseToWall(const out vector center, const out vector extents);
native function      InitiateRagDollBlending(float DeathAnimLength, out array<name> fixedBones);
native function bool IsRagDollBlending();
native function      TickRagDollBlendingDeath(float DeltaTime);
native function      TickRagDollBlending(float DeltaTime);

function OnAssignFaceFXAsset(SeqAct_AssignFaceFXAsset Action)
{
	if (Action.FaceFXAsset != none)
		AssignFaceFXAsset(Action.FaceFXAsset);
}

reliable client function ClientEndClimbLadder(LadderVolume OldLadder)
{
	if ( Controller != None )
		Controller.EndClimbLadder();
	if ( Physics == PHYS_Ladder )
		SetPhysics(PHYS_Falling);
}

reliable client function ClientSetObstacle(EObstacle O)
{
	Obstacle = O;
}

reliable server function ServerSetLadderAction(ELadder LAction)
{
	LadderAction = LAction;
}

reliable server function ServerSetLadderRight(bool bLadderRight)
{
	LadderRight = bLadderRight;
}
reliable server function ServerSetADS(bool Val)
{
	bIsAimDownSight = Val;
}

reliable server function ServerSetLocationAndRotation(optional vector Loc, optional rotator R)
{
	SetLocation(Loc);
	SetRotation(R);
}


simulated event Destroyed()
{
	super.Destroyed();
	if (MyParachute != none)
	{
		MyParachute.Destroy();
		MyParachute = none;
		SetBase(none);
	}
}
simulated event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
					const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	if (OtherComponent != none && Health <= 0 && OtherComponent.Owner == none)
	{
		if (MyParachute != none)
		{
			MyParachute.Destroy();
			MyParachute = none;
			InitRagdoll();
			Mesh.SetNotifyRigidBodyCollision(false);
			SetBase(none);

		}
	}
}

// Added for causing the client to update his weapon attachment.
simulated event ReplicatedEvent(name VarName)
{
	super.ReplicatedEvent(VarName);
	// If CurrentWeaponAttachmentClass has changed, the player has switched weapons and
	// will need to update itself accordingly.
	if ( VarName == 'CurrentWeaponAttachmentClass' )
	{
		WeaponAttachmentChanged();
		return;
	}
}

simulated function WeaponAttachmentChanged()
{
	if (Role < Role_Authority)
	{
		if ( CurrentWeaponAttachment==None || CurrentWeaponAttachment.Class != CurrentWeaponAttachmentClass)
		{
			if (CurrentWeaponAttachment!=None)
			{
				//Mesh.DetachComponent(CurrentWeaponAttachment.Mesh);
				CurrentWeaponAttachment.DetachFrom(Mesh);
				CurrentWeaponAttachment.Destroy();
			}

			// Create the new Attachment.

			if (CurrentWeaponAttachmentClass!=None)
			{
				CurrentWeaponAttachment = Spawn(CurrentWeaponAttachmentClass,self);
				CurrentWeaponAttachment.Instigator = self;
			}
			else
				CurrentWeaponAttachment = none;

			// If all is good, attach it to the Pawn's Mesh.

			if (CurrentWeaponAttachment != None)
			{
				CurrentWeaponAttachment.AttachTo(self);
				//Mesh.AttachComponent(CurrentWeaponAttachment.Mesh, 'JO_gun');
			}
		}
	}
}

function CopyCoverInfo()
{
	local TPAIController theTPAIController;
    local TPSoldierAIController theTPSoldierAIController;

	theTPAIController = TPAIController(Controller);
    theTPSoldierAIController = TPSoldierAIController(Controller);

    if (theTPSoldierAIController != None && theTPSoldierAIController.GrappleKilled())
    {
        // do nothing
    }
	else if ( theTPAIController != None)
	{
        //
        // Just before we lost our controller and information about our cover status that we
        // need in the anim tree, copy it to over here.
        //
        m_currentCoverActionCopy	= theTPAIController.m_CoverFightData.m_CurrentCoverAction;
	}

}

State Dying
{

	//SPMIRROR - overriding BeginState to eliminate destroy timer, just destroy right away.
	function BeginState(Name PreviousStateName)
	{
		local int i;

		if ( Controller != None )
		{
			if ( Controller.bIsPlayer )
			{
				CopyCoverInfo();
				DetachFromController();
			}
			else
			{
				Controller.Destroy();
			}
		}

		for (i = 0; i < Attached.length; i++)
			if (Attached[i] != None)
				Attached[i].PawnBaseDied();


		//******Destroy pawns right away for now.  (Is it necessary to do things above then?)
	//	Destroy();
	}

Begin:
    /* Turn off any hit reaction! */
    //TurnOffHitReaction ( );

    //`log ("-- NOW GOING INTO RAGDOLL ");
    //Mesh.SetBlockRigidBody(true);
    //`log (" -- Block rigid body on the mesh is " $ Mesh.BlockRigidBody );


	//Detach and reattach the head before going into ragdoll - this improves the head detachment problem.
	//Note that the problem with ragdoll and ParentAnimComponents is a known issue by Epic as of April 2006
//	DetachComponent(HeadMesh);
//	Mesh.AttachComponent(HeadMesh, 'JO_neck');


  //  SetCollision(false,true);
  //  InitRagdoll();
	Mesh.AddImpulse (KillHitMomentum, KillHitLocation, KillHitBoneName);

    if(FreezeTime > 0)
    {
        Sleep(FreezeTime);

        Mesh.bUpdateKinematicBonesFromAnimation=false;
	    Mesh.bUpdateJointsFromAnimation=false;

        SetPhysics(PHYS_None);
    }

    Sleep(DestroyTime - FreezeTime);
    Destroy();

}


//***********************************************************************
// FUNCTION DECLARATIONS
//***********************************************************************

function PostMoveTowardNotify();
function FinishedMove(bool bMoveAborted);

native function bool TPSinglePlayerOnlyStopFiring();


function Name GetStartStateName()
{
	return StartStateName;
}

function TakeFallingDamage()
{
	local float fallenDistance;
	local float damageScale;

	fallenDistance = LastStandingLocation.Z - Location.Z;

    if( fallenDistance > (MinDamageHeight+2.f) )
	{
		//Distance between min and max heights becomes percentage of total health
		damageScale = ( fallenDistance -MinDamageHeight) / (MaxDamageHeight - MinDamageHeight);

        TakeDamage(  MaxPlayerHealth * damageScale, None, Location, vector(Rotation), class'DmgType_Fell');
	}

}

simulated function ThrowActiveWeapon()
{
	local vector	POVLoc, TossVel;
	local rotator	POVRot;

    GetActorEyesViewPoint( POVLoc, POVRot );
    //TossVel = Vector(POVRot);
    TossVel = Vector (Rotation);
    TossVel = TossVel * ((Velocity Dot TossVel) + 300) + Vect(0,0,200);

    TossWeapon(Weapon,TossVel);
}

//simulated function TossWeapon(Vector TossVel)
simulated function TossWeapon(Weapon Weap, optional vector TossVel)
{
	// If we shouldn't throw the weapon, then just destroy it.
	if (!bAllowInventoryDrops)
	{
		if (Weapon != None)
		{
			Weapon.Destroy();
			Weapon = None;
		}
	}
	else
	{
		if( TPWeapon(Weapon) != None )
		{
			TPWeapon(Weapon).SetTossAmmo();
		}

		super.TossWeapon(Weap,TossVel);
	}
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
	return FacialAudioComp;
}

simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
	Mesh.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName);

}

simulated function OnStopFaceFXAnim(SeqAct_StopFaceFXAnim inAction)
{
	Mesh.StopFaceFXAnim();
}

simulated event PostBeginPlay()
{
	local int RandMaterialIndex;
	local int i;
	local int MaterialListLength;

	super.PostBeginPlay();

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().TPPawnMoveData );

    // spawn controller the minute you stream in
	if ( Controller == None )
	{
    	if ( ControllerClass != None )
	    	Controller = Spawn(ControllerClass);

    	if ( Controller != None )
	       	Controller.Possess( Self, false );
	}


//	WeaponBlend = TPAnimBlendByWeapon( mesh.Animations.FindAnimNode('FireNode') );
//	if (WeaponBlend==None)
//	{
//		`log("WARNING: Could not find Firing Node (firenode) for this mesh ("$mesh$")");
//	}
//
//	WeaponBlend_FPS = TPAnimBlendByWeapon( mesh.Animations.FindAnimNode('FireNode_FPS') );
//	if (WeaponBlend_FPS==None)
//	{
//		`log("WARNING: Could not find FPS Firing Node (firenode) for this mesh ("$mesh$")");
//	}

	OriginalHeightInfo.PrePivot = PrePivot;
	OriginalHeightInfo.CollisionHeight = CylinderComponent.CollisionHeight;
	OriginalHeightInfo.CollisionRadius = CylinderComponent.CollisionRadius;
	OriginalHeightInfo.CollisionTranslation = CylinderComponent.Translation;

	//`log("---------"@OriginalHeightInfo.CollisionTranslation@"-----------");

	MaxHealth = Health;
	Health = MaxPlayerHealth;


//	InitializeTwist();

	Mesh.SetHasPhysicsAssetInstance(true);
	Mesh.bUpdateKinematicBonesFromAnimation=true;
	Mesh.bUpdateJointsFromAnimation=true;
	Mesh.SetPhysicsWeight(1.0f);
	//Mesh.SetBlockRigidBody(true);


	// If we have any material variations, apply one of them
	if (MaterialVariations.Length != 0)
	{
		RandMaterialIndex = Rand(MaterialVariations.Length);
		//`log("Using Material Index:"@RandMaterialIndex);
		MaterialListLength = MaterialVariations[RandMaterialIndex].MaterialList.Length;
		for (i = 0; i < MaterialListLength; i++)
			Mesh.SetMaterial(i, MaterialVariations[RandMaterialIndex].MaterialList[i]);
	}

	InitGear();

	// attach new bullet collision cylinders
	Mesh.AttachComponent(HeadCollisionCylinder,'JO_Head', vect(0,0,0));
	Mesh.AttachComponent(TorsoCollisionCylinder, 'JO_SpineA', vect(0,-18,10));
	Mesh.AttachComponent(LegsCollisionCylinder, 'JO_hip', vect(0,45,10));
}

function SetMoveSpeeds( MoveSpeedInfo moveSpeeds )
{
	SupportedMovementTypes[MovementType_Default]	= moveSpeeds.defaultSpeed;
	SupportedMovementTypes[MovementType_Walk]		= moveSpeeds.walkSpeed;
	SupportedMovementTypes[MovementType_Sprint]		= moveSpeeds.sprintSpeed;
	SupportedMovementTypes[MovementType_CrouchRun]	= moveSpeeds.crouchRunSpeed;

	SetMovementType( MovementType_Default );
}

function InitGear()
{
}

function ClearCover(TPAIController AI)
{
	if (AI != None)
	{
		AI.ClearCurrentCover();
		AI.ResetCoverAction();
		//CurrentLink = None;
		//CurrentSlotIdx = -1;
		//SetCoverType( CT_None );
		AI.m_CoverFightData.m_CurrentCoverAction = CA_Default;
		//SetCoverAction( CA_Default );
	}
}

function Restart()
{
	Super.Restart();

	ClearCover(TPAIController(Controller));
}

simulated event bool RestoreAnimSetsToDefault()
{

	if( Mesh.AnimSets.Length == default.Mesh.AnimSets.Length )
	{
		//`log(WorldInfo.TimeSeconds @ GetFuncName() @ Self @ "AnimSets already at default, do not change anything.");
		return FALSE;
	}

	//`log(WorldInfo.TimeSeconds @ GetFuncName() @ "Restoring default AnimSets for" @ Self);
	Mesh.AnimSets = default.Mesh.AnimSets;

	return TRUE;
}

simulated function ClientRestart()
{
	local int Idx;
	local class<Inventory> InvClass;
	local TPPlayerController PC;
	local Inventory Inv;
//	local int Chapter;
	local TPWeapon pWeapon;

	//bQuietWeaponEquipping = TRUE;

	super.ClientRestart();

	ClearCover(TPAIController(Controller));
	//SetTargetingMode(false);

	//`log( "TPPawn ClientRestart " $ self );
	//ScriptTrace();
	PC = TPPlayerController(Controller);

	// Is this a player?
	if( PC != None )
	{
		if (PC.bShouldCheckPointTeleport)
		{
			// do some additional reseting when coming from death
			Health = MaxPlayerHealth;
			//GroundSpeed = DefaultGroundSpeed;
//			PC.DoorTriggerDatum.bInsideDoorTrigger = FALSE;
//			StopAllBodyStances(0);
			GotoState('Idle');

			Self.SetPhysics( PHYS_Falling );

			// Prevent really long drops when restarting.
			LastStandingLocation = Location;

			// clear out current inventory
			InvManager.DiscardInventory();

			// Reset animation sets
			if( RestoreAnimSetsToDefault() )
			{
				Mesh.UpdateAnimations();
			}

			if (PC.CKP_Loadout.bIsValid)
			{
				//`Log("Adding inventory");
				for( Idx = 0; Idx < 4; ++Idx )
				{
					InvClass = class<Inventory>(DynamicLoadObject(PC.CKP_Loadout.WeaponName[Idx],class'class'));
					// Ensure we don't give duplicate items
					if (InvClass != None && FindInventoryType(InvClass) == None)
					{
						Inv = InvManager.CreateInventory(InvClass, Idx != PC.CKP_Loadout.SelectedWeapon);
						pWeapon = TPWeapon(Inv);
						//`Log(InvClass@" gives "@pWeapon);
						if (pWeapon != None)
						{
							pWeapon.AmmoCount = PC.CKP_Loadout.AmmoCount[Idx];
							pWeapon.AmmoInMagazine = PC.CKP_Loadout.AmmoInMagazine[Idx];
						}
					}
				}

				PC.CKP_Loadout.bIsValid = false;
			}

			// make sure we have default inventory if we had no other weapons
//			if (InvManager.InventoryChain == None)
//			{
//				AddDefaultInventory();
//			}

			PC.bShouldCheckPointTeleport = FALSE;

//			Chapter = TPGameReplicationInfo(WorldInfo.GRI).TheChapterPointToStartAt;
			// Update rich presence with the chapter information
//			PC.ClientSetCoopRichPresence(Chapter);
		}
	}

//	SetTimer( 3.0f, FALSE, 'AllowWeaponEquippingSound' );
}



function TurnOffHitReaction ( )
{
    bBlendingBack = false;
    SetPATAState(PATA_FixedAll);
    Mesh.SetPhysicsWeight(1.f);
}

function bool PrePokeActor(vector PokeDir)
{
	////////////////////////////////
	//for anim-based hit reactions
	return false;
	////////////////////////////////


    if (IsInState('Dying'))
    {
        return false;
    }

	// If we are all locked, or we have not actually started blending back yet, reset counter and be in fixed-lower mode.
	//if(CurrentState == PATA_FixedAll || WorldInfo.TimeSeconds >= BlendBackStartTime)
    if (CurrentState == PATA_FixedAll && WorldInfo.TimeSeconds >= BlendAllowTime)
	{
		SetPATAState(PATA_FixedLower);

        bBlendingBack = true;
		BlendBackStartTime = WorldInfo.TimeSeconds + PokePauseTime;

        BlendAllowTime = WorldInfo.TimeSeconds + PokePauseTime + PokeBlendTime + PokeGraceTime;
	}

	return true;
}

/** Function for changing what state we are in. */
function SetPATAState(EPATAState NewState)
{
	// Don't allow changing state while recovering from ragdoll.
	if(CurrentState == PATA_Recover)
	{
		return;
	}

	// Can only recover from floppy state.
	if(NewState == PATA_Recover && CurrentState != PATA_Floppy)
	{
		return;
	}

	if(NewState == PATA_FixedAll)
	{
		//RunNode.bPlaying = true;
		//SetPhysics(PHYS_Interpolating);
		SetBodiesFixed(true);
		EnableMotors(false);
		SetBoneSprings(false);
       Mesh.SetPhysicsWeight(1.0f);
	}
	else if(NewState == PATA_FixedLower)
	{
		//RunNode.bPlaying = true;
		//SetPhysics(PHYS_Interpolating);
		SetLowerFixed();
		EnableMotors(true);
		SetBoneSprings(true);
	}

	CurrentState = NewState;
}

function OnSetRagdollFreezeTime(SeqAct_SetRagdollFreezeTime inAction)
{
	FreezeTime = inAction.FreezeTime;
}

function bool IsLinearBoneSpringName(name InName)
{
	local int i;
	for(i=0; i<LinearBoneSpringNames.Length; i++)
	{
		if(LinearBoneSpringNames[i] == InName)
		{
			return true;
		}
	}

	return false;
}

function bool IsAngularBoneSpringName(name InName)
{
	local int i;
	for(i=0; i<AngularBoneSpringNames.Length; i++)
	{
		if(AngularBoneSpringNames[i] == InName)
		{
			return true;
		}
	}

	return false;
}

/** Turn all motors on or off */
function EnableMotors(bool InEnabled)
{
    Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(InEnabled,InEnabled);
}

function SetBoneSprings(bool bEnabled)
{
	local RB_BodyInstance BodyInst;
	local RB_BodySetup BodySetup;
	local int i, BoneIndex;
	local bool bEnableLinear;
	local bool bEnableAngular;
	local matrix BoneMatrix;

	for(i=0; i<Mesh.PhysicsAsset.BodySetup.Length; i++)
	{
		BodyInst = Mesh.PhysicsAssetInstance.Bodies[i];
		BodySetup = Mesh.PhysicsAsset.BodySetup[i];

		bEnableLinear = IsLinearBoneSpringName(BodySetup.BoneName);
		bEnableAngular = IsAngularBoneSpringName(BodySetup.BoneName);

		if(bEnableLinear || bEnableAngular)
		{
			BoneIndex = Mesh.MatchRefBone(BodySetup.BoneName);
			BoneMatrix = Mesh.GetBoneMatrix(BoneIndex);

			BodyInst.EnableBoneSpring(bEnabled && bEnableLinear, bEnabled && bEnableAngular, BoneMatrix);
		}
	}
}

/** Fix or unfix all bodies */
function SetBodiesFixed(bool InFixed)
{
    Mesh.PhysicsAssetInstance.SetAllBodiesFixed (true);
}

/** Set lower half bones to fixed. */
function SetLowerFixed()
{
    Mesh.PhysicsAssetInstance.SetNamedBodiesFixed(true,LowerBoneNames,Mesh,true);
}

/** returns the point where enemies will be aiming at me **/
native function vector GetAimPoint();

/** Returns the location of the pawn's center-of-mass. Assumed to be at the chest unless the bone doesn't exist */
function vector GetCenterOfMass()
{
	return Mesh.GetBoneLocation(ChestBoneNames[0]);
}


/**
 * We override this as we have pawns leaning out of cover and their view location is really where
 * they are peeking out from.  We are using the NeckBone location as that is what we are using in other
 * parts of the code.  We should probably make a more general socket based mechanic for this.
 **/
simulated function Vector GetPawnViewLocation()
{
	if (HeadBoneNames[0] != '')
	{
		return Mesh.GetBoneLocation( HeadBoneNames[0] );
	}
	else
	{
		// just used the location of the pawn. (this is good for vehicles and other pawns which are missing neckbonenames)
		return Super.GetPawnViewLocation();
	}
}

/**
 * returns true if player is safe from cover
 * This function decides if a shot should be ignored because the player is considered safely protected by its current cover.
 */
final function bool IsProtectedByCover( vector ShotDirection )
{
	local vector2D			AngularDist;
	local vector			AxisX, AxisY, AxisZ;
	local bool				bIsInFront;
	local ECoverAction		CoverAction;
	local ECoverType		CoverType;
	local TPAIController	AIController;
	local Vector2D			CoverProtectionFOV;

	CoverProtectionFOV.X = 60;
	CoverProtectionFOV.Y = 30;

	AIController = TPAIController(Controller);

	if (AIController == None)
		return FALSE;

	CoverType = AIController.GetCurrentCoverType();
	CoverAction = AIController.GetCurrentCoverAction();

	// Make sure player has valid cover
	// This CoverProtection FOV is not applied to AI characters.
	if (CoverType == CT_None)
	{
		return false;
	}

	// If Pawn is leaning, then cover is not safe
	if (CoverAction == CA_LeanLeft ||
		CoverAction == CA_LeanRight ||
		CoverAction == CA_StepLeft ||
		CoverAction == CA_StepRight ||
		CoverAction == CA_PopUp )
	{
		return false;
	}

	GetAxes(Rotation, AxisX, AxisY, AxisZ);
	ShotDirection = -1.f * Normal(ShotDirection);
	bIsInFront = GetAngularDistance(AngularDist, ShotDirection, AxisX, AxisY, AxisZ );
	GetAngularDegreesFromRadians(AngularDist);

	// check shot's angle of attack against cover's orientation
	if (bIsInFront &&
		Abs(AngularDist.X) < CoverProtectionFOV.X &&
		Abs(AngularDist.Y) < CoverProtectionFOV.Y)
	{
		return true;
	}

	return false;
}


simulated function Tick(float DeltaTime)
{
	// fix for kynapse pawn getting stuck on edges, begin change
	bCanWalkOffLedges=true;
	bCanJump=true;
	// fix for kynapse pawn getting stuck on edges, end change

	if(bBlendingBack)
	{
		if(BlendBackStartTime > WorldInfo.TimeSeconds)
		{
			// Pausing before blend
		}
		else if(BlendBackStartTime + PokeBlendTime > WorldInfo.TimeSeconds)
		{
			Mesh.SetPhysicsWeight(1.f - ((WorldInfo.TimeSeconds - BlendBackStartTime)/PokeBlendTime));
		}
		else
		{
			bBlendingBack = false;
			SetPATAState(PATA_FixedAll);
		}
	}

    Super.Tick(DeltaTime);
}

simulated function WeaponFired( bool bViaReplication, optional vector HitLocation )
{
//	`log("TPPawn::WeaponFired");

	//WeaponBlend.AnimFire('Fire_Auto_01',false,Rate, 0.15);
	//WeaponBlend.AnimFire('bp0000b_ground_static_stand_attack_soldierfirecycle', false);

	super.WeaponFired(bViaReplication, HitLocation);
}

function DoMeleeAttackHit()
{
	local TPSoldierAIController aicon;

	//`log("I: " @ Self @ " Just nailed someone's face with my gun, and it felt so good.");

	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.DoMeleeAttackHit();
	}
}

function MeleeAttackFinished()
{
	local TPSoldierAIController aicon;

	//`log(" JohnAI - TPPawn::MeleeAttackFinished--------------------");

	m_bPerformingMeleeRifleHorizontalButtstroke = false;

	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.DoMeleeAttackFinished();
	}
}

function NotifyOpenFieldPostureSwitchingStateNowNotSwitching()
{
	local TPSoldierAIController aicon;

	//`log(" ChadAI - Self: " @ Self @ " NotifyOpenFieldPostureSwitchingStateNowNotSwitching called -----------------------------------------------------------------------------------");
	
	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.NotifyOpenFieldPostureSwitchingStateNowNotSwitching();	
	}
}

function NotifyTransitionToCoverThatRotationToCoverCanStart()
{
	local TPSoldierAIController aicon;

	//`log(" ChadAI - Self: " @ Self @ " NotifyTransitionToCoverThatRotationToCoverCanStart called -----------------------------------------------------------------------------------");
	
	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.NotifyTransitionToCoverThatRotationToCoverCanStart();	
	}
}

function NotifyTransitionToCoverThatRotationToCoverShouldStop()
{
	local TPSoldierAIController aicon;

	//`log(" ChadAI - Self: " @ Self @ " NotifyOpenFieldPostureSwitchingStateNowNotSwitching called -----------------------------------------------------------------------------------");
	
	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.NotifyTransitionToCoverThatRotationToCoverShouldStop();	
	}
}


function JumpOffDone()
{
	local TPSoldierAIController aicon;
	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.JumpOffDone();
	}
}

function JumpLandDone()
{
	local TPSoldierAIController aicon;
	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.JumpLandDone();
	}
}

function ThrowGrenadeAtActor()
{
	local TPSoldierAIController aicon;

	//`log("I: " @ Self @ " Just tossed the pill.");

	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.ThrowGrenadeAtActor();
	}
}

function EndThrowGrenadeAtActor()
{
	local TPSoldierAIController aicon;

	//`log("I: " @ Self @ " I really need to run away and hide now.");

	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.EndThrowGrenadeAtActor();
	}
}

simulated function bool IsThirdPerson()
{
	local TPPlayerController	tPC;

	tPC = TPPlayerController(Controller);
	return (tPC != None && tPC.PlayerCamera != None && tPC.PlayerCamera.CameraStyle == 'ThirdPerson');
}


simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	// Do not update Pawn's rotation depending on controller's ViewRotation if in FreeCam.
	if (!InFreeCam())
	{
        if (!IsThirdPerson())
        {
        		if ( Physics == PHYS_Ladder )
          		{
	        		NewRotation = OnLadder.Walldir;
           		}
	         	else if ( (Physics == PHYS_Walking) || (Physics == PHYS_Falling) )
	          	{
	           		NewRotation.Pitch = 0;
	            }
	            SetRotation(NewRotation);
		}
		else
		{
            //smoothly interpolate to desired rotation.
            NewRotation = RLerp(  Rotation, NewRotation, DeltaTime*4, true);
            NewRotation.Pitch = 0;
            SetRotation(NewRotation);
		}
	}
}

//Play scene from script, without kismet
function PlaySceneAnimation(Name animSeqName, int playCount, optional float AIToSceneBlendTime)
{
	local TPAnimSceneTemplateNode sceneNode;






	sceneNode = TPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));
	if (sceneNode == None)
	{
		;
		return;
	}

    SetAIAnimControl(false);

	//Set the time to blend from AI to Scene animations.












	sceneNode.PlayNewScene(animSeqName, playCount, None, 0.25/*SP_DEFAULT_BLENDTIME*/);

}

native function SetPlaySceneOptions( SeqAct_PlayScene action );
// {
// 	local bool bSetActorCollision;
// 	local bool bNewCollideActors;
// 	local bool bNewBlockActors;
// 
// 	bSetActorCollision = false;
// 	bNewCollideActors = bCollideActors;
// 	bNewBlockActors = bBlockActors;
// 
//     SetAIAnimControl(false);
// 
// 	//Turn off physics... TP reinstated this for root rotation.
// 	SetPhysics(PHYS_None);
// 
// 	if (action.m_bCollideWorld != ETO_LeaveAlone)
// 	{
// 		if (action.m_bCollideWorld == ETO_Enable)
// 		{
// 			bCollideWorld = true;
// 		}
// 		else
// 		{
// 			bCollideWorld = false;
// 		}
// 	}
// 
// 
// 	if (action.m_bCollideActors != ETO_LeaveAlone)
// 	{
// 		bSetActorCollision = true;
// 		if (action.m_bCollideActors == ETO_Enable)
// 		{
// 			bNewCollideActors = true;
// 		}
// 		else
// 		{
// 			bNewCollideActors = false;
// 		}
// 	}
// 
// 	if (action.m_bBlockActors != ETO_LeaveAlone)
// 	{
// 		bSetActorCollision = true;
// 		if (action.m_bBlockActors == ETO_Enable)
// 		{
// 			bNewBlockActors = true;
// 		}
// 		else
// 		{
// 			bNewBlockActors = false;
// 		}
// 	}
// 
// 	if (bSetActorCollision == true)
// 	{
// 		SetCollision(bNewCollideActors, bNewBlockActors);
// 	}
// 
// 	if (action.m_bPathColliding != ETO_LeaveAlone)
// 	{
// 		if (action.m_bPathColliding == ETO_Enable)
// 		{
// 			bPathColliding = true;
// 		}
// 		else
// 		{
// 			bPathColliding = false;
// 		}
// 	}
// 
// //	if (action.m_bTargettable == ETO_Enable)
// //	{
// //		DoToggleTargettable(true);
// //	}
// //	else if (action.m_bTargettable == ETO_Disable)
// //	{
// //		DoToggleTargettable(false);
// //	}
// 
// //	if (action.TeleportInfo.m_bTeleport)
// //	{
// //		if (action.TeleportAndOrientInfo.m_bTeleportAndOrient)
// //		{
// //			`Warn("Play Scene Animation has both m_bTeleport and m_bTeleportAndOrient checked!!!  Which one do you want?");
// //		}
// //
// //		Action.GetObjectVars(objVars,"Destination");
// //		for (idx = 0; idx < objVars.Length && destActor == None; idx++)
// //		{
// //			destActor = Actor(objVars[idx]);
// //
// //			// If its a player variable, teleport to the Pawn not the Controller.
// //			C = Controller(destActor);
// //			if(C != None && C.Pawn != None)
// //			{
// //				destActor = C.Pawn;
// //			}
// //		}
// //
// //		DoTeleport(destActor, action.TeleportInfo.m_bPrePivotAdjust, action.TeleportInfo.m_bUpdateRotation);
// //	}
// 
// //	if (action.TeleportAndOrientInfo.m_bTeleportAndOrient && !action.TeleportInfo.m_bTeleport)
// //	{
// //		DoTeleportOrient(action.TeleportAndOrientInfo.m_Position, action.TeleportAndOrientInfo.m_EulerRotation, action.TeleportAndOrientInfo.m_bUseMayaCoords);
// //	}
// 
// 	if (action.PhysicsInfo.m_bSetPhysics)
// 	{
// 		SetPhysics(action.PhysicsInfo.m_bOverridePhysics);
// 	}
// 
// 
// 
// 	//Set the Root motion mode - should this be an option?
// 	Mesh.RootMotionMode=RMM_Translate;
// 
// 	//Set the Root rotation mode - should this be an option?
// 	Mesh.RootMotionRotationMode = RMRM_RotateActor;
// }

function OnPlaySceneAnimation(SeqAct_PlaySceneAnimation action)
{
	local TPAnimSceneTemplateNode sceneNode;





	local TPAIController tpController;

	// this is important to do first, otherwise the act of enabling/disabling AI will override the scene stuff that we set
	// up right below it.
	tpController = TPAIController(Controller);

    // Do not allow playing scene animations during grapple or Human shield otherwise
    // pawn will break out of it.
    if (tpController.IsInState('Grapple_v2'))
        return;

	if ( tpController != None)
	{
		if (action.m_bEnableAI == ETO_Enable)
		{
			tpController.DoToggleAI(true);
		}
		else if (action.m_bEnableAI == ETO_Disable)
		{
			tpController.DoToggleAI(false);
		}
	}


	// find the scene template node.  This is sort of a hack since we are
	// just looking for some specially named node
	sceneNode = TPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));

	if (sceneNode == None)
	{
		;
		action.bAborted = true;
		return;
	}

	//`AILOG(0, 'Scene',"Playing scene anim:"@action.m_animSeqName@"from:"@action@"-"@action.ObjName@"-"@action.ObjComment);
//	if (m_bUseAIForAnimation)
//	{
//		if (spController != None)
//		{
//			m_bOldNoStepASideValue = spController.m_bNoStepAside;
//			spController.m_bNoStepAside = true;
//		}
//
//	}

	//Put AI on hold...
	if( tpController != None )
		tpController.WaitForSceneFinish();


	//Set the blend time for AI/Scene switch node to default.










	SetPlaySceneOptions( action );




	// tell the scene template node to play
	//`log(self @ "OnPlaySceneAnimation");
	sceneNode.PlayNewScene(action.m_animSeqName, action.m_playCount, action, 0.25/*SP_DEFAULT_BLENDTIME*/);



}

//-----------------------------------------------------------------------
// Function:	 FinishSceneAnimation
// Description:  Explicitly ends any scene animation only... no extra stuff!
//-----------------------------------------------------------------------
native function FinishSceneAnimation(optional float AIToSceneBlendTime);
// {
// 	local TPAnimSceneTemplateNode sceneNode;
// 	//local TPAIController tpController;
// 
// `if(`isdefined(TPGEMINI_TODO))
// 	local TPAnimAISceneNode AISceneSwitchNode;
// 	local array<AnimNode> animNodes;
// `endif
// 
// 
// 	// cancel any current playanimations so they don't fire their finished output
// 	sceneNode = TPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));
// 	if (sceneNode != None)
// 	{
// 		IndividualSceneAnimFinished(sceneNode.m_seqAct, FALSE);
// 
// 		sceneNode.Stop();
// 	}
// 
// //	if (!m_bUseAIForAnimation)
// //	{
// //		tpController = TPAIController(Controller);
// //		if (tpController != None)
// //		{
// //			tpController.m_bNoStepAside = m_bOldNoStepASideValue;
// //		}
// //
// //	}
// 
// 
// 	//Set the time to blend from Scene back to AI animations.
// `if(`isdefined(TPGEMINI_TODO))
// 	Mesh.Animations.FindAnimNodes( class'TPAnimAISceneNode', animNodes );
// 	if( animNodes.Length > 0 )
// 	{
// 		//take the first one...
// 		AISceneSwitchNode = TPAnimAISceneNode(animNodes[0]);
// 		AISceneSwitchNode.m_overrideBlendTime = AIToSceneBlendTime;
// 	}
// `endif
// 
// 	//Set the Root motion mode back to ignore - should this be an option?
// 	Mesh.RootMotionMode=RMM_Ignore;
// 
// 	//Set the Root rotation mode back to ignore - should this be an option?
// 	Mesh.RootMotionRotationMode = RMRM_Ignore;
// 
// 
// 	SetAIAnimControl(true);
// 
// 	//SetBase(None);	// ?? don't remember why this was here, but it doesn't seem right
// }

// Overriden from base class in order to set player pawn's physics and not the controller physics!
simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
	local TPAIController tpController;

	//`log(" ChadAI - TP Pawn:" @ Self @ " OnSetPhysics called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

    tpController = TPAIController(Controller);

	if( tpController != None && tpController.m_bGrappled )
	{
		//`log(" ChadAI - TP Pawn:" @ Self @ " OnSetPhysics called m_bGrappled so just end-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		//`AILOG(1, OnEndSceneAnimation, " OnEndSceneAnimation called but the NPC is being Grappled so ignore" );
		return;
	}

	Super.SetPhysics( Action.NewPhysics );
}

//-----------------------------------------------------------------------
// Function:	 OnEndSceneAnimation
// Description:  Kismet action called when the actor is being told to
//				 end his scene animation and return to AI control
//-----------------------------------------------------------------------
function OnEndSceneAnimation(SeqAct_EndSceneAnimation action)
{
	local bool bSetActorCollision;
	local bool bNewCollideActors;
	local bool bNewBlockActors;
	local TPAIController tpController;

	//`log(" ChadAI - TP Pawn:" @ Self @ " OnEndSceneAnimation called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

    tpController = TPAIController(Controller);

	if( tpController != None && tpController.m_bGrappled )
	{
		//`log(" ChadAI - TP Pawn:" @ Self @ " OnEndSceneAnimation called m_bGrappled so just end-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		//`AILOG(1, OnEndSceneAnimation, " OnEndSceneAnimation called but the NPC is being Grappled so ignore" );
		return;
	}


	FinishSceneAnimation();

	if (tpController != none)
		tpController.SceneFinished();

	bSetActorCollision = false;
	bNewCollideActors = bCollideActors;
	bNewBlockActors = bBlockActors;

	if (action.m_bCollideWorld != ETO_LeaveAlone)
	{
		if (action.m_bCollideWorld == ETO_Enable)
		{
			bCollideWorld = true;
		}
		else
		{
			bCollideWorld = false;
		}
	}


	if (action.m_bCollideActors != ETO_LeaveAlone)
	{
		bSetActorCollision = true;
		if (action.m_bCollideActors == ETO_Enable)
		{
			bNewCollideActors = true;
		}
		else
		{
			bNewCollideActors = false;
		}
	}

	if (action.m_bBlockActors != ETO_LeaveAlone)
	{
		bSetActorCollision = true;
		if (action.m_bBlockActors == ETO_Enable)
		{
			bNewBlockActors = true;
		}
		else
		{
			bNewBlockActors = false;
		}
	}

	if (bSetActorCollision == true)
	{
		SetCollision(bNewCollideActors, bNewBlockActors);
	}

	if (action.m_bPathColliding != ETO_LeaveAlone)
	{
		if (action.m_bPathColliding == ETO_Enable)
		{
			bPathColliding = true;
		}
		else
		{
			bPathColliding = false;
		}
	}

	if (action.PhysicsInfo.m_bSetPhysics)
	{
		SetPhysics(action.PhysicsInfo.m_bOverridePhysics);
	}

//	if (action.m_bTargettable == ETO_Enable)
//	{
//		DoToggleTargettable(true);
//	}
//	else if (action.m_bTargettable == ETO_Disable)
//	{
//		DoToggleTargettable(false);
//	}

	if (tpController != none)
	{
		if (action.m_bEnableAI == ETO_Enable)
		{
			tpController.DoToggleAI(true);
		}
		else if (action.m_bEnableAI == ETO_Disable)
		{
			tpController.DoToggleAI(false);
		}
	}

}

native function bool IsPlayingPerformance();
// {
//     return performanceAction != None;
// }

native function OnPlayPerformance(SeqAct_PlayPerformance action);
// {
// 	local TPAIController tpController;
// 
// 	if( Mesh!=None )
// 	{
// 		Mesh.SetAnimTreeTemplate( action.PerformanceAnimTree );
// 
// 		performanceAction = action;
// 
// 		SetPlaySceneOptions( action );
// 
// 		tpController = TPAIController(Controller);
// 		if( tpController != None )
// 			tpController.WaitForPerformanceFinish();
// 	}
// }

function OnEndPerformance(SeqAct_EndPerformance action)
{
	local TPAIController tpController;

	//`log(" ChadAI - TP Pawn OnEndPerformanceAtCover called -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	tpController = TPAIController(Controller);
	if( tpController != None && tpController.m_bGrappled )
	{
		//`log(" ChadAI - OnEndPerformanceAtCover called but the NPC is being Grappled so ignore  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		//`AILOG(1, 'OnEndPerformanceAtCover', "OnEndPerformanceAtCover called but the NPC is being Grappled so ignore" );
		return;
	}

    performanceAction = None;
	OnPerformanceEnd();
}

native function FinishPerformance();
// {
// 	//This activates the output on the sequence action
// 	IndividualPerformanceFinished( performanceAction, true );
// 
// 	if( Mesh!=None )
// 	{
// 		//Set the Root motion mode back to ignore - should this be an option?
// 		Mesh.RootMotionMode=RMM_Ignore;
// 
// 		//Set the Root rotation mode back to ignore - should this be an option?
// 		Mesh.RootMotionRotationMode = RMRM_Ignore;
// 
// 
// 
// 		//Reset the animtree back to default
// 		Mesh.SetAnimTreeTemplate( Default.Mesh.AnimTreeTemplate );
// 
//         performanceAction = None;
// 	}
// 
// }

//should this event be in actor?
native function OnPerformanceEnd(optional TPPerformance pNode);
//native event OnPerformanceEnd(optional TPPerformance pNode)
//{
//    SetAIAnimControl(true);
//
//	//pass to the controller
//	if( TPAIController(Controller) != none )
//		TPAIController(Controller).OnPerformanceEnd(pNode);
//    else
//        FinishPerformance();
//
//}

function TossGrenade( )
{
    local PhysicsGrenade MyGrenade;
    local PhysicsSmokeGrenade   MySmokeGrenade;
    local vector  SocketLoc;
    local rotator SocketRot;

    if (IsInState('Dying'))
    {
        PhyGrenade = None;
        PhySmokeGrenade = none;
        return;
    }

    Mesh.GetSocketWorldLocationAndRotation('Grenade', SocketLoc, SocketRot);

    if(SeqTossGrenade.bSmokeGrenade)
    {
        MySmokeGrenade = Spawn(class'PhysicsSmokeGrenade',Self,,SocketLoc, mesh.Rotation);

        Mesh.DetachComponent(PhySmokeGrenade.SkeletalMeshComponent);
        //PhyGrenade = None;

	    MySmokeGrenade.CookTime=SeqTossGrenade.CookTime;
	    MySmokeGrenade.SetSmokingTime=SeqTossGrenade.SetSmokingTime;
	    MySmokeGrenade.SkeletalMeshComponent.SetRBRotation(Mesh.Rotation);
	    MySmokeGrenade.SkeletalMeshComponent.AddForce(SeqTossGrenade.ThrowForce >> Rotation);
	    MySmokeGrenade.SkeletalMeshComponent.SetRBAngularVelocity(vect(0,10,0) >> Rotation, true);
    }
    else
    {
        MyGrenade = Spawn(class'PhysicsGrenade',Self,,SocketLoc, Mesh.Rotation);

        Mesh.DetachComponent(PhyGrenade.SkeletalMeshComponent);
        //PhyGrenade = None;

	    MyGrenade.Activate(SeqTossGrenade.CookTime, class'Grenade_Persistent'.static.GetDefaultImpulseForce(),
						class'Grenade_Persistent'.static.GetDefaultAffectedRadius(), class'Grenade_Persistent'.static.GetDefaultDamageCaused_AI());

	    MyGrenade.SkeletalMeshComponent.SetRBRotation(Mesh.Rotation);
	    MyGrenade.SkeletalMeshComponent.AddForce(SeqTossGrenade.ThrowForce >> Rotation);
	    MyGrenade.SkeletalMeshComponent.SetRBAngularVelocity(vect(0,10,0) >> Rotation, true);
	}
}

function TimeToSpawnGrenadeForThrow()
{
	local TPSoldierAIController aicon;

	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.TimeToSpawnGrenadeForThrow();
	}
}

function PickUpOfGrenadeThrowBack()
{
	local TPSoldierAIController aicon;

	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.PickUpOfGrenadeThrowBack();
	}
}


function ReleaseOfGrenadeThrowBack( )
{
	if( TPAIController(Controller) != None )
	{
		TPAIController(Controller).ReleaseOfGrenadeThrowBack();
	}
}

function EndThrowBackGrenade()
{
	local TPSoldierAIController aicon;

	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.EndThrowBackGrenade();
	}
}

function EndTossGrenade()
{
    FinishSceneAnimation(0.1);

    if (Weapon != None)
    {
        Weapon.SetWeaponHidden(false);
        TPSoldierAIController(Controller).EnableAI(TRUE);
    }
}

function DoneWithSupriseAnimation()
{
	local TPSoldierAIController aicon;

	aicon = TPSoldierAIController(Controller);

	if( aicon != None )
	{
		aicon.DoneWithSupriseAnimation();
	}
}


function OnTossGrenade(SeqAct_TossGrenade Seq)
{
    if (PhyGrenade != None)
    {
        Mesh.DetachComponent(PhyGrenade.SkeletalMeshComponent);
    }

    if (PhySmokeGrenade != None)
    {
        Mesh.DetachComponent(PhySmokeGrenade.SkeletalMeshComponent);
    }
//PhyGrenade     = spawn( class'PhysicsGrenade' );
    SeqTossGrenade = Seq;

    if (Weapon != None)
    {
        TPSoldierAIController(Controller).DisableAI();
        Weapon.SetWeaponHidden(true);
    }

    //Mesh.AttachComponentToSocket(PhyGrenade.SkeletalMeshComponent,'GrenadeHand');

    PlaySceneAnimation('bp0006i_ground_static_stand_alert_grenadeequip', 1, 0.1);

    SetTimer(0.675f,false,'TossGrenade');     // @hack 1.35f time grenade is let go in animation  (it's .675f now!)
    SetTimer(1.0f, false,'EndTossGrenade');

    //PlaySceneAnimation('bp0006a_ground_static_stand_alert_grenadelob', 1, 0.1);
    PlaySceneAnimation('bp0006b_ground_static_stand_alert_grenadeheadover', 1, 0.1);
}



/** Called each from while the Matinee action is running, with the desired sequence name and position we want to be at. */
event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
	local TPAnimSceneTemplateNode SeqNode;
	local AnimNodeSequence AnimNode;


	if (Mesh!=none && HasAnimTrack())
	{
		SeqNode = TPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));
		if (SeqNode==None)
		{
			;
			return;
		}
		AnimNode = SeqNode.GetActiveChild();

		if (AnimNode==none)
			return;


		if (InPosition==0.0 && (AnimNode.AnimSeqName!=InAnimSeqName))
			return;		// silly matinee, try again when your serious!   (ask jim for an explanation of this return, do not remove plz)

		//`log("SetAnimPosition w/ " @ InAnimSeqName @ "CurrentTime=" @ AnimNode.CurrentTime@ "InPosition=" @ InPosition);


		SetPhysics(PHYS_None); // animtrack needs none physics to correctly extract rotation/translation


		if (AnimNode!=none)
		{
			if (AnimNode.AnimSeqName!=InAnimSeqName)
			{
				//Put AI on hold...
				if( Controller != None )
					TPAIController(Controller).WaitForSceneFinish();
				SetAIAnimControl(false);

				// tell the scene template node to play
				SeqNode.PlayNewScene(InAnimSeqName, 1, None, 0.0f);
			}
			else
			{
				AnimNode.SetPosition(InPosition, bFireNotifies);
			}
		}
	}
	else
	{
		Super.SetAnimPosition(SlotName,ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping);
	}
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
	local array<Object> objVars;
	local int idx;
	local Actor destActor;
	local Controller C;

	local vector offset, newLocation;


	// find the first supplied actor
	Action.GetObjectVars(objVars,"Destination");
	for (idx = 0; idx < objVars.Length && destActor == None; idx++)
	{
		destActor = Actor(objVars[idx]);

		// If its a player variable, teleport to the Pawn not the Controller.
		C = Controller(destActor);
		if(C != None && C.Pawn != None)
		{
			destActor = C.Pawn;
		}
	}

	if( destActor == None )
	{
		;
		return;
	}

	if( Action.PrePivotAdjust )
	{
		offset = PrePivot >> destActor.Rotation;
		newLocation = (destActor.Location - destActor.PrePivot) + offset;
	}
	else
	{
		newLocation = destActor.Location;
	}


	// and set to that actor's location
	if (destActor != None && SetLocation( newLocation ))
	{
		LastStandingLocation = newLocation;
		PlayTeleportEffect(false, true);
		if (Action.bUpdateRotation)
		{
			SetRotation(destActor.Rotation);
			if( Controller != None && TPPlayerController(Controller) != None)
			{
				//for player: update the controller's rotation too.
				Controller.SetRotation(destActor.Rotation);
			}
		}
	}
	else
	{
		;
	}
}

exec function ChangePosture()
{
   if (bIsCrouched)
   {
        // Move collision position to original standing position
       // CylinderComponent.Translation = OriginalHeightInfo.CollisionTranslation;
        ShouldCrouch(false);
		if (Role < Role_Authority)
			ServerCrouch(false);
   }
   else
   {
        // Move collision position for crouch height
        //CylinderComponent.Translation.Z = CrouchHeight;
        ShouldCrouch(true);
		if (Role < Role_Authority)
			ServerCrouch(true);
   }
}

reliable server function ServerCrouch( bool bCrouch )
{
	bWantsToCrouch = bCrouch;
}

function SetUniform( eUniform newUniform )
{
	Uniform = newUniform;

	//CreateRankIcon(Uniform);
}


function CreateRankIcon(eUniform newUniform)
{
// 	if(RankIcon == None)
// 	{
// 		RankIcon = new(None) class'SpriteComponent';
// 		RankIcon.Translation.Z = 200;
// 		RankIcon.Scale = 0.1;
// 		AttachComponent(RankIcon);
// 	}
// 
// 	switch( newUniform )
// 	{
// 		case Uniform_Peon:
// 			RankIcon.Sprite = Texture2D'HUD_Materials.rank_mech';
// 			break;
// 		case Uniform_Soldier:
// 			RankIcon.Sprite = Texture2D'HUD_Materials.rank01';
// 			break;
// 		case Uniform_Officer:
// 			RankIcon.Sprite = Texture2D'HUD_Materials.rank02';
// 			break;
// 		case Uniform_Commandant:
// 			RankIcon.Sprite = Texture2D'HUD_Materials.rank03';
// 
// 			break;
// 
// 	}
}

function eHitZone GetApproxHitZone( Vector hitlocation )
{
	local eHitZone	closestRegion;
	local float		bulletDistance, closestDistance;
	local int		i;

	closestRegion	= HZ_None;
	closestDistance = 9999999.f;

	// Iterate through all the bones

		// How far was I shot from this bone?

		// Is this closer than the closest bone to the bullet hitpoint?

			// Overwrite closest bone information

	// END ITERATION

	// Report back results 


	for (i = 0; i < HeadBoneNames.Length; i++)
	{
		bulletDistance = VSize( Mesh.GetBoneLocation(HeadBoneNames[i]) - hitlocation );

		if ( closestDistance > bulletDistance )
		{
			closestDistance = bulletDistance;
			closestRegion	= HZ_Head;
		}
	}
	// Check Chest
	for (i = 0; i < ChestBoneNames.Length; i++)
	{
		bulletDistance = VSize( Mesh.GetBoneLocation(ChestBoneNames[i]) - hitlocation );

		if ( closestDistance > bulletDistance )
		{
			closestDistance = bulletDistance;
			closestRegion	= HZ_Chest;
		}
	}
	// Check Arms
	for (i = 0; i < ArmBoneNames.Length; i++)
	{
		bulletDistance = VSize( Mesh.GetBoneLocation(ArmBoneNames[i]) - hitlocation );

		if ( closestDistance > bulletDistance )
		{
			closestDistance = bulletDistance;
			closestRegion	= HZ_Arm;
		}
	}
	// Check Legs
	for (i = 0; i < LegBoneNames.Length; i++)
	{
		bulletDistance = VSize( Mesh.GetBoneLocation(LegBoneNames[i]) - hitlocation );

		if ( closestDistance > bulletDistance )
		{
			closestDistance = bulletDistance;
			closestRegion	= HZ_Leg;
		}

	}

	//`log ( "Closest bone hit is" @ closestRegion @ closestDistance );
	return closestRegion;

}

// Overriden so we can save the momentum of a hit and not call SetMovementPhysics (messes up
// root rotation extraction for animations...)
// TO C++
event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation,
						Vector momentum, class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
 	local int actualDamage;
	local PlayerController PC;
    local TPPlayerController TPPC;
	local Controller Killer;
	local eHitZone	damagedRegion;

//	`Log(Self@"took damage"@Damage@"of"@damageType@"from"@instigatedBy);
	
    if ( Role < ROLE_Authority )
	{
		return;
	}

	if ( damagetype == None )
	{
		// `Warn("No damagetype for damage by "$instigatedby.pawn$" with weapon "$InstigatedBy.Pawn.Weapon);
		DamageType = class'DamageType';
	}

	if ( Health <= 0 )
	{
		return;
	}

	// In single player, locational damage is only done on enemies and not the player or his allies
	if (TeamAssignment == TPTEAM_ENEMY)
	{
		damagedRegion = GetHitZone(HitInfo.BoneName);

		if ( damagedRegion == HZ_None )
			damagedRegion = GetApproxHitZone(hitlocation);

		if( DamageType.IsA('TPDamageTypeImpact') && DamageType != class'TPDamageTypeImpactGrenade' && DamageType != class'DmgType_Fell' )
		{
			switch(damagedRegion)
			{
				case HZ_Arm:
					Damage *= DamageMultiplierArms;
					break;

				case HZ_Leg:
					Damage *= DamageMultiplierLegs;
					break;

				case HZ_Head:
					Damage *= DamageMultiplierHead;
					break;

				case HZ_Chest:
				default:
					Damage *= DamageMultiplierChest;
					break;
			}
		}
		
	}

	;

	//if ( (Physics == PHYS_None) && (DrivenVehicle == None) )
    //    SetMovementPhysics();
	if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ && !bIgnoreForces)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	if ( instigatedBy == self && !bIgnoreForces)
		momentum *= 0.6;
	momentum = momentum/Mass;

	if ( DrivenVehicle != None )
		DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );

	ActualDamage = Damage;
	WorldInfo.Game.ReduceDamage(ActualDamage, self, instigatedBy, HitLocation, Momentum, DamageType);
	AdjustDamage(ActualDamage, Momentum, instigatedBy, HitLocation, DamageType, HitInfo);

	// call Actor's version to handle any SeqEvent_TakeDamage for scripting
	Super(Actor).TakeDamage(actualDamage,instigatedBy,hitlocation,momentum,damageType,HitInfo,DamageCauser);

	Health -= actualDamage;
	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;

	PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum, HitInfo);

    TPPC = TPPlayerController(InstigatedBy);
    if (TPPC != None && TPHUD(TPPC.myHUD) != None)
        TPHUD(TPPC.myHUD).ReticleIndicationUpdate();

	if (Controller != none && !Controller.IsInState('Parachuting') && !Controller.IsInState('ParachutingBurstFireWait'))
	{
		//made this happen always for anim-based hit reactions
		KillHitLocation = HitLocation;
		KillHitMomentum = momentum;
		TearOffMomentum = momentum;
	}
	if ( HitInfo.BoneName != '' )
	{
		KillHitBoneName = HitInfo.BoneName;
	}

	else
	{
		if ( KillHitBoneName == '' )
			KillHitBoneName = 'JO_chest';
	}

	if ( Health <= 0 )
	{
		//`log(" ChadAI - Pawn: " @ Self @ "  Is Dying *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

		// Activate the Rigidbody notification
		Mesh.ScriptRigidBodyCollisionThreshold=1.0;
		Mesh.SetNotifyRigidBodyCollision(true);

		// Activate the event if we are hooked up
		ActivateKilledDamageEvent(damageType);

        if (Blimp != None && TPAssaultBlimp_Persistent(Blimp)!=None )
        {
            TPAssaultBlimp_Persistent(Blimp).TriggerDeathEvent(BlimpAction);
        }

        PC = PlayerController(Controller);

		// play force feedback for death
		if (PC != None)
		{
			PC.ClientPlayForceFeedbackWaveform(damageType.default.KilledFFWaveform);
		}
		// pawn died
		if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == controller) && LastHitBy != None )
			Killer = LastHitBy;
		else if ( instigatedBy != None )
			Killer = instigatedBy;



		if (Killer != None)
		{
			//`log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
			//`log("Killer is"@Killer@",Distance is"@VSize(Killer.Pawn.Location - HitLocation));
			KillAnimIntensity = CalculateKillAnimIntensity(class<TPDamageType>(damageType), VSize(Killer.Pawn.Location - HitLocation));
			//`log("KillAnimIntensity evaluated to"@KillAnimIntensity);
			//`log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
			if(WorldInfo.NetMode == NM_Standalone && !TriggeredDeathAchievement && Killer.IsA('TPPlayerController') && Killer.Pawn != Self)
			{
				TriggeredDeathAchievement = true; // same pawn can't contribute twice to this achievement

				TPPlayerController(Killer).Achievements.ClientIncrementEnemiesKilled();
				if (GetHitZone(HitInfo.BoneName) == HZ_Head)
					TPPlayerController(Killer).Achievements.ClientIncrementSniperKillCount();
				else
					TPPlayerController(Killer).Achievements.ClientResetSniperKillCount();

				if (DamageType == class'TPDamageTypeGrapple')
					TPPlayerController(Killer).Achievements.ClientIncrementGrappleKillCount();
				else
					TPPlayerController(Killer).Achievements.ClientResetGrappleKillCount();

				if (DamageType == class'TPDamageTypeImpactGrenade')
				{
					//`log("grenade busted ass of " $ self);
					TPPlayerController(Killer).Achievements.ClientIncrementGrenadeKillCount();
				}
			}

		}

		if ( TPAIController(Controller) != None )
		{
			Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
		}

		//`log(" ChadAI - Pawn: " @ Self @ " Pawn:TakeDamage I am now going to die m_bDeadAndDoesNotKnowItYet " @ m_bDeadAndDoesNotKnowItYet @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		if( !m_bDeadAndDoesNotKnowItYet )
		{
			Died(Killer, damageType, HitLocation);
		}
	}
	else
	{
		//`log(" ChadAI - Pawn: " @ Self @ " Pawn:TakeDamage Not going to die m_bDeadAndDoesNotKnowItYet " @ m_bDeadAndDoesNotKnowItYet @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

        // use IsA(...) ?
        if (DamageType == class'TPDamageTypeImpactGrenade')
        {
		    AddVelocity( momentum, HitLocation, DamageType, HitInfo );
        }

		if ( Controller != None )
		{
			Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
		}
		if (DrivenVehicle != None)
		{
			DrivenVehicle.NotifyDriverTakeHit(InstigatedBy, HitLocation, actualDamage, DamageType, Momentum);
		}
		if ( instigatedBy != None && instigatedBy != controller )
		{
			LastHitBy = instigatedBy;
		}
	}

	//switch(GetHitZone(HitInfo.BoneName))
	//{
	//case HZ_Head:
	//	log("Hit Head");
	//	break;
	//case HZ_Chest:
	//	log("Hit Chest");
	//	break;
	//case HZ_Arm:
	//	log("Hit Arm");
	//	break;
	//case HZ_Leg:
	//	log("Hit Leg");
	//	break;
	//case HZ_None:
	//	log("Hit Nothing");
	//	break;
	//}
	
	if( TPPlayerController(LastHitBy) != None )
		TPPlayerController(LastHitBy).SetMyLastHitPawn(self);

	MakeNoise(m_HUMAN_TAKING_DAMAGE_Loudness, AudioEventType_HUMAN_TAKING_DAMAGE);
}

function eKillAnimIntensity CalculateKillAnimIntensity(class<TPDamageType> damageType, float distance)
{
	if (distance > damageType.default.PowerMin && distance < damageType.default.PowerMax)
	{
		return KillAnim_Power;
	}
	else if (distance > damageType.default.MediumMin && distance < damageType.default.MediumMax)
	{
		return KillAnim_Medium;
	}
	else if (distance > damageType.default.WeakMin && distance < damageType.default.WeakMax)
	{
		return KillAnim_Weak;
	}

	return damageType.default.KillAnimDefault;
}

function ActivateKilledDamageEvent(class<DamageType> damageType)
{
	// Send out the event for damage types.
	switch(damageType)
	{
	case class'TPDamageTypeImpact':
		TriggerEventClass( class'SeqEvent_KilledDamageType', self, 0);
		break;
	case class'TPDamageTypeImpactGrenade':
		TriggerEventClass( class'SeqEvent_KilledDamageType', self, 1);
		break;
	case class'TPDamageTypeImpactLittleJoe':
		TriggerEventClass( class'SeqEvent_KilledDamageType', self, 2);
		break;
	case class'TPDamageTypeImpactLongRifle':
		TriggerEventClass( class'SeqEvent_KilledDamageType', self, 3);
		break;
	case class'TPDamageTypeImpactMP50':
		TriggerEventClass( class'SeqEvent_KilledDamageType', self, 4);
		break;
	case class'TPDamageTypeImpactPanzer':
		TriggerEventClass( class'SeqEvent_KilledDamageType', self, 5);
		break;
	case class'TPDamageTypeImpactSecBlimp':
		TriggerEventClass( class'SeqEvent_KilledDamageType', self, 6);
		break;
	case class'TPDamageTypeImpactTankShell':
		TriggerEventClass( class'SeqEvent_KilledDamageType', self, 7);
		break;
	case class'TPDamageTypeGrapple':
		TriggerEventClass( class'SeqEvent_KilledDamageType', self, 8);
		break;
	}
}

//function eHitZone GetHitZone(name BoneName)
//{
//	local int i;
//
//	if (BoneName == 'None')
//		return HZ_None;
//
//	// Check head
//	for (i = 0; i < HeadBoneNames.Length; i++)
//	{
//		if( BoneName == HeadBoneNames[i] )
//			return HZ_Head;
//	}
//	// Check Chest
//	for (i = 0; i < ChestBoneNames.Length; i++)
//	{
//		if( BoneName == ChestBoneNames[i] )
//			return HZ_Chest;
//	}
//	// Check Arms
//	for (i = 0; i < ArmBoneNames.Length; i++)
//	{
//		if( BoneName == ArmBoneNames[i] )
//			return HZ_Arm;
//	}
//	// Check Legs
//	for (i = 0; i < LegBoneNames.Length; i++)
//	{
//		if( BoneName == LegBoneNames[i] )
//			return HZ_Leg;
//	}
//
//	return HZ_None;
//}

simulated function bool CanEnterLadderFromBottom ( )
{
    local vector LocToLadderCenter;


    if (IsInLadderVolume)
    {
        LocToLadderCenter = Normal(Ladder.Entrance - Location);

        return (!(Location.Z - 200 < Ladder.Top.Z &&
                  Location.Z + 200 > Ladder.Top.Z) &&
                vector(Rotation) Dot Ladder.LookDir > LadderAngle &&
                LocToLadderCenter Dot Ladder.LookDir > 0);
    }
    else
        return false;
}

simulated function bool CanEnterLadderFromTop ( )
{
    if (IsInLadderVolume)
        return (Location.Z - 200 < Ladder.Top.Z &&
                Location.Z + 200 > Ladder.Top.Z &&
                vector(Rotation) Dot Ladder.LookDir < -LadderAngle);
    else
        return false;
}

function ClimbLadder(LadderVolume L)
{
    local vector LadderEntrance;
    local vector MyRotation;

    OnLadder = L;

    LadderEntrance   = Ladder.Entrance;
    LadderEntrance.Z = Location.Z;
    LadderEntrance  += Ladder.EntranceOffset;

    bCollideWorld = false;

    SetLocation (LadderEntrance);

	if (LadderRight)
    {
        LadderAction = LA_EnterBottom;
		ServerSetLadderAction(LA_EnterBottom);

		if (Role < Role_Authority)
		{
			SetRotation(OnLadder.WallDir);
			ServerSetLocationAndRotation(LadderEntrance, OnLadder.WallDir);
		}	
		else
			SetRotation(OnLadder.WallDir);
    }
    else
    {
        MyRotation = -vector(OnLadder.WallDir);

		bCollideWorld = false;
        LadderAction = LA_EnterTop;
		ServerSetLadderAction(LA_EnterTop);

		if (Role < Role_Authority)
		{
			SetRotation(rotator(MyRotation));
			ServerSetLocationAndRotation(LadderEntrance, OnLadder.WallDir);
		}
		else
			SetRotation(rotator(MyRotation));
    }

	SetPhysics(PHYS_Ladder);

	ServerClimbLadder();

	if ( IsHumanControlled() )
		Controller.GotoState('PlayerClimbing');
}

reliable server function ServerClimbLadder()
{
	OnLadder = Ladder;
	SetPhysics(PHYS_Ladder);
	Controller.GotoState('PlayerClimbing');
}

function Actor GetMovementVolumeActor()
{
    if (TPPlayerController(Controller).CurrentPipeVolume != None)
    {
        return TPPlayerController(Controller).CurrentPipeVolume.ActorRotation;
    }
    else if (MovementVolumes.Length > 0)
    {
        return MovementVolumes[MovementVolumes.Length - 1].ActorRotation;
    }

    return None;
}


function StopMovement ( )
{
    Velocity.X = 0;
    Velocity.Y = 0;
    Velocity.Z = 0;
    Acceleration.X = 0;
    Acceleration.Y = 0;
    Acceleration.Z = 0;
}

event SimulateBulletHit (HitInfo Info)
{
    local vector       HitNormal;
    local ImpactInfo   Impact;

    HitNormal = Mesh.GetBoneAxis (Info.BoneName, AXIS_Z);

    Impact.HitActor    = self;
    Impact.HitLocation = Mesh.GetBoneLocation(Info.BoneName);
    Impact.HitNormal   = HitNormal;
    Impact.RayDir      = -HitNormal;
    Impact.HitInfo.PhysMaterial = DefaultBloodMaterial;
    Impact.HitInfo.BoneName     = Info.BoneName;
    Impact.HitInfo.HitComponent = Mesh;

    DefaultBloodMaterial.SpawnImpactParticles(class'TPDamageTypeImpact', Impact);
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	//pass to the controller
	if( Controller != none )
		Controller.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
}

event OnAnimPlay(AnimNodeSequence SeqNode)
{
	//pass to the controller
	if( Controller != None )
		Controller.OnAnimPlay(SeqNode);
}


//-----------------------------------------------------------------------
// Function:	 IsReloading
// Description:  check if our weapon is reloading
//-----------------------------------------------------------------------
simulated event bool IsReloading()
{
	if (TPWeapon(Weapon) != None)
	{
		//`log(" ChadAI - Pawn: " @ Self @ " IsReloading Current Pawn is asking the weapon -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

		return TPWeapon(Weapon).IsReloading();
	}

	return false;
}



//-----------------------------------------------------------------------
// Function:	 GetWeaponStartTraceLocation
// Description:  overridden because the base implementation assumes we are the player
//-----------------------------------------------------------------------
simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	if ( IsHumanControlled() )
	{
		//players
		return Super.GetWeaponStartTraceLocation(CurrentWeapon);
	}

	if (CurrentWeapon != None)
	{
		return CurrentWeapon.GetPhysicalFireStartLoc();
	}
	else if (Weapon != None)
	{
		return Weapon.GetPhysicalFireStartLoc();
	}

	return Location;
}


function int GetSquadNameIndex()
{
	//This should default to a 'Default' name...
	return 0;
}

/**
 * Override from Pawn class - Always return to thirdperson
 * returns default camera mode when viewing this pawn.
 * Mainly called when controller possesses this pawn.
 *
 * @param	PlayerController requesting the default camera view
 * @return	default camera view player should use when controlling this pawn.
 *
 */
simulated function name GetDefaultCameraMode( PlayerController RequestedBy )
{
	if ( RequestedBy != None && RequestedBy.PlayerCamera != None && RequestedBy.PlayerCamera.CameraStyle == 'Fixed' )
		return 'Fixed';

	return 'FirstPerson';
	//return 'FreeCam';
}

//-----------------------------------------------------------------------
// Function:
// Description:	KISMET action to Hide/Show Weapon Mesh
//-----------------------------------------------------------------------
simulated function OnHideWeapon(SeqAct_HideWeapon Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
        HideWeapon(true);
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		HideWeapon(false);
	}
}

simulated function HideWeapon(bool bEnable)
{
    TPWeapon(Weapon).SetWeaponHidden(bEnable);
}

//-----------------------------------------------------------------------
// Function:	 OnSpeedScale
// Description:
//-----------------------------------------------------------------------
function OnSpeedScale(SeqAct_SpeedScale Action)
{
	MaxDesiredSpeed=Action.Scale;
    DesiredSpeed=Action.Scale;
}

/**
 * Removes all weapons from inventory
*/
simulated function OnRemoveInventoryTP(SeqAct_RemoveInventoryTP InAction)
{
	local Inventory	Inv;
	local vector	TossVelocity;

	if (InvManager != none)
	{
		foreach InvManager.InventoryActors(class'Inventory', Inv)
		{
			if (InAction.bDropItems)
			{
				TossVelocity = vector(GetViewRotation());
				TossVelocity = TossVelocity * ((Velocity dot TossVelocity) + 200.f) + 50.f * VRand() + vect(0,0,100);
				Inv.DropFrom(Location, TossVelocity);
			}
			else
			{
				Inv.Destroy();
			}
		}
	}
}

/**
 * Iterates through the list of item classes specified in the action
 * and creates instances that are addeed to this Pawn's inventory.
 *
 * @param		inAction - scripted action that was activated
 */
simulated function OnGiveInventoryTP(SeqAct_GiveInventoryTP InAction)
{
	local int Idx;
	local class<Inventory> InvClass;
	local TPWeapon AWeapon;
	local int AmountToReload;

	local Inventory WeaponItemAlreadyHas;
	local bool		bFoundInInv;


	local TPAIController tpController;

	tpController = TPAIController(Controller);
	if( tpController != None && tpController.m_bGrappled )
	{
		//`AILOG(1, 'OnGiveInventoryTP', "OnGiveInventoryTP called but the NPC is being Grappled so ignore" );
		return;
	}


	if (InAction.WeaponList.Length > 0 )
	{
		for (Idx = 0; Idx < InAction.WeaponList.Length; Idx++)
		{
			InvClass = InAction.WeaponList[idx].WeaponType;

			//InAction.ScriptLog("WARNING: GiveInventory(TP) Want to be able to create a: " @ InvClass );

			if (InvClass != None)
			{
				AWeapon = TPWeapon(CreateInventory(InvClass));

				if( AWeapon != None )
				{
					AWeapon.AmmoCount = InAction.WeaponList[idx].AmmoToGive;
					AWeapon.AmmoInMagazine = 0;

					AmountToReload = AWeapon.MagazineSize - AWeapon.AmmoInMagazine;

					if (AmountToReload <= AWeapon.AmmoCount)
					{
						AWeapon.AmmoInMagazine += AmountToReload;

						if ( !AWeapon.bInfiniteAmmo )
							AWeapon.AmmoCount -= AmountToReload;
					}
					else
					{
						AWeapon.AmmoInMagazine += AWeapon.AmmoCount;

						if ( !AWeapon.bInfiniteAmmo )
							AWeapon.AmmoCount = 0;
					}

                    if (AWeapon.bIsNPCWeapon)
                        AWeapon.AmmoCount = AWeapon.MagazineSize_AI;  // Ensure NPC can reload
				}
				else
				{
					if( InAction.bGiveAmmoIfHasWeaponAlready )
					{
						// check to see if the pawn already has this weapon and is so give him more ammo for it

						AWeapon = TPWeapon(Spawn(InvClass));

						if( AWeapon != None )
						{
							//InAction.ScriptLog("WARNING: GiveInventory(TP) Spawned: " @ AWeapon @ " ID: " @ AWeapon.WeapID);


							for(WeaponItemAlreadyHas = InvManager.InventoryChain; WeaponItemAlreadyHas != None; WeaponItemAlreadyHas = WeaponItemAlreadyHas.Inventory)
							{
								//InAction.ScriptLog("WARNING: GiveInventory(TP) Testing Against: " @ WeaponItemAlreadyHas @ " ID: " @ TPWeapon(WeaponItemAlreadyHas).WeapID);

								//WeapID="Panzer"
								if( TPWeapon(WeaponItemAlreadyHas).WeapID == AWeapon.WeapID )
								{
									bFoundInInv = TRUE;
									TPWeapon(WeaponItemAlreadyHas).AmmoCount += InAction.WeaponList[idx].AmmoToGive;
                                    if (TPWeapon(WeaponItemAlreadyHas).AmmoCount > TPWeapon(WeaponItemAlreadyHas).MaxAmmo)
                                        TPWeapon(WeaponItemAlreadyHas).AmmoCount = TPWeapon(WeaponItemAlreadyHas).MaxAmmo;

									break;
								}
							}

							AWeapon.Destroy();
						}

						if( bFoundInInv == FALSE )
						{
							InAction.ScriptLog("WARNING: GiveInventory(TP) NOT ABLE TO ADD AMMO TO WEAPON BECAUSE THE NPC DOES NOT HAVE ONE TO GIVE AMMO TO");
						}

					}
					else
					{
						InAction.ScriptLog("WARNING: GiveInventory(TP) attempting to give non-TPWeapon inventory");
					}
				}


			}
			else
			{
				InAction.ScriptLog("WARNING: Attempting to give NULL inventory!");
			}
		}
	}
	else
	{
		InAction.ScriptLog("WARNING: Give Inventory without any inventory specified!");
	}
}

//************************ - BEGIN SECTION - ****************************
// FOOTSTEP event HANDLERS
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated function TPPhysicalMaterial GetStandingMaterial(optional out vector GroundPos)
{
	local Actor HitActor;
	local vector HitLocation, HitNormal;
	local TraceHitInfo			HitInfo;
	local TPPhysicalMaterial SPPhysMat;
	//local PhysicalMaterial PhysMat;
	local vector UpDirection;

	SPPhysMat = None;

	UpDirection = vect(0,0,1) * FootstepTraceDistance;

   	//HitActor = Trace(HitLocation, HitNormal, Location - UpDirection, Location, false,, HitInfo, TRACEFLAG_LevelOnly);
   	HitActor = Trace(HitLocation, HitNormal, Location - UpDirection, Location, false,, HitInfo);

    //`log("GetStandingMaterial - hitactor=" @ HitActor @ "material=" @ HitInfo.Material @ "physmaterial" @ HitInfo.PhysMaterial);

	if( HitActor != None )
	{
		if( HitInfo.Material != None )
		{
			SPPhysMat = TPPhysicalMaterial( HitInfo.Material.PhysMaterial );
		}
		else if( HitInfo.PhysMaterial != None )
		{
			SPPhysMat = TPPhysicalMaterial( HitInfo.PhysMaterial );
		}
	}

	GroundPos = HitLocation;

//`log("GetStandingMaterial returned" @ SPPhysMat);

	return SPPhysMat;
}

//-----------------------------------------------------------------------
// Function: Spawn Effect
// Description:  Called from TPAnimNotify_Effect
//				 Spawns a particle system to a socket.
//-----------------------------------------------------------------------
event SpawnEffect(TPAnimNotify_Effect Effect)
{
	local EmitterSpawnable E;
	local SkeletalMeshSocket theSocket;

	if (Effect.EffectTemplate != none)
	{
		if (Effect.SocketName != '')
		{
			theSocket = Mesh.GetSocketByName( Effect.SocketName );
			if (theSocket != none)
			{
				E =  Spawn(class'EmitterSpawnable');
				E.SetTemplate(Effect.EffectTemplate);
				Mesh.AttachComponentToSocket(E.ParticleSystemComponent, Effect.SocketName);
				E.bDestroyOnSystemFinish = true;
				E.ParticleSystemComponent.ActivateSystem();
			}
		}
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated event PlayFootStepSound(int FootDown)
{
	local	TPPhysicalMaterial	SPPhysMat;
    if (!bInAir)
    {
        //ClientMessage("Hit PlayFootStepSound");
	    SPPhysMat = GetStandingMaterial();
		if ( SPPhysMat != None )
		{
			SPPhysMat.PlayFootStepSound( self );
		}
		 if ( ((SPPhysMat == none) || (SPPhysMat.PlayFootStepSound( self ) == false)) && DefaultFootStepSound != None )
      		PlaySound( DefaultFootStepSound );

		MakeNoise(m_WALKING_FOOT_FALLS_Loudness, AudioEventType_WALKING_FOOT_FALLS);
    }
}
//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated event PlayFootScuffSound(int FootDown)
{
	local	TPPhysicalMaterial	SPPhysMat;
	SPPhysMat = GetStandingMaterial();
	if ( ((SPPhysMat == none) || (SPPhysMat.PlayFootScuffSound( self ) == false)) && DefaultFootScuffSound != None )
		PlaySound( DefaultFootScuffSound );

	MakeNoise(m_FEET_SCUFFIING_Loudness, AudioEventType_FEET_SCUFFIING);
}
//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated event PlayFootRunSound(int FootDown)
{
	local	TPPhysicalMaterial	SPPhysMat;
	SPPhysMat = GetStandingMaterial();
	if ( ((SPPhysMat == none) || (SPPhysMat.PlayFootRunSound( self ) == false)) && DefaultFootRunSound != None )
		PlaySound( DefaultFootRunSound );

	MakeNoise(m_RUNNING_FOOT_FALLS_Loudness, AudioEventType_RUNNING_FOOT_FALLS);
}

simulated event PlayFootSprintSound(int FootDown)
{
	local	TPPhysicalMaterial	SPPhysMat;
	SPPhysMat = GetStandingMaterial();
	if ( ((SPPhysMat == none) || (SPPhysMat.PlayFootSprintSound( self ) == false)) && DefaultFootSprintSound != None )
		PlaySound( DefaultFootSprintSound );

	MakeNoise(m_RUNNING_FOOT_FALLS_Loudness, AudioEventType_RUNNING_FOOT_FALLS);
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated event PlayJumpInitSound()
{
	local	TPPhysicalMaterial	SPPhysMat;
    //ClientMessage("Hit PlayJumpInitSound");
	SPPhysMat = GetStandingMaterial();
	if ( ((SPPhysMat == none) || (SPPhysMat.PlayJumpInitSound( self ) == false)) && DefaultJumpInitSound != None )
		PlaySound( DefaultJumpInitSound );

	MakeNoise(m_HUMAN_JUMPING_Loudness, AudioEventType_HUMAN_JUMPING);
}
//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated event PlayJumpLandSound()
{
	local	TPPhysicalMaterial	SPPhysMat;
    //ClientMessage("Hit PlayJumpLandSound");
	SPPhysMat = GetStandingMaterial();
	if ( ((SPPhysMat == none) || (SPPhysMat.PlayJumpLandSound( self ) == false)) && DefaultJumpLandSound != None )
		PlaySound( DefaultJumpLandSound );

	MakeNoise(m_HUMAN_LANDING_FROM_JUMP_Loudness, AudioEventType_HUMAN_LANDING_FROM_JUMP);

}
//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated event PlayBodyFallSound(int FootDown)
{
	local	TPPhysicalMaterial	SPPhysMat;
	SPPhysMat = GetStandingMaterial();
	if ( ((SPPhysMat == none) || (SPPhysMat.PlayBodyFallSound( self ) == false)) && DefaultBodyFallSound != None )
		PlaySound( DefaultBodyFallSound );

	MakeNoise(m_NORMAL_HUMAN_BODY_FALL_Loudness, AudioEventType_NORMAL_HUMAN_BODY_FALL);

}
//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated event PlayBodyFallSoftSound(int FootDown)
{
	local	TPPhysicalMaterial	SPPhysMat;
	SPPhysMat = GetStandingMaterial();
	if ( ((SPPhysMat == none) || (SPPhysMat.PlayBodyFallSoftSound( self ) == false)) && DefaultFallSoftSound != None )
		PlaySound( DefaultFallSoftSound );

	MakeNoise(m_SOFT_HUMAN_BODY_FALL_Loudness, AudioEventType_SOFT_HUMAN_BODY_FALL);
}
//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated event PlayCrouchDownSound()
{
	local	TPPhysicalMaterial	SPPhysMat;
	SPPhysMat = GetStandingMaterial();
	if ( ((SPPhysMat == none) || (SPPhysMat.PlayCrouchDownSound( self ) == false)) && DefaultCrouchDownSound != None )
		PlaySound( DefaultCrouchDownSound );

	MakeNoise(m_HUMAN_CROUCHING_Loudness, AudioEventType_HUMAN_CROUCHING);
}
//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated event PlayCrouchStepSound(int FootDown)
{
	local	TPPhysicalMaterial	SPPhysMat;
	SPPhysMat = GetStandingMaterial();
	if ( ((SPPhysMat == none) || (SPPhysMat.PlayCrouchStepSound( self ) == false)) && DefaultCrouchStepSound != None )
		PlaySound( DefaultCrouchStepSound );

	MakeNoise(m_CROUCHING_FOOT_FALLS_Loudness, AudioEventType_CROUCHING_FOOT_FALLS);
}
//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
simulated event PlayCrouchUpSound()
{
	local	TPPhysicalMaterial	SPPhysMat;
	SPPhysMat = GetStandingMaterial();
	if ( ((SPPhysMat == none) || (SPPhysMat.PlayCrouchUpSound( self ) == false)) && DefaultCrouchUpSound != None )
		PlaySound( DefaultCrouchUpSound );

	MakeNoise(m_HUMAN_CROUCHING_Loudness, AudioEventType_HUMAN_CROUCHING);
}

//***********************************************************************
// FOOTSTEP EVENT HANDLERS
//************************ - END SECTION - ******************************


function bool PosessesHostileWeapon()
{
	local TPWeapon		Weap;

	ForEach InvManager.InventoryActors(class'TPWeapon', Weap)
	{
		if (Weap.bHostile)
		{
			return true;
		}
	}
	return false;

}

//----------------------------------------------------------------------
// KISMET
// Description: Toggles enemy targeting on pawns
//---------------------------------------------------------------------

function onTargettable(SeqAct_Targettable action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
        bTargettable = true;
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bTargettable = false;
	}
	else
	{
	    bTargettable = !bTargettable;
	}
}

//----------------------------------------------------------------------
// KISMET
// Description: Sets health on pawn
//---------------------------------------------------------------------

function OnSetHealth(SeqAct_SetHealth action)
{
    Health=action.Health;
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
// -----------------------------
	local TPSkeletalMeshComponent	weapMesh;
	local TPSkeletalMeshComponent	pawnSkelMesh;
	local SkelControlSingleBone		HeadShrink;

	bReplicateMovement				= false;
	bTearOff						= true;
	bPlayedDeath					= true;

	Mesh.SetRBCollidesWithChannel(RBCC_Default, true);
	TurnOffHitReaction ( );
	Mesh.SetBlockRigidBody(true);
	SetCollision(false,true);

	// Meshes no longer need to be in foreground once unpossess takes place and we aren't viewing in 1st person.
	Mesh.SetDepthPriorityGroup(SDPG_World);

	// And reset their fov
	pawnSkelMesh = TPSkeletalMeshComponent(Mesh);

	if( pawnSkelMesh != None )
	{
		pawnSkelMesh.SetFOV(0);
	}

	// Is this player using a weapon or weapon attachment?
	if ( weapon != None )
		weapMesh = TPSkeletalMeshComponent(weapon.Mesh);
	else if ( CurrentWeaponAttachment != None )
		weapMesh = TPSkeletalMeshComponent(CurrentWeaponAttachment.Mesh);

	// Set this pawn's weapon or weapon attachment to the world depth priority group (DPG) and reset their fov
	if ( weapMesh != None )
	{
		weapMesh.SetDepthPriorityGroup(SDPG_World);
		weapMesh.SetFOV(0);
	}

	// And remove any headshrink
	HeadShrink = SkelControlSingleBone(Mesh.FindSkelControl('HeadShrink'));
	if( HeadShrink != None )
	{
		HeadShrink.SetSkelControlActive(FALSE);
	}

// ---------------------
	if (TPPlayerController(Controller) != none && IsLocallyControlled() )
	{
		if (TPWeapon(Weapon) != None && TPWeapon(Weapon).IsAimDownSight()) //SPLITSCRIPTS_TODO
		{
			TPWeapon(Weapon).ToggleAimDownSight(TPPlayerController(Controller));
		}
		TpHUD(TPPlayerController(Controller).myHUD).bDrawSniperView = false;
	}

    Mesh.bPauseAnims = TRUE;
    InitRagdoll();

	if (TPMPGameReplicationInfo(WorldInfo.GRI) != none)
	{
		;
		LifeSpan = TPMPGameReplicationInfo(WorldInfo.GRI).PawnCleanUpTime;
	}

	if (Controller != none && !Controller.IsInState('Parachuting') && !Controller.IsInState('ParachutingBurstFireWait'))
	{
		GotoState('Dying');
		Velocity += TearOffMomentum;
		//SetPhysics(PHYS_Falling);
	}
}

//----------------------------------------------------------------------
// KISMET
// Description: Sets flashlight on weapon as on or off
//---------------------------------------------------------------------

function OnSetFlashlight(SeqAct_SetFlashlight action)
{
    local MP50_Persistent Mp50;

    if (Weapon != None && TPWeapon(Weapon).WeapID == 'MP50')
    {
		Mp50 = MP50_Persistent(Weapon);
		Mp50.ToggleFlashlight(action.bEnable);
    }
}


//Overriding this to prevent death on encroachment
event EncroachedBy( actor Other )
{
}


event bool IsInHitReaction()
{
	if( Controller == None )
		return false;

	return Controller.IsInState('TakeHit');
}

event SetUseAimOffset(bool value)
{
	if (!IsA('PlayerPawn'))
	{
		bUseAimOffset = value;
		//if we're in gogglevision...
		if (Weapon != None && Weapon.IsA('G47Sniper') && TPGameInfo(WorldInfo.Game).bLastGoggleSetting == true)
		{
			TPWeapon(Weapon).ToggleUVLight(value);
		}
	}
}

function OnSpinach(SeqAct_Spinach Action)
{
	SetDrawScale(Action.Scale);
	if (Weapon != None)
		Weapon.SetDrawScale(Action.Scale);
	if (CylinderComponent != None)
		SetCollisionSize(CylinderComponent.CollisionRadius * Action.Scale, CylinderComponent.CollisionHeight * Action.Scale);
}

function CoverTransitionDone()
{
	local TPAIController aicon;

//	//`log(" ChadAI - TPPawn::CoverTransitionDone() -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	aicon = TPAIController(Controller);
	if( aicon != None )
	{
//		//`log(" ChadAI - TPPawn::CoverTransitionDone() aicon != None -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		aicon.m_CoverMoveData.m_CoverTransitionAction = CoverTransitionAction_NotTransitioning;
		//`log(" ChadAI - Pawn: " @ Self @ " Time: " @ WorldInfo.TimeSeconds @ " CoverTransitionDone aicon.m_CoverMoveData.m_CoverTransitionAction = " @ aicon.m_CoverMoveData.m_CoverTransitionAction @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	}
}

//
// Assign the type of Face FX and voice this guy is going to have.
// If it is FFXCharType_AutoAssign, we let the computer figure out which one to use.
// This is in script so I can check to see if things are WehrmachtPawn, which are not native.
//
event eFFXCharType DetermineFFXCharType( TPPawn thePawn, eFFXCharType currCharType )
{
	local	int	numGermanA;
	local	int	numGermanB;
	local	int	numGermanC;
	local	int	numGermanD;

	local	int	numNationalGuardA;
	local	int	numNationalGuardB;
	local	int	numNationalGuardC;
	local	int	numNationalGuardD;
	local	int	numNationalGuardE;

	local	WehrmachtPawn	wp;
	local	PartisanPawn	pp;

	if ( currCharType != FFXCharType_AutoAssign )
		return ( currCharType );
	//
	// Now we have to look and see if the pawn is a friend or a foe.
	// Then, pick the type that there are the least of.
	//
	if ( WehrmachtPawn( thePawn ) != None )
	{
		numGermanA = 0;
		numGermanB = 0;
		numGermanC = 0;
		numGermanD = 0;

		foreach WorldInfo.AllPawns( class'WehrmachtPawn', wp )
		{
			if ( wp != thePawn )
			{
				if ( wp.FFXCharType == FFXCharType_GermanA )
					numGermanA++;
				else if ( wp.FFXCharType == FFXCharType_GermanB )
					numGermanB++;
				else if ( wp.FFXCharType == FFXCharType_GermanC )
					numGermanC++;
				else if ( wp.FFXCharType == FFXCharType_GermanD )
					numGermanD++;
			}
		}

		//
		// Now just return the type with the least number.
		//
		if ( (numGermanA <= numGermanB) && (numGermanA <= numGermanC) && (numGermanA <= numGermanD) )
			return ( FFXCharType_GermanA );

		if ( (numGermanB <= numGermanA) && (numGermanB <= numGermanC) && (numGermanB <= numGermanD) )
			return ( FFXCharType_GermanB );

		if ( (numGermanC <= numGermanA) && (numGermanC <= numGermanB) && (numGermanC <= numGermanD) )
			return ( FFXCharType_GermanC );

		return ( FFXCharType_GermanD );
	}

	else
	{
		numNationalGuardA = 0;
		numNationalGuardB = 0;
		numNationalGuardC = 0;
		numNationalGuardD = 0;
		numNationalGuardE = 0;

		foreach WorldInfo.AllPawns( class'PartisanPawn', pp )
		{
			if ( pp != thePawn )
			{
				if ( pp.FFXCharType == FFXCharType_NationalGuardA )
					numNationalGuardA++;
				else if ( pp.FFXCharType == FFXCharType_NationalGuardB )
					numNationalGuardB++;
				else if ( pp.FFXCharType == FFXCharType_NationalGuardC )
					numNationalGuardC++;
				else if ( pp.FFXCharType == FFXCharType_NationalGuardD )
					numNationalGuardD++;
				else if ( pp.FFXCharType == FFXCharType_NationalGuardE )
					numNationalGuardE++;
			}
		}

		//
		// Now just return the type with the least number.
		//
		if ( (numNationalGuardA <= numNationalGuardB) &&
			 (numNationalGuardA <= numNationalGuardC) &&
			 (numNationalGuardA <= numNationalGuardD) &&
			 (numNationalGuardA <= numNationalGuardE) )
		{
			return ( FFXCharType_NationalGuardA );
		}

		if ( (numNationalGuardB <= numNationalGuardA) &&
			 (numNationalGuardB <= numNationalGuardC) &&
			 (numNationalGuardB <= numNationalGuardD) &&
			 (numNationalGuardB <= numNationalGuardE) )
		{
			return ( FFXCharType_NationalGuardB );
		}

		if ( (numNationalGuardC <= numNationalGuardA) &&
			 (numNationalGuardC <= numNationalGuardB) &&
			 (numNationalGuardC <= numNationalGuardD) &&
			 (numNationalGuardC <= numNationalGuardE) )
		{
			return ( FFXCharType_NationalGuardC );
		}

		if ( (numNationalGuardD <= numNationalGuardA) &&
			 (numNationalGuardD <= numNationalGuardB) &&
			 (numNationalGuardD <= numNationalGuardC) &&
			 (numNationalGuardD <= numNationalGuardE) )
		{
			return ( FFXCharType_NationalGuardD );
		}

		return ( FFXCharType_NationalGuardE );
	}
}

event TPPawn GetEnemyToPlayFFXOn()
{
	if ( Controller == None )
		return ( None );

	return ( TPPawn(Controller.Enemy) );
}

event TPPawn GetAllyToPlayFFXOn()
{
}


/**
 * Overloaded from Pawn so NPC can be crouched when entering low turrets
 */
simulated event StartDriving(Vehicle V)
{
	//`log(" ChadAI - Pawn: " @ Self @ " TPPawn - StartDriving Called - bIsCrouched: " @ bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	StopFiring();
	if ( Health <= 0 )
		return;

	DrivenVehicle = V;
	//SPARK OCT CODEDROP
	//NetUpdateTime = WorldInfo.TimeSeconds - 1;

	// Move the driver into position, and attach to car.
	if( Turret(v) != None )
	{
		if( Turret(v).TurretType == TU_Crouch )
		{
			//`log(" ChadAI - Pawn: " @ Self @ " TPPawn - StartDriving Called- aTurret(v).TurretType == TU_Crouch - bIsCrouched: " @ bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}
		else
		{
			ShouldCrouch(false);
			//`log(" ChadAI - Pawn: " @ Self @ " TPPawn - StartDriving Called- aTurret(v).TurretType != TU_Crouch - bIsCrouched: " @ bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}
	}
	else
	{
		ShouldCrouch(false);
	}

	bIgnoreForces = true;
	bCanTeleport = false;
	V.AttachDriver( Self );

	//`log(" ChadAI - Pawn: " @ Self @ " TPPawn - StartDriving - after AttachDriver - bIsCrouched: " @ bIsCrouched @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

}


