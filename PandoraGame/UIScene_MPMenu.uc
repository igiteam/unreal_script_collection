class UIScene_MPMenu extends UIScene_NetworkScene
    config(Game);

enum LobbyControlMode
{
    LCM_SERVER_CREATE,              // 0
    LCM_SERVER_WAIT,                // 1
    LCM_CLIENT,                     // 2
    LCM_CLIENT_INPROGRESS,          // 3
    LCM_MAX                         // 4
};

enum LobbyMenuID
{
    LMID_TEAM_A,                    // 0
    LMID_TEAM_B,                    // 1
    LMID_OPTIONS,                   // 2
    LMID_READY,                     // 3
    LMID_BACK,                      // 4
    LMID_MAX                        // 5
};

enum MenuOptionID
{
    MOID_UNDEFINED,                 // 0
    MOID_CREATE_SESSION,            // 1
    MOID_START_MATCH,               // 2
    MOID_MAP,                       // 3
    MOID_NUMCREATURES,              // 4
    MOID_DURATION,                  // 5
    MOID_PRIVATE_SLOTS,             // 6
    MOID_CREATE_PRIVATE_SESSION,    // 7
    MOID_REQUIRED_ANIMUS,           // 8
    MOID_RADAR_MODE,                // 9
    MOID_ALPHA_MODE,                // 10
    MOID_SPAWN_TIME,                // 11
    MOID_JOIN_GAME,                 // 12
    MOID_DEFAULT_OPTIONS,           // 13
    MOID_MAX                        // 14
};

enum CreatureDensityMode
{
    CDM_NONE,                       // 0
    CDM_LOW,                        // 1
    CDM_MEDIUM,                     // 2
    CDM_HIGH,                       // 3
    CDM_MAX                         // 4
};

enum AnimusLimitMode
{
    ALM_100PTS,                     // 0
    ALM_250PTS,                     // 1
    ALM_500PTS,                     // 2
    ALM_750PTS,                     // 3
    ALM_1000PTS,                    // 4
    ALM_MAX                         // 5
};

struct MPGameMode
{
    var string ModeName;
    var string ModeOption;
    var string ModeValue;
    var int ContextID;

    structdefaultproperties
    {
        ModeName=""
        ModeOption=""
        ModeValue=""
        ContextID=0
    }
};

struct MPGameOption
{
    var string OptionName;
    var int DefaultMode;
    var int CurMode;
    var array<MPGameMode> Modes;
    var UIScene_MPMenu.MenuOptionID Id;
    var bool bEnabled;
    var bool bReplicated;
    var bool bPublished;
    var bool bListedFirst;
    var int ContextID;
    var bool bExecutable;

    structdefaultproperties
    {
        OptionName=""
        DefaultMode=0
        CurMode=0
        Modes=none
        Id=MOID_UNDEFINED
        bEnabled=true
        bReplicated=false
        bPublished=false
        bListedFirst=false
        ContextID=0
        bExecutable=false
    }
};

struct PlayerInfoEntry
{
    var UILabelButton UIButton;
    var UIImage UIButtonBG;
    var UIImage UIPlayerImage;
    var UICheckbox UIReadyCheckbox;
    var Controller PlayerController;
    var int PlayerImageIdx;
    var int WeaponSetIdx;
    var int PRIIdx;
    var int PlayerID;
    var UIImage UIPlayerTalkingImage;
    var bool bTalking;
    var float TalkingTimer;

    structdefaultproperties
    {
        UIButton=none
        UIButtonBG=none
        UIPlayerImage=none
        UIReadyCheckbox=none
        PlayerController=none
        PlayerImageIdx=0
        WeaponSetIdx=0
        PRIIdx=-1
        PlayerID=-1
        UIPlayerTalkingImage=none
        bTalking=false
        TalkingTimer=0.0000000
    }
};

var() array<Texture> MapScreenShots;
var UIObject CurrentObjectToHighlight;
var PlayerInfoEntry TeamAPlayers[4];
var PlayerInfoEntry TeamBPlayers[4];
var UIImage imageGameMap;
var array<UILabelButton> btnOption;
var UILabel lblGameStatus;
var UILabel lblTitle;
var SPUIButtonBar bbHelperText;
var UIImage imageHighlight;
var UILabel lblWeaponA;
var UILabel lblWeaponB;
var UILabel lblWeaponC;
var UILabel lblWeaponCCount;
var UIImage imgWeaponA;
var UIImage imgWeaponB;
var UIImage imgWeaponC;
var UILabelButton btnReady;
var UILabelButton btnBack;
var UILabelButton btnDownArrow;
var bool bMenuItemActive;
var bool bOptionMenuEnabled;
var bool bTeamMenuEnabled;
var bool bBackoutEnabled;
var bool bTitleInitialized;
var bool bMapListUpdated;
var bool bPlayerSlotsVisible;
var bool bPCInitialized;
var bool bGRIInitialized;
var bool bShowPlayerMinimum;
var bool bCreatingGame;
var UIScene_MPMenu.LobbyMenuID ActiveMenu;
var UIScene_MPMenu.LobbyControlMode ControlMode;
var int OptionMenuStartIdx;
var int OptionMenuSelIdx;
var array<MPGameOption> GameOptions;
var MPGameOption StartGameOption;
var MPGameOption JoinGameOption;
var int LastUsedMapImageIdx;
var int CurTeamAButton;
var int CurTeamBButton;
var LinearColor SelectColor;
var LinearColor NonSelectColor;
var LinearColor DisabledColor;
var(Images) array<Texture2D> TeamACharacterImages;
var(Images) array<Texture2D> TeamBCharacterImages;
var float TeamMenuRefreshDeltaAccum;
var float CountdownRefreshDeltaAccum;
var UIScene_WeaponConfig WeaponConfigScene;
var int NumLoggedInPlayers;
var array<int> CreatureDensityToAnimusLimitMap;
var float LastCheckForHeadsetTime;
var config int NumSecsToStartMatch;
var config int MinPlayersForRankedMatch;
var config int MinPlayersForUnRankedMatch;
var UIDataStore_GameResource GameResourceDataStore;
var int NumberOfMaps;
var const localized string SwitchingMapString;
var array<Texture2D> MapPreviewTextures;
var int NumListBoxEntries;
var int LastMapID;
var int RequestedTeamID;
var int RequestedAppearanceID;
var IntPoint LastMousePos;
var array<int> LastPublishedOptionModeIdx;
var int LastNumPrivateConnections;
var int LastShownPlayersRequired;
var PandoraPlayerController KickedPC;

function LoadChildScenes()
{
    // End:0x42
    if(WeaponConfigScene == none)
    {
        WeaponConfigScene = UIScene_WeaponConfig(DynamicLoadObject("PandoraShellLobby.WeaponConfig", Class'UIScene_WeaponConfig'));
    }
    // End:0x4D
    if(WeaponConfigScene == none)
    {
    }
    super.LoadChildScenes();
    //return;    
}

