class R6EngineEnums extends Object
    native;

const MAX_NUM_BULLET_IMPACT_SOUNDS = 7;
const AI_TEMPLATE_SOUND_SKILL = -9999;

enum eCONTEXT_RELEVANTOBSTACLE
{
    eCONTEXT_ALL,                   // 0
    eCONTEXT_NAVIGATION,            // 1
    eCONTEXT_TAKECOVER,             // 2
    eCONTEXT_MAX                    // 3
};

enum EWeapon
{
    EWeapon_None,                   // 0
    EWeapon_PistolMK23,             // 1
    EWeapon_PistolUSP40,            // 2
    EWeapon_Pistol92FS,             // 3
    EWeapon_PistolGlock18,          // 4
    EWeapon_PistolDesertEagle,      // 5
    EWeapon_PistolRagingBull,       // 6
    EWeapon_SubMP5N,                // 7
    EWeapon_SubMP7A1,               // 8
    EWeapon_SubUMP45,               // 9
    EWeapon_SubP90,                 // 10
    EWeapon_SubMP9,                 // 11
    EWeapon_SubMAC11,               // 12
    EWeapon_AssaultSCARHCQC,        // 13
    EWeapon_AssaultM8,              // 14
    EWeapon_AssaultAUGA3,           // 15
    EWeapon_AssaultG3KA4,           // 16
    EWeapon_Assault552Commando,     // 17
    EWeapon_AssaultG36C,            // 18
    EWeapon_AssaultMTAR21,          // 19
    EWeapon_AssaultFamas,           // 20
    EWeapon_AssaultAK47,            // 21
    EWeapon_LMGMK46,                // 22
    EWeapon_LMG21E,                 // 23
    EWeapon_LMGM249SPW,             // 24
    EWeapon_LMGMG36,                // 25
    EWeapon_FixedLMGM249,           // 26
    EWeapon_ShotgunM3,              // 27
    EWeapon_ShotgunSpas12,          // 28
    EWeapon_Shotgun870MCS,          // 29
    EWeapon_ShotgunXM26LSS,         // 30
    EWeapon_SniperPSG1,             // 31
    EWeapon_SniperM40A1,            // 32
    EWeapon_SniperSV98,             // 33
    EWeapon_SniperScoutTactical,    // 34
    EWeapon_Deprecated,             // 35
    EWeapon_Shield,                 // 36
    EWeapon_MAX                     // 37
};

enum ETerroArmorLevel
{
    TERROARMOR_NONE,                // 0
    TERROARMOR_LIGHT,               // 1
    TERROARMOR_MEDIUM,              // 2
    TERROARMOR_HEAVY,               // 3
    TERROARMOR_MAX                  // 4
};

enum EEncumbranceType
{
    ENCUMBRANCE_NONE,               // 0
    ENCUMBRANCE_LIGHT,              // 1
    ENCUMBRANCE_MEDIUM,             // 2
    ENCUMBRANCE_HEAVY,              // 3
    ENCUMBRANCE_MAX                 // 4
};

enum EArmorPieceCategory
{
    ARMORCATEGORY_LIGHT,            // 0
    ARMORCATEGORY_MEDIUM,           // 1
    ARMORCATEGORY_HEAVY,            // 2
    ARMORCATEGORY_MAX               // 3
};

enum EArmorPieceType
{
    ARMORTYPE_CHEST,                // 0
    ARMORTYPE_LEGS,                 // 1
    ARMORTYPE_ARMS,                 // 2
    ARMORTYPE_SHOULDERS,            // 3
    ARMORTYPE_MAX                   // 4
};

enum EHIKPassIndex
{
    EHIKPreAttachmentPass,          // 0
    EHIKPostAttachmentPass,         // 1
    EHIKPassIndex_MAX               // 2
};

enum EAnimNotify
{
    ANIMNOTIFY_NONE,                // 0
    ANIMNOTIFY_GRABROPE_SPINE,      // 1
    ANIMNOTIFY_DROPROPE_SPINE,      // 2
    ANIMNOTIFY_DROPROPE_LEFTHAND,   // 3
    ANIMNOTIFY_ADJUST_HANDS_IK,     // 4
    ANIMNOTIFY_DROPROPE_RIGHTHAND,  // 5
    ANIMNOTIFY_EJECT_BULLET,        // 6
    ANIMNOTIFY_DROP_MAGAZINE,       // 7
    ANIMNOTIFY_GRAB_MAGAZINE,       // 8
    ANIMNOTIFY_TOGGLE_WEAPON_ATTACH_HAND,// 9
    ANIMNOTIFY_REACTIVATE_WEAPON_IK,// 10
    ANIMNOTIFY_RELEASE_MAGAZINE,    // 11
    ANIMNOTIFY_ENABLEROOTROTATION,  // 12
    ANIMNOTIFY_ATTACH_SUPPRESSOR_TO_HAND,// 13
    ANIMNOTIFY_DETACH_SUPPRESSOR,   // 14
    ANIMNOTIFY_GRABWEAPON,          // 15
    ANIMNOTIFY_DROPWEAPON,          // 16
    ANIMNOTIFY_ATTACH_SUPPRESSOR_TO_CHARACTER,// 17
    ANIMNOTIFY_GRABROPE_LEFTHAND,   // 18
    ANIMNOTIFY_GRABROPE_RIGHTHAND,  // 19
    ANIMNOTIFY_GRABROPE_BOTHHANDS,  // 20
    ANIMNOTIFY_DROPROPE,            // 21
    ANIMNOTIFY_DETACH_MAGAZINE,     // 22
    ANIMNOTIFY_BLENDOUT_RAGDOLL_DRIVE,// 23
    ANIMNOTIFY_GADGET_ATTACH,       // 24
    ANIMNOTIFY_OK_TO_FIRE,          // 25
    ANIMNOTIFY_GADGET_DETTACH,      // 26
    ANIMNOTIFY_UNUSED7,             // 27
    ANIMNOTIFY_START_RAGDOLL,       // 28
    ANIMNOTIFY_RECORD_RAGDOLL,      // 29
    ANIMNOTIFY_DISABLE_HAND_IK,     // 30
    ANIMNOTIFY_ENABLE_HAND_IK,      // 31
    ANIMNOTIFY_UNUSED2,             // 32
    ANIMNOTIFY_UNUSED3,             // 33
    ANIMNOTIFY_MAX                  // 34
};

enum EGameType
{
    GAMETYPE_NONE,                  // 0
    GAMETYPE_ALL,                   // 1
    GAMETYPE_SOLO,                  // 2
    GAMETYPE_COOP,                  // 3
    GAMETYPE_ADVERSARIAL,           // 4
    GAMETYPE_MAX                    // 5
};

enum EGameMode
{
    GAMEMODE_NONE,                  // 0
    GAMEMODE_ATTACKANDDEFEND,       // 1
    GAMEMODE_DEATHMATCH,            // 2
    GAMEMODE_SHARPSHOOTER,          // 3
    GAMEMODE_TEAMDEATHMATCH,        // 4
    GAMEMODE_TEAMSHARPSHOOTER,      // 5
    GAMEMODE_RETRIEVAL,             // 6
    GAMEMODE_STORY,                 // 7
    GAMEMODE_TERROHUNT,             // 8
    GAMEMODE_GYM,                   // 9
    GAMEMODE_ALL,                   // 10
    GAMEMODE_MENU_OUTFITTING,       // 11
    GAMEMODE_MENU_CHARACTERCREATION,// 12
    GAMEMODE_BASEMP,                // 13
    GAMEMODE_MISSION,               // 14
    GAMEMODE_CONQUEST,              // 15
    GAMEMODE_ASSASSINATION,         // 16
    GAMEMODE_MENU_MAIN,             // 17
    GAMEMODE_OBJECTIVE,             // 18
    GAMEMODE_LOCATION,              // 19
    GAMEMODE_MAX                    // 20
};

enum EGameTypeMP
{
    GAMETYPEMP_RANKEDMATCH,         // 0
    GAMETYPEMP_PLAYERMATCH,         // 1
    GAMETYPEMP_MAX                  // 2
};

enum ELanguage
{
    LANGUAGE_ENGLISH,               // 0
    LANGUAGE_FRENCH,                // 1
    LANGUAGE_GERMAN,                // 2
    LANGUAGE_ITALIAN,               // 3
    LANGUAGE_SPANISH,               // 4
    LANGUAGE_JAPANESE,              // 5
    LANGUAGE_RUSSIAN,               // 6
    LANGUAGE_POLISH,                // 7
    LANGUAGE_CHINESE,               // 8
    LANGUAGE_MAX                    // 9
};

