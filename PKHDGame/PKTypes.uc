class PKTypes extends Object
    abstract
    native;

const PKTotalCollectibleTypes = 8;

enum EPKCollectibleTypes
{
    PKCT_TotalMonsters,             // 0
    PKCT_TotalSouls,                // 1
    PKCT_TotalArmors,               // 2
    PKCT_TotalGold,                 // 3
    PKCT_TotalHolyItems,            // 4
    PKCT_TotalAmmo,                 // 5
    PKCT_TotalObjects,              // 6
    PKCT_TotalSecrets,              // 7
    PKCT_MAX                        // 8
};

enum EAITypes
{
    AIType_ZombieSoldier,           // 0
    AIType_Templar,                 // 1
    AIType_Giant,                   // 2
    AIType_Zombie,                  // 3
    AIType_TestZombie,              // 4
    AIType_Alastor,                 // 5
    AIType_Swamp,                   // 6
    AIType_Banshee,                 // 7
    AIType_Boy,                     // 8
    AIType_Samurai,                 // 9
    AIType_Hellangel,               // 10
    AIType_Sado,                    // 11
    AIType_EvilMonk,                // 12
    AIType_BlackDemon,              // 13
    AIType_EvilMonkRich,            // 14
    AIType_BlackDemonBig,           // 15
    AIType_BlackDemonV2,            // 16
    AIType_BlackDemonBigV2,         // 17
    AIType_BreakBoy,                // 18
    AIType_Clown,                   // 19
    AIType_SkeletonSoldier,         // 20
    AIType_Skeleton,                // 21
    AIType_DevilMonk,               // 22
    AIType_Pinokio,                 // 23
    AIType_Nun,                     // 24
    AIType_Skull,                   // 25
    AIType_Maso,                    // 26
    AIType_Preacher,                // 27
    AIType_KrustyClown,             // 28
    AIType_BagBaby,                 // 29
    AIType_Ghost,                   // 30
    AIType_SkeletonBaby,            // 31
    AIType_PsychoElektro,           // 32
    AIType_GiantAmbient,            // 33
    AIType_LabCommandos,            // 34
    AIType_Amputee,                 // 35
    AIType_Grim_Reaper,             // 36
    AIType_BansheeTrashcan,         // 37
    AIType_Hellangel_NoThrow,       // 38
    AIType_HellAngel_NotMoveableThrower,// 39
    AIType_HellAngel_NoThrowHunter, // 40
    AIType_Banshee_NoScream,        // 41
    AIType_DevilMonk_Slowdown,      // 42
    AIType_EvilMonk_AdrianRunOnlyBigger,// 43
    AIType_EvilMonk_AdrianWalkOnly, // 44
    AIType_EvilMonk_ThrowAndDie,    // 45
    AIType_Sado_1gun,               // 46
    AIType_Sado_1gun_Area,          // 47
    AIType_Sado_1gun_CloseUZI,      // 48
    AIType_SkeletonSoldier_ShootOnlyHunter,// 49
    AIType_SkeletonSoldier_BayonetOnlyHunterSmall,// 50
    AIType_Templar_Arabian,         // 51
    AIType_Templar_Area,            // 52
    AIType_ZombieSoldier_WalkOnly,  // 53
    AIType_ZombieSoldier_RunOnlyHunter,// 54
    AIType_PsychoElektro_Explode,   // 55
    AIType_Samurai_NoFireball,      // 56
    AIType_Samurai_FireballOnly,    // 57
    AIType_Maso_NonMoveable,        // 58
    AIType_Maso_FlameOnly,          // 59
    AIType_Maso_GrenadeOnlyNonMoveable,// 60
    AIType_LabCommandos_SniperMeat, // 61
    AIType_LabCommandos_SniperMeatFar2,// 62
    AIType_LabCommandos_NoGrenades, // 63
    AIType_LabCommandos_NoStrafe,   // 64
    AIType_LabCommandos_NoGrenadesNoStrafe,// 65
    AIType_LabCommandos_AS,         // 66
    AIType_LabCommandos_NoGrenadesAS,// 67
    AIType_EvilMonkRich_RunOnlyBigger,// 68
    AIType_EvilMonkRich_ThrowAndDieShortsighted,// 69
    AIType_EvilMonkRich_WalkOnlyNoThrow,// 70
    AIType_EvilMonkRich_ThrowAndDie,// 71
    AIType_Assassin,                // 72
    AIType_Girl,                    // 73
    AIType_Nun_Adrian,              // 74
    AIType_Alastor_Old,             // 75
    AIType_Banshee_NoMoveScreamer,  // 76
    AIType_EvilMonkRich_Weak,       // 77
    AIType_KrustyFlying,            // 78
    AIType_PreacherBig,             // 79
    AIType_DevilMonk_Adrian,        // 80
    AIType_Skeleton_NoSoul,         // 81
    AIType_Raven,                   // 82
    AIType_HellangelV2,             // 83
    AIType_HellangelV3,             // 84
    AIType_Hellangel_NoThrowV2,     // 85
    AIType_Hellangel_NoThrowV3,     // 86
    AIType_HellAngel_NotMoveableThrowerV2,// 87
    AIType_HellAngel_NotMoveableThrowerV3,// 88
    AIType_ZombieSoldierV2,         // 89
    AIType_ZombieSoldierV3,         // 90
    AIType_Banshee_Opera,           // 91
    AIType_SkeletonSoldier_ShootOnlyHunterV2,// 92
    AIType_SkeletonSoldier_BayonetOnlyHunterSmallV2,// 93
    AIType_BagBabyV2,               // 94
    AIType_BagBabyV3,               // 95
    AIType_Nun_AdrianV2,            // 96
    AIType_DevilMonkV2,             // 97
    AIType_DevilMonkRich,           // 98
    AIType_Preacher_Opera,          // 99
    AIType_Preacher_Loonypark,      // 100
    AIType_SkeletonV2,              // 101
    AIType_Halloweeen_Bat,          // 102
    AIType_Halloween_BagBaby,       // 103
    AIType_Halloween_Banshee,       // 104
    AIType_Halloween_Skeleton,      // 105
    AIType_Halloween_BlackDemonV2,  // 106
    AIType_BoyV2,                   // 107
    AIType_BreakBoyV2,              // 108
    AIType_Xmas_Bagbaby,            // 109
    AIType_Xmas_Banshee,            // 110
    AIType_Xmas_BansheeTrashcan,    // 111
    AIType_Xmas_PsychoElektro,      // 112
    AIType_Xmas_Sado,               // 113
    AIType_Xmas_Amputee,            // 114
    AIType_Xmas_Preacher,           // 115
    AIType_Xmas_Boy,                // 116
    AIType_Xmas_BreakBoy,           // 117
    AIType_Xmas_PsychoElektro_Explode,// 118
    AIType_DLC1_WhiteDemonBig,      // 119
    AIType_DLC1_WhiteDemonBigV2,    // 120
    AIType_DLC2_LeperMonk,          // 121
    AIType_DLC2_Ninja,              // 122
    AIType_DLC1_PKPawn_AssassinV2,  // 123
    AIType_DLC2_NinjaV2,            // 124
    AIType_DLC2_Leper,              // 125
    AIType_DLC2_PsychoElektroExplode,// 126
    AIType_DLC2_Amputee,            // 127
    AIType_DLC2_Ninja_Area,         // 128
    AIType_DLC2_NinjaV2_JumpOnSpawn,// 129
    AIType_DLC2_WhiteDemonBig,      // 130
    AIType_DLC2_Loki,               // 131
    AIType_DLC2_LokiV2,             // 132
    AIType_DLC2_LeperV2,            // 133
    AIType_DLC3_GermanZombieSoldier,// 134
    AIType_DLC3_GermanZombieSoldierV2,// 135
    AIType_DLC3_RussianZombieSoldier,// 136
    AIType_DLC3_RussianZombieSoldierV2,// 137
    AIType_DLC3_Tank,               // 138
    AIType_DLC3_TankV2,             // 139
    AIType_DLC4_Character,          // 140
    AIType_DLC4_Character2,         // 141
    AIType_DLC5_Deto,               // 142
    AIType_DLC5_DetoV2,             // 143
    AIType_DLC5_Officer,            // 144
    AIType_DLC5_OfficerV2,          // 145
    AIType_DLC5_Beast,              // 146
    AIType_DLC5_BeastV2,            // 147
    AIType_DLC5_Executioner,        // 148
    AIType_DLC5_ExecutionerV2,      // 149
    AIType_DLC6_Hellbiker,          // 150
    AIType_DLC6_HellbikerV2,        // 151
    AIType_DLC6_DrunkWorker,        // 152
    AIType_DLC6_DrunkWorkerV2,      // 153
    AIType_DLC6_Thor,               // 154
    AIType_DLC7_WingedDemon,        // 155
    AIType_DLC7_WingedDemonV2,      // 156
    AIType_DLC7_ApocalypticZombie,  // 157
    AIType_DLC7_ApocalypticZombieV2,// 158
    AIType_DLC7_PanzerDemon,        // 159
    AIType_DLC7_PanzerDemonV2,      // 160
    AIType_DLC1_CustomCharacter,    // 161
    AIType_DLC1_CustomCharacter2,   // 162
    AIType_DLC2_CustomCharacter,    // 163
    AIType_DLC2_CustomCharacter2,   // 164
    AIType_DLC3_CustomCharacter,    // 165
    AIType_DLC3_CustomCharacter2,   // 166
    AIType_DLC4_CustomCharacter,    // 167
    AIType_DLC4_CustomCharacter2,   // 168
    AIType_DLC5_CustomCharacter,    // 169
    AIType_DLC5_CustomCharacter2,   // 170
    AIType_DLC6_CustomCharacter,    // 171
    AIType_DLC6_CustomCharacter2,   // 172
    AIType_DLC7_CustomCharacter,    // 173
    AIType_DLC7_CustomCharacter2,   // 174
    AIType_DLC8_CustomCharacter,    // 175
    AIType_DLC8_CustomCharacter2,   // 176
    AIType_DLC8_CustomCharacter3,   // 177
    AIType_DLC2_AmputeeCeiling,     // 178
    AIType_DLC2_Ghost,              // 179
    AIType_DLC2_DeadBody,           // 180
    AIType_DLC3_Sado,               // 181
    AIType_DLC3_Sado_1gun,          // 182
    AIType_DLC5_ExecutionerV3,      // 183
    AIType_DLC5_ExecutionerV4,      // 184
    AIType_DLCReserved78,           // 185
    AIType_DLCReserved79,           // 186
    AIType_DLCReserved80,           // 187
    AIType_DLCReserved81,           // 188
    AIType_DLCReserved82,           // 189
    AIType_DLCReserved83,           // 190
    AIType_DLCReserved84,           // 191
    AIType_DLCReserved85,           // 192
    AIType_DLCReserved86,           // 193
    AIType_DLCReserved87,           // 194
    AIType_DLCReserved88,           // 195
    AIType_DLCReserved89,           // 196
    AIType_DLCReserved90,           // 197
    AIType_DLCReserved91,           // 198
    AIType_DLCReserved92,           // 199
    AIType_DLCReserved93,           // 200
    AIType_DLCReserved94,           // 201
    AIType_DLCReserved95,           // 202
    AIType_DLCReserved96,           // 203
    AIType_DLCReserved97,           // 204
    AIType_DLCReserved98,           // 205
    AIType_DLCReserved99,           // 206
    AIType_DLCReserved100,          // 207
    AIType_DLCReserved101,          // 208
    AIType_DLCReserved102,          // 209
    AIType_DLCReserved103,          // 210
    AIType_DLCReserved104,          // 211
    AIType_DLCReserved105,          // 212
    AIType_DLCReserved106,          // 213
    AIType_DLCReserved107,          // 214
    AIType_DLCReserved108,          // 215
    AIType_DLCReserved109,          // 216
    AIType_DLCReserved110,          // 217
    AIType_DLCReserved111,          // 218
    AIType_DLCReserved112,          // 219
    AIType_DLCReserved113,          // 220
    AIType_DLCReserved114,          // 221
    AIType_DLCReserved115,          // 222
    AIType_DLCReserved116,          // 223
    AIType_DLCReserved117,          // 224
    AIType_DLCReserved118,          // 225
    AIType_DLCReserved119,          // 226
    AIType_DLCReserved120,          // 227
    AIType_MAX                      // 228
};

