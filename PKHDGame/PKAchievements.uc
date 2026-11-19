class PKAchievements extends UTAchievementsBase within PKPlayerController;

enum EPKGameAchievements
{
    EPKA_Invalid,                   // 0
    EPKA_UNLOCKED_CARD_G_ENDURANCE, // 1
    EPKA_UNLOCKED_CARD_G_HASTE,     // 2
    EPKA_UNLOCKED_CARD_G_TIMEBONUS, // 3
    EPKA_UNLOCKED_CARD_G_SPEED,     // 4
    EPKA_UNLOCKED_CARD_G_FURY,      // 5
    EPKA_UNLOCKED_CARD_G_DOUBLEHASTE,// 6
    EPKA_UNLOCKED_CARD_G_DEXTERITY, // 7
    EPKA_UNLOCKED_CARD_G_IRONWILL,  // 8
    EPKA_UNLOCKED_CARD_G_RAGE,      // 9
    EPKA_UNLOCKED_CARD_G_DOUBLETIMEBONUS,// 10
    EPKA_UNLOCKED_CARD_G_TRIPLEHASTE,// 11
    EPKA_UNLOCKED_CARD_G_CONFUSION, // 12
    EPKA_UNLOCKED_CARD_S_SOULKEEPER,// 13
    EPKA_UNLOCKED_CARD_S_BLESSING,  // 14
    EPKA_UNLOCKED_CARD_S_REPLENISH, // 15
    EPKA_UNLOCKED_CARD_S_DARKSOUL,  // 16
    EPKA_UNLOCKED_CARD_S_SOULCATCHER,// 17
    EPKA_UNLOCKED_CARD_S_FORGIVENESS,// 18
    EPKA_UNLOCKED_CARD_S_GREED,     // 19
    EPKA_UNLOCKED_CARD_S_VITALITY,  // 20
    EPKA_UNLOCKED_CARD_S_DIVINEINTERVENTION,// 21
    EPKA_UNLOCKED_CARD_S_LASTBREATH,// 22
    EPKA_UNLOCKED_CARD_S_SOULREDEEMER,// 23
    EPKA_UNLOCKED_CARD_S_MERCY,     // 24
    EPKA_KILL_666_ENEMIES,          // 25
    EPKA_KILL_999_ENEMIES,          // 26
    EPKA_COLLECT_2012_GOLD,         // 27
    EPKA_FIND_25_SECRET_AREAS,      // 28
    EPKA_FINISH_FIRST_CHAPTER,      // 29
    EPKA_FINISH_SECOND_CHAPTER,     // 30
    EPKA_FINISH_THIRDCHAPTER,       // 31
    EPKA_COLLECT_667_SOULS,         // 32
    EPKA_SHOOT_50000_TIMES,         // 33
    EPKA_PLAY_10_LEVELS_IN_COOP,    // 34
    EPKA_COLLECT_500_AMMO_CRATES,   // 35
    EPKA_DESTROY_300_EXPLO_BARRELS, // 36
    EPKA_KILL_333_ENEMIES_WITH_EXPLOSIVES,// 37
    EPKA_KILL_5_ENEMIES_WITH_ONE_ROCKET,// 38
    EPKA_SPEND_666_SEC_BUNNY_HOP,   // 39
    EPKA_GIB_100_ENEMIES,           // 40
    EPKA_FINISH_GAME_ON_NIGHTMARE,  // 41
    EPKA_FINISH_GAME_ON_TRAUMA,     // 42
    EPKA_COLLECT_40_ARMORS,         // 43
    EPKA_FINISH_LEVEL_WITH_STAKEGUN_ONLY,// 44
    EPKA_KILL_10000_ENEMIES,        // 45
    EPKA_KILL_500_ENEMIES_WITH_ENV_DAMAGE,// 46
    EPKA_KILL_123_ENEMIES_WITH_COMBO_DMG,// 47
    EPKA_CAPTURE_3_FLAGS_AS_EVE,    // 48
    EPKA_KILL_1000_ENEMIES_IN_SV,   // 49
    EPKA_30KILLSIN3MIN_INDEATHMATCH,// 50
    EPKA_FINISH_LEVEL_WITHOUT_BEING_HURT,// 51
    EPKA_DONT_LET_YOUR_PARTNER_DIE_COOP,// 52
    EPKA_COLLECT_ALL_AVAILABLE_TAROTS,// 53
    EPKA_KILLS_ENEMY_WHEN_HE_KILLS_U,// 54
    EPKA_KILL_3_ENEMIES_WITH_1_BOLTGUN_SHOT,// 55
    EPKA_BRING_ENEMY_FLAG_TO_YOUR_BASE,// 56
    EPKA_WIN_SURVIVAL_MATCH,        // 57
    EPKA_DONT_DIE_AND_WIN_MULTI_GAME,// 58
    EPKA_DONT_LET_ANY_ENEMIES_COLLECT_QUAD,// 59
    EPKA_GATHER_4_MORE_FRAGS_THAN_ANY_OF_YOUR_ENEMIES,// 60
    EPKA_WIN_TD_WITH_HIGHHEST_SCORE_IN_YOUR_TEAM,// 61
    EPKA_WIN_CTF_AND_BRING_FLAG_TO_YOUR_BASE_IN_10_SECONDS_OF_GAME,// 62
    EPKA_WIN_SV_WITH_2_TIMES_KILLED_MONSTERS_THAN_U_ENEMIES,// 63
    EPKA_KILL_3_ENEMIES_WITH_SHOTGUN_BLAST,// 64
    EPKA_KILL_256_ENEMIES_WHEN_BUNNYHOPPING,// 65
    EPKA_KEEP_HIT_RATIO_ABOVE_90_PERCENT,// 66
    EPKA_FINISH_HALLOWEEN_MAP,      // 67
    EPKA_FINISH_XMAS_MAP,           // 68
    EPKA_DLC1_WIN_DM_ON_PSYCHO,     // 69
    EPKA_DLC1_WIN_SV_ON_ILLUMINATI, // 70
    EPKA_DLC2_KILLALLENEMIES_ON_BRIDGE,// 71
    EPKA_DLC2_FINISH_TOWN_MAP,      // 72
    EPKA_DLC3_FIND_ALL_SECRETS_ON_BUNKER,// 73
    EPKA_DLC3_WIN_DM_ON_FRAGENSTEIN,// 74
    EPKA_DLC4_WIN_CTF_ON_DM_COMMUNITY2,// 75
    EPKA_DLC6_COLLECT_ALL_HOLY_ON_MONASTERY,// 76
    EPKA_DLC6_DESTROY_ALL_OBJECTS_ON_RUINS,// 77
    EPKA_DLC7_COLLECT_ALL_AMMO_ON_PENTAGON,// 78
    EPKA_FINISH_CONCLAVE_LEVEL,     // 79
    EPKA_FINISH_EASTEREGG_LEVEL,    // 80
    EPKA_CHALLENGE_ATRIUMCOMPLEX,   // 81
    EPKA_CHALLENGE_CITYONWATER,     // 82
    EPKA_CHALLENGE_OPERA,           // 83
    EPKA_CHALLENGE_TRAINSTATION,    // 84
    EPKA_CHALLENGE_UNSEEN,          // 85
    EPKA_CHALLENGE_CHAOS,           // 86
    EPKA_CHALLENGE_ILLUMINATI,      // 87
    EPKA_CHALLENGE_INHUMATOR,       // 88
    EPKA_CHALLENGE_PSYCHO,          // 89
    EPKA_CHALLENGE_FRAGENSTEIN,     // 90
    EPKA_CHALLENGE_COMMUNITY_BLINK, // 91
    EPKA_CHALLENGE_COMMUNITY_MEATLESS,// 92
    EPKA_CHALLENGE_COMMUNITY_MINES, // 93
    EPKA_CHALLENGE_COMMUNITY_PRISON,// 94
    EPKA_CHALLENGE_COMMUNITY_SNOWTOWN,// 95
    EPKA_DLC5_FINISH_GRAVEYARD,     // 96
    EPKA_DLC5_FINISH_TOWN,          // 97
    EPKA_DLC5_FINISH_BABEL,         // 98
    EPKA_DLC5_FINISH_ANGKOR,        // 99
    EPKA_DLC5_FINISH_PENTAGON,      // 100
    EPKA_DLC5_BABEL_DONT_KILL_ZOMBIES_WHILE_SOLVING_PUZZLES,// 101
    EPKA_DLC5_BABEL_AVOID_BURNS_ON_FIRE_PLATE_PUZZLE,// 102
    EPKA_DLC5_GRAVEYARD_USE_5_ELECTRIC_SPARKS,// 103
    EPKA_DLC5_GRAVEYARD_SUMMON_GHOSTSHIP,// 104
    EPKA_DLC5_GRAVEYARD_DESTROY_3_AMBULANCES,// 105
    EPKA_DLC5_TOWN_KILL_ALL_CASTLE_GUARDS,// 106
    EPKA_DLC5_TOWN_SOLVE_POPE_PUZZLE,// 107
    EPKA_DLC5_ANGKOR_FLIP_16_COLUMNS,// 108
    EPKA_DLC5_ANGKOR_FINISH_ARENA_WITHOUT_USING_MONK_TRAP,// 109
    EPKA_CHALLENGE_FACTORY,         // 110
    EPKA_CHALLENGE_HALLOWEEN_TOWN,  // 111
    EPKA_MAX                        // 112
};

