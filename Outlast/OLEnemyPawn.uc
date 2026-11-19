class OLEnemyPawn extends OLPawn
	native(AI)
	config(Enemy)
	placeable
	implements(interface_NavMeshPathObstacle)
	implements(interface_NavMeshPathObject)
	dependsOn(OLAIContextualVOAsset); 

var(NPC) class<AIController> NPCController;

var OLBot Bot;

var StaticMeshComponent WeaponMesh;
var array<AnimSet> WeaponAnimSets;

var bool bUsingWeapon;
var bool bHasWeaponEquipped;

var enum EWeaponType
{
	WeaponType_None,
	WeaponType_Blunt,
	WeaponType_Stab,
} WeaponType;

var enum EWeapon
{
	Weapon_None,
	Weapon_Knife,
	Weapon_ButcherKnife,
	Weapon_BoneShear,
	Weapon_Machete,
	Weapon_NightStick,
	Weapon_Pipe,
	Weapon_WoodPlank,
	Weapon_CannibalDrill,
} CurrentWeapon;

var struct native WeaponTypeData
{
	var StaticMesh Mesh;
	var EWeaponType Type;
} Weapons[EWeapon];

struct native EnemyModifiers
{
	var() bool bShouldAttack;
	var() bool bUseKillingBlow;
	var() bool bAlwaysLookAtPlayer;
	var() bool bDisableRepulsion;
	var() bool bSpawnWithNavMeshObstacle;
	var() bool bUseForMusic;
	var() bool bForceUseForStressBreath;
	var() bool bDisableKnockbackFromPlayer;
	var() bool bUseGroup;
	var deprecated StaticMesh WeaponMeshToUse;
	var() EWeapon WeaponToUse;
	var() bool bInterruptVOOnChase;
	var() bool bAttackOnProximity;

	structdefaultproperties
	{
		bUseGroup=true
		bInterruptVOOnChase=true
	}
};

var EnemyModifiers Modifiers;

var OLBTBehaviorTree BehaviorTree;

// Nav Mesh Obstacle
var transient bool bNavMeshRegistered;
var transient vector LastNavMeshCheckLocation;
var transient float LastNavMeshObstacleRegisterTime;
var() float NavMeshObstacleRegistrationTime;

// Pathing
var vector CurrentMovePathStart;
var array<vector> CurrentMovePath;
var int CurrentMovePathIdx;
var vector LastMovePathPoint;

var Actor FocusTarget;

var array<vector2D> CRPathSegments;
var array<vector2D> CRPathSubSegments;

var int CRPathLastIndex;

var const float MaxPathSegmentRatio;
var const int CRPathNumSubSegments;
var const float PathMaxElasticityDistance;
var const float PathMinElasticityDistance;

var array<vector> MovingTestPoints;
var float MovingTestTimer;

var const int NumMovingTestPoints;
var const float MovingTestLength;

// Locomotion
var vector TargetVelocity; // desired velocity computed from locomotion system, includes direction and speed
var float TargetYaw; // degrees
var array<OLAISteering> SteeringBehaviors;
var transient vector CurrentRepulsion; // For Debugging

var bool bHasPreferredPath;
var vector PreferredPathAnchor;
var vector PreferredPathDirection;
var OLPreferredPathMarker PreferredPath; // not strictly necessary - kept only for debug info

enum ERotationMode
{
	RM_FaceVelocity,	// face moving direction (default)
	RM_FaceTarget,		// strafing	
	RM_Explicit			// use DesiredRotation
};

var ERotationMode RotationMode;
var float SmoothedVelocityYaw; // used by RM_FaceVelocity

// Animation
var bool bIsAnimatingFullBody;
var name LastPlayedAnim;

var bool bAnimRootMotionActive;

var array<AnimSet> SpawnerAnimSets;

var AnimNodeSlot TopHalfSlot;
var OLAnimCustomBlend TopHalfBlend;
var OLAnimBlendByEnemyMode AnimNodeSelectEnemyMode;
var SkelControlLookAt HeadTrackingLookAt;

// Nanoswarm effect
struct native NanoSwarmEmitter
{
	var ParticleSystemComponent Emitter;
	var name BoneName;
};
var Array<NanoSwarmEmitter> NanoSwarmEmitters;

var bool bCastShadowInNV;

var enum EEnemyMode
{
	EM_Patrol,
	EM_Investigate,
	EM_Chase,
	EM_SqueezeGrabLeft,
	EM_SqueezeGrabRight,
} EnemyMode;

var const float FallingDeathZ;
var float MeshZOffset; // Moves up and down to adjust the legs for large steps
var vector MeshOffset2D; // Moves back from other pawns (world-space)

var transient rotator TurnStart;
var transient float OldTurnAmount;
var transient float TurnAmount;

var transient float ThrowRotation;

