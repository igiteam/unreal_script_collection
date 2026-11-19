class R6AbstractGameManager extends Object
    abstract
    native;

struct EGameModeInfo
{
    var R6EngineEnums.EGameMode m_eGameMode;
    var string m_szClassName;
    var bool m_bSolo;

    structdefaultproperties
    {
        m_eGameMode=0
        m_szClassName=""
        m_bSolo=false
    }
};

struct SActorReplicationStats
{
    structcpptext
    {

    FSActorReplicationStats( INT iRepTotalInBits, INT iRepTotalOutBits, UBOOL bIsAFunction )
    {
        m_bIsAFunction = bIsAFunction;
        m_iRepTotalInBits = iRepTotalInBits;
        m_iRepTotalOutBits = iRepTotalOutBits;
    }

    }

    var int m_iRepTotalInBits;
    var int m_iRepTotalOutBits;
    var bool m_bIsAFunction;

    structdefaultproperties
    {
        m_iRepTotalInBits=0
        m_iRepTotalOutBits=0
        m_bIsAFunction=false
    }
};

var native array<Pawn> m_VisiblePawns;
var native array<SeqEvent_R6LookedAt> m_LookAtEvents;
var array<EGameModeInfo> m_GameModeInfo;
var const R6ConfigsManager m_ConfigsManager;
var bool m_bDemoSPModeEnabled;
var bool m_bRebootCheckpoints;
var bool m_bUseGamePad;
var bool m_bDebugReplicationStats;
var bool m_bCheatGIJOE;
var bool m_bCheatGODPlayers;
var bool m_bCheatGODRainbowTeam;
var bool m_bCheatSuperRagdoll;
var bool m_bCheatOneShotOnKill;
var bool m_bCheatInvisible;
var bool m_bCheatCameraThird;
var bool m_bCheatBobbleHead;
var float m_fLastInputTime;
var R6EngineEnums.ECONNECTIONFAILURE m_eLastConnectionFailure;
var byte m_SessionID[8];
var byte m_SessionKEY[16];
var R6EngineEnums.EGameMode m_eClientGameMode;
var R6EngineEnums.EGameType m_eClientGameType;
var const R6SplitscreenMgr m_SplitscreenMgr;
var const R6StatisticsManager m_StatisticsManager;
var const R6PlayerProfileMgr m_PlayerProfileMgr;
var const R6PresenceMgr m_PresenceMgr;
var native Pointer m_pVoiceRecognition;
var int m_ePendingVoiceOrder;
var Class m_DebugReplicationStatsClass;
var native map{VOID,VOID} m_DebugReplicationStats;
var string m_szCheatStatus;
var float m_fCheatStatusTimer;
var string m_strNextMapToLoad;
var array<string> m_arrAccessControlBackup;

// Export UR6AbstractGameManager::execResetGameLevel(FFrame&, void* const)
native function ResetGameLevel();

// Export UR6AbstractGameManager::execGetLocalPlayer(FFrame&, void* const)
native function PlayerController GetLocalPlayer(optional int iPlayerIndex);

// Export UR6AbstractGameManager::execGetBaseMenu(FFrame&, void* const)
native function R6MagmaInteraction GetBaseMenu(optional LocalPlayer pLocalPlayer);

// Export UR6AbstractGameManager::execIsUsingGamePad(FFrame&, void* const)
native function bool IsUsingGamePad();

// Export UR6AbstractGameManager::execIsPaused(FFrame&, void* const)
native function bool IsPaused(optional World pWorld);

// Export UR6AbstractGameManager::execCheatStep(FFrame&, void* const)
native function CheatStep(bool bStep);

// Export UR6AbstractGameManager::execCheatPauseGame(FFrame&, void* const)
native function CheatPauseGame();

// Export UR6AbstractGameManager::execRemoveCheatPause(FFrame&, void* const)
native function RemoveCheatPause();

// Export UR6AbstractGameManager::execPauseSB(FFrame&, void* const)
native function PauseSB();

