class SkyPawn extends SkyPawnBase
    abstract
    native
    config(Game);

enum EDamageSource
{
    Damage_Suicide,                 // 0
    Damage_Falling,                 // 1
    Damage_LastAttack,              // 2
    Damage_MAX                      // 3
};

enum EBlendByParachutingState
{
    Parachuting_NotParachuting,     // 0
    Parachuting_Opening,            // 1
    Parachuting_Parachuting,        // 2
    Parachuting_Cutting,            // 3
    Parachuting_Landing,            // 4
    Parachuting_MAX                 // 5
};

enum EBlendByRocketPackingState
{
    RocketPacking_NotRocketPacking, // 0
    RocketPacking_Boosting,         // 1
    RocketPacking_Thrusting,        // 2
    RocketPacking_Gliding,          // 3
    RocketPacking_MAX               // 4
};

enum EPickupState
{
    Pickup_Not,                     // 0
    Pickup_SlowDown,                // 1
    Pickup_Swap,                    // 2
    Pickup_Get,                     // 3
    Pickup_Drop,                    // 4
    Pickup_Max                      // 5
};

enum EArmorType
{
    ArmorType_Undefined,            // 0
    ArmorType_Head,                 // 1
    ArmorType_Torso,                // 2
    ArmorType_ArmRight,             // 3
    ArmorType_ArmLeft,              // 4
    ArmorType_LegRight,             // 5
    ArmorType_LegLeft,              // 6
    ArmorType_ArchonShieldA,        // 7
    ArmorType_ArchonShieldB,        // 8
    ArmorType_ArchonShieldC,        // 9
    ArmorType_ArchonShieldD,        // 10
    ArmorType_MAX                   // 11
};

enum EMatValueCurve
{
    ZeroToOne,                      // 0
    OneToZero,                      // 1
    EMatValueCurve_MAX              // 2
};

enum ESprintState
{
    Sprint_None,                    // 0
    Sprint_Sprinting,               // 1
    Sprint_SprintDive,              // 2
    Sprint_MAX                      // 3
};

enum EFallState
{
    Fall_Suspended,                 // 0
    Fall_Up,                        // 1
    Fall_Down,                      // 2
    Fall_Falling,                   // 3
    Fall_Land,                      // 4
    Fall_None,                      // 5
    Fall_MAX                        // 6
};

enum EDodgeState
{
    Dodge_None,                     // 0
    Dodge_L,                        // 1
    Dodge_R,                        // 2
    Dodge_F,                        // 3
    Dodge_B,                        // 4
    Dodge_MAX                       // 5
};

enum E180State
{
    X180_None,                      // 0
    X180_Yes,                       // 1
    X180_MAX                        // 2
};

enum EMeshType
{
    MT_Body,                        // 0
    MT_Hair,                        // 1
    MT_Head,                        // 2
    MT_Legs,                        // 3
    MT_Rocketpack,                  // 4
    MT_MAX                          // 5
};

enum EReactionCategory
{
    ERC_NONE,                       // 0
    ERC_EXPLOSION,                  // 1
    ERC_BULLET,                     // 2
    ERC_DAMAGE,                     // 3
    ERC_MAX                         // 4
};

enum EAdeptAttackReaction
{
    EAAR_Stun,                      // 0
    EAAR_Kill,                      // 1
    EAAR_MAX                        // 2
};

enum EAnimDrivingState
{
    ADS_PreInit,                    // 0
    ADS_NotDriving,                 // 1
    ADS_Entering,                   // 2
    ADS_Driving,                    // 3
    ADS_Exiting,                    // 4
    ADS_MAX                         // 5
};

enum EMood
{
    Mood_Dead,                      // 0
    Mood_Passive,                   // 1
    Mood_Combative,                 // 2
    Mood_Agitated,                  // 3
    Mood_Hunting,                   // 4
    Mood_MAX                        // 5
};

enum StumbleMagnitude
{
    SM_StumbleSmall,                // 0
    SM_StumbleMedium,               // 1
    SM_StumbleLarge,                // 2
    SM_MAX                          // 3
};

enum StumbleMagnitudeAndDir
{
    SMD_Stumble_Forward_Small,      // 0
    SMD_Stumble_Backward_Small,     // 1
    SMD_Stumble_Right_Small,        // 2
    SMD_Stumble_Left_Small,         // 3
    SMD_Stumble_Forward_Medium,     // 4
    SMD_Stumble_Backward_Medium,    // 5
    SMD_Stumble_Right_Medium,       // 6
    SMD_Stumble_Left_Medium,        // 7
    SMD_Stumble_Forward_Large,      // 8
    SMD_Stumble_Backward_Large,     // 9
    SMD_Stumble_Right_Large,        // 10
    SMD_Stumble_Left_Large,         // 11
    SMD_Stumble_MAX                 // 12
};

enum EWeaponEffect
{
    EWE_None,                       // 0
    EWE_AntiGravity,                // 1
    EWE_DisableRocketpack,          // 2
    EWE_CausesCoverDangle,          // 3
    EWE_Poison,                     // 4
    EWE_VisualEffect,               // 5
    EWE_Explosion,                  // 6
    EWE_Unused,                     // 7
    EWE_MAX                         // 8
};

enum EAnimBehaviorMode
{
    EBM_Default,                    // 0
    EBM_Combative,                  // 1
    EBM_Investigative,              // 2
    EBM_Cautious,                   // 3
    EBM_MAX                         // 4
};

enum ESecondaryItemState
{
    ESIS_None,                      // 0
    ESIS_TakingOut,                 // 1
    ESIS_Holding,                   // 2
    ESIS_Throwing,                  // 3
    ESIS_MAX                        // 4
};

struct native ContextualEffectType
{
    var() name Type;
    var() ParticleSystem Template;

    structdefaultproperties
    {
        Type="None"
        Template=none
    }
};

struct native ContextualEffect
{
    var() name Context;
    var() array<ContextualEffectType> Effects;

    structdefaultproperties
    {
        Context="None"
        Effects=none
    }
};

struct native BodyParts
{
    var() SkeletalMesh SkelMesh;
    var() PhysicsAsset PhysAsset;
    var() name Socket;
    var MaterialInterface MeshMaterial;
    var() array<MaterialInterface> MeshMaterials;
    var() float Chance;

    structdefaultproperties
    {
        SkelMesh=none
        PhysAsset=none
        Socket="None"
        MeshMaterial=none
        MeshMaterials=none
        Chance=1.0000000
    }
};

struct native HeadMorphs
{
    var() name MorphNodeName;
    var deprecated MaterialInterface MorphMaterial;
    var() array<MaterialInterface> MorphMaterials;
    var() float Chance;
    var() array<BodyParts> AdditionalPossibleHairMeshes;

    structdefaultproperties
    {
        MorphNodeName="None"
        MorphMaterials=none
        Chance=1.0000000
        AdditionalPossibleHairMeshes=none
    }
};

struct native SBoneNameType
{
    var() name BoneName;
    var() Pawn.EBoneType BoneType;
    var() float Radius;

    structdefaultproperties
    {
        BoneName="None"
        BoneType=BoneType_Undefined
        Radius=0.0000000
    }
};

struct native SBoneTypeArmorType
{
    var() Pawn.EBoneType BoneType;
    var() SkyPawn.EArmorType ArmorType;
    var int DummyVar;

    structdefaultproperties
    {
        BoneType=BoneType_Undefined
        ArmorType=ArmorType_Undefined
        DummyVar=0
    }
};

struct native SBoneDamageEffect
{
    var() name LocationSocket;
    var() SoundCue Sound;
    var() ParticleSystem EffectTemplate;
    var() float Probability;
    var() name PhysicsSocket;
    var() KActor PhysicsArchetype;
    var() float PhysicsProbability;
    var() Vector PhysicsVelocity;
    var() bool bMoveWithSocket;

    structdefaultproperties
    {
        LocationSocket="None"
        Sound=none
        EffectTemplate=none
        Probability=0.0000000
        PhysicsSocket="None"
        PhysicsArchetype=none
        PhysicsProbability=0.0000000
        PhysicsVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bMoveWithSocket=false
    }
};

struct native SArmorInfo
{
    var() SkyPawn.EArmorType ArmorType;
    var() float Health;
    var() SBoneDamageEffect DestructionEffect;
    var() name MorphNodeName;
    var MorphNodeWeight MorphNode;
    var() name DamageMorphNodeName;
    var MorphNodeWeight DamageMorphNode;
    var() name DestructionSkelCtrl;
    var bool bShouldPlayEffects;
    var float PreviousHealth;
    var() MaterialImpactEffect ImpactEffect;
    var() bool bInActive;
    var() array< class<DamageType> > DamageFilter;

    structdefaultproperties
    {
        ArmorType=ArmorType_Undefined
        Health=0.0000000
        DestructionEffect=(LocationSocket="None",Sound=none,EffectTemplate=none,Probability=0.0000000,PhysicsSocket="None",PhysicsArchetype=none,PhysicsProbability=0.0000000,PhysicsVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000),bMoveWithSocket=false)
        MorphNodeName="None"
        MorphNode=none
        DamageMorphNodeName="None"
        DamageMorphNode=none
        DestructionSkelCtrl="None"
        bShouldPlayEffects=false
        PreviousHealth=0.0000000
        ImpactEffect=(MaterialType="None",ParticleTemplate=none,PCParticleTemplate=none,ParticleDrawScale=1.0000000,Sound=none,DecalMaterial=none,DecalWidth=0.0000000,DecalHeight=0.0000000,DecalMinSize=10.0000000,DecalMaxSize=10.0000000,DecalRotation=0.0000000,DecalMinRotation=0.0000000,DecalMaxRotation=360.0000000,SubImageIndex=0,SubImages_Horizontal=1,SubImages_Vertical=1,SubImageMinIndex=0,SubImageMaxIndex=0,DecalLifeSpan=-1.0000000,FadeDistanceMin=0.0000000,FadeDistanceMax=0.0000000,bKillOnMaxDistance=false,bOnlyIfDead=false,bLocalToHitPawn=false,bLooping=false,bLoopingSound=false,PawnAttachBoneName="None")
        bInActive=false
        DamageFilter=none
    }
};

struct native SVisualEffectParams
{
    var() bool bOnlyOnDeath;
    var() float WaitTime;
    var() float Duration;
    var() ParticleSystem EffectTemplate;
    var() ParticleSystem PCEffectTemplate;
    var() array<name> EffectSockets;
    var() SoundCue Sound;
    var() protectedwrite array<protectedwrite string> AffectedArchetypes;
    var() name MatParamName;
    var deprecated int MatIndex;
    var() SkyPawn.EMatValueCurve MatValueCurve;
    var() bool bHoldUntilCancelled;
    var() bool bOnlyOnceOnDeath;

    structdefaultproperties
    {
        bOnlyOnDeath=false
        WaitTime=0.0000000
        Duration=0.0000000
        EffectTemplate=none
        PCEffectTemplate=none
        EffectSockets=none
        Sound=none
        AffectedArchetypes=none
        MatParamName="None"
        MatValueCurve=ZeroToOne
        bHoldUntilCancelled=false
        bOnlyOnceOnDeath=false
    }
};

struct native WeakPoint
{
    var() name Socket;
    var() float Radius;
    var() float Health;
    var deprecated SBoneDamageEffect DestructionEffect;
    var() name MorphNodeName;
    var MorphNodeWeight MorphNode;
    var() MaterialImpactEffect ImpactEffect;
    var() bool bInActive;
    var() InteractionAnimInfo AnimDatum;
    var() array<SVisualEffectParams> DeathEffects;

    structdefaultproperties
    {
        Socket="None"
        Radius=0.0000000
        Health=0.0000000
        MorphNodeName="None"
        MorphNode=none
        ImpactEffect=(MaterialType="None",ParticleTemplate=none,PCParticleTemplate=none,ParticleDrawScale=1.0000000,Sound=none,DecalMaterial=none,DecalWidth=0.0000000,DecalHeight=0.0000000,DecalMinSize=10.0000000,DecalMaxSize=10.0000000,DecalRotation=0.0000000,DecalMinRotation=0.0000000,DecalMaxRotation=360.0000000,SubImageIndex=0,SubImages_Horizontal=1,SubImages_Vertical=1,SubImageMinIndex=0,SubImageMaxIndex=0,DecalLifeSpan=-1.0000000,FadeDistanceMin=0.0000000,FadeDistanceMax=0.0000000,bKillOnMaxDistance=false,bOnlyIfDead=false,bLocalToHitPawn=false,bLooping=false,bLoopingSound=false,PawnAttachBoneName="None")
        bInActive=false
        AnimDatum=(AnimSeqName="None",AnimTreeTemplate=none,SnapToSocket="None",SnapToSocketBlendTime=0.0000000,bSetRootMotionMode=false,RootMotionMode=RMM_Ignore,RootMotionRotationMode=RMRM_Ignore,RootBoneOption=RBA_Default,RootBoneOption[1]=RBA_Default,RootBoneOption[2]=RBA_Default,RootRotationOption=RRO_Default,RootRotationOption[1]=RRO_Default,RootRotationOption[2]=RRO_Default,AnimBlendInTime=0.0000000,AnimBlendOutTime=0.2000000,PlaybackRate=1.0000000,bMirrorSequence=false,bLoop=false)
        DeathEffects=none
    }
};

struct native SBoneDamageArray
{
    var() array<SBoneDamageEffect> BoneEffects;

    structdefaultproperties
    {
        BoneEffects=none
    }
};

struct native SDamageShakeInfo
{
    var() class<DamageType> DamageType;
    var() editinline ViewShakeInfo ViewShake;
    var() editinline ForceFeedbackWaveform Rumble;

    structdefaultproperties
    {
        DamageType=none
        ViewShake=(OffsetMag=(X=0.0000000,Y=0.0000000,Z=0.0000000),OffsetRate=(X=0.0000000,Y=0.0000000,Z=0.0000000),OffsetTime=0.0000000,RotMag=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotRate=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotTime=0.0000000,minTime=0.0000000,StartTime=0.0000000)
        Rumble=none
    }
};

struct native JumpVehicleFindParams
{
    var() float MaxDist;
    var() float MinDist;
    var() float MaxTimeSinceLastRender;
    var() float InstigatorFOV;
    var() float TargetHorizontalFOV;
    var() float TargetVerticalFOV;

    structdefaultproperties
    {
        MaxDist=0.0000000
        MinDist=0.0000000
        MaxTimeSinceLastRender=0.0000000
        InstigatorFOV=0.0000000
        TargetHorizontalFOV=0.0000000
        TargetVerticalFOV=0.0000000
    }
};

struct native MeshMaterialInfo
{
    var() SkyPawn.EMeshType MeshType;
    var() int Index;
    var() MaterialInterface Material;

    structdefaultproperties
    {
        MeshType=MT_Body
        Index=0
        Material=none
    }
};

struct native FootstepImpact
{
    var() name Material;
    var() ParticleSystem Effect;
    var() ParticleSystem SprintEffect;
    var() MaterialInterface Decal;
    var() float DecalWidth;
    var() float DecalHeight;
    var() float DecalDepth;

    structdefaultproperties
    {
        Material="None"
        Effect=none
        SprintEffect=none
        Decal=none
        DecalWidth=0.0000000
        DecalHeight=0.0000000
        DecalDepth=20.0000000
    }
};

struct native DeathEffect
{
    var() float StartTime;
    var() ParticleSystem EffectTemplate;
    var() name EffectSocket;
    var() SoundCue Sound;
    var export editinline ParticleSystemComponent EffectRef;
    var() array< class<Weapon> > TriggerWeapon;
    var() array< class<Projectile> > TriggerProjectile;
    var() array< class<DamageType> > TriggerDmgType;

    structdefaultproperties
    {
        StartTime=0.0000000
        EffectTemplate=none
        EffectSocket="None"
        Sound=none
        EffectRef=none
        TriggerWeapon=none
        TriggerProjectile=none
        TriggerDmgType=none
    }
};

struct native AuxWeapon
{
    var() SkyWeapon Archetype;
    var() name Socket;
    var() int ExtraAmmo;
    var SkyWeapon Instance;
    var SkyWeaponAttachment Attachment;
    var InventoryManager InvManager;
    var() float PctChanceToDrop;

    structdefaultproperties
    {
        Archetype=none
        Socket="None"
        ExtraAmmo=0
        Instance=none
        Attachment=none
        InvManager=none
        PctChanceToDrop=0.0000000
    }
};

struct native DebugTracingEntry
{
    var name BoneName;
    var Vector LastLocation;
    var byte Red;
    var byte Green;
    var byte Blue;

    structdefaultproperties
    {
        BoneName="None"
        LastLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Red=0
        Green=0
        Blue=0
    }
};

struct native ReactionProfile
{
    var() editconst SkyPawn.EReactionCategory category;
    var float LastReactionTime;
    var float LastOccurTime;
    var float Parameter;
    var class<DamageType> DamageType;
    var() float MinDelay;
    var() float MinQuietPeriod;

    structdefaultproperties
    {
        category=ERC_NONE
        LastReactionTime=0.0000000
        LastOccurTime=0.0000000
        Parameter=0.0000000
        DamageType=none
        MinDelay=0.0000000
        MinQuietPeriod=0.0000000
    }
};

struct native SAutoAimPawnList
{
    var SkyPawn Target;
    var bool OldBoundingBlock;
    var bool OldMeshBlock;
    var float Dist;
    var float ReticleRadius;
    var Vector ReticleCenter;
    var bool bIsWeakPoint;
    var Vector WeakPointLoc;
    var float WeakPointRadius;

    structdefaultproperties
    {
        Target=none
        OldBoundingBlock=false
        OldMeshBlock=false
        Dist=0.0000000
        ReticleRadius=0.0000000
        ReticleCenter=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bIsWeakPoint=false
        WeakPointLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        WeakPointRadius=0.0000000
    }
};

struct native RandomDecal
{
    var() MaterialInterface DecalMaterial;
    var() float DecalMinSize;
    var() float DecalMaxSize;
    var() float DecalDepth;
    var() float DecalLifeSpanMin;
    var() float DecalLifeSpanMax;
    var() float DecalFadeTimeMin;
    var() float DecalFadeTimeMax;
    var() float DecalRotationMin;
    var() float DecalRotationMax;
    var() float Probability;

    structdefaultproperties
    {
        DecalMaterial=none
        DecalMinSize=100.0000000
        DecalMaxSize=100.0000000
        DecalDepth=20.0000000
        DecalLifeSpanMin=20.0000000
        DecalLifeSpanMax=20.0000000
        DecalFadeTimeMin=2.0000000
        DecalFadeTimeMax=2.0000000
        DecalRotationMin=0.0000000
        DecalRotationMax=0.0000000
        Probability=1.0000000
    }
};

struct native ReactionAnimDatum
{
    var() InteractionAnimInfo AnimDatum;
    var deprecated name AnimationName;
    var deprecated float BlendInTime;
    var deprecated float PlaybackRate;
    var deprecated float BlendOutTime;
    var() bool bCheckCanReach;
    var() float CheckYawAngleFromPawnFacing;
    var() float CheckDistAlongAngle;
    var() bool bCheckHasArmor;

    structdefaultproperties
    {
        AnimDatum=(AnimSeqName="None",AnimTreeTemplate=none,SnapToSocket="None",SnapToSocketBlendTime=0.0000000,bSetRootMotionMode=false,RootMotionMode=RMM_Ignore,RootMotionRotationMode=RMRM_Ignore,RootBoneOption=RBA_Default,RootBoneOption[1]=RBA_Default,RootBoneOption[2]=RBA_Default,RootRotationOption=RRO_Default,RootRotationOption[1]=RRO_Default,RootRotationOption[2]=RRO_Default,AnimBlendInTime=0.0000000,AnimBlendOutTime=0.2000000,PlaybackRate=1.0000000,bMirrorSequence=false,bLoop=false)
        bCheckCanReach=false
        CheckYawAngleFromPawnFacing=0.0000000
        CheckDistAlongAngle=0.0000000
        bCheckHasArmor=false
    }
};

struct native StumbleSet
{
    var() SkyPawn.StumbleMagnitudeAndDir StumbleType;
    var() array<ReactionAnimDatum> Reactions;
    var() class<Actor> DamageCauser;

    structdefaultproperties
    {
        StumbleType=SMD_Stumble_Forward_Small
        Reactions=none
        DamageCauser=Class'SkyWeapon'
    }
};

struct native StumbleData
{
    var() class<Actor> Stumble_DamageCauser;
    var() float Stumble_DamageAmount;
    var() float Stumble_Probability;
    var() SkyPawn.StumbleMagnitude Stumble_Magnitude;
    var() float Stumble_ProbabilityVertical;

    structdefaultproperties
    {
        Stumble_DamageCauser=Class'SkyWeapon'
        Stumble_DamageAmount=0.0000000
        Stumble_Probability=1.0000000
        Stumble_Magnitude=SM_StumbleSmall
        Stumble_ProbabilityVertical=0.5000000
    }
};

struct native StumbleArmorData
{
    var() SkyPawn.EArmorType Stumble_ArmorType;
    var() float Stumble_Probability;
    var() SkyPawn.StumbleMagnitude Stumble_Magnitude;

    structdefaultproperties
    {
        Stumble_ArmorType=ArmorType_Undefined
        Stumble_Probability=1.0000000
        Stumble_Magnitude=SM_StumbleSmall
    }
};

struct native SWeaponEffect
{
    var SkyPawn.EWeaponEffect Effect;
    var Actor Instigator;

    structdefaultproperties
    {
        Effect=EWE_None
        Instigator=none
    }
};

struct native SAntiGravEffects
{
    var MaterialInstanceConstant MatInstConst;
    var Material Material;
    var int MaterialIndex;
    var name MaterialParamName;

    structdefaultproperties
    {
        MatInstConst=none
        Material=none
        MaterialIndex=0
        MaterialParamName="None"
    }
};

struct native SPoisonData
{
    var float TotalDuration;
    var float DamageInterval;
    var int DamageAmount;
    var Controller Instigator;
    var Actor WeaponArch;

    structdefaultproperties
    {
        TotalDuration=0.0000000
        DamageInterval=0.0000000
        DamageAmount=0
        Instigator=none
        WeaponArch=none
    }
};

struct native SVisualEffectData
{
    var bool bNeedsInit;
    var float InitTime;
    var float WaitTime;
    var float Duration;
    var ParticleSystem EffectTemplate;
    var init array<init name> EffectSockets;
    var SoundCue Sound;
    var init export editinline array<init export editinline ParticleSystemComponent> EffectRefs;
    var name MatParamName;
    var SkyPawn.EMatValueCurve MatValueCurve;
    var bool bHoldUntilCancelled;
    var Actor EffectCauser;

    structdefaultproperties
    {
        bNeedsInit=false
        InitTime=0.0000000
        WaitTime=0.0000000
        Duration=0.0000000
        EffectTemplate=none
        EffectSockets=none
        Sound=none
        EffectRefs=none
        MatParamName="None"
        MatValueCurve=ZeroToOne
        bHoldUntilCancelled=false
        EffectCauser=none
    }
};

struct native AnimNotifySoundEntry
{
    var AnimNodeSequence Node;
    var export editinline AudioComponent AudioComp;

    structdefaultproperties
    {
        Node=none
        AudioComp=none
    }
};

struct native DeathSpawn
{
    var() class<DamageType> DamageType;
    var() float PctChance;
    var() name Socket;
    var() SkyPawn PawnArchetype;
    var() AIController ControllerArchetype;
    var() name GroundExitReaction;
    var() name AirExitReaction;
    var() float GroundSpawnDelay;
    var() float AirSpawnDelay;
    var() class<SequenceEvent> Event;
    var() name DeathReactionOverride;
    var() bool bNoSpawnInVerticalCover;
    var() int InterruptDeathSpawnDamageAmount;

    structdefaultproperties
    {
        DamageType=none
        PctChance=0.0000000
        Socket="None"
        PawnArchetype=none
        ControllerArchetype=none
        GroundExitReaction="None"
        AirExitReaction="None"
        GroundSpawnDelay=0.0000000
        AirSpawnDelay=0.0000000
        Event=none
        DeathReactionOverride="None"
        bNoSpawnInVerticalCover=false
        InterruptDeathSpawnDamageAmount=300
    }
};

struct native SSecondaryItemTimingInfo
{
    var() float TakingOutTime;
    var() float ThrowingTime;
    var() float AttachTime;
    var() float ReleaseTime;
    var() name ThrowingSocket;

    structdefaultproperties
    {
        TakingOutTime=0.0000000
        ThrowingTime=0.0000000
        AttachTime=0.0000000
        ReleaseTime=0.0000000
        ThrowingSocket="None"
    }
};

struct native SPrevCollision
{
    var Pawn Driver;
    var bool bOldCollideActors;

    structdefaultproperties
    {
        Driver=none
        bOldCollideActors=false
    }
};