var float SpecialMoveBlendAlpha;
var bool bLeftAnim;
var float SpecialMoveRate;
var float SpecialMoveStalledTimestamp; 

var bool bBackAnim;

var enum EAttackSide
{
	EAS_Left,
	EAS_Right,
	EAS_Middle,
} AttackSide;

var AkEvent FootStepSound_Run;
var AkEvent SoundEventAmbientStart;
var AkEvent SoundEventAmbientStop;

var AkEvent SoundEventIdleStart;
var AkEvent SoundEventIdleStop;
var bool bIdleSoundPlaying;

var OLAIContextualVOAsset VOAsset;

struct native VOInstance
{
	var array<bool> EventsPlayed;
	var int NumUnplayedEvents;
};

var transient array<VOInstance> VOInstances;

struct native DelayedVO
{
	var float TimeRemaining;
	var EVOContext VOContext;
};

var transient array<DelayedVO> DelayedVOContexts;

////
// Config Variables
////
struct native SpeedValues
{
	var config float PatrolSpeed;
	var config float InvestigateSpeed;
	var config float ChaseSpeed;
};

var SpeedValues NormalSpeedValues;
var SpeedValues DarknessSpeedValues;
var SpeedValues ElectricitySpeedValues;

enum EMoveSpeedMode
{
	EMSM_Default,
	EMSM_Override,
	EMSM_RubberBanding,
};
var EMoveSpeedMode MoveSpeedMode;
var float MoveSpeed_Target;  // for debug info only
var SpeedValues MoveSpeed_Override;
var float MoveSpeed_AccelRate; // cm/s^2
var float MoveSpeed_DecelRate; // positive
var float MoveSpeed_SpeedNoVisibility;
var float MoveSpeed_ChaseSpeedAtMinDist;
var float MoveSpeed_ChaseSpeedAtMaxDist;
var float MoveSpeed_ChaseDistMin;
var float MoveSpeed_ChaseDistMax;

var config SpeedValues NrmNormalSpeedValues;
var config SpeedValues NrmDarknessSpeedValues;
var config SpeedValues NrmElectricitySpeedValues;

var config SpeedValues HardNormalSpeedValues;
var config SpeedValues HardDarknessSpeedValues;
var config SpeedValues HardElectricitySpeedValues;

var config float NrmEnemyHearingThreshold;
var config float HardEnemyHearingThreshold;

struct native VisionCone
{
	var config float Distance;
	var config float PeekingDistance;
	var config float HorizontalAngle;
	var config float VerticalAngle;
};

struct native VisionParameters
{
	var config float WideConeReactionTime;
	var config float LoseTargetTime;
	var config VisionCone NarrowCone;
	var config VisionCone WideCone;
	var config float CloseDistance;
	var config float CrouchMultiplier;
};

//Base
var VisionParameters LightUnAwareVisionParameters;
var VisionParameters NightvisionUnAwareVisionParameters;
var VisionParameters DarkUnAwareVisionParameters;

var VisionParameters LightAwareVisionParameters;
var VisionParameters NightvisionAwareVisionParameters;
var VisionParameters DarkAwareVisionParameters;

//Normal
var config VisionParameters NrmLightUnAwareVisionParameters;
var config VisionParameters NrmNightvisionUnAwareVisionParameters;
var config VisionParameters NrmDarkUnAwareVisionParameters;

var config VisionParameters NrmLightAwareVisionParameters;
var config VisionParameters NrmNightvisionAwareVisionParameters;
var config VisionParameters NrmDarkAwareVisionParameters;

//Hard
var config VisionParameters HardLightUnAwareVisionParameters;
var config VisionParameters HardNightvisionUnAwareVisionParameters;
var config VisionParameters HardDarkUnAwareVisionParameters;

var config VisionParameters HardLightAwareVisionParameters;
var config VisionParameters HardNightvisionAwareVisionParameters;
var config VisionParameters HardDarkAwareVisionParameters;

var config int NumOfDoorBashLoops;
var config float DoorClosedPathMultiplier;

var config float MoveReactionTime;

var config float WaitLeaveNormalMultiplier;
var config float WaitLeaveChaseMultiplier;

var config float UnstuckCheckTime;

var config float LookAheadDistance;
var config float LookAheadUpdateTime;

var config float AttackRange;
var config float AttackGrabChance;

var float AttackNormalDamage;
var float AttackThrowDamage;

var config float NrmAttackNormalDamage;
var config float NrmAttackThrowDamage;
var config float HardAttackNormalDamage;
var config float HardAttackThrowDamage;

var config float AttackNormalRecovery;
var config float AttackThrowRecovery;

var config float AttackNormalKnockbackPower;
var config float AttackPushKnockbackPower;

