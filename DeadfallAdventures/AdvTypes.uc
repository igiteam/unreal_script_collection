class AdvTypes extends Object
    abstract
    native;

enum EPKPartyType
{
    EPPT_InviteRequired,            // 0
    EPPT_Public,                    // 1
    EPPT_Local,                     // 2
    EPPT_MAX                        // 3
};

enum EMultiGameMode
{
    EMGM_Deathmatch,                // 0
    EMGM_TeamDeathmatch,            // 1
    EMGM_CTF,                       // 2
    EMGM_Survival,                  // 3
    EMGM_TreasureHunt,              // 4
    EMGM_LastManStanding,           // 5
    EMGM_TeamTreasureHunt,          // 6
    EMGM_NONE,                      // 7
    EMGM_MAX                        // 8
};

enum EAdvItemType
{
    EAIT_Bug,                       // 0
    EAIT_Plank,                     // 1
    EAIT_GasCan,                    // 2
    EAIT_HeartOfAtlantis,           // 3
    EAIT_Key,                       // 4
    EAIT_Ball,                      // 5
    EAIT_Scrap,                     // 6
    EAIT_Tear,                      // 7
    EAIT_Money,                     // 8
    EAIT_Puzzle,                    // 9
    EAIT_Skull,                     // 10
    EAIT_Statue,                    // 11
    EAIT_Bucket,                    // 12
    EAIT_DLCTreasure,               // 13
    EAIT_DLC1,                      // 14
    EAIT_DLC2,                      // 15
    EAIT_DLC3,                      // 16
    EAIT_DLC4,                      // 17
    EAIT_DLC5,                      // 18
    EAIT_DLC6,                      // 19
    EAIT_DLC7,                      // 20
    EAIT_DLC8,                      // 21
    EAIT_DLC9,                      // 22
    EAIT_DLC10,                     // 23
    EAIT_MAX                        // 24
};

