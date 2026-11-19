class R6GameEnums extends Object
    native;

const BEHAVIOUR_OFFENSIVE = 0x00000001;
const BEHAVIOUR_DEFENSIVE = 0x00000002;
const UNUSABLE_ACTION_SCORE = -99999;
const NOTEAM = 255;

enum ECamBobMode
{
    ECAMBOBMODE_NONE,               // 0
    ECAMBOBMODE_IDLE,               // 1
    ECAMBOBMODE_WALKING,            // 2
    ECAMBOBMODE_MAX                 // 3
};

enum ECombatCover
{
    COMBATCOVER_Initialize,         // 0
    COMBATCOVER_ChooseAction,       // 1
    COMBATCOVER_Wait,               // 2
    COMBATCOVER_Exit,               // 3
    COMBATCOVER_MAX                 // 4
};

enum EIdleAnimType
{
    IDLEANIM_NORMAL,                // 0
    IDLEANIM_TC,                    // 1
    IDLEANIM_RAPPEL,                // 2
    IDLEANIM_LADDER,                // 3
    IDLEANIM_MAX                    // 4
};

enum ESearch
{
    SEARCH_MoveToSearchLocation,    // 0
    SEARCH_Investigate,             // 1
    SEARCH_MAX                      // 2
};

enum ESearchLevel
{
    ESearchLevel_Inquire,           // 0
    ESearchLevel_InBetween,         // 1
    ESearchLevel_Extensive,         // 2
    ESearchLevel_MAX                // 3
};

enum EKismet
{
    KISMET_Initialize,              // 0
    KISMET_Executing,               // 1
    KISMET_Finished,                // 2
    KISMET_MAX                      // 3
};

enum EInteractRope
{
    INTERACTROPE_Initialize,        // 0
    INTERACTROPE_GetOnRope,         // 1
    INTERACTROPE_MoveOnRope,        // 2
    INTERACTROPE_GetOffRope,        // 3
    INTERACTROPE_Wait,              // 4
    INTERACTROPE_MAX                // 5
};

enum EPawnRopeStatus
{
    PAWNROPESTATUS_NONE,            // 0
    PAWNROPESTATUS_INVERTED,        // 1
    PAWNROPESTATUS_JUMP_BEGIN,      // 2
    PAWNROPESTATUS_JUMP,            // 3
    PAWNROPESTATUS_JUMP_END,        // 4
    PAWNROPESTATUS_BREACH_BEGIN,    // 5
    PAWNROPESTATUS_BREACH,          // 6
    PAWNROPESTATUS_BREACH_END,      // 7
    PAWNROPESTATUS_ENTRY_BEGIN,     // 8
    PAWNROPESTATUS_ENTRY,           // 9
    PAWNROPESTATUS_ENTRY_END,       // 10
    PAWNROPESTATUS_INVERTING,       // 11
    PAWNROPESTATUS_DEINVERTING,     // 12
    PAWNROPESTATUS_BRAKING,         // 13
    PAWNROPESTATUS_ATTACHTRANSITION,// 14
    PAWNROPESTATUS_DETTACHTRANSITION,// 15
    PAWNROPESTATUS_MAX              // 16
};

enum ENavObjAttachment
{
    ATTACH_NONE,                    // 0
    ATTACH_TOP,                     // 1
    ATTACH_BOTTOM,                  // 2
    ATTACH_WINDOW,                  // 3
    ATTACH_HELICOPTER,              // 4
    ATTACH_MAX                      // 5
};

enum EShootFireMode
{
    FIREMODE_FullAuto,              // 0
    FIREMODE_2RoundBurst,           // 1
    FIREMODE_3RoundBurst,           // 2
    FIREMODE_SingleShot,            // 3
    FIREMODE_MAX                    // 4
};

enum EWeaponSlotType
{
    EWeaponSlot_Main,               // 0
    EWeaponSlot_Pistol,             // 1
    EWeaponSlot_MAX                 // 2
};

enum EReloadAnimType
{
    RELOADANIM_StandThirdPerson,    // 0
    RELOADANIM_CrouchThirdPerson,   // 1
    RELOADANIM_Rappel,              // 2
    RELOADANIM_RappelInverted,      // 3
    RELOADANIM_StandTakeCoverReady, // 4
    RELOADANIM_CrouchTakeCoverReady,// 5
    RELOADANIM_FirstPerson,         // 6
    RELOADANIM_WeaponFirstPerson,   // 7
    RELOADANIM_WeaponThirdPerson,   // 8
    RELOADANIM_RappelTc,            // 9
    RELOADANIM_WeaponMagFirstPerson,// 10
    RELOADANIM_WeaponMagThirdPerson,// 11
    RELOADANIM_StandTakeCoverAim,   // 12
    RELOADANIM_CrouchTakeCoverAim,  // 13
    RELOADANIM_StandTakeCoverShortSideLeft,// 14
    RELOADANIM_CrouchTakeCoverShortSideLeft,// 15
    RELOADANIM_StandTakeCoverShortSideRight,// 16
    RELOADANIM_CrouchTakeCoverShortSideRight,// 17
    RELOADANIM_RappelLeft,          // 18
    RELOADANIM_RappelRight,         // 19
    RELOADANIM_RappelInvertedLeft,  // 20
    RELOADANIM_RappelInvertedRight, // 21
    RELOADANIM_StandTakeCoverMoveLeft,// 22
    RELOADANIM_StandTakeCoverMoveRight,// 23
    RELOADANIM_CrouchTakeCoverMoveLeft,// 24
    RELOADANIM_CrouchTakeCoverMoveRight,// 25
    RELOADANIM_MAX                  // 26
};

