class AdvGFxHudWrapper extends EvilGFxHudWrapper
    transient
    config(Game)
    hidecategories(Navigation);

var AdvGFxUI_PauseDifficultyMenu DifficultyChangeMovie;
var AdvGFxUI_Stats StatsMovie;
var AdvGFxUI_EndStats EndStatsMovie;
var AdvGFxUI_Credits CreditsMovie;
var bool bWasVisibleBeforePause;
var bool bBlockScoreboard;
var bool bDrawTimer;
var AdvGFxUI_PauseMenu AdvPauseMenuMovie;
var class<AdvGFxUI_PauseMenu> AdvPauseMenuClass;
var AdvGFxUI_Menu_MultiClassSelection AdvClassSelectionMenuMovie;
var AdvGFxUI_Menu_DemoScreen AdvDemoScreen;
var AdvGFxUI_Menu_MultiStartingScreen AdvMultiStartingScreenMovie;
var AdvGFxUI_EndScreenMP AdvMultiEndScreenMovie;
var AdvGFxUI_EndScreenRound AdvMultiRoundEndScreenMovie;
var AdvGFxUI_EndScreenSurvival AdvSurvivalEndScreenMovie;
var AdvGFxUI_GameOverMenu GameOverMovie;
var AdvGFxUI_Scoreboard AdvScoreboardMovie;
var GFxProjectedUI InventoryMovie;
var AdvGFxUI_QTE QTE;
var AdvGFxUI_InventoryMenu QuickMenuMovie;
var AdvGFxUI_Upgrades UpgradesMenu;
var AdvMagPuzzle_base MagPuzzle;

singular event Destroyed()
{
    RemoveMovies();
    super(Actor).Destroyed();
    //return;    
}

function RemoveMovies()
{
    // End:0x3A
    if(HudMovie != none)
    {
        HudMovie.Close(true);
        HudMovie = none;
    }
    // End:0x74
    if(InventoryMovie != none)
    {
        InventoryMovie.Close(true);
        InventoryMovie = none;
    }
    // End:0xAE
    if(QuickMenuMovie != none)
    {
        QuickMenuMovie.Close(true);
        QuickMenuMovie = none;
    }
    // End:0xE8
    if(UpgradesMenu != none)
    {
        UpgradesMenu.Close(true);
        UpgradesMenu = none;
    }
    super(UTHUDBase).RemoveMovies();
    //return;    
}

function CreateHUDMovie()
{
    // End:0x2F
    if(HudMovie != none)
    {
        HudMovie.Close();
    }
    HudMovie = new HUDClass;
    HudMovie.SetTimingMode(1);
    HudMovie.Init(LocalPlayer(PlayerOwner.Player));
    HudMovie.ToggleCrosshair(true);
    super.CreateHUDMovie();
    //return;    
}

function int GetLocalPlayerOwnerIndex()
{
    return Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));    
    //return ReturnValue;    
}

function HideHUD(bool PlayCloseAnim)
{
    SetVisible(false);
    //return;    
}

function OpenHUD(bool PlayOpenAnim)
{
    SetVisible(true);
    // End:0x37
    if(PlayOpenAnim)
    {
        HudMovie.PlayOpenAnimation();
    }
    //return;    
}

function SetVisible(bool bNewVisible)
{
    // End:0x77
    if(HudMovie != none)
    {
        HudMovie.ToggleCrosshair(bNewVisible);
        super(UTHUDBase).SetVisible(bNewVisible);
        HudMovie.SetPause(!bNewVisible);
    }
    //return;    
}

function DisplayHitAdv(Pawn InstigatorPawn, Vector HitDir, int Damage, class<DamageType> DamageType)
{
    AdvGFxHud(HudMovie).DisplayHit(InstigatorPawn, HitDir, Damage, DamageType);
    //return;    
}

function CloseOtherMenus()
{
    // End:0x54
    if((InventoryMovie != none) && InventoryMovie.bMovieIsOpen)
    {
        InventoryMovie.StartCloseAnimation();
        return;
    }
    // End:0xA8
    if((QuickMenuMovie != none) && QuickMenuMovie.bMovieIsOpen)
    {
        QuickMenuMovie.PlayCloseAnimation();
        return;
    }
    // End:0xFA
    if((UpgradesMenu != none) && UpgradesMenu.bMovieIsOpen)
    {
        UpgradesMenu.PlayCloseAnimation();
    }
    HideInGameStatsScreen();
    //return;    
}