enum EAITypes
{
    AIType_GermanSoldierMp38,       // 0
    AIType_GermanSoldierSeb,        // 1
    AIType_GermanSoldierShotgun,    // 2
    AIType_GermanSoldierRifle,      // 3
    AIType_GermanSoldierLeu,        // 4
    AIType_GermanSoldierMG34,       // 5
    AIType_Jungle_GermanSoldierMp38,// 6
    AIType_Jungle_GermanSoldierSeb, // 7
    AIType_Jungle_GermanSoldierShotgun,// 8
    AIType_Arctic_GermanSoldierMp38,// 9
    AIType_Arctic_GermanSoldierSeb, // 10
    AIType_Arctic_GermanSoldierShotgun,// 11
    AIType_Arctic_GermanSoldierRifle,// 12
    AIType_RussianSoldierFed,       // 13
    AIType_RussianSoldierSuo,       // 14
    AIType_RussianSoldierShotgun,   // 15
    AIType_RussianSoldierRifle,     // 16
    AIType_Arctic_RussianSoldierFed,// 17
    AIType_Arctic_RussianSoldierSuo,// 18
    AIType_Arctic_RussianSoldierShotgun,// 19
    AIType_Arctic_RussianSoldierRifle,// 20
    AIType_Mercenary,               // 21
    AIType_MercenaryShotgun,        // 22
    AIType_MercenaryRifle,          // 23
    AIType_NPCJennifer,             // 24
    AIType_NPCJenniferArctic,       // 25
    AIType_NPCHagen,                // 26
    AIType_NPCHagenArctic,          // 27
    AIType_Koshkin,                 // 28
    AIType_KoshkinArctic,           // 29
    AIType_Stein,                   // 30
    AIType_SteinArctic,             // 31
    AIType_Hagen,                   // 32
    AIType_AztecMummy,              // 33
    AIType_AztecMummy_Weak,         // 34
    AIType_EgyptMummy,              // 35
    AIType_EgyptMummy_Weak,         // 36
    AIType_SkinnyMummy,             // 37
    AIType_ZombieMummy,             // 38
    AIType_Sentinel,                // 39
    AIType_Treeter,                 // 40
    AIType_Conquistador,            // 41
    AIType_ConquistadorRifle,       // 42
    AIType_GeneralMummy,            // 43
    AIType_TreeterMP,               // 44
    AIType_SentinelMP,              // 45
    AIType_GeneralMummyMP,          // 46
    AIType_AztecMummyBoss,          // 47
    AIType_AztecMummy_WeakBoss,     // 48
    AIType_SkinnyMummyBoss,         // 49
    AIType_SkinnyConquistador,      // 50
    AIType_AztecMummyMP,            // 51
    AIType_AztecMummy_WeakMP,       // 52
    AIType_EgyptMummyMP,            // 53
    AIType_EgyptMummy_WeakMP,       // 54
    AIType_SkinnyMummyTrap,         // 55
    AIType_DLC1_1,                  // 56
    AIType_DLC1_2,                  // 57
    AIType_DLC1_3,                  // 58
    AIType_DLC1_4,                  // 59
    AIType_DLC1_5,                  // 60
    AIType_DLC1_6,                  // 61
    AIType_DLC1_7,                  // 62
    AIType_DLC1_8,                  // 63
    AIType_DLC1_9,                  // 64
    AIType_DLC2_1,                  // 65
    AIType_DLC2_2,                  // 66
    AIType_DLC2_3,                  // 67
    AIType_DLC2_4,                  // 68
    AIType_DLC2_5,                  // 69
    AIType_DLC2_6,                  // 70
    AIType_DLC2_7,                  // 71
    AIType_DLC2_8,                  // 72
    AIType_DLC2_9,                  // 73
    AIType_DLC3_1,                  // 74
    AIType_DLC3_2,                  // 75
    AIType_DLC3_3,                  // 76
    AIType_DLC3_4,                  // 77
    AIType_DLC3_5,                  // 78
    AIType_DLC3_6,                  // 79
    AIType_DLC3_7,                  // 80
    AIType_DLC3_8,                  // 81
    AIType_DLC3_9,                  // 82
    AIType_DLC4_1,                  // 83
    AIType_DLC4_2,                  // 84
    AIType_DLC4_3,                  // 85
    AIType_DLC4_4,                  // 86
    AIType_DLC4_5,                  // 87
    AIType_DLC4_6,                  // 88
    AIType_DLC4_7,                  // 89
    AIType_DLC4_8,                  // 90
    AIType_DLC4_9,                  // 91
    AIType_DLC5_1,                  // 92
    AIType_DLC5_2,                  // 93
    AIType_DLC5_3,                  // 94
    AIType_DLC5_4,                  // 95
    AIType_DLC5_5,                  // 96
    AIType_DLC5_6,                  // 97
    AIType_DLC5_7,                  // 98
    AIType_DLC5_8,                  // 99
    AIType_DLC5_9,                  // 100
    AIType_DLC6_1,                  // 101
    AIType_DLC6_2,                  // 102
    AIType_DLC6_3,                  // 103
    AIType_DLC6_4,                  // 104
    AIType_DLC6_5,                  // 105
    AIType_DLC6_6,                  // 106
    AIType_DLC6_7,                  // 107
    AIType_DLC6_8,                  // 108
    AIType_DLC6_9,                  // 109
    AIType_DLC7_1,                  // 110
    AIType_DLC7_2,                  // 111
    AIType_DLC7_3,                  // 112
    AIType_DLC7_4,                  // 113
    AIType_DLC7_5,                  // 114
    AIType_DLC7_6,                  // 115
    AIType_DLC7_7,                  // 116
    AIType_DLC7_8,                  // 117
    AIType_DLC7_9,                  // 118
    AIType_DLC8_1,                  // 119
    AIType_DLC8_2,                  // 120
    AIType_DLC8_3,                  // 121
    AIType_DLC8_4,                  // 122
    AIType_DLC8_5,                  // 123
    AIType_DLC8_6,                  // 124
    AIType_DLC8_7,                  // 125
    AIType_DLC8_8,                  // 126
    AIType_DLC8_9,                  // 127
    AIType_DLC9_1,                  // 128
    AIType_DLC9_2,                  // 129
    AIType_DLC9_3,                  // 130
    AIType_DLC9_4,                  // 131
    AIType_DLC9_5,                  // 132
    AIType_DLC9_6,                  // 133
    AIType_DLC9_7,                  // 134
    AIType_DLC9_8,                  // 135
    AIType_DLC9_9,                  // 136
    AIType_DLC10_1,                 // 137
    AIType_DLC10_2,                 // 138
    AIType_DLC10_3,                 // 139
    AIType_DLC10_4,                 // 140
    AIType_DLC10_5,                 // 141
    AIType_DLC10_6,                 // 142
    AIType_DLC10_7,                 // 143
    AIType_DLC10_8,                 // 144
    AIType_DLC10_9,                 // 145
    AIType_MercenarySuo,            // 146
    AIType_MAX                      // 147
};