enum ESuppressorAnimType
{
    SUPPRESSORANIM_StandThirdPerson,// 0
    SUPPRESSORANIM_CrouchThirdPerson,// 1
    SUPPRESSORANIM_Rappel,          // 2
    SUPPRESSORANIM_RappelInverted,  // 3
    SUPPRESSORANIM_StandTakeCoverReady,// 4
    SUPPRESSORANIM_CrouchTakeCoverReady,// 5
    SUPPRESSORANIM_StandTakeCoverAim,// 6
    SUPPRESSORANIM_CrouchTakeCoverAim,// 7
    SUPPRESSORANIM_StandTakeCoverShortSideLeft,// 8
    SUPPRESSORANIM_CrouchTakeCoverShortSideLeft,// 9
    SUPPRESSORANIM_StandTakeCoverShortSideRight,// 10
    SUPPRESSORANIM_CrouchTakeCoverShortSideRight,// 11
    SUPPRESSORANIM_RappelLeft,      // 12
    SUPPRESSORANIM_RappelRight,     // 13
    SUPPRESSORANIM_RappelInvertedLeft,// 14
    SUPPRESSORANIM_RappelInvertedRight,// 15
    SUPPRESSORANIM_StandTakeCoverMoveLeft,// 16
    SUPPRESSORANIM_StandTakeCoverMoveRight,// 17
    SUPPRESSORANIM_CrouchTakeCoverMoveLeft,// 18
    SUPPRESSORANIM_CrouchTakeCoverMoveRight,// 19
    SUPPRESSORANIM_MAX              // 20
};

enum EHandPoseType
{
    EHandPose_DefaultHold,          // 0
    EHandPose_HandleHold,           // 1
    EHandPose_XM26Hold,             // 2
    EHandPose_SmallMag,             // 3
    EHandPose_MediumMag,            // 4
    EHandPose_LargeMag,             // 5
    EHandPose_LMGMag,               // 6
    EHandPose_P90Hold,              // 7
    EHandPose_MAX                   // 8
};

enum EReloadSoundType
{
    EReloadSound_Tactical,          // 0
    EReloadSound_Empty,             // 1
    EReloadSound_ChamberStart,      // 2
    EReloadSound_ChamberCycle,      // 3
    EReloadSound_ChamberEndTactical,// 4
    EReloadSound_ChamberEndEmpty,   // 5
    EReloadSound_ShieldTactical,    // 6
    EReloadSound_ShieldEmpty,       // 7
    EReloadSound_MAX                // 8
};

enum EGoalScan
{
    SCAN_START,                     // 0
    SCAN_UPDATE,                    // 1
    SCAN_WAIT,                      // 2
    SCAN_SHORTWAIT,                 // 3
    SCAN_MAX                        // 4
};

enum ECivilWander
{
    CIVILWANDER_MoveToPoint,        // 0
    CIVILWANDER_UpdateNextPoint,    // 1
    CIVILWANDER_MAX                 // 2
};

enum ECivilGoal
{
    CIVILGOAL_None,                 // 0
    CIVILGOAL_MoveToPoint,          // 1
    CIVILGOAL_UpdateNextPoint,      // 2
    CIVILGOAL_SeekCover,            // 3
    CIVILGOAL_Covered,              // 4
    CIVILGOAL_ChooseExit,           // 5
    CIVILGOAL_CheckLocationIsSafe,  // 6
    CIVILGOAL_Wait,                 // 7
    CIVILGOAL_MAX                   // 8
};

