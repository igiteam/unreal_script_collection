class MOHAIncludeClass extends Object
    native;

enum eGameDifficulty
{
    Easy,                           // 0
    Medium,                         // 1
    Hard,                           // 2
    eGameDifficulty_MAX             // 3
};

enum eControllerScheme
{
    CONTROLLER_SCHEME_DEFAULT,      // 0
    CONTROLLER_SCHEME_GOW,          // 1
    CONTROLLER_SCHEME_HALO,         // 2
    CONTROLLER_SCHEME_MAX           // 3
};

enum MilitaryRank
{
    Recruit,                        // 0
    Private,                        // 1
    PrivateFirstClass,              // 2
    Corporal,                       // 3
    Sergeant,                       // 4
    StaffSergeant,                  // 5
    SergeantFirstClass,             // 6
    MasterSergeant,                 // 7
    FirstSergeant,                  // 8
    SecondLieutenant,               // 9
    FirstLieutenant,                // 10
    Captain,                        // 11
    Major,                          // 12
    LieutenantColonel,              // 13
    Colonel,                        // 14
    BrigadierGeneral,               // 15
    MajorGeneral,                   // 16
    LieutenantGeneral,              // 17
    General,                        // 18
    GeneralOfTheArmy,               // 19
    MilitaryRank_MAX                // 20
};

enum EWeaponSelection
{
    WEAPONSELECT_None,              // 0
    WEAPONSELECT_Rifle,             // 1
    WEAPONSELECT_SMG,               // 2
    WEAPONSELECT_AutoRifle,         // 3
    WEAPONSELECT_Sniper,            // 4
    WEAPONSELECT_AntiTank,          // 5
    WEAPONSELECT_Carbine,           // 6
    WEAPONSELECT_MAX                // 7
};

enum eWeaponClass
{
    WEAPON_CLASS_MELEE,             // 0
    WEAPON_CLASS_PISTOL,            // 1
    WEAPON_CLASS_RIFLE,             // 2
    WEAPON_CLASS_SMG,               // 3
    WEAPON_CLASS_SNIPER,            // 4
    WEAPON_CLASS_ANTITANK,          // 5
    WEAPON_CLASS_CARBINE,           // 6
    WEAPON_CLASS_GRENADE,           // 7
    WEAPON_CLASS_AUTORIFLE,         // 8
    WEAPON_CLASS_MAX                // 9
};

enum EWeaponType
{
    WEAPON_TYPE_NONE,               // 0
    WEAPON_TYPE_THOMPSON,           // 1
    WEAPON_TYPE_MKIIFRAGGRENADE,    // 2
    WEAPON_TYPE_MP40,               // 3
    WEAPON_TYPE_SPRINGFIELD,        // 4
    WEAPON_TYPE_COMPB_EXPLOSIVE,    // 5
    WEAPON_TYPE_MG42,               // 6
    WEAPON_TYPE_M1GARAND,           // 7
    WEAPON_TYPE_K98,                // 8
    WEAPON_TYPE_COLT45,             // 9
    WEAPON_TYPE_GAMMONGRENADE,      // 10
    WEAPON_TYPE_STICKGRENADE,       // 11
    WEAPON_TYPE_M1CARBINE,          // 12
    WEAPON_TYPE_M1918_BAR,          // 13
    WEAPON_TYPE_M18_RECOILESS_RIFLE,// 14
    WEAPON_TYPE_M12_COMBAT_SHOTGUN, // 15
    WEAPON_TYPE_M1919_30_CAL,       // 16
    WEAPON_TYPE_G43_RIFLE,          // 17
    WEAPON_TYPE_STG_44,             // 18
    WEAPON_TYPE_C96_MAUSER,         // 19
    WEAPON_TYPE_PANZERSCHRECK,      // 20
    WEAPON_TYPE_FG_42,              // 21
    WEAPON_TYPE_MOUNTED_30_CAL,     // 22
    WEAPON_TYPE_HELLBOX,            // 23
    WEAPON_TYPE_COUNT,              // 24
    WEAPON_TYPE_MAX                 // 25
};

enum EDamageSoundType
{
    DAMAGESOUNDTYPE_BulletWound,    // 0
    DAMAGESOUNDTYPE_BulletDeath,    // 1
    DAMAGESOUNDTYPE_FallingDeath,   // 2
    DAMAGESOUNDTYPE_ExplosionDeath, // 3
    DAMAGESOUNDTYPE_MAX             // 4
};

enum EHUDNotifications
{
    ONE_SHOT_KILL,                  // 0
    TRIPLE_KILL,                    // 1
    FIVE_IN_A_ROW,                  // 2
    HEAD_SHOT,                      // 3
    MELEE_KILL,                     // 4
    GREASED_LANDING,                // 5
    FLARED_LANDING,                 // 6
    BOTCHED_LANDING,                // 7
    SKILL_DROP_FOUND,               // 8
    SKILL_DROP_DISCOVERED,          // 9
    EHUDNotifications_MAX           // 10
};