enum EPKPawnAction
{
    Reserved0,                      // 0
    Reserved1,                      // 1
    Reserved2,                      // 2
    Reserved3,                      // 3
    Reserved4,                      // 4
    Reserved5,                      // 5
    Reserved6,                      // 6
    Reserved7,                      // 7
    Reserved8,                      // 8
    Reserved9,                      // 9
    Reserved10,                     // 10
    Reserved11,                     // 11
    Reserved12,                     // 12
    Reserved13,                     // 13
    Reserved14,                     // 14
    Reserved15,                     // 15
    Reserved16,                     // 16
    Reserved17,                     // 17
    Reserved18,                     // 18
    Reserved19,                     // 19
    Reserved20,                     // 20
    Reserved21,                     // 21
    Reserved22,                     // 22
    Reserved23,                     // 23
    Reserved24,                     // 24
    Reserved25,                     // 25
    Reserved26,                     // 26
    Reserved27,                     // 27
    Reserved28,                     // 28
    Reserved29,                     // 29
    Reserved30,                     // 30
    Reserved31,                     // 31
    Reserved32,                     // 32
    Reserved33,                     // 33
    Reserved34,                     // 34
    Reserved35,                     // 35
    Reserved36,                     // 36
    Reserved37,                     // 37
    Reserved38,                     // 38
    Reserved39,                     // 39
    Reserved40,                     // 40
    Reserved41,                     // 41
    Reserved42,                     // 42
    Reserved43,                     // 43
    Reserved44,                     // 44
    Reserved45,                     // 45
    Reserved46,                     // 46
    Reserved47,                     // 47
    Reserved48,                     // 48
    Reserved49,                     // 49
    Reserved50,                     // 50
    PA_Boss_Giant_Spikes,           // 51
    PA_Boss_Giant_Strike,           // 52
    PA_Boss_Giant_Spawn,            // 53
    PA_Boss_Giant_BreakChains,      // 54
    PA_Boss_Giant_Death,            // 55
    PA_Boss_Giant_Suck,             // 56
    PA_Boss_Giant_Suck_Start,       // 57
    PA_Boss_Giant_Suck_End,         // 58
    PA_Frozen,                      // 59
    PA_FarAttackPrepare,            // 60
    PA_Boss_Alastor_BreakFloor,     // 61
    PA_Boss_Alastor_Charge,         // 62
    PA_Boss_Alastor_MeleeStrike,    // 63
    PA_Boss_Alastor_FireStrike,     // 64
    PA_Boss_Alastor_FireBreath,     // 65
    PA_Boss_Alastor_FireBreathPillars,// 66
    PA_Boss_Alastor_FireBall,       // 67
    PA_Boss_Swamp_Waterball,        // 68
    PA_Boss_Swamp_Fireball,         // 69
    PA_Boss_Swamp_SingleWaterhand,  // 70
    PA_Boss_Swamp_DoubleWaterhand,  // 71
    PA_Boss_TurnInPlace,            // 72
    PA_Boss_Swamp_Extinguish,       // 73
    PA_Boss_Reaper_Strike,          // 74
    PA_Boss_Reaper_Strafe,          // 75
    PA_Boss_Reaper_Spin,            // 76
    PA_Boss_Reaper_Release,         // 77
    PA_Boss_Reaper_Spawn,           // 78
    PA_Boss_Alastor_Charge_Start,   // 79
    PA_Boss_Alastor_Charge_End,     // 80
    PA_Boss_Alastor_TurnUp,         // 81
    PA_Boss_Alastor_Land,           // 82
    EPKPawnAction_MAX               // 83
};