var float DoorBashDamage;
var config float NrmDoorBashDamage;
var config float HardDoorBashDamage;
var config float DoorBashKnockbackPower;

var float VaultDamage;
var config float NrmVaultDamage;
var config float HardVaultDamage;
var config float VaultKnockbackPower;

var config float AttackSqueezeRange;
var config float AttackSqueezeCycleTime;

var config float AttackIdleTimeAfterGrab;

var config bool bAttackUseQuickAttack;
var config float AttackQuickSpeedThreshold;
var config float AttackQuickAngleThreshold;
var config float AttackQuickDistanceThreshold;

var config int InvestigationNumPointsGenerated;
var config float InvestigationMinRadius;
var config float InvestigationMaxRadius;
var config float InvestigationMaxPathDistance;
var config float InvestigationFirstPointAngle;

var config bool bInvestigateLockers;
var config bool bInvestigateBeds;
var config float InvestigationNormalWeight;
var config float InvestigationLockerWeight;
var config float InvestigationLockerOccupiedWeight;
var config float InvestigationBedWeight;
var config float InvestigationBedOccupiedWeight;
var config float InvestigateBedAlternateChance;
var config float InvestigationFindHiddenPlayerProbability;

var config bool bDrawSteeringDebug;

var config bool bUsePreferredPaths;

////
// Constants
////
var const bool bUseForMusic;
var const bool bMusicInPatrol;

var const bool bUseAIGroup;

var const bool bCanVault;
var const bool bCanThrow;
var const bool bUsesDirectionalAttacks;
var const bool bCanBeKnockedback;

var const bool bUseFirstInvestigationInFront;
var const bool bCloseDoorInPatrol;

var const name VisionBone;
var const name WeaponAttachBone;
var const name HipBone;

var const float AttackSqueezeVisibleRangeToNode;
var const float AttackSqueezeHiddenRangeToTarget;

var const float DoorOpenDistancePush;
var const float DoorOpenDistancePull;

var const bool bUsesDoorBashLoop;

var const float DoorBreakDistance;
var const float DoorChasingBreakDistance;

var const float DoorBreakFinishDistance;

var const float NormalDropDownDistance;
var const float NormalClimbUpDistance;
var const float ChasingDropDownDistance;
var const float ChasingClimbUpDistance;

var const float WallBashDistance;
var const float WallBashTime;

var const float TableBashDistance;

var const vector DoorOpenEndOffsetPushLeft;
var const vector DoorOpenEndOffsetPushRight;
var const vector DoorOpenEndOffsetPullLeft;
var const vector DoorOpenEndOffsetPullRight;
var const vector DoorOpenEndOffsetPushLeftWithClose;
var const vector DoorOpenEndOffsetPushRightWithClose;
var const vector DoorOpenEndOffsetPullLeftWithClose;
var const vector DoorOpenEndOffsetPullRightWithClose;

var const vector DoorBashEndOffset;

var const vector LockerInvestigateOffset;
var const vector LockerAttackOffset;

var const vector BedInvestigateOffsetLeft;
var const vector BedInvestigateOffsetRight;

var const vector BedAttackOffsetLeft;
var const vector BedAttackOffsetRight;

var const float GrabTargetVelocity;

var const vector SqueezeAttackOffset;
var const float SwarmXplodBackOffset;

var const float GrabDistance;
var const float KillDistance;

var const float ThrowStartPlayerDistance;
var const float ThrowStartPlayerZOffset;

var const class<DamageType> InstantKillDmgType;
var const class<DamageType> AttackNormalDmgType;
var const class<DamageType> AttackThrowDmgType;

var const bool bUseAvoidSystem;
var const float AvoidRatePatrol;
var const float AvoidRateInvestigate;
var const float AvoidRateChase;

// Sound
var const string SoundSwitchDoorMaterial;
var const string SoundSwitchParamDMWood;
var const string SoundSwitchParamDMMetal;
var const string SoundSwitchParamDMSecurity;
var const string SoundSwitchParamDMBigPrison;

var const name SoundSwitchWeaponType;
var const name SoundSwitchWeaponTypeParams[EWeapon];