// Export UR6AbstractGameManager::execStepSB(FFrame&, void* const)
native function StepSB();

// Export UR6AbstractGameManager::execFindGameModeClass(FFrame&, void* const)
native function string FindGameModeClass(R6EngineEnums.EGameMode eMode, bool bSolo);

// Export UR6AbstractGameManager::execGetGameMode(FFrame&, void* const)
native function R6EngineEnums.EGameMode GetGameMode();

// Export UR6AbstractGameManager::execGetGameType(FFrame&, void* const)
native function R6EngineEnums.EGameType GetGameType();

// Export UR6AbstractGameManager::execGetGameRemainingTime(FFrame&, void* const)
native function int GetGameRemainingTime();

// Export UR6AbstractGameManager::execTranslateGameMode(FFrame&, void* const)
native function string TranslateGameMode(R6EngineEnums.EGameMode eMode);

// Export UR6AbstractGameManager::execGetMaxPlayersAllowed(FFrame&, void* const)
native function int GetMaxPlayersAllowed(R6EngineEnums.EGameMode eMode);

// Export UR6AbstractGameManager::execGetMaxCivilsAllowed(FFrame&, void* const)
native function int GetMaxCivilsAllowed(R6EngineEnums.EGameMode eMode);

// Export UR6AbstractGameManager::execGetMaxTerroristsAllowed(FFrame&, void* const)
native function int GetMaxTerroristsAllowed(R6EngineEnums.EGameMode eMode);

// Export UR6AbstractGameManager::execGetMaxRainbowsAllowed(FFrame&, void* const)
native function int GetMaxRainbowsAllowed(R6EngineEnums.EGameMode eMode);

// Export UR6AbstractGameManager::execHandleConnectionFailure(FFrame&, void* const)
native function bool HandleConnectionFailure(string szError, out string szFailCode);

// Export UR6AbstractGameManager::execTranslateConnectionFailure(FFrame&, void* const)
native function string TranslateConnectionFailure(R6EngineEnums.ECONNECTIONFAILURE eCode);

// Export UR6AbstractGameManager::execGetGameStatus(FFrame&, void* const)
native function R6EngineEnums.EGameStatus GetGameStatus();

// Export UR6AbstractGameManager::execOnGameStatusChanged(FFrame&, void* const)
native function OnGameStatusChanged(byte byNewStatus);

// Export UR6AbstractGameManager::execAddGameStatusListener(FFrame&, void* const)
native function AddGameStatusListener(Object pListener);

// Export UR6AbstractGameManager::execRemoveGameStatusListener(FFrame&, void* const)
native function RemoveGameStatusListener(Object pListener);

// Export UR6AbstractGameManager::execIsLocalPlayerHosting(FFrame&, void* const)
native function bool IsLocalPlayerHosting();

// Export UR6AbstractGameManager::execIsMultiplayer(FFrame&, void* const)
native function bool IsMultiplayer();

// Export UR6AbstractGameManager::execIsOffline(FFrame&, void* const)
native function bool IsOffline();

// Export UR6AbstractGameManager::execIsSplitscreen(FFrame&, void* const)
native function bool IsSplitscreen();

// Export UR6AbstractGameManager::execIsSplitscreenVertical(FFrame&, void* const)
native function bool IsSplitscreenVertical();

// Export UR6AbstractGameManager::execQuitSession(FFrame&, void* const)
native function bool QuitSession();

// Export UR6AbstractGameManager::execDestroyNonRelevantActors(FFrame&, void* const)
native final function DestroyNonRelevantActors(R6EngineEnums.EGameMode eMode, R6EngineEnums.EGameType EType);

// Export UR6AbstractGameManager::execGetLocalXNADDR(FFrame&, void* const)
native final function string GetLocalXNADDR();

// Export UR6AbstractGameManager::execAgoraStartMatch(FFrame&, void* const)
native function AgoraStartMatch();

// Export UR6AbstractGameManager::execAgoraEndMatch(FFrame&, void* const)
native function AgoraEndMatch();