enum EPKPartyType
{
    EPPT_InviteRequired,            // 0
    EPPT_Public,                    // 1
    EPPT_Local,                     // 2
    EPPT_MAX                        // 3
};

enum EMultiGameMode
{
    EMGM_NONE,                      // 0
    EMGM_Deathmatch,                // 1
    EMGM_TeamDeathmatch,            // 2
    EMGM_CTF,                       // 3
    EMGM_Survival,                  // 4
    EMGM_Cooperative,               // 5
    EMGM_SplitScreen,               // 6
    EMGM_MAX                        // 7
};

enum EDifficultyLevel
{
    DL_Daydream,                    // 0
    DL_Insomnia,                    // 1
    DL_Nightmare,                   // 2
    DL_Trauma,                      // 3
    DL_MAX                          // 4
};

enum ELevelID
{
    LID_Invalid,                    // 0
    LID_Cemetery,                   // 1
    LID_Cathedral,                  // 2
    LID_AtriumComplex,              // 3
    LID_Enclave,                    // 4
    LID_Opera,                      // 5
    LID_TrainStation,               // 6
    LID_Alastor,                    // 7
    LID_OrientalCastle,             // 8
    LID_Orphanage,                  // 9
    LID_Swamp,                      // 10
    LID_LoonyPark,                  // 11
    LID_Colloseum,                  // 12
    LID_ShadowLand,                 // 13
    LID_CityOnWater,                // 14
    LID_Lab,                        // 15
    LID_Factory,                    // 16
    LID_Tutorial,                   // 17
    LID_Hospital,                   // 18
    LID_Tutorial1,                  // 19
    LID_Halloween,                  // 20
    LID_Xmas,                       // 21
    LID_DLC2_Town,                  // 22
    LID_DLC2_Asylum,                // 23
    LID_DLC2_Bridge,                // 24
    LID_DLC3_Leningrad,             // 25
    LID_DLC3_Bunker,                // 26
    LID_DLC3_MilitaryBase,          // 27
    LID_DLC5_Graveyard,             // 28
    LID_DLC5_Town,                  // 29
    LID_DLC5_Babel,                 // 30
    LID_DLC5_Angkor,                // 31
    LID_DLC5_Pentagon,              // 32
    LID_DLC6_Monastery,             // 33
    LID_DLC6_Docks,                 // 34
    LID_DLC6_Ruins,                 // 35
    LID_DLC7_Prison,                // 36
    LID_DLC7_City,                  // 37
    LID_DLC7_Pentagon,              // 38
    LID_BONUS1_Conclave,            // 39
    LID_BONUS2_EasterEgg,           // 40
    LID_MAX                         // 41
};