function CloseAllMultiMenus()
{
    // End:0x30
    if(AdvPauseMenuMovie != none)
    {
        AdvPauseMenuMovie.PlayCloseAnimation();
        return;
    }
    // End:0x60
    if(AdvClassSelectionMenuMovie != none)
    {
        AdvClassSelectionMenuMovie.PlayCloseAnimation();
        return;
    }
    // End:0x90
    if(AdvMultiStartingScreenMovie != none)
    {
        AdvMultiStartingScreenMovie.PlayCloseAnimation();
        return;
    }
    //return;    
}

function ResolutionChanged()
{
    local bool bNeedInventoryMovie;

    bNeedInventoryMovie = (InventoryMovie != none) && InventoryMovie.bMovieIsOpen;
    super(UTHUDBase).ResolutionChanged();
    CreateHUDMovie();
    // End:0x66
    if(bNeedInventoryMovie)
    {
        ToggleInventory();
    }
    //return;    
}

event PostRender()
{
    super.PostRender();
    // End:0x41
    if(HudMovie != none)
    {
        HudMovie.TickHud(RenderDelta);
    }
    // End:0x9C
    if((MenuBase != none) && MenuBase.bMovieIsOpen)
    {
        MenuBase.Tick(RenderDelta);
    }
    // End:0xD3
    if(StatsMovie != none)
    {
        StatsMovie.Tick(RenderDelta);
    }
    // End:0x179
    if((!bShowHUD && PlayerOwner.IsInState('Demon')) && PlayerOwner.Pawn != none)
    {
        PlayerOwner.Pawn.InvManager.DrawHUD(self);
    }
    // End:0x1F3
    if((InventoryMovie != none) && InventoryMovie.bMovieIsOpen)
    {
        InventoryMovie.Tick(RenderDelta);
        InventoryMovie.UpdatePos();
    }
    // End:0x24E
    if((QuickMenuMovie != none) && QuickMenuMovie.bMovieIsOpen)
    {
        QuickMenuMovie.Tick(RenderDelta);
    }
    // End:0x2A9
    if((AdvScoreboardMovie != none) && AdvScoreboardMovie.bMovieIsOpen)
    {
        AdvScoreboardMovie.Tick(RenderDelta);
    }
    // End:0x304
    if((AdvMultiEndScreenMovie != none) && AdvMultiEndScreenMovie.bMovieIsOpen)
    {
        AdvMultiEndScreenMovie.Tick(RenderDelta);
    }
    // End:0x35F
    if((AdvMultiStartingScreenMovie != none) && AdvMultiStartingScreenMovie.bMovieIsOpen)
    {
        AdvMultiStartingScreenMovie.Tick(RenderDelta);
    }
    //return;    
}

event DrawHUD()
{
    super.DrawHUD();
    // End:0x3B
    if(bCrosshairOnFriendly)
    {
        bGreenCrosshair = CheckCrosshairOnFriendly();
        bCrosshairOnFriendly = false;        
    }
    else
    {
        bGreenCrosshair = false;
    }
    // End:0x89
    if(HudMovie.bDrawWeaponCrosshairs)
    {
        PlayerOwner.DrawHUD(self);
    }
    // End:0xA0
    if(bDrawTimer)
    {
        DrawTimer();
    }
    //return;    
}

function LocalizedMessage(class<LocalMessage> InMessageClass, PlayerReplicationInfo RelatedPRI_1, PlayerReplicationInfo RelatedPRI_2, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor, optional Object OptionalObject)
{
    local class<UTLocalMessage> UTMessageClass;

    UTMessageClass = class<UTLocalMessage>(InMessageClass);
    // End:0xB8
    if(ClassIsChildOf(InMessageClass, Class'EvilGame.EvilDeathMessage') || ClassIsChildOf(InMessageClass, Class'EvilGame.EvilWeaponKillMessage'))
    {
        // End:0x69
        if(ClassIsChildOf(InMessageClass, Class'EvilGame.EvilWeaponKillMessage'))
        {
            return;
        }
        HudMovie.AddDeathMessage(RelatedPRI_1, RelatedPRI_2, Switch, class<EvilDmgType_Base>(OptionalObject));        
    }
    else
    {
        // End:0x15A
        if((UTMessageClass == none) || UTMessageClass.default.MessageArea > 6)
        {
            HudMovie.AddMessage("text", InMessageClass.static.GetString(Switch, false, RelatedPRI_1, RelatedPRI_2, OptionalObject));            
        }
        else
        {
            // End:0x214
            if((UTMessageClass.default.MessageArea < 4) || UTMessageClass.default.MessageArea == 6)
            {
                AdvGFxHud(HudMovie).SetCenterMessageText(InMessageClass.static.GetString(Switch, false, RelatedPRI_1, RelatedPRI_2, OptionalObject));
            }
        }
    }
    //return;    
}