enum EAllowVoiceMode
{
    ALLOWVOICE_EVERYONE,            // 0
    ALLOWVOICE_ALIVEONLY,           // 1
    ALLOWVOICE_NONE,                // 2
    ALLOWVOICE_MAX                  // 3
};

enum EServerOption
{
    SERVEROPTION_DEDICATEDSERVER,   // 0
    SERVEROPTION_HOSTNAME,          // 1
    SERVEROPTION_GAMEMODE,          // 2
    SERVEROPTION_GAMETYPE,          // 3
    SERVEROPTION_MISSION,           // 4
    SERVEROPTION_GAMEPASSWORD,      // 5
    SERVEROPTION_AUTOKICKTEAMKILLERS,// 6
    SERVEROPTION_BALANCETEAM,       // 7
    SERVEROPTION_FRIENDLYFIRE,      // 8
    SERVEROPTION_TIMEBETWEENROUND,  // 9
    SERVEROPTION_ROUNDCOUNT,        // 10
    SERVEROPTION_ROUNDDURATION,     // 11
    SERVEROPTION_MAXPLAYERS,        // 12
    SERVEROPTION_PRIVATESLOTS,      // 13
    SERVEROPTION_PRIVATEOPENSLOTS,  // 14
    SERVEROPTION_PUBLICSLOTS,       // 15
    SERVEROPTION_PUBLICOPENSLOTS,   // 16
    SERVEROPTION_NBPLAYERS,         // 17
    SERVEROPTION_ALLOWRESPAWNS,     // 18
    SERVEROPTION_TEAMRESPAWN,       // 19
    SERVEROPTION_LANGUAGE,          // 20
    SERVEROPTION_GAMEPOINTLIMIT,    // 21
    SERVEROPTION_PRIVATESERVER,     // 22
    SERVEROPTION_LOCKTEAMS,         // 23
    SERVEROPTION_PUNISHTEAMKILLERS, // 24
    SERVEROPTION_BRIEFINGTIMER,     // 25
    SERVEROPTION_TIMEREMAINING,     // 26
    SERVEROPTION_ALLOWJOININPROGRESS,// 27
    SERVEROPTION_DIFFICULTY,        // 28
    SERVEROPTION_HOSTILEDENSITY,    // 29
    SERVEROPTION_COOP_ROUNDDURATION,// 30
    SERVEROPTION_KITRESTRICTIONS,   // 31
    SERVEROPTION_CONQUESTPOINTLIMIT,// 32
    SERVEROPTION_MAX                // 33
};

enum EMatchListOptions
{
    MATCHLIST_PRIVATEOPENSLOTS,     // 0
    MATCHLIST_PUBLICOPENSLOTS,      // 1
    MATCHLIST_GAMEMODE,             // 2
    MATCHLIST_GAMETYPE,             // 3
    MATCHLIST_MAXPLAYERS,           // 4
    MATCHLIST_NBPLAYERS,            // 5
    MATCHLIST_HOSTNAME,             // 6
    MATCHLIST_MISSION,              // 7
    MATCHLIST_GAMEPASSWORD,         // 8
    MATCHLIST_DEDICATEDSERVER,      // 9
    MATCHLIST_LANGUAGE,             // 10
    MATCHLIST_TIMEREMAINING,        // 11
    MATCHLIST_LOCKEDTEAM,           // 12
    MATCHLIST_ALLOWRESPAWNS,        // 13
    MATCHLIST_MAX                   // 14
};

enum EDedicatedServer
{
    DEDICATEDSERVER_NO,             // 0
    DEDICATEDSERVER_YES,            // 1
    DEDICATEDSERVER_MAX             // 2
};

enum EPunkBuster
{
    PUNKBUSTER_NO,                  // 0
    PUNKBUSTER_YES,                 // 1
    PUNKBUSTER_MAX                  // 2
};

enum EMatchFilter
{
    MATCHFILTER_GAMEMODE,           // 0
    MATCHFILTER_GAMETYPE,           // 1
    MATCHFILTER_SERVERTYPE,         // 2
    MATCHFILTER_MINPLAYERS,         // 3
    MATCHFILTER_MAXPLAYERS,         // 4
    MATCHFILTER_LANGUAGE,           // 5
    MATCHFILTER_PUNKBUSTER,         // 6
    MATCHFILTER_MISSION,            // 7
    MATCHFILTER_MAX                 // 8
};

enum EGameDifficulty
{
    GAMEDIFFICULTY_NONE,            // 0
    GAMEDIFFICULTY_NORMAL,          // 1
    GAMEDIFFICULTY_VETERAN,         // 2
    GAMEDIFFICULTY_ELITE,           // 3
    GAMEDIFFICULTY_MAX              // 4
};

enum EGameStatus
{
    GAMESTATUS_NONE,                // 0
    GAMESTATUS_MATCHPENDING,        // 1
    GAMESTATUS_MATCHBETWEENROUND,   // 2
    GAMESTATUS_SYNCHRONIZING,       // 3
    GAMESTATUS_MATCHSTARTING,       // 4
    GAMESTATUS_MATCHINPROGRESS,     // 5
    GAMESTATUS_MATCHROUNDEND,       // 6
    GAMESTATUS_MATCHEND,            // 7
    GAMESTATUS_MAX                  // 8
};

enum EGameHostileDensity
{
    GAMEHOSTILEDENSITY_NONE,        // 0
    GAMEHOSTILEDENSITY_LOW,         // 1
    GAMEHOSTILEDENSITY_MEDIUM,      // 2
    GAMEHOSTILEDENSITY_HIGH,        // 3
    GAMEHOSTILEDENSITY_MAX          // 4
};

enum EAIPeekCoverStatus
{
    AIPEEKCOVERSTATUS_NORMAL_TOLEFT,// 0
    AIPEEKCOVERSTATUS_NORMAL_TORIGHT,// 1
    AIPEEKCOVERSTATUS_NORMAL_TOUPLEFT,// 2
    AIPEEKCOVERSTATUS_NORMAL_TOUPRIGHT,// 3
    AIPEEKCOVERSTATUS_LEFT_TONORMAL,// 4
    AIPEEKCOVERSTATUS_RIGHT_TONORMAL,// 5
    AIPEEKCOVERSTATUS_UPLEFT_TONORMAL,// 6
    AIPEEKCOVERSTATUS_UPRIGHT_TONORMAL,// 7
    AIPEEKCOVERSTATUS_QUICK_LEFT,   // 8
    AIPEEKCOVERSTATUS_QUICK_RIGHT,  // 9
    AIPEEKCOVERSTATUS_QUICK_UPLEFT, // 10
    AIPEEKCOVERSTATUS_QUICK_UPRIGHT,// 11
    AIPEEKCOVERSTATUS_NORMAL,       // 12
    AIPEEKCOVERSTATUS_LEFT,         // 13
    AIPEEKCOVERSTATUS_RIGHT,        // 14
    AIPEEKCOVERSTATUS_UPLEFT,       // 15
    AIPEEKCOVERSTATUS_UPRIGHT,      // 16
    AIPEEKCOVERSTATUS_MAX           // 17
};

enum ESplitScreenType
{
    ESplit_None,                    // 0
    ESplit_Local,                   // 1
    ESplit_XboxLive,                // 2
    ESplit_SystemLink,              // 3
    ESplit_MAX                      // 4
};

enum EPlayerCharacterType
{
    ESPCT_LOGAN,                    // 0
    ESPCT_MICHEAL,                  // 1
    ESPCT_JUNG,                     // 2
    ESPCT_GABRIEL,                  // 3
    ESPCT_KAN,                      // 4
    ESPCT_PEC_CHARACTER,            // 5
    ESPCT_SWATLIGHT,                // 6
    ESPCT_SWATMEDIUM,               // 7
    ESPCT_SWATHEAVY,                // 8
    ESPCT_GUELIGHT,                 // 9
    ESPCT_GUEMED,                   // 10
    ESPCT_GUEHEAVY,                 // 11
    ESPCT_MERCLIGHT,                // 12
    ESPCT_MERCMED,                  // 13
    ESPCT_MERCHEAVY,                // 14
    ESPCT_MILILIGHT,                // 15
    ESPCT_MILIMED,                  // 16
    ESPCT_MILIHEAVY,                // 17
    ESPCT_MAX                       // 18
};