enum EActionType
{
    ACTIONTYPE_None,                // 0
    ACTIONTYPE_ShootCamera,         // 1
    ACTIONTYPE_UseFixedGun,         // 2
    ACTIONTYPE_FastRopeShoot,       // 3
    ACTIONTYPE_FastRopeNoShoot,     // 4
    ACTIONTYPE_MoveFromCoverToCoverLOS,// 5
    ACTIONTYPE_TauntEnemy,          // 6
    ACTIONTYPE_MakeCover,           // 7
    ACTIONTYPE_RunToCoverShoot,     // 8
    ACTIONTYPE_RunToCoverNoShoot,   // 9
    ACTIONTYPE_RollIntoCover,       // 10
    ACTIONTYPE_SlideIntoCover,      // 11
    ACTIONTYPE_HideInCover,         // 12
    ACTIONTYPE_ThrowMolotov,        // 13
    ACTIONTYPE_ThrowIncendiary,     // 14
    ACTIONTYPE_ThrowEMP,            // 15
    ACTIONTYPE_ThrowFrag,           // 16
    ACTIONTYPE_ThrowFlash,          // 17
    ACTIONTYPE_ThrowGas,            // 18
    ACTIONTYPE_ThrowSmoke,          // 19
    ACTIONTYPE_AimShootFromCover,   // 20
    ACTIONTYPE_BlindShootFromCover, // 21
    ACTIONTYPE_RunFromGrenade,      // 22
    ACTIONTYPE_JumpOnToGrenade,     // 23
    ACTIONTYPE_BlockPathWithObject, // 24
    ACTIONTYPE_UsePursuitDeterrent, // 25
    ACTIONTYPE_KickBarrelAtEnemy,   // 26
    ACTIONTYPE_TurnOnLight,         // 27
    ACTIONTYPE_TurnOffLight,        // 28
    ACTIONTYPE_ShootOutLight,       // 29
    ACTIONTYPE_ChargeEnemy,         // 30
    ACTIONTYPE_StandAndShoot,       // 31
    ACTIONTYPE_Retreat,             // 32
    ACTIONTYPE_Surrender,           // 33
    ACTIONTYPE_PushHostageIntoOpen, // 34
    ACTIONTYPE_ActivateNVG,         // 35
    ACTIONTYPE_ActivateFlashlight,  // 36
    ACTIONTYPE_UseKeyObjectAsCover, // 37
    ACTIONTYPE_PeekFromCover,       // 38
    ACTIONTYPE_StrafeShoot,         // 39
    ACTIONTYPE_StrafeNoShoot,       // 40
    ACTIONTYPE_MoveToShoot,         // 41
    ACTIONTYPE_Advance,             // 42
    ACTIONTYPE_Fallback,            // 43
    ACTIONTYPE_EscapeGrenade,       // 44
    ACTIONTYPE_MoveInCover,         // 45
    ACTIONTYPE_ReloadWeapon,        // 46
    ACTIONTYPE_EvadeGrenade,        // 47
    ACTIONTYPE_Revive,              // 48
    ACTIONTYPE_StopAndShoot,        // 49
    ACTIONTYPE_MAX                  // 50
};

enum EActionSuperType
{
    ACTIONSUPERTYPE_None,           // 0
    ACTIONSUPERTYPE_Special,        // 1
    ACTIONSUPERTYPE_Basic,          // 2
    ACTIONSUPERTYPE_Idle,           // 3
    ACTIONSUPERTYPE_MAX             // 4
};

enum ECarriedObjectType
{
    CARRIEDOBJECTTYPE_None,         // 0
    CARRIEDOBJECTTYPE_Canister,     // 1
    CARRIEDOBJECTTYPE_Briefcase,    // 2
    CARRIEDOBJECTTYPE_MAX           // 3
};

enum ESnakeCamPos
{
    ESnakeCamPos_NONE,              // 0
    ESnakeCamPos_LEFT,              // 1
    ESnakeCamPos_CENTER,            // 2
    ESnakeCamPos_RIGHT,             // 3
    ESnakeCamPos_MAX                // 4
};

enum EHelicopterSittingPos
{
    EHelicopterSittingPos_Hacker,   // 0
    EHelicopterSittingPos_Demo,     // 1
    EHelicopterSittingPos_Logan,    // 2
    EHelicopterSittingPos_Joanna,   // 3
    EHelicopterSittingPos_Pilot,    // 4
    EHelicopterSittingPos_CoPilot,  // 5
    EHelicopterSittingPos_Out,      // 6
    EHelicopterSittingPos_MAX       // 7
};

enum ESOLSelection
{
    ESOLSelection_NONE,             // 0
    ESOLSelection_REPEAT,           // 1
    ESOLSelection_CANCEL,           // 2
    ESOLSelection_LEFT,             // 3
    ESOLSelection_RIGHT,            // 4
    ESOLSelection_MAX               // 5
};

