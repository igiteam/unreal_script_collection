class MOHAUIInteraction extends UIInteraction within GameViewportClient
    transient
    native
    config(Engine)
    hidecategories(Object,UIRoot);

enum EProcessUIInput
{
    PROCESS_UI_INPUT_NORMAL,        // 0
    PROCESS_UI_INPUT_PC_CONFIG,     // 1
    PROCESS_UI_INPUT_SWALLOW,       // 2
    PROCESS_UI_INPUT_MAX            // 3
};

enum AlertButtonConfig
{
    ALERTBUTTONS_NONE,              // 0
    ALERTBUTTONS_ACCEPT,            // 1
    ALERTBUTTONS_CANCEL,            // 2
    ALERTBUTTONS_ACCEPT_CANCEL,     // 3
    ALERTBUTTONS_MAX                // 4
};

var MOHAUIInteraction.EProcessUIInput UIInputMode;
var MOHAUIInteraction.AlertButtonConfig alertButtons;
var MOHAUIConfigButton CurrentConfigButton;
var const array<name> OnlineSceneNames;
var const array<name> OnlineMatchingPopupSceneNames;
var const name OptionsSceneName;
var const name OptionsSceneNameSD;
var const UIScene AlertScene;
var UIScene ActiveAlertScene;
var bool externalUIOpen;
var bool controllerUnplugged;
var int controllerUnpluggedId;
var UIScene JoinGamePopup;
var const localized string ConnectionLostTitle;
var const localized string KickedFromGameTitle;
var const localized string JoinGame;
var const localized string Join_InMP;
var const localized string Join_InMPRanked;
var const localized string Join_InSP;
var const localized string Join_InOptionsScreen;
var const localized string JoinFailed;
var float DelayEndTime;

function Initialized()
{
    local Plasma P;

    super(Interaction).Initialized();
    P = Class'Plasma.Plasma'.static.GetPlasma();
    P.SetPlasmaErrorDelegate(OnPlasmaError);
    P.SetConnectionStatusChangeDelegate(OnConnectionStatusChange);
    P.SetGameDisconnectDelegate(OnGameDisconnect);
    P.SetGameInviteAcceptedDelegate(byte(-1), OnGameInviteAccepted);
    P.SetInviteCancelledDelegate(OnInviteCancelled);
    //return;    
}

function int GetActiveControllerIndex()
{
    local UIDataStore_MOHAGameResource GameResourceDatastore;

    // End:0x50
    if(DataStoreManager != none)
    {
        GameResourceDatastore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
        // End:0x50
        if(GameResourceDatastore.bPlayerInputSelected)
        {
            return GameResourceDatastore.nControllerID;
        }
    }
    return -1;
    //return ReturnValue;    
}

event SetProccessUIInputMode(MOHAUIInteraction.EProcessUIInput NewInputMode, MOHAUIConfigButton ConfigButton)
{
    UIInputMode = NewInputMode;
    CurrentConfigButton = ConfigButton;
    //return;    
}

event MOHAUIInteraction.EProcessUIInput GetProcessUIInputMode()
{
    return UIInputMode;
    //return ReturnValue;    
}

event BlockUIInput(bool bBlock)
{
    // End:0x14
    if(bBlock)
    {
        UIInputMode = 2;        
    }
    else
    {
        UIInputMode = 0;
    }
    //return;    
}

event OnInviteCancelled()
{
    local WorldInfo WI;

    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    // End:0x47
    if((WI == none) || int(WI.NetMode) != int(NM_Standalone))
    {
        GoToShellPos(NM_ListenServer);
    }
    //return;    
}

exec function AlertRetryPressed()
{
    //return;    
}

exec function AlertAcceptPressed()
{
    //return;    
}

exec function AlertCancelPressed()
{
    //return;    
}

