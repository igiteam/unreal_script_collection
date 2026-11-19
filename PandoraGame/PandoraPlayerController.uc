class PandoraPlayerController extends GamePlayerController
    native
    config(Game);

const PROP_NonStandardOptions = 0x10000006;
const PROP_DedicatedServer = 0x10000009;
const PROP_CustomMapName = 0x10000011;
const PROP_GameStatus = 0x10000012;
const PROP_LONGBOWACCURACYRATING = 0x30000003;
const GAME_STATUS_LOBBY = 0;
const GAME_STATUS_INPROGRESS = 1;
const GAME_STATUS_POSTGAME = 2;
const GAME_MODE = 0x0000800B;
const GAME_MODE_DM = 0;
const GAME_MODE_TDM = 1;
const CONTEXT_MAPNAME = 0;
const CONTEXT_NUMCREATURES = 1;
const CONTEXT_MATCHDURATION = 2;
const CONTEXT_ANIMUSLIMIT = 3;
const CONTEXT_FULLSERVER = 4;
const CONTEXT_FULLSERVER_NOTFULLSERVER = 0;
const CONTEXT_FULLSERVER_FULLSERVER = 1;
const CONTEXT_MAPNAME_MAP_ANY = 0;
const CONTEXT_MAPNAME_MP_DUR_WW = 1;
const CONTEXT_MAPNAME_WW_TESTMAP = 2;
const CONTEXT_MAPNAME_SUR_RABOUT_MTR = 3;
const CONTEXT_MAPNAME_WEREHOUSE_MTR = 4;
const CONTEXT_MAPNAME_THEKEEP_MTR = 5;
const CONTEXT_MAPNAME_DEN_MTR_MP = 6;
const CONTEXT_MAPNAME_NYSTREET_MTR_MP = 7;
const CONTEXT_MAPNAME_JOHNSPLAYGROUND = 8;
const CONTEXT_MAPNAME_DOUGLAND = 9;
const CONTEXT_NUMCREATURES_ANY = 0;
const CONTEXT_NUMCREATURES_NONE = 1;
const CONTEXT_NUMCREATURES_LOW = 2;
const CONTEXT_NUMCREATURES_MEDIUM = 3;
const CONTEXT_NUMCREATURES_HIGH = 4;
const CONTEXT_MATCHDURATION_ANY = 0;
const CONTEXT_MATCHDURATION_5MIN = 1;
const CONTEXT_MATCHDURATION_10MIN = 2;
const CONTEXT_MATCHDURATION_15MIN = 3;
const CONTEXT_MATCHDURATION_30MIN = 4;
const CONTEXT_MATCHDURATION_1HR = 5;
const CONTEXT_ANIMUSLIMIT_ANYPTS = 0;
const CONTEXT_ANIMUSLIMIT_100PTS = 1;
const CONTEXT_ANIMUSLIMIT_250PTS = 2;
const CONTEXT_ANIMUSLIMIT_500PTS = 3;
const CONTEXT_ANIMUSLIMIT_750PTS = 4;
const CONTEXT_ANIMUSLIMIT_1000PTS = 5;
const CONTEXT_PRESENCE_LEGENDARYMAIN = 0;
const CONTEXT_PRESENCE_LEGENDARYSP = 1;
const CONTEXT_PRESENCE_LEGENDARYMP = 2;
const CONTEXT_PRESENCE_INACTIVEPROFILE = 3;
const QUERY_DMSearch = 1;
const QUERY_PandoraCustomSearch = 2;
const ACHIEVEMENT_ACHIEVEMENT12 = 1;
const ACHIEVEMENT_ACHIEVEMENT13 = 2;
const ACHIEVEMENT_ACHIEVEMENT14 = 3;
const ACHIEVEMENT_ACHIEVEMENT15 = 4;
const ACHIEVEMENT_ACHIEVEMENT01 = 5;
const ACHIEVEMENT_ACHIEVEMENT16 = 6;
const ACHIEVEMENT_ACHIEVEMENT17 = 7;
const ACHIEVEMENT_ACHIEVEMENT02 = 8;
const ACHIEVEMENT_ACHIEVEMENT18 = 9;
const ACHIEVEMENT_ACHIEVEMENT19 = 10;
const ACHIEVEMENT_ACHIEVEMENT20 = 11;
const ACHIEVEMENT_ACHIEVEMENT21 = 12;
const ACHIEVEMENT_ACHIEVEMENT03 = 13;
const ACHIEVEMENT_ACHIEVEMENT22 = 14;
const ACHIEVEMENT_ACHIEVEMENT23 = 15;
const ACHIEVEMENT_ACHIEVEMENT24 = 16;
const ACHIEVEMENT_ACHIEVEMENT04 = 17;
const ACHIEVEMENT_ACHIEVEMENT25 = 18;
const ACHIEVEMENT_ACHIEVEMENT26 = 19;
const ACHIEVEMENT_ACHIEVEMENT27 = 20;
const ACHIEVEMENT_ACHIEVEMENT05 = 21;
const ACHIEVEMENT_ACHIEVEMENT28 = 22;
const ACHIEVEMENT_ACHIEVEMENT30 = 23;
const ACHIEVEMENT_ACHIEVEMENT06 = 24;
const ACHIEVEMENT_ACHIEVEMENT31 = 25;
const ACHIEVEMENT_ACHIEVEMENT32 = 26;
const ACHIEVEMENT_ACHIEVEMENT07 = 27;
const ACHIEVEMENT_ACHIEVEMENT33 = 28;
const ACHIEVEMENT_ACHIEVEMENT29 = 29;
const ACHIEVEMENT_ACHIEVEMENT34 = 30;
const ACHIEVEMENT_ACHIEVEMENT08 = 31;
const ACHIEVEMENT_ACHIEVEMENT09 = 32;
const ACHIEVEMENT_ACHIEVEMENT10 = 33;
const ACHIEVEMENT_ACHIEVEMENT11 = 34;
const ACHIEVEMENT_ACHIEVEMENT35 = 35;
const ACHIEVEMENT_ACHIEVEMENT36 = 36;
const ACHIEVEMENT_ACHIEVEMENT37 = 37;
const ACHIEVEMENT_ACHIEVEMENT38 = 38;
const ACHIEVEMENT_ACHIEVEMENT39 = 39;
const ACHIEVEMENT_ACHIEVEMENT40 = 40;
const ACHIEVEMENT_ACHIEVEMENT41 = 41;
const ACHIEVEMENT_ACHIEVEMENT42 = 42;
const ACHIEVEMENT_ACHIEVEMENT43 = 43;
const ACHIEVEMENT_ACHIEVEMENT45 = 44;
const ACHIEVEMENT_ACHIEVEMENT46 = 45;
const ACHIEVEMENT_ACHIEVEMENT44 = 46;
const ACHIEVEMENT_ACHIEVEMENT47 = 47;
const ACHIEVEMENT_ACHIEVEMENT48 = 48;
const ACHIEVEMENT_ACHIEVEMENT49 = 49;
const ACHIEVEMENT_ACHIEVEMENT50 = 50;

enum WeaponSlots
{
    eGrenadeSlot,                   // 0
    eWeaponRightSlot,               // 1
    eMeleeWeaponSlot,               // 2
    eWeaponLeftSlot,                // 3
    WeaponSlots_MAX                 // 4
};

enum ePlayerActionState
{
    ePlayerActionNone,              // 0
    ePlayerActionWWHARMinigameStart,// 1
    ePlayerActionWWHARMinigameChain,// 2
    ePlayerActionWWHARMinigameFinish,// 3
    ePlayerActionWWDBUpLeft,        // 4
    ePlayerActionWWDBUpRight,       // 5
    ePlayerActionWWDBDownLeft,      // 6
    ePlayerActionWWDBDownRight,     // 7
    ePlayerActionTMGFallback,       // 8
    ePlayerActionTMGGroundStage1,   // 9
    ePlayerActionTMGStage2Choice,   // 10
    ePlayerActionTMGStage1PassKickOff,// 11
    ePlayerActionTMGTransitionToStage2,// 12
    ePlayerActionTMGStage1Fail,     // 13
    ePlayerActionTMGGroundStage2,   // 14
    ePlayerActionTMGStage2Fail,     // 15
    ePlayerActionTMGGetUp,          // 16
    ePlayerActionTMGKillshot,       // 17
    ePlayerActionTMGKillshotSuccess,// 18
    ePlayerActionState_MAX          // 19
};

enum EDeviceValidErrorCode
{
    DVEC_Valid,                     // 0
    DVEC_NoneSelected,              // 1
    DVEC_Invalid,                   // 2
    DVEC_MAX                        // 3
};

enum eSprintMode
{
    SM_SprintBurst,                 // 0
    SM_Sprint,                      // 1
    SM_None,                        // 2
    SM_MAX                          // 3
};

enum eAmBxRumbleType
{
    amBX_boing,                     // 0
    amBX_crash,                     // 1
    amBX_engine,                    // 2
    amBX_explosion,                 // 3
    amBX_hit,                       // 4
    amBX_quake,                     // 5
    amBX_rattle,                    // 6
    amBX_road,                      // 7
    amBX_shot,                      // 8
    amBX_thud,                      // 9
    amBX_thunder,                   // 10
    amBX_MAX                        // 11
};

struct native RecoilData
{
    /** Make sure if you change this, you also make sure that the UISCENT_Scoreboard is updated as well. expose base pitch yaw delta, rand pitch yaw delta recoilimpact time, recovertime */
    var() float PitchImpactAngle;
    /** Make sure if you change this, you also make sure that the UISCENT_Scoreboard is updated as well. expose base pitch yaw delta, rand pitch yaw delta recoilimpact time, recovertime */
    var() float YawImpactAngle;
    /** Make sure if you change this, you also make sure that the UISCENT_Scoreboard is updated as well. expose base pitch yaw delta, rand pitch yaw delta recoilimpact time, recovertime */
    var() float RandPitchImpactAngle;
    /** Make sure if you change this, you also make sure that the UISCENT_Scoreboard is updated as well. expose base pitch yaw delta, rand pitch yaw delta recoilimpact time, recovertime */
    var() float RandYawImpactAngle;
    /** Make sure if you change this, you also make sure that the UISCENT_Scoreboard is updated as well. expose base pitch yaw delta, rand pitch yaw delta recoilimpact time, recovertime */
    var() float EffectImpulseTime;
    /** Make sure if you change this, you also make sure that the UISCENT_Scoreboard is updated as well. expose base pitch yaw delta, rand pitch yaw delta recoilimpact time, recovertime */
    var() float EffectRecoverTime;

    structdefaultproperties
    {
        PitchImpactAngle=0.0000000
        YawImpactAngle=0.0000000
        RandPitchImpactAngle=0.0000000
        RandYawImpactAngle=0.0000000
        EffectImpulseTime=0.0000000
        EffectRecoverTime=0.0000000
    }
};

struct native CheckpointLoadout
{
    var array<string> WeaponNames;
    var /*0x80000000-0x00000000*/ array< class<Inventory> > WeaponInvClass;
    var array<int> WeaponAmmoSpares;
    var array<int> WeaponAmmoUsed;
    var array<int> GrenadeAmmos;
    var bool bIsValid;

    structdefaultproperties
    {
        WeaponNames=none
        WeaponInvClass=none
        WeaponAmmoSpares=none
        WeaponAmmoUsed=none
        GrenadeAmmos=none
        bIsValid=false
    }
};

struct native OnScreenTextData
{
    var UIScene Scene;
    var SeqAct_OnScreenTextPersistent Action;
    var float DialogDuration;
    var float DialogDurationLeft;

    structdefaultproperties
    {
        Scene=none
        Action=none
        DialogDuration=0.0000000
        DialogDurationLeft=0.0000000
    }
};

struct native PlayerProfileData
{
    var bool bInvertMouse;
    var bool bControllerVibration;
    var bool bShowSubTitle;
    var float MasterVolume;
    var bool bMusicEnabled;
    var float GammaSetting;
    var int GameDifficulty;
    var bool bFadeHUD;
    var int CtrlConfig;
    var int CtrlSensitivity;
    var int CompositePerformace;

    structdefaultproperties
    {
        bInvertMouse=false
        bControllerVibration=false
        bShowSubTitle=false
        MasterVolume=0.0000000
        bMusicEnabled=false
        GammaSetting=0.0000000
        GameDifficulty=0
        bFadeHUD=false
        CtrlConfig=0
        CtrlSensitivity=0
        CompositePerformace=0
    }
};

struct native AnimusButtonHandling
{
    var bool bDown;
    var float PressedTime;
    var float ReleaseTime;
    var float LastDuration;
    var float DoubleClickTime;
    var name ButtonName;

    structdefaultproperties
    {
        bDown=false
        PressedTime=0.0000000
        ReleaseTime=0.0000000
        LastDuration=0.0000000
        DoubleClickTime=0.0000000
        ButtonName="None"
    }
};

struct native UICheckpoint
{
    var init string Title;
    var init string Filename;
    var init string CheckpointMapName;
    var init string CheckpointName;

    structdefaultproperties
    {
        Title=""
        Filename=""
        CheckpointMapName=""
        CheckpointName=""
    }
};

var string PlatformStrings;
var() int LockPosition;
var() float WeaponImpulse;
var() float HoldDistanceMin;
var() float HoldDistanceMax;
var() float ThrowImpulse;
var() float ChangeHoldDistanceIncrement;
var() export editinline RB_Handle PhysicsGrabber;
var() export editinline RB_Handle LeftHand;
var() export editinline RB_Handle RightHand;
var float lookDownSiteTime;
var float LastFlipTime;
var float HoldDistance;
var Quat HoldOrientation;
var Weapon CurrentWeapon;
var private MountedWeapon MountedWeapon;
var bool bBurningSprintTime;
var bool bBurnedSprintTime;
var bool bInJump;
var bool bCanSiphon;
var bool bShowCanSiphon;
var bool bSiphonRequest;
var bool bLogEquip;
var bool bLogNet;
var bool bLogSprint;
var bool bDisableHud;
var bool bHealRequest;
var bool bForceSprintExtension;
var bool bDodgeCombineDown;
var bool dodgeReset;
var bool m_bDisableSprintAmbience;
var transient bool bDisableSwitchToBestWeapon;
var transient bool bPushedIsLookingDownSiteState;
var transient bool bLookDownSiteDisabled;
var transient bool bDisplayScoreboard;
var bool m_bCanUseScope;
var bool m_bCanQuickSwap;
var bool m_bTimerForWeaponPickupOrReload;
var bool m_bWeaponPickupOrReload;
var bool m_bLockWeaponFOVtoWorld;
var bool bTackleReenableOverride;
var bool m_bTMGOverride;
var bool m_bSprintSoundFadeBegun;
var bool m_bSprintSoundPlaying;
var bool m_bFireAxeDebugDraw;
var bool m_bWaitForConnectionErrorConfirmation;
var bool m_bShouldRefreshOnlineStatus;
var bool m_bAllowInteractTextDisplay;
var bool m_bOKToSaveCheckpoints;
var bool m_bTimeForTackle;
var bool m_bTimeForHitAndRunMinigame;
var bool m_minigameAlignToEngager;
var bool startedSPGameWithoutProfile;
var bool bOverridePlayerControl;
var bool bForceCameraLookAt;
var bool bEnableConsoleText;
var bool bCarryThrowPrimeRequest;
var bool bExhausted;
var bool bWeaponSwitched;
var bool bShouldCheckPointTeleport;
var bool bQuickMenuOn;
var transient bool bMsgBoxDisplayed;
var bool m_bUsingAnimusUsedAndHeld;
var bool m_bShowedFillMessage;
var bool bUnlimitedWeaponsAndAmmo;
var bool bWalkOrGhost;
var bool bShowKynapsePaths;
var bool bPrevUnlimitedWeaponsAndAmmo;
var bool bPrevShowKynapsePaths;
var bool m_bWantsToLookDownSite;
var transient bool bQuittingToMainMenu;
var transient bool bTestingFov;
var bool bHoldUse;
var bool bLoginChanged;
var transient bool bResetPickupMessageActorState;
var transient bool bDelayMemoryCardRemovedCallBack;
var transient bool bQueuedPause;
var transient bool bDelayedProfileWrite;
var transient bool bCanSaveToDevice;
var transient bool bShouldApplyCached;
var bool m_bPlayingAmBxSprintEffect;
var bool m_bPlayingAmBxFallingEffect;
var bool m_amBX_AmbientLightsEnabled;
var bool bAmbientConfigSet;
var bool bHasSpace;
var bool bReSaveCheckpoint;
var float fPrimeTime;
var float fSinceLastPrime;
var Actor.EDoubleClickDir forceDodgeMove;
var Actor.EMinigameState m_minigameState;
var byte m_HandToHandFireModeNum;
var PandoraPlayerController.ePlayerActionState m_actionState;
var byte bIgnoreFiringInput;
var byte bIgnoreCrouchingInput;
var byte bIgnoreJumpingInput;
var byte bIgnoreSprintInput;
var byte bIgnoreAnimusPulseInput;
var byte bIgnoreAnimusSiphonInput;
var transient byte bTempIgnoreAnimusPulseInput;
var byte bIgnorePauseInput;
var float SprintTime;
var float LastSprintTime;
var float LastSprintDisplayFullTime;
var float CantBeTackledTime;
var float LastDodgeTime;
var() const editconst export editinline RB_RadialImpulseComponent ImpulseComponent;
var() ScreenShakeStruct ExplosionShake;
/** How much "sprint time" it cost do a dodge move (in seconds). Physics debug / */
var(Sprint) config float playerDodgeCost;
var SPPawn DebugPawn;
var SPPawn SecondDebugPawn;
var transient float overRideGlobalFOV;
var int m_TMGBlendState;
var float m_fSprintRate;
var float m_fFatigueAmount;
var export editinline AudioComponent m_SprintSound;
var SPSquad m_squad;
var string m_AdvertisedMap;
var int m_ScoreboardPage;
var Rotator m_tackleViewRotation;
var SPBaseWerewolfAIController m_werewolfTackler;
var SPBaseWerewolfAIController m_werewolfMinigameController;
var(TackleMiniGame) SPTackleMinigameManager tackleMinigameManager;
var float m_blendValueForMash1Animations;
var float m_blendValueForMash2Animations;
var float m_oldFOV;
var Rotator m_minigameDesiredRotation;
var Rotator m_minigameStartingRotation;
var Rotator m_minigameOrientDeltaRotation;
var float m_minigameOrientTime;
var Rotator m_TentacleGrabViewRotation;
var SPSewerTentacleAIController m_TentacleController;
var Vector MoveDest;
var Actor MoveDestActor;
var Vector LastPos;
var Rotator NewRot;
var Rotator CameraLookAtRot;
var float OverrideGroundSpeed;
var DynamicSMActor Carried;
var Pawn CarriedPawn;
var() float m_ThrowItemImpulse;
var() float m_ThrowItemTimingThreshold;
var() float m_ThrowItemRotationOffset;
var() float m_PickupItemMaxDistance;
var() float m_PickupItemMinFacingAngle;
var() name m_CarrySocket;
var float fCarryThrowPrimeTime;
var float LastDropTime;
var export editinline SPKynapseComponent KynapseComponent;
var float SprintRampDownTime;
var float SprintTimeMax;
var float SprintDurationMin;
var float SprintRegenTimeCrouching;
var float SprintRegenTimeStanding;
var float SprintRegenTimeMoving;
var float DodgeTimeCost;
/** Exhaustion effects */
var(ExhaustionParameter) float exhaustTime;
var(ExhaustionParameter) float repeatRate;
var float exhaustLastTime;
var float maxFOVchange;
var float m_oldWeaponFOV;
var float m_oldWorldFOV;
var PandoraCheckpointManager SPCM;
var CheckpointLoadout CKP_Loadout;
var SPGameDifficultyTuneGamePlay m_GameplayGDTuneData;
var float LastDuckTime;
var OnScreenTextData currOnScreenText;
var string DeviceName;
var UIScene quickMenuUIScene;
var UIScene qMenuScene;
var UICheckbox chxGodMode;
var UICheckbox chxUnlimitedWeapsAndAmmo;
var UICheckbox chxWalkOrGhost;
var UICheckbox chxShowKynapsePaths;
var UICheckbox chxShowLowMemMsg;
var UICheckbox chxInvertY;
var UICheckbox chxShowCopyright;
var UICheckbox chxShowBuild;
var float m_fShowedFillMessageTimer;
var UIScene CheckPointMenuUIScene;
var UIScene CPMenuScene;
var UILabelButton btnCheckPoint[7];
var UILabel lblCheckpoint[7];
var array<UICheckpoint> CheckPoints;
var int CheckPointMenuStartIdx;
var PandoraUIDatabase pdaData;
var PandoraProfileSettings ProfileSettings;
var PlayerProfileData SavedProfile;
var AnimusButtonHandling AnimusButton;
var MaterialInstanceConstant m_GrenadeMolotovBarMaterial;
var int VoiceChannel;
var transient float PreTestDefaultFov;
var int DatafileSize;
var PandoraPDAManager PDAManager;
var UIScene MessageBoxScene;
var transient int cachedPawnHealth;
var transient int cachedPawnAnimus;
var SeqAct_AmBxSetWindEffect m_CurrentScriptedWindEffect;
var SeqAct_AmBxSetWindEffect m_PausedScriptedWindEffect;
var config float m_UpdateTimeForWindEffects;
var config float m_amBX_UpdateTimeForAmbientLighting;
var float m_amBX_LastUpdateTimeForAmbientLighting;
var config float m_amBX_AmbientLightScaleFactorLookingDownSights;
var config float m_amBX_AmbientLightScaleFactorLookingDownScope;
var config float m_amBX_AmbientLightBaseLevel;
var config Color m_amBX_AmbientLightBaseColor;
var config float m_amBX_AmbientLightMaxLevel;
var float m_amBX_AmbientCurrentLightBaseLevel;
var Color m_amBX_AmbientCurrentLightBaseColor;
var float m_amBX_AmbientCurrentLightMaxLevel;
var config int m_amBX_FallScriptPlayVelocity;
var float m_fAmBxOutOfBreathThreshold;
var config float m_amBX_ScreenShakeMaxRotAmp;
var config float m_amBX_ScreenShakeMaxRotFreq;
var config float m_amBX_ScreenShakeMaxLocAmp;
var config float m_amBX_ScreenShakeMaxLocFreq;
var config float m_amBX_ScreenShakeRotPerc;
var config float m_amBX_ScreenShakeLocPerc;
var config float m_amBX_ScreenShakeLogBase;
var config float m_amBX_ScreenShakeZeroThreshold;
var config float m_amBX_ScreenShakeDivY;
var config float m_amBX_ScreenShakeMulX;
var config float m_amBX_ScreenShakeAddX;
var config float m_amBX_ScreenShakeAddY;
//var delegate<OnDeviceSelectionComplete> __OnDeviceSelectionComplete__Delegate;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        m_bShowedFillMessage;
}

// Export UPandoraPlayerController::execPlayThisAmBxScript(FFrame&, void* const)
native function PlayThisAmBxScript(string AmBxScript);

// Export UPandoraPlayerController::execPlayAmBxScript(FFrame&, void* const)
native function PlayAmBxScript(string AmBxScriptName, int epoch);

// Export UPandoraPlayerController::execPlayAmBxScriptPOV(FFrame&, void* const)
native function PlayAmBxScriptPOV(string AmBxScriptName, string AmBxLocName, int epoch);

// Export UPandoraPlayerController::execForceStopAmBxScript(FFrame&, void* const)
native function ForceStopAmBxScript(string AmBxScriptName);

// Export UPandoraPlayerController::execStopAmBxScript(FFrame&, void* const)
native function StopAmBxScript(string AmBxScriptName);

// Export UPandoraPlayerController::execStopAllAmBxScripts(FFrame&, void* const)
native function StopAllAmBxScripts();

// Export UPandoraPlayerController::execSafeAmBxTransitionPoint(FFrame&, void* const)
native function SafeAmBxTransitionPoint();

// Export UPandoraPlayerController::execSendAmBxShake(FFrame&, void* const)
native function SendAmBxShake(int durationMillis, float intensity, float Speed);

// Export UPandoraPlayerController::execSetAmBxAllLightColourFloat(FFrame&, void* const)
native function SetAmBxAllLightColourFloat(float Red, float Green, float Blue);

// Export UPandoraPlayerController::execSetAmBxAllLightColour255(FFrame&, void* const)
native function SetAmBxAllLightColour255(int Red, int Green, int Blue);

// Export UPandoraPlayerController::execStopAmbientRumble(FFrame&, void* const)
native function StopAmbientRumble();

// Export UPandoraPlayerController::execStopAmbientLights(FFrame&, void* const)
native function StopAmbientLights();

// Export UPandoraPlayerController::execStopAmbientFans(FFrame&, void* const)
native function StopAmbientFans();

// Export UPandoraPlayerController::execStopInGameAmBX(FFrame&, void* const)
native function StopInGameAmBX();

// Export UPandoraPlayerController::execSetAmBx_N_LightColourFloat(FFrame&, void* const)
native function SetAmBx_N_LightColourFloat(float Red, float Green, float Blue);

// Export UPandoraPlayerController::execSetAmBx_NE_LightColourFloat(FFrame&, void* const)
native function SetAmBx_NE_LightColourFloat(float Red, float Green, float Blue);

// Export UPandoraPlayerController::execSetAmBx_E_LightColourFloat(FFrame&, void* const)
native function SetAmBx_E_LightColourFloat(float Red, float Green, float Blue);

// Export UPandoraPlayerController::execSetAmBx_SE_LightColourFloat(FFrame&, void* const)
native function SetAmBx_SE_LightColourFloat(float Red, float Green, float Blue);

// Export UPandoraPlayerController::execSetAmBx_S_LightColourFloat(FFrame&, void* const)
native function SetAmBx_S_LightColourFloat(float Red, float Green, float Blue);

// Export UPandoraPlayerController::execSetAmBx_SW_LightColourFloat(FFrame&, void* const)
native function SetAmBx_SW_LightColourFloat(float Red, float Green, float Blue);

// Export UPandoraPlayerController::execSetAmBx_W_LightColourFloat(FFrame&, void* const)
native function SetAmBx_W_LightColourFloat(float Red, float Green, float Blue);

// Export UPandoraPlayerController::execSetAmBx_NW_LightColourFloat(FFrame&, void* const)
native function SetAmBx_NW_LightColourFloat(float Red, float Green, float Blue);

// Export UPandoraPlayerController::execSetAmBx_C_LightColourFloat(FFrame&, void* const)
native function SetAmBx_C_LightColourFloat(float Red, float Green, float Blue);

// Export UPandoraPlayerController::execSetAmBx_N_Fan(FFrame&, void* const)
native function SetAmBx_N_Fan(float intensity);

// Export UPandoraPlayerController::execSetAmBx_NE_Fan(FFrame&, void* const)
native function SetAmBx_NE_Fan(float intensity);

// Export UPandoraPlayerController::execSetAmBx_E_Fan(FFrame&, void* const)
native function SetAmBx_E_Fan(float intensity);

// Export UPandoraPlayerController::execSetAmBx_SE_Fan(FFrame&, void* const)
native function SetAmBx_SE_Fan(float intensity);

// Export UPandoraPlayerController::execSetAmBx_S_Fan(FFrame&, void* const)
native function SetAmBx_S_Fan(float intensity);

// Export UPandoraPlayerController::execSetAmBx_SW_Fan(FFrame&, void* const)
native function SetAmBx_SW_Fan(float intensity);

// Export UPandoraPlayerController::execSetAmBx_W_Fan(FFrame&, void* const)
native function SetAmBx_W_Fan(float intensity);

// Export UPandoraPlayerController::execSetAmBx_NW_Fan(FFrame&, void* const)
native function SetAmBx_NW_Fan(float intensity);

// Export UPandoraPlayerController::execSetAmBx_C_Fan(FFrame&, void* const)
native function SetAmBx_C_Fan(float intensity);

// Export UPandoraPlayerController::execDoesThePlayerWantToUseAmBx(FFrame&, void* const)
native function bool DoesThePlayerWantToUseAmBx();

// Export UPandoraPlayerController::execSetThePlayerToUseAmBx(FFrame&, void* const)
native function SetThePlayerToUseAmBx();

// Export UPandoraPlayerController::execSetThePlayerToNOT_UseAmBx(FFrame&, void* const)
native function SetThePlayerToNOT_UseAmBx();

// Export UPandoraPlayerController::execDoesThePlayerWantToUseAmBxFullRumble(FFrame&, void* const)
native function bool DoesThePlayerWantToUseAmBxFullRumble();

// Export UPandoraPlayerController::execSetThePlayerToUseAmBxFullRumble(FFrame&, void* const)
native function SetThePlayerToUseAmBxFullRumble();

// Export UPandoraPlayerController::execSetThePlayerToNOT_UseAmBxFullRumble(FFrame&, void* const)
native function SetThePlayerToNOT_UseAmBxFullRumble();

// Export UPandoraPlayerController::execIsInPauseMenu(FFrame&, void* const)
native function bool IsInPauseMenu();

// Export UPandoraPlayerController::execSetInPauseMenu(FFrame&, void* const)
native function SetInPauseMenu();

// Export UPandoraPlayerController::execSetNOT_InPauseMenu(FFrame&, void* const)
native function SetNOT_InPauseMenu();

// Export UPandoraPlayerController::execDoesThePlayerWantToUseAmBxMediumRumble(FFrame&, void* const)
native function bool DoesThePlayerWantToUseAmBxMediumRumble();

// Export UPandoraPlayerController::execSetThePlayerToUseAmBxMediumRumble(FFrame&, void* const)
native function SetThePlayerToUseAmBxMediumRumble();

// Export UPandoraPlayerController::execSetThePlayerToNOT_UseAmBxMediumRumble(FFrame&, void* const)
native function SetThePlayerToNOT_UseAmBxMediumRumble();

// Export UPandoraPlayerController::execAreAllAmbxObjectsHidden(FFrame&, void* const)
native function bool AreAllAmbxObjectsHidden();

// Export UPandoraPlayerController::execShowAllAmbxObjects(FFrame&, void* const)
native function ShowAllAmbxObjects();

// Export UPandoraPlayerController::execHideAllAmbxObjects(FFrame&, void* const)
native function HideAllAmbxObjects();

// Export UPandoraPlayerController::execPPCBreakpoint(FFrame&, void* const)
native final function PPCBreakpoint();

// Export UPandoraPlayerController::execDoMoveTo(FFrame&, void* const)
native function DoMoveTo(Vector Loc);

// Export UPandoraPlayerController::execFindSpotToDropItemFrom(FFrame&, void* const)
native function bool FindSpotToDropItemFrom(Actor Object, out Vector droplocation);

// Export UPandoraPlayerController::execSetPerformanceSettings(FFrame&, void* const)
native function SetPerformanceSettings(int PerformanceMode);

// Export UPandoraPlayerController::execChangeGammaConsole(FFrame&, void* const)
native function ChangeGammaConsole(float gammaLevel);

// Export UPandoraPlayerController::execToggleHudNative(FFrame&, void* const)
native function ToggleHudNative();

// Export UPandoraPlayerController::execCanIDebug(FFrame&, void* const)
native function bool CanIDebug();

// Export UPandoraPlayerController::execIsWeaponDebugOn(FFrame&, void* const)
native function bool IsWeaponDebugOn();

// Export UPandoraPlayerController::execCanSpawnAtLocation(FFrame&, void* const)
native function bool CanSpawnAtLocation(out Vector chkLocation, Vector ChkExtent, Actor SpawnPointActor);

// Export UPandoraPlayerController::execGetViewportClient(FFrame&, void* const)
native static final function GameViewportClient GetViewportClient();

// Export UPandoraPlayerController::execCleanupBeforeCheckpointOrTransitionNative(FFrame&, void* const)
native function CleanupBeforeCheckpointOrTransitionNative();

// Export UPandoraPlayerController::execClientProcessCheckpointLevels(FFrame&, void* const)
reliable client native final simulated event ClientProcessCheckpointLevels(string CheckpointPackageName, string PersistentLevelName, string CheckpointPathname);

// Export UPandoraPlayerController::execDumpLevelsToScreen(FFrame&, void* const)
native function DumpLevelsToScreen(Pawn P, bool bFull, bool bPackageContent);

// Export UPandoraPlayerController::execEnableStreamingLog(FFrame&, void* const)
native function EnableStreamingLog();

// Export UPandoraPlayerController::execDisableStreamingLog(FFrame&, void* const)
native function DisableStreamingLog();

// Export UPandoraPlayerController::execGetKynapseManager(FFrame&, void* const)
native function SPKynapseManager GetKynapseManager();

// Export UPandoraPlayerController::execSetDebug(FFrame&, void* const)
native function SetDebug(bool bCanDebug);

// Export UPandoraPlayerController::execPopulateCheckPointSceneUI(FFrame&, void* const)
native function PopulateCheckPointSceneUI(UIScene Scene);

// Export UPandoraPlayerController::execCheckPointMenuLoad(FFrame&, void* const)
native function CheckPointMenuLoad(UICheckpoint Checkpoint);

// Export UPandoraPlayerController::execCheckStorageDevice(FFrame&, void* const)
native function CheckStorageDevice(out PandoraPlayerController.EDeviceValidErrorCode CheckResult);

// Export UPandoraPlayerController::execGetCurrentMovie(FFrame&, void* const)
native final function GetCurrentMovie(out string MovieName);

// Export UPandoraPlayerController::execSetMasterVolume(FFrame&, void* const)
native final function SetMasterVolume(float Value);

// Export UPandoraPlayerController::execIsRemotePlayerMuted(FFrame&, void* const)
native final function bool IsRemotePlayerMuted(UniqueNetId UniqueId);

exec function SoundDuck(string Cmd, optional int groupID = -1, optional float Value = -1.0000000)
{
    Class'Engine.Engine'.static.GetAudioDevice().spAudioDuck.ParseCommand(Cmd, groupID, Value);
    //return;    
}

event GetSavedData(out array<byte> LoadOutData)
{
    PlayerForceWriteProfile();
    // End:0x6D
    if(((SPCM != none) && SPCM.CheckpointData.Length > 0) && SPCM.CurrCheckpoint != none)
    {
        SPCM.GenerateCheckpointData();
        LoadOutData = SPCM.CheckpointData;
    }
    //return;    
}

event bool ProcessLoadout(array<byte> LoadOut)
{
    // End:0x25
    if(SPCM != none)
    {
        return SPCM.ProcessPlayerLoadout(LoadOut);
    }
    return false;
    //return ReturnValue;    
}

function ReduceSprintTime(float DeltaTime)
{
    SprintTime -= DeltaTime;
    // End:0x30
    if(SprintTime <= 0.0000000)
    {
        SprintTime = 0.0000000;
        OnSprintStop();
    }
    //return;    
}

function IgnoreFiringInput(bool bNewFiringInput)
{
    bIgnoreFiringInput = ((bNewFiringInput) ? 1 : 0);
    //return;    
}

function bool IsFiringInputIgnored()
{
    return int(bIgnoreFiringInput) > int(0);
    //return ReturnValue;    
}

reliable client simulated function ClientIgnoreFiringInput(bool bIgnore)
{
    IgnoreFiringInput(bIgnore);
    //return;    
}

function IgnoreJumpingInput(bool bNewInput)
{
    bIgnoreJumpingInput = ((bNewInput) ? 1 : 0);
    //return;    
}

function bool IsJumpingInputIgnored()
{
    return int(bIgnoreJumpingInput) > int(0);
    //return ReturnValue;    
}

reliable client simulated function ClientIgnoreJumpingInput(bool bIgnore)
{
    IgnoreJumpingInput(bIgnore);
    //return;    
}

function IgnoreCrouchingInput(bool bNewInput)
{
    bIgnoreCrouchingInput = ((bNewInput) ? 1 : 0);
    //return;    
}

function bool IsCrouchingInputIgnored()
{
    return int(bIgnoreCrouchingInput) > int(0);
    //return ReturnValue;    
}

reliable client simulated function ClientIgnoreCrouchingInput(bool bIgnore)
{
    IgnoreCrouchingInput(bIgnore);
    //return;    
}

function IgnoreSprintInput(bool bNewInput)
{
    bIgnoreSprintInput = ((bNewInput) ? 1 : 0);
    //return;    
}

function bool IsSprintInputIgnored()
{
    return int(bIgnoreSprintInput) > int(0);
    //return ReturnValue;    
}

reliable client simulated function ClientIgnoreSprintInput(bool bIgnore)
{
    IgnoreSprintInput(bIgnore);
    //return;    
}

function IgnorePauseInput(bool bNewInput)
{
    bIgnorePauseInput = ((bNewInput) ? 1 : 0);
    //return;    
}

function bool IsPauseInputIgnored()
{
    return int(bIgnorePauseInput) > int(0);
    //return ReturnValue;    
}

reliable client simulated function ClientIgnorePauseInput(bool bIgnore)
{
    IgnorePauseInput(bIgnore);
    //return;    
}

function IgnoreAnimusPulseInput(bool bNewInput)
{
    bIgnoreAnimusPulseInput = ((bNewInput) ? 1 : 0);
    //return;    
}

function bool IsAnimusPulseInputIgnored()
{
    return ((int(bIgnoreAnimusPulseInput) > int(0)) || int(bTempIgnoreAnimusPulseInput) > int(0)) || IsWeaponReloading();
    //return ReturnValue;    
}

function TempIgnoreAnimusPulseInput(bool bNewInput)
{
    bTempIgnoreAnimusPulseInput = ((bNewInput) ? 1 : 0);
    //return;    
}

reliable client simulated function ClientIgnoreAnimusPulseInput(bool bIgnore)
{
    IgnoreAnimusPulseInput(bIgnore);
    //return;    
}

function IgnoreAnimusSiphonInput(bool bNewInput)
{
    bIgnoreAnimusSiphonInput = ((bNewInput) ? 1 : 0);
    //return;    
}

function bool IsAnimusSiphonInputIgnored()
{
    return int(bIgnoreAnimusSiphonInput) > int(0);
    //return ReturnValue;    
}

reliable client simulated function ClientIgnoreAnimusSiphonInput(bool bIgnore)
{
    IgnoreAnimusSiphonInput(bIgnore);
    //return;    
}

function IgnoreLookInput(bool bNewLookInput)
{
    bIgnoreLookInput = ((bNewLookInput) ? 1 : 0);
    //return;    
}

function IgnoreMoveInput(bool bNewMoveInput)
{
    bIgnoreMoveInput = ((bNewMoveInput) ? 1 : 0);
    //return;    
}

function OnToggleInput(SeqAct_ToggleInput inAction)
{
    local bool bNewValue;

    super(PlayerController).OnToggleInput(inAction);
    // End:0x1D
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    // End:0x181
    if(inAction.InputLinks[0].bHasImpulse)
    {
        // End:0x71
        if(inAction.bToggleFiring)
        {
            IgnoreFiringInput(false);
            ClientIgnoreFiringInput(false);
            UnLookDownSite();
        }
        // End:0x9A
        if(inAction.bToggleJumping)
        {
            IgnoreJumpingInput(false);
            ClientIgnoreJumpingInput(false);
        }
        // End:0xC3
        if(inAction.bToggleCrouching)
        {
            IgnoreCrouchingInput(false);
            ClientIgnoreCrouchingInput(false);
        }
        // End:0xEC
        if(inAction.bToggleAnimusPulse)
        {
            IgnoreAnimusPulseInput(false);
            ClientIgnoreAnimusPulseInput(false);
        }
        // End:0x115
        if(inAction.bToggleAnimusSiphon)
        {
            IgnoreAnimusSiphonInput(false);
            ClientIgnoreAnimusSiphonInput(false);
        }
        // End:0x155
        if(inAction.bToggleSprinting)
        {
            IgnoreSprintInput(false);
            ClientIgnoreSprintInput(false);
            PlayerPawn(Pawn).m_bCanSprint = true;
        }
        // End:0x17E
        if(inAction.bTogglePause)
        {
            IgnorePauseInput(false);
            ClientIgnorePauseInput(false);
        }        
    }
    else
    {
        // End:0x304
        if(inAction.InputLinks[1].bHasImpulse)
        {
            // End:0x1E9
            if(inAction.bToggleFiring)
            {
                // End:0x1C8
                if(bPushedIsLookingDownSiteState)
                {
                    UnLookDownSite();
                }
                IgnoreFiringInput(true);
                ClientIgnoreFiringInput(true);
                StopFire();
            }
            // End:0x212
            if(inAction.bToggleJumping)
            {
                IgnoreJumpingInput(true);
                ClientIgnoreJumpingInput(true);
            }
            // End:0x23B
            if(inAction.bToggleCrouching)
            {
                IgnoreCrouchingInput(true);
                ClientIgnoreCrouchingInput(true);
            }
            // End:0x264
            if(inAction.bToggleAnimusPulse)
            {
                IgnoreAnimusPulseInput(true);
                ClientIgnoreAnimusPulseInput(true);
            }
            // End:0x28D
            if(inAction.bToggleAnimusSiphon)
            {
                IgnoreAnimusSiphonInput(true);
                ClientIgnoreAnimusSiphonInput(true);
            }
            // End:0x2D8
            if(inAction.bToggleSprinting)
            {
                IgnoreSprintInput(true);
                ClientIgnoreSprintInput(true);
                PlayerPawn(Pawn).m_bCanSprint = false;
                HandleSprint(false);
            }
            // End:0x301
            if(inAction.bTogglePause)
            {
                IgnorePauseInput(true);
                ClientIgnorePauseInput(true);
            }            
        }
        else
        {
            // End:0x567
            if(inAction.InputLinks[2].bHasImpulse)
            {
                // End:0x393
                if(inAction.bToggleFiring)
                {
                    bNewValue = !IsFiringInputIgnored();
                    IgnoreFiringInput(bNewValue);
                    ClientIgnoreFiringInput(bNewValue);
                    // End:0x393
                    if(bNewValue)
                    {
                        // End:0x388
                        if(bPushedIsLookingDownSiteState)
                        {
                            UnLookDownSite();
                        }
                        StopFire();
                    }
                }
                // End:0x3D9
                if(inAction.bToggleJumping)
                {
                    bNewValue = !IsJumpingInputIgnored();
                    IgnoreJumpingInput(bNewValue);
                    ClientIgnoreJumpingInput(bNewValue);
                }
                // End:0x41F
                if(inAction.bToggleCrouching)
                {
                    bNewValue = !IsCrouchingInputIgnored();
                    IgnoreCrouchingInput(bNewValue);
                    ClientIgnoreCrouchingInput(bNewValue);
                }
                // End:0x465
                if(inAction.bToggleAnimusPulse)
                {
                    bNewValue = !IsAnimusPulseInputIgnored();
                    IgnoreAnimusPulseInput(bNewValue);
                    ClientIgnoreAnimusPulseInput(bNewValue);
                }
                // End:0x4AB
                if(inAction.bToggleAnimusSiphon)
                {
                    bNewValue = !IsAnimusSiphonInputIgnored();
                    IgnoreAnimusSiphonInput(bNewValue);
                    ClientIgnoreAnimusSiphonInput(bNewValue);
                }
                // End:0x521
                if(inAction.bToggleSprinting)
                {
                    bNewValue = !IsSprintInputIgnored();
                    IgnoreSprintInput(bNewValue);
                    ClientIgnoreSprintInput(bNewValue);
                    PlayerPawn(Pawn).m_bCanSprint = !bNewValue;
                    HandleSprint(!bNewValue);
                }
                // End:0x567
                if(inAction.bTogglePause)
                {
                    bNewValue = !IsPauseInputIgnored();
                    IgnorePauseInput(bNewValue);
                    ClientIgnorePauseInput(bNewValue);
                }
            }
        }
    }
    //return;    
}

simulated event DisableInputsForLadder(bool bDisable)
{
    // End:0x14
    if(bDisable)
    {
        DoUnLookDownSite();
    }
    IgnoreFiringInput(bDisable);
    ClientIgnoreFiringInput(bDisable);
    // End:0x48
    if(bDisable)
    {
        StopFire();
    }
    IgnoreJumpingInput(bDisable);
    ClientIgnoreJumpingInput(bDisable);
    IgnoreCrouchingInput(bDisable);
    ClientIgnoreCrouchingInput(bDisable);
    IgnoreAnimusPulseInput(bDisable);
    ClientIgnoreAnimusPulseInput(bDisable);
    IgnoreAnimusSiphonInput(bDisable);
    ClientIgnoreAnimusSiphonInput(bDisable);
    IgnoreSprintInput(bDisable);
    ClientIgnoreSprintInput(bDisable);
    PlayerPawn(Pawn).m_bCanSprint = !bDisable;
    HandleSprint(!bDisable);
    //return;    
}

simulated function ClearDuckValues()
{
    bDuck = 0;
    LastDuckTime = 0.0000000;
    // End:0x3A
    if(PandoraPlayerInput(PlayerInput) != none)
    {
        PandoraPlayerInput(PlayerInput).bHoldDuck = false;
    }
    //return;    
}

simulated function bool IsWeaponSwitching()
{
    return ((Pawn != none) && Pawn.Weapon != none) && Pawn.Weapon.IsInState('WeaponEquipping') || Pawn.Weapon.IsInState('WeaponPuttingDown');
    //return ReturnValue;    
}

simulated function bool IsWeaponReloading()
{
    return ((Pawn != none) && Pawn.Weapon != none) && Pawn.Weapon.IsInState('Reloading');
    //return ReturnValue;    
}

event AddCheckpoint(string Title, string Filename, optional string MapName, optional string CheckpointName)
{
    local int Idx;

    Idx = CheckPoints.Length;
    CheckPoints.Insert(CheckPoints.Length, 1);
    CheckPoints[Idx].Title = Title;
    CheckPoints[Idx].Filename = Filename;
    CheckPoints[Idx].CheckpointMapName = MapName;
    CheckPoints[Idx].CheckpointName = CheckpointName;
    //return;    
}

function DBG_MsgPPC(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

function int GetWWMiniGameFOV()
{
    return 85;
    //return ReturnValue;    
}

exec function ForceServerFire()
{
    ServerForceServerFire();
    //return;    
}

reliable server function ServerForceServerFire()
{
    local PandoraPlayerController P;

    // End:0x28
    foreach LocalPlayerControllers(Class'PandoraPlayerController', P)
    {
        P.ForceFire();        
    }    
    //return;    
}

exec function ForceClientFire()
{
    ServerForceClientFire();
    //return;    
}

reliable server function ServerForceClientFire()
{
    local PandoraPlayerController P;

    // End:0x4B
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', P)
    {
        // End:0x4A
        if(!P.IsLocalPlayerController())
        {
            P.ClientForceFire();
        }        
    }    
    //return;    
}

reliable client simulated function ClientForceFire()
{
    ForceFire();
    //return;    
}

function ForceFire()
{
    StartFire();
    //return;    
}

exec function ct()
{
    ConsoleText();
    //return;    
}

exec function tmgoff()
{
    bTackleReenableOverride = false;
    //return;    
}

exec function getdiff()
{
    //return;    
}

exec function setdiff(int Value)
{
    ProfileSettings.SetGameDifficulty(Value);
    //return;    
}

exec function aimdottoggle()
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x69
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        mySPHud.HudScene.bEnableAimDot = !mySPHud.HudScene.bEnableAimDot;
    }
    //return;    
}

function SetSquad(SPSquad newSquad, optional bool bNoSquadRemove)
{
    // End:0x40
    if((!bNoSquadRemove && m_squad != none) && m_squad != newSquad)
    {
        m_squad.RemoveSquadMember(self, true);
    }
    m_squad = newSquad;
    //return;    
}

final function SPTeamInfo GetTeam()
{
    return SPTeamInfo(PlayerReplicationInfo.Team);
    //return ReturnValue;    
}

simulated function OnAssignSquad(SeqAct_AssignSquad Action)
{
    local SPTeamInfo myTeam;
    local name squadName;

    // End:0x17
    if(Action.SquadType == none)
    {
        return;
    }
    myTeam = GetTeam();
    // End:0x30
    if(myTeam == none)
    {
        return;
    }
    // End:0x5A
    if(!Action.SquadType.IsAssociatedWithTeam(myTeam))
    {
        return;
    }
    squadName = myTeam.GetPreDefinedSquadName(Action.SquadType.GetSelectedSquadIdx());
    myTeam.AddToSquad(self, squadName);
    //return;    
}

simulated function OnToggleSprint(SeqAct_ToggleSprint inAction)
{
    // End:0x45
    if(inAction.InputLinks[0].bHasImpulse)
    {
        IgnoreSprintInput(false);
        PlayerPawn(Pawn).m_bCanSprint = true;        
    }
    else
    {
        // End:0x95
        if(inAction.InputLinks[1].bHasImpulse)
        {
            IgnoreSprintInput(true);
            PlayerPawn(Pawn).m_bCanSprint = false;
            HandleSprint(false);            
        }
        else
        {
            PlayerPawn(Pawn).m_bCanSprint = !PlayerPawn(Pawn).m_bCanSprint;
            IgnoreSprintInput(!PlayerPawn(Pawn).m_bCanSprint);
            // End:0x108
            if(!PlayerPawn(Pawn).m_bCanSprint)
            {
                HandleSprint(false);
            }
        }
    }
    //return;    
}

simulated function OnToggleJump(SeqAct_ToggleJump inAction)
{
    // End:0x35
    if(inAction.InputLinks[0].bHasImpulse)
    {
        Pawn.bJumpCapable = true;        
    }
    else
    {
        // End:0x6A
        if(inAction.InputLinks[1].bHasImpulse)
        {
            Pawn.bJumpCapable = false;            
        }
        else
        {
            Pawn.bJumpCapable = !Pawn.bJumpCapable;
        }
    }
    IgnoreJumpingInput(!Pawn.bJumpCapable);
    //return;    
}

simulated exec function fireaxedraw()
{
    // End:0x6E
    if(((Pawn.Weapon != none) && SPWeapon(Pawn.Weapon) != none) && SPWeapon(Pawn.Weapon).WeapID == 'FireAxe')
    {
        m_bFireAxeDebugDraw = !m_bFireAxeDebugDraw;
    }
    //return;    
}

exec function MultiplayerCheat()
{
    // End:0x1B
    if(CheatManager == none)
    {
        CheatManager = new (self) CheatClass;
    }
    Say("MULTIPLAYER CHEATS ENABLED xxxx MULTIPLAYER CHEATS ENABLED xxxx MULTIPLAYER CHEATS ENABLED");
    //return;    
}

exec function ToggleMultiplayerScoreboard()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x27
    if(PGRI == none)
    {
        return;
    }
    bDisplayScoreboard = !bDisplayScoreboard;
    // End:0x71
    if(bDisplayScoreboard)
    {
        m_ScoreboardPage = 0;
        PGRI.CloseScoreboard();
        PGRI.OpenScoreboard();        
    }
    else
    {
        PGRI.CloseScoreboard();
    }
    //return;    
}

exec function ConsoleText()
{
    bEnableConsoleText = !bEnableConsoleText;
    // End:0x38
    if(bEnableConsoleText)
    {
        ClientMessage("Console text on");        
    }
    //return;    
}

reliable client simulated event ClientMessage(coerce string S, optional name Type, optional float MsgLifeTime)
{
    // End:0x10
    if(bEnableConsoleText == false)
    {
        return;
    }
    super(PlayerController).ClientMessage(S, Type, MsgLifeTime);
    //return;    
}

simulated event SetSpecialMovementValues()
{
    SprintRampDownTime = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().GetValue(Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Sprint.SprintRampDownTime);
    SprintTimeMax = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Sprint.SprintTimeMax;
    SprintTime = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Sprint.SprintTimeMax;
    SprintDurationMin = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Sprint.SprintDurationMin;
    SprintRegenTimeCrouching = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Sprint.SprintRegenTimeCrouching;
    SprintRegenTimeStanding = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Sprint.SprintRegenTimeStanding;
    SprintRegenTimeMoving = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Sprint.SprintRegenTimeMoving;
    DodgeTimeCost = playerDodgeCost;
    //return;    
}

simulated event PostBeginPlay()
{
    local GameUISceneClient mySceneClient;
    local UIInteraction UIController;
    local OnlineSubsystem.ELoginStatus Status;
    local OnlinePlayerInterface PlayerInterface;

    super(PlayerController).PostBeginPlay();
    SetSpecialMovementValues();
    tackleMinigameManager = Spawn(Class'SPTackleMinigameManager');
    m_GameplayGDTuneData = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    // End:0x57
    if(m_GameplayGDTuneData == none)
    {        
    }
    else
    {
        // End:0x16B
        if(Class'DamageMatrix'.static.GetWorldInfo() != none)
        {
            m_ThrowItemImpulse = m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.ThrowItemImpulse);
            m_ThrowItemTimingThreshold = m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.ThrowItemTimingThreshold);
            m_ThrowItemRotationOffset = (m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.ThrowItemRotationOffset) * 65536.0000000) / 360.0000000;
            m_PickupItemMaxDistance = m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.PickupItemMaxDistance);
            m_PickupItemMinFacingAngle = (90.0000000 - m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.PickupItemMinFacingAngle)) / 90.0000000;
            m_CarrySocket = m_GameplayGDTuneData.CarrySocket;
        }
    }
    // End:0x1B2
    if(SPCM == none)
    {
        // End:0x18A
        foreach AllActors(Class'PandoraCheckpointManager', SPCM)
        {
            // End:0x18A
            break;            
        }        
        // End:0x1AF
        if(SPCM == none)
        {
            SPCM = Spawn(Class'PandoraCheckpointManager');
        }        
    }
    // End:0x1E8
    if(WorldInfo.IsConsoleBuild(1))
    {
        PlatformStrings = "<Strings:PlatformXbox.";        
    }
    else
    {
        // End:0x21E
        if(!WorldInfo.IsConsoleBuild(2))
        {
            PlatformStrings = "<Strings:PlatformPc.";            
        }
        else
        {
            PlatformStrings = "<Strings:platformPS3.";
        }
    }
    // End:0x266
    if(m_GameplayGDTuneData != none)
    {
        AnimusButton.DoubleClickTime = m_GameplayGDTuneData.AnimusPulseDoubleClickTime;
    }
    SetFatigueAmount(0.0000000);
    bResetPickupMessageActorState = true;
    // End:0x2C4
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        PandoraGameInfo(WorldInfo.Game).ResetRadar();
        TurnOffRadar();
    }
    UIController = GetUIController();
    // End:0x30D
    if(UIController != none)
    {
        mySceneClient = UIController.SceneClient;
        // End:0x30D
        if(mySceneClient != none)
        {
            mySceneClient.bOverrideEmulateButtonPress = false;
        }
    }
    Status = 0;
    // End:0x392
    if(OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x37A
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            Status = PlayerInterface.GetLoginStatus(byte(LocalPlayer(Player).ControllerId));
        }
        // End:0x392
        if(int(Status) == int(0))
        {
            startedSPGameWithoutProfile = true;
        }
    }
    //return;    
}

function bool GetOverrideFOV(out float overrideFOV)
{
    overrideFOV = overRideGlobalFOV;
    return overRideGlobalFOV != 0.0000000;
    //return ReturnValue;    
}

function TickCantBeTackledTime(float Time)
{
    // End:0x2A
    if(CantBeTackledTime > 0.0000000)
    {
        CantBeTackledTime -= Time;
        // End:0x2A
        if(CantBeTackledTime < 0.0000000)
        {
        }
    }
    //return;    
}

function NoLongerBeingTackled()
{
    CantBeTackledTime = 15.0000000;
    // End:0x2A
    if(tackleMinigameManager != none)
    {
        tackleMinigameManager.EndTackleMinigame();
    }
    //return;    
}

function bool CanBeTackled()
{
    // End:0x0D
    if(!bTackleReenableOverride)
    {
        return false;
    }
    // End:0x1E
    if(CantBeTackledTime > 0.0000000)
    {
        return false;
    }
    // End:0x2D
    if(IsBeingTackled())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool IsBeingTackled()
{
    switch(m_actionState)
    {
        // End:0x0D
        case 8:
        // End:0x12
        case 9:
        // End:0x17
        case 11:
        // End:0x1C
        case 12:
        // End:0x21
        case 13:
        // End:0x26
        case 14:
        // End:0x2B
        case 15:
        // End:0x30
        case 16:
        // End:0x35
        case 17:
        // End:0x3C
        case 18:
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }
    //return ReturnValue;    
}

function StopFiringFromHandToHand()
{
    // End:0x24
    if(Pawn != none)
    {
        Pawn.StopFire(m_HandToHandFireModeNum);
    }
    //return;    
}

function CheckJumpOrDuck()
{
    // End:0x23
    if(bPressedJump)
    {
        Pawn.DoJump(bUpdating);
    }
    // End:0xBF
    if((int(Pawn.Physics) != int(2)) && Pawn.bCanCrouch)
    {
        // End:0x67
        if(IsCrouchingInputIgnored())
        {
            bDuck = 0;
        }
        Pawn.ShouldCrouch((int(bDuck) != int(0)) && (WorldInfo.TimeSeconds > (LastDuckTime + 0.5000000)) || Pawn.bWantsToCrouch);
    }
    //return;    
}

simulated function FireAxeFailSafeReset()
{
    // End:0x46
    if(PlayerPawn(Pawn).m_bFireAxeReset)
    {
        PlayerPawn(Pawn).m_bHandToHandFiring = false;
        PlayerPawn(Pawn).m_fireAxeState = 3;
    }
    //return;    
}

simulated event bool IsPlayingMovieOrCinematic()
{
    local PandoraGameInfo GameInfo;
    local PandoraGameViewportClient pvc;

    pvc = PandoraGameViewportClient(GetViewportClient());
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x78
    if(((GameInfo != none) && GameInfo.IsInCinematic()) || (pvc != none) && pvc.FullScreenIsMoviePlaying())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool CanSiphonOrHeal()
{
    local PandoraGameInfo GameInfo;
    local PandoraGameViewportClient pvc;

    pvc = PandoraGameViewportClient(GetViewportClient());
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x3A
    if(IsAnimusSiphonInputIgnored())
    {
        return false;
    }
    // End:0x58
    if(PlayerPawn(Pawn).GetIsPartiallyLookingDownSite())
    {
        return false;
    }
    // End:0x6D
    if(Pawn.bPlayedDeath)
    {
        return false;
    }
    // End:0xBA
    if(((GameInfo != none) && GameInfo.IsInCinematic()) || (pvc != none) && pvc.FullScreenIsMoviePlaying())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function bool CheckIfWithinAnimusUseTrigger()
{
    local array<Trigger> useList;
    local int TriggerIdx, EventIdx;
    local SeqEvent_Used UseSeq;
    local Trigger checkTrigger;
    local PlayerPawn PP;
    local float TriggerDot;

    PP = PlayerPawn(Pawn);
    // End:0x16D
    if(PP != none)
    {
        TriggerDot = m_GameplayGDTuneData.TriggerDotRange;
        // End:0x4D
        if(TriggerDot > 1.0000000)
        {
            TriggerDot = 1.0000000;            
        }
        else
        {
            // End:0x67
            if(TriggerDot < 0.0000000)
            {
                TriggerDot = 0.0000000;
            }
        }
        GetTriggerUseList(InteractDistance, 1024.0000000, 0.0000000, false, useList, TriggerDot);
        TriggerIdx = 0;
        J0x92:

        // End:0x16D [Loop If]
        if(TriggerIdx < useList.Length)
        {
            checkTrigger = useList[TriggerIdx];
            // End:0x163
            if(checkTrigger != none)
            {
                EventIdx = 0;
                J0xC5:

                // End:0x163 [Loop If]
                if(EventIdx < checkTrigger.GeneratedEvents.Length)
                {
                    UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[EventIdx]);
                    // End:0x159
                    if(UseSeq != none)
                    {
                        // End:0x159
                        if(UseSeq.bOverrideUseButton)
                        {
                            // End:0x159
                            if(UseSeq.DoGameSpecificChecksPass(PP) && PP.WouldCheckActivateTestsPass(UseSeq))
                            {
                                return true;
                            }
                        }
                    }
                    EventIdx++;
                    // [Loop Continue]
                    goto J0xC5;
                }
            }
            TriggerIdx++;
            // [Loop Continue]
            goto J0x92;
        }
    }
    return false;
    //return ReturnValue;    
}

function AttemptSiphonOrHeal()
{
    local SPPawn SPPawn;

    SPPawn = SPPawn(Pawn);
    // End:0x21
    if(!CanSiphonOrHeal())
    {
        return;
    }
    // End:0xAE
    if(CheckIfWithinAnimusUseTrigger())
    {
        // End:0xA2
        if((SPPawn != none) && SPPawn.IsReloading())
        {
            // End:0xA2
            if((Pawn.Weapon != none) && SPWeapon(Pawn.Weapon) != none)
            {
                SPWeapon(Pawn.Weapon).ForceInterruptReload();
            }
        }
        AnimusUse();
        return;
    }
    PandoraPlayerInput(PlayerInput).Outer.AnimusButton.PressedTime = 0.0000000;
    // End:0x131
    if(PandoraPlayerInput(PlayerInput).QueryCanSiphon() != 0)
    {
        PandoraPlayerInput(PlayerInput).UnHeal();
        PandoraPlayerInput(PlayerInput).Siphon();        
    }
    else
    {
        PandoraPlayerInput(PlayerInput).UnSiphon();
        PandoraPlayerInput(PlayerInput).Heal();
    }
    //return;    
}

function AttemptAnimusPulse()
{
    local SPPawn SPPawn;
    local PlayerPawn PlayerPawn;
    local PandoraGameInfo GameInfo;
    local PandoraGameViewportClient pvc;
    local bool bIsDead, bIsInWWTackle;

    pvc = PandoraGameViewportClient(GetViewportClient());
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x3A
    if(IsAnimusPulseInputIgnored())
    {
        return;
    }
    // End:0x85
    if((WorldInfo != none) && WorldInfo.m_bAnimusPulseDisable || WorldInfo.GetMapName() == "EP01_NYC_MASTER")
    {
        return;
    }
    // End:0xD2
    if(((GameInfo != none) && GameInfo.IsInCinematic()) || (pvc != none) && pvc.FullScreenIsMoviePlaying())
    {
        return;
    }
    SPPawn = SPPawn(Pawn);
    // End:0x175
    if(SPPawn != none)
    {
        PlayerPawn = PlayerPawn(Pawn);
        bIsDead = IsDead();
        bIsInWWTackle = IsInWerewolfTackleState();
        // End:0x172
        if((((PlayerPawn != none) && PlayerPawn.Health > 0) && !bIsDead) && !bIsInWWTackle)
        {
            PlayerPawn.AttemptAnimusPulse();            
        }        
    }
    //return;    
}

function CheckDodgeCombine(out Actor.EDoubleClickDir setForceDodgeMove)
{
    local float MaxInput;

    setForceDodgeMove = 0;
    // End:0xDA
    if((SPPawn(Pawn) != none) && bDodgeCombineDown)
    {
        MaxInput = FMax(Abs(PlayerInput.RawJoyUp), Abs(PlayerInput.RawJoyRight));
        // End:0xDA
        if(MaxInput > 0.7500000)
        {
            // End:0xB0
            if(Abs(PlayerInput.RawJoyUp) > Abs(PlayerInput.RawJoyRight))
            {
                // End:0xA5
                if(PlayerInput.RawJoyUp > float(0))
                {
                    setForceDodgeMove = 3;                    
                }
                else
                {
                    setForceDodgeMove = 4;
                }                
            }
            else
            {
                // End:0xD2
                if(PlayerInput.RawJoyRight > float(0))
                {
                    setForceDodgeMove = 2;                    
                }
                else
                {
                    setForceDodgeMove = 1;
                }
            }
        }
    }
    //return;    
}

event ApplyPawnLoadOut(int Animus, int Health)
{
    local PlayerPawn myPawn;

    // End:0xE1
    if(Pawn != none)
    {
        myPawn = PlayerPawn(Pawn);
        myPawn.LifeForce = float(Animus);
        myPawn.bNetDirty = true;
        myPawn.Health = Health;
        // End:0xB2
        if((myPawn.Health < 1) || myPawn.Health > myPawn.HealthMax)
        {
            myPawn.Health = myPawn.HealthMax;
        }
        bShouldApplyCached = false;
        PandoraGameInfo(WorldInfo.Game).ApplyCheckpointLoadout(self);        
    }
    else
    {
        cachedPawnAnimus = Animus;
        cachedPawnHealth = Health;
        bShouldApplyCached = true;
        PandoraGameInfo(WorldInfo.Game).LoadWeaponPacks(self);
    }
    //return;    
}

event Possess(Pawn aPawn, bool bVehicleTransition)
{
    super(PlayerController).Possess(aPawn, bVehicleTransition);
    // End:0x2E
    if(bShouldApplyCached)
    {
        ApplyPawnLoadOut(cachedPawnAnimus, cachedPawnHealth);
    }
    KynapseComponent.Init();
    //return;    
}

exec function TogglePhysicsMode()
{
    //return;    
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
    // End:0x4F
    if(Caps(GetCurrentLevelName()) != "PANDORASTART")
    {
        ForceStopAmBxScript("WeaponStopAll");
        ForceStopAmBxScript("MenuStopAll");
    }
    super(PlayerController).ClientRestart(NewPawn);
    PlayerPawn(NewPawn).DoAmBXWork(self);
    //return;    
}

reliable client simulated function ClientPickupWeapons()
{
    PlayAmBxScript("player_pickup", 500);
    //return;    
}

reliable client simulated function ClientStopInGameAmBX()
{
    StopInGameAmBX();
    //return;    
}

simulated function bool ShouldDisableSwitchToBestWeapon()
{
    return bDisableSwitchToBestWeapon;
    //return ReturnValue;    
}

exec function ScrollPrevWeapon()
{
    // End:0x1C
    if(!IsWeaponSwitching())
    {
        ChangeWeapon(false, true, false);
    }
    //return;    
}

exec function ScrollNextWeapon()
{
    // End:0x1C
    if(!IsWeaponSwitching())
    {
        ChangeWeapon(true, true, true);
    }
    //return;    
}

exec function PrevWeapon()
{
    ChangeWeapon(false, false, false);
    //return;    
}

exec function NextWeapon()
{
    ChangeWeapon(true, false, false);
    //return;    
}

simulated function ChangeWeapon(bool bUseNextWeapon, bool bUseScrolling, bool bUseScrollingNext)
{
    local int slot;
    local PandoraGameInfo GameInfo;
    local SPInventoryManager spInvManager;
    local PlayerPawn pPawn;
    local Weapon scrolledToWeapon;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    spInvManager = SPInventoryManager(Pawn.InvManager);
    pPawn = PlayerPawn(Pawn);
    // End:0x53
    if(IsFiringInputIgnored())
    {
        return;
    }
    // End:0x95
    if((pPawn != none) && pPawn.GetIsPartiallyLookingDownSite() || int(pPawn.m_eGrenadeState) != int(0))
    {
        return;
    }
    // End:0xBB
    if((GameInfo != none) && GameInfo.IsInCinematic())
    {
        return;
    }
    // End:0x11C
    if(IsWeaponReloading())
    {
        // End:0x11C
        if((Pawn.Weapon != none) && SPWeapon(Pawn.Weapon) != none)
        {
            SPWeapon(Pawn.Weapon).ForceInterruptReload();
        }
    }
    // End:0x127
    if(bHoldUse)
    {
        return;
    }
    // End:0x13E
    if(WorldInfo.Pauser != none)
    {
        return;
    }
    // End:0x164
    if(IsLocalPlayerController())
    {
        ForceStopAmBxScript("WeaponStopAll");
    }
    // End:0x186
    if(Pawn.Weapon == none)
    {
        SwitchToBestWeapon();
        return;
    }
    // End:0x348
    if(((spInvManager != none) && !pPawn.IsSiphoning()) && !IsInWerewolfTackleState())
    {
        pPawn.m_eGrenadeState = 0;
        // End:0x1F1
        if(pPawn.GetIsPartiallyLookingDownSite())
        {
            UnLookDownSite();
        }
        // End:0x263
        if(!bUseScrolling)
        {
            slot = 1;
            // End:0x22C
            if(Pawn.Weapon.IsRightWeapon())
            {
                slot = 3;
            }
            // End:0x24C
            if(bUseNextWeapon)
            {
                spInvManager.NextWeapon();                
            }
            else
            {
                spInvManager.PrevWeapon();
            }            
        }
        else
        {
            scrolledToWeapon = spInvManager.ScrollAllWeapons(bUseScrollingNext);
            // End:0x2B1
            if((scrolledToWeapon == none) || scrolledToWeapon.IsRightWeapon())
            {
                slot = 1;                
            }
            else
            {
                // End:0x2D3
                if(scrolledToWeapon.IsLeftWeapon())
                {
                    slot = 3;                    
                }
                else
                {
                    slot = 2;
                }
            }
        }
        SetWeaponSwapEffect(0.0000000, GetTopWeapID(), GetRightWeapID(), GetLeftWeapID(), GetBottomWeapID(), slot);
        SetTimer(m_GameplayGDTuneData.SwitchWeaponFadeOutTimer, false, 'TimerWeaponSwapFade');
        pPawn.DisableAnimusActivitiesFromClient();
    }
    //return;    
}

simulated function name GetTopWeapID()
{
    local SPInventoryManager spInvManager;

    spInvManager = SPInventoryManager(Pawn.InvManager);
    // End:0x2F
    if(spInvManager == none)
    {
        return 'Explosive';
    }
    // End:0x60
    if(int(spInvManager.curGrenadeType) == int(spInvManager.1))
    {
        return 'Explosive';        
    }
    else
    {
        // End:0x8E
        if(int(spInvManager.curGrenadeType) == int(spInvManager.2))
        {
            return 'Molotov';
        }
    }
    return 'None';
    //return ReturnValue;    
}

simulated function name GetRightWeapID()
{
    local SPInventoryManager spInvManager;
    local SPWeapon rightWeapon;

    spInvManager = SPInventoryManager(Pawn.InvManager);
    // End:0x2F
    if(spInvManager == none)
    {
        return 'None';
    }
    rightWeapon = spInvManager.GetRightWeaponInInventory();
    // End:0x64
    if(rightWeapon != none)
    {
        return rightWeapon.WeapID;
    }
    return 'None';
    //return ReturnValue;    
}

simulated function name GetLeftWeapID()
{
    local SPInventoryManager spInvManager;
    local SPWeapon leftWeapon;

    spInvManager = SPInventoryManager(Pawn.InvManager);
    // End:0x2F
    if(spInvManager == none)
    {
        return 'None';
    }
    leftWeapon = spInvManager.GetLeftWeaponInInventory();
    // End:0x64
    if(leftWeapon != none)
    {
        return leftWeapon.WeapID;
    }
    return 'None';
    //return ReturnValue;    
}

simulated function name GetBottomWeapID()
{
    local SPInventoryManager spInvManager;
    local SPWeapon meleeWeapon;

    spInvManager = SPInventoryManager(Pawn.InvManager);
    // End:0x2F
    if(spInvManager == none)
    {
        return 'None';
    }
    meleeWeapon = spInvManager.GetMeleeWeaponInInventory();
    // End:0x64
    if(meleeWeapon != none)
    {
        return meleeWeapon.WeapID;
    }
    return 'None';
    //return ReturnValue;    
}

exec function EquipMeleeWeapon()
{
    local SPWeapon SwapToWeapon;
    local PandoraGameInfo GameInfo;
    local PlayerPawn pPawn;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x31
    if(WorldInfo.Pauser != none)
    {
        return;
    }
    pPawn = PlayerPawn(Pawn);
    // End:0x92
    if((pPawn != none) && (pPawn.GetIsPartiallyLookingDownSite() || int(pPawn.m_eGrenadeState) != int(0)) || IsWeaponSwitching())
    {
        return;
    }
    // End:0xB8
    if((GameInfo != none) && GameInfo.IsInCinematic())
    {
        return;
    }
    // End:0x1A6
    if(((SPInventoryManager(Pawn.InvManager) != none) && !pPawn.IsSiphoning()) && !IsInWerewolfTackleState())
    {
        SwapToWeapon = SPWeapon(SPInventoryManager(Pawn.InvManager).SwitchToMeleeWeapon());
        // End:0x1A6
        if(SwapToWeapon != none)
        {
            SetWeaponSwapEffect(0.0000000, GetTopWeapID(), GetRightWeapID(), GetLeftWeapID(), SwapToWeapon.WeapID, 2);
            SetTimer(m_GameplayGDTuneData.SwitchWeaponFadeOutTimer, false, 'TimerWeaponSwapFade');
            pPawn.DisableAnimusActivitiesFromClient();
        }
    }
    //return;    
}

simulated function CleanupWeapons()
{
    local SPInventoryManager spInvManager;
    local SPWeapon myWeapon;
    local Inventory Item;

    spInvManager = SPInventoryManager(Pawn.InvManager);
    // End:0x27
    if(spInvManager == none)
    {
        return;
    }
    Item = spInvManager.InventoryChain;
    J0x3C:

    // End:0x8E [Loop If]
    if(Item != none)
    {
        myWeapon = SPWeapon(Item);
        // End:0x76
        if(myWeapon != none)
        {
            myWeapon.CleanupPreMapChange();
        }
        Item = Item.Inventory;
        // [Loop Continue]
        goto J0x3C;
    }
    //return;    
}

reliable client simulated function ClientSetNewAmmoPickupDisplay(name WeapID, float Time, int PickedUpAmmoCount, optional int GrenadeType = -1)
{
    local string Message;

    // End:0x39
    if(GrenadeType == -1)
    {
        Message = string(PickedUpAmmoCount) @ Class'SPInventoryManager'.default.WordRounds;        
    }
    else
    {
        switch(GrenadeType)
        {
            // End:0x66
            case 0:
                Message = string(PickedUpAmmoCount) @ Class'SPInventoryManager'.default.WordFlares;
                // End:0xE5
                break;
            // End:0x8B
            case 1:
                Message = string(PickedUpAmmoCount) @ Class'SPInventoryManager'.default.WordGrenades;
                // End:0xE5
                break;
            // End:0xB1
            case 2:
                Message = string(PickedUpAmmoCount) @ Class'SPInventoryManager'.default.WordMolotovs;
                // End:0xE5
                break;
            // End:0xD7
            case 3:
                Message = string(PickedUpAmmoCount) @ Class'SPInventoryManager'.default.WordTasers;
                // End:0xE5
                break;
            // End:0xFFFF
            default:
                Message = "";
                // End:0xE5
                break;
                break;
        }
    }
    SetNewAmmoPickupDisplay(WeapID, Time, Message);
    //return;    
}

reliable client simulated function ClientAmmoBarAndPickupWeaponBarFadeIn(optional float InFadeInTime = 0.5000000)
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x81
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        mySPHud.HudScene.AmmoBarFadeIn(InFadeInTime);
        mySPHud.HudScene.PickupWeaponBarFadeIn(InFadeInTime);
    }
    //return;    
}

simulated function SetNewAmmoPickupDisplay(name WeapID, float Time, string Message)
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x2F9
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        // End:0x24E
        if(mySPHud.HudScene.bUsingPickupSlot1)
        {
            // End:0x15D
            if(mySPHud.HudScene.bUsingPickupSlot2)
            {
                mySPHud.HudScene.bShowPickupPanel3 = false;
                mySPHud.HudScene.PickupPanelSlot3FadeIn(mySPHud.HudScene.GetPickupSlot2WeapID(), mySPHud.HudScene.GetPickupSlotOpacity(mySPHud.HudScene.GetPickupSlot2Panel(), mySPHud.HudScene.GetPickupSlot2Label()));
                ClearTimer('TimerNewAmmoPickupSlot3Fade');
                SetTimer(0.0100000, true, 'TimerNewAmmoPickupSlot3Fade');
                mySPHud.HudScene.bUsingPickupSlot3 = true;
            }
            mySPHud.HudScene.bShowPickupPanel2 = false;
            mySPHud.HudScene.PickupPanelSlot2FadeIn(mySPHud.HudScene.GetPickupSlot1WeapID(), mySPHud.HudScene.GetPickupSlotOpacity(mySPHud.HudScene.GetPickupSlot1Panel(), mySPHud.HudScene.GetPickupSlot1Label()));
            ClearTimer('TimerNewAmmoPickupSlot2Fade');
            SetTimer(0.0100000, true, 'TimerNewAmmoPickupSlot2Fade');
            mySPHud.HudScene.bUsingPickupSlot2 = true;
        }
        mySPHud.HudScene.bShowPickupPanel1 = false;
        mySPHud.HudScene.PickupPanelSlot1FadeIn(WeapID, Time, Message);
        ClearTimer('TimerNewAmmoPickupSlot1FadeOut');
        ClearTimer('TimerNewAmmoPickupSlot1Fade');
        SetTimer(0.4000000, false, 'TimerNewAmmoPickupSlot1FadeOut');
        SetTimer(0.0100000, true, 'TimerNewAmmoPickupSlot1Fade');
        mySPHud.HudScene.bUsingPickupSlot1 = true;
    }
    //return;    
}

simulated function TimerNewAmmoPickupSlot1FadeOut()
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x50
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        mySPHud.HudScene.PickupPanelSlot1Fade();
    }
    //return;    
}

simulated function TimerNewAmmoPickupSlot1Fade()
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0xBB
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        // End:0xBB
        if(mySPHud.HudScene.PickupSlotMaterialFade(mySPHud.HudScene.GetPickupSlot1Panel(), mySPHud.HudScene.GetPickupSlot1Label()))
        {
            ClearTimer('TimerNewAmmoPickupSlot1Fade');
            mySPHud.HudScene.bUsingPickupSlot1 = false;
        }
    }
    //return;    
}

simulated function TimerNewAmmoPickupSlot2Fade()
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0xBB
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        // End:0xBB
        if(mySPHud.HudScene.PickupSlotMaterialFade(mySPHud.HudScene.GetPickupSlot2Panel(), mySPHud.HudScene.GetPickupSlot2Label()))
        {
            ClearTimer('TimerNewAmmoPickupSlot2Fade');
            mySPHud.HudScene.bUsingPickupSlot2 = false;
        }
    }
    //return;    
}

simulated function TimerNewAmmoPickupSlot3Fade()
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0xBB
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        // End:0xBB
        if(mySPHud.HudScene.PickupSlotMaterialFade(mySPHud.HudScene.GetPickupSlot3Panel(), mySPHud.HudScene.GetPickupSlot3Label()))
        {
            ClearTimer('TimerNewAmmoPickupSlot3Fade');
            mySPHud.HudScene.bUsingPickupSlot3 = false;
        }
    }
    //return;    
}

simulated function FadeOutGrenadeMolotovBoxTimer(bool bSnapOut, MaterialInstanceConstant MatInst)
{
    m_GrenadeMolotovBarMaterial = MatInst;
    // End:0x21
    if(bSnapOut)
    {
        TimerGrenadeMolotovBoxFadeOut(true);
        return;
    }
    SetTimer(0.0100000, true, 'TimerGrenadeMolotovBoxFadeOut');
    //return;    
}

simulated function TimerGrenadeMolotovBoxFadeOut(bool bSnapFade)
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x6E
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        // End:0x6E
        if(mySPHud.HudScene.FadeOutGrenadeMolotovBox(bSnapFade, m_GrenadeMolotovBarMaterial))
        {
            ClearTimer('TimerGrenadeMolotovBoxFadeOut');
        }
    }
    //return;    
}

simulated function FadeInGrenadeMolotovBoxTimer(bool bSnapIn, MaterialInstanceConstant MatInst)
{
    m_GrenadeMolotovBarMaterial = MatInst;
    // End:0x21
    if(bSnapIn)
    {
        TimerGrenadeMolotovBoxFadeIn(true);
        return;
    }
    SetTimer(0.0100000, true, 'TimerGrenadeMolotovBoxFadeIn');
    //return;    
}

simulated function TimerGrenadeMolotovBoxFadeIn(bool bSnapIn)
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x6E
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        // End:0x6E
        if(mySPHud.HudScene.FadeInGrenadeMolotovBox(bSnapIn, m_GrenadeMolotovBarMaterial))
        {
            ClearTimer('TimerGrenadeMolotovBoxFadeIn');
        }
    }
    //return;    
}

simulated function DisableDuckDisplay(float Time)
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x55
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        mySPHud.HudScene.CrouchPanelFadeOut(Time);
    }
    //return;    
}

simulated function EnableDuckDisplay(float Time)
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x55
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        mySPHud.HudScene.CrouchPanelFadeIn(Time);
    }
    //return;    
}

simulated function TimerWeaponSwapMaterialFade()
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x63
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        // End:0x63
        if(mySPHud.HudScene.WeaponSwapMaterialFade())
        {
            ClearTimer('TimerWeaponSwapMaterialFade');
        }
    }
    //return;    
}

simulated function TimerWeaponSwapFade()
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x73
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        mySPHud.HudScene.WeaponSwapFade();
        ClearTimer('TimerWeaponSwapMaterialFade');
        SetTimer(0.0100000, true, 'TimerWeaponSwapMaterialFade');
    }
    //return;    
}

simulated function SetWeaponSwapEffect(float Time, name TopWeapID, name RightWeapID, name LeftWeapID, name BottomWeapID, int slot)
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x8B
    if((mySPHud != none) && mySPHud.HudScene != none)
    {
        mySPHud.HudScene.WeaponSwapBarFadeIn(Time, TopWeapID, RightWeapID, LeftWeapID, BottomWeapID, slot);
        SetTimer(m_GameplayGDTuneData.SwitchWeaponFadeOutTimer, false, 'TimerWeaponSwapFade');
    }
    //return;    
}

exec function EquipLeftWeapon()
{
    local SPWeapon SwapToWeapon;
    local PlayerPawn pPawn;
    local PandoraGameInfo GameInfo;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    pPawn = PlayerPawn(Pawn);
    // End:0x41
    if(WorldInfo.Pauser != none)
    {
        return;
    }
    // End:0x92
    if((pPawn != none) && (pPawn.GetIsPartiallyLookingDownSite() || int(pPawn.m_eGrenadeState) != int(0)) || IsWeaponSwitching())
    {
        return;
    }
    // End:0xB8
    if((GameInfo != none) && GameInfo.IsInCinematic())
    {
        return;
    }
    // End:0x119
    if(IsWeaponReloading())
    {
        // End:0x119
        if((Pawn.Weapon != none) && SPWeapon(Pawn.Weapon) != none)
        {
            SPWeapon(Pawn.Weapon).ForceInterruptReload();
        }
    }
    // End:0x208
    if(((SPInventoryManager(Pawn.InvManager) != none) && !pPawn.IsSiphoning()) && !IsInWerewolfTackleState())
    {
        SwapToWeapon = SPWeapon(SPInventoryManager(Pawn.InvManager).SwitchStoredWeapon(false));
        // End:0x208
        if(SwapToWeapon != none)
        {
            SetWeaponSwapEffect(0.0000000, GetTopWeapID(), GetRightWeapID(), SwapToWeapon.WeapID, GetBottomWeapID(), 3);
            SetTimer(m_GameplayGDTuneData.SwitchWeaponFadeOutTimer, false, 'TimerWeaponSwapFade');
            pPawn.DisableAnimusActivitiesFromClient();
        }
    }
    //return;    
}

exec function EquipRightWeapon()
{
    local SPWeapon SwapToWeapon;
    local PlayerPawn pPawn;
    local PandoraGameInfo GameInfo;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    pPawn = PlayerPawn(Pawn);
    // End:0x41
    if(WorldInfo.Pauser != none)
    {
        return;
    }
    // End:0x92
    if((pPawn != none) && (pPawn.GetIsPartiallyLookingDownSite() || int(pPawn.m_eGrenadeState) != int(0)) || IsWeaponSwitching())
    {
        return;
    }
    // End:0xB8
    if((GameInfo != none) && GameInfo.IsInCinematic())
    {
        return;
    }
    // End:0x119
    if(IsWeaponReloading())
    {
        // End:0x119
        if((Pawn.Weapon != none) && SPWeapon(Pawn.Weapon) != none)
        {
            SPWeapon(Pawn.Weapon).ForceInterruptReload();
        }
    }
    // End:0x207
    if(((SPInventoryManager(Pawn.InvManager) != none) && !pPawn.IsSiphoning()) && !IsInWerewolfTackleState())
    {
        SwapToWeapon = SPWeapon(SPInventoryManager(Pawn.InvManager).SwitchStoredWeapon(true));
        // End:0x207
        if(SwapToWeapon != none)
        {
            SetWeaponSwapEffect(0.0000000, GetTopWeapID(), SwapToWeapon.WeapID, GetLeftWeapID(), GetBottomWeapID(), 1);
            SetTimer(m_GameplayGDTuneData.SwitchWeaponFadeOutTimer, false, 'TimerWeaponSwapFade');
            pPawn.DisableAnimusActivitiesFromClient();
        }
    }
    //return;    
}

exec function NextGrenade()
{
    local SPInventoryManager spInvManager;
    local SPHud mySPHud;
    local int curGrenade, grenadesChecked;
    local bool HasAmmo;

    mySPHud = GetSPHud();
    spInvManager = SPInventoryManager(Pawn.InvManager);
    // End:0x37
    if(spInvManager == none)
    {
        return;
    }
    // End:0x85
    if((int(PlayerPawn(Pawn).m_eGrenadeState) != int(0)) && spInvManager.GetGrenadeAmmo(int(spInvManager.curGrenadeType)) > 0)
    {
        return;
    }
    HasAmmo = false;
    curGrenade = 0;
    J0x94:

    // End:0xE0 [Loop If]
    if(curGrenade < int(spInvManager.5))
    {
        // End:0xD6
        if(spInvManager.GetGrenadeAmmo(curGrenade) > 0)
        {
            HasAmmo = true;
            // [Explicit Break]
            goto J0xE0;
        }
        curGrenade++;
        // [Loop Continue]
        goto J0x94;
    }
    J0xE0:

    // End:0xED
    if(!HasAmmo)
    {
        return;
    }
    curGrenade = int(spInvManager.curGrenadeType);
    grenadesChecked = 0;
    J0x10B:

    // End:0x218 [Loop If]
    if(grenadesChecked < int(spInvManager.5))
    {
        curGrenade++;
        // End:0x149
        if(curGrenade >= int(spInvManager.5))
        {
            curGrenade = 0;
        }
        // End:0x20E
        if(((spInvManager.GetGrenadeAmmo(curGrenade) > 0) && int(spInvManager.curGrenadeType) != int(spInvManager.0)) && int(spInvManager.curGrenadeType) != int(spInvManager.3))
        {
            spInvManager.curGrenadeType = byte(curGrenade);
            // End:0x1F2
            if(mySPHud != none)
            {
                mySPHud.HudScene.bApplyGlowForPickupChange = true;
            }
            spInvManager.PlayGrenadeSwitchSound(Class'SPGrenadeLauncherPersistent');
            // [Explicit Break]
            goto J0x218;
        }
        grenadesChecked++;
        // [Loop Continue]
        goto J0x10B;
    }
    J0x218:

    curGrenade = 0;
    J0x21F:

    // End:0x2AD [Loop If]
    if(curGrenade < int(spInvManager.5))
    {
        // End:0x2A3
        if(spInvManager.GetGrenadeAmmo(curGrenade) > 0)
        {
            mySPHud.HudScene.UpdateGrenadeCount(spInvManager.GetGrenadeAmmo(curGrenade), curGrenade, int(spInvManager.curGrenadeType));
        }
        curGrenade++;
        // [Loop Continue]
        goto J0x21F;
    }
    // End:0x30B
    if(int(spInvManager.curGrenadeType) == int(spInvManager.1))
    {
        SetWeaponSwapEffect(0.0000000, 'Explosive', GetRightWeapID(), GetLeftWeapID(), GetBottomWeapID(), 0);        
    }
    else
    {
        // End:0x366
        if(int(spInvManager.curGrenadeType) == int(spInvManager.2))
        {
            SetWeaponSwapEffect(0.0000000, 'Molotov', GetRightWeapID(), GetLeftWeapID(), GetBottomWeapID(), 0);
        }
    }
    SetTimer(m_GameplayGDTuneData.SwitchWeaponFadeOutTimer, false, 'TimerWeaponSwapFade');
    //return;    
}

exec function StartFire(optional byte FireModeNum)
{
    local PlayerPawn thePawn;

    // End:0x28
    if(WorldInfo.Pauser == PlayerReplicationInfo)
    {
        SetPause(false);
        return;
    }
    // End:0x37
    if(IsFiringInputIgnored())
    {
        return;
    }
    // End:0x55
    if((IsWeaponSwitching()) || IsSprinting())
    {
        return;
    }
    // End:0x87
    if(MountedWeapon != none)
    {
        // End:0x84
        if(int(FireModeNum) == int(0))
        {
            MountedWeapon.StartFire();
        }        
    }
    else
    {
        // End:0x201
        if((Pawn != none) && !bCinematicMode)
        {
            thePawn = PlayerPawn(Pawn);
            // End:0xBA
            if(thePawn != none)
            {
            }
            TempIgnoreAnimusPulseInput(true);
            // End:0x145
            if((thePawn != none) && thePawn.CheckForHandToHandWeapon())
            {
                // End:0x11D
                if(!thePawn.CheckForHandToHandFiring() && !IsInWerewolfTackleState())
                {
                    SetFireAxeFiring();
                }
                // End:0x142
                if(thePawn.m_bEnableMultipleHits)
                {
                    thePawn.m_bDoMultipleHit = true;
                }                
            }
            else
            {
                // End:0x1C9
                if(m_bCanUseScope)
                {
                    // End:0x1C6
                    if(((Pawn.Weapon != none) && SPWeapon(Pawn.Weapon) != none) && SPWeapon(Pawn.Weapon).WeapID == 'AssaultRifle')
                    {
                        Pawn.StartFire(FireModeNum);
                    }                    
                }
                else
                {
                    Pawn.StartFire(FireModeNum);
                    // End:0x201
                    if(thePawn != none)
                    {
                        thePawn.TriggerExplosion();
                    }
                }
            }
        }
    }
    //return;    
}

exec function StopFire(optional byte FireModeNum)
{
    // End:0x33
    if(MountedWeapon != none)
    {
        // End:0x30
        if(int(FireModeNum) == int(0))
        {
            MountedWeapon.StopFire();
        }        
    }
    else
    {
        // End:0x84
        if(Pawn != none)
        {
            // End:0x79
            if(PlayerPawn(Pawn).CheckForHandToHandWeapon() == false)
            {
                Pawn.StopFire(FireModeNum);                
            }
            else
            {
                m_HandToHandFireModeNum = FireModeNum;
            }
        }
    }
    TempIgnoreAnimusPulseInput(false);
    //return;    
}

exec function StartAltFire(optional byte FireModeNum)
{
    // End:0x10
    if(IsFiringInputIgnored())
    {
        return;
    }
    // End:0x5C
    if(Pawn != none)
    {
        // End:0x5C
        if(Pawn.Weapon != none)
        {
            // End:0x5C
            if(Pawn.Weapon.FiringStatesArray.Length > 1)
            {
                StartFire(1);
            }
        }
    }
    //return;    
}

exec function StopAltFire(optional byte FireModeNum)
{
    // End:0x4D
    if(Pawn != none)
    {
        // End:0x4D
        if(Pawn.Weapon != none)
        {
            // End:0x4D
            if(Pawn.Weapon.FiringStatesArray.Length > 1)
            {
                StopFire(1);
            }
        }
    }
    //return;    
}

function bool PrimeCarried()
{
    // End:0x0B
    if(bCarryThrowPrimeRequest)
    {
        return false;
    }
    fCarryThrowPrimeTime = 0.0000000;
    bCarryThrowPrimeRequest = true;
    return true;
    //return ReturnValue;    
}

function bool ReleaseCarried()
{
    // End:0x0D
    if(!bCarryThrowPrimeRequest)
    {
        return false;
    }
    bCarryThrowPrimeRequest = false;
    // End:0x2D
    if(Carried != none)
    {
        DetachCarriedObject();        
    }
    else
    {
        DetachCarriedPawn();
    }
    fCarryThrowPrimeTime = -1.0000000;
    return true;
    //return ReturnValue;    
}

function SetWeaponPickupOrReload()
{
    m_bWeaponPickupOrReload = true;
    m_bTimerForWeaponPickupOrReload = false;
    SetTimer(0.2000000, false, 'WeaponPickupOrReload');
    //return;    
}

function WeaponPickupOrReload()
{
    m_bTimerForWeaponPickupOrReload = true;
    // End:0x6C
    if((CanCollectSwapWeaponOrPerformUse()) == 1)
    {
        // End:0x62
        if(IsWeaponReloading())
        {
            // End:0x62
            if(SPWeapon(Pawn.Weapon) != none)
            {
                SPWeapon(Pawn.Weapon).ForceInterruptReload();
            }
        }
        PerformedUseAction();
    }
    //return;    
}

function ForceFiringFireAxe()
{
    local PlayerPawn thePawn;

    thePawn = PlayerPawn(Pawn);
    thePawn.DetermineHandToHandAnim();
    Pawn.StartFire(0);
    thePawn.SetHandToHandFiring();
    thePawn.m_bResetAction = true;
    thePawn.m_bFireAxeSuper = false;
    //return;    
}

function SetFireAxeFiring()
{
    local PlayerPawn thePawn;

    thePawn = PlayerPawn(Pawn);
    // End:0x1D
    if(thePawn == none)
    {
        return;
    }
    thePawn.m_bFireAxeButtonPress = true;
    thePawn.m_bFireAxeNotifyHit = false;
    thePawn.DetermineHandToHandAnim();
    thePawn.StartFire(0);
    thePawn.SetHandToHandFiring();
    thePawn.m_bEnableMultipleHits = false;
    thePawn.m_bDoMultipleHit = false;
    thePawn.m_bResetAction = true;
    thePawn.m_bFireAxeSuper = false;
    thePawn.m_bFiringSuperAttack = false;
    SetTimer(0.5000000, false, 'FireAxeFailSafeReset');
    thePawn.m_bFireAxeReset = true;
    //return;    
}

exec function FireAxeButtonRelease()
{
    local PlayerPawn thePawn;

    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    thePawn = PlayerPawn(Pawn);
    thePawn.m_bFireAxeButtonPress = false;
    // End:0xAB
    if(thePawn.m_bFireAxeNotifyHit)
    {
        // End:0xAB
        if(((Pawn.Weapon != none) && SPWeapon(Pawn.Weapon) != none) && SPWeapon(Pawn.Weapon).WeapID == 'FireAxe')
        {
            ForceFiringFireAxe();
        }
    }
    //return;    
}

exec function ReleaseUse()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        PerformedReleaseUseAction();
    }
    ServerReleaseUse();
    //return;    
}

reliable server function ServerReleaseUse()
{
    PerformedReleaseUseAction();
    //return;    
}

function bool IsMySeqEvent(SeqEvent_UsedAndHeld UseSeq)
{
    // End:0x34
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        return UseSeq.Instigator == Pawn;        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}

function PerformedReleaseUseAction()
{
    local int Idx;
    local SeqEvent_UsedAndHeld UseSeq;
    local PlayerPawn thePlayerPawn;

    bHoldUse = false;
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    thePlayerPawn = PlayerPawn(Pawn);
    ClearTimer('WeaponPickupOrReload');
    m_bWeaponPickupOrReload = false;
    // End:0x99
    if(!m_bTimerForWeaponPickupOrReload && !IsWeaponSwitching())
    {
        // End:0x8D
        if((thePlayerPawn != none) && thePlayerPawn.GetIsPartiallyLookingDownSite())
        {
            DoUnLookDownSite();
        }
        Reload();
        return;
    }
    m_bTimerForWeaponPickupOrReload = false;
    // End:0xB0
    if(ReleaseCarried())
    {
        return;
    }
    // End:0x17B
    if((thePlayerPawn != none) && thePlayerPawn.m_currentlyHeldTrigger != none)
    {
        Idx = 0;
        J0xD9:

        // End:0x17B [Loop If]
        if(Idx < thePlayerPawn.m_currentlyHeldTrigger.GeneratedEvents.Length)
        {
            UseSeq = SeqEvent_UsedAndHeld(thePlayerPawn.m_currentlyHeldTrigger.GeneratedEvents[Idx]);
            // End:0x171
            if((UseSeq != none) && IsMySeqEvent(UseSeq))
            {
                UseSeq.ActivateReleased(thePlayerPawn.m_currentlyHeldTrigger, Pawn);
                // [Explicit Break]
                goto J0x17B;
            }
            Idx++;
            // [Loop Continue]
            goto J0xD9;
        }
    }
    J0x17B:

    //return;    
}

simulated exec function Flip180()
{
    local Rotator Rot;

    // End:0x80
    if(Pawn != none)
    {
        // End:0x80
        if((WorldInfo.TimeSeconds - LastFlipTime) > float(1))
        {
            Rot = Rotation;
            Rot.Yaw = (Rot.Yaw + 32768) & 65535;
            SetRotation(Rot);
            LastFlipTime = WorldInfo.TimeSeconds;
        }
    }
    //return;    
}

function UpdateRotation(float DeltaTime)
{
    local Rotator DeltaRot, NewRotation, ViewRotation;
    local PandoraPlayerInput PPlayerInput;

    // End:0x21B
    if(MountedWeapon == none)
    {
        ViewRotation = Rotation;
        DesiredRotation = ViewRotation;
        PPlayerInput = PandoraPlayerInput(PlayerInput);
        // End:0x67
        if((LocalPlayer(Player) != none) && PPlayerInput != none)
        {
            PPlayerInput.ProcessOverrides(DeltaTime);
        }
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        // End:0xDD
        if((Pawn != none) && Pawn.bHardAttach)
        {
            DeltaRot.Pitch = 0;
        }
        // End:0x116
        if((Pawn != none) && int(Pawn.Physics) == int(9))
        {
            DeltaRot.Yaw = 0;
        }
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        // End:0x143
        if(bOverridePlayerControl)
        {
            ViewRotation = NewRot;
        }
        // End:0x157
        if(bForceCameraLookAt)
        {
            ViewRotation = CameraLookAtRot;
        }
        SetRotation(ViewRotation);
        DesiredRotation = Rotation;
        ViewShake(DeltaTime);
        NewRotation = ViewRotation;
        NewRotation.Roll = Rotation.Roll;
        // End:0x218
        if(Pawn != none)
        {
            // End:0x1DB
            if(Pawn.bHardAttach)
            {
                Pawn.UpdateRelativeRotation(DeltaRot);                
            }
            else
            {
                Pawn.FaceRotation(NewRotation, DeltaTime);
                Pawn.DesiredRotation = Pawn.Rotation;
            }
        }        
    }
    else
    {
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        MountedWeapon.SetWeaponRotation(MountedWeapon.WeaponRotation + DeltaRot);
    }
    //return;    
}

function SetOverrideRotVel(Rotator newRotDelta, float deltaVelTime, Actor recoverTargetActor, float recoverTime, bool bDisableRecovery)
{
    // End:0x3F
    if(PlayerInput != none)
    {
        PandoraPlayerInput(PlayerInput).SetOverrideRotVel(newRotDelta, deltaVelTime, recoverTargetActor, recoverTime, bDisableRecovery);
    }
    //return;    
}

function HandleRecoilEffect(SPWeapon spWeap)
{
    local RecoilData currRecoilData;
    local Rotator newRotDelta;
    local PlayerPawn thePawn;

    // End:0x38
    if((int(WorldInfo.NetMode) != int(NM_Standalone)) && SPWeaponRapidFirePersistant(Pawn.Weapon) == none)
    {
        return;
    }
    thePawn = PlayerPawn(Pawn);
    // End:0xB8
    if(Pawn.bIsCrouched)
    {
        // End:0x95
        if(thePawn.GetIsFullyLookingDownSite())
        {
            currRecoilData = spWeap.RecoilInfo.CrouchedDownSite;            
        }
        else
        {
            currRecoilData = spWeap.RecoilInfo.Crouched;
        }        
    }
    else
    {
        // End:0xF2
        if(thePawn.GetIsFullyLookingDownSite())
        {
            currRecoilData = spWeap.RecoilInfo.DownSite;            
        }
        else
        {
            currRecoilData = spWeap.RecoilInfo.Normal;
        }
    }
    newRotDelta.Pitch = int(((currRecoilData.PitchImpactAngle + (FRand() * currRecoilData.RandPitchImpactAngle)) * float(65536)) / 360.0000000);
    newRotDelta.Yaw = int(((currRecoilData.YawImpactAngle + (FRand() * currRecoilData.RandYawImpactAngle)) * float(65536)) / 360.0000000);
    newRotDelta = Normalize(newRotDelta);
    // End:0x219
    if((PandoraPlayerInput(PlayerInput) != none) && LocalPlayer(Player) != none)
    {
        PandoraPlayerInput(PlayerInput).SetOverrideRotVel(newRotDelta, currRecoilData.EffectImpulseTime, none, currRecoilData.EffectRecoverTime, false, 4);
    }
    //return;    
}

function int YawForamBXWindDir(PlayerPawn.eAmBxCompassDir E)
{
    switch(E)
    {
        // End:0x16
        case 0:
            return -1;
            // End:0xC0
            break;
        // End:0x20
        case 1:
            return 0;
            // End:0xC0
            break;
        // End:0x35
        case 2:
            return (65535 * 1) / 8;
            // End:0xC0
            break;
        // End:0x4A
        case 3:
            return (65535 * 1) / 4;
            // End:0xC0
            break;
        // End:0x60
        case 4:
            return (65535 * 3) / 8;
            // End:0xC0
            break;
        // End:0x75
        case 5:
            return (65535 * 1) / 2;
            // End:0xC0
            break;
        // End:0x8B
        case 6:
            return (65535 * 5) / 8;
            // End:0xC0
            break;
        // End:0xA1
        case 7:
            return (65535 * 3) / 4;
            // End:0xC0
            break;
        // End:0xB7
        case 8:
            return (65535 * 7) / 8;
            // End:0xC0
            break;
        // End:0xFFFF
        default:
            return -1;
            break;
    }
    //return ReturnValue;    
}

function PlayerPawn.eAmBxCompassDir RelativeAmBxDirFromRelYaw(int YawToTest)
{
    // End:0xF5
    if(YawToTest >= 0)
    {
        // End:0x27
        if(YawToTest < ((65535 * 1) / 16))
        {
            return 1;            
        }
        else
        {
            // End:0x44
            if(YawToTest < ((65535 * 3) / 16))
            {
                return 2;                
            }
            else
            {
                // End:0x61
                if(YawToTest < ((65535 * 5) / 16))
                {
                    return 3;                    
                }
                else
                {
                    // End:0x7E
                    if(YawToTest < ((65535 * 7) / 16))
                    {
                        return 4;                        
                    }
                    else
                    {
                        // End:0x9B
                        if(YawToTest < ((65535 * 9) / 16))
                        {
                            return 5;                            
                        }
                        else
                        {
                            // End:0xB8
                            if(YawToTest < ((65535 * 11) / 16))
                            {
                                return 6;                                
                            }
                            else
                            {
                                // End:0xD5
                                if(YawToTest < ((65535 * 13) / 16))
                                {
                                    return 7;                                    
                                }
                                else
                                {
                                    // End:0xF2
                                    if(YawToTest < ((65535 * 15) / 16))
                                    {
                                        return 8;                                        
                                    }
                                    else
                                    {
                                        return 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return 1;
    //return ReturnValue;    
}

function string NameOfAmBxCompassDir(PlayerPawn.eAmBxCompassDir AmBxDir)
{
    local string relLoc;

    switch(AmBxDir)
    {
        // End:0x19
        case 1:
            relLoc = "N";
            // End:0xA9
            break;
        // End:0x2B
        case 2:
            relLoc = "NE";
            // End:0xA9
            break;
        // End:0x3C
        case 3:
            relLoc = "E";
            // End:0xA9
            break;
        // End:0x4E
        case 4:
            relLoc = "SE";
            // End:0xA9
            break;
        // End:0x5F
        case 5:
            relLoc = "S";
            // End:0xA9
            break;
        // End:0x71
        case 6:
            relLoc = "SW";
            // End:0xA9
            break;
        // End:0x82
        case 7:
            relLoc = "W";
            // End:0xA9
            break;
        // End:0x94
        case 8:
            relLoc = "NW";
            // End:0xA9
            break;
        // End:0xFFFF
        default:
            relLoc = "everywhere";
            break;
    }
    return relLoc;
    //return ReturnValue;    
}

function SendAmbientRelativeSpeed(PlayerPawn.eAmBxCompassDir AmBxDir, float Speed)
{
    local string AmBxDirStr;
    local int Rot;
    local float Perc;

    switch(AmBxDir)
    {
        // End:0x19
        case 1:
            AmBxDirStr = "N";
            // End:0x99
            break;
        // End:0x2B
        case 2:
            AmBxDirStr = "NE";
            // End:0x99
            break;
        // End:0x3C
        case 3:
            AmBxDirStr = "E";
            // End:0x99
            break;
        // End:0x4E
        case 4:
            AmBxDirStr = "SE";
            // End:0x99
            break;
        // End:0x5F
        case 5:
            AmBxDirStr = "S";
            // End:0x99
            break;
        // End:0x71
        case 6:
            AmBxDirStr = "SW";
            // End:0x99
            break;
        // End:0x82
        case 7:
            AmBxDirStr = "W";
            // End:0x99
            break;
        // End:0x94
        case 8:
            AmBxDirStr = "NW";
            // End:0x99
            break;
        // End:0xFFFF
        default:
            return;
            break;
    }
    // End:0x1A2
    if(m_CurrentScriptedWindEffect != none)
    {
        Rot = YawForamBXWindDir(AmBxDir);
        // End:0xEB
        if(Rot > m_CurrentScriptedWindEffect.m_RelativeWindYaw)
        {
            Rot -= m_CurrentScriptedWindEffect.m_RelativeWindYaw;            
        }
        else
        {
            Rot = m_CurrentScriptedWindEffect.m_RelativeWindYaw - Rot;
        }
        // End:0x128
        if(Rot >= 32768)
        {
            Rot = 65535 - Rot;
        }
        // End:0x187
        if(Rot <= 16384)
        {
            Perc = 1.0000000 - (float(Rot) / 16384.0000000);
            Perc = FClamp(Perc, 0.1000000, 1.0000000);
            SendAmbientFanUpdate(AmBxDirStr, Perc * Speed);            
        }
        else
        {
            SendAmbientFanUpdate(AmBxDirStr, 0.1000000 * Speed);
        }
    }
    //return;    
}

function UpdateWindSystemFromRelWindDir(float Speed)
{
    SendAmbientRelativeSpeed(1, Speed);
    SendAmbientRelativeSpeed(2, Speed);
    SendAmbientRelativeSpeed(3, Speed);
    SendAmbientRelativeSpeed(4, Speed);
    SendAmbientRelativeSpeed(5, Speed);
    SendAmbientRelativeSpeed(6, Speed);
    SendAmbientRelativeSpeed(7, Speed);
    SendAmbientRelativeSpeed(8, Speed);
    //return;    
}

function SendAmbientFanUpdate(string RelativeFanLoc, float intensity)
{
    switch(RelativeFanLoc)
    {
        // End:0x20
        case "N":
            SetAmBx_N_Fan(intensity);
            // End:0xCF
            break;
        // End:0x39
        case "NE":
            SetAmBx_NE_Fan(intensity);
            // End:0xCF
            break;
        // End:0x51
        case "E":
            SetAmBx_E_Fan(intensity);
            // End:0xCF
            break;
        // End:0x6A
        case "SE":
            SetAmBx_SE_Fan(intensity);
            // End:0xCF
            break;
        // End:0x82
        case "S":
            SetAmBx_S_Fan(intensity);
            // End:0xCF
            break;
        // End:0x9B
        case "SW":
            SetAmBx_SW_Fan(intensity);
            // End:0xCF
            break;
        // End:0xB3
        case "W":
            SetAmBx_W_Fan(intensity);
            // End:0xCF
            break;
        // End:0xCC
        case "NW":
            SetAmBx_NW_Fan(intensity);
            // End:0xCF
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function BuildAndSendWindStopScriptForKismetWidget()
{
    SendAmbientFanUpdate("N", 0.0000000);
    SendAmbientFanUpdate("NE", 0.0000000);
    SendAmbientFanUpdate("E", 0.0000000);
    SendAmbientFanUpdate("SE", 0.0000000);
    SendAmbientFanUpdate("S", 0.0000000);
    SendAmbientFanUpdate("SW", 0.0000000);
    SendAmbientFanUpdate("W", 0.0000000);
    SendAmbientFanUpdate("NW", 0.0000000);
    //return;    
}

function CalculateThenBuildamBXWindEffect()
{
    local int windDirYaw, finalYaw;
    local float Speed;

    // End:0x308
    if(m_CurrentScriptedWindEffect != none)
    {
        // End:0x56
        if(m_CurrentScriptedWindEffect.m_TimeStarted < float(0))
        {
            m_CurrentScriptedWindEffect.m_TimeStarted = WorldInfo.TimeSeconds;
            m_CurrentScriptedWindEffect.m_LastTimeUpdate = -1000.0000000;
        }
        // End:0xC4
        if((m_CurrentScriptedWindEffect.m_TimeStarted + m_CurrentScriptedWindEffect.DurationSeconds) < WorldInfo.TimeSeconds)
        {
            m_CurrentScriptedWindEffect.m_TimeStarted = -1.0000000;
            m_CurrentScriptedWindEffect.m_RelativeWindYaw = 0;
            m_CurrentScriptedWindEffect = none;
            BuildAndSendWindStopScriptForKismetWidget();            
        }
        else
        {
            // End:0x308
            if((WorldInfo.TimeSeconds - m_CurrentScriptedWindEffect.m_LastTimeUpdate) >= m_UpdateTimeForWindEffects)
            {
                m_CurrentScriptedWindEffect.m_LastTimeUpdate = WorldInfo.TimeSeconds;
                Speed = float(Clamp(int(m_CurrentScriptedWindEffect.Speed), 0, 100)) / 100.0000000;
                windDirYaw = YawForamBXWindDir(m_CurrentScriptedWindEffect.DirectionFrom);
                // End:0x1F6
                if(windDirYaw == -1)
                {
                    SendAmbientFanUpdate("N", Speed);
                    SendAmbientFanUpdate("NE", Speed);
                    SendAmbientFanUpdate("E", Speed);
                    SendAmbientFanUpdate("SE", Speed);
                    SendAmbientFanUpdate("S", Speed);
                    SendAmbientFanUpdate("SW", Speed);
                    SendAmbientFanUpdate("W", Speed);
                    SendAmbientFanUpdate("NW", Speed);
                    return;
                }
                finalYaw = Pawn.Rotation.Yaw;
                J0x216:

                // End:0x23A [Loop If]
                if(finalYaw > 65535)
                {
                    finalYaw = finalYaw - 65535;
                    // [Loop Continue]
                    goto J0x216;
                }
                J0x23A:

                // End:0x25A [Loop If]
                if(finalYaw < 0)
                {
                    finalYaw = 65535 + finalYaw;
                    // [Loop Continue]
                    goto J0x23A;
                }
                m_CurrentScriptedWindEffect.m_RelativeWindYaw = windDirYaw - finalYaw;
                // End:0x2B1
                if(m_CurrentScriptedWindEffect.m_RelativeWindYaw < 0)
                {
                    m_CurrentScriptedWindEffect.m_RelativeWindYaw = 65535 + m_CurrentScriptedWindEffect.m_RelativeWindYaw;
                }
                m_CurrentScriptedWindEffect.m_PrimaryRelativeWindDir = RelativeAmBxDirFromRelYaw(m_CurrentScriptedWindEffect.m_RelativeWindYaw);
                UpdateWindSystemFromRelWindDir(Speed);
                m_CurrentScriptedWindEffect.m_LastRelativeWindDir = m_CurrentScriptedWindEffect.m_PrimaryRelativeWindDir;
            }
        }
    }
    //return;    
}

function BuildAndSendScriptForStartingAmbxSprintEffect()
{
    PlayAmBxScript("player_sprinting", 200);
    m_bPlayingAmBxSprintEffect = true;
    //return;    
}

function BuildAndSendScriptForStopingAmbxSprintEffect()
{
    StopAmBxScript("player_sprinting");
    m_bPlayingAmBxSprintEffect = false;
    //return;    
}

function BuildAndSendScriptForStartingAmbxFallingEffect()
{
    PlayAmBxScript("player_falling", 500);
    m_bPlayingAmBxFallingEffect = true;
    //return;    
}

function BuildAndSendScriptForStopingAmbxFallingEffect()
{
    StopAmBxScript("player_falling");
    m_bPlayingAmBxFallingEffect = false;
    //return;    
}

function BuildAndSendScriptForStartingAmbxOutOfBreathEffect()
{
    PlayAmBxScript("player_out_of_breath", 500);
    m_bPlayingAmBxSprintEffect = true;
    //return;    
}

function BuildAndSendScriptForStopingAmbxOutOfBreathEffect()
{
    StopAmBxScript("player_out_of_breath");
    m_bPlayingAmBxSprintEffect = false;
    //return;    
}

function PlayerPawn.eAmBxCompassDir GetAmBxAbsolutePawnHeading()
{
    local int finalYaw;

    finalYaw = Pawn.Rotation.Yaw;
    J0x20:

    // End:0x44 [Loop If]
    if(finalYaw > 65535)
    {
        finalYaw = finalYaw - 65535;
        // [Loop Continue]
        goto J0x20;
    }
    J0x44:

    // End:0x64 [Loop If]
    if(finalYaw < 0)
    {
        finalYaw = 65535 + finalYaw;
        // [Loop Continue]
        goto J0x44;
    }
    // End:0x80
    if(finalYaw < ((65535 * 1) / 16))
    {
        return 1;        
    }
    else
    {
        // End:0x9D
        if(finalYaw < ((65535 * 3) / 16))
        {
            return 2;            
        }
        else
        {
            // End:0xBA
            if(finalYaw < ((65535 * 5) / 16))
            {
                return 3;                
            }
            else
            {
                // End:0xD7
                if(finalYaw < ((65535 * 7) / 16))
                {
                    return 4;                    
                }
                else
                {
                    // End:0xF4
                    if(finalYaw < ((65535 * 9) / 16))
                    {
                        return 5;                        
                    }
                    else
                    {
                        // End:0x111
                        if(finalYaw < ((65535 * 11) / 16))
                        {
                            return 6;                            
                        }
                        else
                        {
                            // End:0x12E
                            if(finalYaw < ((65535 * 13) / 16))
                            {
                                return 7;                                
                            }
                            else
                            {
                                // End:0x14B
                                if(finalYaw < ((65535 * 15) / 16))
                                {
                                    return 8;                                    
                                }
                                else
                                {
                                    return 1;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return ReturnValue;    
}

function int GetRelativeAmbientLightingStartIndexFromAbsolutePawnHeading(PlayerPawn.eAmBxCompassDir AbsPawnHeading)
{
    switch(AbsPawnHeading)
    {
        // End:0x12
        case 0:
            return 0;
            // End:0x6D
            break;
        // End:0x1C
        case 1:
            return 0;
            // End:0x6D
            break;
        // End:0x26
        case 2:
            return 1;
            // End:0x6D
            break;
        // End:0x31
        case 3:
            return 2;
            // End:0x6D
            break;
        // End:0x3C
        case 4:
            return 3;
            // End:0x6D
            break;
        // End:0x47
        case 5:
            return 4;
            // End:0x6D
            break;
        // End:0x52
        case 6:
            return 5;
            // End:0x6D
            break;
        // End:0x5D
        case 7:
            return 6;
            // End:0x6D
            break;
        // End:0x68
        case 8:
            return 7;
            // End:0x6D
            break;
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    //return ReturnValue;    
}

function SendAmbientLightSystemUpdateBy(string RelativeLightLoc, LinearColor ColorToSend)
{
    local LinearColor northScaleFactor, northE_W_ScaleFactor, otherWhereScaleFactor;
    local SPWeapon Weap;

    northScaleFactor.R = 1.0000000;
    northScaleFactor.G = 1.0000000;
    northScaleFactor.B = 1.0000000;
    northE_W_ScaleFactor.R = 1.0000000;
    northE_W_ScaleFactor.G = 1.0000000;
    northE_W_ScaleFactor.B = 1.0000000;
    otherWhereScaleFactor.R = 1.0000000;
    otherWhereScaleFactor.G = 1.0000000;
    otherWhereScaleFactor.B = 1.0000000;
    // End:0x2E3
    if(((Pawn != none) && Pawn.Weapon != none) && SPWeapon(Pawn.Weapon) != none)
    {
        Weap = SPWeapon(Pawn.Weapon);
        // End:0x2E3
        if(PlayerPawn(Pawn).GetLookDownSitePercent() > 0.5000000)
        {
            // End:0x21D
            if(Weap.m_bAmBxScopedWeapon)
            {
                northScaleFactor.R = 1.0000000;
                northScaleFactor.G = 1.0000000;
                northScaleFactor.B = 1.0000000;
                northE_W_ScaleFactor.R = m_amBX_AmbientLightScaleFactorLookingDownScope;
                northE_W_ScaleFactor.G = m_amBX_AmbientLightScaleFactorLookingDownScope;
                northE_W_ScaleFactor.B = m_amBX_AmbientLightScaleFactorLookingDownScope;
                otherWhereScaleFactor.R = 0.0000000;
                otherWhereScaleFactor.G = 0.0000000;
                otherWhereScaleFactor.B = 0.0000000;                
            }
            else
            {
                northScaleFactor.R = 1.0000000;
                northScaleFactor.G = 1.0000000;
                northScaleFactor.B = 1.0000000;
                northE_W_ScaleFactor.R = m_amBX_AmbientLightScaleFactorLookingDownSights;
                northE_W_ScaleFactor.G = m_amBX_AmbientLightScaleFactorLookingDownSights;
                northE_W_ScaleFactor.B = m_amBX_AmbientLightScaleFactorLookingDownSights;
                otherWhereScaleFactor.R = m_amBX_AmbientLightScaleFactorLookingDownSights;
                otherWhereScaleFactor.G = m_amBX_AmbientLightScaleFactorLookingDownSights;
                otherWhereScaleFactor.B = m_amBX_AmbientLightScaleFactorLookingDownSights;
            }
        }
    }
    switch(RelativeLightLoc)
    {
        // End:0x364
        case "C":
            SetAmBx_C_LightColourFloat(ColorToSend.R * otherWhereScaleFactor.R, ColorToSend.G * otherWhereScaleFactor.G, ColorToSend.B * otherWhereScaleFactor.B);
            // End:0x733
            break;
        // End:0x3DD
        case "N":
            SetAmBx_N_LightColourFloat(ColorToSend.R * northScaleFactor.R, ColorToSend.G * northScaleFactor.G, ColorToSend.B * northScaleFactor.B);
            // End:0x733
            break;
        // End:0x457
        case "NE":
            SetAmBx_NE_LightColourFloat(ColorToSend.R * northE_W_ScaleFactor.R, ColorToSend.G * northE_W_ScaleFactor.G, ColorToSend.B * northE_W_ScaleFactor.B);
            // End:0x733
            break;
        // End:0x4D0
        case "E":
            SetAmBx_E_LightColourFloat(ColorToSend.R * otherWhereScaleFactor.R, ColorToSend.G * otherWhereScaleFactor.G, ColorToSend.B * otherWhereScaleFactor.B);
            // End:0x733
            break;
        // End:0x54A
        case "SE":
            SetAmBx_SE_LightColourFloat(ColorToSend.R * otherWhereScaleFactor.R, ColorToSend.G * otherWhereScaleFactor.G, ColorToSend.B * otherWhereScaleFactor.B);
            // End:0x733
            break;
        // End:0x5C3
        case "S":
            SetAmBx_S_LightColourFloat(ColorToSend.R * otherWhereScaleFactor.R, ColorToSend.G * otherWhereScaleFactor.G, ColorToSend.B * otherWhereScaleFactor.B);
            // End:0x733
            break;
        // End:0x63D
        case "SW":
            SetAmBx_SW_LightColourFloat(ColorToSend.R * otherWhereScaleFactor.R, ColorToSend.G * otherWhereScaleFactor.G, ColorToSend.B * otherWhereScaleFactor.B);
            // End:0x733
            break;
        // End:0x6B6
        case "W":
            SetAmBx_W_LightColourFloat(ColorToSend.R * otherWhereScaleFactor.R, ColorToSend.G * otherWhereScaleFactor.G, ColorToSend.B * otherWhereScaleFactor.B);
            // End:0x733
            break;
        // End:0x730
        case "NW":
            SetAmBx_NW_LightColourFloat(ColorToSend.R * northE_W_ScaleFactor.R, ColorToSend.G * northE_W_ScaleFactor.G, ColorToSend.B * northE_W_ScaleFactor.B);
            // End:0x733
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function CalculateThenBuildAmBxAmbientLighting()
{
    // End:0x34
    if(!bAmbientConfigSet)
    {
        m_amBX_AmbientCurrentLightBaseLevel = m_amBX_AmbientLightBaseLevel;
        m_amBX_AmbientCurrentLightBaseColor = m_amBX_AmbientLightBaseColor;
        m_amBX_AmbientCurrentLightMaxLevel = m_amBX_AmbientLightMaxLevel;
        bAmbientConfigSet = true;
    }
    SendAmbientLightSystemUpdateBy("N", PlayerPawn(Pawn).m_NorthLightEnvironment.AmBxLightColor);
    SendAmbientLightSystemUpdateBy("NE", PlayerPawn(Pawn).m_NorthEastLightEnvironment.AmBxLightColor);
    SendAmbientLightSystemUpdateBy("E", PlayerPawn(Pawn).m_EastLightEnvironment.AmBxLightColor);
    SendAmbientLightSystemUpdateBy("SE", PlayerPawn(Pawn).m_SouthEastLightEnvironment.AmBxLightColor);
    SendAmbientLightSystemUpdateBy("S", PlayerPawn(Pawn).m_SouthLightEnvironment.AmBxLightColor);
    SendAmbientLightSystemUpdateBy("SW", PlayerPawn(Pawn).m_SouthWestLightEnvironment.AmBxLightColor);
    SendAmbientLightSystemUpdateBy("W", PlayerPawn(Pawn).m_WestLightEnvironment.AmBxLightColor);
    SendAmbientLightSystemUpdateBy("NW", PlayerPawn(Pawn).m_NorthWestLightEnvironment.AmBxLightColor);
    //return;    
}

function PauseAmBxAmbientLighting()
{
    SetAmBxAllLightColourFloat(0.1500000, 0.1500000, 0.1500000);
    //return;    
}

function PlayerTick(float DeltaTime)
{
    local Vector CamLoc, NewHandlePos, X, Y, Z;

    local Quat PawnQuat, NewHandleOrientation;
    local Rotator CamRot;
    local Vector vDir;
    local Rotator R;
    local PandoraPlayerInput PPI;
    local PandoraGameInfo GameInfo;
    local PandoraGameViewportClient pvc;
    local SPHud playerHud;
    local PandoraGRI GRI;

    pvc = PandoraGameViewportClient(GetViewportClient());
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    PPI = PandoraPlayerInput(PlayerInput);
    // End:0xEC
    if(((Pawn != none) && PlayerPawn(Pawn) != none) && DoesThePlayerWantToUseAmBx())
    {
        // End:0xEC
        if((WorldInfo.TimeSeconds - m_amBX_LastUpdateTimeForAmbientLighting) >= m_amBX_UpdateTimeForAmbientLighting)
        {
            m_amBX_LastUpdateTimeForAmbientLighting = WorldInfo.TimeSeconds;
            // End:0xEC
            if((GameInfo != none) && !GameInfo.IsInShellLevel())
            {
                // End:0xE2
                if(AreAllAmbxObjectsHidden())
                {
                    ShowAllAmbxObjects();
                    m_amBX_AmbientLightsEnabled = true;
                }
                CalculateThenBuildAmBxAmbientLighting();
            }
        }
    }
    // End:0x110
    if((m_CurrentScriptedWindEffect != none) && DoesThePlayerWantToUseAmBx())
    {
        CalculateThenBuildamBXWindEffect();
    }
    // End:0x150
    if(PPI != none)
    {
        // End:0x150
        if(PPI.IsQuickMenuComboKeyPressed())
        {
            PPI.ResetAllKeyStates();
            QuickMenu();
        }
    }
    playerHud = SPHud(myHUD);
    GRI = PandoraGRI(WorldInfo.GRI);
    // End:0x1C8
    if(playerHud != none)
    {
        playerHud.UpdateMonsterMachineValues(int(GRI.GetMonsterMachineValue(1)), int(GRI.GetMonsterMachineValue(2)));
    }
    UpdateSprintEffects(DeltaTime);
    // End:0x1EC
    if(bCarryThrowPrimeRequest)
    {
        fCarryThrowPrimeTime += DeltaTime;
    }
    // End:0x4F9
    if(Pawn != none)
    {
        // End:0x2B9
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            // End:0x236
            if(IsSprinting())
            {
                // End:0x233
                if(!m_bPlayingAmBxSprintEffect)
                {
                    BuildAndSendScriptForStartingAmbxSprintEffect();
                }                
            }
            else
            {
                // End:0x249
                if(m_bPlayingAmBxSprintEffect)
                {
                    BuildAndSendScriptForStopingAmbxSprintEffect();
                }
            }
            // End:0x2A3
            if((int(Pawn.Physics) == int(2)) && Pawn.Velocity.Z <= float(m_amBX_FallScriptPlayVelocity))
            {
                // End:0x2A0
                if(!m_bPlayingAmBxFallingEffect)
                {
                    BuildAndSendScriptForStartingAmbxFallingEffect();
                }                
            }
            else
            {
                // End:0x2B6
                if(m_bPlayingAmBxFallingEffect)
                {
                    BuildAndSendScriptForStopingAmbxFallingEffect();
                }
            }            
        }
        else
        {
            // End:0x2DE
            if(IsSprinting())
            {
                // End:0x2DB
                if(!m_bPlayingAmBxSprintEffect)
                {
                    BuildAndSendScriptForStartingAmbxSprintEffect();
                }                
            }
            else
            {
                // End:0x2F1
                if(m_bPlayingAmBxSprintEffect)
                {
                    BuildAndSendScriptForStopingAmbxSprintEffect();
                }
            }
            // End:0x34B
            if((int(Pawn.Physics) == int(2)) && Pawn.Velocity.Z <= float(m_amBX_FallScriptPlayVelocity))
            {
                // End:0x348
                if(!m_bPlayingAmBxFallingEffect)
                {
                    BuildAndSendScriptForStartingAmbxFallingEffect();
                }                
            }
            else
            {
                // End:0x35E
                if(m_bPlayingAmBxFallingEffect)
                {
                    BuildAndSendScriptForStopingAmbxFallingEffect();
                }
            }
        }
        // End:0x3C2
        if(bOverridePlayerControl)
        {
            vDir = Pawn.Location - LastPos;
            R = Rotator(vDir);
            Pawn.SetRotation(R);
            LastPos = Pawn.Location;
            NewRot = R;
        }
        // End:0x404
        if(tackleMinigameManager != none)
        {
            tackleMinigameManager.Tick(DeltaTime);
            // End:0x404
            if(!IsBeingTackled())
            {
                TickCantBeTackledTime(DeltaTime);
            }
        }
        // End:0x489
        if((((PlayerPawn(Pawn).GetIsTryingToLookDownSite() && !PlayerPawn(Pawn).GetIsPartiallyLookingDownSite()) && CanLookDownSite()) && !IsWeaponSwitching()) && !SPPawn(Pawn).IsReloading())
        {
            DoLookDownSite();            
        }
        else
        {
            // End:0x4C1
            if(PlayerPawn(Pawn).GetIsPartiallyLookingDownSite() && !CanLookDownSite())
            {
                DoUnLookDownSite();
            }
        }
        // End:0x4F9
        if(m_bShowedFillMessage)
        {
            m_fShowedFillMessageTimer += DeltaTime;
            // End:0x4F9
            if(m_fShowedFillMessageTimer > float(2))
            {
                ServerResetFillMessage();
                m_fShowedFillMessageTimer = 0.0000000;
            }
        }
    }
    super(PlayerController).PlayerTick(DeltaTime);
    // End:0x5EB
    if((PhysicsGrabber != none) && PhysicsGrabber.GrabbedComponent != none)
    {
        PhysicsGrabber.GrabbedComponent.WakeRigidBody(PhysicsGrabber.GrabbedBoneName);
        GetPlayerViewPoint(CamLoc, CamRot);
        GetAxes(CamRot, X, Y, Z);
        NewHandlePos = CamLoc + (HoldDistance * X);
        PhysicsGrabber.SetLocation(NewHandlePos);
        PawnQuat = QuatFromRotator(CamRot);
        NewHandleOrientation = QuatProduct(PawnQuat, HoldOrientation);
        PhysicsGrabber.SetOrientation(NewHandleOrientation);
    }
    // End:0x644
    if((((pvc != none) && !pvc.FullScreenIsMoviePlaying()) && GameInfo != none) && !GameInfo.IsInCinematic())
    {
        ConditionalSaveCheckpoint();
    }
    // End:0x6C8
    if(((pvc != none) && !pvc.FullScreenIsMoviePlaying()) && bDelayMemoryCardRemovedCallBack)
    {
        // End:0x6C8
        if(((GameInfo != none) && !GameInfo.IsInCinematic()) || GameInfo.IsInShellLevel())
        {
            StorageChangeCallback();
            bDelayMemoryCardRemovedCallBack = false;
        }
    }
    // End:0x73D
    if(((((pvc != none) && !pvc.FullScreenIsMoviePlaying()) && (GameInfo != none) && !GameInfo.IsInCinematic()) && !IsPauseInputIgnored()) && bQueuedPause)
    {
        ShowPauseMenu();
    }
    // End:0x83E
    if((((pvc != none) && !pvc.FullScreenIsMoviePlaying()) && (GameInfo != none) && !GameInfo.IsInCinematic()) && !bHasSpace)
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.StorageDeviceFull_Message>", "<Strings:PandoraGame.ErrorMessages.StorageDeviceFull_Title>", 7, OnStorageChangeMsgResult, None, 0, 5);
        bHasSpace = true;
    }
    // End:0x8BE
    if(bDelayedProfileWrite && ProfileSettings.OkToWriteProfile() || ProfileSettings.bForceProfileWrite)
    {
        bDelayedProfileWrite = false;
        ProfileSettings.SetProfileDirty(true);
        // End:0x8B3
        if(ProfileSettings.bForceProfileWrite)
        {
            WriteProfile(true);            
        }
        else
        {
            WriteProfile();
        }
    }
    //return;    
}

function PostCommitConditionalSave()
{
    SetTimer(5.0000000, false, 'CommitConditionalSaveCheckpoint');
    SetTimer(10.0000000, false, 'CommitConditionalSaveCheckpoint');
    //return;    
}

function CommitConditionalSaveCheckpoint()
{
    // End:0x28
    if(PandoraGameViewportClient(GetViewportClient()).FullScreenIsMoviePlaying())
    {
        ConditionalSaveCheckpoint();
    }
    //return;    
}

function ConditionalSaveCheckpoint()
{
    // End:0x111
    if(((SPCM != none) && SPCM.CheckpointsToSave.Length > 0) && m_bOKToSaveCheckpoints)
    {
        ProfileSettings.SetProfileBusy(true);
        m_bOKToSaveCheckpoints = false;
        SetTimer(3.0000000, false, 'OKToSaveCheckpoints');
        // End:0xB7
        if(SPCM.SaveCheckpointData(SPCM.CheckpointsToSave[0].Filename, SPCM.CheckpointsToSave[0].CheckpointData))
        {
            ClientDisplayCheckpointText();
        }
        SPCM.CheckpointsToSave[0].CheckpointData.Length = 0;
        SPCM.CheckpointsToSave.Remove(0, 1);
        // End:0x111
        if(SPCM.CheckpointsToSave.Length == 0)
        {
            SetTimer(3.5000000, false, 'AllowProfileWrites');
        }
    }
    //return;    
}

function AllowProfileWrites()
{
    ProfileSettings.SetProfileBusy(false);
    // End:0x4B
    if(WorldInfo.IsConsoleBuild(2))
    {
        ProfileSettings.nWriteTime = int(WorldInfo.RealTimeSeconds);
    }
    //return;    
}

function OKToSaveCheckpoints()
{
    m_bOKToSaveCheckpoints = true;
    //return;    
}

event PlayerForceWriteProfile()
{
    // End:0x31
    if(bDelayedProfileWrite)
    {
        bDelayedProfileWrite = false;
        ProfileSettings.SetProfileDirty(true);
        WriteProfile(true);
    }
    //return;    
}

event PlayerForceDelayedCheckpointSave()
{
    PlayerForceWriteProfile();
    // End:0x17
    if(SPCM == none)
    {
        return;
    }
    J0x17:

    // End:0xBA [Loop If]
    if(SPCM.CheckpointsToSave.Length > 0)
    {
        // End:0x86
        if(SPCM.SaveCheckpointData(SPCM.CheckpointsToSave[0].Filename, SPCM.CheckpointsToSave[0].CheckpointData))
        {
            ClientDisplayCheckpointText();
        }
        SPCM.CheckpointsToSave[0].CheckpointData.Length = 0;
        SPCM.CheckpointsToSave.Remove(0, 1);
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

function RegenSprint(float DeltaTime)
{
    local float SprintRegenAmt;

    // End:0xAD
    if(Pawn != none)
    {
        // End:0xAD
        if(!IsSprinting())
        {
            // End:0x76
            if(VSizeSq(Pawn.Velocity) < 1.0000000)
            {
                // End:0x61
                if(Pawn.bIsCrouched)
                {
                    SprintRegenAmt = SprintTimeMax / SprintRegenTimeCrouching;                    
                }
                else
                {
                    SprintRegenAmt = SprintTimeMax / SprintRegenTimeStanding;
                }                
            }
            else
            {
                SprintRegenAmt = SprintTimeMax / SprintRegenTimeMoving;
            }
            SprintTime += (DeltaTime * SprintRegenAmt);
            SprintTime = FMin(SprintTimeMax, SprintTime);
        }
    }
    //return;    
}

reliable server function ServerResetFillMessage()
{
    m_bShowedFillMessage = false;
    //return;    
}

simulated function OnCreateMaterialEffect(SeqAct_CreateMaterialEffect inAction)
{
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;

    mySPHud = GetSPHud();
    // End:0xC1
    if(mySPHud != none)
    {
        spEffectsManager = mySPHud.GetEffectsManager();
        // End:0xC1
        if(spEffectsManager != none)
        {
            ClearLatentAction(Class'SeqAct_CreateMaterialEffect', false, inAction);
            spEffectsManager.CreateKismetMaterialEffect(inAction.Material, inAction.MaterialScalerParamName, inAction.FadeOutDelayTime, inAction.FadeOutSpeed, inAction.FadeInValue, inAction.FadeInSpeed);
            return;
        }
    }
    ClearLatentAction(Class'SeqAct_CreateMaterialEffect', false, inAction);
    //return;    
}

function SetAssaultRifleScopePPETimer()
{
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;

    mySPHud = GetSPHud();
    // End:0x55
    if(mySPHud != none)
    {
        spEffectsManager = mySPHud.GetEffectsManager();
        // End:0x55
        if(spEffectsManager != none)
        {
            spEffectsManager.ToggleTimerVariableForTransition(true);
        }
    }
    // End:0x99
    if(Pawn.Weapon.Mesh != none)
    {
        Pawn.Weapon.Mesh.SetHidden(true);
    }
    //return;    
}

function ReEnableSprintAmbience()
{
    m_bDisableSprintAmbience = false;
    //return;    
}

event StartSprintEffect()
{
    SetTimer(0.1000000, true, 'CheckStartSprintEffect');
    //return;    
}

function CheckStartSprintEffect()
{
    local PandoraGameInfo GameInfo;
    local PandoraGameViewportClient pvc;

    pvc = PandoraGameViewportClient(GetViewportClient());
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x78
    if(((GameInfo != none) && GameInfo.IsInCinematic()) || (pvc != none) && pvc.FullScreenIsMoviePlaying())
    {
        return;
    }
    ClearTimer('CheckStartSprintEffect');
    SprintTime = 0.0000000;
    m_bDisableSprintAmbience = true;
    SetTimer(5.0000000, false, 'ReEnableSprintAmbience');
    //return;    
}

function UpdateSprintEffects(float DeltaTime)
{
    local PlayerPawn lePlayerPawn;

    lePlayerPawn = PlayerPawn(Pawn);
    // End:0x28
    if(Class'DamageMatrix'.static.GetWorldInfo() == none)
    {
        return;
    }
    // End:0x35
    if(m_GameplayGDTuneData == none)
    {
        return;
    }
    // End:0xFF
    if(lePlayerPawn != none)
    {
        // End:0xA9
        if(GetSprint())
        {
            // End:0x91
            if(SprintTime < SprintRampDownTime)
            {
                m_fSprintRate = lePlayerPawn.playerSprintSpeedScale - ((lePlayerPawn.playerSprintSpeedScale - float(1)) * m_fFatigueAmount);                
            }
            else
            {
                m_fSprintRate = lePlayerPawn.playerSprintSpeedScale;
            }            
        }
        else
        {
            m_fSprintRate -= ((lePlayerPawn.playerSprintSpeedScale - 1.0000000) * DeltaTime);
            // End:0xE7
            if(m_fSprintRate < 1.0000000)
            {
                m_fSprintRate = 1.0000000;
            }
        }
        m_fAmBxOutOfBreathThreshold = lePlayerPawn.m_fAmBxOutOfBreathPerc;        
    }
    else
    {
        m_fSprintRate = 1.0000000;
    }
    // End:0x139
    if(SprintTime < SprintRampDownTime)
    {
        SetFatigueAmount((SprintRampDownTime - SprintTime) / SprintRampDownTime);        
    }
    else
    {
        // End:0x14C
        if(bExhausted)
        {
            RestoreCurrFOV();
        }
        SetFatigueAmount(0.0000000);
    }
    //return;    
}

function SetFatigueAmount(float fAmount)
{
    local PlayerPawn playaPawn;
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;
    local float fSpeedScalar;

    mySPHud = GetSPHud();
    // End:0x1D
    if(mySPHud == none)
    {
        return;
    }
    spEffectsManager = mySPHud.GetEffectsManager();
    playaPawn = PlayerPawn(Pawn);
    fSpeedScalar = 1.0000000;
    // End:0xAD
    if(playaPawn != none)
    {
        fSpeedScalar = VSize(playaPawn.Velocity) / (playaPawn.playerForwardSpeed * playaPawn.playerSprintSpeedScale);
        fSpeedScalar /= float(2);
        fSpeedScalar += 0.5000000;
    }
    m_fFatigueAmount = fAmount;
    // End:0x33D
    if(!m_bDisableSprintAmbience)
    {
        // End:0x10B
        if((fAmount <= float(0)) && !m_bSprintSoundFadeBegun)
        {
            // End:0xF8
            if(m_SprintSound != none)
            {
                m_SprintSound.Stop();
            }
            m_bSprintSoundFadeBegun = true;
            m_bSprintSoundPlaying = false;            
        }
        else
        {
            // End:0x1D6
            if(((fAmount > float(0)) && !m_bSprintSoundPlaying) && int(WorldInfo.NetMode) == int(NM_Standalone))
            {
                // End:0x1D3
                if((playaPawn != none) && playaPawn.mSoundCue_SprintLooping != none)
                {
                    m_bSprintSoundFadeBegun = false;
                    m_bSprintSoundPlaying = true;
                    // End:0x19E
                    if(m_SprintSound == none)
                    {
                        m_SprintSound = CreateAudioComponent(playaPawn.mSoundCue_SprintLooping, false, true);
                    }
                    // End:0x1D3
                    if(m_SprintSound != none)
                    {
                        m_SprintSound.Play();
                        m_SprintSound.AdjustVolume(0.0000000, 0.0000000);
                    }
                }                
            }
            else
            {
                // End:0x208
                if(fAmount > float(0))
                {
                    // End:0x208
                    if(m_SprintSound != none)
                    {
                        m_SprintSound.AdjustVolume(0.0000000, fAmount);
                    }
                }
            }
        }
        // End:0x25D
        if(spEffectsManager != none)
        {
            spEffectsManager.UpdateSprintEffect(fAmount, (fAmount * m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.SprintMaterialScalar)) * fSpeedScalar);
        }
        // End:0x33D
        if(playaPawn != none)
        {
            // End:0x2A5
            if((fAmount < (m_fAmBxOutOfBreathThreshold / 2.0000000)) && playaPawn.m_bPlayingAmBxOutOfBreath)
            {
                playaPawn.m_bFinishedPlayingAmBxOutOfBreath = true;
            }
            // End:0x2F9
            if((fAmount > m_fAmBxOutOfBreathThreshold) && !playaPawn.m_bPlayingAmBxOutOfBreath)
            {
                BuildAndSendScriptForStartingAmbxOutOfBreathEffect();
                playaPawn.m_bPlayingAmBxOutOfBreath = true;
                playaPawn.m_bFinishedPlayingAmBxOutOfBreath = false;
            }
            // End:0x33D
            if(playaPawn.m_bPlayingAmBxOutOfBreath && playaPawn.m_bFinishedPlayingAmBxOutOfBreath)
            {
                BuildAndSendScriptForStopingAmbxOutOfBreathEffect();
                playaPawn.m_bPlayingAmBxOutOfBreath = false;
            }
        }
    }
    //return;    
}

function ResetPlayerAim()
{
    local PlayerPawn lePlayerPawn;

    lePlayerPawn = PlayerPawn(Pawn);
    // End:0x30
    if(lePlayerPawn != none)
    {
        lePlayerPawn.SetPitchSkelControlPitch(0);
    }
    //return;    
}

simulated function OnSpCameraShake(SeqAct_SpCameraShake inAction)
{
    local ScreenShakeStruct DemoCameraShake;
    local float AmplitudeScale, FrequencyScale;

    // End:0x3C
    if(inAction.InputLinks[2].bHasImpulse)
    {
        RemoveCameraShakeById(inAction.Name);
        return;
    }
    AmplitudeScale = inAction.GlobalScale * inAction.GlobalAmplitudeScale;
    FrequencyScale = inAction.GlobalScale * inAction.GlobalFrequencyScale;
    DemoCameraShake = inAction.CameraShake;
    DemoCameraShake.TimeDuration *= inAction.GlobalScale;
    DemoCameraShake.RotAmplitude *= AmplitudeScale;
    DemoCameraShake.RotFrequency *= FrequencyScale;
    DemoCameraShake.LocAmplitude *= AmplitudeScale;
    DemoCameraShake.LocFrequency *= FrequencyScale;
    DemoCameraShake.FOVAmplitude *= AmplitudeScale;
    DemoCameraShake.FOVFrequency *= FrequencyScale;
    DemoCameraShake.Id = inAction.Name;
    // End:0x19A
    if(inAction.InputLinks[0].bHasImpulse)
    {
        PlayCameraShake(DemoCameraShake);        
    }
    else
    {
        // End:0x1DF
        if(inAction.InputLinks[1].bHasImpulse)
        {
            DemoCameraShake.TimeDuration = 9999999.0000000;
            PlayCameraShake(DemoCameraShake);
        }
    }
    //return;    
}

function StopAllShakes()
{
    local int I;

    // End:0x61
    if(PandoraPlayerCamera(PlayerCamera) != none)
    {
        PandoraPlayerCamera(PlayerCamera).PandoraCamMod_ScreenShake.super(PandoraPlayerController).StopAllShakes();
        I = 0;
        J0x36:

        // End:0x61 [Loop If]
        if(I < 6)
        {
            SendAmBxShake(1, 0.1000000, 1.0000000);
            ++I;
            // [Loop Continue]
            goto J0x36;
        }
    }
    //return;    
}

event PlayCameraShake(ScreenShakeStruct ScreenShake)
{
    local PandoraPlayerCamera Cam;

    Cam = PandoraPlayerCamera(PlayerCamera);
    // End:0x34
    if((Cam != none) && Cam.CameraBloodEmitter != none)
    {
        return;
    }
    // End:0x77
    if((Cam != none) && Pawn.IsFirstPerson())
    {
        Cam.PandoraCamMod_ScreenShake.AddScreenShake(ScreenShake);
    }
    //return;    
}

event RemoveCameraShakeById(name inId)
{
    local PandoraPlayerCamera Cam;

    Cam = PandoraPlayerCamera(PlayerCamera);
    // End:0x53
    if((Cam != none) && Pawn.IsFirstPerson())
    {
        Cam.PandoraCamMod_ScreenShake.RemoveShakeById(inId);
    }
    //return;    
}

function CameraShake(float Duration, Vector newRotAmplitude, Vector newRotFrequency, Vector newLocAmplitude, Vector newLocFrequency, float newFOVAmplitude, float newFOVFrequency)
{
    // End:0x56
    if(PandoraPlayerCamera(PlayerCamera) != none)
    {
        PandoraPlayerCamera(PlayerCamera).PandoraCamMod_ScreenShake.StartNewShake(Duration, newRotAmplitude, newRotFrequency, newLocAmplitude, newLocFrequency, newFOVAmplitude, newFOVFrequency);
    }
    //return;    
}

function PlayLocalizedShake(ScreenShakeStruct ScreenShake, Vector ShakeLocation, float ShakeRadius)
{
    local Rotator CamRot;
    local Vector CamLoc;
    local float DistToOrigin, Pct;

    // End:0x0F
    if(ShakeRadius <= float(0))
    {
        return;
    }
    GetPlayerViewPoint(CamLoc, CamRot);
    DistToOrigin = VSize(ShakeLocation - CamLoc);
    // End:0x14D
    if(DistToOrigin < ShakeRadius)
    {
        Pct = 1.0000000 - (DistToOrigin / ShakeRadius);
        ScreenShake.TimeDuration *= Pct;
        ScreenShake.RotAmplitude *= Pct;
        ScreenShake.RotFrequency *= Pct;
        ScreenShake.LocAmplitude *= Pct;
        ScreenShake.LocFrequency *= Pct;
        ScreenShake.FOVAmplitude *= Pct;
        ScreenShake.FOVFrequency *= Pct;
        // End:0x14D
        if((PandoraPlayerCamera(PlayerCamera) != none) && Pawn.IsFirstPerson())
        {
            PandoraPlayerCamera(PlayerCamera).PandoraCamMod_ScreenShake.AddScreenShake(ScreenShake);
        }
    }
    //return;    
}

exec function TriggerExplosion()
{
    //return;    
}

function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
    super(PlayerController).NotifyChangedWeapon(PreviousWeapon, NewWeapon);
    // End:0x23
    if(NewWeapon != none)
    {
        bWeaponSwitched = true;
    }
    //return;    
}

simulated function OnGiveInventory(SeqAct_GiveInventory inAction)
{
    local int Idx;
    local class<Inventory> InvClass;

    // End:0x46
    if(inAction.bClearExisting)
    {
        // End:0x46
        if(Pawn.InvManager != none)
        {
            Pawn.InvManager.DiscardInventory();
        }
    }
    // End:0xCD
    if(inAction.InventoryList.Length > 0)
    {
        Idx = 0;
        J0x63:

        // End:0xCA [Loop If]
        if(Idx < inAction.InventoryList.Length)
        {
            InvClass = inAction.InventoryList[Idx];
            // End:0xC0
            if(InvClass != none)
            {
                Pawn.CreateInventory(InvClass);
                // [Explicit Continue]
            }
            Idx++;
            // [Loop Continue]
            goto J0x63;
        }        
    }
    //return;    
}

simulated function OnModifyCameraOffset(SeqAct_ModifyCameraOffset Action)
{
    local PandoraPlayerCamera Cam;

    Cam = PandoraPlayerCamera(PlayerCamera);
    // End:0x176
    if(Cam != none)
    {
        // End:0xD7
        if(int(Action.Person) == int(0))
        {
            Cam.fp_Offset.X = Action.Offset.Forward;
            Cam.fp_Offset.Y = Action.Offset.Side;
            Cam.fp_Offset.Z = Action.Offset.Height;            
        }
        else
        {
            Cam.tp_Offset.X = Action.Offset.Forward;
            Cam.tp_Offset.Y = Action.Offset.Side;
            Cam.tp_Offset.Z = Action.Offset.Height;
        }
    }
    //return;    
}

simulated function OnLockPosition(SeqAct_LockPosition Action)
{
    LockPosition = Action.Locked;
    //return;    
}

function StopSprintBurstAndStartSprint()
{
    SetSprint(1);
    //return;    
}

function bool CanInteractWith()
{
    local Vector cameraLoc;
    local Rotator cameraRot;
    local array<Actor> useList;

    GetPlayerViewPoint(cameraLoc, cameraRot);
    GetTotalUseList(InteractDistance, 0.0000000, true, cameraLoc, cameraRot, useList);
    return useList.Length > 0;
    //return ReturnValue;    
}

function Actor FindClosestValidPickup()
{
    local SPWeaponPickupFactory bestPlacedPickup;
    local SPDroppedPickup bestDroppedPickup;
    local PlayerPawn thePlayerPawn;
    local float bestDroppedScore, bestPlacedScore;

    // End:0x0F
    if(CheckIfWithinUseTrigger())
    {
        return none;
    }
    thePlayerPawn = PlayerPawn(Pawn);
    // End:0x49
    if(thePlayerPawn != none)
    {
        bestPlacedPickup = thePlayerPawn.FindBestTouchingWeaponPickupFactories(bestPlacedScore);
    }
    // End:0x73
    if(thePlayerPawn != none)
    {
        bestDroppedPickup = thePlayerPawn.FindBestTouchingDroppedPickup(bestDroppedScore);
    }
    // End:0x8D
    if((bestDroppedPickup == none) && bestPlacedPickup == none)
    {
        return none;
    }
    // End:0x9E
    if(bestDroppedPickup == none)
    {
        return bestPlacedPickup;
    }
    // End:0xAF
    if(bestPlacedPickup == none)
    {
        return bestDroppedPickup;
    }
    // End:0xC4
    if(bestDroppedScore > bestPlacedScore)
    {
        return bestDroppedPickup;
    }
    return bestPlacedPickup;
    //return ReturnValue;    
}

function bool CanPerformUseAction()
{
    local Actor UseTarget;

    // End:0x24
    if((Pawn == none) || !Pawn.bCanUse)
    {
        return false;
    }
    // End:0x36
    if(Vehicle(Pawn) != none)
    {
        return false;
    }
    // End:0x45
    if(FindVehicleToDrive())
    {
        return true;
    }
    return ActorInteracted(UseTarget, true);
    //return ReturnValue;    
}

simulated function bool CheckIfWithinUseTrigger()
{
    local Trigger checkTrigger;
    local SeqEvent_Used UseSeq;
    local int Idx;

    // End:0xC6
    foreach Pawn.CollidingActors(Class'Engine.Trigger', checkTrigger, InteractDistance)
    {
        Idx = 0;
        J0x28:

        // End:0xC5 [Loop If]
        if(Idx < checkTrigger.GeneratedEvents.Length)
        {
            UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[Idx]);
            // End:0xBB
            if(UseSeq != none)
            {
                // End:0xBB
                if(VSizeSq(Pawn.Location - checkTrigger.Location) < (UseSeq.InteractDistance * UseSeq.InteractDistance))
                {                    
                    return true;
                }
            }
            Idx++;
            // [Loop Continue]
            goto J0x28;
        }        
    }    
    return false;
    //return ReturnValue;    
}

simulated event int CanDoStage2MiniGameInput()
{
    // End:0x68
    if(PlayerPawn(Pawn) != none)
    {
        // End:0x68
        if(tackleMinigameManager != none)
        {
            // End:0x68
            if(((tackleMinigameManager.IsState('ButtonMash1Pass') == true) || tackleMinigameManager.IsKillshotInProgress()) || IsBeingTackled())
            {
                return 1;
            }
        }
    }
    return 0;
    //return ReturnValue;    
}

simulated function DoReloadFromADSTransition()
{
    m_bWantsToLookDownSite = false;
    Reload();
    //return;    
}

exec function bool PCDoReload()
{
    return DoReload();
    //return ReturnValue;    
}

simulated function bool DoReload()
{
    local SPWeapon CurrWeapon;

    // End:0x17
    if(Pawn.Weapon == none)
    {
        return false;
    }
    CurrWeapon = SPWeapon(Pawn.Weapon);
    // End:0x3E
    if(CurrWeapon == none)
    {
        return false;
    }
    // End:0x4D
    if(IsWeaponSwitching())
    {
        return false;
    }
    // End:0x131
    if(!IsInWerewolfTackleState())
    {
        // End:0x11F
        if((!IsSprinting() && !CurrWeapon.MagazineFull()) && CurrWeapon.CanReload())
        {
            // End:0xF8
            if(PlayerPawn(Pawn) != none)
            {
                PlayerPawn(Pawn).DisableAnimusActivitiesFromServer();
                // End:0xF8
                if(PlayerPawn(Pawn).GetIsPartiallyLookingDownSite())
                {
                    m_bWantsToLookDownSite = true;
                    ClientDoUnLookDownSiteAndReload();
                    return true;
                }
            }
            // End:0x112
            if(int(Role) < int(ROLE_Authority))
            {
                ServerDoReload();
            }
            Reload();            
        }
        else
        {
            ClientAmmoBarAndPickupWeaponBarFadeIn(0.1000000);
        }        
    }
    else
    {
        // End:0x14B
        if((CanDoStage2MiniGameInput()) != 0)
        {
            TMGTransitionX();
        }
    }
    return true;
    //return ReturnValue;    
}

reliable server function bool ServerDoReload()
{
    return DoReload();
    //return ReturnValue;    
}

exec function AnimusUse()
{
    super(PlayerController).AnimusUse();
    //return;    
}

function bool PerformedAnimusUseAction()
{
    bHoldUse = true;
    // End:0x17
    if(IsWeaponSwitching())
    {
        return false;
    }
    m_bUsingAnimusUsedAndHeld = true;
    return PerformedUseAction();
    //return ReturnValue;    
}

exec function ReleaseAnimusUse()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        PerformedReleaseAnimusUseAction();
    }
    ServerReleaseAnimusUse();
    //return;    
}

reliable server function ServerReleaseAnimusUse()
{
    PerformedReleaseAnimusUseAction();
    //return;    
}

function PerformedReleaseAnimusUseAction()
{
    bHoldUse = false;
    m_bUsingAnimusUsedAndHeld = false;
    m_bTimerForWeaponPickupOrReload = true;
    PerformedReleaseUseAction();
    //return;    
}

exec function Use()
{
    super(PlayerController).Use();
    //return;    
}

simulated function bool PerformedUseAction()
{
    local Actor UseTarget;
    local SPWeaponPickupFactory bestPlacedPickup;
    local SPDroppedPickup bestDroppedPickup;
    local Actor bestActor;
    local SPInventoryManager spInvManager;
    local class<SPWeapon> SPWeaponType;
    local SPWeapon PickedUpWeapon;
    local int AmmoCountFromPickup, MagazineAmmoCountFromPickup;
    local bool bInteractedWithActor;

    bHoldUse = true;
    bInteractedWithActor = false;
    // End:0x1F
    if(IsWeaponSwitching())
    {
        return false;
    }
    // End:0x56
    if(WorldInfo.Pauser == PlayerReplicationInfo)
    {
        // End:0x54
        if(int(Role) == int(ROLE_Authority))
        {
            SetPause(false);
        }
        return true;
    }
    // End:0x7A
    if((Pawn == none) || !Pawn.bCanUse)
    {
        return true;
    }
    // End:0x8C
    if(int(Role) < int(ROLE_Authority))
    {
        return false;
    }
    // End:0xB4
    if(!m_bUsingAnimusUsedAndHeld && (CanCollectSwapWeaponOrPerformUse()) == 0)
    {
        return DoReload();
    }
    // End:0xD7
    if((Carried != none) || CarriedPawn != none)
    {
        return PrimeCarried();
    }
    m_bCanQuickSwap = false;
    bInteractedWithActor = ActorInteracted(UseTarget);
    // End:0x42D
    if(((Pawn.Weapon != none) && SPWeapon(Pawn.Weapon).IsLargeWeapon == true) && !bInteractedWithActor)
    {
        spInvManager = SPInventoryManager(Pawn.InvManager);
        bestActor = FindClosestValidPickup();
        bestPlacedPickup = SPWeaponPickupFactory(bestActor);
        bestDroppedPickup = SPDroppedPickup(bestActor);
        // End:0x226
        if(bestDroppedPickup != none)
        {
            SPWeaponType = bestDroppedPickup.SPWeaponType;
            AmmoCountFromPickup = bestDroppedPickup.AmmoCount;
            MagazineAmmoCountFromPickup = bestDroppedPickup.AmmoCountInMagazine;
            spInvManager.SetStoredSwapFlags(true);
            DiscardWeapon(SPWeaponType);
            bestDroppedPickup.Touch(Pawn, none, Location, vect(0.0000000, 0.0000000, 1.0000000));            
        }
        else
        {
            // End:0x2AB
            if(bestPlacedPickup != none)
            {
                SPWeaponType = bestPlacedPickup.SPWeaponType;
                AmmoCountFromPickup = bestPlacedPickup.AmmoAmount;
                spInvManager.SetStoredSwapFlags(true);
                DiscardWeapon(SPWeaponType);
                bestPlacedPickup.Touch(Pawn, none, Location, vect(0.0000000, 0.0000000, 1.0000000));
            }
        }
        // End:0x42D
        if((SPWeaponType != none) && spInvManager != none)
        {
            PickedUpWeapon = SPWeapon(spInvManager.FindInventoryType(SPWeaponType));
            // End:0x42D
            if(PickedUpWeapon != none)
            {
                // End:0x31A
                if(bestPlacedPickup != none)
                {
                    PickedUpWeapon.AddAmmoFromPickup(AmmoCountFromPickup);                    
                }
                else
                {
                    // End:0x369
                    if(bestDroppedPickup != none)
                    {
                        PickedUpWeapon.AddAmmoFromDroppedPickup(AmmoCountFromPickup, MagazineAmmoCountFromPickup);
                        spInvManager.SetPickupAmmoMessage(SPWeaponType, AmmoCountFromPickup + MagazineAmmoCountFromPickup);
                    }
                }
                // End:0x3C1
                if(PickedUpWeapon.IsLeftWeapon())
                {
                    SetWeaponSwapEffect(0.0000000, GetTopWeapID(), GetRightWeapID(), PickedUpWeapon.WeapID, GetBottomWeapID(), 3);                    
                }
                else
                {
                    SetWeaponSwapEffect(0.0000000, GetTopWeapID(), PickedUpWeapon.WeapID, GetLeftWeapID(), GetBottomWeapID(), 1);
                }
                Pawn.InvManager.SetCurrentWeapon(PickedUpWeapon);
                ReleaseUse();
                return true;
            }
        }
    }
    // End:0x457
    if(MountedWeapon != none)
    {
        MountedWeapon.Dismount(self);
        MountedWeapon = none;        
    }
    else
    {
        MountedWeapon = MountedWeapon(FindGoodOverlappingActor(Class'MountedWeapon'));
        // End:0x491
        if(MountedWeapon != none)
        {
            MountedWeapon.Mount(self);
        }
    }
    return bInteractedWithActor;
    //return ReturnValue;    
}

function DiscardWeapon(class<SPWeapon> SPWeaponType)
{
    local Vector TossVel;
    local SPInventoryManager spInvManager;
    local SPWeapon PawnWeapon;

    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    spInvManager = SPInventoryManager(Pawn.InvManager);
    // End:0x34
    if(spInvManager == none)
    {
        return;
    }
    // End:0x64
    if(SPWeaponType.default.IsMeleeWeapon)
    {
        PawnWeapon = spInvManager.GetMeleeWeaponInInventory();        
    }
    else
    {
        PawnWeapon = SPWeapon(Pawn.Weapon);
    }
    // End:0xEF
    if(PawnWeapon != none)
    {
        TossVel = Vector(Pawn.GetViewRotation());
        TossVel = (TossVel * ((Velocity Dot TossVel) + float(500))) + vect(0.0000000, 0.0000000, 200.0000000);
        PawnWeapon.MarkForDeath(TossVel);
    }
    //return;    
}

function Actor FindGoodOverlappingActor(class<Actor> theClass)
{
    local Actor W, Best;
    local Vector ViewDir, PawnLoc2D, VLoc2D;
    local float NewDot, BestDot;

    Best = none;
    // End:0x18
    if(Pawn == none)
    {
        return Best;
    }
    PawnLoc2D = Pawn.Location;
    PawnLoc2D.Z = 0.0000000;
    ViewDir = Vector(Pawn.Rotation);
    // End:0x11D
    foreach Pawn.OverlappingActors(theClass, W, 128.0000000,, true)
    {
        VLoc2D = W.Location;
        VLoc2D.Z = 0.0000000;
        NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
        // End:0x11C
        if((Best == none) || NewDot > BestDot)
        {
            // End:0x11C
            if(FastTrace(W.Location, Pawn.Location))
            {
                Best = W;
                BestDot = NewDot;
            }
        }        
    }    
    return Best;
    //return ReturnValue;    
}

exec function HidePlayer(bool hide)
{
    // End:0x3C
    if(Pawn != none)
    {
        // End:0x2B
        if(hide == true)
        {
            Pawn.SetHidden(true);            
        }
        else
        {
            Pawn.SetHidden(false);
        }
    }
    //return;    
}

simulated exec function SetHealth(int Val)
{
    Pawn.Health = Val;
    //return;    
}

simulated exec function DisableWWTackle()
{
    CantBeTackledTime = 10000000.0000000;
    //return;    
}

simulated exec function EnableWWTackle()
{
    CantBeTackledTime = 0.0000000;
    //return;    
}

simulated exec function EndNetGame()
{
    local PandoraGRI PGRI;

    // End:0x49
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        PGRI = PandoraGRI(WorldInfo.GRI);
        PGRI.SetIsInPostGame(true);
    }
    //return;    
}

simulated exec function OpenLeaderboard()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x27
    if(PGRI == none)
    {
        return;
    }
    PGRI.OpenLeaderboard();
    //return;    
}

exec function SetWWRegenRate(float Val)
{
    local SPBaseWerewolfPawnPersistent aWW;

    // End:0x39
    foreach WorldInfo.AllPawns(Class'SPBaseWerewolfPawnPersistent', aWW)
    {
        aWW.SetRegenRate(Val);        
    }    
    ClientMessage("WWRegenRate set");
    //return;    
}

exec function SetFDRegenRate(float Val)
{
    local SPFireDrakePawnPersistent aFD;

    // End:0x39
    foreach WorldInfo.AllPawns(Class'SPFireDrakePawnPersistent', aFD)
    {
        aFD.SetRegenRate(Val);        
    }    
    ClientMessage("FDRegenRate set");
    //return;    
}

exec function SetDynDmg(int Enable)
{
    // End:0x46
    if(Enable == 0)
    {
        WorldInfo.m_bUseDynamicDamage = false;
        ClientMessage("Dynamic Damage Disabled!");        
    }
    else
    {
        WorldInfo.m_bUseDynamicDamage = true;
        ClientMessage("Dynamic Damage Enabled.");
    }
    //return;    
}

exec function DumpStreamMem()
{
    DumpLevelsToScreen(Pawn, false, false);
    //return;    
}

exec function DumpStreamMemFull()
{
    DumpLevelsToScreen(Pawn, true, false);
    //return;    
}

exec function DumpStreamMemPackage()
{
    DumpLevelsToScreen(Pawn, true, true);
    //return;    
}

exec function EnableStreamLog()
{
    // End:0x2F
    if(WorldInfo.m_StreamedMemProfile == none)
    {
        WorldInfo.m_StreamedMemProfile = new (none) Class'Engine.StreamedMemProfile';
    }
    EnableStreamingLog();
    //return;    
}

exec function DisableStreamLog()
{
    DisableStreamingLog();
    //return;    
}

reliable server function ServerRestoreHealth()
{
    Pawn.Health = PlayerPawn(Pawn).HealthMax;
    //return;    
}

simulated exec function RestoreHealth()
{
    //return;    
}

exec function DestructCollisionLogging()
{
    SPPawn(Pawn).destructCollisionLog = !SPPawn(Pawn).destructCollisionLog;
    //return;    
}

exec function FOV(float F)
{
    local SPWeapon CurrWeapon;

    super(PlayerController).FOV(F);
    // End:0x54
    if(Pawn != none)
    {
        CurrWeapon = SPWeapon(Pawn.Weapon);
        // End:0x54
        if(CurrWeapon != none)
        {
            CurrWeapon.DetermineDestFOV(0.0000000);
        }
    }
    //return;    
}

exec event SPInputOn()
{
    IgnoreFiringInput(false);
    IgnoreJumpingInput(false);
    IgnoreCrouchingInput(false);
    IgnoreSprintInput(false);
    IgnoreAnimusPulseInput(false);
    IgnoreAnimusSiphonInput(false);
    IgnoreLookInput(false);
    IgnoreMoveInput(false);
    //return;    
}

exec event SPInputOff()
{
    IgnoreFiringInput(true);
    IgnoreJumpingInput(true);
    IgnoreCrouchingInput(true);
    IgnoreSprintInput(true);
    IgnoreAnimusPulseInput(true);
    IgnoreAnimusSiphonInput(true);
    IgnoreLookInput(true);
    IgnoreMoveInput(true);
    //return;    
}

exec function SPTestFOV(float F)
{
    // End:0x76
    if(bTestingFov == false)
    {
        // End:0x73
        if((F > float(0)) && F < float(170))
        {
            PreTestDefaultFov = PlayerCamera.GetDefaultFOV();
            bTestingFov = true;
            PlayerCamera.SetDefaultFOV(F);
            FOV(F);
        }        
    }
    else
    {
        // End:0xBE
        if((F > float(0)) && F < float(170))
        {
            PlayerCamera.SetDefaultFOV(F);
            FOV(F);            
        }
        else
        {
            PlayerCamera.SetDefaultFOV(PreTestDefaultFov);
            FOV(PreTestDefaultFov);
            bTestingFov = false;
        }
    }
    //return;    
}

exec function SPTestChangeHeightBy(float F)
{
    local PandoraPlayerCamera SPCamera;

    SPCamera = PandoraPlayerCamera(PlayerCamera);
    // End:0x8C
    if(SPCamera != none)
    {
        // End:0x5A
        if(F == float(0))
        {
            SPCamera.bTesting = false;
            SPCamera.viewPosOffset = vect(0.0000000, 0.0000000, 0.0000000);            
        }
        else
        {
            SPCamera.bTesting = true;
            SPCamera.viewPosOffset.Z = F;
        }
    }
    //return;    
}

exec function LogEquip()
{
    bLogEquip = !bLogEquip;
    //return;    
}

exec function LogSprint()
{
    bLogSprint = !bLogSprint;
    //return;    
}

exec function NetMode()
{
    bLogNet = !bLogNet;
    //return;    
}

reliable server function ServerRestoreAmmo()
{
    local Weapon nWeap;

    // End:0x7A
    foreach Pawn.InvManager.InventoryActors(Class'Engine.Weapon', nWeap)
    {
        SPWeapon(nWeap).AmmoCount = SPWeapon(nWeap).MaxAmmoCount;
        SPWeapon(nWeap).ammoInMagazine = SPWeapon(nWeap).magazineSize;        
    }    
    SPInventoryManager(Pawn.InvManager).SetGrenadeAmmo(1, 4);
    SPInventoryManager(Pawn.InvManager).SetGrenadeAmmo(2, 4);
    //return;    
}

simulated exec function RestoreAmmo()
{
    //return;    
}

exec function ChangeGamma(float gammaLevel)
{
    ChangeGammaConsole(gammaLevel);
    //return;    
}

exec function ToggleHUD()
{
    //return;    
}

exec function KillGG()
{
    local GoodGuyPawnPersistent P;

    // End:0x2D
    foreach WorldInfo.AllPawns(Class'GoodGuyPawnPersistent', P)
    {
        P.Destroy();        
    }    
    //return;    
}

exec function KillWW()
{
    local SPBaseWerewolfPawnPersistent P;

    // End:0x2D
    foreach WorldInfo.AllPawns(Class'SPBaseWerewolfPawnPersistent', P)
    {
        P.Destroy();        
    }    
    //return;    
}

exec function WWVel(float F)
{
    local SPBaseWerewolfPawnPersistent P;

    // End:0xC6
    foreach WorldInfo.AllPawns(Class'SPBaseWerewolfPawnPersistent', P)
    {
        // End:0x65
        if(VSize(P.Velocity) > 0.0000000)
        {
            P.Velocity = Normal(P.Velocity) * F;
            // End:0xC5
            continue;
        }
        P.Velocity.X = F;
        P.Velocity.Y = 0.0000000;
        P.Velocity.Z = 0.0000000;        
    }    
    Pawn.ClientMessage("Set all WW Vel to: " $ string(F));
    //return;    
}

exec function EnableFireDebug()
{
    Class'SPFireManager'.static.GetFireManager().bDrawDebug = true;
    //return;    
}

exec function DisableFireDebug()
{
    Class'SPFireManager'.static.GetFireManager().bDrawDebug = false;
    //return;    
}

simulated function UpdateWeaponDOFParameter()
{
    local SPMaterialEffectsManager spEffectsManager;
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x1D
    if(mySPHud == none)
    {
        return;
    }
    spEffectsManager = mySPHud.GetEffectsManager();
    // End:0x44
    if(spEffectsManager == none)
    {
        return;
    }
    spEffectsManager.UpdateDOFScalerParameter(PlayerPawn(Pawn).GetLookDownSitePercent());
    //return;    
}

exec function BreakFreeButtonMash()
{
    tackleMinigameManager.PushWerewolfOffPlayer();
    //return;    
}

exec function TMGTransitionA()
{
    // End:0x3D
    if(tackleMinigameManager.IsKillshotInProgress())
    {
        // End:0x3D
        if(tackleMinigameManager.CheckMashWinTransitionNumber() == 1)
        {
            BreakFreeButtonMash();
            return;
        }
    }
    // End:0x6B
    if(tackleMinigameManager.CheckMash1PassTransitionNumber() == 1)
    {
        tackleMinigameManager.TransitionToStages();
    }
    //return;    
}

exec function TMGTransitionX()
{
    // End:0x3E
    if(tackleMinigameManager.IsKillshotInProgress())
    {
        // End:0x3E
        if(tackleMinigameManager.CheckMashWinTransitionNumber() == 2)
        {
            BreakFreeButtonMash();
            return;
        }
    }
    // End:0x6D
    if(tackleMinigameManager.CheckMash1PassTransitionNumber() == 2)
    {
        tackleMinigameManager.TransitionToStages();
    }
    //return;    
}

exec function TMGTransitionY()
{
    // End:0x3E
    if(tackleMinigameManager.IsKillshotInProgress())
    {
        // End:0x3E
        if(tackleMinigameManager.CheckMashWinTransitionNumber() == 3)
        {
            BreakFreeButtonMash();
            return;
        }
    }
    // End:0x6D
    if(tackleMinigameManager.CheckMash1PassTransitionNumber() == 3)
    {
        tackleMinigameManager.TransitionToStages();
    }
    //return;    
}

function TurnLookDownSiteOffDuringTMG()
{
    local SPWeapon CurrWeapon;

    // End:0x90
    if(Pawn.Weapon != none)
    {
        CurrWeapon = SPWeapon(Pawn.Weapon);
        // End:0x90
        if(CurrWeapon != none)
        {
            // End:0x90
            if(PandoraPlayerCamera(PlayerCamera).GetCameraStyle() == 'LookDownSite')
            {
                PandoraPlayerCamera(PlayerCamera).SetCameraStyle('FirstPerson', 0.0000000);
                bPushedIsLookingDownSiteState = false;
            }
        }
    }
    //return;    
}

simulated exec function ToggleLookDownSite()
{
    local PlayerPawn thePawn;

    // End:0x0F
    if(IsFiringInputIgnored())
    {
        return;
    }
    thePawn = PlayerPawn(Pawn);
    // End:0x2C
    if(thePawn == none)
    {
        return;
    }
    // End:0x48
    if(int(thePawn.Physics) == int(9))
    {
        return;
    }
    // End:0x82
    if(thePawn.GetIsPartiallyLookingDownSite() || thePawn.m_bFireAxeBlocking)
    {
        UnLookDownSite();        
    }
    else
    {
        LookDownSite();
    }
    //return;    
}

function ReduceScreenShake()
{
    local PandoraGameInfo PGI;
    local ScreenShakeScaling scales;

    PGI = PandoraGameInfo(WorldInfo.Game);
    // End:0x34
    if((PGI == none) || m_GameplayGDTuneData == none)
    {
        return;
    }
    m_GameplayGDTuneData.GetScreenShakeScaling(scales);
    PGI.SetScreenShakeScaling(scales);
    //return;    
}

function UnReduceScreenShake()
{
    local PandoraGameInfo PGI;

    PGI = PandoraGameInfo(WorldInfo.Game);
    // End:0x27
    if(PGI == none)
    {
        return;
    }
    PGI.ResetScreenShakeScaling();
    //return;    
}

simulated function ActivateScopeViewMaterial()
{
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;

    mySPHud = GetSPHud();
    spEffectsManager = mySPHud.GetEffectsManager();
    // End:0x5C
    if((mySPHud != none) && spEffectsManager != none)
    {
        spEffectsManager.ToggleAssaultRifleScopeView(true, 0.0000000);
    }
    //return;    
}

simulated exec function LookDownSite()
{
    local PlayerPawn thePawn;
    local SPWeapon CurrWeapon;

    thePawn = PlayerPawn(Pawn);
    CurrWeapon = SPWeapon(Pawn.Weapon);
    // End:0x62
    if(((IsFiringInputIgnored()) && thePawn != none) && int(thePawn.m_eGrenadeState) != int(0))
    {
        return;
    }
    // End:0x8A
    if((CurrWeapon != none) && !CurrWeapon.CanWeaponLookDownSite())
    {
        return;
    }
    WeaponLockActivate();
    IgnoreAnimusPulseInput(true);
    IgnoreAnimusSiphonInput(true);
    // End:0xC6
    if(int(thePawn.Physics) == int(9))
    {
        return;
    }
    thePawn.SetIsTryingToLookDownSite(true);
    DoLookDownSite();
    //return;    
}

simulated function DoLookDownSite()
{
    local SPWeapon CurrWeapon;
    local float currLookDownSiteTransTime;
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;
    local SPHudScene hudUIScene;
    local PlayerPawn thePawn;

    thePawn = PlayerPawn(Pawn);
    // End:0x1D
    if(thePawn == none)
    {
        return;
    }
    // End:0x2F
    if((CanLookDownSite()) == false)
    {
        return;
    }
    // End:0x41
    if((IsInWerewolfTackleState()) == true)
    {
        return;
    }
    // End:0x5D
    if(int(thePawn.m_eGrenadeState) != int(0))
    {
        return;
    }
    CurrWeapon = SPWeapon(Pawn.Weapon);
    // End:0x84
    if(CurrWeapon == none)
    {
        return;
    }
    // End:0x9F
    if(!CurrWeapon.CanWeaponLookDownSite())
    {
        return;
    }
    thePawn.DisableAnimusActivitiesFromClient();
    thePawn.SetIsTryingToLookDownSite(true);
    WeaponLockActivate();
    mySPHud = GetSPHud();
    spEffectsManager = ((mySPHud != none) ? mySPHud.GetEffectsManager() : none);
    // End:0x197
    if(((thePawn.playerHud != none) && CurrWeapon != none) && !CurrWeapon.bHudless)
    {
        hudUIScene = thePawn.playerHud.HudScene;
        // End:0x197
        if(hudUIScene != none)
        {
            hudUIScene.AmmoBarFadeIn();
            hudUIScene.PickupWeaponBarFadeIn();
        }
    }
    // End:0x2FC
    if((CurrWeapon != none) && !thePawn.GetIsFullyLookingDownSite())
    {
        currLookDownSiteTransTime = CurrWeapon.LookDownSiteTransTime;
        // End:0x2AE
        if(!bLookDownSiteDisabled && CurrWeapon.HasLookDownSiteSocket())
        {
            // End:0x234
            if(CurrWeapon.CanWeaponLookDownSite())
            {
                PandoraPlayerCamera(PlayerCamera).SetCameraStyle('LookDownSite', currLookDownSiteTransTime);
            }
            OnSprintStop();
            ReduceScreenShake();
            // End:0x2AE
            if(CurrWeapon.WeapID == 'AssaultRifle')
            {
                SetTimer(m_GameplayGDTuneData.ScopeViewFadeInTime * 0.7500000, false, 'SetAssaultRifleScopePPETimer');
                m_bCanUseScope = true;
                SetTimer(m_GameplayGDTuneData.ScopeViewFadeInTime, false, 'ActivateScopeViewMaterial');
            }
        }
        bPushedIsLookingDownSiteState = true;
        CurrWeapon.DetermineDestFOV(currLookDownSiteTransTime);
        // End:0x2F9
        if((spEffectsManager != none) && CurrWeapon.WeapID != 'AssaultRifle')
        {
        }        
    }
    else
    {
        // End:0x353
        if(((CurrWeapon != none) && !thePawn.GetIsFullyLookingDownSite()) && CurrWeapon.WeapID == 'FireAxe')
        {
            thePawn.m_bFireAxeBlocking = false;
        }
    }
    CurrWeapon.SetADSCameraTurnValue(0.0000000, true);
    CurrWeapon.SetADSCameraLookValue(0.0000000, true);
    //return;    
}

simulated exec function UnLookDownSite(optional bool bDoFastTrans)
{
    local PlayerPawn thePawn;

    thePawn = PlayerPawn(Pawn);
    // End:0x3C
    if((IsFiringInputIgnored()) && int(thePawn.Physics) != int(9))
    {
        return;
    }
    WeaponLockDeActivate();
    IgnoreAnimusPulseInput(false);
    IgnoreAnimusSiphonInput(false);
    DoUnLookDownSite(bDoFastTrans);
    thePawn.SetIsTryingToLookDownSite(false);
    //return;    
}

reliable client simulated function ClientDoUnLookDownSiteAndReload()
{
    DoUnLookDownSiteAndReload();
    //return;    
}

simulated function DoUnLookDownSiteAndReload()
{
    DoUnLookDownSite();
    m_bWantsToLookDownSite = true;
    //return;    
}

simulated function DoUnLookDownSite(optional bool bDoFastTrans)
{
    local SPWeapon CurrWeapon;
    local float currLookDownSiteTransTime;
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;
    local PlayerPawn thePawn;

    thePawn = PlayerPawn(Pawn);
    // End:0x23
    if((IsInWerewolfTackleState()) == true)
    {
        return;
    }
    WeaponLockDeActivate();
    UnReduceScreenShake();
    mySPHud = GetSPHud();
    // End:0x6C
    if(mySPHud != none)
    {
        spEffectsManager = mySPHud.GetEffectsManager();
    }
    CurrWeapon = SPWeapon(Pawn.Weapon);
    // End:0x93
    if(CurrWeapon == none)
    {
        return;
    }
    // End:0xC4
    if(CurrWeapon.WeapID == 'FireAxe')
    {
        thePawn.m_bFireAxeBlocking = false;
        return;
    }
    // End:0x100
    if(CurrWeapon != none)
    {
        // End:0xF2
        if(!bDoFastTrans)
        {
            currLookDownSiteTransTime = CurrWeapon.LookDownSiteTransTime;            
        }
        else
        {
            currLookDownSiteTransTime = 0.1000000;
        }        
    }
    else
    {
        currLookDownSiteTransTime = 0.5000000;
    }
    // End:0x186
    if(thePawn.GetIsPartiallyLookingDownSite() || thePawn.GetIsTryingToLookDownSite())
    {
        PandoraPlayerCamera(PlayerCamera).SetCameraStyle('FirstPerson', currLookDownSiteTransTime);
        // End:0x186
        if(CurrWeapon != none)
        {
            CurrWeapon.DetermineDestFOV(currLookDownSiteTransTime);
        }
    }
    bPushedIsLookingDownSiteState = false;
    ClearTimer('SetAssaultRifleScopePPETimer');
    // End:0x22A
    if(CurrWeapon.WeapID == 'AssaultRifle')
    {
        Pawn.Weapon.Mesh.SetHidden(false);
        m_bCanUseScope = false;
        ClearTimer('ActivateScopeViewMaterial');
        // End:0x22A
        if((mySPHud != none) && spEffectsManager != none)
        {
            spEffectsManager.ToggleAssaultRifleScopeView(false, 0.0000000);
        }
    }
    // End:0x235
    if(spEffectsManager != none)
    {
    }
    CurrWeapon.SetADSCameraTurnValue(0.0000000, true);
    CurrWeapon.SetADSCameraLookValue(0.0000000, true);
    //return;    
}

function ResetLookDownSiteState(optional bool bDoFastTrans)
{
    // End:0x2D
    if(PlayerPawn(Pawn).GetIsPartiallyLookingDownSite())
    {
        DoUnLookDownSite(bDoFastTrans);
    }
    //return;    
}

event ResetAndPushLookDownSiteState(optional bool bDoFastTrans)
{
    // End:0x35
    if(PlayerPawn(Pawn).GetIsFullyLookingDownSite())
    {
        DoUnLookDownSite(bDoFastTrans);
        bPushedIsLookingDownSiteState = true;
    }
    bLookDownSiteDisabled = true;
    //return;    
}

event RestorePushedLookDownSiteState()
{
    bLookDownSiteDisabled = false;
    // End:0x39
    if(bPushedIsLookingDownSiteState)
    {
        // End:0x39
        if(!PlayerPawn(Pawn).GetIsPartiallyLookingDownSite())
        {
            DoLookDownSite();
        }
    }
    //return;    
}

function bool CanLookDownSite()
{
    // End:0x17
    if(Pawn.Weapon == none)
    {
        return false;
    }
    // End:0x38
    if(int(PlayerPawn(Pawn).m_eGrenadeState) == int(1))
    {
        return false;
    }
    // End:0x47
    if(IsWeaponSwitching())
    {
        return false;
    }
    // End:0x73
    if((SPPawn(Pawn) != none) && SPPawn(Pawn).IsReloading())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated exec function WeaponLockActivate()
{
    WeaponLockRequest(true);
    //return;    
}

simulated exec function WeaponLockDeActivate()
{
    WeaponLockRequest(false);
    //return;    
}

simulated function WeaponLockRequest(bool bRequested)
{
    local PlayerPawn PlayerPawn;
    local SPRocketLauncherPersistent RocketLauncher;

    // End:0x1C
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        return;
    }
    PlayerPawn = PlayerPawn(Pawn);
    // End:0x85
    if(PlayerPawn != none)
    {
        RocketLauncher = SPRocketLauncherPersistent(PlayerPawn.Weapon);
        // End:0x85
        if(RocketLauncher != none)
        {
            Class'SPWeapon'.static.RequestLock(RocketLauncher.m_lock, bRequested);
        }
    }
    //return;    
}

exec function StartSprintFOV()
{
    local SPWeapon CurrWeapon;
    local float currSprintFOVTransTime;

    // End:0x68
    if(Pawn.Weapon != none)
    {
        CurrWeapon = SPWeapon(Pawn.Weapon);
        // End:0x68
        if(CurrWeapon != none)
        {
            currSprintFOVTransTime = CurrWeapon.SprintFOVTransTime;
            CurrWeapon.DetermineSprintFOV(currSprintFOVTransTime);
        }
    }
    //return;    
}

exec function StopSprintFOV(optional bool bDoFastTrans)
{
    local SPWeapon CurrWeapon;
    local float currSprintFOVTransTime;

    // End:0x9B
    if(Pawn.Weapon != none)
    {
        CurrWeapon = SPWeapon(Pawn.Weapon);
        // End:0x6C
        if(CurrWeapon != none)
        {
            // End:0x5E
            if(!bDoFastTrans)
            {
                currSprintFOVTransTime = CurrWeapon.SprintFOVTransTime;                
            }
            else
            {
                currSprintFOVTransTime = 0.1000000;
            }            
        }
        else
        {
            currSprintFOVTransTime = 0.5000000;
        }
        // End:0x9B
        if(CurrWeapon != none)
        {
            CurrWeapon.DetermineDestFOV(currSprintFOVTransTime);
        }
    }
    //return;    
}

function bool CanPlayerReloadOrSwap()
{
    local SPWeapon CurrWeapon;

    // End:0x17
    if(Pawn.Weapon == none)
    {
        return false;
    }
    CurrWeapon = SPWeapon(Pawn.Weapon);
    // End:0x3E
    if(CurrWeapon == none)
    {
        return false;
    }
    // End:0x92
    if((!CurrWeapon.MagazineFull() && CurrWeapon.CanReload()) && !PlayerPawn(Pawn).IsSiphoning())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

exec function Reload()
{
    local SPWeapon CurrWeapon;
    local PlayerPawn pPawn;

    // End:0x0B
    if(m_bWeaponPickupOrReload)
    {
        return;
    }
    // End:0x1A
    if(IsFiringInputIgnored())
    {
        return;
    }
    // End:0x31
    if(Pawn.Weapon == none)
    {
        return;
    }
    CurrWeapon = SPWeapon(Pawn.Weapon);
    // End:0x58
    if(CurrWeapon == none)
    {
        return;
    }
    pPawn = PlayerPawn(Pawn);
    // End:0x75
    if(pPawn == none)
    {
        return;
    }
    // End:0x91
    if(int(pPawn.m_eGrenadeState) != int(0))
    {
        return;
    }
    // End:0xBA
    if(PandoraPlayerInput(PlayerInput) != none)
    {
        PandoraPlayerInput(PlayerInput).AnimusDeActivate();
    }
    // End:0x118
    if(!CurrWeapon.MagazineFull() && CurrWeapon.CanReload())
    {
        pPawn.RemoveAllActiveSiphonStreams();
        CurrWeapon.GotoState('Reloading');
    }
    //return;    
}

exec function Weapon1()
{
    ChooseWeapon(1);
    //return;    
}

exec function Weapon2()
{
    ChooseWeapon(2);
    //return;    
}

exec function Weapon3()
{
    ChooseWeapon(3);
    //return;    
}

exec function Weapon4()
{
    ChooseWeapon(4);
    //return;    
}

exec function DismountPlayer()
{
    local MountedWeapon mountWpn;

    mountWpn = GetMountedWeapon();
    // End:0x3B
    if(mountWpn != none)
    {
        mountWpn.Dismount(self);
        SetMountedWeapon(none);
    }
    //return;    
}

function ChooseWeapon(int Num)
{
    local SPInventoryManager InvManager;

    // End:0x17
    if(Pawn.InvManager == none)
    {
        return;
    }
    InvManager = SPInventoryManager(Pawn.InvManager);
    // End:0x3E
    if(InvManager == none)
    {
        return;
    }
    InvManager.SelectWeapon(Num);
    //return;    
}

function MountedWeapon GetMountedWeapon()
{
    return MountedWeapon;
    //return ReturnValue;    
}

function SetMountedWeapon(MountedWeapon theWeapon)
{
    MountedWeapon = theWeapon;
    //return;    
}

function DisableHandToHandFiring()
{
    local PlayerPawn thePawn;

    thePawn = PlayerPawn(Pawn);
    // End:0x8A
    if(thePawn.m_bHandToHandFiring == true)
    {
        thePawn.m_bHandToHandFiring = false;
        thePawn.m_bEnableMultipleHits = false;
        thePawn.m_bDoMultipleHit = false;
        thePawn.m_bResetAction = true;
        thePawn.m_fireAxeState = 3;
        StopFiringFromHandToHand();
    }
    //return;    
}

event NotifyBeginTentacleGrab(AIController Controller)
{
    m_TentacleController = SPSewerTentacleAIController(Controller);
    DisableHandToHandFiring();
    PushState('TentacleGrab');
    //return;    
}

simulated function bool IsInTentacleGrabState()
{
    return false;
    //return ReturnValue;    
}

function SetTentacleGrabViewRotation(Rotator ViewRotation)
{
    m_TentacleGrabViewRotation = ViewRotation;
    //return;    
}

function bool IsInLookDownSiteState()
{
    return bPushedIsLookingDownSiteState;
    //return ReturnValue;    
}

event NotifyBeginTackle(AIController TMGController)
{
    m_werewolfMinigameController = SPBaseWerewolfAIController(TMGController);
    InitializeTMGPostProcessing();
    TurnLookDownSiteOffDuringTMG();
    DisableHandToHandFiring();
    PushState('WerewolfTackle');
    //return;    
}

function CheckTMGAllignment()
{
    //return;    
}

event WerewolfTackleGetUpEnded()
{
    //return;    
}

event EndTackle()
{
    //return;    
}

event ResetTimer()
{
    //return;    
}

event EndTackleFromAnimation()
{
    //return;    
}

function SwapToMeleeWeaponIfApplicable()
{
    //return;    
}

simulated function bool IsInWerewolfTackleState()
{
    return false;
    //return ReturnValue;    
}

function bool TimeForTackle()
{
    return m_bTimeForTackle;
    //return ReturnValue;    
}

function bool TimeForHitAndRunMinigame()
{
    return m_bTimeForHitAndRunMinigame;
    //return ReturnValue;    
}

function SetWerewolfTackleViewRotation(Rotator ViewRotation)
{
    m_tackleViewRotation = ViewRotation;
    //return;    
}

function SetWerewolfTackler(SPBaseWerewolfAIController wwController)
{
    m_werewolfTackler = wwController;
    //return;    
}

function TACKLETIMER()
{
    m_bTimeForTackle = true;
    //return;    
}

function HITANDRUNMINIGAMETIMER()
{
    m_bTimeForHitAndRunMinigame = true;
    //return;    
}

function Controller GetCurrentTMGEnemy()
{
    return none;
    //return ReturnValue;    
}

function ResetPlayerMinigameFromCheckpoint()
{
    // End:0x2A
    if(Pawn != none)
    {
        Pawn.SetCollision(true, true);
        Pawn.SetPhysics(1);
    }
    NoLongerBeingTackled();
    DoUnLookDownSite(true);
    SetTimer(5.0000000, false, 'TACKLETIMER');
    m_actionState = 0;
    GotoState('ResumePlayerControl');
    //return;    
}

function StartMinigameTackleAction(PandoraPlayerController.ePlayerActionState actionState, optional float animSynchTime)
{
    //return;    
}

event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
{
    local PlayerPawn thePawn;

    thePawn = PlayerPawn(Pawn);
    // End:0x59
    if(thePawn != none)
    {
        // End:0x47
        if(thePawn.DidWeFallFarEnoughToPlayJumpLandSound())
        {
            thePawn.PlayJumpLandSound();
        }
        thePawn.bInAir = false;
    }
    return bUpdating;
    //return ReturnValue;    
}

function BlendPlayerMinigameTackleAnimationsStage1(SPAnimGenericFunctionBlendNode Node)
{
    m_TMGBlendState = 1;
    Node.TargetWeight[0] = m_blendValueForMash1Animations;
    Node.TargetWeight[1] = 1.0000000 - m_blendValueForMash1Animations;
    //return;    
}

function BlendPlayerMinigameTackleAnimationsStage2(SPAnimGenericFunctionBlendNode Node)
{
    m_TMGBlendState = 2;
    Node.TargetWeight[0] = m_blendValueForMash2Animations;
    Node.TargetWeight[1] = 1.0000000 - m_blendValueForMash2Animations;
    //return;    
}

function InitializeTMGPostProcessing()
{
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;

    mySPHud = GetSPHud();
    // End:0x1D
    if(mySPHud == none)
    {
        return;
    }
    spEffectsManager = mySPHud.GetEffectsManager();
    // End:0x56
    if(spEffectsManager != none)
    {
        spEffectsManager.ActivateTMGEffect();
    }
    //return;    
}

function UpdateTMGPostProcessing()
{
    local float currentBlendValue;
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;

    mySPHud = GetSPHud();
    // End:0x1D
    if(mySPHud == none)
    {
        return;
    }
    spEffectsManager = mySPHud.GetEffectsManager();
    // End:0x44
    if(spEffectsManager == none)
    {
        return;
    }
    // End:0xCD
    if(spEffectsManager.m_bTMGMaterialActive)
    {
        // End:0x77
        if(m_TMGBlendState == 1)
        {
            currentBlendValue = 1.0000000 - m_blendValueForMash1Animations;            
        }
        else
        {
            // End:0x98
            if(m_TMGBlendState == 2)
            {
                currentBlendValue = 1.0000000 - m_blendValueForMash2Animations;                
            }
            else
            {
                currentBlendValue = 0.0000000;
            }
        }
        spEffectsManager.UpdateTMGEffect(currentBlendValue * m_GameplayGDTuneData.TMGPostProcessingEffect);
    }
    //return;    
}

function DisableTMGPostProcessing()
{
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;

    mySPHud = GetSPHud();
    // End:0x1D
    if(mySPHud == none)
    {
        return;
    }
    spEffectsManager = mySPHud.GetEffectsManager();
    // End:0x56
    if(spEffectsManager != none)
    {
        spEffectsManager.DeActivateTMGEffect();
    }
    //return;    
}

function SetMinigameAnim(Actor.EMinigameStage stage, Actor.EMinigameState Condition)
{
    local PlayerPawn lePawn;

    lePawn = PlayerPawn(Pawn);
    switch(stage)
    {
        // End:0x28
        case 0:
            m_actionState = 1;
            // End:0x63
            break;
        // End:0x38
        case 1:
            m_actionState = 2;
            // End:0x63
            break;
        // End:0x48
        case 2:
            m_actionState = 3;
            // End:0x63
            break;
        // End:0x50
        case 3:
            // End:0x63
            break;
        // End:0x60
        case 4:
            m_actionState = 0;
            // End:0x63
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xCD
    if((Pawn != none) && Pawn.Mesh != none)
    {
        // End:0xCD
        if(lePawn != none)
        {
            // End:0xB8
            if(int(m_actionState) != int(0))
            {
                lePawn.EnablePitchSkelControl(false);                
            }
            else
            {
                lePawn.EnablePitchSkelControl(true);
            }
        }
    }
    m_minigameState = Condition;
    // End:0x15A
    if((int(m_actionState) == int(1)) && int(Condition) > int(0))
    {
        // End:0x119
        if(lePawn != none)
        {
            lePawn.GiveKnifeToPlayer();
        }
        lePawn.KnifeComponent.SetFOV(SPSkeletalMeshComponent(Pawn.Mesh).GetFOV());
    }
    //return;    
}

// Export UPandoraPlayerController::execGetDeltaRotationToFace(FFrame&, void* const)
native final function Rotator GetDeltaRotationToFace(Vector CurrentRot, Vector desiredRot, float rotRate, float DeltaTime);

event NotifyBeginWerewolfHitAndRun(AIController hitAndRunController)
{
    m_werewolfMinigameController = SPBaseWerewolfAIController(hitAndRunController);
    PushState('WerewolfHitAndRun');
    //return;    
}

function StartAlignment()
{
    //return;    
}

function NotifyEndWerewolfHitAndRun()
{
    //return;    
}

function ForceInterruptReload()
{
    local SPWeapon PawnWeapon;

    // End:0x44
    if(Pawn != none)
    {
        PawnWeapon = SPWeapon(Pawn.Weapon);
        // End:0x44
        if(PawnWeapon != none)
        {
            PawnWeapon.ForceInterruptReload();
        }
    }
    //return;    
}

exec function dline()
{
    //return;    
}

exec function DrawPt(float X, float Y, float Z)
{
    local Vector pos;

    pos.X = X;
    pos.Y = Y;
    pos.Z = Z;
    DrawDebugLine(pos, pos + vect(0.0000000, 0.0000000, 1000.0000000), 255, 0, 0, true);
    //return;    
}

exec function SetDebugTarget(name TargetName)
{
    local SPPawn A;

    // End:0x64
    foreach WorldInfo.AllPawns(Class'SPPawn', A)
    {
        // End:0x63
        if(A.Name == TargetName)
        {
            DebugPawn = A;
            ClientMessage("Set Debug Pawn!");            
            return;
        }        
    }    
    ClientMessage("Failed to set debug pawn");
    //return;    
}

exec function SetNextDebugTarget(name TargetName)
{
    local SPPawn A;

    // End:0x6B
    foreach WorldInfo.AllPawns(Class'SPPawn', A)
    {
        // End:0x6A
        if(A.Name == TargetName)
        {
            SecondDebugPawn = A;
            ClientMessage("Set Second Debug Pawn!");            
            return;
        }        
    }    
    ClientMessage("Failed to set second debug pawn");
    //return;    
}

exec function ShowPhysTarget()
{
    ClientMessage(string(DebugPawn));
    //return;    
}

exec function GetPawnLocation()
{
    ClientMessage(string(DebugPawn.Location));
    //return;    
}

exec function SetPawnLocation(float X, float Y, float Z)
{
    local Vector pos;

    pos.X = X;
    pos.Y = Y;
    pos.Z = Z;
    DebugPawn.SetLocation(pos);
    //return;    
}

exec function GetGroundLocation()
{
    local Vector HitLocation, HitNormal, traceStart, traceEnd, HeightVec;

    HeightVec = vect(0.0000000, 0.0000000, 1.0000000) * float(50);
    traceStart = DebugPawn.Location + HeightVec;
    traceEnd = DebugPawn.Location - HeightVec;
    // End:0x86
    if(Trace(HitLocation, HitNormal, traceEnd, traceStart, false) != none)
    {
        ClientMessage(string(HitLocation));
    }
    //return;    
}

function SetDebugPawnOnGround()
{
    local Vector HitLocation, HitNormal, traceStart, traceEnd, HeightVec;

    DebugPawn.Mesh.bUpdateKinematicBonesFromAnimation = false;
    HeightVec = vect(0.0000000, 0.0000000, 1.0000000) * float(50);
    traceStart = DebugPawn.Location + HeightVec;
    traceEnd = DebugPawn.Location - HeightVec;
    // End:0xA2
    if(Trace(HitLocation, HitNormal, traceEnd, traceStart, false) != none)
    {
        DebugPawn.SetLocation(HitLocation);
    }
    DebugPawn.SetPhysics(7);
    //return;    
}

exec function BreakTest()
{
    ClientMessage("BreakTest Called");
    SPBaseWerewolfPawnPersistent(DebugPawn).DetachHeadBone();
    //return;    
}

exec function WWHeight()
{
    ClientMessage(string(SPBaseWerewolfPawnPersistent(DebugPawn).ActorOriginHeight));
    //return;    
}

exec function WWRecover2()
{
    //return;    
}

exec function PhysNone()
{
    DebugPawn.SetPhysics(0);
    //return;    
}

exec function PhysRB()
{
    DebugPawn.SetPhysics(10);
    //return;    
}

exec function PhysNorm()
{
    DebugPawn.EnableMotors(false);
    DebugPawn.AttemptPhysAnimState_Fixed(true);
    DebugPawn.PopState();
    DebugPawn.SetPhysics(1);
    SPAIController(DebugPawn.Controller).EnableAI(true);
    DebugPawn.Mesh.SetComponentRBFixed(true);
    //return;    
}

exec function SetPW(float Val)
{
    DebugPawn.Mesh.SetPhysicsWeight(Val);
    //return;    
}

function int GetTimianYawFromDirVect(Vector vDir)
{
    local float theta, vMag;
    local Vector vDirNorm;
    local int Timians;

    vMag = VSize(vDir);
    vDirNorm.X = vDir.X / vMag;
    vDirNorm.Y = vDir.Y / vMag;
    vDirNorm.Z = 0.0000000;
    theta = Acos(vDirNorm.X);
    Pawn.ClientMessage((("vDir.X: " $ string(vDir.X)) $ " Theta: ") $ string(theta));
    // End:0x183
    if((((vDirNorm.X < float(0)) && vDirNorm.Y < float(0)) || (vDirNorm.X > float(0)) && vDirNorm.Y < float(0)) || (vDirNorm.X == float(0)) && vDirNorm.Y < float(0))
    {
        theta = 6.2831850 - theta;
    }
    Timians = int((float(65535) * theta) / 6.2831850);
    Pawn.ClientMessage((("Theta: " $ string(theta)) $ " Timians: ") $ string(Timians));
    return Timians;
    //return ReturnValue;    
}

event NotifyDeathBlow()
{
    Pawn.ClientMessage("HIT NOTIFY DEATHBLOW (PlayerController):  this is obsolete");
    //return;    
}

exec function WhereAmI()
{
    Pawn.ClientMessage("I'm at: " $ string(Pawn.Location));
    //return;    
}

exec function LifeForce(float Percent)
{
    local PlayerController PC;
    local PlayerPawn PP;
    local float Scale;

    Scale = float(Clamp(int(Percent), 0, 100)) / 100.0000000;
    // End:0x42
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        // End:0x40
        if(Pawn != none)
        {
        }
        return;
    }
    // End:0xC0
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xBF
        if(PC.Pawn != none)
        {
            PP = PlayerPawn(PC.Pawn);
            // End:0xBF
            if(PP != none)
            {
                PP.LifeForce = PP.maxLifeForce * Scale;
            }
        }        
    }    
    //return;    
}

exec function TeamStat()
{
    local PandoraGRI PGRI;
    local PlayerPawn P;
    local byte TeamID;
    local int I;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x17C
    if(PGRI != none)
    {
        I = 0;
        J0x2C:

        // End:0x10F [Loop If]
        if(I < PGRI.m_TeamColors.Length)
        {
            DBG_MsgPPC((((((((("C: " @ string(I)) @ " - (") @ string(PGRI.m_TeamColors[I].R)) @ ",") @ string(PGRI.m_TeamColors[I].G)) @ ",") @ string(PGRI.m_TeamColors[I].B)) @ ",") @ string(PGRI.m_TeamColors[I].A));
            I++;
            // [Loop Continue]
            goto J0x2C;
        }
        // End:0x178
        foreach WorldInfo.AllPawns(Class'PlayerPawn', P)
        {
            TeamID = P.GetTeamNum();
            DBG_MsgPPC((("P: " @ string(P)) @ " TeamdID: ") @ string(TeamID));            
        }                
    }
    else
    {
        DBG_MsgPPC("Can't get PandoraGRI!");
    }
    //return;    
}

exec function ColorSync()
{
    local PlayerPawn P;

    // End:0x34
    foreach WorldInfo.AllPawns(Class'PlayerPawn', P)
    {
        P.AssignMPColorByTeam();        
    }    
    DBG_MsgPPC("Colors re-assigned");
    //return;    
}

simulated function bool DetachCarriedObject()
{
    local Vector cameraLoc;
    local Rotator cameraRot;
    local Vector NewLoc;

    NewLoc = Carried.Location;
    // End:0x30
    if(!FindSpotToDropItemFrom(Carried, NewLoc))
    {
        return false;
    }
    Carried.DetachObject(true);
    Carried.SetLocation(NewLoc);
    Carried.StaticMeshComponent.SetRBPosition(NewLoc);
    Carried.SetCollision(true, true, false);
    Carried.CollisionComponent.SetBlockRigidBody(true);
    Carried.SetPhysics(10);
    GetPlayerViewPoint(cameraLoc, cameraRot);
    cameraRot.Pitch += int(m_ThrowItemRotationOffset);
    // End:0x122
    if(fCarryThrowPrimeTime > m_ThrowItemTimingThreshold)
    {
        Carried.CollisionComponent.AddImpulse(Normal(Vector(cameraRot)) * m_ThrowItemImpulse,,, false, 0.0000000, 0.0000000);
    }
    Carried = none;
    Pawn.bNoWeaponFiring = false;
    LastDropTime = WorldInfo.TimeSeconds;
    return true;
    //return ReturnValue;    
}

simulated function AttachCarriedObject(DynamicSMActor NewCarried)
{
    local Vector SocketLocation;
    local Rotator SocketRotation;

    Carried = NewCarried;
    Carried.SetPhysics(0);
    Pawn.AttachObject(Carried, m_CarrySocket, SocketLocation, SocketRotation, false, false);
    Carried.SetCollision(false, false, false);
    Carried.CollisionComponent.SetBlockRigidBody(false);
    Pawn.bNoWeaponFiring = true;
    //return;    
}

function bool ActorInteracted(out Actor UseTarget, optional bool bInquiry)
{
    local Actor A;
    local int Idx;
    local float Weight;
    local bool bInserted;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local array<Actor> useList, sortedList;
    local array<float> weightList;
    local Trigger trig;

    UseTarget = none;
    // End:0x15
    if(Pawn == none)
    {
        return false;
    }
    // End:0x2F
    if((Carried != none) || CarriedPawn != none)
    {
        return true;
    }
    GetPlayerViewPoint(cameraLoc, cameraRot);
    GetTotalUseList(InteractDistance, 0.0000000, true, cameraLoc, cameraRot, useList);
    // End:0x2D9
    if(useList.Length > 0)
    {
        J0x73:

        // End:0x1CB [Loop If]
        if(useList.Length > 0)
        {
            A = useList[useList.Length - 1];
            useList.Length = useList.Length - 1;
            Weight = Normal(A.Location - cameraLoc) Dot Vector(cameraRot);
            Weight += (1.0000000 - (VSize(A.Location - Pawn.Location) / InteractDistance));
            bInserted = false;
            Idx = 0;
            J0x111:

            // End:0x18F [Loop If]
            if((Idx < sortedList.Length) && !bInserted)
            {
                // End:0x185
                if(weightList[Idx] < Weight)
                {
                    sortedList.Insert(Idx, 1);
                    weightList.Insert(Idx, 1);
                    sortedList[Idx] = A;
                    weightList[Idx] = Weight;
                    bInserted = true;
                }
                Idx++;
                // [Loop Continue]
                goto J0x111;
            }
            // End:0x1C8
            if(!bInserted)
            {
                Idx = sortedList.Length;
                sortedList[Idx] = A;
                weightList[Idx] = Weight;
            }
            // [Loop Continue]
            goto J0x73;
        }
        Idx = 0;
        J0x1D2:

        // End:0x2D9 [Loop If]
        if(Idx < sortedList.Length)
        {
            // End:0x259
            if(sortedList[Idx].IsA('Trigger'))
            {
                trig = Trigger(sortedList[Idx]);
                // End:0x224
                if(bInquiry)
                {
                    return true;                    
                }
                else
                {
                    // End:0x256
                    if(trig.GeneratedEvents[Idx].CheckActivate(trig, Pawn, false))
                    {
                        return true;
                    }
                }
                // [Explicit Continue]
                goto J0x2CF;
            }
            // End:0x29A
            if(bInquiry)
            {
                // End:0x297
                if(sortedList[Idx].CanBeUsed(Pawn))
                {
                    UseTarget = sortedList[Idx];
                    return true;
                }
                // [Explicit Continue]
                goto J0x2CF;
            }
            // End:0x2CF
            if(sortedList[Idx].UsedBy(Pawn))
            {
                UseTarget = sortedList[Idx];
                return true;
            }
            J0x2CF:

            Idx++;
            // [Loop Continue]
            goto J0x1D2;
        }
    }
    return false;
    //return ReturnValue;    
}

function GetTotalUseList(float interactDistanceToCheck, float minDot, bool bUsableOnly, Vector cameraLoc, Rotator cameraRot, out array<Actor> out_useList)
{
    local DynamicSMActor checkActor;
    local Trigger checkTrigger;
    local SPPDAMessagePickupFactory PDAMessagePickup;

    // End:0x5B
    foreach Pawn.CollidingActors(Class'Engine.Trigger', checkTrigger, interactDistanceToCheck)
    {
        // End:0x5A
        if(IsValidTriggerToActivate(checkTrigger, bUsableOnly, minDot, cameraLoc, cameraRot))
        {
            out_useList[out_useList.Length] = checkTrigger;
        }        
    }    
    // End:0xAC
    foreach Pawn.CollidingActors(Class'Engine.DynamicSMActor', checkActor, interactDistanceToCheck)
    {
        // End:0xAB
        if(IsValidDynamicSMActorForPickup(checkActor, cameraLoc, cameraRot))
        {
            out_useList[out_useList.Length] = checkActor;
        }        
    }    
    // End:0xF7
    foreach Pawn.CollidingActors(Class'SPPDAMessagePickupFactory', PDAMessagePickup, interactDistanceToCheck)
    {
        // End:0xF6
        if(PDAMessagePickup.m_bAutoPickup != true)
        {
            out_useList[out_useList.Length] = PDAMessagePickup;
        }        
    }    
    //return;    
}

function bool IsValidTriggerToActivate(Trigger checkTrigger, bool bUsableOnly, float minDot, Vector cameraLoc, Rotator cameraRot)
{
    local int Idx;
    local SeqEvent_Used UseSeq;
    local float TriggerDot;

    TriggerDot = m_GameplayGDTuneData.TriggerDotRange;
    // End:0x32
    if(TriggerDot > 1.0000000)
    {
        TriggerDot = 1.0000000;        
    }
    else
    {
        // End:0x4C
        if(TriggerDot < 0.0000000)
        {
            TriggerDot = 0.0000000;
        }
    }
    Idx = 0;
    J0x53:

    // End:0x1A2 [Loop If]
    if(Idx < checkTrigger.GeneratedEvents.Length)
    {
        UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[Idx]);
        // End:0x9B
        if(UseSeq == none)
        {
            // [Explicit Continue]
            goto J0x198;
        }
        // End:0xBE
        if(UseSeq.bOverrideUseButton && !m_bUsingAnimusUsedAndHeld)
        {
            // [Explicit Continue]
            goto J0x198;
        }
        // End:0xFE
        if(bUsableOnly && !checkTrigger.GeneratedEvents[Idx].CheckActivate(checkTrigger, Pawn, true))
        {
            // [Explicit Continue]
            goto J0x198;
        }
        // End:0x12C
        if((Normal(checkTrigger.Location - cameraLoc) Dot Vector(cameraRot)) < minDot)
        {
            // [Explicit Continue]
            goto J0x198;
        }
        // End:0x165
        if(VSize(Pawn.Location - checkTrigger.Location) > UseSeq.InteractDistance)
        {
            // [Explicit Continue]
            goto J0x198;
        }
        // End:0x196
        if(UseSeq.bAimToInteract && !IsAimingAt(checkTrigger, TriggerDot))
        {
            // [Explicit Continue]
            goto J0x198;
        }
        return true;
        J0x198:

        Idx++;
        // [Loop Continue]
        goto J0x53;
    }
    return false;
    //return ReturnValue;    
}

function bool IsValidRagdollForPickup(Pawn checkPawn, Vector cameraLoc, Rotator cameraRot)
{
    // End:0x100
    if(((int(checkPawn.Physics) == int(10)) && checkPawn.Mesh == checkPawn.CollisionComponent) && checkPawn.Mesh.bHasPhysicsAssetInstance)
    {
        // End:0x100
        if(Pawn != none)
        {
            // End:0x100
            if(((Normal(checkPawn.Location - cameraLoc) Dot Vector(cameraRot)) >= m_PickupItemMinFacingAngle) && (VSize(Pawn.Location - checkPawn.Location) - (Pawn.GetCollisionRadius() + checkPawn.CollisionComponent.Bounds.SphereRadius)) <= m_PickupItemMaxDistance)
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsValidDynamicSMActorForPickup(DynamicSMActor checkActor, Vector cameraLoc, Rotator cameraRot)
{
    // End:0xCA
    if(checkActor.IsPickup() && !Pawn.IsBasedOn(checkActor))
    {
        // End:0xCA
        if(((Normal(checkActor.Location - cameraLoc) Dot Vector(cameraRot)) >= m_PickupItemMinFacingAngle) && (VSize(Pawn.Location - checkActor.Location) - (Pawn.GetCollisionRadius() + checkActor.CollisionComponent.Bounds.SphereRadius)) <= m_PickupItemMaxDistance)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function bool AttemptPickupPawn(Pawn Pickup, bool bInquiry)
{
    return false;
    //return ReturnValue;    
}

simulated function bool AttemptPickup(DynamicSMActor Pickup, bool bInquiry)
{
    local bool bCanPickup;

    bCanPickup = (LastDropTime + 0.5000000) < WorldInfo.TimeSeconds;
    // End:0x41
    if(bInquiry || !bCanPickup)
    {
        return bCanPickup;
    }
    AttachCarriedObject(Pickup);
    return true;
    //return ReturnValue;    
}

simulated function AttachCarriedPawn(Pawn NewCarried)
{
    local Vector SocketLocation;
    local Rotator SocketRotation;

    CarriedPawn = NewCarried;
    CarriedPawn.SetPhysics(0);
    Pawn.AttachObject(CarriedPawn, 'PawnCarry', SocketLocation, SocketRotation, false, false);
    CarriedPawn.SetCollision(false, false, CarriedPawn.bIgnoreEncroachers);
    SoldierPawn(CarriedPawn).m_actionState = 9;
    Pawn.bNoWeaponFiring = true;
    //return;    
}

simulated function bool DetachCarriedPawn()
{
    local Vector cameraLoc;
    local Rotator cameraRot;

    CarriedPawn.DetachObject(true);
    CarriedPawn.bCollideWorld = true;
    CarriedPawn.SetPhysics(10);
    SoldierPawn(CarriedPawn).m_actionState = 0;
    GetPlayerViewPoint(cameraLoc, cameraRot);
    cameraRot.Pitch += int(m_ThrowItemRotationOffset);
    // End:0xBD
    if(fCarryThrowPrimeTime > m_ThrowItemTimingThreshold)
    {
        CarriedPawn.CollisionComponent.AddImpulse(Normal(Vector(cameraRot)) * m_ThrowItemImpulse,,, false, 0.0000000, 0.0000000);
    }
    CarriedPawn = none;
    Pawn.bNoWeaponFiring = false;
    LastDropTime = WorldInfo.TimeSeconds;
    return true;
    //return ReturnValue;    
}

function SaveCurrFOV()
{
    local SPWeapon CurrWeapon;

    // End:0x80
    if(Pawn.Weapon != none)
    {
        CurrWeapon = SPWeapon(Pawn.Weapon);
        bExhausted = true;
        m_oldWorldFOV = CurrWeapon.GetCurrWorldFOV();
        m_oldWeaponFOV = CurrWeapon.GetCurrFOV();
        exhaustLastTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

function DoExhaustedFOVChange(float fatigueAmt)
{
    local float newWorldFOV, newWeaponFOV;
    local SPWeapon CurrWeapon;
    local float fovChange;
    local PlayerPawn thePlayer;

    thePlayer = PlayerPawn(Pawn);
    // End:0x3F
    if(Pawn.Weapon != none)
    {
        CurrWeapon = SPWeapon(Pawn.Weapon);
    }
    fovChange = -m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.SprintFOVAmount) * fatigueAmt;
    newWorldFOV = fovChange * Sin((WorldInfo.TimeSeconds * float(2)) * 3.1415930);
    newWeaponFOV = newWorldFOV;
    newWorldFOV += m_oldWorldFOV;
    newWeaponFOV += m_oldWeaponFOV;
    // End:0x126
    if(((fatigueAmt < 1.0000000) && CurrWeapon != none) && (thePlayer != none) && !thePlayer.GetIsPartiallyLookingDownSite())
    {
        CurrWeapon.SetDestFOV(newWeaponFOV, newWorldFOV, 0.0000000);
    }
    //return;    
}

function RestoreCurrFOV()
{
    local SPWeapon CurrWeapon;
    local PlayerPawn thePlayer;

    thePlayer = PlayerPawn(Pawn);
    // End:0x8A
    if((Pawn.Weapon != none) && (thePlayer != none) && !thePlayer.GetIsPartiallyLookingDownSite())
    {
        CurrWeapon = SPWeapon(Pawn.Weapon);
        CurrWeapon.SetDestFOV(m_oldWeaponFOV, m_oldWorldFOV, exhaustTime);
    }
    bExhausted = false;
    //return;    
}

simulated function OnToggleSPHUD(SeqAct_ToggleSPHud inAction)
{
    local SPHud mySPHud;

    // End:0x183
    if(myHUD != none)
    {
        mySPHud = SPHud(myHUD);
        // End:0x28
        if(mySPHud == none)
        {
            return;
        }
        // End:0x6C
        if(inAction.InputLinks[2].bHasImpulse)
        {
            mySPHud.ToggleNewHud(inAction.FadeTime);
        }
        // End:0xF9
        if(inAction.InputLinks[0].bHasImpulse)
        {
            // End:0xC8
            if(myHUD.bShowHUD != true)
            {
                mySPHud.ToggleNewHud(inAction.FadeTime);                
            }
            else
            {
                mySPHud.HudScene.FadeIn(inAction.FadeTime);
            }            
        }
        else
        {
            // End:0x183
            if(inAction.InputLinks[1].bHasImpulse)
            {
                // End:0x155
                if(myHUD.bShowHUD == true)
                {
                    mySPHud.ToggleNewHud(inAction.FadeTime);                    
                }
                else
                {
                    mySPHud.HudScene.FadeOut(inAction.FadeTime);
                }
            }
        }
    }
    //return;    
}

exec function bool CheckPointExists()
{
    return SPCM.HasCheckpoint();
    //return ReturnValue;    
}

reliable client simulated function ClientEndOfGameAchievements(bool bStarted, bool bDied, bool bWon, bool bFirstPlace, int nWerewolfKills, int nPlayerKills, int nTeamA, int nTeamB, int nAnimus)
{
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    // End:0x6F
    if(LocPlayer != none)
    {
        ProfileSettings.Achievements_EndOfRankedGame(LocPlayer.ControllerId, bStarted, bDied, bWon, bFirstPlace, nWerewolfKills, nPlayerKills, nTeamA, nTeamB, nAnimus);
    }
    WriteProfile();
    //return;    
}

reliable client simulated function ClientNewWeaponFiredAchievement(SPEquippedWeaponNode.SPWeaponType nWeaponNumber)
{
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    // End:0x55
    if((LocPlayer != none) && int(nWeaponNumber) != int(0))
    {
        ProfileSettings.Achievement_FiredWeapon(LocPlayer.ControllerId, nWeaponNumber);
    }
    //return;    
}

function SinglePlayerNewWeaponFiredAchievement(SPEquippedWeaponNode.SPWeaponType nWeaponNumber)
{
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    // End:0x55
    if((LocPlayer != none) && int(nWeaponNumber) != int(0))
    {
        ProfileSettings.Achievement_SinglePlayerFiredWeapon(LocPlayer.ControllerId, nWeaponNumber);
    }
    //return;    
}

function SinglePlayerFireAxeKillAchievement()
{
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    // End:0x3E
    if(LocPlayer != none)
    {
        ProfileSettings.Achievement_SinglePlayerFireAxeKill(LocPlayer.ControllerId);
    }
    //return;    
}

function SinglePlayerAnimusPulseUsedAchievement()
{
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    // End:0x3E
    if(LocPlayer != none)
    {
        ProfileSettings.Achievement_SinglePlayerAnimusPulseUsed(LocPlayer.ControllerId);
    }
    //return;    
}

event bool FindAvailableTeleportSpot(SPPawn TestPawn, optional NavigationPoint TeleportAnchor, optional bool bSkipRadiusSearch)
{
    local array<NavigationPoint> NavList;
    local NavigationPoint Nav;
    local Vector ChkLoc, NavLoc;
    local int Idx;

    // End:0xC9
    if(TeleportAnchor != none)
    {
        Nav = TeleportAnchor;
        NavLoc = Nav.Location;
        // End:0xB1
        if(CanSpawnAtLocation(NavLoc, TestPawn.GetCollisionExtent(), Nav))
        {
            // End:0xB1
            if(TestPawn.SetLocation(Nav.Location))
            {
                SetRotation(Nav.Rotation);
                ClientSetRotation(Nav.Rotation, true);
                TestPawn.SetPhysics(2);
                return true;
            }
        }
        ChkLoc = TeleportAnchor.Location;        
    }
    else
    {
        ChkLoc = ((Pawn != none) ? Pawn.Location : Location);
    }
    // End:0x22A
    if(!bSkipRadiusSearch)
    {
        Class'Engine.NavigationPoint'.static.GetAllNavInRadius(TestPawn, ChkLoc, 1024.0000000, NavList);
        Idx = 0;
        J0x129:

        // End:0x22A [Loop If]
        if(Idx < NavList.Length)
        {
            Nav = NavList[Idx];
            // End:0x220
            if(Abs(Nav.Location.Z - ChkLoc.Z) < TestPawn.GetCollisionHeight())
            {
                NavLoc = Nav.Location;
                // End:0x220
                if(CanSpawnAtLocation(NavLoc, TestPawn.GetCollisionExtent(), Nav))
                {
                    // End:0x220
                    if(TestPawn.SetLocation(NavLoc))
                    {
                        SetRotation(Nav.Rotation);
                        ClientSetRotation(Nav.Rotation, true);
                        TestPawn.SetPhysics(2);
                        return true;
                    }
                }
            }
            Idx++;
            // [Loop Continue]
            goto J0x129;
        }
    }
    return false;
    //return ReturnValue;    
}

exec function TestNewCheckpoints()
{
    SPCM.ToggleCheckpointMethod();
    //return;    
}

reliable client simulated function ClientPlayerCleanupBeforeCheckpointOrTransition()
{
    ForceStopAmBxScript("MenuStopAll");
    ForceStopAmBxScript("WeaponStopAll");
    //return;    
}

function PlayerCleanupBeforeCheckpointOrTransition()
{
    CleanupBeforeCheckpointOrTransitionNative();
    ClientPlayerCleanupBeforeCheckpointOrTransition();
    //return;    
}

function OnLoadLastCheckpoint(SeqAct_LoadLastCheckpoint Action)
{
    local PandoraPlayerController PC;
    local PandoraSPGameInfo spGameInfo;
    local PandoraGameViewportClient pvc;

    pvc = PandoraGameViewportClient(GetViewportClient());
    // End:0x40
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {
        PC.ClientStopForceFeedbackWaveform();        
    }    
    spGameInfo = PandoraSPGameInfo(WorldInfo.Game);
    // End:0x9C
    if((spGameInfo != none) && pvc != none)
    {
        spGameInfo.CleanupBeforeCheckpointTransition();
        pvc.OpenLoadLastCheckpointMenu(self);
    }
    //return;    
}

function ResetHudAndDisableMaterialEffects()
{
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;

    mySPHud = GetSPHud();
    // End:0x8E
    if(mySPHud != none)
    {
        spEffectsManager = mySPHud.GetEffectsManager();
        // End:0x54
        if(spEffectsManager != none)
        {
            spEffectsManager.DisableAllMaterialEffects();
        }
        mySPHud.Reset();
        mySPHud.CloseHudScene();
        mySPHud.bShowHUD = false;
    }
    // End:0xB7
    if(LocalPlayer(Player) != none)
    {
        LocalPlayer(Player).UnloadVolumeMaterialEffects();
    }
    //return;    
}

function UnifiedPreTransitionCleanup()
{
    local PandoraPlayerController PC;

    ResetHudAndDisableMaterialEffects();
    CleanupWeapons();
    PandoraPlayerInput(PlayerInput).ResetOverrides();
    PlayerPawn(Pawn).EmptyCachedTouchedActors();
    ResetPlayerMinigameFromCheckpoint();
    // End:0x84
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {
        PC.SetCinematicMode(false, false, true, true, true, true);        
    }    
    // End:0xD2
    if(PandoraGameInfo(WorldInfo.Game).ActiveSlomoManager != none)
    {
        PandoraGameInfo(WorldInfo.Game).ActiveSlomoManager.ClearNotifyArray();
    }
    // End:0x156
    if(currOnScreenText.Scene != none)
    {
        CloseScene(PC.currOnScreenText.Scene, false);
        currOnScreenText.DialogDuration = 0.0000000;
        currOnScreenText.DialogDurationLeft = 0.0000000;
        currOnScreenText.Action.bIsCompleted = true;
    }
    //return;    
}

function UnifiedPostTransitionCleanup()
{
    local SPHud HUD;
    local PandoraPlayerController PC;

    // End:0x87
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {
        PC.SetCinematicMode(false, false, true, true, true, true);
        PC.SPInputOn();
        PC.PlayerCamera.bEnableFading = false;
        PC.PlayerCamera.FadeAmount = 0.0000000;        
    }    
    WorldInfo.ForceGarbageCollection();
    SetUTracing(false);
    HUD = SPHud(myHUD);
    // End:0x13F
    if(HUD != none)
    {
        HUD.bShowHUD = true;
        // End:0x13C
        if(HUD.HudScene == none)
        {
            HUD.CreateHudScene();
            HUD.HudScene.SetVisibility(true);
            HUD.HudScene.FadeIn(2.0000000);            
        }        
    }
    ResetPickupMessageActorState();
    ClearAllSquadBias();
    ProfileSettings.SetProfileBusy(false);
    StartSprintEffect();
    //return;    
}

// Export UPandoraPlayerController::execClearAllSquadBias(FFrame&, void* const)
native function ClearAllSquadBias();

function RealLoadLastCheckpoint(optional bool bLoadFromMainMenu = false)
{
    PlayerForceDelayedCheckpointSave();
    SPCM.bLoadingCheckpoint = true;
    UnifiedPreTransitionCleanup();
    PandoraGameInfo(WorldInfo.Game).CleanupBeforeCheckpointTransition();
    // End:0x93
    if(SPCM.CheckpointData.Length == 0)
    {
        // End:0x93
        if((SPCM.CurrCheckpoint == none) || SPCM.LoadCheckpointData())
        {
        }
    }
    // End:0xC7
    if(SPCM.CheckpointData.Length > 0)
    {
        SPCM.DelayedLoadCheckpoint(self, bLoadFromMainMenu);        
    }
    else
    {
        SPCM.bLoadingCheckpoint = false;
    }
    //return;    
}

event PostLoadCheckpoint()
{
    UnifiedPostTransitionCleanup();
    SPCM.bLoadingCheckpoint = false;
    //return;    
}

reliable client simulated function ClientDisplayCheckpointText()
{
    local SPHud mySPHud;

    // End:0x36
    if(myHUD != none)
    {
        mySPHud = SPHud(myHUD);
        // End:0x36
        if(mySPHud != none)
        {
            mySPHud.StartDrawingCheckpointText();
        }
    }
    //return;    
}

reliable client simulated function ClientSpawnCameraBlood(class<Emit_CameraBlood> CamBloodEmitterClass)
{
    local Vector CamLoc;
    local Rotator CamRot;
    local PandoraPlayerCamera Cam;

    Cam = PandoraPlayerCamera(PlayerCamera);
    // End:0xDB
    if(((Cam != none) && CamBloodEmitterClass != none) && Cam.CameraBloodEmitter == none)
    {
        Cam.CameraBloodEmitter = Spawn(CamBloodEmitterClass, self);
        // End:0xDB
        if(Cam.CameraBloodEmitter != none)
        {
            GetPlayerViewPoint(CamLoc, CamRot);
            Cam.CameraBloodEmitter.UpdateLocation(CamLoc, CamRot, 80.0000000);
            Cam.CameraBloodEmitter.RegisterCamera(Cam);
        }
    }
    //return;    
}

simulated exec function TestCameraBlood()
{
    ClientSpawnCameraBlood(Class'Emit_CameraBlood');
    //return;    
}

function NotifyDeviceSelectComplete(bool bWasSuccessful)
{
    local int DeviceID;
    local OnlinePlayerInterfaceEx PlayerInterfaceEx;

    // End:0x20
    if(OnlineSub != none)
    {
        PlayerInterfaceEx = OnlineSub.PlayerInterfaceEx;
    }
    // End:0xE4
    if(bWasSuccessful && ProfileSettings != none)
    {
        // End:0xE4
        if(NotEqual_InterfaceInterface(PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            DeviceID = PlayerInterfaceEx.GetDeviceSelectionResults(byte(LocalPlayer(Player).ControllerId), DeviceName);
            ProfileSettings.SetCurrentDeviceID(DeviceID);
            WriteProfile();
            bCanSaveToDevice = true;
            bReSaveCheckpoint = true;
            // End:0xE4
            if(bReSaveCheckpoint)
            {
                // End:0xE4
                if(SPCM != none)
                {
                    SPCM.SaveCheckpoint();
                    bReSaveCheckpoint = false;
                }
            }
        }
    }
    // End:0x12F
    if(NotEqual_InterfaceInterface(PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(byte(LocalPlayer(Player).ControllerId), NotifyDeviceSelectComplete);        
    }
    //return;    
}

delegate OnDeviceSelectionComplete(bool bWasSuccessful)
{
    //return;    
}

function bool SelectDevice(int SizeNeeded, optional delegate<OnDeviceSelectionComplete> InDelegate, optional bool bForceShowUI = true)
{
    local OnlinePlayerInterfaceEx PlayerIntEx;

    // End:0xE2
    if(OnlineSub != none)
    {
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        // End:0xDD
        if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
        {
            PlayerIntEx.AddDeviceSelectionDoneDelegate(byte(LocalPlayer(Player).ControllerId), InDelegate);
            // End:0xD8
            if(PlayerIntEx.ShowDeviceSelectionUI(byte(LocalPlayer(Player).ControllerId), SizeNeeded, bForceShowUI) == false)
            {
                PlayerIntEx.ClearDeviceSelectionDoneDelegate(byte(LocalPlayer(Player).ControllerId), InDelegate);
                return false;
            }
            return true;            
        }
        else
        {
            return false;
        }        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

event Destroyed()
{
    ResetHudAndDisableMaterialEffects();
    // End:0x4B
    if(PDAManager != none)
    {
        PDAManager.myPC = none;
        PDAManager.myGameInfo = none;
        PDAManager.Destroyed();
    }
    SetSquad(none);
    super(PlayerController).Destroyed();
    //return;    
}

function CheckPointMenu_UpdateButtons()
{
    local int I, CurCheckpoint;

    CurCheckpoint = CheckPointMenuStartIdx;
    I = 0;
    J0x12:

    // End:0x10A [Loop If]
    if(I < 7)
    {
        // End:0xCA
        if(CurCheckpoint < CheckPoints.Length)
        {
            btnCheckPoint[I].SetCaption(CheckPoints[CurCheckpoint].Title);
            lblCheckpoint[I].SetValue(CheckPoints[CurCheckpoint].CheckpointName);
            btnCheckPoint[I].SetVisibility(true);
            lblCheckpoint[I].SetVisibility(true);
            CurCheckpoint++;
            // [Explicit Continue]
            goto J0x100;
        }
        btnCheckPoint[I].SetVisibility(false);
        lblCheckpoint[I].SetVisibility(false);
        J0x100:

        I++;
        // [Loop Continue]
        goto J0x12;
    }
    //return;    
}

function bool IsInputNavUp(const InputEventParameters EventParms)
{
    // End:0xB2
    if((((EventParms.InputKeyName == 'XboxTypeS_DPad_Up') || EventParms.InputKeyName == 'Gamepad_LeftStick_Up') || !WorldInfo.IsConsoleBuild() && EventParms.InputKeyName == 'Up') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputNavDown(const InputEventParameters EventParms)
{
    // End:0xB2
    if((((EventParms.InputKeyName == 'XboxTypeS_DPad_Down') || EventParms.InputKeyName == 'Gamepad_LeftStick_Down') || !WorldInfo.IsConsoleBuild() && EventParms.InputKeyName == 'Down') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool HandleCheckpointKeyInput(const out InputEventParameters EventParms)
{
    local UIScene_BaseFrontEnd ActiveScene;
    local SPGameUISceneClient theSceneClient;

    theSceneClient = GetSceneClient();
    // End:0x5E
    if(theSceneClient != none)
    {
        ActiveScene = UIScene_BaseFrontEnd(theSceneClient.GetActiveScene());
        // End:0x5E
        if(ActiveScene != none)
        {
            ActiveScene.UpDateUsingGamePadForPC(EventParms);
        }
    }
    // End:0xA5
    if(IsInputNavUp(EventParms))
    {
        // End:0xA2
        if(btnCheckPoint[0].IsFocused())
        {
            // End:0xA2
            if(CheckPointMenuStartIdx > 0)
            {
                CheckPointMenuStartIdx--;
                CheckPointMenu_UpdateButtons();
            }
        }        
    }
    else
    {
        // End:0xF6
        if(IsInputNavDown(EventParms))
        {
            // End:0xF6
            if(btnCheckPoint[7 - 1].IsFocused())
            {
                // End:0xF6
                if((CheckPointMenuStartIdx + 7) < CheckPoints.Length)
                {
                    CheckPointMenuStartIdx++;
                    CheckPointMenu_UpdateButtons();
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

exec function CheckPointMenuSelect()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x69 [Loop If]
    if(I < 7)
    {
        // End:0x5F
        if(btnCheckPoint[I].IsFocused())
        {
            CheckPointMenuLoad(CheckPoints[CheckPointMenuStartIdx + I]);
            GetUIController().CloseScene(CPMenuScene);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

reliable client simulated event UIScene OpenScene(UIScene Scene, optional bool bFadeScreen)
{
    local UIInteraction UIController;
    local UIScene OpenedScene;

    UIController = GetUIController();
    // End:0x42
    if(UIController != none)
    {
        // End:0x42
        if(UIController.super(PandoraPlayerController).OpenScene(Scene, LocalPlayer(Player), OpenedScene))
        {            
        }
    }
    return OpenedScene;
    //return ReturnValue;    
}

reliable client simulated event CloseSceneType(class<UIScene> SceneType)
{
    local UIInteraction UIController;
    local UIScene ActiveScene;

    UIController = GetUIController();
    // End:0x81
    if(UIController != none)
    {
        // End:0x81
        if(UIController.SceneClient != none)
        {
            ActiveScene = UIController.SceneClient.GetActiveScene();
            // End:0x81
            if(ActiveScene.Class == SceneType)
            {
                UIController.CloseScene(ActiveScene);                
            }
        }
    }
    //return;    
}

function UIScene OpenSceneLocal(UIScene Scene)
{
    local UIInteraction UIController;
    local UIScene OpenedScene;

    UIController = GetUIController();
    // End:0x40
    if(UIController != none)
    {
        // End:0x40
        if(!UIController.OpenScene(Scene, LocalPlayer(Player), OpenedScene))
        {
        }
    }
    return OpenedScene;
    //return ReturnValue;    
}

exec function CheckPointMenu()
{
    local LocalPlayer SceneOwner;
    local UIInteraction UIController;
    local bool Result;

    // End:0x2F6
    if(CheckPointMenuUIScene != none)
    {
        UIController = GetUIController();
        SceneOwner = LocalPlayer(Player);
        Result = UIController.OpenScene(CheckPointMenuUIScene, SceneOwner, CPMenuScene);
        // End:0x2F6
        if(Result)
        {
            btnCheckPoint[0] = UILabelButton(CPMenuScene.FindChild('btnCheckpoint1', true));
            btnCheckPoint[1] = UILabelButton(CPMenuScene.FindChild('btnCheckpoint2', true));
            btnCheckPoint[2] = UILabelButton(CPMenuScene.FindChild('btnCheckpoint3', true));
            btnCheckPoint[3] = UILabelButton(CPMenuScene.FindChild('btnCheckpoint4', true));
            btnCheckPoint[4] = UILabelButton(CPMenuScene.FindChild('btnCheckpoint5', true));
            btnCheckPoint[5] = UILabelButton(CPMenuScene.FindChild('btnCheckpoint6', true));
            btnCheckPoint[6] = UILabelButton(CPMenuScene.FindChild('btnCheckpoint7', true));
            lblCheckpoint[0] = UILabel(CPMenuScene.FindChild('lblCheckpoint1', true));
            lblCheckpoint[1] = UILabel(CPMenuScene.FindChild('lblCheckpoint2', true));
            lblCheckpoint[2] = UILabel(CPMenuScene.FindChild('lblCheckpoint3', true));
            lblCheckpoint[3] = UILabel(CPMenuScene.FindChild('lblCheckpoint4', true));
            lblCheckpoint[4] = UILabel(CPMenuScene.FindChild('lblCheckpoint5', true));
            lblCheckpoint[5] = UILabel(CPMenuScene.FindChild('lblCheckpoint6', true));
            lblCheckpoint[6] = UILabel(CPMenuScene.FindChild('lblCheckpoint7', true));
            btnCheckPoint[0].__OnRawInputKey__Delegate = HandleCheckpointKeyInput;
            btnCheckPoint[7 - 1].__OnRawInputKey__Delegate = HandleCheckpointKeyInput;
            PopulateCheckPointSceneUI(CheckPointMenuUIScene);
            // End:0x2EC
            if(CheckPoints.Length == 0)
            {
                UIController.CloseScene(CheckPointMenuUIScene);
            }
            CheckPointMenu_UpdateButtons();
        }
    }
    //return;    
}

exec function QuickMenu()
{
    //return;    
}

function QuickMenuUpdate()
{
    local SPHud playerHud;

    // End:0x180
    if(qMenuScene != none)
    {
        // End:0x31
        if(chxGodMode != none)
        {
            chxGodMode.SetValue(bGodMode);
        }
        // End:0x57
        if(chxUnlimitedWeapsAndAmmo != none)
        {
            chxUnlimitedWeapsAndAmmo.SetValue(bUnlimitedWeaponsAndAmmo);
        }
        // End:0x7D
        if(chxWalkOrGhost != none)
        {
            chxWalkOrGhost.SetValue(bWalkOrGhost);
        }
        // End:0xA3
        if(chxShowKynapsePaths != none)
        {
            chxShowKynapsePaths.SetValue(bShowKynapsePaths);
        }
        playerHud = SPHud(myHUD);
        // End:0xF0
        if((chxShowLowMemMsg != none) && playerHud != none)
        {
            chxShowLowMemMsg.SetValue(playerHud.m_bShowLowMemoryWarning);
        }
        // End:0x120
        if(chxInvertY != none)
        {
            chxInvertY.SetValue(PlayerInput.bInvertMouse);
        }
        // End:0x150
        if(chxShowCopyright != none)
        {
            chxShowCopyright.SetValue(playerHud.bShowCopyrightText);
        }
        // End:0x180
        if(chxShowBuild != none)
        {
            chxShowBuild.SetValue(playerHud.bShowBuildVersion);
        }
    }
    //return;    
}

event ApplyQuickMenuSettings()
{
    // End:0xCD
    if(CheatManager != none)
    {
        // End:0x4F
        if(bPrevShowKynapsePaths != bShowKynapsePaths)
        {
            bPrevShowKynapsePaths = bShowKynapsePaths;            
            ConsoleCommand("Kynapse render graph");
        }
        // End:0x94
        if(bCheatFlying != bWalkOrGhost)
        {
            // End:0x80
            if(bWalkOrGhost)
            {
                CheatManager.Ghost();                
            }
            else
            {
                CheatManager.Walk();
            }
        }
        // End:0xCD
        if(bPrevUnlimitedWeaponsAndAmmo != bUnlimitedWeaponsAndAmmo)
        {
            // End:0xC0
            if(bUnlimitedWeaponsAndAmmo)
            {
                AllWeapons();
                bUnlimitedWeaponsAndAmmo = false;
            }
            bPrevUnlimitedWeaponsAndAmmo = bUnlimitedWeaponsAndAmmo;
        }
    }
    //return;    
}

function OnToggleUnlimitedWeaponsAndAmmo(SeqAct_ToggleUnlimitedWeaponsAndAmmo inAction)
{
    // End:0x2B
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bUnlimitedWeaponsAndAmmo = true;        
    }
    else
    {
        // End:0x56
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bUnlimitedWeaponsAndAmmo = false;            
        }
        else
        {
            bUnlimitedWeaponsAndAmmo = !bUnlimitedWeaponsAndAmmo;
        }
    }
    //return;    
}

function OnToggleGhostMode(SeqAct_ToggleGhostMode inAction)
{
    // End:0x2B
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bWalkOrGhost = true;        
    }
    else
    {
        // End:0x56
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bWalkOrGhost = false;            
        }
        else
        {
            bWalkOrGhost = !bWalkOrGhost;
        }
    }
    //return;    
}

function OnToggleShowLowMemMsg(SeqAct_ToggleShowLowMemMsg inAction)
{
    local SPHud playerHud;

    playerHud = SPHud(myHUD);
    // End:0x1D
    if(playerHud == none)
    {
        return;
    }
    // End:0x52
    if(inAction.InputLinks[0].bHasImpulse)
    {
        playerHud.m_bShowLowMemoryWarning = true;        
    }
    else
    {
        // End:0x87
        if(inAction.InputLinks[1].bHasImpulse)
        {
            playerHud.m_bShowLowMemoryWarning = false;            
        }
        else
        {
            playerHud.m_bShowLowMemoryWarning = !playerHud.m_bShowLowMemoryWarning;
        }
    }
    //return;    
}

function OnToggleShowKynapsePaths(SeqAct_ToggleShowKynapsepaths inAction)
{
    // End:0x2B
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bShowKynapsePaths = true;        
    }
    else
    {
        // End:0x56
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bShowKynapsePaths = false;            
        }
        else
        {
            bShowKynapsePaths = !bShowKynapsePaths;
        }
    }
    //return;    
}

function OnToggleInvertY(SeqAct_ToggleInvertY inAction)
{
    // End:0x35
    if(inAction.InputLinks[0].bHasImpulse)
    {
        PlayerInput.bInvertMouse = true;        
    }
    else
    {
        // End:0x6A
        if(inAction.InputLinks[1].bHasImpulse)
        {
            PlayerInput.bInvertMouse = false;            
        }
        else
        {
            PlayerInput.bInvertMouse = !PlayerInput.bInvertMouse;
        }
    }
    //return;    
}

function OnToggleShowCopyrightText(SeqAct_ToggleShowCopyrightText inAction)
{
    local SPHud playerHud;

    playerHud = SPHud(myHUD);
    // End:0x45
    if(inAction.InputLinks[0].bHasImpulse)
    {
        playerHud.bShowCopyrightText = true;        
    }
    else
    {
        // End:0x7A
        if(inAction.InputLinks[1].bHasImpulse)
        {
            playerHud.bShowCopyrightText = false;            
        }
        else
        {
            playerHud.bShowCopyrightText = !playerHud.bShowCopyrightText;
        }
    }
    //return;    
}

function OnToggleShowBuild(SeqAct_ToggleShowBuild inAction)
{
    local SPHud playerHud;

    playerHud = SPHud(myHUD);
    // End:0x45
    if(inAction.InputLinks[0].bHasImpulse)
    {
        playerHud.bShowBuildVersion = true;        
    }
    else
    {
        // End:0x7A
        if(inAction.InputLinks[1].bHasImpulse)
        {
            playerHud.bShowBuildVersion = false;            
        }
        else
        {
            playerHud.bShowBuildVersion = !playerHud.bShowBuildVersion;
        }
    }
    //return;    
}

function AllWeapons()
{
    local SPWeapon CurrWeapon;

    // End:0x40
    if(((Pawn == none) || CheatManager == none) || !WorldInfo.Game.AllowCheats(self))
    {
        return;
    }
    // End:0xB8
    if(Pawn.Weapon != none)
    {
        CurrWeapon = SPWeapon(Pawn.Weapon);
        // End:0xB8
        if(CurrWeapon != none)
        {
            CurrWeapon.AmmoCount = CurrWeapon.MaxAmmoCount;
            CurrWeapon.ammoInMagazine = CurrWeapon.magazineSize;
        }
    }
    //return;    
}

function AllWeaponsAndAmmo()
{
    bUnlimitedWeaponsAndAmmo = true;
    //return;    
}

exec function ShowGlobalMem()
{
    local SPHud mySPHud;

    mySPHud = SPHud(myHUD);
    // End:0x3E
    if(mySPHud != none)
    {
        mySPHud.m_bShowGlobalMemoryStatus = !mySPHud.m_bShowGlobalMemoryStatus;
    }
    //return;    
}

function SPHud GetSPHud()
{
    local SPHud mySPHud;

    // End:0x2B
    if(myHUD != none)
    {
        mySPHud = SPHud(myHUD);
        // End:0x28
        if(mySPHud == none)
        {
            return none;
        }        
    }
    else
    {
        return none;
    }
    return mySPHud;
    //return ReturnValue;    
}

// Export UPandoraPlayerController::execSetGamma(FFrame&, void* const)
native function SetGamma(float GammaValue);

// Export UPandoraPlayerController::execGetUIPlayerIndex(FFrame&, void* const)
native function int GetUIPlayerIndex();

function UpdateAmBXRumbleSettings()
{
    switch(ProfileSettings.GetAmBxRumbleQuality())
    {
        // End:0x33
        case 0:
            SetThePlayerToNOT_UseAmBxMediumRumble();
            SetThePlayerToNOT_UseAmBxFullRumble();
            // End:0x6E
            break;
        // End:0x4F
        case 1:
            SetThePlayerToNOT_UseAmBxFullRumble();
            SetThePlayerToUseAmBxMediumRumble();
            // End:0x6E
            break;
        // End:0x6B
        case 2:
            SetThePlayerToUseAmBxMediumRumble();
            SetThePlayerToUseAmBxFullRumble();
            // End:0x6E
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

exec function UpdateLocalCacheOfProfileSettings()
{
    local int PlayerIndex;
    local PandoraGameInfo GameInfo;
    local int stickConfig;
    local ConsolePandoraPlayerController ConsolePC;
    local int compositeDefaultValue;
    local PlayerPawn PP;

    compositeDefaultValue = 5;
    PlayerIndex = GetUIPlayerIndex();
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    PlayerInput.bInvertMouse = ProfileSettings.GetInvertMouseOption();
    bControllerVibrationFlag = ProfileSettings.GetControllerVibrationOption();
    ConsolePC = ConsolePandoraPlayerController(self);
    // End:0x9D
    if(ConsolePC != none)
    {
        ConsolePC.LoadSettingsFromProfile();
    }
    // End:0x1F8
    if(PlayerIndex == 0)
    {
        SetShowSubtitles(ProfileSettings.GetSubtitleConfigOption());
        SetSoundVolume();
        SetMusic();
        SetGamma(ProfileSettings.GetGammaSetting());
        // End:0x12E
        if(ProfileSettings != none)
        {
            compositeDefaultValue = int(ProfileSettings.GetVideoPerformance());
            SetPerformanceSettings(compositeDefaultValue);
        }
        ShowHUDElements(true);
        // End:0x1F8
        if(GameInfo != none)
        {
            GameInfo.PDACreatureMessageUnlockedCount = ProfileSettings.GetUnlockedPDACreatureMessageCount();
            GameInfo.PDAEquipmentMessageUnlockedCount = ProfileSettings.GetUnlockedPDAEquipmentMessageCount();
            GameInfo.PDAObjectiveMessageUnlockedCount = ProfileSettings.GetUnlockedPDAObjectiveMessageCount();
            GameInfo.PDAPeopleMessageUnlockedCount = ProfileSettings.GetUnlockedPDAPeopleMessageCount();
            GameInfo.PDAPickedupMessageCount = ProfileSettings.GetPickedUpPDAMessageCount();
        }
    }
    stickConfig = int(ProfileSettings.GetStickConfigOption());
    PandoraPlayerInput(PlayerInput).UpdateControllerConfig(stickConfig);
    ProfileSettings.SetProfileDirty(true);
    // End:0x267
    if(WorldInfo.IsPlayInEditor())
    {
        SetThePlayerToUseAmBx();        
    }
    else
    {
        // End:0x2D3
        if(ProfileSettings.IsAmBxEnabled())
        {
            SetThePlayerToUseAmBx();
            // End:0x2A1
            if(!AreAllAmbxObjectsHidden())
            {
                HideAllAmbxObjects();
            }
            PP = PlayerPawn(Pawn);
            // End:0x2D0
            if(PP != none)
            {
                PP.AttachAmBXLightEnvironments();
            }            
        }
        else
        {
            SetThePlayerToNOT_UseAmBx();
            // End:0x2F4
            if(AreAllAmbxObjectsHidden())
            {
                ShowAllAmbxObjects();
            }
            PP = PlayerPawn(Pawn);
            // End:0x323
            if(PP != none)
            {
                PP.DetachAmBXLightEnvironments();
            }
        }
        UpdateAmBXRumbleSettings();
    }
    //return;    
}

exec function ReadProfile()
{
    // End:0x33
    if(PDAManager != none)
    {
        // End:0x33
        if(PDAManager.PDAMsgData.Length > 0)
        {
            PDAManager.PDAMsgData.Length = 0;
        }
    }
    // End:0x78
    if(OnlineSub != none)
    {
        OnlineSub.PlayerInterface.ReadProfileSettings(byte(LocalPlayer(Player).ControllerId), ProfileSettings);
    }
    //return;    
}

function bool IsProfileWriteEnabled()
{
    // End:0x2B
    if(Class'Engine.Engine'.static.IsSPDemoBuild() && Class'Engine.WorldInfo'.static.IsConsoleBuild())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

event WriteProfile(optional bool Forced)
{
    local PandoraGameInfo GameInfo;
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;

    // End:0x1C
    if(!ProfileSettings.IsProfileDirty())
    {
        return;
    }
    // End:0x4C
    if(!Forced && !ProfileSettings.OkToWriteProfile())
    {
        bDelayedProfileWrite = true;
        return;
    }
    // End:0x7C
    if(((SPCM != none) && SPCM.CheckpointsToSave.Length > 0) && m_bOKToSaveCheckpoints)
    {
        return;
    }
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    ControllerId = LocalPlayer(Player).ControllerId;
    // End:0x16D
    if(GameInfo != none)
    {
        ProfileSettings.SetUnlockedPDACreatureMessageCount(GameInfo.PDACreatureMessageUnlockedCount);
        ProfileSettings.SetUnlockedPDAEquipmentMessageCount(GameInfo.PDAEquipmentMessageUnlockedCount);
        ProfileSettings.SetUnlockedPDAObjectiveMessageCount(GameInfo.PDAObjectiveMessageUnlockedCount);
        ProfileSettings.SetUnlockedPDAPeopleMessageCount(GameInfo.PDAPeopleMessageUnlockedCount);
        ProfileSettings.SetPickedUpPDAMessageCount(GameInfo.PDAPickedupMessageCount);        
    }
    // End:0x1B2
    if(PDAManager != none)
    {
        PDAManager.ConvertPDAMsgData();
        ProfileSettings.SaveUnlockedPDAMessageData(PDAManager.PDAMsgData);        
    }
    // End:0x297
    if(OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0x294
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)) && ControllerId != -1)
        {
            m_bOKToSaveCheckpoints = false;
            ProfileSettings.SetProfileBusy(true);
            ProfileSettings.SetProfileDirty(false);
            // End:0x27F
            if(IsProfileWriteEnabled())
            {
                PlayerInt.AddWriteProfileSettingsCompleteDelegate(byte(ControllerId), OnProfileWriteComplete);
                PlayerInt.WriteProfileSettings(byte(ControllerId), ProfileSettings);                
            }
            else
            {
                OnProfileWriteComplete(byte(ControllerId), true);
            }            
        }        
    }
    //return;    
}

exec function ResetProfile()
{
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;
    local PandoraProfileSettings ProfSettings;

    // End:0xF9
    if(OnlineSub != none)
    {
        ProfSettings = new (OnlineSub) Class'PandoraProfileSettings';
        ProfSettings.SetToDefaults();
        PlayerInt = OnlineSub.PlayerInterface;
        ControllerId = LocalPlayer(Player).ControllerId;
        // End:0xF9
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)) && ControllerId != -1)
        {
            // End:0xE7
            if(IsProfileWriteEnabled())
            {
                PlayerInt.AddWriteProfileSettingsCompleteDelegate(byte(ControllerId), OnProfileWriteComplete);
                OnlineSub.PlayerInterface.WriteProfileSettings(byte(ControllerId), ProfSettings);                
            }
            else
            {
                OnProfileWriteComplete(byte(ControllerId), true);
            }
        }
    }
    //return;    
}

function OnProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;

    // End:0x82
    if(OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0x82
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            ControllerId = LocalPlayer(Player).ControllerId;
            // End:0x82
            if(ControllerId != -1)
            {
                PlayerInt.ClearWriteProfileSettingsCompleteDelegate(byte(ControllerId), OnProfileWriteComplete);
            }
        }
    }
    // End:0x9D
    if(bResetPickupMessageActorState)
    {
        bResetPickupMessageActorState = false;
        ResetPickupMessageActorState();
    }
    ProfileSettings.nWriteTime = int(WorldInfo.RealTimeSeconds);
    ProfileSettings.SetProfileBusy(false);
    ProfileSettings.SetProfileForceWrite(false);
    m_bOKToSaveCheckpoints = true;
    //return;    
}

exec function SaveLocalProfileSettings()
{
    SavedProfile.bInvertMouse = ProfileSettings.GetInvertMouseOption();
    SavedProfile.bControllerVibration = ProfileSettings.GetControllerVibrationOption();
    SavedProfile.bShowSubTitle = ProfileSettings.GetSubtitleConfigOption();
    SavedProfile.MasterVolume = ProfileSettings.GetMasterVol();
    SavedProfile.bMusicEnabled = ProfileSettings.IsMusicEnabled();
    SavedProfile.GammaSetting = ProfileSettings.GetGammaSetting();
    SavedProfile.GameDifficulty = ProfileSettings.GetGameDifficulty();
    SavedProfile.bFadeHUD = ProfileSettings.GetHUDOption();
    SavedProfile.CtrlConfig = int(ProfileSettings.GetStickConfigOption());
    SavedProfile.CtrlSensitivity = ProfileSettings.GetControllerSensitivityValue();
    SavedProfile.CompositePerformace = int(ProfileSettings.GetVideoPerformance());
    //return;    
}

exec function RestoreProfileFromLocalProfileSettings()
{
    ProfileSettings.SetInvertMouseOption(SavedProfile.bInvertMouse);
    ProfileSettings.SetControllerVibrationOption(SavedProfile.bControllerVibration);
    ProfileSettings.SetSubtitleConfigOption(SavedProfile.bShowSubTitle);
    ProfileSettings.SetMasterVol(SavedProfile.MasterVolume);
    ProfileSettings.SetMusicSetting(SavedProfile.bMusicEnabled);
    ProfileSettings.SetGammaSetting(SavedProfile.GammaSetting);
    ProfileSettings.SetGameDifficulty(SavedProfile.GameDifficulty);
    ProfileSettings.SetHUDOption(SavedProfile.bFadeHUD);
    ProfileSettings.SetStickConfigOption(SavedProfile.CtrlConfig);
    ProfileSettings.SetControllerSensitivityValue(SavedProfile.CtrlSensitivity);
    ProfileSettings.SetProfileDirty(true);
    ProfileSettings.SetVideoPerformance(byte(SavedProfile.CompositePerformace));
    UpdateLocalCacheOfProfileSettings();
    //return;    
}

function string GetCurrentLevelName()
{
    local string LevelName;
    local int Index;

    LevelName = Repl(Locs(WorldInfo.GetLocalURL()), ".pda", "");
    Index = InStr(LevelName, "?");
    LevelName = Left(LevelName, Index);
    J0x4A:

    // End:0x7E [Loop If]
    if(InStr(LevelName, "\\") != -1)
    {
        LevelName = Mid(LevelName, InStr(LevelName, "\\") + 1);
        // [Loop Continue]
        goto J0x4A;
    }
    J0x7E:

    // End:0xB2 [Loop If]
    if(InStr(LevelName, "/") != -1)
    {
        LevelName = Mid(LevelName, InStr(LevelName, "/") + 1);
        // [Loop Continue]
        goto J0x7E;
    }
    return LevelName;
    //return ReturnValue;    
}

simulated function RegisterPlayerDataStores()
{
    local LocalPlayer LP;

    super(PlayerController).RegisterPlayerDataStores();
    LP = LocalPlayer(Player);
    // End:0x45
    if(LP != none)
    {
        ProfileSettings = PandoraProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
    }
    //return;    
}

simulated function UnregisterPlayerDataStores()
{
    local LocalPlayer LP;

    super(PlayerController).UnregisterPlayerDataStores();
    LP = LocalPlayer(Player);
    // End:0x28
    if(LP != none)
    {
        ProfileSettings = none;
    }
    //return;    
}

simulated function DrawHUD(HUD H)
{
    super(PlayerController).DrawHUD(H);
    //return;    
}

simulated function bool IsSPPRIAPlayer(SPPlayerReplicationInfo SPPRI)
{
    // End:0x38
    if((SPTeamInfoMPTeam1(SPPRI.Team) != none) || SPTeamInfoMPTeam2(SPPRI.Team) != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function DispDebugHUDScoreboard(SPHud H)
{
    local string S, s2;
    local int localPlayerScore, netPlayerScore, differenceScore, playerScore, leaderScore, secondScore;

    local GameReplicationInfo GRI;
    local string netPlayerName, localPlayerName;
    local PlayerController PC;
    local int localPlayerID, Idx;
    local SPPlayerReplicationInfo SPPRI;

    localPlayerScore = -1;
    netPlayerScore = -1;
    GRI = WorldInfo.GRI;
    // End:0x38
    if(GRI == none)
    {
        return;
    }
    // End:0x8D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        localPlayerID = PC.PlayerReplicationInfo.PlayerID;
        localPlayerName = PC.PlayerReplicationInfo.PlayerName;
        // End:0x8D
        break;        
    }    
    Idx = 0;
    J0x95:

    // End:0x1A2 [Loop If]
    if(Idx < GRI.PRIArray.Length)
    {
        // End:0xCD
        if(GRI.PRIArray[Idx] == none)
        {
            // [Explicit Continue]
            goto J0x198;
        }
        SPPRI = SPPlayerReplicationInfo(GRI.PRIArray[Idx]);
        // End:0x105
        if((IsSPPRIAPlayer(SPPRI)) == false)
        {
            // [Explicit Continue]
            goto J0x198;
        }
        playerScore = SPPRI.GetTotalPoints();
        // End:0x156
        if(GRI.PRIArray[Idx].PlayerID == localPlayerID)
        {
            localPlayerScore = playerScore;
            // [Explicit Continue]
            goto J0x198;
        }
        // End:0x198
        if(playerScore > netPlayerScore)
        {
            netPlayerScore = playerScore;
            netPlayerName = GRI.PRIArray[Idx].PlayerName;
            // [Explicit Continue]
        }
        J0x198:

        Idx++;
        // [Loop Continue]
        goto J0x95;
    }
    differenceScore = localPlayerScore - netPlayerScore;
    // End:0x1EE
    if(differenceScore >= 0)
    {
        leaderScore = localPlayerScore;
        secondScore = netPlayerScore;
        S = localPlayerName;
        s2 = netPlayerName;        
    }
    else
    {
        leaderScore = netPlayerScore;
        secondScore = localPlayerScore;
        S = netPlayerName;
        s2 = localPlayerName;
    }
    H.DrawMultiplayerScore(H, S, s2, leaderScore, secondScore);
    //return;    
}

simulated function DispDebugScoreboard(SPHud H)
{
    local PandoraGRI GRI;
    local int Idx;
    local float spacer, letterWidth, XL, YL;
    local string S;
    local float killsOffset, deathsOffset;
    local array<string> playerNames;
    local array<int> playerPoints, playerDeaths;
    local PlayerPawn P;
    local SPWeapon Weap;
    local SPPlayerReplicationInfo SPPRI;

    killsOffset = 12.0000000;
    deathsOffset = 19.0000000;
    GRI = PandoraGRI(WorldInfo.GRI);
    // End:0xDF
    if(GRI != none)
    {
        // End:0xCD
        if((InStr(string(GRI.GameClass.default.Name), "PandoraTeamDM") != -1) || InStr(string(GRI.GameClass.default.Name), "PandoraMonsterMachine") != -1)
        {
            S = "Team Deathmatch";            
        }
        else
        {
            S = "Deathmatch";
        }
    }
    S = S @ "on DM_Lobby";
    H.Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
    H.Canvas.StrLen(S, XL, YL);
    H.Canvas.SetPos(H.CenterX - (XL / float(2)), float(H.OverscanY) + (YL * 4.0000000));
    H.Canvas.DrawText(S, false);
    // End:0x2F0
    if(int(GRI.winningTeam) != int(0))
    {
        // End:0x20D
        if(int(GRI.winningTeam) == int(1))
        {
            S = "Team 1 Wins";            
        }
        else
        {
            S = "Team 2 Wins";
        }
        H.Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
        H.Canvas.StrLen(S, XL, YL);
        H.Canvas.SetPos(H.CenterX - (XL / float(2)), (float(H.OverscanY) + (YL * 4.0000000)) + float(22));
        H.Canvas.DrawText(S, false);
    }
    S = "xxxx5xxxx0xxxx5xxxx0xxxx5xxxx0";
    H.Canvas.StrLen(S, XL, YL);
    spacer = XL / 2.0000000;
    letterWidth = XL / 30.0000000;
    S = "Name";
    H.Canvas.SetPos(H.CenterX - spacer, float(H.OverscanY) + (YL * 6.0000000));
    H.Canvas.DrawText(S, false);
    S = "Points";
    H.Canvas.SetPos((H.CenterX - spacer) + (killsOffset * letterWidth), float(H.OverscanY) + (YL * 6.0000000));
    H.Canvas.DrawText(S, false);
    S = "Flash";
    H.Canvas.SetPos((H.CenterX - spacer) + (deathsOffset * letterWidth), float(H.OverscanY) + (YL * 6.0000000));
    H.Canvas.DrawText(S, false);
    Idx = 0;
    J0x500:

    // End:0x616 [Loop If]
    if(Idx < GRI.PRIArray.Length)
    {
        // End:0x538
        if(GRI.PRIArray[Idx] == none)
        {
            // [Explicit Continue]
            goto J0x60C;
        }
        SPPRI = SPPlayerReplicationInfo(GRI.PRIArray[Idx]);
        // End:0x570
        if((IsSPPRIAPlayer(SPPRI)) == false)
        {
            // [Explicit Continue]
            goto J0x60C;
        }
        playerNames.Insert(Idx, 1);
        playerPoints.Insert(Idx, 1);
        playerDeaths.Insert(Idx, 1);
        playerNames[Idx] = GRI.PRIArray[Idx].PlayerName;
        playerPoints[Idx] = SPPRI.GetTotalPoints();
        playerDeaths[Idx] = int(GRI.PRIArray[Idx].Deaths);
        J0x60C:

        Idx++;
        // [Loop Continue]
        goto J0x500;
    }
    Idx = 0;
    J0x61D:

    // End:0x7CA [Loop If]
    if(Idx < playerNames.Length)
    {
        // End:0x65D
        if(Idx == 0)
        {
            H.Canvas.SetDrawColor(255, 0, 0, 255);            
        }
        else
        {
            H.Canvas.SetDrawColor(255, 255, 255, 255);
        }
        S = playerNames[Idx];
        H.Canvas.SetPos(H.CenterX - spacer, float(H.OverscanY) + (YL * (8.0000000 + float(Idx))));
        H.Canvas.DrawText(S, false);
        S = "" @ string(playerPoints[Idx]);
        H.Canvas.SetPos((H.CenterX - spacer) + (killsOffset * letterWidth), float(H.OverscanY) + (YL * (8.0000000 + float(Idx))));
        H.Canvas.DrawText(S, false);
        S = "" @ string(playerDeaths[Idx]);
        Idx++;
        // [Loop Continue]
        goto J0x61D;
    }
    Idx = 0;
    // End:0x8E3
    foreach WorldInfo.AllPawns(Class'PlayerPawn', P)
    {
        Weap = SPWeapon(P.Weapon);
        // End:0x8DB
        if(Weap != none)
        {
            S = ((string(P.GetIsPartiallyLookingDownSite()) @ "(") $ string(Weap.GetCurrFOV())) $ ")";
            H.Canvas.SetPos((H.CenterX - spacer) + (deathsOffset * letterWidth), float(H.OverscanY) + (YL * (8.0000000 + float(Idx))));
            H.Canvas.DrawText(S, false);
        }
        Idx++;        
    }    
    //return;    
}

function bool UsingFirstPersonCamera()
{
    return ((((PlayerCamera == none) || PlayerCamera.GetCameraStyle() == 'FirstPerson') || PlayerCamera.GetCameraStyle() == 'LookDownSite') || PlayerCamera.GetCameraStyle() == 'Fixed') && LocalPlayer(Player) != none;
    //return ReturnValue;    
}

function HandleWalking()
{
    // End:0x20
    if(Pawn != none)
    {
        Pawn.SetWalking(false);
    }
    //return;    
}

simulated function HandleSprint(bool turnOn)
{
    // End:0x33
    if(turnOn)
    {
        // End:0x30
        if(int(bRun) == int(0))
        {
            // End:0x30
            if(IsAllowedToSprint())
            {
                OnSprintStartSuccess();
            }
        }        
    }
    else
    {
        // End:0x76
        if(((int(bRun) != int(0)) || Pawn == none) || !PlayerPawn(Pawn).m_bCanSprint)
        {
            OnSprintStop();
        }
    }
    //return;    
}

simulated function bool IsSprintFullyCharged()
{
    // End:0x0D
    if(Pawn == none)
    {
        return false;
    }
    // End:0x1E
    if(SprintTime < SprintTimeMax)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function bool IsSprintCharged()
{
    // End:0x0D
    if(Pawn == none)
    {
        return false;
    }
    // End:0x1E
    if(SprintTime < SprintRampDownTime)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function bool IsAllowedToSprint()
{
    // End:0x0D
    if(Pawn == none)
    {
        return false;
    }
    // End:0x29
    if(!PlayerPawn(Pawn).m_bCanSprint)
    {
        return false;
    }
    // End:0x3A
    if(SprintTime < SprintRampDownTime)
    {
        return false;
    }
    // End:0x49
    if(GetSprint())
    {
        return false;
    }
    // End:0x6B
    if((WorldInfo.TimeSeconds - LastSprintTime) <= SprintDurationMin)
    {
        return false;
    }
    // End:0x7D
    if(PlayerPawn(Pawn) == none)
    {
        return false;
    }
    // End:0x9B
    if(PlayerPawn(Pawn).GetIsPartiallyLookingDownSite())
    {
        return false;
    }
    // End:0xBC
    if(int(PlayerPawn(Pawn).Physics) != int(1))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated event bool IsSprinting()
{
    return (GetSprint()) && VSizeSq(Pawn.Velocity) > 1.0000000;
    //return ReturnValue;    
}

simulated function bool GetSprint()
{
    return int(bRun) != int(0);
    //return ReturnValue;    
}

simulated function SetSprint(PandoraPlayerController.eSprintMode SprintMode)
{
    local SPPawn theSPPawn;

    theSPPawn = SPPawn(Pawn);
    switch(SprintMode)
    {
        // End:0x49
        case 0:
            bRun = 1;
            // End:0x46
            if(theSPPawn != none)
            {
                theSPPawn.SetMovementType(19);
            }
            // End:0xAE
            break;
        // End:0x7A
        case 1:
            bRun = 1;
            // End:0x77
            if(theSPPawn != none)
            {
                theSPPawn.SetMovementType(18);
            }
            // End:0xAE
            break;
        // End:0xAB
        case 2:
            bRun = 0;
            // End:0xA8
            if(theSPPawn != none)
            {
                theSPPawn.SetMovementType(2);
            }
            // End:0xAE
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

simulated function OnSprintStartSuccess()
{
    SetSprint(0);
    bForceSprintExtension = false;
    m_fSprintRate = 1.0000000;
    bBurningSprintTime = false;
    bBurnedSprintTime = false;
    //return;    
}

simulated function OnSprintStop()
{
    SetSprint(2);
    ClearTimer('StopSprintBurstAndStartSprint');
    // End:0x45
    if(PlayerPawn(Pawn) != none)
    {
        PlayerPawn(Pawn).ToMoveOut();
    }
    LastSprintTime = WorldInfo.TimeSeconds;
    bForceSprintExtension = false;
    bBurningSprintTime = false;
    bBurnedSprintTime = false;
    //return;    
}

simulated event ReceivedPlayer()
{
    local PandoraGameInfo GameInfo;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    super(PlayerController).ReceivedPlayer();
    // End:0x8A
    if(PDAManager == none)
    {
        PDAManager = Spawn(Class'PandoraPDAManager');
        // End:0x87
        if(PDAManager != none)
        {
            PDAManager.myPC = self;
            PDAManager.myGameInfo = GameInfo;
            PDAManager.UnlockedPDAMessages.Length = 0;
        }        
    }
    // End:0xD2
    if((int(Role) < int(ROLE_Authority)) || LocalPlayer(Player) != none)
    {
        ReadProfile();
        // End:0xD2
        if(ProfileSettings != none)
        {
            ProfileSettings.nWriteTime = 0;
        }
    }
    //return;    
}

reliable client simulated function ShowHUDElements(bool bShowHUD)
{
    local bool bFadeWhenInactive;
    local SPHud HUD;
    local SPHudScene HudScene;

    // End:0x29
    if(ProfileSettings != none)
    {
        bFadeWhenInactive = ProfileSettings.GetHUDOption();        
    }
    else
    {
        bFadeWhenInactive = true;
    }
    HUD = SPHud(myHUD);
    // End:0x61
    if(HUD != none)
    {
        HudScene = HUD.HudScene;
    }
    // End:0xCD
    if(HudScene != none)
    {
        // End:0xAC
        if(!bFadeWhenInactive && !HudScene.IsHudFadeIn())
        {
            HudScene.FadeIn(2.0000000);
        }
        HUD.HudScene.bFadeWhenInactive = bFadeWhenInactive;
    }
    //return;    
}

simulated event int CanCollectSwapWeapon()
{
    // End:0x31
    if(PlayerPawn(Pawn) != none)
    {
        // End:0x31
        if(PlayerPawn(Pawn).QueryCollectableSwapWeapon() != none)
        {
            return 1;
        }
    }
    return 0;
    //return ReturnValue;    
}

simulated event int CanCollectSwapWeaponOrPerformUse()
{
    local Actor UseTarget;
    local DynamicSMActor Pickup;

    // End:0x0F
    if(IsFiringInputIgnored())
    {
        return 0;
    }
    // End:0x44
    if((CanCollectSwapWeapon()) != 0)
    {
        // End:0x37
        if(!m_bWeaponPickupOrReload)
        {
            SetWeaponPickupOrReload();            
        }
        else
        {
            // End:0x42
            if(m_bTimerForWeaponPickupOrReload)
            {
                return 1;
            }
        }
        return 0;
    }
    m_bTimerForWeaponPickupOrReload = true;
    // End:0x107
    if(((CanCollectSwapWeapon()) != 0) || ActorInteracted(UseTarget, true))
    {
        // End:0x90
        if(PlayerPawn(Pawn) != none)
        {
            // End:0x90
            if(IsInWerewolfTackleState())
            {
                return 0;
            }
        }
        // End:0x105
        if((PlayerPawn(Pawn) != none) && UseTarget != none)
        {
            // End:0x105
            if(UseTarget.IsA('DynamicSMActor'))
            {
                Pickup = DynamicSMActor(UseTarget);
                PlayerPawn(Pawn).ResetMaterialForPickupObject(Pickup);
                Pickup.bIsPickupMaterialChanged = false;
            }
        }
        return 1;
    }
    return 0;
    //return ReturnValue;    
}

function SPGameUISceneClient GetSceneClient()
{
    return SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
    //return ReturnValue;    
}

exec function ShowMenu()
{
    local PandoraGameInfo GameInfo;
    local PlayerController PC;
    local int LocalPlayerCounts;
    local bool bIsTraveling;
    local string MovieName;
    local PandoraGameViewportClient pvc;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x41
    if((GameInfo != none) && GameInfo.IsInShellLevel())
    {
        return;
    }
    // End:0x135
    if(LocalPlayer(Player) != none)
    {
        // End:0x6C
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            LocalPlayerCounts++;            
        }        
        bIsTraveling = GameEngine(Player.Outer).TravelURL != "";
        GetCurrentMovie(MovieName);
        // End:0x135
        if((LocalPlayerCounts == 1) && !bIsTraveling)
        {
            pvc = PandoraGameViewportClient(GetViewportClient());
            // End:0x135
            if((((MovieName == "") && !GameInfo.IsInCinematic()) && (pvc == none) || !pvc.FullScreenIsMoviePlaying()) && !IsPauseInputIgnored())
            {
                ShowPauseMenu();
            }
        }
    }
    //return;    
}

function ShowPauseMenu()
{
    local PandoraGameInfo GameInfo;
    local PandoraGameViewportClient pvc;

    // End:0x43
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // End:0x43
        if(PandoraPlayerInput(PlayerInput) != none)
        {
            PandoraPlayerInput(PlayerInput).ForceFlushOfInput();
        }
    }
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    bQueuedPause = false;
    // End:0x8E
    if(IsLobbySceneActive())
    {
        SPPlayerReplicationInfo(PlayerReplicationInfo).RequestReadyStatusChange(false);
        return;
    }
    // End:0x103
    if((GameInfo == none) || (GameInfo != none) && !GameInfo.IsInShellLevel())
    {
        // End:0x103
        if(!IsPaused())
        {
            ShowMenu();
            pvc = PandoraGameViewportClient(GetViewportClient());
            // End:0x103
            if(pvc != none)
            {
                pvc.OpenPauseMenu();
            }
        }
    }
    //return;    
}

event bool CheckDeviceId(int DeviceID)
{
    local bool bResult;
    local OnlinePlayerInterfaceEx PlayerInterfaceEx;

    bResult = false;
    // End:0x5D
    if(OnlineSub != none)
    {
        PlayerInterfaceEx = OnlineSub.PlayerInterfaceEx;
        // End:0x5D
        if(NotEqual_InterfaceInterface(PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            bResult = PlayerInterfaceEx.IsDeviceValid(DeviceID);
        }
    }
    return bResult;
    //return ReturnValue;    
}

reliable client simulated event ClientOpenLobbyScene(UIScene LobbyScene)
{
    local PandoraGRI GRI;

    GRI = PandoraGRI(WorldInfo.GRI);
    // End:0x53
    if((GRI != none) && int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        GRI.GameStatus = 1;
    }
    GRI.CloseScoreboard();
    ClientOpenHudScene(LobbyScene);
    //return;    
}

reliable client simulated event ClientOpenHudScene(UIScene HudScene)
{
    // End:0x2D
    if(myHUD != none)
    {
        SPHud(myHUD).OpenHUDScene(HudScene);        
    }
    //return;    
}

reliable server function GiveLoadoutInventory(int ProfileIdx)
{
    local int I;
    local class<SPWeapon> InvClass[3];
    local SPPlayerReplicationInfo SPPRI;
    local PandoraGRI PGRI;
    local SPInventoryManager SPInvMgr;

    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x34
    if(PGRI == none)
    {
        return;
    }
    SPInvMgr = SPInventoryManager(Pawn.InvManager);
    // End:0x5B
    if(SPInvMgr == none)
    {
        return;
    }
    SPPRI = SPPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x76
    if(SPPRI == none)
    {
    }
    InvClass[0] = PGRI.WeaponIDToClass(PGRI.WeaponProfiles[ProfileIdx].PriWeaponA);
    InvClass[1] = PGRI.WeaponIDToClass(PGRI.WeaponProfiles[ProfileIdx].PriWeaponB);
    InvClass[2] = PGRI.WeaponIDToClass(6);
    Pawn.InvManager.DiscardInventory();
    SPInvMgr.ResetAmmoTotals();
    I = 0;
    J0x146:

    // End:0x190 [Loop If]
    if(I < 3)
    {
        // End:0x186
        if(InvClass[I] != none)
        {
            Pawn.CreateInventory(InvClass[I]);
            // [Explicit Continue]
        }
        I++;
        // [Loop Continue]
        goto J0x146;
    }
    switch(PGRI.WeaponProfiles[SPPRI.WeaponConfigIdx].SecWeapon)
    {
        // End:0x216
        case 0:
            SPInvMgr.AddAmmoToWeapon(PGRI.WeaponProfiles[SPPRI.WeaponConfigIdx].SecWeaponQuantity, InvClass[2], "Grenade");
            // End:0x27A
            break;
        // End:0x277
        case 1:
            SPInvMgr.AddAmmoToWeapon(PGRI.WeaponProfiles[SPPRI.WeaponConfigIdx].SecWeaponQuantity, InvClass[2], "MolotovCocktail");
            // End:0x27A
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

reliable server function ServerDoPlayerRestart()
{
    local PandoraGameInfo PGI;

    PGI = PandoraGameInfo(WorldInfo.Game);
    PGI.RestartPlayer(self);
    //return;    
}

exec function UnlockAllPDAMessages()
{
    local PandoraGameInfo GameInfo;
    local int I;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x25B
    if((GameInfo != none) && PDAManager != none)
    {
        GameInfo.PDACreatureMessageUnlockedCount = -1;
        GameInfo.PDAEquipmentMessageUnlockedCount = -1;
        GameInfo.PDAObjectiveMessageUnlockedCount = -1;
        GameInfo.PDAPeopleMessageUnlockedCount = -1;
        GameInfo.PDAPickedupMessageCount = -1;
        PDAManager.UnlockedPDAMessages.Length = 0;
        I = 0;
        J0xB4:

        // End:0xFF [Loop If]
        if(I < GameInfo.PDAObjectiveMessages.Length)
        {
            PDAManager.UnlockedPDAMessages.AddItem(GameInfo.PDAObjectiveMessages[I]);
            I++;
            // [Loop Continue]
            goto J0xB4;
        }
        I = 0;
        J0x106:

        // End:0x151 [Loop If]
        if(I < GameInfo.PDACreatureMessages.Length)
        {
            PDAManager.UnlockedPDAMessages.AddItem(GameInfo.PDACreatureMessages[I]);
            I++;
            // [Loop Continue]
            goto J0x106;
        }
        I = 0;
        J0x158:

        // End:0x1A3 [Loop If]
        if(I < GameInfo.PDAEquipmentMessages.Length)
        {
            PDAManager.UnlockedPDAMessages.AddItem(GameInfo.PDAEquipmentMessages[I]);
            I++;
            // [Loop Continue]
            goto J0x158;
        }
        I = 0;
        J0x1AA:

        // End:0x1F5 [Loop If]
        if(I < GameInfo.PDAPeopleMessages.Length)
        {
            PDAManager.UnlockedPDAMessages.AddItem(GameInfo.PDAPeopleMessages[I]);
            I++;
            // [Loop Continue]
            goto J0x1AA;
        }
        I = 0;
        J0x1FC:

        // End:0x247 [Loop If]
        if(I < GameInfo.PDAPickupMessages.Length)
        {
            PDAManager.UnlockedPDAMessages.AddItem(GameInfo.PDAPickupMessages[I]);
            I++;
            // [Loop Continue]
            goto J0x1FC;
        }
        GameInfo.WritePDAMessageUnlockedData();
    }
    //return;    
}

exec function ResetPDAMessages()
{
    local PandoraGameInfo GameInfo;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x90
    if(GameInfo != none)
    {
        GameInfo.PDACreatureMessageUnlockedCount = 0;
        GameInfo.PDAEquipmentMessageUnlockedCount = 3;
        GameInfo.PDAObjectiveMessageUnlockedCount = 0;
        GameInfo.PDAPeopleMessageUnlockedCount = 3;
        GameInfo.PDAPickedupMessageCount = 0;
        GameInfo.WritePDAMessageUnlockedData();
    }
    //return;    
}

function bool HasInactiveProfile()
{
    local int currID;
    local bool bHasInactiveProfile;

    bHasInactiveProfile = false;
    currID = 0;
    J0x0F:

    // End:0x81 [Loop If]
    if(currID < 4)
    {
        // End:0x77
        if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(currID))) >= int(1)) && LocalPlayer(Player).ControllerId != currID)
        {
            bHasInactiveProfile = true;
            // [Explicit Break]
            goto J0x81;
        }
        currID++;
        // [Loop Continue]
        goto J0x0F;
    }
    J0x81:

    return bHasInactiveProfile;
    //return ReturnValue;    
}

function OnInviteJoinComplete(bool bWasSuccessful)
{
    local string URL;

    // End:0xA6
    if(HasInactiveProfile())
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InactiveSignedInMessage>", "<Strings:PandoraGame.ErrorMessages.InviteHandlingFailed_Title>", 0);
        ClearInviteDelegates();
        return;
    }
    // End:0x199
    if(bWasSuccessful)
    {
        // End:0x196
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            // End:0x196
            if(OnlineSub.GameInterface.GetResolvedConnectString(URL))
            {                
                ConsoleCommand(("open " $ URL) $ "?Game=PandorGameContent.PandoraMonsterMachine?GameType=PandoraGameContent.PandoraMonsterMachine?Invited?Name=Player");
            }
        }        
    }
    else
    {
        NotifyInviteFailed();
    }
    ClearInviteDelegates();
    //return;    
}

function bool CBCheckNotJoined()
{
    return true;
    //return ReturnValue;    
}

function CBJoinedResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x24
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        return;
    }
    // End:0x165
    if(int(eReturnValue) != int(4))
    {        
        ConsoleCommand("cancel");
        // End:0xEA
        if(int(eReturnValue) == int(3))
        {
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.jointimeoutmsg>", "<Strings:PandoraGame.ErrorMessages.jointimeouttitle>", 0, DlgReturnToMainMenu, None, 0, 6);            
        }
        else
        {
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.joincanceledmsg>", "<Strings:PandoraGame.ErrorMessages.joincanceledtitle>");
        }
    }
    DestroySession();
    //return;    
}

function OnDestroyForInviteComplete(bool bWasSuccessful)
{
    // End:0x143
    if(bWasSuccessful)
    {
        OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
        ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraJoinMatch.ConnectingMessage>", "<Strings:PandoraGame.UIScene_PandoraJoinMatch.Connectingtitle>", 4, CBJoinedResults, CBCheckNotJoined, 30);
        // End:0x140
        if(!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId)))
        {
            OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
            NotifyInviteFailed();
        }        
    }
    else
    {
        NotifyInviteFailed();
    }
    //return;    
}

function OnGameInviteAccepted(OnlineGameSettings GameInviteSettings)
{
    local OnlineGameSettings GameSettings;
    local int currID;
    local bool bInviteAccepted;

    // End:0x2C1
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        // End:0x2B7
        if(GameInviteSettings != none)
        {
            // End:0x2AA
            if(InviteHasEnoughSpace(GameInviteSettings))
            {
                // End:0x29D
                if(CanAllPlayersPlayOnline())
                {
                    GameSettings = OnlineSub.GameInterface.GetGameSettings();
                    // End:0x124
                    if((int(WorldInfo.NetMode) != int(NM_Standalone)) && GameSettings != none)
                    {
                        WorldInfo.GRI.bNeedsOnlineCleanup = false;
                        // End:0xDA
                        if(GameSettings.bUsesArbitration)
                        {
                            ClientWriteOnlinePlayerScores();
                        }
                        OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndForInviteComplete);
                        OnlineSub.GameInterface.EndOnlineGame();                        
                    }
                    else
                    {
                        OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
                        ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraJoinMatch.ConnectingMessage>", "<Strings:PandoraGame.UIScene_PandoraJoinMatch.Connectingtitle>", 4, CBJoinedResults, CBCheckNotJoined, 30);
                        currID = 0;
                        J0x1F6:

                        // End:0x25D [Loop If]
                        if(currID < 4)
                        {
                            // End:0x253
                            if(OnlineSub.GameInterface.AcceptGameInvite(byte(currID)) == true)
                            {
                                LocalPlayer(Player).SetControllerId(currID);
                                bInviteAccepted = true;
                                // [Explicit Break]
                                goto J0x25D;
                            }
                            currID++;
                            // [Loop Continue]
                            goto J0x1F6;
                        }
                        J0x25D:

                        // End:0x29A
                        if(!bInviteAccepted)
                        {
                            OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
                            NotifyInviteFailed();
                        }
                    }                    
                }
                else
                {
                    NotifyNotAllPlayersCanJoinInvite();
                }                
            }
            else
            {
                NotifyNotEnoughSpaceInInvite();
            }            
        }
        else
        {
            NotifyInviteFailed();
        }
    }
    //return;    
}

reliable client simulated function ClientWriteArbitrationEndGameData(class<OnlineStatsWrite> OnlineStatsWriteClass)
{
    local PanLeaderboardWriteBase Stats;
    local SPPlayerReplicationInfo PRI;
    local PandoraGRI GRI;
    local int Index;

    // End:0x12B
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        Stats = PanLeaderboardWriteBase(new OnlineStatsWriteClass);
        GRI = PandoraGRI(WorldInfo.GRI);
        Index = 0;
        J0x61:

        // End:0x119 [Loop If]
        if(Index < GRI.PRIArray.Length)
        {
            PRI = SPPlayerReplicationInfo(GRI.PRIArray[Index]);
            // End:0x10F
            if(!PRI.bIsInactive && !PRI.bBot)
            {
                UpdateStatsFromPRI(GRI, PRI, Stats);
                OnlineSub.StatsInterface.WriteOnlineStats(PRI.UniqueId, Stats);
            }
            Index++;
            // [Loop Continue]
            goto J0x61;
        }
        GRI.bEndOnlineGameInitiated = true;
    }
    ClientWriteOnlinePlayerScores();
    ServerWritenArbitrationEndGameData();
    //return;    
}

final function UpdateStatsFromPRI(PandoraGRI GRI, SPPlayerReplicationInfo PRI, PanLeaderboardWriteBase Stats)
{
    Stats.UpdateFromPRI(PRI);
    //return;    
}

reliable client simulated function ClientArbitratedMatchEnded()
{
    OnlineSub.GameInterface.EndOnlineGame();
    //return;    
}

function OnOnScreenText(SeqAct_OnScreenTextPersistent Action)
{
    // End:0x4F
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x4C
        if(Action != none)
        {
            Action.bIsCompleted = false;
            StartOnScreenText(Action);
        }        
    }
    else
    {
        StopOnScreenText(Action);
    }
    //return;    
}

event StartOnScreenText(SeqAct_OnScreenTextPersistent Action)
{
    local GameUISceneClient mySceneClient;
    local UIScene_OnScreenText OpenedScene;
    local UIInteraction UIController;

    // End:0x8E
    if((Action != none) && Action.DisplayedInPlayerController != none)
    {
        // End:0x8E
        if(Action.DisplayedInPlayerController.currOnScreenText.Action != none)
        {
            Action.DisplayedInPlayerController.StopOnScreenText(Action.DisplayedInPlayerController.currOnScreenText.Action);
        }
    }
    // End:0x10C
    if(currOnScreenText.DialogDuration != 0.0000000)
    {
        CloseScene(currOnScreenText.Scene, false);
        currOnScreenText.DialogDuration = 0.0000000;
        currOnScreenText.DialogDurationLeft = 0.0000000;
        currOnScreenText.Action.bIsCompleted = true;
    }
    currOnScreenText.Action = Action;
    currOnScreenText.DialogDuration = Action.DialogDuration;
    currOnScreenText.DialogDurationLeft = Action.DialogDuration;
    Action.DisplayedInPlayerController = self;
    OpenedScene = UIScene_OnScreenText(OpenScene(Action.Scene, true));
    // End:0x2BD
    if(OpenedScene != none)
    {
        // End:0x1D9
        if(Action.bShowTitle)
        {
            OpenedScene.SetTitle(Action.TitleMarkUpString);
        }
        UIController = GetUIController();
        // End:0x222
        if(UIController != none)
        {
            mySceneClient = UIController.SceneClient;
            // End:0x222
            if(mySceneClient != none)
            {
                mySceneClient.bOverrideEmulateButtonPress = true;
            }
        }
        OpenedScene.StringBackup = Action.MessageMarkUpString;
        OpenedScene.SetOnScreenText(Action.MessageMarkUpString);
        currOnScreenText.Scene = OpenedScene;
        OpenedScene.CommandIndex = int(Action.CommandIndex);
        OpenedScene.bLookMoveTutorial = Action.bLookMoveTutorial;
    }
    //return;    
}

event StopOnScreenText(SeqAct_OnScreenTextPersistent Action)
{
    local GameUISceneClient mySceneClient;
    local UIInteraction UIController;

    UIController = GetUIController();
    // End:0x49
    if(UIController != none)
    {
        mySceneClient = UIController.SceneClient;
        // End:0x49
        if(mySceneClient != none)
        {
            mySceneClient.bOverrideEmulateButtonPress = false;
        }
    }
    // End:0x77
    if(Action != none)
    {
        Action.bIsCompleted = true;
        Action.DisplayedInPlayerController = none;
    }
    CloseScene(currOnScreenText.Scene, true);
    currOnScreenText.Action = none;
    currOnScreenText.Scene = none;
    currOnScreenText.DialogDuration = 0.0000000;
    currOnScreenText.DialogDurationLeft = 0.0000000;
    //return;    
}

reliable client simulated event CloseScene(UIScene Scene, optional bool bFadeScreen)
{
    local UIInteraction UIController;

    UIController = GetUIController();
    // End:0x3A
    if((UIController != none) && Scene != none)
    {
        UIController.super(PandoraPlayerController).CloseScene(Scene);
    }
    //return;    
}

simulated function int GetDeadTargetType()
{
    local UIScene_MPDeathScene DeathScene;
    local SPGameUISceneClient theSceneClient;

    theSceneClient = GetSceneClient();
    DeathScene = UIScene_MPDeathScene(theSceneClient.GetActiveUIScene('UIScene_MPDeathScene'));
    // End:0x55
    if(DeathScene != none)
    {
        return int(DeathScene.LookTargetType);
    }
    return 0;
    //return ReturnValue;    
}

reliable client simulated function ClientPawnDied()
{
    // End:0x2E
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        ServerCycleNextTarget(GetDeadTargetType());
    }
    //return;    
}

function PawnDied(Pawn P)
{
    super(PlayerController).PawnDied(P);
    ClientPawnDied();
    //return;    
}

exec function UnlockAllAchievements()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x2C [Loop If]
    if(I < 11)
    {
        ClientUnlockAchievement(I);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function bool IsSPGameCompeted()
{
    local bool bGameComplete;
    local int ChaptersCompleted, I;

    // End:0x0D
    if(ProfileSettings == none)
    {
        return false;
    }
    bGameComplete = true;
    ChaptersCompleted = ProfileSettings.GetChapterCompleted();
    I = 0;
    J0x36:

    // End:0x6F [Loop If]
    if(I < (9 - 1))
    {
        // End:0x65
        if(((ChaptersCompleted >> I) & 1) == 0)
        {
            bGameComplete = false;
            // [Explicit Break]
            goto J0x6F;
        }
        I++;
        // [Loop Continue]
        goto J0x36;
    }
    J0x6F:

    return bGameComplete;
    //return ReturnValue;    
}

function OnUnlockAchievement(SeqAct_UnlockAchievement Action)
{
    local bool bCheckGameCompleteness;

    // End:0x15
    if(Class'Engine.Engine'.static.IsSPDemoBuild())
    {
        return;
    }
    bCheckGameCompleteness = false;
    // End:0x218
    if(int(Action.AchievementId) > int(0))
    {
        ClientUnlockAchievement(int(Action.AchievementId));
        // End:0x218
        if(ProfileSettings != none)
        {
            switch(Action.AchievementId)
            {
                // End:0x95
                case 5:
                    ProfileSettings.CompleteChapter(1);
                    bCheckGameCompleteness = true;
                    // End:0x1AC
                    break;
                // End:0xBC
                case 8:
                    ProfileSettings.CompleteChapter(2);
                    bCheckGameCompleteness = true;
                    // End:0x1AC
                    break;
                // End:0xE3
                case 13:
                    ProfileSettings.CompleteChapter(3);
                    bCheckGameCompleteness = true;
                    // End:0x1AC
                    break;
                // End:0x10A
                case 17:
                    ProfileSettings.CompleteChapter(4);
                    bCheckGameCompleteness = true;
                    // End:0x1AC
                    break;
                // End:0x131
                case 21:
                    ProfileSettings.CompleteChapter(5);
                    bCheckGameCompleteness = true;
                    // End:0x1AC
                    break;
                // End:0x158
                case 24:
                    ProfileSettings.CompleteChapter(6);
                    bCheckGameCompleteness = true;
                    // End:0x1AC
                    break;
                // End:0x17F
                case 27:
                    ProfileSettings.CompleteChapter(7);
                    bCheckGameCompleteness = true;
                    // End:0x1AC
                    break;
                // End:0x1A6
                case 31:
                    ProfileSettings.CompleteChapter(8);
                    bCheckGameCompleteness = true;
                    // End:0x1AC
                    break;
                // End:0xFFFF
                default:
                    // End:0x1AC
                    break;
                    break;
            }
            // End:0x218
            if(bCheckGameCompleteness && IsSPGameCompeted())
            {
                switch(ProfileSettings.GetGameDifficulty())
                {
                    // End:0x1EE
                    case 0:
                        ClientUnlockAchievement(33);
                        // End:0x218
                        break;
                    // End:0x202
                    case 2:
                        ClientUnlockAchievement(34);
                        // End:0x218
                        break;
                    // End:0x206
                    case 1:
                    // End:0xFFFF
                    default:
                        ClientUnlockAchievement(32);
                        // End:0x218
                        break;
                        break;
                }
            }
        }
    }
    //return;    
}

reliable client simulated function ClientUnlockAchievement(int AchievementId)
{
    local LocalPlayer LocPlayer;

    // End:0x15
    if(Class'Engine.Engine'.static.IsSPDemoBuild())
    {
        return;
    }
    // End:0x89
    if(OnlineSub != none)
    {
        // End:0x86
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            LocPlayer = LocalPlayer(Player);
            OnlineSub.PlayerInterfaceEx.UnlockAchievement(byte(LocPlayer.ControllerId), AchievementId);            
        }        
    }
    //return;    
}

reliable client simulated function ClientUnlockGamerPic(int GamerPicId)
{
    local LocalPlayer LocPlayer;

    // End:0x74
    if(OnlineSub != none)
    {
        // End:0x71
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            LocPlayer = LocalPlayer(Player);
            OnlineSub.PlayerInterfaceEx.UnlockGamerPicture(byte(LocPlayer.ControllerId), GamerPicId);            
        }        
    }
    //return;    
}

exec function SwitchTeam()
{
    // End:0x45
    if((PlayerReplicationInfo.Team == none) || PlayerReplicationInfo.Team.TeamIndex == 1)
    {
        ServerChangeTeam(2);        
    }
    else
    {
        ServerChangeTeam(1);
    }
    StartSpot = none;
    //return;    
}

exec function ChangeTeam(optional string TeamName)
{
    local int N;

    // End:0x1C
    if(TeamName ~= "blue")
    {
        N = 2;        
    }
    else
    {
        // End:0x7A
        if((((TeamName ~= "red") || PlayerReplicationInfo == none) || PlayerReplicationInfo.Team == none) || PlayerReplicationInfo.Team.TeamIndex > 1)
        {
            N = 1;            
        }
        else
        {
            // End:0xA4
            if(PlayerReplicationInfo.Team.TeamIndex == 1)
            {
                N = 2;                
            }
            else
            {
                N = 1;
            }
        }
    }
    ServerChangeTeam(N);
    StartSpot = none;
    //return;    
}

function UpdateStorageLocation()
{
    local OnlineSubsystem.ELoginStatus Status;
    local OnlinePlayerInterface PlayerInterface;
    local PandoraPlayerController.EDeviceValidErrorCode CheckDeviceResult;

    Status = 0;
    // End:0x6D
    if(OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x6D
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            Status = PlayerInterface.GetLoginStatus(byte(LocalPlayer(Player).ControllerId));
        }
    }
    // End:0xD7
    if((int(Status) == int(2)) || int(Status) == int(1))
    {
        CheckStorageDevice(CheckDeviceResult);
        switch(CheckDeviceResult)
        {
            // End:0xAE
            case 0:
                // End:0xD7
                break;
            // End:0xB3
            case 2:
            // End:0xD4
            case 1:
                SelectDevice(DatafileSize, NotifyDeviceSelectComplete);
                // End:0xD7
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

reliable client simulated function ClientWriteOnlinePlayerScores()
{
    local GameReplicationInfo GRI;
    local int Index;
    local array<OnlinePlayerScore> PlayerScores;
    local UniqueNetId ZeroUniqueId;
    local bool bIsTeamGame;
    local int ScoreIndex;
    local SPPlayerReplicationInfo SPPRI;

    GRI = WorldInfo.GRI;
    // End:0x1F7
    if(((GRI != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        bIsTeamGame = ((GRI.GameClass != none) ? GRI.GameClass.default.bTeamGame : false);
        Index = 0;
        J0x8D:

        // End:0x1D3 [Loop If]
        if(Index < GRI.PRIArray.Length)
        {
            SPPRI = SPPlayerReplicationInfo(GRI.PRIArray[Index]);
            // End:0x1C9
            if((SPPRI != none) && !SPPRI.bBot)
            {
                // End:0x1C6
                if(SPPRI.UniqueId != ZeroUniqueId)
                {
                    ScoreIndex = PlayerScores.Length;
                    PlayerScores.Insert(ScoreIndex, 1);
                    PlayerScores[ScoreIndex].PlayerID = SPPRI.UniqueId;
                    // End:0x17F
                    if(bIsTeamGame)
                    {
                        PlayerScores[ScoreIndex].TeamID = SPPRI.Team.TeamIndex;                        
                    }
                    else
                    {
                        PlayerScores[ScoreIndex].TeamID = Index;
                    }
                    PlayerScores[ScoreIndex].Score = SPPRI.GetTotalPoints();
                }
                // [Explicit Continue]
            }
            Index++;
            // [Loop Continue]
            goto J0x8D;
        }
        OnlineSub.StatsInterface.WriteOnlinePlayerScores(PlayerScores);
    }
    //return;    
}

simulated function SetGameOnlineStatus(int RichPresenceID)
{
    local LocalPlayer LP;
    local array<LocalizedStringSetting> StringSettings;
    local array<SettingsProperty> Properties;
    local int I;

    LP = LocalPlayer(Player);
    // End:0xE5
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        I = 0;
        J0x42:

        // End:0xA3 [Loop If]
        if(I < 4)
        {
            // End:0x99
            if(LP.ControllerId != I)
            {
                OnlineSub.PlayerInterface.SetOnlineStatus(byte(I), 3, StringSettings, Properties);
            }
            I++;
            // [Loop Continue]
            goto J0x42;
        }
        OnlineSub.PlayerInterface.SetOnlineStatus(byte(LP.ControllerId), RichPresenceID, StringSettings, Properties);        
    }
    //return;    
}

simulated function UpdateGameOnlineStatus()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x6F
    if(PGRI != none)
    {
        switch(PGRI.GameStatus)
        {
            // End:0x4A
            case 0:
                SetGameOnlineStatus(0);
                // End:0x6F
                break;
            // End:0x5D
            case 4:
                SetGameOnlineStatus(1);
                // End:0x6F
                break;
            // End:0xFFFF
            default:
                SetGameOnlineStatus(2);
                // End:0x6F
                break;
                break;
        }
    }
    //return;    
}

simulated function UpdateHUDTeamColor()
{
    local SPHud mySPHud;

    mySPHud = GetSPHud();
    // End:0x2F
    if(mySPHud != none)
    {
        mySPHud.UpdateHUDTeamColor();
    }
    //return;    
}

function HandlePickup(Inventory Inv)
{
    local SPWeapon Weapon;
    local SPHudScene HudScene;

    // End:0x1C
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        return;
    }
    Weapon = SPWeapon(Inv);
    HudScene = GetSPHud().HudScene;
    // End:0x5E
    if((Weapon != none) && HudScene != none)
    {
    }
    //return;    
}

event InitInputSystem()
{
    super(PlayerController).InitInputSystem();
    RegisterOnlineDelegates();
    // End:0x4B
    if((int(WorldInfo.NetMode) == int(NM_ListenServer)) && PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.IsInvalidName();
    }
    m_GameplayGDTuneData.GetMeleeImpactShakeData(PandoraPlayerInput(PlayerInput).MeleeImpactShakeParams);
    //return;    
}

function RegisterOnlineDelegates()
{
    local LocalPlayer LocPlayer;
    local int I;

    LocPlayer = LocalPlayer(Player);
    // End:0x3A1
    if((LocPlayer != none) && OnlineSub != none)
    {
        // End:0x9A
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            I = 0;
            J0x4D:

            // End:0x92 [Loop If]
            if(I < 4)
            {
                OnlineSub.PlayerInterface.AddLoginChangeDelegate(LoginChanged, byte(I));
                I++;
                // [Loop Continue]
                goto J0x4D;
            }
            bLoginChanged = false;
        }
        // End:0xE0
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.AddStorageDeviceChangeDelegate(StorageChangeCallback);
        }
        // End:0x14A
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            I = 0;
            J0x105:

            // End:0x14A [Loop If]
            if(I < 4)
            {
                OnlineSub.PlayerInterfaceEx.AddProfileDataChangedDelegate(byte(I), ProfileDataChanged);
                I++;
                // [Loop Continue]
                goto J0x105;
            }
        }
        // End:0x24D
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.AddMutingChangeDelegate(MutingChanged);
            OnlineSub.PlayerInterface.AddFriendsChangeDelegate(byte(LocalPlayer(Player).ControllerId), FriendsChanged);
            OnlineSub.PlayerInterface.AddReadFriendsCompleteDelegate(byte(LocalPlayer(Player).ControllerId), ReadFriendsListDone);
            OnlineSub.PlayerInterface.AddReadProfileSettingsCompleteDelegate(byte(LocalPlayer(Player).ControllerId), OnReadProfileSettingsComplete);            
        }
        // End:0x2AC
        if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
        {
            OnlineSub.ContentInterface.AddQueryAvailableDownloadsComplete(byte(LocalPlayer(Player).ControllerId), DownloadableContentQueryDone);            
        }
        // End:0x369
        if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            OnlineSub.GameInterface.AddCreateOnlineGameCompleteDelegate(GameCreateDone);
            OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(GameDestroyDone);
            I = 0;
            J0x321:

            // End:0x366 [Loop If]
            if(I < 4)
            {
                OnlineSub.GameInterface.AddGameInviteAcceptedDelegate(byte(I), OnGameInviteAccepted);
                I++;
                // [Loop Continue]
                goto J0x321;
            }            
        }
        // End:0x39E
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            RegisterConnectionCallbacks();
            DoControllerCheck();            
        }        
    }
    else
    {
        // End:0x3B7
        if(OnlineSub == none)
        {
            // End:0x3B7
            if(LocPlayer != none)
            {
            }
        }
    }
    //return;    
}

event ClearOnlineDelegates()
{
    local LocalPlayer LocPlayer;
    local int I;

    LocPlayer = LocalPlayer(Player);
    // End:0x437
    if((LocPlayer != none) && OnlineSub != none)
    {
        // End:0x9A
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            I = 0;
            J0x4D:

            // End:0x92 [Loop If]
            if(I < 4)
            {
                OnlineSub.PlayerInterface.ClearLoginChangeDelegate(LoginChanged, byte(I));
                I++;
                // [Loop Continue]
                goto J0x4D;
            }
            bLoginChanged = false;
        }
        // End:0xE0
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.ClearStorageDeviceChangeDelegate(StorageChangeCallback);
        }
        // End:0x14A
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            I = 0;
            J0x105:

            // End:0x14A [Loop If]
            if(I < 4)
            {
                OnlineSub.PlayerInterfaceEx.ClearProfileDataChangedDelegate(byte(I), ProfileDataChanged);
                I++;
                // [Loop Continue]
                goto J0x105;
            }
        }
        // End:0x24A
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.ClearMutingChangeDelegate(MutingChanged);
            OnlineSub.PlayerInterface.ClearFriendsChangeDelegate(byte(LocalPlayer(Player).ControllerId), FriendsChanged);
            OnlineSub.PlayerInterface.ClearReadFriendsCompleteDelegate(byte(LocalPlayer(Player).ControllerId), ReadFriendsListDone);
            OnlineSub.PlayerInterface.ClearReadProfileSettingsCompleteDelegate(byte(LocalPlayer(Player).ControllerId), OnReadProfileSettingsComplete);
        }
        // End:0x2A6
        if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
        {
            OnlineSub.ContentInterface.ClearQueryAvailableDownloadsComplete(byte(LocalPlayer(Player).ControllerId), DownloadableContentQueryDone);
        }
        // End:0x360
        if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(GameCreateDone);
            OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(GameDestroyDone);
            I = 0;
            J0x31B:

            // End:0x360 [Loop If]
            if(I < 4)
            {
                OnlineSub.GameInterface.ClearGameInviteAcceptedDelegate(byte(I), OnGameInviteAccepted);
                I++;
                // [Loop Continue]
                goto J0x31B;
            }
        }
        // End:0x388
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            UnregisterConnectionCallbacks();
        }
        // End:0x437
        if(int(Role) < int(ROLE_Authority))
        {
            // End:0x437
            if(NotEqual_InterfaceInterface(VoiceInterface, OnlineVoiceInterface(none)))
            {
                // End:0x437
                if(EqualEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) || NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) && OnlineSub.GameInterface.GetGameSettings() == none)
                {
                    VoiceInterface.UnregisterLocalTalker(byte(LocPlayer.ControllerId));
                }
            }
        }
    }
    //return;    
}

function DoControllerCheck()
{
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    // End:0x8F
    if(((LocPlayer != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
    {
        OnControllerChanged(LocPlayer.ControllerId, OnlineSub.SystemInterface.IsControllerConnected(LocPlayer.ControllerId));
    }
    //return;    
}

function ProfileDataChanged()
{
    local string OldPlayerName;
    local OnlineGameSettings GameSettings;

    OldPlayerName = PlayerReplicationInfo.PlayerName;
    // End:0x93
    if(OldPlayerName != OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocalPlayer(Player).ControllerId)))
    {
        SetName(OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocalPlayer(Player).ControllerId)));
    }
    // End:0x147
    if(int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings();
        // End:0x147
        if(GameSettings != none)
        {
            GameSettings.OwningPlayerName = OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocalPlayer(Player).ControllerId));
            OnlineSub.GameInterface.UpdateOnlineGame(GameSettings, true);
        }
    }
    //return;    
}

function MutingChanged()
{
    //return;    
}

function FriendsChanged()
{
    //return;    
}

function ReadFriendsListDone(bool bWasSuccessful)
{
    local array<OnlineFriend> Friends;
    local int Index;

    // End:0x33
    if(OnlineSub != none)
    {
        OnlineSub.PlayerInterface.GetFriendsList(0, Friends);
    }
    Index = 0;
    J0x3A:

    // End:0x54 [Loop If]
    if(Index < Friends.Length)
    {
        Index++;
        // [Loop Continue]
        goto J0x3A;
    }
    //return;    
}

function OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local int DeviceID;
    local OnlineSubsystem.ELoginStatus Status;
    local OnlinePlayerInterface PlayerInterface;

    // End:0x138
    if(bWasSuccessful && ProfileSettings != none)
    {
        UpdateLocalCacheOfProfileSettings();
        SaveLocalProfileSettings();
        // End:0x87
        if(PDAManager != none)
        {
            ProfileSettings.GetUnlockedPDAMessageData(PDAManager.PDAMsgData);
            PDAManager.BuildUnlockedPDAMsgs();
            // End:0x87
            if(bResetPickupMessageActorState)
            {
                bResetPickupMessageActorState = false;
                ResetPickupMessageActorState();
            }
        }
        Status = 0;
        // End:0x138
        if(OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            // End:0xF4
            if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
            {
                Status = PlayerInterface.GetLoginStatus(byte(LocalPlayer(Player).ControllerId));
            }
            // End:0x138
            if(int(Status) > int(0))
            {
                DeviceID = ProfileSettings.GetCurrentDeviceID();
                // End:0x138
                if(CheckDeviceId(DeviceID))
                {
                    bCanSaveToDevice = true;
                }
            }
        }
    }
    //return;    
}

function DownloadableContentQueryDone(bool bWasSuccessful)
{
    local int NewDownloads, TotalDownloads;

    // End:0x62
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
    {
        // End:0x62
        if(bWasSuccessful)
        {
            OnlineSub.ContentInterface.GetAvailableDownloadCounts(0, NewDownloads, TotalDownloads);            
        }
    }
    //return;    
}

function GameCreateDone(bool bWasSuccessful)
{
    local string hostURL;
    local PandoraGRI PGRI;
    local UIDataStore_GameResource GameResourceDataStore;
    local UIProviderScriptFieldValue MapNameValue;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x25
    if(PGRI == none)
    {
    }
    // End:0x115
    if(PGRI != none)
    {
        // End:0x115
        if(bWasSuccessful)
        {
            GameResourceDataStore = UIDataStore_GameResource(GetUIController().DataStoreManager.FindDataStore('GameResources'));
            GameResourceDataStore.GetProviderFieldValue('MultiplayerMaps', 'MapName', PandoraGameInfo(WorldInfo.Game).MP_MapId, MapNameValue);
            hostURL = MapNameValue.StringValue $ "?listen?Game=PandoraGameContent.PandoraMonsterMachine?Team=255";
            LocalTravel(hostURL);
        }
    }
    //return;    
}

function GameDestroyDone(bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(GameDestroyDone);
    //return;    
}

function GameEndDone(bool bWasSuccessful)
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(WorldInfo.GRI);
    OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(GameEndDone);
    DestroySession();
    PGRI.bEndOnlineGameInitiated = false;
    //return;    
}

exec function EndOnlineGame()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x9A
    if((OnlineSub != none) && int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(GameEndDone);
        OnlineSub.GameInterface.EndOnlineGame();
        PGRI.bEndOnlineGameInitiated = true;
    }
    //return;    
}

exec function DestroySession()
{
    // End:0x30
    if(OnlineSub != none)
    {
        // End:0x30
        if(OnlineSub.GameInterface.DestroyOnlineGame() == false)
        {
        }
    }
    //return;    
}

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    return ((Pawn != none) ? Pawn.GetBaseAimRotation() : Rotation);
    //return ReturnValue;    
}

reliable server function ServerChangeTeam(int N)
{
    super(PlayerController).ServerChangeTeam(N);
    NotifyTeamChanged();
    //return;    
}

simulated function NotifyTeamChanged()
{
    local SPHud theHud;

    // End:0x60
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        theHud = SPHud(myHUD);
        // End:0x60
        if(theHud != none)
        {
            theHud.InitTargetManager();
            theHud.UpdateHUDTeamColor();            
        }
    }
    //return;    
}

function OnControllerChanged(int ControllerId, bool bIsConnected)
{
    local PandoraGameViewportClient pvc;
    local PandoraGameInfo GameInfo;

    pvc = none;
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x18B
    if((LocalPlayer(Player) != none) && LocalPlayer(Player).ControllerId == ControllerId)
    {
        bIsControllerConnected = bIsConnected;
        PauseGame(ControllerId, bIsConnected);
        // End:0xF7
        if(bIsConnected)
        {
            // End:0xF7
            if(!bIsExternalUIOpen && bQueuedPause)
            {
                pvc = PandoraGameViewportClient(GetViewportClient());
                // End:0xF7
                if(((GameInfo != none) && GameInfo.IsInCinematic()) || (pvc != none) && pvc.FullScreenIsMoviePlaying())
                {
                    bQueuedPause = false;
                }
            }
        }
        // End:0x18B
        if(WorldInfo.IsConsoleBuild(2) && ControllerId == 0)
        {
            // End:0x139
            if(bIsConnected)
            {
                Class'SPUIScene'.static.ClearScreenWarningMessage();                
            }
            else
            {
                Class'SPUIScene'.static.ShowScreenWarningMessage(Localize("ToastMessagesPS3", "ReconnectController", "PlatformPS3"));
            }
        }
    }
    //return;    
}

event OnSystemPauseRequest(bool bShouldPause)
{
    OnExternalUIChanged(bShouldPause);
    //return;    
}

function PauseGame(int ControllerId, bool bIsConnected, optional bool bIsBladeOpening = false)
{
    local PandoraGameInfo GameInfo;
    local PlayerController PC;
    local int LocalPlayerCounts;
    local bool bIsTraveling;
    local string MovieName;
    local PandoraGameViewportClient pvc;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    pvc = PandoraGameViewportClient(GetViewportClient());
    // End:0x1AA
    if((LocalPlayer(Player) != none) && LocalPlayer(Player).ControllerId == ControllerId)
    {
        // End:0x7B
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            LocalPlayerCounts++;            
        }        
        bIsTraveling = GameEngine(Player.Outer).TravelURL != "";
        GetCurrentMovie(MovieName);
        // End:0x1AA
        if((((!bIsConnected || bIsBladeOpening) && LocalPlayerCounts == 1) && !bIsTraveling) && int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            // End:0x1A2
            if((((MovieName == "") && !GameInfo.IsInCinematic()) && !pvc.FullScreenIsMoviePlaying()) && !IsPauseInputIgnored())
            {
                bQueuedPause = false;
                // End:0x19F
                if(!GameInfo.IsInShellLevel())
                {
                    // End:0x19F
                    if(!IsPaused() && !bIsConnected || bIsBladeOpening)
                    {
                        ShowPauseMenu();
                    }
                }                
            }
            else
            {
                bQueuedPause = true;
            }
        }
    }
    //return;    
}

function OnExternalUIChanged(bool bIsOpening)
{
    local SPGameUISceneClient theSceneClient;
    local PandoraGameViewportClient pvc;
    local PandoraGameInfo GameInfo;

    pvc = none;
    theSceneClient = none;
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    bIsExternalUIOpen = bIsOpening;
    // End:0x136
    if(LocalPlayer(Player) != none)
    {
        // End:0x8C
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            PauseGame(LocalPlayer(Player).ControllerId, bIsControllerConnected, bIsOpening);            
        }
        else
        {
            // End:0xB3
            if(IsLobbySceneActive())
            {
                SPPlayerReplicationInfo(PlayerReplicationInfo).RequestReadyStatusChange(false);
            }
        }
        // End:0x136
        if(!bIsExternalUIOpen)
        {
            // End:0x136
            if(bIsControllerConnected && bQueuedPause)
            {
                pvc = PandoraGameViewportClient(GetViewportClient());
                // End:0x136
                if(((GameInfo != none) && GameInfo.IsInCinematic()) || (pvc != none) && pvc.FullScreenIsMoviePlaying())
                {
                    bQueuedPause = false;
                }
            }
        }
    }
    // End:0x1A9
    if(bLoginChanged && !bIsOpening)
    {
        bLoginChanged = false;
        theSceneClient = GetSceneClient();
        // End:0x1A9
        if((ProfileSettings != none) && theSceneClient.MainMenuIsActive())
        {
            // End:0x1A9
            if(!WorldInfo.IsConsoleBuild(2))
            {
                UpdateStorageLocation();
            }
        }
    }
    //return;    
}

reliable server function ServerEnablePawn()
{
    // End:0x2C
    if(Pawn != none)
    {
        Pawn.SetHidden(false);
        Pawn.SetCollision(true, true);
    }
    //return;    
}

reliable server function ServerDisablePawn()
{
    // End:0x2C
    if(Pawn != none)
    {
        Pawn.SetHidden(true);
        Pawn.SetCollision(false, false);
    }
    //return;    
}

exec function EditWeapons()
{
    local UIScene_WeaponAdjustment WeaponAdjustmentScene;

    WeaponAdjustmentScene = UIScene_WeaponAdjustment(DynamicLoadObject("MegaMPScenes.WeaponAdjustmentScene", Class'UIScene_WeaponAdjustment'));
    OpenScene(WeaponAdjustmentScene);
    //return;    
}

simulated function ToggleDeathEffect(bool bEnable)
{
    local SPHud mySPHud;
    local SPMaterialEffectsManager spEffectsManager;

    mySPHud = GetSPHud();
    spEffectsManager = mySPHud.GetEffectsManager();
    // End:0xB1
    if(spEffectsManager != none)
    {
        // End:0x79
        if(bEnable)
        {
            mySPHud.HudScene.FadeOut(2.0000000);
            spEffectsManager.ActivatePlayerDeathEffect();            
        }
        else
        {
            mySPHud.HudScene.FadeIn(0.0000000);
            spEffectsManager.DeActivatePlayerDeathEffect();
        }
    }
    //return;    
}

reliable server function ServerCycleNextTarget(int LookType)
{
    // End:0x20
    if(IsInState('Dead'))
    {
        CycleMultiplayerView(1, LookType);
    }
    //return;    
}

reliable server function ServerCyclePrevTarget(int LookType)
{
    // End:0x24
    if(IsInState('Dead'))
    {
        CycleMultiplayerView(-1, LookType);
    }
    //return;    
}

function CycleMultiplayerView(int Dir, int LookType)
{
    local PlayerReplicationInfo PRI;
    local SPMonsterMachinePersistent MonsterMachine;
    local int I, CurrentIndex, NewIndex;
    local bool bSuccess;

    CurrentIndex = -1;
    // End:0x82
    if(RealViewTarget != none)
    {
        I = 0;
        J0x1D:

        // End:0x82 [Loop If]
        if(I < WorldInfo.GRI.PRIArray.Length)
        {
            // End:0x78
            if(RealViewTarget == WorldInfo.GRI.PRIArray[I])
            {
                CurrentIndex = I;
                // [Explicit Break]
                goto J0x82;
            }
            I++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    J0x82:

    NewIndex = CurrentIndex + Dir;
    J0x94:

    // End:0x202 [Loop If]
    if((NewIndex >= 0) && NewIndex < WorldInfo.GRI.PRIArray.Length)
    {
        PRI = WorldInfo.GRI.PRIArray[NewIndex];
        // End:0x1ED
        if((((PRI != none) && Controller(PRI.Owner) != none) && Controller(PRI.Owner).Pawn != none) && (WorldInfo.GRI.OnSameTeam(self, PRI) && LookType == 0) || (int(PRI.GetTeamNum()) == int(3)) && LookType == 1)
        {
            // End:0x1E2
            if(Controller(PRI.Owner).Pawn.PhysicsVolume.LocationName ~= "OOW")
            {
                bSuccess = false;                
            }
            else
            {
                bSuccess = true;
                // [Explicit Break]
                goto J0x202;
            }
        }
        NewIndex = NewIndex + Dir;
        // [Loop Continue]
        goto J0x94;
    }
    J0x202:

    // End:0x3BF
    if(!bSuccess)
    {
        CurrentIndex = ((NewIndex < 0) ? WorldInfo.GRI.PRIArray.Length : -1);
        NewIndex = CurrentIndex + Dir;
        J0x251:

        // End:0x3BF [Loop If]
        if((NewIndex >= 0) && NewIndex < WorldInfo.GRI.PRIArray.Length)
        {
            PRI = WorldInfo.GRI.PRIArray[NewIndex];
            // End:0x3AA
            if((((PRI != none) && Controller(PRI.Owner) != none) && Controller(PRI.Owner).Pawn != none) && (WorldInfo.GRI.OnSameTeam(self, PRI) && LookType == 0) || (int(PRI.GetTeamNum()) == int(3)) && LookType == 1)
            {
                // End:0x39F
                if(Controller(PRI.Owner).Pawn.PhysicsVolume.LocationName ~= "OOW")
                {
                    bSuccess = false;                    
                }
                else
                {
                    bSuccess = true;
                    // [Explicit Break]
                    goto J0x3BF;
                }
            }
            NewIndex = NewIndex + Dir;
            // [Loop Continue]
            goto J0x251;
        }
    }
    J0x3BF:

    // End:0x3F7
    if(bSuccess)
    {
        SetRotation(PRI.Owner.Rotation);
        SetViewTarget(PRI);        
    }
    else
    {
        // End:0x4CF
        foreach WorldInfo.DynamicActors(Class'SPMonsterMachinePersistent', MonsterMachine)
        {
            // End:0x471
            if((int(MonsterMachine.OwningTeam) == int(0)) && int(GetTeamNum()) == int(1))
            {
                RealViewTarget = none;
                SetRotation(MonsterMachine.Rotation);
                SetViewTarget(MonsterMachine);
                // End:0x4CF
                break;
                // End:0x4CE
                continue;
            }
            // End:0x4CE
            if((int(MonsterMachine.OwningTeam) == int(1)) && int(GetTeamNum()) == int(2))
            {
                RealViewTarget = none;
                SetRotation(MonsterMachine.Rotation);
                SetViewTarget(MonsterMachine);
                // End:0x4CF
                break;
            }            
        }        
    }
    //return;    
}

reliable client simulated function ClientSetOnlineStatus()
{
    local OnlineGameSettings GameSettings;
    local string MapName;
    local int GameStatusVal;
    local string strGameStatusVal, strBuildVersion;
    local PandoraGRI PGRI;

    // End:0x1FB
    if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) && int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings();
        // End:0x1FB
        if(GameSettings != none)
        {
            // End:0x85
            if(Len(m_AdvertisedMap) > 0)
            {
                MapName = m_AdvertisedMap;                
            }
            else
            {
                MapName = WorldInfo.GetMapName();
            }
            GameSettings.SetPropertyFromStringByName('MyCustomMapName', MapName);
            PGRI = PandoraGRI(WorldInfo.GRI);
            // End:0xE3
            if(PGRI == none)
            {
            }
            // End:0x128
            if(!PGRI.IsRoundInProgress())
            {
                // End:0x11E
                if(PGRI.IsAtEndgameScoreboard())
                {
                    GameStatusVal = 2;                    
                }
                else
                {
                    GameStatusVal = 0;
                }                
            }
            else
            {
                GameStatusVal = 1;
            }
            strGameStatusVal = string(GameStatusVal);
            GameSettings.SetPropertyFromStringByName('MyGameStatus', strGameStatusVal);
            strBuildVersion = GetSPHud().GetBuildVersion();
            GameSettings.SetPropertyFromStringByName('BuildVersion', strBuildVersion);
            // End:0x1EA
            if((GameSettings.bIsLanMatch == false) && OnlineSub.GameInterface.UpdateOnlineGame(GameSettings, m_bShouldRefreshOnlineStatus) == false)
            {                
            }
            // End:0x1FB
            if(m_bShouldRefreshOnlineStatus)
            {
                m_bShouldRefreshOnlineStatus = false;
            }
        }
    }
    // End:0x21F
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        UpdateGameOnlineStatus();
    }
    //return;    
}

simulated function ReplaceUnsupportedCharacters(out string Gamertag)
{
    Gamertag = Repl(Gamertag, " ", "_");
    Gamertag = Repl(Gamertag, "?", "_");
    Gamertag = Repl(Gamertag, "=", "_");
    Gamertag = Repl(Gamertag, "<", "\\<");
    Gamertag = Repl(Gamertag, "[", "_");
    Gamertag = Repl(Gamertag, "]", "_");
    Gamertag = Repl(Gamertag, "#", "_");
    Gamertag = Repl(Gamertag, "/", "_");
    Gamertag = Repl(Gamertag, "\\", "_");
    Gamertag = Repl(Gamertag, ":", "_");
    //return;    
}

reliable server function ServerSetPlayerName(string Gamertag)
{
    // End:0x26
    if(!WorldInfo.IsConsoleBuild(1))
    {
        ReplaceUnsupportedCharacters(Gamertag);
    }
    PlayerReplicationInfo.SetPlayerName(Gamertag);
    //return;    
}

function UpdatePlayerName()
{
    local LocalPlayer LocPlayer;
    local string Gamertag;

    // End:0x9B
    if(OnlineSub != none)
    {
        LocPlayer = LocalPlayer(Player);
        // End:0x98
        if(LocPlayer != none)
        {
            // End:0x98
            if(WorldInfo.IsConsoleBuild())
            {
                Gamertag = OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocPlayer.ControllerId));
                // End:0x98
                if(PlayerReplicationInfo.PlayerName != Gamertag)
                {
                    ServerSetPlayerName(Gamertag);
                }
            }
        }        
    }
    else
    {
        // End:0xD9
        if(PlayerReplicationInfo.PlayerName != Class'PandoraGameInfo'.static.GetComputerName())
        {
            ServerSetPlayerName(Class'PandoraGameInfo'.static.GetComputerName());
        }
    }
    //return;    
}

event InitUniquePlayerId()
{
    UpdatePlayerName();
    super(PlayerController).InitUniquePlayerId();
    //return;    
}

reliable server function ServerAnnounceMessage(int Switch)
{
    local PandoraGameInfo Game;
    local PlayerController Receiver;

    Game = PandoraGameInfo(WorldInfo.Game);
    // End:0x7E
    if(Game != none)
    {
        // End:0x7D
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', Receiver)
        {
            // End:0x7C
            if(Receiver != self)
            {
                Receiver.ReceiveLocalizedMessage(Game.GameMessageClass, Switch, PlayerReplicationInfo);
            }            
        }        
    }
    //return;    
}

function CheckMoviePlayingTimer()
{
    local PandoraGameViewportClient pvc;
    local PandoraGRI PGRI;

    pvc = PandoraGameViewportClient(GetViewportClient());
    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0xBC
    if(PGRI != none)
    {
        // End:0x61
        if(!PGRI.IsInPostGame())
        {
            ClearTimer('CheckMoviePlayingTimer');
            return;
        }
        // End:0xB9
        if(pvc != none)
        {
            // End:0xB9
            if(!pvc.FullScreenIsMoviePlaying() && PGRI.IsInPostGame())
            {
                ClearTimer('CheckMoviePlayingTimer');
                ClientProcessMovieCompletion();
            }
        }        
    }
    else
    {
        ClearTimer('CheckMoviePlayingTimer');
    }
    //return;    
}

reliable client simulated event ClientPlayMovie(name MovieName, optional PandoraGameViewportClient.ePlayMovie PlayMovieMode = 4)
{
    local PandoraGameViewportClient pvc;

    pvc = PandoraGameViewportClient(GetViewportClient());
    // End:0x78
    if(pvc != none)
    {
        pvc.FullScreenPlayMovie(MovieName, PlayMovieMode);
        // End:0x78
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            SetTimer(WorldInfo.TimeDilation, true, 'CheckMoviePlayingTimer');
        }
    }
    //return;    
}

reliable client simulated event ClientStopMovie()
{
    local PandoraGameViewportClient pvc;

    pvc = PandoraGameViewportClient(GetViewportClient());
    // End:0x49
    if(pvc != none)
    {
        // End:0x49
        if(pvc.FullScreenIsMoviePlaying())
        {
            pvc.FullScreenSetNeedLoadingMovieOnCineCancel(false);
        }
    }
    Class'Engine.GameEngine'.static.StopMovie(false);
    //return;    
}

reliable client simulated function ClientProcessMovieCompletion()
{
    ServerProcessMovieCompletion();
    //return;    
}

reliable server function ServerProcessMovieCompletion()
{
    PandoraGameInfo(WorldInfo.Game).ProcessClientMovieCompletion(self);
    //return;    
}

reliable client simulated function ClientLoadingScreen(bool bShow)
{
    local string GameTypeName;
    local name MovieName;
    local PandoraGameViewportClient pvc;

    GameTypeName = PathName(WorldInfo.GetGameClass());
    GameTypeName = Mid(GameTypeName, InStr(GameTypeName, ".") + 1);
    // End:0x6C
    if(GameTypeName ~= "PandoraMonsterMachine")
    {
        MovieName = 'loadingMP';
    }
    pvc = PandoraGameViewportClient(GetViewportClient());
    // End:0xCA
    if(pvc != none)
    {
        // End:0xB0
        if(bShow)
        {
            pvc.FullScreenPlayMovie(MovieName, 1);            
        }
        else
        {
            pvc.FullScreenStopMovie(MovieName, false);
        }
    }
    //return;    
}

simulated function bool IsMoviePlaying()
{
    local PandoraGameViewportClient pvc;

    pvc = PandoraGameViewportClient(GetViewportClient());
    // End:0x32
    if(pvc != none)
    {
        return pvc.FullScreenIsMoviePlaying();
    }
    return false;
    //return ReturnValue;    
}

exec function ExitLoadingScreen()
{
    ClientLoadingScreen(false);
    //return;    
}

function StorageChangeCallback()
{
    local PandoraGameInfo GameInfo;
    local OnlineSubsystem.ELoginStatus LoginStatus;
    local PandoraPlayerController.EDeviceValidErrorCode CheckDeviceResult;
    local PandoraGameViewportClient pvc;

    LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(byte(LocalPlayer(Player).ControllerId));
    // End:0x4D
    if(int(LoginStatus) == int(0))
    {
        return;
    }
    pvc = PandoraGameViewportClient(GetViewportClient());
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0xF6
    if(((pvc != none) && pvc.FullScreenIsMoviePlaying()) || (GameInfo != none) && GameInfo.IsInCinematic())
    {
        // End:0xF6
        if(!InShellLevel() || pvc.FullScreenIsMoviePlaying())
        {
            bDelayMemoryCardRemovedCallBack = true;
            return;
        }
    }
    CheckStorageDevice(CheckDeviceResult);
    switch(CheckDeviceResult)
    {
        // End:0x1D5
        case 2:
            // End:0x1D2
            if(bCanSaveToDevice && int(LoginStatus) > int(0))
            {
                bCanSaveToDevice = false;
                ShowMsgBox("<Strings:PandoraGame.ErrorMessages.MemoryCardRemovedMessage>", "<Strings:PandoraGame.ErrorMessages.MemoryCardRemovedTitle>", 7, OnStorageChangeMsgResult, None, 0, 5);
                return;
            }
            // End:0x1D8
            break;
        // End:0xFFFF
        default:
            break;
    }
    TestProfileWrite();
    //return;    
}

function ResetPickupMessageActorState()
{
    local SPPDAMessagePickupFactory P;

    // End:0x30
    foreach AllActors(Class'SPPDAMessagePickupFactory', P)
    {
        // End:0x2F
        if(P != none)
        {
            P.ResetPickupState();
        }        
    }    
    //return;    
}

function SetSoundVolume()
{
    local int PlayerIndex;

    PlayerIndex = GetUIPlayerIndex();
    // End:0x35
    if(PlayerIndex == 0)
    {
        SetMasterVolume(ProfileSettings.GetMasterVol());
    }
    //return;    
}

function SetMusic()
{
    local int PlayerIndex;

    PlayerIndex = GetUIPlayerIndex();
    // End:0x65
    if(PlayerIndex == 0)
    {
        // End:0x4D
        if(ProfileSettings.IsMusicEnabled())
        {
            SetAudioGroupVolume('MASTER_Music', 1.0000000);            
        }
        else
        {
            SetAudioGroupVolume('MASTER_Music', 0.0000000);
        }
    }
    //return;    
}

reliable client simulated event bool ClientOpenScene(UIScene Scene)
{
    return GetUIController().OpenScene(Scene);
    //return ReturnValue;    
}

simulated function Restore()
{
    bMsgBoxDisplayed = false;
    //return;    
}

simulated function UIScene_ConfirmationDialog ShowMsgBox(string msg, optional string boxTitle = "", optional PandoraGRI.eMsgBoxType Mode = 0, optional delegate<OnResults> OnResultsDelegate, optional delegate<OnMessage> OnMessageDelegate, optional int nTimeoutValue, optional UIScene_BaseFrontEnd.eMsgBoxPriorityType msgPriority = 2)
{
    local UIScene_ConfirmationDialog msgBoxScene;

    msgBoxScene = Class'SPGameUISceneClient'.static.ShowMessageBox(LocalPlayer(Player), msgPriority, msg, boxTitle, Mode, nTimeoutValue, OnResultsDelegate, OnMessageDelegate);
    // End:0xA5
    if(msgBoxScene != none)
    {
        msgBoxScene.__OnSceneClose__Delegate = Restore;
        bMsgBoxDisplayed = true;
        msgBoxScene.FadeIn(0.0000000);        
    }
    return msgBoxScene;
    //return ReturnValue;    
}

reliable client simulated function ClientSetProgressMessage(PlayerController.EProgressMessageType MessageType, string Message, optional string Title)
{
    super(PlayerController).ClientSetProgressMessage(MessageType, Message, Title);
    // End:0x7C
    if(((!bMsgBoxDisplayed && !m_bWaitForConnectionErrorConfirmation) && int(MessageType) == int(5)) && !IsScoreboardActive())
    {
        ShowMsgBox(Message, Title, 0, ConnectionErrorReturnToMainMenu, None, 0, 7);
    }
    //return;    
}

function NotifyConnectionError(optional string Message = Localize("ErrorMessages", "ConnectionFailed", "PandoraGame"), optional string Title = Localize("ErrorMessages", "ConnectionFailed_Title", "PandoraGame"))
{
    local OnlineGameSettings Settings;
    local bool bArbitrated;

    ScriptTrace();
    // End:0x199
    if(WorldInfo.Game != none)
    {
        WorldInfo.Game.bHasNetworkError = true;
        bArbitrated = WorldInfo.Game.bUsingArbitration;
        // End:0x196
        if(!bMsgBoxDisplayed && !bArbitrated)
        {
            // End:0x16B
            if((int(WorldInfo.NetMode) == int(NM_Standalone)) && IsMoviePlaying())
            {
                // End:0x14F
                if(WorldInfo.GetMapName() ~= "pandorastart")
                {
                    Class'Engine.GameEngine'.static.StopMovie(false);                    
                }
                else
                {
                    ClientTravel("pandorastart", 0);
                }
            }
            ShowMsgBox(Message, Title, 0, ConnectionErrorReturnToMainMenu, None, 0, 7);
        }        
    }
    else
    {
        Settings = OnlineSub.GameInterface.GetGameSettings();
        // End:0x1E3
        if(Settings != none)
        {
            bArbitrated = Settings.bUsesArbitration;            
        }
        else
        {
            bArbitrated = false;
        }
        // End:0x2AB
        if(!bMsgBoxDisplayed && !bArbitrated)
        {
            // End:0x280
            if((int(WorldInfo.NetMode) == int(NM_Standalone)) && IsMoviePlaying())
            {
                // End:0x264
                if(WorldInfo.GetMapName() ~= "pandorastart")
                {
                    Class'Engine.GameEngine'.static.StopMovie(false);                    
                }
                else
                {
                    ClientTravel("pandorastart", 0);
                }
            }
            ShowMsgBox(Message, Title, 0, ConnectionErrorReturnToMainMenu, None, 0, 7);
        }
    }
    //return;    
}

function ConnectionErrorReturnToMainMenu(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    local OnlineGameSettings Settings;
    local bool bArbitrated;

    // End:0x24
    if((int(eReturnValue) == int(4)) || int(eReturnValue) == int(0))
    {
        return;
    }
    Settings = OnlineSub.GameInterface.GetGameSettings();
    // End:0x6E
    if(Settings != none)
    {
        bArbitrated = Settings.bUsesArbitration;        
    }
    else
    {
        bArbitrated = false;
    }
    m_bWaitForConnectionErrorConfirmation = false;
    DestroySession();
    // End:0x104
    if((!IsLobbySceneActive() && int(WorldInfo.NetMode) != int(NM_Standalone)) && int(WorldInfo.NetMode) != int(NM_ListenServer))
    {
        // End:0xE5
        if(bArbitrated)
        {
            ClientToggleEndGameScoreboard();            
        }
        else
        {
            ClientTravel("pandorastart", 0);
        }        
    }
    else
    {
        ClientTravel("pandorastart", 0);
    }
    //return;    
}

simulated function bool IsLobbySceneActive()
{
    local SPGameUISceneClient SceneClient;
    local UIScene_MPMenu LobbySceneUI;

    SceneClient = GetSceneClient();
    // End:0x3A
    if(SceneClient != none)
    {
        LobbySceneUI = UIScene_MPMenu(SceneClient.GetActiveScene());
    }
    return LobbySceneUI != none;
    //return ReturnValue;    
}

simulated function bool IsScoreboardActive()
{
    local SPGameUISceneClient SceneClient;
    local UIScene_Scoreboard TheScoreboard;

    SceneClient = GetSceneClient();
    // End:0x3A
    if(SceneClient != none)
    {
        TheScoreboard = UIScene_Scoreboard(SceneClient.GetActiveScene());
    }
    return TheScoreboard != none;
    //return ReturnValue;    
}

reliable client simulated function ClientToggleEndGameScoreboard()
{
    local UIScene ScoreboardUIRef, ScoreboardUI;

    // End:0xA4
    if(!IsScoreboardActive())
    {
        ScoreboardUIRef = UIScene(DynamicLoadObject("PandoraShellLobby.PandoraScoreboard", Class'Engine.UIScene'));
        GetUIController().OpenScene(ScoreboardUIRef, LocalPlayer(Player), ScoreboardUI);
        UIScene_Scoreboard(ScoreboardUI).SetInGameMode(false);
        UIScene_Scoreboard(ScoreboardUI).bLostConnectionToHost = true;        
    }
    else
    {
        ScoreboardUI = GetSceneClient().FindSceneByTag('SPScoreBoard');
        // End:0xF0
        if(UIScene_Scoreboard(ScoreboardUI) != none)
        {
            UIScene_Scoreboard(ScoreboardUI).bLostConnectionToHost = true;
        }
    }
    //return;    
}

function QuitToMainMenu(optional bool bDoCleanup = true)
{
    bQuittingToMainMenu = true;
    // End:0x33
    if(bDoCleanup && (CleanupOnlineSubsystemSession(true)) == false)
    {
        FinishQuitToMainMenu();
    }
    //return;    
}

function FinishQuitToMainMenu()
{
    Class'Engine.Engine'.static.StopMovie(false);    
    ConsoleCommand("Disconnect");
    //return;    
}

function bool CleanupOnlineSubsystemSession(bool bWasFromMenu)
{
    // End:0x8F
    if((((int(WorldInfo.NetMode) != int(NM_Standalone)) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && OnlineSub.GameInterface.GetGameSettings() != none)
    {
        OnlineSub.GameInterface.EndOnlineGame();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnEndOnlineGameComplete(bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
    // End:0x88
    if(bQuittingToMainMenu)
    {
        OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
        // End:0x88
        if(!OnlineSub.GameInterface.DestroyOnlineGame())
        {
            OnDestroyOnlineGameComplete(true);
        }
    }
    //return;    
}

function OnDestroyOnlineGameComplete(bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyOnlineGameComplete);
    FinishQuitToMainMenu();
    //return;    
}

simulated function DlgReturnToMainMenu(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x12
    if(int(eReturnValue) == int(4))
    {
        return;
    }
    DestroySession();
    ClientTravel("pandorastart", 0);
    //return;    
}

function bool InLANGameOrMenu()
{
    local bool bIsLANMode;
    local PandoraDMOnlineGameSettings pDM_OGS;

    bIsLANMode = false;
    pDM_OGS = PandoraDMOnlineGameSettings(OnlineSub.GameInterface.GetGameSettings());
    // End:0x5A
    if((pDM_OGS != none) && pDM_OGS.bIsLanMatch)
    {
        bIsLANMode = true;
    }
    // End:0x84
    if(PandoraGameInfo(WorldInfo.Game).bLanMatch)
    {
        bIsLANMode = true;
    }
    return bIsLANMode;
    //return ReturnValue;    
}

function bool InMultiplayerGameOrMenu()
{
    local bool bIsMPMode;
    local SPGameUISceneClient GameSceneClient;

    GameSceneClient = GetSceneClient();
    bIsMPMode = false;
    // End:0x3A
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        bIsMPMode = true;
    }
    // End:0x66
    if((GameSceneClient != none) && GameSceneClient.NetworkSceneIsActive())
    {
        bIsMPMode = true;
    }
    return bIsMPMode;
    //return ReturnValue;    
}

function bool InShellLevel()
{
    local PandoraGameInfo GameInfo;

    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0x41
    if((GameInfo != none) && GameInfo.IsInShellLevel())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
    local UIScene_BaseFrontEnd UISceneBFE;

    UISceneBFE = UIScene_BaseFrontEnd(GetSceneClient().GetActiveScene());
    // End:0x48
    if((UISceneBFE != none) && !UISceneBFE.bQuitToMainMenuOnProfileChange)
    {
        return;
    }
    // End:0x1FB
    if((InMultiplayerGameOrMenu()) && !InLANGameOrMenu())
    {
        switch(ConnectionStatus)
        {
            // End:0x102
            case 7:
                CloseSceneType(Class'UIScene_ConfirmationDialog');
                ShowMsgBox(PlatformStrings $ "ErrorMessages.DuplicateSignin_Message>", PlatformStrings $ "ErrorMessages.DuplicateSignin_Title>", 0, DlgReturnToMainMenu, None, 0, 9);
                // End:0x1F8
                break;
            // End:0x107
            case 2:
            // End:0x10C
            case 3:
            // End:0x111
            case 4:
            // End:0x116
            case 5:
            // End:0x1F5
            case 6:
                // End:0x168
                if((WorldInfo.Game != none) && int(WorldInfo.NetMode) != int(NM_Standalone))
                {
                    WorldInfo.Game.bHasNetworkError = true;
                }
                CloseSceneType(Class'UIScene_ConfirmationDialog');
                ShowMsgBox(PlatformStrings $ "ErrorMessages.LostConnection_Message>", PlatformStrings $ "ErrorMessages.LostConnection_Title>", 0, DlgReturnToMainMenu, None, 0, 9);
                // End:0x1F8
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        // End:0x35C
        if((InMultiplayerGameOrMenu()) && InLANGameOrMenu())
        {
            switch(ConnectionStatus)
            {
                // End:0x2B3
                case 7:
                    CloseSceneType(Class'UIScene_ConfirmationDialog');
                    ShowMsgBox(PlatformStrings $ "ErrorMessages.DuplicateSignin_Message>", PlatformStrings $ "ErrorMessages.DuplicateSignin_Title>", 0, DlgReturnToMainMenu, None, 0, 9);
                    // End:0x35C
                    break;
                // End:0x2B8
                case 2:
                // End:0x2BD
                case 3:
                // End:0x2C2
                case 4:
                // End:0x2C7
                case 5:
                // End:0x359
                case 6:
                    CloseSceneType(Class'UIScene_ConfirmationDialog');
                    ShowMsgBox(PlatformStrings $ "ErrorMessages.LostConnection_Message>", PlatformStrings $ "ErrorMessages.LostConnection_Title>", 0, None, None, 0, 8);
                    // End:0x35C
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
        }
        //return;        
    }
}

simulated function OnLinkStatusChange(bool bIsConnected)
{
    local UIScene_BaseFrontEnd UISceneBFE;

    UISceneBFE = UIScene_BaseFrontEnd(GetSceneClient().GetActiveScene());
    // End:0x66
    if(UISceneBFE.SceneTag != 'Confirmation_Dialog')
    {
        // End:0x66
        if((UISceneBFE != none) && UISceneBFE.bHandleConnectionMessages == false)
        {
            return;
        }
    }
    // End:0x14A
    if(!bIsConnected && InMultiplayerGameOrMenu())
    {
        // End:0xCB
        if(int(WorldInfo.NetMode) == int(NM_ListenServer))
        {
            // End:0xCB
            if(WorldInfo.Game != none)
            {
                WorldInfo.Game.bHasNetworkError = true;
            }
        }
        ShowMsgBox(PlatformStrings $ "ErrorMessages.NoLinkConnection_Message>", PlatformStrings $ "ErrorMessages.NoLinkConnection_Title>", 0, DlgReturnToMainMenu, None, 0, 9);
    }
    //return;    
}

function ProfileChangeCB(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    local SPGameUISceneClient SceneClient;
    local UIScene_BaseFrontEnd TopmostScene;

    // End:0x12
    if(int(eReturnValue) == int(4))
    {
        return;
    }
    // End:0x7F
    if(InShellLevel())
    {
        SceneClient = GetSceneClient();
        // End:0x59
        if(SceneClient != none)
        {
            TopmostScene = UIScene_BaseFrontEnd(SceneClient.GetActiveScene());
        }
        // End:0x7C
        if(TopmostScene != none)
        {
            LocalTravel("PandoraStart");
        }        
    }
    else
    {
        // End:0xB5
        if(InMultiplayerGameOrMenu())
        {
            DestroySession();
            ClientTravel("pandorastart", 0);            
        }
        else
        {
            ReadProfile();
            LocalTravel("PandoraStart");
        }
    }
    //return;    
}

function LoginChanged()
{
    // End:0x30
    if(LocalPlayer(Player).ControllerId != -1)
    {
        ProcessLoginChange();
        bLoginChanged = true;
    }
    //return;    
}

function ProcessLoginChange()
{
    local OnlineSubsystem.ELoginStatus LoginStatus, LoginThreshold;
    local SPGameUISceneClient theSceneClient;
    local UIScene_BaseFrontEnd ActiveScene;
    local PandoraGameInfo GameInfo;
    local string OldPlayerName;

    theSceneClient = GetSceneClient();
    ActiveScene = UIScene_BaseFrontEnd(theSceneClient.GetActiveScene());
    // End:0x53
    if((ActiveScene != none) && !ActiveScene.bQuitToMainMenuOnProfileChange)
    {
        return;
    }
    GameInfo = PandoraGameInfo(WorldInfo.Game);
    // End:0xF0
    if(((int(WorldInfo.NetMode) == int(NM_Standalone)) && GameInfo.IsInShellLevel()) && !InMultiplayerGameOrMenu())
    {
        // End:0xCB
        if(theSceneClient.MainMenuIsActive())
        {
            return;
        }
        // End:0xF0
        if(theSceneClient.GetActiveUIScene('UIScene_StartMenu') != none)
        {
            return;
        }
    }
    // End:0x125
    if((InMultiplayerGameOrMenu()) && !OnlineSub.SystemInterface.HasLinkConnection())
    {
        return;
    }
    // End:0x1DA
    if((HasInactiveProfile()) && InMultiplayerGameOrMenu())
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InactiveSignedInMessage>", "<Strings:PandoraGame.ErrorMessages.OnePlayerOnly_Title>", 0, ProfileChangeCB, None, 0, 8);
        return;
    }
    // End:0x276
    if((HasInactiveProfile()) && !InMultiplayerGameOrMenu())
    {
        ShowMsgBox(PlatformStrings $ "ErrorMessages.ProfileNotAvailable>", PlatformStrings $ "ErrorMessages.ProfileNotAvailableTitle>", 0, ProfileChangeCB, None, 0, 8);
        return;
    }
    LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(byte(LocalPlayer(Player).ControllerId));
    // End:0x2CB
    if(!InMultiplayerGameOrMenu())
    {
        LoginThreshold = 1;        
    }
    else
    {
        // End:0x2E3
        if(InLANGameOrMenu())
        {
            LoginThreshold = 1;            
        }
        else
        {
            LoginThreshold = 2;
        }
    }
    // End:0x330
    if(((InLANGameOrMenu()) && int(WorldInfo.NetMode) == int(NM_ListenServer)) && int(LoginStatus) == int(0))
    {
        DestroySession();
    }
    // End:0x423
    if(WorldInfo.IsConsoleBuild(1))
    {
        OldPlayerName = PlayerReplicationInfo.PlayerName;
        // End:0x423
        if(OldPlayerName != OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocalPlayer(Player).ControllerId)))
        {
            ShowMsgBox(PlatformStrings $ "UIScene_ConfirmationDialog.ProfileChangedText>", PlatformStrings $ "ErrorMessages.ProfileNotAvailableTitle>", 0, ProfileChangeCB, None, 0, 8);
            return;
        }
    }
    // End:0x4D3
    if((int(LoginStatus) >= int(LoginThreshold)) && startedSPGameWithoutProfile)
    {
        ShowMsgBox(PlatformStrings $ "UIScene_ConfirmationDialog.ProfileChangedText>", PlatformStrings $ "ErrorMessages.ProfileNotAvailableTitle>", 0, ProfileChangeCB, None, 0, 8);
        startedSPGameWithoutProfile = false;
        return;
    }
    // End:0x58E
    if((int(LoginStatus) >= int(LoginThreshold)) && !startedSPGameWithoutProfile)
    {
        // End:0x58C
        if(WorldInfo.IsConsoleBuild())
        {
            // End:0x58C
            if(InLANGameOrMenu())
            {
                ShowMsgBox(PlatformStrings $ "ErrorMessages.LostConnection_Message>", PlatformStrings $ "ErrorMessages.LostLink_Title>", 0, None, None, 0, 8);                
            }
        }
        return;
    }
    startedSPGameWithoutProfile = false;
    ShowMsgBox(PlatformStrings $ "ErrorMessages.ProfileNotAvailable>", PlatformStrings $ "ErrorMessages.ProfileNotAvailableTitle>", 0, ProfileChangeCB, None, 0, 8);
    //return;    
}

simulated function RegisterConnectionCallbacks()
{
    OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
    OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(OnLinkStatusChange);
    //return;    
}

simulated function UnregisterConnectionCallbacks()
{
    OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
    OnlineSub.SystemInterface.ClearLinkStatusChangeDelegate(OnLinkStatusChange);
    //return;    
}

exec function TurnOnRadarButtonPressed()
{
    // End:0x17
    if(WorldInfo.Pauser != none)
    {
        return;
    }
    // End:0x7F
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x75
        if((m_GameplayGDTuneData != none) && m_GameplayGDTuneData.ShowSinglePlayerRadarButtonPressDelay > float(0))
        {
            SetTimer(m_GameplayGDTuneData.ShowSinglePlayerRadarButtonPressDelay, false, 'TurnOnRadar');            
        }
        else
        {
            TurnOnRadar();
        }
    }
    //return;    
}

exec function TurnOffRadarButtonPressed()
{
    // End:0x24
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        TurnOffRadar();
    }
    //return;    
}

function TurnOnRadar()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x37
    if(PGRI != none)
    {
        PGRI.RadarMode = 1;
    }
    //return;    
}

function TurnOffRadar()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x37
    if(PGRI != none)
    {
        PGRI.RadarMode = 2;
    }
    ClearTimer('TurnOnRadar');
    //return;    
}

simulated function name GetNonControllerBinding(string TheCommand)
{
    local name TempBinding;

    TempBinding = 'None';
    // End:0x3E
    if(PandoraPlayerInput(PlayerInput) != none)
    {
        return PandoraPlayerInput(PlayerInput).GetNonControllerBinding(TheCommand);
    }
    return TempBinding;
    //return ReturnValue;    
}

static final simulated function bool IsAXBoxButton(name theName)
{
    // End:0x24C
    if((((((((((((((((((((((((((((theName == 'XboxTypeS_A') || theName == 'XboxTypeS_B') || theName == 'XboxTypeS_X') || theName == 'XboxTypeS_Y') || theName == 'XboxTypeS_Back') || theName == 'XboxTypeS_Start') || theName == 'XboxTypeS_RightThumbstick') || theName == 'XboxTypeS_LeftThumbstick') || theName == 'XboxTypeS_LeftX') || theName == 'XboxTypeS_LeftY') || theName == 'XboxTypeS_RightX') || theName == 'XboxTypeS_RightY') || theName == 'XboxTypeS_DPad_Right') || theName == 'XboxTypeS_DPad_Left') || theName == 'XboxTypeS_DPad_Up') || theName == 'XboxTypeS_DPad_Down') || theName == 'XboxTypeS_LeftTrigger') || theName == 'XboxTypeS_LeftShoulder') || theName == 'XboxTypeS_RightTrigger') || theName == 'XboxTypeS_RightShoulder') || theName == 'Gamepad_LeftStick_Up') || theName == 'Gamepad_LeftStick_Down') || theName == 'Gamepad_LeftStick_Right') || theName == 'Gamepad_LeftStick_Left') || theName == 'Gamepad_RightStick_Up') || theName == 'Gamepad_RightStick_Down') || theName == 'Gamepad_RightStick_Right') || theName == 'Gamepad_RightStick_Left')
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function SetNonControllerBinding(name theName, string TheCommand)
{
    local int BindIndex, BindIndexToChange;

    BindIndexToChange = -1;
    BindIndex = 0;
    J0x12:

    // End:0x98 [Loop If]
    if(BindIndex < PlayerInput.Bindings.Length)
    {
        // End:0x8E
        if(!IsAXBoxButton(PlayerInput.Bindings[BindIndex].Name) && PlayerInput.Bindings[BindIndex].Command == TheCommand)
        {
            BindIndexToChange = BindIndex;
        }
        ++BindIndex;
        // [Loop Continue]
        goto J0x12;
    }
    // End:0xCD
    if(BindIndexToChange != -1)
    {
        PlayerInput.Bindings[BindIndexToChange].Name = theName;
    }
    PlayerInput.SaveConfig();
    //return;    
}

function OnStorageChangeMsgResult(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x29
    if(int(eReturnValue) == int(2))
    {
        SelectDevice(DatafileSize, NotifyDeviceSelectComplete);
    }
    //return;    
}

reliable client simulated function ClientReset()
{
    local SPEmitterSpawnable Particles;
    local SPDroppedPickup Pickup;

    super(PlayerController).ClientReset();
    // End:0x24
    foreach AllActors(Class'SPDroppedPickup', Pickup)
    {
        Pickup.Destroy();        
    }    
    // End:0x43
    foreach AllActors(Class'SPEmitterSpawnable', Particles)
    {
        Particles.Destroy();        
    }    
    PandoraPlayerInput(PlayerInput).ResetOverrides();
    ToggleDeathEffect(false);
    m_bOKToSaveCheckpoints = true;
    //return;    
}

reliable server function ServerSyncPRI()
{
    local string StatGuid;

    WorldInfo.Game.FindInactivePRI(self);
    // End:0xA9
    if((WorldInfo.GRI.bMatchHasBegun && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        StatGuid = OnlineSub.StatsInterface.GetHostStatGuid();
        // End:0xA9
        if(StatGuid != "")
        {
            ClientRegisterHostStatGuid(StatGuid);
        }
    }
    //return;    
}

exec function UnlockAllEpisodes()
{
    local int I, J;

    // End:0x0D
    if(ProfileSettings == none)
    {
        return;
    }
    I = 0;
    J0x14:

    // End:0x83 [Loop If]
    if(I < 3)
    {
        J = 1;
        J0x27:

        // End:0x79 [Loop If]
        if(J < 9)
        {
            ProfileSettings.UnlockChapter(J, I);
            ProfileSettings.CompleteChapter(J, I);
            J++;
            // [Loop Continue]
            goto J0x27;
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    WriteProfile();
    //return;    
}

exec function UnlockEpisode(int epNo)
{
    // End:0x0D
    if(ProfileSettings == none)
    {
        return;
    }
    ProfileSettings.UnlockChapter(epNo);
    WriteProfile();
    //return;    
}

function OnAmBxSetRumble(SeqAct_AmBxSetRumble Action)
{
    SendAmBxShake(Action.durationMillis, Action.intensity, Action.Speed);
    //return;    
}

function OnAmBxSetWindEffect(SeqAct_AmBxSetWindEffect Action)
{
    m_CurrentScriptedWindEffect.m_TimeStarted = -1.0000000;
    m_CurrentScriptedWindEffect.m_RelativeWindYaw = 0;
    m_CurrentScriptedWindEffect = Action;
    //return;    
}

function OnAmBxPauseAllWindEffects(bool Pause)
{
    // End:0x28
    if(Pause)
    {
        m_PausedScriptedWindEffect = m_CurrentScriptedWindEffect;
        m_CurrentScriptedWindEffect = none;
        BuildAndSendWindStopScriptForKismetWidget();        
    }
    else
    {
        m_CurrentScriptedWindEffect = m_PausedScriptedWindEffect;
    }
    //return;    
}

function OnAmBxStopAllWindEffects(SeqAct_AmBxStopAllWindEffects Action)
{
    m_CurrentScriptedWindEffect.m_TimeStarted = -1.0000000;
    m_CurrentScriptedWindEffect.m_RelativeWindYaw = 0;
    m_CurrentScriptedWindEffect = none;
    BuildAndSendWindStopScriptForKismetWidget();
    //return;    
}

function OnAmBxPlayScript(SeqAct_AmBxPlayScript Action)
{
    PlayAmBxScript(Action.ScriptName, 0);
    //return;    
}

function OnAmBxStopScript(SeqAct_AmBxStopScript Action)
{
    StopAmBxScript(Action.ScriptName);
    //return;    
}

function bool CanAllPlayersPlayOnline()
{
    local int I;
    local bool bCanPlayOnline;

    bCanPlayOnline = false;
    I = 0;
    J0x0F:

    // End:0xC7 [Loop If]
    if(I < 4)
    {
        // End:0x84
        if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(I))) != int(0)) && int(OnlineSub.PlayerInterface.CanPlayOnline(byte(I))) == int(0))
        {
            return false;
            // [Explicit Continue]
            goto J0xBD;
        }
        // End:0xBD
        if(int(OnlineSub.PlayerInterface.GetLoginStatus(byte(I))) == int(2))
        {
            bCanPlayOnline = true;
        }
        J0xBD:

        I++;
        // [Loop Continue]
        goto J0x0F;
    }
    return bCanPlayOnline;
    //return ReturnValue;    
}

function NotifyTooManyPlayersSignedInToJoinInvite()
{
    ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InactiveSignedInMessage>", "<Strings:PandoraGame.ErrorMessages.OnePlayerOnly_Title>", 0);
    //return;    
}

function NotifyNotAllPlayersCanJoinInvite()
{
    ShowMsgBox("<Strings:PandoraGame.ErrorMessages.NotAllPlayersCanJoin_Message>", "<Strings:PandoraGame.ErrorMessages.InviteHandlingFailed_Title>", 0);
    //return;    
}

function NotifyNotEnoughSpaceInInvite()
{
    ShowMsgBox("<Strings:PandoraGame.ErrorMessages.UnableToJoinInvite_Message>", "<Strings:PandoraGame.ErrorMessages.InviteHandlingFailed_Title>", 0);
    //return;    
}

function NotifyInviteFailed()
{
    ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InviteHandlingFailed_Message>", "<Strings:PandoraGame.ErrorMessages.InviteHandlingFailed_Title>", 0);
    //return;    
}

function bool IsGuestProfile()
{
    local bool bIsGuestProfile;

    bIsGuestProfile = false;
    // End:0x4F
    if(OnlineSub != none)
    {
        bIsGuestProfile = OnlineSub.PlayerInterface.IsGuestLogin(byte(LocalPlayer(Player).ControllerId));
    }
    return bIsGuestProfile;
    //return ReturnValue;    
}

function TestProfileWrite()
{
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;

    ControllerId = LocalPlayer(Player).ControllerId;
    // End:0xF7
    if(OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0xF4
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)) && ControllerId != -1)
        {
            ProfileSettings.SetProfileBusy(true);
            ProfileSettings.SetProfileDirty(false);
            // End:0xDF
            if(IsProfileWriteEnabled())
            {
                PlayerInt.AddWriteProfileSettingsCompleteDelegate(byte(ControllerId), OnTestProfileWriteComplete);
                PlayerInt.WriteProfileSettings(byte(ControllerId), ProfileSettings);                
            }
            else
            {
                OnTestProfileWriteComplete(byte(ControllerId), true);
            }            
        }        
    }
    //return;    
}

function OnTestProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;

    // End:0x82
    if(OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0x82
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            ControllerId = LocalPlayer(Player).ControllerId;
            // End:0x82
            if(ControllerId != -1)
            {
                PlayerInt.ClearWriteProfileSettingsCompleteDelegate(byte(ControllerId), OnTestProfileWriteComplete);
            }
        }
    }
    // End:0x128
    if(!bWasSuccessful)
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.GamerProfileLost_Message>", "<Strings:PandoraGame.ErrorMessages.MemoryCardRemovedTitle>", 0, None, None, 0, 5);
    }
    ProfileSettings.SetProfileBusy(false);
    //return;    
}

reliable server function ServerSetTrackingOnDisconnect()
{
    SPPlayerReplicationInfo(PlayerReplicationInfo).bTrackOnDisconnect = true;
    //return;    
}

event LoadCheckpointFailed()
{
    ShowMsgBox("<Strings:PandoraGame.ErrorMessages.ErrorLoadingGame_Message>", "<Strings:PandoraGame.ErrorMessages.ErrorLoadingGame_Title>", 0, ProfileChangeCB, None, 0, 8);
    //return;    
}

simulated function bool PromptOnUnavailableProfile()
{
    local OnlineSubsystem.ELoginStatus LoginStatus;
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId));
    // End:0xE0
    if(int(LoginStatus) == int(0))
    {
        ShowMsgBox(PlatformStrings $ "UIScene_ConfirmationDialog.ProfileChangedText>", PlatformStrings $ "ErrorMessages.ProfileNotAvailableTitle>", 0, ProfileChangeCB, None, 0, 8);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsAlreadyBound(name KeyName)
{
    local int Idx;

    // End:0x6A
    if(KeyName != 'None')
    {
        Idx = 0;
        J0x1A:

        // End:0x6A [Loop If]
        if(Idx < PlayerInput.Bindings.Length)
        {
            // End:0x60
            if(KeyName == PlayerInput.Bindings[Idx].Name)
            {
                return true;
            }
            Idx++;
            // [Loop Continue]
            goto J0x1A;
        }
    }
    return false;
    //return ReturnValue;    
}

reliable client simulated function ClientWasKicked()
{
    ClientSetProgressMessage(5, Localize("AccessControl", "KickedMsg", "Engine"), Localize("ErrorMessages", "CommunicationRequired_Title", "PandoraGame"));
    DestroySession();
    // End:0xBD
    if(!WorldInfo.IsConsoleBuild())
    {        
        ConsoleCommand("Disconnect Local");
    }
    //return;    
}

private final simulated function bool CanCommunicate()
{
    return int(WorldInfo.NetMode) != int(NM_Standalone);
    //return ReturnValue;    
}

auto state PlayerWaiting
{
    reliable server function ServerRestartPlayer()
    {
        super.ServerRestartPlayer();
        //return;        
    }
Begin:

    PlayerReplicationInfo.bOnlySpectator = false;
    // End:0x86
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        WorldInfo.Game.bRestartLevel = false;
        WorldInfo.Game.RestartPlayer(self);
        WorldInfo.Game.bRestartLevel = true;        
    }
    else
    {
        WorldInfo.Game.bRestartLevel = false;
    }
    stop;        
}

state PhysicsSpectator extends BaseSpectating
{
    ignores SwitchToBestWeapon, TogglePhysicsMode, ServerSuicide;

    function bool CanRestartPlayer()
    {
        return !PlayerReplicationInfo.bOnlySpectator;
        //return ReturnValue;        
    }

    exec function Jump()
    {
        LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText("Jump D");
        //return;        
    }

    reliable server function ServerChangeTeam(int N)
    {
        WorldInfo.Game.ChangeTeam(self, 0, true);
        NotifyTeamChanged();
        //return;        
    }

    reliable server function ServerRestartPlayer()
    {
        // End:0x1B
        if(WorldInfo.TimeSeconds < WaitDelay)
        {
            return;
        }
        // End:0x37
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            return;
        }
        // End:0x69
        if(WorldInfo.Game.bWaitingToStartMatch)
        {
            PlayerReplicationInfo.bReadyToPlay = true;            
        }
        else
        {
            WorldInfo.Game.RestartPlayer(self);
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        bCollideWorld = false;
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        bCollideWorld = true;
        //return;        
    }
    stop;    
}

state PlayerAttached
{
    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        // End:0x0D
        if(Pawn == none)
        {
            return;
        }
        // End:0x5C
        if(Pawn.IsLocallyControlled() && int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z, newAccel;
        local Actor.EDoubleClickDir DoubleClickMove;
        local Rotator OldRotation;
        local bool bSaveJump;

        // End:0x0B
        if(bOverridePlayerControl)
        {
            return;
        }
        // End:0x18
        if(Pawn == none)
        {
            return;
        }
        GetAxes(Pawn.Rotation, X, Y, Z);
        // End:0x56
        if(LockPosition == 1)
        {
            newAccel = float(0) * X;            
        }
        else
        {
            newAccel = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
        }
        newAccel.Z = 0.0000000;
        // End:0xC4
        if(VSize(newAccel) < 1.0000000)
        {
            newAccel = vect(0.0000000, 0.0000000, 0.0000000);
        }
        DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        bDoubleJump = false;
        // End:0x14B
        if(bPressedJump && Pawn.CannotJumpNow())
        {
            bSaveJump = true;
            bPressedJump = false;            
        }
        else
        {
            bSaveJump = false;
        }
        // End:0x18C
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);            
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
        }
        bPressedJump = bSaveJump;
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        DoubleClickDir = 0;
        bPressedJump = false;
        GroundPitch = 0;
        // End:0x7C
        if(Pawn != none)
        {
            Pawn.ShouldCrouch(false);
            // End:0x7C
            if((int(Pawn.Physics) != int(2)) && int(Pawn.Physics) != int(10))
            {
                Pawn.SetPhysics(1);
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        GroundPitch = 0;
        // End:0x48
        if(Pawn != none)
        {
            Pawn.SetRemoteViewPitch(0);
            // End:0x48
            if(int(bDuck) == int(0))
            {
                Pawn.ShouldCrouch(false);
            }
        }
        //return;        
    }
    stop;    
}

state PlayerWalking
{
    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        local PlayerPawn playaPawn;

        playaPawn = PlayerPawn(Pawn);
        // End:0x1D
        if(playaPawn == none)
        {
            return;
        }
        // End:0x7C
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            // End:0x7C
            if((int(Role) == int(ROLE_Authority)) || Pawn.IsLocallyControlled())
            {
                Pawn.SetRemoteViewPitch(Rotation.Pitch);
            }
        }
        Pawn.Acceleration = newAccel;
        // End:0xA6
        if(LockPosition != 1)
        {
            CheckJumpOrDuck();
        }
        //return;        
    }

    simulated function ScaleSpeedByWeapon()
    {
        local PlayerPawn myPawn;
        local float Scale;

        myPawn = PlayerPawn(Pawn);
        // End:0x77
        if(myPawn != none)
        {
            Scale = myPawn.WeaponWalkSpeedScalar();
            myPawn.Velocity.X *= Scale;
            myPawn.Velocity.Y *= Scale;
        }
        //return;        
    }

    function DoSprint(float DeltaTime)
    {
        local PlayerPawn playaPawn;

        playaPawn = PlayerPawn(Pawn);
        // End:0x4A
        if((PandoraPlayerInput(PlayerInput) != none) && PandoraPlayerInput(PlayerInput).Outer.IsSprintInputIgnored())
        {
            return;
        }
        // End:0x216
        if(playaPawn != none)
        {
            // End:0x1D9
            if((playaPawn.Velocity.X != 0.0000000) || playaPawn.Velocity.Y != 0.0000000)
            {
                // End:0x1C7
                if(!bBurningSprintTime)
                {
                    bBurningSprintTime = true;
                    // End:0xED
                    if(!bBurnedSprintTime)
                    {
                        bBurnedSprintTime = true;
                        SetTimer(0.5000000, false, 'StopSprintBurstAndStartSprint');
                        LastSprintTime = WorldInfo.TimeSeconds;
                    }
                    ForceInterruptReload();
                    // End:0x11D
                    if(PlayerPawn(Pawn) != none)
                    {
                        PlayerPawn(Pawn).InSprintAnimNodeStatus = 1;
                    }
                    // End:0x14B
                    if((Pawn != none) && Pawn.IsFiring())
                    {
                        StopFiring();
                    }
                    // End:0x176
                    if(playaPawn.CheckForHandToHandWeapon())
                    {
                        playaPawn.StopFiringHandToHandWeapon();
                    }
                    // End:0x19F
                    if(PandoraPlayerInput(PlayerInput) != none)
                    {
                        PandoraPlayerInput(PlayerInput).AnimusDeActivate();
                    }
                    playaPawn.DisableAnimusActivitiesFromClient();
                    playaPawn.RemoveAllActiveSiphonStreams();
                }
                ReduceSprintTime(DeltaTime);                
            }
            else
            {
                bBurningSprintTime = false;
            }
            // End:0x216
            if(bForceSprintExtension && (WorldInfo.TimeSeconds - LastSprintTime) > SprintDurationMin)
            {
                OnSprintStop();
            }
        }
        //return;        
    }

    function bool DoDodge(Actor.EDoubleClickDir DoubleClickMove)
    {
        local PlayerPawn playaPawn;
        local Actor.EDoubleClickDir dodgeDoubleClickMoveOverride, dodgeDoubleClickMove;
        local float saveVelDotY;
        local Vector X, Y, Z;

        playaPawn = PlayerPawn(Pawn);
        // End:0x32
        if(int(forceDodgeMove) == int(0))
        {
            CheckDodgeCombine(dodgeDoubleClickMoveOverride);            
        }
        else
        {
            dodgeDoubleClickMoveOverride = forceDodgeMove;
        }
        // End:0x58
        if(int(dodgeDoubleClickMoveOverride) == int(0))
        {
            dodgeReset = true;            
        }
        else
        {
            // End:0x6B
            if(!dodgeReset)
            {
                dodgeDoubleClickMoveOverride = 0;
            }
        }
        // End:0xA2
        if((int(DoubleClickMove) == int(5)) && int(Pawn.Physics) == int(2))
        {
            DoubleClickDir = 5;            
        }
        else
        {
            // End:0x179
            if((int(dodgeDoubleClickMoveOverride) != int(0)) && int(dodgeDoubleClickMoveOverride) < int(5))
            {
                // End:0x179
                if(((SprintTime >= DodgeTimeCost) && (WorldInfo.TimeSeconds - LastDodgeTime) > playaPawn.DodgeTimeIntervalMin) && !playaPawn.GetIsPartiallyLookingDownSite())
                {
                    // End:0x176
                    if(SPPawn(Pawn).Dodge(dodgeDoubleClickMoveOverride))
                    {
                        ForceInterruptReload();
                        SprintTime -= DodgeTimeCost;
                        DoubleClickDir = 5;
                        LastDodgeTime = WorldInfo.TimeSeconds;
                        dodgeReset = false;
                    }                    
                }
            }
        }
        forceDodgeMove = 0;
        // End:0x349
        if((playaPawn.bDodging && !playaPawn.GetIsPartiallyLookingDownSite()) && !playaPawn.bIsCrouched)
        {
            // End:0x248
            if(((WorldInfo.TimeSeconds - LastDodgeTime) > playaPawn.DodgeTimeLength) || int(playaPawn.Physics) != int(1))
            {
                playaPawn.bDodging = false;
                CheckDodgeCombine(dodgeDoubleClickMove);
                // End:0x245
                if(int(dodgeDoubleClickMove) == int(0))
                {
                    dodgeReset = true;
                }                
            }
            else
            {
                GetAxes(Pawn.Rotation, X, Y, Z);
                saveVelDotY = playaPawn.Velocity Dot Y;
                // End:0x2F6
                if(Abs(saveVelDotY) > Abs(playaPawn.Velocity Dot X))
                {
                    playaPawn.Velocity = Y * playaPawn.DodgeSpeed;
                    // End:0x2F3
                    if(saveVelDotY < 0.0000000)
                    {
                        playaPawn.Velocity *= -1.0000000;
                    }                    
                }
                else
                {
                    playaPawn.Velocity = Normal(playaPawn.Velocity) * playaPawn.DodgeSpeed;
                }
                playaPawn.GroundSpeed = playaPawn.DodgeSpeed;
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z, newAccel;
        local Actor.EDoubleClickDir DoubleClickMove;
        local Rotator OldRotation;
        local bool bSaveJump;
        local PlayerPawn playaPawn;

        // End:0x0B
        if(bOverridePlayerControl)
        {
            return;
        }
        // End:0x40
        if(Pawn == none)
        {
            // End:0x3E
            if(int(WorldInfo.NetMode) != int(NM_Standalone))
            {
                GotoState('Dead');
            }
            return;
        }
        GetAxes(Pawn.Rotation, X, Y, Z);
        // End:0x8A
        if((int(bRun) != int(0)) || bForceSprintExtension)
        {
            DoSprint(DeltaTime);
        }
        ScaleSpeedByWeapon();
        // End:0xB2
        if(LockPosition == 1)
        {
            newAccel = float(0) * X;            
        }
        else
        {
            newAccel = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
            newAccel.Z = 0.0000000;
            newAccel = Pawn.AccelRate * Normal(newAccel);
        }
        // End:0x13E
        if(VSize(newAccel) < 1.0000000)
        {
            newAccel = vect(0.0000000, 0.0000000, 0.0000000);
        }
        DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
        playaPawn = PlayerPawn(Pawn);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        bDoubleJump = false;
        // End:0x210
        if(bPressedJump)
        {
            // End:0x1D3
            if(Pawn.CannotJumpNow())
            {
                bSaveJump = true;
                bPressedJump = false;                
            }
            else
            {
                // End:0x205
                if(playaPawn != none)
                {
                    playaPawn.bInAir = true;
                    playaPawn.PlayJumpInitSound();
                }
                bSaveJump = false;
            }            
        }
        else
        {
            bSaveJump = false;
        }
        // End:0x251
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);            
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
        }
        bPressedJump = bSaveJump;
        // End:0x2B2
        if(playaPawn.GroundSpeed == 0.0000000)
        {
            playaPawn.GroundSpeed = OverrideGroundSpeed;
        }
        //return;        
    }
    stop;    
}

simulated state TentacleGrab
{
    simulated function bool IsInTentacleGrabState()
    {
        return true;
        //return ReturnValue;        
    }

    function PlayerMove(float DeltaTime)
    {
        UpdateRotation(DeltaTime);
        //return;        
    }

    event EndGrab()
    {
        Pawn.SetCollision(true, true);
        Pawn.SetPhysics(1);
        //return;        
    }
Begin:

    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    stop;        
}

simulated state WerewolfTackle
{
    simulated function bool IsInWerewolfTackleState()
    {
        return true;
        //return ReturnValue;        
    }

    function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot, ViewRotation;

        ViewRotation = Rotation;
        DesiredRotation = ViewRotation;
        ViewRotation = m_tackleViewRotation;
        DeltaRot.Yaw = 0;
        DeltaRot.Pitch = 0;
        DeltaRot.Roll = 0;
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        // End:0xA1
        if(Pawn != none)
        {
            Pawn.FaceRotation(ViewRotation, DeltaTime);
        }
        //return;        
    }

    function EndTackleFromAnimation()
    {
        PlayerPawn(Pawn).playerHud.UnRegisterTackleMinigame();
        tackleMinigameManager.ResumePlayerControl();
        //return;        
    }

    function Controller GetCurrentTMGEnemy()
    {
        return m_werewolfTackler;
        //return ReturnValue;        
    }

    function CheckTMGAllignment()
    {
        local Vector playerSocket1, playerSocket2, enemySocket1;
        local Rotator playerRotator1, playerRotator2, enemyRotator1;
        local Vector vDir1, vDir2;

        // End:0x24
        if((m_werewolfMinigameController == none) || m_werewolfMinigameController.Pawn == none)
        {
            return;
        }
        // End:0xE1
        if(((Pawn.Mesh.GetSocketWorldLocationAndRotation('PlayerWWFailSafeCheck1', playerSocket1, playerRotator1) == false) || m_werewolfMinigameController.Pawn.Mesh.GetSocketWorldLocationAndRotation('WWFailSafeCheckAlligned', enemySocket1, enemyRotator1) == false) || Pawn.Mesh.GetSocketWorldLocationAndRotation('PlayerWWFailSafeCheck2', playerSocket2, playerRotator2) == false)
        {
            m_werewolfMinigameController.TMGFailed();
            return;
        }
        vDir1 = Normal(playerSocket1 - playerSocket2);
        vDir2 = Normal(enemySocket1 - playerSocket1);
        // End:0x135
        if((vDir1 Dot vDir2) < 0.7500000)
        {
            m_werewolfMinigameController.TMGFailed();
            return;
        }
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        // End:0x0B
        if(bOverridePlayerControl)
        {
            return;
        }
        UpdateRotation(DeltaTime);
        //return;        
    }

    function StartMinigameTackleAction(PandoraPlayerController.ePlayerActionState actionState, optional float animSynchTime)
    {
        local SPPawn pSPPawn;

        m_actionState = actionState;
        pSPPawn = SPPawn(Pawn);
        // End:0x40
        if(pSPPawn != none)
        {
            pSPPawn.SetAnimationSynchronizationTime(animSynchTime);
        }
        //return;        
    }

    function SwapToMeleeWeaponIfApplicable()
    {
        local SPWeapon Weap;

        // End:0x17
        if(WorldInfo.Pauser != none)
        {
            return;
        }
        Weap = SPWeapon(Pawn.Weapon);
        // End:0x1A4
        if((Pawn.InvManager != none) && !PlayerPawn(Pawn).IsSiphoning())
        {
            // End:0x1A4
            if((Weap != none) && ((((((Weap.WeapID == '9MM') || Weap.WeapID == 'DesertEagle') || Weap.WeapID == 'Flame') || Weap.WeapID == 'RocketLauncher') || Weap.WeapID == 'HK_UMP') || !Weap.bSemiAuto && Weap.ammoInMagazine < 3) || Weap.bSemiAuto && Weap.ammoInMagazine == 0)
            {
                // End:0x1A4
                if(SPInventoryManager(Pawn.InvManager) != none)
                {
                    SPInventoryManager(Pawn.InvManager).SwitchToMeleeWeapon();
                }
            }
        }
        //return;        
    }

    event ResetTimer()
    {
        ClearTimer('TACKLETIMER');
        SetTimer(3.0000000, false, 'TACKLETIMER');
        //return;        
    }

    event EndTackle()
    {
        Pawn.SetCollision(true, true);
        Pawn.SetPhysics(1);
        DisableTMGPostProcessing();
        SPSkeletalMeshComponent(Pawn.Mesh).SetFOV(m_oldFOV);
        overRideGlobalFOV = 0.0000000;
        m_bLockWeaponFOVtoWorld = false;
        SetTimer(5.0000000, false, 'TACKLETIMER');
        m_actionState = 0;
        Pawn.bNoWeaponFiring = false;
        //return;        
    }

    event WerewolfTackleGetUpEnded()
    {
        // End:0x1A
        if(int(m_actionState) == int(17))
        {
            EndTackleFromAnimation();
        }
        //return;        
    }
Begin:

    m_bTimeForTackle = false;
    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    m_blendValueForMash1Animations = 0.5000000;
    StopFire();
    ResetPlayerAim();
    Pawn.bNoWeaponFiring = true;
    m_oldFOV = SPSkeletalMeshComponent(Pawn.Mesh).GetFOV();
    SPSkeletalMeshComponent(Pawn.Mesh).SetFOV(85.0000000);
    overRideGlobalFOV = 85.0000000;
    m_bLockWeaponFOVtoWorld = true;
    tackleMinigameManager.BeginTackleMinigame(self);
    m_werewolfMinigameController.TMGHandshake(self);
    stop;        
}

state WerewolfHitAndRun
{
    function PushedState()
    {
        StopFire();
        Pawn.bNoWeaponFiring = true;
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        m_minigameDesiredRotation = GetDesiredRotation();
        m_minigameAlignToEngager = false;
        //return;        
    }

    function PoppedState()
    {
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        local PlayerPawn thePawn;

        thePawn = PlayerPawn(Pawn);
        SPSkeletalMeshComponent(Pawn.Mesh).SetFOV(m_oldFOV);
        thePawn.KnifeComponent.SetFOV(m_oldFOV);
        Pawn.bNoWeaponFiring = false;
        SetMinigameAnim(4, 0);
        thePawn.TakeKnifeFromPlayer();
        SetTimer(45.0000000, false, 'HITANDRUNMINIGAMETIMER');
        //return;        
    }

    function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot, ViewRotation;
        local Vector rotationV, minigameRotationV;

        // End:0x88
        if(m_minigameAlignToEngager)
        {
            rotationV = Vector(Rotation);
            minigameRotationV = Vector(m_minigameDesiredRotation);
            m_minigameDesiredRotation = GetDesiredRotation();
            DeltaRot = GetDeltaRotationToFace(Vector(Rotation), Vector(m_minigameDesiredRotation), 3.1415930 * 0.6600000, DeltaTime);
            // End:0x88
            if((rotationV Dot minigameRotationV) > 0.9900000)
            {
                m_werewolfMinigameController.InAlignment();
            }
        }
        ViewRotation = Rotation;
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        // End:0xDD
        if(Pawn != none)
        {
            Pawn.FaceRotation(ViewRotation, DeltaTime);
        }
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        UpdateRotation(DeltaTime);
        //return;        
    }

    function Rotator GetDesiredRotation()
    {
        local Vector Delta;

        Delta = m_werewolfMinigameController.Pawn.Location - Pawn.Location;
        Delta = Normal(Delta);
        return Rotator(Delta);
        //return ReturnValue;        
    }

    function StartAlignment()
    {
        m_minigameAlignToEngager = true;
        //return;        
    }

    function NotifyEndWerewolfHitAndRun()
    {
        PopState();
        //return;        
    }
Begin:

    m_bTimeForHitAndRunMinigame = false;
    m_werewolfMinigameController.MinigameHandshake(self);
    m_oldFOV = SPSkeletalMeshComponent(Pawn.Mesh).GetFOV();
    SPSkeletalMeshComponent(Pawn.Mesh).SetFOV(85.0000000);
    stop;        
}

state ResumePlayerControl
{Begin:

    overRideGlobalFOV = 0.0000000;
    m_actionState = 0;
    bOverridePlayerControl = false;
    bForceCameraLookAt = false;
    GotoState('PlayerWalking');
    stop;            
}

state PlayerClimbing
{
    function BeginState(name PreviousStateName)
    {
        SPWeapon(Pawn.Weapon).PlayWeaponPutDown();
        super.BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        local PlayerPawn P;

        P = PlayerPawn(Pawn);
        // End:0x3F
        if(P != none)
        {
            P.bInUnequip = false;
            P.bInEquip = false;
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state Dead
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function PlayerMove(float DeltaTime)
    {
        super.PlayerMove(DeltaTime);
        CheckForWerewolfOutOfWorld();
        UpdateRotation(DeltaTime);
        //return;        
    }

    function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot, ViewRotation;
        local ConsolePandoraPlayerInput cPPI;

        ViewRotation = Rotation;
        cPPI = ConsolePandoraPlayerInput(PlayerInput);
        // End:0xBC
        if((cPPI != none) && WorldInfo.IsConsoleBuild())
        {
            cPPI.aTurn *= cPPI.TurningAccelerationMultiplier;
            cPPI.aLookUp *= cPPI.PitchAccelerationMultiplier;
            cPPI.aTurn *= cPPI.SensitivityMultiplier;
            cPPI.aLookUp *= cPPI.SensitivityMultiplier;
        }
        DeltaRot.Yaw = int(cPPI.aTurn);
        DeltaRot.Pitch = int(cPPI.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        //return;        
    }

    simulated function CheckForWerewolfOutOfWorld()
    {
        local Actor AttachedTarget;

        AttachedTarget = GetViewTarget();
        // End:0x63
        if((AttachedTarget != none) && AttachedTarget.IsA('SPBaseWerewolfPawnPersistent'))
        {
            // End:0x63
            if(AttachedTarget.PhysicsVolume.LocationName ~= "OOW")
            {
                ServerCycleNextTarget(1);
            }
        }
        //return;        
    }
    stop;    
}