enum EGAMEMSG
{
    GAMEMSG_MatchOvertime,          // 0
    GAMEMSG_PlayerEnterGame,        // 1
    GAMEMSG_PlayerChangeName,       // 2
    GAMEMSG_PlayerChangeTeam,       // 3
    GAMEMSG_PlayerExitGame,         // 4
    GAMEMSG_Reserved5,              // 5
    GAMEMSG_PlayerChangeTeamFailed, // 6
    GAMEMSG_ServerFull,             // 7
    GAMEMSG_Reserved8,              // 8
    GAMEMSG_Reserved9,              // 9
    GAMEMSG_Reserved10,             // 10
    GAMEMSG_Reserved11,             // 11
    GAMEMSG_EnterSpectatorModeFailed,// 12
    GAMEMSG_Reserved13,             // 13
    GAMEMSG_EnterSpectatorMode,     // 14
    GAMEMSG_PlayerKickWarning,      // 15
    GAMEMSG_EnterSpectatorModeOnJoin,// 16
    GAMEMSG_MatchWaiting,           // 17
    GAMEMSG_MatchBegins,            // 18
    GAMEMSG_MatchHasBegun,          // 19
    GAMEMSG_MatchHasEnded,          // 20
    GAMEMSG_MatchRoundBegins,       // 21
    GAMEMSG_MatchRoundHasEnded,     // 22
    GAMEMSG_MatchResultSucceeded,   // 23
    GAMEMSG_MatchResultFailed,      // 24
    GAMEMSG_MatchTeamHasScored,     // 25
    GAMEMSG_PlayerSuicided,         // 26
    GAMEMSG_PlayerKilledByEnvironment,// 27
    GAMEMSG_PlayerKilledByPlayer,   // 28
    GAMEMSG_PlayerKilledByTerrorist,// 29
    GAMEMSG_PlayerRevived,          // 30
    GAMEMSG_PlayerRevivedHelper,    // 31
    GAMEMSG_TeamSpawnZoneDestroyed, // 32
    GAMEMSG_ObjectRespawned,        // 33
    GAMEMSG_ObjectTaken,            // 34
    GAMEMSG_ObjectsTaken,           // 35
    GAMEMSG_ObjectDropped,          // 36
    GAMEMSG_HostageEscorted,        // 37
    GAMEMSG_HostageRescued,         // 38
    GAMEMSG_HostageKilled,          // 39
    GAMEMSG_HostagesKilled,         // 40
    GAMEMSG_TerroristKilled,        // 41
    GAMEMSG_TerroristsEliminated,   // 42
    GAMEMSG_PlayerObjective,        // 43
    GAMEMSG_PlayerBanned,           // 44
    GAMEMSG_TeamKillerBanned,       // 45
    GAMEMSG_CoopLeashing_TooFarFromLeader,// 46
    GAMEMSG_ObjectTakenRemind,      // 47
    GAMEMSG_HostageEscortedRemind,  // 48
    GAMEMSG_PunkBusterBanned,       // 49
    GAMEMSG_OutputTextPB,           // 50
    GAMEMSG_MAX                     // 51
};

enum EThrowType
{
    THROW_Standard,                 // 0
    THROW_Stack_Left,               // 1
    THROW_Stack_Right,              // 2
    THROW_TC_Aim,                   // 3
    THROW_TC_SSLeft,                // 4
    THROW_TC_SSRight,               // 5
    THROW_TC_UpLeft,                // 6
    THROW_TC_UpRight,               // 7
    THROW_TC_SideLeft,              // 8
    THROW_TC_SideRight,             // 9
    THROW_TC_PeekLeft,              // 10
    THROW_TC_PeekRight,             // 11
    THROW_TC_PeekExpLeft,           // 12
    THROW_TC_PeekExpRight,          // 13
    THROW_TC_PeekUp,                // 14
    THROW_TC_WindowLeft,            // 15
    THROW_TC_WindowRight,           // 16
    THROW_None,                     // 17
    THROW_MAX                       // 18
};

enum EShootBurstLength
{
    BURST_Default,                  // 0
    BURST_Single,                   // 1
    BURST_Short,                    // 2
    BURST_Medium,                   // 3
    BURST_Long,                     // 4
    BURST_FullAuto,                 // 5
    BURST_MAX                       // 6
};

enum EFiringType
{
    FIRING_Blind,                   // 0
    FIRING_Suppress,                // 1
    FIRING_Aim,                     // 2
    FIRING_MAX                      // 3
};

enum EPlayerClass
{
    PLAYERCLASS_None,               // 0
    PLAYERCLASS_Commando,           // 1
    PLAYERCLASS_Breacher,           // 2
    PLAYERCLASS_SpecOp,             // 3
    PLAYERCLASS_Sniper,             // 4
    PLAYERCLASS_Chemist,            // 5
    PLAYERCLASS_MAX                 // 6
};

enum ETEAMIDENTITY
{
    ETEAMIDENTITY_A,                // 0
    ETEAMIDENTITY_B,                // 1
    ETEAMIDENTITY_ALL,              // 2
    ETEAMIDENTITY_MAX               // 3
};

enum ERainbowEntryLocation
{
    RAINBOWENTRY_None,              // 0
    RAINBOWENTRY_RightTC,           // 1
    RAINBOWENTRY_RightStack,        // 2
    RAINBOWENTRY_LeftTC,            // 3
    RAINBOWENTRY_LeftStack,         // 4
    RAINBOWENTRY_MAX                // 5
};

enum EEnterTakeCover
{
    ENTERTAKECOVER_None,            // 0
    ENTERTAKECOVER_Ready,           // 1
    ENTERTAKECOVER_Aim,             // 2
    ENTERTAKECOVER_Blend,           // 3
    ENTERTAKECOVER_MAX              // 4
};

enum EExitTakeCover
{
    EXITTAKECOVER_None,             // 0
    EXITTAKECOVER_Ready,            // 1
    EXITTAKECOVER_Aim,              // 2
    EXITTAKECOVER_Blend,            // 3
    EXITTAKECOVER_MAX               // 4
};