enum EGameTerroHuntTeamType
{
    EGTH_TEAMTYPE_AI_TEAM,          // 0
    EGTH_TEAMTYPE_LONE_WOLF,        // 1
    EGTH_TEAMTYPE_MAX               // 2
};

enum ETargetMenuId
{
    eTM_PressStart,                 // 0
    eTM_MainMenu,                   // 1
    eTM_TerroHuntMenu,              // 2
    eTM_OnlineMain,                 // 3
    eTM_SplitscreenLocal,           // 4
    eTM_MAX                         // 5
};

enum ECameraConfiguration
{
    ECAMCONFIG_OTS,                 // 0
    ECAMCONFIG_FP,                  // 1
    ECAMCONFIG_FP_ON_FIRING,        // 2
    ECAMCONFIG_BUTTON,              // 3
    ECAMCONFIG_MAX                  // 4
};

enum EZoomType
{
    EZoom_None,                     // 0
    EZoom_IronSights,               // 1
    EZoom_ReflexSights,             // 2
    EZoom_3X,                       // 3
    EZoom_6X,                       // 4
    EZoom_12X,                      // 5
    EZoom_TakeCover,                // 6
    EZoom_TakeCover12X,             // 7
    EZoom_MAX                       // 8
};

enum EMagmaScopeType
{
    EMagmaScope_None,               // 0
    EMagmaScope_Riffle,             // 1
    EMagmaScope_Acog,               // 2
    EMagmaScope_Sniper,             // 3
    EMagmaScope_MAX                 // 4
};

enum EOdorType
{
    EOdor_Gas,                      // 0
    EOdor_Fire,                     // 1
    EOdor_Smoke,                    // 2
    EOdor_Flower,                   // 3
    EOdor_Death,                    // 4
    EOdor_Decay,                    // 5
    EOdor_MAX                       // 6
};

enum EButtonsKey
{
    eBK_A,                          // 0
    eBK_B,                          // 1
    eBK_X,                          // 2
    eBK_Y,                          // 3
    eBK_Back,                       // 4
    eBK_Start,                      // 5
    eBK_LT,                         // 6
    eBK_RT,                         // 7
    eBK_LB,                         // 8
    eBK_RB,                         // 9
    eBK_MAX                         // 10
};

enum EThumbstickKey
{
    eTK_LeftX,                      // 0
    eTK_LeftY,                      // 1
    eTK_LeftPush,                   // 2
    eTK_RightX,                     // 3
    eTK_RightY,                     // 4
    eTK_RightPush,                  // 5
    eTK_MAX                         // 6
};

enum EButtonsConfig
{
    eBUTTONS_DEFAULT,               // 0
    eBUTTONS_ALTERNATE1,            // 1
    eBUTTONS_ALTERNATE2,            // 2
    eBUTTONS_MAX                    // 3
};

enum EThumbstickConfig
{
    eTHUMBSTICK_DEFAULT,            // 0
    eTHUMBSTICK_SOUTHPAW,           // 1
    eTHUMBSTICK_LEGACY,             // 2
    eTHUMBSTICK_LEGACYSOUTHPAW,     // 3
    eTHUMBSTICK_MAX                 // 4
};

enum EButtonsAction
{
    eBUTTONSACTION_VISION_MODE,     // 0
    eBUTTONSACTION_TAKE_COVER,      // 1
    eBUTTONSACTION_ROE,             // 2
    eBUTTONSACTION_FIRE,            // 3
    eBUTTONSACTION_TAG_MAP,         // 4
    eBUTTONSACTION_WEAPON_SWITCH,   // 5
    eBUTTONSACTION_RELOAD,          // 6
    eBUTTONSACTION_USE_GADGET,      // 7
    eBUTTONSACTION_MOVETO,          // 8
    eBUTTONSACTION_PAUSE,           // 9
    eBUTTONSACTION_MAX              // 10
};

enum EThumbstickAction
{
    eTHUMBSACTION_STRAFE,           // 0
    eTHUMBSACTION_MOVE,             // 1
    eTHUMBSACTION_LOOK_LEFTRIGHT,   // 2
    eTHUMBSACTION_LOOK_UPDOWN,      // 3
    eTHUMBSACTION_ZOOM,             // 4
    eTHUMBSACTION_CROUCH,           // 5
    eTHUMBSACTION_MAX               // 6
};

enum EPlayerID
{
    EPlayerID_Player1,              // 0
    EPlayerID_Player2,              // 1
    EPlayerID_MAX                   // 2
};

enum EControllerID
{
    EControllerID_0,                // 0
    EControllerID_1,                // 1
    EControllerID_2,                // 2
    EControllerID_3,                // 3
    EControllerID_MAX               // 4
};

enum EMissionSortType
{
    ESortType_None,                 // 0
    ESortType_MissionOrderId,       // 1
    ESortType_MissionName,          // 2
    ESortType_MAX                   // 3
};

enum EExplosionEffectType
{
    EEffect_CameraShake,            // 0
    EEffect_Damage,                 // 1
    EEffect_Deafening,              // 2
    EEffect_Dizziness,              // 3
    EEffect_VisionBlur,             // 4
    EEffect_TearGas,                // 5
    EEffect_Stun,                   // 6
    EEffect_Smoke,                  // 7
    EEffect_Impulse,                // 8
    EEffect_Gas,                    // 9
    EEffect_PointLight,             // 10
    EEffect_MaterialGlow,           // 11
    EEffect_Flash,                  // 12
    EEffect_Fire,                   // 13
    EEffect_MAX                     // 14
};

enum EEffectImmuneType
{
    EImmune_None,                   // 0
    EImmune_NotLooking,             // 1
    EImmune_HasGasMask,             // 2
    EImmune_IsPlayer,               // 3
    EImmune_IsCombatant,            // 4
    EImmune_MAX                     // 5
};

enum EVisionMode
{
    VISION_NORMAL,                  // 0
    VISION_NIGHT,                   // 1
    VISION_HEAT,                    // 2
    VISION_GASMASK,                 // 3
    VISION_MAX                      // 4
};

enum EHealthStates
{
    HEALTHSTATE_FullHealth,         // 0
    HEALTHSTATE_Wounded,            // 1
    HEALTHSTATE_Critical,           // 2
    HEALTHSTATE_Incapacitated,      // 3
    HEALTHSTATE_Dead,               // 4
    HEALTHSTATE_Invulnerable,       // 5
    HEALTHSTATE_MAX                 // 6
};

enum EVisionModeAction
{
    EVisionModeAction_None,         // 0
    EVisionModeAction_Enable,       // 1
    EVisionModeAction_Disable,      // 2
    EVisionModeAction_MAX           // 3
};

enum EWeaponOption
{
    EWeaponOption_None,             // 0
    EWeaponOption_FireMode,         // 1
    EWeaponOption_Underbarrel,      // 2
    EWeaponOption_Silencer,         // 3
    EWeaponOption_MAX               // 4
};

enum ER6WeaponOptionDesc
{
    ER6WeaponOptionDesc_None,       // 0
    ER6WeaponOptionDesc_RoF,        // 1
    ER6WeaponOptionDesc_Laser,      // 2
    ER6WeaponOptionDesc_Silencer,   // 3
    ER6WeaponOptionDesc_Flashlight, // 4
    ER6WeaponOptionDesc_MAX         // 5
};

enum ER6InteractDesc
{
    ER6InteractDesc_None,           // 0
    ER6InteractDesc_InteractiveDevice,// 1
    ER6InteractDesc_CloseDoor,      // 2
    ER6InteractDesc_OpenDoor,       // 3
    ER6InteractDesc_ScopeDoor,      // 4
    ER6InteractDesc_LeaveSnakeCam,  // 5
    ER6InteractDesc_UnlockDoor,     // 6
    ER6InteractDesc_OpenWindow,     // 7
    ER6InteractDesc_ClimbWindow,    // 8
    ER6InteractDesc_BreachWindow,   // 9
    ER6InteractDesc_RappelToFastRope,// 10
    ER6InteractDesc_UseTurret,      // 11
    ER6InteractDesc_LeaveTurret,    // 12
    ER6InteractDesc_EnterHelicopter,// 13
    ER6InteractDesc_LeaveHelicopter,// 14
    ER6InteractDesc_UseFastRope,    // 15
    ER6InteractDesc_RevivePawn,     // 16
    ER6InteractDesc_EscortPawn,     // 17
    ER6InteractDesc_HoldPawn,       // 18
    ER6InteractDesc_ClimbLedge,     // 19
    ER6InteractDesc_PickUp,         // 20
    ER6InteractDesc_UseLadder,      // 21
    ER6InteractDesc_DisarmBomb,     // 22
    ER6InteractDesc_UseSwitch,      // 23
    ER6InteractDesc_Jump,           // 24
    ER6InteractDesc_UseRappel,      // 25
    ER6InteractDesc_Outfitting,     // 26
    ER6InteractDesc_Slide,          // 27
    ER6InteractDesc_HackComputer,   // 28
    ER6InteractDesc_SetExplosives,  // 29
    ER6InteractDesc_SOL,            // 30
    ER6InteractDesc_MAX             // 31
};