function Message(PlayerReplicationInfo PRI, coerce string msg, name MsgType, optional float Lifetime)
{
    local class<LocalMessage> MsgClass;

    // End:0x2D
    if(bMessageBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    MsgClass = Class'EvilGame.UTSayMsg';
    // End:0xA9
    if((MsgType == 'Say') || MsgType == 'TeamSay')
    {
        msg = (PRI.PlayerName $ ": ") $ msg;
    }
    AddConsoleMessage(msg, MsgClass, PRI, Lifetime);
    //return;    
}

function AddConsoleMessage(string M, class<LocalMessage> InMessageClass, PlayerReplicationInfo PRI, optional float Lifetime)
{
    // End:0x51
    if(bMessageBeep && InMessageClass.default.bBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    HudMovie.AddMessage("text", M);
    //return;    
}

function ClearMessages()
{
    // End:0x2E
    if(HudMovie != none)
    {
        HudMovie.ClearMessages();
    }
    //return;    
}

exec function SetShowScores(bool bEnableShowScores)
{
    local bool bWasUsingGamepad;

    // End:0x25F
    if(bEnableShowScores)
    {
        // End:0x7E
        if(AdvScoreboardMovie == none)
        {
            AdvScoreboardMovie = new Class'AdvGFxUI_Scoreboard';
            AdvScoreboardMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
            AdvScoreboardMovie.SetTimingMode(1);
        }
        // End:0x251
        if(!AdvScoreboardMovie.bMovieIsOpen)
        {
            AdvScoreboardMovie.Init(LocalPlayer(PlayerOwner.Player));
            // End:0x251
            if(PlayerOwner.WorldInfo.IsConsoleBuild(0))
            {
                AdvScoreboardMovie.bCaptureInput = true;
                AdvScoreboardMovie.bOnlyOwnerFocusable = true;
                bWasUsingGamepad = PlayerOwner.PlayerInput.bUsingGamepad;
                AdvScoreboardMovie.FlushPlayerInput(false);
                PlayerOwner.PlayerInput.bUsingGamepad = bWasUsingGamepad;
                AdvScoreboardMovie.AddFocusIgnoreKey('XboxTypeS_Back');
                AdvScoreboardMovie.AddFocusIgnoreKey('XboxTypeS_Start');
            }
        }
        SetVisible(false);        
    }
    else
    {
        // End:0x2DC
        if((AdvScoreboardMovie != none) && AdvScoreboardMovie.bMovieIsOpen)
        {
            AdvScoreboardMovie.PlayCloseAnimation();
            AdvScoreboardMovie.Close(false);
            SetVisible(true);
        }
    }
    //return;    
}

function bool IsTeamPanelActive()
{
    return (AdvScoreboardMovie != none) && AdvScoreboardMovie.bMovieIsOpen;
    //return ReturnValue;    
}

exec function ShowScoreboardAndHud()
{
    local bool bWasUsingGamepad;

    // End:0x71
    if(AdvScoreboardMovie == none)
    {
        AdvScoreboardMovie = new Class'AdvGFxUI_Scoreboard';
        AdvScoreboardMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
        AdvScoreboardMovie.SetTimingMode(1);
    }
    // End:0x244
    if(!AdvScoreboardMovie.bMovieIsOpen)
    {
        AdvScoreboardMovie.Init(LocalPlayer(PlayerOwner.Player));
        // End:0x244
        if(PlayerOwner.WorldInfo.IsConsoleBuild(0))
        {
            AdvScoreboardMovie.bCaptureInput = true;
            AdvScoreboardMovie.bOnlyOwnerFocusable = true;
            bWasUsingGamepad = PlayerOwner.PlayerInput.bUsingGamepad;
            AdvScoreboardMovie.FlushPlayerInput(false);
            PlayerOwner.PlayerInput.bUsingGamepad = bWasUsingGamepad;
            AdvScoreboardMovie.AddFocusIgnoreKey('XboxTypeS_Back');
            AdvScoreboardMovie.AddFocusIgnoreKey('XboxTypeS_Start');
        }
    }
    AdvGFxHud(HudMovie).SetHUDElementsVisible(false);
    //return;    
}

exec function HideAndCloseScoreboard()
{
    // End:0x9B
    if((AdvScoreboardMovie != none) && AdvScoreboardMovie.bMovieIsOpen)
    {
        AdvScoreboardMovie.PlayCloseAnimation();
        AdvScoreboardMovie.Close(false);
        AdvGFxHud(HudMovie).SetHUDElementsVisible(true);
    }
    //return;    
}

simulated function ShowMPStatsScreen()
{
    // End:0x44
    if(!AdvGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        return;
    }
    // End:0xD9
    if((bBlockScoreboard || AdvGRI(WorldInfo.GRI).bMatchIsOver) || !AdvGRI(WorldInfo.GRI).bMatchHasBegun)
    {
        return;
    }
    // End:0x119
    if((AdvScoreboardMovie == none) || !AdvScoreboardMovie.bMovieIsOpen)
    {
        SetShowScores(true);
    }
    //return;    
}

simulated function HideMPStatsScreen()
{
    // End:0x44
    if(!AdvGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        return;
    }
    // End:0xD9
    if((bBlockScoreboard || AdvGRI(WorldInfo.GRI).bMatchIsOver) || !AdvGRI(WorldInfo.GRI).bMatchHasBegun)
    {
        return;
    }
    // End:0x117
    if((AdvScoreboardMovie != none) && AdvScoreboardMovie.bMovieIsOpen)
    {
        SetShowScores(false);
    }
    //return;    
}

simulated function ShowInGameStatsScreen()
{
    // End:0xA7
    if(((AdvGRI(WorldInfo.GRI) == none) && int(WorldInfo.NetMode) == int(NM_Client)) || AdvGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        ShowMPStatsScreen();        
    }
    //return;    
}

simulated function HideInGameStatsScreen()
{
    // End:0x4D
    if(AdvGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        HideMPStatsScreen();        
    }
    //return;    
}

function bool CanUnpauseFromUIOpen()
{
    local UIInteraction UIController;
    local bool bResult;

    bResult = true;
    UIController = PlayerOwner.GetUIController();
    // End:0x87
    if(UIController != none)
    {
        bResult = !UIController.SceneClient.IsUIActive(4);
    }
    return bResult;
    //return ReturnValue;    
}

function bool IsGamePaused()
{
    return (AdvPauseMenuMovie != none) && AdvPauseMenuMovie.bMovieIsOpen || (AdvPauseMenuMovie.OptionsMenu != none) && AdvPauseMenuMovie.OptionsMenu.bMovieIsOpen;
    //return ReturnValue;    
}

function PauseGame(optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpauseFromUIOpen)
{
    local AdvPlayerController MyPC, PC;
    local delegate<CanUnpause> DefaultUnpauseDelegate;
    local bool bBuddyIsAlreadyPaused, bGameOverForBuddy;

    // End:0x3A
    if(Class'Engine.WorldInfo'.static.IsMenuLevel())
    {
        return;
    }
    MyPC = AdvPlayerController(PlayerOwner);
    // End:0x8B
    if((GameOverMovie != none) && GameOverMovie.bMovieIsOpen)
    {
        return;
    }
    // End:0x1D3
    foreach MyPC.LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        // End:0x1D2
        if((PC != MyPC) && PC.AdvHudWrapper != none)
        {
            // End:0x13F
            if(PC.AdvHudWrapper.IsGamePaused())
            {
                bBuddyIsAlreadyPaused = true;
            }
            // End:0x1D2
            if((PC.AdvHudWrapper.GameOverMovie != none) && PC.AdvHudWrapper.GameOverMovie.bMovieIsOpen)
            {
                bGameOverForBuddy = true;
            }
        }        
    }    
    // End:0x225
    if((bGameOverForBuddy || bBuddyIsAlreadyPaused && MyPC.bCinematicMode) || IsGamePaused())
    {
        return;
    }
    // End:0x5D4
    if((GameOverMovie == none) && (int(MyPC.Role) != int(ROLE_Authority)) || !EndLevelStatsOpen())
    {
        CloseOtherMenus();
        // End:0x2A1
        if(AdvPauseMenuMovie == none)
        {
            AdvPauseMenuMovie = new AdvPauseMenuClass;
        }
        AdvPauseMenuMovie.LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));        
        // End:0x5D4
        if(AdvPauseMenuMovie.ActivatePauseScene(LocalPlayer(PlayerOwner.Player)))
        {
            // End:0x3AB
            if(AdvPauseMenuMovie.bPauseGameWhileActive)
            {
                PlayerOwner.SetPause(true);
            }
            // End:0x4CF
            if((int(PlayerOwner.Role) == int(ROLE_Authority)) && WorldInfo.Game.bPauseable)
            {
                bBuddyIsAlreadyPaused = false;
                // End:0x4CE
                foreach MyPC.LocalPlayerControllers(Class'AdvPlayerController', PC)
                {
                    // End:0x4CD
                    if((PC != MyPC) && PC.AdvHudWrapper != none)
                    {
                        // End:0x4CD
                        if(PC.AdvHudWrapper.IsGamePaused())
                        {
                            bBuddyIsAlreadyPaused = true;
                        }
                    }                    
                }                
            }
            // End:0x5D4
            if((int(WorldInfo.NetMode) != int(NM_Client)) || WorldInfo.IsPlayingDemo())
            {
                DefaultUnpauseDelegate = MyPC.CanUnpause;
                // End:0x5D4
                if(!MyPC.IsPaused() || CanUnpauseDelegate != DefaultUnpauseDelegate)
                {
                    // End:0x5D4
                    if(AdvPauseMenuMovie.bPauseGameWhileActive)
                    {
                        PlayerOwner.SetPause(true, CanUnpauseDelegate);
                    }
                }
            }
        }
    }
    //return;    
}