var(Effects) array<ContextualEffect> ContextualEffects;
var transient SoundCue CachedKilledEnemyVO;
var transient float LastVOTime;
var(Debug) bool bCacheInstantHitTrace;
var deprecated bool bUseWeaponMultiTrace;
var transient bool bLostLastHijackInteraction;
var() bool IKEnabled;
var transient bool NotifyRocketPacking;
var deprecated bool bStartsWithRocketPack;
var bool bKismetDisabledRPPrimaryFire;
var bool bKismetDisabledRPSecondaryFire;
var bool bStartInRocketpackThrust;
var bool bWasInFreeFall;
var bool bHadPrimaryDrawn;
var bool bDoAirbornFiringPhysics;
var(Inventory) bool bHasInfiniteExtraAmmo;
var(Movement) bool bUseDefaultPhysics;
var transient bool bPickupState_Swap;
var transient bool bPickupState_Primary;
var transient bool bPickupState_Ammo;
var transient bool bPickupState_NonWeapon;
var(Armor) bool bCanDestroyAllArmorAtOnce;
var(WeakPoints) bool bNoWeakPointDeath;
var transient bool bIgnoreNotifies;
var transient bool SprintDisable;
var transient bool bAutomoveTranslateSnapToSocket;
var transient bool bAutomoveAlignVerticallyWithTarget;
var transient bool bAutomoveTranslateToTarget;
var transient bool bAutomove_TranslateAssumeTargetLocation;
var transient bool bAutomove_TranslateAssumeTargetXYOnly;
var transient bool bAutomoveRotateToTarget;
var transient bool bAutomove_RotateAssumeTargetRotation;
var transient bool bAutomove_RotateInverse;
var() bool bPawnFaceVelocityDir;
var(Health) bool bHealthAutoRegen;
var(Health) bool bHealthAutoRegenRocketpack;
var transient bool bDodgeInteruptible;
var transient bool bDodgeTriggerInterupt;
var transient bool bIsSecondaryAiming;
var transient bool bIsRocketPacking;
var transient bool bIsThrusting;
var transient bool bIsParachuting;
var transient bool bWasFallingLastFrame;
var transient bool bWasFreeFallingLastFrame;
var transient bool bIsFreefalling;
var(PlayerMovement) bool bUseConstantRotateVelocity;
var transient bool bFaceRotationRequest;
var transient bool bNoSpeedBlendUpdate;
var transient bool bDirectionalBlendLock;
var transient bool bHijackFinalApproach;
var transient bool bExitingHijackDangerZone;
var transient bool bHijackBoostActive;
var transient bool bHijackingFromVehicle;
var transient bool bHijackClearInput;
var transient bool OverrideVehicleEnter;
var transient bool bCanPlayImpactSound;
var transient bool bPlayedOneshotImpact;
var bool CanBreathe;
var transient bool bGoingIntervehicular;
var transient bool bIntervehicularFinalApproach;
var transient bool bJumpVehicleTriggerPulled;
var bool bRecoveringFromRagdoll;
var bool bNoRecoverFromRagdoll;
var() bool bPlayPhysicsBasedTakeHitAnimations;
var(Death) bool bPlayDeathAnim;
var(Death) bool bPlayDeathRagdoll;
var(Death) bool bBlockActorsOnDeath;
var(Death) bool bBlowApartOnDeath;
var transient bool bForceAccelRate;
var transient bool bControlledVelocity;
var protected transient bool bAllLocalEffectsArePassive;
var(Player) bool bCanUseBikes;
var transient bool bRootMotionOverriden;
var(Inventory) bool bAllowTwoWeapons;
var(Weapon) bool Pickup_DropOnlyOneAuxWeapon;
var transient bool LastLevelCollisionLeftSide;
var transient bool bMedusa;
var deprecated bool bEnableDeathFading;
var bool bHasCachedAimVector;
var transient bool bUseRotationalVelocityYaw;
var deprecated bool bAdeptMindControlAllowed;
var deprecated bool bAdeptMindControlInProgress;
var deprecated bool bAdeptMindControlKillVictim;
var repnotify transient bool bGliding;
var transient bool bPlayGripHitReaction;
var transient bool ActionButtonPressedLastFrame;
var() bool bUseDebugReticle;
var() bool bAutoAimValidTarget;
var bool bCylinderNeedsToGrow;
var(Grip) bool bGripDangleEnabled;
var transient bool bGripDangleIsActive;
var transient bool bGripDangleHasThrashed;
var transient bool bWasShooting;
var transient bool bUsingRotEpsilon;
var transient bool bWasMelee;
var(BulletExitEffects) bool bPlayExitWoundEffects;
var(BulletExitEffects) bool bPlayExitWoundGroundEffects;
var(BleedOutEffects) bool bShouldBleedOutOnDeath;
var bool AnimDatumUpdatedFlag;
var transient bool bIsHindered;
var transient bool bSteppedInShallowWater;
var transient bool bSteppedInDeepWater;
var transient bool CachedGroundMaterialTypeUndefined;
var bool bSecondaryItemShouldThrow;
var bool bSecondaryItemReleased;
var transient bool bWaitingOnJumpLaunch;
var transient bool bSprintingMode2;
var transient bool bAlreadyProcessedArmor;
var transient SkyPrimaryWSM PrimaryWSM;
var transient SkySecondaryWSM SecondaryWSM;
var(WeaponStateMachine) SkyPrimaryWSM PrimaryWSMArchetype;
var(WeaponStateMachine) SkySecondaryWSM SecondaryWSMArchetype;
var(GettingShotAt) float SecondaryAimOffsetRadius;
var float JumpVehicleTargetUpdateTimer;
var(Mesh) export editinline SkeletalMeshComponent LegMesh;
var(Mesh) export editinline SkeletalMeshComponent HeadMesh;
var(Mesh) export editinline SkyKSkeletalMeshComponent HairMesh;
var name HeadMorphName;
var int HeadMorphIndex;
var(Mesh) SkeletalMesh HeadSkelMesh;
var export editinline AudioComponent FacialAudioComp;
var transient Scene.ESceneDepthPriorityGroup SavedMeshDPG;
var transient Scene.ESceneDepthPriorityGroup SavedHeadMeshDPG;
var transient Scene.ESceneDepthPriorityGroup SavedHairMeshDPG;
var transient Scene.ESceneDepthPriorityGroup SavedWeaponMeshDPG;
var transient Scene.ESceneDepthPriorityGroup SavedMuzzleFlashDPG;
var transient Scene.ESceneDepthPriorityGroup SavedRocketPackMeshDPG;
var repnotify transient SkyPawn.EBlendByParachutingState ParachuteState;
var transient SkyPawn.EBlendByRocketPackingState RocketPackState;
var transient SkyPawn.EPickupState PickupState;
var transient SkyPawn.ESprintState SprintState;
var transient SkyPawn.EFallState FallState;
var transient SkyPawn.EDodgeState DodgeState;
var transient SkyPawn.E180State X180State;
var byte SecondaryFlashCount;
var byte SecondaryFiringMode;
var SkyPawnBase.ESkyWeaponHand SecondaryWeaponHand;
var deprecated SkyPawn.EAdeptAttackReaction AdeptAttackReaction;
var deprecated byte AdeptMindControlPrevTeamIdx;
var SkyPawn.EAnimDrivingState AnimDrivingState;
var transient SkyPawn.EMood TargetMood;
var transient SkyPawn.EAnimBehaviorMode CurrentPawnBehaviorMode;
var SkyPawn.ESecondaryItemState SecondaryItemState;
var(Mesh) array<BodyParts> PossibleHairMeshes;
var(Mesh) array<BodyParts> PossibleBodyMeshes;
var(Mesh) array<BodyParts> PossibleLegsMeshes;
var(Mesh) array<HeadMorphs> PossibleHeadMorphs;
var(HitBounding) array<name> HitBoundingBones;
var export editinline CylinderComponent HitBoundingComponent;
var(Inventory) SkyItem_RocketPack RocketPackArchetype;
var SkyAirVehicle_RocketPackThrust RocketPackThrustVehicle;
var float ThrustJumpDelay;
var deprecated SkyLocalEffect FreefallingLocalEffect;
var(Effects) editinline SkyLocalEffectSettings FreefallingLocalEffectSettings;
var protected export editinline transient SkyLocalEffectComponent FreefallingLocalEffectComponent;
var export editinline transient SkyLocalEffectComponent VehicleStandardMovementLocalEffectComponent;
var export editinline transient SkyLocalEffectComponent VehicleBoostLocalEffectComponent;
var export editinline deprecated transient SkyLocalEffectComponent VehicleThrottleLocalEffectComponent;
var export editinline transient SkyLocalEffectComponent VehicleBrakeLocalEffectComponent;
var deprecated SkyLocalEffect RocketpackLocalEffectThrust;
var(RocketPack) editinline SkyLocalEffectSettings RocketpackLocalEffectThrustSettings;
var protected export editinline transient SkyLocalEffectComponent RocketpackLocalEffectThrustComponent;
var deprecated SkyLocalEffect RocketpackLocalEffectTurbo;
var(RocketPack) editinline SkyLocalEffectSettings RocketpackLocalEffectTurboSettings;
var protected export editinline transient SkyLocalEffectComponent RocketpackLocalEffectTurboComponent;
var deprecated SkyLocalEffect RocketpackLocalEffectTurboCritical;
var(RocketPack) editinline SkyLocalEffectSettings RocketpackLocalEffectTurboCriticalSetttings;
var protected export editinline transient SkyLocalEffectComponent RocketpackLocalEffectTurboCriticalComponent;
var(RocketPack) notforconsole export editinline ApexTurbulenceComponent TurbulenceInstance;
var(RocketPack) SkyBotControllerPilot RocketPackThrustControllerArchetype;
var transient SkyBotControllerPilot StoredRocketPackThrustController;
var(Movement) float Backwards_GroundSpeed;
var(Movement) float Backwards_SpeedModifierAngle;
var(Movement) float Sideways_GroundSpeed;
var(Movement) float Sideways_SpeedModifierAngle;
var(Weapon) float Pickup_MinDistance;
var(Weapon) Vector Pickup_DropVelocity;
var(Weapon) Vector Pickup_AngularVelocity;
var(Weapon) float Pickup_DropProbability;
var(Weapon) float Pickup_SecondaryDropProbability;
var(Weapon) float WeaponScale;
var(Weapon) array<SBoneNameType> SpecialBoneTypes;
var(Armor) array<SArmorInfo> ArmorInfo;
var(Armor) array<SBoneTypeArmorType> BoneTypeToArmorType;
var(Armor) float DamageThresholdToIgnoreArmor;
var(Armor) float DamageToDestroyAllArmor;
var(Sounds) SoundCue AllArmorDestroyedSound;
var(Sounds) SoundCue AmmoCachePickupSound;
var transient Vector LastHitsMomentum;
var transient class<DamageType> LastDamageType;
var(WeakPoints) array<WeakPoint> WeakPoints;
var deprecated array< class<DamageType> > DamageFilter;
var SkelControlSingleBone HeadControl;
var name HeadControlName;
var transient ParticleSystem CachedHeadExplodeParticleSystem;
var transient name CachedHeadExplodeSocket;
var(Effects) array<SBoneDamageArray> BoneDamageEffects;
var Vector LastSafeLocation;
var(Sprint) float SprintHoldTime;
var(Sprint) float SprintSpeed;
var(Sprint) float SprintAccelRate;
var(Sprint) float SprintTurnRate;
var(Sprint) float StopSprintDelay;
var(Sprint) float SprintTime;
var(Sprint) float SprintTimeRegenRate;
var(PlayerMovement) array<float> SpeedByTargetMode;
var transient float SprintFatigue;
var(Sprint) float SprintFatigueMax;
var(Sprint) float SprintReactionMinVelocity;
var(Sprint) float SprintReactionMaxAngle;
var(Sprint) float SprintReactionMiddleAngle;
var(Sprint) float SprintReactionPerpAngle;
var transient Actor AutomoveTarget;
var transient name AutomoveTranslateSocket;
var transient name AutomoveRotateSocket;
var transient float Automove_TranslateStopDistFromTarget;
var transient float Automove_TranslateTime;
var transient float Automove_RotateTolerance;
var transient float Automove_RotateTime;
var(Health) float HealthAutoRegenRate;
var(Health) float HealthAutoRegenRateRocketpack;
var(Health) int HealthAutoRegenMax;
var(Health) const float HealthDelayBeforeAutoRegen;
var(Health) const float HealthDelayBeforeAutoRegenRocketpack;
var(Health) int HealthMin;
var transient float HealthLastDamageTaken;
var transient float HealthRegenTick;
var(Eyes) Vector EyeOffset;
var transient Vector chargeTakeOffPos;
var(PlayerMovement) float JumpSpeed;
var(PlayerMovement) float JumpAccelRate;
var deprecated float FallSpeed;
var float MeleeSpeed;
var(FallingMovement) float TerminalVelocity;
var(FallingMovement) float TerminalVelocityDive;
var(FallingMovement) float TerminalVelocityBrake;
var(FallingMovement) float TerminalVelocityParachute;
var(FallingMovement) float TerminalVelocityDeceleration;
var(Freefall) float FreefallViewPitchMin;
var(Freefall) float FreefallViewPitchMax;
var(Freefall) float FreefallSpeed;
var(Freefall) float FreefallAccelRate;
var(Freefall) float FreefallHeight;
var(Freefall) float FreefallTime;
var transient float FreefallTimer;
var transient float CurrentTerminalVelocity;
var transient float TargetTerminalVelocity;
var deprecated SkyItem_Parachute Parachute;
var repnotify SkyItem_RocketPack RocketPack;
var transient SkyItem_RocketPack OldRocketPack;
var(PlayerMovement) float FaceRotationTime;
var(PlayerMovement) float FaceRotationTimeShooting;
var(PlayerMovement) float FaceRotationTimeMelee;
var(PlayerMovement) float FaceRotationTimeJump;
var(PlayerMovement) float FaceRotationTimeFreefall;
var(PlayerMovement) float FaceRotationTimeIntervehics;
var(PlayerMovement) float FaceRotationTimeIntervehicsFinalRot;
var(PlayerMovement) float FaceRotationConstantVelocity;
var(Hijack) float HijackApproachSpeed;
var(Hijack) float HijackAccelRate;
var(Hijack) float HijackBoostDuration;
var(Hijack) int HijackFailureDamage;
var(Hijack) class<SkyDamageType> HijackFailureDamageType;
var(Hijack) float HijackWindEffectTarget;
var deprecated SkyLocalEffect HijackLocalEffect;
var(Hijack) editinline SkyLocalEffectSettings HijackLocalEffectSettings;
var protected export editinline transient SkyLocalEffectComponent HijackLocalEffectComponent;
var transient float HijackDeltaYaw;
var transient float HijackDeltaPitch;
var transient SkyAirVehicle HijackTarget;
var transient SkyPawn HijackOpponent;
var transient class<SkyAirVehicle> HijackPrevVehicleClass;
var transient string HijackKeyString;
var transient SkyPawn Hijacker;
var repnotify Weapon SecondaryWeapon;
var deprecated class<SkyWeaponAttachment> CurrSecondaryWeaponAttachmentClass;
var repnotify SkyWeapon CurrSecondaryWeaponArchetype;
var SkyWeaponAttachment CurrSecondaryWeaponAttachment;
var() name SecondaryWeaponBone;
var Vector SecondaryFlashLocation;
var int SecondaryShotCount;
var() name TwoHandedWeaponBone;
var transient int LastRotationYaw;
var transient int YawRotationSpeed;
var() float SprintDiveFallVelMax;
var() float JumpZSprintDive;
var float AimMaxDegreesRight;
var float AimMaxDegreesLeft;
var float AimMaxDegreesUp;
var float AimMaxDegreesDown;
var(Collision) name CollisionAnchorBone;
var int CollisionAnchorBoneIndex;
var deprecated Surface HijackHudIcon;
var deprecated Surface HijackFromVehicleIcon;
var deprecated Surface AdeptLeapHudIcon;
var(Sounds) export editinline AudioComponent FallingWindSound;
var(Sounds) export editinline AudioComponent ParachuteWindSound;
var export editinline AudioComponent SprintingSound;
var export editinline AudioComponent BreathingSound;
var int LastFootDown;
var int HandSwapRefCount;
var(CoverRumble) editinline ForceFeedbackWaveform EnterCoverFFeedback;
var editinline deprecated ViewShakeInfo HitByGunViewShake;
var editinline deprecated ViewShakeInfo HitByExplosionViewShake;
var deprecated array< class<DamageType> > BulletDamageTypesViewShake;
var deprecated array< class<DamageType> > ExplosionDamageTypesViewShake;
var(DamageShake) array<SDamageShakeInfo> DamageShake;
var(Hijack) JumpVehicleFindParams JumpVehicleWalkingFindParams;
var(Hijack) JumpVehicleFindParams JumpVehicleFlyingFindParams;
var(Hijack) JumpVehicleFindParams JumpVehicleThrustFindParams;
var transient Vehicle JumpVehicleTarget;
var transient Vehicle JumpVehicleTargetCurrent;
var transient Vehicle ExitingVehicle;
var transient float SlomoAnimNotifyResetSpeed;
var SkyWeapon PreviousSecondary;
var float RagdollBlendPercent;
var float RagdollToAnimBlendTime;
var(Death) name DeathReaction;
var transient name DeathReactionOverride;
var(Death) float BlowApartMinImpulse;
var(Death) float BlowApartMaxImpulse;
var(Death) ParticleSystem BlowApartEffectTemplate;
var(Death) array<MeshMaterialInfo> DeathMaterials;
var transient Vector ControlledVelocity;
var(JumpAbility) float MaxFallSpeedDeath;
var(JumpAbility) float FallingDamage;
var Vector CameraCollisionOffset;
var(Effects) array<name> FootstepSockets;
var(Effects) array<FootstepImpact> FootstepImpacts;
var(Effects) array<FootstepImpact> ShallowWaterFootstepImpacts;
var(Effects) array<FootstepImpact> DeepWaterFootstepImpacts;
var deprecated array<DeathEffect> DeathEffects;
var protected export editinline transient array<export editinline SkyLocalEffectComponent> SkyLocalEffectComponents;
var protected transient PostProcessSettings CombinedLocalEffectPostProcessSettings;
var protected transient PostProcessSettingsPart2 CombinedLocalEffectPostProcessSettingsPart2;
var float FootPlacementVelocityMax;
var transient Actor AutoTarget;
var const Texture2D TexObjectiveArrow;
var(Inventory) array<Inventory> DefaultInventory;
var transient Actor PowercellTarget;
var() float LeftAirplaneJackGravityDelay;
var() float LeftAirplaneFixGravityDelay;
var() float LeftAirplaneJackGravityScale;
var float TurningAngle;
var float TurningAngleCosine;
var repnotify transient Vector NetViewRot;
var repnotify transient Vector NetViewLoc;
var repnotify transient Vector2D NetStick;
var(TargetPill) float m_fMagnetismPillDiameter;
var(TargetPill) float m_fMagnetismPillHeight;
var(TargetPill) float m_fMagnetismPillZOffset;
var protected transient int m_DisableMagnetismRefCount;
var(Vertical) float ShootableAngleVertUpRight;
var(Vertical) float ShootableAngleVertUpLeft;
var(Vertical) float ShootableAngleVertDownRight;
var(Vertical) float ShootableAngleVertDownLeft;
var SkyWeaponAttachment CurrWeaponAttachment;
var repnotify SkyWeapon CurrWeaponArchetype;
var Weapon BackWeapon;
var Weapon PrevWeapon;
var(Weapon) array<AuxWeapon> AuxWeapons;
var transient array<DebugTracingEntry> DebugTracingEntries;
var float OvershieldRegenRate;
var float OvershieldPercent;
var transient float LastLevelCollisionDotProduct;
var transient array<AnimNodeSlot> SlotNodes;
var transient MaterialInstanceConstant ActiveMaterialInstanceConstant;
var deprecated int RagDollFadeMaterialIndex;
var deprecated int HeadFadeMaterialIndex;
var deprecated int LegFadeMaterialIndex;
var deprecated int HairFadeMaterialIndex;
var deprecated int RocketpackFadeMaterialIndex;
var deprecated float RagDollWaitToFadeTime;
var deprecated float RagDollFadeDuration;
var deprecated array< class<Weapon> > RagDollFadeTriggerWeapon;
var deprecated array< class<Projectile> > RagDollFadeTriggerProjectile;
var deprecated array< class<DamageType> > RagDollFadeTriggerDmgType;
var float Wind;
var float WindTarget;
var float Wind_EffectTarget;
var float Wind_InterpolationDuration;
var float Wind_TargetInterpolationDuration;
var float Wind_TimeRemaining;
var Vector CachedAimVector;
var name LandedFailsafeTimerName;
var float LandedFailsafeTimerDuration;
var(Reaction) array<ReactionProfile> ReactionProfiles;
var const name ManualTransition_PWSM_FailSafeTimerName;
var const name ManualTransition_SWSM_FailSafeTimerName;
var transient float RotationalVelocityYaw;
var transient float LastShortestRouteYaw;
var deprecated float AdeptMindControlTimeLeft;
var deprecated int AdeptMindControlDamage;
var deprecated Pawn AdeptMindControlInstigator;
var deprecated class<DamageType> AdeptMindControlDamageType;
var deprecated int AdeptMindControlExtraHealth;
var deprecated float AdeptMindControlDamageRadius;
var(FireTickets) int NumFireTickets;
var array<Controller> FireTickets;
var private transient SkyGripPoint GripPoint;
var export editinline SkeletalMeshComponent GripUprightSkelMeshComp;
var export editinline SkeletalMeshComponent GripHangingSkelMeshComp;
var private native transient float GripPhysicsWeight;
var native transient float GripHangingWeight;
var private transient array<float> GripLimbIKWeights;
var private native transient Matrix RightHandMatrixInitial;
var private native transient Matrix LeftHandMatrixInitial;
var transient AnimTree ThrownFromGripPointAnimTree;
var transient float ThrownFromGripPointDuration;
var transient AnimTree ReleasedGripPointAnimTree;
var transient float ReleasedGripPointDuration;
var transient AnimTree ShotFromGripPointAnimTree;
var transient float ShotFromGripPointDuration;
var(Grip) ForceFeedbackWaveform GripPointActionRumbleDefaults;
var(Grip) float GripHitReactionDuration;
var transient name GripHitReactionTimer;
var transient array<SkyAnimPhysicsBranch> PhysicsBranches;
var ImpactInfo AutoAimImpact;
var() float AutoAimMaxRange;
var() float AutoAimHitDist;
var transient float AutoAimTargetChangedTime;
var deprecated float AutoAimNumTraces;
var deprecated int AutoAimNumTraceCycles;
var deprecated array<int> AutoAimTraceCycleLookUp;
var protected transient SkyAnimNodePlayCustomAnim ScriptedAnimNode;
var() int PersonalityIndex;
var float NewCylinderRadius;
var float NewCylinderHeight;
var float NewCylinderCheckTime;
var float NewCylinderCheckTimer;
var() float BoundingCylinderHeightFudgeFactor;
var() float BoundingCylinderRadiusFudgeFactor;
var(Camera) float FadeToBlackDeathDelayTime;
var(Camera) float FadeToBlackTime;
var transient GripDangleInfo GripDangleSetup;
var transient float GripDangleMeter;
var transient float GripDangleDecayRate;
var const float GripDangleMinTimer;
var const float GripDangleEmptyMeter;
var const float GripDangleFullMeter;
var(Grip) float DangleRecoverDelay;
var transient string DangleActionString;
var transient float DangleRecoverCounter;
var transient int CalcPawnRotationState;
var transient int StandShootRotTolerance;
var transient int StandShootRotEpsilon;
var transient int StandCombatLookRightLimit;
var transient int StandCombatLookLeftLimit;
var transient int StandCombatRotEpsilonLeft;
var transient int StandCombatRotEpsilonRight;
var transient int RunShootRotToleranceRight;
var transient int RunShootRotToleranceLeft;
var transient int StandShootRotToleranceCurrent;
var int MoveNoShootRotTolerance;
var int MoveNoMeleeRotTolerance;
var(BulletExitEffects) float ExitWoundMaxDistance;
var(BulletExitEffects) float ExitWoundAngleVariance;
var(BulletExitEffects) array<RandomDecal> ExitWoundVariations;
var(BulletExitEffects) float ExitWoundGroundMaxDistance;
var(BulletExitEffects) array<RandomDecal> ExitWoundGroundVariations;
var transient int DeathExitWoundEffectsCount;
var(BulletExitEffects) int MaxDeathExitWouldEffects;
var(BleedOutEffects) MaterialInterface BleedOutDecalMaterial;
var(BleedOutEffects) float BleedOutDecalMinSize;
var(BleedOutEffects) float BleedOutDecalMaxSize;
var(BleedOutEffects) float BleedOutDecalDepth;
var(BleedOutEffects) float BleedOutDecalStartDelay;
var(BleedOutEffects) float BleedOutDecalLifeSpanMin;
var(BleedOutEffects) float BleedOutDecalLifeSpanMax;
var(BleedOutEffects) float BleedOutDecalFadeTimeMin;
var(BleedOutEffects) float BleedOutDecalFadeTimeMax;
var(BleedOutEffects) name BleedOutDecalBoneToSpawnFrom;
var(BleedOutEffects) array< class<Weapon> > BleedOutTriggerWeapon;
var(BleedOutEffects) array< class<Projectile> > BleedOutTriggerProjectile;
var Vector LevelMoveThisTick;
var Rotator LevelRotThisTick;
var(Debug) Vector AnimDebugDisplayPos;
var(Debug) Vector TransitionDebugDisplayPos;
var(Effects) editfixedsize array<float> MoodInterpolationTimes;
var transient float CurrentMood;
var(HitReactions) protected array<StumbleData> TriggerStumbleConditions;
var(HitReactions) protected array<StumbleArmorData> TriggerArmorStumbleConditions;
var(HitReactions) protected array<StumbleSet> Stumbles;
var(HitReactions) protected float MaximumDelayBetweenDamage;
var transient float StumbleAccumulatedDamage;
var transient float StumbleResetDamageTimer;
var transient float HinderedSpeed;
var transient float HinderedAudioSlowmo;
var transient name CachedGroundMaterialType;
var transient array<SWeaponEffect> CurrWeaponEffects;
var() array<SkyPawn.EWeaponEffect> WeaponEffectImmunities;
var deprecated SAntiGravEffects AntiGravEffects;
var transient SPoisonData PoisonData;
var init transient array<init SVisualEffectData> VisualEffectList;
var init transient array<init MaterialInstanceConstant> MatInstConsts;
var(Pilot) SkyArchonPilot PilotArchetype;
var(Pilot) name PilotSocket;
var SkyArchonPilot Pilot;
var array<AnimNotifySoundEntry> SoundAnimNotifies;
var(Sounds) name PawnSoundContext;
var deprecated float MovingLevelTimeForDettach;
var float MovingLevelDetachTimeout;
var float KismetOverride_MaxDesiredSpeed;
var SkySeqAct_AIFactoryNew KismetAIFactory;
var transient float SocketBlendTotalTime;
var transient float SocketBlendCurrentTime;
var transient Vector SocketBlendOldLocation;
var transient Rotator SocketBlendOldRotation;
var transient name SocketBlendName;
var(DeathSpawn) editinline array<editinline DeathSpawn> DeathSpawnTypes;
var transient int DeathSpawnIndex;
var transient Pawn DeathOffspring;
var(SecondaryItem) SSecondaryItemTimingInfo SecondaryItemTimingInfo;
var SSecondaryItemTimingInfo CurrSecondaryItemInfo;
var(Death) array<SVisualEffectParams> InstantDeathEffects;
var transient Vector PreviousLocation;
var transient Vector CurrentLocation;
var(Effects) array<SVisualEffectParams> ForceFieldVisualEffects;
var(Effects) notforconsole const export editinline ApexTurbulenceGridComponent TurbulenceDeathGridInstance;
var(Effects) name TurbulenceDeathGridSocket;
var(Effects) notforconsole const export editinline ApexTurbulenceEmitterComponent TurbulenceDeathEmitterArchetype;
var(Effects) array<name> TurbulenceDeathEmitterSockets;
var transient Vector DesiredJumpVelocity;
var() float SprintSmoothPct;
var() float SprintStickConeAngle;
var() float SprintStickConeOffset;
var() float SprintCancelStickConeAngle;
var() float SprintCancelStickConeOffset;
var transient SkyInteraction_WeaponLocker WeaponLocker;
var transient int ForceTargetingRefCount;
var transient float TimeDied;
var transient array<Inventory> DesiredInvList;
var(Ragdoll) float XPackRagdollLifeSpan;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        CurrSecondaryWeaponArchetype, CurrWeaponArchetype, 
        DodgeState, ExitingVehicle, 
        Parachute, PickupState, 
        RocketPack, SecondaryWeapon, 
        bDodgeTriggerInterupt, bGliding;

    // Pos:0x00D
    if((int(Role) == int(ROLE_Authority)) && !bNetOwner
        FallState, HijackOpponent, 
        Hijacker, LastLevelCollisionDotProduct, 
        LastLevelCollisionLeftSide, NetStick, 
        NetViewLoc, NetViewRot, 
        ParachuteState, RocketPackState, 
        SprintState, YawRotationSpeed;

    // Pos:0x027
    if(bNetOwner
        AutoAimImpact;
}

// Export USkyPawn::execBlendAttachToPawnAndSocket(FFrame&, void* const)
native function bool BlendAttachToPawnAndSocket(Pawn NewParent, name SocketName, float Time);

// Export USkyPawn::execGetTargetLocation(FFrame&, void* const)
native simulated function Vector GetTargetLocation(Actor RequestedBy, optional bool bRequestAlternateLoc);

// Export USkyPawn::execPlayCustomAnim(FFrame&, void* const)
native final function bool PlayCustomAnim(out InteractionAnimInfo AnimDatum, optional bool bOverride);

// Export USkyPawn::execStopCustomAnim(FFrame&, void* const)
native final function StopCustomAnim(optional float BlendOutTime);

// Export USkyPawn::execIsPlayingCustomAnim(FFrame&, void* const)
native final function bool IsPlayingCustomAnim();

// Export USkyPawn::execGetGrippee(FFrame&, void* const)
native final function SkyGrippableActor GetGrippee();

// Export USkyPawn::execTryAnInteraction(FFrame&, void* const)
native final function bool TryAnInteraction();

// Export USkyPawn::execTrySpecificInteractionType(FFrame&, void* const)
native final function bool TrySpecificInteractionType(class<SkyInteraction> InteractionType);

function SetMood(SkyPawn.EMood NewMood, optional float InterpolationTime = 0.0000000)
{
    TargetMood = NewMood;
    //return;    
}

// Export USkyPawn::execVerifyCanPerform(FFrame&, void* const)
native final function bool VerifyCanPerform(ReactionAnimDatum RAD);

final function EnableMagnetism(bool bEnable)
{
    // End:0x1E
    if(bEnable)
    {
        // End:0x1B
        if(m_DisableMagnetismRefCount > 0)
        {
            --m_DisableMagnetismRefCount;
        }        
    }
    else
    {
        ++m_DisableMagnetismRefCount;
    }
    //return;    
}

final function SetNumberOfFireTickets(int inNum)
{
    NumFireTickets = inNum;
    FireTickets.Length = NumFireTickets;
    //return;    
}

function OnSetNumFireTickets(SkySeqAct_SetNumFireTickets inAction)
{
    SetNumberOfFireTickets(inAction.NewFireTicketCount);
    //return;    
}

// Export USkyPawn::execClaimFireTicket(FFrame&, void* const)
native final function bool ClaimFireTicket(Controller inClaimer, optional bool bClaimAll, optional bool bTest);

// Export USkyPawn::execReleaseFireTicket(FFrame&, void* const)
native final function bool ReleaseFireTicket(Controller inReleaser);

// Export USkyPawn::execIsAnyFireTicketClaimed(FFrame&, void* const)
native final function bool IsAnyFireTicketClaimed();

// Export USkyPawn::execShowGammaDebug(FFrame&, void* const)
native function ShowGammaDebug(Canvas Canvas, bool bShow);

// Export USkyPawn::execIgnoreInputForTransition(FFrame&, void* const)
native function bool IgnoreInputForTransition();

// Export USkyPawn::execCalcPawnRotation(FFrame&, void* const)
native final function Rotator CalcPawnRotation(Rotator NewRotation, float DeltaTime);

// Export USkyPawn::execSuggestCustomJumpVelocity(FFrame&, void* const)
native function bool SuggestCustomJumpVelocity(out Vector JumpVelocity, Vector End, Vector Start, float HorizontalSpeed, float VerticalSpeed);

simulated event SetFallState(SkyPawn.EFallState S)
{
    // End:0x22
    if(int(S) == int(4))
    {
        SetTimer(LandedFailsafeTimerDuration, false, LandedFailsafeTimerName);        
    }
    else
    {
        // End:0x5F
        if(int(S) == int(5))
        {
            ClearTimer('LeftAirplaneJackGravity');
            ClearTimer('LeftAirplaneFixGravity');
            LeftAirplaneFixGravity();            
        }
        else
        {
            // End:0x91
            if(((SkyPawn_MaxValenti(self) != none) && int(S) == int(1)) && int(FallState) != int(5))
            {
                return;
            }
        }
    }
    // End:0xB0
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetFallState(S);
    }
    FallState = S;
    //return;    
}

reliable server function ServerSetFallState(SkyPawn.EFallState S)
{
    FallState = S;
    //return;    
}

simulated function SetAccelRate(float NewRate)
{
    // End:0x1F
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetAccelRate(NewRate);
    }
    AccelRate = NewRate;
    //return;    
}

reliable server function ServerSetAccelRate(float NewRate)
{
    // End:0x1F
    if(int(Role) == int(ROLE_Authority))
    {
        SetAccelRate(NewRate);
    }
    //return;    
}

// Export USkyPawn::execIsInVerticalSpace(FFrame&, void* const)
native final function bool IsInVerticalSpace();

// Export USkyPawn::execIsNearVerticalSpace(FFrame&, void* const)
native final function bool IsNearVerticalSpace();

// Export USkyPawn::execSetFaceMorph(FFrame&, void* const)
native function bool SetFaceMorph(name NodeName);

// Export USkyPawn::execNeedToTurnToward(FFrame&, void* const)
native function bool NeedToTurnToward(Vector Target);

// Export USkyPawn::execTurnOneStepToward(FFrame&, void* const)
native function TurnOneStepToward(Vector Target);

exec function ShowBones(optional name Who, optional name Branch)
{
    local Pawn SP;

    // End:0x61
    foreach WorldInfo.AllPawns(Class'Engine.Pawn', SP)
    {
        // End:0x60
        if(SkySkelMeshComponent(SP.Mesh) != none)
        {
            SkySkelMeshComponent(SP.Mesh).SetShowBones(false);
        }        
    }    
    // End:0xA1
    if((Who == 'Off') || (Who == 'None') && Branch == 'None')
    {
        return;
    }
    // End:0xF2
    if(Who == 'Self')
    {
        // End:0xEF
        if(SkySkelMeshComponent(self.Mesh) != none)
        {
            SkySkelMeshComponent(self.Mesh).SetShowBones(true, Branch);
        }        
    }
    else
    {
        // End:0x1CA
        foreach WorldInfo.AllPawns(Class'Engine.Pawn', SP)
        {
            // End:0x1C9
            if((((Who == 'All') || (Who == 'AI') && SP != self) || Who == SP.Name) || Who == SP.Controller.Name)
            {
                // End:0x1C9
                if(SkySkelMeshComponent(SP.Mesh) != none)
                {
                    SkySkelMeshComponent(SP.Mesh).SetShowBones(true, Branch);
                }
            }            
        }        
    }
    //return;    
}

exec function IgnoreNotifies()
{
    bIgnoreNotifies = !bIgnoreNotifies;
    // End:0x34
    if(bIgnoreNotifies)
    {
        ClientMessage("Notifies off");        
    }
    else
    {
        ClientMessage("Notifies on");
    }
    //return;    
}

event Hinder(float HinderSpeed, float HinderDuration, float AudioSlowmo)
{
    bIsHindered = true;
    HinderedSpeed = HinderSpeed;
    HinderedAudioSlowmo = AudioSlowmo;
    SetTimer(HinderDuration, false, 'ResetHinder');
    //return;    
}

function ResetHinder()
{
    bIsHindered = false;
    //return;    
}

simulated function bool HavePotentialAutoAimTargets(Vector vStartTrace, Vector vEndTrace)
{
    local Pawn pPawn;
    local Vector vToPawn, vToPawnNorm, vTraceDir;
    local float fDot;

    vTraceDir = Normal(vEndTrace - vStartTrace);
    // End:0x105
    foreach WorldInfo.AllPawns(Class'Engine.Pawn', pPawn)
    {
        // End:0x104
        if(!pPawn.IsA('SkyPawn_MaxValenti') && pPawn.Health > 0)
        {
            vToPawn = pPawn.Location - vStartTrace;
            // End:0x104
            if((vToPawn Dot vTraceDir) > float(0))
            {
                vToPawnNorm = Normal(pPawn.Location - vStartTrace);
                fDot = vToPawnNorm Dot vTraceDir;
                // End:0xF2
                if((VSizeSq(vToPawn) < float(2000000)) && fDot > 0.9500000)
                {                    
                    return true;
                    // End:0x104
                    continue;
                }
                // End:0x104
                if(fDot > 0.9950000)
                {                    
                    return true;
                }
            }
        }        
    }    
    return false;
    //return ReturnValue;    
}

// Export USkyPawn::execGetImpactList(FFrame&, void* const)
native function ImpactInfo GetImpactList(Vector vStartTrace, Vector vEndTrace, optional out array<ImpactInfo> ImpactList, optional out int FlashImpactIdx, optional Actor SourceActor, optional Vector Extents);

// Export USkyPawn::execGetAutoAimTraceActor(FFrame&, void* const)
native function ImpactInfo GetAutoAimTraceActor(Vector vStartTrace, Vector vEndTrace);

simulated event GetCameraAxes(out Vector vOutCamX, out Vector vOutCamY, out Vector vOutCamZ)
{
    local SkyPlayerController pSPC;
    local Vector vCamLoc;
    local Rotator rCamRot;

    pSPC = SkyPlayerController(Controller);
    // End:0x4F
    if(pSPC != none)
    {
        pSPC.GetPlayerViewPoint(vCamLoc, rCamRot);
        GetAxes(rCamRot, vOutCamX, vOutCamY, vOutCamZ);
    }
    //return;    
}

simulated function float GetReticleDistFromCamera()
{
    local SkyPlayerController pSPC;
    local float fResult;

    fResult = Class'SkyPlayerController'.default.m_fReticleDistFromCamera;
    pSPC = SkyPlayerController(Controller);
    // End:0x45
    if(pSPC != none)
    {
        fResult = pSPC.m_fReticleDistFromCamera;
    }
    return fResult;
    //return ReturnValue;    
}

simulated event float GetAutoAimTraceOffsetLength()
{
    local SkyWeapon W;
    local float ReticleSize;

    W = SkyWeapon(Weapon);
    // End:0x38
    if(W != none)
    {
        ReticleSize = W.GetAutoAimTraceOffsetLength();        
    }
    else
    {
        ReticleSize = 25.0000000;
    }
    return ((AutoAimMaxRange * ReticleSize) * float(2)) / (GetReticleDistFromCamera());
    //return ReturnValue;    
}

// Export USkyPawn::execGetAutoAimTargetNative(FFrame&, void* const)
native function ImpactInfo GetAutoAimTargetNative(Vector StartTrace, Vector EndTrace);

exec function ToggleDebugReticle()
{
    bUseDebugReticle = !bUseDebugReticle;
    //return;    
}

// Export USkyPawn::execIsLookingAround(FFrame&, void* const)
native final function bool IsLookingAround();

// Export USkyPawn::execShouldStop(FFrame&, void* const)
native function bool ShouldStop();

// Export USkyPawn::execFixGroundIntersection(FFrame&, void* const)
native function FixGroundIntersection();

// Export USkyPawn::execIsHijacking(FFrame&, void* const)
native function bool IsHijacking();

// Export USkyPawn::execIsBeingHijacked(FFrame&, void* const)
native function bool IsBeingHijacked();

simulated event PlayVoiceOver(SoundCue Cue)
{
    local SkyPawn_MaxValenti SP;

    // End:0x136
    if(Cue != none)
    {
        // End:0x4C
        if(SkyPawnSoundGroup(SoundGroup) != none)
        {
            // End:0x4C
            if((WorldInfo.TimeSeconds - LastVOTime) < SkyPawnSoundGroup(SoundGroup).GlobalVODelay)
            {
                return;
            }
        }
        SP = SkyPawn_MaxValenti(self);
        // End:0xE7
        if((((((SP != none) && Mesh != none) && Mesh.CachedFaceFXAudioComp != none) && Mesh.CachedFaceFXAudioComp.IsPlaying()) || SP.CurrVOTimeRemaining > float(0)) && !PlayerController(SP.Controller).IsPaused())
        {
            return;
        }
        PlaySound(Cue, false, true);
        LastVOTime = WorldInfo.TimeSeconds;
        // End:0x136
        if(SP != none)
        {
            SP.CurrVOTimeRemaining = Cue.Duration;
        }
    }
    //return;    
}

simulated event PlayFootStepSound(int FootDown)
{
    local SoundCue CueToPlay;

    PlayFootstepEffect(FootDown);
    // End:0xE0
    if((CachedGroundMaterialType != 'None') || CachedGroundMaterialTypeUndefined)
    {
        // End:0xD7
        if(SoundGroup != none)
        {
            // End:0x68
            if(bSteppedInShallowWater)
            {
                CueToPlay = SoundGroup.GetShallowWaterFootstepSound(FootDown, CachedGroundMaterialType);                
            }
            else
            {
                // End:0x98
                if(bSteppedInDeepWater)
                {
                    CueToPlay = SoundGroup.GetDeepWaterFootstepSound(FootDown, CachedGroundMaterialType);                    
                }
                else
                {
                    CueToPlay = SoundGroup.GetFootstepSound(FootDown, CachedGroundMaterialType);
                }
            }
            // End:0xD7
            if(CueToPlay != none)
            {
                PlaySound(CueToPlay);
            }
        }
        MakeNoise(0.2500000);
    }
    LastFootDown = FootDown;
    //return;    
}

simulated function PlayFootstepEffect(int FootDown)
{
    local TraceHitInfo HitInfo;
    local Vector StartLoc, EndLoc, HitLoc, HitNorm, FootLoc;

    local Rotator FootRot;
    local Actor HitActor;
    local int I;
    local SkyPhysicalMaterialProperty PhysProp;
    local float deltaZ;

    CachedGroundMaterialTypeUndefined = false;
    // End:0x1A
    if(FootDown >= FootstepSockets.Length)
    {
        return;
    }
    Mesh.GetSocketWorldLocationAndRotation(FootstepSockets[FootDown], FootLoc, FootRot);
    StartLoc = FootLoc + (float(150) * vect(0.0000000, 0.0000000, 1.0000000));
    EndLoc = FootLoc + (float(100) * vect(0.0000000, 0.0000000, -1.0000000));
    HitActor = Trace(HitLoc, HitNorm, EndLoc, StartLoc, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 524288);
    // End:0xD0
    if(HitActor == none)
    {
        CachedGroundMaterialType = 'None';
        return;
    }
    // End:0xF1
    if(HitInfo.PhysMaterial == none)
    {
        CachedGroundMaterialTypeUndefined = true;        
    }
    else
    {
        PhysProp = SkyPhysicalMaterialProperty(HitInfo.PhysMaterial.PhysicalMaterialProperty);
        // End:0x13B
        if(PhysProp == none)
        {
            CachedGroundMaterialType = 'None';
            CachedGroundMaterialTypeUndefined = true;            
        }
        else
        {
            CachedGroundMaterialType = PhysProp.MaterialType;
        }
    }
    bSteppedInDeepWater = false;
    bSteppedInShallowWater = false;
    // End:0x1CF
    if(HitLoc.Z > FootLoc.Z)
    {
        deltaZ = HitLoc.Z - FootLoc.Z;
        // End:0x1C7
        if(deltaZ > 25.0000000)
        {
            bSteppedInDeepWater = true;            
        }
        else
        {
            bSteppedInShallowWater = true;
        }
    }
    // End:0x266
    if(bSteppedInShallowWater)
    {
        I = 0;
        J0x1DF:

        // End:0x263 [Loop If]
        if(I < ShallowWaterFootstepImpacts.Length)
        {
            // End:0x259
            if(ShallowWaterFootstepImpacts[I].Material == CachedGroundMaterialType)
            {
                SpawnFootstepEffect(HitLoc, FootRot, ShallowWaterFootstepImpacts[I]);
                SpawnFootstepDecal(HitActor, HitLoc, HitNorm, ShallowWaterFootstepImpacts[I], FootDown);
                return;
            }
            ++I;
            // [Loop Continue]
            goto J0x1DF;
        }        
    }
    else
    {
        // End:0x2FD
        if(bSteppedInDeepWater)
        {
            I = 0;
            J0x276:

            // End:0x2FA [Loop If]
            if(I < DeepWaterFootstepImpacts.Length)
            {
                // End:0x2F0
                if(DeepWaterFootstepImpacts[I].Material == CachedGroundMaterialType)
                {
                    SpawnFootstepEffect(HitLoc, FootRot, DeepWaterFootstepImpacts[I]);
                    SpawnFootstepDecal(HitActor, HitLoc, HitNorm, DeepWaterFootstepImpacts[I], FootDown);
                    return;
                }
                ++I;
                // [Loop Continue]
                goto J0x276;
            }            
        }
        else
        {
            I = 0;
            J0x304:

            // End:0x388 [Loop If]
            if(I < FootstepImpacts.Length)
            {
                // End:0x37E
                if(FootstepImpacts[I].Material == CachedGroundMaterialType)
                {
                    SpawnFootstepEffect(HitLoc, FootRot, FootstepImpacts[I]);
                    SpawnFootstepDecal(HitActor, HitLoc, HitNorm, FootstepImpacts[I], FootDown);
                    return;
                }
                ++I;
                // [Loop Continue]
                goto J0x304;
            }
        }
    }
    //return;    
}

simulated function SpawnFootstepEffect(Vector SpawnLocation, Rotator SpawnRotation, FootstepImpact Effect)
{
    local SkyEmitter ImpactEffect;
    local SkyGameReplicationInfo GRI;
    local ParticleSystem PSTemplate;

    PSTemplate = none;
    // End:0x45
    if((IsSprinting()) && Effect.SprintEffect != none)
    {
        PSTemplate = Effect.SprintEffect;        
    }
    else
    {
        PSTemplate = Effect.Effect;
    }
    // End:0x10C
    if(PSTemplate != none)
    {
        GRI = SkyGameReplicationInfo(WorldInfo.GRI);
        // End:0xC8
        if(GRI.SOP != none)
        {
            ImpactEffect = GRI.SOP.CreateEmitter(PSTemplate, self, SpawnLocation, SpawnRotation);            
        }
        else
        {
            ImpactEffect = Spawn(Class'SkyEmitter', self,, SpawnLocation, SpawnRotation);
            // End:0x10C
            if(ImpactEffect != none)
            {
                ImpactEffect.SetTemplate(PSTemplate, true);
            }
        }
    }
    //return;    
}

simulated function SpawnFootstepDecal(Actor HitActor, Vector HitLoc, Vector HitNorm, FootstepImpact ImpactEffect, int FootDown)
{
    local MaterialInstanceConstant MatInst;
    local LinearColor UV;
    local Rotator DecalRot;

    DecalRot = Rotator(-HitNorm);
    DecalRot.Yaw = Rotation.Yaw;
    // End:0x18E
    if(ImpactEffect.Decal != none)
    {
        MatInst = new (Outer) Class'Engine.MaterialInstanceConstant';
        MatInst.SetParent(ImpactEffect.Decal);
        // End:0x18E
        if(MatInst != none)
        {
            UV.G = 1.0000000;
            // End:0xC6
            if((FootDown & 1) == 1)
            {
                UV.R = 1.0000000;                
            }
            else
            {
                UV.R = -1.0000000;
            }
            MatInst.SetVectorParameterValue('footstep_uv', UV);
            WorldInfo.MyDecalManager.SpawnDecal(MatInst, HitLoc - vect(0.0000000, 0.0000000, 5.0000000), DecalRot, ImpactEffect.DecalWidth, ImpactEffect.DecalHeight, ImpactEffect.DecalDepth, false, 0.0000000, none, false, false, 'None', -1, -1);
        }
    }
    //return;    
}

// Export USkyPawn::execAcceptsImpacts(FFrame&, void* const)
native function bool AcceptsImpacts();

// Export USkyPawn::execAddLocalEffect(FFrame&, void* const)
native simulated function SkyLocalEffectComponent AddLocalEffect(const SkyLocalEffectSettings NewEffect);

// Export USkyPawn::execRemoveLocalEffect(FFrame&, void* const)
native simulated function RemoveLocalEffect(SkyLocalEffectComponent OldSkyLocalEffectComponent);

// Export USkyPawn::execSetKillOnDeactivate(FFrame&, void* const)
native simulated function SetKillOnDeactivate(SkyLocalEffectComponent SkyLocalEffectComponent, bool bKill);

simulated function UpdateGroundMaterialType()
{
    // End:0x2E
    if(Weapon != none)
    {
        // End:0x2E
        if(Weapon.PendingFire(0))
        {
            GetGroundMaterialType();
        }
    }
    //return;    
}

simulated event name GetGroundMaterialType(optional bool bCached)
{
    local Vector HitLocation, HitNormal, TraceStart, TraceEnd;
    local TraceHitInfo HitInfo;
    local SkyPhysicalMaterialProperty PhysicalProperty;
    local float deltaZ;

    // End:0x1A9
    if(!bCached)
    {
        TraceStart = Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000));
        TraceEnd = (Location - ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000))) - vect(0.0000000, 0.0000000, 32.0000000);
        Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 524288);
        // End:0x19A
        if(HitInfo.PhysMaterial != none)
        {
            PhysicalProperty = SkyPhysicalMaterialProperty(HitInfo.PhysMaterial.GetPhysicalMaterialProperty(Class'SkyPhysicalMaterialProperty'));
            // End:0x188
            if(PhysicalProperty != none)
            {
                // End:0x170
                if(PhysicalProperty.MaterialType == 'Water')
                {
                    deltaZ = HitLocation.Z - (Location.Z - (GetCollisionHeight()));
                    // End:0x15E
                    if(deltaZ > 25.0000000)
                    {
                        CachedGroundMaterialType = PhysicalProperty.MaterialType;                        
                    }
                    else
                    {
                        CachedGroundMaterialType = 'Dirt';
                    }                    
                }
                else
                {
                    CachedGroundMaterialType = PhysicalProperty.MaterialType;
                }                
            }
            else
            {
                CachedGroundMaterialType = 'None';
            }            
        }
        else
        {
            CachedGroundMaterialType = 'None';
        }
    }
    return CachedGroundMaterialType;
    //return ReturnValue;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    super(Pawn).Landed(HitNormal, FloorActor);
    // End:0x42
    if(Velocity.Z < float(-200))
    {
        OldZ = Location.Z;
    }
    // End:0x6A
    if(InvManager != none)
    {
        InvManager.OwnerEvent('Landed');
    }
    // End:0xC6
    if(bDodging || Velocity.Z < (float(-2) * JumpZ))
    {
        Velocity.X *= 0.1000000;
        Velocity.Y *= 0.1000000;
    }
    bDodging = false;
    // End:0x115
    if(SkyPawnSoundGroup(SoundGroup) != none)
    {
        SkyPawnSoundGroup(SoundGroup).PlayLandSounds(self, -Velocity.Z, GetGroundMaterialType());
    }
    SetBaseEyeheight();
    // End:0x139
    if(IsParachuting())
    {
        KillParachute();        
    }
    else
    {
        // End:0x150
        if(IsRocketPacking())
        {
            TurnOffRocketPack();
        }
    }
    // End:0x16F
    if(RocketPack != none)
    {
        RocketPack.OnLand();
    }
    SetFallState(4);
    //return;    
}

