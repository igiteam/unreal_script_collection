class EvilPawn extends UTPawn
    native(Pawn)
    config(Pawn)
    hidecategories(Navigation)
    implements(EvilBurningInterface);

const MAXFLASHLOCATION = 20;

enum ELeanState
{
    ELS_None,                       // 0
    ELS_Left,                       // 1
    ELS_Right,                      // 2
    ELS_MAX                         // 3
};

enum eMaterialType
{
    MT_Default,                     // 0
    MT_Plasma,                      // 1
    MT_Burning,                     // 2
    MT_MAX                          // 3
};

enum ESetSize
{
    SSCollisionCylinder,            // 0
    SSSearchExtent,                 // 1
    ESetSize_MAX                    // 2
};

enum EPawnAction
{
    PA_None,                        // 0
    PA_FullBodyHitReaction,         // 1
    PA_TopBodyHalfHitReaction,      // 2
    PA_DeathAnim,                   // 3
    PA_BurnDeathAnim,               // 4
    PA_Melee,                       // 5
    PA_Kick,                        // 6
    PA_Charge,                      // 7
    PA_ChargeFail,                  // 8
    PA_Throw,                       // 9
    PA_Aim,                         // 10
    PA_Shoot,                       // 11
    PA_Reload,                      // 12
    PA_RecoverFromRagdoll,          // 13
    PA_Emerge,                      // 14
    PA_ZombieScream,                // 15
    PA_Run2Cover,                   // 16
    PA_MirrorTransition,            // 17
    PA_CoverSlip,                   // 18
    PA_JumpOverCover,               // 19
    PA_AnimControl,                 // 20
    PA_PlayerReload,                // 21
    PA_PlayerEquipWeapon,           // 22
    PA_PlayerHideWeapon,            // 23
    PA_PlayerMelee,                 // 24
    PA_Jump,                        // 25
    PA_JumpStart,                   // 26
    PA_JumpFalling,                 // 27
    PA_JumpPreLand,                 // 28
    PA_JumpLand,                    // 29
    PA_ShieldLost,                  // 30
    PA_DeathAnimWithoutMotors,      // 31
    PA_Dodge,                       // 32
    PA_Scream,                      // 33
    PA_PreJump,                     // 34
    PA_MAX                          // 35
};

enum EDebugDisplayType
{
    EDDT_AnimTree,                  // 0
    EDDT_SkelControls,              // 1
    EDDT_LODs,                      // 2
    EDDT_Locomotion,                // 3
    EDDT_MAX                        // 4
};

struct native AnimNameToSpecialHitReactionAnimInfo
{
    var name AnimName;
    var EvilAnimInfo CustomAnimInfo;

    structdefaultproperties
    {
        AnimName="None"
        CustomAnimInfo=(AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
    }
};

struct native BoneNameToSpecialHitReactionAnimInfo
{
    var name BoneName;
    var EvilAnimInfo CustomAnimInfo;

    structdefaultproperties
    {
        BoneName="None"
        CustomAnimInfo=(AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
    }
};

struct native PhysicsImpulseInfo
{
    var Vector LinearVelocity;
    var Vector AngularVelocity;
    var Vector RadialOrigin;
    var float RadialRadius;
    var float RadialStrength;

    structdefaultproperties
    {
        LinearVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        AngularVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RadialOrigin=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RadialRadius=0.0000000
        RadialStrength=0.0000000
    }
};

struct native BoneRagdollInfo
{
    var float px;
    var float Py;
    var float pz;
    var int Pitch;
    var int Yaw;
    var int Roll;

    structdefaultproperties
    {
        px=0.0000000
        Py=0.0000000
        pz=0.0000000
        Pitch=0
        Yaw=0
        Roll=0
    }
};

struct native MeleeHitParticleInfo
{
    var float MinScale;
    var float MaxScale;
    var ParticleSystem Particle;
    var bool bAttachToBone;

    structdefaultproperties
    {
        MinScale=1.0000000
        MaxScale=1.0000000
        Particle=none
        bAttachToBone=false
    }
};

struct native EvilTakeHitInfo
{
    var int Damage;
    var Controller EventInstigator;
    var Vector HitLocation;
    var Vector Momentum;
    var TraceHitInfo HitInfo;
    var Actor DamageCauser;
    var _PawnParameters DamageClassification;
    var _GibsParameters GibClassification;

    structdefaultproperties
    {
        Damage=0
        EventInstigator=none
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName="None",HitComponent=none)
        DamageCauser=none
        DamageClassification=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light)
        GibClassification=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000)
    }
};

struct native PAStruct
{
    var byte PawnAction;
    var EvilPawn InteractionPawn;
    var int Flags;

    structdefaultproperties
    {
        PawnAction=0
        InteractionPawn=none
        Flags=0
    }
};

struct native EvilAnimSetInfo
{
    var() array<EvilAnimInfo> Animations;

    structdefaultproperties
    {
        Animations=none
    }
};

struct native WakeAnimInfo
{
    var array<EvilAnimInfo> AnimNames;

    structdefaultproperties
    {
        AnimNames=none
    }
};

struct native _WakeInformation
{
    var EvilTypes.ERecoverTypeFromAnimation RecoverID;
    var EvilTypes.ELayFirstFrameAnimation LayAnimID;
    var byte WakeAnimIndex;
    var bool bEnabledMotionDelta;

    structdefaultproperties
    {
        RecoverID=ERecoverTypeFromAnimation.ETFA_PlayWholeAnimation
        LayAnimID=ELayFirstFrameAnimation.EFFA_Skeleton_Dismembered_1
        WakeAnimIndex=0
        bEnabledMotionDelta=false
    }
};

struct native HitZone
{
    var EvilTypes.EBodyParts BodyPart;
    var const localized string ZoneComboName;
    var float ZoneScoring;
    var int ZonePriority;
    var array<name> ZoneBones;
    var int Health;
    var bool bIsLimbDetached;

    structdefaultproperties
    {
        BodyPart=EBodyParts.BP_Head
        ZoneComboName=""
        ZoneScoring=0.0000000
        ZonePriority=0
        ZoneBones=none
        Health=0
        bIsLimbDetached=false
    }
};

var bool bCanPinToThisActor;
var bool bInheritJumpVelocityFromMotionDelta;
var() bool bAimWhenFullBodySlotAnim;
var bool bDisableIK;
var bool bTakeFriendlyFire;
var bool bGiveFriendlyFire;
var bool bDisableEvilAnimWeaponAnims;
var bool bPlayingTurnTransition;
var bool bShouldWalkFast;
var bool bCanLongDistanceCharge;
var bool bCanThrowGrenade;
var bool bThrowingGrenade;
var bool bShouldBeginStumble;
var bool bStrafing;
var bool bDamageCanBeIgnored;
var() bool bCanBeAffectedByLight;
var bool bOnLightInfluenceFromFlashLight;
var bool bOnLightInfluenceFromVolume;
var bool bIgnoreSetMovementPhysics;
var bool bShowOnRadar;
var bool bCanPlayVO;
var bool bPlayHitSoundInPlayHit;
var transient bool bIsJumping;
var transient bool IsSprinting;
var bool bCanPlayRecoverAnimationTowardsEnemy;
var bool bForcePlayDeathAnimation;
var bool bDeathAnimationWithoutMotors;
var bool bShouldPlayDeathAnimationToRagdoll;
var bool bCanBeKnockedDown;
var bool bPotentiallyCanPlayKnockDown;
var bool bShouldPlayMeleeImpacts;
var bool bHasDirectionalMoveAnims;
var transient bool bEndingPawnAction;
var bool bFastSpinUp;
var bool bUseEstimatedYawFromAnim;
var bool DetachingSpecificLimbEnabled;
var bool bDetachingLimbsWhenDiedEnabled;
var bool EnableHitDecals;
var() bool bThrowRandomBloodDecals;
var bool bInMoveLatent;
var bool bForceMoveMode;
var bool bFiringLeft;
var protected repnotify bool bPuttingDownWeaponLeft;
var bool WaitingForDualReload;
var bool LastReloadWasFromInput;
var bool DualWieldRightLastShot;
var repnotify bool bQuickHidenWeapon;
var repnotify bool bQuickHidenLeftWeapon;
var bool bMovingToCover;
var bool bWantsToBeMirrored;
var bool bDoingMirrorTransition;
var bool bIsMirrored;
var bool bDoingCoverActionAnimTransition;
var() config bool bCanDoTurnInPlaceAnim;
var bool bLockRotation;
var bool bRotInterpCoverTransition;
var bool bStartedStumbleAnim;
var bool bReadyToRun;
var bool bCanSlowDown;
var() float JumpDeltaMultiplier;
var() Vector JumpImpulseFromKismet;
var() Vector AccumulatedMotionDelta;
var EvilJumpSequenceInformation CurrentJumpInfo;
var SeqAct_Jump JumpKismetAction;
var() config float NPCAimingHelpRadius;
var() float LeftHandIKStrength;
var Rotator AimRotation;
var EvilTypes.EAimZone RequestedAimZone;
var EvilTypes.EAimZone CurrentAimZone;
var EvilTypesNative.EMoveMode CurrentMoveMode;
var EvilTypesNative.EMoveMode LastMoveMode;
var EvilTypesNative.EMoveMode SavedSupremeMoveMode;
var EvilTypesNative.EMoveMode SupremeMoveMode;
var EvilPawn.ELeanState CurrentLeanState;
var EvilTypes.ECharacterFootStepType CharacterFootStepType;
var EvilPawn.ESetSize SetSize;
var byte PawnAction;
var byte PreviousPawnAction;
var() repnotify byte ReplicatedLimbsInfo[EBodyParts];
var EvilTypesNative.EMoveMode MoveModeToEnforce;
var CoverLink.ECoverType CoverType;
var CoverLink.ECoverAction CoverAction;
var CoverLink.ECoverAction PreviousCoverAction;
var CoverLink.ECoverAction SavedCoverAction;
var transient CoverLink.ECoverDirection LastCoverDirection;
var transient CoverLink.ECoverDirection CoverDirection;
var transient CoverLink.ECoverDirection CurrentSlotDirection;
var CoverLink.ECoverAction CoverActionAnim;
var EvilTypesNative.EAnimationSetType SpinUpAST;
var(Debug) EvilPawn.EDebugDisplayType DebugDisplayType;
var config float MyEnemyRatingForOthersModifier;
var float NewMovementSpeedModifier;
var float SavedMovementSpeedModifier;
var float PawnActionAnimRateModifier;
var SeqAct_AIFactory AIFactory;
var int PawnAIType;
var class<EvilWeap_MeleeHands> HandsClass;
var config float IgnoreDamageTimer;
var config float ReduceDamagePercentage;
var config float ReduceDamageFactor;
var config float DodgeChanceByDamage;
var config float DodgeDelayByDamage;
var float LastDodgeTime;
var float LightInfluenceWeight;
var float LightInfluenceTimeout;
var() class<EvilWeap_Base> MeleeKickWeapClass;
var Weapon MeleeKickWeap;
var Weapon MeleeWeapon;
var Weapon ThrowWeapon;
var repnotify EvilInventoryManager EvilInvManager;
var() array< class<Inventory> > DefaultInventory;
var() config float DefaultHealth;
var repnotify Vector FlashLocationArray[20];
var repnotify Vector FlashLocationArrayMelee[20];
var Vector DamageInstigatorLocation;
var Vector DamageLocations[20];
var transient float LastDamageCollectionTime;
var transient int LastDamageCollectionIndex;
var AnimNodeSlot CoverTopHalfAnimSlot;
var AnimNodeAdditiveBlending ShootAddToRunNode;
var AnimNodeBlend BlendAimOffsetByRunNode;
var() config float LeanLenght;
var() config float LeanRoll;
var transient float CurrLeanRotVal;
var transient float CurrLeanLocVal;
var transient float LastLeanRotTime;
var transient float LastLeanLocTime;
var() config float SprintSpeedModifier;
var() config float SprintFOV;
var() config float SprintFOVRate;
var float Stamina;
var() config float StaminaDecreaseAmount;
var() config float StaminaRegenAmount;
var() CameraAnim SprintCameraAnim;
var() CameraAnim KickCameraAnim;
var EvilAIController MyEvilAI;
var EvilWeap_Base MyEvilWeapon;
var EvilAnim_TurnInPlace TurnInPlaceNode;
var array<AnimNodeAimOffset> EvilAimNodes;
var EvilAnim_AimOffset EvilAimNode;
var AnimNodeSlot AimSlot;
var UDKAnimNodeCopyBoneTranslation CopyBoneTranslationNode;
var EvilAnimNodeForwardMovement EvilForwardMovementNode;
var AnimNodeBlend BlendByRailCar;
var EvilAnimBaseBlendNode BaseBlendNode;
var EvilAnimBlendByMoveMode MoveModeNode;
var AnimNodeAdditiveBlending AimBlendNode;
var() Vector2D AimOffsetPct;
var name HipsBoneName;
var name RightHandBoneName;
var name LeftHandBoneName;
var name LeftFootBoneName;
var name RightFootBoneName;
var config float MaximumRagdollSpeed;
var Controller Kicker;
var EvilAttachment_Weap_Base CurrentMeleeWeaponAttachment;
var repnotify class<EvilAttachment_Weap_Base> CurrentMeleeWeaponAttachmentClass;
var EvilAttachment_Weap_Base CurrentThrowWeaponAttachment;
var repnotify class<EvilAttachment_Weap_Base> CurrentThrowWeaponAttachmentClass;
var() EvilPawnGoreSettings GoreSettings;
var() EvilPawnClothingSettings ClothesSettings;
var() export editinline SkeletalMeshComponent BaseSkeletalMeshComp;
var() export editinline SkeletalMeshComponent HeadSkeletalMeshComp;
var array<AnimNameToSpecialHitReactionAnimInfo> AnimNamesToSpecialHitReactionIndexes;
var array<EvilAnimInfo> AnimInfoFromSpecialHitReaction;
var config float MinTimeBetweenHits;
var float NextHitTime;
var array<BoneNameToSpecialHitReactionAnimInfo> BoneNamesToSpecialHitReactionIndexes;
var float TimeToBodyDisappear;
var float TimeToBodyDisappear_NoGore;
var transient array<AnimNodeSequence> ResumePlayNodes;
var name GrenadeSocket;
var float GrenadeTossZ;
var int BoneToRagdollCounter;
var repnotify BoneRagdollInfo ReplicatedBoneToRagfollInfo[32];
var array<int> SynchronizedBonesIndexes;
var repnotify PhysicsImpulseInfo KnockdownImpulse;
var array<MeleeHitParticleInfo> MeleeHitParticles;
var export editinline ParticleSystemComponent BurnEffectPSC;
var export editinline ParticleSystemComponent CapturedEffectPSC;
var ParticleSystem BurnEffectPS;
var ParticleSystem BurnEffectPS_NoGore;
var ParticleSystem CapturedEffectPS;
var EvilLightActor BurnLightActor;
var EvilLightActor BurnLightArchetype;
var float BurningDamageAmount;
var float BurnBlackMaterialValue;
var float BurnDotsMaterialValue;
var float BurnBlackMaterialDelay;
var float BurnDotsMaterialDelay;
var float BurnBlackMaterialAmount;
var float BurnDotsMaterialAmount;
var float RemoveBurnDotsAmount;
var repnotify int ReplicatedHeadClothIndex;
var repnotify int ReplicatedEquipmentClothIndex;
var() repnotify ReplicatedClothInfo ReplicatedClothesInfo[32];
var() repnotify ReplicatedClothMaterial ReplicatedClothMaterials[32];
var repnotify ReplicatedClothMaterial ReplicatedClothWeapon;
var repnotify ReplicatedClothMaterial ReplicatedClothShield;
var class<EvilDmgType_Base> CurrentDamageType;
var EvilTakeHitInfo CurrentHitInformation;
var EvilNavMeshGoal Goal;
var() config float GameIntesityFactor;
var PAStruct PendingPawnActionStruct;
var EvilNavPointAction CurrentNavPointAction;
var array< class<EvilPawnAction> > PawnActionClasses;
var(PawnActions) editconst editinline transient array<editconst editinline EvilPawnAction> PawnActions;
var repnotify PAStruct ReplicatedPawnActionStruct;
var EvilPawn InteractionPawn;
var int PawnActionFlags;
var array<byte> PawnToPawnInteractionList;
var Vector PawnActionLocation;
var EvilAnimDef AnimDefArchetype;
var EvilAnimDef AlternativeAnimDefArchetype;
var array<AnimSet> AlternativeAddAnimSets;
var() int WalkSlowAnimIndex;
var() int WalkFastAnimIndex;
var() int RunAnimIndex;
var() int IdleAnimIndex;
var() int RunFailAnimIndex;
var() int PackedFastSpinUpAnimInfo;
var array<EvilAnimInfo> LayAnims;
var array<WakeAnimInfo> WakeAnims;
var array<EvilAnimInfo> SpawnAnims;
var _WakeInformation WakeInformation;
var() array<HitZone> HitZones;
var() HitZone DefaultZone;
var int LastHitZone;
var int DetachingLimbsSoundsCounter;
var int DetachingLimbSoundLimiter;
var int DecalMaterialIndex;
var() float HitDecalSize;
var TextureRenderTarget2D MaskTexture;
var export editinline SceneCapture2DHitMaskComponent HitMaskComponent;
var array<MaterialInstanceConstant> PawnMaterials;
var array<MaterialInstanceConstant> PawnHeadMaterials;
var float TurnInPlaceWhileMovingYawThreshold;
var TeamInfo AITeamInfo;
var Actor ClampedBase;
var repnotify class<EvilAttachment_Weap_Base> CurrentWeaponLeftAttachmentClass;
var EvilAttachment_Weap_Base CurrentWeaponLeftAttachment;
var float LastCoverTime;
var float NextCoverActionTime;
var float LastCoverActionTime;
var int CurrentSlotIdx;
var int ClosestSlotIdx;
var int PreviousSlotIdx;
var int LeftSlotIdx;
var int RightSlotIdx;
var float CurrentSlotPct;
var CoverLink CurrentLink;
var CovPosInfo AcquiredCoverInfo;
var AnimNodeMirror MirrorNode;
var class<EvilWeap_Base> SavedWeapon;
var class<EvilWeap_Base> SavedWeaponLeft;
var() float PawnRotationInterpolationTime;
var float PawnRotationBlendTimeToGo;
var Rotator LastCoverRotation;
var float ReadyToRunInterval;
var(animation) name WalkSlowSpinUpAnim;
var(animation) name WalkFastSpinUpAnim;
var int OldWalking;
var int SpinUpIndex;
var float SlowDownDelay;
var float LastRunDeactivationTime;
var transient float CustomMoveModeBlendTime;
var transient int MeshYawOffset;
var() FaceFXAnimSet FaceFXEmotionAnimSetRef;
var() class<EvilProjectile_Base> GrenadeProjectile;

replication
{
    // Pos:0x000
    if(bNetDirty)
        AITeamInfo, CurrentDamageType, 
        CurrentLeanState, CurrentMeleeWeaponAttachmentClass, 
        CurrentMoveMode, CurrentThrowWeaponAttachmentClass, 
        CurrentWeaponLeftAttachmentClass, DamageInstigatorLocation, 
        DamageLocations, FlashLocationArray, 
        FlashLocationArrayMelee, IsSprinting, 
        KnockdownImpulse, LastDamageCollectionIndex, 
        ReplicatedBoneToRagfollInfo, ReplicatedClothMaterials, 
        ReplicatedClothShield, ReplicatedClothWeapon, 
        ReplicatedClothesInfo, ReplicatedEquipmentClothIndex, 
        ReplicatedHeadClothIndex, ReplicatedLimbsInfo, 
        Stamina, bQuickHidenLeftWeapon, 
        bQuickHidenWeapon;

    // Pos:0x00A
    if(bNetDirty && bNetOwner)
        EvilInvManager, MeleeKickWeap, 
        MeleeWeapon, ThrowWeapon;

    // Pos:0x023
    if((!bNetOwner || bDemoRecording) && int(Role) == int(ROLE_Authority))
        AimRotation, CurrentAimZone, 
        IdleAnimIndex, PackedFastSpinUpAnimInfo, 
        ReplicatedPawnActionStruct, RunAnimIndex, 
        RunFailAnimIndex, WalkFastAnimIndex, 
        WalkSlowAnimIndex, bFastSpinUp, 
        bInMoveLatent, bPlayingTurnTransition, 
        bShouldBeginStumble, bShouldWalkFast, 
        bStrafing;

    // Pos:0x054
    if(bNetDirty && !bNetOwner || bDemoRecording)
        bFiringLeft;

    // Pos:0x07E
    if(bNetDirty && !bNetOwner)
        WaitingForDualReload, bPuttingDownWeaponLeft;

    // Pos:0x099
    if(int(Role) == int(ROLE_Authority))
        ClampedBase;
}

// Export UEvilPawn::execMergeMeshes(FFrame&, void* const)
native simulated function MergeMeshes(SkeletalMesh Head, SkeletalMesh Torso);

simulated event BeginAnimControl(InterpGroup InInterpGroup)
{
    super(Pawn).BeginAnimControl(InInterpGroup);
    // End:0x4A
    if(MyEvilAI != none)
    {
        MyEvilAI.OnBeginAnimControl(InInterpGroup);
    }
    //return;    
}

simulated event FinishAnimControl(InterpGroup InInterpGroup)
{
    super(Pawn).FinishAnimControl(InInterpGroup);
    // End:0x4A
    if(MyEvilAI != none)
    {
        MyEvilAI.OnFinishAnimControl(InInterpGroup);
    }
    //return;    
}

simulated function Projectile ThrowGrenade(Rotator Rot, Vector Loc, optional out Vector SuggestedTossVelocity)
{
    local Projectile Proj;

    Proj = Spawn(GrenadeProjectile, self,, Loc, Rot);
    Proj.Init(Normal(Vector(Rot)));
    Proj.Velocity = SuggestedTossVelocity;
    Proj.Damage = 450.0000000;
    return Proj;
    //return ReturnValue;    
}

function bool IsLongDistanceChargeActive()
{
    return false;
    //return ReturnValue;    
}

function StartLongDistanceCharge()
{
    bIsWalking = true;
    //return;    
}

function StopLongDinstanceCharge()
{
    bIsWalking = false;
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);
    // End:0x104
    if(SkelComp == Mesh)
    {
        ClearAnimNodes();
        CacheAnimNodes();
        // End:0x7B
        if(!IsPlayerPawn())
        {
            WalkSlowAnimIndex = AST_GetRandomAnimIndex(69);
            RunAnimIndex = AST_GetRandomAnimIndex(67);
        }
        // End:0x104
        if(((GoreSettings == none) || GoreSettings.AlternateSkeletalMesh == none) || SkelComp.SkeletalMesh != GoreSettings.AlternateSkeletalMesh)
        {
            ChangeMoveMode(0, 0.0000000);
        }
    }
    //return;    
}