enum EMedalTypeSP
{
    WWII_VICTORY_MEDAL,             // 0
    DISTINGUISHED_SERVICE_CROSS,    // 1
    BRONZE_STAR,                    // 2
    SILVER_STAR,                    // 3
    SOLDIERS_MEDAL,                 // 4
    LEGION_OF_MERIT,                // 5
    EMedalTypeSP_MAX                // 6
};

enum EDropBadgeType
{
    DROP_BADGE_BASIC,               // 0
    DROP_BADGE_SENIOR,              // 1
    DROP_BADGE_MASTER,              // 2
    DROP_BADGE_MAX                  // 3
};

enum TapedMagazineMode
{
    TAPED_MAG_A,                    // 0
    TAPED_MAG_B,                    // 1
    TAPED_MAG_MAX                   // 2
};

enum HellBoxIdleMode
{
    HELLBOX_IDLE_A,                 // 0
    HELLBOX_IDLE_B,                 // 1
    HELLBOX_IDLE_MAX                // 2
};

enum ECheatType
{
    CHEAT_UNLOCK_MISSIONS,          // 0
    CHEAT_BULLET_SHIELD,            // 1
    CHEAT_INFINITE_AMMO,            // 2
    CHEAT_UNLOCK_WEAPONS,           // 3
    CHEAT_UPGRADE_WEAPONS,          // 4
    CHEAT_HEADSHOTS_ONLY,           // 5
    CHEAT_UNLOCK_PC_CHEATS,         // 6
    CHEAT_ANY,                      // 7
    CHEAT_MAX                       // 8
};

enum EPawnType
{
    PAWN_TYPE_PLAYER,               // 0
    PAWN_TYPE_US,                   // 1
    PAWN_TYPE_GE,                   // 2
    PAWN_TYPE_MAX                   // 3
};

enum EShellStartPosition
{
    E_PRESS_START,                  // 0
    E_MAIN_MENU,                    // 1
    E_MP_LOGIN,                     // 2
    E_SIGNIN_CHANGE,                // 3
    E_ACCEPTING_INVITE,             // 4
    E_MAX                           // 5
};

struct native ViewKickTuning
{
    var() float PitchDistance;
    var() float PitchRandomness;
    var() float PitchCutoffDistance;
    var() float PitchRecenterRate;
    var() float YawDistance;
    var() float YawRandomness;
    var() float PushDistance;
    var() float PushRecenterRate;
    var() float PushCutoffDistance;
    var() float PushRandomness;
    var() bool ConstantPitchReturn;
    var() bool ConstantPushReturn;
    var() float KickTimePitchYaw;
    var() float KickTimePush;

    structdefaultproperties
    {
        PitchDistance=0.0000000
        PitchRandomness=0.0000000
        PitchCutoffDistance=0.0000000
        PitchRecenterRate=0.0000000
        YawDistance=0.0000000
        YawRandomness=0.0000000
        PushDistance=0.0000000
        PushRecenterRate=0.0000000
        PushCutoffDistance=0.0000000
        PushRandomness=0.0000000
        ConstantPitchReturn=false
        ConstantPushReturn=false
        KickTimePitchYaw=0.0000000
        KickTimePush=0.0000000
    }
};

struct native AccuracyTuning
{
    var() float CrouchPenaltyMin;
    var() float CrouchPenaltyMax;
    var() float RunPenalty;
    var() float JumpPenalty;
    var() float TurnPenaltyMax;
    var() float BasePenaltyMin;
    var() float BasePenaltyMax;
    var() float BasePenaltyRange;
    var() float AccuracyDistance;
    var() float AccuracyRecoveryScalar;

    structdefaultproperties
    {
        CrouchPenaltyMin=0.0000000
        CrouchPenaltyMax=0.0000000
        RunPenalty=0.0000000
        JumpPenalty=0.0000000
        TurnPenaltyMax=0.0000000
        BasePenaltyMin=0.0000000
        BasePenaltyMax=0.0000000
        BasePenaltyRange=0.0000000
        AccuracyDistance=0.0000000
        AccuracyRecoveryScalar=0.0000000
    }
};

struct native ScopeTuning
{
    var() float MinFOV;
    var() float MaxFOV;
    var() float FOVChangeRate;
    var() float fFocalLengthRateOfChange;
    var() float fFocalRadiusRateOfChange;
    var() float fFocalRadiusTarget;
    var() float fZoomFocalDegredationScalar;

    structdefaultproperties
    {
        MinFOV=0.0000000
        MaxFOV=0.0000000
        FOVChangeRate=0.0000000
        fFocalLengthRateOfChange=0.0000000
        fFocalRadiusRateOfChange=0.0000000
        fFocalRadiusTarget=0.0000000
        fZoomFocalDegredationScalar=0.0000000
    }
};

struct ParticleSystemInfo
{
    var ParticleSystem PSystem;

    structdefaultproperties
    {
        PSystem=none
    }
};

struct native ReserveAmmo
{
    var class<EALAAmmoInventoryClass> AmmoClass;
    var int ReserveAmmoAmount;
    var int MaxAmmoCount;

    structdefaultproperties
    {
        AmmoClass=none
        ReserveAmmoAmount=0
        MaxAmmoCount=0
    }
};