function OpenMutliplayerStartingScreen()
{
    // End:0x27
    if(AdvMultiStartingScreenMovie == none)
    {
        AdvMultiStartingScreenMovie = new Class'AdvGFxUI_Menu_MultiStartingScreen';
    }
    AdvMultiStartingScreenMovie.LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));    
    AdvMultiStartingScreenMovie.ActivatePauseScene(LocalPlayer(PlayerOwner.Player));
    //return;    
}

function OpenDemoScreen()
{
    // End:0x27
    if(AdvDemoScreen == none)
    {
        AdvDemoScreen = new Class'AdvGFxUI_Menu_DemoScreen';
    }
    AdvDemoScreen.LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));    
    AdvDemoScreen.ActivatePauseScene(LocalPlayer(PlayerOwner.Player));
    //return;    
}

function OpenMutliplayerEndScreen()
{
    // End:0x27
    if(AdvMultiEndScreenMovie == none)
    {
        AdvMultiEndScreenMovie = new Class'AdvGFxUI_EndScreenMP';
    }
    AdvMultiEndScreenMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
    AdvMultiEndScreenMovie.SetTimingMode(1);
    // End:0xDB
    if(!AdvMultiEndScreenMovie.bMovieIsOpen)
    {
        AdvMultiEndScreenMovie.Init(LocalPlayer(PlayerOwner.Player));
    }
    // End:0x12D
    if((AdvMultiRoundEndScreenMovie != none) && AdvMultiRoundEndScreenMovie.bMovieIsOpen)
    {
        AdvMultiRoundEndScreenMovie.EndOfMovie();
    }
    SetVisible(false);
    //return;    
}