reliable server function ServerSetHijackTarget(SkyAirVehicle Target)
{
    SetHijackTarget(Target);
    //return;    
}

simulated event SetHijackTarget(SkyAirVehicle Target)
{
    // End:0x39
    if(Target != HijackTarget)
    {
        // End:0x2E
        if(int(Role) < int(ROLE_Authority))
        {
            ServerSetHijackTarget(Target);
        }
        HijackTarget = Target;
    }
    //return;    
}

simulated event FireHijackKismetEvent(bool bHijacking, bool bSuccess)
{
    local class<SequenceEvent> SelfTrigger, TargetTrigger;

    // End:0x22
    if(bSuccess)
    {
        TargetTrigger = Class'SkySeqEvent_HijackedOusted';
        SelfTrigger = Class'SkySeqEvent_HijackingSuccess';        
    }
    else
    {
        TargetTrigger = Class'SkySeqEvent_HijackedDefended';
        SelfTrigger = Class'SkySeqEvent_HijackingFailure';
    }
    HijackTarget.TriggerEventClass(TargetTrigger, self);
    TriggerEventClass(SelfTrigger, self);
    //return;    
}

// Export USkyPawn::execAbortHijacking(FFrame&, void* const)
native simulated function AbortHijacking();

reliable server event ServerAbortHijacking()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        AbortHijacking();
    }
    //return;    
}

// Export USkyPawn::execEndHijacking(FFrame&, void* const)
native simulated function EndHijacking(bool bSuccess);

reliable client simulated event ClientEndHijacking(bool bSuccess)
{
    // End:0x46
    if((Controller != none) && !Controller.IsLocalPlayerController())
    {
        // End:0x46
        if(int(Role) > int(ROLE_SimulatedProxy))
        {
            EndHijacking(bSuccess);
        }
    }
    //return;    
}

simulated event Vector2D ModifyAnimStickInput(Vector2D StickInput, name NameParam)
{
    // End:0x7C
    if(((NameParam == 'MotorcycleLean') && SVehicle(DrivenVehicle) != none) && SkyVehicleSim_Motorcycle(SVehicle(DrivenVehicle).SimObj) != none)
    {
        return SkyVehicleSim_Motorcycle(SVehicle(DrivenVehicle).SimObj).ModifyAnimStickInput(StickInput, NameParam);        
    }
    else
    {
        return StickInput;
    }
    //return ReturnValue;    
}

simulated function AttachPilot()
{
    // End:0x82
    if(PilotArchetype != none)
    {
        Pilot = Spawn(PilotArchetype.Class, self,,,, PilotArchetype);
        // End:0x7F
        if(Pilot != none)
        {
            // End:0x7C
            if(PilotSocket != 'None')
            {
                Pilot.AttachToPawnAndSocket(self, PilotSocket);
                Pilot.PilotedPawn = self;                
            }            
        }        
    }
    //return;    
}

event CreateMaterialInstanceConstant(SkeletalMeshComponent OwnerMesh)
{
    local int NewIdx, I, NumMaterials;
    local MaterialInterface MatInterface;

    // End:0x15F
    if((OwnerMesh != none) && OwnerMesh.SkeletalMesh != none)
    {
        NumMaterials = OwnerMesh.SkeletalMesh.Materials.Length;
        NewIdx = MatInstConsts.Add(NumMaterials);
        I = 0;
        J0x5A:

        // End:0x15F [Loop If]
        if(I < NumMaterials)
        {
            MatInstConsts[NewIdx + I] = new (Outer) Class'Engine.MaterialInstanceConstant';
            // End:0xDF
            if((I < OwnerMesh.Materials.Length) && OwnerMesh.Materials[I] != none)
            {
                MatInterface = OwnerMesh.Materials[I];                
            }
            else
            {
                MatInterface = OwnerMesh.SkeletalMesh.Materials[I];
            }
            MatInstConsts[NewIdx + I].SetParent(MatInterface);
            OwnerMesh.SetMaterial(I, MatInstConsts[NewIdx + I]);
            ++I;
            // [Loop Continue]
            goto J0x5A;
        }
    }
    //return;    
}

event SetMaterialInstanceConstant(SkeletalMeshComponent OwnerMesh, int MaterialIndex, MaterialInterface NewMaterial)
{
    local int I;

    // End:0xBF
    if(((OwnerMesh != none) && OwnerMesh.SkeletalMesh != none) && (MaterialIndex < OwnerMesh.SkeletalMesh.Materials.Length) && MaterialIndex >= 0)
    {
        I = MatInstConsts.Add(1);
        MatInstConsts[I] = new (Outer) Class'Engine.MaterialInstanceConstant';
        MatInstConsts[I].SetParent(NewMaterial);
        OwnerMesh.SetMaterial(MaterialIndex, MatInstConsts[I]);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local int HairIdx;
    local array<BodyParts> CombinedHairMeshes;
    local int I;

    InitWSM();
    Mesh.bForceUpdateAttachmentsInTick = true;
    SetNumberOfFireTickets(NumFireTickets);
    // End:0x48
    if(PossibleBodyMeshes.Length > 0)
    {
        PickBodyPartMesh(Mesh, PossibleBodyMeshes);
    }
    // End:0x6A
    if(HeadMesh != none)
    {
        HeadMesh.SetSkeletalMesh(HeadSkelMesh);
    }
    // End:0x8A
    if(LegMesh != none)
    {
        PickBodyPartMesh(LegMesh, PossibleLegsMeshes);
    }
    Mesh.MorphChildComponent = HeadMesh;
    super.PostBeginPlay();
    PickFaceMorph();
    // End:0x1D0
    if(HairMesh != none)
    {
        CombinedHairMeshes.Add(PossibleHairMeshes.Length);
        // End:0x100
        if((HeadMorphIndex >= 0) && HeadMorphIndex < PossibleHeadMorphs.Length)
        {
            CombinedHairMeshes.Add(PossibleHeadMorphs[HeadMorphIndex].AdditionalPossibleHairMeshes.Length);
        }
        I = 0;
        J0x107:

        // End:0x138 [Loop If]
        if(I < PossibleHairMeshes.Length)
        {
            CombinedHairMeshes[I] = PossibleHairMeshes[I];
            I++;
            // [Loop Continue]
            goto J0x107;
        }
        // End:0x1B7
        if((HeadMorphIndex >= 0) && HeadMorphIndex < PossibleHeadMorphs.Length)
        {
            I = 0;
            J0x15C:

            // End:0x1B7 [Loop If]
            if(I < PossibleHeadMorphs[HeadMorphIndex].AdditionalPossibleHairMeshes.Length)
            {
                CombinedHairMeshes[PossibleHairMeshes.Length + I] = PossibleHeadMorphs[HeadMorphIndex].AdditionalPossibleHairMeshes[I];
                I++;
                // [Loop Continue]
                goto J0x15C;
            }
        }
        PickBodyPartMesh(HairMesh, CombinedHairMeshes, HairIdx);
    }
    // End:0x250
    if(LightEnvironment != none)
    {
        Mesh.SetLightEnvironment(LightEnvironment);
        // End:0x210
        if(HeadMesh != none)
        {
            HeadMesh.SetLightEnvironment(LightEnvironment);
        }
        // End:0x230
        if(LegMesh != none)
        {
            LegMesh.SetLightEnvironment(LightEnvironment);
        }
        // End:0x250
        if(HairMesh != none)
        {
            HairMesh.SetLightEnvironment(LightEnvironment);
        }
    }
    bIsSecondaryAiming = false;
    SetFallState(5);
    DodgeState = 0;
    CurrentTerminalVelocity = TerminalVelocity;
    TargetTerminalVelocity = TerminalVelocity;
    // End:0x2E2
    if(SkyPawnSoundGroup(SoundGroup) != none)
    {
        SprintingSound.SoundCue = SkyPawnSoundGroup(SoundGroup).SprintingSound;
        BreathingSound.SoundCue = SkyPawnSoundGroup(SoundGroup).HeavyBreathingSound;
        CanBreathe = true;
    }
    ResetNavigationSetCache();
    TurningAngleCosine = Cos(TurningAngle * 0.0174500);
    // End:0x320
    if(LegMesh != none)
    {
        LegMesh.SetShadowParent(Mesh);
    }
    // End:0x340
    if(HeadMesh != none)
    {
        HeadMesh.SetShadowParent(Mesh);
    }
    // End:0x360
    if(HairMesh != none)
    {
        HairMesh.SetShadowParent(Mesh);
    }
    Mesh.CastShadow = true;
    Mesh.bCastDynamicShadow = true;
    // End:0x3B3
    if(LegMesh != none)
    {
        LegMesh.CastShadow = true;
        LegMesh.bCastDynamicShadow = true;
    }
    // End:0x3E2
    if(HairMesh != none)
    {
        HairMesh.CastShadow = true;
        HairMesh.bCastDynamicShadow = true;
    }
    // End:0x411
    if(HeadMesh != none)
    {
        HeadMesh.CastShadow = true;
        HeadMesh.bCastDynamicShadow = true;
    }
    ShootableAngleVertUpRight = Cos(default.ShootableAngleVertUpRight * 0.0174533);
    ShootableAngleVertUpLeft = Cos(default.ShootableAngleVertUpLeft * 0.0174533);
    ShootableAngleVertDownRight = Cos(default.ShootableAngleVertDownRight * 0.0174533);
    ShootableAngleVertDownLeft = Cos(default.ShootableAngleVertDownLeft * 0.0174533);
    SetupParentAnim(HeadMesh);
    SetupParentAnim(LegMesh);
    // End:0x578
    if(HairMesh != none)
    {
        // End:0x510
        if((HairIdx < PossibleHairMeshes.Length) && PossibleHairMeshes[HairIdx].Socket != 'None')
        {
            HairMesh.SetParentAnimComponent(none);
            HairMesh.bTransformFromAnimParent = 0;
            Mesh.AttachComponentToSocket(HairMesh, PossibleHairMeshes[HairIdx].Socket);            
        }
        else
        {
            SetupParentAnim(HairMesh);
        }
        // End:0x578
        if((HairIdx < PossibleHairMeshes.Length) && PossibleHairMeshes[HairIdx].PhysAsset != none)
        {
            HairMesh.EnablePhysics(PossibleHairMeshes[HairIdx].PhysAsset, 1.0000000);
        }
    }
    ActiveMaterialInstanceConstant = MaterialInstanceConstant(Mesh.GetMaterial(0));
    CreateMaterialInstanceConstant(Mesh);
    CreateMaterialInstanceConstant(LegMesh);
    CreateMaterialInstanceConstant(HairMesh);
    CreateMaterialInstanceConstant(HeadMesh);
    SetTimer(JumpVehicleTargetUpdateTimer + ((FRand() - 0.5000000) * (JumpVehicleTargetUpdateTimer * 0.1000000)), false, 'UpdateJumpVehicleTarget');
    // End:0x61F
    if(bMatineeCharacter)
    {
        ++MatineeCharacterRefCount;
        SetPhysics(7);
        AddRocketPackToInv();
    }
    HealthAutoRegenMax = Min(HealthAutoRegenMax, Health);
    ScriptedAnimNode = SkyAnimNodePlayCustomAnim(Mesh.Animations.FindAnimNode('ScriptedAnim'));
    // End:0x677
    if(PersonalityIndex < 0)
    {
        PersonalityIndex = Rand(1000);
    }
    SetMood(1);
    // End:0x6CC
    if(RocketPackThrustControllerArchetype != none)
    {
        StoredRocketPackThrustController = Spawn(Class'SkyBotControllerPilot', self,, Location, Rotation, RocketPackThrustControllerArchetype, true);
        StoredRocketPackThrustController.PushState('Frozen');
    }
    InitTurbulence();
    // End:0x701
    if(LightEnvironment != none)
    {
        // End:0x701
        if(TurbulenceInstance != none)
        {
            TurbulenceInstance.SetLightEnvironment(LightEnvironment);
        }
    }
    AttachPilot();
    CurrentLocation = Location;
    PreviousLocation = Location;
    DeathSpawnIndex = -1;
    UpdateSecrets();
    //return;    
}

simulated event UpdateSecrets()
{
    local int AlternateMatIdx;

    // End:0x7E
    if(PlayerController(Controller) != none)
    {
        AlternateMatIdx = PlayerController(Controller).GetSecretIndex();
        // End:0x7E
        if(AlternateMatIdx >= 0)
        {
            // End:0x5A
            if(HairMesh != none)
            {
                HairMesh.UseAlternateMaterial(AlternateMatIdx);
            }
            // End:0x7E
            if(RocketPack != none)
            {
                RocketPack.UpdateSecrets(AlternateMatIdx);
            }
        }
    }
    //return;    
}

// Export USkyPawn::execInitWSM(FFrame&, void* const)
native function InitWSM();

// Export USkyPawn::execInitTurbulence(FFrame&, void* const)
native function InitTurbulence();

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local int I;

    super(Actor).PostInitAnimTree(SkelComp);
    // End:0x188
    if(SkelComp == Mesh)
    {
        HeadControl = SkelControlSingleBone(Mesh.FindSkelControl(HeadControlName));
        I = 0;
        J0x41:

        // End:0x125 [Loop If]
        if(I < ArmorInfo.Length)
        {
            ArmorInfo[I].MorphNode = MorphNodeWeight(Mesh.FindMorphNode(ArmorInfo[I].MorphNodeName));
            ArmorInfo[I].DamageMorphNode = MorphNodeWeight(Mesh.FindMorphNode(ArmorInfo[I].DamageMorphNodeName));
            // End:0x11B
            if(ArmorInfo[I].DamageMorphNode != none)
            {
                ArmorInfo[I].DamageMorphNode.SetNodeWeight(0.0000000);
            }
            ++I;
            // [Loop Continue]
            goto J0x41;
        }
        I = 0;
        J0x12C:

        // End:0x188 [Loop If]
        if(I < WeakPoints.Length)
        {
            WeakPoints[I].MorphNode = MorphNodeWeight(Mesh.FindMorphNode(WeakPoints[I].MorphNodeName));
            I++;
            // [Loop Continue]
            goto J0x12C;
        }
    }
    //return;    
}

simulated function OnSetAnimTree(SkySeqAct_SetAnimTree inAction)
{
    // End:0x2C
    if(inAction.bUpdateAnimTree)
    {
        SetAnimTree(inAction.Template);
    }
    // End:0x58
    if(inAction.bUpdateAnimSets)
    {
        SetAnimSets(inAction.AnimSets);
    }
    //return;    
}

simulated event SetAnimSets(array<AnimSet> AnimSets)
{
    Mesh.AnimSets = AnimSets;
    Mesh.UpdateAnimations();
    //return;    
}

simulated event SetAnimTree(AnimTree Template)
{
    Mesh.SetAnimTreeTemplate(Template);
    ScriptedAnimNode = SkyAnimNodePlayCustomAnim(Mesh.Animations.FindAnimNode('ScriptedAnim'));
    //return;    
}

final event SkyAnimNodePlayCustomAnim GetScriptedAnimNode()
{
    return ScriptedAnimNode;
    //return ReturnValue;    
}

// Export USkyPawn::execSetupParentAnim(FFrame&, void* const)
native function SetupParentAnim(SkeletalMeshComponent Comp);

simulated event Destroyed()
{
    super.Destroyed();
    // End:0x1E
    if(RocketPack != none)
    {
        RocketPack.Destroy();
    }
    // End:0x36
    if(StoredRocketPackThrustController != none)
    {
        StoredRocketPackThrustController.Destroy();
    }
    SecondaryWeapon = none;
    //return;    
}

simulated function DisconnectPilot()
{
    // End:0x30
    if(Pilot != none)
    {
        Pilot.PilotedPawn = none;
        Pilot.Destroy();
        Pilot = none;
    }
    //return;    
}

function SpawnDeathSpawn()
{
    local Vector vSpawnLoc;
    local Rotator rSpawnRot;
    local SkyPawn NewPawn;
    local bool PrevCollideActors;
    local int Index;

    Index = DeathSpawnIndex;
    Mesh.GetSocketWorldLocationAndRotation(DeathSpawnTypes[Index].Socket, vSpawnLoc, rSpawnRot);
    PrevCollideActors = bCollideActors;
    SetCollision(false, bBlockActors, bIgnoreEncroachers);
    NewPawn = Spawn(DeathSpawnTypes[Index].PawnArchetype.Class, self,, vSpawnLoc, rSpawnRot, DeathSpawnTypes[Index].PawnArchetype);
    NewPawn.SetCollision(false, NewPawn.bBlockActors, NewPawn.bIgnoreEncroachers);
    SetCollision(PrevCollideActors, bBlockActors, bIgnoreEncroachers);
    // End:0x165
    if(DeathSpawnTypes[Index].ControllerArchetype != none)
    {
        NewPawn.Controller = Spawn(DeathSpawnTypes[Index].ControllerArchetype.Class, self,, vSpawnLoc, Rotation, DeathSpawnTypes[Index].ControllerArchetype);        
    }
    else
    {
        NewPawn.Controller = Spawn(DeathSpawnTypes[Index].PawnArchetype.ControllerClass);
    }
    NewPawn.Controller.Possess(NewPawn, false);
    NewPawn.ControllerClass = class<AIController>(NewPawn.Controller.Class);
    // End:0x24F
    if((Base == none) || (int(Physics) != int(1)) && int(Physics) != int(12))
    {
        NewPawn.StartReaction(DeathSpawnTypes[Index].AirExitReaction);        
    }
    else
    {
        NewPawn.StartReaction(DeathSpawnTypes[Index].GroundExitReaction);
    }
    DeathOffspring = NewPawn;
    // End:0x2C8
    if(DeathSpawnTypes[Index].Event != none)
    {
        TriggerEventClass(DeathSpawnTypes[Index].Event, NewPawn);
    }
    // End:0x2EC
    if(KismetAIFactory != none)
    {
        KismetAIFactory.RegisterDeathSpawn(NewPawn);
    }
    //return;    
}

