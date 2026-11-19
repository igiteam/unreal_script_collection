class PandoraGameViewportClient extends GameViewportClient within Engine
    transient
    native;

enum ePlayMovie
{
    PLAYMOVIE_LoadFromMemoryBlock,  // 0
    PLAYMOVIE_LoadFromMemoryLoop,   // 1
    PLAYMOVIE_StreamBlock,          // 2
    PLAYMOVIE_StreamLoop,           // 3
    PLAYMOVIE_StreamNoBlock,        // 4
    PLAYMOVIE_MAX                   // 5
};

var const bool bLevelSelect;
var bool bShowPDA;
var bool bShowQuickMenu;
var bool bInMenu;
var bool bPaused;
var PandoraUIInteraction ViewportUI;
var int UIInteractionIndex;
var int UIHandlerIndex;
var Engine.ETransitionType LastTransition;
var Texture2D MenuBackground;
var private Material BackgroundMaterial;
var UIScene PDAUIScene;
var UIScene PDALoadingUIScene;
var transient UIScene OpenedPDALoadingUIScene;
var UIScene PDALists[5];
var UIScene PauseMenu;
var UIScene MPOptionMenu;
var UIScene MPInfoScene;
var name CurrCheckpointName;
var UIScene LoadLastCheckpointMenu;
var int msgIndex;
var name listName;
var PDAAsyncPackageCBData PDAAsyncLoadCBData;

// Export UPandoraGameViewportClient::execFullScreenPlayMovie(FFrame&, void* const)
native simulated function FullScreenPlayMovie(name MovieName, PandoraGameViewportClient.ePlayMovie PlayMovieMode, optional bool bFlushAudio = false);

// Export UPandoraGameViewportClient::execFullScreenStopMovie(FFrame&, void* const)
native simulated function FullScreenStopMovie(name MovieName, bool bWaitForFinish);

// Export UPandoraGameViewportClient::execFullScreenSetNeedLoadingMovieOnCineCancel(FFrame&, void* const)
native simulated function FullScreenSetNeedLoadingMovieOnCineCancel(bool bEnable);

// Export UPandoraGameViewportClient::execFullScreenIsMoviePlaying(FFrame&, void* const)
native simulated function bool FullScreenIsMoviePlaying(optional name MovieName = 'None');

// Export UPandoraGameViewportClient::execSetLevelLoadingName(FFrame&, void* const)
native simulated function SetLevelLoadingName(name MovieName);

// Export UPandoraGameViewportClient::execDisableGameRendering(FFrame&, void* const)
native simulated function DisableGameRendering();

function PDAAsyncPackageLoadedNotify(PDAAsyncPackageCBData CBData)
{
    local LocalPlayer LocPlayer;
    local PandoraPlayerController PC;
    local SPHud mySPHud;

    // End:0x5C
    foreach Outer.GetCurrentWorldInfo().AllControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x5B
        if(PC != none)
        {
            LocPlayer = LocalPlayer(PC.Player);
            // End:0x5B
            if(LocPlayer != none)
            {
                // End:0x5C
                break;
            }
        }        
    }    
    // End:0x6A
    if(LocPlayer == none)
    {
        return;
    }
    // End:0xC6
    if(CBData.LoadedScene != none)
    {
        // End:0xA0
        if(OpenedPDALoadingUIScene != none)
        {
            UIController.CloseScene(OpenedPDALoadingUIScene);
        }
        UIController.OpenScene(CBData.LoadedScene, LocPlayer);
    }
    mySPHud = PC.GetSPHud();
    // End:0x114
    if(mySPHud.HudScene != none)
    {
        mySPHud.HudScene.SetEMailIcon(false);
    }
    bShowPDA = true;
    //return;    
}