`define ENEMY_ANIMS_DECL
`include(OLEnemyPawnAnims.uci)
`undefine(ENEMY_ANIMS_DECL)

cpptext
{
	virtual void TickPrePhysics(FLOAT deltaTime);
	virtual void TickPostPhysics(FLOAT deltaTime);
	virtual void performPhysics(FLOAT deltaSeconds);
	virtual void setPhysics(BYTE NewPhysics, AActor* NewFloor = NULL, FVector NewFloorV = FVector(0,0,1));

	UBOOL moveToward(const FVector &Dest, AActor *GoalActor );
	UBOOL moveAlongPath(const TArray<FVector>& PathPoints);
	
	// For AI Avoidance
	virtual void CalcVelocity(FVector &AccelDir, FLOAT DeltaTime, FLOAT MaxSpeed, FLOAT Friction, INT bFluid, INT bBrake, INT bBuoyant);
	virtual FVector GetAIRepulsion(const class AOLEnemyPawn* Agent);

	// pathobstacle interface
	virtual UBOOL GetBoundingShape(TArray<FVector>& out_PolyShape,INT ShapeIdx)
	{
		#define BUFFER 20.0f
		if( CylinderComponent == NULL )
		{
			debugf(TEXT("%s cylinder component is NULL? Bailing from GetBoundingShape()"),*GetName());
			return FALSE;
		}
		out_PolyShape.AddItem(Location + FVector(CylinderComponent->CollisionRadius+BUFFER,CylinderComponent->CollisionRadius+BUFFER,0.f));
		out_PolyShape.AddItem(Location + FVector(-(CylinderComponent->CollisionRadius+BUFFER),CylinderComponent->CollisionRadius+BUFFER,0.f));
		out_PolyShape.AddItem(Location + FVector(-(CylinderComponent->CollisionRadius+BUFFER),-(CylinderComponent->CollisionRadius+BUFFER),0.f));
		out_PolyShape.AddItem(Location + FVector(CylinderComponent->CollisionRadius+BUFFER,-(CylinderComponent->CollisionRadius+BUFFER),0.f));
		return TRUE;
	}

	virtual UBOOL PreserveInternalPolys() { return TRUE; }

	virtual EEdgeHandlingStatus AddObstacleEdge( EEdgeHandlingStatus Status, const FVector& inV1, const FVector& inV2, TArray<FNavMeshPolyBase*>& ConnectedPolys, UBOOL bEdgesNeedToBeDynamic, INT PolyAssocatedWithThisPO, FLOAT SupportedEdgeWidth=-1.0f, BYTE EdgeGroupID=MAXBYTE)
	{
		return AddObstacleEdgeForObstacle(Status,inV1,inV2,ConnectedPolys,bEdgesNeedToBeDynamic,PolyAssocatedWithThisPO,this,SupportedEdgeWidth,EdgeGroupID);
	}

	virtual void BeginDestroy()
	{
		Super::BeginDestroy();
		UnregisterNavmeshObstacle();
	}

	virtual INT CostFor( const FNavMeshPathParams& PathParams, const FVector& PreviousPoint, FVector& out_PathEdgePoint, FNavMeshPathObjectEdge* Edge, FNavMeshPolyBase* SourcePoly );

	virtual UBOOL Verify()
	{
		return !IsPendingKill() && GetName().Len();
	}

	void UpdateLookAt(const FVector& lookAtTarget);

	virtual void EnableNightVisionEffect();
	virtual void DisableNightVisionEffect();

	virtual FLOAT PlayTopHalfBlendedAnim(const FName& animNameA, const FName& animNameB, FLOAT alpha, FLOAT blendInTime=0.0f, FLOAT blendOutTime=0, FLOAT rate=1.0f, FLOAT startRatio=0.0f);

	virtual void OnPlayWeaponAnimNotify(UAnimNodeSequence* animNodeSeq) {}

	void MoveOutOfTheWay();
	
	UBOOL CanBeKnockedback(UBOOL bForced = FALSE);

	void InitContextualVO(); // Called in ActorFactoryOLAI after VOAsset is set.

	virtual UBOOL CanStartAndStop();

	FVector GetTrueDoorDestination(AOLDoor* Door, FNavMeshPathObjectEdge* Edge);

	UBOOL IsMoving(FLOAT Threshold = 10.0f);

protected:
	virtual UBOOL ShouldAllowOtherPawnSpecialMove(AOLPawn* otherPawn, ESpecialMoveType moveType, AActor* refActor);
	virtual void OnOtherPawnStartSpecialMove(AOLPawn* otherPawn, ESpecialMoveType moveType, AActor* refActor);
	virtual void SpecialMovePhaseCompleted();
	virtual void SpecialMoveCompleted();
	virtual void PlayAnimForSpecialMove(ESpecialMoveType moveType);
	virtual UBOOL IsSpecialMoveCompleted();

	void UpdateMovePath(FLOAT deltaTime);
	void UpdateGroundSpeed(FLOAT deltaTime);
	FLOAT CalculateSpeed(FLOAT deltaTime, FLOAT currentSpeed, FVector moveDirection);
	void UpdateLocomotion(FLOAT deltaTime);
	void ApplyTurning(FLOAT deltaTime);
	void ApplyPreferredPaths(FLOAT deltaTime);
	void UpdateFootPlacement(FLOAT DeltaSeconds);
	void UpdateMeshOffset(FLOAT deltaTime);
	void UpdateRotation(FLOAT deltaTime);
	void UpdateTargetVelocity(FLOAT deltaTime);

	UBOOL TryPullIntermediateDestOnPreferredPath(FVector& newPoint, const FVector& prevPoint, const FVector& nextPoint);
	void CalculateCRSubSegments(INT Idx, INT NumSubSegments, TArray<FVector2D>& SubSegments);

	FLOAT CalculateLedgeRatio();
	FLOAT EstimateLengthOfPathLeft() const;

	UBOOL CanStrafe();

	void UpdateDelayedVO(FLOAT DeltaSeconds);
};

native final function RegisterNavMeshObstacle();
native final function UnregisterNavmeshObstacle();

native function StartSpecialMove(ESpecialMoveType moveType, optional vector targetPosition, optional vector targetDirection, optional EAdjustPositionTargetType targetType);

native function CancelSpecialMove();

final function UpdateNavMeshObstacle()
{
	// if we have an obstacle for ourselves and we start to move, unregister it
	if( VSize2D(Location - LastNavMeshCheckLocation) > 10.f )
	{
		UnregisterNavmeshObstacle();
	}
	else
	{
		// Recheck later
		SetTimer(0.25, FALSE, nameof(UpdateNavMeshObstacle));
	}
}

final function bool HasRegisteredNavMeshRecently()
{
	return bNavMeshRegistered || `TimeSince(LastNavMeshObstacleRegisterTime) < 1.0;
}