enum EWeaponFireMode
{
    EWFM_Pain,                      // 0
    EWFM_Killer,                    // 1
    EWFM_Shotgun,                   // 2
    EWFM_Freezer,                   // 3
    EWFM_Stakegun,                  // 4
    EWFM_GrenadeLauncher,           // 5
    EWFM_Chaingun,                  // 6
    EWFM_RocketLauncher,            // 7
    EWFM_Electro,                   // 8
    EWFM_Driver,                    // 9
    EWFM_SMG,                       // 10
    EWFM_Flamethrower,              // 11
    EWFM_Boltgun,                   // 12
    EWFM_Heater,                    // 13
    EWFM_SoulSaw,                   // 14
    EWFM_SoulReaper,                // 15
    EWFM_DLC1_1,                    // 16
    EWFM_DLC1_2,                    // 17
    EWFM_DLC2_1,                    // 18
    EWFM_DLC2_2,                    // 19
    EWFM_DLC3_1,                    // 20
    EWFM_DLC3_2,                    // 21
    EWFM_DLC4_1,                    // 22
    EWFM_DLC4_2,                    // 23
    EWFM_DLC5_1,                    // 24
    EWFM_DLC5_2,                    // 25
    EWFM_DLC6_1,                    // 26
    EWFM_DLC6_2,                    // 27
    EWFM_DLC7_1,                    // 28
    EWFM_DLC7_2,                    // 29
    EWFM_DLC8_1,                    // 30
    EWFM_DLC8_2,                    // 31
    EWFM_DLC9_1,                    // 32
    EWFM_DLC9_2,                    // 33
    EWFM_DLC10_1,                   // 34
    EWFM_DLC10_2,                   // 35
    EWFM_MAX                        // 36
};