function OpenMutliplayerRoundEndScreen()
{
    // End:0x27
    if(AdvMultiRoundEndScreenMovie == none)
    {
        AdvMultiRoundEndScreenMovie = new Class'AdvGFxUI_EndScreenRound';
    }
    AdvMultiRoundEndScreenMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
    AdvMultiRoundEndScreenMovie.SetTimingMode(1);
    // End:0xDB
    if(!AdvMultiRoundEndScreenMovie.bMovieIsOpen)
    {
        AdvMultiRoundEndScreenMovie.Init(LocalPlayer(PlayerOwner.Player));
    }
    SetVisible(false);
    //return;    
}

function OpenSurvivalEndScreen()
{
    // End:0x27
    if(AdvSurvivalEndScreenMovie == none)
    {
        AdvSurvivalEndScreenMovie = new Class'AdvGFxUI_EndScreenSurvival';
    }
    AdvSurvivalEndScreenMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
    AdvSurvivalEndScreenMovie.SetTimingMode(1);
    // End:0xDB
    if(!AdvSurvivalEndScreenMovie.bMovieIsOpen)
    {
        AdvSurvivalEndScreenMovie.Init(LocalPlayer(PlayerOwner.Player));
    }
    SetVisible(false);
    //return;    
}

function SetVisibilityForPause(bool bNewPaused)
{
    // End:0x24
    if(PlayerOwner.bCinematicMode)
    {
        return;
    }
    // End:0x70
    if(bNewPaused)
    {
        bWasVisibleBeforePause = bWasVisibleBeforePause || bShowHUD;
        // End:0x6D
        if(bShowHUD)
        {
            SetVisible(false);
        }        
    }
    else
    {
        // End:0x15F
        if((bWasVisibleBeforePause && !bShowHUD) && ((AdvPauseMenuMovie == none) || !AdvPauseMenuMovie.bMovieIsOpen) && ((AdvPauseMenuMovie != none) && (AdvPauseMenuMovie.OptionsMenu == none) || !AdvPauseMenuMovie.OptionsMenu.bMovieIsOpen) || AdvPauseMenuMovie == none)
        {
            SetVisible(true);
            bWasVisibleBeforePause = false;
        }
    }
    //return;    
}