exec function ShowPDA()
{
    local LocalPlayer LocPlayer;
    local PandoraPlayerController PC;
    local ConsolePandoraPlayerController CPC;
    local PandoraPDAManager PDAManager;
    local string UISceneName;
    local PandoraGameInfo GameInfo;
    local bool bSceneOpened;

    // End:0x6C
    foreach Outer.GetCurrentWorldInfo().AllControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x6B
        if(PC != none)
        {
            LocPlayer = LocalPlayer(PC.Player);
            CPC = ConsolePandoraPlayerController(PC);
            // End:0x6B
            if(LocPlayer != none)
            {
                // End:0x6C
                break;
            }
        }        
    }    
    GameInfo = PandoraGameInfo(Outer.GetCurrentWorldInfo().Game);
    UISceneName = "";
    PDAManager = PC.PDAManager;
    // End:0xFC
    if(((GameInfo == none) || CPC != none) && GameInfo.IsInCinematic() || GameInfo.IsInShellLevel())
    {
        return;
    }
    // End:0x10C
    if(FullScreenIsMoviePlaying())
    {
        return;
    }
    // End:0x131
    if(PDAManager != none)
    {
        UISceneName = PDAManager.GetLastUnlockedPDAMessage();
    }
    // End:0x1C8
    if(Len(UISceneName) > 0)
    {
        // End:0x1C5
        if(GameInfo != none)
        {
            UIController.OpenScene(PDAUIScene, LocPlayer);
            bSceneOpened = UIController.OpenScene(PDALoadingUIScene, LocPlayer, OpenedPDALoadingUIScene);
            // End:0x1A2
            if(!bSceneOpened || OpenedPDALoadingUIScene == none)
            {
            }
            GameInfo.LoadCurrPDAUIScene(self, UISceneName, PDAAsyncPackageLoadedNotify);
        }        
    }
    else
    {
        UIController.OpenScene(PDAUIScene, LocPlayer);
        bShowPDA = true;
    }
    //return;    
}

exec function OpenPauseMenu()
{
    local LocalPlayer SceneOwner;
    local int PlayerIndex;
    local PandoraPlayerController PC;
    local LocalPlayer LocPlayer;
    local WorldInfo WI;

    // End:0x5F
    foreach Outer.GetCurrentWorldInfo().AllControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x5E
        if(PC != none)
        {
            // End:0x5E
            if(PC.IsScoreboardActive())
            {
                PC.ToggleMultiplayerScoreboard();
            }
        }        
    }    
    WI = Outer.GetCurrentWorldInfo();
    PlayerIndex = 0;
    // End:0xA7
    if(PlayerIndex != -1)
    {
        SceneOwner = Outer.GamePlayers[PlayerIndex];
    }
    // End:0xED
    if(int(WI.NetMode) == int(NM_Standalone))
    {
        // End:0xEA
        if(PauseMenu != none)
        {
            UIController.OpenScene(PauseMenu, SceneOwner);            
        }        
    }
    else
    {
        // End:0x116
        if(MPOptionMenu != none)
        {
            UIController.OpenScene(MPOptionMenu, SceneOwner);            
        }
    }
    // End:0x18B
    foreach Outer.GetCurrentWorldInfo().AllControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x18A
        if(PC != none)
        {
            LocPlayer = LocalPlayer(PC.Player);
            // End:0x18A
            if(LocPlayer == SceneOwner)
            {
                PC.WriteProfile();
                // End:0x18B
                break;
            }
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

    WI = Outer.GetCurrentWorldInfo();
    bResult = false;
    // End:0xA5
    if(WI.StreamingLevels.Length > 0)
    {
        LevelIndex = 0;
        J0x3B:

        // End:0xA5 [Loop If]
        if(LevelIndex < WI.StreamingLevels.Length)
        {
            TheLevel = WI.StreamingLevels[LevelIndex];
            // End:0x9B
            if(TheLevel != none)
            {
                // End:0x9B
                if(!TheLevel.bIsVisible)
                {
                    bResult = true;
                    // [Explicit Break]
                    goto J0xA5;
                }
            }
            LevelIndex++;
            // [Loop Continue]
            goto J0x3B;
        }
    }
    J0xA5:

    return bResult;
    //return ReturnValue;    
}

function DrawTransition(Canvas Canvas)
{
    local WorldInfo WI;

    WI = Outer.GetCurrentWorldInfo();
    // End:0x51
    if((WI.Pauser == none) && int(Outer.TransitionType) == int(1))
    {
        ExitMenu();
    }
    switch(Outer.TransitionType)
    {
        // End:0x6B
        case 2:
            // End:0x1DA
            break;
        // End:0x87
        case 3:
            DrawTransitionMessage(Canvas, SavingMessage);
            // End:0x1DA
            break;
        // End:0xA3
        case 4:
            DrawTransitionMessage(Canvas, ConnectingMessage);
            // End:0x1DA
            break;
        // End:0xBF
        case 5:
            DrawTransitionMessage(Canvas, PrecachingMessage);
            // End:0x1DA
            break;
        // End:0xEF
        case 1:
            // End:0xEC
            if(((bShowPDA == false) && bShowQuickMenu == false) && bPaused == false)
            {
            }
            // End:0x1DA
            break;
        // End:0x189
        case 6:
            // End:0x126
            if(bInMenu == false)
            {
                ViewportUI.BuildActiveMenuFromTransitionData();
                InitMenuControl();
                bInMenu = true;
            }
            // End:0x14A
            if(int(LastTransition) != int(6))
            {
                ViewportUI.ClearKeyStates();
            }
            ViewportUI.UpdateMenuLogic();
            RenderBackground(Canvas);
            ViewportUI.RenderMenu(Canvas);
            // End:0x1DA
            break;
        // End:0x1D7
        case 0:
            // End:0x1BB
            if(bShowPDA)
            {
                bShowPDA = false;
                Outer.GetCurrentWorldInfo().ForceGarbageCollection();
            }
            bShowQuickMenu = false;
            // End:0x1D4
            if(bPaused)
            {
                bPaused = false;
            }
            // End:0x1DA
            break;
        // End:0xFFFF
        default:
            break;
    }
    LastTransition = Outer.TransitionType;
    //return;    
}