enum ERainbowHealthReaction
{
    RAINBOWHEALTHREACTION_None,     // 0
    RAINBOWHEALTHREACTION_Unused,   // 1
    RAINBOWHEALTHREACTION_ExplosionBig,// 2
    RAINBOWHEALTHREACTION_ExplosionDeath,// 3
    RAINBOWHEALTHREACTION_ExplosionSmall,// 4
    RAINBOWHEALTHREACTION_Flash,    // 5
    RAINBOWHEALTHREACTION_Stun,     // 6
    RAINBOWHEALTHREACTION_Fire,     // 7
    RAINBOWHEALTHREACTION_Choke,    // 8
    RAINBOWHEALTHREACTION_BulletHit,// 9
    RAINBOWHEALTHREACTION_Breach,   // 10
    RAINBOWHEALTHREACTION_Curiosity,// 11
    RAINBOWHEALTHREACTION_Flinch,   // 12
    RAINBOWHEALTHREACTION_Shrug,    // 13
    RAINBOWHEALTHREACTION_Stunned,  // 14
    RAINBOWHEALTHREACTION_Surprise, // 15
    RAINBOWHEALTHREACTION_MAX       // 16
};

enum EEventRelativeLocation
{
    EVENTRELATIVELOCATION_FRONTLEFT,// 0
    EVENTRELATIVELOCATION_FRONT,    // 1
    EVENTRELATIVELOCATION_FRONTRIGHT,// 2
    EVENTRELATIVELOCATION_LEFT,     // 3
    EVENTRELATIVELOCATION_RIGHT,    // 4
    EVENTRELATIVELOCATION_BACKLEFT, // 5
    EVENTRELATIVELOCATION_BACK,     // 6
    EVENTRELATIVELOCATION_BACKRIGHT,// 7
    EVENTRELATIVELOCATION_NONE,     // 8
    EVENTRELATIVELOCATION_MAX       // 9
};

enum EBodyPartReaction
{
    BODYPARTREACTION_ARM,           // 0
    BODYPARTREACTION_HEAD,          // 1
    BODYPARTREACTION_LEG,           // 2
    BODYPARTREACTION_TORSOUPPER,    // 3
    BODYPARTREACTION_TORSOLOWER,    // 4
    BODYPARTREACTION_LEFT_LEG,      // 5
    BODYPARTREACTION_RIGHT_LEG,     // 6
    BODYPARTREACTION_LEFT_ARM,      // 7
    BODYPARTREACTION_RIGHT_ARM,     // 8
    BODYPARTREACTION_LEFT_SHOULDER, // 9
    BODYPARTREACTION_RIGHT_SHOULDER,// 10
    BODYPARTREACTION_STOMACH,       // 11
    BODYPARTREACTION_BACK_HIGH,     // 12
    BODYPARTREACTION_MAX            // 13
};

enum EStancesType
{
    STANCETYPE_READY,               // 0
    STANCETYPE_AIM,                 // 1
    STANCETYPE_ZOOM,                // 2
    STANCETYPE_MAX                  // 3
};

enum EBurstShootAnimState
{
    BURSTANIM_CYCLE,                // 0
    BURSTANIM_END,                  // 1
    BURSTANIM_MAX                   // 2
};

enum EEntryAssaultTakeCover
{
    ENTRYASSAULTTC_NoneInTakeCover, // 0
    ENTRYASSAULTTC_OneInTakeCover,  // 1
    ENTRYASSAULTTC_TwoInTakeCover,  // 2
    ENTRYASSAULTTC_MAX              // 3
};

enum EMovement
{
    MOVEMENT_SIDESTEP,              // 0
    MOVEMENT_CROSSOVER,             // 1
    MOVEMENT_WALKSTOP,              // 2
    MOVEMENT_FASTWALKSTOP,          // 3
    MOVEMENT_JOGSTOP,               // 4
    MOVEMENT_WALKSTART,             // 5
    MOVEMENT_FASTWALKSTART,         // 6
    MOVEMENT_JOGSTART,              // 7
    MOVEMENT_NONE,                  // 8
    MOVEMENT_MAX                    // 9
};

enum EAnimateDoorAction
{
    ANIMATEDOOR_None,               // 0
    ANIMATEDOOR_Open,               // 1
    ANIMATEDOOR_RainbowEntry,       // 2
    ANIMATEDOOR_Protect,            // 3
    ANIMATEDOOR_UnProtect,          // 4
    ANIMATEDOOR_PickLock,           // 5
    ANIMATEDOOR_PlaceBreach,        // 6
    ANIMATEDOOR_DetonateBreach,     // 7
    ANIMATEDOOR_CoverForBreach,     // 8
    ANIMATEDOOR_MAX                 // 9
};

enum EAttachmentType
{
    EAttachmentType_None,           // 0
    EAttachmentType_Hand,           // 1
    EAttachmentType_HandComplementary,// 2
    EAttachmentType_Chest,          // 3
    EAttachmentType_BodyPrimary,    // 4
    EAttachmentType_BodySecondary,  // 5
    EAttachmentType_BodyPistol,     // 6
    EAttachmentType_MAX             // 7
};