enum EOrderId
{
    ORDERID_NONE,                   // 0
    ORDERID_MOVE_TO,                // 1
    ORDERID_CLEAR,                  // 2
    ORDERID_BREACH_DOOR,            // 3
    ORDERID_STACK_DOOR,             // 4
    ORDERID_OPEN,                   // 5
    ORDERID_OPEN_CLEAR,             // 6
    ORDERID_OPEN_FRAG_CLEAR,        // 7
    ORDERID_OPEN_FLASH_CLEAR,       // 8
    ORDERID_OPEN_SMOKE_CLEAR,       // 9
    ORDERID_OPEN_GAS_CLEAR,         // 10
    ORDERID_REGROUP,                // 11
    ORDERID_HOLD,                   // 12
    ORDERID_FRAG,                   // 13
    ORDERID_FLASH,                  // 14
    ORDERID_BREACH_DETONATEBREACH_CLEAR,// 15
    ORDERID_SOL_CANCEL,             // 16
    ORDERID_SOL_GO,                 // 17
    ORDERID_PICKLOCK_OPEN_CLEAR,    // 18
    ORDERID_ENTER,                  // 19
    ORDERID_ADVANCE,                // 20
    ORDERID_SMOKE,                  // 21
    ORDERID_STACK_WINDOW,           // 22
    ORDERID_WINDOW_ENTER_CLEAR,     // 23
    ORDERID_WINDOW_FLASH_CLEAR,     // 24
    ORDERID_WINDOW_FRAG_CLEAR,      // 25
    ORDERID_WINDOW_SMOKE_CLEAR,     // 26
    ORDERID_WINDOW_GAS_CLEAR,       // 27
    ORDERID_GAS,                    // 28
    ORDERID_ENTER_SMOKE_CLEAR,      // 29
    ORDERID_ENTER_FLASH_CLEAR,      // 30
    ORDERID_ENTER_FRAG_CLEAR,       // 31
    ORDERID_ENTER_GAS_CLEAR,        // 32
    ORDERID_INTERACT_WITH,          // 33
    ORDERID_USE,                    // 34
    ORDERID_ROPE_BREACH,            // 35
    ORDERID_ROPE_UP,                // 36
    ORDERID_ROPE_DOWN,              // 37
    ORDERID_REVIVE,                 // 38
    ORDERID_INTERACT_WITH_FAILED,   // 39
    COMMANDS_BELOW_DO_NOT_WORK,     // 40
    ORDERID_HACK,                   // 41
    EOrderId_MAX                    // 42
};

enum EOrderSignalId
{
    ORDERSIGNALID_NONE,             // 0
    ORDERSIGNALID_HOLD,             // 1
    ORDERSIGNALID_MOVE,             // 2
    ORDERSIGNALID_REGROUP,          // 3
    ORDERSIGNALID_MAX               // 4
};

enum ECommunicationTeamMessageType
{
    TEAMMESSAGE_NONE,               // 0
    TEAMMESSAGE_REGROUP,            // 1
    TEAMMESSAGE_MOVETO,             // 2
    TEAMMESSAGE_HOLD,               // 3
    TEAMMESSAGE_FOLLOWME,           // 4
    TEAMMESSAGE_MOVECAUTIOUS,       // 5
    TEAMMESSAGE_GO,                 // 6
    TEAMMESSAGE_OPENDOOR,           // 7
    TEAMMESSAGE_BREACHCLEAR,        // 8
    TEAMMESSAGE_BREACHBANGCLEAR,    // 9
    TEAMMESSAGE_BREACHFRAGCLEAR,    // 10
    TEAMMESSAGE_CLEAR,              // 11
    TEAMMESSAGE_BANGCLEAR,          // 12
    TEAMMESSAGE_FRAGCLEAR,          // 13
    TEAMMESSAGE_SECUREHOSTAGE,      // 14
    TEAMMESSAGE_SECURETERRORIST,    // 15
    TEAMMESSAGE_FORMATION,          // 16
    TEAMMESSAGE_INTERACT,           // 17
    TEAMMESSAGE_BREACHDOOR,         // 18
    TEAMMESSAGE_FRAGDOOR,           // 19
    TEAMMESSAGE_BANGDOOR,           // 20
    TEAMMESSAGE_SMOKEDOOR,          // 21
    TEAMMESSAGE_FRAGCHOKE,          // 22
    TEAMMESSAGE_BANGCHOKE,          // 23
    TEAMMESSAGE_SMOKECHOKE,         // 24
    TEAMMESSAGE_DETONATECHARGE,     // 25
    TEAMMESSAGE_SCOPEDOOR,          // 26
    TEAMMESSAGE_STOPSCOPE,          // 27
    TEAMMESSAGE_ADJUSTSCOPE,        // 28
    TEAMMESSAGE_ZOOM_SCOPE,         // 29
    TEAMMESSAGE_DOORSTACK,          // 30
    TEAMMESSAGE_CHOKESTACK,         // 31
    TEAMMESSAGE_ENTER,              // 32
    TEAMMESSAGE_STACK,              // 33
    TEAMMESSAGE_FRAG,               // 34
    TEAMMESSAGE_FLASH,              // 35
    TEAMMESSAGE_SMOKE,              // 36
    TEAMMESSAGE_PICKLOCK,           // 37
    TEAMMESSAGE_HACK,               // 38
    TEAMMESSAGE_OPEN,               // 39
    TEAMMESSAGE_BREACH,             // 40
    TEAMMESSAGE_DETONATEBREACH,     // 41
    TEAMMESSAGE_SCOPE,              // 42
    TEAMMESSAGE_SCOPESTOP,          // 43
    TEAMMESSAGE_SCOPELEFT,          // 44
    TEAMMESSAGE_SCOPERIGHT,         // 45
    TEAMMESSAGE_SCOPEZOOM,          // 46
    TEAMMESSAGE_REQUEST,            // 47
    TEAMMESSAGE_RESPONSE,           // 48
    TEAMMESSAGE_STATEMENT,          // 49
    TEAMMESSAGE_ORDER,              // 50
    TEAMMESSAGE_ENEMYSPOTTED,       // 51
    TEAMMESSAGE_HEARDSOMETHING,     // 52
    TEAMMESSAGE_MANDOWN,            // 53
    TEAMMESSAGE_ENEMYELIMINATED,    // 54
    TEAMMESSAGE_AFFIRMATIVE,        // 55
    TEAMMESSAGE_NEGATIVE,           // 56
    TEAMMESSAGE_ADVANCE,            // 57
    TEAMMESSAGE_LOST,               // 58
    TEAMMESSAGE__PROCESSED_,        // 59
    TEAMMESSAGE_UP,                 // 60
    TEAMMESSAGE_DOWN,               // 61
    TEAMMESSAGE_GAS,                // 62
    TEAMMESSAGE_REVIVE,             // 63
    TEAMMESSAGE_MOVETOSOL,          // 64
    TEAMMESSAGE_MAX                 // 65
};

enum EGrenadeType
{
    GRENADETYPE_None,               // 0
    GRENADETYPE_Frag,               // 1
    GRENADETYPE_Flashbang,          // 2
    GRENADETYPE_Smoke,              // 3
    GRENADETYPE_Molotov,            // 4
    GRENADETYPE_UNUSED1,            // 5
    GRENADETYPE_Incendiary,         // 6
    GRENADETYPE_TearGas,            // 7
    GRENADETYPE_Deterrent,          // 8
    GRENADETYPE_MAX                 // 9
};

enum EExplosiveType
{
    EXPLOSIVETYPE_None,             // 0
    EXPLOSIVETYPE_Breach,           // 1
    EXPLOSIVETYPE_Demolition,       // 2
    EXPLOSIVETYPE_UNUSED1,          // 3
    EXPLOSIVETYPE_UNUSED2,          // 4
    EXPLOSIVETYPE_MotionSensor,     // 5
    EXPLOSIVETYPE_MAX               // 6
};

