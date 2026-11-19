class EvilTypesNative extends Object
    abstract
    native
    config(Game);

enum EDamageClassification
{
    EDC_Light,                      // 0
    EDC_Medium,                     // 1
    EDC_Heavy,                      // 2
    EDC_Explosion,                  // 3
    EDC_MAX                         // 4
};

enum EAITeam
{
    AIT_Default,                    // 0
    AIT_PlayerFriendly,             // 1
    AIT_PlayerEnemy,                // 2
    AIT_CustomEnemyTeam,            // 3
    AIT_Deathmatch_PlayerNeutral,   // 4
    AIT_MAX                         // 5
};

enum EStrafeDirection
{
    SD_Custom,                      // 0
    SD_Random,                      // 1
    SD_Left,                        // 2
    SD_Right,                       // 3
    SD_Back,                        // 4
    SD_Forward,                     // 5
    SD_CustomStrafeLeft,            // 6
    SD_CustomStrafeRight,           // 7
    SD_MAX                          // 8
};

enum EFaceFXEmotionSetType
{
    FFXEST_None,                    // 0
    FFXEST_Idle,                    // 1
    FFXEST_Shoot,                   // 2
    FFXEST_MAX                      // 3
};

enum EAnimationSetType
{
    AST_Invalid,                    // 0
    AST_DeathDefault,               // 1
    AST_DeathRunDefault,            // 2
    AST_DeathKnockBack,             // 3
    AST_DeathKnockFront,            // 4
    AST_DeathKnockLeft,             // 5
    AST_DeathKnockRight,            // 6
    AST_DeathFront,                 // 7
    AST_DeathBack,                  // 8
    AST_DeathLeft,                  // 9
    AST_DeathRight,                 // 10
    AST_DeathFrontRun,              // 11
    AST_DeathBackRun,               // 12
    AST_DeathLeftRun,               // 13
    AST_DeathRightRun,              // 14
    AST_DeathBurning,               // 15
    AST_HitHead,                    // 16
    AST_HitTorso,                   // 17
    AST_HitLeftLeg,                 // 18
    AST_HitRightLeg,                // 19
    AST_HitLeftArm,                 // 20
    AST_HitRightArm,                // 21
    AST_HitDefault,                 // 22
    AST_HitFront,                   // 23
    AST_HitBack,                    // 24
    AST_HitLeft,                    // 25
    AST_HitRight,                   // 26
    AST_HitMidCoverLeft,            // 27
    AST_HitMidCoverRight,           // 28
    AST_HitStdCoverLeft,            // 29
    AST_HitStdCoverRight,           // 30
    AST_KickHitDefault,             // 31
    AST_KickHitLeft,                // 32
    AST_KickHitRight,               // 33
    AST_KickHitBack,                // 34
    AST_KickHitFront,               // 35
    AST_TopHalfHit,                 // 36
    AST_ShieldHit,                  // 37
    AST_Melee,                      // 38
    AST_WeaponMelee,                // 39
    AST_Kick,                       // 40
    AST_Charge,                     // 41
    AST_ChargeFail,                 // 42
    AST_Throw,                      // 43
    AST_ThrowFromMidCoverLeft,      // 44
    AST_ThrowFromMidCoverRight,     // 45
    AST_ThrowFromMidCoverLeftUp,    // 46
    AST_ThrowFromMidCoverRightUp,   // 47
    AST_ThrowFromStdCoverLeft,      // 48
    AST_ThrowFromStdCoverRight,     // 49
    AST_GrabRock,                   // 50
    AST_AimAR,                      // 51
    AST_AimRifle,                   // 52
    AST_AimThrow,                   // 53
    AST_ShootAR,                    // 54
    AST_ReloadAR,                   // 55
    AST_ReloadAR_Left,              // 56
    AST_ReloadAR_Right,             // 57
    AST_ShootRifle,                 // 58
    AST_ReloadRifle,                // 59
    AST_ReloadRifle_Left,           // 60
    AST_ReloadRifle_Right,          // 61
    AST_ReloadPistol,               // 62
    AST_EquipAR,                    // 63
    AST_EquipPistol,                // 64
    AST_HideAR,                     // 65
    AST_HidePistol,                 // 66
    AST_Run,                        // 67
    AST_RunFail,                    // 68
    AST_WalkSlow,                   // 69
    AST_WalkFast,                   // 70
    AST_Reserved1,                  // 71
    AST_Reserved2,                  // 72
    AST_FastSpinUp,                 // 73
    AST_FastSpinUpRight,            // 74
    AST_FastSpinUpLeft,             // 75
    AST_FastSpinUpBack,             // 76
    AST_FastSpinUpBackLeft,         // 77
    AST_FastSpinUpBackRight,        // 78
    AST_FastSpinUpSecondPhase,      // 79
    AST_Recognize,                  // 80
    AST_RecognizeRight,             // 81
    AST_RecognizeLeft,              // 82
    AST_RecognizeBack,              // 83
    AST_RecognizeBackLeft,          // 84
    AST_RecognizeBackRight,         // 85
    AST_Scream,                     // 86
    AST_GolemHeadLost,              // 87
    AST_ShieldLost,                 // 88
    AST_DodgeInMelee,               // 89
    AST_DodgeByDamageWalkSlow,      // 90
    AST_DodgeByDamageWalkFast,      // 91
    AST_DodgeByDamageRunning,       // 92
    AST_Run2MidCoverLeftStart,      // 93
    AST_Run2MidCoverRightStart,     // 94
    AST_Run2MidCoverLeftLoop,       // 95
    AST_Run2MidCoverRightLoop,      // 96
    AST_Run2MidCoverLeftStop,       // 97
    AST_Run2MidCoverRightStop,      // 98
    AST_Run2StdCoverLeftStart,      // 99
    AST_Run2StdCoverRightStart,     // 100
    AST_Run2StdCoverLeftLoop,       // 101
    AST_Run2StdCoverRightLoop,      // 102
    AST_Run2StdCoverLeftStop,       // 103
    AST_Run2StdCoverRightStop,      // 104
    AST_SpecialHitReaction,         // 105
    AST_SpecialBoneHitReaction,     // 106
    AST_ShootAR_AddtoRun,           // 107
    AST_Idle,                       // 108
    AST_CoverFromLightStart,        // 109
    AST_CoverFromLightLoop,         // 110
    AST_CoverFromLightStrafe,       // 111
    AST_CoverFromLightHit,          // 112
    AST_CoverFromLightStop,         // 113
    AST_LightCharge,                // 114
    AST_CoverFromLightStrafeLeft,   // 115
    AST_CoverFromLightStrafeRight,  // 116
    AST_CoverFromLightStrafeL2R,    // 117
    AST_CoverFromLightStrafeR2L,    // 118
    AST_CoverFromLightJumpLeft,     // 119
    AST_CoverFromLightJumpRight,    // 120
    AST_FarAttackPrepare,           // 121
    AST_ShootPistol,                // 122
    AST_ShootPistol_Left,           // 123
    AST_ShootPistol_Right,          // 124
    AST_ShootAR_Left,               // 125
    AST_ShootAR_Right,              // 126
    AST_CustomStrafe_Left,          // 127
    AST_CustomStrafe_Right,         // 128
    AST_Front_HitHead_Pistol,       // 129
    AST_Front_HitTorso_Pistol,      // 130
    AST_Front_HitLeftLeg_Pistol,    // 131
    AST_Front_HitRightLeg_Pistol,   // 132
    AST_Front_HitLeftArm_Pistol,    // 133
    AST_Front_HitRightArm_Pistol,   // 134
    AST_Front_HitHead_SMG,          // 135
    AST_Front_HitTorso_SMG,         // 136
    AST_Front_HitLeftLeg_SMG,       // 137
    AST_Front_HitRightLeg_SMG,      // 138
    AST_Front_HitLeftArm_SMG,       // 139
    AST_Front_HitRightArm_SMG,      // 140
    AST_Front_HitHead_AssaultRifle, // 141
    AST_Front_HitTorso_AssaultRifle,// 142
    AST_Front_HitLeftLeg_AssaultRifle,// 143
    AST_Front_HitRightLeg_AssaultRifle,// 144
    AST_Front_HitLeftArm_AssaultRifle,// 145
    AST_Front_HitRightArm_AssaultRifle,// 146
    AST_Front_HitHead_Shotgun,      // 147
    AST_Front_HitTorso_Shotgun,     // 148
    AST_Front_HitLeftLeg_Shotgun,   // 149
    AST_Front_HitRightLeg_Shotgun,  // 150
    AST_Front_HitLeftArm_Shotgun,   // 151
    AST_Front_HitRightArm_Shotgun,  // 152
    AST_Front_HitHead_Rifle,        // 153
    AST_Front_HitTorso_Rifle,       // 154
    AST_Front_HitLeftLeg_Rifle,     // 155
    AST_Front_HitRightLeg_Rifle,    // 156
    AST_Front_HitLeftArm_Rifle,     // 157
    AST_Front_HitRightArm_Rifle,    // 158
    AST_Front_HitHead_MG,           // 159
    AST_Front_HitTorso_MG,          // 160
    AST_Front_HitLeftLeg_MG,        // 161
    AST_Front_HitRightLeg_MG,       // 162
    AST_Front_HitLeftArm_MG,        // 163
    AST_Front_HitRightArm_MG,       // 164
    AST_Front_HitHead_HeavyPistol,  // 165
    AST_Front_HitTorso_HeavyPistol, // 166
    AST_Front_HitLeftLeg_HeavyPistol,// 167
    AST_Front_HitRightLeg_HeavyPistol,// 168
    AST_Front_HitLeftArm_HeavyPistol,// 169
    AST_Front_HitRightArm_HeavyPistol,// 170
    AST_JumpStart,                  // 171
    AST_JumpFalling,                // 172
    AST_JumpPreLand,                // 173
    AST_JumpLand,                   // 174
    AST_CoverFromLightStrafeForward,// 175
    AST_Jump,                       // 176
    AST_PreJump,                    // 177
    AST_MAX                         // 178
};