function UnPauseGame()
{
    // End:0x53
    if((GameOverMovie != none) && GameOverMovie.bMovieIsOpen)
    {
        GameOverMovie.Close();
    }
    // End:0xA7
    if((DifficultyChangeMovie != none) && DifficultyChangeMovie.bMovieIsOpen)
    {
        DifficultyChangeMovie.PlayCloseAnimation();
        return;
    }
    // End:0xF9
    if((AdvPauseMenuMovie != none) && AdvPauseMenuMovie.bMovieIsOpen)
    {
        AdvPauseMenuMovie.PlayCloseAnimation();
    }
    //return;    
}

function ShowGameOverMenu()
{
    local bool bWasUsingGamepad;

    CloseOtherMenus();
    PlayerOwner.SetPause(true);
    // End:0x9C
    if(GameOverMovie == none)
    {
        GameOverMovie = new Class'AdvGFxUI_GameOverMenu';
        GameOverMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
        GameOverMovie.SetTimingMode(1);
    }
    SetVisible(false);
    bWasUsingGamepad = PlayerOwner.PlayerInput.bUsingGamepad;
    GameOverMovie.FlushPlayerInput(false);
    PlayerOwner.PlayerInput.bUsingGamepad = bWasUsingGamepad;
    GameOverMovie.Init(LocalPlayer(PlayerOwner.Player));
    GameOverMovie.PlayOpenAnimation();
    GameOverMovie.AddFocusIgnoreKey('Escape');
    GameOverMovie.AddFocusIgnoreKey('XboxTypeS_B');
    //return;    
}

exec function ToggleInventory()
{
    // End:0x55
    if((InventoryMovie != none) && InventoryMovie.bMovieIsOpen)
    {
        InventoryMovie.StartCloseAnimation();        
    }
    else
    {
        // End:0x1C4
        if(PlayerOwner.Pawn != none)
        {
            // End:0xA0
            if(InventoryMovie == none)
            {
                InventoryMovie = new Class'EvilGame.GFxProjectedUI';
            }
            InventoryMovie.LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));            
            InventoryMovie.SetTimingMode(1);
            InventoryMovie.Start();
            // End:0x1B9
            if(!WorldInfo.bPlayersOnly)
            {                
                PlayerOwner.ConsoleCommand("playersonly");
            }
            SetVisible(false);
        }
    }
    //return;    
}

function CompleteCloseInventory()
{
    // End:0x58
    if(WorldInfo.bPlayersOnly)
    {        
        PlayerOwner.ConsoleCommand("playersonly");
    }
    SetTimer(0.1000000, false, 'CompleteCloseTimer');
    //return;    
}

function CompleteCloseTimer()
{
    // End:0x53
    if((InventoryMovie != none) && InventoryMovie.bMovieIsOpen)
    {
        InventoryMovie.Close(false);
    }
    SetVisible(true);
    //return;    
}

function ToggleQuickMenu(optional AdvTypes.EInventoryItem SelectedItem)
{
    // End:0x25
    if(PlayerOwner.bCinematicMode)
    {
        return;
    }
    // End:0x90
    if(((QuickMenuMovie != none) && QuickMenuMovie.bMovieIsOpen) || int(SelectedItem) == int(0))
    {
        QuickMenuMovie.PlayCloseAnimation();        
    }
    else
    {
        CloseOtherMenus();
        // End:0x188
        if(QuickMenuMovie == none)
        {
            QuickMenuMovie = new Class'AdvGFxUI_InventoryMenu';
            QuickMenuMovie.MovieInfo = SwfMovie'UI_EvilUI.EvilInventory';
            QuickMenuMovie.LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));            
            QuickMenuMovie.SetTimingMode(1);
        }
        HudMovie.HideGameplayIndicator();
        SetVisible(false);
        QuickMenuMovie.Start();
        QuickMenuMovie.PlayOpenAnimation(SelectedItem);
    }
    //return;    
}

function CompleteQuickMenuClose()
{
    QuickMenuMovie.Close(false);
    SetVisible(true);
    //return;    
}

function ShowUpgradesMenu()
{
    // End:0x24
    if(PlayerOwner.bCinematicMode)
    {
        return;
    }
    CloseOtherMenus();
    // End:0x55
    if(UpgradesMenu == none)
    {
        UpgradesMenu = new Class'AdvGFxUI_Upgrades';
    }
    HudMovie.HideGameplayIndicator();
    SetVisible(false);
    UpgradesMenu.Init(LocalPlayer(PlayerOwner.Player));
    //return;    
}