function ProcessDeathSpawn(class<DamageType> DamageType)
{
    local int I;
    local float delay;

    I = 0;
    J0x07:

    // End:0x15E [Loop If]
    if(I < DeathSpawnTypes.Length)
    {
        // End:0x154
        if((DeathSpawnTypes[I].DamageType == none) || ClassIsChildOf(DamageType, DeathSpawnTypes[I].DamageType))
        {
            // End:0x151
            if((RandRange(0.0000000, 100.0000000) <= DeathSpawnTypes[I].PctChance) && DeathSpawnTypes[I].PctChance > 0.0000000)
            {
                DeathSpawnIndex = I;
                // End:0xEA
                if((int(Physics) == int(1)) && Base != none)
                {
                    delay = DeathSpawnTypes[I].GroundSpawnDelay;                    
                }
                else
                {
                    delay = DeathSpawnTypes[I].AirSpawnDelay;
                }
                // End:0x12B
                if(delay > 0.0000000)
                {
                    SetTimer(delay, false, 'SpawnDeathSpawn');                    
                }
                else
                {
                    SpawnDeathSpawn();
                }
                DeathReactionOverride = DeathSpawnTypes[I].DeathReactionOverride;
            }
            // [Explicit Break]
            goto J0x15E;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x15E:

    //return;    
}

event KilledBy(Pawn EventInstigator)
{
    local SkyWeaponUpgradeDataStore wud;
    local DataStoreClient GSC;

    GSC = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x10B
    if(GSC != none)
    {
        wud = SkyWeaponUpgradeDataStore(GSC.FindDataStore('SkyWeaponUpgrade'));
        // End:0x10B
        if(wud != none)
        {
            wud.Loadout.PrimaryIndex = -1;
            wud.Loadout.SecondaryIndex = -1;
            wud.Loadout.SpecialIndex = -1;
            wud.CacheActors(true);
            wud.bPendingLoadout = true;
            wud.ControllerThisFrame = none;
            wud.PawnThisFrame = none;
            wud.UpgradesThisFrame = none;
        }
    }
    super(Pawn).KilledBy(EventInstigator);
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x17
    if(HasAntiGravWeaponEffect())
    {
        EndEffectAntiGravity();
    }
    // End:0x41
    if(SkyWeapon(Weapon) != none)
    {
        SkyWeapon(Weapon).ZoomSetOwnerNoSee(false);
    }
    TimeDied = WorldInfo.TimeSeconds;
    DeathSpawnIndex = -1;
    ProcessDeathSpawn(DamageType);
    // End:0x87
    if(IsInteracting())
    {
        AbortInteraction();
    }
    // End:0xBF
    if((Pilot != none) && Pilot.IsInteracting())
    {
        Pilot.AbortInteraction();
    }
    // End:0xDE
    if(SecondaryWeapon != none)
    {
        SecondaryWeapon.HolderDied();
    }
    // End:0xFE
    if(HijackTarget != none)
    {
        HijackTarget.SetBeingHijacked(none);
    }
    DropWeaponOnDeath();
    // End:0x133
    if(RocketPack != none)
    {
        TurnOffRocketPack();
        RocketPack.RocketPackPlayTag(1);
    }
    Mesh.SetNotifyRigidBodyCollision(true);
    // End:0x16F
    if(SkyBot(Controller) != none)
    {
        SkyBot(Controller).Freeze(true);
    }
    SetSkin(none);
    ActivateDeathMaterials();
    DisconnectPilot();
    // End:0x1AE
    if(KismetAIFactory != none)
    {
        KismetAIFactory.TriggerDeath(self);
    }
    // End:0x209
    if((SkyAirVehicle_RocketPackThrust(DrivenVehicle) != none) && DrivenVehicle.Health > 0)
    {
        DrivenVehicle.Health = 0;
        DrivenVehicle.Died(Killer, DamageType, HitLocation);
    }
    // End:0x236
    if(ActiveMaterialInstanceConstant != none)
    {
        ActiveMaterialInstanceConstant.SetScalarParameterValue('Wind', 0.0000000);
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function ThrowActiveWeapon(optional class<DamageType> DamageType)
{
    //return;    
}

function DropWeaponOnDeath()
{
    local array<int> DroppedAuxWeaponIndices, DestroyedAuxWeaponIndices;
    local int I, auxIndex;
    local bool bDestroyRemaining;
    local int LoopingSoundIndex;

    I = 0;
    J0x07:

    // End:0x12D [Loop If]
    if(I < AuxWeapons.Length)
    {
        // End:0x58
        if(AuxWeapons[I].Attachment != none)
        {
            AuxWeapons[I].Attachment.StopThirdPersonFireEffects();
        }
        // End:0x123
        if(AuxWeapons[I].Instance != none)
        {
            LoopingSoundIndex = 0;
            J0x7B:

            // End:0x123 [Loop If]
            if(LoopingSoundIndex < AuxWeapons[I].Instance.LoopingWeaponFire.Length)
            {
                // End:0x119
                if(AuxWeapons[I].Instance.LoopingWeaponFire[LoopingSoundIndex].Component != none)
                {
                    AuxWeapons[I].Instance.LoopingWeaponFire[LoopingSoundIndex].Component.Stop();
                }
                ++LoopingSoundIndex;
                // [Loop Continue]
                goto J0x7B;
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x1BD
    if(FRand() <= Pickup_DropProbability)
    {
        bDestroyRemaining = false;
        I = 0;
        J0x148:

        // End:0x1BA [Loop If]
        if(I < AuxWeapons.Length)
        {
            // End:0x1A3
            if((FRand() < AuxWeapons[I].PctChanceToDrop) && !bDestroyRemaining)
            {
                DroppedAuxWeaponIndices.AddItem(I);
                // End:0x1A0
                if(Pickup_DropOnlyOneAuxWeapon)
                {
                    bDestroyRemaining = true;
                }
                // [Explicit Continue]
                goto J0x1B0;
            }
            DestroyedAuxWeaponIndices.AddItem(I);
            J0x1B0:

            ++I;
            // [Loop Continue]
            goto J0x148;
        }        
    }
    else
    {
        I = 0;
        J0x1C4:

        // End:0x1EB [Loop If]
        if(I < AuxWeapons.Length)
        {
            DestroyedAuxWeaponIndices.AddItem(I);
            ++I;
            // [Loop Continue]
            goto J0x1C4;
        }
    }
    I = 0;
    J0x1F2:

    // End:0x285 [Loop If]
    if(I < DroppedAuxWeaponIndices.Length)
    {
        auxIndex = DroppedAuxWeaponIndices[I];
        AuxWeapons[auxIndex].Instance.HolderDied();
        DropWeapon(AuxWeapons[auxIndex].Instance, true, auxIndex);
        // End:0x27B
        if(Weapon != none)
        {
            Weapon.bDestroyOnDeath = false;
        }
        I++;
        // [Loop Continue]
        goto J0x1F2;
    }
    I = 0;
    J0x28C:

    // End:0x348 [Loop If]
    if(I < DestroyedAuxWeaponIndices.Length)
    {
        auxIndex = DestroyedAuxWeaponIndices[I];
        AuxWeapons[auxIndex].Instance.HolderDied();
        AuxWeapons[auxIndex].Attachment.Destroy();
        AuxWeapons[auxIndex].Instance.Destroy();
        AuxWeapons[auxIndex].Attachment = none;
        AuxWeapons[auxIndex].Instance = none;
        I++;
        // [Loop Continue]
        goto J0x28C;
    }
    // End:0x3D3
    if(Weapon != none)
    {
        Weapon.HolderDied();
        // End:0x39B
        if((SkyWeapon(Weapon) != none) && FRand() <= Pickup_DropProbability)
        {
            DropWeapon(SkyWeapon(Weapon));
        }
        // End:0x3CC
        if(CurrWeaponAttachment != none)
        {
            CurrWeaponAttachment.DetachFrom(Mesh);
            CurrWeaponAttachment.Destroy();
        }
        Weapon = none;
    }
    // End:0x45D
    if(SecondaryWeapon != none)
    {
        SecondaryWeapon.HolderDied();
        // End:0x42C
        if((SkyWeapon(SecondaryWeapon) != none) && FRand() <= self.Pickup_SecondaryDropProbability)
        {
            DropWeapon(SkyWeapon(SecondaryWeapon));
        }
        // End:0x45D
        if(CurrSecondaryWeaponAttachment != none)
        {
            CurrSecondaryWeaponAttachment.DetachFrom(Mesh);
            CurrSecondaryWeaponAttachment.Destroy();
        }
    }
    //return;    
}

event bool DiedEvent(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x1F
    if(Controller != none)
    {
        Controller.Destroy();
        Controller = none;
    }
    return Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
    local int HealthToHeal;

    HealthToHeal = Amount;
    // End:0x47
    if(default.Health < (Amount + Instigator.Health))
    {
        HealthToHeal = default.Health - Instigator.Health;
    }
    Health += HealthToHeal;
    return true;
    //return ReturnValue;    
}

function SetAdeptOvershield(float newOvershieldRegenRate, float newPercent, float instantHeal)
{
    //return;    
}

function Vector GetCameraLocation()
{
    // End:0x2E
    if(int(Physics) == int(2))
    {
        return Mesh.GetBoneLocation('j_VEL', 0);        
    }
    else
    {
        return Location;
    }
    //return ReturnValue;    
}

event Vector GetCameraCollisionOffset()
{
    local SkyCamera pCam;

    // End:0x2F
    if(SkyPlayerController(Controller) != none)
    {
        pCam = SkyCamera(SkyPlayerController(Controller).PlayerCamera);
    }
    // End:0x60
    if(pCam != none)
    {
        // End:0x60
        if(Controller != none)
        {
            return pCam.CameraInfo.CamSafeLoc;
        }
    }
    return Location + CameraCollisionOffset;
    //return ReturnValue;    
}

simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
    // End:0x2C
    if(VarName == 'SecondaryFiringMode')
    {
        SecondaryFiringModeUpdated(true);        
    }
    else
    {
        // End:0x4D
        if(VarName == 'SecondaryFlashCount')
        {
            SecondaryFlashCountUpdated(true);            
        }
        else
        {
            // End:0x6E
            if(VarName == 'SecondaryFlashLocation')
            {
                SecondaryFlashLocationUpdated(true);                
            }
            else
            {
                // End:0x14A
                if((VarName == 'RocketPack') && RocketPack != none)
                {
                    // End:0x140
                    if(OldRocketPack != RocketPack)
                    {
                        // End:0xDB
                        if(OldRocketPack != none)
                        {
                            OldRocketPack.DetachFrom();
                            Mesh.DetachComponent(OldRocketPack.Mesh);
                        }
                        RocketPack.AttachTo(Mesh, 'skt_rocketpack');
                        Mesh.AttachComponentToSocket(RocketPack.Mesh, 'skt_rocketpack');
                        // End:0x140
                        if(RocketPack.bAllowBoost)
                        {
                            bCanFly = true;
                        }
                    }
                    OldRocketPack = none;                    
                }
                else
                {
                    // End:0x16C
                    if(VarName == 'NetViewRot')
                    {
                        NetViewRot *= 0.0010000;                        
                    }
                    else
                    {
                        // End:0x18E
                        if(VarName == 'NetViewLoc')
                        {
                            NetViewLoc *= 0.1000000;                            
                        }
                        else
                        {
                            // End:0x1D2
                            if(VarName == 'NetStick')
                            {
                                NetStick.X *= 0.0010000;
                                NetStick.Y *= 0.0010000;                                
                            }
                            else
                            {
                                // End:0x255
                                if(VarName == 'ParachuteState')
                                {
                                    // End:0x214
                                    if((int(ParachuteState) == int(1)) || int(ParachuteState) == int(2))
                                    {
                                        OpenParachute();                                        
                                    }
                                    else
                                    {
                                        // End:0x252
                                        if(((int(ParachuteState) == int(3)) || int(ParachuteState) == int(4)) || int(ParachuteState) == int(0))
                                        {
                                            KillParachute();
                                        }
                                    }                                    
                                }
                                else
                                {
                                    // End:0x277
                                    if(VarName == 'CurrWeaponArchetype')
                                    {
                                        WeaponAttachmentChanged();
                                        return;                                        
                                    }
                                    else
                                    {
                                        // End:0x299
                                        if(VarName == 'CurrSecondaryWeaponArchetype')
                                        {
                                            SecondaryWeaponAttachmentChanged();
                                            return;                                            
                                        }
                                        else
                                        {
                                            // End:0x2F1
                                            if(VarName == 'SecondaryWeapon')
                                            {
                                                SecondaryWeapon.SetOwner(self);
                                                // End:0x2DD
                                                if(SecondaryWeapon != none)
                                                {
                                                    SecondaryWSM.Acquire(true);                                                    
                                                }
                                                else
                                                {
                                                    SecondaryWSM.Discard();
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

simulated function SecondaryWeaponAttachmentChanged()
{
    local editinline SkeletalMeshComponent SkyAttachSkelComp;

    // End:0x1E5
    if(((CurrSecondaryWeaponArchetype == none) || CurrSecondaryWeaponAttachment == none) || CurrSecondaryWeaponAttachment.Class != CurrSecondaryWeaponArchetype.AttachClass)
    {
        // End:0x6E
        if(CurrSecondaryWeaponAttachment != none)
        {
            CurrSecondaryWeaponAttachment.DetachFrom(Mesh);
            CurrSecondaryWeaponAttachment.Destroy();
        }
        // End:0x1B1
        if((CurrSecondaryWeaponArchetype != none) && CurrSecondaryWeaponArchetype.AttachClass != none)
        {
            CurrSecondaryWeaponAttachment = Spawn(CurrSecondaryWeaponArchetype.AttachClass, self);
            SkyAttachSkelComp = SkeletalMeshComponent(CurrSecondaryWeaponArchetype.DroppedPickupMesh);
            SkeletalMeshComponent(CurrSecondaryWeaponAttachment.Mesh).SkeletalMesh = SkyAttachSkelComp.SkeletalMesh;
            SkeletalMeshComponent(CurrSecondaryWeaponAttachment.Mesh).AnimSets = SkyAttachSkelComp.AnimSets;
            SkeletalMeshComponent(CurrSecondaryWeaponAttachment.Mesh).SetAnimTreeTemplate(SkyAttachSkelComp.AnimTreeTemplate);
            SkeletalMeshComponent(CurrSecondaryWeaponAttachment.Mesh).SetPhysicsAsset(SkyAttachSkelComp.PhysicsAsset);
            CurrSecondaryWeaponAttachment.Instigator = self;
            CurrSecondaryWeaponAttachment.SetWeaponArchetype(CurrSecondaryWeaponArchetype);            
        }
        else
        {
            CurrSecondaryWeaponAttachment = none;
        }
        // End:0x1E5
        if((CurrSecondaryWeaponAttachment != none) && Mesh != none)
        {
            CurrSecondaryWeaponAttachment.AttachTo(self);
        }
    }
    //return;    
}

exec function SecondaryAttachAdjustMesh(string Cmd)
{
    local string C, V;
    local Vector T, S;
    local Rotator R;
    local float sc;

    C = Left(Cmd, InStr(Cmd, "="));
    V = Mid(Cmd, InStr(Cmd, "=") + 1);
    T = CurrSecondaryWeaponAttachment.Mesh.Translation;
    R = CurrSecondaryWeaponAttachment.Mesh.Rotation;
    S = CurrSecondaryWeaponAttachment.Mesh.Scale3D;
    sc = CurrSecondaryWeaponAttachment.Mesh.Scale;
    // End:0xD6
    if(C ~= "x")
    {
        T.X += float(V);
    }
    // End:0xFC
    if(C ~= "ax")
    {
        T.X = float(V);
    }
    // End:0x122
    if(C ~= "y")
    {
        T.Y += float(V);
    }
    // End:0x148
    if(C ~= "ay")
    {
        T.Y = float(V);
    }
    // End:0x16E
    if(C ~= "z")
    {
        T.Z += float(V);
    }
    // End:0x194
    if(C ~= "az")
    {
        T.Z = float(V);
    }
    // End:0x1BA
    if(C ~= "r")
    {
        R.Roll += int(V);
    }
    // End:0x1E0
    if(C ~= "ar")
    {
        R.Roll = int(V);
    }
    // End:0x206
    if(C ~= "p")
    {
        R.Pitch += int(V);
    }
    // End:0x22C
    if(C ~= "ap")
    {
        R.Pitch = int(V);
    }
    // End:0x252
    if(C ~= "w")
    {
        R.Yaw += int(V);
    }
    // End:0x278
    if(C ~= "aw")
    {
        R.Yaw = int(V);
    }
    // End:0x2A2
    if(C ~= "scalex")
    {
        S.X = float(V);
    }
    // End:0x2CC
    if(C ~= "scaley")
    {
        S.Y = float(V);
    }
    // End:0x2F6
    if(C ~= "scalez")
    {
        S.Z = float(V);
    }
    // End:0x314
    if(C ~= "scale")
    {
        sc = float(V);
    }
    CurrSecondaryWeaponAttachment.Mesh.SetTranslation(T);
    CurrSecondaryWeaponAttachment.Mesh.SetRotation(R);
    CurrSecondaryWeaponAttachment.Mesh.SetScale(sc);
    CurrSecondaryWeaponAttachment.Mesh.SetScale3D(S);
    //return;    
}

event UpdateWeaponAndAttachment()
{
    WeaponAttachmentChanged();
    SecondaryWeaponAttachmentChanged();
    PrimaryWSM.Init(true);
    SecondaryWSM.Init(false);
    //return;    
}

// Export USkyPawn::execGetSecondaryEffectLocation(FFrame&, void* const)
native simulated function Vector GetSecondaryEffectLocation();

simulated function Rotator GetSecondaryEffectRotation()
{
    local Vector SocketLocation;
    local Rotator SocketRotation;

    // End:0x87
    if(((CurrSecondaryWeaponAttachment != none) && SkeletalMeshComponent(CurrSecondaryWeaponAttachment.Mesh) != none) && CurrSecondaryWeaponAttachment.MuzzleFlashSocket != 'None')
    {
        SkeletalMeshComponent(CurrSecondaryWeaponAttachment.Mesh).GetSocketWorldLocationAndRotation(CurrSecondaryWeaponAttachment.MuzzleFlashSocket, SocketLocation, SocketRotation);
        return SocketRotation;        
    }
    else
    {
        return Rotation;
    }
    //return ReturnValue;    
}

// Export USkyPawn::execSecondaryFlashCountUpdated(FFrame&, void* const)
native simulated function SecondaryFlashCountUpdated(bool bViaReplication);

simulated function SecondaryFlashLocationUpdated(bool bViaReplication)
{
    // End:0x25
    if(!IsZero(SecondaryFlashLocation))
    {
        SecondaryWeaponFired(bViaReplication, SecondaryFlashLocation);        
    }
    else
    {
        SecondaryWeaponStoppedFiring(bViaReplication);
    }
    //return;    
}

// Export USkyPawn::execSecondaryWeaponFired(FFrame&, void* const)
native simulated function SecondaryWeaponFired(bool bViaReplication, optional Vector HitLocation);

// Export USkyPawn::execSecondaryWeaponStoppedFiring(FFrame&, void* const)
native simulated function SecondaryWeaponStoppedFiring(bool bViaReplication);

reliable server function ServerGroundIntervehic(Vehicle jvt)
{
    bGoingIntervehicular = true;
    JumpVehicleTarget = jvt;
    JumpVehicleTargetCurrent = none;
    //return;    
}

simulated function ClearAirbornPhysics()
{
    bDoAirbornFiringPhysics = false;
    //return;    
}

// Export USkyPawn::execCanUseItem(FFrame&, void* const)
native function bool CanUseItem();

// Export USkyPawn::execCanPrimaryWeaponFire(FFrame&, void* const)
native function bool CanPrimaryWeaponFire(optional bool bIgnoreReload, optional bool bCheckingForTargeting);

event bool CanSecondaryItemFire()
{
    local SkySecondaryItem SecWeap;

    SecWeap = SkySecondaryItem(SecondaryWeapon);
    // End:0x38
    if((SecWeap != none) && !SecWeap.CanFire())
    {
        return false;
    }
    return (((((((((((CanUseItem()) && (IsInWalkVolume()) == false) && !bGoingIntervehicular) && !IsInteracting()) && CameraAllowsFire()) && !bGoingIntervehicular) && SecondaryWeapon.HasAnyAmmo()) && (Weapon == none) || Weapon.GetStateName() != 'Reloading') && !ThrownFromGripPoint()) && !ReleasedGripPoint()) && !ShotFromGripPoint()) && !IsTimerActive('TimedTurnOnRocketPackThrust');
    //return ReturnValue;    
}

simulated event StartSecondaryItemFire(byte FireModeNum)
{
    SecondaryWSM.FiringInput(true,, true);
    //return;    
}

simulated event StopSecondaryItemFire(byte FireModeNum)
{
    SecondaryWSM.FiringInput(false);
    //return;    
}

function CheckSecondaryItemExplodedInHand(SkyProj_SecondaryItemBase Proj)
{
    local SkySecondaryItem SecWeap;
    local SkyItem_Dynamite Dynamite;

    SecWeap = SkySecondaryItem(SecondaryWeapon);
    // End:0xE4
    if((SecWeap != none) && SecWeap.HeldItem == Proj)
    {
        SecWeap.SetItemState(2);
        SecWeap.EndFire(SecWeap.CurrentFireMode);
        SecWeap.HeldItem = none;
        bSecondaryItemReleased = true;
        SecWeap.Release();
        Dynamite = SkyItem_Dynamite(SecondaryWeapon);
        // End:0xC9
        if(Dynamite != none)
        {
            Dynamite.bThrowing = false;
        }
        SetSecondaryItemState(0);
        CheckForceDamage(Proj);
    }
    //return;    
}

function CheckForceDamage(SkyProj_SecondaryItemBase Proj)
{
    //return;    
}

// Export USkyPawn::execSetSecondaryItemState(FFrame&, void* const)
native function SetSecondaryItemState(SkyPawn.ESecondaryItemState NewState);

// Export USkyPawn::execCanCreateSecondaryItem(FFrame&, void* const)
native function bool CanCreateSecondaryItem();

simulated event StartSecondaryItemFireImmediately(byte FireModeNum)
{
    local SkySecondaryItem SecWeap;
    local SkyWeapon Weap;

    SecWeap = SkySecondaryItem(SecondaryWeapon);
    // End:0x2E
    if((SecWeap == none) || !CanCreateSecondaryItem())
    {
        return;
    }
    // End:0x130
    if((int(SecondaryItemState) == int(0)) || bSecondaryItemReleased)
    {
        SetSecondaryItemState(1);
        // End:0x71
        if(CurrSecondaryWeaponAttachment != none)
        {
            CurrSecondaryWeaponAttachment.SetHidden(false);
        }
        SecWeap.StartFire(FireModeNum);
        // End:0x130
        if(PrimaryWSM != none)
        {
            Weap = SkyWeapon(Weapon);
            // End:0xC5
            if(Weap != none)
            {
                Weap.ZoomSetOwnerNoSee(false);
            }
            PrimaryWSM.FiringInput(false);
            PrimaryWSM.TargetingInput(false);
            PrimaryWSM.ZoomingInput(false);
            PrimaryWSM.TryHolster(true);
            PrimaryWSM.TryDraw(true);
        }
    }
    //return;    
}

simulated event StopSecondaryItemFireImmediately(byte FireModeNum)
{
    local SkySecondaryItem SecWeap;

    SecWeap = SkySecondaryItem(SecondaryWeapon);
    // End:0x28
    if(bGoingIntervehicular || SecWeap == none)
    {
        return;
    }
    // End:0x59
    if(int(SecondaryItemState) != int(0))
    {
        bSecondaryItemShouldThrow = true;
        SecWeap.StopFire(FireModeNum);
    }
    //return;    
}

// Export USkyPawn::execSetSecondaryFiringMode(FFrame&, void* const)
native function SetSecondaryFiringMode(byte FiringModeNum);

// Export USkyPawn::execSecondaryFiringModeUpdated(FFrame&, void* const)
native simulated function SecondaryFiringModeUpdated(bool bViaReplication);

// Export USkyPawn::execIncrementSecondaryFlashCount(FFrame&, void* const)
native function IncrementSecondaryFlashCount(Weapon Who, byte FireModeNum);

simulated function ClearSecondaryFlashCount(Weapon Who)
{
    // End:0x23
    if(int(SecondaryFlashCount) != int(0))
    {
        SecondaryFlashCount = 0;
        SecondaryFlashCountUpdated(false);
    }
    //return;    
}

function SetSecondaryFlashLocation(Weapon Who, byte FireModeNum, Vector NewLoc)
{
    // End:0x23
    if(NewLoc == SecondaryFlashLocation)
    {
        NewLoc += vect(0.0000000, 0.0000000, 1.0000000);
    }
    // End:0x4D
    if(NewLoc == vect(0.0000000, 0.0000000, 0.0000000))
    {
        NewLoc = vect(0.0000000, 0.0000000, 1.0000000);
    }
    SecondaryFlashLocation = NewLoc;
    SetSecondaryFiringMode(FireModeNum);
    SecondaryFlashLocationUpdated(false);
    //return;    
}

simulated function TossSecondaryWeapon()
{
    local Inventory Item;
    local SkyWeapon SW;

    Item = InvManager.InventoryChain;
    J0x15:

    // End:0xBB [Loop If]
    if(Item != none)
    {
        SW = SkyWeapon(Item);
        // End:0x6A
        if((SW == none) || !SW.bIsSecondaryWeapon)
        {
            Item = Item.Inventory;            
        }
        else
        {
            Item.DropFrom(Location + (Vector(Rotation) * CylinderComponent.CollisionRadius), Velocity);
            SecondaryWSM.Discard();
            return;
        }
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

simulated function bool HasSecondary(class<SkyWeapon> SecClass)
{
    local Inventory Item;
    local SkyWeapon SW;

    Item = InvManager.InventoryChain;
    J0x15:

    // End:0x83 [Loop If]
    if(Item != none)
    {
        SW = SkyWeapon(Item);
        // End:0x6B
        if((SW != none) && SW.bIsSecondaryWeapon)
        {
            // End:0x6B
            if(SW.Class == Class)
            {
                return true;
            }
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x15;
    }
    return false;
    //return ReturnValue;    
}

function byte ChooseSecondaryFireMode()
{
    // End:0x2A
    if(SkyWeapon(SecondaryWeapon) != none)
    {
        return SkyWeapon(SecondaryWeapon).BestMode();
    }
    return 0;
    //return ReturnValue;    
}

simulated function SetSecondaryWeaponVisibility(bool bWeaponVisible, bool bAttachmentVisible)
{
    local int I;
    local SkyWeapon Weap;
    local editinline SkeletalMeshComponent AttachmentMesh;
    local editinline PrimitiveComponent Primitive;

    Weap = SkyWeapon(SecondaryWeapon);
    // End:0x52
    if(Weap != none)
    {
        // End:0x52
        if(Weap.Mesh != none)
        {
            Weap.Mesh.SetHidden(!bWeaponVisible);
        }
    }
    // End:0x134
    if((CurrSecondaryWeaponAttachment != none) && CurrSecondaryWeaponAttachment.Mesh != none)
    {
        CurrSecondaryWeaponAttachment.Mesh.SetOwnerNoSee(!bAttachmentVisible);
        AttachmentMesh = SkeletalMeshComponent(CurrSecondaryWeaponAttachment.Mesh);
        // End:0x134
        if(AttachmentMesh != none)
        {
            I = 0;
            J0xC2:

            // End:0x134 [Loop If]
            if(I < AttachmentMesh.Attachments.Length)
            {
                Primitive = PrimitiveComponent(AttachmentMesh.Attachments[I].Component);
                // End:0x12A
                if(Primitive != none)
                {
                    Primitive.SetOwnerNoSee(!bAttachmentVisible);
                }
                I++;
                // [Loop Continue]
                goto J0xC2;
            }
        }
    }
    //return;    
}

simulated event StartDriving(Vehicle V)
{
    super.StartDriving(V);
    DeactivateSpawnProtection();
    PrimaryWSM.TryHolster(true);
    SecondaryWSM.TryHolster(true);
    LegMesh.SetShadowParent(V.Mesh);
    HeadMesh.SetShadowParent(V.Mesh);
    HairMesh.SetShadowParent(V.Mesh);
    //return;    
}

simulated event StopDriving(Vehicle V)
{
    local SkyPlayerController SPC;

    super.StopDriving(V);
    // End:0x1F
    if(bWantsToCrouch)
    {
        ShouldCrouch(false);
    }
    // End:0x3B
    if(CurrSecondaryWeaponAttachment != none)
    {
        CurrSecondaryWeaponAttachment.SetHidden(false);
    }
    // End:0x61
    if(SkyWeapon(SecondaryWeapon) != none)
    {
        SkyWeapon(SecondaryWeapon).SetHidden(false);
    }
    // End:0x7D
    if(CurrWeaponAttachment != none)
    {
        CurrWeaponAttachment.SetHidden(false);
    }
    SetLocation(Location);
    // End:0xBA
    if((SkyAirVehicle(V) != none) && SkyAirVehicle_RocketPackThrust(V) == none)
    {
        SetTimer(LeftAirplaneJackGravityDelay, false, 'LeftAirplaneJackGravity');
    }
    // End:0xDA
    if(LegMesh != none)
    {
        LegMesh.SetShadowParent(Mesh);
    }
    // End:0xFA
    if(HeadMesh != none)
    {
        HeadMesh.SetShadowParent(Mesh);
    }
    // End:0x11A
    if(HairMesh != none)
    {
        HairMesh.SetShadowParent(Mesh);
    }
    // End:0x1A4
    if(SkyAirVehicle_RocketPackThrust(V) != none)
    {
        TurnOffRocketPackThrust();
        SPC = SkyPlayerController(Controller);
        // End:0x1A1
        if(SPC != none)
        {
            SkyPlayerInput(SPC.PlayerInput).InputKey(LocalPlayer(SPC.Player).ControllerId, 'XboxTypeS_Y', 1, 0.0000000, true);
        }        
    }
    else
    {
        PrimaryWSM.TryDraw();
    }
    //return;    
}

function LeftAirplaneJackGravity()
{
    CustomGravityScaling = LeftAirplaneJackGravityScale;
    SetTimer(LeftAirplaneFixGravityDelay, false, 'LeftAirplaneFixGravity');
    //return;    
}

function LeftAirplaneFixGravity()
{
    CustomGravityScaling = 1.0000000;
    //return;    
}

function NotifyStunFinished()
{
    //return;    
}

// Export USkyPawn::execAdjustDamage(FFrame&, void* const)
native function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo);

function SetSecondaryHand(SkyPawnBase.ESkyWeaponHand NewWeaponHand)
{
    SecondaryWeaponHand = NewWeaponHand;
    //return;    
}

// Export USkyPawn::execGetWeaponStartTraceLocation(FFrame&, void* const)
native simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon);

// Export USkyPawn::execCanPlayTakeHitPhysicsAnimation(FFrame&, void* const)
native simulated function bool CanPlayTakeHitPhysicsAnimation();

// Export USkyPawn::execPlayTakeHitEffects(FFrame&, void* const)
native simulated function PlayTakeHitEffects();

// Export USkyPawn::execPlayExitWoundEffects(FFrame&, void* const)
native simulated function PlayExitWoundEffects(Vector CurrHitLocation, Vector CurrMomentum, class<DamageType> CurrDamageType, optional TraceHitInfo CurrHitInfo, optional bool bSkipDamageTypeCheck);

event TriggerBleedOut()
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal, TraceStart, TraceEnd;
    local TraceHitInfo HitInfo;
    local MaterialInstanceConstant MatInst;
    local float Size;

    // End:0x2C
    if(VSizeSq(Velocity) > Square(FeignDeathBodyAtRestSpeed))
    {
        SetTimer(0.1000000, false, 'TriggerBleedOut');
        return;
    }
    TraceStart = ((Mesh != none) ? Mesh.GetBoneLocation(BleedOutDecalBoneToSpawnFrom, 0) + vect(0.0000000, 0.0000000, 50.0000000) : Location);
    TraceEnd = TraceStart;
    TraceEnd.Z -= ((GetCollisionHeight()) * 2.0000000);
    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false, vect(0.0000000, 0.0000000, 0.0000000), HitInfo);
    // End:0x193
    if(HitActor != none)
    {
        MatInst = new (Outer) Class'Engine.MaterialInstanceConstant';
        MatInst.SetParent(BleedOutDecalMaterial);
        Size = BleedOutDecalMinSize + ((BleedOutDecalMaxSize - BleedOutDecalMinSize) * FRand());
        WorldInfo.MyDecalManager.SpawnDecal(MatInst, HitLocation + (HitNormal * 5.0000000), Rotator(-HitNormal), Size, Size, BleedOutDecalDepth, false, FRand() * 360.0000000, none, false, false, 'None', -1, -1);
    }
    //return;    
}

simulated function bool IsRagdollProhibited()
{
    local SkyPawnCoverUser SPCU;

    // End:0xA5
    foreach WorldInfo.AllPawns(Class'SkyPawnCoverUser', SPCU, Location, (GetCollisionHeight()) * 2.0000000)
    {
        // End:0xA4
        if(((SPCU != self) && SPCU.HasStartedVerticalMantle()) && VSize2D(SPCU.Location - Location) <= (2.0000000 * ((GetCollisionRadius()) + SPCU.GetCollisionRadius())))
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

simulated function bool FindGoodLocation()
{
    local Vector HitLocation, HitNormal, TraceStart, TraceEnd, DesiredLocation, StepHeightCorrection,
	    TraceDir, TracePos;

    local float Height, Radius, RAD, ang;
    local Vector BestLocation, Extent;
    local float bestDist;
    local bool OldCylCollide, OldMeshCollide, OldHitCollide;

    Height = GetCollisionHeight();
    Extent = GetCollisionExtent();
    Radius = GetCollisionRadius();
    StepHeightCorrection = vect(0.0000000, 0.0000000, 2.1500000);
    DesiredLocation = Location + (vect(0.0000000, 0.0000000, 1.0000000) * Height);
    TracePos = Location;
    OldCylCollide = CylinderComponent.CollideActors;
    OldMeshCollide = Mesh.CollideActors;
    OldHitCollide = HitBoundingComponent.CollideActors;
    CylinderComponent.SetActorCollision(true, CylinderComponent.BlockActors);
    Mesh.SetActorCollision(false, Mesh.BlockActors);
    HitBoundingComponent.SetActorCollision(false, HitBoundingComponent.BlockActors);
    bestDist = 99999.0000000;
    RAD = 0.0000000;
    J0x12C:

    // End:0x2B9 [Loop If]
    if(RAD < (1.5000000 * Radius))
    {
        ang = 0.0000000;
        J0x14D:

        // End:0x2AA [Loop If]
        if(ang < 6.2820000)
        {
            TraceDir.X = RAD * Cos(ang);
            TraceDir.Y = RAD * Sin(ang);
            TraceDir.Z = 0.0000000;
            TraceStart = (TracePos + TraceDir) + ((vect(0.0000000, 0.0000000, 1.0000000) * Height) * 1.5000000);
            TraceEnd = (TracePos + TraceDir) - (vect(0.0000000, 0.0000000, 1.0000000) * float(20));
            // End:0x288
            if(Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true, Extent) != none)
            {
                // End:0x288
                if(HitLocation != TraceStart)
                {
                    HitLocation += StepHeightCorrection;
                    // End:0x288
                    if(SetLocation(HitLocation))
                    {
                        // End:0x288
                        if(VSize(Location - DesiredLocation) < bestDist)
                        {
                            BestLocation = HitLocation;
                            bestDist = VSize(Location - DesiredLocation);
                        }
                    }
                }
            }
            ang += ((5.0000000 * 6.2820000) / (RAD + float(1)));
            // [Loop Continue]
            goto J0x14D;
        }
        RAD += Radius;
        // [Loop Continue]
        goto J0x12C;
    }
    SetLocation(BestLocation);
    CylinderComponent.SetActorCollision(OldCylCollide, CylinderComponent.BlockActors);
    Mesh.SetActorCollision(OldMeshCollide, Mesh.BlockActors);
    HitBoundingComponent.SetActorCollision(OldHitCollide, HitBoundingComponent.BlockActors);
    return bestDist < Height;
    //return ReturnValue;    
}

simulated function SequenceByBoneRotationOnBecomeRelevant()
{
    // End:0x2D
    if(!FindGoodLocation())
    {
        Health = 0;
        Died(LastHitBy, none, Location);
        return;
    }
    //return;    
}

simulated event PlayFeignDeath(optional bool bDontResetPhysicsOnGetup)
{
    local Rotator NewRotation;

    // End:0x124
    if(bFeigningDeath)
    {
        // End:0x121
        if(!IsRagdollProhibited())
        {
            GotoState('FeigningDeath');
            Mesh.SetPhysicsAsset(RagdollPhysicsAsset);
            Mesh.ForceSkelUpdate();
            bBlendOutTakeHitPhysics = false;
            // End:0x121
            if(InitRagdoll())
            {
                Mesh.bUpdateJointsFromAnimation = true;
                Mesh.bUpdateKinematicBonesFromAnimation = false;
                FeignDeathStartTime = WorldInfo.TimeSeconds - 1.0000000;
                Mesh.SetTranslation(default.Mesh.Translation);
                Mesh.ScriptRigidBodyCollisionThreshold = MaxFallSpeed;
                Mesh.SetNotifyRigidBodyCollision(true);
                // End:0x121
                if(int(Role) == int(ROLE_Authority))
                {
                    SetTimer(0.5000000, true, 'FeignDeathDelayTimer');
                    SetTimer(FeignDeathKillTime, false, 'FeignDeathTimeoutTimer');
                }
            }
        }        
    }
    else
    {
        bPlayingFeignDeathRecovery = true;
        FeignDeathRecoveryStartTime = WorldInfo.TimeSeconds;
        Mesh.SetNotifyRigidBodyCollision(false);
        // End:0x162
        if(!bDontResetPhysicsOnGetup)
        {
            SetPhysics(0);
        }
        Mesh.SetAnimTreeTemplate(Mesh.AnimTreeTemplate);
        Mesh.PhysicsWeight = 1.0000000;
        NewRotation.Yaw = Rotator(Mesh.GetBoneAxis('j_spine_1', 4)).Yaw + 32768;
        // End:0x21D
        if(Mesh.GetBoneAxis('j_spine_1', 1).Z < 0.0000000)
        {
            NewRotation.Yaw += 32768;
        }
        NewRotation.Pitch = 0;
        SetRotation(NewRotation);
    }
    //return;    
}

// Export USkyPawn::execExplosionNotify(FFrame&, void* const)
native function ExplosionNotify(Vector HitLocation, Vector HitNormal, class<DamageType> DamageType);

exec event DoForceRagdoll()
{
    ForceRagdoll();
    //return;    
}

simulated function Vector GetPawnViewLocation()
{
    return Location + (vect(0.0000000, 0.0000000, 1.0000000) * BaseEyeHeight);
    //return ReturnValue;    
}

function bool CanDuck()
{
    return (((((((!IsFalling() && !IsSprinting()) && !IsMelee()) && !IsHijacking()) && !IsInteracting()) && !IsGripping()) && !ThrownFromGripPoint()) && !ReleasedGripPoint()) && !ShotFromGripPoint();
    //return ReturnValue;    
}

function bool CanSprint()
{
    local SkyPlayerController SPC;

    // End:0x0D
    if(ForceTargetingRefCount > 0)
    {
        return false;
    }
    // End:0x1A
    if(Weapon == none)
    {
        return false;
    }
    // End:0x46
    if((SkyWeaponBase(Weapon) != none) && SkyWeaponBase(Weapon).bIsLargeWeapon)
    {
        return false;
    }
    // End:0x55
    if(UsingSecondaryItem())
    {
        return false;
    }
    // End:0x64
    if(IsInWalkVolume())
    {
        return false;
    }
    // End:0x73
    if(IsSprinting())
    {
        return false;
    }
    SPC = SkyPlayerController(Controller);
    // End:0xA7
    if((SPC == none) || !SPC.bAllowSprint)
    {
        return false;
    }
    return (((((((((((!SprintDisable && !bIsCrouched) && !bIsHindered) && SprintTime > 0.0000000) && !IsFreefalling()) && !IsMelee()) && !IsInteracting()) && !IsPickingUp()) && !IsGripping()) && !IsGliding()) && !ThrownFromGripPoint()) && !ReleasedGripPoint()) && !ShotFromGripPoint();
    //return ReturnValue;    
}

// Export USkyPawn::execIsSprinting(FFrame&, void* const)
native simulated function bool IsSprinting();

simulated event StartSprint(int Mode)
{
    local SkyPlayerController SPC;
    local SkyPlayerInput SPI;
    local Vector StickVec;
    local SkyWeapon SW;

    // End:0x11
    if(!CanSprint())
    {
        return;
    }
    SPC = SkyPlayerController(Controller);
    // End:0x2E
    if(SPC == none)
    {
        return;
    }
    SPI = SkyPlayerInput(SPC.PlayerInput);
    // End:0x55
    if(SPI == none)
    {
        return;
    }
    // End:0x74
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStartSprint(Mode);
    }
    // End:0x101
    if(Mode == 1)
    {
        StickVec.X = SPI.RawJoyUp - SprintStickConeOffset;
        StickVec.Y = SPI.RawJoyRight;
        StickVec = Normal(StickVec);
        // End:0xFC
        if((StickVec Dot vect(1.0000000, 0.0000000, 0.0000000)) > SprintStickConeAngle)
        {
            bSprintingMode2 = true;            
        }
        else
        {
            return;
        }        
    }
    else
    {
        bSprintingMode2 = false;
    }
    SW = SkyWeapon(Weapon);
    // End:0x1AF
    if(PrimaryWSM != none)
    {
        PrimaryWSM.FiringInput(false);
        PrimaryWSM.TargetingInput(false);
        PrimaryWSM.ZoomingInput(false);
        PrimaryWSM.TryHolster(true);
        PrimaryWSM.TryDraw(true);
        // End:0x1AF
        if(SW != none)
        {
            SW.ZoomSetOwnerNoSee(false);
        }
    }
    SPC.bAttemptingSprint = false;
    SPI.bSprint = 1;
    SprintState = 1;
    // End:0x205
    if(SkyPawnSoundGroup(SoundGroup) != none)
    {
        SkyPawnSoundGroup(SoundGroup).PlayStartSprintSound(self);
    }
    // End:0x220
    if(SprintingSound != none)
    {
        SprintingSound.Play();
    }
    ClearTimer('StopSprintTimer');
    //return;    
}

reliable server function ServerStartSprint(int Mode)
{
    StartSprint(Mode);
    //return;    
}

simulated event StopSprint()
{
    local SkyPlayerController SPC;
    local SkyPlayerInput SPI;

    // End:0x11
    if(!IsSprinting())
    {
        return;
    }
    SPC = SkyPlayerController(Controller);
    // End:0x2E
    if(SPC == none)
    {
        return;
    }
    SPI = SkyPlayerInput(SPC.PlayerInput);
    // End:0x55
    if(SPI == none)
    {
        return;
    }
    // End:0x6F
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStopSprint();
    }
    SprintingSound.Stop();
    // End:0xA9
    if(SkyPawnSoundGroup(SoundGroup) != none)
    {
        SkyPawnSoundGroup(SoundGroup).PlayStopSprintSound(self);
    }
    // End:0xE3
    if((int(SprintState) == int(1)) && !IsTimerActive('StopSprintTimer'))
    {
        SetTimer(StopSprintDelay, false, 'StopSprintTimer');
    }
    SPI.bSprint = 0;
    bSprintingMode2 = false;
    //return;    
}

reliable server function ServerStopSprint()
{
    StopSprint();
    //return;    
}

simulated exec event StopSprintTimer()
{
    local bool bAttemptDuck;
    local SkyPlayerInput SPI;

    SPI = SkyPlayerInput(PlayerController(Controller).PlayerInput);
    // End:0x5A
    if(SPI != none)
    {
        bAttemptDuck = (int(SPI.bPosture) != int(0)) && int(SprintState) == int(2);
    }
    SprintState = 0;
    // End:0x8C
    if((SPI != none) && bAttemptDuck)
    {
        SPI.Duck();
    }
    //return;    
}

simulated function PlayHeavyBreathing()
{
    BreathingSound.Play();
    //return;    
}

function bool CanSprintDive()
{
    // End:0x93
    if((((((((((IsMelee()) || bIsCrouched) || int(SprintState) != int(1)) || IsFalling()) || IsInteracting()) || !IsPickingUp()) || IsGripping()) || ThrownFromGripPoint()) || ReleasedGripPoint()) || ShotFromGripPoint())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function SprintDive()
{
    ClearTimer('StopSprintTimer');
    SprintState = 2;
    SetFallState(FallState);
    //return;    
}

// Export USkyPawn::execIsFalling(FFrame&, void* const)
native function bool IsFalling();

// Export USkyPawn::execIsMelee(FFrame&, void* const)
native function bool IsMelee();

simulated function StartJump()
{
    SetFallState(1);
    //return;    
}

simulated event BotLaunchJump()
{
    // End:0x34
    if(bWaitingOnJumpLaunch)
    {
        Velocity = DesiredJumpVelocity;
        SetPhysics(2);
        bWaitingOnJumpLaunch = false;
        DesiredJumpVelocity = vect(0.0000000, 0.0000000, 0.0000000);
    }
    //return;    
}

// Export USkyPawn::execIsPrimaryWeaponDrawn(FFrame&, void* const)
native function bool IsPrimaryWeaponDrawn();

simulated event bool IsArmed()
{
    // End:0x69
    if((((Weapon == none) || Weapon.IsA('SkyWeap_MeleePunch')) || int(PrimaryWSM.GetState()) == int(6)) || int(PrimaryWSM.GetState()) == int(4))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated event bool IsAimingSecondary()
{
    // End:0x47
    if(SkySecondaryItem(SecondaryWeapon) != none)
    {
        return SkySecondaryItem(SecondaryWeapon).UsingMeansAiming && SkySecondaryItem(SecondaryWeapon).IsInUse();        
    }
    else
    {
        // End:0x80
        if(SecondaryWeapon != none)
        {
            return SecondaryWeapon.HasAnyAmmo() && SecondaryWeapon.IsFiring();
        }
    }
    return false;
    //return ReturnValue;    
}

simulated event bool IsShooting()
{
    local int I;

    // End:0x0F
    if(IsAimingSecondary())
    {
        return true;
    }
    I = 0;
    J0x16:

    // End:0xA0 [Loop If]
    if(I < AuxWeapons.Length)
    {
        // End:0x96
        if(AuxWeapons[I].Instance != none)
        {
            // End:0x96
            if(AuxWeapons[I].Instance.HasAnyAmmo() && AuxWeapons[I].Instance.IsFiring())
            {
                return true;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x16;
    }
    // End:0xC7
    if((Weapon == none) || Weapon.IsA('SkyWeap_MeleePunch'))
    {
        return false;
    }
    // End:0xFD
    if(!Weapon.HasAnyAmmo() || !Weapon.IsFiring())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

// Export USkyPawn::execCameraAllowsFire(FFrame&, void* const)
native simulated function bool CameraAllowsFire();

simulated function StartFire(byte FireModeNum)
{
    PrimaryWSM.FiringInput(true, FireModeNum);
    //return;    
}

simulated event StopFire(byte FireModeNum)
{
    PrimaryWSM.FiringInput(false);
    //return;    
}

simulated event StartFireImmediately(byte FireModeNum)
{
    StartFire(FireModeNum);
    // End:0x2A
    if(CurrWeaponAttachment != none)
    {
        CurrWeaponAttachment.StartRumble();
    }
    //return;    
}

simulated event StopFireImmediately(byte FireModeNum)
{
    StopFire(FireModeNum);
    //return;    
}

simulated event Vector GetAimVector()
{
    // End:0x2A
    if(SkyPlayerController(Controller) != none)
    {
        return SkyPlayerController(Controller).GetAimVector();
    }
    return Vector(GetViewRotation());
    //return ReturnValue;    
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
    // End:0x55
    if(((RequestedBy != none) && RequestedBy.PlayerCamera != none) && RequestedBy.PlayerCamera.CameraStyle == 'Fixed')
    {
        return 'Fixed';
    }
    return 'FirstPerson';
    //return ReturnValue;    
}

// Export USkyPawn::execFaceRotation(FFrame&, void* const)
native function FaceRotation(Rotator NewRotation, float DeltaTime);

// Export USkyPawn::execUpdateYawRotationSpeed(FFrame&, void* const)
native function UpdateYawRotationSpeed(float DeltaTime);

simulated function Vector EyePosition()
{
    local Vector X, Y, Z, EyePos;

    GetAxes(Rotation, X, Y, Z);
    EyePos = ((EyeOffset.X * X) + (EyeOffset.Y * Y)) + (EyeOffset.Z * Z);
    return (EyeHeight * vect(0.0000000, 0.0000000, 1.0000000)) + EyePos;
    //return ReturnValue;    
}

// Export USkyPawn::execGetActorEyesViewPoint(FFrame&, void* const)
native simulated function GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation);

// Export USkyPawn::execGetViewRotation(FFrame&, void* const)
native simulated event Rotator GetViewRotation();

simulated function ProcessViewRotation(float fDeltaTime, out Rotator rOutViewRot, out Rotator rOutDeltaRot)
{
    local SkyPlayerController pSPC;
    local SkyCamera pCamera;

    // End:0x2C
    if(bGoingIntervehicular)
    {
        rOutViewRot += rOutDeltaRot;
        rOutDeltaRot = rot(0, 0, 0);        
    }
    else
    {
        pSPC = SkyPlayerController(Controller);
        // End:0x61
        if(pSPC != none)
        {
            pCamera = SkyCamera(pSPC.PlayerCamera);
        }
        // End:0xCB
        if(pCamera != none)
        {
            ViewPitchMin = (pCamera.CameraInfo.CamPitchMin / 360.0000000) * 65536.0000000;
            ViewPitchMax = (pCamera.CameraInfo.CamPitchMax / 360.0000000) * 65536.0000000;            
        }
        else
        {
            // End:0xF3
            if(!IsFreefalling())
            {
                ViewPitchMin = default.ViewPitchMin;
                ViewPitchMax = default.ViewPitchMax;                
            }
            else
            {
                ViewPitchMin = FreefallViewPitchMin;
                ViewPitchMax = FreefallViewPitchMax;
            }
        }
        rOutDeltaRot = rot(0, 0, 0);
    }
    //return;    
}

simulated function bool CalcThirdPersonCam(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector Loc, pos, HitLocation, HitNormal;
    local Rotator Rot;
    local Actor HitActor;

    // End:0x11D
    if(PlayerController(Controller) != none)
    {
        GetActorEyesViewPoint(Loc, Rot);
        // End:0x6A
        if(PlayerController(Controller).PlayerCamera.CameraStyle == 'FreeCam')
        {
            Rot = PlayerController(Controller).Rotation;
        }
        pos = Loc - (Vector(Rot) * float(0));
        HitActor = Trace(HitLocation, HitNormal, pos, Loc, false, vect(0.0000000, 0.0000000, 0.0000000));
        // End:0xD6
        if(HitActor != none)
        {
            Loc = HitLocation + (HitNormal * float(2));            
        }
        else
        {
            Loc = pos;
        }
        out_CamLoc = Loc;
        out_CamRot = Rot;
        out_FOV = PlayerController(Controller).PlayerCamera.DefaultFOV;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool DoJump(bool bUpdating)
{
    // End:0x157
    if(((bJumpCapable && !bIsCrouched) && !bWantsToCrouch) && ((int(Physics) == int(1)) || int(Physics) == int(9)) || int(Physics) == int(8))
    {
        // End:0x91
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x91
            if(InvManager != none)
            {
                InvManager.OwnerEvent('Jumped');
            }
        }
        // End:0xC6
        if(RocketPack != none)
        {
            Velocity.Z = default.JumpZ * RocketPack.JumpZModifier;            
        }
        else
        {
            Velocity.Z = default.JumpZ;
        }
        // End:0x150
        if(((Base != none) && !Base.bWorldGeometry) && Base.Velocity.Z > 0.0000000)
        {
            Velocity.Z += Base.Velocity.Z;
        }
        SetPhysics(2);
        return true;
    }
    return false;
    //return ReturnValue;    
}

event nativeAddInv()
{
    AddDefaultInventory();
    //return;    
}

function AddDefaultInventory()
{
    local int I;

    // End:0x54
    if((WorldInfo.WorldInfo.GetCPManager() != none) && WorldInfo.WorldInfo.GetCPManager().bLoadingCheckpoint)
    {
        return;
    }
    // End:0x68
    if(FindInventoryType(Class'Engine.Inventory', true) != none)
    {
        return;
    }
    I = 0;
    J0x6F:

    // End:0xC7 [Loop If]
    if(I < DefaultInventory.Length)
    {
        // End:0xBD
        if(FindInventoryTypeByArch(DefaultInventory[I]) == none)
        {
            CreateInventory(DefaultInventory[I].Class, true, DefaultInventory[I]);
        }
        I++;
        // [Loop Continue]
        goto J0x6F;
    }
    AddParachuteToInv();
    AddRocketPackToInv();
    super.AddDefaultInventory();
    UpdateWeaponAndAttachment();
    SpawnAndAttachAuxWeapons();
    //return;    
}

simulated function AddRocketPackToInv()
{
    // End:0x1C
    if(RocketPackArchetype != none)
    {
        CreateInventory(Class'SkyItem_RocketPack', true, RocketPackArchetype);
    }
    //return;    
}

simulated event AddParachuteToInv()
{
    //return;    
}

function bool NeedsAmmo(Weapon Weap)
{
    local SkyWeapon SkyWeap;

    SkyWeap = SkyWeapon(Weap);
    // End:0x70
    if(SkyWeap != none)
    {
        return (SkyWeap.AmmoCount != SkyWeap.MaxAmmoCount) || SkyWeap.AdditionalAmmo != SkyWeapon(Weap.ObjectArchetype).AdditionalAmmo;
    }
    return false;
    //return ReturnValue;    
}

function bool ShouldFillAmmo()
{
    return (((NeedsAmmo(Weapon)) || NeedsAmmo(BackWeapon)) || NeedsAmmo(SecondaryWeapon)) || NeedsAmmo(PrevWeapon);
    //return ReturnValue;    
}

event FillAmmo()
{
    // End:0x1B
    if(AmmoCachePickupSound != none)
    {
        PlaySound(AmmoCachePickupSound);
    }
    // End:0x45
    if(SkyWeapon(Weapon) != none)
    {
        SkyWeapon(Weapon).Loaded(true);
    }
    // End:0x6F
    if(SkyWeapon(BackWeapon) != none)
    {
        SkyWeapon(BackWeapon).Loaded(true);
    }
    // End:0x99
    if(SkyWeapon(SecondaryWeapon) != none)
    {
        SkyWeapon(SecondaryWeapon).Loaded(true);
    }
    // End:0xC3
    if(SkyWeapon(PrevWeapon) != none)
    {
        SkyWeapon(PrevWeapon).Loaded(true);
    }
    // End:0x11D
    if((PlayerController(Controller) != none) && SkyHUD(PlayerController(Controller).myHUD) != none)
    {
        SkyHUD(PlayerController(Controller).myHUD).HudIdleTime = 0.0000000;
    }
    //return;    
}

function OnFillAmmo(SkySeqAct_FillAmmo Action)
{
    FillAmmo();
    //return;    
}

simulated function GiveInventoryByArchList(string InvArchetypeString, bool bClearExisting, array<Inventory> InvList)
{
    local int I;
    local class<Inventory> InvClass;
    local bool bGivingSecondary;

    // End:0x3E
    if(bClearExisting)
    {
        DesiredInvList.Length = 0;
        InvManager.DiscardInventory();
        // End:0x3B
        if(RocketPack != none)
        {
            DropRocketPack(true);
        }        
    }
    else
    {
        bGivingSecondary = false;
        I = 0;
        J0x4D:

        // End:0xA5 [Loop If]
        if(I < InvList.Length)
        {
            // End:0x9B
            if((SkyWeapon(InvList[I]) != none) && SkyWeapon(InvList[I]).bIsSecondaryWeapon)
            {
                bGivingSecondary = true;
            }
            ++I;
            // [Loop Continue]
            goto J0x4D;
        }
        // End:0xD7
        if(bGivingSecondary)
        {
            // End:0xD7
            if(SkyInventoryManager(InvManager) != none)
            {
                SkyInventoryManager(InvManager).DiscardSecondaryInventory();
            }
        }
    }
    I = 0;
    J0xDE:

    // End:0x181 [Loop If]
    if(I < InvList.Length)
    {
        InvClass = InvList[I].Class;
        // End:0x139
        if(SkyItem_RocketPack(InvList[I]) != none)
        {
            CreateInventory(InvClass, true, InvList[I]);
            // [Explicit Continue]
            goto J0x177;
        }
        // End:0x177
        if(InvClass != none)
        {
            // End:0x177
            if(FindInventoryType(InvClass, false) == none)
            {
                CreateInventory(InvClass, true, InvList[I]);
                UpdateWeaponAndAttachment();
            }
        }
        J0x177:

        ++I;
        // [Loop Continue]
        goto J0xDE;
    }
    //return;    
}

simulated function OnGiveInventoryByArch(SkySeqAct_GiveInventoryByArch inAction)
{
    // DebugMode: 0
    assert(inAction.InvArchetypeList.Length > 0);
    GiveInventoryByArchList(inAction.InvArchetypeString, inAction.bClearExisting, inAction.InvArchetypeList);
    //return;    
}

final simulated function Inventory FindInventoryTypeByArch(Inventory DesiredClassArch)
{
    return ((SkyInventoryManager(InvManager) != none) ? SkyInventoryManager(InvManager).FindInventoryTypeByArch(DesiredClassArch) : none);
    //return ReturnValue;    
}

exec function EditPlayer()
{
    local string Command;

    Command = "editactor name=" $ string(self.Name);    
    ConsoleCommand(Command);
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    local name BoneName;
    local Vector BoneLoc, tempVec;
    local Rotator targetRot;
    local SkyPawn SP;
    local float savex, savey, XPos, BarWidth, barHeight;

    local SkyPlayerController SPC;
    local SkyPlayerInput SPI;
    local int I;

    super.DisplayDebug(HUD, out_YL, out_YPos);
    XPos = 4.0000000;
    SPC = SkyPlayerController(Controller);
    // End:0x79
    if(((SPC == none) && DrivenVehicle != none) && DrivenVehicle.Driver != none)
    {
        SPC = SkyPlayerController(DrivenVehicle.Controller);
    }
    // End:0x9E
    if(SPC != none)
    {
        SPI = SkyPlayerInput(SPC.PlayerInput);
    }
    Canvas = HUD.Canvas;
    // End:0xEC
    if(HUD.ShouldDisplayDebug('States'))
    {
        DrawDebugStates(Canvas, out_YL, out_YPos);
    }
    // End:0x374
    if(HUD.ShouldDisplayDebug('Speed'))
    {
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("GroundSpeed " $ string(GroundSpeed)) $ ",  YawRotationSpeed ") $ string(YawRotationSpeed));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("Acceleration " $ string(VSize(Acceleration))) $ "/") $ string(AccelRate));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        // End:0x290
        if(PlayerController(Controller) != none)
        {
            Canvas.DrawText("MoveForwardSpeed " $ string(PlayerController(Controller).PlayerInput.MoveForwardSpeed));
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
        Canvas.DrawText((("TerminalVelocity " $ string(CurrentTerminalVelocity)) $ ", PhysicsVolume ") $ string(PhysicsVolume != none));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("AirSpeed " $ string(AirSpeed)) $ ", Default AirSpeed ") $ string(default.AirSpeed));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0x42D
    if(HUD.ShouldDisplayDebug('Sprint'))
    {
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.DrawText(((((("SprintTime: " $ string(SprintTime)) $ "/") $ string(default.SprintTime)) $ " (") $ string((SprintTime / default.SprintTime) * 100.0000000)) $ "%)");
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    savex = Canvas.CurX;
    savey = out_YPos;
    // End:0x94F
    if(HUD.ShouldDisplayDebug('Hijack'))
    {
        Canvas.SetDrawColor(128, 0, 0);
        out_YPos = 200.0000000;
        Canvas.SetPos(400.0000000, out_YPos);
        Canvas.DrawText((("bGoingIntervehicular: " $ string(bGoingIntervehicular)) $ ", IsHijacking: ") $ string(IsHijacking()));
        out_YPos += out_YL;
        Canvas.SetPos(400.0000000, out_YPos);
        Canvas.DrawText((((((("HijackTarget: " $ string(HijackTarget)) $ ", ") $ string(HijackOpponent)) $ "(") $ string(((HijackOpponent == none) ? 0 : HijackOpponent.Health))) $ "), JumpVehicleTarget: ") $ string(JumpVehicleTarget));
        out_YPos += out_YL;
        Canvas.SetPos(400.0000000, out_YPos);
        // End:0x657
        if(HijackTarget != none)
        {
            Canvas.DrawText(((((("Hijackee: (" $ string(HijackTarget.Location)) $ ") - Hijacker: (") $ string(Location)) $ ") = (") $ string(HijackTarget.Location - Location)) $ ")");            
        }
        else
        {
            // End:0x68B
            if(Hijacker != none)
            {
                Canvas.DrawText("Hijacker: " $ string(Hijacker));
            }
        }
        out_YPos += out_YL;
        Canvas.SetPos(400.0000000, out_YPos);
        Canvas.DrawText((("IsBeingHijacked: " $ string(IsBeingHijacked())) $ "/") $ string(((SkyAirVehicle(DrivenVehicle) == none) ? false : SkyAirVehicle(DrivenVehicle).IsBeingHijacked())));
        out_YPos += out_YL;
        // End:0x7CE
        if(HijackTarget != none)
        {
            Canvas.DrawText("Target is Thrashing: " $ string(HijackTarget.IsThrashing()));
            out_YPos += out_YL;
            Canvas.DrawText("Target is Stalled: " $ string(HijackTarget.IsStalled()));
            out_YPos += out_YL;
        }
        Canvas.SetPos(400.0000000, out_YPos);
        out_YPos = savey;
        // End:0x83C
        if(HijackTarget != none)
        {
            DrawDebugCoordinateSystem(HijackTarget.GetHijackInteractionStartLoc(Location), HijackTarget.GetHijackInteractionStartRot(Location), 100.0000000, false);
        }
        // End:0x94F
        if(IsGripping())
        {
            savex = Canvas.CurX;
            savey = Canvas.CurY;
            BarWidth = 200.0000000;
            barHeight = 40.0000000;
            Canvas.SetDrawColor(255, 255, 0);
            Canvas.SetPos(HUD.CenterX - (BarWidth / 2.0000000), HUD.CenterY - barHeight);
            Canvas.DrawBox(BarWidth, barHeight);
            Canvas.DrawRect(BarWidth * (GripPoint.GetPercentActionComplete() / 100.0000000), barHeight);
            Canvas.SetPos(savex, savey);
        }
    }
    // End:0x99D
    if(HUD.ShouldDisplayDebug('vanim') && DrivenVehicle != none)
    {
        ShowAnimDebug(DrivenVehicle.Mesh, Canvas);        
    }
    else
    {
        // End:0xA0A
        if(HUD.ShouldDisplayDebug('wanim'))
        {
            // End:0xA07
            if((CurrWeaponAttachment != none) && SkeletalMeshComponent(CurrWeaponAttachment.Mesh) != none)
            {
                ShowAnimDebug(SkeletalMeshComponent(CurrWeaponAttachment.Mesh), Canvas);
            }            
        }
        else
        {
            // End:0xA8C
            if(HUD.ShouldDisplayDebug('AnimTree') || HUD.ShouldDisplayDebug('Anim'))
            {
                ShowAnimDebug(self.Mesh, Canvas);
                out_YPos += out_YL;
                Canvas.SetPos(4.0000000, out_YPos);
            }
        }
    }
    ShowGammaDebug(Canvas, HUD.ShouldDisplayDebug('xgammaramp'));
    // End:0xAE7
    if(HUD.ShouldDisplayDebug('Aim'))
    {
        ShowAimDebug(Canvas);
    }
    // End:0xB21
    if(HUD.ShouldDisplayDebug('Transition'))
    {
        ShowTransitionDebug(self.Mesh, Canvas);
    }
    // End:0xB8B
    if(HUD.ShouldDisplayDebug('otheranim'))
    {
        // End:0xB8A
        foreach WorldInfo.AllPawns(Class'SkyPawn', SP)
        {
            // End:0xB89
            if(SP != self)
            {
                ShowAnimDebug(SP.Mesh, Canvas);
            }            
        }        
    }
    // End:0xBD5
    if(HUD.ShouldDisplayDebug('Notify'))
    {
        ShowNotifyDebug(self, Canvas);
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0xCFB
    if(HUD.ShouldDisplayDebug('lockedinput') && SPI != none)
    {
        Canvas.SetDrawColor(255, 150, 150);
        Canvas.SetPos(60.0000000, 220.0000000);
        Canvas.DrawTextClipped("InputLocking:");
        Canvas.CurY += float(15);
        I = 0;
        J0xC72:

        // End:0xCE1 [Loop If]
        if(I < SPI.LockedInputs.Length)
        {
            Canvas.DrawTextClipped(string(SPI.LockedInputs[I].Label));
            Canvas.CurY += float(15);
            ++I;
            // [Loop Continue]
            goto J0xC72;
        }
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0xE06
    if(HUD.ShouldDisplayDebug('Hit'))
    {
        // End:0xE06
        if(SkyWeapon(Weapon) != none)
        {
            // End:0xE06
            if(SkyWeapon(Weapon).TracerBestHitActor != none)
            {
                DrawDebugSphere(SkyWeapon(Weapon).TracerBestHitLocation, 10.0000000, 5, 0, 255, 0, false);
                // End:0xDDA
                if(Pawn(SkyWeapon(Weapon).TracerBestHitActor) != none)
                {
                    BoneName = Pawn(SkyWeapon(Weapon).TracerBestHitActor).Mesh.FindClosestBone(SkyWeapon(Weapon).TracerBestHitLocation, BoneLoc);
                }
                // End:0xE06
                if(BoneName != 'None')
                {
                    DrawDebugSphere(BoneLoc, 10.0000000, 5, 255, 255, 0, false);
                }
            }
        }
    }
    // End:0x12FB
    if(HUD.ShouldDisplayDebug('automove'))
    {
        // End:0xE94
        if(AutomoveTarget != none)
        {
            tempVec = AutomoveTarget.Location - Location;
            tempVec.Z = 0.0000000;
            // End:0xE84
            if(bAutomove_RotateAssumeTargetRotation)
            {
                targetRot = AutomoveTarget.Rotation;                
            }
            else
            {
                targetRot = Rotator(tempVec);
            }            
        }
        else
        {
            tempVec = vect(0.0000000, 0.0000000, 0.0000000);
            targetRot = Rotation;
        }
        Canvas.SetDrawColor(255, 255, 0);
        Canvas.DrawText(((((("AutomoveTarget: " $ string(AutomoveTarget)) $ " (") $ string(((AutomoveTarget != none) ? AutomoveTarget.Location : vect(-1.0000000, -1.0000000, -1.0000000)))) $ "), (") $ string(((AutomoveTarget != none) ? AutomoveTarget.Rotation : rot(-1, -1, -1)))) $ ")");
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText(((((((("Automove_TranslateDistFromTarget: " $ string(Automove_TranslateStopDistFromTarget)) $ ", Timeleft(") $ string(Automove_RotateTime)) $ "), Delta (") $ string(tempVec)) $ ") (") $ string(VSize(tempVec))) $ ")");
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText(((((((("bAutomoveTranslateToTarget: " $ string(bAutomoveTranslateToTarget)) $ ", Timeleft(") $ string(Automove_TranslateTime)) $ "), Delta (") $ string(tempVec)) $ ") (") $ string(VSize(tempVec))) $ ")");
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText(((((((("bAutomoveRotateToTarget " $ string(bAutomoveRotateToTarget)) $ ", Timeleft(") $ string(Automove_RotateTime)) $ "), Delta (") $ string(targetRot - Rotation)) $ ") (") $ string(RSize(targetRot - Rotation))) $ ")");
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        // End:0x12FB
        if(AutomoveTarget != none)
        {
            // End:0x123F
            if(bAutomoveTranslateToTarget)
            {
                DrawDebugSphere(AutomoveTarget.Location, 10.0000000, 5, 0, 0, 255, false);
                tempVec = Location;
                tempVec.Z = AutomoveTarget.Location.Z;
                DrawDebugSphere(tempVec, 10.0000000, 5, 0, 255, 0, false);
                DrawDebugLine(tempVec, AutomoveTarget.Location, 255, 0, 0, false);
            }
            // End:0x12A7
            if(bAutomoveRotateToTarget)
            {
                DrawDebugLine(Location, Location + (50.0000000 * Vector(Rotation)), 255, 255, 0, false);
                DrawDebugLine(Location, Location + (50.0000000 * Normal(AutomoveTarget.Location - Location)), 0, 255, 0, false);
            }
            // End:0x12FB
            if((Pawn(AutomoveTarget) != none) && SkyAIController(Pawn(AutomoveTarget).Controller) != none)
            {
                AutomoveTarget.DisplayDebug(HUD, out_YL, out_YPos);
            }
        }
    }
    // End:0x13A1
    if(HUD.ShouldDisplayDebug('controlvel'))
    {
        Canvas.SetDrawColor(0, 0, 255);
        Canvas.DrawText(((("bControlledVelocity: " $ string(bControlledVelocity)) $ " (") $ string(Velocity)) $ ")");
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0x143F
    if(HUD.ShouldDisplayDebug('gravity'))
    {
        Canvas.SetDrawColor(0, 255, 255);
        Canvas.DrawText(((("Gravity: " $ string(GetGravityZ())) $ " (") $ string(CustomGravityScaling)) $ ")");
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0x1469
    if(HUD.ShouldDisplayDebug('Pawn'))
    {
        DrawDebugPawn();
    }
    // End:0x14A2
    if(HUD.ShouldDisplayDebug('Interaction'))
    {
        DrawDebugInteractions(Canvas, out_YL, out_YPos);
    }
    // End:0x14E0
    if(HUD.ShouldDisplayDebug('ik'))
    {
        DrawDebugIK(Canvas, XPos, out_YL, out_YPos);
    }
    // End:0x150F
    if(HUD.ShouldDisplayDebug('deadend'))
    {
        DrawDebugDeadEnd(Canvas);
    }
    // End:0x1552
    if(HUD.ShouldDisplayDebug('PrimaryWSM'))
    {
        PrimaryWSM.DisplayDebug(Canvas, out_YL, out_YPos);
    }
    // End:0x1595
    if(HUD.ShouldDisplayDebug('SecondaryWSM'))
    {
        SecondaryWSM.DisplayDebug(Canvas, out_YL, out_YPos);
    }
    // End:0x164C
    if(HUD.ShouldDisplayDebug('secondary'))
    {
        // End:0x1629
        if(SecondaryWeapon == none)
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("NO SECONDARY WEAPON");
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);            
        }
        else
        {
            SecondaryWeapon.DisplayDebug(HUD, out_YL, out_YPos);
        }
    }
    // End:0x174E
    if(HUD.ShouldDisplayDebug('BackWeapon'))
    {
        // End:0x16DB
        if(BackWeapon == none)
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("NO BACK WEAPON");
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);            
        }
        else
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("BACK WEAPON: " @ string(BackWeapon.Name));
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
    }
    // End:0x1A24
    if(HUD.ShouldDisplayDebug('Weapons'))
    {
        // End:0x17E0
        if(Weapon == none)
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("NO PRIMARY WEAPON");
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);            
        }
        else
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("PRIMARY WEAPON: " @ string(Weapon.Name));
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
        // End:0x18CA
        if(SecondaryWeapon == none)
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("NO SECONDARY WEAPON");
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);            
        }
        else
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("SECONDARY WEAPON: " @ string(SecondaryWeapon.Name));
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
        // End:0x19B1
        if(BackWeapon == none)
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("NO BACK WEAPON");
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);            
        }
        else
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("BACK WEAPON: " @ string(BackWeapon.Name));
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
    }
    // End:0x2002
    if(HUD.ShouldDisplayDebug('Grip'))
    {
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.DrawText((("IsGripping():" @ string(IsGripping())) @ ", GripPoint:") @ string(GripPoint));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("GripUprightSkelMeshComp:" @ string(GripUprightSkelMeshComp)) @ ", GripHangingSkelMeshComp:") @ string(GripHangingSkelMeshComp));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("GripPhysicsWeight:" @ string(GripPhysicsWeight));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("GripHangingWeight :" @ string(GripHangingWeight)) @ ", GripUprightWeight (calculated):") @ string(1.0000000 - GripHangingWeight));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("GripLimbIKWeights");
        out_YPos += out_YL;
        Canvas.SetPos(12.0000000, out_YPos);
        Canvas.DrawText("RightArm:" @ string(GripLimbIKWeights[0]));
        out_YPos += out_YL;
        Canvas.SetPos(12.0000000, out_YPos);
        Canvas.DrawText("LeftArm:" @ string(GripLimbIKWeights[1]));
        out_YPos += out_YL;
        Canvas.SetPos(12.0000000, out_YPos);
        Canvas.DrawText("RightLeg:" @ string(GripLimbIKWeights[2]));
        out_YPos += out_YL;
        Canvas.SetPos(12.0000000, out_YPos);
        Canvas.DrawText("LeftLeg:" @ string(GripLimbIKWeights[3]));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("ThrownFromGripPointAnimTree:" @ string(ThrownFromGripPointAnimTree)) @ ", ThrownFromGripPointDuration:") @ string(ThrownFromGripPointDuration));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("ReleasedGripPointAnimTree:" @ string(ReleasedGripPointAnimTree)) @ ", ReleasedGripPointDuration:") @ string(ReleasedGripPointDuration));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("ShotFromGripPointAnimTree:" @ string(ShotFromGripPointAnimTree)) @ ", ShotFromGripPointAnimTree:") @ string(ShotFromGripPointAnimTree));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((((("bPlayGripHitReaction:" @ string(bPlayGripHitReaction)) @ ", GripHitReactionDuration:") @ string(GripHitReactionDuration)) @ ", GripHitReactionTimer:") @ string(GripHitReactionTimer));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0x202C
    if(HUD.ShouldDisplayDebug('WeakPoints'))
    {
        DrawDebugWeakpoints();
    }
    // End:0x2065
    if(HUD.ShouldDisplayDebug('tickets'))
    {
        DrawFireTickets(Canvas, out_YL, out_YPos);
    }
    //return;    
}

function DrawDebugStates(Canvas Canvas, float YL, out float out_YPos)
{
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("SprintState: " $ string(SprintState));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText("FallState: " $ string(FallState));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText("bHijackable: " $ string(((SkyAirVehicle(DrivenVehicle) == none) ? false : SkyAirVehicle(DrivenVehicle).bHijackable)));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText("ParachuteState: " $ string(ParachuteState));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText("RocketPackState: " $ string(RocketPackState));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText("DodgeState: " $ string(DodgeState));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText("X180State: " $ string(X180State));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    //return;    
}

simulated function DrawDebugDeadEnd(Canvas Canvas)
{
    local SkyPlayerController SPC;
    local SkyNavigationPoint SkyNav;
    local Vector ScreenLoc, CameraFacing;

    SPC = SkyPlayerController(Controller);
    // End:0x34
    if((SPC == none) || SPC.PlayerCamera == none)
    {
        return;
    }
    CameraFacing = Vector(SPC.PlayerCamera.Rotation);
    // End:0x26B
    foreach WorldInfo.RadiusNavigationPoints(Class'Engine.SkyNavigationPoint', SkyNav, SPC.PlayerCamera.Location, 4000.0000000)
    {
        // End:0x26A
        if((CameraFacing Dot Normal(SkyNav.Location - SPC.PlayerCamera.Location)) > 0.4000000)
        {
            // End:0x26A
            if(SkyNav.PathList.Length == 0)
            {
                DrawDebugLine(SkyNav.Location - vect(20.0000000, 0.0000000, 0.0000000), SkyNav.Location + vect(20.0000000, 0.0000000, 0.0000000), 255, 0, 0);
                DrawDebugLine(SkyNav.Location - vect(0.0000000, 20.0000000, 0.0000000), SkyNav.Location + vect(0.0000000, 20.0000000, 0.0000000), 255, 0, 0);
                DrawDebugLine(SkyNav.Location - vect(0.0000000, 0.0000000, 20.0000000), SkyNav.Location + vect(0.0000000, 0.0000000, 20.0000000), 255, 0, 0);
                ScreenLoc = Canvas.Project(SkyNav.Location + vect(0.0000000, 0.0000000, 20.0000000));
                ScreenLoc.X -= float(75);
                Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
                Canvas.DrawText("DeadEnd: " $ string(SkyNav.Name), false);
            }
        }        
    }    
    //return;    
}

simulated function DrawFireTickets(Canvas Canvas, out float out_YL, out float out_YPos)
{
    local int Idx;

    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText((("FireTickets Total:" @ string(NumFireTickets)) @ "InUse:") @ string(FireTickets.Length));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Idx = 0;
    J0x89:

    // End:0x11A [Loop If]
    if(Idx < FireTickets.Length)
    {
        Canvas.DrawText((("   +FireTickets[" $ string(Idx)) $ "] = Claimed by:") @ string(FireTickets[Idx]));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        ++Idx;
        // [Loop Continue]
        goto J0x89;
    }
    //return;    
}

simulated function DrawDebugPawn()
{
    local Vector Start, End;

    // End:0xC6
    if(CylinderComponent != none)
    {
        Start = Location;
        Start.Z -= CylinderComponent.CollisionHeight;
        End = Location;
        End.Z += CylinderComponent.CollisionHeight;
        DrawDebugCylinder(Start, End, CylinderComponent.CollisionRadius, 20, 255, 255, 255, false);
        DrawDebugCoordinateSystem(Location, Rotation, 200.0000000, false);
        DrawDebugLine(Location, Location + (Velocity * 300.0000000), 255, 255, 0, false);
    }
    //return;    
}

simulated function DrawDebugInteractions(Canvas Canvas, float YL, out float out_YPos)
{
    local SkyPawnPlayerCharacter Player;
    local SkyPawn PawnTarget;

    // End:0x138
    foreach WorldInfo.AllPawns(Class'SkyPawnPlayerCharacter', Player)
    {
        Canvas.SetDrawColor(255, 255, 204, 255);
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("Interaction : " $ string(Player.GetInteraction().ObjectArchetype));
        out_YPos += YL;
        Canvas.SetPos(4.0000000, out_YPos);
        // End:0x137
        if(Player.CachedTarget != none)
        {
            PawnTarget = SkyPawn(Player.CachedTarget);
            // End:0x10A
            if(PawnTarget != none)
            {
                PawnTarget.DrawDebugPawn();
                // End:0x137
                continue;
            }
            DrawDebugSphere(Player.CachedTarget.Location, 100.0000000, 8, 255, 255, 255, false);
        }        
    }    
    //return;    
}

simulated function ShowAimDebug(Canvas Canvas)
{
    local Vector MuzzleLoc, MuzzleDir, ImpactLocation;
    local Rotator MuzzleRot;

    Mesh.GetSocketWorldLocationAndRotation(TwoHandedWeaponBone, MuzzleLoc, MuzzleRot);
    MuzzleDir = Vector(MuzzleRot);
    SkeletalMeshComponent(CurrWeaponAttachment.Mesh).GetSocketWorldLocationAndRotation(CurrWeaponAttachment.MuzzleFlashSocket, MuzzleLoc);
    DrawDebugLine(MuzzleLoc, MuzzleLoc + (MuzzleDir * 1000.0000000), 0, 255, 0);
    ImpactLocation = SkyWeapon(Weapon).DebugGetWeaponImpactLocation();
    DrawDebugLine(MuzzleLoc, ImpactLocation, 255, 0, 255);
    //return;    
}

simulated function DrawDebugIK(Canvas Canvas, float XPos, out float out_YL, out float out_YPos)
{
    local array<SkyWeaponAttachment> Attachments;
    local int I, J;
    local SkySkelControl_SocketIK IKControl;

    Attachments[0] = CurrWeaponAttachment;
    Attachments[1] = CurrSecondaryWeaponAttachment;
    Canvas.SetDrawColor(255, 50, 255);
    I = 0;
    J0x38:

    // End:0x1EF [Loop If]
    if(I < Attachments.Length)
    {
        // End:0x5C
        if(Attachments[I] == none)
        {
            // [Explicit Continue]
            goto J0x1E5;
        }
        J = 0;
        J0x63:

        // End:0x1E5 [Loop If]
        if(J < Attachments[I].IKControls.Length)
        {
            IKControl = Attachments[I].GetIKControl(Attachments[I].IKControls[J].SkelControl);
            // End:0x1DB
            if(IKControl != none)
            {
                // End:0x165
                if(IKControl.StrengthTarget > 0.0000000)
                {
                    Canvas.DrawText(((string(Attachments[I].Class) $ " ") $ string(IKControl.ControlName)) $ " Enabled");
                    out_YPos += out_YL;
                    Canvas.SetPos(XPos, out_YPos);
                    // [Explicit Continue]
                    goto J0x1DB;
                }
                Canvas.DrawText(((string(Attachments[I].Class) $ " ") $ string(IKControl.ControlName)) $ " Disabled");
                out_YPos += out_YL;
                Canvas.SetPos(XPos, out_YPos);
            }
            J0x1DB:

            ++J;
            // [Loop Continue]
            goto J0x63;
        }
        J0x1E5:

        ++I;
        // [Loop Continue]
        goto J0x38;
    }
    //return;    
}

simulated function ShowAnimDebug(SkeletalMeshComponent pMesh, Canvas pCanvas)
{
    local AnimTree pAnimTree;
    local array<AnimNode> NodeList;

    pAnimTree = AnimTree(pMesh.Animations);
    // End:0x6E
    if(pAnimTree != none)
    {
        pCanvas.SetPos(AnimDebugDisplayPos.X, AnimDebugDisplayPos.Y);
        DrawAnimNode(pAnimTree, pCanvas, NodeList);
    }
    //return;    
}

simulated function DrawAnimNode(AnimNode pNode, Canvas pCanvas, out array<AnimNode> NodeList)
{
    local AnimNodeSequence pAnimSeq;
    local AnimNodeBlendBase pBlendList;
    local AnimTree pAnimTree;
    local AnimNodeAimOffset pAimNode;
    local AnimNodeBlendPerBone pPerBone;
    local float fWidth, fHeight;
    local name NodeName;
    local int I;
    local string NodeWeightString;
    local int nDrawColor;
    local string BlendListText;
    local int nPrevX, nCurY, nParentY, nChildY, nNumActiveChildren;

    I = NodeList.Length - 1;
    J0x0F:

    // End:0x3B [Loop If]
    if(I >= 0)
    {
        // End:0x31
        if(pNode == NodeList[I])
        {
            return;
        }
        --I;
        // [Loop Continue]
        goto J0x0F;
    }
    // End:0x8E
    if(pCanvas.CurY > float(pCanvas.SizeY - 35))
    {
        pCanvas.SetPos(pCanvas.CurX + float(80), 5.0000000);
    }
    NodeList.Insert(NodeList.Length, 1);
    NodeList[NodeList.Length - 1] = pNode;
    pAnimSeq = AnimNodeSequence(pNode);
    pBlendList = AnimNodeBlendBase(pNode);
    pAnimTree = AnimTree(pNode);
    pAimNode = AnimNodeAimOffset(pNode);
    pPerBone = AnimNodeBlendPerBone(pNode);
    // End:0xB35
    if((pNode != none) && pNode.NodeTotalWeight > 0.0000100)
    {
        NodeWeightString = TruncateFraction(string(pNode.NodeTotalWeight), 2);
        NodeName = ((pNode.NodeName != 'None') ? pNode.NodeName : pNode.Class.Name);
        // End:0x2D8
        if(pAnimTree != none)
        {
            pCanvas.SetDrawColor(255, 255, 255);
            pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
            pCanvas.DrawTextClipped(string(NodeName) @ NodeWeightString);
            pCanvas.SetPos(pCanvas.CurX + float(10), pCanvas.CurY);
            I = 0;
            J0x249:

            // End:0x2A1 [Loop If]
            if(I < pAnimTree.Children.Length)
            {
                DrawAnimNode(pAnimTree.Children[I].Anim, pCanvas, NodeList);
                ++I;
                // [Loop Continue]
                goto J0x249;
            }
            pCanvas.SetPos(pCanvas.CurX - float(10), pCanvas.CurY);            
        }
        else
        {
            // End:0x8C6
            if(pBlendList != none)
            {
                nDrawColor = int(Lerp(150.0000000, 255.0000000, pNode.NodeTotalWeight));
                // End:0x34D
                if(pNode.NodeTotalWeight > pNode.PrevNodeTotalWeight)
                {
                    pCanvas.SetDrawColor(byte(nDrawColor), 255, byte(nDrawColor));                    
                }
                else
                {
                    // End:0x38F
                    if(pNode.NodeTotalWeight < pNode.PrevNodeTotalWeight)
                    {
                        pCanvas.SetDrawColor(byte(nDrawColor), 150, 150);                        
                    }
                    else
                    {
                        pCanvas.SetDrawColor(byte(nDrawColor), byte(nDrawColor), byte(nDrawColor));
                    }
                }
                pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
                pCanvas.DrawTextClipped(string(NodeName) @ NodeWeightString);
                // End:0x480
                if(pAimNode != none)
                {
                    BlendListText = ((("(" $ (TruncateFraction(string(pAimNode.Aim.X), 2))) $ ",") $ (TruncateFraction(string(pAimNode.Aim.Y), 2))) $ ")";                    
                }
                else
                {
                    // End:0x524
                    if(pPerBone != none)
                    {
                        BlendListText = "(";
                        I = 0;
                        J0x49B:

                        // End:0x511 [Loop If]
                        if(I < pPerBone.BranchStartBoneName.Length)
                        {
                            BlendListText = BlendListText $ string(pPerBone.BranchStartBoneName[I]);
                            // End:0x507
                            if(I < (pPerBone.BranchStartBoneName.Length - 1))
                            {
                                BlendListText = BlendListText $ ", ";
                            }
                            ++I;
                            // [Loop Continue]
                            goto J0x49B;
                        }
                        BlendListText = BlendListText $ ")";                        
                    }
                    else
                    {
                        BlendListText = "(";
                        I = 0;
                        J0x534:

                        // End:0x60C [Loop If]
                        if(I < pBlendList.Children.Length)
                        {
                            // End:0x602
                            if(pBlendList.Children[I].Weight > 0.0000100)
                            {
                                ++nNumActiveChildren;
                                // End:0x59D
                                if(BlendListText != "(")
                                {
                                    BlendListText = BlendListText $ ", ";
                                }
                                BlendListText = ((BlendListText $ string(pBlendList.Children[I].Name)) $ ": ") $ (TruncateFraction(string(pBlendList.Children[I].Weight), 2));
                            }
                            ++I;
                            // [Loop Continue]
                            goto J0x534;
                        }
                        BlendListText = BlendListText $ ")";
                    }
                }
                nPrevX = int(pCanvas.CurX);
                pCanvas.StrLen(string(NodeName) @ NodeWeightString, fWidth, fHeight);
                pCanvas.SetPos((pCanvas.CurX + fWidth) + float(5), pCanvas.CurY);
                pCanvas.SetDrawColor(200, 200, 200);
                pCanvas.DrawTextClipped(BlendListText);
                pCanvas.SetPos(float(nPrevX), pCanvas.CurY);
                nParentY = int(pCanvas.CurY);
                pCanvas.SetPos(pCanvas.CurX + float(10), pCanvas.CurY);
                I = 0;
                J0x73E:

                // End:0x7D7 [Loop If]
                if(I < pBlendList.Children.Length)
                {
                    // End:0x799
                    if(pBlendList.Children[I].Weight > 0.0000100)
                    {
                        nChildY = int(pCanvas.CurY);
                    }
                    DrawAnimNode(pBlendList.Children[I].Anim, pCanvas, NodeList);
                    ++I;
                    // [Loop Continue]
                    goto J0x73E;
                }
                pCanvas.SetPos(pCanvas.CurX - float(10), pCanvas.CurY);
                // End:0x8C3
                if(nNumActiveChildren > 1)
                {
                    pCanvas.SetDrawColor(180, 180, 180);
                    nCurY = int(pCanvas.CurY);
                    pCanvas.SetPos(pCanvas.CurX + float(5), float(nParentY + 18));
                    pCanvas.DrawBox(1.0000000, float(nChildY - nParentY));
                    pCanvas.SetPos(pCanvas.CurX - float(5), float(nCurY));
                }                
            }
            else
            {
                // End:0xB35
                if(pAnimSeq != none)
                {
                    NodeName = ((pAnimSeq.AnimSeqName != 'None') ? pAnimSeq.AnimSeqName : NodeName);
                    nDrawColor = int(Lerp(170.0000000, 255.0000000, pNode.NodeTotalWeight));
                    pCanvas.SetDrawColor(byte(nDrawColor), 0, 0);
                    pCanvas.SetPos(pCanvas.CurX - float(2), pCanvas.CurY + float(15));
                    pCanvas.DrawTextClipped(string(NodeName) @ NodeWeightString);
                    pCanvas.StrLen(string(NodeName), fWidth, fHeight);
                    pCanvas.DrawBox((fWidth * pNode.NodeTotalWeight) + float(4), fHeight);
                    nPrevX = int(pCanvas.CurX);
                    pCanvas.StrLen(string(NodeName) @ NodeWeightString, fWidth, fHeight);
                    pCanvas.SetPos((pCanvas.CurX + fWidth) + float(5), pCanvas.CurY);
                    pCanvas.SetDrawColor(255, 255, 255);
                    fWidth = 50.0000000;
                    pCanvas.DrawBox(fWidth, fHeight);
                    pCanvas.DrawRect(fWidth * (pAnimSeq.CurrentTime / (pAnimSeq.AnimSeq.SequenceLength / pAnimSeq.AnimSeq.RateScale)), fHeight);
                    pCanvas.SetPos(float(nPrevX), pCanvas.CurY);
                }
            }
        }
    }
    //return;    
}

function string TruncateFraction(string Src, int nNumDecimalPlaces)
{
    local string Whole, Fraction, Result;
    local int nDecimalPlace;

    Result = Src;
    nDecimalPlace = InStr(Result, ".");
    // End:0x6E
    if(nDecimalPlace != -1)
    {
        Whole = Left(Result, nDecimalPlace);
        Fraction = Mid(Result, nDecimalPlace + 1, nNumDecimalPlaces);
        Result = (Whole $ ".") $ Fraction;
    }
    return Result;
    //return ReturnValue;    
}

function string TruncateString(string Src, int nNumLetters)
{
    local string Result;

    Result = Src;
    // End:0x39
    if(Len(Src) > (nNumLetters + 3))
    {
        Result = Left(Result, nNumLetters) $ "...";
    }
    return Result;
    //return ReturnValue;    
}

simulated event ShowAnimLogDebug(Pawn P)
{
    local AnimNodeSequence SeqNode;

    // End:0x4E
    foreach P.Mesh.AllAnimNodes(Class'Engine.AnimNodeSequence', SeqNode)
    {
        // End:0x4D
        if(SeqNode.NodeTotalWeight > float(0))
        {
            LogAnimItem(SeqNode);
        }        
    }    
    //return;    
}

simulated function DrawAnimItemTree(Canvas Canvas, AnimNode Node)
{
    local int I;

    DrawAnimItem(Canvas, Node, false);
    Canvas.CurX += float(30);
    // End:0xC9
    if(AnimNodeBlendBase(Node) != none)
    {
        I = 0;
        J0x41:

        // End:0xC9 [Loop If]
        if(I < AnimNodeBlendBase(Node).Children.Length)
        {
            // End:0xBF
            if(AnimNodeBlendBase(Node).Children[I].Anim != none)
            {
                DrawAnimItemTree(Canvas, AnimNodeBlendBase(Node).Children[I].Anim);
            }
            ++I;
            // [Loop Continue]
            goto J0x41;
        }
    }
    Canvas.CurX -= float(30);
    //return;    
}

simulated function float DrawAnimItem(Canvas Canvas, AnimNode Node, bool TreeDebug)
{
    local AnimNodeSequence SeqNode;
    local float Width, Height;
    local name NodeName;
    local string DrawText;
    local int I;
    local string childweights;

    SeqNode = AnimNodeSequence(Node);
    // End:0x33
    if(SeqNode != none)
    {
        NodeName = SeqNode.AnimSeqName;        
    }
    else
    {
        // End:0x68
        if(Node.NodeName != 'None')
        {
            NodeName = Node.NodeName;            
        }
        else
        {
            NodeName = Node.Class.Name;
        }
    }
    // End:0x14E
    if(SeqNode != none)
    {
        DrawText = (((((((string(NodeName) $ " (") $ string(SeqNode.CurrentTime)) $ "/") $ string(SeqNode.AnimSeq.SequenceLength)) $ ") ") $ string((SeqNode.CurrentTime * 100.0000000) / SeqNode.AnimSeq.SequenceLength)) $ ((SeqNode.bLooping) ? "% L " : "% 1 ")) $ string(SeqNode.NodeTotalWeight);        
    }
    else
    {
        // End:0x284
        if(Node.IsA('AnimNodeBlendList'))
        {
            childweights = "";
            I = 0;
            J0x175:

            // End:0x242 [Loop If]
            if(I < AnimNodeBlendList(Node).Children.Length)
            {
                // End:0x238
                if(AnimNodeBlendList(Node).Children[I].Weight > float(0))
                {
                    childweights = (((((childweights $ " (") $ string(I)) $ ": ") $ string(AnimNodeBlendList(Node).Children[I].Name)) @ string(AnimNodeBlendList(Node).Children[I].Weight)) $ ")";
                }
                ++I;
                // [Loop Continue]
                goto J0x175;
            }
            DrawText = ((string(NodeName) @ string(Node.NodeTotalWeight)) @ string(AnimNodeBlendList(Node).ActiveChildIndex)) $ childweights;            
        }
        else
        {
            DrawText = string(NodeName) @ string(Node.NodeTotalWeight);
        }
    }
    Canvas.DrawTextClipped(DrawText);
    Canvas.CurY += float(10);
    Canvas.StrLen(DrawText, Width, Height);
    // End:0x33C
    if(SeqNode != none)
    {
        Canvas.DrawBox(Width * Node.NodeTotalWeight, 1.0000000);
        Canvas.CurY += float(10);
    }
    // End:0x3D1
    if(TreeDebug)
    {
        I = 0;
        J0x34C:

        // End:0x3D1 [Loop If]
        if(I < Node.ParentNodes.Length)
        {
            // End:0x3C7
            if(Node.ParentNodes[I].NodeTotalWeight > 0.0000000)
            {
                return float(Max(int(DrawAnimItem(Canvas, Node.ParentNodes[I], TreeDebug)), int(Width)));
            }
            ++I;
            // [Loop Continue]
            goto J0x34C;
        }
    }
    return Width;
    //return ReturnValue;    
}

simulated function LogAnimItem(AnimNode Node)
{
    //return;    
}

simulated function ShowTransitionDebug(SkeletalMeshComponent pMesh, Canvas Canvas)
{
    local Vector ScreenPos;
    local AnimNodeTransition TransNode;
    local editinline SkySkelMeshComponent SkySkelMesh;
    local int I;

    Canvas.SetDrawColor(255, 255, 100);
    SkySkelMesh = SkySkelMeshComponent(pMesh);
    ScreenPos = TransitionDebugDisplayPos;
    // End:0x64
    if(ScreenPos.X < float(50))
    {
        ScreenPos.X = 50.0000000;        
    }
    else
    {
        // End:0xBA
        if(ScreenPos.X > (Canvas.ClipX - float(400)))
        {
            ScreenPos.X = Canvas.ClipX - float(400);
        }
    }
    Canvas.SetPos(ScreenPos.X, ScreenPos.Y);
    Canvas.DrawTextClipped("Transition Info");
    Canvas.CurY += float(10);
    // End:0x174
    if(SkySkelMesh == none)
    {
        Canvas.DrawTextClipped("No SkySkelMeshComponent!");
        Canvas.CurY += float(10);
        return;
    }
    // End:0x22E
    if(SkySkelMesh != none)
    {
        I = 0;
        J0x186:

        // End:0x22E [Loop If]
        if(I < SkySkelMesh.GreatestBlendSequences.Length)
        {
            // End:0x224
            if(SkySkelMesh.GreatestBlendSequences[I] != none)
            {
                Canvas.DrawTextClipped((("Most Weight " $ string(I)) $ ": ") $ string(SkySkelMesh.GreatestBlendSequences[I].AnimSeqName));
                Canvas.CurY += float(10);
            }
            ++I;
            // [Loop Continue]
            goto J0x186;
        }
    }
    // End:0x28D
    if((SkySkelMesh != none) && SkySkelMesh.LockInputCounter > 0)
    {
        Canvas.DrawTextClipped("Input is locked: " $ string(SkySkelMesh.LockInputCounter));        
    }
    else
    {
        Canvas.DrawTextClipped("Input is not locked: " $ string(SkySkelMesh.LockInputCounter));
    }
    Canvas.CurY += float(10);
    Canvas.DrawTextClipped("BlendSeq: " $ string(SkySkelMesh.BlendSequence.AnimSeqName));
    Canvas.CurY += float(20);
    // End:0x37B
    foreach SkySkelMesh.AllAnimNodes(Class'AnimNodeTransition', TransNode)
    {
        // End:0x37A
        if(TransNode.NodeTotalWeight > float(0))
        {
            DrawTransitionItem(Canvas, TransNode);
        }        
    }    
    Canvas.SetDrawColor(100, 255, 255);
    Canvas.SetPos(125.0000000, 380.0000000);
    Canvas.DrawTextClipped("Transition Events:");
    Canvas.CurY += float(15);
    DrawEventLog(TransitionDebugEvents, Canvas, 0.5000000, 1.0000000, 0.9000000);
    //return;    
}

simulated function DrawTransitionItem(Canvas Canvas, AnimNode Node)
{
    local AnimNodeTransition TransNode;
    local float Width, Height;
    local name SeqName, NodeName, TransitionName, FromName, TransName, ToName,
	    StateName;

    local AnimTransition Trans;
    local int TransState;

    TransNode = AnimNodeTransition(Node);
    // End:0x1A2
    if(TransNode != none)
    {
        SeqName = TransNode.AnimSeqName;
        Trans = TransNode.Transition;
        // End:0xA4
        if(Trans != none)
        {
            TransitionName = Trans.TransitionName;
            FromName = Trans.FromAnim;
            TransName = Trans.TransAnim;
            ToName = Trans.ToAnim;
        }
        TransState = TransNode.TransitionState;
        // End:0xD6
        if(TransState == 0)
        {
            StateName = 'From';            
        }
        else
        {
            // End:0xF3
            if(TransState == 1)
            {
                StateName = 'From To Trans';                
            }
            else
            {
                // End:0x111
                if(TransState == 2)
                {
                    StateName = 'Trans';                    
                }
                else
                {
                    // End:0x12F
                    if(TransState == 3)
                    {
                        StateName = 'Trans To To';                        
                    }
                    else
                    {
                        // End:0x14D
                        if(TransState == 4)
                        {
                            StateName = 'To';                            
                        }
                        else
                        {
                            StateName = 'Invalid';
                        }
                    }
                }
            }
        }
        ((TransNode.bInTransition) ? Canvas.SetDrawColor(255, 255, 255) : Canvas.SetDrawColor(255, 100, 100));        
    }
    else
    {
        NodeName = ((TransNode.NodeName != 'None') ? TransNode.NodeName : TransNode.Class.Name);
    }
    // End:0x412
    if(TransNode != none)
    {
        Canvas.DrawTextClipped("Node Name: " $ string(NodeName));
        Canvas.CurY += float(10);
        // End:0x28F
        if(!TransNode.bInTransition)
        {
            Canvas.DrawTextClipped("CurSequence: " $ string(SeqName));
            Canvas.CurY += float(10);
        }
        Canvas.CurY += float(4);
        // End:0x2D5
        if(Trans == none)
        {
            Canvas.DrawTextClipped("No Transition");            
        }
        else
        {
            Canvas.DrawTextClipped("Name: " $ string(TransitionName));
            Canvas.CurY += float(10);
            Canvas.DrawTextClipped("From: " $ string(FromName));
            Canvas.CurY += float(10);
            Canvas.DrawTextClipped("Transition: " $ string(TransName));
            Canvas.CurY += float(10);
            Canvas.DrawTextClipped("To: " $ string(ToName));
        }
        Canvas.CurY += float(14);
        // End:0x40F
        if(TransNode.bInTransition)
        {
            Canvas.DrawTextClipped("State: " $ string(StateName));
            Canvas.CurY += float(10);
        }        
    }
    else
    {
        Canvas.DrawTextClipped(string(SeqName) @ string(Node.NodeTotalWeight));
        Canvas.CurY += float(10);
    }
    Canvas.CurY += float(10);
    Canvas.StrLen(string(SeqName), Width, Height);
    Width = 175.0000000;
    // End:0x5B4
    if(TransNode != none)
    {
        Canvas.DrawBox(Width * Node.NodeTotalWeight, 1.0000000);
        Canvas.CurX += Width;
        Canvas.DrawTextClipped("Weight");
        Canvas.CurX -= Width;
        // End:0x5B4
        if(TransNode.bInTransition)
        {
            Canvas.CurY += float(10);
            Canvas.DrawBox(Width * TransNode.BlendSequenceWeight, 1.0000000);
            Canvas.CurX += Width;
            Canvas.DrawTextClipped("BlendWeight");
            Canvas.CurX -= Width;
        }
    }
    Canvas.CurY += float(20);
    //return;    
}

simulated function DrawEventLog(array<GenericDebugEventLogEntry> EventLog, Canvas Canvas, float R, float G, float B)
{
    local int I, H;
    local float TimeRatio, EventLife;

    I = 0;
    J0x07:

    // End:0x227 [Loop If]
    if(I < EventLog.Length)
    {
        TimeRatio = 1.0000000;
        EventLife = WorldInfo.TimeSeconds - EventLog[I].TimeCreated;
        // End:0xB8
        if(EventLife > float(8))
        {
            H = 0;
            J0x64:

            // End:0x9B [Loop If]
            if(H < (EventLog.Length - 1))
            {
                EventLog[H] = EventLog[H + 1];
                ++H;
                // [Loop Continue]
                goto J0x64;
            }
            EventLog.Remove(EventLog.Length - 1, 1);
            --I;
            // [Explicit Continue]
            goto J0x21D;            
        }
        else
        {
            // End:0xE6
            if(EventLife > float(3))
            {
                TimeRatio -= FMin(1.0000000, (EventLife - float(3)) / 3.0000000);
            }
        }
        Canvas.SetDrawColor(byte(float(150) + ((TimeRatio * 105.0000000) * R)), byte(float(150) + ((TimeRatio * 105.0000000) * G)), byte(float(150) + ((TimeRatio * 105.0000000) * B)));
        Canvas.DrawTextClipped(EventLog[I].String1);
        Canvas.CurX += float(250);
        Canvas.DrawTextClipped(EventLog[I].String2);
        Canvas.CurX += float(250);
        Canvas.DrawTextClipped(EventLog[I].String3);
        Canvas.CurX -= float(500);
        Canvas.CurY += float(15);
        J0x21D:

        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function ShowNotifyDebug(Pawn P, Canvas Canvas)
{
    Canvas.SetDrawColor(255, 255, 100);
    Canvas.SetPos(10.0000000, 240.0000000);
    Canvas.DrawTextClipped("Notifies:");
    Canvas.CurY += float(15);
    DrawEventLog(NotifyDebugEvents, Canvas, 1.0000000, 1.0000000, 0.4000000);
    //return;    
}

simulated function DrawDebugWeakpoints()
{
    local Vector Loc;
    local Rotator Rot;
    local int I, R, G;

    I = 0;
    J0x07:

    // End:0x1F9 [Loop If]
    if(I < WeakPoints.Length)
    {
        // End:0x1EF
        if(((!WeakPoints[I].bInActive && WeakPoints[I].Health > float(0)) && WeakPoints[I].Socket != 'None') && Mesh != none)
        {
            // End:0x1EF
            if(Mesh.GetSocketWorldLocationAndRotation(WeakPoints[I].Socket, Loc, Rot))
            {
                // End:0x104
                if(WeakPoints[I].Health > SkyPawn(ObjectArchetype).WeakPoints[I].Health)
                {
                    G = 255;                    
                }
                else
                {
                    // End:0x160
                    if(SkyPawn(ObjectArchetype).WeakPoints[I].Health == float(0))
                    {
                        G = int((255.0000000 * WeakPoints[I].Health) / 1000.0000000);                        
                    }
                    else
                    {
                        G = int((255.0000000 * WeakPoints[I].Health) / SkyPawn(ObjectArchetype).WeakPoints[I].Health);
                    }
                }
                R = 255 - G;
                DrawDebugSphere(Loc, WeakPoints[I].Radius, 8, byte(R), byte(G), 0, false);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function SetTerminalVelocity(float Speed)
{
    // End:0x39
    if(Speed != TargetTerminalVelocity)
    {
        // End:0x2E
        if(int(Role) < int(ROLE_Authority))
        {
            ServerSetTerminalVelocity(Speed);
        }
        TargetTerminalVelocity = Speed;
    }
    //return;    
}

reliable server function ServerSetTerminalVelocity(float Speed)
{
    TargetTerminalVelocity = Speed;
    CurrentTerminalVelocity = Speed;
    //return;    
}

event float GetFreefallSpeed()
{
    return TerminalVelocityBrake - float(100);
    //return ReturnValue;    
}

reliable server function ServerOpenParachute()
{
    OpenParachute();
    //return;    
}

reliable client simulated function ClientOpenParachute()
{
    // End:0x1A
    if(int(Role) == int(ROLE_SimulatedProxy))
    {
        OpenParachute();
    }
    //return;    
}

simulated function OpenParachute()
{
    //return;    
}

reliable server function ServerKillParachute()
{
    KillParachute();
    //return;    
}

simulated event KillParachute()
{
    //return;    
}

simulated event bool CanParachute()
{
    // End:0x0D
    if(RocketPack != none)
    {
        return false;
    }
    // End:0x1F
    if(int(Physics) != int(2))
    {
        return false;
    }
    // End:0x30
    if(!IsFreefalling())
    {
        return false;
    }
    // End:0x3B
    if(bIsParachuting)
    {
        return false;
    }
    // End:0x4A
    if(IsHijacking())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

// Export USkyPawn::execIsParachuting(FFrame&, void* const)
native simulated function bool IsParachuting();

simulated event StartParachute()
{
    OpenParachute();
    // End:0x24
    if(int(Role) < int(ROLE_Authority))
    {
        ServerOpenParachute();
    }
    //return;    
}

simulated event StopParachute()
{
    KillParachute();
    // End:0x24
    if(int(Role) < int(ROLE_Authority))
    {
        ServerKillParachute();
    }
    //return;    
}

reliable server function ServerTurnOnRocketPack()
{
    // End:0x1B
    if(int(Role) == int(ROLE_Authority))
    {
        TurnOnRocketPack();
    }
    //return;    
}

reliable server function ServerTurnOffRocketPack()
{
    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        TurnOffRocketPack();
    }
    //return;    
}

function SetMovementPhysics()
{
    // End:0x15
    if(!IsRocketPacking())
    {
        super(Pawn).SetMovementPhysics();
    }
    //return;    
}

simulated event TurnOnRocketPack(optional bool bFromCheckpoint)
{
    local SkyPlayerController PC;
    local SkyWeaponBase Weap;

    // End:0x2B5
    if(((DrivenVehicle == none) && !bIsRocketPacking) && RocketPack != none)
    {
        bWasInFreeFall = IsFreefalling();
        Weap = SkyWeaponBase(Weapon);
        PC = SkyPlayerController(Controller);
        // End:0x18E
        if(PC != none)
        {
            // End:0x74
            if((IsInWalkVolume()) == true)
            {
                return;
            }
            // End:0xF4
            if((((RocketPack.bAllowBoost && RocketPack.bHasDoubleJump) && !bFromCheckpoint) && Weap != none) && !Weap.bIsLargeWeapon)
            {
                SetRocketPackState(1);
                PC.GotoState('PlayerBoosting');                
            }
            else
            {
                // End:0x167
                if(((RocketPack.bAllowDoubleJump && RocketPack.bHasDoubleJump) && Weap != none) && !Weap.bIsLargeWeapon)
                {
                    SetRocketPackState(3);
                    PC.GotoState('PlayerDoubleJumping');                    
                }
                else
                {
                    SetRocketPackState(3);
                    PC.GotoState('PlayerGliding');
                }
            }            
        }
        else
        {
            // End:0x219
            if(RocketPack.bAllowBoost || RocketPack.bAllowDoubleJump && RocketPack.bHasDoubleJump)
            {
                SetRocketPackState(1);
                AirControl = RocketPack.BoostAirControl;
                GroundSpeed = RocketPack.BoostAirSpeed;
                AirSpeed = RocketPack.BoostAirSpeed;                
            }
            else
            {
                SetRocketPackState(3);
                AirControl = RocketPack.GlideAirControl;
                GroundSpeed = RocketPack.GlideAirSpeed;
                AirSpeed = RocketPack.GlideAirSpeed;
            }
            SetPhysics(4);
        }
        bIsRocketPacking = true;
        RocketPack.Activate();
        RocketPack.CountActivationsPerAirborne++;
        TriggerEventClass(Class'SkySeqEvent_HoverActivated', self);
        SetFallState(3);
    }
    //return;    
}

simulated event SetRocketPackState(SkyPawn.EBlendByRocketPackingState NewState)
{
    // End:0xAC
    if(int(NewState) == int(1))
    {
        // End:0x39
        if(int(RocketPackState) == int(3))
        {
            RocketPack.RocketPackPlayTag(9);            
        }
        else
        {
            // End:0x8B
            if(int(RocketPackState) == int(2))
            {
                RocketPack.RocketPackPlayTag(7);
                RocketPack.RocketPackPlayTag(12);
                RocketPack.RocketPackPlayTag(14);
            }
        }
        RocketPack.RocketPackPlayTag(4);
        RocketPackState = 1;        
    }
    else
    {
        // End:0x163
        if(int(NewState) == int(3))
        {
            // End:0xE5
            if(int(RocketPackState) == int(1))
            {
                RocketPack.RocketPackPlayTag(5);                
            }
            else
            {
                // End:0x142
                if(int(RocketPackState) == int(2))
                {
                    // End:0x116
                    if(!bHijackingFromVehicle)
                    {
                        RocketPack.RocketPackPlayTag(7);
                    }
                    RocketPack.RocketPackPlayTag(12);
                    RocketPack.RocketPackPlayTag(14);
                }
            }
            RocketPack.RocketPackPlayTag(8);
            RocketPackState = 3;            
        }
        else
        {
            // End:0x1E3
            if(int(NewState) == int(2))
            {
                // End:0x19C
                if(int(RocketPackState) == int(1))
                {
                    RocketPack.RocketPackPlayTag(5);                    
                }
                else
                {
                    // End:0x1C2
                    if(int(RocketPackState) == int(3))
                    {
                        RocketPack.RocketPackPlayTag(9);
                    }
                }
                RocketPack.RocketPackPlayTag(6);
                RocketPackState = 2;                
            }
            else
            {
                // End:0x29F
                if(int(NewState) == int(0))
                {
                    // End:0x21C
                    if(int(RocketPackState) == int(1))
                    {
                        RocketPack.RocketPackPlayTag(5);                        
                    }
                    else
                    {
                        // End:0x271
                        if(int(RocketPackState) == int(2))
                        {
                            RocketPack.RocketPackPlayTag(7);
                            RocketPack.RocketPackPlayTag(12);
                            RocketPack.RocketPackPlayTag(14);                            
                        }
                        else
                        {
                            // End:0x297
                            if(int(RocketPackState) == int(3))
                            {
                                RocketPack.RocketPackPlayTag(9);
                            }
                        }
                    }
                    RocketPackState = 0;
                }
            }
        }
    }
    //return;    
}

// Export USkyPawn::execTurnOffRocketPack(FFrame&, void* const)
native simulated function TurnOffRocketPack();

// Export USkyPawn::execCalculateDirectionalGroundSpeed(FFrame&, void* const)
native final function bool CalculateDirectionalGroundSpeed();

// Export USkyPawn::execGetPawnGroundSpeed(FFrame&, void* const)
native simulated function float GetPawnGroundSpeed();

simulated event bool CanRocketPack()
{
    // End:0x0D
    if(RocketPack == none)
    {
        return false;
    }
    // End:0x26
    if(RocketPack.CurrentFuel <= float(0))
    {
        return false;
    }
    // End:0x62
    if((RocketPack.NumActivationsPerAirborne > 0) && RocketPack.CountActivationsPerAirborne >= RocketPack.NumActivationsPerAirborne)
    {
        return false;
    }
    // End:0x7C
    if((IsHijacking()) || IsPickingUp())
    {
        return false;
    }
    // End:0xA0
    if((int(FallState) == int(4)) || int(FallState) == int(0))
    {
        return false;
    }
    // End:0xEB
    if(((((IsInteracting()) || IsGripping()) || ThrownFromGripPoint()) || ReleasedGripPoint()) || ShotFromGripPoint())
    {
        return false;
    }
    // End:0xFC
    if(FindWeaponEffect(2))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

// Export USkyPawn::execFindWeaponEffect(FFrame&, void* const)
native function bool FindWeaponEffect(SkyPawn.EWeaponEffect Effect);

// Export USkyPawn::execRemoveWeaponEffect(FFrame&, void* const)
native function RemoveWeaponEffect(SkyPawn.EWeaponEffect Effect);

// Export USkyPawn::execAddWeaponEffect(FFrame&, void* const)
native function AddWeaponEffect(SkyPawn.EWeaponEffect Effect, Actor EffectInstigator);

// Export USkyPawn::execIsRocketPacking(FFrame&, void* const)
native simulated function bool IsRocketPacking();

simulated event bool CommittedToRocketPacking()
{
    return bIsThrusting || IsTimerActive('TimedTurnOnRocketPackThrust');
    //return ReturnValue;    
}

simulated event StartRocketPack()
{
    TurnOnRocketPack();
    // End:0x25
    if(int(Role) < int(ROLE_Authority))
    {
        ServerTurnOnRocketPack();
    }
    //return;    
}

simulated event StopRocketPack()
{
    TurnOffRocketPack();
    // End:0x24
    if(int(Role) < int(ROLE_Authority))
    {
        ServerTurnOffRocketPack();
    }
    //return;    
}

reliable server function ServerGotoRocketPackGlide()
{
    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        GotoRocketPackGlide();
    }
    //return;    
}

simulated event GotoRocketPackGlide()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerGotoRocketPackGlide();
    }
    // End:0xDD
    if(bIsRocketPacking && RocketPack != none)
    {
        // End:0x8D
        if(SkyPlayerController(Controller) != none)
        {
            SkyPlayerController(Controller).GotoState('PlayerGliding');
            // End:0x8A
            if((HijackTarget == none) && JumpVehicleTarget == none)
            {
                PrimaryWSM.TryDraw();
            }            
        }
        else
        {
            AirControl = RocketPack.GlideAirControl;
            GroundSpeed = RocketPack.GlideAirSpeed;
            AirSpeed = RocketPack.GlideAirSpeed;
            SetPhysics(4);
        }
        SetRocketPackState(3);
    }
    //return;    
}

// Export USkyPawn::execIsGliding(FFrame&, void* const)
native function bool IsGliding();

simulated event ToggleRocketPackThrust()
{
    local SkyWeapon SW;

    // End:0x4E
    if(bIsThrusting)
    {
        // End:0x4B
        if(SkyAirVehicle(DrivenVehicle).NoExitFromCollision <= 0.0000000)
        {
            TurnOffRocketPackThrust();
            // End:0x4B
            if(int(Role) < int(ROLE_Authority))
            {
                ServerTurnOffRocketPackThrust();
            }
        }        
    }
    else
    {
        // End:0x2BC
        if((((CanRocketPack()) == true) && RocketPack.bAllowThrust == true) && (SkyPlayerController(Controller) == none) || SkyPlayerController(Controller).DisableThrustCount <= 0)
        {
            // End:0xC8
            if((SkyPlayerController(Controller) != none) && (IsInWalkVolume()) == true)
            {
                return;
            }
            // End:0x1B0
            if(PrimaryWSM != none)
            {
                SW = SkyWeapon(Weapon);
                // End:0x117
                if((SW != none) && SW.bIsLargeWeapon)
                {
                    DropWeapon(SW);                    
                }
                else
                {
                    PrimaryWSM.FiringInput(false);
                    StopFireImmediately(SW.CurrentFireMode);
                    PrimaryWSM.TryHolster(true);
                    PrimaryWSM.TargetingInput(false);
                    PrimaryWSM.ZoomingInput(false);
                    // End:0x1B0
                    if(SkyWeapon(Weapon) != none)
                    {
                        SkyWeapon(Weapon).ZoomSetOwnerNoSee(false);
                    }
                }
            }
            // End:0x235
            if(SecondaryWSM != none)
            {
                // End:0x1DF
                if(SecondaryWeapon != none)
                {
                    StopSecondaryItemFireImmediately(SecondaryWeapon.CurrentFireMode);
                }
                SecondaryWSM.FiringInput(false);
                SecondaryWSM.TryHolster(true);
                SecondaryWSM.TargetingInput(false);
                SecondaryWSM.ZoomingInput(false);
            }
            // End:0x298
            if(((SkyPlayerController(Controller) != none) && int(Physics) == int(1)) && int(RocketPackState) == int(0))
            {
                SkyPlayerController(Controller).StartJump();
                SetTimer(ThrustJumpDelay, false, 'TimedTurnOnRocketPackThrust');                
            }
            else
            {
                TurnOnRocketPackThrust();
                // End:0x2BC
                if(int(Role) < int(ROLE_Authority))
                {
                    ServerTurnOnRocketPackThrust();
                }
            }
        }
    }
    //return;    
}

simulated function TimedTurnOnRocketPackThrust()
{
    // End:0x27
    if(SkyPlayerController(Controller) != none)
    {
        SkyPlayerController(Controller).bWantRocketpackThrust = false;
    }
    TurnOnRocketPackThrust();
    // End:0x4B
    if(int(Role) < int(ROLE_Authority))
    {
        ServerTurnOnRocketPackThrust();
    }
    //return;    
}

reliable server function ServerTurnOnRocketPackThrust()
{
    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        TurnOnRocketPackThrust();
    }
    //return;    
}

reliable server function ServerTurnOffRocketPackThrust()
{
    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        TurnOffRocketPackThrust();
    }
    //return;    
}

// Export USkyPawn::execCanDraw(FFrame&, void* const)
native function bool CanDraw();

simulated event TurnOnRocketPackThrust()
{
    local editinline SkyVehicleSim_CrimsonAircraft SVS_Crimson;
    local SkyPlayerController PC;
    local Weapon Inv;
    local bool hadMovingLevel;

    // End:0xA3
    if((StoredRocketPackThrustController != none) && StoredRocketPackThrustController.bImmediateTetherResting == true)
    {
        // End:0xA3
        if(RocketPackThrustControllerArchetype != none)
        {
            // End:0x6C
            if(SkyAirVehicle(StoredRocketPackThrustController.Pawn) != none)
            {
                SkyAirVehicle(StoredRocketPackThrustController.Pawn).DriverLeave(true);
            }
            StoredRocketPackThrustController.Destroy();
            StoredRocketPackThrustController = Spawn(Class'SkyBotControllerPilot', self,, Location, Rotation, RocketPackThrustControllerArchetype, true);
            RocketPackThrustVehicle = none;
        }
    }
    // End:0xC0
    if(((IsInWalkVolume()) == true) || bIsThrusting)
    {
        return;
    }
    // End:0xF3
    if(((SkyPawnPlayerCharacter(self) != none) && SkyPawnPlayerCharacter(self).bFailedUse) || IsInteracting())
    {
        return;
    }
    // End:0x5B3
    if(RocketPack != none)
    {
        bWasInFreeFall = IsFreefalling();
        bHadPrimaryDrawn = (int(PrimaryWSM.GetState()) == int(3)) || int(PrimaryWSM.GetState()) == int(5);
        PC = SkyPlayerController(Controller);
        // End:0x570
        if(RocketPack.bAllowThrust)
        {
            IKEnabled = false;
            RocketPack.bHasDoubleJump = false;
            SetRocketPackState(2);
            RocketpackLocalEffectThrustComponent = AddLocalEffect(RocketpackLocalEffectThrustSettings);
            // End:0x1D1
            if(RocketPackThrustVehicle == none)
            {
                RocketPackThrustVehicle = RocketPack.StoredRocketPackThrustVehicle;
            }
            // End:0x570
            if(RocketPackThrustVehicle != none)
            {
                // End:0x220
                if(MovingLevel != none)
                {
                    SkyVehicleSim_CrimsonAircraft(RocketPackThrustVehicle.SimObj).UnmodifiedSpeed = LevelMoveThisTick;
                    RemoveFromMovingLevel();
                    hadMovingLevel = true;                    
                }
                else
                {
                    SkyVehicleSim_CrimsonAircraft(RocketPackThrustVehicle.SimObj).UnmodifiedSpeed = vect(0.0000000, 0.0000000, 0.0000000);
                }
                // End:0x318
                if(Controller != none)
                {
                    // End:0x2ED
                    if(PC != none)
                    {
                        // End:0x2B7
                        if(PC.LastRespawnedFromCheckpointTime < (WorldInfo.TimeSeconds - 1.0000000))
                        {
                            RocketPackThrustVehicle.SetVehicleLocationAndRotationRB(Location, PC.CalcViewRotation);                            
                        }
                        else
                        {
                            RocketPackThrustVehicle.SetVehicleLocationAndRotationRB(Location, Rotation);
                        }
                        PC.MostRecentVehiclePossessed = RocketPackThrustVehicle;                        
                    }
                    else
                    {
                        RocketPackThrustVehicle.SetVehicleLocationAndRotationRB(Location, Controller.Rotation);
                    }                    
                }
                else
                {
                    RocketPackThrustVehicle.SetVehicleLocationAndRotationRB(Location, Rotation);
                }
                // End:0x359
                if(MatineeCharacterRefCount > 0)
                {
                    RocketPackThrustVehicle.SetDorment(true);                    
                }
                else
                {
                    RocketPackThrustVehicle.SetDorment(false);
                }
                RocketPackThrustVehicle.bKismetDisabledPrimaryFire = bKismetDisabledRPPrimaryFire;
                RocketPackThrustVehicle.bKismetDisabledSecondaryFire = bKismetDisabledRPSecondaryFire;
                RocketPackThrustVehicle.TryToDrive(self);
                RocketPackThrustVehicle.Takeoff();
                RocketPackThrustVehicle.CurrentCollisionSpeedModifier = 1.0000000;
                RocketPackThrustVehicle.CollisionSpeedRampOutTimer = 0.0000000;
                // End:0x42B
                foreach RocketPackThrustVehicle.InvManager.InventoryActors(Class'Engine.Weapon', Inv)
                {
                    Inv.Activate();                    
                }                
                SVS_Crimson = SkyVehicleSim_CrimsonAircraft(RocketPackThrustVehicle.SimObj);
                // End:0x52A
                if(SVS_Crimson != none)
                {
                    SVS_Crimson.TakeoffStallTimer = SVS_Crimson.TakeoffStallTime;
                    // End:0x4BC
                    if(WorldInfo.DeltaSeconds > 0.0000000)
                    {
                        SVS_Crimson.InitialVel = (float(10) * (CurrentLocation - PreviousLocation)) / WorldInfo.DeltaSeconds;
                    }
                    // End:0x4F9
                    if(hadMovingLevel)
                    {
                        SVS_Crimson.TimerToRampInitialVelOut = SVS_Crimson.TimeToRampInitialVelOutMovingLevel;
                        SVS_Crimson.bWasMovingLevelInitialVel = true;                        
                    }
                    else
                    {
                        SVS_Crimson.TimerToRampInitialVelOut = SVS_Crimson.TimeToRampInitialVelOut;
                        SVS_Crimson.bWasMovingLevelInitialVel = false;
                    }
                }
                // End:0x570
                if(RocketPack.MaterialEffectManager != none)
                {
                    RocketPackThrustVehicle.MaterialEffectManager = RocketPack.MaterialEffectManager;
                    RocketPackThrustVehicle.bTickMatEffectManager = false;
                }
            }
        }
        bIsRocketPacking = true;
        bIsThrusting = true;
        TriggerEventClass(Class'SkySeqEvent_ThrustActivated', self);
        RocketPack.Activate();
        SetFallState(3);
    }
    //return;    
}

simulated event TurnOffRocketPackThrust()
{
    local SkyWeaponBase Weap;

    // End:0x128
    if(bIsThrusting)
    {
        // End:0x38
        if(SkyPawn(ObjectArchetype) != none)
        {
            IKEnabled = SkyPawn(ObjectArchetype).IKEnabled;            
        }
        else
        {
            IKEnabled = default.IKEnabled;
        }
        RocketPackThrustVehicle.ModCollisionPos = false;
        RocketPackThrustVehicle.ModCollisionRot = false;
        bIsThrusting = false;
        // End:0xA9
        if((bHadPrimaryDrawn && HijackTarget == none) && JumpVehicleTarget == none)
        {
            PrimaryWSM.TryDraw();
        }
        // End:0xBF
        if(SkyPawn_Dweller(self) == none)
        {
            GotoRocketPackGlide();
        }
        RocketPackThrustVehicle.SetDorment(true);
        RocketPackThrustVehicle = none;
        RemoveLocalEffect(RocketpackLocalEffectThrustComponent);
        RocketpackLocalEffectThrustComponent = none;
        Weap = SkyWeaponBase(Weapon);
        // End:0x120
        if(Weap != none)
        {
            Weap.ClearRecoilData();
        }
        bWasInFreeFall = false;
    }
    //return;    
}

// Export USkyPawn::execIsFreefalling(FFrame&, void* const)
native simulated function bool IsFreefalling();

simulated event bool IsHighEnoughToFreefall()
{
    local Vector vHitLoc, vHitNorm, vStartLoc, vEndLoc;

    vStartLoc = Location;
    vEndLoc = vStartLoc;
    vEndLoc.Z -= FreefallHeight;
    return Trace(vHitLoc, vHitNorm, vEndLoc, vStartLoc, true, vect(0.0000000, 0.0000000, 0.0000000)) == none;
    //return ReturnValue;    
}

simulated function UpdateJumpVehicleTarget()
{
    JumpVehicleTargetCurrent = none;
    // End:0x7C
    if((SkyAirVehicle_RocketPackThrust(Owner) != none) && int(RocketPackState) == int(2))
    {
        // End:0x7C
        if(SkyPlayerController(SkyVehicle(Owner).Controller) != none)
        {
            JumpVehicleTargetCurrent = SkyPlayerController(SkyVehicle(Owner).Controller).FindJumpVehicleTarget(JumpVehicleThrustFindParams, DrivenVehicle);
        }
    }
    SetTimer(JumpVehicleTargetUpdateTimer + ((FRand() - 0.5000000) * (JumpVehicleTargetUpdateTimer * 0.1000000)), false, 'UpdateJumpVehicleTarget');
    //return;    
}

simulated function Tick(float DeltaTime)
{
    bHasCachedAimVector = false;
    super(Actor).Tick(DeltaTime);
    //return;    
}

simulated event JumpVehicle()
{
    local SkyAirVehicle SkyAV;
    local SkyPlayerController SPC;

    SkyAV = SkyAirVehicle(JumpVehicleTarget);
    // End:0x15B
    if(SkyAV != none)
    {
        // End:0x15B
        if(SkyPlayerController(Controller) != none)
        {
            bGoingIntervehicular = true;
            bIntervehicularFinalApproach = false;
            SetHijackTarget(SkyAV);
            SkyAV.SpawnDriverForHijackInteraction();
            bJumpVehicleTriggerPulled = false;
            // End:0x90
            if((IsGliding()) || bIsThrusting)
            {
                TurnOffRocketPack();
                NotifyRocketPacking = true;
            }
            SetPhysics(13);
            SetCollision(true, false);
            bCollideWorld = false;
            SPC = SkyPlayerController(Controller);
            // End:0x124
            if(SkyAV.bFadeToBlackHijack && SPC != none)
            {
                SPC.HijackFadeToBlack(SkyAV.HJ_TimeUntilFadeToBlack, SkyAV.HJ_TimeOfFadeToBlack, SkyAV.HJ_TimeOfBlack, SkyAV.HJ_TimeOfFadeFromBlack);
            }
            // End:0x15B
            if((HijackPrevVehicleClass != none) && HijackPrevVehicleClass != Class'SkyAirVehicle_RocketPackThrust')
            {
                bHijackBoostActive = true;
                SetTimer(HijackBoostDuration, false, 'HijackBoostTimer');
            }
        }
    }
    //return;    
}

function HijackBoostTimer()
{
    bHijackBoostActive = false;
    //return;    
}

simulated function OnToggleHUD(SeqAct_ToggleHUD inAction)
{
    local PlayerController PlayerCont;

    PlayerCont = PlayerController(Controller);
    // End:0x34
    if(PlayerCont != none)
    {
        PlayerCont.OnToggleHUD(inAction);
    }
    //return;    
}

function SlomoAnimNotifyTimer()
{
    WorldInfo.Game.SetGameSpeed(SlomoAnimNotifyResetSpeed);
    //return;    
}

// Export USkyPawn::execWeaponFired(FFrame&, void* const)
native simulated function WeaponFired(bool bViaReplication, optional Weapon Weap, optional ImpactInfo Impact);

event bool CanPerformTargeting()
{
    // End:0x0D
    if(Weapon == none)
    {
        return false;
    }
    // End:0x39
    if((SkyWeaponBase(Weapon) != none) && SkyWeaponBase(Weapon).bIsLargeWeapon)
    {
        return false;
    }
    return (CanPrimaryWeaponFire(false, true)) && !Weapon.bAllowZoom;
    //return ReturnValue;    
}

// Export USkyPawn::execCanPerformZooming(FFrame&, void* const)
native final function bool CanPerformZooming();

simulated function SetTargeting(bool Value)
{
    // End:0x20
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetTargeting(Value);
    }
    PrimaryWSM.TargetingInput(Value);
    //return;    
}

unreliable server function ServerSetTargeting(bool Value)
{
    // End:0x20
    if(int(Role) == int(ROLE_Authority))
    {
        SetTargeting(Value);
    }
    //return;    
}

simulated event SetTargetingActive(bool Value)
{
    local PlayerController PC;
    local SkyPlayerInput SPI;

    PC = PlayerController(Controller);
    // End:0x74
    if(PC != none)
    {
        SPI = SkyPlayerInput(PC.PlayerInput);
        // End:0x74
        if(SPI != none)
        {
            // End:0x60
            if(Value)
            {
                SPI.StartTargeting();                
            }
            else
            {
                SPI.StopTargeting();
            }
        }
    }
    //return;    
}

simulated function SetZooming(bool Value)
{
    // End:0x20
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetZooming(Value);
    }
    PrimaryWSM.ZoomingInput(Value);
    //return;    
}

unreliable server function ServerSetZooming(bool Value)
{
    // End:0x20
    if(int(Role) == int(ROLE_Authority))
    {
        SetZooming(Value);
    }
    //return;    
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
    local SkyCamera pCam;

    // End:0x4C
    if(SkyPlayerController(Controller) != none)
    {
        pCam = SkyCamera(SkyPlayerController(Controller).PlayerCamera);
        // End:0x4C
        if(pCam != none)
        {
            pCam.bSmoothBlendDisable = true;
        }
    }
    super(Pawn).PlayTeleportEffect(bOut, bSound);
    //return;    
}

event bool Is180ing()
{
    return int(X180State) != int(0);
    //return ReturnValue;    
}

event bool Can180()
{
    return (((((((!IsFalling() && !IsSprinting()) && !IsHijacking()) && !Is180ing()) && !IsInteracting()) && !IsGripping()) && !ThrownFromGripPoint()) && !ReleasedGripPoint()) && !ShotFromGripPoint();
    //return ReturnValue;    
}

simulated event Start180()
{
    X180State = 1;
    //return;    
}

simulated event TakeFallingDamage(Vector HitNormal)
{
    local SkyPlayerControllerBase PC;
    local float UsedFallingDamage, UsedMaxFallSpeedDeath, UsedMaxFallSpeed, Speed;

    // End:0x4D
    if(RocketPack != none)
    {
        UsedFallingDamage = RocketPack.FallingDamage;
        UsedMaxFallSpeedDeath = RocketPack.MaxFallSpeedDeath;
        UsedMaxFallSpeed = RocketPack.MaxFallSpeed;        
    }
    else
    {
        UsedFallingDamage = FallingDamage;
        UsedMaxFallSpeedDeath = MaxFallSpeedDeath;
        UsedMaxFallSpeed = MaxFallSpeed;
    }
    // End:0x7D
    if(IsGliding())
    {
        return;
    }
    // End:0xEA
    if(((HitNormal.X < 0.0001000) && HitNormal.Y < 0.0001000) && HitNormal.Z < 0.0001000)
    {
        Speed = Abs(Velocity.Z);        
    }
    else
    {
        Speed = Abs(HitNormal.Z) * Abs(Velocity.Z);
    }
    // End:0x2A3
    if(Speed > (0.5000000 * UsedMaxFallSpeed))
    {
        // End:0x22E
        if(int(Role) == int(ROLE_Authority))
        {
            MakeNoise(1.0000000);
            // End:0x22E
            if(Speed > UsedMaxFallSpeed)
            {
                // End:0x1C4
                if((UsedFallingDamage == 0.0000000) && UsedMaxFallSpeedDeath != UsedMaxFallSpeed)
                {
                    TakeDamage(int((float(-default.Health) * (-Speed + UsedMaxFallSpeed)) / (UsedMaxFallSpeedDeath - UsedMaxFallSpeed)), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');                    
                }
                else
                {
                    // End:0x203
                    if(Speed > UsedMaxFallSpeedDeath)
                    {
                        TakeDamage(default.Health * 10, none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');                        
                    }
                    else
                    {
                        TakeDamage(int(UsedFallingDamage), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
                    }
                }
            }
        }
        PC = SkyPlayerControllerBase(Controller);
        // End:0x2A0
        if((PC != none) && LocalPlayer(PC.Player) != none)
        {
            PC.DamageShake(int(FMin(1.0000000, (-1.0000000 * Velocity.Z) / UsedMaxFallSpeed)));
        }        
    }
    else
    {
        // End:0x2CD
        if(Velocity.Z < (-1.4000000 * JumpZ))
        {
            MakeNoise(0.5000000);
        }
    }
    //return;    
}

function OnAddNavigationSet(SkySeqAct_AddNavigationSet inAction)
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x42 [Loop If]
    if(Idx < NavigationSets.Length)
    {
        // End:0x38
        if(NavigationSets[Idx] == inAction.NewSet)
        {
            return;
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    NavigationSets[NavigationSets.Length] = inAction.NewSet;
    ResetNavigationSetCache();
    //return;    
}

function OnClearNavigationSets(SkySeqAct_ClearNavigationSets inAction)
{
    NavigationSets.Remove(0, NavigationSets.Length);
    ResetNavigationSetCache();
    //return;    
}

function OnChangeNavigationSets(SkySeqAct_ChangeNavigationSets inAction)
{
    local int Idx;

    NavigationSets.Remove(0, NavigationSets.Length);
    Idx = 0;
    J0x14:

    // End:0x59 [Loop If]
    if(Idx < inAction.NewSets.Length)
    {
        NavigationSets[Idx] = inAction.NewSets[Idx];
        Idx++;
        // [Loop Continue]
        goto J0x14;
    }
    ResetNavigationSetCache();
    //return;    
}

function OnSetInvulnerability(SkySeqAct_SetInvulnerability inAction)
{
    bIsInvulnerable = inAction.bIsInvulnerable;
    //return;    
}

function OnSetWeakPointHealth(SkySeqAct_SetWeakPointHealth inAction)
{
    // End:0x4A
    if(inAction.Index < WeakPoints.Length)
    {
        WeakPoints[inAction.Index].Health = inAction.Health;
    }
    //return;    
}

function bool NeedToTurn(Vector targ)
{
    return NeedToTurnToward(targ);
    //return ReturnValue;    
}

function SetAutoTarget(Actor newAutoTarget)
{
    AutoTarget = newAutoTarget;
    //return;    
}

function gibbedBy(Actor Other)
{
    //return;    
}

event ClearAnimControlFlags()
{
    // End:0x11
    if(bControlledVelocity)
    {
        bControlledVelocity = false;
    }
    // End:0x22
    if(bAutomoveRotateToTarget)
    {
        bAutomoveRotateToTarget = false;
    }
    // End:0x33
    if(bAutomoveTranslateToTarget)
    {
        bAutomoveTranslateToTarget = false;
    }
    // End:0x44
    if(bAutomoveAlignVerticallyWithTarget)
    {
        bAutomoveAlignVerticallyWithTarget = false;
    }
    //return;    
}

// Export USkyPawn::execCheckForStumbleReaction(FFrame&, void* const)
native final function CheckForStumbleReaction(int DamageAmount, Vector Momentum, Actor DamageCauser, Controller EventInstigator);

// Export USkyPawn::execTriggerRandomStumbleReaction(FFrame&, void* const)
native final function bool TriggerRandomStumbleReaction(Vector Direction, SkyPawn.StumbleMagnitude Magnitude, class<Actor> DamageCauser);

// Export USkyPawn::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyPawn::execTakeDamageInStateDying(FFrame&, void* const)
native function TakeDamageInStateDying(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyPawn::execOnWeakPointDestroyed(FFrame&, void* const)
native function OnWeakPointDestroyed(int Index, Actor EventInstigator);

// Export USkyPawn::execAllWeakPointsDestroyed(FFrame&, void* const)
native function bool AllWeakPointsDestroyed();

simulated event SetWeakPointActive(int Index, bool bActive)
{
    // End:0x3D
    if((Index >= 0) && Index < WeakPoints.Length)
    {
        WeakPoints[Index].bInActive = !bActive;
    }
    //return;    
}

// Export USkyPawn::execChooseBoneDamageEntry(FFrame&, void* const)
native function int ChooseBoneDamageEntry(Pawn.EBoneType BoneType);

// Export USkyPawn::execSpecialBoneDamageEffectLogic(FFrame&, void* const)
native function bool SpecialBoneDamageEffectLogic(Pawn.EBoneType BoneType);

// Export USkyPawn::execPlayBoneDamageEffect(FFrame&, void* const)
native function bool PlayBoneDamageEffect(Pawn.EBoneType BoneType);

// Export USkyPawn::execProcessRadiusDamageForWeakpoints(FFrame&, void* const)
native function bool ProcessRadiusDamageForWeakpoints(Controller InstigatedBy, float BaseDamage, float DamageRadius, float InnerDamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser);

// Export USkyPawn::execProcessRadiusDamageForArmor(FFrame&, void* const)
native function float ProcessRadiusDamageForArmor(Controller InstigatedBy, float BaseDamage, float DamageRadius, float InnerDamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser);

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, float InnerDamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser)
{
    local float DamageToDeal;

    // End:0x3D
    if(ProcessRadiusDamageForWeakpoints(InstigatedBy, BaseDamage, DamageRadius, InnerDamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser))
    {
        return;
    }
    bAlreadyProcessedArmor = false;
    DamageToDeal = ProcessRadiusDamageForArmor(InstigatedBy, BaseDamage, DamageRadius, InnerDamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser);
    super(Actor).TakeRadiusDamage(InstigatedBy, DamageToDeal, DamageRadius, InnerDamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser);
    bAlreadyProcessedArmor = false;
    //return;    
}

simulated event EndCrouch(float HeightAdjust)
{
    super(Pawn).EndCrouch(HeightAdjust);
    // End:0x4F
    if(Mesh != none)
    {
        Mesh.SetTranslation(Mesh.Translation - (vect(0.0000000, 0.0000000, 1.0000000) * HeightAdjust));
    }
    //return;    
}

simulated event StartCrouch(float HeightAdjust)
{
    super(Pawn).StartCrouch(HeightAdjust);
    // End:0x4F
    if(Mesh != none)
    {
        Mesh.SetTranslation(Mesh.Translation + (vect(0.0000000, 0.0000000, 1.0000000) * HeightAdjust));
    }
    //return;    
}

simulated event ReleaseSecondaryItem()
{
    // End:0x40
    if(UsingSecondaryItem())
    {
        SkySecondaryItem(SecondaryWeapon).EndFire(0);
        StopSecondaryItemFire(0);
        SetSecondaryItemState(3);
    }
    // End:0xA4
    if((SkyWeapon(Weapon) != none) && SkyWeapon(Weapon).bIsLargeWeapon)
    {
        DropWeapon(SkyWeapon(Weapon));
        CurrWeaponArchetype = SkyWeapon(Weapon.ObjectArchetype);
        WeaponAttachmentChanged();
    }
    //return;    
}

// Export USkyPawn::execUsingSecondaryItem(FFrame&, void* const)
native simulated function bool UsingSecondaryItem();

function bool HoldingDynamite()
{
    // End:0x2C
    if((SkyItem_Dynamite(SecondaryWeapon) != none) && SkyItem_Dynamite(SecondaryWeapon).bThrowing)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CanSwapWeapon()
{
    return (((((((!bIsFreefalling && !UsingSecondaryItem()) && !IsHijacking()) && !IsInteracting()) && !IsPickingUp()) && !IsGripping()) && !ThrownFromGripPoint()) && !ReleasedGripPoint()) && !ShotFromGripPoint();
    //return ReturnValue;    
}

function bool CanReloadWeapon()
{
    local SkyWeapon SkyWeap;

    SkyWeap = SkyWeapon(Weapon);
    // End:0x36
    if((SkyWeap == none) || SkyWeap.HasFullAmmo())
    {
        return false;
    }
    // End:0x41
    if(bIsFreefalling)
    {
        return false;
    }
    // End:0x50
    if(HoldingDynamite())
    {
        return false;
    }
    // End:0x5B
    if(IsPickingUp())
    {
        return false;
    }
    // End:0x74
    if(PrimaryWSM.IsReloading())
    {
        return false;
    }
    // End:0x83
    if(IsGripping())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function ReloadWeapon()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerReloadWeapon();
    }
    // End:0x43
    if(SkyWeapon(Weapon) != none)
    {
        SkyWeapon(Weapon).Reload();
    }
    //return;    
}

reliable server function ServerReloadWeapon()
{
    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        ReloadWeapon();
    }
    //return;    
}

// Export USkyPawn::execPlayImpactEffect(FFrame&, void* const)
native function PlayImpactEffect(Vector HitLocation, Vector HitNormal, class<SkyWeapon> WeaponType);

function bool CanDisablePowercell()
{
    return !IsPickingUp();
    //return ReturnValue;    
}

function DisablePowercell(Actor PowerCell)
{
    PowercellTarget = PowerCell;
    AutomoveTarget = PowercellTarget;
    //return;    
}

simulated function OnCanUseBikes(SkySeqAct_CanUseBikes inAction)
{
    bCanUseBikes = inAction.bCanUseBikes;
    //return;    
}

simulated function OnSetSpeed(SkySeqAct_SetSpeed inAction)
{
    KismetOverride_MaxDesiredSpeed = inAction.SpeedPercent;
    //return;    
}

simulated function OnDetachFromMovingLevel(SkySeqAct_DetachFromMovingLevel inAction)
{
    FlushMovingLevel();
    //return;    
}

event AddVelocity(Vector NewVelocity, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    // End:0x2D
    if((class<SkyDamageType>(DamageType) != none) && class<SkyDamageType>(DamageType).default.bBulletHit)
    {
        return;
    }
    // End:0x52
    if((class<SkyDmgType_SmallExplosives>(DamageType) != none) && VSize(NewVelocity) < RagdollThresholdVelocity)
    {
        return;
    }
    super.AddVelocity(NewVelocity, HitLocation, DamageType, HitInfo);
    //return;    
}

// Export USkyPawn::execFindShortestAngleDifference(FFrame&, void* const)
native final function int FindShortestAngleDifference(int StartAngle, int EndAngle);

simulated function PickBodyPartMesh(SkeletalMeshComponent InOutMesh, array<BodyParts> PossibleMeshes, optional out int MeshIdx)
{
    local int I, J;
    local float maxRand, curRand;

    // End:0x0F
    if(PossibleMeshes.Length <= 0)
    {
        return;
    }
    maxRand = 0.0000000;
    I = 0;
    J0x21:

    // End:0x58 [Loop If]
    if(I < PossibleMeshes.Length)
    {
        maxRand += PossibleMeshes[I].Chance;
        I++;
        // [Loop Continue]
        goto J0x21;
    }
    curRand = FRand() * maxRand;
    I = 0;
    J0x6E:

    // End:0x161 [Loop If]
    if(I < PossibleMeshes.Length)
    {
        // End:0x13A
        if(curRand <= PossibleMeshes[I].Chance)
        {
            MeshIdx = I;
            InOutMesh.SetSkeletalMesh(PossibleMeshes[I].SkelMesh);
            J = 0;
            J0xD8:

            // End:0x138 [Loop If]
            if(J < PossibleMeshes[I].MeshMaterials.Length)
            {
                InOutMesh.SetMaterial(J, PossibleMeshes[I].MeshMaterials[J]);
                ++J;
                // [Loop Continue]
                goto J0xD8;
            }
            return;
        }
        curRand -= PossibleMeshes[I].Chance;
        I++;
        // [Loop Continue]
        goto J0x6E;
    }
    //return;    
}

simulated event bool PickFaceMorph()
{
    local int I, J;
    local float maxRand, curRand;

    // End:0x0E
    if(PossibleHeadMorphs.Length <= 0)
    {
        return false;
    }
    maxRand = 0.0000000;
    I = 0;
    J0x20:

    // End:0x57 [Loop If]
    if(I < PossibleHeadMorphs.Length)
    {
        maxRand += PossibleHeadMorphs[I].Chance;
        I++;
        // [Loop Continue]
        goto J0x20;
    }
    curRand = FRand() * maxRand;
    I = 0;
    J0x6D:

    // End:0x176 [Loop If]
    if(I < PossibleHeadMorphs.Length)
    {
        // End:0x14F
        if(curRand <= PossibleHeadMorphs[I].Chance)
        {
            HeadMorphName = PossibleHeadMorphs[I].MorphNodeName;
            J = 0;
            J0xC0:

            // End:0x142 [Loop If]
            if(J < PossibleHeadMorphs[I].MorphMaterials.Length)
            {
                // End:0x138
                if(PossibleHeadMorphs[I].MorphMaterials[J] != none)
                {
                    HeadMesh.SetMaterial(J, PossibleHeadMorphs[I].MorphMaterials[J]);
                }
                J++;
                // [Loop Continue]
                goto J0xC0;
            }
            HeadMorphIndex = I;
            return true;
        }
        curRand -= PossibleHeadMorphs[I].Chance;
        I++;
        // [Loop Continue]
        goto J0x6D;
    }
    //return ReturnValue;    
}

simulated event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    return Mesh.PlayFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay);
    //return ReturnValue;    
}

simulated event StopActorFaceFXAnim()
{
    Mesh.StopFaceFXAnim();
    //return;    
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
    return FacialAudioComp;
    //return ReturnValue;    
}

simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
    Mesh.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName, inAction.SoundCueToPlay);
    //return;    
}

simulated event FaceFXAsset GetActorFaceFXAsset()
{
    // End:0x32
    if(Mesh.SkeletalMesh != none)
    {
        return Mesh.SkeletalMesh.FaceFXAsset;        
    }
    else
    {
        return none;
    }
    //return ReturnValue;    
}

simulated function bool IsActorPlayingFaceFXAnim()
{
    return (Mesh != none) && Mesh.IsPlayingFaceFXAnim();
    //return ReturnValue;    
}

function bool CannotJumpNow()
{
    return (((((((super(Pawn).CannotJumpNow() || ((int(FallState) != int(5)) && int(FallState) != int(1)) && int(FallState) != int(4)) || IsInteracting()) || IsPickingUp()) || bIsRocketPacking) || IsGripping()) || ThrownFromGripPoint()) || ReleasedGripPoint()) || ShotFromGripPoint();
    //return ReturnValue;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    local TraceHitInfo HitInfo;
    local PlayerController PC;
    local bool bPlayersRagdoll;

    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
    bForcedFeignDeath = false;
    bPlayingFeignDeathRecovery = false;
    HitDamageType = DamageType;
    TakeHitLocation = HitLoc;
    // End:0x70
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        GotoState('Dying');
        return;
    }
    // End:0xEE
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xED
        if(PC.ViewTarget == self)
        {
            // End:0xE2
            if(SkyHUD(PC.myHUD) != none)
            {
                SkyHUD(PC.myHUD).DisplayHit(HitLoc, 100, DamageType);
            }
            bPlayersRagdoll = true;
            // End:0xEE
            break;
        }        
    }    
    // End:0x13C
    if((((WorldInfo.TimeSeconds - LastRenderTime) > float(3)) && int(WorldInfo.NetMode) != int(NM_ListenServer)) && !bPlayersRagdoll)
    {
        Destroy();
        return;
    }
    CheckHitInfo(HitInfo, Mesh, Normal(TearOffMomentum), TakeHitLocation);
    GotoState('Dying');
    //return;    
}

// Export USkyPawn::execWeaponStoppedFiring(FFrame&, void* const)
native simulated function WeaponStoppedFiring(bool bViaReplication, optional Weapon Weap);

simulated event SetupWeapon(SkyWeaponAttachment Attachment, name SocketName, int incRefCount)
{
    local bool bIsSecondary, refCountBailEarly;

    refCountBailEarly = true;
    HandSwapRefCount += incRefCount;
    // End:0x2A
    if(incRefCount == 0)
    {
        refCountBailEarly = false;        
    }
    else
    {
        // End:0x4D
        if((incRefCount > 0) && HandSwapRefCount == 1)
        {
            refCountBailEarly = false;            
        }
        else
        {
            // End:0x6D
            if((incRefCount < 0) && HandSwapRefCount == 0)
            {
                refCountBailEarly = false;
            }
        }
    }
    // End:0x7F
    if(HandSwapRefCount < 0)
    {
        HandSwapRefCount = 0;
    }
    // End:0x9A
    if((Attachment == none) || refCountBailEarly == true)
    {
        return;
    }
    // End:0xBF
    if(Attachment.WeaponArchetype.bIsSecondaryWeapon)
    {
        bIsSecondary = true;
    }
    // End:0x176
    if((SocketName != 'None') && SocketName != 'None')
    {
        // End:0x176
        if((bIsSecondary && SecondaryWeaponBone != SocketName) || WeaponBone != SocketName)
        {
            Attachment.DetachFrom(Mesh);
            // End:0x142
            if(bIsSecondary)
            {
                SecondaryWeaponBone = SocketName;                
            }
            else
            {
                WeaponBone = SocketName;
            }
            Attachment.AttachTo(self);
            Attachment.CopyDroppedPickupToAttachment();
        }
    }
    //return;    
}

simulated event SetSkin(Material NewMaterial)
{
    local int I;

    ReplicatedBodyMaterial = NewMaterial;
    // End:0x124
    if(VerifyBodyMaterialInstance())
    {
        // End:0x3C
        if(CurrWeaponAttachment != none)
        {
            CurrWeaponAttachment.SetSkin(NewMaterial);
        }
        // End:0x6A
        if(SkyWeapon(Weapon) != none)
        {
            SkyWeapon(Weapon).SetSkin(NewMaterial);
        }
        // End:0xD1
        if(NewMaterial == none)
        {
            I = 0;
            J0x7C:

            // End:0xCE [Loop If]
            if(I < Mesh.SkeletalMesh.Materials.Length)
            {
                Mesh.SetMaterial(I, BodyMaterialInstances[I]);
                I++;
                // [Loop Continue]
                goto J0x7C;
            }            
        }
        else
        {
            I = 0;
            J0xD8:

            // End:0x124 [Loop If]
            if(I < Mesh.SkeletalMesh.Materials.Length)
            {
                Mesh.SetMaterial(I, NewMaterial);
                I++;
                // [Loop Continue]
                goto J0xD8;
            }
        }
    }
    //return;    
}

simulated event ActivateDeathMaterials()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x196 [Loop If]
    if(I < DeathMaterials.Length)
    {
        switch(DeathMaterials[I].MeshType)
        {
            // End:0x73
            case 0:
                SetMaterialInstanceConstant(Mesh, DeathMaterials[I].Index, DeathMaterials[I].Material);
                // End:0x18C
                break;
            // End:0xB6
            case 1:
                SetMaterialInstanceConstant(HairMesh, DeathMaterials[I].Index, DeathMaterials[I].Material);
                // End:0x18C
                break;
            // End:0xF9
            case 2:
                SetMaterialInstanceConstant(HeadMesh, DeathMaterials[I].Index, DeathMaterials[I].Material);
                // End:0x18C
                break;
            // End:0x13C
            case 3:
                SetMaterialInstanceConstant(LegMesh, DeathMaterials[I].Index, DeathMaterials[I].Material);
                // End:0x18C
                break;
            // End:0x189
            case 4:
                SetMaterialInstanceConstant(RocketPack.Mesh, DeathMaterials[I].Index, DeathMaterials[I].Material);
                // End:0x18C
                break;
            // End:0xFFFF
            default:
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function SetWeaponAttachmentVisibility(bool bAttachmentVisible)
{
    // End:0x25
    if(CurrWeaponAttachment != none)
    {
        CurrWeaponAttachment.ChangeVisibility(bAttachmentVisible);
    }
    //return;    
}

simulated function ApplyWeaponOverlayFlags(byte NewFlags)
{
    // End:0x1B
    if(int(Role) == int(ROLE_Authority))
    {
        WeaponOverlayFlags = NewFlags;
    }
    // End:0x55
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x55
        if(CurrWeaponAttachment != none)
        {
            CurrWeaponAttachment.SetWeaponOverlayFlags(self);
        }
    }
    //return;    
}

simulated event WeaponAttachmentChanged()
{
    local SkyWeapon SW;

    // End:0x121
    if(((CurrWeaponArchetype == none) || CurrWeaponAttachment == none) || CurrWeaponAttachment.Class != CurrWeaponArchetype.AttachClass)
    {
        // End:0x6E
        if(CurrWeaponAttachment != none)
        {
            CurrWeaponAttachment.DetachFrom(Mesh);
            CurrWeaponAttachment.Destroy();
        }
        CurrWeaponAttachment = none;
        // End:0x101
        if((CurrWeaponArchetype != none) && CurrWeaponArchetype.AttachClass != none)
        {
            CurrWeaponAttachment = Spawn(CurrWeaponArchetype.AttachClass, self);
            // End:0x101
            if(CurrWeaponAttachment != none)
            {
                CurrWeaponAttachment.Instigator = self;
                CurrWeaponAttachment.SetWeaponArchetype(CurrWeaponArchetype);
                CurrWeaponAttachment.CopyDroppedPickupToAttachment();
            }
        }
        // End:0x121
        if(CurrWeaponAttachment != none)
        {
            CurrWeaponAttachment.AttachTo(self);
        }
    }
    SW = SkyWeapon(Weapon);
    // End:0x150
    if(SW != none)
    {
        SW.UpdateHideWeaponSkelControl();
    }
    //return;    
}

// Export USkyPawn::execGetEffectLocation(FFrame&, void* const)
native simulated function Vector GetEffectLocation();

simulated function AnimNotifyDeath(optional SkyPawn.EDamageSource Source)
{
    local Controller Killer;
    local class<DamageType> DamageType;

    // End:0x2B
    if(int(Source) == int(2))
    {
        Killer = Pawn(Owner).LastHitBy;
    }
    // End:0x49
    if(int(Source) == int(0))
    {
        DamageType = Class'Engine.DmgType_Suicided';        
    }
    else
    {
        // End:0x64
        if(int(Source) == int(1))
        {
            DamageType = Class'Engine.DmgType_Fell';
        }
    }
    Health = 0;
    Died(Killer, DamageType, Owner.Location);
    //return;    
}

// Export USkyPawn::execIsAutomoving(FFrame&, void* const)
native function bool IsAutomoving();

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    local SkyPawnCoverUser SPCU;

    // End:0x97
    if((IsInWalkVolume()) == true)
    {
        // End:0x27
        if(IsInteracting())
        {
            AbortInteraction();
        }
        // End:0x3E
        if(IsSprinting())
        {
            StopSprint();
        }
        // End:0x55
        if(IsRocketPacking())
        {
            TurnOffRocketPack();
        }
        SPCU = SkyPawnCoverUser(self);
        // End:0x97
        if((SPCU != none) && SPCU.IsInCover())
        {
            SPCU.PerformReleaseCover(true, false);
        }
    }
    super(Actor).PhysicsVolumeChange(NewVolume);
    //return;    
}

// Export USkyPawn::execDoBlowApart(FFrame&, void* const)
native final function DoBlowApart();

simulated event KillPawn()
{
    //return;    
}

// Export USkyPawn::execIsPickingUp(FFrame&, void* const)
native final function bool IsPickingUp();

simulated function bool BeginWeaponPickup(Actor Pickup, bool Factory, bool primary, bool bIsLargeWeapon)
{
    local SkyWeaponPickup SkyWeapPickup;
    local SkyWeaponPickupFactory PickupFactory;
    local class<Inventory> PickupInventoryClass, CurrentWeaponClass;
    local SkyWeapon SkyWeap;

    // End:0x1F
    if((int(PickupState) != int(0)) || Pickup == none)
    {
        return false;
    }
    PickupFactory = SkyWeaponPickupFactory(Pickup);
    SkyWeapPickup = SkyWeaponPickup(Pickup);
    // End:0x60
    if(Factory)
    {
        PickupInventoryClass = PickupFactory.InventoryType;        
    }
    else
    {
        PickupInventoryClass = SkyWeapPickup.InventoryClass;
    }
    // End:0xA3
    if(primary && Weapon != none)
    {
        CurrentWeaponClass = Weapon.Class;        
    }
    else
    {
        // End:0xC3
        if(SecondaryWeapon != none)
        {
            CurrentWeaponClass = SecondaryWeapon.Class;
        }
    }
    // End:0xE4
    if(primary)
    {
        PrimaryWSM.Acquire(false);        
    }
    else
    {
        SecondaryWSM.Acquire(false);
    }
    bPickupState_Swap = false;
    bPickupState_Ammo = false;
    bPickupState_NonWeapon = false;
    bPickupState_Primary = primary;
    SkyWeap = SkyWeapon(Weapon);
    // End:0x23F
    if((primary && Weapon != none) || !primary && SecondaryWeapon != none)
    {
        // End:0x1DC
        if(CurrentWeaponClass == PickupInventoryClass)
        {
            bPickupState_Ammo = true;
            // End:0x1A8
            if(primary)
            {
                // End:0x1A5
                if((SkyWeap != none) && SkyWeap.AmmoFullyMaxed(0))
                {
                    return false;
                }                
            }
            else
            {
                // End:0x1D9
                if((SkyWeapon(SecondaryWeapon) != none) && SkyWeapon(SecondaryWeapon).AmmoFullyMaxed(0))
                {
                    return false;
                }
            }            
        }
        else
        {
            // End:0x20C
            if(((BackWeapon != none) && !bIsLargeWeapon) || !primary)
            {
                bPickupState_Swap = true;                
            }
            else
            {
                // End:0x23F
                if((bIsLargeWeapon && SkyWeap != none) && SkyWeap.bIsLargeWeapon)
                {
                    bPickupState_Swap = true;
                }
            }
        }
    }
    PlayerController(Controller).IgnoreMoveInput(true);
    AutomoveTarget = Pickup;
    bAutomoveTranslateToTarget = true;
    bAutomoveRotateToTarget = true;
    bAutomove_TranslateAssumeTargetLocation = false;
    bAutomove_TranslateAssumeTargetXYOnly = false;
    Automove_TranslateStopDistFromTarget = 0.0000000;
    Automove_TranslateTime = 0.2000000;
    Automove_RotateTime = 0.2000000;
    bCanPickupInventory = false;
    PickupState = 1;
    // End:0x2E4
    if(SkyPawnSoundGroup(SoundGroup) != none)
    {
        PlayVoiceOver(SkyPawnSoundGroup(SoundGroup).VO_FoundGun);
    }
    return true;
    //return ReturnValue;    
}

simulated function bool BeginItemPickup(Actor inPickup)
{
    // End:0x1F
    if((int(PickupState) != int(0)) || inPickup == none)
    {
        return false;
    }
    bPickupState_Swap = true;
    bPickupState_Ammo = false;
    bPickupState_Primary = false;
    bPickupState_NonWeapon = true;
    PlayerController(Controller).IgnoreMoveInput(true);
    AutomoveTarget = inPickup;
    bAutomoveTranslateToTarget = true;
    bAutomoveRotateToTarget = true;
    bAutomove_TranslateAssumeTargetLocation = false;
    bAutomove_TranslateAssumeTargetXYOnly = false;
    Automove_TranslateStopDistFromTarget = 0.0000000;
    Automove_TranslateTime = 0.2000000;
    Automove_RotateTime = 0.2000000;
    bCanPickupInventory = false;
    PickupState = 1;
    return true;
    //return ReturnValue;    
}

simulated function ReadyToPickup()
{
    local SkyWeaponPickup PickupDropped;
    local SkyWeaponPickupFactory PickupFactory;

    // End:0x0B
    if(AutomoveTarget == none)
    {
    }
    PickupFactory = SkyWeaponPickupFactory(AutomoveTarget);
    PickupDropped = SkyWeaponPickup(AutomoveTarget);
    // End:0x109
    if(PickupFactory != none)
    {
        // End:0xD0
        if(bPickupState_Ammo && SkyInventoryManager(InvManager) != none)
        {
            SkyInventoryManager(InvManager).AddAmmoToWeapon(PickupFactory.SpawnedArchetype.MaxAmmoCount + PickupFactory.SpawnedArchetype.AdditionalAmmo, PickupFactory.SpawnedArchetype.Class);
            PickupFactory.PickedUpBy(self);            
        }
        else
        {
            // End:0x106
            if(PickupFactory.CanGive(SkyPlayerReplicationInfo(PlayerReplicationInfo)))
            {
                PickupFactory.Give(self);
            }
        }        
    }
    else
    {
        // End:0x1BA
        if(PickupDropped != none)
        {
            // End:0x184
            if(bPickupState_Ammo && SkyInventoryManager(InvManager) != none)
            {
                SkyInventoryManager(InvManager).AddAmmoToWeapon(PickupDropped.ContainedAmmo, class<SkyWeapon>(PickupDropped.InventoryClass));
                PickupDropped.PickedUpBy(self);                
            }
            else
            {
                // End:0x1BA
                if(PickupDropped.CanGive(SkyPlayerReplicationInfo(PlayerReplicationInfo)))
                {
                    PickupDropped.Give(self);
                }
            }
        }
    }
    // End:0x250
    if(((Mesh != none) && int(Mesh.DepthPriorityGroup) == int(2)) && CurrWeaponAttachment != none)
    {
        // End:0x21F
        if(CurrWeaponAttachment.Mesh != none)
        {
            CurrWeaponAttachment.Mesh.SetDepthPriorityGroup(2);
        }
        // End:0x250
        if(CurrWeaponAttachment.MuzzleFlashPSC != none)
        {
            CurrWeaponAttachment.MuzzleFlashPSC.SetDepthPriorityGroup(2);
        }
    }
    AutomoveTarget = none;
    bCanPickupInventory = true;
    //return;    
}

simulated function ReadyToPickupItem()
{
    local SkyPickup Pickup;
    local SkyPickupFactory PickupFactory;
    local bool PickupRocketpack;

    // End:0x0B
    if(AutomoveTarget == none)
    {
    }
    PickupFactory = SkyPickupFactory(AutomoveTarget);
    Pickup = SkyPickup(AutomoveTarget);
    PickupRocketpack = false;
    // End:0xA4
    if(PickupFactory != none)
    {
        // End:0xA1
        if(PickupFactory.CanGive(SkyPlayerReplicationInfo(PlayerReplicationInfo)))
        {
            // End:0x8C
            if(class<SkyItem_RocketPack>(PickupFactory.InventoryType) != none)
            {
                DropRocketPack();
                PickupRocketpack = true;
            }
            PickupFactory.Give(self);
        }        
    }
    else
    {
        // End:0x112
        if(Pickup != none)
        {
            // End:0x112
            if(Pickup.CanGive(SkyPlayerReplicationInfo(PlayerReplicationInfo)))
            {
                // End:0xFD
                if(class<SkyItem_RocketPack>(Pickup.InventoryClass) != none)
                {
                    DropRocketPack();
                    PickupRocketpack = true;
                }
                Pickup.Give(self);
            }
        }
    }
    // End:0x135
    if(PickupRocketpack)
    {
        RocketPack = FindRocketPackInInventory();
        AttachRocketPackHelper();
    }
    AutomoveTarget = none;
    bCanPickupInventory = true;
    //return;    
}

simulated event FinishedPickup()
{
    PlayerController(Controller).IgnoreMoveInput(false);
    bPickupState_NonWeapon = false;
    PickupState = 0;
    //return;    
}

simulated event FinishAcquiringWeapon(bool bPrimary)
{
    // End:0x20
    if(bPrimary)
    {
        PrimaryWSM.AcquisitionComplete();        
    }
    else
    {
        SecondaryWSM.AcquisitionComplete();
    }
    //return;    
}

function DropWeapon(SkyWeapon drop, optional bool bAuxiliary, optional int auxIndex)
{
    local Vector SocketLocation;
    local Rotator SocketRotation;
    local Vector RelativeVelocity;

    // End:0x3E
    if(bAuxiliary)
    {
        Mesh.GetSocketWorldLocationAndRotation(AuxWeapons[auxIndex].Socket, SocketLocation, SocketRotation);        
    }
    else
    {
        Mesh.GetSocketWorldLocationAndRotation(TwoHandedWeaponBone, SocketLocation, SocketRotation);
    }
    RelativeVelocity = Pickup_DropVelocity >> Rotation;
    drop.DropFromEx(SocketLocation, SocketRotation, Velocity + RelativeVelocity, Pickup_AngularVelocity >> SocketRotation, bAuxiliary, auxIndex);
    //return;    
}

reliable server function SwapPrimaryWeapon(optional bool AllowStoreOfPrimary)
{
    local SkyBaseInventoryManager InvMgr;

    InvMgr = SkyBaseInventoryManager(InvManager);
    // End:0x5C
    if(InvMgr != none)
    {
        // End:0x43
        if(PrevWeapon != none)
        {
            InvMgr.SetCurrentWeapon(PrevWeapon);            
        }
        else
        {
            InvMgr.SetCurrentWeapon(BackWeapon);
        }
    }
    GroundSpeed = GetPawnGroundSpeed();
    //return;    
}

// Export USkyPawn::execFiredUpon(FFrame&, void* const)
native final function FiredUpon();

simulated function ChangeRocketpack(SkyItem_RocketPack newPack)
{
    // End:0x16
    if(RocketPack != none)
    {
        DropRocketPack(true);
    }
    RocketPack = newPack;
    AttachRocketPackHelper();
    //return;    
}

simulated function DropRocketPack(optional bool bDontDropOldPack)
{
    local Vector SocketLocation;
    local Rotator SocketRotation;
    local Vector RelativeVelocity;

    InvManager.RemoveFromInventory(RocketPack);
    RocketPack.DetachFrom();
    Mesh.DetachComponent(RocketPack.Mesh);
    Mesh.GetSocketWorldLocationAndRotation(TwoHandedWeaponBone, SocketLocation, SocketRotation);
    RelativeVelocity = Pickup_DropVelocity >> Rotation;
    // End:0xD6
    if(bDontDropOldPack == false)
    {
        RocketPack.DropFromSkyInv(SocketLocation, SocketRotation, Velocity + RelativeVelocity, Pickup_AngularVelocity >> SocketRotation, Inventory(RocketPack.ObjectArchetype));
    }
    RocketPack = none;
    //return;    
}

simulated function SkyItem_RocketPack FindRocketPackInInventory()
{
    return SkyItem_RocketPack(InvManager.FindInventoryType(Class'SkyItem_RocketPack', false));
    //return ReturnValue;    
}

// Export USkyPawn::execAttachRocketPackHelper(FFrame&, void* const)
native function AttachRocketPackHelper();

// Export USkyPawn::execDetachRocketPackHelper(FFrame&, void* const)
native function DetachRocketPackHelper();

// Export USkyPawn::execMAT_BeginAnimControl(FFrame&, void* const)
native function MAT_BeginAnimControl(array<AnimSet> InAnimSets);

// Export USkyPawn::execMAT_SetAnimPosition(FFrame&, void* const)
native function MAT_SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping);