event bool Init(out string OutError)
{
    // End:0x12
    if(!super.Init(OutError))
    {
        return false;
    }
    ViewportUI = new (self) Class'PandoraUIInteraction';
    Class'LCDInterface'.static.InitLCD("Legendary");
    return true;
    //return ReturnValue;    
}

function bool InitMenuControl()
{
    UIInteractionIndex = GlobalInteractions.Find(ViewportConsole) + 1;
    UIHandlerIndex = InsertInteraction(ViewportUI, UIInteractionIndex);
    // End:0x41
    if(UIHandlerIndex == -1)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function InitMenu()
{
    // End:0x44
    if(bInMenu == false)
    {
        ViewportUI.BuildActiveMenuFromTransitionData();
        InitMenuControl();
        bInMenu = true;
        Outer.TransitionType = 6;
    }
    //return;    
}

function ExitMenu()
{
    GlobalInteractions.Remove(UIHandlerIndex, 1);
    Outer.TransitionType = 0;
    bInMenu = false;
    //return;    
}

event PostRender(Canvas Canvas)
{
    local PandoraSPGameInfo GameInfo;
    local SPMiniGameManager MGManager;
    local Vector2D extents;

    super.PostRender(Canvas);
    GameInfo = PandoraSPGameInfo(Outer.GetCurrentWorldInfo().Game);
    // End:0x89
    if(GameInfo != none)
    {
        MGManager = Class'SPMiniGameManager'.static.Get();
        GetViewportSize(extents);
        // End:0x89
        if(MGManager != none)
        {
            MGManager.Render(Canvas, extents);
        }
    }
    //return;    
}

function RenderBackground(Canvas Canvas)
{
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.SetPos(0.0000000, 0.0000000);
    Canvas.DrawTile(MenuBackground, Canvas.ClipX, Canvas.ClipY, 0.0000000, 0.0000000, 2048.0000000, 1024.0000000);
    //return;    
}

function OpenLoadLastCheckpointMenu(PandoraPlayerController Controller)
{
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Controller.Player);
    // End:0x50
    if((LoadLastCheckpointMenu != none) && UIController != none)
    {
        UIController.OpenScene(LoadLastCheckpointMenu, LocPlayer);        
    }
    //return;    
}

function PostListSceneActived(UIScene ActivatedScene, bool bInitialActivation)
{
    local UIList currList;

    currList = UIList(ActivatedScene.FindChild(listName, true));
    // End:0x43
    if(currList != none)
    {
        currList.SetIndex(msgIndex);
    }
    //return;    
}

defaultproperties
{
    bLevelSelect=true
    LastTransition=TT_Loading
    MenuBackground=Texture2D'PandoraShell.Texture.Sub_menu_frame'
    PDAUIScene=UIScene_PDAMainMenu'SP_PDA.PDAMsgFilter_Menu'
    PDALoadingUIScene=UIScene_PDALoading'SP_PDA.PDALoading_Screen'
    PauseMenu=UIScene_PauseMenu'SP_Hud.UI_Scene.Pause_Menu'
    MPOptionMenu=UIScene_PauseMenu'MegaMPScenes.UI_Scene.Pause_Menu'
    LoadLastCheckpointMenu=UIScene_LoadCheckPointMenu'SP_Hud.LoadLastCheckpoint_Menu'
    PDAAsyncLoadCBData=(Id=-1,PackageOwner=none,UISceneName="",LoadedScene=none,OnPackageLoadCBDelegate=None)
    UIControllerClass=Class'SPGameInteraction'
    SavingMessage="GUARDANDO"
    PausedMessage="PAUSA"
}