function CompleteUpgradesMenuClose()
{
    UpgradesMenu.Close(true);
    UpgradesMenu = none;
    SetVisible(true);
    //return;    
}

function CompletePauseMenuClose()
{
    PlayerOwner.SetPause(false);
    // End:0x74
    if((PauseMenuMovie != none) && PauseMenuMovie.bMovieIsOpen)
    {
        PauseMenuMovie.Close(false);
    }
    // End:0xC7
    if((GameOverMovie != none) && GameOverMovie.bMovieIsOpen)
    {
        GameOverMovie.Close(false);
    }
    SetVisible(true);
    //return;    
}

exec function ShowAIDebug()
{
    bShowAIDebug = !bShowAIDebug;
    //return;    
}

function DrawCovers()
{
    local CoverInfo covinf;
    local Color Col;

    // End:0x53A
    foreach CachedCoverInfos(covinf)
    {
        // End:0x465
        if(covinf.Link.IsEnabled())
        {
            // End:0x113
            if(covinf.Link.Slots[covinf.SlotIdx].SlotOwner != none)
            {
                Col.R = 0;
                Col.G = 0;
                Col.B = 255;                
            }
            else
            {
                Col.R = 0;
                Col.G = 255;
                Col.B = 0;
            }
            DrawDebugBox(covinf.Link.GetSlotLocation(covinf.SlotIdx), vect(5.0000000, 5.0000000, 5.0000000), Col.R, Col.G, Col.B);
            DrawDebugBox(covinf.Link.GetSlotViewPoint(covinf.SlotIdx,, 7), vect(2.0000000, 2.0000000, 2.0000000), Col.R, Col.G, Col.B);
            DrawDebugBox(covinf.Link.GetSlotViewPoint(covinf.SlotIdx,, 8), vect(2.0000000, 2.0000000, 2.0000000), Col.R, Col.G, Col.B);
            DrawDebugBox(covinf.Link.GetSlotViewPoint(covinf.SlotIdx,, 9), vect(2.0000000, 2.0000000, 2.0000000), Col.R, Col.G, Col.B);            
        }
        else
        {
            Col.R = 255;
            DrawDebugSphere(covinf.Link.GetSlotLocation(covinf.SlotIdx), 20.0000000, 20, Col.R, Col.G, Col.B);
        }        
    }    
    //return;    
}

function DrawAIOverlays()
{
    local AIController B;
    local Vector pos;
    local float XL, YL;
    local string Text;

    Canvas.Font = GetFontSizeIndex(0);
    // End:0x4D4
    foreach WorldInfo.AllControllers(Class'Engine.AIController', B)
    {
        // End:0x4D3
        if(B.Pawn != none)
        {
            DrawRoute(B.Pawn);
            // End:0x4D3
            if((Vector(PlayerOwner.Rotation) Dot (B.Pawn.Location - PlayerOwner.ViewTarget.Location)) > 0.0000000)
            {
                pos = Canvas.Project(B.Pawn.Location + (B.Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.1000000)));
                Text = ((B.IsA('EvilAIController')) ? EvilAIController(B).GetDebugString() : ((B.IsA('EvilAI_Creature')) ? EvilAI_Creature(B).GetDebugString() : ""));
                Canvas.StrLen(Text, XL, YL);
                pos.X = FClamp(pos.X, 0.0000000, Canvas.ClipX - XL);
                pos.Y = FClamp(pos.Y, 0.0000000, Canvas.ClipY - YL);
                Canvas.SetPos(pos.X, pos.Y);
                Canvas.DrawColor = RedColor;
                Canvas.DrawColor.A = ((LocalPlayer(PlayerOwner.Player).GetActorVisibility(B.Pawn)) ? 255 : 128);
                Canvas.DrawText(Text);
            }
        }        
    }    
    //return;    
}

function DrawRoute(Pawn Target)
{
    local EvilCreature EC;

    // End:0x19D
    if(!Target.IsA('EvilCreature'))
    {
        super.DrawRoute(Target);
        DrawDebugLine(Target.Location, Target.Location + (Vector(Target.Rotation) * 128.0000000), 255, 255, 0);
        DrawDebugLine(Target.Location, Target.Location + (Vector(Target.DesiredRotation) * 128.0000000), 0, 255, 0);
        DrawDebugLine(Target.Location, Target.Location + (Normal(Target.Velocity) * 128.0000000), 0, 0, 255);        
    }
    else
    {
        EC = EvilCreature(Target);
        // End:0x22C
        if(!IsZero(EC.DesiredLocation))
        {
            DrawDebugLine(EC.Location, EC.DesiredLocation, 0, 0, 255);
        }
        DrawDebugLine(EC.Location, EC.Location + (Vector(EC.Rotation) * float(100)), 0, 255, 0);
        DrawDebugLine(EC.Location, EC.Location + (Vector(EC.DesiredRotation) * float(100)), 255, 0, 0);
        // End:0x3F8
        if(EC.IsA('EvilCreatureFlying'))
        {
            DrawDebugLine(EC.Location, EC.Location + (((EC.DesiredSpeed * Vector(EC.DesiredRotation)) * EvilCreatureFlying(EC).LookAheadInterval) * 0.5000000), 255, 255, 0);
        }
    }
    //return;    
}