struct AchiLocKit
{
    var const localized string Name_PC;
    var const localized string Name_XBOX;
    var const localized string Name_PS3;
    var const localized string UnlockCriteria;
    var const localized string UnlockedDesc;

    structdefaultproperties
    {
        Name_PC=""
        Name_XBOX=""
        Name_PS3=""
        UnlockCriteria=""
        UnlockedDesc=""
    }
};

var array<AchiLocKit> AchievementsLocKit;
var private array<PKAchievements.EPKGameAchievements> GoldenCardsToAchievementMap;
var private array<PKAchievements.EPKGameAchievements> SilverCardsToAchievementMap;
var array<PKAchievements.EPKGameAchievements> GlobalStatToAchievementMap;

static simulated function PKAchievements.EPKGameAchievements TranslateGoldCardToAchievement(PKTarotManager.EGoldenTarrotCard card)
{
    return default.GoldenCardsToAchievementMap[int(card)];
    //return ReturnValue;    
}

static simulated function PKAchievements.EPKGameAchievements TranslateSilverCardToAchievement(PKTarotManager.ESilverTarrotCard card)
{
    return default.SilverCardsToAchievementMap[int(card)];
    //return ReturnValue;    
}

defaultproperties
{
    AchievementsLocKit[0]=(Name_PC="Invalid",Name_XBOX="Invalid",Name_PS3="Invalid",UnlockCriteria="Invalid",UnlockedDesc="Invalid")
    AchievementsLocKit[1]=(Name_PC="Endurance",Name_XBOX="Evil's Endurance",Name_PS3="Golden Endurance",UnlockCriteria="Cemetery: Beat the level (Solo Campaign)",UnlockedDesc="Finished Cemetery level (Solo Campaign)")
    AchievementsLocKit[2]=(Name_PC="Haste",Name_XBOX="Evil's Haste",Name_PS3="Golden Haste",UnlockCriteria="Tutorial: Destroy all objects (Solo Campaign)",UnlockedDesc="Smashed all objects at Tutorial level (Solo Campaign)")
    AchievementsLocKit[3]=(Name_PC="Time Bonus",Name_XBOX="Evil's Time",Name_PS3="Golden Time Bonus",UnlockCriteria="Oriental Castle: Gib 123 enemies (Solo Campaign)",UnlockedDesc="Gibbed 123 enemies at Oriental Castle (Solo Campaign)")
    AchievementsLocKit[4]=(Name_PC="Speed",Name_XBOX="Evil's Speed",Name_PS3="Golden Speed",UnlockCriteria="Cathedral: Collect 330 pieces of gold dropped by enemies (Solo Campaign)",UnlockedDesc="Collected 330 pieces of gold from fallen enemies at Cathedral (Solo Campaign)")
    AchievementsLocKit[5]=(Name_PC="Fury",Name_XBOX="Evil's Fury",Name_PS3="Golden Fury",UnlockCriteria="Loonypark: Kill 3 monsters in a row using saw blade (Solo Campaign)",UnlockedDesc="Killed 3 monsters in a row using saw blade at Loonypark (Solo Campaign)")
    AchievementsLocKit[6]=(Name_PC="Double Haste",Name_XBOX="Evil's Double Haste",Name_PS3="Golden Double Haste",UnlockCriteria="Opera: Collect 100 souls (Solo Campaign)",UnlockedDesc="Collected 100 souls of dead singers at Opera (Solo Campaign)")
    AchievementsLocKit[7]=(Name_PC="Dexterity",Name_XBOX="Evil's Dexterity",Name_PS3="Golden Dexterity",UnlockCriteria="Swamp: Kill Swamp Thing in under 4:00 (Solo Campaign)",UnlockedDesc="Killed Swamp Thing in under 4:00 (Solo Campaign)")
    AchievementsLocKit[8]=(Name_PC="Iron Will",Name_XBOX="Evil's Will",Name_PS3="Golden Iron Will",UnlockCriteria="Orphanage: Gib 50 frozen enemies (Solo Campaign)",UnlockedDesc="Gibbed 50 frozen enemies at Orphanage (Solo Campaign)")
    AchievementsLocKit[9]=(Name_PC="Rage",Name_XBOX="Evil's Rage",Name_PS3="Golden Rage",UnlockCriteria="Shadowland: Collect all Holy Items (Solo Campaign)",UnlockedDesc="Collected all Holy Items at Shadowland (Solo Campaign)")
    AchievementsLocKit[10]=(Name_PC="Double Time Bonus",Name_XBOX="Evil's Double Time",Name_PS3="Golden Double Time Bonus",UnlockCriteria="Colosseum: Pick up every ammo box (Solo Campaign)",UnlockedDesc="Collected all ammo boxes from Collosseum (Solo Campaign)")
    AchievementsLocKit[11]=(Name_PC="Triple Haste",Name_XBOX="Evil's Triple Haste",Name_PS3="Golden Triple Haste",UnlockCriteria="Alastor: Kill Alastor in under 5:00 (Solo Campaign)",UnlockedDesc="Killed Alastor in under 5:00 (Solo Campaign)")
    AchievementsLocKit[12]=(Name_PC="Confusion",Name_XBOX="Evil's Confusion",Name_PS3="Golden Confusion",UnlockCriteria="Lab: Morph into demon 3 times (Solo Campaign)",UnlockedDesc="Mophed into demon 3 times (Solo Campaign)")
    AchievementsLocKit[13]=(Name_PC="Soul Keeper",Name_XBOX="Angel's Soul",Name_PS3="Silver Soul Keeper",UnlockCriteria="Atrium Complex: Finish level in under 7:00 (Solo Campaign)",UnlockedDesc="Finished Atrium Complex level in under 7:00 (Solo Campaign)")
    AchievementsLocKit[14]=(Name_PC="Blessing",Name_XBOX="Angel's Blessing",Name_PS3="Silver Blessing",UnlockCriteria="Enclave: Kill Necrogiant in under 2:00 (Solo Campaign)",UnlockedDesc="Killed Necrogiant in under 2:00 (Solo Campaign)")
    AchievementsLocKit[15]=(Name_PC="Replenish",Name_XBOX="Angel's Replenish",Name_PS3="Silver Replenish",UnlockCriteria="Colosseum: Morph into demon 3 times (Solo Campaign)",UnlockedDesc="Morphed into demon 3 times at Collosseum (Solo Campaign)")
    AchievementsLocKit[16]=(Name_PC="Dark Soul",Name_XBOX="Angel's Dark",Name_PS3="Silver Dark Soul",UnlockCriteria="Opera: Find all secret areas (Solo Campaign)",UnlockedDesc="Found all secret areas at Opera (Solo Campaign)")
    AchievementsLocKit[17]=(Name_PC="Soul Catcher",Name_XBOX="Angel's Catcher",Name_PS3="Silver Soul Catcher",UnlockCriteria="Trainstation: Cut limbs of 100 enemies using Soul Catcher (Solo Campaign)",UnlockedDesc="Cut 100 limbs at Trainstation using Soul Catcher (Solo Campaign)")
    AchievementsLocKit[18]=(Name_PC="Forgiveness",Name_XBOX="Angel's Forgiveness",Name_PS3="Silver Forgiveness",UnlockCriteria="Factory: Kill 30 enemies in demon mode (Solo Campaign)",UnlockedDesc="Shredded 30 enemies being a demon (Solo Campaign)")
    AchievementsLocKit[19]=(Name_PC="Greed",Name_XBOX="Angel's Greed",Name_PS3="Silver Greed",UnlockCriteria="Orphanage: Kill all monsters (Solo Campaign)",UnlockedDesc="Killed all monsters at Orphanage (Solo Campaign)")
    AchievementsLocKit[20]=(Name_PC="Vitality",Name_XBOX="Angel's Vitality",Name_PS3="Silver Vitality",UnlockCriteria="Cathedral: Collect 500 gold (Solo Campaign)",UnlockedDesc="Collected 500 pieces of gold at Cathedra (Solo Campaign)")
    AchievementsLocKit[21]=(Name_PC="Divine Intervention",Name_XBOX="Angel's Intervention",Name_PS3="Silver Divine Intervention",UnlockCriteria="Loonypark: Possess 25 enemies using Soul Catcher (Solo Campaign)",UnlockedDesc="Possessed 25 enemies using Soul Catcher at Loonypark (Solo Campaign)")
    AchievementsLocKit[22]=(Name_PC="Last Breath",Name_XBOX="Angel's Last Breath",Name_PS3="Silver Last Breath",UnlockCriteria="City On Water: Find all secret areas (Solo Campaign)",UnlockedDesc="Found all secret areas at City on Water (Solo Campaign)")
    AchievementsLocKit[23]=(Name_PC="Soul Redeemer",Name_XBOX="Angel's Redeemer",Name_PS3="Silver Soul Redeemer",UnlockCriteria="Oriental Castle: Collect all Holy Items (Solo Campaign)",UnlockedDesc="Collected all Holy Items at Oriental Castle (Solo Campaign)")
    AchievementsLocKit[24]=(Name_PC="Mercy",Name_XBOX="Angel's Mercy",Name_PS3="Silver Mercy",UnlockCriteria="Shadowland: Kill Grim Reaper (Solo Campaign)",UnlockedDesc="Defeated the Death himself (Solo Campaign)")
    AchievementsLocKit[25]=(Name_PC="Name of the Beast",Name_XBOX="Devil's Name",Name_PS3="Name the Evil",UnlockCriteria="Kill 666 enemies with Soul Catcher",UnlockedDesc="Killed 666 enemies with Soul Catcher")
    AchievementsLocKit[26]=(Name_PC="Upside Down Beast",Name_XBOX="Reversed Devil",Name_PS3="Upside-Down",UnlockCriteria="Kill 999 enemies with Shotgun",UnlockedDesc="Killed 999 enemies with Shotgun")
    AchievementsLocKit[27]=(Name_PC="Farmer",Name_XBOX="Greedy Farmer",Name_PS3="Farm Master",UnlockCriteria="Solo Campaign: Collect 2012 pieces of gold from fallen enemies",UnlockedDesc="Solo Campaign: Collected 2012 pieces of gold from fallen enemies")
    AchievementsLocKit[28]=(Name_PC="Adventurer",Name_XBOX="Discoverer",Name_PS3="Treasure Hunter",UnlockCriteria="Solo Campaign: Find 25 secret areas",UnlockedDesc="Solo Campaign: Found 25 secret areas")
    AchievementsLocKit[29]=(Name_PC="Grave Digger",Name_XBOX="Grave Raider",Name_PS3="Grave Hunter",UnlockCriteria="Solo Campaign: Finish 1st chapter",UnlockedDesc="Solo Campaign: Finished 1st chapter")
    AchievementsLocKit[30]=(Name_PC="Penthouse Down",Name_XBOX="Skyscraper",Name_PS3="Fallen",UnlockCriteria="Solo Campaign: Finish 2nd chapter",UnlockedDesc="Solo Campaign: Finished 2nd chapter")
    AchievementsLocKit[31]=(Name_PC="Evil's Orphans",Name_XBOX="Evil's Kids",Name_PS3="New Kids On the Blob",UnlockCriteria="Solo Campaign: Finish 3rd chapter",UnlockedDesc="Solo Campaign: Finished 3rd chapter")
    AchievementsLocKit[32]=(Name_PC="Neighbor of the Beast",Name_XBOX="Above the Beast",Name_PS3="Imperfection",UnlockCriteria="Collect 667 souls of dismembered enemies",UnlockedDesc="Collected 667 souls of dismembered enemies")
    AchievementsLocKit[33]=(Name_PC="Spammer",Name_XBOX="Statistical Effect",Name_PS3="Bullet Spammer",UnlockCriteria="Shoot 50000 times",UnlockedDesc="Made 50000 shots")
    AchievementsLocKit[34]=(Name_PC="I have friends",Name_XBOX="True friendship",Name_PS3="Real colleague",UnlockCriteria="Play 10 different levels in cooperative mode",UnlockedDesc="Played 10 different levels in cooperative mode")
    AchievementsLocKit[35]=(Name_PC="Warehouseman",Name_XBOX="Warehouse",Name_PS3="Depot",UnlockCriteria="Collect 500 ammo crates",UnlockedDesc="Collected 500 ammo crates")
    AchievementsLocKit[36]=(Name_PC="Barrel hater",Name_XBOX="Barrel destroyer",Name_PS3="Barrel killer",UnlockCriteria="Destroy 300 barrels",UnlockedDesc="Destroyed 300 barrels")
    AchievementsLocKit[37]=(Name_PC="Tornado",Name_XBOX="Cyclone",Name_PS3="Hurricane",UnlockCriteria="Kill 333 enemies with explosive weapons",UnlockedDesc="Killed 333 enemies with explosive weapons")
    AchievementsLocKit[38]=(Name_PC="Five Points",Name_XBOX="Five Points Gangsta",Name_PS3="Five at Once",UnlockCriteria="Kill 5 enemies with one rocket",UnlockedDesc="Killed 5 enemies with one rocket")
    AchievementsLocKit[39]=(Name_PC="Demon Kangaroo",Name_XBOX="Rabbit's Son",Name_PS3="Bunny the Rabbit",UnlockCriteria="Spend 666 seconds on bunny-hopping",UnlockedDesc="Spent 666 seconds jumping like a rabbit")
    AchievementsLocKit[40]=(Name_PC="Mass Chopper",Name_XBOX="Chopper of the Year",Name_PS3="Chop-Chop",UnlockCriteria="Gib 100 enemies entirely with rockets",UnlockedDesc="Using rockets, made 100 enemies rest in pieces")
    AchievementsLocKit[41]=(Name_PC="Nightmare Lover",Name_XBOX="Nightmare is Over",Name_PS3="Nightmare Collector",UnlockCriteria="Solo Campaign: Play whole game on Nightmare difficulty level",UnlockedDesc="Played whole game on Nightmare difficulty")
    AchievementsLocKit[42]=(Name_PC="Sweet dreams",Name_XBOX="Trauma's End",Name_PS3="Trauma Survived",UnlockCriteria="Solo Campaign: Play whole game on Trauma difficulty level",UnlockedDesc="Played whole game on Trauma difficulty")
    AchievementsLocKit[43]=(Name_PC="Militarist",Name_XBOX="Cloth Collector",Name_PS3="Fussy Knight",UnlockCriteria="Collect 40 armors",UnlockedDesc="Collected 40 armors")
    AchievementsLocKit[44]=(Name_PC="Sniping Elite",Name_XBOX="High Stakes",Name_PS3="Puncture",UnlockCriteria="Finish the level using stakes only and don't miss any hit",UnlockedDesc="Finished level using stakes only with 100% accuracy")
    AchievementsLocKit[45]=(Name_PC="Plague",Name_XBOX="Extinction",Name_PS3="Annihilation",UnlockCriteria="Kill 6666 enemies with stakes",UnlockedDesc="Impaled 6666 enemies using stakes")
    AchievementsLocKit[46]=(Name_PC="Twister",Name_XBOX="Disaster",Name_PS3="Calamity",UnlockCriteria="Kill 500 enemies with environmental explosions",UnlockedDesc="Killed 500 enemies not wasting ammo on them")
    AchievementsLocKit[47]=(Name_PC="Mountebank",Name_XBOX="Trickster",Name_PS3="Warlock",UnlockCriteria="Kill 123 enemies with combo damage",UnlockedDesc="Killed 123 enemies with special attacks")
    AchievementsLocKit[48]=(Name_PC="Sport Season",Name_XBOX="Sport League",Name_PS3="Promoter",UnlockCriteria="Capture 3 flags playing as Eve in one game",UnlockedDesc="Captured 3 flags playing as Eve in one game")
    AchievementsLocKit[49]=(Name_PC="Beard Grill",Name_XBOX="Exterminator",Name_PS3="Immortal",UnlockCriteria="Kill 1000 enemies in Survival mode",UnlockedDesc="Killed 1000 enemies in Survival mode")
    AchievementsLocKit[50]=(Name_PC="Insolent",Name_XBOX="Hard-boiled",Name_PS3="Road Roller",UnlockCriteria="Get 30 kills in 3 minutes in Deathmatch mode",UnlockedDesc="Got 30 kills in 3 minutes playing in Deathmatch mode")
    AchievementsLocKit[51]=(Name_PC="Ghost",Name_XBOX="Wary",Name_PS3="Cautious",UnlockCriteria="Finish level without being hurt",UnlockedDesc="Avoided wounds in whole level")
    AchievementsLocKit[52]=(Name_PC="Surgeon",Name_XBOX="Protector",Name_PS3="Angel Guard",UnlockCriteria="Play cooperative level and don't let your partner die",UnlockedDesc="Invalid")
    AchievementsLocKit[53]=(Name_PC="Collector",Name_XBOX="Cardshaper",Name_PS3="Blackleg",UnlockCriteria="Collect all available Black Tarot cards",UnlockedDesc="Invalid")
    AchievementsLocKit[54]=(Name_PC="Mirror Effect",Name_XBOX="Back to the Sender",Name_PS3="Dead-heat",UnlockCriteria="Kill enemy at the same time he kills you",UnlockedDesc="Invalid")
    AchievementsLocKit[55]=(Name_PC="Skewers",Name_XBOX="Big Toothpicks",Name_PS3="Triple Impaled",UnlockCriteria="Kill 3 enemies with one Boltgun shot",UnlockedDesc="Invalid")
    AchievementsLocKit[56]=(Name_PC="Robber",Name_XBOX="Lifter",Name_PS3="Thief",UnlockCriteria="Bring enemy flag to your base",UnlockedDesc="Invalid")
    AchievementsLocKit[57]=(Name_PC="Hard-bitten",Name_XBOX="Imperishable",Name_PS3="Incorruptible",UnlockCriteria="Win Survival match",UnlockedDesc="Invalid")
    AchievementsLocKit[58]=(Name_PC="Untouched",Name_XBOX="Untouchable",Name_PS3="Last Man Standing",UnlockCriteria="Don't die and win multiplayer game",UnlockedDesc="Invalid")
    AchievementsLocKit[59]=(Name_PC="Malicious",Name_XBOX="Vicious",Name_PS3="Scathing",UnlockCriteria="Don't let any of your enemies collect Quad Damage",UnlockedDesc="Invalid")
    AchievementsLocKit[60]=(Name_PC="4x4",Name_XBOX="Quad Damage",Name_PS3="Quad Fury",UnlockCriteria="Play with at least 4 other people and collect 4 frags more than any of your enemies",UnlockedDesc="Invalid")
    AchievementsLocKit[61]=(Name_PC="Best of the Best",Name_XBOX="Team Leader",Name_PS3="Team Owner",UnlockCriteria="Win Team Deathmatch with the highest score in your team",UnlockedDesc="Invalid")
    AchievementsLocKit[62]=(Name_PC="Last moment",Name_XBOX="Savior of the Day",Name_PS3="Final Rescue",UnlockCriteria="Win Capture The Flag by bringing the flag to your base in last 10 seconds of the game",UnlockedDesc="Invalid")
    AchievementsLocKit[63]=(Name_PC="Employee of the month",Name_XBOX="Double Ownage",Name_PS3="Overwhelming",UnlockCriteria="Win Survival killing at least 2 times more monsters than your rivals",UnlockedDesc="Invalid")
    AchievementsLocKit[64]=(Name_PC="Scavenger",Name_XBOX="Sweeper",Name_PS3="Cleaner",UnlockCriteria="Kill 3 enemies with one shotgun blast",UnlockedDesc="Invalid")
    AchievementsLocKit[65]=(Name_PC="Jumping Death",Name_XBOX="Jumping Justice",Name_PS3="Killing Rabbit",UnlockCriteria="Kill 256 enemies when bunnyhopping",UnlockedDesc="Invalid")
    AchievementsLocKit[66]=(Name_PC="Hygienic",Name_XBOX="Always Healthy",Name_PS3="Health and Luck",UnlockCriteria="Keep the hit ratio above 90% in whole level",UnlockedDesc="Invalid")
    GoldenCardsToAchievementMap[0]=.EPKA_Invalid
    GoldenCardsToAchievementMap[1]=.EPKA_UNLOCKED_CARD_G_ENDURANCE
    GoldenCardsToAchievementMap[2]=.EPKA_UNLOCKED_CARD_G_HASTE
    GoldenCardsToAchievementMap[3]=.EPKA_UNLOCKED_CARD_G_TIMEBONUS
    GoldenCardsToAchievementMap[4]=.EPKA_UNLOCKED_CARD_G_SPEED
    GoldenCardsToAchievementMap[5]=.EPKA_UNLOCKED_CARD_G_FURY
    GoldenCardsToAchievementMap[6]=.EPKA_UNLOCKED_CARD_G_DOUBLEHASTE
    GoldenCardsToAchievementMap[7]=.EPKA_UNLOCKED_CARD_G_DEXTERITY
    GoldenCardsToAchievementMap[8]=.EPKA_UNLOCKED_CARD_G_IRONWILL
    GoldenCardsToAchievementMap[9]=.EPKA_UNLOCKED_CARD_G_RAGE
    GoldenCardsToAchievementMap[10]=.EPKA_UNLOCKED_CARD_G_DOUBLETIMEBONUS
    GoldenCardsToAchievementMap[11]=.EPKA_UNLOCKED_CARD_G_TRIPLEHASTE
    GoldenCardsToAchievementMap[12]=.EPKA_UNLOCKED_CARD_G_CONFUSION
    SilverCardsToAchievementMap[0]=.EPKA_Invalid
    SilverCardsToAchievementMap[1]=.EPKA_UNLOCKED_CARD_S_SOULKEEPER
    SilverCardsToAchievementMap[2]=.EPKA_UNLOCKED_CARD_S_BLESSING
    SilverCardsToAchievementMap[3]=.EPKA_UNLOCKED_CARD_S_REPLENISH
    SilverCardsToAchievementMap[4]=.EPKA_UNLOCKED_CARD_S_DARKSOUL
    SilverCardsToAchievementMap[5]=.EPKA_UNLOCKED_CARD_S_SOULCATCHER
    SilverCardsToAchievementMap[6]=.EPKA_UNLOCKED_CARD_S_FORGIVENESS
    SilverCardsToAchievementMap[7]=.EPKA_UNLOCKED_CARD_S_GREED
    SilverCardsToAchievementMap[8]=.EPKA_UNLOCKED_CARD_S_VITALITY
    SilverCardsToAchievementMap[9]=.EPKA_UNLOCKED_CARD_S_DIVINEINTERVENTION
    SilverCardsToAchievementMap[10]=.EPKA_UNLOCKED_CARD_S_LASTBREATH
    SilverCardsToAchievementMap[11]=.EPKA_UNLOCKED_CARD_S_SOULREDEEMER
    SilverCardsToAchievementMap[12]=.EPKA_UNLOCKED_CARD_S_MERCY
    GlobalStatToAchievementMap[0]=.EPKA_Invalid
    GlobalStatToAchievementMap[1]=.EPKA_Invalid
    GlobalStatToAchievementMap[2]=.EPKA_Invalid
    GlobalStatToAchievementMap[3]=.EPKA_Invalid
    GlobalStatToAchievementMap[4]=.EPKA_Invalid
    GlobalStatToAchievementMap[5]=.EPKA_Invalid
    GlobalStatToAchievementMap[6]=.EPKA_Invalid
    GlobalStatToAchievementMap[7]=.EPKA_Invalid
    GlobalStatToAchievementMap[8]=.EPKA_Invalid
    GlobalStatToAchievementMap[9]=.EPKA_Invalid
    GlobalStatToAchievementMap[10]=.EPKA_Invalid
    GlobalStatToAchievementMap[11]=.EPKA_Invalid
    GlobalStatToAchievementMap[12]=.EPKA_Invalid
    GlobalStatToAchievementMap[13]=.EPKA_Invalid
    GlobalStatToAchievementMap[14]=.EPKA_Invalid
    GlobalStatToAchievementMap[15]=.EPKA_Invalid
    GlobalStatToAchievementMap[16]=.EPKA_Invalid
    GlobalStatToAchievementMap[17]=.EPKA_Invalid
    GlobalStatToAchievementMap[18]=.EPKA_Invalid
    GlobalStatToAchievementMap[19]=.EPKA_Invalid
    GlobalStatToAchievementMap[20]=.EPKA_Invalid
    GlobalStatToAchievementMap[21]=.EPKA_Invalid
    GlobalStatToAchievementMap[22]=.EPKA_Invalid
    GlobalStatToAchievementMap[23]=.EPKA_Invalid
    GlobalStatToAchievementMap[24]=.EPKA_Invalid
    GlobalStatToAchievementMap[25]=.EPKA_Invalid
    GlobalStatToAchievementMap[26]=.EPKA_Invalid
    GlobalStatToAchievementMap[27]=.EPKA_Invalid
    GlobalStatToAchievementMap[28]=.EPKA_Invalid
    GlobalStatToAchievementMap[29]=.EPKA_Invalid
    GlobalStatToAchievementMap[30]=.EPKA_Invalid
    GlobalStatToAchievementMap[31]=.EPKA_Invalid
    GlobalStatToAchievementMap[32]=.EPKA_Invalid
    GlobalStatToAchievementMap[33]=.EPKA_Invalid
    GlobalStatToAchievementMap[34]=.EPKA_Invalid
    GlobalStatToAchievementMap[35]=.EPKA_Invalid
    GlobalStatToAchievementMap[36]=.EPKA_Invalid
    GlobalStatToAchievementMap[37]=.EPKA_Invalid
    GlobalStatToAchievementMap[38]=.EPKA_Invalid
    GlobalStatToAchievementMap[39]=.EPKA_Invalid
    GlobalStatToAchievementMap[40]=.EPKA_Invalid
    GlobalStatToAchievementMap[41]=.EPKA_Invalid
    GlobalStatToAchievementMap[42]=.EPKA_Invalid
    GlobalStatToAchievementMap[43]=.EPKA_Invalid
    GlobalStatToAchievementMap[44]=.EPKA_Invalid
    GlobalStatToAchievementMap[45]=.EPKA_Invalid
    GlobalStatToAchievementMap[46]=.EPKA_Invalid
    GlobalStatToAchievementMap[47]=.EPKA_Invalid
    GlobalStatToAchievementMap[48]=.EPKA_Invalid
    GlobalStatToAchievementMap[49]=.EPKA_Invalid
    GlobalStatToAchievementMap[50]=.EPKA_Invalid
    GlobalStatToAchievementMap[51]=.EPKA_Invalid
    GlobalStatToAchievementMap[52]=.EPKA_Invalid
    GlobalStatToAchievementMap[53]=.EPKA_Invalid
    GlobalStatToAchievementMap[54]=.EPKA_Invalid
    GlobalStatToAchievementMap[55]=.EPKA_Invalid
    GlobalStatToAchievementMap[56]=.EPKA_Invalid
    GlobalStatToAchievementMap[57]=.EPKA_Invalid
    GlobalStatToAchievementMap[58]=.EPKA_Invalid
    GlobalStatToAchievementMap[59]=.EPKA_Invalid
    GlobalStatToAchievementMap[60]=.EPKA_Invalid
    GlobalStatToAchievementMap[61]=.EPKA_Invalid
    GlobalStatToAchievementMap[62]=.EPKA_Invalid
    GlobalStatToAchievementMap[63]=.EPKA_Invalid
    GlobalStatToAchievementMap[64]=.EPKA_Invalid
    GlobalStatToAchievementMap[65]=.EPKA_Invalid
    GlobalStatToAchievementMap[66]=.EPKA_Invalid
    GlobalStatToAchievementMap[67]=.EPKA_Invalid
    GlobalStatToAchievementMap[68]=.EPKA_Invalid
    GlobalStatToAchievementMap[69]=.EPKA_Invalid
    GlobalStatToAchievementMap[70]=.EPKA_Invalid
    GlobalStatToAchievementMap[71]=.EPKA_Invalid
    GlobalStatToAchievementMap[72]=.EPKA_Invalid
    GlobalStatToAchievementMap[73]=.EPKA_Invalid
    GlobalStatToAchievementMap[74]=.EPKA_Invalid
    GlobalStatToAchievementMap[75]=.EPKA_Invalid
    GlobalStatToAchievementMap[76]=.EPKA_Invalid
    GlobalStatToAchievementMap[77]=.EPKA_Invalid
    GlobalStatToAchievementMap[78]=.EPKA_Invalid
    GlobalStatToAchievementMap[79]=.EPKA_Invalid
    GlobalStatToAchievementMap[80]=.EPKA_Invalid
    GlobalStatToAchievementMap[81]=.EPKA_Invalid
    GlobalStatToAchievementMap[82]=.EPKA_Invalid
    GlobalStatToAchievementMap[83]=.EPKA_Invalid
    GlobalStatToAchievementMap[84]=.EPKA_Invalid
    GlobalStatToAchievementMap[85]=.EPKA_Invalid
    GlobalStatToAchievementMap[86]=.EPKA_Invalid
    GlobalStatToAchievementMap[87]=.EPKA_Invalid
    GlobalStatToAchievementMap[88]=.EPKA_Invalid
    GlobalStatToAchievementMap[89]=.EPKA_Invalid
    GlobalStatToAchievementMap[90]=.EPKA_Invalid
    GlobalStatToAchievementMap[91]=.EPKA_Invalid
    GlobalStatToAchievementMap[92]=.EPKA_Invalid
    GlobalStatToAchievementMap[93]=.EPKA_Invalid
    GlobalStatToAchievementMap[94]=.EPKA_Invalid
    GlobalStatToAchievementMap[95]=.EPKA_Invalid
    GlobalStatToAchievementMap[96]=.EPKA_Invalid
    GlobalStatToAchievementMap[97]=.EPKA_Invalid
    GlobalStatToAchievementMap[98]=.EPKA_Invalid
    GlobalStatToAchievementMap[99]=.EPKA_Invalid
    GlobalStatToAchievementMap[100]=.EPKA_Invalid
    GlobalStatToAchievementMap[101]=.EPKA_Invalid
    GlobalStatToAchievementMap[102]=.EPKA_Invalid
    GlobalStatToAchievementMap[103]=.EPKA_Invalid
    GlobalStatToAchievementMap[104]=.EPKA_Invalid
    GlobalStatToAchievementMap[105]=.EPKA_Invalid
    GlobalStatToAchievementMap[106]=.EPKA_Invalid
    GlobalStatToAchievementMap[107]=.EPKA_Invalid
    GlobalStatToAchievementMap[108]=.EPKA_Invalid
    GlobalStatToAchievementMap[109]=.EPKA_Invalid
    GlobalStatToAchievementMap[110]=.EPKA_Invalid
    GlobalStatToAchievementMap[111]=.EPKA_Invalid
    GlobalStatToAchievementMap[112]=.EPKA_Invalid
    GlobalStatToAchievementMap[113]=.EPKA_Invalid
    GlobalStatToAchievementMap[114]=.EPKA_Invalid
    GlobalStatToAchievementMap[115]=.EPKA_FIND_25_SECRET_AREAS
    GlobalStatToAchievementMap[116]=.EPKA_Invalid
    GlobalStatToAchievementMap[117]=.EPKA_COLLECT_500_AMMO_CRATES
    GlobalStatToAchievementMap[118]=.EPKA_DESTROY_300_EXPLO_BARRELS
    GlobalStatToAchievementMap[119]=.EPKA_SPEND_666_SEC_BUNNY_HOP
    GlobalStatToAchievementMap[120]=.EPKA_Invalid
    GlobalStatToAchievementMap[121]=.EPKA_COLLECT_40_ARMORS
    GlobalStatToAchievementMap[122]=.EPKA_KILL_1000_ENEMIES_IN_SV
    GlobalStatToAchievementMap[123]=.EPKA_KILL_500_ENEMIES_WITH_ENV_DAMAGE
    GlobalStatToAchievementMap[124]=.EPKA_KILL_333_ENEMIES_WITH_EXPLOSIVES
    GlobalStatToAchievementMap[125]=.EPKA_SHOOT_50000_TIMES
    GlobalStatToAchievementMap[126]=.EPKA_Invalid
    GlobalStatToAchievementMap[127]=.EPKA_Invalid
    GlobalStatToAchievementMap[128]=.EPKA_Invalid
    GlobalStatToAchievementMap[129]=.EPKA_KILL_256_ENEMIES_WHEN_BUNNYHOPPING
    GlobalStatToAchievementMap[130]=.EPKA_KILL_123_ENEMIES_WITH_COMBO_DMG
    GlobalStatToAchievementMap[131]=.EPKA_Invalid
    GlobalStatToAchievementMap[132]=.EPKA_KILL_666_ENEMIES
    GlobalStatToAchievementMap[133]=.EPKA_KILL_999_ENEMIES
    GlobalStatToAchievementMap[134]=.EPKA_KILL_10000_ENEMIES
    GlobalStatToAchievementMap[135]=.EPKA_COLLECT_667_SOULS
    GlobalStatToAchievementMap[136]=.EPKA_Invalid
    GlobalStatToAchievementMap[137]=.EPKA_COLLECT_2012_GOLD
    GlobalStatToAchievementMap[138]=.EPKA_GIB_100_ENEMIES
    AchievementStatsReadClass=Class'PKStatsReadAchievements'
    AchievementStatsWriteClass=Class'PKStatsWriteAchievements'
}