enum EDLCIdentifiers
{
    EDLC_Invalid,                   // 0
    EDLCI_CollectorsDLC1,           // 1
    EDLCI_CollectorsDLC2,           // 2
    EDLCI_PreorderDLC1,             // 3
    EDLCI_Halloween,                // 4
    EDLCI_XMas,                     // 5
    EDLCI_Easter,                   // 6
    EDLCI_Independence,             // 7
    EDLCI_DLC1,                     // 8
    EDLCI_DLC2,                     // 9
    EDLCI_DLC3,                     // 10
    EDLCI_DLC4,                     // 11
    EDLCI_DLC5,                     // 12
    EDLCI_DLC6,                     // 13
    EDLCI_DLC7,                     // 14
    EDLCI_DLC8,                     // 15
    EDLCI_DLC9,                     // 16
    EDLCI_DLC10,                    // 17
    EDLCI_DLC11,                    // 18
    EDLCI_DLC12,                    // 19
    EDLCI_DLC13,                    // 20
    EDLCI_DLC14,                    // 21
    EDLCI_DLC15,                    // 22
    EDLCI_DLC16,                    // 23
    EDLCI_DLC17,                    // 24
    EDLCI_DLC18,                    // 25
    EDLCI_DLC19,                    // 26
    EDLCI_DLC20,                    // 27
    EDLCIdentifiers_MAX             // 28
};

