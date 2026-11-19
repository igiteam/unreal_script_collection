class R6GameInfo extends GameInfo
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

const SETTING_DIFFICULTY = "GD";

struct SR6BTracerPtr
{
    var Pointer I;

    structdefaultproperties
    {
        I=none
    }
};

var R6AIInfo m_pAIInfo;
var R6ObjectiveManager m_ObjectiveManager;
var float m_fReplenishRespawnTime;
var bool m_bAllowIncapacitation;
var const localized string GameDescription;
var SR6BTracerPtr m_pBulletTracer;

// Export UR6GameInfo::execTickNative(FFrame&, void* const)
native final function TickNative(float fDeltaTime);

// Export UR6GameInfo::execIsInEditor(FFrame&, void* const)
native final function bool IsInEditor();

// Export UR6GameInfo::execGetGameStatus(FFrame&, void* const)
native function R6EngineEnums.EGameStatus GetGameStatus();

// Export UR6GameInfo::execGetGameMode(FFrame&, void* const)
native function R6EngineEnums.EGameMode GetGameMode();

// Export UR6GameInfo::execGetGameType(FFrame&, void* const)
native function R6EngineEnums.EGameType GetGameType();

// Export UR6GameInfo::execInitializeGameReplicationInfo(FFrame&, void* const)
native function InitializeGameReplicationInfo();

// Export UR6GameInfo::execBroadcastGameMessage(FFrame&, void* const)
native function BroadcastGameMessage(class<LocalMessage> Message, R6GameEnums.EGAMEMSG eMsg, optional PlayerReplicationInfo pRelatedPlayer1, optional PlayerReplicationInfo pRelatedPlayer2, optional Object pOptionalObject);

// Export UR6GameInfo::execBroadcastGameTeamMessage(FFrame&, void* const)
native function BroadcastGameTeamMessage(class<LocalMessage> Message, TeamInfo pReceiver, R6GameEnums.EGAMEMSG eMsg, optional Object pOptionalObject);

// Export UR6GameInfo::execSendGameMessage(FFrame&, void* const)
native function SendGameMessage(class<LocalMessage> Message, PlayerController pReceiver, R6GameEnums.EGAMEMSG eMsg, optional PlayerReplicationInfo pRelatedPlayer1, optional PlayerReplicationInfo pRelatedPlayer2, optional Object pOptionalObject);

// Export UR6GameInfo::execIsIncapacitationAllowed(FFrame&, void* const)
native function bool IsIncapacitationAllowed();

// Export UR6GameInfo::execCanObservePlayer(FFrame&, void* const)
native function bool CanObservePlayer(PlayerController pViewer, bool bOnlySpectator, Actor pViewTarget);

// Export UR6GameInfo::execOnGameBeginning(FFrame&, void* const)
native function OnGameBeginning();

// Export UR6GameInfo::execSpawnTeammates(FFrame&, void* const)
native final function SpawnTeammates(Vector vLocation, Rotator rRotation);

// Export UR6GameInfo::execGetPlayerTemplate(FFrame&, void* const)
native function class<Pawn> GetPlayerTemplate(PlayerController pPlayer);

// Export UR6GameInfo::execGetTeamManager(FFrame&, void* const)
native final function R6TeamManager GetTeamManager(R6Pawn pPawn);

// Export UR6GameInfo::execInitManagerCtrl(FFrame&, void* const)
native final function InitManagerCtrl();

// Export UR6GameInfo::execGetIntGameDifficulty(FFrame&, void* const)
native final function int GetIntGameDifficulty(R6EngineEnums.EGameDifficulty EGameDifficulty);

simulated function bool CanThrowWeapon(Pawn P)
{
    return;
}

function CreateInitialObjectives()
{
    return;
}

function ReceivedInputReady(PlayerReplicationInfo pPlayerInfo)
{
    return;
}

function ReceivedHasVoice(PlayerReplicationInfo pPlayerInfo, bool bHasVoice)
{
    return;
}

event OnObjectiveFailed(R6Objective pObjective)
{
    return;
}

event OnObjectiveSucceeded(R6Objective pObjective)
{
    return;
}

function OnObjectiveRegistered(R6Objective pObjective)
{
    return;
}

event OnMissionFailed(R6MissionFailedInfo FailureInfo)
{
    return;
}

event bool GetMissionFailureInfo(out R6MissionFailedInfo out_FailureInfo)
{
    return false;
    return;
}

function taken(R6CarriedObject pObject)
{
    return;
}

function Dropped(R6CarriedObject pObject)
{
    return;
}

function Respawned(R6CarriedObject pObject)
{
    return;
}

function Exploded(R6InteractiveBomb pBomb)
{
    return;
}

function Interacted(R6InteractiveActor pActor, Pawn pPawn, bool bSuccess)
{
    return;
}

function PawnInteracted(R6Pawn pPawn, Pawn pInteractor, bool bSuccess)
{
    return;
}

event RelocatePlayers()
{
    return;
}