simulated function OpenAlert(string Title, string details, MOHAUIInteraction.AlertButtonConfig Buttons, optional name NewState = 'AlertOpen', optional string Caption = "Error", optional int Size = 0)
{
    local PlayerController PC;
    local WorldInfo WI;
    local UILabelButton AcceptButton, CancelButton;

    // End:0x2C
    if(CheckForMoviePlaying())
    {
        return;
    }
    // End:0x42
    if(ActiveAlertScene != none)
    {
        CloseAlert();
    }
    // End:0x2D3
    if(OpenScene(AlertScene, none, ActiveAlertScene))
    {
        UILabel(ActiveAlertScene.FindChild('Caption', true)).SetValue(Caption);
        UILabel(ActiveAlertScene.FindChild('Title', true)).SetValue(Title);
        UILabel(ActiveAlertScene.FindChild('details', true)).SetValue(details);
        // End:0x145
        if(Class'Engine.WorldInfo'.static.GetPlatform() == 'Xenon')
        {
            AcceptButton = UILabelButton(ActiveAlertScene.FindChild('Accept_360', true));
            CancelButton = UILabelButton(ActiveAlertScene.FindChild('Cancel_360', true));            
        }
        else
        {
            AcceptButton = UILabelButton(ActiveAlertScene.FindChild('Accept_PC', true));
            CancelButton = UILabelButton(ActiveAlertScene.FindChild('Cancel_PC', true));
        }
        // End:0x201
        if(AcceptButton != none)
        {
            AcceptButton.SetVisibility((int(Buttons) == int(1)) || int(Buttons) == int(3));
            // End:0x201
            if((int(Buttons) == int(1)) || int(Buttons) == int(3))
            {
                AcceptButton.SetFocus(none);
            }
        }
        // End:0x263
        if(CancelButton != none)
        {
            CancelButton.SetVisibility((int(Buttons) == int(2)) || int(Buttons) == int(3));
            // End:0x263
            if(int(Buttons) == int(2))
            {
                CancelButton.SetFocus(none);
            }
        }
        alertButtons = Buttons;
        WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
        // End:0x2C4
        if(WI != none)
        {
            // End:0x2C3
            foreach WI.LocalPlayerControllers(PC)
            {
                PC.ForceFeedbackManager.PauseWaveform(true);                
            }            
        }
        PushState(NewState);        
    }
    //return;    
}

function CloseAlert(optional bool bClosedState)
{
    // End:0x35
    if(ActiveAlertScene != none)
    {
        CloseScene(ActiveAlertScene);
        ActiveAlertScene = none;
        // End:0x35
        if(bClosedState)
        {
            GotoState('None');
        }
    }
    //return;    
}

// Export UMOHAUIInteraction::execCheckForMoviePlaying(FFrame&, void* const)
native function bool CheckForMoviePlaying();