function bool DoingAnimationTransition()
{
    // End:0x0F
    if(bDoingMirrorTransition)
    {
        return true;
    }
    // End:0x51
    if(bDoingCoverActionAnimTransition || (int(CoverType) != int(0)) && int(CoverAction) != int(CoverActionAnim))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsMirrorTransitionSafe()
{
    return (MirrorNode != none) && !bDoingMirrorTransition;
    //return ReturnValue;    
}

function bool CanTurnInPlace()
{
    return (TurnInPlaceNode != none) && bCanDoTurnInPlaceAnim;
    //return ReturnValue;    
}

function bool IsMoving()
{
    return int(CurrentMoveMode) != int(0);
    //return ReturnValue;    
}

function bool IsMoveInterrupted()
{
    return false;
    //return ReturnValue;    
}

function bool IsWalking()
{
    return int(CurrentMoveMode) == int(1);
    //return ReturnValue;    
}

function bool IsInStealthMode()
{
    return (EvilWeap_Base(Weapon) != none) && EvilWeap_Base(Weapon).bHasSuppressor;
    //return ReturnValue;    
}

function bool IsAiming()
{
    return int(PawnAction) == 10;
    //return ReturnValue;    
}

function bool IsFiring()
{
    local bool bWeaponLeftFiring;

    // End:0x39
    if(WeaponLeft != none)
    {
        bWeaponLeftFiring = WeaponLeft.IsFiring();
    }
    return bWeaponLeftFiring || super(Pawn).IsFiring();
    //return ReturnValue;    
}

// Export UEvilPawn::execIsReloading(FFrame&, void* const)
native function bool IsReloading();

function bool IsRunning()
{
    return int(CurrentMoveMode) == int(2);
    //return ReturnValue;    
}

function bool IsSpinningUp()
{
    return int(CurrentMoveMode) == int(3);
    //return ReturnValue;    
}

function bool IsBlindFiring(CoverLink.ECoverAction InCoverAction)
{
    return ((int(InCoverAction) == int(2)) || int(InCoverAction) == int(1)) || int(InCoverAction) == int(6);
    //return ReturnValue;    
}

function bool IsALeaningAction(CoverLink.ECoverAction InCoverAction)
{
    return ((int(InCoverAction) == int(4)) || int(InCoverAction) == int(3)) || int(InCoverAction) == int(5);
    //return ReturnValue;    
}

function bool IsLeaning()
{
    return IsALeaningAction(CoverAction);
    //return ReturnValue;    
}

function bool IsPoppingUp()
{
    return (int(CoverAction) == int(5)) || (int(CoverAction) != int(6)) && int(CoverDirection) == int(3);
    //return ReturnValue;    
}

final simulated function bool IsPeeking(CoverLink.ECoverAction InCoverAction)
{
    return ((int(InCoverAction) == int(8)) || int(InCoverAction) == int(7)) || int(InCoverAction) == int(9);
    //return ReturnValue;    
}

function bool IsRightCoverAction(CoverLink.ECoverAction InCoverAction)
{
    return ((int(InCoverAction) == int(8)) || int(InCoverAction) == int(4)) || int(InCoverAction) == int(2);
    //return ReturnValue;    
}

function bool IsLeftCoverAction(CoverLink.ECoverAction InCoverAction)
{
    return ((int(InCoverAction) == int(7)) || int(InCoverAction) == int(3)) || int(InCoverAction) == int(1);
    //return ReturnValue;    
}

function ForceLimitedMoveMode(EvilTypesNative.EMoveMode InSupremeMoveMode)
{
    SavedSupremeMoveMode = SupremeMoveMode;
    // End:0x45
    if(CanChangeMoveMode(InSupremeMoveMode, SupremeMoveMode))
    {
        SupremeMoveMode = InSupremeMoveMode;
    }
    //return;    
}

function RollbackLimitedMoveMode()
{
    SupremeMoveMode = SavedSupremeMoveMode;
    //return;    
}

function ChangeMoveMode(EvilTypesNative.EMoveMode InNewMode, optional float InBlendTime = -1.0000000)
{
    // End:0x8C
    if(CanChangeMoveMode(InNewMode, CurrentMoveMode))
    {
        LastMoveMode = CurrentMoveMode;
        CurrentMoveMode = InNewMode;
        CustomMoveModeBlendTime = InBlendTime;
        ProcessMovementMode(0.0000000);
        MoveModeChanged(CurrentMoveMode, LastMoveMode);
    }
    //return;    
}

function bool CanChangeMoveMode(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    // End:0x1D
    if(int(InNewMode) == int(InOldMode))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function MoveModeChanged(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    // End:0x40
    if(MyEvilAI != none)
    {
        MyEvilAI.NotifyMoveModeChanged(InNewMode, InOldMode);
    }
    // End:0x69
    if(int(InOldMode) == int(1))
    {
        bShouldWalkFast = default.bShouldWalkFast;
    }
    // End:0xCB
    if(bFastSpinUp)
    {
        ZeroMovementVariables();
        ReadyToRunInterval = MoveModeNode.GetAnimDuration(3) - MoveModeNode.BlendTime;
    }
    //return;    
}

function NotifyBehaviorModeChanged(EvilTypes.EBehaviorMode InNewMode, EvilTypes.EBehaviorMode InOldMode)
{
    //return;    
}

function ToggleAimingAnimMode(optional bool bForceOff)
{
    local EPA_Aim AimAction;

    // End:0x3D
    if(int(PawnAction) != 0)
    {
        AimAction = EPA_Aim(PawnActions[int(PawnAction)]);        
    }
    else
    {
        bForceOff = true;
    }
    // End:0xA6
    if(!bForceOff)
    {
        switch(CurrentMoveMode)
        {
            // End:0x88
            case 2:
                SetAimingAnim(AimAction, true);
                // End:0xA3
                break;
            // End:0xFFFF
            default:
                SetAimingAnim(AimAction, false);
                // End:0xA3
                break;
                break;
        }        
    }
    else
    {
        SetAimingAnim(,,, true);
    }
    //return;    
}

function SetAimingAnim(optional EPA_Aim AimAction, optional bool bRunMode, optional bool bForceOff)
{
    // End:0x68
    if(bRunMode || bForceOff)
    {
        // End:0x65
        if(AimSlot.bIsPlayingCustomAnim)
        {
            AimSlot.StopCustomAnim(0.1000000);
        }        
    }
    else
    {
        // End:0x223
        if(AimAction != none)
        {
            AimSlot.PlayCustomAnim(AimAction.AnimInfo.AnimName, AimAction.AnimInfo.AnimSpeed * AimAction.SpeedModifier, AimAction.AnimInfo.BlendInTime / AimAction.SpeedModifier, AimAction.AnimInfo.BlendOutTime / AimAction.SpeedModifier, !AimAction.bStartFireFromAnim, true, 0.0000000);
            AimSlot.SetActorAnimEndNotification(AimAction.bStartFireFromAnim);            
        }
        else
        {
            AimSlot.ReplayAnim();
        }
    }
    SetAimingAnimNodes(bRunMode, bForceOff);
    //return;    
}

function SetAimingAnimNodes(bool bRunMode, optional bool bForceOff)
{
    local float BlendTarget;

    // End:0x31
    if(!bRunMode || bForceOff)
    {
        BlendTarget = 0.0000000;        
    }
    else
    {
        BlendTarget = 1.0000000;
    }
    ShootAddToRunNode.SetBlendTarget(BlendTarget, 0.1000000);
    BlendAimOffsetByRunNode.SetBlendTarget(BlendTarget, 0.1000000);
    //return;    
}

function float GetAimingTotalWeight()
{
    local float TotalWeight;
    local AnimNodeSequence AnimNodeSeq;

    // End:0xB6
    if(IsAiming())
    {
        AnimNodeSeq = AimSlot.GetCustomAnimNodeSeq();
        switch(CurrentMoveMode)
        {
            // End:0x79
            case 2:
                TotalWeight = ShootAddToRunNode.NodeTotalWeight;
                // End:0xB6
                break;
            // End:0xFFFF
            default:
                // End:0xB3
                if(AnimNodeSeq != none)
                {
                    TotalWeight = AnimNodeSeq.NodeTotalWeight;
                }
                // End:0xB6
                break;
                break;
        }
    }
    return TotalWeight;
    //return ReturnValue;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super.PossessedBy(C, bVehicleTransition);
    MyEvilAI = EvilAIController(C);
    // End:0xF3
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0xF3
        if((WorldInfo.Game != none) && EvilGame(WorldInfo.Game) != none)
        {
            EvilGame(WorldInfo.Game).AIDirectorInstance.AddMonitoredPawn(self);
        }
    }
    //return;    
}

function UnPossessed()
{
    super(Pawn).UnPossessed();
    MyEvilAI = none;
    //return;    
}

simulated function TurnOffPawn()
{
    StopBurning();
    super.TurnOffPawn();
    //return;    
}

// Export UEvilPawn::execAST_GetRandomAnimIndex(FFrame&, void* const)
native static final function int AST_GetRandomAnimIndex(EvilTypesNative.EAnimationSetType InAnimType, optional bool InUseEqualChance = false);

// Export UEvilPawn::execAST_GetRandomAnimByChance(FFrame&, void* const)
protected native static function int AST_GetRandomAnimByChance(const out array<EvilAnimInfo> AnimList);

// Export UEvilPawn::execAST_GetAnimName(FFrame&, void* const)
native final function name AST_GetAnimName(EvilTypesNative.EAnimationSetType InAnimType, int InIndex);

// Export UEvilPawn::execAST_GetAnimInfo(FFrame&, void* const)
native final function bool AST_GetAnimInfo(EvilTypesNative.EAnimationSetType InAnimType, int InIndex, out EvilAnimInfo OutEvilAnimInfo);

function int AST_GetAnimCount(EvilTypesNative.EAnimationSetType InAnimType)
{
    // End:0x11
    if(AnimDefArchetype == none)
    {
        return 0;
    }
    return AnimDefArchetype.GetAnimCount(InAnimType);
    //return ReturnValue;    
}

function bool AST_GetAnimDefInfo(EvilTypesNative.EAnimationSetType InAnimType, out AnimDefInfo OutAnimDefInfo)
{
    // End:0x11
    if(AnimDefArchetype == none)
    {
        return false;
    }
    return AnimDefArchetype.GetAnimDefInfo(InAnimType, OutAnimDefInfo);
    //return ReturnValue;    
}

function SetAnimSetsFromAnimDef(EvilAnimDef InAnimDef)
{
    local int I;

    // End:0xDF
    if(InAnimDef != none)
    {
        Mesh.AnimSets.Remove(0, Mesh.AnimSets.Length);
        I = 0;
        J0x5A:

        // End:0xDF [Loop If]
        if(I < InAnimDef.AnimSets.Length)
        {
            Mesh.AnimSets.AddItem(InAnimDef.AnimSets[I]);
            ++I;
            // [Loop Continue]
            goto J0x5A;
        }
    }
    //return;    
}

// Export UEvilPawn::execGetTotalRootMotionForSequence(FFrame&, void* const)
native function bool GetTotalRootMotionForSequence(name AnimSeqName, out Vector out_Translation, out Quat out_Rotation);

simulated function CreatePawnMaterials()
{
    local editinline SkeletalMeshComponent SKComp;
    local int I, numElems;

    SKComp = GetSkeletalMeshComponent();
    numElems = SKComp.GetNumElements();
    PawnMaterials.Remove(0, PawnMaterials.Length);
    I = 0;
    J0x5E:

    // End:0xB8 [Loop If]
    if(I < numElems)
    {
        PawnMaterials.AddItem(SKComp.CreateAndSetMaterialInstanceConstant(I));
        ++I;
        // [Loop Continue]
        goto J0x5E;
    }
    // End:0x142
    if(HeadSkeletalMeshComp != none)
    {
        I = 0;
        J0xD2:

        // End:0x142 [Loop If]
        if(I < HeadSkeletalMeshComp.GetNumElements())
        {
            PawnHeadMaterials.AddItem(HeadSkeletalMeshComp.CreateAndSetMaterialInstanceConstant(I));
            I++;
            // [Loop Continue]
            goto J0xD2;
        }
    }
    //return;    
}

simulated function SkeletalMeshComponent GetSkeletalMeshComponent()
{
    return ((BaseSkeletalMeshComp != none) ? BaseSkeletalMeshComp : Mesh);
    //return ReturnValue;    
}

simulated function PreBeginPlay()
{
    super(Pawn).PreBeginPlay();
    // End:0x23
    if(ClothesSettings == none)
    {
        CreatePawnMaterials();
    }
    //return;    
}

simulated event CacheAnimNodes()
{
    local AnimNodeAimOffset AimOffsetNode;

    super(Pawn).CacheAnimNodes();
    // End:0x55
    foreach Mesh.AllAnimNodes(Class'Engine.AnimNodeAimOffset', AimOffsetNode)
    {
        EvilAimNodes.AddItem(AimOffsetNode);        
    }    
    CoverTopHalfAnimSlot = AnimNodeSlot(Mesh.FindAnimNode('CoverTopHalfSlot'));
    TurnInPlaceNode = EvilAnim_TurnInPlace(Mesh.FindAnimNode('TurnInPlaceNode'));
    AimSlot = AnimNodeSlot(Mesh.FindAnimNode('AimSlot'));
    EvilAimNode = EvilAnim_AimOffset(Mesh.FindAnimNode('EvilAimNode'));
    // End:0x175
    if((PlayerReplicationInfo != none) && AimNode == none)
    {
        AimNode = EvilAimNode;
    }
    CopyBoneTranslationNode = UDKAnimNodeCopyBoneTranslation(Mesh.FindAnimNode('CopyBoneTranslationNode'));
    EvilForwardMovementNode = EvilAnimNodeForwardMovement(Mesh.FindAnimNode('EvilAnimNodeForwardMovement'));
    MirrorNode = AnimNodeMirror(Mesh.FindAnimNode('MirrorNode'));
    BlendByRailCar = AnimNodeBlend(Mesh.FindAnimNode('BlendByRailCar'));
    BaseBlendNode = EvilAnimBaseBlendNode(Mesh.FindAnimNode('BaseBlendNode'));
    MoveModeNode = EvilAnimBlendByMoveMode(Mesh.FindAnimNode('MoveModeBlend'));
    MoveModeNode.bMasterMoveBlendNode = true;
    ShootAddToRunNode = AnimNodeAdditiveBlending(Mesh.FindAnimNode('ShootAddToRunNode'));
    BlendAimOffsetByRunNode = AnimNodeBlend(Mesh.FindAnimNode('BlendAimOffsetByRunNode'));
    AimBlendNode = AnimNodeAdditiveBlending(Mesh.FindAnimNode('AimAdditiveBlend'));
    SlotNodes.AddItem(FullBodyAnimSlot);
    //return;    
}

simulated function ClearAnimNodes()
{
    super(Pawn).ClearAnimNodes();
    EvilAimNodes.Length = 0;
    CoverTopHalfAnimSlot = none;
    TurnInPlaceNode = none;
    AimSlot = none;
    EvilAimNode = none;
    AimNode = none;
    CopyBoneTranslationNode = none;
    EvilForwardMovementNode = none;
    MirrorNode = none;
    BlendByRailCar = none;
    BaseBlendNode = none;
    MoveModeNode = none;
    ShootAddToRunNode = none;
    BlendAimOffsetByRunNode = none;
    //return;    
}

simulated function PostBeginPlay()
{
    InitDefaultHealth();
    super.PostBeginPlay();
    // End:0x48
    if(EvilInventoryManager(InvManager) != none)
    {
        EvilInvManager = EvilInventoryManager(InvManager);
    }
    SetTimer(0.1000000, true, 'HandleStamina');
    // End:0x72
    if(EnableHitDecals)
    {
        CreateHitDecalTexture();
    }
    // End:0xAB
    if((int(Role) == int(ROLE_Authority)) && !IsPlayerPawn())
    {
        AddDefaultInventory();
        CopyLimbsHealth();
    }
    //return;    
}

function InitDefaultHealth()
{
    Health = int(DefaultHealth);
    HealthMax = int(DefaultHealth);
    //return;    
}

simulated function SetHandIKEnabled(bool bEnabled)
{
    // End:0x9A
    if((((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Mesh.Animations != none) && LeftHandIK != none) && RightHandIK != none)
    {
        LeftHandIK.SetSkelControlActive(bEnabled);
    }
    //return;    
}

simulated function WeaponChanged(EvilWeap_Base NewWeapon)
{
    local editinline UDKSkeletalMeshComponent UTSkel;

    // End:0x245
    if(NewWeapon.Mesh != none)
    {
        NewWeapon.Mesh.SetHidden(!IsFirstPerson());
        UTSkel = UDKSkeletalMeshComponent(NewWeapon.Mesh);
        // End:0x245
        if(UTSkel != none)
        {
            // End:0x188
            if(!NewWeapon.UsesOffhand)
            {
                ArmsMesh[0].SetFOV(UTSkel.FOV);
                ArmsMesh[0].SetScale(UTSkel.Scale);
                ArmsMesh[0].SetDepthPriorityGroup(UTSkel.DepthPriorityGroup);                
            }
            else
            {
                ArmsMesh[1].SetFOV(UTSkel.FOV);
                ArmsMesh[1].SetScale(UTSkel.Scale);
                ArmsMesh[1].SetDepthPriorityGroup(UTSkel.DepthPriorityGroup);
            }
        }
    }
    CurrentLeanState = 0;
    //return;    
}

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
    //return;    
}

function OnIKStatusUpdate(optional bool bZoomIn)
{
    // End:0x74
    if(EvilSkelControlLimb(LeftHandIK) != none)
    {
        EvilSkelControlLimb(LeftHandIK).OnWeaponAttachmentChanged(self);
        EvilSkelControlLimb(LeftHandIK).OnIKStatusUpdate(bZoomIn);
    }
    // End:0xE7
    if(EvilSkelControlLimb(RightHandIK) != none)
    {
        EvilSkelControlLimb(RightHandIK).OnWeaponAttachmentChanged(self);
        EvilSkelControlLimb(RightHandIK).OnIKStatusUpdate(bZoomIn);
    }
    //return;    
}

simulated function WeaponAttachmentChanged()
{
    super.WeaponAttachmentChanged();
    OnIKStatusUpdate();
    //return;    
}

simulated function WeaponLeftAttachmentChanged()
{
    // End:0x193
    if(((CurrentWeaponLeftAttachment == none) || CurrentWeaponLeftAttachment.Class != CurrentWeaponLeftAttachmentClass) && Mesh.SkeletalMesh != none)
    {
        // End:0xB2
        if(CurrentWeaponLeftAttachment != none)
        {
            CurrentWeaponLeftAttachment.DetachFrom(Mesh);
            CurrentWeaponLeftAttachment.Destroy();
        }
        // End:0x107
        if(CurrentWeaponLeftAttachmentClass != none)
        {
            CurrentWeaponLeftAttachment = Spawn(CurrentWeaponLeftAttachmentClass, self);
            CurrentWeaponLeftAttachment.Instigator = self;            
        }
        else
        {
            CurrentWeaponLeftAttachment = none;
        }
        // End:0x193
        if(CurrentWeaponLeftAttachment != none)
        {
            CurrentWeaponLeftAttachment.AttachTo(self, true);
            CurrentWeaponLeftAttachment.SetSkin(ReplicatedBodyMaterial);
            CurrentWeaponLeftAttachment.ChangeVisibility(bWeaponAttachmentVisible);
        }
    }
    //return;    
}

simulated function WeaponMeleeAttachmentChanged()
{
    local EvilWeap_Base Wpn;

    // End:0x1D5
    if(((CurrentMeleeWeaponAttachment == none) || CurrentMeleeWeaponAttachment.Class != CurrentMeleeWeaponAttachmentClass) && Mesh.SkeletalMesh != none)
    {
        // End:0xAE
        if(CurrentMeleeWeaponAttachmentClass == none)
        {
            Wpn = FindMeleeWeapon();
            CurrentMeleeWeaponAttachmentClass = Wpn.AttachmentClass;
        }
        // End:0xFD
        if(CurrentMeleeWeaponAttachment != none)
        {
            CurrentMeleeWeaponAttachment.DetachFrom(Mesh);
            CurrentMeleeWeaponAttachment.Destroy();
        }
        // End:0x152
        if(CurrentMeleeWeaponAttachmentClass != none)
        {
            CurrentMeleeWeaponAttachment = Spawn(CurrentMeleeWeaponAttachmentClass, self);
            CurrentMeleeWeaponAttachment.Instigator = self;            
        }
        else
        {
            CurrentMeleeWeaponAttachment = none;
        }
        // End:0x1D5
        if(CurrentMeleeWeaponAttachment != none)
        {
            CurrentMeleeWeaponAttachment.AttachTo(self);
            CurrentMeleeWeaponAttachment.SetSkin(ReplicatedBodyMaterial);
            CurrentMeleeWeaponAttachment.ChangeVisibility(false);
        }
    }
    //return;    
}

simulated function WeaponThrowAttachmentChanged()
{
    // End:0x18A
    if(((CurrentThrowWeaponAttachment == none) || CurrentThrowWeaponAttachment.Class != CurrentThrowWeaponAttachmentClass) && Mesh.SkeletalMesh != none)
    {
        // End:0xB2
        if(CurrentThrowWeaponAttachment != none)
        {
            CurrentThrowWeaponAttachment.DetachFrom(Mesh);
            CurrentThrowWeaponAttachment.Destroy();
        }
        // End:0x107
        if(CurrentThrowWeaponAttachmentClass != none)
        {
            CurrentThrowWeaponAttachment = Spawn(CurrentThrowWeaponAttachmentClass, self);
            CurrentThrowWeaponAttachment.Instigator = self;            
        }
        else
        {
            CurrentThrowWeaponAttachment = none;
        }
        // End:0x18A
        if(CurrentThrowWeaponAttachment != none)
        {
            CurrentThrowWeaponAttachment.AttachTo(self);
            CurrentThrowWeaponAttachment.SetSkin(ReplicatedBodyMaterial);
            CurrentThrowWeaponAttachment.ChangeVisibility(false);
        }
    }
    //return;    
}

simulated function CopyLimbsHealth()
{
    local int I, ZoneIndex;

    // End:0x119
    if(GoreSettings != none)
    {
        I = 0;
        J0x1A:

        // End:0x119 [Loop If]
        if(I < GoreSettings.GoreBreakableJoints.Length)
        {
            ZoneIndex = GetZoneIndexByBodyPart(GoreSettings.GoreBreakableJoints[I].Type);
            // End:0x10B
            if(ZoneIndex != -1)
            {
                HitZones[ZoneIndex].Health = GoreSettings.GoreBreakableJoints[I].Health;
            }
            I++;
            // [Loop Continue]
            goto J0x1A;
        }
    }
    //return;    
}

simulated function AddDefaultInventory()
{
    local class<Inventory> InvClass;
    local Inventory Inv;
    local bool HasSelectableWeapon;

    // End:0xBF
    foreach DefaultInventory(InvClass)
    {
        Inv = FindInventoryType(InvClass);
        // End:0x6D
        if(Inv == none)
        {
            Inv = CreateInventory(InvClass, Weapon != none);
        }
        // End:0xBE
        if((EvilWeap_Base(Inv) != none) && EvilWeap_Base(Inv).bSelectable)
        {
            HasSelectableWeapon = true;
        }        
    }    
    // End:0x11A
    if(IsPlayerPawn())
    {
        // End:0x101
        if((MeleeKickWeapClass != none) && MeleeKickWeap == none)
        {
            CreateInventory(MeleeKickWeapClass, true);
        }
        // End:0x11A
        if(!HasSelectableWeapon)
        {
            EquipHandsWeapon();
        }
    }
    super.AddDefaultInventory();
    //return;    
}

simulated function EquipHandsWeapon()
{
    SetCurrentWeaponClass(HandsClass, true);
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x4C
        case 'bQuickHidenWeapon':
            // End:0x3C
            if(bQuickHidenWeapon)
            {
                QuickHideCurrentWeapon(true);                
            }
            else
            {
                EndQuickHideCurrentWeapon(true);
            }
            // End:0x238
            break;
        // End:0x85
        case 'bQuickHidenLeftWeapon':
            // End:0x75
            if(bQuickHidenLeftWeapon)
            {
                QuickHideCurrentWeapon(true,, true);                
            }
            else
            {
                EndQuickHideCurrentWeapon(true,, true);
            }
            // End:0x238
            break;
        // End:0x9E
        case 'CurrentMeleeWeaponAttachmentClass':
            WeaponMeleeAttachmentChanged();
            // End:0x238
            break;
        // End:0xB7
        case 'CurrentThrowWeaponAttachmentClass':
            WeaponThrowAttachmentChanged();
            // End:0x238
            break;
        // End:0xD0
        case 'CurrentWeaponLeftAttachmentClass':
            WeaponLeftAttachmentChanged();
            // End:0x238
            break;
        // End:0xF3
        case 'bPuttingDownWeaponLeft':
            SetPuttingDownWeaponLeft(bPuttingDownWeaponLeft);
            // End:0x238
            break;
        // End:0x120
        case 'FlashLocationArray':
            FlashLocationArrayUpdated(Weapon, FlashLocationArray, true);
            // End:0x238
            break;
        // End:0x14D
        case 'FlashLocationArrayMelee':
            FlashLocationArrayUpdated(Weapon, FlashLocationArrayMelee, true, true);
            // End:0x238
            break;
        // End:0x170
        case 'ReplicatedPawnActionStruct':
            DoPawnActionFromStruct(ReplicatedPawnActionStruct, true);
            // End:0x238
            break;
        // End:0x189
        case 'KnockdownImpulse':
            ApplyKnockdownImpulse();
            // End:0x238
            break;
        // End:0x1A2
        case 'ReplicatedClothesInfo':
            DressUpClient();
            // End:0x238
            break;
        // End:0x1BB
        case 'ReplicatedHeadClothIndex':
            DressUpHead();
            // End:0x238
            break;
        // End:0x1D4
        case 'ReplicatedClothWeapon':
            EquipWeaponClient();
            // End:0x238
            break;
        // End:0x1ED
        case 'ReplicatedClothShield':
            EquipShieldClient();
            // End:0x238
            break;
        // End:0x206
        case 'ReplicatedLimbsInfo':
            OnLimbsInfoChanged();
            // End:0x238
            break;
        // End:0x21F
        case 'ReplicatedBoneToRagfollInfo':
            OnRagdollPositionChange();
            // End:0x238
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            // End:0x238
            break;
            break;
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local int I;
    local Vector BonePos;
    local Rotator BoneRot;
    local BoneRagdollInfo boneInfo;

    super(Actor).Tick(DeltaTime);
    // End:0x22
    if(MyEvilAI != none)
    {
    }
    UpdateMeshBoneControllers(DeltaTime);
    // End:0x34F
    if(((((int(Physics) == int(10)) && int(Role) == int(ROLE_Authority)) && IsAliveAndWell()) && int(WorldInfo.NetMode) != int(NM_Standalone)) && int(WorldInfo.NetMode) != int(NM_Client))
    {
        BoneToRagdollCounter++;
        // End:0x34F
        if(BoneToRagdollCounter > 1)
        {
            I = 0;
            J0xE9:

            // End:0x344 [Loop If]
            if(I < SynchronizedBonesIndexes.Length)
            {
                BonePos = Mesh.GetBoneLocation(Mesh.GetBoneName(SynchronizedBonesIndexes[I]));
                BoneRot = QuatToRotator(Mesh.GetBoneQuaternion(Mesh.GetBoneName(SynchronizedBonesIndexes[I])));
                boneInfo.px = BonePos.X;
                boneInfo.Py = BonePos.Y;
                boneInfo.pz = BonePos.Z;
                boneInfo.Pitch = BoneRot.Pitch;
                boneInfo.Roll = BoneRot.Roll;
                boneInfo.Yaw = BoneRot.Yaw;
                ReplicatedBoneToRagfollInfo[I] = boneInfo;
                I++;
                // [Loop Continue]
                goto J0xE9;
            }
            BoneToRagdollCounter = 0;
        }
    }
    // End:0x3B1
    if((int(PawnAction) != 0) && PawnActions[int(PawnAction)] != none)
    {
        PawnActions[int(PawnAction)].Tick(DeltaTime);
    }
    // End:0x3E0
    if(!Mesh.IsPlayingFaceFXAnim())
    {
        UpdateFaceFXEmotion();
    }
    // End:0x45D
    if(int(Role) == int(ROLE_Authority))
    {
        bInMoveLatent = (Controller != none) && Controller.InLatentExecution(503) || Controller.InLatentExecution(501);
    }
    ProcessMovementMode(DeltaTime);
    //return;    
}

function UpdateFaceFXEmotion(optional EvilTypesNative.EFaceFXEmotionSetType ForcedFaceFXEmotionSetType)
{
    local EvilFaceFXEmotionInfo FaceFXEmotionInfo;
    local int Index;

    // End:0x124
    if(int(ForcedFaceFXEmotionSetType) == int(0))
    {
        // End:0x121
        if(MyEvilAI != none)
        {
            // End:0x121
            if((!Mesh.IsPlayingFaceFXAnim() || int(GetFacialCompnentEmotionSetType()) == int(1)) && FaceFXEmotionAnimSetRef != none)
            {
                // End:0xEA
                if(((int(CurrentMoveMode) == int(0)) && int(PawnAction) == 0) && MyEvilAI.Enemy == none)
                {
                    AnimDefArchetype.GetFaceFXEmotionInfo(1, FaceFXEmotionInfo);                    
                }
                else
                {
                    // End:0x121
                    if(IsFiring())
                    {
                        AnimDefArchetype.GetFaceFXEmotionInfo(2, FaceFXEmotionInfo);
                    }
                }
            }
        }        
    }
    else
    {
        AnimDefArchetype.GetFaceFXEmotionInfo(ForcedFaceFXEmotionSetType, FaceFXEmotionInfo);
    }
    // End:0x267
    if(FaceFXEmotionInfo.FaceFXAnimInfoList.Length > 0)
    {
        Index = Rand(FaceFXEmotionInfo.FaceFXAnimInfoList.Length);
        // End:0x267
        if(Mesh.PlayFaceFXAnim(FaceFXEmotionAnimSetRef, FaceFXEmotionInfo.FaceFXAnimInfoList[Index].AnimName, FaceFXEmotionInfo.FaceFXAnimInfoList[Index].GroupName, none))
        {
            SetFacialComponentSoundSetType(0, FaceFXEmotionInfo.FaceFXEmotionSetType);
        }
    }
    //return;    
}

function UpdateMeshBoneControllers(float DeltaTime)
{
    //return;    
}

function OnAnimEndFromNotify()
{
    // End:0x3C
    if(int(PawnAction) != 0)
    {
        PawnActions[int(PawnAction)].OnAnimEndFromNotify();
    }
    //return;    
}

simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    // End:0x57
    if(int(PawnAction) != 0)
    {
        PawnActions[int(PawnAction)].OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    }
    //return;    
}

function bool SetGoal(Vector Loc)
{
    // End:0x27
    if(Goal != none)
    {
        Goal.Destroy();
    }
    Goal = Spawn(Class'EvilNavMeshGoal', none,, Loc,,, true);
    // End:0x63
    if(Goal != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ShouldPlayDodge()
{
    return ((WorldInfo.TimeSeconds > LastDodgeTime) && int(CoverType) == int(0)) && FRand() < DodgeChanceByDamage;
    //return ReturnValue;    
}

function bool ShouldPlayHitOnTopHalfOnly()
{
    return (VSizeSq2D(Velocity) > (((0.6700000 * GroundSpeed) * 0.6700000) * GroundSpeed)) && FRand() < 0.3000000;
    //return ReturnValue;    
}

function bool ShouldPlayFullBodyHit(class<DamageType> DamageType, optional Controller EventInstigator)
{
    return (WorldInfo.TimeSeconds > NextHitTime) && DamageType != Class'EvilDmgType_Fire';
    //return ReturnValue;    
}

function RecomputeNextHitTime()
{
    NextHitTime = WorldInfo.TimeSeconds + MinTimeBetweenHits;
    //return;    
}

function NotifyStartFullBodyHit()
{
    //return;    
}

function NotifyEndFullBodyHit()
{
    //return;    
}

function CreateHitDecalTexture()
{
    local MaterialInstanceConstant MIC;

    MaskTexture = Class'Engine.TextureRenderTarget2D'.static.Create(64, 64, 3, MakeLinearColor(0.0000000, 0.0000000, 0.0000000, 0.0000000));
    // End:0xB0
    if(MaskTexture != none)
    {
        HitMaskComponent = new Class'Engine.SceneCapture2DHitMaskComponent';
        AttachComponent(HitMaskComponent);
        HitMaskComponent.SetCaptureTargetTexture(MaskTexture);
    }
    MIC = GetSkeletalMeshComponent().CreateAndSetMaterialInstanceConstant(DecalMaterialIndex);
    // End:0x134
    if((MIC != none) && MaskTexture != none)
    {
        MIC.SetTextureParameterValue('FilterMask', MaskTexture);
    }
    //return;    
}

simulated function SpawnMeshDecal(Vector HitLocation)
{
    HitMaskComponent.SetCaptureParameters(HitLocation, HitDecalSize, HitLocation, false);
    //return;    
}

function ClothTakeDamage(out int Damage, EvilPawnClothAssetInterface clothAsset, class<DamageType> DamageType, Vector HitLocation, Vector Momentum)
{
    clothAsset.ReduceDamage(Damage, DamageType, HitLocation, Momentum);
    //return;    
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local Vector MoveDir;
    local float AngleDiff;

    AngleDiff = FindDeltaAngle(float(Rotator(HitNormal).Yaw) * 0.0000959, float(Rotation.Yaw) * 0.0000959);
    // End:0x9D
    if(Abs(AngleDiff) > (float(75) * 0.0174533))
    {
        TriggerEventClass(Class'Engine.SeqEvent_HitWall', Wall);        
    }
    else
    {
        // End:0x175
        if(AngleDiff < float(0))
        {
            MoveDir.X = Cos((float(Rotation.Yaw) * 0.0000959) + (float(90) * 0.0174533));
            MoveDir.Y = Sin((float(Rotation.Yaw) * 0.0000959) + (float(90) * 0.0174533));
            MoveDir.Z = 0.5000000;            
        }
        else
        {
            MoveDir.X = Cos((float(Rotation.Yaw) * 0.0000959) - (float(90) * 0.0174533));
            MoveDir.Y = Sin((float(Rotation.Yaw) * 0.0000959) - (float(90) * 0.0174533));
            MoveDir.Z = 0.5000000;
        }
        SetLocation(Location + (float(10) * MoveDir));
    }
    //return;    
}

function AdjustDamage(out int InDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    super.AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
    // End:0x61
    if(bIsInvulnerable)
    {
        InDamage = 0;
    }
    //return;    
}

function bool CanBeDamagedBy(Controller EventInstigator)
{
    // End:0x11
    if(MyEvilAI == none)
    {
        return true;
    }
    // End:0x40
    if(!MyEvilAI.IsFriendly(EventInstigator))
    {
        return true;
    }
    return bTakeFriendlyFire && (EvilAIController(EventInstigator) == none) || EvilAIController(EventInstigator).MyEvilPawn.bGiveFriendlyFire;
    //return ReturnValue;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local float DamageModifer;
    local EvilPawnClothAssetInterface clothAsset;
    local Pawn InstigatedByPawn;
    local class<EvilDmgType_Base> EvilDamageType;
    local HitZone Zone;
    local int I;
    local bool FoundZone;
    local EvilWeap_Base InstigatorWeap;

    InstigatedByPawn = ((EventInstigator != none) ? EventInstigator.Pawn : none);
    // End:0xDA
    if(((InstigatedByPawn != none) && InstigatedByPawn != self) && !CanBeDamagedBy(EventInstigator))
    {
        // End:0xD8
        if(InstigatedByPawn.IsPlayerOwned())
        {
            NotifyTakeHit(EventInstigator, HitLocation, Damage, DamageType, Momentum, DamageCauser);
        }
        return;
    }
    EvilDamageType = class<EvilDmgType_Base>(DamageType);
    DamageModifer = 1.0000000;
    // End:0x14E
    if(InstigatedByPawn != none)
    {
        CollectDamageLocations(InstigatedByPawn.Location, HitLocation, EvilDamageType);
    }
    // End:0x1D0
    if(WorldInfo.Game != none)
    {
        DamageModifer *= EvilGame(WorldInfo.Game).AIDirectorInstance.GetDamageInfluence(self);
    }
    CurrentHitInformation.Damage = int(float(Damage) * DamageModifer);
    CurrentHitInformation.EventInstigator = EventInstigator;
    CurrentHitInformation.HitLocation = HitLocation;
    CurrentHitInformation.Momentum = Momentum;
    CurrentDamageType = EvilDamageType;
    CurrentHitInformation.HitInfo = HitInfo;
    CurrentHitInformation.DamageCauser = DamageCauser;
    // End:0x345
    if(GoreSettings != none)
    {
        GoreSettings.GetClassification(EvilDamageType, CurrentHitInformation.DamageClassification, CurrentHitInformation.GibClassification);
    }
    clothAsset = EvilPawnClothAssetInterface(HitInfo.HitComponent);
    // End:0x3CB
    if(NotEqual_InterfaceInterface(clothAsset, EvilPawnClothAssetInterface(none)))
    {
        ClothTakeDamage(Damage, clothAsset, DamageType, HitLocation, Momentum);
    }
    // End:0x4C1
    if(CurrentHitInformation.DamageClassification.bIsValid && CurrentHitInformation.DamageClassification.bSpawnGibs)
    {
        Damage = TryDetachLimb(Damage, EvilDamageType, CurrentHitInformation.HitLocation, CurrentHitInformation.Momentum, CurrentHitInformation.HitInfo.BoneName);
    }
    // End:0x4E1
    if(EnableHitDecals)
    {
        SpawnMeshDecal(HitLocation);
    }
    // End:0x55D
    if((InstigatedByPawn != none) && EvilPawn(InstigatedByPawn) != none)
    {
        EvilPawn(InstigatedByPawn).DamagedSomeone(int(FClamp(float(Damage) * DamageModifer, 0.0000000, float(Health))), self);
    }
    Damage *= DamageModifer;
    // End:0x5A7
    if(class<EvilDmgType_InstantGib>(EvilDamageType) != none)
    {
        Damage = Max(Health * 2, 1000);
    }
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x63A
    if(EvilDamageType != none)
    {
        EvilDamageType.static.HandleDamagedPawn(self, InstigatedByPawn, Damage, Momentum);
    }
    // End:0x7F6
    if(((int(Physics) != int(10)) && HasValidDamage(Damage)) && !IsJumping())
    {
        // End:0x6BF
        if(bPotentiallyCanPlayKnockDown && CanBeKnockedDown())
        {
            Knockdown(vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000));            
        }
        else
        {
            // End:0x6E3
            if(CanDoPawnAction(32) && TryStartDodge(1))
            {                
            }
            else
            {
                // End:0x71E
                if(CanDoPawnAction(2) && ShouldPlayHitOnTopHalfOnly())
                {
                    ServerDoPawnAction(2,,, GetTopHalfHitAnimIndex());                    
                }
                else
                {
                    // End:0x7F6
                    if(CanDoPawnAction(1) && ShouldPlayFullBodyHit(DamageType, EventInstigator))
                    {
                        // End:0x798
                        if(!IsInCover())
                        {
                            ServerDoPawnAction(1,,, GetHitAnimIndex(EvilDamageType, EvilWeap_Melee_Base(DamageCauser) != none));                            
                        }
                        else
                        {
                            // End:0x7BF
                            if(CanFullBodyHitInCover())
                            {
                                ServerDoPawnAction(1,,, GetHitInCoverAnimIndex());
                            }
                        }
                        // End:0x7F6
                        if(MyEvilAI != none)
                        {
                            MyEvilAI.NotifyFullBodyHit(EventInstigator);
                        }
                    }
                }
            }
        }
    }
    // End:0x8E7
    if(EvilPlayerController(EventInstigator) != none)
    {
        EvilPlayerController(EventInstigator).GetComboManager().HandleEvent('Damage', self, HitLocation, DamageType, GetBodyPartByBone(HitInfo.BoneName), (EvilExplosionActor(DamageCauser) != none) && EvilExplosionActor(DamageCauser).ExplosionTemplate.HitActor == self);
    }
    // End:0x9B9
    if((((EventInstigator != none) && EventInstigator.Pawn != none) && EvilDamageType != none) && EvilDamageType.default.DamageWeaponClass != none)
    {
        InstigatorWeap = EvilWeap_Base(EventInstigator.Pawn.FindInventoryType(EvilDamageType.default.DamageWeaponClass, true));
    }
    // End:0xD13
    if(InstigatorWeap != none)
    {
        FoundZone = false;
        CheckHitInfo(HitInfo, Mesh, Momentum, HitLocation);
        // End:0xA8A
        foreach HitZones(Zone, I)
        {
            // End:0xA89
            if(Zone.ZoneBones.Find(HitInfo.BoneName) > -1)
            {
                LastHitZone = I;
                FoundZone = true;                
            }
            else
            {                
            }
        }        
        // End:0xAA9
        if(!FoundZone)
        {
            LastHitZone = -1;
        }
        // End:0xD13
        if(((EvilPlayerController(EventInstigator) != none) && EventInstigator.Pawn != self) && EvilPlayerReplicationInfo(EvilPlayerController(EventInstigator).PlayerReplicationInfo) != none)
        {
            // End:0xC29
            if(LastHitZone > -1)
            {
                EvilPlayerReplicationInfo(EvilPlayerController(EventInstigator).PlayerReplicationInfo).AddHit(HitZones[LastHitZone].BodyPart, ((InstigatorWeap.UsesOffhand) ? EvilInventoryManager(EventInstigator.Pawn.InvManager).FindOtherHandWeaponFor(InstigatorWeap) : InstigatorWeap));                
            }
            else
            {
                EvilPlayerReplicationInfo(EvilPlayerController(EventInstigator).PlayerReplicationInfo).AddHit(DefaultZone.BodyPart, ((InstigatorWeap.UsesOffhand) ? EvilInventoryManager(EventInstigator.Pawn.InvManager).FindOtherHandWeaponFor(InstigatorWeap) : InstigatorWeap));
            }
        }
    }
    //return;    
}

function bool HasValidDamage(int Damage, optional class<DamageType> DamageType)
{
    return Damage > 0;
    //return ReturnValue;    
}

function DamagedSomeone(int InDamage, Pawn InVictim)
{
    //return;    
}

simulated function LeaveABloodDecal(Vector HitLoc, Vector HitNorm)
{
    local Actor TraceActor;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

    local TraceHitInfo HitInfo;
    local MaterialInstanceTimeVarying MITV_Decal;

    TraceStart = HitLoc;
    HitNorm.Z = RandRange(-10.0000000, 0.0000000);
    TraceDest = HitLoc + (Normal(HitNorm) * float(150));
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, 2);
    // End:0x200
    if((TraceActor != none) && Pawn(TraceActor) == none)
    {
        MITV_Decal = new (Outer) Class'Engine.MaterialInstanceTimeVarying';
        MITV_Decal.SetParent(static.GetFamilyInfo().default.BloodSplatterDecalMaterial);
        WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, out_HitLocation, Rotator(-out_HitNormal), 100.0000000, 100.0000000, 50.0000000, false);
        MITV_Decal.SetScalarStartTime(Class'EvilGib'.default.DecalDissolveParamName, Class'EvilGib'.default.DecalWaitTimeBeforeDissolve);
    }
    //return;    
}

simulated function LeaveABloodDecalCustomMaterial(Vector HitLoc, Vector HitNorm, MaterialInstance InDecalMat)
{
    local Actor TraceActor;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

    local TraceHitInfo HitInfo;
    local MaterialInstanceTimeVarying MITV_Decal;

    TraceStart = HitLoc + (Normal(HitNorm) * float(50));
    TraceDest = HitLoc + (Normal(-HitNorm) * float(300));
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, 2 | 8);
    // End:0x1D5
    if((TraceActor != none) && Pawn(TraceActor) == none)
    {
        MITV_Decal = new (Outer) Class'Engine.MaterialInstanceTimeVarying';
        MITV_Decal.SetParent(InDecalMat);
        WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, out_HitLocation, Rotator(-out_HitNormal), 100.0000000, 100.0000000, 50.0000000, false);
        MITV_Decal.SetScalarStartTime(Class'EvilGib'.default.DecalDissolveParamName, Class'EvilGib'.default.DecalWaitTimeBeforeDissolve);
    }
    //return;    
}

simulated function DropDecals(const Vector HitLocation, optional bool bRandomDirection = true, optional bool bUnderHitDirection = true)
{
    local class<EvilFamilyInfoBase> FamilyInf;
    local class<EvilDmgType_Base> UTDamage;
    local EvilExplosionHelper bloodHelper;

    // End:0x1B
    if(!CanLeaveBloodDecals())
    {
        return;
    }
    UTDamage = class<EvilDmgType_Base>(LastTakeHitInfo.DamageType);
    FamilyInf = GetFamilyInfo();
    // End:0x1DC
    if(((((FamilyInf != none) && FamilyInf.default.BloodSplatterDecalMaterial != none) && UTDamage.default.bCausesBloodSplatterDecals) && !IsZero(LastTakeHitInfo.Momentum)) && !Class'EvilGame'.static.UseLowGore(WorldInfo))
    {
        // End:0x1DC
        if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            bloodHelper = Spawn(Class'EvilExplosionHelper');
            // End:0x195
            if(bRandomDirection)
            {
                bloodHelper.ThrowRandomBloodDecals(HitLocation, 3, 75.0000000);
            }
            // End:0x1D1
            if(bUnderHitDirection)
            {
                bloodHelper.ThrowBloodDecalsUnderHitLocation(HitLocation, 1, 100.0000000);
            }
            bloodHelper = none;
        }
    }
    //return;    
}

simulated function PlayTakeHitEffects()
{
    local class<EvilDmgType_Base> UTDamage;

    // End:0xBD
    if(EffectIsRelevant(Location, false))
    {
        UTDamage = class<EvilDmgType_Base>(LastTakeHitInfo.DamageType);
        // End:0xBD
        if(UTDamage != none)
        {
            // End:0x95
            if(ClassIsChildOf(UTDamage, Class'EvilDmgType_Melee'))
            {
                PlayMeleeImpacts(LastTakeHitInfo.HitLocation);
            }
            DropDecals(LastTakeHitInfo.HitLocation);
        }
    }
    //return;    
}

simulated function PlayMeleeImpacts(Vector HitLocation)
{
    local int I;
    local Vector Dir, Position;
    local Emitter ExplosionEmitter;
    local editinline ParticleSystemComponent EffectPSC;
    local name BoneName;

    // End:0x23
    if((MeleeHitParticles.Length == 0) || !bShouldPlayMeleeImpacts)
    {
        return;
    }
    Dir = Normal(HitLocation - Location);
    switch(Rand(3))
    {
        // End:0x6B
        case 0:
            BoneName = 'LeftArm';
            // End:0xB6
            break;
        // End:0x85
        case 1:
            BoneName = 'RightArm';
            // End:0xB6
            break;
        // End:0xA0
        case 2:
            BoneName = 'Head';
            // End:0xB6
            break;
        // End:0xFFFF
        default:
            BoneName = 'Hips';
            break;
    }
    I = Rand(MeleeHitParticles.Length);
    Position = Mesh.GetBoneLocation(BoneName);
    // End:0x2A1
    if(MeleeHitParticles[I].bAttachToBone)
    {
        EffectPSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(MeleeHitParticles[I].Particle);
        EffectPSC.SetRotation(Rotator(Dir));
        EffectPSC.SetScale(RandRange(MeleeHitParticles[I].MinScale, MeleeHitParticles[I].MaxScale));
        Mesh.AttachComponent(EffectPSC, BoneName);
        EffectPSC.ActivateSystem();        
    }
    else
    {
        ExplosionEmitter = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactEmitter(MeleeHitParticles[I].Particle, Position, Rotator(Dir));
        ExplosionEmitter.SetDrawScale(RandRange(MeleeHitParticles[I].MinScale, MeleeHitParticles[I].MaxScale));
        ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
    }
    //return;    
}

function EvilTypes.EHitDirectionType GetDirection(const out Vector Dir, const out Vector LookDir)
{
    local float DotFront, DotRight;
    local Vector HitNormal, RightDir;

    HitNormal = -1.0000000 * Dir;
    HitNormal.Z = 0.0000000;
    HitNormal = Normal(HitNormal);
    RightDir = vect(0.0000000, 0.0000000, 1.0000000) Cross LookDir;
    DotFront = HitNormal Dot LookDir;
    DotRight = HitNormal Dot RightDir;
    // End:0xE3
    if(Abs(DotFront) > Abs(DotRight))
    {
        // End:0xE0
        if(DotFront > 0.0000000)
        {
            return 1;
        }
        return 2;
    }
    // End:0xF9
    if(DotRight > 0.0000000)
    {
        return 4;
    }
    return 3;
    //return ReturnValue;    
}

function EvilTypes.EHitDirectionType GetHitDirection()
{
    local Vector ShotDir, Rot;

    // End:0x25
    if(CurrentHitInformation.EventInstigator == none)
    {
        return 2;
    }
    ShotDir = ((IsZero(CurrentHitInformation.Momentum)) ? Normal(CurrentHitInformation.EventInstigator.Pawn.Location - CurrentHitInformation.HitLocation) : Normal(CurrentHitInformation.Momentum));
    Rot = Vector(Rotation);
    return GetDirection(ShotDir, Rot);
    //return ReturnValue;    
}