enum EPawnInteractionType
{
    PAWNINTERACTIONTYPE_NONE,       // 0
    PAWNINTERACTIONTYPE_OPENPUSHNEAR_LEFT,// 1
    PAWNINTERACTIONTYPE_OPENPUSHNEAR_RIGHT,// 2
    PAWNINTERACTIONTYPE_OPENPULLNEAR_LEFT,// 3
    PAWNINTERACTIONTYPE_OPENPULLNEAR_RIGHT,// 4
    PAWNINTERACTIONTYPE_OPENPUSHFAR_LEFT,// 5
    PAWNINTERACTIONTYPE_OPENPUSHFAR_RIGHT,// 6
    PAWNINTERACTIONTYPE_OPENPULLFAR_LEFT,// 7
    PAWNINTERACTIONTYPE_OPENPULLFAR_RIGHT,// 8
    PAWNINTERACTIONTYPE_UNUSED1,    // 9
    PAWNINTERACTIONTYPE_UNUSED2,    // 10
    PAWNINTERACTIONTYPE_ENTRY,      // 11
    PAWNINTERACTIONTYPE_UNUSED3,    // 12
    PAWNINTERACTIONTYPE_PROTECT,    // 13
    PAWNINTERACTIONTYPE_TO_PROTECT, // 14
    PAWNINTERACTIONTYPE_TO_UNPROTECT,// 15
    PAWNINTERACTIONTYPE_OPEN_WINDOW_LEFT,// 16
    PAWNINTERACTIONTYPE_OPEN_WINDOW_RIGHT,// 17
    PAWNINTERACTIONTYPE_BREAK_WINDOW_LEFT,// 18
    PAWNINTERACTIONTYPE_BREAK_WINDOW_RIGHT,// 19
    PAWNINTERACTIONTYPE_BREAK_WINDOW_UNDER,// 20
    PAWNINTERACTIONTYPE_MAX         // 21
};

enum ECameraMode
{
    CAMMODE_NONE,                   // 0
    CAMMODE_DEFAULT,                // 1
    CAMMODE_TAKECOVER,              // 2
    CAMMODE_RAPPEL,                 // 3
    CAMMODE_FASTROPE,               // 4
    CAMMODE_LADDER,                 // 5
    CAMMODE_INTERACTION,            // 6
    CAMMODE_TURRETING,              // 7
    CAMMODE_HELICOPTER,             // 8
    CAMMODE_DEBUG,                  // 9
    CAMMODE_THIRD,                  // 10
    CAMMODE_ORBIT,                  // 11
    CAMMODE_PAWN_INTERACTION,       // 12
    CAMMODE_KILLCAM,                // 13
    CAMMODE_DEAD,                   // 14
    CAMMODE_MAX                     // 15
};

enum EDebugCameraModes
{
    DEBUGCAMMODE_NONE,              // 0
    DEBUGCAMMODE_THIRD,             // 1
    DEBUGCAMMODE_THIRDFREE,         // 2
    DEBUGCAMMODE_FOLLOW,            // 3
    DEBUGCAMMODE_FIXED,             // 4
    DEBUGCAMMODE_OVERWORLD,         // 5
    DEBUGCAMMODE_PAWNCYCLE,         // 6
    DEBUGCAMMODE_MAX                // 7
};

enum EIncapaciteState
{
    INCAPACITESTATE_NONE,           // 0
    INCAPACITESTATE_GOING_DOWN,     // 1
    INCAPACITESTATE_LAYING_DOWN,    // 2
    INCAPACITESTATE_BEING_REVIVED,  // 3
    INCAPACITESTATE_REVIVING,       // 4
    INCAPACITESTATE_MAX             // 5
};

enum EUnderbarrelType
{
    EUnderbarrel_None,              // 0
    EUnderbarrel_Laser,             // 1
    EUnderbarrel_MAX                // 2
};

enum EScopeType
{
    EScope_None,                    // 0
    EScope_IronSights,              // 1
    EScope_ReflexSights,            // 2
    EScope_Rifle,                   // 3
    EScope_ACOG,                    // 4
    EScope_SniperA,                 // 5
    EScope_SniperB,                 // 6
    EScope_SniperC,                 // 7
    EScope_MAX                      // 8
};

enum EWeaponAttachmentLevel
{
    EAttachmentLevel_None,          // 0
    EAttachmentLevel_BuiltIn,       // 1
    EAttachmentLevel_Option1,       // 2
    EAttachmentLevel_Option2,       // 3
    EAttachmentLevel_Option3,       // 4
    EAttachmentLevel_Option4,       // 5
    EAttachmentLevel_MAX            // 6
};

enum EWeaponAttachment
{
    EAttachment_None,               // 0
    EAttachment_Laser,              // 1
    EAttachment_HighCapacityMag,    // 2
    EAttachment_RecoilControlStock, // 3
    EAttachment_ReflexSights,       // 4
    EAttachment_RifleScope,         // 5
    EAttachment_ACOGScope,          // 6
    EAttachment_SniperScopeA,       // 7
    EAttachment_SniperScopeB,       // 8
    EAttachment_SniperScopeC,       // 9
    EAttachment_MAX                 // 10
};