// Export USkyPawn::execMAT_SetAnimWeights(FFrame&, void* const)
native function MAT_SetAnimWeights(array<AnimSlotInfo> SlotInfos);

// Export USkyPawn::execMAT_FinishAnimControl(FFrame&, void* const)
native function MAT_FinishAnimControl();

simulated event BeginAnimControl(array<AnimSet> InAnimSets)
{
    MAT_BeginAnimControl(InAnimSets);
    //return;    
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    MAT_SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping);
    //return;    
}

// Export USkyPawn::execSetAnimWeights(FFrame&, void* const)
native function SetAnimWeights(array<AnimSlotInfo> SlotInfos);

simulated event FinishAnimControl()
{
    MAT_FinishAnimControl();
    //return;    
}

simulated function ResetCanPlayImpactSound()
{
    bCanPlayImpactSound = true;
    //return;    
}

// Export USkyPawn::execIsFirstPerson(FFrame&, void* const)
native simulated function bool IsFirstPerson();

function LandedFailsafe()
{
    // End:0x1C
    if(int(FallState) == int(4))
    {
        SetFallState(5);
    }
    //return;    
}

simulated function MindControlBegin(Pawn pInstigator, float fDuration, int nExtraHealth, int nDamage, float fDamageRadius, bool bKillVictim, class<DamageType> DamageType)
{
    //return;    
}