function AIStartingMove()
{
	UnregisterNavmeshObstacle();
}

simulated event PostBeginPlay()
{
  if(NPCController != none)
  {
    //set the existing ControllerClass to our new NPCController class
    ControllerClass = NPCController;
  }
   
  Super.PostBeginPlay();

  // Add Steering Behaviors
  SteeringBehaviors.AddItem(new(self) class'OLAISteeringFollowPath');
  SteeringBehaviors.AddItem(new(self) class'OLAISteeringAvoidance');

  if (SoundEventAmbientStart != None)
  {
	  PlayAkEvent(SoundEventAmbientStart);
  }

  UpdateDifficultyBasedValues();
}

simulated function ZeroMovementVariables()
{
	Super.ZeroMovementVariables();

	CurrentMovePath.length = 0;
	CurrentMovePathIdx = 0;
	CurrentMovePathStart = vect(0.f,0.f,0.f);

	TargetVelocity = vect(0.f,0.f,0.f);
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	Super.PossessedBy(C, bVehicleTransition);
	Bot = OLBot(C);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	if (SkelComp == Mesh)
	{
		TopHalfSlot = AnimNodeSlot(Mesh.FindAnimNode('TopHalfSlot'));
		TopHalfBlend = OLAnimCustomBlend(Mesh.FindAnimNode('TopHalfBlend'));
		HeadTrackingLookAt = SkelControlLookAt(Mesh.FindSkelControl('HeadTracking'));
		AnimNodeSelectEnemyMode = OLAnimBlendByEnemyMode(Mesh.FindAnimNode('SelectEnemyMode'));
	}

	Super.PostInitAnimTree(SkelComp);
}

event ApplyModifiers(EnemyModifiers NewModifiers)
{
	Modifiers = NewModifiers;

	if (Modifiers.bSpawnWithNavMeshObstacle)
	{
		RegisterNavMeshObstacle();
	}

	CurrentWeapon = Modifiers.WeaponToUse;

	if (CurrentWeapon != Weapon_None)
	{
		WeaponMesh.DetachFromAny();
		WeaponMesh.SetStaticMesh(Weapons[CurrentWeapon].Mesh);
		Mesh.AttachComponent(WeaponMesh, WeaponAttachBone);

		WeaponType = Weapons[CurrentWeapon].Type;
		bUsingWeapon = TRUE;
		bHasWeaponEquipped = TRUE;

		UpdateAnimSetList();
	}
	
	SetSwitch(SoundSwitchWeaponType, SoundSwitchWeaponTypeParams[CurrentWeapon]);

	if (bUseAIGroup && Modifiers.bUseGroup)
	{
		Bot.AddToAIGroup();
	}
}

