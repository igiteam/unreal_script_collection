class EvilTypes extends Object
    abstract;

enum EPerceptionType
{
    PT_Sight,                       // 0
    PT_Heard,                       // 1
    PT_HurtBy,                      // 2
    PT_Force,                       // 3
    PT_SightPlayer,                 // 4
    PT_HeardPlayer,                 // 5
    PT_MAX                          // 6
};

enum ENavPointMoveToGoalMode
{
    NPMTGM_Default,                 // 0
    NPMTGM_Cover,                   // 1
    NPMTGM_MAX                      // 2
};

enum ECoverBlend
{
    CB_Idle,                        // 0
    CB_Transition,                  // 1
    CB_BackToWall,                  // 2
    CB_FireSide,                    // 3
    CB_FireUp,                      // 4
    CB_FireSideBlind,               // 5
    CB_FireUpBlind,                 // 6
    CB_MAX                          // 7
};

enum EAimZone
{
    AZ_Disabled,                    // 0
    AZ_Middle,                      // 1
    AZ_Head,                        // 2
    AZ_Freeze,                      // 3
    AZ_MAX                          // 4
};

enum ECharacterClothTypes
{
    CCT_Default,                    // 0
    CCT_GermanSoldier,              // 1
    CCT_GermanOfficer,              // 2
    CCT_MAX                         // 3
};

enum EHandOnLine
{
    HOL_Both,                       // 0
    HOL_Left,                       // 1
    HOL_Right,                      // 2
    HOL_MAX                         // 3
};

enum EAcquireCoverType
{
    ACT_None,                       // 0
    ACT_Immediate,                  // 1
    ACT_DesireBetter,               // 2
    ACT_MAX                         // 3
};

enum ECoverSearchType
{
    CST_Towards,                    // 0
    CST_Away,                       // 1
    CST_Near,                       // 2
    CST_Ambush,                     // 3
    CST_AlongPath,                  // 4
    CST_Any,                        // 5
    CST_MAX                         // 6
};

enum EGameButtons
{
    GB_A,                           // 0
    GB_X,                           // 1
    GB_Y,                           // 2
    GB_B,                           // 3
    GB_Start,                       // 4
    GB_Back,                        // 5
    GB_LeftTrigger,                 // 6
    GB_LeftBumper,                  // 7
    GB_RightTrigger,                // 8
    GB_RightBumper,                 // 9
    GB_DPad_Up,                     // 10
    GB_DPad_Left,                   // 11
    GB_DPad_Down,                   // 12
    GB_DPad_Right,                  // 13
    GB_LeftStick_Push,              // 14
    GB_RightStick_Push,             // 15
    GB_LeftStick_Up,                // 16
    GB_LeftStick_Down,              // 17
    GB_LeftStick_Left,              // 18
    GB_LeftStick_Right,             // 19
    GB_RightStick_Up,               // 20
    GB_RightStick_Down,             // 21
    GB_RightStick_Left,             // 22
    GB_RightStick_Right,            // 23
    GB_PC_Use,                      // 24
    GB_Max                          // 25
};

enum ESpinUpSide
{
    ESS_Default,                    // 0
    ESS_Front,                      // 1
    ESS_BackLeft,                   // 2
    ESS_BackRight,                  // 3
    ESS_Left,                       // 4
    ESS_Right,                      // 5
    ESS_MAX                         // 6
};

enum ESpinUpQueryResult
{
    ESUQ_Success,                   // 0
    ESUQ_Failure_NoAnimForDirection,// 1
    ESUQ_Failure_NoAnimForDistance, // 2
    ESUQ_Failure,                   // 3
    ESUQ_MAX                        // 4
};

enum EEvilWeapAnimType
{
    EEWAT_Default,                  // 0
    EEWAT_Pistol,                   // 1
    EEWAT_AK47,                     // 2
    EEWAT_Blunderbuss,              // 3
    EEWAT_Cannon,                   // 4
    EEWAT_Crossbow,                 // 5
    EEWAT_Gew98,                    // 6
    EEWAT_LAW72,                    // 7
    EEWAT_M200,                     // 8
    EEWAT_MGL140,                   // 9
    EEWAT_Minigun,                  // 10
    EEWAT_MP18,                     // 11
    EWWAT_Remington,                // 12
    EEWAT_Scar,                     // 13
    EEWAT_SM500,                    // 14
    EEWAT_Vector,                   // 15
    EEvilWeapAnimType_MAX           // 16
};