simulated event MindControlEnd()
{
    //return;    
}

event DeactivateSpawnProtection()
{
    // End:0x12
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    // End:0xC7
    if(!bSpawnDone)
    {
        bSpawnDone = true;
        // End:0xBC
        if((WorldInfo.TimeSeconds - SpawnTime) < SkyGame(WorldInfo.Game).SpawnProtectionTime)
        {
            bSpawnIn = true;
            // End:0x82
            if(BodyMatColor == SpawnProtectionColor)
            {
                ClearBodyMatColor();
            }
            SpawnTime = (WorldInfo.TimeSeconds - SkyGame(WorldInfo.Game).SpawnProtectionTime) - float(1);
        }
        SpawnTime = -100000.0000000;
    }
    //return;    
}

simulated event SetupWeaponIK(name ControlName, SkyWeaponAttachment Attachment)
{
    Attachment.SetupIK(ControlName);
    //return;    
}

simulated event CleanupWeaponIK(name ControlName, SkyWeaponAttachment Attachment)
{
    Attachment.CleanupIK(ControlName);
    //return;    
}

simulated event RemoveInventory(Inventory Item)
{
    InvManager.RemoveFromInventory(Item);
    //return;    
}

simulated event AddInventory(Inventory Item)
{
    Item.GiveTo(self);
    Item.AnnouncePickup(self);
    //return;    
}