event InitGame(string Options, out string ErrorMessage)
{
    local int iGameDifficulty;

    InitGame(Options, ErrorMessage);
    // End:0x25
    if(int(GetGameMode()) == int(0))
    {
        return;
    }
    m_ObjectiveManager = new Class'R6ObjectiveManager';    
    m_ObjectiveManager.m_gameInfo = self;
    CreateInitialObjectives();
    InitManagerCtrl();
    GetGameManager().DestroyNonRelevantActors(GetGameMode(), GetGameType());
    iGameDifficulty = GetIntOption(Options, "GD", GetIntGameDifficulty(2));
    GetGameManager().SetGameDifficulty(byte(iGameDifficulty));
    return;
}

event PlayerController Login(string Portal, string Options, out string ErrorMessage, optional int iLocalPlayerId)
{
    local PlayerController Result;

    Result = Login(Portal, Options, ErrorMessage, iLocalPlayerId);
    // End:0x67
    if((ParseOption(Options, "WithTeammates")) ~= "1")
    {
        SpawnTeammates(Result.Location, Result.Rotation);
    }
    return Result;
    return;
}

event GameBeginning()
{
    OnGameBeginning();
    return;
}

function InitGameReplicationInfo()
{
    InitGameReplicationInfo();
    InitializeGameReplicationInfo();
    return;
}

function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x22
    if(m_ObjectiveManager != none)
    {
        m_ObjectiveManager.Save();
    }
    return;
}

event SetDeleteOnReset(bool bVal)
{
    // End:0x21
    if(GameReplicationInfo != none)
    {
        GameReplicationInfo.SetDeleteOnReset(bVal);
    }
    // End:0x42
    if(BaseMutator != none)
    {
        BaseMutator.SetDeleteOnReset(bVal);
    }
    SetDeleteOnReset(bVal);
    return;
}

function DrawHUD(HUD H)
{
    // End:0x20
    if(m_ObjectiveManager != none)
    {
        m_ObjectiveManager.DrawHUD(H);
    }
    return;
}

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
    // End:0x21
    if(!C.bIsPlayer)
    {
        return GetDefaultPlayerClass(C);
    }
    return GetPlayerTemplate(PlayerController(C));
    return;
}

event Tick(float fDeltaTime)
{
    Tick(fDeltaTime);
    TickNative(fDeltaTime);
    return;
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
    local R6PlayerController R6Killer, R6Killed;
    local R6EngineEnums.EAwardKillDetail eKillDetail;

    // End:0xDB
    if(KilledPlayer != none)
    {
        ScoreKill(Killer, KilledPlayer);
        // End:0xDB
        if(Killer != none)
        {
            // End:0xDB
            if(!WorldInfo.GRI.OnSameTeam(KilledPlayer, Killer))
            {
                R6Killer = R6PlayerController(Killer);
                R6Killed = R6PlayerController(KilledPlayer);
                eKillDetail = 0;
                // End:0x91
                if(DamageType.default.m_bExplosiveDamage)
                {
                    eKillDetail = 2;
                }
                // End:0xC1
                if((R6Killer != none) && Killer != KilledPlayer)
                {
                    R6Killer.ClientOnKilledPlayer(eKillDetail);
                }
                // End:0xDB
                if(R6Killed != none)
                {
                    R6Killed.ClientOnDied();
                }
            }
        }
    }
    // End:0x105
    if(m_ObjectiveManager != none)
    {
        m_ObjectiveManager.PawnDied(R6Pawn(KilledPawn), Killer);
    }
    NotifyKilled(Killer, KilledPlayer, KilledPawn);
    return;
}

function Revived(Controller pHealer, Controller pRevivedPlayer)
{
    return;
}

function Spectated(PlayerController pPlayer)
{
    return;
}

event Entered(R6ExtractionZone PZone, R6Pawn pPawn)
{
    // End:0x25
    if(m_ObjectiveManager != none)
    {
        m_ObjectiveManager.ZoneEntered(PZone, pPawn);
    }
    return;
}

event Exited(R6ExtractionZone PZone, R6Pawn pPawn)
{
    // End:0x25
    if(m_ObjectiveManager != none)
    {
        m_ObjectiveManager.ZoneExited(PZone, pPawn);
    }
    return;
}

function bool SetPause(bool bPause, PlayerController P)
{
    local bool bRes;

    bRes = SetPause(bPause, P);
    // End:0x35
    if(!bPause)
    {
        GetGameManager().RemoveCheatPause();
    }
    return bRes;
    return;
}

function bool AllowCheats(PlayerController P)
{
    return true;
    return;
}

function ResetGameInfo()
{
    ResetGameInfo();
    // End:0x22
    if(GameReplicationInfo != none)
    {
        GameReplicationInfo.Reset();
    }
    // End:0x3D
    if(m_ObjectiveManager != none)
    {
        m_ObjectiveManager.Reset();
    }
    // End:0x57
    if(m_pAIInfo != none)
    {
        m_pAIInfo.Reset();
    }
    return;
}

function ApplyPlayerPenalty(PlayerReplicationInfo Player)
{
    return;
}