enum EReactTimerMode
{
    ERTM_Default,                   // 0
    ERTM_InitRandom,                // 1
    ERTM_Random,                    // 2
    ERTM_MAX                        // 3
};

enum EAggressionLevel
{
    AL_None,                        // 0
    AL_Covered,                     // 1
    AL_Low,                         // 2
    AL_Normal,                      // 3
    AL_High,                        // 4
    AL_MAX                          // 5
};

enum EBodyParts
{
    BP_Head,                        // 0
    BP_Torso,                       // 1
    BP_LeftLeg,                     // 2
    BP_RightLeg,                    // 3
    BP_LeftArm,                     // 4
    BP_RightArm,                    // 5
    BP_Tail,                        // 6
    BP_Nuts,                        // 7
    BP_Brain,                       // 8
    BP_Heart,                       // 9
    BP_Helmet,                      // 10
    BP_MAX                          // 11
};

enum EAIFactoryEvent
{
    EAIFE_SpawnCompleted,           // 0
    EAIFE_PawnDied,                 // 1
    EAIFE_MAX                       // 2
};

enum EHitReactionType
{
    HRT_Front,                      // 0
    HRT_Back,                       // 1
    HRT_Left,                       // 2
    HRT_Right,                      // 3
    HRT_MAX                         // 4
};

enum EHitDirectionType
{
    HDT_Default,                    // 0
    HDT_Front,                      // 1
    HDT_Back,                       // 2
    HDT_Left,                       // 3
    HDT_Right,                      // 4
    HDT_MAX                         // 5
};

enum EDodgeType
{
    DT_InMelee,                     // 0
    DT_ByDamage,                    // 1
    DT_MAX                          // 2
};

enum ESoundSetType
{
    SST_Invalid,                    // 0
    SST_Hit,                        // 1
    SST_FireHit,                    // 2
    SST_Death,                      // 3
    SST_Alarmed,                    // 4
    SST_Scream,                     // 5
    SST_AttackMelee,                // 6
    SST_AttackShoot,                // 7
    SST_AttackGrenade,              // 8
    SST_CoveredAttackShoot,         // 9
    SST_CoveredAttackGrenade,       // 10
    SST_IdleEmote,                  // 11
    SST_ShootEmote,                 // 12
    SST_AttackAmbient,              // 13
    SST_AttackMeleeHit,             // 14
    SST_AttackMeleeMiss,            // 15
    SST_Transform,                  // 16
    SST_Spawn,                      // 17
    SST_Run,                        // 18
    SST_KilledEnemy,                // 19
    SST_RequestHelp,                // 20
    SST_WarnGrenade,                // 21
    SST_WarnDynamite,               // 22
    SST_DeathDrown,                 // 23
    SST_DeathDrownLava,             // 24
    SST_MAX                         // 25
};

enum ECharacterFootStepType
{
    CFST_Generic,                   // 0
    CFST_Soldiers,                  // 1
    CFST_AztecMummy,                // 2
    CFST_HeavySoldiers,             // 3
    CFST_Player,                    // 4
    CFST_Jennifer,                  // 5
    CFST_Treeter,                   // 6
    CFST_EgyptMummy,                // 7
    CFST_RunningMummy,              // 8
    CFST_SkinnyMummy,               // 9
    CFST_Sentinel,                  // 10
    CFST_PlayerMP,                  // 11
    CFST_MAX                        // 12
};

enum EImpactTypeBallistic
{
    ITB_None,                       // 0
    ITB_Pistol,                     // 1
    ITB_SMG,                        // 2
    ITB_AssaultRifle,               // 3
    ITB_Shotgun,                    // 4
    ITB_Rifle,                      // 5
    ITB_MG,                         // 6
    ITB_HeavyPistol,                // 7
    ITB_Melee,                      // 8
    ITB_MeleeBlunt,                 // 9
    ITB_MeleeSharp,                 // 10
    ITB_MeleeSharpLong,             // 11
    ITB_MAX                         // 12
};

enum EImpactTypeExplosion
{
    ITE_None,                       // 0
    ITE_Cannon,                     // 1
    ITE_Grenade,                    // 2
    ITE_Rocket,                     // 3
    ITE_Bomb,                       // 4
    ITE_SmallBomb,                  // 5
    ITE_Fire,                       // 6
    ITE_Electro,                    // 7
    ITE_Magic,                      // 8
    ITE_Magic2,                     // 9
    ITE_MAX                         // 10
};