event ScriptedDeath()
{
    SkyDied(Controller, Class'Engine.DmgType_Crushed', Location + vect(0.0000000, 0.0000000, 32.0000000));
    //return;    
}

event bool SkyDied(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local bool retval;

    // End:0x12
    if(Health > 0)
    {
        Health = 0;
    }
    // End:0x3C
    if(SkyWeapon(Weapon) != none)
    {
        SkyWeapon(Weapon).ZoomSetOwnerNoSee(false);
    }
    // End:0x52
    if(DamageType == none)
    {
        DamageType = Class'Engine.DamageType';
    }
    // End:0x70
    if(IsZero(TearOffMomentum))
    {
        TearOffMomentum = vect(0.0000000, 0.0000000, 1.0000000);
    }
    bBlocksNavigation = false;
    // End:0xBB
    if(int(Role) == int(ROLE_Authority))
    {
        WorldInfo.Game.BroadcastDeathMessage(Killer, self.Controller, DamageType);
    }
    // End:0xDB
    if(KismetAIFactory != none)
    {
        KismetAIFactory.TriggerDeath(self);
    }
    retval = Died(Killer, DamageType, HitLocation);
    return retval;
    //return ReturnValue;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    // End:0x59
    if(int(Role) == int(ROLE_Authority))
    {
        Health = -1;
        Died(none, dmgType, Location);
        // End:0x59
        if(dmgType == none)
        {
            SetPhysics(0);
            SetHidden(true);
            LifeSpan = FMin(LifeSpan, 1.0000000);
        }
    }
    //return;    
}