enum EMoveMode
{
    EMM_Stop,                       // 0
    EMM_Walk,                       // 1
    EMM_Run,                        // 2
    EMM_FastSpinUp,                 // 3
    EMM_SlowDown,                   // 4
    EMM_Custom,                     // 5
    EMM_MAX                         // 6
};

struct native EvilAnimInfo
{
    var() name AnimName;
    var() float AnimSpeed;
    var() float Chance;
    var() bool OverrideBlendTimes;
    var() float BlendInTime;
    var() float BlendOutTime;

    structdefaultproperties
    {
        AnimName="None"
        AnimSpeed=1.0000000
        Chance=1.0000000
        OverrideBlendTimes=false
        BlendInTime=0.2000000
        BlendOutTime=0.2000000
    }
};

struct native _PawnParameters
{
    var bool bIsValid;
    var() bool bRagdoll;
    var() bool bSpawnGibs;
    var() float InstaGibChance;
    var() float InstaGibRange;
    var() float RagdollMomentumScale;
    var() EvilTypesNative.EDamageClassification HitClassification;
    var() EvilTypesNative.EDamageClassification DeathAnimClassification;

    structdefaultproperties
    {
        bIsValid=false
        bRagdoll=false
        bSpawnGibs=false
        InstaGibChance=0.0000000
        InstaGibRange=0.0000000
        RagdollMomentumScale=1.0000000
        HitClassification=EDamageClassification.EDC_Light
        DeathAnimClassification=EDamageClassification.EDC_Light
    }
};

