class UIScene_SinglePlayerMenu extends UIScene_BaseFrontEnd
    native;

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

enum ESPOption
{
    SPO_PlayPrologue,               // 0
    SPO_New,                        // 1
    SPO_Continue,                   // 2
    SPO_LoadEpisode,                // 3
    SPO_PDA,                        // 4
    SPO_MAX                         // 5
};

/** MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(UIScene) int DatafileSize;
var transient string NotLoginTitle;
var transient string OverwriteCheckpointTitle;
var transient string NoDeviceSelectedTitle;
var transient string NotLoginErr;
var transient string NotLoginContinueErr;
var transient string NotLoginContinueTitle;
var transient string OverwriteCheckpointErr;
var transient string NoDeviceSelectedErr;
var transient string NoDeviceLoadErr;
var transient string NoDeviceLoadTitle;
var transient string NoSaveGameTitle;
var transient string NoSaveGameErr;
var transient string CheckpointCorruptErr;
var transient string CheckpointCorruptTitle;
var transient string StorageDeviceFull_Title;
var transient string StorageDeviceFull_Message;
var transient string GuestProfileErr;
var transient string GuestProfileTitle;
var transient int IsDone;
var transient int GameExists;
var transient int DataCorrupt;
var transient bool bPlayPrologue;
var transient bool bCheckSavedGame;
var transient int DeviceID;
var transient int bHasSpace;

event InitScene()
{
    super.InitScene();
    NoSaveGameErr = PlatformStrings $ "ErrorMessages.NoSaveGame_Message>";
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    // End:0x18
    if(CurrMenuItemIdx == 0)
    {
        PlayPrologue();        
    }
    else
    {
        CheckLogin();
    }
    //return;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    super.UpdateScene(DeltaTime, WorldInfo);
    // End:0xF6
    if(IsDone > 0)
    {
        IsDone = 0;
        bCheckSavedGame = false;
        // End:0xB6
        if(GameExists > 0)
        {
            GameExists = 0;
            // End:0x7A
            if((CurrMenuItemIdx == 1) || CurrMenuItemIdx == 3)
            {
                ShowMsgBox(OverwriteCheckpointErr, OverwriteCheckpointTitle, 1, OnOverWriteCheckpointMsgResults);                
            }
            else
            {
                // End:0xA9
                if(DataCorrupt > 0)
                {
                    ShowMsgBox(CheckpointCorruptErr, CheckpointCorruptTitle, 0);
                    DataCorrupt = 0;                    
                }
                else
                {
                    ContinueGame();
                }
            }            
        }
        else
        {
            // End:0xDC
            if((CurrMenuItemIdx == 1) || CurrMenuItemIdx == 3)
            {
                OpenNextUIScene();                
            }
            else
            {
                ShowMsgBox(NoSaveGameErr, NoSaveGameTitle, 0);
            }
        }
    }
    // End:0x109
    if(bCheckSavedGame)
    {
        EnableButtonDelay();
    }
    // End:0x12B
    if(bPlayPrologue && !IsProloguePlay())
    {
        bPlayPrologue = false;
    }
    //return;    
}

function bool ProcessAcceptInput(const out InputEventParameters EventParms)
{
    // End:0x24
    if(IsInputAccept(EventParms))
    {
        OnClick(none, CurrMenuItemIdx);
        return true;
    }
    return false;
    //return ReturnValue;    
}

event SceneActivated(bool bInitialActivation)
{
    SetOnlineStatusMode(4);
    super.SceneActivated(bInitialActivation);
    //return;    
}

function OnNoLoginMsgResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x64
    if(((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0)) && myPC != none)
    {
        // End:0x64
        if((CurrMenuItemIdx == 1) || CurrMenuItemIdx == 3)
        {
            myPC.startedSPGameWithoutProfile = true;
            OpenNextUIScene();
        }
    }
    //return;    
}

function OnNoDeviceSelectedMsgResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x12
    if(int(eReturnValue) == int(4))
    {
        return;
    }
    // End:0x67
    if(((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0)) && myPC != none)
    {
        myPC.SelectDevice(DatafileSize, NotifyDeviceSelectComplete);        
    }
    else
    {
        // End:0x8A
        if((CurrMenuItemIdx == 1) || CurrMenuItemIdx == 3)
        {
            OpenNextUIScene();
        }
    }
    //return;    
}

function OnOverWriteCheckpointMsgResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x37
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        // End:0x37
        if(myPC != none)
        {
            OpenNextUIScene();
        }
    }
    //return;    
}

function NewGame()
{
    CheckLogin();
    //return;    
}

function CheckLogin()
{
    local OnlineSubsystem.ELoginStatus Status;
    local int PlayerIndex, ControllerId;

    PlayerIndex = 0;
    ControllerId = 0;
    Status = 0;
    // End:0x56
    if(myPC != none)
    {
        PlayerIndex = myPC.GetUIPlayerIndex();
        ControllerId = Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
    }
    Status = GetLoginStatus(ControllerId);
    switch(Status)
    {
        // End:0x78
        case 1:
        // End:0xE9
        case 2:
            // End:0x96
            if(CurrMenuItemIdx == 4)
            {
                OpenNextUIScene();                
            }
            else
            {
                // End:0xD2
                if(myPC.IsGuestProfile())
                {
                    ShowMsgBox(GuestProfileErr, GuestProfileTitle, 1, OnGuestProfileMsgResults);                    
                }
                else
                {
                    EnableButtonDelay();
                    CheckSavedGame();
                }
            }
            // End:0x171
            break;
        // End:0xFFFF
        default:
            // End:0x123
            if((CurrMenuItemIdx == 2) || CurrMenuItemIdx == 3)
            {
                ShowMsgBox(NotLoginContinueErr, NotLoginContinueTitle, 0);                
            }
            else
            {
                // End:0x14C
                if(CurrMenuItemIdx == 4)
                {
                    ShowMsgBox(NeedProfile_Message, NeedProfile_Title, 0);                    
                }
                else
                {
                    ShowMsgBox(NotLoginErr, NotLoginTitle, 1, OnNoLoginMsgResults);
                }
            }
            // End:0x171
            break;
            break;
    }
    //return;    
}

function CheckSavedGame()
{
    local PandoraPlayerController.EDeviceValidErrorCode CheckDeviceResult;

    // End:0xE1
    if(myPC != none)
    {
        myPC.CheckStorageDevice(CheckDeviceResult);
        switch(CheckDeviceResult)
        {
            // End:0x7E
            case 0:
                // End:0x7B
                if(myPC.SPCM != none)
                {
                    myPC.SPCM.SavedGameExists(IsDone, GameExists, DataCorrupt);
                    bCheckSavedGame = true;
                }
                // End:0xE1
                break;
            // End:0x83
            case 2:
            // End:0xDE
            case 1:
                // End:0xB9
                if(CurrMenuItemIdx == 2)
                {
                    ShowMsgBox(NoDeviceLoadErr, NoDeviceLoadTitle, 1, OnNoDeviceSelectedMsgResults);                    
                }
                else
                {
                    ShowMsgBox(NoDeviceSelectedErr, NoDeviceSelectedTitle, 1, OnNoDeviceSelectedMsgResults);
                }
                // End:0xE1
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

function ContinueGame()
{
    // End:0xAF
    if(myPC != none)
    {
        SceneClient.CloseScene(self);
        // End:0x3E
        if(PreviousMenuScene != none)
        {
            SceneClient.CloseScene(PreviousMenuScene);
        }
        // End:0xAF
        if((LocPlayer != none) && LocPlayer.Actor != none)
        {            
            LocPlayer.Actor.ConsoleCommand("open PandoraGame_P?LoadSaveGame");
            SetLoadingMovie();
        }
    }
    //return;    
}

function OpenNextUIScene()
{
    local UIScene OpenedScene;
    local UIScene_BaseFrontEnd newBFEScene;

    ActivateRemoteEvent(MenuItems[CurrMenuItemIdx].RemoteEvent);
    SceneClient.OpenScene(GetMenuItemsValidSceneRef(MenuItems[CurrMenuItemIdx]), LocPlayer, OpenedScene);
    newBFEScene = UIScene_BaseFrontEnd(OpenedScene);
    // End:0xD5
    if(newBFEScene != none)
    {
        newBFEScene.PreviousMenuScene = self;
        newBFEScene.LocPlayer = LocPlayer;
        newBFEScene.BaseScene = BaseScene;
        newBFEScene.SetVisibility(true);
        newBFEScene.FadeIn(fadeInTimeEd);
    }
    FadeOut(fadeOutTimeEd);
    //return;    
}

function PlayPrologue()
{
    local PandoraGameViewportClient pvc;

    // End:0x26
    if(myPC != none)
    {
        pvc = PandoraGameViewportClient(myPC.GetViewportClient());
    }
    // End:0x59
    if(pvc != none)
    {
        pvc.FullScreenPlayMovie('E1_Slideshow', 4);
        bPlayPrologue = true;
    }
    //return;    
}

function StopPrologue()
{
    local PandoraGameViewportClient pvc;

    // End:0x26
    if(myPC != none)
    {
        pvc = PandoraGameViewportClient(myPC.GetViewportClient());
    }
    // End:0x57
    if(pvc != none)
    {
        pvc.FullScreenStopMovie('E1_Slideshow', false);
        bPlayPrologue = false;
    }
    //return;    
}

function bool IsProloguePlay()
{
    local PandoraGameViewportClient pvc;
    local bool Results;

    Results = false;
    // End:0x2E
    if(myPC != none)
    {
        pvc = PandoraGameViewportClient(myPC.GetViewportClient());
    }
    // End:0x5D
    if(pvc != none)
    {
        Results = pvc.FullScreenIsMoviePlaying('E1_Slideshow');
    }
    return Results;
    //return ReturnValue;    
}

function NotifyDeviceSelectComplete(bool bWasSuccessful)
{
    local OnlinePlayerInterfaceEx PlayerInterfaceEx;

    // End:0x73
    if((myPC != none) && myPC.OnlineSub != none)
    {
        PlayerInterfaceEx = myPC.OnlineSub.PlayerInterfaceEx;
        PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(byte(LocPlayer.ControllerId), NotifyDeviceSelectComplete);        
    }
    super.NotifyDeviceSelectComplete(bWasSuccessful);
    // End:0x145
    if(bWasSuccessful)
    {
        // End:0x138
        if((CurrMenuItemIdx == 1) || CurrMenuItemIdx == 3)
        {
            DeviceID = myPC.ProfileSettings.GetCurrentDeviceID();
            myPC.SPCM.CheckDeviceSpace(DeviceID, DatafileSize, bHasSpace);
            // End:0x10A
            if(bHasSpace > 0)
            {
                OpenNextUIScene();                
            }
            else
            {
                ShowMsgBox(StorageDeviceFull_Message, StorageDeviceFull_Title, 7, OnStorageChangeMsgResult, None, 0, 5);
            }            
        }
        else
        {
            CheckSavedGame();
        }        
    }
    else
    {
        ShowMsgBox(NoDeviceSelectedErr, NoDeviceSelectedTitle, 1, OnNoDeviceSelectedMsgResults);
    }
    //return;    
}

function OnGuestProfileMsgResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x45
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        // End:0x45
        if((CurrMenuItemIdx == 1) || CurrMenuItemIdx == 3)
        {
            OpenNextUIScene();
        }
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x1A
    if(bInputDisabled)
    {
        return true;
    }
    // End:0xFE
    if((CurrMenuItemIdx == 0) && bPlayPrologue)
    {
        // End:0xF9
        if((int(EventParms.EventType) == int(1)) && IsXboxBuild() || EventParms.ControllerId == 0)
        {
            // End:0xF9
            if((((((IsPCBuild() || IsInputAccept(EventParms)) || IsInputCancel(EventParms)) || IsInputAlt2Accept(EventParms)) || IsInputAltAccept(EventParms)) || IsInputStart(EventParms)) || IsInputLeftMouseUp(EventParms))
            {
                StopPrologue();
            }
        }
        return true;        
    }
    else
    {
        return super.CustomInputKey(EventParms);
    }
    //return ReturnValue;    
}

function OnStorageChangeMsgResult(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x40
    if((myPC != none) && int(eReturnValue) == int(2))
    {
        myPC.SelectDevice(DatafileSize, NotifyDeviceSelectComplete);
    }
    //return;    
}