function bool CanSpectate(PlayerController Viewer, bool bOnlySpectator, Actor ViewTarget)
{
    return CanObservePlayer(Viewer, bOnlySpectator, ViewTarget);
    return;
}

function BroadcastDeathMessage(Controller Killer, Controller other, class<DamageType> DamageType)
{
    // End:0x43
    if(((other != none) && other.PlayerReplicationInfo != none) && other.PlayerReplicationInfo.IsInState('s_Leaving'))
    {
        return;
    }
    // End:0x77
    if(Killer == other)
    {
        BroadcastGameMessage(GameMessageClass, 26, none, other.PlayerReplicationInfo, DamageType);        
    }
    else
    {
        // End:0xA7
        if(Killer == none)
        {
            BroadcastGameMessage(GameMessageClass, 27, none, other.PlayerReplicationInfo, DamageType);            
        }
        else
        {
            // End:0xED
            if(Killer.PlayerReplicationInfo != none)
            {
                BroadcastGameMessage(GameMessageClass, 28, Killer.PlayerReplicationInfo, other.PlayerReplicationInfo, DamageType);                
            }
            else
            {
                BroadcastGameMessage(GameMessageClass, 29, none, other.PlayerReplicationInfo, DamageType);
            }
        }
    }
    return;
}

event bool KickPlayerID(int iPlayerID)
{
    local PlayerReplicationInfo pPlayerInfo;

    pPlayerInfo = GameReplicationInfo.FindPlayerByID(iPlayerID);
    return KickPlayerInfo(pPlayerInfo);
    return;
}

event bool KickPlayerInfo(PlayerReplicationInfo pPlayer)
{
    // End:0x13
    if(!CanKickPlayer(pPlayer))
    {
        return false;
    }
    // End:0x43
    if(R6PlayerReplicationInfo(pPlayer).IsAnExcessiveTeamKiller())
    {
        BroadcastGameMessage(GameMessageClass, 45, pPlayer);        
    }
    else
    {
        BroadcastGameMessage(GameMessageClass, 44, pPlayer);
    }
    Kick(pPlayer.PlayerName);
    return true;
    return;
}

event bool KickPlayer(int iPlayerID)
{
    local PlayerReplicationInfo pPlayerInfo;

    pPlayerInfo = GameReplicationInfo.FindPlayerByID(iPlayerID);
    // End:0x2E
    if(!CanKickPlayer(pPlayerInfo))
    {
        return false;
    }
    // End:0x5E
    if(R6PlayerReplicationInfo(pPlayerInfo).IsAnExcessiveTeamKiller())
    {
        BroadcastGameMessage(GameMessageClass, 45, pPlayerInfo);        
    }
    else
    {
        BroadcastGameMessage(GameMessageClass, 44, pPlayerInfo);
    }
    Kick(pPlayerInfo.PlayerName);
    return true;
    return;
}

event bool KickPlayerPB(int iPlayerID)
{
    local PlayerReplicationInfo pPlayerInfo;

    pPlayerInfo = GameReplicationInfo.FindPlayerByID(iPlayerID);
    // End:0x2E
    if(!CanKickPlayer(pPlayerInfo))
    {
        return false;
    }
    BroadcastGameMessage(GameMessageClass, 49, pPlayerInfo);
    Kick(pPlayerInfo.PlayerName);
    return true;
    return;
}

function bool CanKickPlayer(PlayerReplicationInfo pPlayer)
{
    return (((pPlayer != none) && pPlayer.Owner != none) && PlayerController(pPlayer.Owner) != none) && PlayerController(pPlayer.Owner).LocalPlayerController() != true;
    return;
}

function bool GetBoolOption(string Options, string ParseString, bool bCurrentValue)
{
    local string InOpt;

    InOpt = ParseOption(Options, ParseString);
    // End:0x2E
    if(InOpt != "")
    {
        return InOpt ~= "1";
    }
    return bCurrentValue;
    return;
}

event OnHostagesSpawned()
{
    return;
}

function ChangeName(Controller other, coerce string S, bool bNameChange)
{
    local R6PlayerReplicationInfo pR6PRI;
    local int pos;
    local string Prefix;

    // End:0x0E
    if(S == "")
    {
        return;
    }
    ChangeName(other, S, bNameChange);
    pos = InStr(S, "]");
    // End:0x4F
    if(pos == -1)
    {
        Prefix = "";        
    }
    else
    {
        Prefix = Left(S, pos + 1);
    }
    pR6PRI = R6PlayerReplicationInfo(other.PlayerReplicationInfo);
    pR6PRI.SetPrefixTag(Prefix);
    return;
}

defaultproperties
{
    m_bAllowIncapacitation=true
    DefaultPawnClass=Class'R6RainbowPawn'
    HUDType=Class'R6HUD'
    PlayerControllerClass=Class'R6PlayerController'
    DedicatedServerLocalPlayerControllerClass=Class'R6DedicatedServerLocalPlayerController'
    PlayerReplicationInfoClass=Class'R6PlayerReplicationInfo'
    GameReplicationInfoClass=Class'R6GameReplicationInfo'
}