enum EEmergeAnimType
{
    EAT_Wake,                       // 0
    EAT_Spawn,                      // 1
    EAT_Lay,                        // 2
    EAT_MAX                         // 3
};

enum ERecoverTypeFromAnimation
{
    ETFA_PlayWholeAnimation,        // 0
    ETFA_RecoverFromKismet,         // 1
    ETFA_RecoverFromAI,             // 2
    ETFA_MAX                        // 3
};

enum ELayFirstFrameAnimation
{
    EFFA_Skeleton_Dismembered_1,    // 0
    EFFA_Skeleton_Dismembered_2,    // 1
    EFFA_Skeleton_WakeFront,        // 2
    EFFA_Skeleton_WakeBack,         // 3
    EFFA_Zombie_WakeFront,          // 4
    EFFA_Zombie_WakeBack,           // 5
    EFFA_Skeleton_GratingsIdle1,    // 6
    EFFA_Skeleton_GratingsIdle2,    // 7
    EFFA_Skeleton_FromWall1,        // 8
    EFFA_Zombie_Eat1,               // 9
    EFFA_Zombie_Eat2,               // 10
    EFFA_Zombie_Eat3,               // 11
    EFFA_Zombie_IdleWall1,          // 12
    EFFA_Zombie_IdleWall2,          // 13
    EFFA_Zombie_IdleWall3,          // 14
    EFFA_Skeleton_JumpOverFence1,   // 15
    EFFA_Zombie_FromWall1,          // 16
    EFFA_Zombie_JumpOverFence1,     // 17
    EFFA_ZombieMinigun_GetUp1,      // 18
    EFFA_Sit,                       // 19
    EFFA_Knee,                      // 20
    EFFA_Treeter_WakeUp1,           // 21
    EFFA_SoldierRelaxed1,           // 22
    EFFA_SoldierRelaxed_Talk1,      // 23
    EFFA_SoldierRelaxed_SitTalk1,   // 24
    EFFA_SoldierRelaxed_Wall1,      // 25
    EFFA_SoldierRelaxed_Wall2,      // 26
    EFFA_SoldierRelaxed_Crouch1,    // 27
    EFFA_SoldierRelaxed_SitBook1,   // 28
    EFFA_SkinnyMummy_WakeUp1,       // 29
    EFFA_SkinnyMummy_WakeUp2,       // 30
    EFFA_SkinnyMummy_WakeUp3,       // 31
    EFFA_SkinnyMummy_WakeUp4,       // 32
    EFFA_MAX                        // 33
};

enum ESpawnAnimation
{
    ESA_Zombie_SpawnFromHole1,      // 0
    ESA_Skeleton_Jump,              // 1
    ESA_Skeleton_GetUpFromTheGrave1,// 2
    ESA_Skeleton_SpawnRubble1,      // 3
    ESA_Zombie_Jump,                // 4
    ESA_Zombie_SpawmRubble1,        // 5
    ESA_Sit,                        // 6
    ESA_Knee,                       // 7
    ESA_Mummy_SpawnFromHole1,       // 8
    ESA_ZombieMummy_SpawnFromSarcofag1,// 9
    ESA_Mummy_OutOfWall,            // 10
    ESA_Mummy_OutOfFloor,           // 11
    ESA_MAX                         // 12
};

enum EClothAssetSpecialActionOnTakeDamage
{
    ECASATD_None,                   // 0
    ECASATD_ShieldTakeDamage,       // 1
    ECASATD_MAX                     // 2
};

enum EClothAssetSpecialActionOnZeroHealth
{
    ECASAOZH_None,                  // 0
    ECASAOZH_ShieldDropped,         // 1
    ECASAOZH_WeaponDropped,         // 2
    ECASAOZH_GrenadeIgnition,       // 3
    ECASAOZH_GolemHeadLost,         // 4
    ECASAOZH_HeartDestroyed,        // 5
    ECASAOZH_MAX                    // 6
};

enum EClothAssetSpecialActionOnRagdoll
{
    ECASAOR_None,                   // 0
    ECASAOR_ShieldDropped,          // 1
    ECASAOR_WeaponDropped,          // 2
    ECASAOR_HeartDestroyed,         // 3
    ECASAOR_MAX                     // 4
};