enum EAdvPawnAction
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
    PA_GolemWeakPhase,              // 51
    PA_GolemWeakPhaseIdle,          // 52
    PA_GolemScream,                 // 53
    PA_MummyScream,                 // 54
    PA_CoverFromLight,              // 55
    PA_CoverFromLightStart,         // 56
    PA_CoverFromLightStrafe,        // 57
    PA_CoverFromLightStrafeLeft,    // 58
    PA_CoverFromLightStrafeRight,   // 59
    PA_Finisher,                    // 60
    PA_FinisherVictim,              // 61
    PA_AttackedByCreature,          // 62
    EAdvPawnAction_MAX              // 63
};

enum EHandsType
{
    EHT_HandsOnly,                  // 0
    EHT_HandsWithDynamite,          // 1
    EHT_MAX                         // 2
};

enum ETreasureType
{
    ETT_Health,                     // 0
    ETT_Flashlight,                 // 1
    ETT_Weapon,                     // 2
    ETT_MAX                         // 3
};

enum EDLCIdentifiers
{
    EDLC_Invalid,                   // 0
    EDLCI_DLC1,                     // 1
    EDLCI_DLC2,                     // 2
    EDLCI_DLC3,                     // 3
    EDLCI_DLC4,                     // 4
    EDLCI_DLC5,                     // 5
    EDLCI_DLC6,                     // 6
    EDLCI_DLC7,                     // 7
    EDLCI_DLC8,                     // 8
    EDLCI_DLC9,                     // 9
    EDLCI_DLC1_PREORDER,            // 10
    EDLCIdentifiers_MAX             // 11
};

enum ELevelID
{
    LID_Invalid,                    // 0
    LID_SaharaIntro,                // 1
    LID_ArabicRoom,                 // 2
    LID_SaharaOutdoor,              // 3
    LID_SaharaIndoor,               // 4
    LID_SanFrancisco,               // 5
    LID_ArcticBase,                 // 6
    LID_ArcticBase2,                // 7
    LID_ArcticTemple,               // 8
    LID_PetraMines,                 // 9
    LID_MayanJungleIntro,           // 10
    LID_MayanJungle,                // 11
    LID_MayanUnderground,           // 12
    LID_MayanCity,                  // 13
    LID_MayanTemple,                // 14
    LID_Xibalba,                    // 15
    LID_SanFrancisco2,              // 16
    LID_ArabicRoom2,                // 17
    LID_DLC1_1,                     // 18
    LID_DLC1_2,                     // 19
    LID_DLC1_3,                     // 20
    LID_DLC1_4,                     // 21
    LID_DLC1_5,                     // 22
    LID_DLC1_6,                     // 23
    LID_DLC1_7,                     // 24
    LID_DLC1_8,                     // 25
    LID_DLC1_9,                     // 26
    LID_DLC1_10,                    // 27
    LID_DLC2_1,                     // 28
    LID_DLC2_2,                     // 29
    LID_DLC2_3,                     // 30
    LID_DLC2_4,                     // 31
    LID_DLC2_5,                     // 32
    LID_DLC2_6,                     // 33
    LID_DLC2_7,                     // 34
    LID_DLC2_8,                     // 35
    LID_DLC2_9,                     // 36
    LID_DLC2_10,                    // 37
    LID_DLC3_1,                     // 38
    LID_DLC3_2,                     // 39
    LID_DLC3_3,                     // 40
    LID_DLC3_4,                     // 41
    LID_DLC3_5,                     // 42
    LID_DLC3_6,                     // 43
    LID_DLC3_7,                     // 44
    LID_DLC3_8,                     // 45
    LID_DLC3_9,                     // 46
    LID_DLC3_10,                    // 47
    LID_DLC4_1,                     // 48
    LID_DLC4_2,                     // 49
    LID_DLC4_3,                     // 50
    LID_DLC4_4,                     // 51
    LID_DLC4_5,                     // 52
    LID_DLC4_6,                     // 53
    LID_DLC4_7,                     // 54
    LID_DLC4_8,                     // 55
    LID_DLC4_9,                     // 56
    LID_DLC4_10,                    // 57
    LID_DLC5_1,                     // 58
    LID_DLC5_2,                     // 59
    LID_DLC5_3,                     // 60
    LID_DLC5_4,                     // 61
    LID_DLC5_5,                     // 62
    LID_DLC5_6,                     // 63
    LID_DLC5_7,                     // 64
    LID_DLC5_8,                     // 65
    LID_DLC5_9,                     // 66
    LID_DLC5_10,                    // 67
    LID_DLC6_1,                     // 68
    LID_DLC6_2,                     // 69
    LID_DLC6_3,                     // 70
    LID_DLC6_4,                     // 71
    LID_DLC6_5,                     // 72
    LID_DLC6_6,                     // 73
    LID_DLC6_7,                     // 74
    LID_DLC6_8,                     // 75
    LID_DLC6_9,                     // 76
    LID_DLC6_10,                    // 77
    LID_DLC7_1,                     // 78
    LID_DLC7_2,                     // 79
    LID_DLC7_3,                     // 80
    LID_DLC7_4,                     // 81
    LID_DLC7_5,                     // 82
    LID_DLC7_6,                     // 83
    LID_DLC7_7,                     // 84
    LID_DLC7_8,                     // 85
    LID_DLC7_9,                     // 86
    LID_DLC7_10,                    // 87
    LID_DLC8_1,                     // 88
    LID_DLC8_2,                     // 89
    LID_DLC8_3,                     // 90
    LID_DLC8_4,                     // 91
    LID_DLC8_5,                     // 92
    LID_DLC8_6,                     // 93
    LID_DLC8_7,                     // 94
    LID_DLC8_8,                     // 95
    LID_DLC8_9,                     // 96
    LID_DLC8_10,                    // 97
    LID_DLC9_1,                     // 98
    LID_DLC9_2,                     // 99
    LID_DLC9_3,                     // 100
    LID_DLC9_4,                     // 101
    LID_DLC9_5,                     // 102
    LID_DLC9_6,                     // 103
    LID_DLC9_7,                     // 104
    LID_DLC9_8,                     // 105
    LID_DLC9_9,                     // 106
    LID_DLC9_10,                    // 107
    LID_DLC10_1,                    // 108
    LID_DLC10_2,                    // 109
    LID_DLC10_3,                    // 110
    LID_DLC10_4,                    // 111
    LID_DLC10_5,                    // 112
    LID_DLC10_6,                    // 113
    LID_DLC10_7,                    // 114
    LID_DLC10_8,                    // 115
    LID_DLC10_9,                    // 116
    LID_DLC10_10,                   // 117
    LID_MAX                         // 118
};