// Export UR6AbstractGameManager::execIncrementCivKills(FFrame&, void* const)
native function int IncrementCivKills();

// Export UR6AbstractGameManager::execResetCivKills(FFrame&, void* const)
native function ResetCivKills();

// Export UR6AbstractGameManager::execGetNumberOfCivKilled(FFrame&, void* const)
native function int GetNumberOfCivKilled();

// Export UR6AbstractGameManager::execInitializeFromCheckpoint(FFrame&, void* const)
native function InitializeFromCheckpoint();

// Export UR6AbstractGameManager::execIsLoadingCheckpoint(FFrame&, void* const)
native function bool IsLoadingCheckpoint();

// Export UR6AbstractGameManager::execCanPlayMapIntro(FFrame&, void* const)
native function bool CanPlayMapIntro();

function ToggleForceFireFightColorGel()
{
    return;
}

function ToggleFireFightColorGel()
{
    return;
}

// Export UR6AbstractGameManager::execGetNextMissionURL(FFrame&, void* const)
native function string GetNextMissionURL();

// Export UR6AbstractGameManager::execSetNextMissionURL(FFrame&, void* const)
native function SetNextMissionURL(string fstrNextMissionURL);

// Export UR6AbstractGameManager::execShowTutorialCase(FFrame&, void* const)
native function ShowTutorialCase(R6EngineEnums.ER6Tutorial eCase);

// Export UR6AbstractGameManager::execTutorialCaseDone(FFrame&, void* const)
native function TutorialCaseDone(R6EngineEnums.ER6Tutorial eCase, bool bSucceeded);

// Export UR6AbstractGameManager::execCanSpawnPawn(FFrame&, void* const)
native function bool CanSpawnPawn(class<Pawn> pPawnClass);

// Export UR6AbstractGameManager::execUpdateNetworkSimulationOnLogin(FFrame&, void* const)
native function UpdateNetworkSimulationOnLogin();

// Export UR6AbstractGameManager::execGetGameDifficulty(FFrame&, void* const)
native function R6EngineEnums.EGameDifficulty GetGameDifficulty();

// Export UR6AbstractGameManager::execSetGameDifficulty(FFrame&, void* const)
native function SetGameDifficulty(R6EngineEnums.EGameDifficulty eNewDifficulty);

// Export UR6AbstractGameManager::execEnableCheat(FFrame&, void* const)
native function EnableCheat(int iCheatID);

// Export UR6AbstractGameManager::execIsFriendlyFireOn(FFrame&, void* const)
native function bool IsFriendlyFireOn();

// Export UR6AbstractGameManager::execCleanFXPools(FFrame&, void* const)
native function CleanFXPools();

// Export UR6AbstractGameManager::execResetInitialPlayerInventory(FFrame&, void* const)
native function ResetInitialPlayerInventory();

function SaveAccessControlBannedXUIDs(array<string> arrBannedXUIDs)
{
    local int I;

    ResetAccessControlBannedXUIDs();
    I = 0;
    J0x0E:

    // End:0x40 [Loop If]
    if(I < arrBannedXUIDs.Length)
    {
        m_arrAccessControlBackup[m_arrAccessControlBackup.Length] = arrBannedXUIDs[I];
        I++;
        // [Loop Continue]
        goto J0x0E;
    }
    return;
}

function LoadAccessControlBannedXUIDs(out array<string> arrBannedXUIDs)
{
    local int I;

    arrBannedXUIDs.Remove(0, arrBannedXUIDs.Length);
    I = 0;
    J0x14:

    // End:0x46 [Loop If]
    if(I < m_arrAccessControlBackup.Length)
    {
        arrBannedXUIDs[arrBannedXUIDs.Length] = m_arrAccessControlBackup[I];
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    return;
}

event ResetAccessControlBannedXUIDs()
{
    m_arrAccessControlBackup.Remove(0, m_arrAccessControlBackup.Length);
    return;
}