enum EChapterPoint
{
    CHAP_01_CrashSite_01,           // 0
    CHAP_01_CrashSite_02,           // 1
    CHAP_01_CrashSite_03,           // 2
    CHAP_01_CrashSite_04,           // 3
    CHAP_01_CrashSite_05,           // 4
    CHAP_01_CrashSite_06,           // 5
    CHAP_01_CrashSite_07,           // 6
    CHAP_01_CrashSite_08,           // 7
    CHAP_01_CrashSite_09,           // 8
    CHAP_01_CrashSite_10,           // 9
    CHAP_02_Swamp_01,               // 10
    CHAP_02_Swamp_02,               // 11
    CHAP_02_Swamp_03,               // 12
    CHAP_02_Swamp_04,               // 13
    CHAP_02_Swamp_05,               // 14
    CHAP_02_Swamp_06,               // 15
    CHAP_02_Swamp_07,               // 16
    CHAP_02_Swamp_08,               // 17
    CHAP_02_Swamp_09,               // 18
    CHAP_02_Swamp_10,               // 19
    CHAP_03_Cathedral_01,           // 20
    CHAP_03_Cathedral_02,           // 21
    CHAP_03_Cathedral_03,           // 22
    CHAP_03_Cathedral_04,           // 23
    CHAP_03_Cathedral_05,           // 24
    CHAP_03_Cathedral_06,           // 25
    CHAP_03_Cathedral_07,           // 26
    CHAP_03_Cathedral_08,           // 27
    CHAP_03_Cathedral_09,           // 28
    CHAP_03_Cathedral_10,           // 29
    CHAP_04_Catacombs_01,           // 30
    CHAP_04_Catacombs_02,           // 31
    CHAP_04_Catacombs_03,           // 32
    CHAP_04_Catacombs_04,           // 33
    CHAP_04_Catacombs_05,           // 34
    CHAP_04_Catacombs_06,           // 35
    CHAP_04_Catacombs_07,           // 36
    CHAP_04_Catacombs_08,           // 37
    CHAP_04_Catacombs_09,           // 38
    CHAP_04_Catacombs_10,           // 39
    CHAP_05_Catacombs_01,           // 40
    CHAP_05_Catacombs_02,           // 41
    CHAP_05_Catacombs_03,           // 42
    CHAP_05_Catacombs_04,           // 43
    CHAP_05_Catacombs_05,           // 44
    CHAP_05_Catacombs_06,           // 45
    CHAP_05_Catacombs_07,           // 46
    CHAP_05_Catacombs_08,           // 47
    CHAP_05_Catacombs_09,           // 48
    CHAP_05_Catacombs_10,           // 49
    CHAP_06_Forest_01,              // 50
    CHAP_06_Forest_02,              // 51
    CHAP_06_Forest_03,              // 52
    CHAP_06_Forest_04,              // 53
    CHAP_06_Forest_05,              // 54
    CHAP_06_Forest_06,              // 55
    CHAP_06_Forest_07,              // 56
    CHAP_06_Forest_08,              // 57
    CHAP_06_Forest_09,              // 58
    CHAP_06_Forest_10,              // 59
    CHAP_07_UndergroundCity_01,     // 60
    CHAP_07_UndergroundCity_02,     // 61
    CHAP_07_UndergroundCity_03,     // 62
    CHAP_07_UndergroundCity_04,     // 63
    CHAP_07_UndergroundCity_05,     // 64
    CHAP_07_UndergroundCity_06,     // 65
    CHAP_07_UndergroundCity_07,     // 66
    CHAP_07_UndergroundCity_08,     // 67
    CHAP_07_UndergroundCity_09,     // 68
    CHAP_07_UndergroundCity_10,     // 69
    CHAP_08_UndergroundTemple_01,   // 70
    CHAP_08_UndergroundTemple_02,   // 71
    CHAP_08_UndergroundTemple_03,   // 72
    CHAP_08_UndergroundTemple_04,   // 73
    CHAP_08_UndergroundTemple_05,   // 74
    CHAP_08_UndergroundTemple_06,   // 75
    CHAP_08_UndergroundTemple_07,   // 76
    CHAP_08_UndergroundTemple_08,   // 77
    CHAP_08_UndergroundTemple_09,   // 78
    CHAP_08_UndergroundTemple_10,   // 79
    CHAP_09_City_01,                // 80
    CHAP_09_City_02,                // 81
    CHAP_09_City_03,                // 82
    CHAP_09_City_04,                // 83
    CHAP_09_City_05,                // 84
    CHAP_09_City_06,                // 85
    CHAP_09_City_07,                // 86
    CHAP_09_City_08,                // 87
    CHAP_09_City_09,                // 88
    CHAP_09_City_10,                // 89
    CHAP_10_Bunker_01,              // 90
    CHAP_10_Bunker_02,              // 91
    CHAP_10_Bunker_03,              // 92
    CHAP_10_Bunker_04,              // 93
    CHAP_10_Bunker_05,              // 94
    CHAP_10_Bunker_06,              // 95
    CHAP_10_Bunker_07,              // 96
    CHAP_10_Bunker_08,              // 97
    CHAP_10_Bunker_09,              // 98
    CHAP_10_Bunker_10,              // 99
    CHAP_11_SubmarineGrave_01,      // 100
    CHAP_11_SubmarineGrave_02,      // 101
    CHAP_11_SubmarineGrave_03,      // 102
    CHAP_11_SubmarineGrave_04,      // 103
    CHAP_11_SubmarineGrave_05,      // 104
    CHAP_11_SubmarineGrave_06,      // 105
    CHAP_11_SubmarineGrave_07,      // 106
    CHAP_11_SubmarineGrave_08,      // 107
    CHAP_11_SubmarineGrave_09,      // 108
    CHAP_11_SubmarineGrave_10,      // 109
    CHAP_MAX                        // 110
};