enum EInventoryItem
{
    II_None,                        // 0
    II_Torch,                       // 1
    II_Notepad,                     // 2
    II_NotepadPrev,                 // 3
    II_NotepadNext,                 // 4
    II_Weapon,                      // 5
    II_Compass,                     // 6
    II_MAX                          // 7
};

struct native LevelStatistics
{
    var int GameplayTime;
    var EvilTypesNative.EDifficultyLevel Difficulty;
    var int MonstersKilled;
    var int GoldFound;
    var int BonusItems;
    var int AmmoFound;
    var int ObjectsDestroyed;
    var int SecretsFound;
    var int TotalMonsters;
    var int TotalAmmo;
    var int TotalObjects;
    var int TotalSecrets;

    structdefaultproperties
    {
        GameplayTime=0
        Difficulty=EDifficultyLevel.DL_Low
        MonstersKilled=0
        GoldFound=0
        BonusItems=0
        AmmoFound=0
        ObjectsDestroyed=0
        SecretsFound=0
        TotalMonsters=0
        TotalAmmo=0
        TotalObjects=0
        TotalSecrets=0
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

struct SteamServerData
{
    var string SteamServerId;
    var string Label;
    var string ServerName;
    var string Players;
    var string GameType;
    var string MapName;
    var string FriendlyMapName;
    var int Ping;
    var bool bUsePassword;
    var OnlineGameSearchResult GameToJoin;

    structdefaultproperties
    {
        SteamServerId=""
        Label=""
        ServerName=""
        Players=""
        GameType=""
        MapName=""
        FriendlyMapName=""
        Ping=0
        bUsePassword=false
        GameToJoin=(GameSettings=none)
    }
};

struct native InventoryElement
{
    var int AmmoCount;
    var string Inventory;

    structdefaultproperties
    {
        AmmoCount=0
        Inventory=""
    }
};