enum EHelicopterAction
{
    EHelicopter_Entering,           // 0
    EHelicopter_Sitting,            // 1
    EHelicopter_SittingToFastRoping,// 2
    EHelicopter_FastRoping,         // 3
    EHelicopter_None,               // 4
    EHelicopter_MAX                 // 5
};

enum EMentalState
{
    MENTALSTATE_UnAware,            // 0
    MENTALSTATE_Aware,              // 1
    MENTALSTATE_MAX                 // 2
};

enum EDetectionAction
{
    DETECTIONACTION_Investigate,    // 0
    DETECTIONACTION_Fortify,        // 1
    DETECTIONACTION_MAX             // 2
};

enum EWakeEvents
{
    EWakeEvent_AnyEvent,            // 0
    EWakeEvent_SeeAnything,         // 1
    EWakeEvent_SeeAnyEnemy,         // 2
    EWakeEvent_SeeEnemyAlert,       // 3
    EWakeEvent_SeeEnemyInvisible,   // 4
    EWakeEvent_SeeEnemyInDark,      // 5
    EWakeEvent_SeeEnemyBehindSmoke, // 6
    EWakeEvent_SeeEnemyInCover,     // 7
    EWakeEvent_SeeEnemyLost,        // 8
    EWakeEvent_SeeGrenade,          // 9
    EWakeEvent_SeeLightTurnOn,      // 10
    EWakeEvent_SeeLightTurnOff,     // 11
    EWakeEvent_HearAnything,        // 12
    EWakeEvent_HearEnemyGunfire,    // 13
    EWakeEvent_HearGrenadeBounce,   // 14
    EWakeEvent_HearGrenadeExplosion,// 15
    EWakeEvent_HearRicochet,        // 16
    EWakeEvent_HearAnyFootsteps,    // 17
    EWakeEvent_HearQuietFootstep,   // 18
    EWakeEvent_HearHeavyFootstep,   // 19
    EWakeEvent_HearDoor,            // 20
    EWakeEvent_HearVoice,           // 21
    EWakeEvent_HearShatter,         // 22
    EWakeEvent_HearScream,          // 23
    EWakeEvent_AnyCloseShots,       // 24
    EWakeEvent_ShotJustMissed,      // 25
    EWakeEvent_TakingDamage,        // 26
    EWakeEvent_AnyNPCBlock,         // 27
    EWakeEvent_NPCBlockingPath,     // 28
    EWakeEvent_NPCBlocksActor,      // 29
    EWakeEvent_NPCDestinationOccupied,// 30
    EWakeEvent_SeeEnemyPeripheral,  // 31
    EWakeEvent_SeeCorpse,           // 32
    EWakeEvent_Threatening,         // 33
    EWakeEvent_NonThreatening,      // 34
    EWakeEvent_MAX                  // 35
};

enum EDoorToken
{
    DOORTOKEN_None,                 // 0
    DOORTOKEN_Inside,               // 1
    DOORTOKEN_Outside,              // 2
    DOORTOKEN_MAX                   // 3
};

enum EAnimTreeType
{
    ANIMTREETYPE_FP,                // 0
    ANIMTREETYPE_TP,                // 1
    ANIMTREETYPE_TC,                // 2
    ANIMTREETYPE_MAX                // 3
};

enum EAnimTc360MoveChildren
{
    ANIMTCMOVECHILD_IDLE,           // 0
    ANIMTCMOVECHILD_SIDESTEP,       // 1
    ANIMTCMOVECHILD_WALK,           // 2
    ANIMTCMOVECHILD_STEALTH,        // 3
    ANIMTCMOVECHILD_FASTWALK,       // 4
    ANIMTCMOVECHILD_MAX             // 5
};

enum EVoiceOrders
{
    EVoiceOrder_Move,               // 0
    EVoiceOrder_Hold,               // 1
    EVoiceOrder_Regroup,            // 2
    EVoiceOrder_Assault,            // 3
    EVoiceOrder_Infiltrate,         // 4
    EVoiceOrder_Tag,                // 5
    EVoiceOrder_MAX                 // 6
};

enum ESpawnGameMode
{
    SpawnGameMode_Mission,          // 0
    SpawnGameMode_TerroHunt,        // 1
    SpawnGameMode_MAX               // 2
};

enum EFadeInterpolationType
{
    E_NONE,                         // 0
    E_LINEAR,                       // 1
    E_SQUARE,                       // 2
    E_ROOT,                         // 3
    E_SIN,                          // 4
    E_CIRCLE,                       // 5
    E_CIRCLEDECEL,                  // 6
    E_MAX                           // 7
};