function bool IsInOptionsMenus()
{
    // End:0x14
    if(FindSceneByTag(OptionsSceneName) != none)
    {
        return true;
    }
    // End:0x28
    if(FindSceneByTag(OptionsSceneNameSD) != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInOnlineMenus()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3B [Loop If]
    if(I < OnlineSceneNames.Length)
    {
        // End:0x31
        if(FindSceneByTag(OnlineSceneNames[I]) != none)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function CloseAllOnlineScenes()
{
    local int I;
    local UIScene Scene;

    I = 0;
    J0x07:

    // End:0x4F [Loop If]
    if(I < OnlineSceneNames.Length)
    {
        Scene = FindSceneByTag(OnlineSceneNames[I]);
        // End:0x45
        if(Scene != none)
        {
            CloseScene(Scene);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    CloseAllOnlineMatchingPopupScenes();
    //return;    
}

function CloseAllOnlineMatchingPopupScenes()
{
    local int I;
    local UIScene Scene;

    I = 0;
    J0x07:

    // End:0x4F [Loop If]
    if(I < OnlineMatchingPopupSceneNames.Length)
    {
        Scene = FindSceneByTag(OnlineMatchingPopupSceneNames[I]);
        // End:0x45
        if(Scene != none)
        {
            CloseScene(Scene);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function OnPlasmaError(int err, string Title, string msg)
{
    OpenAlert(Title, msg, 2);
    //return;    
}

event OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
    local Plasma P;
    local UIDataStore_MOHAGameResource GameResourceDatastore;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    switch(ConnectionStatus)
    {
        // End:0x25
        case 0:
        // End:0x2A
        case 2:
        // End:0x2F
        case 3:
        // End:0x34
        case 4:
        // End:0x39
        case 5:
        // End:0x3E
        case 6:
        // End:0x43
        case 7:
        // End:0x1A8
        case 8:
            // End:0x7F
            if(int(Class'Engine.Engine'.static.GetCurrentWorldInfo().NetMode) != int(NM_Standalone))
            {
                SceneClient.ConditionalPause(true);
            }
            // End:0x132
            if(P.LosingConnectionDuringGame)
            {
                SceneClient.ConditionalPause(true);
                // End:0xEF
                if(DataStoreManager != none)
                {
                    GameResourceDatastore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
                    // End:0xEF
                    if(GameResourceDatastore != none)
                    {
                        GameResourceDatastore.ShellStartPos = 1;
                    }
                }
                CloseAllOnlineMatchingPopupScenes();
                OpenAlert(ConnectionLostTitle, P.InGameStatusString, 2, 'ConnectionLostAlert');
                GoToShellPos(1);                
            }
            else
            {
                // End:0x1A5
                if(((IsInOnlineMenus()) || int(Class'Engine.Engine'.static.GetCurrentWorldInfo().NetMode) != int(NM_Standalone)) || P.InviteAccepted)
                {
                    OpenAlert(ConnectionLostTitle, P.SignInStatusString, 2, 'PlasmaDownAlertOpen');                    
                }
            }
            // End:0x1AB
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

// Export UMOHAUIInteraction::execAreUniqueNetIdsEqual(FFrame&, void* const)
native function bool AreUniqueNetIdsEqual(UniqueNetId FirstNetId, UniqueNetId SecondNetId);

event OnGameDisconnect(int Reason)
{
    local Plasma P;
    local WorldInfo WI;
    local UIDataStore_MOHAGameResource GameResourceDatastore;
    local int I;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    SceneClient.ConditionalPause(true);
    // End:0x9F
    if((P.xenonModule != none) && int(P.xenonModule.GetLoginStatus(byte(P.con.GetActiveUserIndex()))) != int(2))
    {
        return;
    }
    // End:0x348
    if((!P.VoluntaryQuit && !P.InviteAccepted) && MOHAGameReplicationInfo(WI.GRI).RoundStatus != 2)
    {
        // End:0x2C9
        if(P.GetGame() != none)
        {
            I = 0;
            J0x10E:

            // End:0x2C9 [Loop If]
            if(I < WI.GRI.PRIArray.Length)
            {
                // End:0x2BF
                if(AreUniqueNetIdsEqual(WI.GRI.PRIArray[I].UniqueId, P.HostId))
                {
                    WI.GRI.PRIArray[I].Score -= float(2);
                    WI.GRI.PRIArray[I].Deaths += float(1);
                    MOHAPlayerReplicationInfo(WI.GRI.PRIArray[I]).m_iTeamPoints -= 2;
                    MOHAPlayerReplicationInfo(WI.GRI.PRIArray[I]).MP_Suicides += 1;
                    WI.GRI.PRIArray[I].bIsInactive = true;
                    WI.GRI.InactivePRIArray.AddItem(WI.GRI.PRIArray[I]);
                    WI.GRI.RemovePRI(WI.GRI.PRIArray[I]);
                    // [Explicit Break]
                    goto J0x2C9;
                }
                I++;
                // [Loop Continue]
                goto J0x10E;
            }
        }
        J0x2C9:

        // End:0x314
        if(DataStoreManager != none)
        {
            GameResourceDatastore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
            // End:0x314
            if(GameResourceDatastore != none)
            {
                GameResourceDatastore.ShellStartPos = 2;
            }
        }
        OpenAlert(ConnectionLostTitle, P.InGameStatusString, 2, 'ConnectionLostAlert');
        CloseAllOnlineMatchingPopupScenes();
    }
    //return;    
}

// Export UMOHAUIInteraction::execReactivateTopmostScene(FFrame&, void* const)
native function ReactivateTopmostScene();

event GoToShellPos(MOHAIncludeClass.EShellStartPosition startPos)
{
    local string MapName;
    local UIDataStore_MOHAGameResource GameResourceDatastore;

    MapName = Class'Engine.GameEngine'.static.GetGameEngine().LoadingURL.Map;
    // End:0x11C
    if(DataStoreManager != none)
    {
        GameResourceDatastore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
        // End:0x11C
        if(GameResourceDatastore != none)
        {
            GameResourceDatastore.ShellStartPos = int(startPos);
            // End:0xDB
            if(MapName ~= "Shell")
            {
                // End:0xC0
                if(SceneClient.GetTopmostScene().SceneTag == 'UIScene_Title_Menu_Xenon')
                {
                    ReactivateTopmostScene();                    
                }
                else
                {
                    Class'MOHAUtilities'.static.ShellJumpToPosition(startPos);
                }                
            }
            else
            {                
                Outer.ConsoleCommand("open ?closed?game=MOHAGame.MOHAGameInfo");
            }
        }
    }
    //return;    
}

event OnGameInviteAccepted(OnlineGameSettings GameInviteSettings)
{
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x1E4
    if(GameInviteSettings != none)
    {
        // End:0x109
        if(Class'Engine.GameEngine'.static.GetGameEngine().LoadingURL.Map ~= "Shell")
        {
            // End:0x83
            if(IsInOptionsMenus())
            {
                OpenAlert(JoinGame, Join_InOptionsScreen, 3, 'ConfirmJoinGame');                
            }
            else
            {
                CloseAlert(true);
                // End:0xD2
                if((P.InviteUserIndex != (GetActiveControllerIndex())) || FindSceneByTag('UIScene_Main_Menu') == none)
                {
                    GoToShellPos(4);                    
                }
                else
                {
                    // End:0xF9
                    if(!P.IsSignedIn())
                    {
                        GoToShellPos(2);                        
                    }
                    else
                    {
                        OpenScene(JoinGamePopup);
                    }
                }
            }            
        }
        else
        {
            CloseAlert(true);
            // End:0x176
            if(((P != none) && P.GetGame() != none) && P.isRanked())
            {
                OpenAlert(JoinGame, Join_InMPRanked, 3, 'ConfirmJoinGame');                
            }
            else
            {
                // End:0x1C0
                if((P != none) && P.GetGame() != none)
                {
                    OpenAlert(JoinGame, Join_InMP, 3, 'ConfirmJoinGame');                    
                }
                else
                {
                    OpenAlert(JoinGame, Join_InSP, 3, 'ConfirmJoinGame');
                }
            }
        }        
    }
    else
    {
        OpenAlert("ZZZJoin Failed", P.PlayNowStatusString, 2);
    }
    //return;    
}

state AlertOpen
{
    event OnCancel()
    {
        PopState();
        //return;        
    }

    event OnGameInviteAccepted(OnlineGameSettings Settings)
    {
        CloseAlert(true);
        super(AlertOpen).OnGameInviteAccepted(Settings);
        //return;        
    }

    exec function AlertAcceptPressed()
    {
        local WorldInfo WI;
        local PlayerController PC;

        // End:0x94
        if((int(alertButtons) == int(1)) || int(alertButtons) == int(3))
        {
            OnAccept();
            CloseAlert();
            WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
            // End:0x8D
            if(WI != none)
            {
                // End:0x8C
                foreach WI.LocalPlayerControllers(PC)
                {
                    PC.ForceFeedbackManager.PauseWaveform(true);                    
                }                
            }
            PopState();
        }
        //return;        
    }

    exec function AlertCancelPressed()
    {
        local WorldInfo WI;
        local PlayerController PC;

        // End:0x8D
        if((int(alertButtons) == int(2)) || int(alertButtons) == int(3))
        {
            WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
            // End:0x78
            if(WI != none)
            {
                // End:0x77
                foreach WI.LocalPlayerControllers(PC)
                {
                    PC.ForceFeedbackManager.PauseWaveform(true);                    
                }                
            }
            CloseAlert();
            OnCancel();
        }
        //return;        
    }
    stop;    
}

state PlasmaDownAlertOpen extends AlertOpen
{
    event OnCancel()
    {
        CloseAllOnlineScenes();
        // End:0x39
        if(int(Class'Engine.Engine'.static.GetCurrentWorldInfo().NetMode) != int(NM_Standalone))
        {
            GoToShellPos(NM_DedicatedServer);
        }
        super.OnCancel();
        //return;        
    }
    stop;    
}

state ConnectionLostAlert extends AlertOpen
{
    event OnCancel()
    {
        local Plasma P;
        local WorldInfo WI;
        local MOHAMultiplayerController mpc;
        local string MapName;

        P = Class'Plasma.Plasma'.static.GetPlasma();
        // End:0xBD
        if(P.GameHasStarted)
        {
            WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
            // End:0xBA
            if(WI != none)
            {
                MOHAGameReplicationInfo(WI.GRI).ConnectionLost = true;
                MOHAGameReplicationInfo(WI.GRI).RoundStatus = 2;
                // End:0xB9
                foreach WI.AllControllers(Class'MOHAMultiplayerController', mpc)
                {
                    mpc.ShowFinalScoreBoard();                    
                }                
            }            
        }
        else
        {
            MapName = Class'Engine.GameEngine'.static.GetGameEngine().LoadingURL.Map;
            // End:0xF9
            if(MapName ~= "Shell")
            {                
            }
            else
            {
                GoToShellPos(((P.IsSignedIn()) ? 2 : 1));
            }
        }
        super.OnCancel();
        //return;        
    }
    stop;    
}

state ConfirmJoinGame extends AlertOpen
{
    event OnAccept()
    {
        local Plasma P;

        P = Class'Plasma.Plasma'.static.GetPlasma();
        CloseAlert();
        // End:0x50
        if(P.InviteUserIndex != (GetActiveControllerIndex()))
        {
            GoToShellPos(4);            
        }
        else
        {
            // End:0x77
            if(!P.IsSignedIn())
            {
                GoToShellPos(2);                
            }
            else
            {
                OpenScene(JoinGamePopup);
            }
        }
        //return;        
    }

    event OnCancel()
    {
        local WorldInfo WI;
        local PlayerController PC;
        local Plasma P;

        P = Class'Plasma.Plasma'.static.GetPlasma();
        P.CancelInvite();
        // End:0x9D
        if(P.GetGame() == none)
        {
            WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
            // End:0x9D
            if(WI != none)
            {
                // End:0x9C
                foreach WI.LocalPlayerControllers(PC)
                {
                    // End:0x9B
                    if(MOHAMultiplayerController(PC) != none)
                    {
                        GoToShellPos(2);
                        // End:0x9C
                        break;
                    }                    
                }                
            }
        }
        super.OnCancel();
        //return;        
    }
    stop;    
}

defaultproperties
{
    OnlineSceneNames[0]="UIScene_OnlineMenu"
    OnlineSceneNames[1]="UIScene_MainMenu_PU_SignIn"
    OnlineSceneNames[2]="SD_UIScene_MainMenu_PU_SignIn"
    OnlineSceneNames[3]="PU_JoinInvite"
    OnlineSceneNames[4]="PU_JoinPassword"
    OnlineSceneNames[5]="CreateAccount"
    OnlineSceneNames[6]="UIScene_Login"
    OnlineSceneNames[7]="TermsOfService"
    OnlineSceneNames[8]="TermsOfService2"
    OnlineSceneNames[9]="Leaderboard"
    OnlineSceneNames[10]="Leaderboard_Retrieving"
    OnlineSceneNames[11]="Leaderboard_Error"
    OnlineMatchingPopupSceneNames[0]="PlayerMatch_PU_QuickMatch"
    OnlineMatchingPopupSceneNames[1]="CustomMatch_PU_Matching"
    OnlineMatchingPopupSceneNames[2]="RankedMatch_PU_QuickMatch"
    OnlineMatchingPopupSceneNames[3]="RankedMatchCustom_PU_Matching"
    OnlineMatchingPopupSceneNames[4]="PU_JoinInvite"
    OnlineMatchingPopupSceneNames[5]="Serverlist_PU_Join"
    OptionsSceneName="UIScene_Options_Menu"
    OptionsSceneNameSD="SD_UIScene_Options_Menu"
    AlertScene=UIScene'UI_Popups.InGame_PU_Small'
    JoinGamePopup=UIScene'UI_Popups.PU_JoinInvite'
    ConnectionLostTitle="Connection Lost"
    KickedFromGameTitle="Kicked By Host"
    Join_InMP="You will be disconnected from your current session.  Are you sure you want to quit?"
    Join_InMPRanked="You will be disconnected from your current session and your rank may be affected.  Are you sure you want to quit?"
    Join_InSP="Any progress made since your last checkpoint save will be lost.  Are you sure you want to quit?"
    Join_InOptionsScreen="You will lose changes to your options.  Are you sure you want to quit?"
    JoinFailed="Join Failed"
}