enum EPreEntryType
{
    PreEntry_None,                  // 0
    PreEntry_Scope,                 // 1
    PreEntry_MAX                    // 2
};

enum EBreachMethod
{
    Breach_None,                    // 0
    Breach_Open,                    // 1
    Breach_PickLock,                // 2
    Breach_Pack,                    // 3
    Breach_ShootHinges,             // 4
    Breach_ShootKnob,               // 5
    Breach_Kick,                    // 6
    Breach_MAX                      // 7
};

enum EEntryType
{
    Entry_None,                     // 0
    Entry_Covert,                   // 1
    Entry_Clear,                    // 2
    Entry_BangClear,                // 3
    Entry_FragClear,                // 4
    Entry_SmokeClear,               // 5
    Entry_Frag,                     // 6
    Entry_Bang,                     // 7
    Entry_Smoke,                    // 8
    Entry_MAX                       // 9
};

enum ECommunicationMethod
{
    CM_RADIO,                       // 0
    CM_TALK,                        // 1
    CM_SHOUT,                       // 2
    CM_HANDSIGNAL,                  // 3
    CM_IMPLICIT,                    // 4
    CM_MAX                          // 5
};

enum ERainbowMembers
{
    RAINBOW_NONE,                   // 0
    RAINBOW_JUNG,                   // 1
    RAINBOW_MICHAEL,                // 2
    RAINBOW_GABRIEL,                // 3
    RAINBOW_KAN,                    // 4
    RAINBOW_MAX                     // 5
};

enum ECoopPlayers
{
    COOPPLAYER_NONE,                // 0
    COOPPLAYER_ONE,                 // 1
    COOPPLAYER_TWO,                 // 2
    COOPPLAYER_THREE,               // 3
    COOPPLAYER_FOUR,                // 4
    COOPPLAYER_MAX                  // 5
};

enum EChopperPawns
{
    CHOPPERPAWN_NONE,               // 0
    CHOPPERPAWN_GABRIEL,            // 1
    CHOPPERPAWN_JOANNA,             // 2
    CHOPPERPAWN_BRODY,              // 3
    CHOPPERPAWN_MAX                 // 4
};

enum EActionSide
{
    ACTIONSIDE_LEFT,                // 0
    ACTIONSIDE_RIGHT,               // 1
    ACTIONSIDE_NONE,                // 2
    ACTIONSIDE_MAX                  // 3
};

enum ERootMotion
{
    ROOTMOTION_None,                // 0
    ROOTMOTION_Discard,             // 1
    ROOTMOTION_Translate,           // 2
    ROOTMOTION_DiscardTranslate,    // 3
    ROOTMOTION_MAX                  // 4
};

enum EAnimSyncType
{
    ANIMSYNCTYPE_None,              // 0
    ANIMSYNCTYPE_Walking,           // 1
    ANIMSYNCTYPE_General,           // 2
    ANIMSYNCTYPE_CoverHeight,       // 3
    ANIMSYNCTYPE_TurretStep,        // 4
    ANIMSYNCTYPE_MAX                // 5
};

enum ESoundSlot
{
    SLOT_None,                      // 0
    SLOT_Music,                     // 1
    SLOT_Ambient,                   // 2
    SLOT_Voice,                     // 3
    SLOT_SFX,                       // 4
    SLOT_Weapon,                    // 5
    SLOT_Menus,                     // 6
    SLOT_VolumetricSound,           // 7
    SLOT_PIP,                       // 8
    SLOT_Impact,                    // 9
    SLOT_ImpactPlayer,              // 10
    SLOT_40Amb,                     // 11
    SLOT_Special,                   // 12
    SLOT_VoiceFiltered,             // 13
    SLOT_MenuMusic,                 // 14
    SLOT_ScoreMusic,                // 15
    SLOT_SourceMusic,               // 16
    SLOT_MAX                        // 17
};

enum ESoundOccluderType
{
    OT_DISABLED,                    // 0
    OT_BRICK_WALL,                  // 1
    OT_CURTAIN,                     // 2
    OT_DOUBLE_WINDOW,               // 3
    OT_SINGLE_WINDOW,               // 4
    OT_STONE_WALL,                  // 5
    OT_THICK_DOOR,                  // 6
    OT_THIN_DOOR,                   // 7
    OT_WOOD_WALL,                   // 8
    OT_MAX                          // 9
};

enum ESoundSurfaceType
{
    SURF_Metal_Barrel,              // 0
    SURF_Metal_Pipe,                // 1
    SURF_Metal_Pipe_Steam,          // 2
    SURF_Metal_Can,                 // 3
    SURF_Metal_Hard,                // 4
    SURF_Metal_Sheet,               // 5
    SURF_Metal_VentShaft,           // 6
    SURF_Metal_Fence,               // 7
    SURF_Metal_Grille,              // 8
    SURF_Generic_Hard,              // 9
    SURF_Conrete_Dirt,              // 10
    SURF_Concrete_Tiles,            // 11
    SURF_Dirt,                      // 12
    SURF_Gravel,                    // 13
    SURF_Grass,                     // 14
    SURF_Water_Puddle,              // 15
    SURF_Water_Deep,                // 16
    SURF_Glass,                     // 17
    SURF_Glass_Shards,              // 18
    SURF_Wood_Boomy,                // 19
    SURF_Wood_Tree,                 // 20
    SURF_Wood_Hard,                 // 21
    SURF_Tire_Air,                  // 22
    SURF_Tire_GenRubber,            // 23
    SURF_Vegetation,                // 24
    SURF_SandBag,                   // 25
    SURF_Plush,                     // 26
    SURF_Carpet,                    // 27
    SURF_Blinds,                    // 28
    SURF_Cloth,                     // 29
    SURF_Piano_Keyboard,            // 30
    SURF_Piano_Chords,              // 31
    SURF_Flesh,                     // 32
    SURF_Body,                      // 33
    SURF_Head,                      // 34
    SURF_Metal_Alarm,               // 35
    SURF_Metal_Electronics,         // 36
    SURF_Metal_SheetSmall,          // 37
    SURF_Metal_SheetBig,            // 38
    SURF_Metal_Stands,              // 39
    SURF_Plastic_Thin,              // 40
    SURF_Plastic_Thick,             // 41
    SURF_Plastic_Cloth,             // 42
    SURF_Plastic_Bins,              // 43
    SURF_Plaster,                   // 44
    SURF_Metal_MiscObjects,         // 45
    SURF_Pottery,                   // 46
    SURF_Ceramics,                  // 47
    SURF_Paper,                     // 48
    SURF_Bell,                      // 49
    SURF_Metal_Shelf,               // 50
    SURF_Metal_StepLadder,          // 51
    SURF_Wood_StepLadder,           // 52
    SURF_Metal_Scaffold,            // 53
    SURF_Electric_Field,            // 54
    SURF_Plastic_TrashBag,          // 55
    SURF_Electric_lightbulbs_LEDcreen,// 56
    SURF_Metal_ForgedFence_Grille,  // 57
    SURF_Metal_Signs,               // 58
    SURF_Metal_Glassed,             // 59
    SURF_Drum_Cymbal,               // 60
    SURF_Drum_Tom,                  // 61
    SURF_Drum_Snare,                // 62
    SURF_Woody_Creaky,              // 63
    SURF_SlotMachines_Electro,      // 64
    SURF_SlotMachines_Old,          // 65
    SURF_SlotMachines_Inferno,      // 66
    SURF_Sofa,                      // 67
    SURF_CartonBox,                 // 68
    SURF_Guitar,                    // 69
    SURF_Amp,                       // 70
    SURF_CartonBox_Bottles,         // 71
    SURF_Car_Vehicule,              // 72
    SURF_Arcade_Machines,           // 73
    SURF_Dantes_PipeOrgan,          // 74
    SURF_Aquarium_WaterLeak,        // 75
    SURF_MAX                        // 76
};

enum EFadeCurve
{
    FADE_Linear,                    // 0
    FADE_Log,                       // 1
    FADE_Pow_9,                     // 2
    FADE_Pow_12,                    // 3
    FADE_Pow_18,                    // 4
    FADE_Pow_3,                     // 5
    FADE_Pow_4,                     // 6
    FADE_Pow_5,                     // 7
    FADE_SCurve_1_5,                // 8
    FADE_SCurve_0_75,               // 9
    FADE_Inv_SCurve_5,              // 10
    FADE_Inv_SCurve_5_75,           // 11
    FADE_MAX                        // 12
};