enum ER6TeamStateDesc
{
    ER6TeamStateDesc_None,          // 0
    ER6TeamStateDesc_DoorClosed,    // 1
    ER6TeamStateDesc_DoorOpened,    // 2
    ER6TeamStateDesc_DoorOpening,   // 3
    ER6TeamStateDesc_DoorLocked,    // 4
    ER6TeamStateDesc_ChokePoint,    // 5
    ER6TeamStateDesc_Window,        // 6
    ER6TeamStateDesc_TakingCover,   // 7
    ER6TeamStateDesc_Following,     // 8
    ER6TeamStateDesc_Rappeling,     // 9
    ER6TeamStateDesc_FollowingRappeling,// 10
    ER6TeamStateDesc_StandingBy,    // 11
    ER6TeamStateDesc_MovingToDoor,  // 12
    ER6TeamStateDesc_MovingToLadder,// 13
    ER6TeamStateDesc_MovingToFastrope,// 14
    ER6TeamStateDesc_MovingToRappelling,// 15
    ER6TeamStateDesc_MovingToWindow,// 16
    ER6TeamStateDesc_MovingToCover, // 17
    ER6TeamStateDesc_InFastRope,    // 18
    ER6TeamStateDesc_InLadder,      // 19
    ER6TeamStateDesc_EngagingEnemy, // 20
    ER6TeamStateDesc_ClearingRoom,  // 21
    ER6TeamStateDesc_Regrouping,    // 22
    ER6TeamStateDesc_Interacting,   // 23
    ER6TeamStateDesc_ManDown,       // 24
    ER6TeamStateDesc_EnemySpotted,  // 25
    ER6TeamStateDesc_Holding,       // 26
    ER6TeamStateDesc_BreachingDoor, // 27
    ER6TeamStateDesc_SwitchingROE,  // 28
    ER6TeamStateDesc_MAX            // 29
};

enum ETutorialNodeType
{
    EType_SingleAction,             // 0
    EType_FirstMultiAction,         // 1
    EType_SecondMultiAction,        // 2
    EType_ThirdMultiAction,         // 3
    EType_MAX                       // 4
};

enum ETutorialAxisInput
{
    ETutorialAxisInput_None,        // 0
    ETutorialAxisInput_Up,          // 1
    ETutorialAxisInput_Down,        // 2
    ETutorialAxisInput_Left,        // 3
    ETutorialAxisInput_Right,       // 4
    ETutorialAxisInput_Horizontal,  // 5
    ETutorialAxisInput_Vertical,    // 6
    ETutorialAxisInput_All,         // 7
    ETutorialAxisInput_MAX          // 8
};

enum EPawnAlertStatus
{
    EStatus_Unaware,                // 0
    EStatus_Aware,                  // 1
    EStatus_Combat,                 // 2
    EStatus_MAX                     // 3
};

enum EDoorGrenadeToken
{
    DOORGRENADETOKEN_None,          // 0
    DOORGRENADETOKEN_Right,         // 1
    DOORGRENADETOKEN_Left,          // 2
    DOORGRENADETOKEN_MAX            // 3
};

struct R6WakeInfo
{
    var() R6GameEnums.EWakeEvents m_Event;
    var() bool m_PlayerEventOnly;
    var() bool m_IncludeTeammates;

    structdefaultproperties
    {
        m_Event=0
        m_PlayerEventOnly=false
        m_IncludeTeammates=false
    }
};

struct MotionSensorRepInfo
{
    var int m_iID;
    var Vector m_vLoc;
    var int m_iRotation;

    structdefaultproperties
    {
        m_iID=0
        m_vLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iRotation=0
    }
};

struct FadeParams
{
    var() string m_szText;
    var() float m_fFadeDuration;
    var() float m_fBlockInputsTime;
    var() float m_fPauseHudTime;
    var() Color m_cStartColor;
    var() Color m_cEndColor;
    var() bool m_bCloseOnceDone;
    var() TextureMovie m_pMovie;
    var() R6GameEnums.EFadeInterpolationType m_eInterpolationType;

    structdefaultproperties
    {
        m_szText=""
        m_fFadeDuration=1.0000000
        m_fBlockInputsTime=1.0000000
        m_fPauseHudTime=1.0000000
        m_cStartColor=(R=255,G=255,B=255,A=255)
        m_cEndColor=(R=255,G=255,B=255,A=0)
        m_bCloseOnceDone=true
        m_pMovie=none
        m_eInterpolationType=1
    }
};

struct R6TutMultiTextInfo
{
    var() float m_fTimeToShowText;
    var() string m_sTextId;

    structdefaultproperties
    {
        m_fTimeToShowText=5.0000000
        m_sTextId=""
    }
};

struct R6TutorialInfo
{
    var R6EngineEnums.ER6Tutorial m_eScenario;
    var R6GameEnums.ETutorialNodeType m_eNodeType;
    var R6GameEnums.ETutorialAxisInput m_eAxis;
    var float m_fTimeDescShown;
    var bool m_bDontShowButton;
    var name m_KeyName;
    var string m_sDescId;
    var string m_sActionId;
    var array<R6TutMultiTextInfo> m_aExtraDesc;

    structdefaultproperties
    {
        m_eScenario=0
        m_eNodeType=0
        m_eAxis=0
        m_fTimeDescShown=0.0000000
        m_bDontShowButton=false
        m_KeyName="None"
        m_sDescId=""
        m_sActionId=""
        m_aExtraDesc=none
    }
};