function UpdateDifficultyBasedValues()
{
	local OLGame TheGame;
	
	TheGame = OLGame(WorldInfo.Game);
	if (TheGame == None || TheGame.DifficultyMode == EDM_Normal)
	{
		AttackNormalDamage = NrmAttackNormalDamage;
		AttackThrowDamage = NrmAttackThrowDamage;
		DoorBashDamage = NrmDoorBashDamage;
		VaultDamage = NrmVaultDamage;

		NormalSpeedValues = NrmNormalSpeedValues;
		DarknessSpeedValues = NrmDarknessSpeedValues;
		ElectricitySpeedValues = NrmElectricitySpeedValues;

		LightUnAwareVisionParameters = NrmLightUnAwareVisionParameters;
		NightvisionUnAwareVisionParameters = NrmNightvisionUnAwareVisionParameters;
		DarkUnAwareVisionParameters = NrmDarkUnAwareVisionParameters;

		LightAwareVisionParameters = NrmLightAwareVisionParameters;
		NightvisionAwareVisionParameters = NrmNightvisionAwareVisionParameters;
		DarkAwareVisionParameters = NrmDarkAwareVisionParameters;

		HearingThreshold = NrmEnemyHearingThreshold;
	}
	else
	{
		AttackNormalDamage = HardAttackNormalDamage;
		AttackThrowDamage = HardAttackThrowDamage;
		DoorBashDamage = HardDoorBashDamage;
		VaultDamage = HardVaultDamage;

		NormalSpeedValues = HardNormalSpeedValues;
		DarknessSpeedValues = HardDarknessSpeedValues;
		ElectricitySpeedValues = HardElectricitySpeedValues;

		LightUnAwareVisionParameters = HardLightUnAwareVisionParameters;
		NightvisionUnAwareVisionParameters = HardNightvisionUnAwareVisionParameters;
		DarkUnAwareVisionParameters = HardDarkUnAwareVisionParameters;

		LightAwareVisionParameters = HardLightAwareVisionParameters;
		NightvisionAwareVisionParameters = HardNightvisionAwareVisionParameters;
		DarkAwareVisionParameters = HardDarkAwareVisionParameters;

		HearingThreshold = HardEnemyHearingThreshold;
	}
}

simulated event BuildScriptAnimSetList()
{
	if (bHasWeaponEquipped && WeaponAnimSets.length > 0)
	{
		AddAnimSets(WeaponAnimSets);
	}

	AddAnimSets(SpawnerAnimSets);
}

simulated event Destroyed()
{
	Super.Destroyed();

	if (SoundEventAmbientStop != None)
	{
		PlayAkEvent(SoundEventAmbientStop);
	}

	StopIdleSound();
}

event DamageTarget()
{
	Bot.DamageTarget();
}

event DamageTargetRangeStartNotify()
{
	Bot.DamageTargetRangeStartNotify();
}

event DamageTargetRangeTickNotify()
{
	Bot.DamageTargetRangeTickNotify();
}

event BashDoorNotify()
{
	Bot.BashDoorNotify();
}

event BreakDoorNotify()
{
	Bot.BreakDoorNotify();
}

event KnockbackStartNotify()
{
	Bot.KnockbackStartNotify();
}

event KnockbackTickNotify()
{
	Bot.KnockbackTickNotify();
}

event PushNotify()
{
	Bot.PushNotify();
}

event ResetAnimationMode()
{
	EnemyMode = EM_Chase;
	Bot.UpdateAnimationMode();
}

event ShowWeapon()
{
	WeaponMesh.SetHidden(false);
	bHasWeaponEquipped = TRUE;
	UpdateAnimSetList();

	SetSwitch(SoundSwitchWeaponType, SoundSwitchWeaponTypeParams[CurrentWeapon]);
}

event HideWeapon()
{
	WeaponMesh.SetHidden(true);
	bHasWeaponEquipped = FALSE;
	UpdateAnimSetList();

	SetSwitch(SoundSwitchWeaponType, SoundSwitchWeaponTypeParams[Weapon_None]);
}

event ShowWeaponMatinee()
{
	WeaponMesh.SetHidden(false);
}

event HideWeaponMatinee()
{
	WeaponMesh.SetHidden(true);
}

event StartIdleSound()
{
	if (!bIdleSoundPlaying && SoundEventIdleStart != None)
	{
		PlayAkEvent(SoundEventIdleStart);
		bIdleSoundPlaying = true;
	}
}

event StopIdleSound()
{
	if (bIdleSoundPlaying && SoundEventIdleStop != None)
	{
		PlayAkEvent(SoundEventIdleStop);
		bIdleSoundPlaying = false;
	}
}

native function EnableRootMotion();

native function DisableRootMotion();

function PlayFullBodyAnim
(
	name	AnimName,
	float	Rate,
	optional	float	BlendInTime,
	optional	float	BlendOutTime,
	optional	bool	bLooping,
	optional	float	StartTime,
	optional	float	EndTime
)
{
	if (FullBodyAnimSlot != None)
	{
		if (FullBodyAnimSlot.PlayCustomAnim(AnimName, Rate, BlendInTime, BlendOutTime, bLooping, TRUE, StartTime, EndTime) > 0.f)
		{
			bIsAnimatingFullBody = true;
			FullBodyAnimSlot.SetActorAnimEndNotification(true);

			LastPlayedAnim = AnimName;
		}
	}
}

native function TurnOnSpot(rotator EndRotation);

native function StartAvoid(OLEnemyPawn OtherPawn);