struct native LevelStatistics
{
    var int GameplayTime;
    var PKTypes.EDifficultyLevel Difficulty;
    var int MonstersKilled;
    var int SoulsCollected;
    var int ArmorsFound;
    var int GoldFound;
    var int BonusItems;
    var int HolyItemsFound;
    var int AmmoFound;
    var int ObjectsDestroyed;
    var int SecretsFound;
    var int TotalMonsters;
    var int TotalSouls;
    var int TotalArmors;
    var int TotalGold;
    var int TotalHolyItems;
    var int TotalAmmo;
    var int TotalObjects;
    var int TotalSecrets;
    var int TimeDiff;
    var int MonstersDiff;
    var int SoulsDiff;
    var int ArmorsDiff;
    var int GoldDiff;
    var int HolyDiff;
    var int AmmoDiff;
    var int ObjectsDiff;
    var int SecretsDiff;

    structdefaultproperties
    {
        GameplayTime=0
        Difficulty=EDifficultyLevel.DL_Daydream
        MonstersKilled=0
        SoulsCollected=0
        ArmorsFound=0
        GoldFound=0
        BonusItems=0
        HolyItemsFound=0
        AmmoFound=0
        ObjectsDestroyed=0
        SecretsFound=0
        TotalMonsters=0
        TotalSouls=0
        TotalArmors=0
        TotalGold=0
        TotalHolyItems=0
        TotalAmmo=0
        TotalObjects=0
        TotalSecrets=0
        TimeDiff=0
        MonstersDiff=0
        SoulsDiff=0
        ArmorsDiff=0
        GoldDiff=0
        HolyDiff=0
        AmmoDiff=0
        ObjectsDiff=0
        SecretsDiff=0
    }
};

struct native BindingInfo
{
    var name PrimaryBind;
    var name SecondaryBind;
    var string Command;

    structdefaultproperties
    {
        PrimaryBind="None"
        SecondaryBind="None"
        Command=""
    }
};

struct native CustomWeaponSelectInfo
{
    var Class WeaponClass;
    var bool bAltMode;

    structdefaultproperties
    {
        WeaponClass=none
        bAltMode=false
    }
};