enum EWeaponSound
{
    WSOUND_None,                    // 0
    WSOUND_Initialize,              // 1
    WSOUND_PlayTrigger,             // 2
    WSOUND_PlayFireSingleShot,      // 3
    WSOUND_PlayFireEndSingleShot,   // 4
    WSOUND_PlayFireThreeBurst,      // 5
    WSOUND_PlayFireFullAuto,        // 6
    WSOUND_PlayEmptyMag,            // 7
    WSOUND_PlayReloadEmpty,         // 8
    WSOUND_PlayReload,              // 9
    WSOUND_StopFireFullAuto,        // 10
    WSOUND_PlayFireTwoBurst,        // 11
    WSOUND_PlayEquipSuppressor,     // 12
    WSOUND_ForceStopFireFullAuto,   // 13
    WSOUND_MAX                      // 14
};

enum ESoundInfoObjectType
{
    eSIONone,                       // 0
    eSIOAmbient,                    // 1
    eSIOVolumetric,                 // 2
    ESoundInfoObjectType_MAX        // 3
};

enum EWaveMarker
{
    WM_None,                        // 0
    WM_Light,                       // 1
    WM_Light1,                      // 2
    WM_MAX                          // 3
};

enum ESoundSplitter
{
    SPLIT_X,                        // 0
    SPLIT_Y,                        // 1
    SPLIT_Z,                        // 2
    SPLIT_MAX                       // 3
};

enum EVoiceSoundType
{
    VOICESOUNDTYPE_NONE,            // 0
    VOICESOUNDTYPE_UNFILTERED,      // 1
    VOICESOUNDTYPE_FILTERED,        // 2
    VOICESOUNDTYPE_MAX              // 3
};

enum ECameraOffsetRotation
{
    ECAMOFFSETROT_WORLD,            // 0
    ECAMOFFSETROT_PAWN,             // 1
    ECAMOFFSETROT_CAMERA,           // 2
    ECAMOFFSETROT_MAX               // 3
};

enum EAimAxis
{
    AIM_PITCH,                      // 0
    AIM_YAW,                        // 1
    AIM_MAX                         // 2
};

enum EBoneArmsAndHead
{
    BONEPART_Body,                  // 0
    BONEPART_Head,                  // 1
    BONEPART_LeftArm,               // 2
    BONEPART_RightArm,              // 3
    BONEPART_Legs,                  // 4
    BONEPART_Camera,                // 5
    BONEPART_MAX                    // 6
};

enum ETakeCover
{
    TAKECOVER_None,                 // 0
    TAKECOVER_Ready,                // 1
    TAKECOVER_Aim,                  // 2
    TAKECOVER_PeekUp,               // 3
    TAKECOVER_PeekLeft,             // 4
    TAKECOVER_PeekRight,            // 5
    TAKECOVER_Transition,           // 6
    TAKECOVER_MAX                   // 7
};

enum ETakeCoverAngle
{
    TAKECOVERANGLE_None,            // 0
    TAKECOVERANGLE_Aim,             // 1
    TAKECOVERANGLE_DeadAngle,       // 2
    TAKECOVERANGLE_ShortSideLeft,   // 3
    TAKECOVERANGLE_ShortSideRight,  // 4
    TAKECOVERANGLE_BlindFireSide,   // 5
    TAKECOVERANGLE_PeekNormal,      // 6
    TAKECOVERANGLE_PeekExposed,     // 7
    TAKECOVERANGLE_DeadAngleBlindFireUp,// 8
    TAKECOVERANGLE_Transition,      // 9
    TAKECOVERANGLE_All,             // 10
    TAKECOVERANGLE_MAX              // 11
};

enum ETakeCoverMode
{
    TAKECOVERMODE_Ready,            // 0
    TAKECOVERMODE_Aim,              // 1
    TAKECOVERMODE_Peek,             // 2
    TAKECOVERMODE_MAX               // 3
};

enum ETakeCoverPosition
{
    TAKECOVERPOS_None,              // 0
    TAKECOVERPOS_Cover,             // 1
    TAKECOVERPOS_PeekRight,         // 2
    TAKECOVERPOS_PeekLeft,          // 3
    TAKECOVERPOS_PeekExposedRight,  // 4
    TAKECOVERPOS_PeekExposedLeft,   // 5
    TAKECOVERPOS_MAX                // 6
};

enum ECONNECTIONFAILURE
{
    ECONNECTIONFAILURE_None,        // 0
    ECONNECTIONFAILURE_Reserved1,   // 1
    ECONNECTIONFAILURE_Reserved2,   // 2
    ECONNECTIONFAILURE_Reserved3,   // 3
    ECONNECTIONFAILURE_Reserved4,   // 4
    ECONNECTIONFAILURE_Reserved5,   // 5
    ECONNECTIONFAILURE_Reserved6,   // 6
    ECONNECTIONFAILURE_Reserved7,   // 7
    ECONNECTIONFAILURE_Reserved8,   // 8
    ECONNECTIONFAILURE_Reserved9,   // 9
    ECONNECTIONFAILURE_ServerFull,  // 10
    ECONNECTIONFAILURE_PlayerNeedPassword,// 11
    ECONNECTIONFAILURE_PlayerWrongPassword,// 12
    ECONNECTIONFAILURE_PlayerBanned,// 13
    ECONNECTIONFAILURE_ServerCannotFindPlace,// 14
    ECONNECTIONFAILURE_PlayerCannotSpawn,// 15
    ECONNECTIONFAILURE_MAX          // 16
};

enum ECommunicationState
{
    COMMUNICATIONSTATE_Playing,     // 0
    COMMUNICATIONSTATE_Queued,      // 1
    COMMUNICATIONSTATE_Finished,    // 2
    COMMUNICATIONSTATE_Waiting,     // 3
    COMMUNICATIONSTATE_Sleeping,    // 4
    COMMUNICATIONSTATE_WaitingPosition,// 5
    COMMUNICATIONSTATE_QueuedPosition,// 6
    COMMUNICATIONSTATE_MAX          // 7
};

enum ECommunicationType
{
    COMMUNICATIONTYPE_Dialog,       // 0
    COMMUNICATIONTYPE_Order,        // 1
    COMMUNICATIONTYPE_SituationalReports,// 2
    COMMUNICATIONTYPE_Scripted_Events,// 3
    COMMUNICATIONTYPE_TerroIdleChat,// 4
    COMMUNICATIONTYPE_Order_Hostage,// 5
    COMMUNICATIONTYPE_MAX           // 6
};

enum ERulesOfEngagement
{
    ROE_INFILTRATION,               // 0
    ROE_ASSAULT,                    // 1
    ROE_MAX                         // 2
};

enum ER6Tutorial
{
    ER6Tutorial_None,               // 0
    ER6Tutorial_KismetOnly,         // 1
    ER6Tutorial_FastRopeChopper,    // 2
    ER6Tutorial_SnakeCam,           // 3
    ER6Tutorial_Rappel,             // 4
    ER6Tutorial_FireWeapon,         // 5
    ER6Tutorial_TakeCover,          // 6
    ER6Tutorial_TakeCoverPeek,      // 7
    ER6Tutorial_TakeCoverBlindFire, // 8
    ER6Tutorial_TakeCoverAimFire,   // 9
    ER6Tutorial_InventoryMenu,      // 10
    ER6Tutorial_ChangeWeapon,       // 11
    ER6Tutorial_Map,                // 12
    ER6Tutorial_WeaponOption,       // 13
    ER6Tutorial_ThrowGrenade,       // 14
    ER6Tutorial_Regroup,            // 15
    ER6Tutorial_MoveTo,             // 16
    ER6Tutorial_StackAtDoor,        // 17
    ER6Tutorial_ROE,                // 18
    ER6Tutorial_TagEnemy,           // 19
    ER6Tutorial_InvertRappel,       // 20
    ER6Tutorial_SoundSuppressor,    // 21
    ER6Tutorial_ClimbOver,          // 22
    ER6Tutorial_UsedNightVision,    // 23
    ER6Tutorial_UsedThermal,        // 24
    ER6Tutorial_Crouch,             // 25
    ER6Tutorial_DoorBreachClear,    // 26
    ER6Tutorial_DoorFlashClear,     // 27
    ER6Tutorial_TeammateHeal,       // 28
    ER6Tutorial_PlayerHeal,         // 29
    ER6Tutorial_ThrowSmokeGrenade,  // 30
    ER6Tutorial_ChangeGadget,       // 31
    ER6Tutorial_TakeCoverStandPeek, // 32
    ER6Tutorial_TakeCoverCrouchPeek,// 33
    ER6Tutorial_PlayerLadder,       // 34
    ER6Tutorial_TeamUseLadder,      // 35
    ER6Tutorial_TeamSendToFastRope, // 36
    ER6Tutorial_DoorFragClear,      // 37
    ER6Tutorial_DoorSmokeClear,     // 38
    ER6Tutorial_DoorOpenClear,      // 39
    ER6Tutorial_ExitSnakeCam,       // 40
    ER6Tutorial_WindowBreachEntry,  // 41
    ER6Tutorial_TeamUseFastRope,    // 42
    ER6Tutorial_ExitThermalVision,  // 43
    ER6Tutorial_ExitNightVision,    // 44
    ER6Tutorial_OpenVisionMenu,     // 45
    ER6Tutorial_RefittingStation,   // 46
    ER6Tutorial_TeamRappelling,     // 47
    ER6Tutorial_TeamClimbingRappel, // 48
    ER6Tutorial_TakeCoverTurret,    // 49
    ER6Tutorial_MAX                 // 50
};