exec function ShowQTEButton(EvilTypes.EGameButtons Button)
{
    // End:0x91
    if(QTE == none)
    {
        QTE = new Class'AdvGFxUI_QTE';
        QTE.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
        QTE.SetTimingMode(1);
        QTE.Start();
    }
    QTE.ShowButton(Button);
    //return;    
}

function DrawTimer()
{
    Canvas.Font = GetFontSizeIndex(1);
    Canvas.SetDrawColor(128, 128, 128);
    Canvas.SetPos(600.0000000, 20.0000000, 0.0000000);
    //return;    
}

final function bool EndLevelStatsOpen()
{
    return EndStatsMovie != none;
    //return ReturnValue;    
}

simulated function ShowEndStatsScreen()
{
    // End:0x71
    if(EndStatsMovie == none)
    {
        EndStatsMovie = new Class'AdvGFxUI_EndStats';
        EndStatsMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
        EndStatsMovie.SetTimingMode(1);
    }
    EndStatsMovie.Init(LocalPlayer(PlayerOwner.Player));
    EndStatsMovie.PlayOpenAnimation();
    //return;    
}

simulated function CheckCardUnlockingStatusAndPlayAllEndLevelScreens()
{
    ShowEndStatsScreen();
    //return;    
}

simulated function ToggleEndGameSPStatsScreen()
{
    // End:0x60
    if((EndStatsMovie != none) && EndStatsMovie.bMovieIsOpen)
    {
        EndStatsMovie.PlayCloseAnimation();
        EndStatsMovie = none;        
    }
    else
    {
        // End:0x1C6
        if((AdvGRI_SP(WorldInfo.GRI) != none) && AdvGRI_SP(WorldInfo.GRI).bForceNextLevel)
        {
            // End:0x140
            if(EndStatsMovie == none)
            {
                EndStatsMovie = new Class'AdvGFxUI_EndStats';
                EndStatsMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
                EndStatsMovie.SetTimingMode(1);
            }
            // End:0x1A4
            if(EndStatsMovie.StartNextLevel())
            {
                AdvGRI_SP(WorldInfo.GRI).bForceNextLevel = false;                
            }
            else
            {
                EndStatsMovie.PlayOpenAnimation();
            }            
        }
        else
        {
            CheckCardUnlockingStatusAndPlayAllEndLevelScreens();
        }
    }
    //return;    
}

simulated function ShowInGameSPStatsScreen()
{
    // End:0x71
    if(StatsMovie == none)
    {
        StatsMovie = new Class'AdvGFxUI_Stats';
        StatsMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
        StatsMovie.SetTimingMode(1);
    }
    StatsMovie.Init(LocalPlayer(PlayerOwner.Player));
    StatsMovie.PlayOpenAnimation();
    //return;    
}

simulated function HideInGameSPStatsScreen()
{
    // End:0x5D
    if((StatsMovie != none) && StatsMovie.bMovieIsOpen)
    {
        StatsMovie.PlayCloseAnimation();
        StatsMovie = none;
    }
    //return;    
}

simulated function ShowCredits(class<AdvGFxUI_Credits> CreditsClass)
{
    local bool bWasUsingGamepad;

    // End:0x27
    if(CreditsMovie == none)
    {
        CreditsMovie = new CreditsClass;
    }
    // End:0x7F
    if(PlayerOwner.Pawn != none)
    {
        PlayerOwner.Pawn.ZeroMovementVariables();
    }
    bWasUsingGamepad = PlayerOwner.PlayerInput.bUsingGamepad;
    CreditsMovie.FlushPlayerInput(false);
    PlayerOwner.PlayerInput.bUsingGamepad = bWasUsingGamepad;
    CreditsMovie.Init(LocalPlayer(PlayerOwner.Player));
    //return;    
}

defaultproperties
{
    AdvPauseMenuClass=Class'AdvGFxUI_PauseMenu'
    HUDClass=Class'AdvGFxHud'
    bCrosshairShow=true
}