native function StartKnockback(OLHero Hero, vector HitNormal);

native function StartDoorKnockback(vector Direction, bool bLocker);

native function StartNormalAttack();

native function StartDisturbed();

simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	Super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);

	if (SeqNode.AnimSeqName == LastPlayedAnim)
	{
		bIsAnimatingFullBody = false;	
	}
}

native function StartMatinee(vector startLoc, rotator startRot, float blendTime);

simulated function BeginAIGroup()
{
	CancelSpecialMove();

	SetPhysics(PHYS_Interpolating);
	Bot.BeginMatinee();
}

simulated function FinishAIGroup()
{
	Bot.FinishMatinee();
	SetPhysics(WalkingPhysics);
}

simulated event PlayFootStepSound(int FootDown, AnimNotify_Footstep footstepNotify)
{
	local float Speed;
	Speed = VSizeSq2D(Velocity);

	if (Speed > 25.0f || footstepNotify.bForceRunEvent || footstepNotify.bForceWalkEvent)
	{
		SetSwitch(FloorMaterialGroup, GetMaterialBelowFeet());

		if ((Speed > 200.f * 200.f || footstepNotify.bForceRunEvent) && !footstepNotify.bForceWalkEvent)
		{
			PlayAkEvent(FootStepSound_Run);
		}
		else
		{
			PlayAkEvent(FootStepSound_Walk);
		}
	}
}

native function PlayContextualVO(EVOContext VOContext, optional float DelayTime);

