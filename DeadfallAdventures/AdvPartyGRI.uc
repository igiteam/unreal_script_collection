class AdvPartyGRI extends AdvGRI
    config(Game)
    hidecategories(Navigation,Movement,Collision);

const GOINGTOGAME_DIFFICULTYSELECTION = 254;
const NO_DIFFICULTYSELECTION = 255;
const NUM_GAMESETTINGS_VALUES = 18;

enum EMatchmakingState
{
    MMS_NotMatchmaking,             // 0
    MMS_CancelingMatchmaking,       // 1
    MMS_ReadingSkills,              // 2
    MMS_FindingBestDedicated,       // 3
    MMS_FindingAnyDedicated,        // 4
    MMS_FindingEmptyDedicated,      // 5
    MMS_FindingBestParty,           // 6
    MMS_FindingAnyParty,            // 7
    MMS_ConnectingToMatch,          // 8
    MMS_ConnectingToPregameLobby,   // 9
    MMS_HostCancelingMatchmaking,   // 10
    MMS_MAX                         // 11
};

enum EMatchmakingSearchState
{
    MSS_SearchPending,              // 0
    MSS_JoinAttemptStarted,         // 1
    MSS_JoinAttemptSucceeded,       // 2
    MSS_JoinAttemptFailed,          // 3
    MSS_Hosting,                    // 4
    MSS_MAX                         // 5
};

enum EPKPGLState
{
    eGPGLSTATE_None,                // 0
    eGPGLSTATE_Initialize,          // 1
    eGPGLSTATE_PreGameSelection,    // 2
    eGPGLSTATE_GameSelection,       // 3
    eGPGLSTATE_HostNameRep,         // 4
    eGPGLSTATE_MAX                  // 5
};

var repnotify AdvPartyGRI.EMatchmakingState MatchmakingState;
var repnotify AdvPartyGRI.EMatchmakingSearchState MatchmakingSearchState;
var byte CurrMenuSelection;
var repnotify AdvTypes.EPKPartyType CurrPartyType;
var repnotify OnlineSubsystem.ENATType HostNATType;
var repnotify AdvPartyGRI.EPKPGLState PreGameLobbyState;
var int BestSessionIndex;
var int QoSIndex;
var int QoSTotal;
var repnotify string HostName;
var repnotify int PartySlotsFilled;
var repnotify int TeamSize;
var repnotify int TeamCount;
var repnotify int MaxPartySize;
var int ConnectingPlayerCount;
var bool bBandwidthTestActive;
var bool bSurvival;
var repnotify bool bAutoMatchmaking;
var repnotify int VersusGameType;
var repnotify int DifficultySelectionChapter;
var transient int PreviousDifficultySelectionChapter;
var repnotify int GameSettingsValues[18];
var int MainMenuCountdownTimer;
var int MatchmakeCountdown;
//var delegate<OnMatchMakingStateChanged> __OnMatchMakingStateChanged__Delegate;
//var delegate<OnMatchMakingSearchStateChanged> __OnMatchMakingSearchStateChanged__Delegate;
//var delegate<OnCustomGameSettingsChanged> __OnCustomGameSettingsChanged__Delegate;
//var delegate<OnVersusGameTypeChanged> __OnVersusGameTypeChanged__Delegate;
//var delegate<OnPartyTypeChanged> __OnPartyTypeChanged__Delegate;
//var delegate<OnMaxPartySizeChanged> __OnMaxPartySizeChanged__Delegate;
//var delegate<OnMatchmakeCountdownChange> __OnMatchmakeCountdownChange__Delegate;
//var delegate<OnLobbyStateChanged> __OnLobbyStateChanged__Delegate;