function int GetHitInCoverAnimIndex(optional bool bKickHit = false)
{
    local EvilTypesNative.EAnimationSetType AST;

    switch(CoverType)
    {
        // End:0x48
        case 2:
            // End:0x39
            if(bIsMirrored)
            {
                AST = 27;                
            }
            else
            {
                AST = 28;
            }
            // End:0x7B
            break;
        // End:0x78
        case 1:
            // End:0x69
            if(bIsMirrored)
            {
                AST = 29;                
            }
            else
            {
                AST = 30;
            }
            // End:0x7B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function EvilTypesNative.EAnimationSetType TryGetHitAnimIndexPerBallisticType(EvilTypes.EHitDirectionType HitDirectionID, EvilTypes.EBodyParts BP, class<EvilDmgType_Base> EvilDamageType)
{
    return 0;
    //return ReturnValue;    
}

function int GetHitAnimIndex(class<EvilDmgType_Base> EvilDamageType, optional bool bKickHit = false)
{
    local EvilTypes.EBodyParts BP;
    local EvilTypes.EHitDirectionType HitDirectionID;
    local EvilTypesNative.EAnimationSetType AST;
    local name CurrentFullBodySlotAnim;
    local int Index, ZoneIndex;

    HitDirectionID = GetHitDirection();
    // End:0x108
    if((FullBodyAnimSlot != none) && FullBodyAnimSlot.GetCustomAnimNodeSeq() != none)
    {
        CurrentFullBodySlotAnim = FullBodyAnimSlot.GetCustomAnimNodeSeq().AnimSeqName;
        Index = 0;
        J0x98:

        // End:0x108 [Loop If]
        if(Index < AnimNamesToSpecialHitReactionIndexes.Length)
        {
            // End:0xFA
            if(AnimNamesToSpecialHitReactionIndexes[Index].AnimName == CurrentFullBodySlotAnim)
            {
                return PackAnimInfo(105, Index);
            }
            Index++;
            // [Loop Continue]
            goto J0x98;
        }
    }
    // End:0x3AF
    if(CurrentHitInformation.HitInfo.BoneName != 'None')
    {
        Index = 0;
        J0x150:

        // End:0x1E6 [Loop If]
        if(Index < BoneNamesToSpecialHitReactionIndexes.Length)
        {
            // End:0x1D8
            if(CurrentHitInformation.HitInfo.BoneName == BoneNamesToSpecialHitReactionIndexes[Index].BoneName)
            {
                return PackAnimInfo(106, Index);
            }
            Index++;
            // [Loop Continue]
            goto J0x150;
        }
        ZoneIndex = GetZoneIndex(CurrentHitInformation.HitInfo.BoneName);
        // End:0x3AF
        if(ZoneIndex != -1)
        {
            BP = HitZones[ZoneIndex].BodyPart;
            AST = TryGetHitAnimIndexPerBallisticType(HitDirectionID, BP, EvilDamageType);
            // End:0x2DE
            if((int(AST) != int(0)) && (AST_GetAnimCount(AST)) > 0)
            {
                return PackRandomAnimInfo(AST);
            }
            switch(BP)
            {
                // End:0x305
                case 0:
                    AST = 16;
                    // End:0x36C
                    break;
                // End:0x319
                case 1:
                    AST = 17;
                    // End:0x36C
                    break;
                // End:0x32D
                case 2:
                    AST = 18;
                    // End:0x36C
                    break;
                // End:0x341
                case 3:
                    AST = 19;
                    // End:0x36C
                    break;
                // End:0x355
                case 4:
                    AST = 20;
                    // End:0x36C
                    break;
                // End:0x369
                case 5:
                    AST = 21;
                    // End:0x36C
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x3AF
            if((int(AST) != int(0)) && (AST_GetAnimCount(AST)) > 0)
            {
                return PackRandomAnimInfo(AST);
            }
        }
    }
    AST = ((bKickHit) ? 31 : 22);
    switch(HitDirectionID)
    {
        // End:0x404
        case 1:
            AST = ((bKickHit) ? 35 : 23);
            // End:0x476
            break;
        // End:0x429
        case 2:
            AST = ((bKickHit) ? 34 : 24);
            // End:0x476
            break;
        // End:0x44E
        case 3:
            AST = ((bKickHit) ? 32 : 25);
            // End:0x476
            break;
        // End:0x473
        case 4:
            AST = ((bKickHit) ? 33 : 26);
            // End:0x476
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x4C3
    if((bKickHit && int(AST) != int(31)) && (AST_GetAnimCount(AST)) < 1)
    {
        AST = 31;        
    }
    else
    {
        // End:0x4FE
        if((int(AST) != int(22)) && (AST_GetAnimCount(AST)) < 1)
        {
            AST = 22;
        }
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function int GetTopHalfHitAnimIndex()
{
    return PackRandomAnimInfo(36);
    //return ReturnValue;    
}

function bool CanFastSpinUp()
{
    return false;
    //return ReturnValue;    
}

function int GetPackedSpinUpAnimInfoByYaw(int InYawDelta)
{
    local EvilTypes.ESpinUpSide SpinUpSide;

    // End:0x22
    if(InYawDelta > 26000)
    {
        SpinUpSide = 3;        
    }
    else
    {
        // End:0x44
        if(InYawDelta < -26000)
        {
            SpinUpSide = 2;            
        }
        else
        {
            // End:0x66
            if(InYawDelta > 12000)
            {
                SpinUpSide = 5;                
            }
            else
            {
                // End:0x88
                if(InYawDelta < -12000)
                {
                    SpinUpSide = 4;                    
                }
                else
                {
                    SpinUpSide = 1;
                }
            }
        }
    }
    return GetPackedSpinUpAnimInfoBySide(SpinUpSide);
    //return ReturnValue;    
}

function int GetPackedSpinUpAnimInfoBySide(EvilTypes.ESpinUpSide SpinUpSide)
{
    local EvilTypesNative.EAnimationSetType AST;

    switch(SpinUpSide)
    {
        // End:0x48
        case 3:
            // End:0x39
            if((AST_GetAnimCount(78)) > 0)
            {
                AST = 78;                
            }
            else
            {
                AST = 76;
            }
            // End:0xCB
            break;
        // End:0x7D
        case 2:
            // End:0x6E
            if((AST_GetAnimCount(77)) > 0)
            {
                AST = 77;                
            }
            else
            {
                AST = 76;
            }
            // End:0xCB
            break;
        // End:0x91
        case 4:
            AST = 75;
            // End:0xCB
            break;
        // End:0xA5
        case 5:
            AST = 74;
            // End:0xCB
            break;
        // End:0xB9
        case 1:
            AST = 73;
            // End:0xCB
            break;
        // End:0xFFFF
        default:
            AST = 73;
            // End:0xCB
            break;
            break;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function int GetPackedRecognizeAnimInfoBySide(EvilTypes.ESpinUpSide SpinUpSide)
{
    local EvilTypesNative.EAnimationSetType AST;

    switch(SpinUpSide)
    {
        // End:0x48
        case 3:
            // End:0x39
            if((AST_GetAnimCount(85)) > 0)
            {
                AST = 85;                
            }
            else
            {
                AST = 83;
            }
            // End:0xCB
            break;
        // End:0x7D
        case 2:
            // End:0x6E
            if((AST_GetAnimCount(84)) > 0)
            {
                AST = 84;                
            }
            else
            {
                AST = 83;
            }
            // End:0xCB
            break;
        // End:0x91
        case 4:
            AST = 82;
            // End:0xCB
            break;
        // End:0xA5
        case 5:
            AST = 81;
            // End:0xCB
            break;
        // End:0xB9
        case 1:
            AST = 80;
            // End:0xCB
            break;
        // End:0xFFFF
        default:
            AST = 80;
            // End:0xCB
            break;
            break;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function int PackRandomAnimInfo(EvilTypesNative.EAnimationSetType AST)
{
    return Class'EvilPawn'.static.PackAnimInfo(AST, AST_GetRandomAnimIndex(AST));
    //return ReturnValue;    
}

static function int PackAnimInfo(EvilTypesNative.EAnimationSetType AST, int Index)
{
    return (Index & 16777215) | (int(AST) << int(24));
    //return ReturnValue;    
}

static function UnpackAnimInfo(int PAFlags, out EvilTypesNative.EAnimationSetType AST, out int Index)
{
    AST = byte(PAFlags >> 24);
    Index = PAFlags & 16777215;
    //return;    
}

private final function EvilTypesNative.EAnimationSetType GetDefaultAnimIndex(class<EvilDmgType_Base> DamageType, Vector HitLoc, EvilTypes.EHitDirectionType HitDir)
{
    local EvilTypesNative.EAnimationSetType AST;

    AST = 1;
    switch(HitDir)
    {
        // End:0x44
        case 1:
            AST = ((IsRunning()) ? 11 : 7);
            // End:0xD3
            break;
        // End:0x69
        case 2:
            AST = ((IsRunning()) ? 12 : 8);
            // End:0xD3
            break;
        // End:0x8E
        case 3:
            AST = ((IsRunning()) ? 13 : 9);
            // End:0xD3
            break;
        // End:0xB3
        case 4:
            AST = ((IsRunning()) ? 14 : 10);
            // End:0xD3
            break;
        // End:0xFFFF
        default:
            AST = ((IsRunning()) ? 2 : 1);
            break;
    }
    return AST;
    //return ReturnValue;    
}

function int GetDeathAnimIndex(class<EvilDmgType_Base> DamageType, Vector HitLoc)
{
    local EvilTypes.EHitDirectionType HitDirectionID;
    local EvilTypesNative.EAnimationSetType AST, DefaultAST;
    local bool bKnockBack;

    // End:0x9E
    if(CurrentHitInformation.EventInstigator.Pawn != none)
    {
        bKnockBack = VSize(CurrentHitInformation.EventInstigator.Pawn.Location - Location) < float(300);
    }
    HitDirectionID = GetHitDirection();
    AST = GetDefaultAnimIndex(DamageType, HitLoc, HitDirectionID);
    DefaultAST = AST;
    // End:0x193
    if(bKnockBack)
    {
        switch(HitDirectionID)
        {
            // End:0x128
            case 1:
                AST = 3;
                // End:0x167
                break;
            // End:0x13C
            case 2:
                AST = 4;
                // End:0x167
                break;
            // End:0x150
            case 3:
                AST = 5;
                // End:0x167
                break;
            // End:0x164
            case 4:
                AST = 6;
                // End:0x167
                break;
            // End:0xFFFF
            default:
                break;
        }
        // End:0x193
        if((AST_GetAnimCount(AST)) < 1)
        {
            AST = DefaultAST;
        }
    }
    // End:0x1CE
    if((int(AST) != int(1)) && (AST_GetAnimCount(AST)) < 1)
    {
        AST = 1;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function int GetKickAnimIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    AST = 40;
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function int GetMeleeAnimIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x32
    if((CurrentWeaponAttachment != none) && (AST_GetAnimCount(39)) > 0)
    {
        AST = 39;        
    }
    else
    {
        AST = 38;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function RequestFastSpinUp(optional int InYawDelta, optional bool InWithoutRotating, optional bool InWithoutBlendFromMovingToIdle)
{
    bFastSpinUp = true;
    // End:0x42
    if(InWithoutRotating)
    {
        PackedFastSpinUpAnimInfo = PackAnimInfo(79, AST_GetRandomAnimIndex(79));        
    }
    else
    {
        PackedFastSpinUpAnimInfo = GetPackedSpinUpAnimInfoByYaw(InYawDelta);
    }
    //return;    
}

function bool CanSlowDown(EvilAICmd_MoveToGoal MTG)
{
    return false;
    //return ReturnValue;    
}

function RequestSlowDown()
{
    local AnimNodeSequence Seq;
    local Vector FocalPoint;

    Seq = AnimNodeSequence(MoveModeNode.Children[4].Anim);
    ReadyToRunInterval = (Seq.Rate * Mesh.GetAnimLength(Seq.AnimSeqName)) - MoveModeNode.BlendTime;
    bForceMoveMode = true;
    MoveModeToEnforce = 4;
    FocalPoint = MyEvilAI.GetFocalPoint();
    MyEvilAI.SetFocalPoint(FocalPoint + (1024.0000000 * Normal(FocalPoint - Location)));
    MyEvilAI.Focus = none;
    //return;    
}

function SetFastSpinUp(int InFastSpinUpAnimIndex)
{
    bFastSpinUp = true;
    PackedFastSpinUpAnimInfo = PackAnimInfo(73, InFastSpinUpAnimIndex);
    //return;    
}

function int GetThrowAnimIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0xFA
    if((int(CoverType) != int(0)) && !bMovingToCover)
    {
        switch(CoverType)
        {
            // End:0xAE
            case 2:
                switch(CoverAction)
                {
                    // End:0x64
                    case 3:
                        AST = 44;
                        // End:0xAB
                        break;
                    // End:0x78
                    case 4:
                        AST = 45;
                        // End:0xAB
                        break;
                    // End:0xA8
                    case 5:
                        // End:0x99
                        if(bWantsToBeMirrored)
                        {
                            AST = 46;                            
                        }
                        else
                        {
                            AST = 47;
                        }
                        // End:0xAB
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                // End:0xF7
                break;
            // End:0xF4
            case 1:
                switch(CoverAction)
                {
                    // End:0xDA
                    case 3:
                        AST = 48;
                        // End:0xF1
                        break;
                    // End:0xEE
                    case 4:
                        AST = 49;
                        // End:0xF1
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                // End:0xF7
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        AST = 43;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function int GetRun2CoverStartAnimPackedIndex()
{
    //return ReturnValue;    
}

function int GetRun2CoverLoopAnimPackedIndex()
{
    //return ReturnValue;    
}

function int GetRun2CoverStopAnimPackedIndex()
{
    //return ReturnValue;    
}

function int GetChargeAnimIndex()
{
    return PackRandomAnimInfo(41);
    //return ReturnValue;    
}

function int GetFarAttackPreparePackedIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    AST = 121;
    // End:0x27
    if((AST_GetAnimCount(AST)) < 1)
    {
        return 0;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function int GetScreamPackedIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    AST = 86;
    // End:0x27
    if((AST_GetAnimCount(AST)) < 1)
    {
        return 0;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function int GetShootAnimPackedIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x53
    if(EvilWeap_Base(Weapon) != none)
    {
        AST = ((EvilWeap_Base(Weapon).bFastRepeater) ? 54 : 58);
    }
    // End:0x6E
    if((AST_GetAnimCount(AST)) < 1)
    {
        return 0;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function int GetReloadAnimPackedIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0xDD
    if(EvilWeap_Base(Weapon) != none)
    {
        AST = ((EvilWeap_Base(Weapon).bFastRepeater) ? 55 : 59);
        // End:0xDD
        if(int(CoverType) != int(0))
        {
            switch(AST)
            {
                // End:0xAA
                case 55:
                    // End:0x9B
                    if(bIsMirrored)
                    {
                        AST = 56;                        
                    }
                    else
                    {
                        AST = 57;
                    }
                    // End:0xDD
                    break;
                // End:0xDA
                case 59:
                    // End:0xCB
                    if(bIsMirrored)
                    {
                        AST = 60;                        
                    }
                    else
                    {
                        AST = 61;
                    }
                    // End:0xDD
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x0DD! */
        return PackRandomAnimInfo(AST);
        //return ReturnValue;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x000! */
}

function int GetAimAnimIndex(optional bool bInAimToThrow)
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x1D
    if(bInAimToThrow)
    {
        AST = 53;        
    }
    else
    {
        // End:0x70
        if(EvilWeap_Base(Weapon) != none)
        {
            AST = ((EvilWeap_Base(Weapon).bFastRepeater) ? 51 : 52);
        }
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function Vector GetAimOffsetOrigin()
{
    return GetWeaponStartTraceLocation();
    //return ReturnValue;    
}

function int GetLayAnimation(EvilTypes.ELayFirstFrameAnimation _type)
{
    WakeInformation.LayAnimID = _type;
    return int(_type);
    return -1;
    //return ReturnValue;    
}

function int GetWakeAnimation(EvilTypes.ELayFirstFrameAnimation _type, optional bool bRandom = false)
{
    // End:0x1BA
    if((WakeAnims.Length > int(_type)) && WakeAnims[int(_type)].AnimNames.Length > 0)
    {
        // End:0x131
        if(bRandom)
        {
            WakeInformation.WakeAnimIndex = byte(Rand(WakeAnims[int(_type)].AnimNames.Length));
            // End:0x12E
            if(WakeAnims[int(_type)].AnimNames[int(WakeInformation.WakeAnimIndex)].AnimName != 'None')
            {
                return int(WakeInformation.WakeAnimIndex);
            }            
        }
        else
        {
            WakeInformation.WakeAnimIndex = 0;
            // End:0x1BA
            if(WakeAnims[int(_type)].AnimNames[int(WakeInformation.WakeAnimIndex)].AnimName != 'None')
            {
                return 0;
            }
        }
    }
    return -1;
    //return ReturnValue;    
}

function int GetSpawnAnimation(EvilTypes.ESpawnAnimation _type)
{
    return int(_type);
    return -1;
    //return ReturnValue;    
}

function bool CanFullBodyHitInCover()
{
    local bool bResult;

    // End:0x9E
    if(int(CoverAction) == int(0))
    {
        switch(CoverType)
        {
            // End:0x61
            case 2:
                // End:0x5E
                if(((AST_GetAnimCount(27)) > 0) && (AST_GetAnimCount(28)) > 0)
                {
                    bResult = true;
                }
                // End:0x9E
                break;
            // End:0x9B
            case 1:
                // End:0x98
                if(((AST_GetAnimCount(29)) > 0) && (AST_GetAnimCount(30)) > 0)
                {
                    bResult = true;
                }
                // End:0x9E
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return bResult;
        //return ReturnValue;        
    }
}

function bool CanEngageMelee()
{
    return (AST_GetAnimCount(38)) > 0;
    //return ReturnValue;    
}

function bool CanEngageCharge()
{
    return ((AST_GetAnimCount(41)) > 0) && !bIsWalking;
    //return ReturnValue;    
}

function bool CanAim()
{
    // End:0x70
    if(EvilWeap_Base(Weapon) != none)
    {
        return (int(CoverType) == int(0)) && (AST_GetAnimCount(((EvilWeap_Base(Weapon).bFastRepeater) ? 51 : 52))) > 0;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool CanThrowGrenade()
{
    return bCanThrowGrenade;
    //return ReturnValue;    
}

function bool CanLongDistanceCharge()
{
    return bCanLongDistanceCharge;
    //return ReturnValue;    
}

function bool CanStrafe(Vector Point)
{
    return bCanStrafe;
    //return ReturnValue;    
}

event bool IsStrafing()
{
    return bStrafing;
    //return ReturnValue;    
}

simulated function bool TryStartDodge(EvilTypes.EDodgeType DodgeType)
{
    local bool bDodgeFindFailed;
    local EvilTypesNative.EAnimationSetType ASTType;

    // End:0x11
    if(!ShouldPlayDodge())
    {
        return false;
    }
    bDodgeFindFailed = false;
    // End:0x40
    if(int(DodgeType) == int(0))
    {
        ASTType = 89;        
    }
    else
    {
        switch(CurrentMoveMode)
        {
            // End:0x67
            case 0:
                ASTType = 90;
                // End:0xB4
                break;
            // End:0x8C
            case 1:
                ASTType = ((bShouldWalkFast) ? 91 : 90);
                // End:0xB4
                break;
            // End:0x91
            case 2:
            // End:0xA5
            case 3:
                ASTType = 92;
                // End:0xB4
                break;
            // End:0xFFFF
            default:
                bDodgeFindFailed = true;
                break;
        }
    }
    // End:0x116
    if(((AST_GetAnimCount(ASTType)) > 0) && !bDodgeFindFailed)
    {
        ServerDoPawnAction(32,,, PackAnimInfo(ASTType, AST_GetRandomAnimIndex(ASTType)));
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function StopAim()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStopAim();
    }
    //return;    
}

simulated function StartShootAttack()
{
    //return;    
}

simulated function StopShootAttack()
{
    //return;    
}

simulated function StartReload()
{
    //return;    
}

simulated function StartEquipWeapon()
{
    //return;    
}

simulated function StartHideWeapon()
{
    //return;    
}

simulated function StartThrowAttack()
{
    ServerDoPawnAction(9,,, GetThrowAnimIndex());
    //return;    
}

function StartMeleeAttack()
{
    PlayMeleeAttackVoice();
    ServerDoPawnAction(5,,, GetMeleeAnimIndex());
    //return;    
}

function StartChargeAttack()
{
    ServerDoPawnAction(7,, EvilPawn(MyEvilAI.Enemy), GetChargeAnimIndex());
    //return;    
}

simulated function StartAim()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStartAim();
    }
    ServerDoPawnAction(10,,, GetAimAnimIndex());
    //return;    
}

simulated function StartAimToThrow()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStartThrow();
    }
    ServerDoPawnAction(10,,, GetAimAnimIndex(true));
    //return;    
}

simulated function StartFire(byte FireModeNum)
{
    local bool UsingGamepad;
    local EvilPlayerController PC;

    PC = EvilPlayerController(Controller);
    // End:0x75
    if((PC != none) && PC.GetComboManager().HandleEvent('StartFire', none))
    {
        return;
    }
    // End:0xC3
    if(PC != none)
    {
        UsingGamepad = PC.PlayerInput.bUsingGamepad;
    }
    // End:0xD2
    if(bNoWeaponFiring)
    {
        return;
    }
    // End:0x1B6
    if((((((int(FireModeNum) == int(0)) && !UsingGamepad) || (int(FireModeNum) == int(1)) && UsingGamepad) && EvilWeap_Base(WeaponLeft) != none) && !EvilWeap_Base(WeaponLeft).OffHandDoesNotFire) && EvilWeap_Base(WeaponLeft).SeperateOffHandFiring)
    {
        WeaponLeft.StartFire(0);        
    }
    else
    {
        // End:0x43A
        if(Weapon != none)
        {
            // End:0x2BD
            if((((EvilWeap_Base(WeaponLeft) != none) && !EvilWeap_Base(WeaponLeft).OffHandDoesNotFire) && !EvilWeap_Base(WeaponLeft).SeperateOffHandFiring) && int(FireModeNum) == int(0))
            {
                // End:0x282
                if(DualWieldRightLastShot)
                {
                    WeaponLeft.StartFire(0);                    
                }
                else
                {
                    Weapon.StartFire(0);
                }
                DualWieldRightLastShot = !DualWieldRightLastShot;                
            }
            else
            {
                Weapon.StartFire(((((EvilWeap_Base(WeaponLeft) != none) && !EvilWeap_Base(WeaponLeft).OffHandDoesNotFire) && EvilWeap_Base(WeaponLeft).SeperateOffHandFiring) ? 0 : FireModeNum));
            }
            // End:0x43A
            if((AimBlendNode != none) && (AimBlendNode.Child2WeightTarget == 1.0000000) != (PC.DesiredFOV < PC.DefaultFOV))
            {
                AimBlendNode.SetBlendTarget(float(PC.DesiredFOV < PC.DefaultFOV), 0.2000000);
            }
        }
    }
    //return;    
}

simulated function StopFire(byte FireModeNum)
{
    local bool UsingGamepad;

    // End:0x60
    if(EvilPlayerController(Controller) != none)
    {
        UsingGamepad = EvilPlayerController(Controller).PlayerInput.bUsingGamepad;
    }
    // End:0x144
    if((((int(FireModeNum) == int(0)) && !UsingGamepad) || (int(FireModeNum) == int(1)) && UsingGamepad) && ((EvilWeap_Base(WeaponLeft) != none) && !EvilWeap_Base(WeaponLeft).OffHandDoesNotFire) && EvilWeap_Base(WeaponLeft).SeperateOffHandFiring)
    {
        WeaponLeft.StopFire(0);        
    }
    else
    {
        // End:0x28A
        if(Weapon != none)
        {
            Weapon.StopFire(((((EvilWeap_Base(WeaponLeft) != none) && !EvilWeap_Base(WeaponLeft).OffHandDoesNotFire) && EvilWeap_Base(WeaponLeft).SeperateOffHandFiring) ? 0 : FireModeNum));
            // End:0x28A
            if(((EvilWeap_Base(WeaponLeft) != none) && !EvilWeap_Base(WeaponLeft).OffHandDoesNotFire) && !EvilWeap_Base(WeaponLeft).SeperateOffHandFiring)
            {
                WeaponLeft.StopFire(0);
            }
        }
    }
    //return;    
}

function bool StopWeaponFiring()
{
    local int I;
    local EvilWeap_Base WeapLeft;

    WeapLeft = EvilWeap_Base(WeaponLeft);
    // End:0xAF
    if(WeapLeft != none)
    {
        WeapLeft.ClientEndFire(0);
        WeapLeft.ClientEndFire(1);
        WeapLeft.ServerStopFire(0);
        WeapLeft.ServerStopFire(1);
    }
    // End:0x172
    if(EvilInvManager != none)
    {
        I = 0;
        J0xC9:

        // End:0x172 [Loop If]
        if(I < EvilInvManager.GetPendingFireLength(WeaponLeft))
        {
            // End:0x164
            if(EvilInvManager.IsPendingFire(WeaponLeft, I))
            {
                EvilInvManager.ClearPendingFire(WeaponLeft, I);
            }
            I++;
            // [Loop Continue]
            goto J0xC9;
        }
    }
    return super.StopWeaponFiring();
    //return ReturnValue;    
}

simulated function bool DualWieldRefireNotify(EvilWeap_Base Weap)
{
    // End:0xF5
    if((WeaponLeft != none) && Weapon != none)
    {
        // End:0x8C
        if((Weap == Weapon) && !EvilWeap_Base(WeaponLeft).SeperateOffHandFiring)
        {
            WeaponLeft.StartFire(0);
            return true;            
        }
        else
        {
            // End:0xF5
            if((Weap == WeaponLeft) && !EvilWeap_Base(WeaponLeft).SeperateOffHandFiring)
            {
                Weapon.StartFire(0);
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function ModifyGameIntensity(out float Intensity)
{
    local float Modifier;

    // End:0x11
    if(Health <= 0)
    {
        return;
    }
    Modifier = 1.0000000;
    // End:0x59
    if(MyEvilAI != none)
    {
        Modifier *= MyEvilAI.ModifyGameIntensity();
    }
    Intensity += (GameIntesityFactor * Modifier);
    //return;    
}

function HandleStamina()
{
    Stamina = 1.0000000;
    //return;    
}

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    super(Actor).PhysicsVolumeChange(NewVolume);
    //return;    
}

function RollbackSpeedModifier()
{
    ChangeSpeedModifier(SavedMovementSpeedModifier);
    //return;    
}

function ChangeSpeedModifier(float InNewSpeedModifier)
{
    NewMovementSpeedModifier = InNewSpeedModifier;
    SavedMovementSpeedModifier = MovementSpeedModifier;
    // End:0x52
    if(!IsTimerActive('UpdateSpeedMovementModifier'))
    {
        SetTimer(0.0100000, false, 'UpdateSpeedMovementModifier');
    }
    //return;    
}

function UpdateSpeedMovementModifier()
{
    // End:0x59
    if(Abs(MovementSpeedModifier - NewMovementSpeedModifier) > 0.0100000)
    {
        MovementSpeedModifier = Lerp(MovementSpeedModifier, NewMovementSpeedModifier, 0.1000000);
        SetTimer(0.0100000, false, 'UpdateSpeedMovementModifier');        
    }
    else
    {
        MovementSpeedModifier = NewMovementSpeedModifier;
    }
    //return;    
}

simulated function bool CanModifyMovementSpeed()
{
    local EvilWalkingVolume WV;

    // End:0x66
    foreach TouchingActors(Class'EvilWalkingVolume', WV)
    {
        // End:0x65
        if(WV.bEnabled && WV.MoveSpeedModifier > float(0))
        {            
            return false;
        }        
    }    
    return true;
    //return ReturnValue;    
}

function SetSprint(bool SprintState)
{
    // End:0x20
    if(SprintState && !CanSprint())
    {
        return;
    }
    // End:0xBD
    if(SprintState && (EvilWeap_Base(Weapon) != none) && EvilWeap_Base(Weapon).IsFrozen && (EvilWeap_Base(WeaponLeft) != none) && EvilWeap_Base(WeaponLeft).IsFrozen)
    {
        return;
    }
    // End:0x1DA
    if((EvilWeap_Base(Weapon) != none) && int(EvilWeap_Base(Weapon).ZoomedFireModeNum) < int(255))
    {
        EvilWeap_Base(Weapon).EndZoom(EvilPlayerController(Controller));
        // End:0x1B0
        if(int(EvilWeap_Base(Weapon).Role) < int(ROLE_Authority))
        {
            EvilWeap_Base(Weapon).ServerEndZoom(EvilPlayerController(Controller));
        }
        EvilWeap_Base(Weapon).ZoomedFireModeNum = 255;
    }
    // End:0x2F7
    if((EvilWeap_Base(WeaponLeft) != none) && int(EvilWeap_Base(WeaponLeft).ZoomedFireModeNum) < int(255))
    {
        EvilWeap_Base(WeaponLeft).EndZoom(EvilPlayerController(Controller));
        // End:0x2CD
        if(int(EvilWeap_Base(WeaponLeft).Role) < int(ROLE_Authority))
        {
            EvilWeap_Base(WeaponLeft).ServerEndZoom(EvilPlayerController(Controller));
        }
        EvilWeap_Base(WeaponLeft).ZoomedFireModeNum = 255;
    }
    IsSprinting = SprintState;
    // End:0x32F
    if(SprintState)
    {
        ChangeSpeedModifier(SprintSpeedModifier);        
    }
    else
    {
        // End:0x37B
        if(EvilWeap_Base(Weapon) != none)
        {
            ChangeSpeedModifier(EvilWeap_Base(Weapon).MovementSpeedModifier);            
        }
        else
        {
            ChangeSpeedModifier(default.MovementSpeedModifier);
        }
    }
    //return;    
}

simulated function bool IsRealSprinting()
{
    return IsSprinting && (Velocity.X != float(0)) || Velocity.Y != float(0);
    //return ReturnValue;    
}

simulated function bool CanSprint()
{
    local EvilWalkingVolume WV;

    // End:0x62
    foreach TouchingActors(Class'EvilWalkingVolume', WV)
    {
        // End:0x61
        if(WV.bEnabled && WV.bBlockSprint)
        {            
            return false;
        }        
    }    
    // End:0xF1
    if(((EvilWeap_Base(Weapon) != none) && EvilWeap_Base(Weapon).BlockSprint) || (EvilWeap_Base(WeaponLeft) != none) && EvilWeap_Base(WeaponLeft).BlockSprint)
    {
        return false;
    }
    return Stamina > 0.4000000;
    //return ReturnValue;    
}

simulated function bool IsLeanPossible(bool IsLeft)
{
    local Vector VLean, Extend;

    // End:0x16
    if(VSize(Velocity) > float(50))
    {
        return false;
    }
    // End:0x4E
    if(IsLeft)
    {
        VLean.Y = -LeanLenght;        
    }
    else
    {
        VLean.Y = LeanLenght;
    }
    VLean = VLean >> Rotation;
    Extend.X = LeanLenght;
    Extend.Y = LeanLenght;
    Extend.Z = CylinderComponent.CollisionHeight * 0.7500000;
    // End:0x152
    if(!FastTrace(Location + VLean, Location, Extend))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

reliable server function ServerSetLean(bool LeftLean, bool LeanState)
{
    // End:0x24
    if(LeftLean)
    {
        SetLeanLeft(LeanState);        
    }
    else
    {
        SetLeanRight(LeanState);
    }
    //return;    
}

simulated function SetLeanLeft(bool LeanState)
{
    // End:0x29
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetLean(true, LeanState);
    }
    // End:0x55
    if(LeanState && IsLeanPossible(true))
    {
        CurrentLeanState = 1;        
    }
    else
    {
        CurrentLeanState = 0;
    }
    //return;    
}

function UpdateLightInfluence_T()
{
    // End:0x45
    if(bOnLightInfluenceFromFlashLight)
    {
        LightInfluenceWeight = FMin(1.0000000, LightInfluenceWeight + 1.0000000);
        SetTimer(2.0000000, false, GetFuncName(), self);        
    }
    else
    {
        // End:0x8D
        if(LightInfluenceWeight > 0.0000000)
        {
            LightInfluenceWeight = FMax(0.0000000, LightInfluenceWeight - 1.0000000);
            SetTimer(2.0000000, false, GetFuncName(), self);
        }
    }
    //return;    
}

simulated function SetLeanRight(bool LeanState)
{
    // End:0x29
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetLean(false, LeanState);
    }
    // End:0x55
    if(LeanState && IsLeanPossible(false))
    {
        CurrentLeanState = 2;        
    }
    else
    {
        CurrentLeanState = 0;
    }
    //return;    
}

simulated function DoReload(optional bool bFromInput = false)
{
    // End:0x1C7
    if(((Controller != none) && EvilPlayerController(Controller) != none) && EvilPlayerController(Controller).bFiringOnZipLine)
    {
        switch(EvilPlayerController(Controller).WhichHandHoldLine)
        {
            // End:0x127
            case 1:
                // End:0x124
                if(EvilWeap_Base(Weapon) != none)
                {
                    EvilWeap_Base(Weapon).DoQuickHide();
                    EvilWeap_Base(Weapon).ReloadAmmo();
                    EvilWeap_Base(Weapon).NeedReload = false;
                }
                // End:0x1C5
                break;
            // End:0x1C2
            case 2:
                // End:0x1BF
                if(EvilWeap_Base(WeaponLeft) != none)
                {
                    EvilWeap_Base(WeaponLeft).DoQuickHide();
                    EvilWeap_Base(WeaponLeft).ReloadAmmo();
                    EvilWeap_Base(WeaponLeft).NeedReload = false;
                }
                // End:0x1C5
                break;
            // End:0xFFFF
            default:
                break;
        }
        return;
    }
    // End:0x576
    if((((EvilWeap_Base(Weapon) != none) && EvilWeap_Base(WeaponLeft) != none) && Controller != none) && EvilPlayerController(Controller) != none)
    {
        // End:0x28D
        if((WaitingForDualReload || EvilWeap_Base(Weapon).IsReloading()) || EvilWeap_Base(WeaponLeft).IsReloading())
        {
            return;
        }
        LastReloadWasFromInput = bFromInput;
        // End:0x3C6
        if(((LastReloadWasFromInput && EvilWeap_Base(Weapon).SupportAlternateReload) && EvilWeap_Base(WeaponLeft).SupportAlternateReload) && EvilWeap_Base(Weapon).IsReloadNeeded() || EvilWeap_Base(WeaponLeft).IsReloadNeeded())
        {
            EvilWeap_Base(Weapon).ReloadWeapon(true, true);
            EvilWeap_Base(WeaponLeft).ReloadWeapon(true, true);
            WaitingForDualReload = true;            
        }
        else
        {
            // End:0x4DB
            if((LastReloadWasFromInput && EvilWeap_Base(Weapon).IsReloadNeeded()) || (!LastReloadWasFromInput && EvilWeap_Base(Weapon).IsMagazineEmpty()) && EvilWeap_Base(Weapon).HasAnyAmmo())
            {
                // End:0x4D8
                if(QuickHideCurrentWeapon(,, EvilWeap_Base(Weapon).GetQuickHideDurationForDualReload(), true))
                {
                    EvilWeap_Base(Weapon).ReloadWeapon(true);
                    WaitingForDualReload = true;
                }                
            }
            else
            {
                // End:0x573
                if(EvilWeap_Base(WeaponLeft).IsReloadNeeded())
                {
                    // End:0x573
                    if(QuickHideCurrentWeapon(,, EvilWeap_Base(WeaponLeft).GetQuickHideDurationForDualReload()))
                    {
                        EvilWeap_Base(WeaponLeft).ReloadWeapon(true);
                        WaitingForDualReload = true;
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x613
        if((WaitingForDualReload || (EvilWeap_Base(Weapon) != none) && EvilWeap_Base(Weapon).IsReloading()) || (EvilWeap_Base(WeaponLeft) != none) && EvilWeap_Base(WeaponLeft).IsReloading())
        {
            return;
        }
        // End:0x675
        if(EvilWeap_Base(Weapon) != none)
        {
            LastReloadWasFromInput = bFromInput;
            EvilWeap_Base(Weapon).ReloadWeapon(!bFromInput);
        }
        // End:0x6D7
        if(EvilWeap_Base(WeaponLeft) != none)
        {
            LastReloadWasFromInput = bFromInput;
            EvilWeap_Base(WeaponLeft).ReloadWeapon(!bFromInput);
        }
    }
    //return;    
}

reliable server function ServerMeleeKick()
{
    DoMeleeKick();
    //return;    
}

simulated function DoMeleeKick()
{
    // End:0x1E
    if(int(Role) < int(ROLE_Authority))
    {
        ServerMeleeKick();
    }
    // End:0xAF
    if((MeleeKickWeap == none) || ((Weapon != none) && !EvilWeap_Base(Weapon).DoMeleeKick()) || (WeaponLeft != none) && !EvilWeap_Base(WeaponLeft).DoMeleeKick())
    {
        return;
    }
    // End:0x136
    if(((Controller != none) && Controller.IsA('EvilPlayerController')) && EvilPlayerController(Controller).GetComboManager().HandleEvent('MeleeKick', none))
    {
        return;
    }
    MeleeKickWeap.Activate();
    //return;    
}

simulated function EndMeleeKick()
{
    RestoreMeleeAttachment();
    //return;    
}

reliable server function ServerMelee()
{
    DoMelee();
    //return;    
}

simulated function DoMelee()
{
    // End:0x11
    if(MeleeWeapon == none)
    {
        return;
    }
    // End:0x2F
    if(int(Role) < int(ROLE_Authority))
    {
        ServerMelee();
    }
    // End:0x57
    if(!QuickHideCurrentWeapon() || !QuickHideCurrentWeapon(,,, true))
    {
        return;
    }
    MeleeWeapon.Activate();
    //return;    
}

simulated function EndMelee()
{
    EndQuickHideCurrentWeapon();
    EndQuickHideCurrentWeapon(,,, true);
    RestoreAttachment();
    RestoreMeleeAttachment();
    //return;    
}

function EvilWeap_Melee_Base FindMeleeWeapon()
{
    local EvilWeap_Melee_Base Wpn;

    Wpn = EvilWeap_Melee_Base(MeleeWeapon);
    // End:0x67
    if(Wpn == none)
    {
        Wpn = EvilWeap_Melee_Base(InvManager.FindInventoryType(Class'EvilWeap_Melee_Base', true));
    }
    return Wpn;
    //return ReturnValue;    
}

function GetNonMeleeWeaponList(out array<Inventory> WeaponList)
{
    local EvilWeap_Base Inv;

    // End:0x8A
    if(InvManager != none)
    {
        // End:0x89
        foreach InvManager.InventoryActors(Class'EvilWeap_Base', Inv)
        {
            // End:0x88
            if(!ClassIsChildOf(Inv.Class, Class'EvilWeap_Melee_Base'))
            {
                WeaponList.AddItem(Inv);
            }            
        }        
    }
    //return;    
}

function DoMeleeAttackDamage()
{
    local EvilWeap_Melee_Base Wpn;

    Wpn = FindMeleeWeapon();
    // End:0x83
    if(Wpn != none)
    {
        // End:0x3C
        if(CurrentMeleeWeaponAttachmentClass == none)
        {
            WeaponMeleeAttachmentChanged();
        }
        Wpn.DoMeleeDamage(DamageScaling, Controller.Enemy);
    }
    //return;    
}

reliable server function ServerDynamiteThrow()
{
    DoDynamiteThrow();
    //return;    
}

reliable server function ServerGrenadeThrow()
{
    DoGrenadeThrow();
    //return;    
}

simulated function DoDynamiteThrow()
{
    local EvilWeap_Throw_Base Dynamite;

    // End:0x1E
    if(int(Role) < int(ROLE_Authority))
    {
        ServerDynamiteThrow();
    }
    Dynamite = EvilWeap_Throw_Base(ThrowWeapon);
    // End:0x71
    if((Dynamite == none) || Dynamite.AmmoCount == 0)
    {
        return;
    }
    // End:0xCC
    if((WaitingForDualReload || !QuickHideCurrentWeapon()) || Dynamite.BothHandWeapon && !QuickHideCurrentWeapon(,,, true))
    {
        return;
    }
    // End:0x153
    if(((Controller != none) && Controller.IsA('EvilPlayerController')) && EvilPlayerController(Controller).GetComboManager().HandleEvent('GrenadeThrow', none))
    {
        return;
    }
    Dynamite.Activate();
    //return;    
}

simulated function DoGrenadeThrow()
{
    local EvilWeap_Throw_Base Grenade;

    // End:0x1E
    if(int(Role) < int(ROLE_Authority))
    {
        ServerGrenadeThrow();
    }
    Grenade = EvilWeap_Throw_Base(ThrowWeapon);
    // End:0x71
    if((Grenade == none) || Grenade.AmmoCount == 0)
    {
        return;
    }
    // End:0xCC
    if((WaitingForDualReload || !QuickHideCurrentWeapon()) || Grenade.BothHandWeapon && !QuickHideCurrentWeapon(,,, true))
    {
        return;
    }
    // End:0x153
    if(((Controller != none) && Controller.IsA('EvilPlayerController')) && EvilPlayerController(Controller).GetComboManager().HandleEvent('GrenadeThrow', none))
    {
        return;
    }
    Grenade.bReleaseGrenade = false;
    Grenade.Activate();
    //return;    
}

reliable server function ServerDynamiteRelease()
{
    DoDynamiteRelease();
    //return;    
}

reliable server function ServerGrenadeRelease()
{
    DoGrenadeRelease();
    //return;    
}

simulated function DoDynamiteRelease()
{
    local EvilWeap_Throw_Base Dynamite;

    Dynamite = EvilWeap_Throw_Base(ThrowWeapon);
    // End:0x2D
    if(Dynamite == none)
    {
        return;
    }
    Dynamite.bReleaseGrenade = false;
    Dynamite.DoRelease();
    //return;    
}

simulated function DoGrenadeRelease()
{
    local EvilWeap_Throw_Base Grenade;

    Grenade = EvilWeap_Throw_Base(ThrowWeapon);
    // End:0x2D
    if(Grenade == none)
    {
        return;
    }
    Grenade.DoRelease();
    //return;    
}

simulated function EndDynamiteThrow()
{
    EndQuickHideCurrentWeapon();
    EndQuickHideCurrentWeapon(,,, true);
    RestoreAttachment();
    RestoreThrowAttachment();
    //return;    
}

simulated function EndGrenadeThrow()
{
    EndQuickHideCurrentWeapon();
    EndQuickHideCurrentWeapon(,,, true);
    RestoreAttachment();
    RestoreThrowAttachment();
    //return;    
}

simulated function RestoreAttachment()
{
    // End:0xE1
    if(EvilWeap_Base(Weapon) != none)
    {
        CurrentWeaponAttachmentClass = EvilWeap_Base(Weapon).AttachmentClass;
        // End:0xE1
        if(((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_Client)) && IsLocallyControlled())
        {
            WeaponAttachmentChanged();
        }
    }
    //return;    
}

simulated function RestoreMeleeAttachment()
{
    // End:0xE1
    if(EvilWeap_Base(MeleeWeapon) != none)
    {
        CurrentMeleeWeaponAttachmentClass = EvilWeap_Base(MeleeWeapon).AttachmentClass;
        // End:0xE1
        if(((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_Client)) && IsLocallyControlled())
        {
            WeaponMeleeAttachmentChanged();
        }
    }
    //return;    
}

simulated function RestoreThrowAttachment()
{
    // End:0xE1
    if(EvilWeap_Base(ThrowWeapon) != none)
    {
        CurrentThrowWeaponAttachmentClass = EvilWeap_Base(ThrowWeapon).AttachmentClass;
        // End:0xE1
        if(((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_Client)) && IsLocallyControlled())
        {
            WeaponThrowAttachmentChanged();
        }
    }
    //return;    
}

simulated function ReattachMesh()
{
    super(GamePawn).ReattachMesh();
    //return;    
}

simulated function bool QuickHideCurrentWeapon(optional bool bInstant = false, optional float HideTime = 0.0000000, optional bool bLeftHand = false)
{
    local EvilWeap_Base Weap;
    local EvilAttachment_Weap_Base Attach;
    local bool bResult;

    // End:0x52
    if(bLeftHand)
    {
        Weap = EvilWeap_Base(WeaponLeft);
        Attach = CurrentWeaponLeftAttachment;        
    }
    else
    {
        Weap = EvilWeap_Base(Weapon);
        Attach = CurrentWeaponAttachment;
    }
    // End:0xDA
    if(Weap != none)
    {
        bResult = Weap.DoQuickHide(((bInstant) ? 0.0100000 : HideTime));        
    }
    else
    {
        bResult = true;
    }
    // End:0x123
    if(bResult && Attach != none)
    {
        Attach.DoQuickHide();
    }
    // End:0x158
    if(bResult)
    {
        // End:0x14C
        if(bLeftHand)
        {
            bQuickHidenLeftWeapon = true;            
        }
        else
        {
            bQuickHidenWeapon = true;
        }
    }
    return bResult;
    //return ReturnValue;    
}

simulated function EndQuickHideCurrentWeapon(optional bool bInstant = false, optional float ShowTime = 0.0000000, optional bool bLeftHand = false)
{
    local EvilWeap_Base Weap;
    local EvilAttachment_Weap_Base Attach;

    // End:0x52
    if(bLeftHand)
    {
        Weap = EvilWeap_Base(WeaponLeft);
        Attach = CurrentWeaponLeftAttachment;        
    }
    else
    {
        Weap = EvilWeap_Base(Weapon);
        Attach = CurrentWeaponAttachment;
    }
    // End:0xCC
    if(Weap != none)
    {
        Weap.EndQuickHide(((bInstant) ? 0.0100000 : ShowTime));
    }
    // End:0xFA
    if(Attach != none)
    {
        Attach.EndQuickHide();
    }
    // End:0x116
    if(bLeftHand)
    {
        bQuickHidenLeftWeapon = false;        
    }
    else
    {
        bQuickHidenWeapon = false;
    }
    //return;    
}

simulated event NotifyWeapReloadStart(EvilWeap_Base Weap)
{
    //return;    
}

simulated event NotifyWeapReloadEnd(EvilWeap_Base Weap)
{
    // End:0xFC
    if((WaitingForDualReload && LastReloadWasFromInput) && Weap.SupportAlternateReload)
    {
        // End:0xFC
        if(((int(Weap.GetHand()) == int(2)) && EvilWeap_Base(WeaponLeft).SupportAlternateReload) || (int(Weap.GetHand()) == int(3)) && EvilWeap_Base(Weapon).SupportAlternateReload)
        {
            WaitingForDualReload = false;
        }
    }
    // End:0x150
    if(WaitingForDualReload)
    {
        // End:0x143
        if(int(Weap.GetHand()) == int(3))
        {
            EndQuickHideCurrentWeapon();            
        }
        else
        {
            EndQuickHideCurrentWeapon(,,, true);
        }
    }
    //return;    
}

simulated event NotifyWeapQuickHideDone(EvilWeap_Base Weap)
{
    // End:0x84
    if((WaitingForDualReload && !Weap.AlwaysBothHandReload) && !LastReloadWasFromInput)
    {
        Weap.ReloadAmmo();
        Weap.NeedReload = false;
    }
    //return;    
}

simulated event NotifyWeapQuickHideEnd(EvilWeap_Base Weap)
{
    local bool ContinueDualReload;

    ContinueDualReload = false;
    // End:0x166
    if(WaitingForDualReload && Weap.AlwaysBothHandReload || LastReloadWasFromInput)
    {
        // End:0x166
        if((int(Weap.GetHand()) == int(3)) && (LastReloadWasFromInput && Weap.IsReloadNeeded()) || (!LastReloadWasFromInput && Weap.IsMagazineEmpty()) && Weap.HasAnyAmmo())
        {
            ContinueDualReload = QuickHideCurrentWeapon(,, Weap.GetQuickHideDurationForDualReload());
            // End:0x166
            if(ContinueDualReload)
            {
                Weap.ReloadWeapon(true);
            }
        }
    }
    // End:0x181
    if(!ContinueDualReload)
    {
        WaitingForDualReload = false;
    }
    //return;    
}

simulated function SetFlashLocationArray(Weapon InWeapon, byte InFiringMode, array<Vector> NewLocArray, optional bool bIsMelee = false)
{
    local int I;

    // End:0x17
    if(NewLocArray.Length == 0)
    {
        return;
    }
    // End:0x4A
    if(NewLocArray[0] == LastFiringFlashLocation)
    {
        NewLocArray[0] += vect(0.0000000, 0.0000000, 1.0000000);
    }
    // End:0x80
    if(NewLocArray[0] == vect(0.0000000, 0.0000000, 0.0000000))
    {
        NewLocArray[0] = vect(0.0000000, 0.0000000, 1.0000000);
    }
    bForceNetUpdate = true;
    LastFiringFlashLocation = NewLocArray[0];
    // End:0x13D
    if(bIsMelee)
    {
        I = 0;
        J0xB9:

        // End:0x11C [Loop If]
        if(I < 20)
        {
            // End:0xE7
            if(I > (NewLocArray.Length - 1))
            {
                // [Explicit Break]
                goto J0x11C;
            }
            FlashLocationArrayMelee[I] = NewLocArray[I];
            I++;
            // [Loop Continue]
            goto J0xB9;
        }
        J0x11C:

        FlashLocationArrayUpdated(InWeapon, FlashLocationArrayMelee, false, true);        
    }
    else
    {
        I = 0;
        J0x148:

        // End:0x1AB [Loop If]
        if(I < 20)
        {
            // End:0x176
            if(I > (NewLocArray.Length - 1))
            {
                // [Explicit Break]
                goto J0x1AB;
            }
            FlashLocationArray[I] = NewLocArray[I];
            I++;
            // [Loop Continue]
            goto J0x148;
        }
        J0x1AB:

        SetFiringMode(InWeapon, InFiringMode);
        FlashLocationArrayUpdated(InWeapon, FlashLocationArray, false, false);
    }
    //return;    
}

function ClearFlashLocationArray(Weapon InWeapon, optional bool bIsMelee = false)
{
    local int I;

    // End:0x9C
    if(bIsMelee)
    {
        // End:0x99
        if(!IsZero(FlashLocationArrayMelee[0]))
        {
            bForceNetUpdate = true;
            I = 0;
            J0x3C:

            // End:0x7B [Loop If]
            if(I < 20)
            {
                FlashLocationArrayMelee[I] = vect(0.0000000, 0.0000000, 0.0000000);
                I++;
                // [Loop Continue]
                goto J0x3C;
            }
            FlashLocationArrayUpdated(InWeapon, FlashLocationArrayMelee, false, true);
        }        
    }
    else
    {
        // End:0x123
        if(!IsZero(FlashLocationArray[0]))
        {
            bForceNetUpdate = true;
            I = 0;
            J0xC6:

            // End:0x105 [Loop If]
            if(I < 20)
            {
                FlashLocationArray[I] = vect(0.0000000, 0.0000000, 0.0000000);
                I++;
                // [Loop Continue]
                goto J0xC6;
            }
            FlashLocationArrayUpdated(InWeapon, FlashLocationArray, false);
        }
    }
    //return;    
}

simulated function FlashLocationArrayUpdated(Weapon InWeapon, Vector InFlashLocation[20], bool bViaReplication, optional bool bIsMelee = false)
{
    // End:0x4B
    if(!IsZero(InFlashLocation[0]))
    {
        WeaponFiredArray(InWeapon, bViaReplication, InFlashLocation, bIsMelee);        
    }
    else
    {
        WeaponStoppedFiring(InWeapon, bViaReplication);
    }
    //return;    
}

simulated function IncrementFlashCountEvil(Weapon InWeapon, byte InFiringMode, optional bool bIsMelee = false)
{
    bForceNetUpdate = true;
    FlashCount++;
    // End:0x3D
    if(int(FlashCount) == int(0))
    {
        FlashCount += 2;
    }
    SetFiringMode(InWeapon, InFiringMode);
    FlashCountUpdatedEvil(InWeapon, FlashCount, false, bIsMelee);
    //return;    
}

simulated function ClearFlashCountEvil(Weapon InWeapon, optional bool bIsMelee = false)
{
    // End:0x58
    if(int(FlashCount) != int(0))
    {
        bForceNetUpdate = true;
        FlashCount = 0;
        FlashCountUpdatedEvil(InWeapon, FlashCount, false, bIsMelee);
    }
    //return;    
}

simulated function FlashCountUpdatedEvil(Weapon InWeapon, byte InFlashCount, bool bViaReplication, optional bool bIsMelee = false)
{
    // End:0x44
    if(int(InFlashCount) > int(0))
    {
        WeaponFiredArray(InWeapon, bViaReplication,, bIsMelee);        
    }
    else
    {
        WeaponStoppedFiring(InWeapon, bViaReplication);
    }
    //return;    
}

simulated function WeaponFiredArray(Weapon InWeapon, bool bViaReplication, optional Vector HitLocation[20], optional bool bIsMelee = false)
{
    local int I;
    local EvilAttachment_Weap_Base Attachment;

    // End:0x3A
    if(bFiringLeft && CurrentWeaponLeftAttachment != none)
    {
        Attachment = CurrentWeaponLeftAttachment;        
    }
    else
    {
        Attachment = CurrentWeaponAttachment;
    }
    // End:0x171
    if(bIsMelee && CurrentMeleeWeaponAttachment != none)
    {
        // End:0x16E
        if((HitLocation[0] != vect(0.0000000, 0.0000000, 0.0000000)) && ((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || bViaReplication)
        {
            I = 0;
            J0xF8:

            // End:0x16E [Loop If]
            if(I < 20)
            {
                // End:0x160
                if(HitLocation[I] != vect(0.0000000, 0.0000000, 0.0000000))
                {
                    CurrentMeleeWeaponAttachment.PlayImpactEffects(HitLocation[I]);
                }
                I++;
                // [Loop Continue]
                goto J0xF8;
            }
        }        
    }
    else
    {
        // End:0x370
        if(Attachment != none)
        {
            // End:0x1BC
            if(!IsFirstPerson())
            {
                Attachment.ThirdPersonFireEffects(HitLocation[0]);                
            }
            else
            {
                Attachment.FirstPersonFireEffects(((bFiringLeft && CurrentWeaponLeftAttachment != none) ? WeaponLeft : Weapon), HitLocation[0]);
                // End:0x264
                if(Class'Engine.Engine'.static.IsSplitScreen())
                {
                    Attachment.ThirdPersonFireEffects(HitLocation[0]);
                }
            }
            // End:0x370
            if((HitLocation[0] != vect(0.0000000, 0.0000000, 0.0000000)) && ((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || bViaReplication)
            {
                I = 0;
                J0x2F1:

                // End:0x370 [Loop If]
                if(I < 20)
                {
                    // End:0x362
                    if(HitLocation[I] != vect(0.0000000, 0.0000000, 0.0000000))
                    {
                        Attachment.PlayImpactEffects(HitLocation[I], bFiringLeft);
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x2F1;
                }
            }
        }
    }
    //return;    
}

simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
    // End:0x56
    if(CurrentMeleeWeaponAttachment != none)
    {
        CurrentMeleeWeaponAttachment.StopThirdPersonFireEffects();
        CurrentMeleeWeaponAttachment.StopFirstPersonFireEffects(MeleeWeapon);
    }
    // End:0xBE
    if(bFiringLeft && CurrentWeaponLeftAttachment != none)
    {
        CurrentWeaponLeftAttachment.StopThirdPersonFireEffects();
        CurrentWeaponLeftAttachment.StopFirstPersonFireEffects(WeaponLeft);        
    }
    else
    {
        // End:0x114
        if(CurrentWeaponAttachment != none)
        {
            CurrentWeaponAttachment.StopThirdPersonFireEffects();
            CurrentWeaponAttachment.StopFirstPersonFireEffects(Weapon);
        }
    }
    //return;    
}

simulated function Vector WeaponBob(float BobDamping, float JumpDamping)
{
    local Vector WBob;

    WBob = BobDamping * WalkBob;
    WBob.Z = (0.4500000 + (0.5500000 * BobDamping)) * WalkBob.Z;
    // End:0x8F
    if(!bWeaponBob)
    {
        WBob *= 2.5000000;
    }
    WBob.Z += (JumpDamping * LandBob);
    return WBob;
    //return ReturnValue;    
}

simulated event EndCrouch(float HeightAdjust)
{
    super(UDKPawn).EndCrouch(HeightAdjust);
    PlayCrouchingEndSound();
    //return;    
}

simulated event StartCrouch(float HeightAdjust)
{
    super(UDKPawn).StartCrouch(HeightAdjust);
    PlayCrouchingSound();
    //return;    
}

simulated function bool CanCrouch()
{
    local EvilWalkingVolume WV;

    // End:0x62
    foreach TouchingActors(Class'EvilWalkingVolume', WV)
    {
        // End:0x61
        if(WV.bEnabled && WV.bBlockCrouch)
        {            
            return false;
        }        
    }    
    return true;
    //return ReturnValue;    
}

function PlayCrouchingSound()
{
    local Actor TraceActor;
    local TraceHitInfo LastFootStepTraceInfo;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

    local SoundCue SC;

    TraceStart = Location - (vect(0.0000000, 0.0000000, 0.6500000) * (GetCollisionHeight()));
    TraceDest = TraceStart - ((vect(0.0000000, 0.0000000, 0.3500000) * (GetCollisionHeight())) + vect(0.0000000, 0.0000000, 60.0000000));
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, LastFootStepTraceInfo, 1 | 2);
    // End:0x224
    if(TraceActor != none)
    {
        // End:0x11F
        if(EvilWaterVolume(TraceActor) != none)
        {
            LastFootStepTraceInfo.PhysMaterial = EvilWaterVolume(TraceActor).WaterPhysMaterial;
        }
        SC = Class'EvilPhysicalMaterialProperty'.static.DetermineCrouchingSound(Class'EvilPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(LastFootStepTraceInfo), self, WorldInfo);
        // End:0x1AC
        if(SC != none)
        {
            PlaySound(SC, true, true, false, out_HitLocation, true);            
        }
        else
        {
            PlaySound(SoundGroupClass.static.GetCrouchSound(GetMaterialBelowFeet()));
        }
        // End:0x224
        if(EvilWeap_Base(Weapon) != none)
        {
            EvilWeap_Base(Weapon).PlayCrouchingSound();
        }
    }
    //return;    
}

function PlayCrouchingEndSound()
{
    local Actor TraceActor;
    local TraceHitInfo LastFootStepTraceInfo;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

    local SoundCue SC;

    TraceStart = Location - (vect(0.0000000, 0.0000000, 0.6500000) * (GetCollisionHeight()));
    TraceDest = TraceStart - ((vect(0.0000000, 0.0000000, 0.3500000) * (GetCollisionHeight())) + vect(0.0000000, 0.0000000, 30.0000000));
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, LastFootStepTraceInfo, 1 | 2);
    // End:0x224
    if(TraceActor != none)
    {
        // End:0x11F
        if(EvilWaterVolume(TraceActor) != none)
        {
            LastFootStepTraceInfo.PhysMaterial = EvilWaterVolume(TraceActor).WaterPhysMaterial;
        }
        SC = Class'EvilPhysicalMaterialProperty'.static.DetermineCrouchingEndSound(Class'EvilPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(LastFootStepTraceInfo), self, WorldInfo);
        // End:0x1AC
        if(SC != none)
        {
            PlaySound(SC, true, true, false, out_HitLocation, true);            
        }
        else
        {
            PlaySound(SoundGroupClass.static.GetCrouchEndSound(GetMaterialBelowFeet()));
        }
        // End:0x224
        if(EvilWeap_Base(Weapon) != none)
        {
            EvilWeap_Base(Weapon).PlayCrouchingEndSound();
        }
    }
    //return;    
}

function PlayJumpingSound()
{
    local Actor TraceActor;
    local TraceHitInfo LastFootStepTraceInfo;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

    local SoundCue SC;
    local PlayerController PC;

    TraceStart = Location - (vect(0.0000000, 0.0000000, 0.6500000) * (GetCollisionHeight()));
    TraceDest = TraceStart - ((vect(0.0000000, 0.0000000, 0.3500000) * (GetCollisionHeight())) + vect(0.0000000, 0.0000000, 30.0000000));
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, LastFootStepTraceInfo, 1 | 2);
    // End:0x2C1
    if(TraceActor != none)
    {
        // End:0x11F
        if(EvilWaterVolume(TraceActor) != none)
        {
            LastFootStepTraceInfo.PhysMaterial = EvilWaterVolume(TraceActor).WaterPhysMaterial;
        }
        // End:0x280
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x27F
            if((PC.ViewTarget != none) && VSizeSq(PC.ViewTarget.Location - Location) < MaxJumpSoundDistSq)
            {
                SC = Class'EvilPhysicalMaterialProperty'.static.DetermineLeapingSound(Class'EvilPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(LastFootStepTraceInfo), self, WorldInfo);
                // End:0x23F
                if(SC != none)
                {
                    PlaySound(SC, true, true, false, out_HitLocation, true);
                    // End:0x27F
                    continue;
                }
                PlaySound(SoundGroupClass.static.GetJumpSound(GetMaterialBelowFeet()), true, true, false, out_HitLocation, true);
            }            
        }        
        // End:0x2C1
        if(EvilWeap_Base(Weapon) != none)
        {
            EvilWeap_Base(Weapon).PlayJumpingSound();
        }
    }
    //return;    
}

function bool DoJump(bool bUpdating)
{
    bIsJumping = super.DoJump(bUpdating);
    // End:0xEC
    if(bIsJumping)
    {
        // End:0x6C
        if(EvilPlayerController(Controller) != none)
        {
            EvilPlayerController(Controller).Jumped();
        }
        // End:0xAC
        if(EvilWeap_Base(Weapon) != none)
        {
            EvilWeap_Base(Weapon).Jumped();
        }
        // End:0xEC
        if(EvilWeap_Base(WeaponLeft) != none)
        {
            EvilWeap_Base(WeaponLeft).Jumped();
        }
    }
    return bIsJumping;
    //return ReturnValue;    
}

function PlayLandingSound()
{
    local PlayerController PC;
    local Actor TraceActor;
    local TraceHitInfo LastFootStepTraceInfo;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

    local SoundCue SC;

    TraceStart = Location - (vect(0.0000000, 0.0000000, 0.6500000) * (GetCollisionHeight()));
    TraceDest = TraceStart - ((vect(0.0000000, 0.0000000, 0.3500000) * (GetCollisionHeight())) + vect(0.0000000, 0.0000000, 30.0000000));
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, LastFootStepTraceInfo, 1 | 2);
    // End:0x2FB
    if(TraceActor != none)
    {
        // End:0x11F
        if(EvilWaterVolume(TraceActor) != none)
        {
            LastFootStepTraceInfo.PhysMaterial = EvilWaterVolume(TraceActor).WaterPhysMaterial;
        }
        // End:0x2BA
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x2B9
            if((PC.ViewTarget != none) && VSizeSq(PC.ViewTarget.Location - Location) < MaxJumpSoundDistSq)
            {
                SC = Class'EvilPhysicalMaterialProperty'.static.DetermineLandingSound(Class'EvilPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(LastFootStepTraceInfo), self, WorldInfo);
                // End:0x23F
                if(SC != none)
                {
                    PlaySound(SC, true, true, false, out_HitLocation, true);
                    // End:0x2B9
                    continue;
                }
                SC = SoundGroupClass.static.GetLandSound(GetMaterialBelowFeet());
                // End:0x2B9
                if(SC != none)
                {
                    PlaySound(SoundGroupClass.static.GetLandSound(GetMaterialBelowFeet()));
                }
            }            
        }        
        // End:0x2FB
        if(EvilWeap_Base(Weapon) != none)
        {
            EvilWeap_Base(Weapon).PlayLandingSound();
        }
    }
    //return;    
}

simulated function TakeFallingDamage()
{
    // End:0x19
    if(CurrentJumpInfo == none)
    {
        super.TakeFallingDamage();
    }
    //return;    
}

simulated function bool CanJump()
{
    local EvilWalkingVolume WV;

    // End:0x62
    foreach TouchingActors(Class'EvilWalkingVolume', WV)
    {
        // End:0x61
        if(WV.bEnabled && WV.bBlockJump)
        {            
            return false;
        }        
    }    
    // End:0xF1
    if(((EvilWeap_Base(Weapon) != none) && EvilWeap_Base(Weapon).BlockSprint) || (EvilWeap_Base(WeaponLeft) != none) && EvilWeap_Base(WeaponLeft).BlockSprint)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool IsJumping()
{
    // End:0x11
    if(MyEvilAI == none)
    {
        return false;
    }
    return ((((int(PawnAction) == 25) || int(PawnAction) == 27) || int(PawnAction) == 28) || int(PawnAction) == 29) || EvilAICmd_Jump(MyEvilAI.GetActiveEvilCommand()) != none;
    //return ReturnValue;    
}

event Falling()
{
    super(Pawn).Falling();
    // End:0x4A
    if(EvilWeap_Base(Weapon) != none)
    {
        EvilWeap_Base(Weapon).Jumped();
    }
    // End:0x8A
    if(EvilWeap_Base(WeaponLeft) != none)
    {
        EvilWeap_Base(WeaponLeft).Jumped();
    }
    // End:0xC3
    if(EvilPlayerController(Controller) == none)
    {
        Mesh.RootMotionMode = 2;
    }
    //return;    
}

simulated function LandedOnPawn(Vector HitNormal, EvilPawn FloorPawn)
{
    FloorPawn.Knockdown(Velocity, vect(0.0000000, 0.0000000, 0.0000000));
    FloorPawn.TakeDamage(int(VSize(Velocity)), MyEvilAI, Location, Velocity, Class'EvilDmgType_Fell');
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    local Vector Impulse;

    super(Pawn).Landed(HitNormal, FloorActor);
    // End:0x13B
    if((MyEvilAI != none) && IsJumping())
    {
        // End:0x77
        if(EvilPawn(FloorActor) != none)
        {
            LandedOnPawn(HitNormal, EvilPawn(FloorActor));
        }
        EPA_Jump(PawnActions[int(PawnAction)]).PawnLanded(HitNormal, FloorActor);
        // End:0x13B
        if(EvilAICmd_Jump(MyEvilAI.GetActiveEvilCommand()) != none)
        {
            EvilAICmd_Jump(MyEvilAI.GetActiveEvilCommand()).PawnLanded(HitNormal, FloorActor);
        }
    }
    Impulse.Z = Velocity.Z * 4.0000000;
    // End:0x1E7
    if(EvilVehicle_Base(FloorActor) != none)
    {
        EvilVehicle_Base(FloorActor).Mesh.AddImpulse(Impulse, Location);        
    }
    else
    {
        // End:0x250
        if(DynamicSMActor(FloorActor) != none)
        {
            DynamicSMActor(FloorActor).StaticMeshComponent.AddImpulse(Impulse, Location);
        }
    }
    // End:0x2E8
    if(Velocity.Z < float(-200))
    {
        OldZ = Location.Z;
        bJustLanded = (bUpdateEyeheight && Controller != none) && Controller.LandingShake();
    }
    // End:0x31F
    if(EvilInvManager != none)
    {
        EvilInvManager.OwnerEvent('Landed');
    }
    // End:0x3CF
    if((((MultiJumpRemaining < MaxMultiJump) && bStopOnDoubleLanding) || bDodging) || Velocity.Z < (float(-2) * JumpZ))
    {
        Velocity.X *= 0.1000000;
        Velocity.Y *= 0.1000000;
    }
    AirControl = DefaultAirControl;
    MultiJumpRemaining = MaxMultiJump;
    bDodging = false;
    bReadyToDoubleJump = false;
    // End:0x450
    if(!bHidden && Velocity.Z < float(-200))
    {
        PlayLandingSound();
    }
    // End:0x49F
    if(Velocity.Z < -MaxFallSpeed)
    {
        SoundGroupClass.static.PlayFallingDamageLandSound(self);        
    }
    else
    {
        // End:0x4F0
        if(Velocity.Z < (MaxFallSpeed * -0.5000000))
        {
            SoundGroupClass.static.PlayLandSound(self);
        }
    }
    SetBaseEyeheight();
    // End:0x54F
    if(EvilPlayerController(Controller) != none)
    {
        EvilPlayerController(Controller).Landed(HitNormal, FloorActor);        
    }
    else
    {
        Mesh.RootMotionMode = default.Mesh.RootMotionMode;
    }
    // End:0x5DE
    if(EvilWeap_Base(Weapon) != none)
    {
        EvilWeap_Base(Weapon).Landed(HitNormal, FloorActor);
    }
    // End:0x630
    if(EvilWeap_Base(WeaponLeft) != none)
    {
        EvilWeap_Base(WeaponLeft).Landed(HitNormal, FloorActor);
    }
    bIsJumping = false;
    //return;    
}

function PreparePawnForRagdoll()
{
    // End:0x249
    if(InitRagdoll())
    {
        // End:0x13D
        if(Mesh.PhysicsAssetInstance != none)
        {
            Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(false, false, Mesh, true);
            Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(0.0000000, 0.0000000, 0.0040000, Mesh, true);
            Mesh.PhysicsAssetInstance.SetAllMotorsAngularVelocityDrive(true, true, Mesh, true);
            Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
            AddBaseLinearVelocityUponWhenGoingRagDoll();
        }
        bBlendOutTakeHitPhysics = false;
        Mesh.SetTickGroup(2);
        SetTickGroup(2);
        Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
        Mesh.bUpdateKinematicBonesFromAnimation = false;
        Mesh.bUpdateJointsFromAnimation = false;
        Mesh.bUpdateKinematicBonesFromAnimation = false;
        StopAllAnimations();
        SetCollision(true, false);
        Mesh.WakeRigidBody();
        SetPawnRBChannels(true);
    }
    //return;    
}

function OnToggleCastShadows(SeqAct_ToggleCastShadows Action)
{
    // End:0x11
    if(Mesh == none)
    {
        return;
    }
    Mesh.CastShadow = !Mesh.CastShadow;
    //return;    
}

function OnActivatePawn(SeqAct_ActivatePawn Action)
{
    // End:0x41
    if(Action.InputLinks[0].bHasImpulse)
    {
        CheckGetUpFromAnimation();
    }
    //return;    
}

function OnCheckPoint(SeqAct_Checkpoint Action)
{
    //return;    
}

function OnPlayRagdoll(SeqAct_PlayRagdoll Action)
{
    local Vector LinearVel, AngularVel;

    // End:0x65
    if(Action.InputLinks[1].bHasImpulse)
    {
        // End:0x58
        if(int(Physics) == int(10))
        {
            CheckGetUpFromRagdoll();            
        }
        else
        {
            CheckGetUpFromAnimation();
        }        
    }
    else
    {
        // End:0x217
        if(Action.InputLinks[0].bHasImpulse)
        {
            // End:0x134
            if(Action.ImpulseVector != none)
            {
                LinearVel = Vector(Action.ImpulseVector.Rotation) * Action.ImpulseVector.ImpulseStrength;
            }
            // End:0x187
            if(Action.ForceVariation > float(0))
            {
                LinearVel += (VRand() * Action.ForceVariation);
            }
            // End:0x1D9
            if(Action.AngularVariation > float(0))
            {
                AngularVel = VRand() * Action.AngularVariation;
            }
            Knockdown(LinearVel, AngularVel,,,, Action.bRecoverFromRagdoll);
        }
    }
    //return;    
}

simulated function OnShowOnRadar(SeqAct_ShowOnRadar Action)
{
    SetShowOnRadar(Action.bShowOnRadar);
    //return;    
}

simulated function SetShowOnRadar(bool bShow)
{
    bShowOnRadar = bShow;
    //return;    
}

simulated function bool CanBeShownOnRadar()
{
    return bShowOnRadar;
    //return ReturnValue;    
}

function OnDoPawnAction(SeqAct_DoPawnAction Action)
{
    switch(Action.PawnActionToDo)
    {
        // End:0xFFFF
        default:
            //return;
            break;
    }    
}

final simulated function string PAStructToString(PAStruct InPAStruct)
{
    return ((((("[PawnAction:" @ string(InPAStruct.PawnAction)) $ ", InteractionPawn:") @ string(InPAStruct.InteractionPawn)) $ ", SpecialMoveFlags:") @ string(InPAStruct.Flags)) $ "]";
    //return ReturnValue;    
}

final simulated function string PawnActionToString(byte InPawnAction, EvilPawn InInteractionPawn, int InSpecialMoveFlags)
{
    return ((((("[PawnAction:" @ string(InPawnAction)) $ ", InteractionPawn:") @ string(InInteractionPawn)) $ ", SpecialMoveFlags:") @ string(InSpecialMoveFlags)) $ "]";
    //return ReturnValue;    
}

simulated function DoSpecialClothActionOnTakeDamage(EvilTypes.EClothAssetSpecialActionOnTakeDamage Action, EvilPawnClothAssetInterface clothComponent, bool bHealthStepOcurred)
{
    //return;    
}

simulated function DoSpecialClothActionOnZeroHealth(EvilTypes.EClothAssetSpecialActionOnZeroHealth Action, EvilPawnClothAssetInterface clothComponent)
{
    //return;    
}

simulated function DoSpecialClothActionOnRagdoll(EvilTypes.EClothAssetSpecialActionOnRagdoll Action, EvilPawnClothAssetInterface clothComponent)
{
    // End:0x14
    if(int(Action) == int(1))
    {
    }
    //return;    
}

simulated function DoPawnAction(byte NewMove, optional bool bForceMove, optional EvilPawn InInteractionPawn, optional int InPawnActionFlags)
{
    local byte PrevMove;
    local PAStruct NewMoveStruct;

    // End:0x76
    if((!bForceMove && int(NewMove) == int(PawnAction)) && (int(PawnAction) != 0) && !PawnActions[int(PawnAction)].CanOverrideWithCurrentAction())
    {
        return;
    }
    // End:0xA3
    if((int(NewMove) != 0) && !VerifyPAHasBeenInstanced(NewMove))
    {
        return;
    }
    NewMoveStruct = FillPAStructFromParams(NewMove, InInteractionPawn, InPawnActionFlags);
    // End:0xF4
    if(bEndingPawnAction)
    {
        PendingPawnActionStruct = NewMoveStruct;
        return;
    }
    // End:0x1F7
    if(((int(PawnAction) != 0) && !bForceMove) && int(NewMove) != 0)
    {
        // End:0x1A8
        if(PawnActions[int(PawnAction)].CanOverrideActionWith(NewMove) || PawnActions[int(NewMove)].CanOverrideAction(PawnAction))
        {
            bForceMove = true;            
        }
        else
        {
            // End:0x1F5
            if(PawnActions[int(PawnAction)].CanChainAction(NewMove))
            {
                PendingPawnActionStruct = NewMoveStruct;                
            }
            return;
        }
    }
    // End:0x236
    if(((int(NewMove) != 0) && !bForceMove) && !CanDoPawnAction(NewMove))
    {
        return;
    }
    PrevMove = PawnAction;
    // End:0x29A
    if(int(PawnAction) != 0)
    {
        bEndingPawnAction = true;
        PawnAction = 0;
        PawnActionEnded(PrevMove, NewMove);
        bEndingPawnAction = false;
    }
    PawnAction = NewMove;
    InteractionPawn = InInteractionPawn;
    PawnActionFlags = InPawnActionFlags;
    // End:0x398
    if((((int(WorldInfo.NetMode) != int(NM_Standalone)) || WorldInfo.IsRecordingDemo()) && int(Role) == int(ROLE_Authority)) && (int(PawnAction) == 0) || PawnActions[int(PawnAction)].ShouldReplicate())
    {
        ReplicatedPawnActionStruct = NewMoveStruct;
        bForceNetUpdate = true;
    }
    PawnActionAssigned(NewMove, PrevMove);
    // End:0x413
    if(int(NewMove) != 0)
    {
        PawnActionStarted(NewMove, PrevMove, bForceMove);
        // End:0x410
        if(bForceMove)
        {
            PendingPawnActionStruct = FillPAStructFromParams(0, none, 0);
        }        
    }
    else
    {
        // End:0x476
        if(int(PendingPawnActionStruct.PawnAction) != 0)
        {
            NewMoveStruct = PendingPawnActionStruct;
            PendingPawnActionStruct = FillPAStructFromParams(0, none, 0);
            DoPawnActionFromStruct(NewMoveStruct, false);
        }
    }
    //return;    
}

simulated event LocalDoPawnAction(byte NewAction, optional bool bForceAction = false, optional EvilPawn InInteractionPawn, optional int InPawnActionFlags = 0)
{
    // End:0x26
    if(!IsLocallyControlled())
    {
        ScriptTrace();
        return;
    }
    // End:0xE8
    if(bForceAction || CanDoPawnAction(NewAction))
    {
        // End:0xBF
        if(Controller.IsA('EvilPlayerController'))
        {
            EvilPlayerController(Controller).DoPawnAction(NewAction, bForceAction, InInteractionPawn, InPawnActionFlags);            
        }
        else
        {
            DoPawnAction(NewAction, true, InInteractionPawn, InPawnActionFlags);
        }        
    }
    //return;    
}

simulated event ServerDoPawnAction(byte NewAction, optional bool bForceAction = false, optional EvilPawn InInteractionPawn, optional int InPawnActionFlags = 0, optional EvilPawn.EPawnAction PAToChain)
{
    // End:0x52
    if((int(WorldInfo.NetMode) == int(NM_Client)) && !bTearOff)
    {
        ScriptTrace();
        return;
    }
    // End:0x134
    if(bForceAction || CanDoPawnAction(NewAction))
    {
        // End:0xE1
        if(Controller.IsA('EvilPlayerController'))
        {
            EvilPlayerController(Controller).ServerDictatePawnAction(NewAction, InInteractionPawn, InPawnActionFlags);            
        }
        else
        {
            DoPawnAction(NewAction, true, InInteractionPawn, InPawnActionFlags);
        }
        // End:0x131
        if(int(PAToChain) != int(0))
        {
            DoPawnAction(PAToChain, false);
        }        
    }
    //return;    
}

final simulated function PawnActionEnded(byte PrevMove, byte NextMove)
{
    // End:0xA0
    if(int(PrevMove) != 0)
    {
        // End:0x69
        if(PawnActions[int(PrevMove)] != none)
        {
            PawnActions[int(PrevMove)].PawnActionEnded(PrevMove, NextMove);
        }
        // End:0xA0
        if(MyEvilAI != none)
        {
            MyEvilAI.NotifyEndOfPawnAction(PrevMove);
        }
    }
    //return;    
}

final simulated function PawnActionStarted(byte NewMove, byte PrevMove, bool bForced)
{
    local EvilPlayerController PC;

    // End:0xC8
    if(int(NewMove) != 0)
    {
        PC = EvilPlayerController(Controller);
        // End:0x64
        if(PC != none)
        {
            PC.PawnActionStarted(NewMove);
        }
        UpdateFaceFXEmotion();
        // End:0xC8
        if(PawnActions[int(NewMove)] != none)
        {
            PawnActions[int(NewMove)].PawnActionStarted(bForced, PrevMove);
        }
    }
    //return;    
}

simulated function PawnActionAssigned(byte NewMove, byte PrevMove)
{
    PreviousPawnAction = PrevMove;
    //return;    
}

final simulated function DoPawnActionFromStruct(PAStruct InPawnActionStruct, optional bool bForceMove)
{
    DoPawnAction(InPawnActionStruct.PawnAction, bForceMove, InPawnActionStruct.InteractionPawn, InPawnActionStruct.Flags);
    //return;    
}

final simulated function bool VerifyPAHasBeenInstanced(byte AAction)
{
    // End:0x101
    if(int(AAction) != 0)
    {
        // End:0xFF
        if((int(AAction) >= PawnActions.Length) || PawnActions[int(AAction)] == none)
        {
            // End:0xE6
            if((int(AAction) < PawnActionClasses.Length) && PawnActionClasses[int(AAction)] != none)
            {
                PawnActions[int(AAction)] = new (Outer) PawnActionClasses[int(AAction)];
                PawnActions[int(AAction)].PawnOwner = self;                
            }
            else
            {
                PawnActions[int(AAction)] = none;
                return false;
            }
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ClaimCover(CoverLink Link, int SlotIdx)
{
    // End:0x39
    if(Link != none)
    {
        return Link.Claim(self, SlotIdx);
    }
    return false;
    //return ReturnValue;    
}

function bool UnClaimCover(CoverLink Link, int SlotIdx, bool UnClaimAll)
{
    // End:0x43
    if(Link != none)
    {
        return Link.UnClaim(self, SlotIdx, UnClaimAll);
    }
    return false;
    //return ReturnValue;    
}

function Vector GetCoverNormal()
{
    return ((CurrentLink != none) ? -Normal(Vector(CurrentLink.GetSlotRotation(CurrentSlotIdx))) : Normal(Vector(Rotation)));
    //return ReturnValue;    
}

function UpdateCoverActionAnimTransition(bool bInDoingTransition)
{
    bDoingCoverActionAnimTransition = bInDoingTransition;
    //return;    
}

function SetMirroredSide(bool bDesiredMirrored)
{
    bWantsToBeMirrored = bDesiredMirrored;
    //return;    
}

function PAStruct FillPAStructFromParams(byte Act, optional EvilPawn InInteractionPawn, optional int InSpecialActionFlags = 0)
{
    local PAStruct OutPawnActionStruct;

    OutPawnActionStruct.PawnAction = Act;
    OutPawnActionStruct.InteractionPawn = InInteractionPawn;
    OutPawnActionStruct.Flags = InSpecialActionFlags;
    return OutPawnActionStruct;
    //return ReturnValue;    
}

final simulated exec function EndPawnAction(optional byte PawnActionToEnd)
{
    // End:0x9F
    if(IsDoingAPawnAction())
    {
        // End:0x67
        if((int(PawnActionToEnd) != 0) && int(PendingPawnActionStruct.PawnAction) == int(PawnActionToEnd))
        {
            PendingPawnActionStruct = FillPAStructFromParams(0);
        }
        // End:0x9F
        if((int(PawnActionToEnd) == 0) || IsDoingPawnAction(PawnActionToEnd))
        {
            DoPawnAction(0, true);
        }
    }
    //return;    
}

final event ServerEndPawnAction(optional byte PawnActionToEnd)
{
    // End:0x2C
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return;
    }
    // End:0x50
    if(int(PawnActionToEnd) == 0)
    {
        PawnActionToEnd = PawnAction;
    }
    // End:0xCC
    if(int(PawnActionToEnd) != 0)
    {
        EndPawnAction(PawnActionToEnd);
        // End:0xCC
        if(((Controller != none) && Controller.IsA('EvilPlayerController')) && !IsLocallyControlled())
        {
            ReplicatedClientEndPawnAction(PawnActionToEnd);
        }
    }
    //return;    
}

reliable client final simulated function ReplicatedClientEndPawnAction(optional byte PawnActionToEnd)
{
    EndPawnAction(PawnActionToEnd);
    //return;    
}

final simulated event LocalEndPawnAction(optional byte PawnActionToEnd)
{
    // End:0x12
    if(!IsLocallyControlled())
    {
        return;
    }
    // End:0x36
    if(int(PawnActionToEnd) == 0)
    {
        PawnActionToEnd = PawnAction;
    }
    // End:0xCC
    if(int(PawnActionToEnd) != 0)
    {
        EndPawnAction(PawnActionToEnd);
        // End:0xCC
        if(((Controller != none) && Controller.IsA('EvilPlayerController')) && int(WorldInfo.NetMode) == int(NM_Client))
        {
            ReplicatedServerEndPawnAction(PawnActionToEnd);
        }
    }
    //return;    
}

reliable server final simulated function ReplicatedServerEndPawnAction(optional byte PawnActionToEnd)
{
    EndPawnAction(PawnActionToEnd);
    //return;    
}

function bool CanDoLeaningTransition()
{
    return true;
    //return ReturnValue;    
}

function AdjustMyEnemyRatingFor(EvilAIController AIToAdjustFor, out float RatingToAdjust)
{
    RatingToAdjust *= MyEnemyRatingForOthersModifier;
    //return;    
}

final simulated event bool CanDoPawnAction(byte AMove, optional bool bForceCheck)
{
    // End:0xC5
    if((((int(Physics) != int(10)) && int(AMove) != 0) && PawnActionClasses.Length > int(AMove)) && PawnActionClasses[int(AMove)] != none)
    {
        // End:0xC5
        if(VerifyPAHasBeenInstanced(AMove))
        {
            return CanChainPawnAction(AMove) && PawnActions[int(AMove)].super(EvilPawn).CanDoPawnAction(bForceCheck);
        }
    }
    return false;
    //return ReturnValue;    
}

// Export UEvilPawn::execIsDoingAPawnAction(FFrame&, void* const)
native simulated function bool IsDoingAPawnAction();

// Export UEvilPawn::execIsDoingPawnAction(FFrame&, void* const)
native simulated function bool IsDoingPawnAction(byte Action);

final simulated function bool CanChainPawnAction(byte NextMove)
{
    return (((int(PawnAction) == 0) || PawnActions[int(PawnAction)].CanChainAction(NextMove)) || PawnActions[int(PawnAction)].CanOverrideActionWith(NextMove)) || PawnActions[int(NextMove)].CanOverrideAction(PawnAction);
    //return ReturnValue;    
}

simulated event PlayFootStepSound(int FootDown)
{
    super.PlayFootStepSound(FootDown);
    // End:0x4A
    if(MoveModeNode != none)
    {
        MoveModeNode.OnFootstep(FootDown);
    }
    //return;    
}

simulated function ActuallyPlayFootstepSound(int FootDown)
{
    local Actor TraceActor;
    local TraceHitInfo LastFootStepTraceInfo;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

    local SoundCue SC;
    local float Loudness;

    // End:0x16
    if(int(Physics) == int(10))
    {
        return;
    }
    // End:0x92
    if(int(Role) == int(ROLE_Authority))
    {
        Loudness = VSize(Velocity) / GroundSpeed;
        // End:0x92
        if(FRand() < FMin(0.5000000, Loudness ** float(4)))
        {
            MakeNoise((Loudness * Loudness) * Loudness, 'NOISETYPE_FootStep');
        }
    }
    // End:0x12E
    if(FootDown == 0)
    {
        TraceStart = Mesh.GetBoneLocation(LeftFootBoneName, 0) + ((vect(0.0000000, 0.0000000, 1.0000000) * 0.3000000) * (GetCollisionHeight()));
        TraceDest = TraceStart - ((vect(0.0000000, 0.0000000, 1.0000000) * 1.8000000) * (GetCollisionHeight()));        
    }
    else
    {
        TraceStart = Mesh.GetBoneLocation(RightFootBoneName, 0) + ((vect(0.0000000, 0.0000000, 1.0000000) * 0.3000000) * (GetCollisionHeight()));
        TraceDest = TraceStart - ((vect(0.0000000, 0.0000000, 1.0000000) * 1.8000000) * (GetCollisionHeight()));
    }
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, LastFootStepTraceInfo, 1 | 2);
    // End:0x3AD
    if(TraceActor != none)
    {
        // End:0x26C
        if(EvilWaterVolume(TraceActor) != none)
        {
            LastFootStepTraceInfo.PhysMaterial = EvilWaterVolume(TraceActor).WaterPhysMaterial;
        }
        SC = Class'EvilPhysicalMaterialProperty'.static.DetermineFootStepSound(Class'EvilPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(LastFootStepTraceInfo), self, WorldInfo);
        // End:0x2F6
        if(SC != none)
        {
            PlaySound(SC, true, true, false, out_HitLocation, true);
        }
        // End:0x344
        if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            ActuallyPlayFootParticleEffect(FootDown, LastFootStepTraceInfo, out_HitLocation);
        }
        // End:0x3AD
        if((IsLocallyControlled() && EvilPlayerController(Controller) != none) && EvilWeap_Base(Weapon) != none)
        {
            EvilWeap_Base(Weapon).PlayFootStepSound();
        }
    }
    //return;    
}

final simulated function ActuallyPlayFootParticleEffect(int FootDown, TraceHitInfo HitInfo, Vector HitLocation)
{
    local PhysicalMaterial ParentPhysMaterial;
    local ParticleSystem PS, FootStepEffect;
    local Emitter FootStepEmitter;
    local Vector BoneLocation;

    // End:0x5E
    if(HitInfo.PhysMaterial != none)
    {
        FootStepEffect = GetFootStepEffect(HitInfo.PhysMaterial, FootDown);        
    }
    else
    {
        // End:0xD1
        if(HitInfo.Material != none)
        {
            FootStepEffect = GetFootStepEffect(HitInfo.Material.PhysMaterial, FootDown);            
        }
        else
        {
            return;
        }
    }
    // End:0x133
    if(HitInfo.PhysMaterial != none)
    {
        ParentPhysMaterial = HitInfo.PhysMaterial.Parent;        
    }
    else
    {
        // End:0x1BD
        if(HitInfo.Material.PhysMaterial != none)
        {
            ParentPhysMaterial = HitInfo.Material.PhysMaterial.Parent;            
        }
        else
        {
            ParentPhysMaterial = none;
        }
    }
    J0x1C8:

    // End:0x239 [Loop If]
    if((FootStepEffect == none) && ParentPhysMaterial != none)
    {
        FootStepEffect = GetFootStepEffect(ParentPhysMaterial, FootDown);
        ParentPhysMaterial = ParentPhysMaterial.Parent;
        // [Loop Continue]
        goto J0x1C8;
    }
    // End:0x25E
    if(FootStepEffect != none)
    {
        PS = FootStepEffect;        
    }
    else
    {
        return;
    }
    BoneLocation = HitLocation;
    // End:0x360
    if((BoneLocation != vect(0.0000000, 0.0000000, 0.0000000)) && WorldInfo.GRI != none)
    {
        FootStepEmitter = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactEmitter(PS, BoneLocation, Rotation);
        FootStepEmitter.ParticleSystemComponent.ActivateSystem();
    }
    //return;    
}

final function ParticleSystem GetFootStepEffect(PhysicalMaterial PMaterial, int FootDown)
{
    local ParticleSystem Retval;

    Retval = none;
    // End:0xB6
    if(((none != PMaterial) && none != PMaterial.PhysicalMaterialProperty) && none != EvilPhysicalMaterialPropertyBase(PMaterial.PhysicalMaterialProperty))
    {
        Retval = GetSpecificFootStepEffect(EvilPhysicalMaterialPropertyBase(PMaterial.PhysicalMaterialProperty), FootDown);        
    }
    else
    {
        Retval = none;
    }
    return Retval;
    //return ReturnValue;    
}

function ParticleSystem GetSpecificFootStepEffect(EvilPhysicalMaterialPropertyBase FootstepSounds, int FootDown)
{
    local ParticleSystem Retval;

    // End:0x4D
    if(GroundSpeed > (GroundSpeed * WalkingPct))
    {
        Retval = FootstepSounds.FootstepEffectRun;        
    }
    else
    {
        Retval = FootstepSounds.FootstepEffectWalk;
    }
    return Retval;
    //return ReturnValue;    
}

function ThrowWeaponOnRagdoll()
{
    //return;    
}

function bool ShouldIgnoreProjectiles()
{
    return false;
    //return ReturnValue;    
}

function TossInventory(Inventory Inv, optional Vector ForceVelocity)
{
    local Vector POVLoc, TossVel;
    local Rotator POVRot;
    local Vector X, Y, Z;

    // End:0x12
    if(Inv == none)
    {
        return;
    }
    // End:0x43
    if(ForceVelocity != vect(0.0000000, 0.0000000, 0.0000000))
    {
        TossVel = ForceVelocity;        
    }
    else
    {
        GetActorEyesViewPoint(POVLoc, POVRot);
        TossVel = Vector(POVRot);
        TossVel = (TossVel * ((Velocity Dot TossVel) + float(120))) + vect(0.0000000, 0.0000000, 50.0000000);
    }
    GetAxes(Rotation, X, Y, Z);
    Inv.DropFrom((Location + ((0.8000000 * CylinderComponent.CollisionRadius) * X)) - ((0.5000000 * CylinderComponent.CollisionRadius) * Y), TossVel);
    // End:0x2D9
    if(((EvilWeap_Base(Inv) != none) && !EvilWeap_Base(Inv).UsesOffhand) && EvilWeap_Base(Inv).OffHandWeaponClass != none)
    {
        // End:0x2D9
        if(FindInventoryType(EvilWeap_Base(Inv).OffHandWeaponClass) != none)
        {
            FindInventoryType(EvilWeap_Base(Inv).OffHandWeaponClass).DropFrom((Location + ((0.8000000 * CylinderComponent.CollisionRadius) * X)) - ((0.5000000 * CylinderComponent.CollisionRadius) * Y), TossVel);
        }
    }
    //return;    
}

simulated function bool CanThrowWeaponAlt()
{
    return (WeaponLeft != none) && WeaponLeft.CanThrow();
    //return ReturnValue;    
}

simulated function ThrowInventory(Inventory Inv, optional Vector ForceVelocity, optional bool bAlternateWeapon)
{
    local Vector Loc, TossVel;
    local Rotator Rot;
    local Vector X, Y, Z;

    GetAxes(Rotation, X, Y, Z);
    Mesh.GetSocketWorldLocationAndRotation(((bAlternateWeapon) ? WeaponSocket2 : WeaponSocket), Loc, Rot, 0);
    // End:0xAC
    if(ForceVelocity != vect(0.0000000, 0.0000000, 0.0000000))
    {
        TossVel = ForceVelocity;        
    }
    else
    {
        TossVel = X;
        TossVel = (TossVel * ((Velocity Dot TossVel) + float(1500))) + vect(0.0000000, 0.0000000, 120.0000000);
    }
    // End:0x155
    if(EvilWeap_Base(Inv) != none)
    {
        EvilWeap_Base(Inv).ThrowFrom(Loc, TossVel);        
    }
    else
    {
        Inv.DropFrom(Loc, TossVel);
    }
    //return;    
}

simulated function OnStartThrow()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStartThrow();
    }
    //return;    
}

simulated function OnStartThrowAlt()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStartThrowAlt();
    }
    //return;    
}

simulated function OnStopThrow()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStopThrow();
    }
    //return;    
}

simulated function OnStartFire()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStartFire();
    }
    UpdateFaceFXEmotion(2);
    //return;    
}

simulated function OnStartFireAlt()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStartFireAlt();
    }
    UpdateFaceFXEmotion(2);
    //return;    
}

simulated function OnStopFireWithLag()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStopFireWithLag();
    }
    //return;    
}

simulated function OnStopFire()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStopFire();
    }
    //return;    
}

simulated function OnStopFireAlt()
{
    // End:0x2E
    if(MyEvilAI != none)
    {
        MyEvilAI.OnStopFireAlt();
    }
    //return;    
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
    // End:0x7A
    if(WorldInfo.GRI.IsMultiplayerGame() && int(WorldInfo.NetMode) != int(NM_Client))
    {
        PlaySound(TeleportSound);
    }
    //return;    
}

simulated function OnFinisherAnimBlendToMotors()
{
    // End:0x46
    if(int(PawnAction) == 31)
    {
        EPA_DeathAnimWithoutMotors(PawnActions[int(PawnAction)]).OnAnimBlendToMotors();
    }
    //return;    
}

simulated function OnDeathAnimBodyRest()
{
    // End:0x93
    if((int(PawnAction) == 3) || int(PawnAction) == 31)
    {
        DropClothesOnRagdoll(CurrentDamageType, CurrentHitInformation.HitLocation, Velocity, true);
        EPA_DeathAnimBase(PawnActions[int(PawnAction)]).OnDeathAnimBodyRest();
    }
    //return;    
}

simulated event OnRigidBodySpringOverextension(RB_BodyInstance BodyInstance)
{
    super(Actor).OnRigidBodySpringOverextension(BodyInstance);
    // End:0x62
    if(int(PawnAction) == 3)
    {
        EPA_DeathAnim(PawnActions[int(PawnAction)]).OnRigidBodySpringOverextension(BodyInstance);
    }
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local bool Result;

    // End:0x19
    if(DrivenVehicle != none)
    {
        KickPawnOffVehicle();
    }
    // End:0x5B
    if(EvilRailCar_Base(ClampedBase) != none)
    {
        EvilRailCar_Base(ClampedBase).DetachPawn(self, true);
    }
    Result = super.Died(Killer, DamageType, HitLocation);
    // End:0xCA
    if(Result)
    {
        // End:0xCA
        if(MeleeKickWeap != none)
        {
            MeleeKickWeap.Destroy();
            MeleeKickWeap = none;
        }
    }
    SpawnCompleted(1);
    // End:0x18D
    if((!IsPlayerPawn() && WorldInfo.Game != none) && EvilGame(WorldInfo.Game) != none)
    {
        EvilGame(WorldInfo.Game).AIDirectorInstance.RemoveMonitoredPawn(self);
    }
    // End:0x1C6
    if(BurnLightActor != none)
    {
        BurnLightActor.Deactivate();
        BurnLightActor = none;
    }
    return Result;
    //return ReturnValue;    
}

simulated event Destroyed()
{
    // End:0xB7
    if((!IsPlayerPawn() && WorldInfo.Game != none) && EvilGame(WorldInfo.Game) != none)
    {
        EvilGame(WorldInfo.Game).AIDirectorInstance.RemoveMonitoredPawn(self);
    }
    // End:0xF0
    if((int(PawnAction) != 0) && PawnActions[int(PawnAction)] != none)
    {
        EndPawnAction();
    }
    PawnActions.Length = 0;
    ClearAnimNodes();
    CurrentNavPointAction = none;
    super.Destroyed();
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    local Vector ShotDir;
    local TraceHitInfo HitInfo;
    local PlayerController PC;
    local class<EvilDmgType_Base> EvilDamageType;
    local class<UDKEmitCameraEffect> CameraEffect;
    local int DeathAnimIndex;
    local EvilTypesNative.EAnimationSetType AST;
    local EvilAnimInfo AnimInfo;
    local int Index;

    bCanTeleport = false;
    bReplicateMovement = false;
    bPlayedDeath = true;
    bForcedFeignDeath = false;
    bPlayingFeignDeathRecovery = false;
    HitDamageType = DamageType;
    TakeHitLocation = HitLoc;
    CurrentWeaponAttachmentClass = none;
    WeaponAttachmentChanged();
    // End:0x13C
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x13B
        if(PC.ViewTarget == self)
        {
            // End:0x138
            if(UTHUD(PC.myHUD) != none)
            {
                UTHUD(PC.myHUD).DisplayHit(HitLoc, 100, DamageType);
            }
            // End:0x13C
            break;
        }        
    }    
    EvilDamageType = class<EvilDmgType_Base>(DamageType);
    // End:0x1C8
    if(GoreSettings != none)
    {
        GoreSettings.GetClassification(EvilDamageType, CurrentHitInformation.DamageClassification, CurrentHitInformation.GibClassification);
    }
    // End:0x23C
    if((EvilDamageType != none) && ShouldGib(EvilDamageType))
    {
        InstantGib(1, EvilDamageType, CurrentHitInformation.HitLocation, CurrentHitInformation.Momentum);
    }
    CheckHitInfo(HitInfo, Mesh, Normal(TearOffMomentum), TakeHitLocation);
    // End:0x35A
    if(EvilDamageType != none)
    {
        // End:0x2D8
        if(EvilDamageType.default.bUseDamageBasedDeathEffects)
        {
            EvilDamageType.static.DoCustomDamageEffects(self, EvilDamageType, HitInfo, TakeHitLocation);
        }
        // End:0x35A
        if(EvilPlayerController(PC) != none)
        {
            CameraEffect = EvilDamageType.static.GetDeathCameraEffectVictim(self);
            // End:0x35A
            if(CameraEffect != none)
            {
                UTPlayerController(PC).ClientSpawnCameraEffect(CameraEffect);
            }
        }
    }
    // End:0x3C8
    if(MyEvilAI != none)
    {
        MyEvilAI.bAllowCombatTransitions = false;
        MyEvilAI.AbortCommand(MyEvilAI.CommandList);
    }
    // End:0x69A
    if(bForcePlayDeathAnimation || (((!bPotentiallyCanPlayKnockDown && CanDoPawnAction(3)) && CurrentHitInformation.DamageClassification.bIsValid) && !CurrentHitInformation.DamageClassification.bRagdoll) && !bGibbed)
    {
        // End:0x697
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            DeathAnimIndex = GetDeathAnimIndex(EvilDamageType, HitLoc);
            Class'EvilPawn'.static.UnpackAnimInfo(DeathAnimIndex, AST, Index);
            // End:0x59B
            if(AST_GetAnimInfo(AST, Index, AnimInfo))
            {
                // End:0x59B
                if((InStr(string(AnimInfo.AnimName), "Long") > -1) || InStr(string(AnimInfo.AnimName), "InRun") > -1)
                {
                    bDeathAnimationWithoutMotors = true;
                }
            }
            // End:0x621
            if(bDeathAnimationWithoutMotors)
            {
                ServerDoPawnAction(31, true, ((CurrentHitInformation.EventInstigator != none) ? EvilPawn(CurrentHitInformation.EventInstigator.Pawn) : none), DeathAnimIndex);                
            }
            else
            {
                ServerDoPawnAction(3, true, ((CurrentHitInformation.EventInstigator != none) ? EvilPawn(CurrentHitInformation.EventInstigator.Pawn) : none), DeathAnimIndex);
            }
        }        
    }
    else
    {
        bTearOff = true;
        DropClothesOnRagdoll(EvilDamageType, HitLoc, Velocity, true);
        Mesh.SetNotifyRigidBodyCollision(true);
        Mesh.ScriptRigidBodyCollisionThreshold = 1000.0000000;
        DoPawnAction(0, true);
        StopAllAnimations();
        bBlendOutTakeHitPhysics = false;
        SetHandIKEnabled(false);
        // End:0x759
        if(int(Physics) == int(10))
        {
            SetPhysics(2);
        }
        PreRagdollCollisionComponent = CollisionComponent;
        CollisionComponent = Mesh;
        Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
        // End:0x805
        if(Mesh.bNotUpdatingKinematicDueToDistance)
        {
            Mesh.ForceSkelUpdate();
            Mesh.UpdateRBBonesFromSpaceBases(true, true);
        }
        Mesh.PhysicsWeight = 1.0000000;
        SetPhysics(10);
        Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
        SetPawnRBChannels(true);
        // End:0x8DF
        if(TearOffMomentum != vect(0.0000000, 0.0000000, 0.0000000))
        {
            ShotDir = Normal(TearOffMomentum);
            ApplyPlayDyingRagdollImpulse(ShotDir, HitLoc, HitInfo.BoneName, EvilDamageType);
        }
    }
    GotoState('Dying');
    //return;    
}

simulated function ApplyPlayDyingRagdollImpulse(Vector ShotDir, Vector HitLocation, name BoneName, class<EvilDmgType_Base> DamageType)
{
    local Vector ApplyImpulse;

    ApplyImpulse = (ShotDir * DamageType.default.KDamageImpulse) * CurrentHitInformation.DamageClassification.RagdollMomentumScale;
    // End:0xC4
    if(Velocity.Z > float(-10))
    {
        ApplyImpulse += (vect(0.0000000, 0.0000000, 1.0000000) * DamageType.default.KDeathUpKick);
    }
    Mesh.SetRBLinearVelocity(ApplyImpulse + Velocity);
    //return;    
}

simulated function ClientAddDeathImpulse(class<EvilDmgType_Base> DamageType)
{
    local int I;
    local Vector ApplyImpulse, tmpBestHitLoc;
    local name nearestBone;
    local array<name> AcceptedBoneNames;

    I = 0;
    J0x0B:

    // End:0xFF [Loop If]
    if(I < LastDamageCollectionIndex)
    {
        ApplyImpulse = ComputeDeathRagdollImpulse(DamageLocations[I] - DamageInstigatorLocation, DamageType, false);
        Class'EvilWeap_Base'.static.FindNearestBone(self, DamageLocations[I], nearestBone, tmpBestHitLoc, AcceptedBoneNames);
        Mesh.AddImpulse(ApplyImpulse, DamageLocations[I], nearestBone, false);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function SetDyingPhysics()
{
    //return;    
}

function CheckSoundEffects()
{
    // End:0xE2
    if((((int(Physics) != int(10)) || VSize(Velocity) < 8.0000000) || !Mesh.RigidBodyIsAwake()) && !FullBodyAnimSlot.bIsPlayingCustomAnim)
    {
        // End:0xDF
        if(FacialAudioComp.IsPlaying() && !FacialAudioComp.IsFadingOut())
        {
            FacialAudioComp.Stop();
        }        
    }
    else
    {
        SetTimer(0.0500000, false, 'CheckSoundEffects');
    }
    //return;    
}

function PlayDyingSound()
{
    // End:0x30
    if(!IsBurning() && int(GetFacialCompnentSoundSetType()) != int(2))
    {
        super.PlayDyingSound();
    }
    //return;    
}

simulated function Vector ComputeDeathRagdollAngularImpulse(Vector HitLoc, name BoneName, optional bool checkdiedTimer = false)
{
    local float impulseScale;
    local Vector ret, CMassBodyLocation;

    impulseScale = 1.0000000;
    ret = vect(0.0000000, 0.0000000, 0.0000000);
    // End:0x62
    if(checkdiedTimer && !IsTimerActive('TrueDied_T'))
    {
        impulseScale = 0.1000000;
    }
    // End:0xF1
    if(Class'EvilPawn'.static.GetGlobalCMassLocation(Mesh, CMassBodyLocation, BoneName))
    {
        ret = HitLoc;
        ret -= CMassBodyLocation;
        ret = Normal(ret Cross HitLoc) * impulseScale;
    }
    return ret;
    //return ReturnValue;    
}

simulated function Vector ComputeDeathRagdollImpulse(Vector ShotDir, class<EvilDmgType_Base> DamageType, optional bool checkdiedTimer = false)
{
    local float impulseScale;
    local Vector ret;

    impulseScale = 1.0000000;
    ShotDir.Z = 0.0000000;
    ShotDir = Normal(ShotDir);
    ret = ((DamageType.default.KDeathVel * ShotDir) * impulseScale) * RandRange(0.7000000, 1.0000000);
    // End:0x11A
    if(DamageType.default.bThrowRagdoll)
    {
        ret += (((vect(0.0000000, 0.0000000, 1.0000000) * DamageType.default.KDeathUpKick) * impulseScale) * RandRange(0.7000000, 1.0000000));
    }
    return ret;
    //return ReturnValue;    
}

simulated function AddBaseLinearVelocityUponWhenGoingRagDoll()
{
    local Actor TestBase;

    TestBase = Base;
    // End:0x35
    if(ClampedBase != none)
    {
        TestBase = ClampedBase;
    }
    // End:0x85
    if((TestBase != none) && TestBase == InteractionPawn)
    {
        TestBase = InteractionPawn.Base;
    }
    // End:0xF8
    if((TestBase != none) && !TestBase.bStatic)
    {
        Mesh.SetRBLinearVelocity(TestBase.Velocity, false);
    }
    //return;    
}

simulated function StopAllAnimations()
{
    local AnimNodeSequence SeqNode;

    // End:0x56
    foreach Mesh.AllAnimNodes(Class'Engine.AnimNodeSequence', SeqNode)
    {
        SeqNode.bPlaying = false;        
    }    
    // End:0x14B
    if(!AnimTree(Mesh.Animations).bUseSavedPose)
    {
        AnimTree(Mesh.Animations).SetUseSavedPose(true);
        AnimTree(Mesh.Animations).Children[0].Anim = none;
        Mesh.bUpdateSkelWhenNotRendered = false;
    }
    //return;    
}

final simulated function PauseAllAnimations()
{
    local AnimNodeSequence SeqNode;

    // End:0x9F
    if(ResumePlayNodes.Length == 0)
    {
        // End:0x9E
        foreach Mesh.AllAnimNodes(Class'Engine.AnimNodeSequence', SeqNode)
        {
            // End:0x7C
            if(SeqNode.bPlaying)
            {
                ResumePlayNodes.AddItem(SeqNode);
            }
            SeqNode.bPlaying = false;            
        }        
    }
    //return;    
}

final simulated function ResumeAllAnimations()
{
    local AnimNodeSequence SeqNode;

    // End:0x39
    foreach ResumePlayNodes(SeqNode)
    {
        SeqNode.bPlaying = true;        
    }    
    ResumePlayNodes.Length = 0;
    //return;    
}

function HandleMomentum(Vector Momentum, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    // End:0x43
    if(int(Physics) == int(10))
    {
        AddVelocity(Momentum, HitLocation, DamageType, HitInfo);
    }
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    local EvilDestroyPackBase OtherDestroyPack;

    super(Actor).Bump(Other, OtherComp, HitNormal);
    OtherDestroyPack = EvilDestroyPackBase(Other);
    // End:0xC0
    if(((OtherDestroyPack != none) && !IsPlayerPawn()) && VSize(OtherDestroyPack.Velocity) > float(200))
    {
        Knockdown(OtherDestroyPack.Velocity, VRand() * float(4));
    }
    //return;    
}

protected simulated function ApplyKnockdownImpulse()
{
    // End:0x2D5
    if((int(Physics) != int(10)) || Mesh != CollisionComponent)
    {
        DropClothesOnRagdoll(Class'Engine.DamageType', vect(0.0000000, 0.0000000, 0.0000000), KnockdownImpulse.LinearVelocity, false);
        // End:0x83
        if(int(Physics) == int(10))
        {
            SetPhysics(2);
        }
        Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
        SetPawnRBChannels(true);
        Mesh.ForceSkelUpdate();
        Mesh.SetTickGroup(2);
        SetTickGroup(2);
        bBlendOutTakeHitPhysics = false;
        PreRagdollCollisionComponent = CollisionComponent;
        CollisionComponent = Mesh;
        CylinderComponent.SetActorCollision(true, false);
        Mesh.SetActorCollision(true, false);
        SetPhysics(10);
        Mesh.PhysicsWeight = 1.0000000;
        // End:0x1E0
        if(Mesh.bNotUpdatingKinematicDueToDistance)
        {
            Mesh.UpdateRBBonesFromSpaceBases(true, true);
        }
        Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
        Mesh.bUpdateKinematicBonesFromAnimation = false;
        Mesh.SetTranslation(vect(0.0000000, 0.0000000, 1.0000000) * BaseTranslationOffset);
        Mesh.ScriptRigidBodyCollisionThreshold = MaxFallSpeed;
        Mesh.SetNotifyRigidBodyCollision(true);
        Mesh.WakeRigidBody();
    }
    ApplyKnockdownForceAndVelocity();
    //return;    
}

simulated function ApplyKnockdownForceAndVelocity()
{
    // End:0x177
    if(int(Physics) == int(10))
    {
        Mesh.SetRBAngularVelocity(KnockdownImpulse.AngularVelocity, false);
        // End:0xB0
        if(!IsZero(KnockdownImpulse.LinearVelocity))
        {
            Mesh.SetRBLinearVelocity(KnockdownImpulse.LinearVelocity, true);
        }
        // End:0x174
        if((KnockdownImpulse.RadialRadius > 0.0000000) && KnockdownImpulse.RadialStrength > 0.0000000)
        {
            Mesh.AddRadialImpulse(KnockdownImpulse.RadialOrigin, KnockdownImpulse.RadialRadius, KnockdownImpulse.RadialStrength, 1);
        }        
    }
    //return;    
}

simulated function bool CanBeKnockedDown()
{
    return bCanBeKnockedDown;
    //return ReturnValue;    
}

reliable server function Knockdown(optional Vector LinearVelocityImpulse, optional Vector AngularVelocityImpulse, optional Vector RadialOrigin, optional float RadialRadius, optional float RadialStrength, optional bool bAutoRecover = true)
{
    local PhysicsImpulseInfo NewKnockdownImpulse;

    // End:0x31
    if((int(Role) < int(ROLE_Authority)) || !CanBeKnockedDown())
    {
        return;
    }
    // End:0x45
    if(int(PawnAction) == 14)
    {
        return;
    }
    // End:0x8B
    if(int(PawnAction) == 3)
    {
        EPA_DeathAnim(PawnActions[int(PawnAction)]).OnPawnKnockDown();
    }
    NewKnockdownImpulse.LinearVelocity = LinearVelocityImpulse;
    NewKnockdownImpulse.LinearVelocity.Z += 0.0010000;
    NewKnockdownImpulse.AngularVelocity = AngularVelocityImpulse;
    NewKnockdownImpulse.RadialOrigin = RadialOrigin;
    NewKnockdownImpulse.RadialRadius = RadialRadius;
    NewKnockdownImpulse.RadialStrength = RadialStrength;
    KnockdownImpulse = NewKnockdownImpulse;
    FullBodyAnimSlot.StopCustomAnim(0.0000000);
    TopHalfAnimSlot.StopCustomAnim(0.0000000);
    ApplyKnockdownImpulse();
    // End:0x1F3
    if(bPlayedDeath)
    {
        return;
    }
    // End:0x211
    if(bAutoRecover)
    {
        GotoState('KnockedDown');        
    }
    else
    {
        GotoState('KnockedDown', 'SkipRecover');
    }
    //return;    
}

function KickPawnOffVehicle()
{
    // End:0x2F
    if(DrivenVehicle != none)
    {
        DrivenVehicle.DriverLeave(true);
    }
    //return;    
}

function Rotator GetRagdollOrientation()
{
    local Rotator NewRotation;
    local int OrientationBodyIndex;
    local Matrix BodyTM;
    local name OrientationBoneName;

    OrientationBoneName = 'Spine';
    OrientationBodyIndex = Mesh.PhysicsAsset.FindBodyIndex(OrientationBoneName);
    // End:0x111
    if(OrientationBodyIndex != -1)
    {
        BodyTM = Mesh.PhysicsAssetInstance.Bodies[OrientationBodyIndex].GetUnrealWorldTM();
        NewRotation.Yaw = Rotator(MatrixGetAxis(BodyTM, 1)).Yaw;
    }
    return NewRotation;
    //return ReturnValue;    
}

function EndKnockedDownState()
{
    local EvilTypes.EHitDirectionType ComputedDirection;
    local Vector DirToEnemy, LookDir;

    ComputedDirection = 0;
    ClearTimer('EndKnockedDownState');
    ClearTimer('CheckGetUpFromRagdoll');
    ClearTimer('KnockdownFailsafe');
    KnockdownImpulse.LinearVelocity = vect(0.0000000, 0.0000000, 0.0000000);
    KnockdownImpulse.AngularVelocity = vect(0.0000000, 0.0000000, 0.0000000);
    // End:0xE7
    if(CheckIfFeltInBadPlace())
    {
        TakeDamage(Health + 1000, none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilDmgType_Fell',, self);
        return;
    }
    // End:0x1EF
    if((Health > 0) && int(Physics) == int(10))
    {
        // End:0x1C7
        if((MyEvilAI.Enemy != none) && bCanPlayRecoverAnimationTowardsEnemy)
        {
            DirToEnemy = Normal(Location - MyEvilAI.Enemy.Location);
            LookDir = Normal(Vector(GetRagdollOrientation()));
            ComputedDirection = GetDirection(DirToEnemy, LookDir);
        }
        ServerDoPawnAction(13, true,, int(ComputedDirection));
        GotoState('Auto');
    }
    //return;    
}

function bool CheckMirrorTransition(CoverLink.ECoverAction CovAct, optional bool bCheckAiming = true)
{
    local int YawDelta;

    YawDelta = Class'EvilAnim_TurnInPlace'.static.CheckYawDelta(self, AimRotation.Yaw);
    // End:0x71
    if(IsRightCoverAction(CovAct))
    {
        bWantsToBeMirrored = false;        
    }
    else
    {
        // End:0x96
        if(IsLeftCoverAction(CovAct))
        {
            bWantsToBeMirrored = true;            
        }
        else
        {
            // End:0xDB
            if((YawDelta >= 0) && !bCheckAiming || int(CurrentAimZone) != int(0))
            {
                bWantsToBeMirrored = false;                
            }
            else
            {
                // End:0x11D
                if((YawDelta < 0) && !bCheckAiming || int(CurrentAimZone) != int(0))
                {
                    bWantsToBeMirrored = true;
                }
            }
        }
    }
    return bWantsToBeMirrored != bIsMirrored;
    //return ReturnValue;    
}

function FireSpinUpFromRecover()
{
    // End:0x3D
    if(int(PawnAction) == 13)
    {
        EPA_RecoverFromRagdoll(PawnActions[13]).FireSpinUpFromRecover();
    }
    //return;    
}

function CheckGetUpFromAnimation()
{
    local int AnimIndex;

    // End:0x133
    if(int(WakeInformation.RecoverID) != int(0))
    {
        AnimIndex = GetWakeAnimation(WakeInformation.LayAnimID, true);
        // End:0xF3
        if(AnimIndex != -1)
        {
            ServerDoPawnAction(14, true,, Class'EPA_Emerge'.static.EncodeEmergeInfo(AnimIndex, 0, 0, WakeInformation.LayAnimID));
            EPA_Emerge(PawnActions[14]).DoEmerge();            
        }
        else
        {
            FullBodyAnimSlot.StopCustomAnim(0.2000000);
            ServerDoPawnAction(0, true);
            SpawnCompleted(0);
        }
    }
    //return;    
}

function CheckGetUpFromRagdoll()
{
    // End:0x73
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x73
        if(int(Physics) == int(10))
        {
            // End:0x4A
            if(VSize(Velocity) < 8.0000000)
            {
                EndKnockedDownState();                
            }
            else
            {
                SetTimer(0.2500000 + RandRange(0.2500000, 0.5000000), false, 'CheckGetUpFromRagdoll');
            }
        }
    }
    //return;    
}

function bool CheckIfFeltInBadPlace()
{
    // End:0x35
    if((MyEvilAI != none) && MyEvilAI.CheckIfNotOnNavmesh())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event StartFeignDeathRecoveryAnim()
{
    // End:0x46
    if(int(PawnAction) == 13)
    {
        EPA_RecoverFromRagdoll(PawnActions[int(PawnAction)]).StartFeignDeathRecoveryAnim();
    }
    //return;    
}

simulated exec function FeignDeath()
{
    //return;    
}

function SetMovementPhysics()
{
    // End:0x0F
    if(bIgnoreSetMovementPhysics)
    {
        return;
    }
    // End:0x39
    if(PhysicsVolume.bWaterVolume)
    {
        SetPhysics(3);        
    }
    else
    {
        // End:0x52
        if(int(Physics) != int(2))
        {
            SetPhysics(2);
        }
    }
    //return;    
}

simulated event BecomeViewTarget(PlayerController PC)
{
    local EvilPlayerController UTPC;

    super(Pawn).BecomeViewTarget(PC);
    // End:0x126
    if(LocalPlayer(PC.Player) != none)
    {
        PawnAmbientSound.bAllowSpatialization = false;
        WeaponAmbientSound.bAllowSpatialization = false;
        bArmsAttached = true;
        AttachComponent(ArmsMesh[0]);
        AttachComponent(ArmsMesh[1]);
        UTPC = EvilPlayerController(PC);
        // End:0x10F
        if(UTPC != none)
        {
            SetMeshVisibility(UTPC.bBehindView);            
        }
        else
        {
            SetMeshVisibility(true);
        }
        bUpdateEyeheight = true;
    }
    //return;    
}

simulated event ReachedCoverSlot(int SlotIdx)
{
    CurrentSlotIdx = SlotIdx;
    ClosestSlotIdx = SlotIdx;
    SetCurrentCoverType();
    //return;    
}

simulated function SetCurrentWeaponClassString(string WeapClassStr, optional bool bForce = false)
{
    local class<EvilWeap_Base> WeaponClass;

    WeaponClass = class<EvilWeap_Base>(DynamicLoadObject(WeapClassStr, Class'Core.Class'));
    SetCurrentWeaponClass(WeaponClass, bForce);
    //return;    
}

simulated function SetCurrentWeaponClass(class<EvilWeap_Base> WeapClass, optional bool bForce = false)
{
    local EvilWeap_Base Weap;

    // End:0x22
    if(WeapClass == none)
    {
        Weap = none;        
    }
    else
    {
        Weap = EvilWeap_Base(EvilInvManager.FindInventoryType(WeapClass));
    }
    // End:0xAE
    if(bForce)
    {
        // End:0x83
        if(IsSprinting)
        {
            SetSprint(false);
        }
        EvilInvManager.ForceWeapon(Weap);        
    }
    else
    {
        EvilInvManager.SetCurrentWeapon(Weap);
    }
    //return;    
}

simulated function SetCurrentWeaponLeftClassString(string WeapClassStr, optional bool bForce = false)
{
    local class<EvilWeap_Base> WeaponClass;

    WeaponClass = class<EvilWeap_Base>(DynamicLoadObject(WeapClassStr, Class'Core.Class'));
    SetCurrentWeaponLeftClass(WeaponClass, bForce);
    //return;    
}

simulated function SetCurrentWeaponLeftClass(class<EvilWeap_Base> WeapClass, optional bool bForce = false)
{
    local EvilWeap_Base Weap;

    // End:0x22
    if(WeapClass == none)
    {
        Weap = none;        
    }
    else
    {
        Weap = EvilWeap_Base(EvilInvManager.FindInventoryType(WeapClass));
    }
    // End:0xB0
    if((Weap != none) && Weap.BothHandWeapon)
    {
        SetCurrentWeaponClass(WeapClass, bForce);
        return;
    }
    // End:0x100
    if(bForce)
    {
        // End:0xD5
        if(IsSprinting)
        {
            SetSprint(false);
        }
        EvilInvManager.ForceWeaponLeft(Weap);        
    }
    else
    {
        EvilInvManager.SetCurrentWeaponLeft(Weap);
    }
    //return;    
}

simulated function SetBlockingInventoryClass(class<Inventory> InvClass, optional bool InLeftHand = false)
{
    // End:0x3D
    if(InLeftHand)
    {
        EvilInvManager.BlockingClassLeft = InvClass;        
    }
    else
    {
        EvilInvManager.BlockingClass = InvClass;
    }
    //return;    
}

simulated function SetEvilWeapAnimType(EvilTypes.EEvilWeapAnimType EvilAnimType)
{
    local UDKAnimNodeSeqWeap nsw;
    local name AimProfile;

    // End:0xDA
    if(EvilAimNode != none)
    {
        switch(EvilAnimType)
        {
            // End:0xFFFF
            default:
                AimProfile = 'Default';
                // End:0x3B
                break;
                break;
        }
        // End:0xB1
        foreach CopyBoneTranslationNode.SeqWeaps(nsw)
        {
            // End:0xB0
            if(EvilAnimNodeSeqWeap(nsw) != none)
            {
                EvilAnimNodeSeqWeap(nsw).EvilWeapTypeChanged(AimProfile);
            }            
        }        
        EvilAimNode.SetActiveProfileByName(AimProfile);
    }
    //return;    
}

simulated function SetWeapAnimType(UTPawn.EWeapAnimType AnimType)
{
    super.SetWeapAnimType(AnimType);
    // End:0x128
    if(AimNode != none)
    {
        switch(AnimType)
        {
            // End:0x65
            case 0:
                AimNode.SetActiveProfileByName('Default');
                // End:0x128
                break;
            // End:0x95
            case 1:
                AimNode.SetActiveProfileByName('SinglePistol');
                // End:0x128
                break;
            // End:0xC5
            case 2:
                AimNode.SetActiveProfileByName('DualPistols');
                // End:0x128
                break;
            // End:0xF5
            case 3:
                AimNode.SetActiveProfileByName('ShoulderRocket');
                // End:0x128
                break;
            // End:0x125
            case 4:
                AimNode.SetActiveProfileByName('Stinger');
                // End:0x128
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

simulated function SetWeaponVisibility(bool bWeaponVisible)
{
    local EvilWeap_Base Weap;
    local AnimNodeSequence WeaponAnimNode, ArmAnimNode;
    local int I;

    Weap = EvilWeap_Base(Weapon);
    // End:0x1D0
    if(Weap != none)
    {
        Weap.ChangeVisibility(bWeaponVisible);
        WeaponAnimNode = Weap.GetWeaponAnimNodeSeq();
        // End:0x1D0
        if(WeaponAnimNode != none)
        {
            I = 0;
            J0x97:

            // End:0x1D0 [Loop If]
            if(I < 2)
            {
                // End:0x1C2
                if(ArmsMesh[I].bAttached)
                {
                    ArmAnimNode = Weap.GetArmAnimNodeSeq();
                    // End:0x1C2
                    if(ArmAnimNode != none)
                    {
                        ArmAnimNode.SetAnim(WeaponAnimNode.AnimSeqName);
                        ArmAnimNode.PlayAnim(WeaponAnimNode.bLooping, WeaponAnimNode.Rate, WeaponAnimNode.CurrentTime);
                    }
                }
                I++;
                // [Loop Continue]
                goto J0x97;
            }
        }
    }
    //return;    
}

simulated function SetFiringLeft(Weapon InWeapon, bool IsFiringLeft)
{
    // End:0x3A
    if(bFiringLeft != IsFiringLeft)
    {
        bFiringLeft = IsFiringLeft;
        bForceNetUpdate = true;
    }
    //return;    
}

simulated function SetPuttingDownWeaponLeft(bool bNowPuttingDownWeapon)
{
    // End:0x7C
    if((bPuttingDownWeaponLeft != bNowPuttingDownWeapon) || int(Role) < int(ROLE_Authority))
    {
        bPuttingDownWeaponLeft = bNowPuttingDownWeapon;
        // End:0x7C
        if(CurrentWeaponLeftAttachment != none)
        {
            CurrentWeaponLeftAttachment.SetPuttingDownWeapon(bPuttingDownWeaponLeft);
        }
    }
    //return;    
}

simulated function bool GetPuttingDownWeaponLeft()
{
    return bPuttingDownWeaponLeft;
    //return ReturnValue;    
}

function EquipRandomInventory()
{
    //return;    
}

simulated function EquipWeaponClient()
{
    //return;    
}

simulated function EquipShieldClient()
{
    local EvilPawnClothAssetInterface DressUpAsset;

    // End:0x29
    if(int(ReplicatedClothShield.MaterialIndex) == int(255))
    {
        return;
    }
    DressUpAsset = new ClothesSettings.Shields[int(ReplicatedClothShield.MaterialIndex)].ShieldAsset.Class (ClothesSettings.Shields[int(ReplicatedClothShield.MaterialIndex)].ShieldAsset);
    // End:0x19A
    if(ClothesSettings.Shields[int(ReplicatedClothShield.MaterialIndex)].ShieldAsset.GetRandomMaterialsAmount() > 0)
    {
        DressUpAsset.ISetMaterialFromRandomMaterials(int(ReplicatedClothShield.RandomMaterialIndex));
    }
    DressUpAsset.AttachCloth(self);
    //return;    
}

function EquipWeapon(class<Inventory> InvClass)
{
    //return;    
}

function EquipShield(class<Inventory> InvClass)
{
    local int Index, I;

    // End:0x11
    if(ClothesSettings == none)
    {
        return;
    }
    Index = -1;
    // End:0x5D
    if(InvClass == none)
    {
        Index = Rand(ClothesSettings.Shields.Length);        
    }
    else
    {
        I = 0;
        J0x68:

        // End:0x102 [Loop If]
        if(I < ClothesSettings.Shields.Length)
        {
            // End:0xF4
            if(ClothesSettings.Shields[I].ShieldClass == InvClass)
            {
                Index = I;
                // [Explicit Break]
                goto J0x102;
            }
            I++;
            // [Loop Continue]
            goto J0x68;
        }
    }
    J0x102:

    // End:0x235
    if(Index != -1)
    {
        ReplicatedClothShield.MaterialIndex = byte(Index);
        // End:0x232
        if(ClothesSettings.Shields[int(ReplicatedClothShield.MaterialIndex)].ShieldAsset.GetRandomMaterialsAmount() > 0)
        {
            ReplicatedClothShield.RandomMaterialIndex = byte(Rand(ClothesSettings.Shields[int(ReplicatedClothShield.MaterialIndex)].ShieldAsset.GetRandomMaterialsAmount()));
        }        
    }
    EquipShieldClient();
    //return;    
}

function DressUp(optional EvilPawnClothingSettings InClothSettings)
{
    local int I, Index;
    local EvilPawnClothAssetInterface DressUpAsset;
    local array<int> SuitableEquipment;
    local array<EvilPawnClothAssetInterface> validateAssets;

    // End:0x23
    if(InClothSettings != none)
    {
        ClothesSettings = InClothSettings;
    }
    // End:0x34
    if(ClothesSettings == none)
    {
        return;
    }
    // End:0x16D
    if(ClothesSettings.Heads.Length > 0)
    {
        Index = Rand(ClothesSettings.Heads[0].ClothParts.Length);
        DressUpAsset = new ClothesSettings.Heads[0].ClothParts[Index].Class (ClothesSettings.Heads[0].ClothParts[Index]);
        DressUpAsset.AttachCloth(self);
        ReplicatedHeadClothIndex = Index;
    }
    I = 0;
    J0x178:

    // End:0x39B [Loop If]
    if(I < ClothesSettings.Clothes.Length)
    {
        // End:0x38D
        if(FRand() < ClothesSettings.Clothes[I].ChanceToShow)
        {
            Index = Rand(ClothesSettings.Clothes[I].ClothParts.Length);
            ReplicatedClothesInfo[I].ClothIndex = byte(Index);
            DressUpAsset = new ClothesSettings.Clothes[I].ClothParts[Index].Class (ClothesSettings.Clothes[I].ClothParts[Index]);
            // End:0x382
            if(DressUpAsset.GetRandomMaterialsAmount() > 0)
            {
                ReplicatedClothesInfo[I].RandomMaterialIndex = byte(Rand(DressUpAsset.GetRandomMaterialsAmount()));
            }
            DressUpAsset = none;
        }
        I++;
        // [Loop Continue]
        goto J0x178;
    }
    I = 0;
    J0x3A6:

    // End:0x580 [Loop If]
    if(I < ClothesSettings.Materials.Length)
    {
        // End:0x572
        if(FRand() < ClothesSettings.Materials[I].ChanceToShow)
        {
            Index = Rand(ClothesSettings.Materials[I].MaterialsInfo.Length);
            ReplicatedClothMaterials[I].MaterialIndex = byte(Index);
            // End:0x572
            if(ClothesSettings.Materials[I].MaterialsInfo[Index].RandomMaterials.Length > 0)
            {
                ReplicatedClothMaterials[I].RandomMaterialIndex = byte(Rand(ClothesSettings.Materials[I].MaterialsInfo[Index].RandomMaterials.Length));
            }
        }
        I++;
        // [Loop Continue]
        goto J0x3A6;
    }
    // End:0x74F
    if((FRand() < ClothesSettings.EquipmentChance) && ClothesSettings.Equipment.Length > 0)
    {
        I = 0;
        J0x5D7:

        // End:0x70C [Loop If]
        if(I < ClothesSettings.Equipment[0].ClothParts.Length)
        {
            DressUpAsset = new ClothesSettings.Equipment[0].ClothParts[I].Class (ClothesSettings.Equipment[0].ClothParts[I]);
            // End:0x6F3
            if(DressUpAsset.PreValidateMaterials(self))
            {
                SuitableEquipment.AddItem(I);
            }
            DressUpAsset = none;
            I++;
            // [Loop Continue]
            goto J0x5D7;
        }
        // End:0x74F
        if(SuitableEquipment.Length > 0)
        {
            Index = SuitableEquipment[Rand(SuitableEquipment.Length)];
            ReplicatedEquipmentClothIndex = Index;
        }
    }
    CollectClothComponentsToArray(validateAssets);
    I = 0;
    J0x76D:

    // End:0x7C7 [Loop If]
    if(I < validateAssets.Length)
    {
        validateAssets[I].ValidateComponent(self, validateAssets);
        I++;
        // [Loop Continue]
        goto J0x76D;
    }
    DressUpClient();
    //return;    
}

simulated function DressUpHead()
{
    local EvilPawnClothAssetInterface DressUpAsset;

    DressUpAsset = new ClothesSettings.Heads[0].ClothParts[ReplicatedHeadClothIndex].Class (ClothesSettings.Heads[0].ClothParts[ReplicatedHeadClothIndex]);
    DressUpAsset.AttachCloth(self);
    //return;    
}

simulated function DressUpClient()
{
    local EvilPawnClothAssetInterface DressUpAsset;
    local editinline SkeletalMeshComponent SKComp;
    local int I, J;

    // End:0x11
    if(ClothesSettings == none)
    {
        return;
    }
    SKComp = GetSkeletalMeshComponent();
    // End:0xA4
    if(ClothesSettings.Materials.Length > 0)
    {
        I = 0;
        J0x55:

        // End:0xA4 [Loop If]
        if(I < SKComp.GetNumElements())
        {
            ShowMaterialSectionOnAllLods(I, false);
            I++;
            // [Loop Continue]
            goto J0x55;
        }
    }
    I = 0;
    J0xAF:

    // End:0x480 [Loop If]
    if(I < ClothesSettings.Materials.Length)
    {
        // End:0x110
        if(int(ReplicatedClothMaterials[I].MaterialIndex) == int(255))
        {            
        }
        else
        {
            ShowMaterialSectionOnAllLods(ClothesSettings.Materials[I].MaterialsInfo[int(ReplicatedClothMaterials[I].MaterialIndex)].MaterialIndexes, true);
            // End:0x347
            if(ClothesSettings.Materials[I].MaterialsInfo[int(ReplicatedClothMaterials[I].MaterialIndex)].RandomMaterials.Length > 0)
            {
                GetSkeletalMeshComponent().SetMaterial(ClothesSettings.Materials[I].MaterialsInfo[int(ReplicatedClothMaterials[I].MaterialIndex)].MaterialIndexes, ClothesSettings.Materials[I].MaterialsInfo[int(ReplicatedClothMaterials[I].MaterialIndex)].RandomMaterials[int(ReplicatedClothMaterials[I].RandomMaterialIndex)]);
            }
            J = 0;
            J0x352:

            // End:0x472 [Loop If]
            if(J < ClothesSettings.Materials[I].MaterialsInfo[int(ReplicatedClothMaterials[I].MaterialIndex)].AddInMaterials.Length)
            {
                ShowMaterialSectionOnAllLods(ClothesSettings.Materials[I].MaterialsInfo[int(ReplicatedClothMaterials[I].MaterialIndex)].AddInMaterials[J], true);
                J++;
                // [Loop Continue]
                goto J0x352;
            }
        }
        I++;
        // [Loop Continue]
        goto J0xAF;
    }
    I = 0;
    J0x48B:

    // End:0x682 [Loop If]
    if(I < ClothesSettings.Clothes.Length)
    {
        // End:0x4EC
        if(int(ReplicatedClothesInfo[I].ClothIndex) == int(255))
        {            
        }
        else
        {
            DressUpAsset = new ClothesSettings.Clothes[I].ClothParts[int(ReplicatedClothesInfo[I].ClothIndex)].Class (ClothesSettings.Clothes[I].ClothParts[int(ReplicatedClothesInfo[I].ClothIndex)]);
            // End:0x653
            if(int(ReplicatedClothesInfo[I].RandomMaterialIndex) != int(255))
            {
                DressUpAsset.ISetMaterialFromRandomMaterials(int(ReplicatedClothesInfo[I].RandomMaterialIndex));
            }
            DressUpAsset.AttachCloth(self);
        }
        I++;
        // [Loop Continue]
        goto J0x48B;
    }
    I = 0;
    J0x68D:

    // End:0x75D [Loop If]
    if(I < ClothesSettings.SwitchMaterials.Length)
    {
        SKComp.SetMaterial(ClothesSettings.SwitchMaterials[I].MaterialIndex, ClothesSettings.SwitchMaterials[I].NewMaterial);
        I++;
        // [Loop Continue]
        goto J0x68D;
    }
    CreatePawnMaterials();
    // End:0x83B
    if(ReplicatedEquipmentClothIndex != -1)
    {
        DressUpAsset = new ClothesSettings.Equipment[0].ClothParts[ReplicatedEquipmentClothIndex].Class (ClothesSettings.Equipment[0].ClothParts[ReplicatedEquipmentClothIndex]);
        DressUpAsset.AttachCloth(self);
    }
    //return;    
}

function CollectClothComponentsToArray(out array<EvilPawnClothAssetInterface> RetArray)
{
    local editinline ActorComponent clothAsset;

    // End:0x68
    foreach ComponentList(Class'Engine.ActorComponent', clothAsset)
    {
        // End:0x67
        if(NotEqual_InterfaceInterface(EvilPawnClothAssetInterface(clothAsset), EvilPawnClothAssetInterface(none)))
        {
            RetArray.AddItem(EvilPawnClothAssetInterface(clothAsset));
        }        
    }    
    // End:0xE6
    foreach Mesh.AttachedComponents(Class'Engine.ActorComponent', clothAsset)
    {
        // End:0xE5
        if(NotEqual_InterfaceInterface(EvilPawnClothAssetInterface(clothAsset), EvilPawnClothAssetInterface(none)))
        {
            RetArray.AddItem(EvilPawnClothAssetInterface(clothAsset));
        }        
    }    
    //return;    
}

function DropClothesOnRagdoll(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, optional bool bPlayingDeath = false)
{
    local array<EvilPawnClothAssetInterface> dropAssets;
    local int I;

    CollectClothComponentsToArray(dropAssets);
    I = 0;
    J0x23:

    // End:0x98 [Loop If]
    if(I < dropAssets.Length)
    {
        dropAssets[I].TryDropOnRagdoll(DamageType, HitLocation, Momentum, bPlayingDeath);
        I++;
        // [Loop Continue]
        goto J0x23;
    }
    //return;    
}

function AnimNodeSlot GetActiveHalfBodySlot()
{
    return ((int(CoverType) == int(0)) ? TopHalfAnimSlot : CoverTopHalfAnimSlot);
    //return ReturnValue;    
}

function EvilTypes.EBodyParts GetBodyPartByBone(name Bone)
{
    local HitZone it;
    local name BoneName;

    // End:0x7A
    foreach HitZones(it)
    {
        // End:0x78
        foreach it.ZoneBones(BoneName)
        {
            // End:0x77
            if(BoneName == Bone)
            {
                break;                
                return it.BodyPart;
            }            
        }                
    }    
    return 1;
    //return ReturnValue;    
}

function int GetZoneIndex(name Bone)
{
    local HitZone Zone;
    local int I;

    // End:0x5E
    foreach HitZones(Zone, I)
    {
        // End:0x5D
        if(Zone.ZoneBones.Find(Bone) > -1)
        {            
            return I;
        }        
    }    
    return -1;
    //return ReturnValue;    
}

simulated function int GetZoneIndexByBodyPart(EvilTypes.EBodyParts BodyPart)
{
    return HitZones.Find('BodyPart', BodyPart);
    //return ReturnValue;    
}

function array<name> GetBodyZoneBones(EvilTypes.EBodyParts BodyPart)
{
    local HitZone it;

    // End:0x64
    foreach HitZones(it)
    {
        // End:0x63
        if(int(it.BodyPart) == int(BodyPart))
        {            
            return it.ZoneBones;
        }        
    }    
    //return ReturnValue;    
}

function SpawnCompleted(EvilTypes.EAIFactoryEvent EventType)
{
    SetShowOnRadar(true);
    // End:0x22
    if(int(EventType) == int(0))
    {        
    }
    else
    {
        // End:0x36
        if(int(EventType) == int(1))
        {
        }
    }
    // End:0x6D
    if(MyEvilAI != none)
    {
        MyEvilAI.NotifySpawnCompleted(EventType);
    }
    // End:0xA5
    if(AIFactory != none)
    {
        AIFactory.NotifyFactory(self, EventType);
    }
    //return;    
}

simulated function OnRagdollPositionChange()
{
    local Vector pos;
    local Rotator Rot;
    local int I;

    I = 0;
    J0x0B:

    // End:0x277 [Loop If]
    if(I < SynchronizedBonesIndexes.Length)
    {
        pos.X = ReplicatedBoneToRagfollInfo[I].px;
        pos.Y = ReplicatedBoneToRagfollInfo[I].Py;
        pos.Z = ReplicatedBoneToRagfollInfo[I].pz;
        Rot.Pitch = ReplicatedBoneToRagfollInfo[I].Pitch;
        Rot.Roll = ReplicatedBoneToRagfollInfo[I].Roll;
        Rot.Yaw = ReplicatedBoneToRagfollInfo[I].Yaw;
        Mesh.SetRBPosition(pos, Mesh.GetBoneName(SynchronizedBonesIndexes[I]));
        Mesh.SetRBRotation(Rot, Mesh.GetBoneName(SynchronizedBonesIndexes[I]));
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function OnLimbsInfoChanged()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0xBE [Loop If]
    if(I < 11)
    {
        // End:0xB0
        if(int(ReplicatedLimbsInfo[I]) == int(1))
        {
            SpawnDetachedLimbAndEffects(1, CurrentDamageType, LastTakeHitInfo.HitLocation, LastTakeHitInfo.Momentum, GetZoneIndexByBodyPart(byte(I)));
            ReplicatedLimbsInfo[I] = 2;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function BreakConstraint(Vector Momentum, Vector HitLocation, class<EvilDmgType_Base> EvilDamageType, const out _GoreBreakableJoints BreakableJointInfo)
{
    Mesh.super(EvilPawn).BreakConstraint(Momentum * BreakableJointInfo.MomentumScale, HitLocation, BreakableJointInfo.BreakableConstraintName, true);
    //return;    
}

simulated function PostSwitchSkeletalMeshFromGoreSettings()
{
    //return;    
}

simulated function int SpawnDetachedLimbAndEffects(int Damage, class<EvilDmgType_Base> EvilDamageType, Vector HitLocation, Vector Momentum, int ZoneIndex)
{
    local int I;
    local bool bSpawnEffects, bMaterialIsHidden;
    local ParticleSystem PS, overridePS;
    local SoundCue OverrideSoundCue;
    local _GoreBreakableJoints BreakableJointInfo;
    local bool bIsGore;

    BreakableJointInfo = GoreSettings.GoreBreakableJoints[int(HitZones[ZoneIndex].BodyPart)];
    bShouldPlayDeathAnimationToRagdoll = BreakableJointInfo.bShouldPlayDeathAnimationToRagdoll;
    bSpawnEffects = true;
    bIsGore = WorldInfo.GRI.ShouldShowGore();
    // End:0x1E4
    if(BreakableJointInfo.Gibs.Length > 0)
    {
        HitLocation = Mesh.GetBoneLocation(BreakableJointInfo.BreakableConstraintName);
        // End:0x1D5
        if(bIsGore && Class'EvilPawnGoreSettings'.static.SpawnGibs(GoreSettings.Parameters, BreakableJointInfo.Gibs, EvilDamageType, HitLocation, Momentum * BreakableJointInfo.MomentumScale, self))
        {            
        }
        else
        {
            bSpawnEffects = false;
        }        
    }
    else
    {
        // End:0x482
        if(bIsGore)
        {
            // End:0x294
            if(GoreSettings.GoreMeshPhysicsAsset != none)
            {
                // End:0x294
                if(Mesh.PhysicsAsset != GoreSettings.GoreMeshPhysicsAsset)
                {
                    Mesh.SetPhysicsAsset(GoreSettings.GoreMeshPhysicsAsset);
                }
            }
            // End:0x341
            if(GoreSettings.AlternateSkeletalMesh != none)
            {
                // End:0x341
                if(Mesh.SkeletalMesh != GoreSettings.AlternateSkeletalMesh)
                {
                    Mesh.SetSkeletalMesh(GoreSettings.AlternateSkeletalMesh);
                    PostSwitchSkeletalMeshFromGoreSettings();
                }
            }
            // End:0x419
            if(BreakableJointInfo.RelyOnMaterialIndex > -1)
            {
                // End:0x419
                if(GetSkeletalMeshComponent().LODInfo[0].HiddenMaterials.Length > BreakableJointInfo.RelyOnMaterialIndex)
                {
                    bMaterialIsHidden = GetSkeletalMeshComponent().LODInfo[0].HiddenMaterials[BreakableJointInfo.RelyOnMaterialIndex];
                }
            }
            // End:0x482
            if((BreakableJointInfo.BreakableConstraintName != 'None') && !bMaterialIsHidden)
            {
                BreakConstraint(Momentum, HitLocation, EvilDamageType, BreakableJointInfo);
            }
        }
    }
    // End:0x79D
    if(bSpawnEffects && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        I = 0;
        J0x4C5:

        // End:0x52F [Loop If]
        if(I < BreakableJointInfo.MaterialsIndicesToHide.Length)
        {
            ShowMaterialSectionOnAllLods(BreakableJointInfo.MaterialsIndicesToHide[I], false);
            I++;
            // [Loop Continue]
            goto J0x4C5;
        }
        I = 0;
        J0x53A:

        // End:0x5BA [Loop If]
        if(I < BreakableJointInfo.BonesIndicesToHide.Length)
        {
            Mesh.HideBone(BreakableJointInfo.BonesIndicesToHide[I], 2);
            I++;
            // [Loop Continue]
            goto J0x53A;
        }
        // End:0x60E
        if(Class'EvilGame'.static.UseLowGore(WorldInfo))
        {
            PS = BreakableJointInfo.DetachFX_NoGore;            
        }
        else
        {
            PS = BreakableJointInfo.DetachFX;
        }
        // End:0x6DE
        if(PS != none)
        {
            overridePS = OverrideDetachFX();
            // End:0x679
            if(overridePS != none)
            {
                PS = overridePS;
            }
            WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(PS, Mesh, BreakableJointInfo.BreakableConstraintName, false);
        }
        OverrideSoundCue = OverrideDetachLimbSoundCue(EvilDamageType);
        // End:0x730
        if(OverrideSoundCue == none)
        {
            OverrideSoundCue = BreakableJointInfo.DetachSound;
        }
        // End:0x79D
        if(OverrideSoundCue != none)
        {
            // End:0x79D
            if((DetachingLimbSoundLimiter < 0) || DetachingLimbsSoundsCounter < DetachingLimbSoundLimiter)
            {
                PlaySound(OverrideSoundCue, true);
                DetachingLimbsSoundsCounter++;
                SetTimer(0.5000000, false, 'ResetCurrentDetachLimbsSoundCounter');
            }
        }
    }
    // End:0x8DC
    if(GoreSettings.GoreMeshLOD >= 0)
    {
        Mesh.ForcedLodModel = GoreSettings.GoreMeshLOD + 1;
        I = 0;
        J0x80C:

        // End:0x8DC [Loop If]
        if(I < GoreSettings.GoreLodMaterials.Length)
        {
            Mesh.SetMaterial(GoreSettings.GoreLodMaterials[I].MaterialIndex, GoreSettings.GoreLodMaterials[I].LodMaterial);
            I++;
            // [Loop Continue]
            goto J0x80C;
        }
    }
    return Damage;
    //return ReturnValue;    
}

simulated function ResetCurrentDetachLimbsSoundCounter()
{
    DetachingLimbsSoundsCounter = 0;
    //return;    
}

simulated function ParticleSystem OverrideHitImpactEffect(class<EvilDmgType_Base> EvilDamageType, PhysicalMaterial PhysMat)
{
    return none;
    //return ReturnValue;    
}

simulated function SoundCue OverrideHitImpactSound(class<EvilDmgType_Base> EvilDamageType, PhysicalMaterial PhysMat, SoundCue DefaultSoundCue)
{
    return none;
    //return ReturnValue;    
}

simulated function ParticleSystem OverrideDetachFX()
{
    return none;
    //return ReturnValue;    
}

simulated function SoundCue OverrideDetachLimbSoundCue(class<EvilDmgType_Base> EvilDamageType)
{
    return none;
    //return ReturnValue;    
}

simulated function ParticleSystem OverrideBloodFountainFX()
{
    return none;
    //return ReturnValue;    
}

simulated event ConstraintBrokenNotify(Actor ConOwner, RB_ConstraintSetup ConSetup, RB_ConstraintInstance ConInstance)
{
    local editinline SkeletalMeshComponent SMC;
    local ParticleSystem PS, overridePS;
    local editinline ParticleSystemComponent PSC;

    // End:0x19
    if(!ActorEffectIsRelevant(self, false, 2000.0000000))
    {
        return;
    }
    // End:0x32B
    if((((ConInstance != none) && GoreSettings != none) && GoreSettings.GoreBreakableJoints[0].BloodFountainFX != none) && WorldInfo.GRI.ShouldShowGore())
    {
        SMC = SkeletalMeshComponent(ConInstance.OwnerComponent);
        PS = GoreSettings.GoreBreakableJoints[0].BloodFountainFX;
        overridePS = OverrideBloodFountainFX();
        // End:0x151
        if(overridePS != none)
        {
            PS = overridePS;
        }
        PSC = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(PS, SMC, ConSetup.ConstraintBone1, false, ConSetup.Pos1 * 50.0000000, Rotator((ConSetup.Pos1 * 50.0000000) * vect(-1.0000000, 0.0000000, 0.0000000)));
        PSC.SetAbsolute(,,, true);
        PSC = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(PS, SMC, ConSetup.ConstraintBone2, false, ConSetup.Pos2 * 50.0000000, Rotator((ConSetup.Pos2 * 50.0000000) * vect(1.0000000, 0.0000000, 0.0000000)));
        PSC.SetAbsolute(,,, true);
    }
    //return;    
}

simulated function int DetachLimb(int Damage, class<EvilDmgType_Base> EvilDamageType, Vector HitLocation, Vector Momentum, int ZoneIndex)
{
    // End:0x34
    if(HitZones[ZoneIndex].bIsLimbDetached)
    {
        return Damage;
    }
    SpawnDetachedLimbAndEffects(Damage, EvilDamageType, HitLocation, Momentum, ZoneIndex);
    Damage = int(Abs(float(Health)) + float(10));
    ReplicatedLimbsInfo[int(HitZones[ZoneIndex].BodyPart)] = 1;
    HitZones[ZoneIndex].bIsLimbDetached = true;
    return Damage;
    //return ReturnValue;    
}

function ShowHeadShotMsg()
{
    //return;    
}

function int TryDetachLimb(int Damage, class<EvilDmgType_Base> EvilDamageType, Vector HitLocation, Vector Momentum, name BoneName, optional bool bForce = false)
{
    local int ZoneIndex;

    // End:0x1E
    if(GoreSettings == none)
    {
        return Damage;
    }
    ZoneIndex = GetZoneIndex(BoneName);
    // End:0x58
    if(ZoneIndex == -1)
    {
        return Damage;
    }
    // End:0x87
    if(GoreSettings.GoreBreakableJoints.Length == 0)
    {
        return Damage;
    }
    // End:0xDD
    if(GoreSettings.GoreBreakableJoints.Length < int(HitZones[ZoneIndex].BodyPart))
    {
        return Damage;
    }
    // End:0x1B1
    if((GoreSettings.GoreBreakableJoints[int(HitZones[ZoneIndex].BodyPart)].BreakableConstraintName == 'None') && !GoreSettings.GoreBreakableJoints[int(HitZones[ZoneIndex].BodyPart)].bHeadShot)
    {
        return Damage;
    }
    // End:0x219
    if(GoreSettings.GoreBreakableJoints[int(HitZones[ZoneIndex].BodyPart)].bHeadShot)
    {
        ShowHeadShotMsg();
    }
    HitZones[ZoneIndex].Health -= Damage;
    // End:0x2E2
    if((HitZones[ZoneIndex].Health <= 0) || bForce)
    {
        // End:0x2E2
        if(DetachingSpecificLimbEnabled || bForce)
        {
            Damage = DetachLimb(Damage, EvilDamageType, HitLocation, Momentum, ZoneIndex);
        }
    }
    return Damage;
    //return ReturnValue;    
}

protected function bool CanBePartialGib(class<EvilDmgType_Base> EvilDamageType)
{
    return false;
    //return ReturnValue;    
}

protected function CollectPartialGibs(out array<int> PartialGibs, class<EvilDmgType_Base> EvilDamageType, Vector HitLocation)
{
    //return;    
}

protected function SpawnInstantGibParticle()
{
    //return;    
}

protected function bool InstantGib(int Damage, class<EvilDmgType_Base> EvilDamageType, Vector HitLocation, Vector Momentum, optional bool bPartialGibEnabled)
{
    local int I;
    local array<int> PartialGibs;

    // End:0x12
    if(GoreSettings == none)
    {
        return false;
    }
    // End:0x12D
    if(bPartialGibEnabled)
    {
        CollectPartialGibs(PartialGibs, EvilDamageType, HitLocation);
        I = 0;
        J0x4F:

        // End:0xF4 [Loop If]
        if(I < PartialGibs.Length)
        {
            Damage += (TryDetachLimb(Damage, EvilDamageType, HitLocation, Momentum, GoreSettings.GoreBreakableJoints[PartialGibs[I]].BreakableConstraintName, true));
            I++;
            // [Loop Continue]
            goto J0x4F;
        }
        // End:0x12A
        if(Damage > Health)
        {
            Damage = int(Abs(float(Health)) + float(10));
        }        
    }
    else
    {
        I = 0;
        J0x138:

        // End:0x231 [Loop If]
        if(I < GoreSettings.GoreBreakableJoints.Length)
        {
            // End:0x223
            if(GoreSettings.GoreBreakableJoints[I].BreakableConstraintName != 'None')
            {
                Damage += (TryDetachLimb(Damage, EvilDamageType, HitLocation, Momentum, GoreSettings.GoreBreakableJoints[I].BreakableConstraintName, true));
            }
            I++;
            // [Loop Continue]
            goto J0x138;
        }
        // End:0x267
        if(Damage > Health)
        {
            Damage = int(Abs(float(Health)) + float(10));
        }
    }
    I = 0;
    J0x272:

    // End:0x32D [Loop If]
    if(I < GoreSettings.AdditionalInstantGibConstraintNames.Length)
    {
        Mesh.BreakConstraint(Normal(Momentum) * EvilDamageType.default.KDeathVel, vect(0.0000000, 0.0000000, 0.0000000), GoreSettings.AdditionalInstantGibConstraintNames[I], true);
        I++;
        // [Loop Continue]
        goto J0x272;
    }
    SpawnInstantGibParticle();
    bGibbed = true;
    return true;
    //return ReturnValue;    
}

simulated function bool ShouldGib(class<EvilDmgType_Base> EvilDamageType)
{
    // End:0x19
    if(Class'EvilDmgType_InstantGib' == EvilDamageType)
    {
        return true;
    }
    // End:0x17F
    if(CurrentHitInformation.DamageClassification.bIsValid && CurrentHitInformation.DamageClassification.bSpawnGibs)
    {
        // End:0x17F
        if(((CurrentHitInformation.DamageClassification.InstaGibRange > float(-1)) && VSize(Location - CurrentHitInformation.EventInstigator.Pawn.Location) < CurrentHitInformation.DamageClassification.InstaGibRange) && FRand() < CurrentHitInformation.DamageClassification.InstaGibChance)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function SetParameterForAllMaterials(name InParamName, float InValue)
{
    local int I, numElems;
    local array<EvilPawnClothAssetInterface> clothAsset;
    local editinline SkeletalMeshComponent SKComp;

    // End:0x1C8
    if(PawnMaterials.Length > 0)
    {
        SKComp = GetSkeletalMeshComponent();
        numElems = SKComp.GetNumElements();
        I = 0;
        J0x58:

        // End:0xB8 [Loop If]
        if(I < numElems)
        {
            PawnMaterials[I].SetScalarParameterValue(InParamName, InValue);
            ++I;
            // [Loop Continue]
            goto J0x58;
        }
        // End:0x148
        if(HeadSkeletalMeshComp != none)
        {
            I = 0;
            J0xD2:

            // End:0x148 [Loop If]
            if(I < HeadSkeletalMeshComp.GetNumElements())
            {
                PawnHeadMaterials[I].SetScalarParameterValue(InParamName, InValue);
                I++;
                // [Loop Continue]
                goto J0xD2;
            }
        }
        CollectClothComponentsToArray(clothAsset);
        I = 0;
        J0x166:

        // End:0x1C8 [Loop If]
        if(I < clothAsset.Length)
        {
            clothAsset[I].SetScalarParameterForMaterials(InParamName, InValue);
            I++;
            // [Loop Continue]
            goto J0x166;
        }
    }
    //return;    
}

simulated function Burn(float InTotalTime, float InDamageInterval, float InDamageAmount, optional bool bMaterialsBlackEffects = true, optional bool bMaterialsDotEffects = true, optional bool bResetActualBlackMaterialValue = true, optional bool bResetActualDotsMaterialValue = true)
{
    // End:0x69
    if((CanDoPawnAction(4) && int(Role) == int(ROLE_Authority)) && (AST_GetAnimCount()) > 0)
    {
        ServerDoPawnAction(ROLE_MAX, false, none, PackRandomAnimInfo());
    }
    // End:0x78
    if(IsBurning())
    {
        return;
    }
    // End:0xC1
    if(MyEvilAI != none)
    {
        MyEvilAI.NotifyStartBurn(InTotalTime, InDamageInterval, InDamageAmount);
    }
    // End:0xDD
    if(bResetActualDotsMaterialValue)
    {
        BurnDotsMaterialValue = 0.0000000;
    }
    // End:0xF9
    if(bResetActualBlackMaterialValue)
    {
        BurnBlackMaterialValue = 0.0000000;
    }
    BurningDamageAmount = InDamageAmount;
    BurnEffectPSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(BurnEffectPS);
    AttachComponent(BurnEffectPSC);
    BurnEffectPSC.SetActorParameter('BoneSocketActor', self);
    BurnEffectPSC.ActivateSystem();
    BurnLightActor = Spawn(Class'EvilLightActor', self,, Location,, BurnLightArchetype);
    BurnLightActor.SetBase(self);
    BurnLightActor.Activate();
    // End:0x25F
    if(bMaterialsBlackEffects)
    {
        SetTimer(BurnBlackMaterialDelay, true, 'DoBurnBlackMaterialChange');
    }
    // End:0x283
    if(bMaterialsDotEffects)
    {
        SetTimer(BurnDotsMaterialDelay, true, 'DoBurnDotsMaterialChange');
    }
    SetTimer(InDamageInterval, true, 'DoBurnDamageTimer');
    // End:0x2C9
    if(InTotalTime != float(-1))
    {
        SetTimer(InTotalTime, false, 'StopBurning');        
    }
    //return;    
}

function DoBurnBlackMaterialChange()
{
    SetParameterForAllMaterials('Black', BurnBlackMaterialValue);
    BurnBlackMaterialValue += BurnBlackMaterialAmount;
    // End:0x52
    if(BurnBlackMaterialValue > 1.0000000)
    {
        BurnBlackMaterialValue = 1.0000000;
    }
    //return;    
}

function DoRemoveBurnDotsMaterialChange()
{
    // End:0x32
    if(BurnDotsMaterialValue > 0.5000000)
    {
        SetParameterForAllMaterials('Burning', BurnDotsMaterialValue);        
    }
    else
    {
        SetParameterForAllMaterials('Burning', BurnDotsMaterialValue);
    }
    BurnDotsMaterialValue = FMax(0.0000000, BurnDotsMaterialValue - RemoveBurnDotsAmount);
    // End:0x98
    if(BurnDotsMaterialValue <= float(0))
    {
        ClearTimer('DoRemoveBurnDotsMaterialChange');
    }
    //return;    
}

function DoBurnDotsMaterialChange()
{
    // End:0x32
    if(BurnDotsMaterialValue > 0.5000000)
    {
        SetParameterForAllMaterials('Burning', BurnDotsMaterialValue);        
    }
    else
    {
        SetParameterForAllMaterials('Burning', BurnDotsMaterialValue);
    }
    BurnDotsMaterialValue += BurnDotsMaterialAmount;
    // End:0x84
    if(BurnDotsMaterialValue > 1.0000000)
    {
        BurnDotsMaterialValue = 1.0000000;
    }
    //return;    
}

function DoBurnDamageTimer()
{
    TakeDamage(int(BurningDamageAmount), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilDmgType_Fire',, self);
    //return;    
}

function bool IsBurning()
{
    return IsTimerActive('DoBurnDamageTimer') || BurnEffectPSC != none;
    //return ReturnValue;    
}

function StopBurning()
{
    ClearTimer('DoBurnBlackMaterialChange');
    ClearTimer('DoBurnDotsMaterialChange');
    ClearTimer('DoBurnDamageTimer');
    SetTimer(BurnDotsMaterialDelay, true, 'DoRemoveBurnDotsMaterialChange');
    // End:0x8C
    if(BurnEffectPSC != none)
    {
        BurnEffectPSC.DeactivateSystem();
        BurnEffectPSC = none;
    }
    // End:0xC5
    if(BurnLightActor != none)
    {
        BurnLightActor.Deactivate();
        BurnLightActor = none;
    }
    // End:0xF3
    if(MyEvilAI != none)
    {
        MyEvilAI.NotifyStopBurn();
    }
    //return;    
}

function OnBurn(SeqAct_Burn Action)
{
    // End:0xA2
    if(Action.InputLinks[0].bHasImpulse)
    {
        Burn(Action.InTotalTime, Action.InDamageInterval, Action.InDamageAmount);        
    }
    else
    {
        // End:0xE3
        if(Action.InputLinks[1].bHasImpulse)
        {
            StopBurning();
        }
    }
    //return;    
}

function bool CanBeAttacked(EvilPawn InAttacker)
{
    // End:0x11
    if(IsDoingPawnAction(14))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool HasShield()
{
    return false;
    //return ReturnValue;    
}

function bool CanBeAffectedByLight()
{
    return bCanBeAffectedByLight;
    //return ReturnValue;    
}

function bool CanBePinned()
{
    return true;
    //return ReturnValue;    
}

function bool PerformDodge(Actor.EDoubleClickDir DoubleClickMove, Vector Dir, Vector Cross)
{
    local float VelocityZ;

    // End:0x1E
    if(int(Physics) == int(2))
    {
        TakeFallingDamage();
    }
    bDodging = true;
    bReadyToDoubleJump = JumpBootCharge > 0;
    VelocityZ = Velocity.Z;
    Velocity = (DodgeSpeed * Dir) + ((Velocity Dot Cross) * Cross);
    // End:0xEF
    if(VelocityZ < float(-200))
    {
        Velocity.Z = VelocityZ + DodgeSpeedZ;        
    }
    else
    {
        Velocity.Z = DodgeSpeedZ;
    }
    CurrentDir = DoubleClickMove;
    SetPhysics(2);
    PlayJumpingSound();
    // End:0x177
    if(EvilPlayerController(Controller) != none)
    {
        EvilPlayerController(Controller).Jumped();
    }
    // End:0x1B7
    if(EvilWeap_Base(Weapon) != none)
    {
        EvilWeap_Base(Weapon).Jumped();
    }
    // End:0x1F7
    if(EvilWeap_Base(WeaponLeft) != none)
    {
        EvilWeap_Base(WeaponLeft).Jumped();
    }
    return true;
    //return ReturnValue;    
}

function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
    local bool HitSoundPlayed;
    local editinline EvilAudioComponent EvilFacialAudioComp;

    EvilFacialAudioComp = EvilAudioComponent(FacialAudioComp);
    // End:0x178
    if(bPlayHitSoundInPlayHit && (WorldInfo.TimeSeconds - LastPainSound) >= 0.4000000)
    {
        LastPainSound = WorldInfo.TimeSeconds;
        // End:0x178
        if((Damage > float(0)) && Health > 0)
        {
            HitSoundPlayed = false;
            // End:0x15F
            if(((DamageType == Class'EvilDmgType_Fire') || DamageType == Class'EvilDmgType_Light') && EvilFacialAudioComp != none)
            {
                // End:0x153
                if((int(EvilFacialAudioComp.SoundSetType) != int(2)) && int(EvilFacialAudioComp.LastSoundSetType) != int(2))
                {
                    PlayFireHitSound();
                }
                HitSoundPlayed = true;
            }
            // End:0x178
            if(!HitSoundPlayed)
            {
                PlayHitSound();
            }
        }
    }
    super.PlayHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
    //return;    
}

function bool GetSoundSetTypeFromString(name SoundSetTypeName, out EvilTypes.ESoundSetType SoundSetType, out int HearReplyFlag)
{
    local name TempSoundSetTypeName;
    local int HeardReplyIndex, SoundSetTypeIndex, I;

    HeardReplyIndex = InStr(string(SoundSetTypeName), "_Reply", true, true);
    // End:0x66
    if(HeardReplyIndex > -1)
    {
        SoundSetTypeName = name(Mid(string(SoundSetTypeName), 0, HeardReplyIndex));
        HearReplyFlag = 0;        
    }
    else
    {
        HearReplyFlag = -1;
    }
    SoundSetTypeIndex = InStr(string(SoundSetTypeName), "SST_",, true);
    // End:0x150
    if(SoundSetTypeIndex > -1)
    {
        I = 0;
        J0xB3:

        TempSoundSetTypeName = GetEnum(Enum'EvilTypes.ESoundSetType', I);
        // End:0x100
        if(InStr(string(SoundSetTypeName), string(TempSoundSetTypeName),, true) >= 0)
        {
            goto J0x122;            
        }
        I++;
        // End:0xB3
        if(!(TempSoundSetTypeName == 'SST_MAX'))
            goto J0xB3;
        J0x122:

        // End:0x150
        if(TempSoundSetTypeName != 'SST_MAX')
        {
            SoundSetType = byte(I);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function EvilTypes.ESoundSetType GetFacialCompnentSoundSetType()
{
    local EvilTypes.ESoundSetType SoundSetType;

    // End:0x49
    if(EvilAudioComponent(FacialAudioComp) != none)
    {
        SoundSetType = EvilAudioComponent(FacialAudioComp).SoundSetType;
    }
    return SoundSetType;
    //return ReturnValue;    
}

function EvilTypes.ESoundSetType GetFacialCompnentActiveSoundSetType()
{
    local EvilTypes.ESoundSetType SoundSetType;

    // End:0x3F
    if(EvilAudioComponent(FacialAudioComp).IsPlaying())
    {
        SoundSetType = GetFacialCompnentSoundSetType();
    }
    return SoundSetType;
    //return ReturnValue;    
}

function EvilTypesNative.EFaceFXEmotionSetType GetFacialCompnentEmotionSetType()
{
    local EvilTypesNative.EFaceFXEmotionSetType EmotionSetType;

    // End:0x49
    if(EvilAudioComponent(FacialAudioComp) != none)
    {
        EmotionSetType = EvilAudioComponent(FacialAudioComp).EmotionSetType;
    }
    return EmotionSetType;
    //return ReturnValue;    
}

function SetFacialComponentSoundSetType(EvilTypes.ESoundSetType SoundSetType, optional EvilTypesNative.EFaceFXEmotionSetType EmotionSetType = 0)
{
    // End:0x11E
    if(EvilAudioComponent(FacialAudioComp) != none)
    {
        EvilAudioComponent(FacialAudioComp).LastSoundSetType = EvilAudioComponent(FacialAudioComp).SoundSetType;
        EvilAudioComponent(FacialAudioComp).LastEmotionSetType = EvilAudioComponent(FacialAudioComp).EmotionSetType;
        EvilAudioComponent(FacialAudioComp).SoundSetType = SoundSetType;
        EvilAudioComponent(FacialAudioComp).EmotionSetType = EmotionSetType;
    }
    //return;    
}

function bool PlayOnFacialComponent(SoundCue SoundCue, optional bool TryToUseFaceFX = true)
{
    local bool bSoundPlayed;

    // End:0x1B4
    if((SoundCue != none) && bCanPlayVO)
    {
        // End:0x64
        if(FacialAudioComp.IsPlaying())
        {
            FacialAudioComp.Stop();
        }
        // End:0x14F
        if((TryToUseFaceFX && SoundCue.FaceFXAnimName != "") && SoundCue.FaceFXGroupName != "")
        {
            bSoundPlayed = Mesh.PlayFaceFXAnim(SoundCue.FaceFXAnimSetRef, SoundCue.FaceFXAnimName, SoundCue.FaceFXGroupName, SoundCue);            
        }
        else
        {
            EvilAudioComponent(FacialAudioComp).SoundCue = SoundCue;
            EvilAudioComponent(FacialAudioComp).Play();
            bSoundPlayed = true;
        }
    }
    return bSoundPlayed;
    //return ReturnValue;    
}

simulated function FaceFXAudioFinished(AudioComponent AC)
{
    SetFacialComponentSoundSetType(0);
    // End:0x44
    if(MyEvilAI != none)
    {
        MyEvilAI.NotifyFaceFXAudioFinished(AC);
    }
    UpdateFaceFXEmotion();
    //return;    
}

function bool IsPlayingSoundType(EvilTypes.ESoundSetType SoundSetType)
{
    return int(GetFacialCompnentSoundSetType()) == int(SoundSetType);
    //return ReturnValue;    
}

function bool PlaySoundFromArchetypeByChance(EvilTypes.ESoundSetType SoundSetType, optional bool bHearReply, optional bool bPlayOnFacialComponent = true)
{
    local int MaxConcurrentPlays;
    local float SoundSetInterval;

    MaxConcurrentPlays = SoundGroupClass.static.GetMaxConcurrentPlayCount(SoundSetType, bHearReply);
    SoundSetInterval = SoundGroupClass.static.GetSoundSetInterval(SoundSetType, bHearReply);
    // End:0x146
    if(((SoundSetInterval > float(0)) && WorldInfo.TimeSeconds < (SoundGroupClass.static.GetLastPlayedSoundTime(SoundSetType, bHearReply) + SoundSetInterval)) || (MaxConcurrentPlays > 0) && MaxConcurrentPlays <= SoundGroupClass.static.GetActualConcurrentPlayCount(SoundSetType, bHearReply))
    {
        return false;
    }
    return SoundGroupClass.static.PlayFaceFXSoundFromArchetypeByChance(self, SoundSetType, bHearReply, bPlayOnFacialComponent);
    //return ReturnValue;    
}

function bool IsPlayingHitSound()
{
    return IsPlayingSoundType(1);
    //return ReturnValue;    
}

function bool PlayHitSound()
{
    return PlaySoundFromArchetypeByChance(1);
    //return ReturnValue;    
}

function bool PlayFireHitSound()
{
    return PlaySoundFromArchetypeByChance(2);
    //return ReturnValue;    
}

function bool PlayShootAttackVoice()
{
    return PlaySoundFromArchetypeByChance(7);
    //return ReturnValue;    
}

function bool PlayMeleeAttackVoice()
{
    return PlaySoundFromArchetypeByChance(6);
    //return ReturnValue;    
}

function bool PlayTransformSound()
{
    return PlaySoundFromArchetypeByChance(16,, false);
    //return ReturnValue;    
}

function bool PlayMeleeAttackHitSound()
{
    return PlaySoundFromArchetypeByChance(14);
    //return ReturnValue;    
}

function bool PlayMeleeAttackMissSound()
{
    return PlaySoundFromArchetypeByChance(15);
    //return ReturnValue;    
}

function bool PlayCoveredGrenadeAttackVoice()
{
    return PlaySoundFromArchetypeByChance(10);
    //return ReturnValue;    
}

function bool PlayScreamVoice()
{
    return PlaySoundFromArchetypeByChance(5);
    //return ReturnValue;    
}

function bool PlayAttackAmbientVoice()
{
    // End:0x24
    if(int(GetFacialCompnentActiveSoundSetType()) == int(0))
    {
        return PlaySoundFromArchetypeByChance(13);
    }
    return false;
    //return ReturnValue;    
}

function bool PlaySpawnVoice()
{
    return PlaySoundFromArchetypeByChance(17);
    //return ReturnValue;    
}

function DirectHitByProjectile()
{
    //return;    
}

simulated function byte GetTeamNum()
{
    // End:0x2C
    if(NotEqual_InterfaceInterface(EvilPlayer_interface(self), EvilPlayer_interface(none)))
    {
        return super(Pawn).GetTeamNum();
    }
    // End:0x5C
    if(AITeamInfo != none)
    {
        return byte(AITeamInfo.TeamIndex);
    }
    return 255;
    //return ReturnValue;    
}

simulated function TeamInfo GetTeam()
{
    // End:0x2C
    if(NotEqual_InterfaceInterface(EvilPlayer_interface(self), EvilPlayer_interface(none)))
    {
        return super(Pawn).GetTeam();
    }
    return AITeamInfo;
    //return ReturnValue;    
}

static function StaticShowMaterialSections(const out SkeletalMeshComponent InMesh, bool bShow)
{
    local int I, MaterialsNum;

    MaterialsNum = InMesh.GetNumElements();
    I = 0;
    J0x34:

    // End:0x94 [Loop If]
    if(I < MaterialsNum)
    {
        Class'EvilPawn'.static.StaticShowMaterialSectionOnAllLods(InMesh, I, bShow);
        I++;
        // [Loop Continue]
        goto J0x34;
    }
    //return;    
}

static function StaticShowMaterialSectionOnAllLods(const out SkeletalMeshComponent InMesh, int MaterialID, bool bShow)
{
    local int I, LodSize;

    LodSize = InMesh.LODInfo.Length;
    I = 0;
    J0x34:

    // End:0x94 [Loop If]
    if(I < LodSize)
    {
        InMesh.ShowMaterialSection(MaterialID, bShow, I);
        I++;
        // [Loop Continue]
        goto J0x34;
    }
    //return;    
}

simulated function ShowMaterialSectionOnAllLods(int MaterialID, bool bShow)
{
    local editinline SkeletalMeshComponent SKComp;
    local int I, LodSize;

    SKComp = GetSkeletalMeshComponent();
    LodSize = SKComp.LODInfo.Length;
    I = 0;
    J0x48:

    // End:0xA8 [Loop If]
    if(I < LodSize)
    {
        SKComp.ShowMaterialSection(MaterialID, bShow, I);
        I++;
        // [Loop Continue]
        goto J0x48;
    }
    //return;    
}

function bool ConfineToClampedBase()
{
    local EvilRailCar_Base PlatBase;

    // End:0x110
    if((ClampedBase != none) && Base != ClampedBase)
    {
        PlatBase = EvilRailCar_Base(Base);
        // End:0x110
        if(((PlatBase == none) || PlatBase.bAlwaysConfineToClampedBase) || ((PlatBase.Base != none) && PlatBase.Base != ClampedBase) && PlatBase.Base != ClampedBase.Base)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

event BaseChange()
{
    local bool bBasedOnInteractionPawn;
    local Vector HitLoc, HitNorm;

    bBasedOnInteractionPawn = ((InteractionPawn != none) && IsDoingAPawnAction()) && Base == InteractionPawn;
    // End:0x18C
    if(((ClampedBase != none) && ClampedBase != Base) && bJustTeleported || int(Physics) == int(10))
    {
        // End:0x18C
        if((((EvilRailCar_Base(ClampedBase) == none) || EvilRailCar_Base(ClampedBase).StaticMeshComponent.BlockZeroExtent) || EvilRailCar_Base(ClampedBase).AttachedPawnList.Find(self) < 0) && (Base != none) || ClampedBase != Trace(HitLoc, HitNorm, Location - (vect(0.0000000, 0.0000000, 2.0000000) * (GetCollisionHeight())), Location, true))
        {
            ClampedBase = none;
        }
    }
    // End:0x250
    if((((ClampedBase != none) && !bHardAttach) && !bBasedOnInteractionPawn) && ConfineToClampedBase())
    {
        SetBase(ClampedBase);
        // End:0x24D
        if((int(Physics) == int(2)) && Controller != none)
        {
            bCanJump = true;
            Controller.MayFall(false, vect(0.0000000, 0.0000000, 1.0000000));
            // End:0x24D
            if(!bCanJump)
            {
                SetPhysics(1);
            }
        }        
    }
    else
    {
        super(Pawn).BaseChange();
    }
    //return;    
}

event TickSpecial(float DeltaTime)
{
    //return;    
}

simulated function Rotator GetViewRotation()
{
    local Rotator out_Rotator, DeltaRotator;
    local float Delta;

    out_Rotator = super(Pawn).GetViewRotation();
    Delta = WorldInfo.TimeSeconds - LastLeanRotTime;
    LastLeanRotTime = WorldInfo.TimeSeconds;
    // End:0xBC
    if(int(CurrentLeanState) == int(1))
    {
        CurrLeanRotVal = FInterpTo(CurrLeanRotVal, -LeanRoll, Delta, 10.0000000);        
    }
    else
    {
        // End:0x107
        if(int(CurrentLeanState) == int(2))
        {
            CurrLeanRotVal = FInterpTo(CurrLeanRotVal, LeanRoll, Delta, 10.0000000);            
        }
        else
        {
            CurrLeanRotVal = FInterpTo(CurrLeanRotVal, 0.0000000, Delta, 10.0000000);
        }
    }
    DeltaRotator.Roll = int(CurrLeanRotVal);
    out_Rotator += DeltaRotator;
    return out_Rotator;
    //return ReturnValue;    
}

simulated function Vector GetPawnViewLocation()
{
    local Vector out_vector, DeltaVector;
    local float Delta;

    out_vector = super.GetPawnViewLocation();
    Delta = WorldInfo.TimeSeconds - LastLeanLocTime;
    LastLeanLocTime = WorldInfo.TimeSeconds;
    // End:0xBC
    if(int(CurrentLeanState) == int(1))
    {
        CurrLeanLocVal = FInterpTo(CurrLeanLocVal, -LeanLenght, Delta, 10.0000000);        
    }
    else
    {
        // End:0x107
        if(int(CurrentLeanState) == int(2))
        {
            CurrLeanLocVal = FInterpTo(CurrLeanLocVal, LeanLenght, Delta, 10.0000000);            
        }
        else
        {
            CurrLeanLocVal = FInterpTo(CurrLeanLocVal, 0.0000000, Delta, 10.0000000);
        }
    }
    DeltaVector.Y = CurrLeanLocVal;
    out_vector += (DeltaVector >> ((Controller == none) ? Rotation : Controller.Rotation));
    return out_vector;
    //return ReturnValue;    
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
    local Rotator BlendDelta, Delta;
    local float CoverBlendWeight;

    // End:0x42
    if(int(CoverType) != int(0))
    {
        NewRotation = Rotator(-GetCoverNormal());
        LastCoverRotation = NewRotation;        
    }
    else
    {
        // End:0xBB
        if(((int(Physics) == int(0)) && EvilRailCar_Base(Base) != none) && EvilRailCar_Base(Base).bDisallowPawnMovement)
        {
            NewRotation.Pitch = 0;
        }
    }
    NewRotation = Normalize(NewRotation);
    // End:0x1ED
    if(bRotInterpCoverTransition && BaseBlendNode != none)
    {
        CoverBlendWeight = 1.0000000 - (BaseBlendNode.NodeTotalWeight * BaseBlendNode.Children[1].Weight);
        Delta = Normalize(NewRotation - LastCoverRotation);
        BlendDelta = Delta * CoverBlendWeight;
        NewRotation = Normalize(LastCoverRotation + BlendDelta);
        // End:0x1EA
        if(CoverBlendWeight >= 1.0000000)
        {
            bRotInterpCoverTransition = false;
        }        
    }
    else
    {
        // End:0x2CF
        if(PawnRotationBlendTimeToGo > 0.0000000)
        {
            // End:0x2C0
            if(PawnRotationBlendTimeToGo > DeltaTime)
            {
                PawnRotationBlendTimeToGo -= DeltaTime;
                Delta = Normalize(NewRotation - Normalize(Rotation));
                BlendDelta = Delta * FClamp(DeltaTime / PawnRotationBlendTimeToGo, 0.0000000, 1.0000000);
                NewRotation = Normalize(Rotation + BlendDelta);                
            }
            else
            {
                PawnRotationBlendTimeToGo = 0.0000000;
            }
        }
    }
    super.FaceRotation(NewRotation, DeltaTime);
    //return;    
}

simulated function SetCoverAction(CoverLink.ECoverAction NewCoverAction)
{
    // End:0x22D
    if(int(NewCoverAction) != int(CoverAction))
    {
        // End:0x150
        if((int(Role) == int(ROLE_Authority)) && !IsHumanControlled())
        {
            // End:0xCB
            if(((int(CoverAction) == int(3)) || int(CoverAction) == int(1)) && (int(NewCoverAction) != int(3)) && int(NewCoverAction) != int(1))
            {
                NextCoverActionTime = -WorldInfo.TimeSeconds + 0.3000000;                
            }
            else
            {
                // End:0x150
                if(((int(CoverAction) == int(4)) || int(CoverAction) == int(2)) && (int(NewCoverAction) != int(4)) && int(NewCoverAction) != int(2))
                {
                    NextCoverActionTime = WorldInfo.TimeSeconds + 0.3000000;
                }
            }
        }
        // End:0x22D
        if((int(NewCoverAction) != int(0)) && Abs(NextCoverActionTime) > WorldInfo.TimeSeconds)
        {
            // End:0x1E2
            if(((NextCoverActionTime < 0.0000000) && int(NewCoverAction) != int(3)) && int(NewCoverAction) != int(1))
            {
                NewCoverAction = 0;                
            }
            else
            {
                // End:0x22D
                if(((NextCoverActionTime > 0.0000000) && int(NewCoverAction) != int(4)) && int(NewCoverAction) != int(2))
                {
                    NewCoverAction = 0;
                }
            }
        }
    }
    // End:0x263
    if(!CanDoLeaningTransition())
    {
        // End:0x263
        if((IsALeaningAction(NewCoverAction)) && IsLeaning())
        {
            return;
        }
    }
    CoverAction = NewCoverAction;
    LastCoverActionTime = WorldInfo.TimeSeconds;
    // End:0x2BE
    if(int(Role) == int(ROLE_Authority))
    {
        bForceNetUpdate = true;
    }
    CoverActionChanged();
    //return;    
}

simulated function CoverActionChanged()
{
    PreviousCoverAction = SavedCoverAction;
    SavedCoverAction = CoverAction;
    //return;    
}

simulated function CovPosInfo CoverInfoToCovPosInfo(CoverInfo CovInfo)
{
    local CovPosInfo PosInfo;

    PosInfo.Link = CovInfo.Link;
    PosInfo.LtSlotIdx = CovInfo.SlotIdx;
    PosInfo.RtSlotIdx = CovInfo.SlotIdx;
    PosInfo.Location = CovInfo.Link.GetSlotLocation(CovInfo.SlotIdx);
    PosInfo.LtToRtPct = 0.0000000;
    PosInfo.Normal = -1.0000000 * Normal(Vector(CovInfo.Link.GetSlotRotation(CovInfo.SlotIdx)));
    return PosInfo;
    //return ReturnValue;    
}

simulated function CoverAcquired(CovPosInfo CovInfo)
{
    SetCoverAction(0);
    CurrentSlotDirection = 0;
    SetCovPosInfo(CovInfo, true);
    CurrentLink.Claim(self, CurrentSlotIdx);
    AcquiredCoverInfo = CovInfo;
    ServerDoPawnAction(16,,, GetRun2CoverStartAnimPackedIndex());
    //return;    
}

simulated function SetCovPosInfo(CovPosInfo CovInfo, bool bReplicate)
{
    SetCoverInfo(CovInfo.Link, ((CovInfo.LtToRtPct < 0.5000000) ? CovInfo.LtSlotIdx : CovInfo.RtSlotIdx), CovInfo.LtSlotIdx, CovInfo.RtSlotIdx, CovInfo.LtToRtPct, bReplicate);
    //return;    
}

event bool SpecialMoveThruEdge(Pylon.ENavMeshEdgeType EdgeType, int Dir, Vector MoveStart, Vector MoveDest, optional Actor RelActor, optional int RelItem, optional NavigationHandle NavHandle)
{
    return super(Pawn).SpecialMoveThruEdge(EdgeType, Dir, MoveStart, MoveDest, RelActor, RelItem, NavHandle);
    //return ReturnValue;    
}

function bool SpecialMoveTo_Mantle(int Dir, Vector MoveStart, Vector MoveDest)
{
    ServerDoPawnAction(19);
    return true;
    //return ReturnValue;    
}

simulated function SetCoverInfo(CoverLink Link, int SlotIdx, int LeftIdx, int RightIdx, float SlotPct, bool bReplicate)
{
    // End:0x39
    if(CurrentLink != none)
    {
        CurrentLink.UnClaim(self, CurrentSlotIdx, false);
    }
    CurrentLink = Link;
    CurrentSlotIdx = SlotIdx;
    ClosestSlotIdx = SlotIdx;
    LeftSlotIdx = LeftIdx;
    RightSlotIdx = RightIdx;
    CurrentSlotPct = SlotPct;
    SetCurrentCoverType();
    // End:0xEE
    if(CurrentLink != none)
    {
        CurrentLink.Claim(self, SlotIdx);
    }
    //return;    
}

function SetCurrentCoverType(optional bool bClear)
{
    // End:0x38
    if(!bClear && CurrentLink != none)
    {
        SetCoverType(FindCoverType());        
    }
    else
    {
        SetCoverType(0);
    }
    //return;    
}

function SetCoverType(CoverLink.ECoverType NewCoverType)
{
    // End:0x9F
    if(int(NewCoverType) != int(CoverType))
    {
        // End:0x64
        if((int(CoverType) != int(0)) && int(NewCoverType) == int(0))
        {
            // End:0x64
            if(!IsDoingPawnRotationInterpolation())
            {
                InterpolatePawnRotation(0.0000000, true);
            }
        }
        LastCoverTime = WorldInfo.TimeSeconds;
        CoverType = NewCoverType;
    }
    //return;    
}

function CoverLink.ECoverType FindCoverType()
{
    // End:0x10
    if(bWantsToCrouch)
    {
        return 2;
    }
    return CurrentLink.Slots[((ClosestSlotIdx != -1) ? ClosestSlotIdx : CurrentSlotIdx)].CoverType;
    //return ReturnValue;    
}

function LeaveCover()
{
    AcquiredCoverInfo.Link = none;
    PreviousSlotIdx = CurrentSlotIdx;
    CurrentSlotPct = -1.0000000;
    CurrentSlotIdx = -1;
    CurrentLink = none;
    SetCurrentCoverType(true);
    //return;    
}

function OnJump(SeqAct_Jump Action)
{
    // End:0x11
    if(CurrentJumpInfo != none)
    {
        return;
    }
    ZeroMovementVariables();
    // End:0xB3
    if(Action.ImpulseVector != none)
    {
        JumpImpulseFromKismet = Vector(Action.ImpulseVector.Rotation) * Action.ImpulseVector.ImpulseStrength;
    }
    CurrentJumpInfo = Action.JumpSequenceInfos[Rand(Action.JumpSequenceInfos.Length)];
    // End:0x10E
    if(CurrentJumpInfo == none)
    {
        return;
    }
    JumpKismetAction = Action;
    JumpDeltaMultiplier = Action.JumpDeltaMultiplier;
    bInheritJumpVelocityFromMotionDelta = Action.bInheritVelocityFromMotionDelta;
    // End:0x188
    if(bInheritJumpVelocityFromMotionDelta)
    {
        SetPhysics(2);        
    }
    MyEvilAI.AbortCommand(MyEvilAI.CommandList);
    Class'EvilAICmd_Jump'.static.InitJump(MyEvilAI);
    //return;    
}

function StartJump()
{
    Velocity = JumpImpulseFromKismet;
    // End:0x23
    if(bInheritJumpVelocityFromMotionDelta)
    {        
    }
    else
    {
        SetPhysics(2);
    }
    //return;    
}

function ENABLEHITPLAYRAGDOLL()
{
    bPotentiallyCanPlayKnockDown = true;
    //return;    
}

function DISABLEHITPLAYRAGDOLL()
{
    bPotentiallyCanPlayKnockDown = false;
    //return;    
}

function DROPWEAPONONDEATH()
{
    //return;    
}

final simulated function InterpolatePawnRotation(optional float RotationInterpTime, optional bool bCoverTransition)
{
    bRotInterpCoverTransition = bCoverTransition;
    // End:0x57
    if(!bCoverTransition)
    {
        PawnRotationBlendTimeToGo = ((RotationInterpTime > 0.0000000) ? RotationInterpTime : PawnRotationInterpolationTime);
    }
    //return;    
}

final simulated function bool IsDoingPawnRotationInterpolation()
{
    return (PawnRotationBlendTimeToGo > 0.0000000) || bRotInterpCoverTransition;
    //return ReturnValue;    
}

function bool IsInCover()
{
    return ((int(CoverType) != int(0)) && CurrentLink != none) && CurrentSlotIdx >= 0;
    //return ReturnValue;    
}

function RequestDefaultMovementMode()
{
    // End:0xAE
    if(int(SupremeMoveMode) == int(0))
    {
        // End:0x94
        if((MyEvilAI != none) && MyEvilAI.InLatentExecution(503) || MyEvilAI.InLatentExecution(501))
        {
            MyEvilAI.StopLatentExecution();
        }
        ZeroMovementVariables();
        ChangeMoveMode(0);        
    }
    else
    {
        // End:0xE0
        if(bIsWalking)
        {
            bShouldWalkFast = default.bShouldWalkFast;
            ChangeMoveMode(1);            
        }
        else
        {
            // End:0x119
            if((int(SupremeMoveMode) >= int(2)) && ReadyToRunInterval <= 0.0000000)
            {
                ChangeMoveMode(2);                
            }
            else
            {
                // End:0x13A
                if(int(SupremeMoveMode) >= int(1))
                {
                    ChangeMoveMode(1);
                }
            }
        }
    }
    //return;    
}

function bool IsReadyToRun()
{
    return ReadyToRunInterval <= 0.0000000;
    //return ReturnValue;    
}

protected singular simulated function ProcessMovementMode(float DeltaSeconds)
{
    local EvilAnim_AST ASTNode;
    local int I;
    local float R;
    local Rotator Rot;

    // End:0x188
    if((Controller != none) && Controller.bIsPlayer)
    {
        // End:0x6F
        if(bForceMoveMode)
        {
            // End:0x6F
            if(int(CurrentMoveMode) != int(MoveModeToEnforce))
            {
                ChangeMoveMode(MoveModeToEnforce);
            }
        }
        switch(CurrentMoveMode)
        {
            // End:0xB9
            case 0:
                // End:0xB6
                if(!IsZero(Velocity))
                {
                    ChangeMoveMode(((bIsWalking) ? 1 : 2));
                }
                // End:0x185
                break;
            // End:0x113
            case 1:
                // End:0x103
                if(!IsZero(Velocity))
                {
                    // End:0x100
                    if(!bIsWalking && MovementSpeedModifier > 1.5000000)
                    {
                        ChangeMoveMode(2);
                    }                    
                }
                else
                {
                    ChangeMoveMode(0);
                }
                // End:0x185
                break;
            // End:0x16B
            case 2:
                // End:0x15B
                if(!IsZero(Velocity))
                {
                    // End:0x158
                    if(bIsWalking || MovementSpeedModifier < 0.7500000)
                    {
                        ChangeMoveMode(1);
                    }                    
                }
                else
                {
                    ChangeMoveMode(0);
                }
                // End:0x185
                break;
            // End:0x170
            case 3:
            // End:0x175
            case 4:
            // End:0xFFFF
            default:
                RequestDefaultMovementMode();
                // End:0x185
                break;
                break;
        }        
    }
    else
    {
        // End:0x1C0
        if((WalkSlowAnimIndex >= (AST_GetAnimCount(69))) || RunAnimIndex >= (AST_GetAnimCount(67)))
        {
            return;
        }
        // End:0x1FF
        if(bForceMoveMode)
        {
            // End:0x1FC
            if(int(CurrentMoveMode) != int(MoveModeToEnforce))
            {
                ChangeMoveMode(MoveModeToEnforce);
            }            
        }
        else
        {
            // End:0x25C
            if((bFastSpinUp && int(CurrentMoveMode) != int(0)) && int(CurrentMoveMode) != int(3))
            {
                bFastSpinUp = false;
                MeshYawOffset = 0;
                RequestDefaultMovementMode();                
            }
            else
            {
                // End:0x308
                if(bInMoveLatent || bFastSpinUp)
                {
                    // End:0x305
                    if((int(CurrentMoveMode) == int(0)) && int(SupremeMoveMode) > int(0))
                    {
                        // End:0x2EC
                        if(int(Mesh.RootMotionMode) != int(2))
                        {
                            Mesh.RootMotionMode = 1;
                        }
                        // End:0x305
                        if(!bFastSpinUp)
                        {
                            RequestDefaultMovementMode();
                        }
                    }                    
                }
                else
                {
                    // End:0x329
                    if(int(CurrentMoveMode) != int(0))
                    {
                        ChangeMoveMode(0);
                    }
                }
            }
        }
        bReadyToRun = IsReadyToRun();
        switch(CurrentMoveMode)
        {
            // End:0x84A
            case 0:
                // End:0x7A6
                if(bFastSpinUp && int(SupremeMoveMode) >= int(2))
                {
                    Class'EvilPawn'.static.UnpackAnimInfo(PackedFastSpinUpAnimInfo, SpinUpAST, SpinUpIndex);
                    ASTNode = EvilAnim_AST(MoveModeNode.Children[3].Anim);
                    ASTNode.AST = SpinUpAST;
                    ASTNode.ForceUpdateFromAnimDef();
                    ReadyToRunInterval = ASTNode.GetAnimPlaybackLength() - MoveModeNode.GetBlendTime(2, true);
                    // End:0x665
                    if(MyEvilAI != none)
                    {
                        R = RSize(Rotation - Rotator(MyEvilAI.GetFocalPoint() - Location));
                        I = 0;
                        J0x4F5:

                        // End:0x665 [Loop If]
                        if(I < ASTNode.AnimSeq.Notifies.Length)
                        {
                            // End:0x657
                            if(AnimNotify_FastSpinUpRotationEnd(ASTNode.AnimSeq.Notifies[I].Notify) != none)
                            {
                                RotationRate.Yaw = int(R / ((ASTNode.AnimSeq.Notifies[I].Time - MoveModeNode.GetBlendTime(2, true)) * ASTNode.Rate));
                                // [Explicit Break]
                                goto J0x665;
                            }
                            ++I;
                            // [Loop Continue]
                            goto J0x4F5;
                        }
                    }
                    J0x665:

                    RotationRate.Yaw = Max(RotationRate.Yaw, Round(Abs(R / ReadyToRunInterval)));
                    MeshYawOffset = NormalizeRotAxis(DesiredRotation.Yaw - Rotation.Yaw);
                    Rot = Rotation;
                    Rot.Yaw = DesiredRotation.Yaw;
                    SetRotation(Rot);
                    // End:0x796
                    if(TurnInPlaceNode != none)
                    {
                        TurnInPlaceNode.LastPawnYaw += MeshYawOffset;
                    }
                    ChangeMoveMode(3);                    
                }
                else
                {
                    // End:0x847
                    if(((MyEvilAI != none) && CanTurnInPlace()) && RSize(DesiredRotation - Rotation) > float(0))
                    {
                        // End:0x847
                        if(!IsDesiredRotationLocked() && bCanDoTurnInPlaceAnim)
                        {
                            RotationRate.Yaw = TurnInPlaceNode.GetYawRate();
                        }
                    }
                }
                // End:0xAC1
                break;
            // End:0x8A5
            case 1:
                // End:0x870
                if(int(SupremeMoveMode) < int(1))
                {
                    RequestDefaultMovementMode();                    
                }
                else
                {
                    // End:0x8A2
                    if(!bIsWalking && int(SupremeMoveMode) >= int(2))
                    {
                        ChangeMoveMode(2);
                    }
                }
                // End:0xAC1
                break;
            // End:0x8EA
            case 2:
                // End:0x8CB
                if(int(SupremeMoveMode) < int(2))
                {
                    RequestDefaultMovementMode();                    
                }
                else
                {
                    // End:0x8D8
                    if(bShouldBeginStumble)
                    {
                    }
                }
                ReadyToRunInterval = 0.0000000;
                // End:0xAC1
                break;
            // End:0xA76
            case 3:
                // End:0x960
                if(int(SupremeMoveMode) < int(2))
                {
                    RotationRate.Yaw = default.RotationRate.Yaw;
                    bFastSpinUp = false;
                    MeshYawOffset = 0;
                    RequestDefaultMovementMode();                    
                }
                else
                {
                    // End:0xA19
                    if(ReadyToRunInterval > 0.0000000)
                    {
                        I = MeshYawOffset;
                        MeshYawOffset += (((MeshYawOffset > 0) ? -1 : 1) * FCeil(DeltaSeconds * float(RotationRate.Yaw)));
                        // End:0xA02
                        if((I * MeshYawOffset) <= 0)
                        {
                            MeshYawOffset = 0;
                        }
                        ReadyToRunInterval -= DeltaSeconds;                        
                    }
                    else
                    {
                        bFastSpinUp = false;
                        MeshYawOffset = 0;
                        RotationRate.Yaw = default.RotationRate.Yaw;
                        RequestDefaultMovementMode();
                    }
                }
                // End:0xAC1
                break;
            // End:0xABB
            case 4:
                // End:0xAA5
                if(ReadyToRunInterval > 0.0000000)
                {
                    ReadyToRunInterval -= DeltaSeconds;                    
                }
                else
                {
                    bForceMoveMode = false;
                    RequestDefaultMovementMode();
                }
            // End:0xFFFF
            default:
                // End:0xAC1
                break;
                break;
        }
        // End:0xB47
        if(int(Mesh.RootMotionMode) == int(2))
        {
            MoveModeNode.SetActiveChildRootExtract(false, bFastSpinUp || bPlayingTurnTransition);
            Mesh.RootMotionRotationMode = 0;            
        }
        else
        {
            MoveModeNode.SetActiveChildRootExtract(true, bFastSpinUp || bPlayingTurnTransition);
            // End:0xC12
            if((((int(PawnAction) == 0) && CurrentNavPointAction == none) && Base != none) && int(Physics) == int(1))
            {
                // End:0xC12
                if(MoveModeNode.BlendTimeToGo <= 0.0000000)
                {
                    Mesh.RootMotionMode = 1;
                }
            }
        }
    }
    //return;    
}

function DoubleGravity_T()
{
    CustomGravityScaling = 2.0000000;
    //return;    
}

function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive)
{
    bOnLightInfluenceFromFlashLight = bInLightCone;
    UpdateLightInfluence_T();
    //return;    
}

function UpdateLightInfluence()
{
    // End:0x2A
    if(LightInfluenceTimeout > 0.0000000)
    {
        SetTimer(LightInfluenceTimeout, false, 'ClearLightInfluence');
    }
    //return;    
}

function ClearLightInfluence()
{
    StopBurning();
    //return;    
}

function SetLightAffectionFromVolume(bool bInLightVolume)
{
    bOnLightInfluenceFromVolume = bInLightVolume;
    //return;    
}

function DieInBurningAnim_T()
{
    EndPawnAction();
    //return;    
}

simulated function BeginAIGroup()
{
    MyEvilAI.DisableAI(true, true);
    //return;    
}

simulated function FinishAIGroup()
{
    MyEvilAI.EnableAI();
    //return;    
}

simulated function bool CanPlayHitSounds()
{
    return true;
    //return ReturnValue;    
}

function bool CanPlayDirectHitByProjectile()
{
    return true;
    //return ReturnValue;    
}

simulated function bool CanPlayHitImpactEffects()
{
    return true;
    //return ReturnValue;    
}

simulated function bool CanLeaveBloodDecals()
{
    return true;
    //return ReturnValue;    
}

function AddComboBonus(int bonusAmount)
{
    //return;    
}

function CallKismetEvent(class<SequenceObject> DesiredClass, optional int LinkNumber = 0)
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local array<int> EventOutLinks;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0xDA
    if(GameSeq != none)
    {
        EventOutLinks[0] = LinkNumber;
        GameSeq.FindSeqObjectsByClass(DesiredClass, true, ExecutionEvents);
        // End:0xD9
        foreach ExecutionEvents(ExecutionEvent)
        {
            SequenceEvent(ExecutionEvent).CheckActivate(WorldInfo, none, false, EventOutLinks);            
        }        
    }
    //return;    
}

simulated function PlayNoGoreDyingEffects()
{
    //return;    
}

simulated function class<EvilBloodGlob> GetBloodGlobClass(class<EvilDmgType_Base> dmgType)
{
    return none;
    //return ReturnValue;    
}

function CollectDamageLocations(Vector InDamageInstigatorLocation, Vector DamageLocation, class<DamageType> DamageType)
{
    //return;    
}

// Export UEvilPawn::execSetRBLinearVelocityToLinkedBodies(FFrame&, void* const)
native static final function SetRBLinearVelocityToLinkedBodies(SkeletalMeshComponent InMesh, Vector NewVel, bool bAddToCurrent, name BoneName);

// Export UEvilPawn::execApplyPointImpulseForAllBodies(FFrame&, void* const)
native static final function ApplyPointImpulseForAllBodies(SkeletalMeshComponent InMesh, Vector Impulse, Vector Position, bool bVelChange);

// Export UEvilPawn::execSetRBLinearVelocity2(FFrame&, void* const)
native static final function SetRBLinearVelocity2(SkeletalMeshComponent InMesh, Vector NewVel, optional bool bAddToCurrent, optional name BoneName);

// Export UEvilPawn::execSetRBAngularVelocity2(FFrame&, void* const)
native static final function SetRBAngularVelocity2(SkeletalMeshComponent InMesh, Vector NewAngVel, optional bool bAddToCurrent, optional name BoneName);

// Export UEvilPawn::execSetRBMaxAngularVelocity(FFrame&, void* const)
native static final function SetRBMaxAngularVelocity(SkeletalMeshComponent InMesh, float maxAngVel, optional name BoneName);

// Export UEvilPawn::execGetGlobalCMassLocation(FFrame&, void* const)
native static final function bool GetGlobalCMassLocation(SkeletalMeshComponent InMesh, out Vector outCMassLoc, optional name BoneName);

// Export UEvilPawn::execLimitRagdollSpeed(FFrame&, void* const)
native final function LimitRagdollSpeed(float SpeedLimit);

simulated state Dying
{
    ignores TrueDied_T;

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SetTimer(TimeToBodyDisappear, false);
        SetTimer(0.0100000, false, 'TrueDied_T');
        //return;        
    }

    simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
    {
        PlayMeleeImpacts(RigidCollisionData.ContactInfos[0].ContactPosition);
        //return;        
    }

    simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        local Pawn InstigatedByPawn;
        local class<EvilDmgType_Base> EvilDamageType;
        local Vector ApplyImpulse;

        EvilDamageType = class<EvilDmgType_Base>(DamageType);
        // End:0x76
        if(bDetachingLimbsWhenDiedEnabled)
        {
            TryDetachLimb(Damage, EvilDamageType, HitLocation, Momentum, HitInfo.BoneName);
        }
        InstigatedByPawn = ((InstigatedBy != none) ? InstigatedBy.Pawn : none);
        // End:0xF9
        if(InstigatedByPawn != none)
        {
            CollectDamageLocations(InstigatedByPawn.Location, HitLocation, EvilDamageType);
        }
        // End:0x13D
        if(bPotentiallyCanPlayKnockDown && CanBeKnockedDown())
        {
            Knockdown(vect(0.0000000, 0.0000000, 0.0000000), vect(1.0000000, 1.0000000, 1.0000000));
        }
        // End:0x1B8
        if(Class'EvilGame'.static.UseLowGore(WorldInfo))
        {
            // End:0x1B6
            if(!bGibbed)
            {
                // End:0x1B6
                if((EvilDamageType != none) && ShouldGib(EvilDamageType))
                {
                    bTearOffGibs = true;
                    bGibbed = true;
                }
            }
            return;
        }
        // End:0x206
        if(DeathAnimDamageType != none)
        {
            // End:0x206
            if(DamageType == DeathAnimDamageType)
            {
                TimeLastTookDeathAnimDamage = WorldInfo.TimeSeconds;
            }
        }
        // End:0x5A7
        if((InstigatedBy != none) || EffectIsRelevant(Location, true, 0.0000000))
        {
            // End:0x297
            if(AccumulationTime != WorldInfo.TimeSeconds)
            {
                AccumulateDamage = 0.0000000;
                AccumulationTime = WorldInfo.TimeSeconds;
            }
            AccumulateDamage += float(Damage);
            Health -= Damage;
            // End:0x5A7
            if(EvilDamageType != none)
            {
                // End:0x5A7
                if(!bHideOnListenServer && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
                {
                    CheckHitInfo(HitInfo, Mesh, Normal(Momentum), HitLocation);
                    EvilDamageType.static.SpawnHitEffect(self, float(Damage), Momentum, HitInfo.BoneName, HitLocation);
                    // End:0x3B4
                    if(FRand() < 0.1500000)
                    {
                        DropDecals(HitLocation, false);
                    }
                    // End:0x46A
                    if((EvilDamageType.default.DamageOverlayTime > float(0)) && EvilDamageType.default.DamageBodyMatColor != Class'EvilDmgType_Base'.default.DamageBodyMatColor)
                    {
                        SetBodyMatColor(EvilDamageType.default.DamageBodyMatColor, EvilDamageType.default.DamageOverlayTime);
                    }
                    // End:0x4B3
                    if(ShouldGib(EvilDamageType))
                    {
                        InstantGib(Damage, EvilDamageType, HitLocation, vect(0.0000000, 0.0000000, 0.0000000));
                    }
                    // End:0x512
                    if(((int(Physics) != int(10)) || Momentum == vect(0.0000000, 0.0000000, 0.0000000)) || HitInfo.BoneName == 'None')
                    {
                        return;
                    }
                    ApplyImpulse = ComputeDeathRagdollImpulse(Momentum, EvilDamageType, true);
                    Mesh.WakeRigidBody();
                    Mesh.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName, true);
                }
            }
        }
        //return;        
    }
Begin:

    PlayDyingSound();
    Sleep(0.2000000);
    CheckSoundEffects();
    stop;                
}

state KnockedDown
{
    function BeginState(name PrevStatName)
    {
        ClearTimer('EndKnockedDownState');
        ClearTimer('CheckGetUpFromRagdoll');
        ClearTimer('KnockdownFailsafe');
        Class'EvilAICmd_KnockDown'.static.InitCommand(MyEvilAI);
        //return;        
    }
Begin:

    SetTimer(5.0000000 + RandRange(0.3000000, 0.7000000), false, 'EndKnockedDownState');
    J0x29:

    Sleep(0.3500000);
    ThrowWeaponOnRagdoll();
    // End:0x29
    if(!(((int(Physics) != int(10)) || VSize(Velocity) < 8.0000000) || !Mesh.RigidBodyIsAwake()))
        goto J0x29;
    Sleep(RandRange(0.1000000, 0.5000000));
    EndKnockedDownState();
SkipRecover:


    stop;        
}

state RidingRailCar
{
    ignores SetMovementPhysics;
    stop;    
}

defaultproperties
{
    bCanPinToThisActor=true
    bDisableEvilAnimWeaponAnims=true
    bShowOnRadar=true
    bCanPlayVO=true
    bPlayHitSoundInPlayHit=true
    bCanBeKnockedDown=true
    bShouldPlayMeleeImpacts=true
    bHasDirectionalMoveAnims=true
    DetachingSpecificLimbEnabled=true
    bDetachingLimbsWhenDiedEnabled=true
    bCanDoTurnInPlaceAnim=true
    JumpDeltaMultiplier=1.0000000
    RequestedAimZone=EAimZone.AZ_Middle
    SupremeMoveMode=EMoveMode.None
    MyEnemyRatingForOthersModifier=1.0000000
    PawnActionAnimRateModifier=1.0000000
    ReduceDamageFactor=1.0000000
    DefaultHealth=300.0000000
    SprintSpeedModifier=2.0000000
    SprintFOV=80.0000000
    SprintFOVRate=60.0000000
    Stamina=1.0000000
    StaminaDecreaseAmount=0.0100000
    StaminaRegenAmount=0.0200000
    HipsBoneName="Hips"
    RightHandBoneName="RightHand"
    LeftHandBoneName="LeftHand"
    LeftFootBoneName="LeftFoot"
    RightFootBoneName="RightFoot"
    TimeToBodyDisappear=18.0000000
    TimeToBodyDisappear_NoGore=0.6000000
    GrenadeSocket="GrenadeSocket"
    GrenadeTossZ=1300.0000000
    SynchronizedBonesIndexes[0]=1
    SynchronizedBonesIndexes[1]=3
    SynchronizedBonesIndexes[2]=5
    SynchronizedBonesIndexes[3]=40
    SynchronizedBonesIndexes[4]=61
    SynchronizedBonesIndexes[5]=83
    SynchronizedBonesIndexes[6]=87
    BurnLightArchetype=EvilLightActor'ps_Fire.Archetypes.ar_FireLight'
    BurnBlackMaterialDelay=0.1000000
    BurnDotsMaterialDelay=0.1000000
    BurnBlackMaterialAmount=0.0300000
    BurnDotsMaterialAmount=0.0500000
    RemoveBurnDotsAmount=0.1000000
    ReplicatedHeadClothIndex=-1
    ReplicatedEquipmentClothIndex=-1
    ReplicatedClothesInfo[0]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[1]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[2]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[3]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[4]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[5]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[6]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[7]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[8]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[9]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[10]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[11]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[12]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[13]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[14]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[15]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[16]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[17]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[18]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[19]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[20]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[21]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[22]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[23]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[24]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[25]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[26]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[27]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[28]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[29]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[30]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothesInfo[31]=(ClothIndex=255,RandomMaterialIndex=255,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[0]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[1]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[2]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[3]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[4]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[5]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[6]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[7]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[8]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[9]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[10]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[11]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[12]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[13]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[14]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[15]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[16]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[17]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[18]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[19]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[20]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[21]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[22]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[23]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[24]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[25]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[26]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[27]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[28]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[29]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[30]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothMaterials[31]=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothWeapon=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    ReplicatedClothShield=(MaterialIndex=255,RandomMaterialIndex=0,Dummy=0,Dummy[1]=0)
    CurrentHitInformation=(Damage=0,EventInstigator=none,HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000),HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName="None",HitComponent=none),DamageCauser=none,DamageClassification=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),GibClassification=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000))
    GameIntesityFactor=0.1000000
    HitZones[0]=(BodyPart=EBodyParts.BP_Head,ZoneComboName="Headshot",ZoneScoring=100.0000000,ZonePriority=1,ZoneBones=ZoneBones[0]="Head",Health=0,bIsLimbDetached=false)
    HitZones[1]=(BodyPart=EBodyParts.BP_Nuts,ZoneComboName="Nutshot",ZoneScoring=100.0000000,ZonePriority=1,ZoneBones=ZoneBones[0]="Hips",Health=0,bIsLimbDetached=false)
    HitZones[2]=(BodyPart=EBodyParts.BP_Torso,ZoneComboName="Gutshot",ZoneScoring=50.0000000,ZonePriority=1,ZoneBones=ZoneBones[0]="Spine"
    ZoneBones[1]="Spine1",Health=0,bIsLimbDetached=false)
    HitZones[3]=(BodyPart=EBodyParts.BP_LeftLeg,ZoneComboName="Surgery",ZoneScoring=50.0000000,ZonePriority=1,ZoneBones=ZoneBones[0]="LeftUpLeg"
    ZoneBones[1]="LeftFoot"
    ZoneBones[2]="LeftLeg",Health=0,bIsLimbDetached=false)
    HitZones[4]=(BodyPart=EBodyParts.BP_RightLeg,ZoneComboName="Limbo",ZoneScoring=50.0000000,ZonePriority=1,ZoneBones=ZoneBones[0]="RightUpLeg"
    ZoneBones[1]="RightFoot"
    ZoneBones[2]="RightLeg",Health=0,bIsLimbDetached=false)
    HitZones[5]=(BodyPart=EBodyParts.BP_LeftArm,ZoneComboName="Armbar",ZoneScoring=50.0000000,ZonePriority=1,ZoneBones=ZoneBones[0]="LeftShoulder"
    ZoneBones[1]="LeftArm"
    ZoneBones[2]="LeftForeArm"
    ZoneBones[3]="LeftHand",Health=0,bIsLimbDetached=false)
    HitZones[6]=(BodyPart=EBodyParts.BP_RightArm,ZoneComboName="Handshake",ZoneScoring=50.0000000,ZonePriority=1,ZoneBones=ZoneBones[0]="RightShoulder"
    ZoneBones[1]="RightArm"
    ZoneBones[2]="RightForeArm"
    ZoneBones[3]="RightHand",Health=0,bIsLimbDetached=false)
    DefaultZone=(BodyPart=EBodyParts.BP_Torso,ZoneComboName="Hit",ZoneScoring=0.0000000,ZonePriority=0,ZoneBones=none,Health=0,bIsLimbDetached=false)
    LastHitZone=-1
    DetachingLimbSoundLimiter=-1
    DecalMaterialIndex=1
    HitDecalSize=4.0000000
    TurnInPlaceWhileMovingYawThreshold=21845.0000000
    AcquiredCoverInfo=none
    PawnRotationInterpolationTime=0.1500000
    WalkSlowSpinUpAnim="WalkSlow1"
    WalkFastSpinUpAnim="WalkFast1"
    SlowDownDelay=0.1000000
    // Reference: DynamicLightEnvironmentComponent'Default__EvilPawn.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__UTPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
        VelocityUpdateTimeScale=0.0020000
        ModShadowFadeoutTime=0.7500000
        bAllowDynamicShadowsOnTranslucency=true
    end object
    LightEnvironment=MyLightEnvironment
    DodgeSpeed=300.0000000
    DodgeSpeedZ=300.0000000
    // Reference: ForceFeedbackWaveform'Default__EvilPawn.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__UTPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    RagdollLifespan=0.0000000
    bCanDoubleJump=false
    bEnableFootPlacement=false
    MaxMultiJump=0
    // Reference: UTAmbientSoundComponent'Default__EvilPawn.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__UTPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__EvilPawn.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__UTPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__EvilPawn.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__UTPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    LeftFootBone="LeftFoot_REMOVEMEWHENFIXED"
    RightFootBone="RightFoot_REMOVEMEWHENFIXED"
    LeftFootControlName="LeftFootControl_REMOVEMEWHENFIXED"
    RightFootControlName="RightFootControl_REMOVEMEWHENFIXED"
    MaxLeanRoll=1024
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__EvilPawn.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__UTPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__EvilPawn.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__UTPawn.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__EvilPawn.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__UTPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__EvilPawn.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__UTPawn.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bRespondToExplosions=true
    MaxStepHeight=30.0000000
    MaxJumpHeight=5.0000000
    LedgeCheckThreshold=70.0000000
    bCanCrouch=false
    bPartiallyOverLedge=true
    bCanWalkOffLedges=true
    bCanMantle=true
    bCanClimbUp=true
    CrouchHeight=35.0000000
    CrouchRadius=25.0000000
    JumpOverCoverDist=180.0000000
    JumpOverCoverHeight=80.0000000
    SightRadius=2500.0000000
    GroundSpeed=300.0000000
    WaterSpeed=240.0000000
    AirSpeed=340.0000000
    AccelRate=150.0000000
    JumpZ=100.0000000
    BaseEyeHeight=40.0000000
    EyeHeight=40.0000000
    // Reference: SkeletalMeshComponent'Default__EvilPawn.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__UTPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        bUpdateSkelWhenNotRendered=true
        bIgnoreControllersWhenNotRendered=false
        bRootMotionModeChangeNotify=true
        RootMotionMode=ERootMotionMode.RMM_Velocity
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilPawn.MyLightEnvironment'
        RBChannel=ERBCollisionChannel.RBCC_Pawn
        CollideActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true
        RBCollideWithChannels=(Default=true,Pawn=true,EffectPhysics=true,Untitled3=false,SoftBody=true,FracturedMeshPart=true,BlockingVolume=true)
        Translation=(X=0.0000000,Y=0.0000000,Z=-65.0000000)
        Scale=1.0000000
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__EvilPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__UTPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=62.0000000
        CollisionRadius=25.0000000
        ReplacementPrimitive=none
        BlockZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    ViewPitchMin=-14924.0000000
    ViewPitchMax=14924.0000000
    // Reference: EvilAudioComponent'Default__EvilPawn.FaceAudioComponent'
    begin object name="FaceAudioComponent" class=Class'EvilAudioComponent'
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    bCanStepUpOn=false
    bAlwaysRelevant=true
    bReplicateRigidBodyLocation=false
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=30000,Yaw=30000,Roll=30000)
}