enum ECombatActionType
{
    CAT_Fire,                       // 0
    CAT_Melee,                      // 1
    CAT_PlasmaThrow,                // 2
    CAT_MeleeKick,                  // 3
    CAT_MAX                         // 4
};

struct EvilSoundInfo
{
    var() SoundCue SoundCue;
    var() float Chance;
    var transient float ActualChance;
    var transient float LastPlayTime;
    var transient bool bInitialized;

    structdefaultproperties
    {
        SoundCue=none
        Chance=1.0000000
        ActualChance=0.0000000
        LastPlayTime=0.0000000
        bInitialized=false
    }
};

struct EvilSoundSetNoiseInfo
{
    var() float Range;
    var() float Loudness;

    structdefaultproperties
    {
        Range=0.0000000
        Loudness=1.0000000
    }
};

struct EvilSoundSetInfo
{
    var() array<EvilSoundInfo> SoundInfoList;
    var() EvilSoundSetNoiseInfo SoundSetNoiseInfo;
    var() float Chance;
    var transient float TotalChance;
    var() float interval;
    var() float SoundSetInterval;
    var() int MaxConcurrentPlayCount;

    structdefaultproperties
    {
        SoundInfoList=none
        SoundSetNoiseInfo=(Range=4000.0000000,Loudness=1.0000000)
        Chance=1.0000000
        TotalChance=0.0000000
        interval=0.0000000
        SoundSetInterval=0.0000000
        MaxConcurrentPlayCount=0
    }
};

struct EvilSoundSetInfoGroup
{
    var() EvilTypes.ESoundSetType SoundSetType;
    var() EvilSoundSetInfo SoundSetInfo;
    var() EvilSoundSetInfo HearReplySoundSetInfo;

    structdefaultproperties
    {
        SoundSetType=ESoundSetType.SST_Invalid
        SoundSetInfo=(SoundInfoList=none,SoundSetNoiseInfo=(Range=4000.0000000,Loudness=1.0000000),Chance=1.0000000,TotalChance=0.0000000,interval=0.0000000,SoundSetInterval=0.0000000,MaxConcurrentPlayCount=0)
        HearReplySoundSetInfo=(SoundInfoList=none,SoundSetNoiseInfo=(Range=4000.0000000,Loudness=1.0000000),Chance=1.0000000,TotalChance=0.0000000,interval=0.0000000,SoundSetInterval=0.0000000,MaxConcurrentPlayCount=0)
    }
};

struct JumpPhase extends EvilAnimInfo
{
    var() float CustomGravityScaling;

    structdefaultproperties
    {
        CustomGravityScaling=1.0000000
        AnimSpeed=0.0000000
        Chance=0.0000000
        BlendInTime=0.0000000
        BlendOutTime=0.0000000
    }
};

struct native DecalData
{
    var bool bIsValid;
    var() MaterialInterface DecalMaterial;
    var() bool ClipDecalsUsingFastPath;
    var() float Width;
    var() float Height;
    var() float Thickness;
    var() bool bRandomizeRotation;
    var() Vector2D RandomScalingRange;
    var() float RandomRadiusOffset;
    var() float LifeSpan;
    var() Vector2D BlendRange;