replication
{
    // Pos:0x000
    if(bNetDirty
        ConnectingPlayerCount, CurrMenuSelection, 
        CurrPartyType, DifficultySelectionChapter, 
        GameSettingsValues, HostNATType, 
        MainMenuCountdownTimer, MatchmakeCountdown, 
        MatchmakingSearchState, MatchmakingState, 
        MaxPartySize, PartySlotsFilled, 
        TeamCount, TeamSize, 
        VersusGameType, bAutoMatchmaking, 
        bBandwidthTestActive, bSurvival;

    // Pos:0x00A
    if((int(Role) == int(ROLE_Authority)) && bNetDirty
        HostName, PreGameLobbyState;
}

delegate OnMatchMakingStateChanged()
{
    //return;    
}

delegate OnMatchMakingSearchStateChanged()
{
    //return;    
}

delegate OnCustomGameSettingsChanged()
{
    //return;    
}

delegate OnVersusGameTypeChanged(int GameContextId)
{
    //return;    
}

delegate OnPartyTypeChanged(AdvTypes.EPKPartyType PartyType)
{
    //return;    
}

delegate OnMaxPartySizeChanged(int NewMaxPartySize)
{
    //return;    
}

delegate OnMatchmakeCountdownChange()
{
    //return;    
}

delegate OnLobbyStateChanged(AdvPartyGRI.EPKPGLState NewLobbyState)
{
    //return;    
}

simulated event PostBeginPlay()
{
    local AdvGameMenu MenuGame;

    super.PostBeginPlay();
    // End:0x9C
    if(int(Role) == int(ROLE_Authority))
    {
        MenuGame = AdvGameMenu(WorldInfo.Game);
        // End:0x90
        if(MenuGame != none)
        {
            HostNATType = MenuGame.NatType;
            OnHostNATTypeChange();
        }
        SetLobbyState(1);
    }
    //return;    
}

simulated function AddPRI(PlayerReplicationInfo PRI)
{
    super.AddPRI(PRI);
    FindHostName();
    //return;    
}

simulated function FindHostName()
{
    local int I;
    local AdvPlayerController PC;

    // End:0xE8
    if(int(Role) == int(ROLE_Authority))
    {
        I = 0;
        J0x1F:

        // End:0xE8 [Loop If]
        if(I < PRIArray.Length)
        {
            PC = AdvPlayerController(PRIArray[I].Owner);
            // End:0xDA
            if((PC != none) && PC.IsPartyLeader())
            {
                HostName = PRIArray[I].PlayerName;
                // [Explicit Break]
                goto J0xE8;
            }
            I++;
            // [Loop Continue]
            goto J0x1F;
        }
    }
    J0xE8:

    //return;    
}

simulated function SetPlaylist(int NewPlaylistId)
{
    local OnlinePlaylistManager PlaylistMan;
    local OnlineSubsystem OnlineSub;

    super.SetPlaylist(NewPlaylistId);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x1DA
    if(OnlineSub != none)
    {
        // End:0xFE
        if((AdvGameMenu(WorldInfo.Game) != none) && int(AdvGameMenu(WorldInfo.Game).MultiGameModeSelected) == int(3))
        {
            Class'AdvGameSurvivalBase'.static.SetDefaultTeamInfo(TeamSize, TeamCount, MaxPartySize);            
        }
        else
        {
            Class'AdvGameMP_Base'.static.SetDefaultTeamInfo(TeamSize, TeamCount, MaxPartySize);
        }
        PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
        // End:0x1DA
        if((PlaylistMan != none) && PlaylistId != -1)
        {
            PlaylistMan.GetTeamInfoFromPlaylist(PlaylistId, TeamSize, TeamCount, MaxPartySize);
        }
    }
    //return;    
}

function UpdateMaxPartySize(int InMaxPartySize)
{
    MaxPartySize = InMaxPartySize;
    OnMaxPartySizeChanged(MaxPartySize);
    bForceNetUpdate = true;
    bNetDirty = true;
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x37
        case 'HostName':
            OnLobbyStateChanged(4);
            // End:0x17E
            break;
        // End:0x62
        case 'PreGameLobbyState':
            OnLobbyStateChanged(PreGameLobbyState);
            // End:0x17E
            break;
        // End:0x84
        case 'MatchmakingState':
            OnMatchMakingStateChanged();
            // End:0x17E
            break;
        // End:0xA9
        case 'MatchmakingSearchState':
            OnMatchMakingSearchStateChanged();
            // End:0x17E
            break;
            // End:0x17E
            break;
        // End:0xD4
        case 'VersusGameType':
            OnVersusGameTypeChanged(VersusGameType);
            // End:0x17E
            break;
        // End:0xFF
        case 'CurrPartyType':
            OnPartyTypeChanged(CurrPartyType);
            // End:0x17E
            break;
        // End:0x12A
        case 'MaxPartySize':
            OnMaxPartySizeChanged(MaxPartySize);
            // End:0x17E
            break;
        // End:0x143
        case 'HostNATType':
            OnHostNATTypeChange();
            // End:0x17E
            break;
        // End:0x165
        case 'bAutoMatchmaking':
            OnMatchmakeCountdownChange();
            // End:0x17E
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            // End:0x17E
            break;
            break;
    }
    //return;    
}

function ResetMainMenuCountdownTimer(int StartTime)
{
    MainMenuCountdownTimer = StartTime;
    // End:0x35
    if(StartTime > 0)
    {
        SetTimer(1.0000000, true, 'DecrementCountdownTimer');
    }
    //return;    
}

function DecrementCountdownTimer()
{
    // End:0x68
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x45
        if(MainMenuCountdownTimer > 0)
        {
            MainMenuCountdownTimer = MainMenuCountdownTimer - 1;
            bForceNetUpdate = true;
        }
        // End:0x68
        if(MainMenuCountdownTimer <= 0)
        {
            ClearTimer('DecrementCountdownTimer');
        }
    }
    //return;    
}

simulated function bool IsSystemLinkParty()
{
    return false;
    //return ReturnValue;    
}

simulated function OnHostNATTypeChange()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local AdvLocalPlayer GLP;
    local bool bDisplayCredits;

    GLP = AdvLocalPlayer(Class'Engine.Engine'.static.GetEngine().GamePlayers[0]);
    // End:0x88
    if((GLP != none) && GLP.bDisplayCredits)
    {
        bDisplayCredits = true;
    }
    // End:0x216
    if(!bDisplayCredits)
    {
        // End:0x216
        if(((int(Role) != int(ROLE_Authority)) && int(HostNATType) >= int(3)) && !IsSystemLinkParty())
        {
            UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
            ButtonAliases.AddItem('GenericAccept');            
            UIManager.ShowUIMessage('HostNatMsg', Localize("MessageBoxErrorStrings", "HostNATBad_Title", "ADVGame"), Localize("MessageBoxErrorStrings", "HostNATBad_Message", "ADVGame"), ButtonAliases, None, Class'Engine.Engine'.static.GetEngine().GamePlayers[0],,,, false, true);
        }
    }
    //return;    
}

function SetLobbyState(AdvPartyGRI.EPKPGLState NewState)
{
    PreGameLobbyState = NewState;
    OnLobbyStateChanged(NewState);
    //return;    
}

defaultproperties
{
    CurrPartyType=EPKPartyType.None
    BestSessionIndex=-1
    QoSIndex=-1
    QoSTotal=-1
    PartySlotsFilled=1
    VersusGameType=-1
    DifficultySelectionChapter=255
    PreviousDifficultySelectionChapter=255
    MainMenuCountdownTimer=-1
    MatchmakeCountdown=-1
}