defaultproperties 
{
	`include(OLEnemyPawnData.uci)
	`include(OLEnemyPawnAnims.uci)

	Begin Object Class=SkeletalMeshComponent Name=WPawnSkeletalMeshComponent
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=true
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		Translation=(Z=1.0)
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		LightEnvironment=MyLightEnvironment
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		AnimSets(0)=AnimSet'03_NPCMedium_Generic.NpcMediumGeneric-01_AS'
		AnimTreeTemplate=AnimTree'02_Behaviors.Enemy.Enemy_AnimTree'
		bHasPhysicsAssetInstance=true
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2
		bChartDistanceFactor=true
		//bSkipAllUpdateWhenPhysicsAsleep=TRUE
		RBDominanceGroup=20
		Scale=1
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=false
		MotionBlurInstanceScale=0.0
		SkeletalMesh=SkeletalMesh'02_Generic_Patient.Pawn.Generic_Patient'
		PhysicsAsset=PhysicsAsset'02_Generic_Patient.Meshes.Patient_2_Physics'
		Rotation=(Pitch=0,Yaw=0,Roll=0)
	End Object
	Mesh=WPawnSkeletalMeshComponent
	Components.Add(WPawnSkeletalMeshComponent)	
	//BaseTranslationOffset=6.0

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0030.000000
		CollisionHeight=90.0
		Translation=(Z=95.0)
	End Object
	CylinderComponent=CollisionCylinder

	Begin Object Class=StaticMeshComponent Name=WeaponMeshComponent
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		CastShadow=false
		bCastDynamicShadow=true
		BlockRigidBody=false
		BlockActors=false
		CollideActors=false
		Translation=(Z=0.0)
		LightEnvironment=MyLightEnvironment
		bAcceptsDynamicDecals=FALSE
		LightingChannels=(bInitialized=True,BSP=True,Static=True,Dynamic=True,CompositeDynamic=True,Skybox=True,Unnamed_1=True,Unnamed_2=True,Unnamed_3=True,Unnamed_4=True,Unnamed_5=True,Unnamed_6=True,Cinematic_1=True,Cinematic_2=True,Cinematic_3=True,Cinematic_4=True,Cinematic_5=True,Dynamic_1=True,Dynamic_2=True,Dynamic_3=True,Dynamic_4=True,Dynamic_5=True,Gameplay_1=True,Gameplay_2=True,Gameplay_3=True,Gameplay_4=True)
		TickGroup=TG_PreAsyncWork
		//bSkipAllUpdateWhenPhysicsAsleep=TRUE
		RBDominanceGroup=20
		HiddenGame=False
		bCastHiddenShadow=false
		MotionBlurInstanceScale=0.0
		Scale=1
		bUseOnePassLightingOnTranslucency=TRUE
		StaticMesh=StaticMesh'Weapons.Machete-01'
		Rotation=(Pitch=0,Yaw=0,Roll=0)
	End Object
	WeaponMesh=WeaponMeshComponent

	//Points to your custom AIController class - as the default value
	NPCController=class'OLBot'
	WalkingPhysics=PHYS_Walking

	bRepelsAI=TRUE

	BaseEyeHeight=172.6
	EyeHeight=172.6

	bModifyNavPointDest=true

	BehaviorTree=OLBTBehaviorTree'02_AI_Behaviors.Default_BT'

	FallingDeathZ=-20000.0

	bUseForMusic=false
	bMusicInPatrol=false

	bUseAIGroup=false
	bCanVault=false
	bCanThrow=false

	VisionBone=NPCMedium-Head
	HeadBoneName=NPCMedium-Head
	WeaponAttachBone=NPCMedium-R-Hand_aux
	HipBone=NPCMedium

	FootStepSound_Walk=AkEvent'NPCs_Sounds.Footsteps_Walk_NPC'
	FootStepSound_Run=AkEvent'NPCs_Sounds.Footsteps_Run_NPC'

	AttackSqueezeVisibleRangeToNode=200.0
	AttackSqueezeHiddenRangeToTarget=300.0
	
	DoorOpenDistancePush=50.0
	DoorOpenDistancePull=50.0

	bUsesDoorBashLoop=false

	DoorBreakDistance=50.0
	DoorChasingBreakDistance=50.0
	DoorBreakFinishDistance=100.0

	SpecialMoveRate=1.0f

	NormalDropDownDistance=50.0
	NormalClimbUpDistance=50.0
	ChasingDropDownDistance=50.0
	ChasingClimbUpDistance=50.0

	WallBashDistance=160.0
	WallBashTime=0.5

	TableBashDistance=281.0

	DoorOpenEndOffsetPushLeft=(X=50.0,Y=0.0,Z=0.0)
	DoorOpenEndOffsetPushRight=(X=50.0,Y=0.0,Z=0.0)
	DoorOpenEndOffsetPullLeft=(X=50.0,Y=0.0,Z=0.0)
	DoorOpenEndOffsetPullRight=(X=50.0,Y=0.0,Z=0.0)
	DoorOpenEndOffsetPushLeftWithClose=(X=50.0,Y=0.0,Z=0.0)
	DoorOpenEndOffsetPushRightWithClose=(X=50.0,Y=0.0,Z=0.0)
	DoorOpenEndOffsetPullLeftWithClose=(X=50.0,Y=0.0,Z=0.0)
	DoorOpenEndOffsetPullRightWithClose=(X=50.0,Y=0.0,Z=0.0)

	DoorBashEndOffset=(X=50.0,Y=0.0,Z=0.0)

	LockerInvestigateOffset=(X=87.534,Y=28.846)
	LockerAttackOffset=(X=87.534,Y=28.846)

	BedInvestigateOffsetLeft=(X=-26.215,Y=-176.188)
	BedInvestigateOffsetRight=(X=-26.293,Y=176.512)
	BedAttackOffsetLeft=(X=-26.215,Y=-176.188)
	BedAttackOffsetRight=(X=-26.293,Y=176.512)

	SqueezeAttackOffset=(X=75,Y=29.6,Z=0.0)
	SwarmXplodBackOffset=150.0

	GrabDistance=100.0
	KillDistance=150.0

	ThrowStartPlayerDistance=77.9
	ThrowStartPlayerZOffset=42.6

	GrabTargetVelocity=20.0
	HearingThreshold=2000.0f

	MaxPathSegmentRatio=2.5f
	CRPathNumSubSegments=10
	PathMaxElasticityDistance=100.0f
	PathMinElasticityDistance=5.0f

	NumMovingTestPoints=10
	MovingTestLength=1.0f

	InstantKillDmgType=class'OLDmgType'
	AttackNormalDmgType=class'OLDmgType_GenericHit'
	AttackThrowDmgType=class'OLDmgType_GenericHit'

	bUseAvoidSystem=false
	AvoidRatePatrol=1.0f
	AvoidRateInvestigate=1.0f
	AvoidRateChase=1.0f

	SoundSwitchDoorMaterial="Door_Material"
	SoundSwitchParamDMWood="Wood"
	SoundSwitchParamDMMetal="Metal_Gate"
	SoundSwitchParamDMSecurity="Security"
	SoundSwitchParamDMBigPrison="Metal_Prison_Gate"

	SoundSwitchWeaponType=WeaponType
	SoundSwitchWeaponTypeParams(Weapon_None)=NoneWeapon
	SoundSwitchWeaponTypeParams(Weapon_Knife)=Knife
	SoundSwitchWeaponTypeParams(Weapon_ButcherKnife)=ButcherKnife
	SoundSwitchWeaponTypeParams(Weapon_BoneShear)=BoneShear
	SoundSwitchWeaponTypeParams(Weapon_Machete)=Machete
	SoundSwitchWeaponTypeParams(Weapon_NightStick)=NightStick
	SoundSwitchWeaponTypeParams(Weapon_Pipe)=Pipe
	SoundSwitchWeaponTypeParams(Weapon_WoodPlank)=WoodPlank
	SoundSwitchWeaponTypeParams(Weapon_CannibalDrill)=WoodPlank // TODO
}