struct native _GibsParameters
{
    var() float LinearVariationFactor;
    var() float AngularVariationFactor;
    var() float MomentumScale;
    var() float UpVectorScale;

    structdefaultproperties
    {
        LinearVariationFactor=0.0000000
        AngularVariationFactor=0.0000000
        MomentumScale=1.0000000
        UpVectorScale=0.0000000
    }
};

struct native EvilStrafeData
{
    var() EvilTypesNative.EStrafeDirection StrafeDirection;
    var() float StrafeDistance;
    var() float DefaultRating;
    var() float StrafeDelay;
    var Vector StrafePoint;
    var float RandomAngleOffset;
    var bool bClearFireLine;
    var bool bEnemyReachable;
    var float Rating;
    var bool bValidMoveToStrafePoint;
    var int Count;
    var Vector CustomStrafeDelta;
    var bool bDisabled;
    var float LastStrafeTime;

    structdefaultproperties
    {
        StrafeDirection=EStrafeDirection.SD_Custom
        StrafeDistance=0.0000000
        DefaultRating=0.0000000
        StrafeDelay=0.0000000
        StrafePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RandomAngleOffset=0.0000000
        bClearFireLine=false
        bEnemyReachable=false
        Rating=0.0000000
        bValidMoveToStrafePoint=false
        Count=0
        CustomStrafeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bDisabled=false
        LastStrafeTime=0.0000000
    }
};

struct native EvilFaceFXAnimInfo
{
    var() string AnimName;
    var() string GroupName;

    structdefaultproperties
    {
        AnimName=""
        GroupName="Default"
    }
};

struct native EvilFaceFXEmotionInfo
{
    var() EvilTypesNative.EFaceFXEmotionSetType FaceFXEmotionSetType;
    var() array<EvilFaceFXAnimInfo> FaceFXAnimInfoList;

    structdefaultproperties
    {
        FaceFXEmotionSetType=EFaceFXEmotionSetType.FFXEST_None
        FaceFXAnimInfoList=none
    }
};

struct native AnimDefInfo
{
    var() EvilTypesNative.EAnimationSetType AnimType;
    var() array<EvilAnimInfo> Animations;
    var() float DefaultBlendIn;
    var() float DefaultBlendOut;