enum EMoodType
{
    EMOODTYPE_None,                 // 0
    EMOODTYPE_Basic,                // 1
    EMOODTYPE_Guilty,               // 2
    EMOODTYPE_Calm,                 // 3
    EMOODTYPE_Nervous,              // 4
    EMOODTYPE_MAX                   // 5
};

enum PresetHeadParameters
{
    HP_NORMAL,                      // 0
    HP_INTERESTED,                  // 1
    HP_CONTRADICTED,                // 2
    HP_INTRIGUED,                   // 3
    HP_AFRAID,                      // 4
    HP_MAX                          // 5
};

enum EIdleAction
{
    EIDLEACTION_NONE,               // 0
    EIDLEACTION_LEADER,             // 1
    EIDLEACTION_SOMEONE,            // 2
    EIDLEACTION_SOMETHING_RANDOM,   // 3
    EIDLEACTION_SOMETHING_STIMULING,// 4
    EIDLEACTION_FOCUS,              // 5
    EIDLEACTION_IMITATE_FOCUS,      // 6
    EIDLEACTION_SOMETHING_ON_MY_FEET,// 7
    EIDLEACTION_SOMETHING_FRONT_OF_ME,// 8
    EIDLEACTION_MAX                 // 9
};

enum EIdleRole
{
    EIDLEROLE_NONE,                 // 0
    EIDLEROLE_NEUTRAL,              // 1
    EIDLEROLE_FOCUSED,              // 2
    EIDLEROLE_FOCUS,                // 3
    EIDLEROLE_MAX                   // 4
};

enum EAIGestureId
{
    AIGESTURE_NONE,                 // 0
    AIGESTURE_HOLDFIST_OPEN,        // 1
    AIGESTURE_HOLDFIST_CLOSED,      // 2
    AIGESTURE_NOD,                  // 3
    AIGESTURE_TAP_SHOULDER,         // 4
    AIGESTURE_POINT,                // 5
    AIGESTURE_WAVE,                 // 6
    AIGESTURE_DECLINE,              // 7
    AIGESTURE_CHARGE,               // 8
    AIGESTURE_FLANK,                // 9
    AIGESTURE_HOLD,                 // 10
    AIGESTURE_MOVE,                 // 11
    AIGESTURE_PINCER,               // 12
    AIGESTURE_REGROUP,              // 13
    AIGESTURE_MAX                   // 14
};

enum EMusicIntensityState
{
    MUSICINTENSITY_CLEAR,           // 0
    MUSICINTENSITY_ENEMY_SEEN,      // 1
    MUSICINTENSITY_ENEMY_FIGHT_STARTED,// 2
    MUSICINTENSITY_ON_GOING_FIGHT,  // 3
    MUSICINTENSITY_ENEMY_FIGHT_END, // 4
    MUSICINTENSITY_MAX              // 5
};

enum EAward
{
    AWARD_SNIPER,                   // 0
    AWARD_MARKSMAN,                 // 1
    AWARD_KILLERSPREE,              // 2
    AWARD_KILLERRAMPAGE,            // 3
    AWARD_DEMOEXPERT,               // 4
    AWARD_SPECOPS,                  // 5
    AWARD_SIEGESPEC,                // 6
    AWARD_SURVIVOR,                 // 7
    AWARD_LONEWOLF,                 // 8
    AWARD_TEAMSURVIVALIST,          // 9
    AWARD_TEAMCHAMPION,             // 10
    AWARD_HOSTAGERESCUE,            // 11
    AWARD_BOMBEXPERT,               // 12
    AWARD_INFILSPEC,                // 13
    AWARD_HAZMATSPEC,               // 14
    AWARD_MC,                       // 15
    AWARD_BESTOFBEST,               // 16
    AWARD_OFFICER,                  // 17
    AWARD_BASICTRAINING,            // 18
    AWARD_TOUROFDUTY,               // 19
    AWARD_VEGASCHAMPION,            // 20
    AWARD_COOPHUNTNOVICE,           // 21
    AWARD_COOPSTORYNOVICE,          // 22
    AWARD_TOUGHHOMBRE,              // 23
    AWARD_DAMBUSTER,                // 24
    AWARD_HIGHROLLER,               // 25
    AWARD_STREETCLEANER,            // 26
    AWARD_HIGHCLIMBER,              // 27
    AWARD_HELLHOUND,                // 28
    AWARD_R6LEGEND,                 // 29
    AWARD_EXECUTIONER,              // 30
    AWARD_PISTOLEER,                // 31
    AWARD_EQUIPSPEC,                // 32
    AWARD_VETERANHUNTER,            // 33
    AWARD_ELITEHUNTER,              // 34
    AWARD_TRUEIDENTITY,             // 35
    AWARD_MAX                       // 36
};

enum EAwardType
{
    AWARDTYPE_RIBBON,               // 0
    AWARDTYPE_MEDAL,                // 1
    AWARDTYPE_BADGE,                // 2
    AWARDTYPE_TROPHY,               // 3
    AWARDTYPE_MAX                   // 4
};

enum EAwardKillDetail
{
    KILLDETAIL_NONE,                // 0
    KILLDETAIL_PISTOL,              // 1
    KILLDETAIL_EXPLOSIVE,           // 2
    KILLDETAIL_SNIPER,              // 3
    KILLDETAIL_MAX                  // 4
};

enum EAwardGadgets
{
    AWARDGADGET_FRAG,               // 0
    AWARDGADGET_FLASH,              // 1
    AWARDGADGET_SMOKE,              // 2
    AWARDGADGET_INCENDIARY,         // 3
    AWARDGADGET_C4,                 // 4
    AWARDGADGET_BREACHING,          // 5
    AWARDGADGET_MAX                 // 6
};

enum EPingLevels
{
    PINGLEVEL_SLOW,                 // 0
    PINGLEVEL_AVG,                  // 1
    PINGLEVEL_FAST,                 // 2
    PINGLEVEL_UNKNOWN,              // 3
    PINGLEVEL_MAX                   // 4
};

enum EWeaponAnimType
{
    WEAPONANIM_MG,                  // 0
    WEAPONANIM_Pistol,              // 1
    WEAPONANIM_RPG,                 // 2
    WEAPONANIM_Shield,              // 3
    WEAPONANIM_Shotgun,             // 4
    WEAPONANIM_Sniper,              // 5
    WEAPONANIM_None,                // 6
    WEAPONANIM_MAX                  // 7
};

enum EOutfittingKit
{
    KIT_Assault,                    // 0
    KIT_Recon,                      // 1
    KIT_Demolition,                 // 2
    KIT_Sniper,                     // 3
    KIT_SinglePlayer,               // 4
    KIT_MAX                         // 5
};

enum EOutfittingFullLists
{
    WEAPONLIST_AllAssault,          // 0
    WEAPONLIST_AllSniper,           // 1
    WEAPONLIST_AllSMGs,             // 2
    WEAPONLIST_AllLMGs,             // 3
    WEAPONLIST_AllShotguns,         // 4
    WEAPONLIST_AllPistols,          // 5
    WEAPONLIST_AllGadgets,          // 6
    WEAPONLIST_AllGadgetsMP,        // 7
    WEAPONLIST_AllShields,          // 8
    WEAPONLIST_WeaponAttachments,   // 9
    WEAPONLIST_MAX                  // 10
};