    structdefaultproperties
    {
        bIsValid=false
        DecalMaterial=none
        ClipDecalsUsingFastPath=false
        Width=6.0000000
        Height=6.0000000
        Thickness=10.0000000
        bRandomizeRotation=true
        RandomScalingRange=(X=1.0000000,Y=1.2000000)
        RandomRadiusOffset=0.0000000
        LifeSpan=15.0000000
        BlendRange=(X=70.0000000,Y=89.5000000)
    }
};

struct ParametersDefault
{
    var() _GibsParameters GibParameters;
    var() _PawnParameters PawnParameters;
    var() bool bGetParametersFromDefault;

    structdefaultproperties
    {
        GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000)
        PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light)
        bGetParametersFromDefault=true
    }
};

struct ParametersBallistic extends ParametersDefault
{
    var() EvilTypes.EImpactTypeBallistic Type;

    structdefaultproperties
    {
        GibParameters=(MomentumScale=0.0000000)
        PawnParameters=(RagdollMomentumScale=0.0000000)
        bGetParametersFromDefault=false
    }
};

struct ParametersExplosion extends ParametersDefault
{
    var() EvilTypes.EImpactTypeExplosion Type;

    structdefaultproperties
    {
        GibParameters=(MomentumScale=0.0000000)
        PawnParameters=(RagdollMomentumScale=0.0000000)
        bGetParametersFromDefault=false
    }
};

struct _GoreInfo
{
    var() ParametersBallistic DefaultBallisticParameters;
    var() ParametersExplosion DefaultExplosionParameters;
    var() array<ParametersBallistic> BallisticParameters;
    var() array<ParametersExplosion> ExplosionParameters;

    structdefaultproperties
    {
        DefaultBallisticParameters=(Type=EImpactTypeBallistic.ITB_None,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        DefaultExplosionParameters=(Type=EImpactTypeExplosion.ITE_None,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[0]=(Type=EImpactTypeBallistic.ITB_None,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[1]=(Type=EImpactTypeBallistic.ITB_Pistol,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[2]=(Type=EImpactTypeBallistic.ITB_SMG,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[3]=(Type=EImpactTypeBallistic.ITB_AssaultRifle,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[4]=(Type=EImpactTypeBallistic.ITB_Shotgun,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[5]=(Type=EImpactTypeBallistic.ITB_Rifle,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[6]=(Type=EImpactTypeBallistic.ITB_MG,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[7]=(Type=EImpactTypeBallistic.ITB_HeavyPistol,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[8]=(Type=EImpactTypeBallistic.ITB_Melee,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[9]=(Type=EImpactTypeBallistic.ITB_MeleeBlunt,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        BallisticParameters[10]=(Type=EImpactTypeBallistic.ITB_MeleeSharp,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        ExplosionParameters[0]=(Type=EImpactTypeExplosion.ITE_None,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        ExplosionParameters[1]=(Type=EImpactTypeExplosion.ITE_Cannon,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        ExplosionParameters[2]=(Type=EImpactTypeExplosion.ITE_Grenade,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        ExplosionParameters[3]=(Type=EImpactTypeExplosion.ITE_Rocket,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        ExplosionParameters[4]=(Type=EImpactTypeExplosion.ITE_Bomb,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        ExplosionParameters[5]=(Type=EImpactTypeExplosion.ITE_SmallBomb,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        ExplosionParameters[6]=(Type=EImpactTypeExplosion.ITE_Fire,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        ExplosionParameters[7]=(Type=EImpactTypeExplosion.ITE_Electro,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        ExplosionParameters[8]=(Type=EImpactTypeExplosion.ITE_Magic,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
        ExplosionParameters[9]=(Type=EImpactTypeExplosion.ITE_Magic2,GibParameters=(LinearVariationFactor=0.0000000,AngularVariationFactor=0.0000000,MomentumScale=1.0000000,UpVectorScale=0.0000000),PawnParameters=(bIsValid=false,bRagdoll=false,bSpawnGibs=false,InstaGibChance=0.0000000,InstaGibRange=0.0000000,RagdollMomentumScale=1.0000000,HitClassification=EDamageClassification.EDC_Light,DeathAnimClassification=EDamageClassification.EDC_Light),bGetParametersFromDefault=true)
    }
};