    structdefaultproperties
    {
        AnimType=EAnimationSetType.AST_Invalid
        Animations=none
        DefaultBlendIn=0.2000000
        DefaultBlendOut=0.2000000
    }
};

struct native CheckpointTime
{
    var int SecondsSinceMidnight;
    var int Day;
    var int Month;
    var int Year;

    structdefaultproperties
    {
        SecondsSinceMidnight=0
        Day=0
        Month=0
        Year=0
    }
};

struct native InventoryRecord
{
    var string InventoryClassPath;
    var int AmmoCount;
    var int AmmoAltCount;
    var int MagazineAmmoCount;
    var bool bIsActiveWeapon;
    var bool bIsActiveLeftWeapon;

    structdefaultproperties
    {
        InventoryClassPath=""
        AmmoCount=0
        AmmoAltCount=0
        MagazineAmmoCount=0
        bIsActiveWeapon=false
        bIsActiveLeftWeapon=false
    }
};

struct native ReplicatedClothMaterial
{
    var byte MaterialIndex;
    var byte RandomMaterialIndex;
    var byte Dummy[2];

    structdefaultproperties
    {
        MaterialIndex=255
        RandomMaterialIndex=0
        Dummy[0]=0
        Dummy[1]=0
    }
};

struct native ReplicatedClothInfo
{
    var byte ClothIndex;
    var byte RandomMaterialIndex;
    var byte Dummy[2];

    structdefaultproperties
    {
        ClothIndex=255
        RandomMaterialIndex=255
        Dummy[0]=0
        Dummy[1]=0
    }
};

var config array<config name> ChapterLevelNames;

defaultproperties
{
    ChapterLevelNames[0]="Dummy"
    ChapterLevelNames[1]="SP-Cemetery_P"
    ChapterLevelNames[2]="SP-Cathedral_P"
    ChapterLevelNames[3]="SP-AtriumComplex_P"
    ChapterLevelNames[4]="SP-Enclave_P"
    ChapterLevelNames[5]="SP-Opera_P"
    ChapterLevelNames[6]="SP-TrainStation_P"
    ChapterLevelNames[7]="SP-Alastor_P"
    ChapterLevelNames[8]="SP-OrientalCastle_P"
    ChapterLevelNames[9]="SP-Orphanage_P"
    ChapterLevelNames[10]="SP-Swamp_P"
    ChapterLevelNames[11]="SP-Loonypark_P"
    ChapterLevelNames[12]="SP-Colloseum_P"
    ChapterLevelNames[13]="SP-Shadowland_P"
    ChapterLevelNames[14]="SP-CityOnWater_P"
    ChapterLevelNames[15]="SP-Lab_P"
    ChapterLevelNames[16]="SP-Factory_P"
    ChapterLevelNames[17]="SP-Tutorial_P"
    ChapterLevelNames[18]="SP-Hospital_P"
    ChapterLevelNames[19]="SP-Tutorial1_P"
    ChapterLevelNames[20]="SP-Halloween_P"
    ChapterLevelNames[21]="SP-XmassStation_P"
    ChapterLevelNames[22]="SP-Town_DLC_2_P"
    ChapterLevelNames[23]="SP-Asylum_DLC_2_P"
    ChapterLevelNames[24]="SP-Bridge_DLC_2_P"
    ChapterLevelNames[25]="SP-Leningrad_DLC_3_P"
    ChapterLevelNames[26]="SP-Bunker_DLC_3_P"
    ChapterLevelNames[27]="SP-MilitaryBase_DLC_3_P"
    ChapterLevelNames[28]="SP-GraveyardTPP_DLC_5_P"
    ChapterLevelNames[29]="SP-TownTPP_DLC_5_P"
    ChapterLevelNames[30]="SP-BabelTPP_DLC_5_P"
    ChapterLevelNames[31]="SP-AngkorTPP_DLC_5_P"
    ChapterLevelNames[32]="SP-PentagonTPP_DLC_5_P"
    ChapterLevelNames[33]="SP-Monastery_DLC_6_P"
    ChapterLevelNames[34]="SP-Docks_DLC_6_P"
    ChapterLevelNames[35]="SP-Ruins_DLC_6_P"
    ChapterLevelNames[36]="SP-Prison_DLC_7_P"
    ChapterLevelNames[37]="SP-City_DLC_7_P"
    ChapterLevelNames[38]="SP-Pentagon_DLC_7_P"
    ChapterLevelNames[39]="SP-Conclave"
    ChapterLevelNames[40]="SP-Easter_P"
}