function SwitchMenu(UIScene_MPMenu.LobbyMenuID MenuID)
{
    ActiveMenu = MenuID;
    DeactivateOptionStates();
    switch(MenuID)
    {
        // End:0x25
        case 0:
            // End:0x63
            break;
        // End:0x2D
        case 1:
            // End:0x63
            break;
        // End:0x3C
        case 2:
            OptionMenuSelIdx = 0;
            // End:0x63
            break;
        // End:0x4E
        case 3:
            FocusOnReadyButton();
            // End:0x63
            break;
        // End:0x60
        case 4:
            FocusOnBackButton();
            // End:0x63
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xC7
    if(((int(ControlMode) == int(2)) || IsSystemLinkMatch()) || !((int(MenuID) == int(0)) || int(MenuID) == int(1)) && int(ControlMode) == int(1))
    {
        SetHelperLabel();        
    }
    else
    {
        bbHelperText.SetDataStoreBinding(PlatformStrings $ "HelperText.CreateSessionBarOnlineKick>");
    }
    //return;    
}

function bool HandlePlayerTeamKeyInput(const out InputEventParameters EventParms)
{
    return false;
    //return ReturnValue;    
}

function RemoveGameOptionByID(int Id)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x51 [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x47
        if(int(GameOptions[I].Id) == Id)
        {
            GameOptions.Remove(I, 1);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function string BuildURL()
{
    local int I;
    local string Str, PCLANProfileName;

    Str = GetOptionValue(3);
    I = 0;
    J0x19:

    // End:0x137 [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x12D
        if(GameOptions[I].Modes.Length > 0)
        {
            // End:0x12D
            if((GameOptions[I].CurMode >= 0) && Len(GameOptions[I].Modes[GameOptions[I].CurMode].ModeOption) > 0)
            {
                Str = (((Str $ "?") $ GameOptions[I].Modes[GameOptions[I].CurMode].ModeOption) $ "=") $ GameOptions[I].Modes[GameOptions[I].CurMode].ModeValue;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x19;
    }
    // End:0x199
    if(IsPCBuild() && myGameInfo.bLanMatch)
    {
        GetPC().ProfileSettings.GetSavedLocalPlayerName(PCLANProfileName);
        Str = (Str $ "?Name=") $ PCLANProfileName;
    }
    return Str;
    //return ReturnValue;    
}

function ParseURL(URL inurl)
{
    local int I, CurOption, CurMode, EqPos;
    local string OptionName, OptionValue;

    I = 0;
    J0x07:

    // End:0x17A [Loop If]
    if(I < inurl.Op.Length)
    {
        EqPos = InStr(inurl.Op[I], "=");
        // End:0x170
        if(EqPos != -1)
        {
            OptionName = Left(inurl.Op[I], EqPos);
            OptionValue = Mid(inurl.Op[I], EqPos + 1);
            CurOption = 0;
            J0xA4:

            // End:0x170 [Loop If]
            if(CurOption < GameOptions.Length)
            {
                CurMode = 0;
                J0xBB:

                // End:0x166 [Loop If]
                if(CurMode < GameOptions[CurOption].Modes.Length)
                {
                    // End:0x15C
                    if((GameOptions[CurOption].Modes[CurMode].ModeOption == OptionName) && GameOptions[CurOption].Modes[CurMode].ModeValue == OptionValue)
                    {
                        GameOptions[CurOption].CurMode = CurMode;
                    }
                    CurMode++;
                    // [Loop Continue]
                    goto J0xBB;
                }
                CurOption++;
                // [Loop Continue]
                goto J0xA4;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function SessionCreateDone(bool bWasSuccessful)
{
    local PandoraGameInfo PGI;
    local PandoraGRI PGRI;
    local string hostURL;
    local PandoraPlayerController PC;

    bCreatingGame = false;
    PGI = PandoraGameInfo(GetWorldInfo().Game);
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    PC = GetPC();
    // End:0x63
    if(PGI == none)
    {
        return;
    }
    // End:0x70
    if(PGRI == none)
    {
        return;
    }
    // End:0x137
    if(bWasSuccessful)
    {
        hostURL = (BuildURL()) $ "?listen?Game=PandoraGameContent.PandoraMonsterMachine?Team=255";
        InitControlMode(1);
        PGRI.GameStatus = 1;
        PGI.OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(SessionCreateDone);
        PC.LocalTravel(hostURL);        
    }
    else
    {
        ShowMsgBox("<Strings:PandoraGame.UIScene_OnlineDMSetup.Failed>", "<Strings:PandoraGame.ErrorMessages.CommunicationRequired_Title>", 0);
    }
    //return;    
}

function bool CBCheckCreating()
{
    // End:0x0B
    if(bCreatingGame)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CreatingResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x24
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        return;
    }    
    GetPC().ConsoleCommand("cancel");
    GetPC().DestroySession();
    myGameInfo.GameInterface.CancelFindOnlineGames();
    myGameInfo.GameInterface.ClearFindOnlineGamesCompleteDelegate(SessionCreateDone);
    bCreatingGame = false;
    // End:0x141
    if(int(eReturnValue) == int(2))
    {
        ShowMsgBox("<Strings:PandoraGame.UIScene_OnlineDMSetup.Canceled>", "<Strings:PandoraGame.UIScene_OnlineDMSetup.CreateMatch>");
    }
    // End:0x1D5
    if(int(eReturnValue) == int(3))
    {
        ShowMsgBox("<Strings:PandoraGame.UIScene_OnlineDMSetup.Failed>", "<Strings:PandoraGame.ErrorMessages.CommunicationRequired_Title>");
    }
    //return;    
}

function LobbyCreateSession(bool bPrivateSession)
{
    local PandoraGameInfo PGI;
    local int nPrivateSlots;

    ShowMsgBox("<Strings:PandoraGame.UIScene_OnlineDMSetup.Creating>", "<Strings:PandoraGame.UIScene_OnlineDMSetup.CreateMatch>", 8, CreatingResults, CBCheckCreating, 60);
    PGI = PandoraGameInfo(GetWorldInfo().Game);
    // End:0xBE
    if(PromptProfileSignIn())
    {
        return;
    }
    // End:0xCC
    if(PGI == none)
    {        
    }
    else
    {
        GetPC().OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(PGI.OnServerCreateComplete);
        GetPC().OnlineSub.GameInterface.AddCreateOnlineGameCompleteDelegate(SessionCreateDone);
        GetPC().RegisterConnectionCallbacks();
        // End:0x18D
        if(bPrivateSession)
        {
            nPrivateSlots = 8 - 1;
            SetOptionValue(6, "7");
            StoreRepOptionsInGRI();            
        }
        else
        {
            nPrivateSlots = int(GetOptionValue(6));
        }
        UpdateAdvertisedData();
        EnableMPLoadingScreen();
        PGI.CreateGameSession(nPrivateSlots, int(GetOptionValue(4)));
        bCreatingGame = true;
    }
    //return;    
}

function bool GetGameOptionByID(int Id, out MPGameOption Option)
{
    local int I;
    local MPGameOption UnassignedOption;

    I = 0;
    J0x07:

    // End:0x56 [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x4C
        if(int(GameOptions[I].Id) == Id)
        {
            Option = GameOptions[I];
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    Option = UnassignedOption;
    return false;
    //return ReturnValue;    
}

function int GetGameOptionIdxByID(int Id)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x49 [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x3F
        if(int(GameOptions[I].Id) == Id)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function string GetOptionValue(UIScene_MPMenu.MenuOptionID OptionID)
{
    local MPGameOption Option;

    // End:0x1E
    if(!GetGameOptionByID(int(OptionID), Option))
    {
        return "";
    }
    return Option.Modes[Option.CurMode].ModeValue;
    //return ReturnValue;    
}

function SetOptionDefaultValue(UIScene_MPMenu.MenuOptionID OptionID, string Value)
{
    local int OptionIdx, I;

    OptionIdx = GetGameOptionIdxByID(int(OptionID));
    I = 0;
    J0x1E:

    // End:0xD4 [Loop If]
    if(I < GameOptions[OptionIdx].Modes.Length)
    {
        // End:0xCA
        if(GameOptions[OptionIdx].Modes[I].ModeValue == Value)
        {
            // End:0xAC
            if(GameOptions[OptionIdx].DefaultMode == -1)
            {
                GameOptions[OptionIdx].CurMode = I;
            }
            GameOptions[OptionIdx].DefaultMode = I;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x1E;
    }
    return;
    //return;    
}

function bool SetOptionValue(UIScene_MPMenu.MenuOptionID OptionID, string Value)
{
    local int OptionIdx, I;

    OptionIdx = GetGameOptionIdxByID(int(OptionID));
    I = 0;
    J0x1E:

    // End:0x98 [Loop If]
    if(I < GameOptions[OptionIdx].Modes.Length)
    {
        // End:0x8E
        if(GameOptions[OptionIdx].Modes[I].ModeValue == Value)
        {
            GameOptions[OptionIdx].CurMode = I;
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x1E;
    }
    return false;
    //return ReturnValue;    
}

function string GetOptionModeName(UIScene_MPMenu.MenuOptionID OptionID)
{
    local MPGameOption Option;

    // End:0x1E
    if(!GetGameOptionByID(int(OptionID), Option))
    {
        return "";
    }
    return Option.Modes[Option.CurMode].ModeName;
    //return ReturnValue;    
}

function AssignAppearances()
{
    local int I;
    local PandoraGRI PGRI;
    local SPPlayerReplicationInfo SPPRI;
    local PandoraPlayerController PC;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    I = 0;
    J0x33:

    // End:0x203 [Loop If]
    if(I < 4)
    {
        // End:0x11C
        if(TeamAPlayers[I].PlayerController != none)
        {
            TeamAPlayers[I].PlayerController.Pawn.Destroy();
            PandoraPlayerController(TeamAPlayers[I].PlayerController).ServerDoPlayerRestart();
            SPPRI = SPPlayerReplicationInfo(TeamAPlayers[I].PlayerController.PlayerReplicationInfo);
            PC = PandoraPlayerController(TeamAPlayers[I].PlayerController);
            PC.GiveLoadoutInventory(SPPRI.WeaponConfigIdx);
        }
        // End:0x1F9
        if(TeamBPlayers[I].PlayerController != none)
        {
            TeamBPlayers[I].PlayerController.Pawn.Destroy();
            PandoraPlayerController(TeamBPlayers[I].PlayerController).ServerDoPlayerRestart();
            SPPRI = SPPlayerReplicationInfo(TeamBPlayers[I].PlayerController.PlayerReplicationInfo);
            PC = PandoraPlayerController(TeamBPlayers[I].PlayerController);
            PC.GiveLoadoutInventory(SPPRI.WeaponConfigIdx);
        }
        I++;
        // [Loop Continue]
        goto J0x33;
    }
    //return;    
}

function ExitToStartMenuLevel()
{
    local PlayerController PC;

    PC = GetPC();
    // End:0x1D
    if(PC == none)
    {
        return;
    }
    PC.ClientTravel("PandoraStart", 2);
    // End:0x74
    if(int(GetWorldInfo().NetMode) == int(NM_Standalone))
    {
        SceneClient.CloseScene(self);
    }
    //return;    
}

function OnlineGameDestroyComplete(bool bWasSuccessful)
{
    local PandoraGameInfo PGI;

    PGI = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x2C
    if(PGI == none)
    {
        return;
    }
    PGI.OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnlineGameDestroyComplete);
    ExitToStartMenuLevel();
    //return;    
}

function AbortSession()
{
    SetReadyFlag(false);
    switch(ControlMode)
    {
        // End:0x18
        case 2:
        // End:0xB7
        case 3:
            ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraLobbyMP.PromptQuitGame>", "<Strings:PandoraGame.UIScene_PandoraLobbyMP.PromptQuitGameTitle>", 1, OnAbortSessionCB);
            // End:0x208
            break;
        // End:0x15A
        case 1:
            ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraLobbyMP.PromptQuitSrvrGame>", "<Strings:PandoraGame.UIScene_PandoraLobbyMP.PromptQuitGameTitle>", 1, OnAbortSessionCB);
            // End:0x208
            break;
        // End:0x15F
        case 0:
        // End:0xFFFF
        default:
            ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraLobbyMP.PromptQuitCreateGame>", "<Strings:PandoraGame.UIScene_PandoraLobbyMP.PromptQuitCreateGameTitle>", 1, OnAbortSessionCB);
            // End:0x208
            break;
            break;
    }
    //return;    
}

function bool OnBackButtonClicked(UIScreenObject EventObject, int PlayerIndex)
{
    PlayUISound('SceneClosed');
    AbortSession();
    return true;
    //return ReturnValue;    
}

function bool OnArrowDownClick(UIScreenObject EventObject, int PlayerIndex)
{
    PlayUISound('Clicked');
    // End:0x2E
    if(OptionMenuStartIdx < (GameOptions.Length - NumListBoxEntries))
    {
        OptionMenuStartIdx++;
    }
    OptionMenuSelIdx = (OptionMenuStartIdx + NumListBoxEntries) - 1;
    PopulateOptionMenu();
    return true;
    //return ReturnValue;    
}

function OnAbortSessionCB(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    local PandoraGameInfo PGI;
    local PandoraGRI PGRI;
    local PandoraPlayerController PPC;
    local SPPlayerReplicationInfo SPPRI;

    // End:0x12
    if(int(eReturnValue) != int(1))
    {
        return;
    }
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    PPC = GetPC();
    // End:0xB3
    if(int(ControlMode) == int(3))
    {
        // End:0xB3
        if(PPC != none)
        {
            SPPRI = SPPlayerReplicationInfo(PPC.PlayerReplicationInfo);
            // End:0xB3
            if(SPPRI != none)
            {
                PGRI.RemovePlayerFromInactiveStatList(SPPRI.PlayerName, SPPRI.UniqueId);
            }
        }
    }
    // End:0x11B
    if(((int(ControlMode) != int(1)) && int(ControlMode) != int(2)) && int(ControlMode) != int(3))
    {
        // End:0x118
        if(int(GetWorldInfo().NetMode) == int(NM_Standalone))
        {
            SceneClient.CloseScene(self);
        }        
    }
    else
    {
        PGI = PandoraGameInfo(GetWorldInfo().Game);
        // End:0x1A1
        if(int(ControlMode) == int(1))
        {
            // End:0x16A
            if(PGRI != none)
            {
                PGRI.GameStatus = 0;                
            }
            // End:0x1A1
            if(PGI != none)
            {
                PGI.OnlineSub.GameInterface.DestroyOnlineGame();                
            }
        }
        // End:0x1D2
        if(int(GetWorldInfo().NetMode) == int(NM_Standalone))
        {
            SceneClient.CloseScene(self);
        }
        // End:0x21A
        if(PPC != none)
        {
            PPC.DestroySession();
            PPC.ClientTravel("pandorastart", 0);            
        }
    }
    //return;    
}

function InitWeaponConfig()
{
    local PandoraGRI PGRI;
    local SPPlayerReplicationInfo SPPRI;
    local PlayerController PC;

    PC = GetPC();
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x3C
    if(PGRI == none)
    {
        return;
    }
    SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[0]);
    WeaponConfigScene.SPPRI = SPPRI;
    WeaponConfigScene.theController = PC;
    SceneClient.OpenScene(WeaponConfigScene);
    //return;    
}

function HandleLinkedOptions(int SelIdx)
{
    local int OptionIdx;

    // End:0x91
    if(SelIdx == (FindOptionIndex(4)))
    {
        OptionIdx = FindOptionIndex(8);
        // End:0x91
        if(CreatureDensityToAnimusLimitMap[GameOptions[SelIdx].CurMode + 1] != -1)
        {
            GameOptions[OptionIdx].CurMode = CreatureDensityToAnimusLimitMap[GameOptions[SelIdx].CurMode + 1];
            PopulateOptionMenu();
        }
    }
    //return;    
}

function SetDefaultsForMapChanges(int SelIdx)
{
    local UIProviderScriptFieldValue RespawnTimeValue;

    // End:0x7A
    if(int(GameOptions[SelIdx].Id) == int(3))
    {
        GameResourceDataStore.GetProviderFieldValue('MultiplayerMaps', 'SuggestedRespawnTime', GameOptions[SelIdx].CurMode, RespawnTimeValue);
        SetOptionDefaultValue(11, RespawnTimeValue.StringValue);
    }
    //return;    
}

function bool IsSelectableOptionHighlighted()
{
    // End:0x2C
    if(int(ActiveMenu) == int(2))
    {
        // End:0x2C
        if(GameOptions[OptionMenuSelIdx].bExecutable)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool MouseIsOverActiveMenuButton()
{
    local int I;
    local SPGameUISceneClient SPSceneClient;

    // End:0x1BB
    if(IsPCBuild())
    {
        SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
        I = 0;
        J0x2B:

        // End:0xC1 [Loop If]
        if(I < btnOption.Length)
        {
            // End:0xB7
            if(btnOption[I].GetCurrentState().IsA('UIState_Active'))
            {
                // End:0xB7
                if(PtIntersectsUIObject(btnOption[I], float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
                {
                    return true;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x2B;
        }
        // End:0x13E
        if((btnReady != none) && btnReady.GetCurrentState().IsA('UIState_Active'))
        {
            // End:0x13E
            if(PtIntersectsUIObject(btnReady, float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
            {
                return true;
            }
        }
        // End:0x1BB
        if((btnBack != none) && btnBack.GetCurrentState().IsA('UIState_Active'))
        {
            // End:0x1BB
            if(PtIntersectsUIObject(btnBack, float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool MouseIsOverMenuButton()
{
    local SPGameUISceneClient SPSceneClient;

    // End:0x156
    if(IsPCBuild())
    {
        SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
        // End:0xA8
        if(((OptionMenuSelIdx - OptionMenuStartIdx) >= 0) && (OptionMenuSelIdx - OptionMenuStartIdx) < btnOption.Length)
        {
            // End:0xA8
            if(PtIntersectsUIObject(btnOption[OptionMenuSelIdx - OptionMenuStartIdx], float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
            {
                return true;
            }
        }
        // End:0xFF
        if(btnReady != none)
        {
            // End:0xFF
            if(PtIntersectsUIObject(btnReady, float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
            {
                return true;
            }
        }
        // End:0x156
        if(btnBack != none)
        {
            // End:0x156
            if(PtIntersectsUIObject(btnBack, float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessMouseInput(const out InputEventParameters EventParms)
{
    local int curGameMode, curNumModes;

    // End:0x197
    if(IsPCBuild() && bDisplayCursor)
    {
        // End:0x197
        if(((EventParms.InputKeyName == 'LeftMouseButton') && int(EventParms.EventType) == int(1)) && MouseIsOverMenuButton())
        {
            // End:0x95
            if(int(ActiveMenu) == int(3))
            {
                PlayUISound('Clicked');
                ToggleReadyFlag();
                FocusOnReadyButton();
                return true;
            }
            // End:0xB1
            if(int(ActiveMenu) == int(4))
            {
                HandleBackButton();
                return true;
            }
            curGameMode = GameOptions[OptionMenuSelIdx].CurMode;
            curNumModes = GameOptions[OptionMenuSelIdx].Modes.Length;
            PlayUISound('NavigateRight');
            amBXPulseMenuItemChange();
            // End:0x18B
            if(GameOptions[OptionMenuSelIdx].bEnabled)
            {
                // End:0x14B
                if(curGameMode < (curNumModes - 1))
                {
                    GameOptions[OptionMenuSelIdx].CurMode++;                    
                }
                else
                {
                    GameOptions[OptionMenuSelIdx].CurMode = 0;
                }
                SetDefaultsForMapChanges(OptionMenuSelIdx);
                HandleLinkedOptions(OptionMenuSelIdx);
                PopulateOptionMenu();
            }
            StoreRepOptionsInGRI();
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function SetSelectionToHighlight()
{
    local int I, OrigSel;

    OrigSel = OptionMenuSelIdx;
    I = 0;
    J0x12:

    // End:0x74 [Loop If]
    if(I < btnOption.Length)
    {
        // End:0x6A
        if(btnOption[I].GetCurrentState().IsA('UIState_Active'))
        {
            SwitchMenu(2);
            OptionMenuSelIdx = OptionMenuStartIdx + I;
        }
        I++;
        // [Loop Continue]
        goto J0x12;
    }
    // End:0xDB
    if(btnReady != none)
    {
        // End:0xBC
        if(btnReady.GetCurrentState().IsA('UIState_Active'))
        {
            SwitchMenu(3);
            FocusOnReadyButton();            
        }
        else
        {
            btnReady.StringRenderComponent.SetColor(NonSelectColor);
        }
    }
    // End:0x142
    if(btnBack != none)
    {
        // End:0x123
        if(btnBack.GetCurrentState().IsA('UIState_Active'))
        {
            SwitchMenu(4);
            FocusOnBackButton();            
        }
        else
        {
            btnBack.StringRenderComponent.SetColor(NonSelectColor);
        }
    }
    // End:0x15B
    if(OptionMenuSelIdx != OrigSel)
    {
        PopulateOptionMenu();
    }
    //return;    
}

function bool IsButtonActive(UILabelButton btn)
{
    // End:0x26
    if(btn.GetCurrentState().IsA('UIState_Active'))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool HandleBackKeyInput(const out InputEventParameters EventParms)
{
    // End:0x1E
    if(IsInputAccept(EventParms))
    {
        HandleBackButton();
        return true;
    }
    // End:0x77
    if(IsInputNavDown(EventParms))
    {
        PlayUISound('NavigateDown');
        amBXPulseMenuItemChange();
        btnBack.StringRenderComponent.SetColor(NonSelectColor);
        SwitchMenu(0);
        return true;
    }
    // End:0x8B
    if(ProcessMouseInput(EventParms))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool HandleReadyKeyInput(const out InputEventParameters EventParms)
{
    // End:0x2F
    if(IsInputAccept(EventParms))
    {
        PlayUISound('Clicked');
        ToggleReadyFlag();
        return true;
    }
    // End:0xC8
    if((IsInputNavUp(EventParms)) || IsInputNavLeft(EventParms))
    {
        PlayUISound('NavigateUp');
        amBXPulseMenuItemChange();
        btnReady.StringRenderComponent.SetColor(NonSelectColor);
        SwitchMenu(2);
        OptionMenuSelIdx = GameOptions.Length - 1;
        OptionMenuStartIdx = GameOptions.Length - NumListBoxEntries;
        PopulateOptionMenu();
        return true;
    }
    // End:0xDC
    if(ProcessMouseInput(EventParms))
    {
        return true;
    }
    PopulateOptionMenu();
    return true;
    //return ReturnValue;    
}

function bool HandleGameOptionKeyInput(const out InputEventParameters EventParms)
{
    local int curGameMode, curNumModes;

    // End:0x1F
    if(IsPCBuild() && HandleDownArrowInput(EventParms))
    {
        return true;
    }
    // End:0x17A
    if(IsInputAccept(EventParms))
    {
        // End:0x14F
        if(GameOptions[OptionMenuSelIdx].bEnabled)
        {
            switch(GameOptions[OptionMenuSelIdx].Id)
            {
                // End:0x87
                case 1:
                    PlayUISound('Clicked');
                    LobbyCreateSession(false);
                    // End:0x14C
                    break;
                // End:0xAA
                case 7:
                    PlayUISound('Clicked');
                    LobbyCreateSession(true);
                    // End:0x14C
                    break;
                // End:0xEC
                case 12:
                    PlayUISound('Clicked');
                    LobbyStartMatch(GameOptions[OptionMenuSelIdx].Id);
                    JoinGameInProgress();
                    // End:0x14C
                    break;
                // End:0x124
                case 2:
                    PlayUISound('Clicked');
                    LobbyStartMatch(GameOptions[OptionMenuSelIdx].Id);
                    // End:0x14C
                    break;
                // End:0x146
                case 13:
                    PlayUISound('Clicked');
                    SetOptionsToDefault();
                    // End:0x14C
                    break;
                // End:0xFFFF
                default:
                    // End:0x14C
                    break;
                    break;
            }            
        }
        else
        {
            // End:0x17A
            if(int(GameOptions[OptionMenuSelIdx].Id) == int(2))
            {
                CheckMinimumPlayers();
            }
        }
    }
    // End:0x2AC
    if(IsInputNavUp(EventParms))
    {
        // End:0x1E8
        if(OptionMenuSelIdx > 0)
        {
            PlayUISound('NavigateUp');
            amBXPulseMenuItemChange();
            // End:0x1D4
            if((OptionMenuStartIdx > 0) && OptionMenuSelIdx == OptionMenuStartIdx)
            {
                OptionMenuStartIdx--;
            }
            OptionMenuSelIdx--;
            SetHelperLabel();            
        }
        else
        {
            // End:0x2A0
            if(bTeamMenuEnabled)
            {
                PlayUISound('NavigateUp');
                amBXPulseMenuItemChange();
                SwitchMenu(0);
                CurTeamAButton = 4 - 1;
                OptionMenuSelIdx = -1;
                SetFocus(TeamAPlayers[CurTeamAButton].UIButton.GetOwner());
                UpdateTeamMenus();
                DeactivateOptionStates();
                OptionMenuSelIdx = -1;
                TeamAPlayers[CurTeamAButton].UIButton.ActivateStateByClass(Class'Engine.UIState_Active', 0);
            }
        }
        PopulateOptionMenu();
        return true;
    }
    // End:0x376
    if(IsInputNavDown(EventParms))
    {
        // End:0x32F
        if(OptionMenuSelIdx < (GameOptions.Length - 1))
        {
            // End:0x301
            if(GameOptions.Length > NumListBoxEntries)
            {
                // End:0x301
                if(OptionMenuSelIdx == ((OptionMenuStartIdx + NumListBoxEntries) - 1))
                {
                    OptionMenuStartIdx++;
                }
            }
            OptionMenuSelIdx++;
            SetHelperLabel();
            PlayUISound('NavigateDown');
            amBXPulseMenuItemChange();            
        }
        else
        {
            // End:0x36A
            if(btnReady != none)
            {
                PlayUISound('NavigateDown');
                amBXPulseMenuItemChange();
                SwitchMenu(3);
                FocusOnReadyButton();
            }
        }
        PopulateOptionMenu();
        return true;
    }
    curGameMode = GameOptions[OptionMenuSelIdx].CurMode;
    curNumModes = GameOptions[OptionMenuSelIdx].Modes.Length;
    // End:0x46E
    if(IsInputNavRight(EventParms))
    {
        PlayUISound('NavigateRight');
        amBXPulseMenuItemChange();
        // End:0x462
        if(GameOptions[OptionMenuSelIdx].bEnabled)
        {
            // End:0x422
            if(curGameMode < (curNumModes - 1))
            {
                GameOptions[OptionMenuSelIdx].CurMode++;                
            }
            else
            {
                GameOptions[OptionMenuSelIdx].CurMode = 0;
            }
            SetDefaultsForMapChanges(OptionMenuSelIdx);
            HandleLinkedOptions(OptionMenuSelIdx);
            PopulateOptionMenu();
        }
        StoreRepOptionsInGRI();
        return true;
    }
    // End:0x52D
    if(IsInputNavLeft(EventParms))
    {
        PlayUISound('NavigateLeft');
        amBXPulseMenuItemChange();
        // End:0x521
        if(GameOptions[OptionMenuSelIdx].bEnabled)
        {
            // End:0x4E1
            if(curGameMode == 0)
            {
                GameOptions[OptionMenuSelIdx].CurMode = curNumModes - 1;                
            }
            else
            {
                GameOptions[OptionMenuSelIdx].CurMode--;
            }
            SetDefaultsForMapChanges(OptionMenuSelIdx);
            HandleLinkedOptions(OptionMenuSelIdx);
            PopulateOptionMenu();
        }
        StoreRepOptionsInGRI();
        return true;
    }
    // End:0x541
    if(ProcessMouseInput(EventParms))
    {
        return true;
    }
    PopulateOptionMenu();
    return true;
    //return ReturnValue;    
}

function int GetTeamCount(int TeamNum)
{
    local PandoraGRI PGRI;
    local int I, Count;

    Count = 0;
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x33
    if(PGRI == none)
    {
        return 0;
    }
    I = 0;
    J0x3A:

    // End:0xDA [Loop If]
    if(I < PGRI.PRIArray.Length)
    {
        // End:0xD0
        if(PGRI.PRIArray[I] != none)
        {
            // End:0xD0
            if((PGRI.PRIArray[I].Team != none) && PGRI.PRIArray[I].Team.TeamIndex == TeamNum)
            {
                Count++;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x3A;
    }
    return Count;
    //return ReturnValue;    
}

function bool TeamAbandoned()
{
    // End:0x27
    if(((GetTeamCount(1)) == 0) || (GetTeamCount(2)) == 0)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function int GetMinimumPlayerCount()
{
    // End:0x2B
    if(GetWorldInfo().GRI.bIsArbitrated)
    {
        return MinPlayersForRankedMatch;        
    }
    else
    {
        return MinPlayersForUnRankedMatch;
    }
    //return ReturnValue;    
}

function int GetNumPlayersInLobby()
{
    return (GetTeamCount(1)) + (GetTeamCount(2));
    //return ReturnValue;    
}

function bool HasMinimumPlayers()
{
    // End:0x2A
    if(((GetTeamCount(1)) + (GetTeamCount(2))) < (GetMinimumPlayerCount()))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool IsTeamBalanced()
{
    local int TeamASize, TeamBSize;

    TeamASize = GetTeamCount(1);
    TeamBSize = GetTeamCount(2);
    // End:0x34
    if(TeamASize == TeamBSize)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsTeamMinimallyBalanced()
{
    // End:0x27
    if(((GetTeamCount(1)) >= 1) && (GetTeamCount(2)) >= 1)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsTeamAcceptablyBalanced()
{
    local int TeamASize, TeamBSize;

    TeamASize = GetTeamCount(1);
    TeamBSize = GetTeamCount(2);
    // End:0x34
    if(TeamASize == TeamBSize)
    {
        return true;
    }
    // End:0x48
    if(TeamASize == (TeamBSize + 1))
    {
        return true;
    }
    // End:0x5C
    if(TeamBSize == (TeamASize + 1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ValidateTeamChange(bool bOnTeamA)
{
    local int TeamASize, TeamBSize;
    local PandoraGRI PGRI;

    TeamASize = GetTeamCount(1);
    TeamBSize = GetTeamCount(2);
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x69
    if(PGRI.bStartMatchCountdown && int(ControlMode) != int(3))
    {
        return false;
    }
    // End:0xF5
    if(bOnTeamA)
    {
        // End:0xF2
        if(TeamBSize == 4)
        {
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.TeamFullBO>", "<Strings:PandoraGame.ErrorMessages.TeamFullTitle>");
            return false;
        }        
    }
    else
    {
        // End:0x175
        if(TeamASize == 4)
        {
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.TeamFullCO>", "<Strings:PandoraGame.ErrorMessages.TeamFullTitle>");
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

function ChangeAMenuTeam()
{
    // End:0x65
    if(ValidateTeamChange(false))
    {
        // End:0x65
        if(TeamAPlayers[CurTeamAButton].PlayerID != -1)
        {
            PlayerController(TeamAPlayers[CurTeamAButton].PlayerController).SwitchTeam();
            UpdateTeamMenus();            
        }
    }
    //return;    
}

function ChangeBMenuTeam()
{
    // End:0x65
    if(ValidateTeamChange(true))
    {
        // End:0x65
        if(TeamBPlayers[CurTeamBButton].PlayerID != -1)
        {
            PlayerController(TeamBPlayers[CurTeamBButton].PlayerController).SwitchTeam();
            UpdateTeamMenus();            
        }
    }
    //return;    
}

function int SetPlayerImage(int PRIIdx, int ImageIdx, int TeamID)
{
    local PandoraGRI PGRI;
    local SPPlayerReplicationInfo SPPRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x30
    if(PGRI == none)
    {
        return ImageIdx;
    }
    SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[PRIIdx]);
    // End:0x61
    if(SPPRI == none)
    {
        return ImageIdx;
    }
    switch(TeamID)
    {
        // End:0xA4
        case 1:
            // End:0x87
            if(ImageIdx >= TeamACharacterImages.Length)
            {
                ImageIdx = 0;                
            }
            else
            {
                // End:0xA1
                if(ImageIdx < 0)
                {
                    ImageIdx = TeamACharacterImages.Length - 1;
                }
            }
            // End:0xE9
            break;
        // End:0xE0
        case 2:
            // End:0xC3
            if(ImageIdx >= TeamBCharacterImages.Length)
            {
                ImageIdx = 0;                
            }
            else
            {
                // End:0xDD
                if(ImageIdx < 0)
                {
                    ImageIdx = TeamBCharacterImages.Length - 1;
                }
            }
            // End:0xE9
            break;
        // End:0xFFFF
        default:
            return ImageIdx;
            break;
    }
    SPPRI.AppearanceIdx = ImageIdx;
    RequestedAppearanceID = ImageIdx;
    SPPRI.RequestAppearanceChange(ImageIdx);
    SPPRI.bNetDirty = true;
    SPPRI.bForceNetUpdate = true;
    return ImageIdx;
    //return ReturnValue;    
}

function SetOptionsToDefault()
{
    local int I, pass;

    pass = 0;
    J0x07:

    // End:0x18F [Loop If]
    if(pass < 3)
    {
        I = 0;
        J0x1A:

        // End:0x185 [Loop If]
        if(I < GameOptions.Length)
        {
            // End:0x17B
            if(GameOptions[I].DefaultMode != -1)
            {
                // End:0xE8
                if(int(ControlMode) == int(0))
                {
                    switch(GameOptions[I].Id)
                    {
                        // End:0xFFFF
                        default:
                            switch(pass)
                            {
                                // End:0x94
                                case 0:
                                    SetDefaultsForMapChanges(I);
                                    // End:0xE2
                                    break;
                                // End:0xC8
                                case 1:
                                    GameOptions[I].CurMode = GameOptions[I].DefaultMode;
                                    // End:0xE2
                                    break;
                                // End:0xDF
                                case 2:
                                    HandleLinkedOptions(I);
                                    // End:0xE2
                                    break;
                                // End:0xFFFF
                                default:
                                    break;
                            }
                            // End:0xE5
                            break;
                            break;
                    }
                    // [Explicit Continue]
                    goto J0x17B;
                }
                switch(GameOptions[I].Id)
                {
                    // End:0x109
                    case 6:
                        // End:0x17B
                        break;
                    // End:0xFFFF
                    default:
                        switch(pass)
                        {
                            // End:0x12A
                            case 0:
                                SetDefaultsForMapChanges(I);
                                // End:0x178
                                break;
                            // End:0x15E
                            case 1:
                                GameOptions[I].CurMode = GameOptions[I].DefaultMode;
                                // End:0x178
                                break;
                            // End:0x175
                            case 2:
                                HandleLinkedOptions(I);
                                // End:0x178
                                break;
                            // End:0xFFFF
                            default:
                                break;
                        }
                        // End:0x17B
                        break;
                        break;
                }
            }
            J0x17B:

            I++;
            // [Loop Continue]
            goto J0x1A;
        }
        pass++;
        // [Loop Continue]
        goto J0x07;
    }
    StoreRepOptionsInGRI();
    //return;    
}

function SetReadyFlag(bool bMode)
{
    local PlayerController PC;
    local SPPlayerReplicationInfo SPPRI;

    PC = GetPC();
    // End:0x1D
    if(PC == none)
    {
        return;
    }
    PC.PlayerReplicationInfo.bReadyToPlay = bMode;
    SPPRI = SPPlayerReplicationInfo(PC.PlayerReplicationInfo);
    SPPRI.RequestReadyStatusChange(PC.PlayerReplicationInfo.bReadyToPlay);
    UpdateReadyStatus();
    //return;    
}

function ToggleReadyFlag(optional bool bForceReady)
{
    local PlayerController PC;
    local PandoraGRI PGRI;
    local SPPlayerReplicationInfo SPPRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2D
    if(PGRI == none)
    {
        return;
    }
    // End:0x42
    if(PGRI.bStartMatchCountdown)
    {
        return;
    }
    PC = GetPC();
    // End:0x5F
    if(PC == none)
    {
        return;
    }
    // End:0x87
    if(bForceReady)
    {
        PC.PlayerReplicationInfo.bReadyToPlay = true;        
    }
    else
    {
        PC.PlayerReplicationInfo.bReadyToPlay = !PC.PlayerReplicationInfo.bReadyToPlay;
    }
    SPPRI = SPPlayerReplicationInfo(PC.PlayerReplicationInfo);
    SPPRI.RequestReadyStatusChange(PC.PlayerReplicationInfo.bReadyToPlay);
    UpdateReadyStatus();
    //return;    
}

function string GetFriendlyNameFromMarkup(string Markup)
{
    local int StartIndex, EndIndex;
    local array<string> LocPieces;

    StartIndex = InStr(Caps(Markup), "<STRINGS:");
    // End:0x30
    if(StartIndex == -1)
    {
        return Markup;
    }
    Markup = Right(Markup, (Len(Markup) - StartIndex) - 9);
    EndIndex = InStr(Markup, ">");
    // End:0xC8
    if(EndIndex != -1)
    {
        Markup = Left(Markup, EndIndex);
        ParseStringIntoArray(Markup, LocPieces, ".", true);
        // End:0xC8
        if(LocPieces.Length >= 3)
        {
            Markup = Localize(LocPieces[1], LocPieces[2], LocPieces[0]);
        }
    }
    return Markup;
    //return ReturnValue;    
}

function bool HandleTeamAKeyInput(const out InputEventParameters EventParms)
{
    local string KickMessage;

    // End:0x2E
    if(IsInputCancel(EventParms))
    {
        PlayUISound('SceneClosed');
        AbortSession();
        return true;
    }
    // End:0x1AE
    if(IsInputAccept(EventParms))
    {
        PlayUISound('Clicked');
        // End:0x6E
        if(int(ControlMode) != int(1))
        {
            ToggleReadyFlag();            
        }
        else
        {
            // End:0x1A1
            if(!IsSystemLinkMatch())
            {
                // End:0x19E
                if((TeamAPlayers[CurTeamAButton].PRIIdx != -1) && TeamAPlayers[CurTeamAButton].PlayerID != GetPC().PlayerReplicationInfo.PlayerID)
                {
                    KickedPC = TeamAPlayers[CurTeamAButton].PlayerController;
                    KickMessage = GetFriendlyNameFromMarkup(PlatformStrings $ "HelperText.KickMessage>");
                    KickMessage = Repl(KickMessage, "%s", TeamAPlayers[CurTeamAButton].UIButton.GetCaption());
                    ShowMsgBox(KickMessage, PlatformStrings $ "HelperText.KickMsgTitle>", 1, OnKickResults, None, 0, 3);
                }                
            }
            else
            {
                ToggleReadyFlag();
            }
        }
        return true;
    }
    // End:0x212
    if(IsInputAltAccept(EventParms))
    {
        // End:0x210
        if(TeamAPlayers[CurTeamAButton].PRIIdx != -1)
        {
            PlayUISound('Clicked');
            ShowGamercard(TeamAPlayers[CurTeamAButton].PRIIdx);
        }
        return true;
    }
    // End:0x292
    if(IsInputNavUp(EventParms))
    {
        // End:0x250
        if(CurTeamAButton > 0)
        {
            PlayUISound('NavigateUp');
            amBXPulseMenuItemChange();
            CurTeamAButton--;
        }
        SetFocus(TeamAPlayers[CurTeamAButton].UIButton.GetOwner());
        UpdateTeamMenus();
        PopulateOptionMenu();
        return true;
    }
    // End:0x36D
    if(IsInputNavDown(EventParms))
    {
        // End:0x314
        if(CurTeamAButton == (4 - 1))
        {
            PlayUISound('NavigateDown');
            amBXPulseMenuItemChange();
            SwitchMenu(2);
            SetFocus(btnOption[0].GetOwner());
            OptionMenuSelIdx = 0;
            SetHelperLabel();
            PopulateOptionMenu();            
        }
        else
        {
            PlayUISound('NavigateDown');
            amBXPulseMenuItemChange();
            CurTeamAButton++;
            SetFocus(TeamAPlayers[CurTeamAButton].UIButton.GetOwner());
        }
        UpdateTeamMenus();
        return true;
    }
    // End:0x3E8
    if(IsInputNavRight(EventParms))
    {
        PlayUISound('NavigateRight');
        amBXPulseMenuItemChange();
        SwitchMenu(1);
        CurTeamBButton = CurTeamAButton;
        SetFocus(TeamBPlayers[CurTeamBButton].UIButton.GetOwner());
        UpdateTeamMenus();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool HandleTeamBKeyInput(const out InputEventParameters EventParms)
{
    local string KickMessage;

    // End:0x2E
    if(IsInputCancel(EventParms))
    {
        PlayUISound('SceneClosed');
        AbortSession();
        return true;
    }
    // End:0x1AE
    if(IsInputAccept(EventParms))
    {
        PlayUISound('Clicked');
        // End:0x6E
        if(int(ControlMode) != int(1))
        {
            ToggleReadyFlag();            
        }
        else
        {
            // End:0x1A1
            if(!IsSystemLinkMatch())
            {
                // End:0x19E
                if((TeamBPlayers[CurTeamBButton].PRIIdx != -1) && TeamBPlayers[CurTeamBButton].PlayerID != GetPC().PlayerReplicationInfo.PlayerID)
                {
                    KickedPC = TeamBPlayers[CurTeamBButton].PlayerController;
                    KickMessage = GetFriendlyNameFromMarkup(PlatformStrings $ "HelperText.KickMessage>");
                    KickMessage = Repl(KickMessage, "%s", TeamBPlayers[CurTeamBButton].UIButton.GetCaption());
                    ShowMsgBox(KickMessage, PlatformStrings $ "HelperText.KickMsgTitle>", 1, OnKickResults, None, 0, 3);
                }                
            }
            else
            {
                ToggleReadyFlag();
            }
        }
        return true;
    }
    // End:0x212
    if(IsInputAltAccept(EventParms))
    {
        PlayUISound('Clicked');
        // End:0x210
        if(TeamBPlayers[CurTeamBButton].PRIIdx != -1)
        {
            ShowGamercard(TeamBPlayers[CurTeamBButton].PRIIdx);
        }
        return true;
    }
    // End:0x292
    if(IsInputNavUp(EventParms))
    {
        // End:0x250
        if(CurTeamBButton > 0)
        {
            PlayUISound('NavigateUp');
            amBXPulseMenuItemChange();
            CurTeamBButton--;
        }
        SetFocus(TeamBPlayers[CurTeamBButton].UIButton.GetOwner());
        UpdateTeamMenus();
        PopulateOptionMenu();
        return true;
    }
    // End:0x363
    if(IsInputNavDown(EventParms))
    {
        // End:0x30A
        if(CurTeamBButton == (4 - 1))
        {
            PlayUISound('NavigateDown');
            amBXPulseMenuItemChange();
            SwitchMenu(2);
            SetFocus(btnOption[0].GetOwner());
            OptionMenuSelIdx = 0;
            PopulateOptionMenu();            
        }
        else
        {
            PlayUISound('NavigateDown');
            amBXPulseMenuItemChange();
            CurTeamBButton++;
            SetFocus(TeamBPlayers[CurTeamBButton].UIButton.GetOwner());
        }
        UpdateTeamMenus();
        return true;
    }
    // End:0x3DE
    if(IsInputNavLeft(EventParms))
    {
        PlayUISound('NavigateLeft');
        amBXPulseMenuItemChange();
        SwitchMenu(0);
        CurTeamAButton = CurTeamBButton;
        SetFocus(TeamBPlayers[CurTeamBButton].UIButton.GetOwner());
        UpdateTeamMenus();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsActivePlayerReady()
{
    local int PCIdx, TeamID;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return false;
    }
    PCIdx = GetLocalPCIndex(TeamID);
    // End:0x81
    if(TeamID == 1)
    {
        return PGRI.PRIArray[TeamAPlayers[PCIdx].PRIIdx].bReadyToPlay;        
    }
    else
    {
        // End:0xBF
        if(TeamID == 2)
        {
            return PGRI.PRIArray[TeamBPlayers[PCIdx].PRIIdx].bReadyToPlay;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool SwitchToTeamA()
{
    local PlayerController PC;

    // End:0x0F
    if(IsActivePlayerReady())
    {
        return false;
    }
    // End:0x1C
    if(RequestedTeamID != 0)
    {
        return false;
    }
    PC = GetPC();
    // End:0x39
    if(PC == none)
    {
        return false;
    }
    // End:0x99
    if((PC.PlayerReplicationInfo.Team.TeamIndex != 1) && ValidateTeamChange(false))
    {
        RequestedTeamID = 1;
        PC.SwitchTeam();
        UpdateTeamMenus();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool SwitchToTeamB()
{
    local PlayerController PC;

    // End:0x0F
    if(IsActivePlayerReady())
    {
        return false;
    }
    // End:0x1C
    if(RequestedTeamID != 0)
    {
        return false;
    }
    PC = GetPC();
    // End:0x39
    if(PC == none)
    {
        return false;
    }
    // End:0x9B
    if((PC.PlayerReplicationInfo.Team.TeamIndex != 2) && ValidateTeamChange(true))
    {
        RequestedTeamID = 2;
        PC.SwitchTeam();
        UpdateTeamMenus();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function int GetLocalPCIndex(optional out int TeamID)
{
    local PlayerController PC;
    local int I;

    PC = GetPC();
    // End:0x10A
    if(PC != none)
    {
        // End:0x92
        if(PC.PlayerReplicationInfo.Team.TeamIndex == 1)
        {
            TeamID = 1;
            I = 0;
            J0x53:

            // End:0x8F [Loop If]
            if(I < 4)
            {
                // End:0x85
                if(TeamAPlayers[I].PlayerController == PC)
                {
                    return I;
                }
                I++;
                // [Loop Continue]
                goto J0x53;
            }            
        }
        else
        {
            // End:0x107
            if(PC.PlayerReplicationInfo.Team.TeamIndex == 2)
            {
                TeamID = 2;
                I = 0;
                J0xCB:

                // End:0x107 [Loop If]
                if(I < 4)
                {
                    // End:0xFD
                    if(TeamBPlayers[I].PlayerController == PC)
                    {
                        return I;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0xCB;
                }
            }
        }        
    }
    return -1;
    //return ReturnValue;    
}

function bool HandleCharacterUpdate(const out InputEventParameters EventParms)
{
    local int PCIdx, TeamID;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(RequestedTeamID != 0)
    {
        return false;
    }
    // End:0x39
    if(RequestedAppearanceID != 0)
    {
        return false;
    }
    // End:0x1BA
    if(IsInputNavTriggerR(EventParms))
    {
        PCIdx = GetLocalPCIndex(TeamID);
        // End:0x10D
        if(TeamID == 1)
        {
            // End:0x10A
            if(TeamAPlayers[PCIdx].PlayerController == (GetPC()))
            {
                // End:0x10A
                if(!PGRI.PRIArray[TeamAPlayers[PCIdx].PRIIdx].bReadyToPlay)
                {
                    SetPlayerImage(TeamAPlayers[PCIdx].PRIIdx, TeamAPlayers[PCIdx].PlayerImageIdx + 1, 1);
                    UpdateTeamMenus();
                }
            }            
        }
        else
        {
            // End:0x1B8
            if(TeamID == 2)
            {
                // End:0x1B8
                if(TeamBPlayers[PCIdx].PlayerController == (GetPC()))
                {
                    // End:0x1B8
                    if(!PGRI.PRIArray[TeamBPlayers[PCIdx].PRIIdx].bReadyToPlay)
                    {
                        SetPlayerImage(TeamBPlayers[PCIdx].PRIIdx, TeamBPlayers[PCIdx].PlayerImageIdx + 1, 1);
                        UpdateTeamMenus();
                    }
                }
            }
        }
        return true;
    }
    // End:0x345
    if(IsInputNavTriggerL(EventParms))
    {
        PCIdx = GetLocalPCIndex(TeamID);
        // End:0x28E
        if(TeamID == 1)
        {
            // End:0x28B
            if(TeamAPlayers[PCIdx].PlayerController == (GetPC()))
            {
                // End:0x28B
                if(!PGRI.PRIArray[TeamAPlayers[PCIdx].PRIIdx].bReadyToPlay)
                {
                    SetPlayerImage(TeamAPlayers[PCIdx].PRIIdx, TeamAPlayers[PCIdx].PlayerImageIdx - 1, 1);
                    UpdateTeamMenus();
                }
            }            
        }
        else
        {
            // End:0x339
            if(TeamID == 2)
            {
                // End:0x339
                if(TeamBPlayers[PCIdx].PlayerController == (GetPC()))
                {
                    // End:0x339
                    if(!PGRI.PRIArray[TeamBPlayers[PCIdx].PRIIdx].bReadyToPlay)
                    {
                        SetPlayerImage(TeamBPlayers[PCIdx].PRIIdx, TeamBPlayers[PCIdx].PlayerImageIdx - 1, 1);
                        UpdateTeamMenus();
                    }
                }
            }
        }
        UpdateTeamMenus();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool HandleGameKeyInput(const out InputEventParameters EventParms)
{
    local PandoraGRI PGRI;

    UpDateUsingGamePadForPC(EventParms);
    // End:0x1A
    if(bCreatingGame)
    {
        return false;
    }
    // End:0x5C
    if((IsInputCancel(EventParms)) || IsInputEscape(EventParms))
    {
        PlayUISound('SceneClosed');
        AbortSession();
        return true;
    }
    // End:0x16F
    if(int(ControlMode) != int(0))
    {
        PGRI = PandoraGRI(GetWorldInfo().GRI);
        // End:0xD2
        if((IsInputNavShoulderL(EventParms)) && !PGRI.bStartMatchCountdown || int(ControlMode) == int(3))
        {
            SwitchToTeamA();
            return true;
        }
        // End:0x119
        if((IsInputNavShoulderR(EventParms)) && !PGRI.bStartMatchCountdown || int(ControlMode) == int(3))
        {
            SwitchToTeamB();
            return true;
        }
        // End:0x160
        if((IsInputAlt2Accept(EventParms)) && !PGRI.bStartMatchCountdown || int(ControlMode) == int(3))
        {
            InitWeaponConfig();
            return true;
        }
        HandleCharacterUpdate(EventParms);
    }
    switch(ActiveMenu)
    {
        // End:0x18C
        case 0:
            return HandleTeamAKeyInput(EventParms);
        // End:0x1A1
        case 1:
            return HandleTeamBKeyInput(EventParms);
        // End:0x1B6
        case 2:
            return HandleGameOptionKeyInput(EventParms);
        // End:0x1CB
        case 3:
            return HandleReadyKeyInput(EventParms);
        // End:0x1E0
        case 4:
            return HandleBackKeyInput(EventParms);
        // End:0xFFFF
        default:
            return false;
            break;
    }
    //return ReturnValue;    
}

function BindInterfaceKeys()
{
    __OnRawInputKey__Delegate = HandleGameKeyInput;
    //return;    
}

function string BuildActiveGameOptionString(int I)
{
    local MPGameOption GameOption;

    GameOption = GameOptions[I];
    // End:0x96
    if((GameOption.CurMode >= 0) && GameOption.CurMode < GameOption.Modes.Length)
    {
        return (GameOption.OptionName @ " ") @ GameOption.Modes[GameOption.CurMode].ModeName;        
    }
    else
    {
        return GameOption.OptionName;
    }
    //return ReturnValue;    
}

function UpdateMapImage()
{
    local int ImageIdx, I;

    I = 0;
    J0x07:

    // End:0xA3 [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x99
        if(int(GameOptions[I].Id) == int(3))
        {
            ImageIdx = GameOptions[I].CurMode;
            // End:0x97
            if((ImageIdx >= 0) && ImageIdx < MapPreviewTextures.Length)
            {
                LastUsedMapImageIdx = ImageIdx;
                imageGameMap.SetValue(MapPreviewTextures[ImageIdx]);
            }
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function UpdateMapImageFromSel()
{
    local int ImageIdx;

    // End:0x0D
    if(OptionMenuSelIdx < 0)
    {
        return;
    }
    // End:0x9E
    if(int(GameOptions[OptionMenuSelIdx].Id) == int(3))
    {
        ImageIdx = GameOptions[OptionMenuSelIdx].CurMode;
        // End:0x9E
        if(((ImageIdx >= 0) && ImageIdx != LastUsedMapImageIdx) && ImageIdx < MapPreviewTextures.Length)
        {
            LastUsedMapImageIdx = ImageIdx;
            imageGameMap.SetValue(MapPreviewTextures[ImageIdx]);
        }
    }
    //return;    
}

function UpdatePlayerImages()
{
    local PandoraGRI PGRI;
    local SPPlayerReplicationInfo SPPRI;
    local int I;

    // End:0x0D
    if(!bPlayerSlotsVisible)
    {
        return;
    }
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x39
    if(PGRI == none)
    {
        return;
    }
    I = 0;
    J0x40:

    // End:0x2B6 [Loop If]
    if(I < 4)
    {
        // End:0x156
        if(TeamAPlayers[I].PRIIdx != -1)
        {
            SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[TeamAPlayers[I].PRIIdx]);
            // End:0x12D
            if(SPPRI != none)
            {
                TeamAPlayers[I].UIPlayerImage.SetValue(TeamACharacterImages[SPPRI.AppearanceIdx]);
                TeamAPlayers[I].UIPlayerImage.SetVisibility(true);
                TeamAPlayers[I].PlayerImageIdx = SPPRI.AppearanceIdx;                
            }
            else
            {
                TeamAPlayers[I].UIPlayerImage.SetVisibility(false);
            }            
        }
        else
        {
            TeamAPlayers[I].UIPlayerImage.SetVisibility(false);
        }
        // End:0x286
        if(TeamBPlayers[I].PRIIdx != -1)
        {
            SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[TeamBPlayers[I].PRIIdx]);
            // End:0x25D
            if(SPPRI != none)
            {
                TeamBPlayers[I].UIPlayerImage.SetValue(TeamBCharacterImages[SPPRI.AppearanceIdx]);
                TeamBPlayers[I].UIPlayerImage.SetVisibility(true);
                TeamBPlayers[I].PlayerImageIdx = SPPRI.AppearanceIdx;                
            }
            else
            {
                TeamBPlayers[I].UIPlayerImage.SetVisibility(false);
            }
            // [Explicit Continue]
            goto J0x2AC;
        }
        TeamBPlayers[I].UIPlayerImage.SetVisibility(false);
        J0x2AC:

        I++;
        // [Loop Continue]
        goto J0x40;
    }
    //return;    
}

function bool IsPrivateLogin(int PRIIdx)
{
    local PandoraGRI PGRI;
    local SPPlayerReplicationInfo PRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return false;
    }
    PRI = SPPlayerReplicationInfo(PGRI.PRIArray[PRIIdx]);
    // End:0x59
    if(PRI == none)
    {
        return false;
    }
    // End:0x75
    if(int(PRI.LoginType) == int(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function UpdateArbitratedSessionStartPermission()
{
    local int StartMatchIdx;
    local bool bChanged;

    bChanged = false;
    // End:0xD0
    if(int(ControlMode) == int(1))
    {
        StartMatchIdx = FindOptionIndex(2);
        // End:0x7F
        if(NumLoggedInPlayers >= (GetMinimumPlayerCount()))
        {
            // End:0x63
            if(GameOptions[StartMatchIdx].bEnabled == false)
            {
                bChanged = true;
            }
            GameOptions[StartMatchIdx].bEnabled = true;            
        }
        else
        {
            // End:0xA4
            if(GameOptions[StartMatchIdx].bEnabled == true)
            {
                bChanged = true;
            }
            GameOptions[StartMatchIdx].bEnabled = false;
        }
        // End:0xD0
        if(bChanged)
        {
            PopulateOptionMenu();
        }
    }
    //return;    
}

function UpdateTeamsWithPlayers()
{
    local PandoraGRI PGRI;
    local int I, TeamAIdx, TeamBIdx;
    local TeamInfo tm_info;
    local int NumUnclaimedPrivateSlots;
    local SPPlayerReplicationInfo SPPRI;

    NumLoggedInPlayers = 0;
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x33
    if(PGRI == none)
    {
        return;
    }
    TeamAIdx = 0;
    TeamBIdx = 0;
    NumUnclaimedPrivateSlots = int(GetOptionValue(6));
    // End:0x5E5
    if(PGRI.PRIArray.Length > 0)
    {
        I = 0;
        J0x72:

        // End:0x5E5 [Loop If]
        if(I < PGRI.PRIArray.Length)
        {
            tm_info = PGRI.PRIArray[I].Team;
            // End:0x33A
            if((tm_info != none) && tm_info.TeamIndex == 1)
            {
                // End:0xE2
                if(TeamAIdx > 4)
                {
                    // [Explicit Continue]
                    goto J0x5DB;
                }
                // End:0x2B3
                if(PGRI.PRIArray[I] != none)
                {
                    TeamAPlayers[TeamAIdx].PlayerController = Controller(PGRI.PRIArray[I].Owner);
                    TeamAPlayers[TeamAIdx].PRIIdx = I;
                    TeamAPlayers[TeamAIdx].PlayerID = PGRI.PRIArray[I].PlayerID;
                    SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[I]);
                    // End:0x1E6
                    if(SPPRI.bSkippedIntermission)
                    {
                        TeamAPlayers[TeamAIdx].UIButton.Opacity = 1.0000000;                        
                    }
                    else
                    {
                        TeamAPlayers[TeamAIdx].UIButton.Opacity = 0.2500000;
                    }
                    // End:0x26C
                    if(IsPrivateLogin(I))
                    {
                        TeamAPlayers[TeamAIdx].UIButton.SetCaption(PGRI.PRIArray[I].PlayerName);
                        NumUnclaimedPrivateSlots--;                        
                    }
                    else
                    {
                        TeamAPlayers[TeamAIdx].UIButton.SetCaption(PGRI.PRIArray[I].PlayerName);
                    }                    
                }
                else
                {
                    TeamAPlayers[TeamAIdx].PlayerController = none;
                    TeamAPlayers[TeamAIdx].PRIIdx = -1;
                    TeamAPlayers[TeamAIdx].PlayerID = -1;
                    TeamAPlayers[TeamAIdx].UIButton.Opacity = 1.0000000;
                }
                TeamAIdx++;
                NumLoggedInPlayers++;
                // [Explicit Continue]
                goto J0x5DB;
            }
            // End:0x5DB
            if((tm_info != none) && tm_info.TeamIndex == 2)
            {
                // End:0x36C
                if(TeamBIdx > 4)
                {
                    // [Explicit Continue]
                    goto J0x5DB;
                }
                // End:0x53D
                if(PGRI.PRIArray[I] != none)
                {
                    TeamBPlayers[TeamBIdx].PlayerController = Controller(PGRI.PRIArray[I].Owner);
                    TeamBPlayers[TeamBIdx].PRIIdx = I;
                    TeamBPlayers[TeamBIdx].PlayerID = PGRI.PRIArray[I].PlayerID;
                    SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[I]);
                    // End:0x470
                    if(SPPRI.bSkippedIntermission)
                    {
                        TeamBPlayers[TeamBIdx].UIButton.Opacity = 1.0000000;                        
                    }
                    else
                    {
                        TeamBPlayers[TeamBIdx].UIButton.Opacity = 0.2500000;
                    }
                    // End:0x4F6
                    if(IsPrivateLogin(I))
                    {
                        TeamBPlayers[TeamBIdx].UIButton.SetCaption(PGRI.PRIArray[I].PlayerName);
                        NumUnclaimedPrivateSlots--;                        
                    }
                    else
                    {
                        TeamBPlayers[TeamBIdx].UIButton.SetCaption(PGRI.PRIArray[I].PlayerName);
                    }                    
                }
                else
                {
                    TeamBPlayers[TeamBIdx].PlayerController = none;
                    TeamBPlayers[TeamBIdx].PRIIdx = -1;
                    TeamBPlayers[TeamBIdx].PlayerID = PGRI.PRIArray[I].PlayerID;
                    TeamBPlayers[TeamBIdx].UIButton.Opacity = 1.0000000;
                }
                TeamBIdx++;
                NumLoggedInPlayers++;
            }
            J0x5DB:

            I++;
            // [Loop Continue]
            goto J0x72;
        }
    }
    I = TeamAIdx;
    J0x5F0:

    // End:0x648 [Loop If]
    if(I < 4)
    {
        TeamAPlayers[I].PRIIdx = -1;
        TeamAPlayers[I].UIButton.Opacity = 1.0000000;
        I++;
        // [Loop Continue]
        goto J0x5F0;
    }
    I = TeamBIdx;
    J0x653:

    // End:0x6AB [Loop If]
    if(I < 4)
    {
        TeamBPlayers[I].PRIIdx = -1;
        TeamBPlayers[I].UIButton.Opacity = 1.0000000;
        I++;
        // [Loop Continue]
        goto J0x653;
    }
    I = 0;
    J0x6B2:

    // End:0x90A [Loop If]
    if(I < 4)
    {
        // End:0x7DF
        if(TeamAPlayers[I].PRIIdx == -1)
        {
            // End:0x74E
            if(NumUnclaimedPrivateSlots > 0)
            {
                TeamAPlayers[I].UIButton.SetCaption("<Strings:PandoraGame.UIScene_PandoraLobbyMP.Private>");
                NumUnclaimedPrivateSlots--;                
            }
            else
            {
                TeamAPlayers[I].UIButton.SetCaption("<Strings:PandoraGame.UIScene_PandoraLobbyMP.Empty>");
            }
            TeamAPlayers[I].PRIIdx = -1;
            TeamAPlayers[I].PlayerID = -1;
        }
        // End:0x900
        if(TeamBPlayers[I].PRIIdx == -1)
        {
            // End:0x86F
            if(NumUnclaimedPrivateSlots > 0)
            {
                TeamBPlayers[I].UIButton.SetCaption("<Strings:PandoraGame.UIScene_PandoraLobbyMP.Private>");
                NumUnclaimedPrivateSlots--;                
            }
            else
            {
                TeamBPlayers[I].UIButton.SetCaption("<Strings:PandoraGame.UIScene_PandoraLobbyMP.Empty>");
            }
            TeamBPlayers[I].PRIIdx = -1;
            TeamBPlayers[I].PlayerID = -1;
        }
        I++;
        // [Loop Continue]
        goto J0x6B2;
    }
    UpdatePlayerImages();
    UpdateReadyStatus();
    // End:0x94A
    if(GetWorldInfo().GRI.bIsArbitrated)
    {
        UpdateArbitratedSessionStartPermission();
    }
    //return;    
}

function UpdateTeamMenus()
{
    local int I;
    local UIObject ObjectToHighlight;

    UpdateTeamsWithPlayers();
    ObjectToHighlight = none;
    I = 0;
    J0x18:

    // End:0x252 [Loop If]
    if(I < 4)
    {
        // End:0x92
        if(!bTeamMenuEnabled)
        {
            TeamAPlayers[I].UIButton.StringRenderComponent.SetColor(DisabledColor);
            TeamBPlayers[I].UIButton.StringRenderComponent.SetColor(DisabledColor);
            // [Explicit Continue]
            goto J0x248;
        }
        // End:0x13D
        if((int(ActiveMenu) == int(0)) && CurTeamAButton == I)
        {
            TeamAPlayers[I].UIButton.StringRenderComponent.SetColor(SelectColor);
            ObjectToHighlight = TeamAPlayers[I].UIButton;
            // End:0x13A
            if(imageHighlight != none)
            {
                imageHighlight.Position = TeamAPlayers[I].UIButton.Position;
            }            
        }
        else
        {
            TeamAPlayers[I].UIButton.StringRenderComponent.SetColor(NonSelectColor);
        }
        // End:0x218
        if((int(ActiveMenu) == int(1)) && CurTeamBButton == I)
        {
            TeamBPlayers[I].UIButton.StringRenderComponent.SetColor(SelectColor);
            ObjectToHighlight = TeamBPlayers[I].UIButton;
            // End:0x215
            if(imageHighlight != none)
            {
                imageHighlight.Position = TeamBPlayers[I].UIButton.Position;
            }
            // [Explicit Continue]
            goto J0x248;
        }
        TeamBPlayers[I].UIButton.StringRenderComponent.SetColor(NonSelectColor);
        J0x248:

        I++;
        // [Loop Continue]
        goto J0x18;
    }
    // End:0x2B1
    if(OptionMenuSelIdx == -1)
    {
        // End:0x2B1
        if(ObjectToHighlight != CurrentObjectToHighlight)
        {
            KillFocus(CurrentObjectToHighlight.GetOwner());
            SetFocus(ObjectToHighlight.GetOwner());
            CurrentObjectToHighlight = ObjectToHighlight;
        }
    }
    //return;    
}

function DeactivateOptionStates()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(I < btnOption.Length)
    {
        btnOption[I].DeactivateStateByClass(Class'Engine.UIState_Active', 0);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x60
    if(btnReady != none)
    {
        btnReady.DeactivateStateByClass(Class'Engine.UIState_Active', 0);
    }
    // End:0x82
    if(btnBack != none)
    {
        btnBack.DeactivateStateByClass(Class'Engine.UIState_Active', 0);
    }
    //return;    
}

function ClearActiveOptionStates()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(I < btnOption.Length)
    {
        btnOption[I].ActivateStateByClass(Class'Engine.UIState_Enabled', 0);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x60
    if(btnReady != none)
    {
        btnReady.ActivateStateByClass(Class'Engine.UIState_Enabled', 0);
    }
    // End:0x82
    if(btnBack != none)
    {
        btnBack.ActivateStateByClass(Class'Engine.UIState_Enabled', 0);
    }
    //return;    
}

function MatchMousePosWithCurSel()
{
    local int BtnIdx;
    local SPGameUISceneClient SPSceneClient;

    ClearActiveOptionStates();
    BtnIdx = GetButtonIndexFromOptionIndex(OptionMenuSelIdx);
    // End:0x127
    if(IsPCBuild())
    {
        SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
        ClearActiveOptionStates();
        // End:0xCF
        if((LastMousePos.X != SPSceneClient.MousePosition.X) || LastMousePos.Y != SPSceneClient.MousePosition.Y)
        {
            SetSelectionToHighlight();
            LastMousePos = SPSceneClient.MousePosition;            
        }
        else
        {
            SPSceneClient.SetMousePosition(int(btnOption[BtnIdx].Position.Value[0]), int(btnOption[BtnIdx].Position.Value[1]));
        }
    }
    //return;    
}

function SetActiveButton(int Idx)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x6D [Loop If]
    if(I < btnOption.Length)
    {
        // End:0x46
        if(I == Idx)
        {
            btnOption[I].ActivateStateByClass(Class'Engine.UIState_Active', 0);
            // [Explicit Continue]
            goto J0x63;
        }
        btnOption[I].DeactivateStateByClass(Class'Engine.UIState_Active', 0);
        J0x63:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function int GetButtonIndexFromOptionIndex(int OptIdx)
{
    local int CurOption, I;

    CurOption = OptionMenuStartIdx;
    I = 0;
    J0x12:

    // End:0x57 [Loop If]
    if(I < NumListBoxEntries)
    {
        // End:0x46
        if(CurOption < GameOptions.Length)
        {
            // End:0x46
            if(CurOption == OptIdx)
            {
                return I;
            }
        }
        CurOption++;
        I++;
        // [Loop Continue]
        goto J0x12;
    }
    return -1;
    //return ReturnValue;    
}

function PopulateOptionMenu()
{
    local int I, CurOption;
    local UIObject ObjectToHighlight;

    CurOption = OptionMenuStartIdx;
    UpdateMapImage();
    UpdateAdvertisedData();
    ObjectToHighlight = none;
    I = 0;
    J0x2E:

    // End:0x12D [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x123
        if(int(GameOptions[I].Id) == int(2))
        {
            // End:0xC1
            if(!IsSwitchingMap())
            {
                GameOptions[I].OptionName = "<Strings:PandoraGame.UIScene_PandoraLobbyMP.StartMatch>";                
            }
            else
            {
                // End:0x120
                if(int(ControlMode) != int(0))
                {
                    GameOptions[I].OptionName = "<Strings:PandoraGame.UIScene_PandoraLobbyMP.SwitchMap>";
                }
            }
            // [Explicit Break]
            goto J0x12D;
        }
        I++;
        // [Loop Continue]
        goto J0x2E;
    }
    J0x12D:

    I = 0;
    J0x134:

    // End:0x2DB [Loop If]
    if(I < NumListBoxEntries)
    {
        // End:0x2AF
        if(CurOption < GameOptions.Length)
        {
            btnOption[I].SetCaption(BuildActiveGameOptionString(CurOption));
            btnOption[I].SetVisibility(true);
            // End:0x22A
            if(CurOption == OptionMenuSelIdx)
            {
                // End:0x227
                if(btnOption[I].StringRenderComponent != none)
                {
                    btnOption[I].StringRenderComponent.SetColor(SelectColor);
                    // End:0x216
                    if(imageHighlight != none)
                    {
                        imageHighlight.Position = btnOption[I].Position;
                    }
                    ObjectToHighlight = btnOption[I];
                }                
            }
            else
            {
                // End:0x2AC
                if(btnOption[I].StringRenderComponent != none)
                {
                    // End:0x287
                    if(GameOptions[CurOption].bEnabled)
                    {
                        btnOption[I].StringRenderComponent.SetColor(NonSelectColor);                        
                    }
                    else
                    {
                        btnOption[I].StringRenderComponent.SetColor(DisabledColor);
                    }
                }
            }            
        }
        else
        {
            btnOption[I].SetVisibility(false);
        }
        CurOption++;
        I++;
        // [Loop Continue]
        goto J0x134;
    }
    // End:0x336
    if(OptionMenuSelIdx >= 0)
    {
        // End:0x336
        if(ObjectToHighlight != CurrentObjectToHighlight)
        {
            KillFocus(CurrentObjectToHighlight.GetOwner());
            SetFocus(ObjectToHighlight.GetOwner());
            CurrentObjectToHighlight = ObjectToHighlight;
        }
    }
    // End:0x388
    if(btnDownArrow != none)
    {
        // End:0x373
        if(((GameOptions.Length - OptionMenuStartIdx) - NumListBoxEntries) > 0)
        {
            btnDownArrow.SetVisibility(true);            
        }
        else
        {
            btnDownArrow.SetVisibility(false);
        }
    }
    //return;    
}

event InitScene()
{
    __OnSceneActivated__Delegate = LobbySceneActivated;
    super(UIScene_BaseFrontEnd).InitScene();
    GameResourceDataStore = UIDataStore_GameResource(GetCurrentUIController().DataStoreManager.FindDataStore('GameResources'));
    NumberOfMaps = GameResourceDataStore.GetProviderCount('MultiplayerMaps');
    CurrentObjectToHighlight = none;
    //return;    
}

function SetSlotVisibility(bool bVisible)
{
    local int I;

    // End:0x1AA
    if(TeamAPlayers[0].UIButton != none)
    {
        // End:0x1AA
        if(int(ControlMode) != int(0))
        {
            I = 0;
            J0x2F:

            // End:0x19D [Loop If]
            if(I < 4)
            {
                TeamAPlayers[I].UIButton.SetVisibility(bVisible);
                TeamAPlayers[I].UIButtonBG.SetVisibility(bVisible);
                TeamAPlayers[I].UIReadyCheckbox.SetVisibility(bVisible);
                TeamAPlayers[I].UIPlayerImage.SetVisibility(bVisible);
                TeamBPlayers[I].UIButton.SetVisibility(bVisible);
                TeamBPlayers[I].UIButtonBG.SetVisibility(bVisible);
                TeamBPlayers[I].UIReadyCheckbox.SetVisibility(bVisible);
                TeamBPlayers[I].UIPlayerImage.SetVisibility(bVisible);
                I++;
                // [Loop Continue]
                goto J0x2F;
            }
            bPlayerSlotsVisible = bVisible;
        }
    }
    //return;    
}

function SetHelperLabel()
{
    // End:0x5A
    if(int(ControlMode) == int(0))
    {
        bbHelperText.SetDataStoreBinding("<Strings:PandoraGame.HelperText.ChooseChangeBackBar>");        
    }
    else
    {
        // End:0xA7
        if(IsSystemLinkMatch())
        {
            bbHelperText.SetDataStoreBinding(PlatformStrings $ "HelperText.CreateSessionBarSysLink>");            
        }
        else
        {
            bbHelperText.SetDataStoreBinding(PlatformStrings $ "HelperText.CreateSessionBar>");
        }
    }
    //return;    
}

function bool SetTitleLabel()
{
    local OnlineGameSettings Settings;
    local PandoraGRI PGRI;

    Settings = GetWorldInfo().Game.GameSettings;
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x50
    if(PGRI == none)
    {
        return false;
    }
    // End:0x75
    if(Settings == none)
    {
        Settings = PGRI.GetPandoraGameSettings();
    }
    // End:0xEB
    if(myGameInfo.bLanMatch || (Settings != none) && Settings.bIsLanMatch)
    {
        lblTitle.SetValue(PlatformStrings $ "UIScene_PandoraLobbyMP.MPModeSysLink>");        
    }
    else
    {
        // End:0x160
        if(myGameInfo.bUsesArbitration || (Settings != none) && Settings.bUsesArbitration)
        {
            lblTitle.SetValue(PlatformStrings $ "UIScene_PandoraLobbyMP.MPLiveRanked>");            
        }
        else
        {
            lblTitle.SetValue(PlatformStrings $ "UIScene_PandoraLobbyMP.MPLiveUnranked>");
        }
    }
    return true;
    //return ReturnValue;    
}

function ClearReadyStatus()
{
    local PandoraGRI PGRI;
    local int I;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2A
    if(PGRI == none)
    {
    }
    I = 0;
    J0x31:

    // End:0x151 [Loop If]
    if(I < 4)
    {
        TeamAPlayers[I].UIReadyCheckbox.SetValue(false);
        TeamBPlayers[I].UIReadyCheckbox.SetValue(false);
        // End:0xE9
        if(TeamAPlayers[I].PRIIdx != -1)
        {
            // End:0xE9
            if(PGRI != none)
            {
                PGRI.PRIArray[TeamAPlayers[I].PRIIdx].bReadyToPlay = false;
            }
        }
        // End:0x147
        if(TeamBPlayers[I].PRIIdx != -1)
        {
            // End:0x147
            if(PGRI != none)
            {
                PGRI.PRIArray[TeamBPlayers[I].PRIIdx].bReadyToPlay = false;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x31;
    }
    UpdateReadyStatus();
    //return;    
}

function UpdateReadyStatus()
{
    local PandoraGRI PGRI;
    local int I;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    // End:0x202
    if(int(ControlMode) != int(0))
    {
        I = 0;
        J0x43:

        // End:0x11F [Loop If]
        if(I < 4)
        {
            // End:0xEF
            if(TeamAPlayers[I].PRIIdx != -1)
            {
                TeamAPlayers[I].UIReadyCheckbox.SetValue(PGRI.PRIArray[TeamAPlayers[I].PRIIdx].bReadyToPlay);
                TeamAPlayers[I].UIReadyCheckbox.SetVisibility(true);
                // [Explicit Continue]
                goto J0x115;
            }
            TeamAPlayers[I].UIReadyCheckbox.SetVisibility(false);
            J0x115:

            I++;
            // [Loop Continue]
            goto J0x43;
        }
        I = 0;
        J0x126:

        // End:0x202 [Loop If]
        if(I < 4)
        {
            // End:0x1D2
            if(TeamBPlayers[I].PRIIdx != -1)
            {
                TeamBPlayers[I].UIReadyCheckbox.SetValue(PGRI.PRIArray[TeamBPlayers[I].PRIIdx].bReadyToPlay);
                TeamBPlayers[I].UIReadyCheckbox.SetVisibility(true);
                // [Explicit Continue]
                goto J0x1F8;
            }
            TeamBPlayers[I].UIReadyCheckbox.SetVisibility(false);
            J0x1F8:

            I++;
            // [Loop Continue]
            goto J0x126;
        }
    }
    //return;    
}

function AssignOptionButtons()
{
    btnOption[0] = UILabelButton(FindChild('btnOption01', true));
    btnOption[1] = UILabelButton(FindChild('btnOption02', true));
    btnOption[2] = UILabelButton(FindChild('btnOption03', true));
    btnOption[3] = UILabelButton(FindChild('btnOption04', true));
    btnOption[4] = UILabelButton(FindChild('btnOption05', true));
    //return;    
}

function LobbySceneActivated(UIScene ActivatedScene, bool bInitialActivation)
{
    local PandoraGRI PGRI;
    local WorldInfo WI;
    local int I;

    SceneActivated(bInitialActivation);
    // End:0xE1C
    if(bInitialActivation)
    {
        LoadChildScenes();
        WI = GetWorldInfo();
        // End:0x3D
        if(WI == none)
        {            
        }
        else
        {
            PGRI = PandoraGRI(WI.GRI);
            // End:0x62
            if(PGRI == none)
            {
            }
        }
        TeamAPlayers[0].UIButton = UILabelButton(FindChild('btnTeam1Player1', true));
        TeamAPlayers[1].UIButton = UILabelButton(FindChild('btnTeam1Player2', true));
        TeamAPlayers[2].UIButton = UILabelButton(FindChild('btnTeam1Player3', true));
        TeamAPlayers[3].UIButton = UILabelButton(FindChild('btnTeam1Player4', true));
        TeamAPlayers[0].UIButtonBG = UIImage(FindChild('BGA0', true));
        TeamAPlayers[1].UIButtonBG = UIImage(FindChild('BGA1', true));
        TeamAPlayers[2].UIButtonBG = UIImage(FindChild('BGA2', true));
        TeamAPlayers[3].UIButtonBG = UIImage(FindChild('BGA3', true));
        TeamAPlayers[0].UIButtonBG.Position = TeamAPlayers[0].UIButton.Position;
        TeamAPlayers[1].UIButtonBG.Position = TeamAPlayers[1].UIButton.Position;
        TeamAPlayers[2].UIButtonBG.Position = TeamAPlayers[2].UIButton.Position;
        TeamAPlayers[3].UIButtonBG.Position = TeamAPlayers[3].UIButton.Position;
        TeamAPlayers[0].UIReadyCheckbox = UICheckbox(FindChild('chkReadyA1', true));
        TeamAPlayers[1].UIReadyCheckbox = UICheckbox(FindChild('chkReadyA2', true));
        TeamAPlayers[2].UIReadyCheckbox = UICheckbox(FindChild('chkReadyA3', true));
        TeamAPlayers[3].UIReadyCheckbox = UICheckbox(FindChild('chkReadyA4', true));
        TeamAPlayers[0].UIPlayerImage = UIImage(FindChild('imgTeam1Player1Char', true));
        TeamAPlayers[1].UIPlayerImage = UIImage(FindChild('imgTeam1Player2Char', true));
        TeamAPlayers[2].UIPlayerImage = UIImage(FindChild('imgTeam1Player3Char', true));
        TeamAPlayers[3].UIPlayerImage = UIImage(FindChild('imgTeam1Player4Char', true));
        TeamBPlayers[0].UIButton = UILabelButton(FindChild('btnTeam2Player1', true));
        TeamBPlayers[1].UIButton = UILabelButton(FindChild('btnTeam2Player2', true));
        TeamBPlayers[2].UIButton = UILabelButton(FindChild('btnTeam2Player3', true));
        TeamBPlayers[3].UIButton = UILabelButton(FindChild('btnTeam2Player4', true));
        TeamBPlayers[0].UIButtonBG = UIImage(FindChild('BGB0', true));
        TeamBPlayers[1].UIButtonBG = UIImage(FindChild('BGB1', true));
        TeamBPlayers[2].UIButtonBG = UIImage(FindChild('BGB2', true));
        TeamBPlayers[3].UIButtonBG = UIImage(FindChild('BGB3', true));
        TeamBPlayers[0].UIButtonBG.Position = TeamBPlayers[0].UIButton.Position;
        TeamBPlayers[1].UIButtonBG.Position = TeamBPlayers[1].UIButton.Position;
        TeamBPlayers[2].UIButtonBG.Position = TeamBPlayers[2].UIButton.Position;
        TeamBPlayers[3].UIButtonBG.Position = TeamBPlayers[3].UIButton.Position;
        TeamBPlayers[0].UIReadyCheckbox = UICheckbox(FindChild('chkReadyB1', true));
        TeamBPlayers[1].UIReadyCheckbox = UICheckbox(FindChild('chkReadyB2', true));
        TeamBPlayers[2].UIReadyCheckbox = UICheckbox(FindChild('chkReadyB3', true));
        TeamBPlayers[3].UIReadyCheckbox = UICheckbox(FindChild('chkReadyB4', true));
        TeamBPlayers[0].UIPlayerImage = UIImage(FindChild('imgTeam2Player1Char', true));
        TeamBPlayers[1].UIPlayerImage = UIImage(FindChild('imgTeam2Player2Char', true));
        TeamBPlayers[2].UIPlayerImage = UIImage(FindChild('imgTeam2Player3Char', true));
        TeamBPlayers[3].UIPlayerImage = UIImage(FindChild('imgTeam2Player4Char', true));
        TeamAPlayers[0].UIPlayerTalkingImage = UIImage(FindChild('imgTeam1Player1Talking', true));
        TeamAPlayers[1].UIPlayerTalkingImage = UIImage(FindChild('imgTeam1Player2Talking', true));
        TeamAPlayers[2].UIPlayerTalkingImage = UIImage(FindChild('imgTeam1Player3Talking', true));
        TeamAPlayers[3].UIPlayerTalkingImage = UIImage(FindChild('imgTeam1Player4Talking', true));
        TeamBPlayers[0].UIPlayerTalkingImage = UIImage(FindChild('imgTeam2Player1Talking', true));
        TeamBPlayers[1].UIPlayerTalkingImage = UIImage(FindChild('imgTeam2Player2Talking', true));
        TeamBPlayers[2].UIPlayerTalkingImage = UIImage(FindChild('imgTeam2Player3Talking', true));
        TeamBPlayers[3].UIPlayerTalkingImage = UIImage(FindChild('imgTeam2Player4Talking', true));
        I = 0;
        J0x88D:

        // End:0x93F [Loop If]
        if(I < 4)
        {
            TeamAPlayers[I].UIPlayerTalkingImage.SetVisibility(false);
            TeamBPlayers[I].UIPlayerTalkingImage.SetVisibility(false);
            TeamAPlayers[I].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
            TeamBPlayers[I].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
            I++;
            // [Loop Continue]
            goto J0x88D;
        }
        AssignOptionButtons();
        imageGameMap = UIImage(FindChild('imgLevel', true));
        imageHighlight = UIImage(FindChild('MenuHighlight', true));
        lblGameStatus = UILabel(FindChild('lblGameStatus', true));
        lblGameStatus.SetValue("");
        lblGameStatus.SetVisibility(true);
        bbHelperText = SPUIButtonBar(FindChild('SPUIButtonBar', true));
        lblTitle = UILabel(FindChild('lblTitle', true));
        bTitleInitialized = SetTitleLabel();
        BindInterfaceKeys();
        // End:0xAB0
        if(int(WI.NetMode) != int(NM_Standalone))
        {
            // End:0xA83
            if(int(WI.NetMode) == int(NM_Client))
            {
                // End:0xA78
                if((PGRI != none) && int(PGRI.GameStatus) == int(2))
                {
                    ControlMode = 3;                    
                }
                else
                {
                    ControlMode = 2;
                }                
            }
            else
            {
                // End:0xAA8
                if(int(PGRI.GameStatus) == int(1))
                {
                    ControlMode = 1;                    
                }
                else
                {
                    ControlMode = 0;
                }
            }
        }
        AddMPMapsToGameOptions();
        SyncMapSelection();
        // End:0xAEA
        if(int(ControlMode) == int(1))
        {
            // End:0xAE7
            if(bInitialActivation)
            {
                ClearReadyStatus();
            }            
        }
        else
        {
            UpdateReadyStatus();
        }
        InitControlMode(ControlMode);
        PopulateOptionMenu();
        // End:0xB36
        if(int(ControlMode) == int(0))
        {
            HandleLinkedOptions(FindOptionIndex(4));            
        }
        else
        {
            I = 0;
            J0xB3D:

            // End:0xBEF [Loop If]
            if(I < 4)
            {
                TeamAPlayers[I].UIPlayerTalkingImage.SetVisibility(false);
                TeamBPlayers[I].UIPlayerTalkingImage.SetVisibility(false);
                TeamAPlayers[I].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
                TeamBPlayers[I].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
                I++;
                // [Loop Continue]
                goto J0xB3D;
            }
            lblGameStatus.SetValue("");
            lblGameStatus.SetVisibility(true);
            UpdateTeamMenus();
        }
        DisablePlayer();
        TrackChat();
        SetFocus(btnOption[0].GetOwner());
        WI.Game.ClearPause();
        // End:0xCC0
        if(((PGRI != none) && int(PGRI.GameStatus) == int(2)) && !PGRI.IsInPostGame())
        {
            AddGameOption(JoinGameOption);
        }
        UpdateHeadsetState();
        UpdateAdvertisedData();
        imgWeaponA = UIImage(FindChild('imgWeaponA', true));
        imgWeaponB = UIImage(FindChild('imgWeaponB', true));
        imgWeaponC = UIImage(FindChild('imgWeaponC', true));
        lblWeaponA = UILabel(FindChild('lblWeaponA', true));
        lblWeaponB = UILabel(FindChild('lblWeaponB', true));
        lblWeaponC = UILabel(FindChild('lblWeaponC', true));
        lblWeaponCCount = UILabel(FindChild('lblWeaponCCount', true));
        lblWeaponA.SetVisibility(false);
        lblWeaponB.SetVisibility(false);
        lblWeaponC.SetVisibility(false);
        lblWeaponCCount.SetVisibility(false);
        btnReady = UILabelButton(FindChild('btnReady', true));
        btnBack = UILabelButton(FindChild('backbutton', true));
    }
    btnDownArrow = UILabelButton(FindChild('btnArrowDown', true));
    I = 0;
    J0xE3E:

    // End:0xEA0 [Loop If]
    if(I < 4)
    {
        TeamAPlayers[I].UIPlayerImage.SetVisibility(false);
        TeamBPlayers[I].UIPlayerImage.SetVisibility(false);
        I++;
        // [Loop Continue]
        goto J0xE3E;
    }
    UpdateWeaponLoadoutInfo();
    SetHelperLabel();
    LastMapID = -1;
    UpdateMapImage();
    LastShownPlayersRequired = 0;
    // End:0xF04
    if((int(ControlMode) == int(0)) || int(ControlMode) == int(1))
    {
        PGRI.bStartMatchCountdown = false;
    }
    //return;    
}

function SetGameOptionsState(bool bEnabled)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(I < GameOptions.Length)
    {
        GameOptions[I].bEnabled = bEnabled;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    PopulateOptionMenu();
    //return;    
}

function SetGameOptionState(int SearchID, bool bEnabled)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x61 [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x57
        if(int(GameOptions[I].Id) == SearchID)
        {
            GameOptions[I].bEnabled = bEnabled;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    PopulateOptionMenu();
    //return;    
}

function RemoveModesByConnectionType()
{
    // End:0x37
    if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        RemoveGameOptionByID(6);
        RemoveGameOptionByID(7);
    }
    // End:0x50
    if(IsSystemLinkMatch())
    {
        RemoveGameOptionByID(7);
    }
    //return;    
}

function RemoveModesByPlatform()
{
    // End:0x2F
    if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
    {
        RemoveGameOptionByID(6);
        RemoveGameOptionByID(7);
    }
    //return;    
}

function InitServerCreateMode()
{
    SetSlotVisibility(false);
    SetGameOptionsState(true);
    bOptionMenuEnabled = true;
    bTeamMenuEnabled = false;
    bBackoutEnabled = true;
    // End:0x59
    if(myGameInfo.bUsesArbitration)
    {
        RemoveGameOptionByID(6);
        RemoveGameOptionByID(7);
    }
    // End:0x72
    if(IsSystemLinkMatch())
    {
        RemoveGameOptionByID(7);
    }
    RemoveModesByPlatform();
    RemoveModesByConnectionType();
    //return;    
}

function AddGameOption(MPGameOption Option)
{
    local int I, Idx;

    I = 0;
    J0x07:

    // End:0x52 [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x48
        if(int(GameOptions[I].Id) == int(Option.Id))
        {
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x7E
    if(Option.bListedFirst)
    {
        GameOptions.Insert(0, 1);
        GameOptions[0] = Option;        
    }
    else
    {
        Idx = GameOptions.Length;
        GameOptions.Insert(Idx, 1);
        GameOptions[Idx] = Option;
    }
    //return;    
}

function InitServerWaitMode()
{
    local PandoraGameInfo PGI;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    SetSlotVisibility(true);
    RemoveGameOptionByID(1);
    RemoveGameOptionByID(7);
    SetGameOptionsState(true);
    AddGameOption(StartGameOption);
    // End:0x12E
    if((PGRI != none) && !PGRI.bStartMatchCountdown)
    {
        SetGameOptionState(2, true);
        SetGameOptionState(13, true);
        SetGameOptionState(4, true);
        SetGameOptionState(5, true);
        SetGameOptionState(8, true);
        SetGameOptionState(9, true);
        SetGameOptionState(11, true);
        SetGameOptionState(10, true);
        // End:0x108
        if(PGRI.bIsArbitrated)
        {
            SetGameOptionState(3, false);            
        }
        else
        {
            // End:0x121
            if(IsPCBuild())
            {
                SetGameOptionState(3, false);                
            }
            else
            {
                SetGameOptionState(3, true);
            }
        }
    }
    bOptionMenuEnabled = true;
    bTeamMenuEnabled = true;
    bBackoutEnabled = false;
    PGI = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x19B
    if(PGI != none)
    {
        ParseURL(PGI.GetLastURL());
        StoreRepOptionsInGRI();        
    }
    RemoveModesByPlatform();
    RemoveModesByConnectionType();
    //return;    
}

function InitClientMode()
{
    SetSlotVisibility(true);
    RemoveGameOptionByID(1);
    RemoveGameOptionByID(7);
    RemoveGameOptionByID(2);
    RemoveGameOptionByID(12);
    RemoveGameOptionByID(13);
    SetGameOptionsState(false);
    bOptionMenuEnabled = false;
    bTeamMenuEnabled = true;
    bBackoutEnabled = false;
    RetrieveRepOptionsFromGRI();
    RemoveModesByPlatform();
    RemoveModesByConnectionType();
    //return;    
}

function InitClientInProgressMode()
{
    InitClientMode();
    AddGameOption(JoinGameOption);
    RemoveModesByPlatform();
    RemoveModesByConnectionType();
    //return;    
}

function InitControlMode(UIScene_MPMenu.LobbyControlMode Mode)
{
    switch(Mode)
    {
        // End:0x1A
        case 0:
            InitServerCreateMode();
            // End:0x53
            break;
        // End:0x2C
        case 1:
            InitServerWaitMode();
            // End:0x53
            break;
        // End:0x3E
        case 2:
            InitClientMode();
            // End:0x53
            break;
        // End:0x50
        case 3:
            InitClientInProgressMode();
            // End:0x53
            break;
        // End:0xFFFF
        default:
            break;
    }
    SetHelperLabel();
    //return;    
}

function HandlePCInitialized()
{
    local PandoraPlayerController PC;

    PC = GetPC();
    // End:0x52
    if(!bPCInitialized)
    {
        // End:0x52
        if(PC != none)
        {
            DisablePlayer();
            GetPC().ServerAnnounceMessage(1);
            bPCInitialized = true;
        }
    }
    //return;    
}

function HandleGRIInitialized()
{
    local PandoraGRI PGRI;

    // End:0x99
    if(!bGRIInitialized)
    {
        PGRI = PandoraGRI(GetWorldInfo().GRI);
        // End:0x99
        if(((PGRI != none) && !IsLevelStillStreaming()) && int(PGRI.GameStatus) != int(5))
        {
            GetPC().ClientLoadingScreen(false);
            UpdateWeaponLoadoutInfo();
            bGRIInitialized = true;
            UpdateAdvertisedData(true);
        }
    }
    //return;    
}

function bool IsLevelStillStreaming()
{
    local int LevelIndex;
    local LevelStreaming TheLevel;
    local WorldInfo WI;
    local bool bResult;

    WI = GetWorldInfo();
    bResult = false;
    // End:0xBB
    if((int(WI.NetMode) != int(NM_Standalone)) && WI.StreamingLevels.Length > 0)
    {
        LevelIndex = 0;
        J0x51:

        // End:0xBB [Loop If]
        if(LevelIndex < WI.StreamingLevels.Length)
        {
            TheLevel = WI.StreamingLevels[LevelIndex];
            // End:0xB1
            if(TheLevel != none)
            {
                // End:0xB1
                if(!TheLevel.bIsVisible)
                {
                    bResult = true;
                    // [Explicit Break]
                    goto J0xBB;
                }
            }
            LevelIndex++;
            // [Loop Continue]
            goto J0x51;
        }
    }
    J0xBB:

    return bResult;
    //return ReturnValue;    
}

function bool DidAllPlayersSkipIntermission()
{
    local bool bResult;
    local int I;
    local SPPlayerReplicationInfo SPPRI;
    local GameReplicationInfo GRI;

    GRI = GetWorldInfo().GRI;
    I = 0;
    J0x21:

    // End:0x92 [Loop If]
    if(I < GRI.PRIArray.Length)
    {
        SPPRI = SPPlayerReplicationInfo(GRI.PRIArray[I]);
        // End:0x88
        if((SPPRI != none) && !SPPRI.bSkippedIntermission)
        {
            bResult = true;
            // [Explicit Break]
            goto J0x92;
        }
        I++;
        // [Loop Continue]
        goto J0x21;
    }
    J0x92:

    return !bResult;
    //return ReturnValue;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    local PandoraGRI PGRI;
    local OnlineSubsystem.ELoginStatus Status;
    local int NumPlayersNeeded;
    local PandoraPlayerController PC;
    local SPPlayerReplicationInfo SPPRI;
    local SPGameUISceneClient SPSceneClient;

    // End:0xAD
    if(IsPCBuild())
    {
        SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
        ClearActiveOptionStates();
        // End:0xAD
        if((LastMousePos.X != SPSceneClient.MousePosition.X) || LastMousePos.Y != SPSceneClient.MousePosition.Y)
        {
            SetSelectionToHighlight();
            LastMousePos = SPSceneClient.MousePosition;
        }
    }
    NumPlayersNeeded = (GetMinimumPlayerCount()) - (GetNumPlayersInLobby());
    // End:0xDB
    if(NumPlayersNeeded < 0)
    {
        NumPlayersNeeded = 0;
    }
    // End:0x1C3
    if(NumPlayersNeeded != LastShownPlayersRequired)
    {
        LastShownPlayersRequired = NumPlayersNeeded;
        // End:0x115
        if(NumPlayersNeeded == 0)
        {
            lblGameStatus.SetValue("");            
        }
        else
        {
            lblGameStatus.SetValue(("<Strings:PandoraGame.UIScene_PandoraLobbyMP.MinimumPlayersStatusPrefix>" @ string(NumPlayersNeeded)) @ "<Strings:PandoraGame.UIScene_PandoraLobbyMP.MinimumPlayersStatusPostfix>");
        }
    }
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x1ED
    if(PGRI == none)
    {
    }
    // End:0x222
    if(PGRI.IsInPostGame() && int(ControlMode) == int(3))
    {
        RemoveGameOptionByID(12);
    }
    // End:0x248
    if(!bTitleInitialized)
    {
        bTitleInitialized = SetTitleLabel();
        SetHelperLabel();
    }
    HandlePCInitialized();
    // End:0x2A2
    if(((int(ControlMode) == int(2)) && PGRI != none) && int(PGRI.GameStatus) == int(2))
    {
        ControlMode = 3;
        InitControlMode(ControlMode);
    }
    TeamMenuRefreshDeltaAccum += DeltaTime;
    // End:0x363
    if(TeamMenuRefreshDeltaAccum >= 0.1000000)
    {
        // End:0x2DF
        if(!bMapListUpdated)
        {
            AddMPMapsToGameOptions();
            SyncMapSelection();            
        }
        // End:0x2F9
        if(int(ControlMode) != int(0))
        {
            UpdateTeamsWithPlayers();
        }
        // End:0x358
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            RetrieveRepOptionsFromGRI();
            PopulateOptionMenu();
            // End:0x358
            if((PGRI != none) && int(PGRI.GameStatus) == int(0))
            {
                ExitToStartMenuLevel();
            }
        }
        TeamMenuRefreshDeltaAccum = 0.0000000;
    }
    // End:0x565
    if(((PGRI != none) && PGRI.bStartMatchCountdown) && int(PGRI.GameStatus) != int(2))
    {
        Status = GetLoginStatus(LocPlayer.ControllerId);
        // End:0x3F5
        if((int(Status) != int(1)) && int(Status) != int(2))
        {
            PGRI.bStartMatchCountdown = false;            
        }
        else
        {
            // End:0x52E
            if((!HasMinimumPlayers() && !IsSwitchingMap()) && int(WorldInfo.NetMode) == int(NM_ListenServer))
            {
                ShowMsgBox(("<Strings:PandoraGame.UIScene_PandoraLobbyMP.MinimumPlayersPrefix>" @ string(GetMinimumPlayerCount())) @ "<Strings:PandoraGame.UIScene_PandoraLobbyMP.MinimumPlayersPostfix>", "<Strings:PandoraGame.UIScene_PandoraLobbyMP.MinimumPlayersTitle>");
                PGRI.bStartMatchCountdown = false;                
            }
            else
            {
                CountdownRefreshDeltaAccum += DeltaTime;
                // End:0x565
                if(CountdownRefreshDeltaAccum >= float(GetCountdownRefreshTime()))
                {
                    UpdateStartCountdown();
                    CountdownRefreshDeltaAccum = 0.0000000;
                }
            }
        }
    }
    LastCheckForHeadsetTime += DeltaTime;
    // End:0x595
    if(LastCheckForHeadsetTime >= 1.5000000)
    {
        UpdateHeadsetState();
        LastCheckForHeadsetTime = 0.0000000;
    }
    // End:0x5DA
    if(int(ControlMode) != int(0))
    {
        // End:0x5CB
        if(int(ControlMode) == int(1))
        {
            SetGameOptionState(2, DidAllPlayersSkipIntermission());
        }
        UpdateTalking(DeltaTime);
    }
    PC = GetPC();
    // End:0x671
    if(PC != none)
    {
        // End:0x629
        if(PC.PlayerReplicationInfo.Team.TeamIndex == RequestedTeamID)
        {
            RequestedTeamID = 0;
        }
        SPPRI = SPPlayerReplicationInfo(PC.PlayerReplicationInfo);
        // End:0x651
        if(SPPRI == none)
        {            
        }
        else
        {
            // End:0x671
            if(SPPRI.AppearanceIdx == RequestedAppearanceID)
            {
                RequestedAppearanceID = 0;
            }
        }
    }
    HandleGRIInitialized();
    // End:0x6A3
    if(OptionMenuSelIdx != -1)
    {
        SetActiveButton(GetButtonIndexFromOptionIndex(OptionMenuSelIdx));
    }
    //return;    
}

function int GetCountdownRefreshTime()
{
    // End:0x12
    if(int(ControlMode) == int(1))
    {
        return 1;
    }
    return int(0.1000000);
    //return ReturnValue;    
}

function bool StoreRepOptionInGRI(int Id)
{
    local int I;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return false;
    }
    I = 0;
    J0x33:

    // End:0xBD [Loop If]
    if(I < PGRI.NumRepLobbyOptions)
    {
        // End:0xB3
        if(PGRI.GetRepLobbyOptionID(I) == int(GameOptions[Id].Id))
        {
            PGRI.SetRepLobbyModeID(I, GameOptions[Id].CurMode);
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x33;
    }
    return false;
    //return ReturnValue;    
}

function StoreRepOptionsInGRI()
{
    local int I;
    local PandoraGRI PGRI;
    local int Idx;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    Idx = 0;
    I = 0;
    J0x3A:

    // End:0xBC [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0xB2
        if(GameOptions[I].bReplicated)
        {
            PGRI.SetRepLobbyData(Idx, int(GameOptions[I].Id), GameOptions[I].CurMode);
            Idx++;
        }
        I++;
        // [Loop Continue]
        goto J0x3A;
    }
    J0xBC:

    // End:0xFD [Loop If]
    if(Idx < PGRI.NumRepLobbyOptions)
    {
        PGRI.SetRepLobbyOptionID(Idx, -1);
        Idx++;
        // [Loop Continue]
        goto J0xBC;
    }
    PGRI.bNetDirty = true;
    PGRI.bForceNetUpdate = true;
    //return;    
}

function RetrieveRepOptionsFromGRI()
{
    local int I, J;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    I = 0;
    J0x33:

    // End:0xDD [Loop If]
    if(I < PGRI.NumRepLobbyOptions)
    {
        J = 0;
        J0x53:

        // End:0xD3 [Loop If]
        if(J < GameOptions.Length)
        {
            // End:0xC9
            if(int(GameOptions[J].Id) == PGRI.GetRepLobbyOptionID(I))
            {
                GameOptions[J].CurMode = PGRI.GetRepLobbyModeID(I);
            }
            J++;
            // [Loop Continue]
            goto J0x53;
        }
        I++;
        // [Loop Continue]
        goto J0x33;
    }
    //return;    
}

function int FindSlotAIdxFromPRI(SPPlayerReplicationInfo PRI)
{
    local PandoraGRI PGRI;
    local int I;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x30
    if(PGRI == none)
    {
        return -1;
    }
    I = 0;
    J0x37:

    // End:0xA8 [Loop If]
    if(I < 4)
    {
        // End:0x9E
        if(TeamAPlayers[I].PRIIdx != -1)
        {
            // End:0x9E
            if(SPPlayerReplicationInfo(PGRI.PRIArray[TeamAPlayers[I].PRIIdx]) == PRI)
            {
                return I;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x37;
    }
    return -1;
    //return ReturnValue;    
}

function int FindSlotBIdxFromPRI(SPPlayerReplicationInfo PRI)
{
    local PandoraGRI PGRI;
    local int I;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x30
    if(PGRI == none)
    {
        return -1;
    }
    I = 0;
    J0x37:

    // End:0xA8 [Loop If]
    if(I < 4)
    {
        // End:0x9E
        if(TeamBPlayers[I].PRIIdx != -1)
        {
            // End:0x9E
            if(SPPlayerReplicationInfo(PGRI.PRIArray[TeamAPlayers[I].PRIIdx]) == PRI)
            {
                return I;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x37;
    }
    return -1;
    //return ReturnValue;    
}

function int FindSlotIdxFromPRI(SPPlayerReplicationInfo PRI, out int Team)
{
    local int Idx;

    Idx = FindSlotAIdxFromPRI(PRI);
    // End:0x47
    if(Idx == -1)
    {
        Idx = FindSlotBIdxFromPRI(PRI);
        Team = 2;
        return Idx;
    }
    Team = 1;
    return Idx;
    //return ReturnValue;    
}

function SPPlayerReplicationInfo GetPRIFromTeamSlotIdx(int TeamID, int SlotIdx)
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return none;
    }
    // End:0x66
    if(TeamID == 1)
    {
        return SPPlayerReplicationInfo(PGRI.PRIArray[TeamAPlayers[SlotIdx].PRIIdx]);        
    }
    else
    {
        // End:0x9E
        if(TeamID == 2)
        {
            return SPPlayerReplicationInfo(PGRI.PRIArray[TeamBPlayers[SlotIdx].PRIIdx]);
        }
    }
    return none;
    //return ReturnValue;    
}

function bool RequiresNetworkUpdates()
{
    return true;
    //return ReturnValue;    
}

function int FindOptionIndex(UIScene_MPMenu.MenuOptionID moid)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4B [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x41
        if(int(GameOptions[I].Id) == int(moid))
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function SyncMapSelection()
{
    local int MapOptionID;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x9B
    if(PGRI != none)
    {
        // End:0x98
        if((int(ControlMode) == int(2)) || int(ControlMode) == int(3))
        {
            MapOptionID = FindOptionIndex(3);
            GameOptions[MapOptionID].CurMode = PGRI.GetRepLobbyModeForOptionID(MapOptionID);
            PopulateOptionMenu();
        }        
    }
    //return;    
}

function AddMPMapsToGameOptions()
{
    local PandoraGRI PGRI;
    local int I, MapOptionID, NewModeID, MapContext, Idx;

    local UIProviderScriptFieldValue MapNameValue, FriendlyMapNameValue, DebugMapValue, PreviewImageValue;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2E7
    if(PGRI != none)
    {
        MapOptionID = FindOptionIndex(3);
        // End:0x4D
        if(MapOptionID == -1)
        {
            return;
        }
        MapPreviewTextures.Length = 0;
        GameOptions[MapOptionID].Modes.Length = 0;
        MapContext = 1;
        I = 0;
        J0x7C:

        // End:0x2CD [Loop If]
        if(I < NumberOfMaps)
        {
            GameResourceDataStore.GetProviderFieldValue('MultiplayerMaps', 'bDebugMap', I, DebugMapValue);
            // End:0xED
            if(!PGRI.bAllowDebugMaps && bool(DebugMapValue.StringValue))
            {
                MapContext++;
                // [Explicit Continue]
                goto J0x2C3;
            }
            GameResourceDataStore.GetProviderFieldValue('MultiplayerMaps', 'MapName', I, MapNameValue);
            GameResourceDataStore.GetProviderFieldValue('MultiplayerMaps', 'FriendlyMapName', I, FriendlyMapNameValue);
            GameResourceDataStore.GetProviderFieldValue('MultiplayerMaps', 'MapPreviewImage', I, PreviewImageValue);
            Idx = MapPreviewTextures.Length;
            MapPreviewTextures.Insert(Idx, 1);
            MapPreviewTextures[Idx] = Texture2D(DynamicLoadObject(PreviewImageValue.StringValue, Class'Engine.Texture2D'));
            NewModeID = GameOptions[MapOptionID].Modes.Length;
            GameOptions[MapOptionID].Modes.Insert(NewModeID, 1);
            GameOptions[MapOptionID].Modes[NewModeID].ModeName = FriendlyMapNameValue.StringValue;
            GameOptions[MapOptionID].Modes[NewModeID].ModeOption = "MapId";
            GameOptions[MapOptionID].Modes[NewModeID].ModeValue = MapNameValue.StringValue;
            GameOptions[MapOptionID].Modes[NewModeID].ContextID = MapContext;
            MapContext++;
            J0x2C3:

            I++;
            // [Loop Continue]
            goto J0x7C;
        }
        SetDefaultsForMapChanges(MapOptionID);
        bMapListUpdated = true;        
    }
    else
    {
        bMapListUpdated = false;
    }
    //return;    
}

function bool IsSwitchingMap()
{
    local string MapName;

    MapName = GetWorldInfo().GetMapName();
    // End:0x38
    if(Locs(MapName) == Locs(GetOptionValue(3)))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function LobbyBeginGame()
{
    local PandoraGameInfo PGI;
    local PandoraGRI PGRI;
    local PandoraPlayerController PC;
    local SPPlayerReplicationInfo SPPRI;

    PGI = PandoraGameInfo(GetWorldInfo().Game);
    PC = GetPC();
    // End:0x77
    if(PC != none)
    {
        SPPRI = SPPlayerReplicationInfo(PC.PlayerReplicationInfo);
        // End:0x74
        if(SPPRI != none)
        {
            SPPRI.bHostIsReady = true;            
        }        
    }
    // End:0xD6
    if(IsSwitchingMap())
    {
        // End:0xD4
        if(DidAllPlayersSkipIntermission())
        {
            PGI.KillPlayers(false);
            ClearReadyStatus();
            GetWorldInfo().ServerTravel(BuildURL());
        }
        return;
    }
    AssignAppearances();
    // End:0xED
    if(PGI == none)
    {
        return;
    }
    PGI.CloseLobby();
    SceneClient.CloseScene(self);
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x13F
    if(PGRI == none)
    {
        return;
    }
    PGRI.MonsterMachineMaximum = int(GetOptionValue(8));
    PGRI.RadarMode = byte(int(GetOptionValue(9)));
    PGRI.RespawnTimer = float(GetOptionValue(11));
    // End:0x1C4
    if((GetOptionValue(10)) == "1")
    {
        PGRI.bAlphasEnabled = true;        
    }
    else
    {
        PGRI.bAlphasEnabled = false;
    }
    PGRI.GameStatus = 2;
    PGRI.bStartMatchCountdown = false;
    PC = GetPC();
    // End:0x229
    if(PC != none)
    {
        PC.ClientSetOnlineStatus();
    }
    InitMatchValues();
    TriggerMatchStartEvents();
    //return;    
}

function AssignMatchSettings()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x86
    if(PGRI != none)
    {
        PGRI.MonsterMachineMaximum = int(GetOptionValue(8));
        PGRI.RadarMode = byte(int(GetOptionValue(9)));
        PGRI.RespawnTimer = float(GetOptionValue(11));
    }
    //return;    
}

function UpdateStartCountdown()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    // End:0x71
    if(int(ControlMode) == int(1))
    {
        PGRI.LobbyStartTimeRemaining--;
        PGRI.bNetDirty = true;
        PGRI.bForceNetUpdate = true;
    }
    // End:0xCA
    if(!IsSwitchingMap())
    {
        lblGameStatus.SetValue("<Strings:PandoraGame.UIScene_PandoraLobbyMP.Starting>");        
    }
    else
    {
        // End:0x10E
        if(int(ControlMode) != int(0))
        {
            lblGameStatus.SetValue(SwitchingMapString @ (GetOptionModeName(3)));
            PGRI.LobbyStartTimeRemaining = 0;
        }
    }
    // End:0x13F
    if((PGRI.LobbyStartTimeRemaining <= 0) && int(ControlMode) == int(1))
    {
        LobbyBeginGame();
    }
    //return;    
}

function bool PlayersAreReady()
{
    local PandoraGRI PGRI;
    local int I;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return false;
    }
    I = 0;
    J0x33:

    // End:0xF9 [Loop If]
    if(I < 4)
    {
        // End:0x97
        if(TeamAPlayers[I].PRIIdx != -1)
        {
            // End:0x97
            if(!PGRI.PRIArray[TeamAPlayers[I].PRIIdx].bReadyToPlay)
            {
                return false;
            }
        }
        // End:0xEF
        if(TeamBPlayers[I].PRIIdx != -1)
        {
            // End:0xEF
            if(!PGRI.PRIArray[TeamBPlayers[I].PRIIdx].bReadyToPlay)
            {
                return false;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x33;
    }
    return true;
    //return ReturnValue;    
}

function CheckMinimumPlayers()
{
    // End:0x12B
    if((!HasMinimumPlayers() && !IsSwitchingMap()) && int(GetWorldInfo().NetMode) == int(NM_ListenServer))
    {
        ShowMsgBox(("<Strings:PandoraGame.UIScene_PandoraLobbyMP.MinimumPlayersPrefix>" @ string(GetMinimumPlayerCount())) @ "<Strings:PandoraGame.UIScene_PandoraLobbyMP.MinimumPlayersPostfix>", "<Strings:PandoraGame.UIScene_PandoraLobbyMP.MinimumPlayersTitle>");
        return;
    }
    //return;    
}

function OnKickResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x41
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        // End:0x41
        if(KickedPC != none)
        {
            KickedPC.ClientWasKicked();
        }
    }
    KickedPC = none;
    //return;    
}

function LobbyStartMatch(UIScene_MPMenu.MenuOptionID OptionID)
{
    local PandoraGRI PGRI;
    local PandoraPlayerController PPC, PC;

    // End:0x1A
    if(!IsSwitchingMap())
    {
        ToggleReadyFlag(true);
    }
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x46
    if(PGRI == none)
    {
        return;
    }
    // End:0x366
    if(int(OptionID) == int(2))
    {
        // End:0x28E
        if(!IsSwitchingMap())
        {
            // End:0x10C
            if(!PlayersAreReady())
            {
                ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraLobbyMP.NotAllPlayersReady>", "<Strings:PandoraGame.UIScene_PandoraLobbyMP.NotAllPlayersReadyTitle>");
                return;
            }
            CheckMinimumPlayers();
            // End:0x1E8
            if(GetWorldInfo().Game.GameSettings.bUsesArbitration)
            {
                // End:0x1E5
                if(!IsTeamAcceptablyBalanced())
                {
                    ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraLobbyMP.TeamsNotBalanced>", "<Strings:PandoraGame.UIScene_PandoraLobbyMP.TeamsNotBalancedTitle>");
                    return;
                }                
            }
            else
            {
                // End:0x28B
                if(!IsTeamMinimallyBalanced())
                {
                    ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraLobbyMP.TeamsNotBalanced>", "<Strings:PandoraGame.UIScene_PandoraLobbyMP.TeamsNotBalancedTitle>");
                    return;
                }
            }            
        }
        else
        {
            // End:0x365
            foreach GetWorldInfo().AllControllers(Class'PandoraPlayerController', PC)
            {
                // End:0x364
                if(!PC.HasClientLoadedCurrentWorld())
                {
                    ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraLobbyMP.PromptWaitForTraveler>", "<Strings:PandoraGame.UIScene_PandoraLobbyMP.PromptWaitForTravelerTitle>");                    
                    return;
                }                
            }            
        }
    }
    PGRI.LobbyStartTimeRemaining = NumSecsToStartMatch;
    PGRI.bStartMatchCountdown = true;
    SetGameOptionsState(false);
    PGRI.bNetDirty = true;
    PGRI.bForceNetUpdate = true;
    PPC = GetPC();
    // End:0x3EB
    if(PPC != none)
    {
        PPC.ServerSetTrackingOnDisconnect();
    }
    //return;    
}

function JoinGameInProgress()
{
    GetPC().ServerAnnounceMessage(3);
    CloseScene(self);
    //return;    
}

function EnablePlayer()
{
    local PandoraPlayerController PC;

    PC = GetPC();
    // End:0x1B
    if(PC == none)
    {
    }
    PC.ServerEnablePawn();
    // End:0x62
    if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        PC.ServerRestartPlayer();
    }
    //return;    
}

function DisablePlayer()
{
    local PandoraPlayerController PC;

    PC = GetPC();
    // End:0x1B
    if(PC == none)
    {
    }
    PC.ServerDisablePawn();
    //return;    
}

event SceneDeactivated()
{
    EnablePlayer();
    DisableMPLoadingScreen();
    super(UIScene_BaseFrontEnd).SceneDeactivated();
    //return;    
}

function AssignGameSettings()
{
    local PandoraGameInfo PGI;
    local PandoraDMOnlineGameSettings POGS;
    local int I;

    PGI = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x2F
    if(PGI == none)
    {
        return;        
    }
    else
    {
        POGS = PandoraDMOnlineGameSettings(GetWorldInfo().Game.GameSettings);
        // End:0x7F
        if(POGS == none)
        {
            POGS = PGI.InitOnlineGameSettings();
        }
    }
    I = 0;
    J0x86:

    // End:0x11D [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x113
        if(GameOptions[I].bPublished)
        {
            POGS.SetStringSettingValue(GameOptions[I].ContextID, GameOptions[I].Modes[GameOptions[I].CurMode].ContextID, false);
        }
        I++;
        // [Loop Continue]
        goto J0x86;
    }
    // End:0x142
    if(myGameInfo.bLanMatch)
    {
        POGS.bIsLanMatch = true;
    }
    // End:0x167
    if(myGameInfo.bUsesArbitration)
    {
        POGS.bUsesArbitration = true;
    }
    POGS.CreatureDensity = int(GetOptionValue(4));
    // End:0x1E5
    if(int(GetWorldInfo().NetMode) == int(NM_Standalone))
    {
        POGS.NumPrivateConnections = int(GetOptionValue(6));
        POGS.NumPublicConnections = 8 - POGS.NumPrivateConnections;
    }
    //return;    
}

function OnPlayerTalking(UniqueNetId TalkingPlayer)
{
    local SPPlayerReplicationInfo TalkerPRI;
    local int I;

    TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
    // End:0x1D4
    if(TalkerPRI != none)
    {
        I = 0;
        J0x27:

        // End:0xFA [Loop If]
        if(I < 4)
        {
            // End:0xF0
            if((CanCommunicate(TalkingPlayer)) && TalkerPRI.PlayerName == TeamAPlayers[I].UIButton.GetCaption())
            {
                TalkerPRI.SetPlayerTalking(true);
                TeamAPlayers[I].bTalking = true;
                TeamAPlayers[I].TalkingTimer = 1.0000000;
                TeamAPlayers[I].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Enabled', 0);
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x27;
        }
        I = 0;
        J0x101:

        // End:0x1D4 [Loop If]
        if(I < 4)
        {
            // End:0x1CA
            if((CanCommunicate(TalkingPlayer)) && TalkerPRI.PlayerName == TeamBPlayers[I].UIButton.GetCaption())
            {
                TalkerPRI.SetPlayerTalking(true);
                TeamBPlayers[I].bTalking = true;
                TeamBPlayers[I].TalkingTimer = 1.0000000;
                TeamBPlayers[I].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Enabled', 0);
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x101;
        }
    }
    //return;    
}

function UpdateTalking(float DeltaTime)
{
    local PandoraGRI PGRI;
    local SPPlayerReplicationInfo SPPRI;
    local TeamInfo tm_info;
    local int I, TeamAIdx, TeamBIdx;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    TeamAIdx = 0;
    TeamBIdx = 0;
    I = 0;
    J0x41:

    // End:0x473 [Loop If]
    if(I < PGRI.PRIArray.Length)
    {
        // End:0x469
        if(PGRI.PRIArray[I] != none)
        {
            tm_info = PGRI.PRIArray[I].Team;
            // End:0x283
            if((tm_info != none) && tm_info.TeamIndex == 1)
            {
                // End:0xCC
                if(TeamAIdx > 4)
                {
                    // [Explicit Continue]
                    goto J0x469;
                }
                SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[I]);
                // End:0x1F6
                if(SPPRI != none)
                {
                    TeamAPlayers[TeamAIdx].UIPlayerTalkingImage.SetVisibility(SPPRI.bHeadsetPresent);
                    // End:0x1F3
                    if(TeamAPlayers[TeamAIdx].bTalking)
                    {
                        TeamAPlayers[TeamAIdx].TalkingTimer -= DeltaTime;
                        // End:0x1F3
                        if(TeamAPlayers[TeamAIdx].TalkingTimer <= float(0))
                        {
                            SPPRI.SetPlayerTalking(false);
                            TeamAPlayers[TeamAIdx].bTalking = false;
                            TeamAPlayers[TeamAIdx].TalkingTimer = 0.0000000;
                            TeamAPlayers[TeamAIdx].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
                        }
                    }                    
                }
                else
                {
                    TeamAPlayers[TeamAIdx].bTalking = false;
                    TeamAPlayers[TeamAIdx].TalkingTimer = 0.0000000;
                    TeamAPlayers[TeamAIdx].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
                    TeamAPlayers[TeamAIdx].UIPlayerTalkingImage.SetVisibility(false);
                }
                TeamAIdx++;
                // [Explicit Continue]
                goto J0x469;
            }
            // End:0x469
            if((tm_info != none) && tm_info.TeamIndex == 2)
            {
                // End:0x2B5
                if(TeamBIdx > 4)
                {
                    // [Explicit Continue]
                    goto J0x469;
                }
                SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[I]);
                // End:0x3DF
                if(SPPRI != none)
                {
                    TeamBPlayers[TeamBIdx].UIPlayerTalkingImage.SetVisibility(SPPRI.bHeadsetPresent);
                    // End:0x3DC
                    if(TeamBPlayers[TeamBIdx].bTalking)
                    {
                        TeamBPlayers[TeamBIdx].TalkingTimer -= DeltaTime;
                        // End:0x3DC
                        if(TeamBPlayers[TeamBIdx].TalkingTimer <= float(0))
                        {
                            SPPRI.SetPlayerTalking(false);
                            TeamBPlayers[TeamBIdx].bTalking = false;
                            TeamBPlayers[TeamBIdx].TalkingTimer = 0.0000000;
                            TeamBPlayers[TeamBIdx].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
                        }
                    }                    
                }
                else
                {
                    TeamBPlayers[TeamBIdx].bTalking = false;
                    TeamBPlayers[TeamBIdx].TalkingTimer = 0.0000000;
                    TeamBPlayers[TeamBIdx].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
                    TeamBPlayers[TeamBIdx].UIPlayerTalkingImage.SetVisibility(false);
                }
                TeamBIdx++;
            }
        }
        J0x469:

        I++;
        // [Loop Continue]
        goto J0x41;
    }
    I = TeamAIdx;
    J0x47E:

    // End:0x517 [Loop If]
    if(I < 4)
    {
        TeamAPlayers[I].bTalking = false;
        TeamAPlayers[I].TalkingTimer = 0.0000000;
        TeamAPlayers[I].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
        TeamAPlayers[I].UIPlayerTalkingImage.SetVisibility(false);
        I++;
        // [Loop Continue]
        goto J0x47E;
    }
    I = TeamBIdx;
    J0x522:

    // End:0x5BB [Loop If]
    if(I < 4)
    {
        TeamBPlayers[I].bTalking = false;
        TeamBPlayers[I].TalkingTimer = 0.0000000;
        TeamBPlayers[I].UIPlayerTalkingImage.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
        TeamBPlayers[I].UIPlayerTalkingImage.SetVisibility(false);
        I++;
        // [Loop Continue]
        goto J0x522;
    }
    //return;    
}

function Cleanup()
{
    super(UIScene_BaseFrontEnd).Cleanup();
    IgnoreChat();
    //return;    
}

function int GetPublishedOptionCount()
{
    local int I, Count;

    I = 0;
    J0x07:

    // End:0x42 [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x38
        if(GameOptions[I].bPublished)
        {
            Count++;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return Count;
    //return ReturnValue;    
}

function SavePublishedOptionStates()
{
    local int CurPublishedOption, nPublishedOptions, I;

    nPublishedOptions = GetPublishedOptionCount();
    // End:0x39
    if(LastPublishedOptionModeIdx.Length < nPublishedOptions)
    {
        LastPublishedOptionModeIdx.Insert(LastPublishedOptionModeIdx.Length, nPublishedOptions - LastPublishedOptionModeIdx.Length);
    }
    CurPublishedOption = 0;
    I = 0;
    J0x47:

    // End:0xA4 [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x9A
        if(GameOptions[I].bPublished)
        {
            LastPublishedOptionModeIdx[CurPublishedOption] = GameOptions[I].CurMode;
            CurPublishedOption++;
        }
        I++;
        // [Loop Continue]
        goto J0x47;
    }
    //return;    
}

function bool HavePublishedOptionsChanged()
{
    local int CurPublishedOption, I;

    CurPublishedOption = 0;
    I = 0;
    J0x0E:

    // End:0x86 [Loop If]
    if(I < GameOptions.Length)
    {
        // End:0x7C
        if(GameOptions[I].bPublished)
        {
            // End:0x4D
            if(LastPublishedOptionModeIdx.Length < (CurPublishedOption + 1))
            {
                return true;
            }
            // End:0x75
            if(GameOptions[I].CurMode != LastPublishedOptionModeIdx[CurPublishedOption])
            {
                return true;
            }
            CurPublishedOption++;
        }
        I++;
        // [Loop Continue]
        goto J0x0E;
    }
    return false;
    //return ReturnValue;    
}

function UpdateAdvertisedData(optional bool bForceUpdate = false)
{
    local MPGameOption opt;
    local PandoraPlayerController PC;
    local bool bDoStatusUpdate;
    local int NumPrivateSlots;
    local bool bGameSettingsAssigned;

    bDoStatusUpdate = bForceUpdate;
    bGameSettingsAssigned = false;
    PC = GetPC();
    // End:0x37
    if(PC == none)
    {
        return;
    }
    // End:0xBF
    if(GetGameOptionByID(3, opt))
    {
        // End:0xBF
        if(LastMapID != opt.CurMode)
        {
            PC.m_AdvertisedMap = opt.Modes[opt.CurMode].ModeValue;
            bDoStatusUpdate = true;
            LastMapID = opt.CurMode;
        }
    }
    // End:0xFB
    if((HavePublishedOptionsChanged()) || bForceUpdate)
    {
        AssignGameSettings();
        bGameSettingsAssigned = true;
        bDoStatusUpdate = true;
        SavePublishedOptionStates();
    }
    NumPrivateSlots = int(GetOptionValue(6));
    // End:0x158
    if(LastNumPrivateConnections != NumPrivateSlots)
    {
        bDoStatusUpdate = true;
        PC.m_bShouldRefreshOnlineStatus = true;
        LastNumPrivateConnections = NumPrivateSlots;
        // End:0x158
        if(!bGameSettingsAssigned)
        {
            AssignGameSettings();
        }
    }
    // End:0x175
    if(bDoStatusUpdate)
    {
        PC.ClientSetOnlineStatus();
    }
    //return;    
}

function UpdateWeaponLoadoutInfo()
{
    local PandoraGRI PGRI;
    local PandoraPlayerController PC;
    local SPPlayerReplicationInfo SPPRI;
    local int CurProfile, PriWeaponA, PriWeaponB, SecWeapon;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    PC = GetPC();
    // End:0x49
    if(PC == none)
    {
        return;
    }
    SPPRI = SPPlayerReplicationInfo(PC.PlayerReplicationInfo);
    CurProfile = SPPRI.WeaponConfigIdx;
    PriWeaponA = int(PGRI.WeaponProfiles[CurProfile].PriWeaponA);
    PriWeaponB = int(PGRI.WeaponProfiles[CurProfile].PriWeaponB);
    SecWeapon = int(PGRI.WeaponProfiles[CurProfile].SecWeapon);
    // End:0x236
    if(WeaponConfigScene != none)
    {
        // End:0x11F
        if(PriWeaponA == 5)
        {
            imgWeaponA.SetVisibility(false);            
        }
        else
        {
            imgWeaponA.SetValue(WeaponConfigScene.PriWeapons[PriWeaponA].Tex);
            imgWeaponA.SetVisibility(true);
        }
        // End:0x188
        if(PriWeaponB == 5)
        {
            imgWeaponB.SetVisibility(false);            
        }
        else
        {
            imgWeaponB.SetValue(WeaponConfigScene.PriWeapons[PriWeaponB].Tex);
            imgWeaponB.SetVisibility(true);
        }
        // End:0x1F1
        if(SecWeapon == 5)
        {
            imgWeaponC.SetVisibility(false);            
        }
        else
        {
            imgWeaponC.SetValue(WeaponConfigScene.SecWeapons[SecWeapon].Tex);
            imgWeaponC.SetVisibility(true);
        }
    }
    //return;    
}

function FocusOnReadyButton()
{
    SetFocus(btnReady.GetOwner());
    ClearActiveOptionStates();
    OptionMenuSelIdx = -1;
    btnReady.StringRenderComponent.SetColor(SelectColor);
    btnReady.ActivateStateByClass(Class'Engine.UIState_Active', 0);
    //return;    
}

function FocusOnBackButton()
{
    SetFocus(btnBack.GetOwner());
    ClearActiveOptionStates();
    OptionMenuSelIdx = -1;
    btnBack.StringRenderComponent.SetColor(SelectColor);
    btnBack.ActivateStateByClass(Class'Engine.UIState_Active', 0);
    //return;    
}

function TriggerMatchStartEvents()
{
    local int Idx;
    local SeqEvent_SpMPMatchStarted StartEvent;
    local array<SequenceObject> Events;
    local PandoraPlayerController PC;

    PC = GetPC();
    // End:0xCE
    if(GetWorldInfo().GetGameSequence() != none)
    {
        GetWorldInfo().GetGameSequence().FindSeqObjectsByClass(Class'SeqEvent_SpMPMatchStarted', true, Events);
        Idx = 0;
        J0x5D:

        // End:0xCE [Loop If]
        if(Idx < Events.Length)
        {
            StartEvent = SeqEvent_SpMPMatchStarted(Events[Idx]);
            // End:0xC4
            if(StartEvent != none)
            {
                // End:0xC4
                if(StartEvent.CheckActivate(PC.Pawn, none))
                {
                    StartEvent.PopulateLinkedVariableValues();
                }
            }
            Idx++;
            // [Loop Continue]
            goto J0x5D;
        }
    }
    //return;    
}

function InitMatchValues()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    PGRI.Reset();
    //return;    
}

function bool HandleDownArrowInput(const out InputEventParameters EventParms)
{
    local SPGameUISceneClient SPSceneClient;

    // End:0xBD
    if(btnDownArrow != none)
    {
        // End:0xBD
        if(IsPCBuild())
        {
            // End:0xBD
            if(IsInputLeftMouseDown(EventParms))
            {
                SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
                // End:0xBD
                if(PtIntersectsUIObject(btnDownArrow, float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
                {
                    DeactivateOptionStates();
                    btnDownArrow.ActivateStateByClass(Class'Engine.UIState_Active', 0);
                    return OnArrowDownClick(btnDownArrow, 0);
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function HandleBackButton()
{
    PlayUISound('Clicked');
    // End:0x30
    if(int(ControlMode) == int(0))
    {
        CloseScene(self);        
    }
    else
    {
        AbortSession();
    }
    //return;    
}
