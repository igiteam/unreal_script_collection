class TurokStatEnumerations extends Object
    native;

const NUM_COMMON_STATS = 32;
const NUM_MP_STATS = 130;
const BASE_DERIVED_STAT = 130;
const NUM_DERIVED_STATS = 11;

enum eStat
{
    Stat_ShotsFired,                // 0
    Stat_ShotsHit,                  // 1
    Stat_Headshots,                 // 2
    Stat_LimbShots,                 // 3
    Stat_GrenadesUsed,              // 4
    Stat_BodyShots,                 // 5
    Stat_Deaths,                    // 6
    Stat_Kills,                     // 7
    Stat_FragKills,                 // 8
    Stat_GunKills,                  // 9
    Stat_HeadshotKills,             // 10
    Stat_StealthKills,              // 11
    Stat_TurretKills,               // 12
    Stat_Bugs_NumKilled,            // 13
    Stat_Dinos_NumKilled,           // 14
    Stat_Weapon_KnifeKills,         // 15
    Stat_Weapon_BowKills,           // 16
    Stat_TimePlayed,                // 17
    Stat_Scarface_Fights,           // 18
    Stat_WaterBoss_Kills,           // 19
    Stat_Shotgunless_Runs,          // 20
    Stat_Campaigns_Completed,       // 21
    Stat_HardCampaigns_Completed,   // 22
    Stat_Max_MG_Frag_Combo,         // 23
    Stat_Max_MG_Rocket_Combo,       // 24
    Stat_Weapon_ShotgunShotsFired,  // 25
    Stat_Creature_Knife_Kills,      // 26
    Stat_Mauls_Won,                 // 27
    Stat_Bait_Kills,                // 28
    Stat_MG_Arrow_Pins,             // 29
    Stat_MG_Knife_Kills,            // 30
    Stat_MaxConsecutiveHeadshots,   // 31
    Stat_LongestDeathStreak,        // 32
    Stat_LongestKillStreak,         // 33
    Stat_LongestSurvivalTime,       // 34
    Stat_MaxKillCombo,              // 35
    Stat_MaxConsecutiveVictimKills, // 36
    Stat_DeathsByTeammates,         // 37
    Stat_Suicides,                  // 38
    Stat_Assists,                   // 39
    Stat_HumanoidsKilled,           // 40
    Stat_PlayersKilled,             // 41
    Stat_PlayersKilledRanked,       // 42
    Stat_TeammatesKilled,           // 43
    Stat_RivalsStealthKilled,       // 44
    Stat_GamesPlayed,               // 45
    Stat_GamesWon,                  // 46
    Stat_GamesLost,                 // 47
    Stat_DMGamesPlayed,             // 48
    Stat_DMGamesWon,                // 49
    Stat_TDMGamesPlayed,            // 50
    Stat_TDMGamesWon,               // 51
    Stat_CTFGamesPlayed,            // 52
    Stat_CTFGamesWon,               // 53
    Stat_ACTFGamesPlayed,           // 54
    Stat_ACTFGamesWon,              // 55
    Stat_WarGamesPlayed,            // 56
    Stat_WarGamesWon,               // 57
    Stat_CoopGamesPlayed,           // 58
    Stat_CoopGamesWon,              // 59
    Stat_MPCoop02Completed,         // 60
    Stat_MPCoop03Completed,         // 61
    Stat_MPCoop04Completed,         // 62
    Stat_PublicSmallTeamGamesWon,   // 63
    Stat_PublicLargeTeamGamesWon,   // 64
    Stat_PublicCoopGamesWon,        // 65
    Stat_Weapon_BowKillsPublic,     // 66
    Stat_Weapon_BowShotsFired,      // 67
    Stat_Weapon_BowShotsHit,        // 68
    Stat_Weapon_FlamethrowerKills,  // 69
    Stat_Weapon_FlamethrowerKillsPublic,// 70
    Stat_Weapon_FlamethrowerShotsFired,// 71
    Stat_Weapon_FlamethrowerShotsHit,// 72
    Stat_Weapon_FragGrenadeKills,   // 73
    Stat_Weapon_FragGrenadeKillsPublic,// 74
    Stat_Weapon_HandgunKills,       // 75
    Stat_Weapon_HandgunKillsPublic, // 76
    Stat_Weapon_HandgunShotsFired,  // 77
    Stat_Weapon_HandgunShotsHit,    // 78
    Stat_Weapon_KnifeKillsPublic,   // 79
    Stat_Weapon_KnifeShotsFired,    // 80
    Stat_Weapon_KnifeShotsHit,      // 81
    Stat_Weapon_MinigunKills,       // 82
    Stat_Weapon_MinigunKillsPublic, // 83
    Stat_Weapon_MinigunShotsFired,  // 84
    Stat_Weapon_MinigunShotsHit,    // 85
    Stat_Weapon_RailgunKills,       // 86
    Stat_Weapon_RailgunKillsPublic, // 87
    Stat_Weapon_RailgunShotsFired,  // 88
    Stat_Weapon_RailgunShotsHit,    // 89
    Stat_Weapon_RPGKills,           // 90
    Stat_Weapon_RPGKillsPublic,     // 91
    Stat_Weapon_RPGShotsFired,      // 92
    Stat_Weapon_RPGShotsHit,        // 93
    Stat_Weapon_ShotgunKills,       // 94
    Stat_Weapon_ShotgunKillsPublic, // 95
    Stat_Weapon_ShotgunShotsHit,    // 96
    Stat_Weapon_SMGKills,           // 97
    Stat_Weapon_SMGKillsPublic,     // 98
    Stat_Weapon_SMGShotsFired,      // 99
    Stat_Weapon_SMGShotsHit,        // 100
    Stat_Weapon_SniperRifleKills,   // 101
    Stat_Weapon_SniperRifleKillsPublic,// 102
    Stat_Weapon_SniperRifleShotsFired,// 103
    Stat_Weapon_SniperRifleShotsHit,// 104
    Stat_Weapon_StickyGunKills,     // 105
    Stat_Weapon_StickyGunKillsPublic,// 106
    Stat_Weapon_StickyGunShotsFired,// 107
    Stat_Weapon_StickyGunShotsHit,  // 108
    Stat_Weapon_FragGrenadeShotsFired,// 109
    Stat_Weapon_FragGrenadeShotsHit,// 110
    Stat_BombsPlanted,              // 111
    Stat_BombsDefused,              // 112
    Stat_BombCarriersKilled,        // 113
    Stat_ComputersHacked,           // 114
    Stat_FlagsCaptured,             // 115
    Stat_FlagsRecovered,            // 116
    Stat_NearFlagKills,             // 117
    Stat_FlagCarriersKilled,        // 118
    Stat_HurtFlagCarrierRevengeKills,// 119
    Stat_NearYourFlagCarrierKills,  // 120
    Stat_ReturnFlagThenCaptureFlag, // 121
    Stat_KillFlagCarrierThenCaptureFlag,// 122
    Stat_PowerCoresCaptured,        // 123
    Stat_PowerCoresStolen,          // 124
    Stat_PowerCoreCarrierKills,     // 125
    Stat_HurtCarrierRevengeKills,   // 126
    Stat_KillsNearYourCarrier,      // 127
    Stat_KillsNearYourCoreOrBomb,   // 128
    Stat_Dinos_DilosKilledWithStickyGun,// 129
    Stat_BattleRating,              // 130
    Stat_AccuracyPercentage,        // 131
    Stat_VictoryPercentage,         // 132
    Stat_KillsPerDeath,             // 133
    Stat_KillsPerMinute,            // 134
    Stat_DeathsPerMinute,           // 135
    Stat_FavoriteWeaponId,          // 136
    Stat_FavoriteWeaponKills,       // 137
    Stat_FavoriteWeaponAccuracy,    // 138
    Stat_TotalCTFActPoints,         // 139
    Stat_TotalWGActPoints,          // 140
    Stat_MAX                        // 141
};

enum eStatType
{
    StatType_Unknown,               // 0
    StatType_Int,                   // 1
    StatType_Float,                 // 2
    StatType_Time,                  // 3
    StatType_Weapon,                // 4
    StatType_Percentage,            // 5
    StatType_BitField,              // 6
    StatType_MAX                    // 7
};

enum eStatOp
{
    StatOp_Set,                     // 0
    StatOp_Accumulate,              // 1
    StatOp_UseMaxValue,             // 2
    StatOp_Or,                      // 3
    StatOp_MAX                      // 4
};