event SetHealth(int inHealth)
{
    Health = Max(HealthMin, inHealth);
    //return;    
}

event OnSetMinHealth(SeqAct_SetMinHealth Action)
{
    HealthMin = Action.MinHealth;
    // End:0x2F
    if(HealthMin > default.Health)
    {
        HealthMin = default.Health;
    }
    // End:0x49
    if(Health < HealthMin)
    {
        Health = HealthMin;
    }
    //return;    
}

event StartHitReaction(SkyPawn.EReactionCategory category, optional float ParamValue, optional class<DamageType> DamageType)
{
    // End:0x16
    if(int(category) >= ReactionProfiles.Length)
    {
        return;
    }
    // End:0x1BB
    if(((ReactionProfiles[int(category)].LastReactionTime == float(0)) || (WorldInfo.TimeSeconds - ReactionProfiles[int(category)].LastReactionTime) > ReactionProfiles[int(category)].MinDelay) && (ReactionProfiles[int(category)].LastOccurTime == float(0)) || (WorldInfo.TimeSeconds - ReactionProfiles[int(category)].LastOccurTime) > ReactionProfiles[int(category)].MinQuietPeriod)
    {
        ReactionProfiles[int(category)].Parameter = ParamValue;
        ReactionProfiles[int(category)].DamageType = DamageType;
        ReactionProfiles[int(category)].LastReactionTime = WorldInfo.TimeSeconds;
        // End:0x1BB
        if(SkyPawnSoundGroup(SoundGroup) != none)
        {
            // End:0x18D
            if(int(category) == int(2))
            {
                PlayVoiceOver(SkyPawnSoundGroup(SoundGroup).VO_ShotAtClose);                
            }
            else
            {
                // End:0x1BB
                if(int(category) == int(3))
                {
                    PlayVoiceOver(SkyPawnSoundGroup(SoundGroup).VO_GettingHit);
                }
            }
        }
    }
    ReactionProfiles[int(category)].LastOccurTime = WorldInfo.TimeSeconds;
    //return;    
}

simulated function PlayCachedKilledEnemyVO()
{
    PlayVoiceOver(CachedKilledEnemyVO);
    //return;    
}

event PossessVehForCheckpoint(Vehicle Veh)
{
    local SkyAirVehicle SkyAVeh;

    OverrideVehicleEnter = true;
    Veh.TryToDrive(self);
    SkyAVeh = SkyAirVehicle(Veh);
    // End:0x6E
    if(SkyAVeh != none)
    {
        SkyAVeh.ForceFlying();
        // End:0x6E
        if(int(SkyAVeh.CockpitState) == int(0))
        {
            bStasis = true;
        }
    }
    //return;    
}

// Export USkyPawn::execIsValidSoundContext(FFrame&, void* const)
native function bool IsValidSoundContext(name SoundContext);

// Export USkyPawn::execIsValidEffectContext(FFrame&, void* const)
native function bool IsValidEffectContext(name EffectContext);

// Export USkyPawn::execIsValidEffectType(FFrame&, void* const)
native function bool IsValidEffectType(name EffectType);

// Export USkyPawn::execGetContextualEffect(FFrame&, void* const)
native function ParticleSystem GetContextualEffect(name EffectContext);

// Export USkyPawn::execEnablePhysics(FFrame&, void* const)
native function EnablePhysics(PhysicsAsset NewPhysicsAsset, float NewPhysicsWeight);

// Export USkyPawn::execDisablePhysics(FFrame&, void* const)
native function DisablePhysics();

function ManualTransition_PWSM_FailSafeTimer()
{
    PrimaryWSM.AttachWeaponToPawn();
    //return;    
}

function ManualTransition_SWSM_FailSafeTimer()
{
    SecondaryWSM.AttachWeaponToPawn();
    //return;    
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    local array<Object> objVars;
    local int Idx;
    local Actor destActor;
    local Controller C;
    local SkyCamera pCam;
    local bool bResult;
    local SkyCameraTree pCamTree;
    local TraceHitInfo HitInfo;
    local Vector HitLoc, HitNorm, TraceDir;

    RemoveFromMovingLevel();
    Action.GetObjectVars(objVars, "Destination");
    Idx = 0;
    J0x33:

    // End:0xB7 [Loop If]
    if((Idx < objVars.Length) && destActor == none)
    {
        destActor = Actor(objVars[Idx]);
        C = Controller(destActor);
        // End:0xAD
        if((C != none) && C.Pawn != none)
        {
            destActor = C.Pawn;
        }
        Idx++;
        // [Loop Continue]
        goto J0x33;
    }
    // End:0x392
    if(destActor != none)
    {
        // End:0xF8
        if(Action.bIgnoreCollision)
        {
            bResult = SetLocationNoCheck(destActor.Location);            
        }
        else
        {
            bResult = SetLocation(destActor.Location);
        }
        // End:0x11C
        if(!bResult)
        {
        }
        CurrentLocation = Location;
        PreviousLocation = Location;
        PlayTeleportEffect(false, true);
        // End:0x1BE
        if(Action.bUpdateRotation)
        {
            SetRotation(destActor.Rotation);
            DesiredRotation = destActor.Rotation;
            // End:0x1BE
            if(Controller != none)
            {
                Controller.SetRotation(destActor.Rotation);
                Controller.DesiredRotation = destActor.Rotation;
            }
        }
        // End:0x27D
        if(Action.bSnapToGround)
        {
            TraceDir.Z = CylinderComponent.CollisionHeight;
            Trace(HitLoc, HitNorm, Location - (2.0000000 * TraceDir), Location, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 8);
            // End:0x27D
            if(HitLoc.Z > (Location.Z - (2.0000000 * TraceDir.Z)))
            {
                SetLocation(HitLoc + TraceDir);
                SetPhysics(1);
            }
        }
        bFirstFootPlacementUpdateDone = false;
        // End:0x2D8
        if(SkyPlayerController(Controller) != none)
        {
            SkyPlayerController(Controller).CalcViewRotation = destActor.Rotation;
            pCam = SkyCamera(SkyPlayerController(Controller).PlayerCamera);
        }
        // End:0x392
        if(pCam != none)
        {
            pCam.bSmoothBlendDisable = true;
            pCam.bCollInitialized = false;
            pCamTree = pCam.CamTreeRoot;
            // End:0x344
            if(pCamTree != none)
            {
                pCamTree.AutoPitchInfo.CurrState = 0;
            }
            // End:0x392
            if(Action.bUpdateRotation)
            {
                pCam.SetRotation(destActor.Rotation);
                pCam.DesiredRotation = destActor.Rotation;
            }
        }
    }
    // End:0x3B2
    if(Controller != none)
    {
        Controller.OnTeleport(none);
    }
    //return;    
}

// Export USkyPawn::execShouldUpdatePawnRotation(FFrame&, void* const)
native function bool ShouldUpdatePawnRotation();

simulated event bool MyCanAttack(Actor Other)
{
    return CanAttack(Other);
    //return ReturnValue;    
}

function bool CanAttack(Actor Other)
{
    local bool bResult;

    bResult = CanAttackRegardlessOfWeapon(Other);
    return bResult && super(Pawn).CanAttack(Other);
    //return ReturnValue;    
}

event bool CanAttackRegardlessOfWeapon(Actor Other)
{
    local SkyPawn SPOther;

    SPOther = SkyPawn(Other);
    // End:0x65
    if(SPOther != none)
    {
        // End:0x34
        if(SPOther.IsHijacking())
        {
            return false;
        }
        // End:0x65
        if(SPOther.IsGripping() && SPOther.GetGrippee() != self)
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

// Export USkyPawn::execModifyDamageForArmor(FFrame&, void* const)
native function float ModifyDamageForArmor(Pawn.EBoneType BoneType, int Damage, float BoneMultiplier, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, Actor DamageCauser);

// Export USkyPawn::execDestroyAllArmor(FFrame&, void* const)
native function DestroyAllArmor();

event DestroyArmor(SkyPawn.EArmorType ArmorType)
{
    local int Idx;
    local SkelControlBase SkelCtl;

    Idx = GetArmorInfoIndex(ArmorType);
    // End:0x197
    if(Idx != -1)
    {
        ArmorInfo[Idx].Health = 0.0000000;
        ArmorInfo[Idx].MorphNode.SetNodeWeight(1.0000000);
        ArmorInfo[Idx].bShouldPlayEffects = true;
        // End:0xD6
        if(ArmorInfo[Idx].DestructionEffect.Sound != none)
        {
            PlaySound(ArmorInfo[Idx].DestructionEffect.Sound);
        }
        // End:0x102
        if((AllArmorDestroyedSound != none) && !HasArmor())
        {
            PlaySound(AllArmorDestroyedSound);
        }
        SpawnBoneDamagePhysics(ArmorInfo[Idx].DestructionEffect);
        // End:0x197
        if(ArmorInfo[Idx].DestructionSkelCtrl != 'None')
        {
            SkelCtl = Mesh.FindSkelControl(ArmorInfo[Idx].DestructionSkelCtrl);
            // End:0x197
            if(SkelCtl != none)
            {
                SkelCtl.SetSkelControlStrength(1.0000000, 0.0000000);
            }
        }
    }
    return;
    //return;    
}

// Export USkyPawn::execSpawnBoneDamagePhysics(FFrame&, void* const)
native simulated function SpawnBoneDamagePhysics(SBoneDamageEffect Effect);

// Export USkyPawn::execGetSpecialDamageBone(FFrame&, void* const)
native simulated function Pawn.EBoneType GetSpecialDamageBone(Actor HitActor, Vector HitLocation);

// Export USkyPawn::execDoWeaponEffects(FFrame&, void* const)
native simulated function DoWeaponEffects(array<SkyPawn.EWeaponEffect> Effects, SkyWeaponBase Weap, SkyProjectile Proj, Vector ShotDir);

// Export USkyPawn::execBeginEffectAntiGravity(FFrame&, void* const)
native function BeginEffectAntiGravity(SkyWeaponBase Weap, SkyProjectile Proj, Vector ShotDir);

// Export USkyPawn::execEndEffectAntiGravity(FFrame&, void* const)
native function EndEffectAntiGravity();

// Export USkyPawn::execAntiGravityRestoreGravity(FFrame&, void* const)
native function AntiGravityRestoreGravity();

// Export USkyPawn::execAntiGravLaunch(FFrame&, void* const)
native function AntiGravLaunch(Vector Dir, float Impulse);

// Export USkyPawn::execBeginEffectVisualEffect(FFrame&, void* const)
native function BeginEffectVisualEffect(SkyWeaponBase Weap, SkyProjectile Proj);

// Export USkyPawn::execEndEffectVisualEffect(FFrame&, void* const)
native function EndEffectVisualEffect(Actor EffectCauser);

// Export USkyPawn::execAddEffectVisualEffect(FFrame&, void* const)
native function AddEffectVisualEffect(array<SVisualEffectParams> Data, Actor EffectCauser);

// Export USkyPawn::execBeginEffectDisableRocketpack(FFrame&, void* const)
native function BeginEffectDisableRocketpack(SkyWeaponBase Weap, SkyProjectile Proj);

simulated function EndEffectDisableRocketpack()
{
    RemoveWeaponEffect(2);
    //return;    
}

// Export USkyPawn::execBeginEffectCauseCoverDangle(FFrame&, void* const)
native function BeginEffectCauseCoverDangle(SkyWeaponBase Weap, SkyProjectile Proj);

// Export USkyPawn::execBeginEffectPoison(FFrame&, void* const)
native function BeginEffectPoison(SkyWeaponBase Weap, SkyProjectile Proj);

// Export USkyPawn::execBeginEffectExplosion(FFrame&, void* const)
native function BeginEffectExplosion(SkyWeaponBase Weap, SkyProjectile Proj);

function TakePoisonDamage()
{
    TakeDamage(PoisonData.DamageAmount, PoisonData.Instigator, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'SkyDmgType_SmallBallistics',, PoisonData.WeaponArch);
    //return;    
}

function EndEffectPoison()
{
    RemoveWeaponEffect(4);
    ClearTimer('TakePoisonDamage');
    //return;    
}

// Export USkyPawn::execGetArmorInfoIndex(FFrame&, void* const)
native function int GetArmorInfoIndex(SkyPawn.EArmorType ArmorType);

// Export USkyPawn::execGetArmorTypeForBoneType(FFrame&, void* const)
native function SkyPawn.EArmorType GetArmorTypeForBoneType(Pawn.EBoneType BoneType);

// Export USkyPawn::execGetArmorActive(FFrame&, void* const)
native function bool GetArmorActive(SkyPawn.EArmorType ArmorType);

// Export USkyPawn::execSetArmorActive(FFrame&, void* const)
native function SetArmorActive(SkyPawn.EArmorType ArmorType, bool bActive);

// Export USkyPawn::execGetArmorHealth(FFrame&, void* const)
native function float GetArmorHealth(SkyPawn.EArmorType ArmorType);

// Export USkyPawn::execGetTotalArmorHealth(FFrame&, void* const)
native function float GetTotalArmorHealth();

// Export USkyPawn::execSetArmorHealth(FFrame&, void* const)
native function SetArmorHealth(SkyPawn.EArmorType ArmorType, float NewHealth);

// Export USkyPawn::execGetPreviousArmorHealth(FFrame&, void* const)
native function float GetPreviousArmorHealth(SkyPawn.EArmorType ArmorType);

// Export USkyPawn::execSetPreviousArmorHealth(FFrame&, void* const)
native function SetPreviousArmorHealth(SkyPawn.EArmorType ArmorType, float NewHealth);

// Export USkyPawn::execGetArmorImpactEffect(FFrame&, void* const)
native function MaterialImpactEffect GetArmorImpactEffect(Pawn.EBoneType BoneType);

// Export USkyPawn::execHasHeadArmor(FFrame&, void* const)
native function bool HasHeadArmor();

// Export USkyPawn::execHasBodyArmor(FFrame&, void* const)
native function bool HasBodyArmor();

// Export USkyPawn::execHasArmor(FFrame&, void* const)
native function bool HasArmor();

// Export USkyPawn::execProcessWeakPointDamage(FFrame&, void* const)
native function ProcessWeakPointDamage(int Damage, Vector HitLocation, class<DamageType> DamageType, Actor DamageCauser);

// Export USkyPawn::execGetWeakPointImpactEffect(FFrame&, void* const)
native function MaterialImpactEffect GetWeakPointImpactEffect(Vector HitLocation);

// Export USkyPawn::execIsGripping(FFrame&, void* const)
native function bool IsGripping();

// Export USkyPawn::execSetGripping(FFrame&, void* const)
native function SetGripping(SkyGripPoint NewGripPoint);

// Export USkyPawn::execIsMovingToGripPoint(FFrame&, void* const)
native function bool IsMovingToGripPoint();

// Export USkyPawn::execIsMovingBetweenGripPoints(FFrame&, void* const)
native function bool IsMovingBetweenGripPoints();

// Export USkyPawn::execIsMovingFromGripPoint(FFrame&, void* const)
native function bool IsMovingFromGripPoint();

// Export USkyPawn::execIsInteractingWithGripPoint(FFrame&, void* const)
native function bool IsInteractingWithGripPoint();

// Export USkyPawn::execIsEndingHijack(FFrame&, void* const)
native function bool IsEndingHijack();

// Export USkyPawn::execIsBeginningHijack(FFrame&, void* const)
native function bool IsBeginningHijack();

// Export USkyPawn::execIsReactingToGripHit(FFrame&, void* const)
native function bool IsReactingToGripHit();

// Export USkyPawn::execIsBeingThrashed(FFrame&, void* const)
native function bool IsBeingThrashed();

// Export USkyPawn::execGetGripAnimTree(FFrame&, void* const)
native function AnimTree GetGripAnimTree();

// Export USkyPawn::execGetGripPointActionCount(FFrame&, void* const)
native function int GetGripPointActionCount();

// Export USkyPawn::execGetGripPointMaxActionCount(FFrame&, void* const)
native function int GetGripPointMaxActionCount();

// Export USkyPawn::execGetGripPointPercentActionComplete(FFrame&, void* const)
native function float GetGripPointPercentActionComplete(int ActionIndex);

// Export USkyPawn::execCurrentGripPointActionIsProgressive(FFrame&, void* const)
native function bool CurrentGripPointActionIsProgressive();

// Export USkyPawn::execCurrentGripPointActionIsHoldType(FFrame&, void* const)
native function bool CurrentGripPointActionIsHoldType();

// Export USkyPawn::execCurrentGripPointActionIsMashType(FFrame&, void* const)
native function bool CurrentGripPointActionIsMashType();

// Export USkyPawn::execCurrentGripPointActionIsStickType(FFrame&, void* const)
native function bool CurrentGripPointActionIsStickType();

// Export USkyPawn::execCurrentGripActionStickInputIsOk(FFrame&, void* const)
native function bool CurrentGripActionStickInputIsOk();

// Export USkyPawn::execSetThrownFromGripPoint(FFrame&, void* const)
native function SetThrownFromGripPoint();

// Export USkyPawn::execSetReleasedGripPoint(FFrame&, void* const)
native function SetReleasedGripPoint();

// Export USkyPawn::execSetShotFromGripPoint(FFrame&, void* const)
native function SetShotFromGripPoint();

// Export USkyPawn::execThrownFromGripPoint(FFrame&, void* const)
native function bool ThrownFromGripPoint();

// Export USkyPawn::execReleasedGripPoint(FFrame&, void* const)
native function bool ReleasedGripPoint();

// Export USkyPawn::execShotFromGripPoint(FFrame&, void* const)
native function bool ShotFromGripPoint();

// Export USkyPawn::execGetThrownFromGripPointAnimTree(FFrame&, void* const)
native function AnimTree GetThrownFromGripPointAnimTree();

// Export USkyPawn::execGetReleasedGripPointAnimTree(FFrame&, void* const)
native function AnimTree GetReleasedGripPointAnimTree();

// Export USkyPawn::execGetShotFromGripPointAnimTree(FFrame&, void* const)
native function AnimTree GetShotFromGripPointAnimTree();

// Export USkyPawn::execStopThrownFromGripPointAnim(FFrame&, void* const)
native function StopThrownFromGripPointAnim();

// Export USkyPawn::execStopReleasedGripPointAnim(FFrame&, void* const)
native function StopReleasedGripPointAnim();

// Export USkyPawn::execStopShotFromGripPointAnim(FFrame&, void* const)
native function StopShotFromGripPointAnim();

// Export USkyPawn::execOnShotAtWhileGripping(FFrame&, void* const)
native function OnShotAtWhileGripping();

// Export USkyPawn::execIsGrippingOntoArchonNoseAndIsInDangerOfBeingShot(FFrame&, void* const)
native function bool IsGrippingOntoArchonNoseAndIsInDangerOfBeingShot();

// Export USkyPawn::execGripDangleStart(FFrame&, void* const)
native function GripDangleStart(GripDangleInfo Setup);

// Export USkyPawn::execGripDangleAbort(FFrame&, void* const)
native function GripDangleAbort();

// Export USkyPawn::execGripDangleIsActive(FFrame&, void* const)
native function bool GripDangleIsActive();

// Export USkyPawn::execGripDangleUpdate(FFrame&, void* const)
native function GripDangleUpdate(float DeltaSeconds);

// Export USkyPawn::execGripDangleAction(FFrame&, void* const)
native function GripDangleAction(string Button);

function GripHitReactionComplete()
{
    bPlayGripHitReaction = false;
    //return;    
}

// Export USkyPawn::execCanPerformGripAction(FFrame&, void* const)
native function bool CanPerformGripAction();

// Export USkyPawn::execCanShowDefaultGripIcon(FFrame&, void* const)
native function bool CanShowDefaultGripIcon();

// Export USkyPawn::execSetCollisionSizeSafe(FFrame&, void* const)
native function bool SetCollisionSizeSafe(float NewRadius, float NewHeight);

// Export USkyPawn::execSetMovingLevel(FFrame&, void* const)
native function bool SetMovingLevel(Level newMovingLevel);

// Export USkyPawn::execFlushMovingLevel(FFrame&, void* const)
native function FlushMovingLevel();

simulated function OnForceActorLOD(SkySeqAct_ForceActorLOD Action)
{
    // End:0x3A
    if(!Action.bAutoLOD)
    {
        Mesh.ForcedLodModel = Action.ForceLOD + 1;        
    }
    else
    {
        Mesh.ForcedLodModel = 0;
    }
    //return;    
}

// Export USkyPawn::execSetLocationToMatchMesh(FFrame&, void* const)
native function SetLocationToMatchMesh(optional name BoneName);

// Export USkyPawn::execEnterHijackVehicle(FFrame&, void* const)
native function EnterHijackVehicle();

// Export USkyPawn::execIsActionButtonPressed(FFrame&, void* const)
native function bool IsActionButtonPressed();

// Export USkyPawn::execActionUpdate(FFrame&, void* const)
native function ActionUpdate(float DeltaSeconds);

// Export USkyPawn::execPlayDeathImpact(FFrame&, void* const)
native final function PlayDeathImpact(float Speed, name Material, name BoneImpact, Vector HitLocation, Vector HitNormal);

event bool WeaponHasAnyAmmo()
{
    return (Weapon != none) && Weapon.HasAnyAmmo();
    //return ReturnValue;    
}

simulated event bool MyBotFire(bool bFinished)
{
    return BotFire(bFinished);
    //return ReturnValue;    
}

function SpawnAndAttachAuxWeapons()
{
    local int I, J;
    local editinline SkeletalMeshComponent DropMesh, AttachMesh;

    I = 0;
    J0x07:

    // End:0x5F1 [Loop If]
    if(I < AuxWeapons.Length)
    {
        // End:0x5E7
        if(AuxWeapons[I].Archetype != none)
        {
            AuxWeapons[I].Instance = Spawn(AuxWeapons[I].Archetype.Class, self,,,, AuxWeapons[I].Archetype);
            // End:0x5E7
            if((AuxWeapons[I].Instance != none) && AuxWeapons[I].Instance.AttachClass != none)
            {
                AuxWeapons[I].InvManager = Spawn(InventoryManagerClass, self);
                // End:0x3EC
                if(AuxWeapons[I].InvManager != none)
                {
                    AuxWeapons[I].Instance.InvManager = AuxWeapons[I].InvManager;
                    AuxWeapons[I].Instance.Instigator = self;
                    AuxWeapons[I].Instance.AdditionalAmmo += AuxWeapons[I].ExtraAmmo;
                    AuxWeapons[I].Instance.GotoState('Active');
                    AuxWeapons[I].Attachment = Spawn(AuxWeapons[I].Archetype.AttachClass, self);
                    // End:0x3EC
                    if(AuxWeapons[I].Attachment != none)
                    {
                        DropMesh = SkeletalMeshComponent(AuxWeapons[I].Archetype.DroppedPickupMesh);
                        AttachMesh = SkeletalMeshComponent(AuxWeapons[I].Attachment.Mesh);
                        AttachMesh.SkeletalMesh = DropMesh.SkeletalMesh;
                        AttachMesh.AnimSets = DropMesh.AnimSets;
                        AttachMesh.SetAnimTreeTemplate(DropMesh.AnimTreeTemplate);
                        AttachMesh.SetPhysicsAsset(DropMesh.PhysicsAsset);
                        AttachMesh.SetScale(DropMesh.Scale * WeaponScale);
                        AuxWeapons[I].Attachment.Instigator = self;
                        AuxWeapons[I].Attachment.SetWeaponArchetype(AuxWeapons[I].Archetype);
                        AuxWeapons[I].Attachment.AttachToSocketOrBone(self, AuxWeapons[I].Socket);
                        AuxWeapons[I].Attachment.SetSkin(ReplicatedBodyMaterial);
                    }
                }
                J = 0;
                J0x3F3:

                // End:0x4B6 [Loop If]
                if(J < AuxWeapons[I].Instance.LoopingWeaponFire.Length)
                {
                    // End:0x4AC
                    if(AuxWeapons[I].Instance.LoopingWeaponFire[J].Component != none)
                    {
                        AuxWeapons[I].Instance.AttachLoopingWeaponSound(self, AuxWeapons[I].Instance.LoopingWeaponFire[J].Component);
                    }
                    ++J;
                    // [Loop Continue]
                    goto J0x3F3;
                }
                J = 0;
                J0x4BD:

                // End:0x596 [Loop If]
                if(J < AuxWeapons[I].Instance.ChargeUpParams.Length)
                {
                    // End:0x58C
                    if(AuxWeapons[I].Instance.ChargeUpParams[J].ChargeUpSound.Component != none)
                    {
                        AuxWeapons[I].Instance.AttachLoopingWeaponSound(self, AuxWeapons[I].Instance.ChargeUpParams[J].ChargeUpSound.Component);
                    }
                    ++J;
                    // [Loop Continue]
                    goto J0x4BD;
                }
                AuxWeapons[I].Instance.AttachLoopingWeaponSound(self, AuxWeapons[I].Instance.OverheatSound.Component);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export USkyPawn::execStartAuxWeaponFire(FFrame&, void* const)
native simulated function StartAuxWeaponFire(int Index);

// Export USkyPawn::execStopAuxWeaponFire(FFrame&, void* const)
native simulated function StopAuxWeaponFire(int Index);

// Export USkyPawn::execCanAuxWeaponFireAt(FFrame&, void* const)
native simulated function bool CanAuxWeaponFireAt(int Index, Actor Other);

// Export USkyPawn::execIsAuxWeapon(FFrame&, void* const)
native simulated function bool IsAuxWeapon(Weapon Weap);

// Export USkyPawn::execIsAuxWeaponFiring(FFrame&, void* const)
native simulated function bool IsAuxWeaponFiring(int Index);

simulated function NotifyStartInterpolation(float Speed, float Accel, float Duration, AnimNodeSequence Seq)
{
    local float Dist;

    SetPhysics(14);
    // End:0x5D
    if((SkyInterpTarget != none) && Duration > float(0))
    {
        Dist = VSize(SkyInterpTarget.Location - Location);
        SkyInterpAccel = 1000000000000.0000000;
        SkyInterpApproachSpeed = Dist / Duration;        
    }
    else
    {
        SkyInterpAccel = Accel;
        SkyInterpApproachSpeed = Speed;
    }
    //return;    
}

simulated function PlaySoundNotify(SkyAnimNotify_Sound Notify, AnimNodeSequence Node)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xA2 [Loop If]
    if(I < SoundAnimNotifies.Length)
    {
        // End:0x40
        if(!SoundAnimNotifies[I].AudioComp.bWasPlaying)
        {
            // [Explicit Break]
            goto J0xA2;
        }
        // End:0x98
        if((SoundAnimNotifies[I].AudioComp.SoundCue == Notify.Sound) && SoundAnimNotifies[I].Node == Node)
        {
            return;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    J0xA2:

    // End:0x14B
    if(I >= SoundAnimNotifies.Length)
    {
        SoundAnimNotifies.Add(1);
        I = SoundAnimNotifies.Length - 1;
        SoundAnimNotifies[I].AudioComp = new (self) Class'Engine.AudioComponent';
        SoundAnimNotifies[I].AudioComp.bAutoDestroy = false;
        SoundAnimNotifies[I].AudioComp.bStopWhenOwnerDestroyed = true;
        AttachComponent(SoundAnimNotifies[I].AudioComp);
    }
    SoundAnimNotifies[I].Node = Node;
    SoundAnimNotifies[I].AudioComp.VolumeMultiplier = Notify.Volume;
    SoundAnimNotifies[I].AudioComp.PitchMultiplier = Notify.Pitch;
    SoundAnimNotifies[I].AudioComp.SoundCue = Notify.Sound;
    SoundAnimNotifies[I].AudioComp.Play();
    //return;    
}

simulated function StopSoundNotify(SkyAnimNotify_Sound Notify, AnimNodeSequence Node)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xEB [Loop If]
    if(I < SoundAnimNotifies.Length)
    {
        // End:0xE1
        if((SoundAnimNotifies[I].Node == Node) && SoundAnimNotifies[I].AudioComp.SoundCue == Notify.Sound)
        {
            // End:0xBE
            if(Notify.FadeOutTime > 0.0000000)
            {
                SoundAnimNotifies[I].AudioComp.FadeOut(Notify.FadeOutTime, 0.0000000);                
            }
            else
            {
                SoundAnimNotifies[I].AudioComp.Stop();
            }
            return;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export USkyPawn::execIsInWalkVolume(FFrame&, void* const)
native function bool IsInWalkVolume();

// Export USkyPawn::execIsInInstantDeathVolume(FFrame&, void* const)
native function bool IsInInstantDeathVolume();

simulated function SkyBotControllerPilot GetPilotController()
{
    local SkyBotControllerPilot myPilot;

    // End:0x20
    if(SkyBotControllerPilot(Controller) != none)
    {
        myPilot = SkyBotControllerPilot(Controller);
    }
    // End:0x5C
    if((myPilot == none) && SkyVehicle(DrivenVehicle) != none)
    {
        myPilot = SkyBotControllerPilot(SkyVehicle(DrivenVehicle).Controller);
    }
    // End:0x7F
    if((myPilot == none) && StoredRocketPackThrustController != none)
    {
        myPilot = StoredRocketPackThrustController;
    }
    return myPilot;
    //return ReturnValue;    
}

function OnSetTether(SkySeqAct_SetTether Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = GetPilotController();
    // End:0x36
    if(SBCP != none)
    {
        SBCP.OnSetTether(Action);
        return;
    }
    //return;    
}

function OnPilotSeekLandingZone(SkySeqAct_PilotSeekLandingZone Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = GetPilotController();
    // End:0x36
    if(SBCP != none)
    {
        SBCP.OnPilotSeekLandingZone(Action);
        return;
    }
    //return;    
}

function OnSetPilotVars(SkySeqAct_SetPilotVars Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = GetPilotController();
    // End:0x36
    if(SBCP != none)
    {
        SBCP.OnSetPilotVars(Action);
        return;
    }
    //return;    
}

function OnRequestChangeState(SkySeqAct_RequestChangeState Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = GetPilotController();
    // End:0x36
    if(SBCP != none)
    {
        SBCP.OnRequestChangeState(Action);
        return;
    }
    //return;    
}

event OnFollowSpline(SkySeqAct_FollowSpline Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = GetPilotController();
    // End:0x36
    if(SBCP != none)
    {
        SBCP.OnFollowSpline(Action);
        return;
    }
    //return;    
}

simulated function OnToggleHover(SkySeqAct_ToggleHover Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = GetPilotController();
    // End:0x36
    if(SBCP != none)
    {
        SBCP.OnToggleHover(Action);
        return;
    }
    //return;    
}

simulated function OnControlShooting(SkySeqAct_ControlShooting Action)
{
    // End:0x30
    if(SkyVehicle(DrivenVehicle) != none)
    {
        SkyVehicle(DrivenVehicle).OnControlShooting(Action);
        return;
    }
    //return;    
}

simulated function OnSetSocketPreferenceChannel(SkySeqAct_SetSocketPreferenceChannel inAction)
{
    local SkyBotControllerPilot SBCP;

    // End:0x2E
    if(SkyAIController(Controller) != none)
    {
        SkyAIController(Controller).OnSetSocketPreferenceChannel(inAction);
    }
    SBCP = GetPilotController();
    // End:0x62
    if(SBCP != none)
    {
        SBCP.OnSetSocketPreferenceChannel(inAction);
    }
    //return;    
}

simulated function OnGodSight(SkySeqAct_GodSight inAction)
{
    local SkyBotControllerPilot SBCP;

    SBCP = GetPilotController();
    // End:0x34
    if(SBCP != none)
    {
        SBCP.OnGodSight(inAction);
    }
    // End:0x62
    if(SkyAIController(Controller) != none)
    {
        SkyAIController(Controller).OnGodSight(inAction);
    }
    //return;    
}

simulated function OnIgnorePawn(SkySeqAct_IgnorePawn inAction)
{
    local SkyBotControllerPilot SBCP;

    SBCP = GetPilotController();
    // End:0x34
    if(SBCP != none)
    {
        SBCP.OnIgnorePawn(inAction);
    }
    // End:0x62
    if(SkyAIController(Controller) != none)
    {
        SkyAIController(Controller).OnIgnorePawn(inAction);
    }
    //return;    
}

simulated function OnLockEnemy(SkySeqAct_LockEnemy Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = GetPilotController();
    // End:0x36
    if(SBCP != none)
    {
        SBCP.OnLockEnemy(Action);
        return;
    }
    //return;    
}

// Export USkyPawn::execHasAntiGravWeaponEffect(FFrame&, void* const)
native function bool HasAntiGravWeaponEffect();

event WeaponLockerAbort(SkyInteraction_WeaponLocker WL)
{
    WeaponLocker = WL;
    SetTimer(0.1000000, false, 'WeaponLockerAbortTimer');
    //return;    
}

function WeaponLockerAbortTimer()
{
    WeaponLocker.AbortTimer();
    WeaponLocker = none;
    //return;    
}

function OnClearMorphSets(SkySeqAct_ClearMorphSets inAction)
{
    // End:0x2E
    if(HeadMesh != none)
    {
        HeadMesh.MorphSets.Length = 0;
        Mesh.MorphChildComponent = none;
    }
    //return;    
}

simulated state Dying
{
    ignores OnAnimEnd, BreathTimer, StartFeignDeathRecoveryAnim, ForceRagdoll, FellOutOfWorld, FeignDeath, 
	    ServerFeignDeath;

    event bool EncroachingOn(Actor Other)
    {
        return false;
        //return ReturnValue;        
    }

    event Timer()
    {
        // End:0x0D
        if(!PlayerCanSeeMe())
        {
            Destroy();
            return;
        }
        SetTimer(2.0000000, false);
        //return;        
    }

    simulated event Landed(Vector HitNormal, Actor FloorActor)
    {
        local Vector BounceDir;

        // End:0x87
        if(Velocity.Z < float(-500))
        {
            BounceDir = 0.5000000 * (Velocity - ((2.0000000 * HitNormal) * (Velocity Dot HitNormal)));
            TakeDamage(int(float(1) - (Velocity.Z / float(30))), Controller, Location, BounceDir, Class'Engine.DmgType_Crushed');
        }
        //return;        
    }

    simulated function AnimNotifyDeath(optional SkyPawn.EDamageSource Source)
    {
        KillPawn();
        //return;        
    }

    simulated event KillPawn()
    {
        SetCollision(true, bBlockActorsOnDeath);
        CylinderComponent.SetActorCollision(false, false);
        HitBoundingComponent.SetActorCollision(false, false);
        // End:0x62
        if(Mesh != none)
        {
            Mesh.SetTraceBlocking(true, true);
            Mesh.SetActorCollision(true, true);
        }
        DetachFromController(true);
        // End:0x83
        if(bPlayDeathRagdoll)
        {
            DoDeathRagdoll();            
        }
        else
        {
            SetTimer(2.0000000, false);
        }
        Mesh.bPauseAnims = true;
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetMood(0);
        CustomGravityScaling = 1.0000000;
        // End:0x4B
        if(bTearOff && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
        {
            LifeSpan = 1.0000000;            
        }
        else
        {
            // End:0x81
            if((DeathReaction == 'None') && DeathReactionOverride == 'None')
            {
                SetTimer(2.0000000, false);                
            }
            else
            {
                // End:0x98
                if(IsReacting())
                {
                    AbortReaction();
                }
                // End:0xBD
                if(DeathReactionOverride != 'None')
                {
                    StartReaction(DeathReactionOverride);                    
                }
                else
                {
                    StartReaction(DeathReaction);
                }
            }
        }
        // End:0x10B
        if((!bPlayDeathAnim && DeathReaction == 'None') && DeathReactionOverride == 'None')
        {
            KillPawn();
        }
        //return;        
    }

    simulated function DoDeathRagdoll()
    {
        local SkyGame SG;

        Mesh.SetPhysicsAsset(DeathPhysicsAsset);
        InitRagdoll();
        // End:0x2F
        if(bBlowApartOnDeath)
        {
            DoBlowApart();
        }
        bBlendOutTakeHitPhysics = false;
        Mesh.bUpdateKinematicBonesFromAnimation = false;
        Mesh.bUpdateJointsFromAnimation = false;
        Mesh.bSkipAllUpdateWhenPhysicsAsleep = true;
        SG = SkyGame(WorldInfo.Game);
        // End:0xB5
        if((SG != none) && SG.bXPackInstalled)
        {
            SetTimer(XPackRagdollLifeSpan, false);            
        }
        else
        {
            SetTimer(RagdollLifespan, false);
        }
        //return;        
    }
    stop;    
}

simulated state FeigningDeath
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x3A
        if(SkyAIController(Controller) != none)
        {
            SkyAIController(Controller).PushState('Frozen');
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x31
        if(SkyAIController(Controller) != none)
        {
            SkyAIController(Controller).PopState();
        }
        //return;        
    }
    stop;    
}