enum EPecAsset
{
    ASSET_HeadModel,                // 0
    ASSET_FacialHairTexture,        // 1
    ASSET_FacialFeatureTexture,     // 2
    ASSET_HeadGearModel,            // 3
    ASSET_FaceGearModel,            // 4
    ASSET_ChestGearModel,           // 5
    ASSET_LegsGearModel,            // 6
    ASSET_EyewearModel,             // 7
    ASSET_HeadGearCamo,             // 8
    ASSET_FaceGearCamo,             // 9
    ASSET_ChestCamo,                // 10
    ASSET_LegsCamo,                 // 11
    ASSET_EyewearCamo,              // 12
    ASSET_ArmorShoulderModel,       // 13
    ASSET_ArmorArmModel,            // 14
    ASSET_ArmorShinModel,           // 15
    ASSET_ArmorBodyModel,           // 16
    ASSET_ShinCamo,                 // 17
    ASSET_ArmCamo,                  // 18
    ASSET_TorsoCamo,                // 19
    ASSET_ShoulderCamo,             // 20
    ASSET_MAX                       // 21
};

enum ESearchGraphResult
{
    GRAPH_AddAndExploreBranch,      // 0
    GRAPH_StopExploreBranch,        // 1
    GRAPH_AddAndStopExploreBranch,  // 2
    GRAPH_MAX                       // 3
};

struct TerroHuntMissionInfo
{
    structcpptext
    {

        FTerroHuntMissionInfo()
        {
            m_bDone = 0;
            m_iBestTime = 2147483647;
        }

        friend FArchive& operator<<( FArchive& Ar, FTerroHuntMissionInfo& A )
        {
            Ar<<A.m_bDone;
            Ar<<A.m_iBestTime;

            return Ar;
        }
    
    }

    var int m_bDone;
    var int m_iBestTime;

    structdefaultproperties
    {
        m_bDone=0
        m_iBestTime=0
    }
};

struct TerroHuntMissionDifficultyInfo
{
    structcpptext
    {

        friend FArchive& operator<<( FArchive& Ar, FTerroHuntMissionDifficultyInfo& A )
        {
            Ar<<A.m_VeteranInfo;
            Ar<<A.m_EliteInfo;
            Ar<<A.m_iMissionOrderId;

            return Ar;
        }
    
    }

    var TerroHuntMissionInfo m_VeteranInfo;
    var TerroHuntMissionInfo m_EliteInfo;
    var int m_iMissionOrderId;

    structdefaultproperties
    {
        m_VeteranInfo=(m_bDone=0,m_iBestTime=0)
        m_EliteInfo=(m_bDone=0,m_iBestTime=0)
        m_iMissionOrderId=0
    }
};

struct SAngleLimits
{
    var() /*0x20000000-0x00000000*/ int m_iMax;
    var() /*0x20000000-0x00000000*/ int m_iMin;

    structdefaultproperties
    {
        m_iMax=0
        m_iMin=0
    }
};

struct R6CoverSeg_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6Goal_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6GoalList_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6CoverZone_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6AICommunicateDef_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6ShareCover_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6ComputedData_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6ComputedAdvanceData_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6ComputedAmbushData_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6ComputedCornerData_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6ComputedCoverData_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6ComputedSearchData_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6ComputedFindPath_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6ComputedNavMeshPathData_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6RequestProc_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6RequestNavMeshPath_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct NavMeshPortal_Ptr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

struct R6OrderInfo
{
    var R6EngineEnums.EOrderId m_eOrderId;
    var bool m_bDisabled;

    structdefaultproperties
    {
        m_eOrderId=0
        m_bDisabled=false
    }
};

struct ThumbsActionInfo
{
    var() R6EngineEnums.EThumbstickAction m_eThumbstick_LeftX;
    var() R6EngineEnums.EThumbstickAction m_eThumbstick_LeftY;
    var() R6EngineEnums.EThumbstickAction m_eThumbstick_LeftPush;
    var() R6EngineEnums.EThumbstickAction m_eThumbstick_RightX;
    var() R6EngineEnums.EThumbstickAction m_eThumbstick_RightY;
    var() R6EngineEnums.EThumbstickAction m_eThumbstick_RightPush;

    structdefaultproperties
    {
        m_eThumbstick_LeftX=0
        m_eThumbstick_LeftY=0
        m_eThumbstick_LeftPush=0
        m_eThumbstick_RightX=0
        m_eThumbstick_RightY=0
        m_eThumbstick_RightPush=0
    }
};

struct ButtonsActionInfo
{
    var() R6EngineEnums.EButtonsAction m_eButton_A;
    var() R6EngineEnums.EButtonsAction m_eButton_B;
    var() R6EngineEnums.EButtonsAction m_eButton_X;
    var() R6EngineEnums.EButtonsAction m_eButton_Y;
    var() R6EngineEnums.EButtonsAction m_eButton_Back;
    var() R6EngineEnums.EButtonsAction m_eButton_Start;
    var() R6EngineEnums.EButtonsAction m_eButton_LT;
    var() R6EngineEnums.EButtonsAction m_eButton_RT;
    var() R6EngineEnums.EButtonsAction m_eButton_LB;
    var() R6EngineEnums.EButtonsAction m_eButton_RB;

    structdefaultproperties
    {
        m_eButton_A=0
        m_eButton_B=0
        m_eButton_X=0
        m_eButton_Y=0
        m_eButton_Back=0
        m_eButton_Start=0
        m_eButton_LT=0
        m_eButton_RT=0
        m_eButton_LB=0
        m_eButton_RB=0
    }
};

struct R6ScriptedAnimInfo
{
    var() name m_AnimName;
    var() bool m_bLooping;
    var bool m_bKeepAnimAtLastFrame;
    var float m_fAnimPos;
    var() float m_fStartPos;
    var() float m_fPlayRate;
    var() float m_fStartBlendTime;
    var() float m_fEndBlendTime;
    var() bool m_bApplyRootYawRotation;
    var() bool m_bNoFailCollision;
    var() bool m_bIsFacial;
    var() bool m_bCalculateVelocity;
    var() R6EngineEnums.ERootMotion m_eRootMotion[3];

    structdefaultproperties
    {
        m_AnimName="None"
        m_bLooping=false
        m_bKeepAnimAtLastFrame=false
        m_fAnimPos=0.0000000
        m_fStartPos=0.0000000
        m_fPlayRate=1.0000000
        m_fStartBlendTime=0.5000000
        m_fEndBlendTime=0.5000000
        m_bApplyRootYawRotation=true
        m_bNoFailCollision=false
        m_bIsFacial=false
        m_bCalculateVelocity=false
        m_eRootMotion[0]=2
        m_eRootMotion[1]=2
        m_eRootMotion[2]=0
    }
};

struct GestureSpeed
{
    var() R6EngineEnums.EMoodType m_eMoodType;
    var() float m_fBodySpeed;
    var() float m_fBreathingSpeed;
    var() float m_fHeadSpeed;
    var() float m_fOriginalHeadSpeed;

    structdefaultproperties
    {
        m_eMoodType=0
        m_fBodySpeed=1.0000000
        m_fBreathingSpeed=1.0000000
        m_fHeadSpeed=1.0000000
        m_fOriginalHeadSpeed=1.0000000
    }
};

struct PostureType
{
    var() R6EngineEnums.EMoodType m_eMoodType;
    var() float m_fBreathingStrength;
    var() R6EngineEnums.PresetHeadParameters m_eHeadPosture;

    structdefaultproperties
    {
        m_eMoodType=0
        m_fBreathingStrength=1500.0000000
        m_eHeadPosture=0
    }
};

struct R6StreamingKismetData
{
    var array<SoundCue> m_arrSoundCues;

    structdefaultproperties
    {
        m_arrSoundCues=none
    }
};

struct R6MissionFailedInfo
{
    var() string m_strFailureReason;
    var() float m_fTimeBeforeShowing;
    var bool m_bHasOptionalParam;
    var bool m_bPlayerDied;
    var int m_iNetVersion;
    var string m_strOptionalParam;

    structdefaultproperties
    {
        m_strFailureReason=""
        m_fTimeBeforeShowing=0.0000000
        m_bHasOptionalParam=false
        m_bPlayerDied=false
        m_iNetVersion=0
        m_strOptionalParam=""
    }
};
