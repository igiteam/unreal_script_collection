class PainGFxHudWrapper extends EvilGFxHudWrapper
    transient
    config(Game)
    hidecategories(Navigation);

enum EMessageBoxType
{
    EMBT_Info,                      // 0
    EMBT_InfoNoButton,              // 1
    EMBT_Confirm,                   // 2
    EMBT_MAX                        // 3
};

var PKGFxUI_GameOverMenu GameOverMovie;
var PKGFxUI_PauseDifficultyMenu DifficultyChangeMovie;
var PKGFxUI_Scoreboard PKScoreboardMovie;
var bool bBlockScoreboard;
var bool bShowContinueMsgOnStats;
var bool bBusyIndicatorHideCalled;
var bool bWasVisibleBeforePause;
var PKGFxUI_Stats StatsMovie;
var PKGFxUI_EndStats EndStatsMovie;
var PKGFxUI_SurvivalComplete SurvivalEndMovie;
var PKGFxUI_TarotPopUp TarotPopUp;
var PainGFxUI_PauseMenu PKPauseMenuMovie;
var PKGFxUI_Credits CreditsMovie;
var PKGFxUI_TarotCards TarotMovie;
var array<PKGFxUI_Info> OpenMsgBox;
var PKGFxUI_Busy BusyIndicator;

function ShowMessageBox(PainGFxHudWrapper.EMessageBoxType MsgType, string MessageTag, string Text, optional delegate<OnMessageBoxFinish> MsgBoxFinishCallback = None, optional bool bPauseGame, optional out PKGFxUI_Info out_MessageBox)
{
    local PKGFxUI_Info MsgBox;
    local int I;

    I = 0;
    J0x22:

    // End:0x9E [Loop If]
    if(I < OpenMsgBox.Length)
    {
        // End:0x90
        if(OpenMsgBox[I].MessageTag == MessageTag)
        {
            MsgBox = OpenMsgBox[I];
            // [Explicit Break]
            goto J0x9E;
        }
        I++;
        // [Loop Continue]
        goto J0x22;
    }
    J0x9E:

    // End:0x2CD
    if(MsgBox == none)
    {
        // End:0xF2
        if((int(MsgType) == int(0)) || int(MsgType) == int(1))
        {
            MsgBox = new Class'PKGFxUI_Info';            
        }
        else
        {
            // End:0x11E
            if(int(MsgType) == int(2))
            {
                MsgBox = new Class'PKGFxUI_Confirm';
            }
        }
        // End:0x155
        if(bPauseGame)
        {
            MsgBox.bPauseGameWhileActive = bPauseGame;
        }
        MsgBox.SetTimingMode(1);
        MsgBox.Init(LocalPlayer(PlayerOwner.Player));
        MsgBox.SetText(Text);
        MsgBox.PlayOpenAnimation();
        MsgBox.SetPriority(70);
        // End:0x25B
        if(MsgBoxFinishCallback != none)
        {
            MsgBox.__OnMessageBoxFinish__Delegate = MsgBoxFinishCallback;
        }
        OpenMsgBox.AddItem(MsgBox);
        // End:0x2BA
        if(int(MsgType) == int(1))
        {
            MsgBox.OkBtn.SetVisible(false);
        }
        out_MessageBox = MsgBox;
    }
    //return;    
}

function RemoveMessageBoxReference(PKGFxUI_Info MessageBox)
{
    OpenMsgBox.RemoveItem(MessageBox);
    //return;    
}

function ShowBusyIndicator(optional bool bBlockInput, optional out PKGFxUI_Busy out_BusyIndicator)
{
    // End:0x105
    if(BusyIndicator == none)
    {
        BusyIndicator = new Class'PKGFxUI_Busy';
        BusyIndicator.SetTimingMode(1);
        BusyIndicator.bCaptureInput = bBlockInput;
        BusyIndicator.bAllowFocus = bBlockInput;
        BusyIndicator.Init(LocalPlayer(PlayerOwner.Player));
        BusyIndicator.SetPriority(100);
    }
    SetTimer(3.0000000, false, 'HideBusyIndicator_t');
    bBusyIndicatorHideCalled = false;
    out_BusyIndicator = BusyIndicator;
    //return;    
}

function HideBusyIndicator()
{
    // End:0x26
    if(IsTimerActive('HideBusyIndicator_t'))
    {
        bBusyIndicatorHideCalled = true;        
    }
    else
    {
        // End:0x60
        if(BusyIndicator != none)
        {
            BusyIndicator.Close(true);
            BusyIndicator = none;
        }
    }
    //return;    
}

function HideBusyIndicator_t()
{
    // End:0x49
    if(bBusyIndicatorHideCalled && BusyIndicator != none)
    {
        BusyIndicator.Close(true);
        BusyIndicator = none;
    }
    bBusyIndicatorHideCalled = false;
    //return;    
}

event Destroyed()
{
    RemoveMovies();
    HideBusyIndicator();
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
    if(PKPauseMenuMovie != none)
    {
        PKPauseMenuMovie.Close();
        PKPauseMenuMovie = none;
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
    HudMovie.ToggleCrosshair(bNewVisible);
    super(UTHUDBase).SetVisible(bNewVisible);
    HudMovie.SetPause(!bNewVisible);
    //return;    
}

function ResolutionChanged()
{
    super(UTHUDBase).ResolutionChanged();
    CreateHUDMovie();
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
    // End:0xF7
    if((PKPauseMenuMovie != none) && PKPauseMenuMovie.bMovieIsOpen)
    {
        PKPauseMenuMovie.Tick(RenderDelta);
    }
    // End:0x12E
    if(StatsMovie != none)
    {
        StatsMovie.Tick(RenderDelta);
    }
    // End:0x189
    if((PKScoreboardMovie != none) && PKScoreboardMovie.bMovieIsOpen)
    {
        PKScoreboardMovie.Tick(RenderDelta);
    }
    // End:0x22F
    if((!bShowHUD && PlayerOwner.IsInState('Demon')) && PlayerOwner.Pawn != none)
    {
        PlayerOwner.Pawn.InvManager.DrawHUD(self);
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
    //return;    
}

function LocalizedMessage(class<LocalMessage> InMessageClass, PlayerReplicationInfo RelatedPRI_1, PlayerReplicationInfo RelatedPRI_2, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor, optional Object OptionalObject)
{
    local class<UTLocalMessage> UTMessageClass;

    UTMessageClass = class<UTLocalMessage>(InMessageClass);
    // End:0xAD
    if(!ClassIsChildOf(WorldInfo.GetGameClass(), Class'PKGameDeathmatch') && ClassIsChildOf(InMessageClass, Class'EvilGame.EvilDeathMessage'))
    {
        HudMovie.AddDeathMessage(RelatedPRI_1, RelatedPRI_2, class<EvilDmgType_Base>(OptionalObject));        
    }
    else
    {
        // End:0x14F
        if((UTMessageClass == none) || UTMessageClass.default.MessageArea > 6)
        {
            HudMovie.AddMessage("text", InMessageClass.static.GetString(Switch, false, RelatedPRI_1, RelatedPRI_2, OptionalObject));            
        }
        else
        {
            // End:0x207
            if((UTMessageClass.default.MessageArea < 4) || UTMessageClass.default.MessageArea == 6)
            {
                PainGFxHud(HudMovie).SetCenterText(InMessageClass.static.GetString(Switch, false, RelatedPRI_1, RelatedPRI_2, OptionalObject));
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
    // End:0xE9
    if((MsgType == 'Say') || MsgType == 'TeamSay')
    {
        msg = (PRI.PlayerName $ ": ") $ msg;
        // End:0xD6
        if(MsgType == 'TeamSay')
        {
            MsgClass = Class'PKTeamSayMsg';            
        }
        else
        {
            MsgClass = Class'PKSayMsg';
        }
    }
    AddConsoleMessage(msg, MsgClass, PRI, Lifetime);
    //return;    
}

function AddConsoleMessage(string M, class<LocalMessage> InMessageClass, PlayerReplicationInfo PRI, optional float Lifetime)
{
    local Color MsgColor;
    local string FinalMsg;

    // End:0x51
    if(bMessageBeep && InMessageClass.default.bBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    // End:0x22D
    if(InMessageClass == Class'PKSayMsg')
    {
        MsgColor = InMessageClass.static.GetConsoleColor(PRI);
        FinalMsg = "<Color:";        
        FinalMsg $= ("R=" $ string(float(MsgColor.R) / 255.0000000));        
        FinalMsg $= ",";        
        FinalMsg $= ("G=" $ string(float(MsgColor.G) / 255.0000000));        
        FinalMsg $= ",";        
        FinalMsg $= ("B=" $ string(float(MsgColor.B) / 255.0000000));        
        FinalMsg $= ">";        
        FinalMsg $= M;        
        FinalMsg $= "</Color>";
        HudMovie.AddMessage("htmlText", FinalMsg);        
    }
    else
    {
        HudMovie.AddMessage("text", M);
    }
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
    return (PKPauseMenuMovie != none) && PKPauseMenuMovie.bMovieIsOpen;
    //return ReturnValue;    
}

function PauseGame(optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpauseFromUIOpen)
{
    local PKPlayerController MyPKPC, PC;
    local delegate<CanUnpause> DefaultUnpauseDelegate;
    local bool bBuddyIsAlreadyPaused, bGameOverForBuddy;

    // End:0x3A
    if(Class'Engine.WorldInfo'.static.IsMenuLevel())
    {
        return;
    }
    MyPKPC = PKPlayerController(PlayerOwner);
    // End:0x8B
    if((GameOverMovie != none) && GameOverMovie.bMovieIsOpen)
    {
        return;
    }
    // End:0x185
    foreach MyPKPC.LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        // End:0x184
        if((PC != MyPKPC) && PC.PKHudWrapper != none)
        {
            // End:0x13F
            if(PC.PKHudWrapper.IsGamePaused())
            {
                bBuddyIsAlreadyPaused = true;
            }
            // End:0x184
            if(PC.PKHudWrapper.GameOverMovie != none)
            {
                bGameOverForBuddy = true;
            }
        }        
    }    
    // End:0x1C8
    if(bGameOverForBuddy || bBuddyIsAlreadyPaused && MyPKPC.bCinematicMode)
    {
        return;
    }
    // End:0x533
    if((GameOverMovie == none) && (int(MyPKPC.Role) != int(ROLE_Authority)) || !EndLevelStatsOpen())
    {
        CloseOtherMenus();
        // End:0x244
        if(PKPauseMenuMovie == none)
        {
            PKPauseMenuMovie = new Class'PainGFxUI_PauseMenu';
        }
        PKPauseMenuMovie.LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
        // End:0x533
        if(PKPauseMenuMovie.ActivatePauseScene(LocalPlayer(PlayerOwner.Player)))
        {
            PlayerOwner.SetPause(true);
            // End:0x450
            if((int(PlayerOwner.Role) == int(ROLE_Authority)) && WorldInfo.Game.bPauseable)
            {
                bBuddyIsAlreadyPaused = false;
                // End:0x44F
                foreach MyPKPC.LocalPlayerControllers(Class'PKPlayerController', PC)
                {
                    // End:0x44E
                    if((PC != MyPKPC) && PC.PKHudWrapper != none)
                    {
                        // End:0x44E
                        if(PC.PKHudWrapper.IsGamePaused())
                        {
                            bBuddyIsAlreadyPaused = true;
                        }
                    }                    
                }                
            }
            // End:0x533
            if((int(WorldInfo.NetMode) != int(NM_Client)) || WorldInfo.IsPlayingDemo())
            {
                DefaultUnpauseDelegate = MyPKPC.CanUnpause;
                // End:0x533
                if(!MyPKPC.IsPaused() || CanUnpauseDelegate != DefaultUnpauseDelegate)
                {
                    PlayerOwner.SetPause(true, CanUnpauseDelegate);
                }
            }
        }
    }
    //return;    
}

function SetVisibilityForPause(bool bNewPaused)
{
    // End:0x4C
    if(bNewPaused)
    {
        bWasVisibleBeforePause = bWasVisibleBeforePause || bShowHUD;
        // End:0x49
        if(bShowHUD)
        {
            SetVisible(false);
        }        
    }
    else
    {
        // End:0x81
        if(bWasVisibleBeforePause && !bShowHUD)
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
    if((PKPauseMenuMovie != none) && PKPauseMenuMovie.bMovieIsOpen)
    {
        PKPauseMenuMovie.PlayCloseAnimation();
    }
    //return;    
}

function ShowGameOverMenu()
{
    CloseOtherMenus();
    PlayerOwner.SetPause(true);
    // End:0x9C
    if(GameOverMovie == none)
    {
        GameOverMovie = new Class'PKGFxUI_GameOverMenu';
        GameOverMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
        GameOverMovie.SetTimingMode(1);
    }
    SetVisible(false);
    GameOverMovie.Init(LocalPlayer(PlayerOwner.Player));
    GameOverMovie.PlayOpenAnimation();
    GameOverMovie.AddFocusIgnoreKey('Escape');
    GameOverMovie.AddFocusIgnoreKey('XboxTypeS_B');
    //return;    
}

exec function SetShowScores(bool bEnableShowScores)
{
    // End:0x35
    if((LeaderboardMovie != none) && LeaderboardMovie.bMovieIsOpen)
    {
        return;
    }
    // End:0xA6
    if((PainGRI(WorldInfo.GRI) != none) && PainGRI(WorldInfo.GRI).IsSingleSurvivalGame())
    {
        return;
    }
    // End:0x242
    if(bEnableShowScores)
    {
        // End:0x124
        if(PKScoreboardMovie == none)
        {
            PKScoreboardMovie = new Class'PKGFxUI_Scoreboard';
            PKScoreboardMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
            PKScoreboardMovie.SetTimingMode(1);
        }
        // End:0x18E
        if(!PKScoreboardMovie.bMovieIsOpen)
        {
            PKScoreboardMovie.Init(LocalPlayer(PlayerOwner.Player));
        }
        // End:0x1FD
        if(bShowContinueMsgOnStats)
        {
            PKScoreboardMovie.FooterItemTF.SetText(Class'PKGFxUI_Stats'.default.ContinueLabel);
            bShowContinueMsgOnStats = false;            
        }
        else
        {
            PKScoreboardMovie.FooterItemTF.SetText("");
        }
        SetVisible(false);        
    }
    else
    {
        // End:0x2BF
        if((PKScoreboardMovie != none) && PKScoreboardMovie.bMovieIsOpen)
        {
            PKScoreboardMovie.PlayCloseAnimation();
            PKScoreboardMovie.Close(false);
            SetVisible(true);
        }
    }
    //return;    
}

function bool IsTeamPanelActive()
{
    return (PKScoreboardMovie != none) && PKScoreboardMovie.bMovieIsOpen;
    //return ReturnValue;    
}

exec function ShowScoreboardAndHud()
{
    // End:0x71
    if(PKScoreboardMovie == none)
    {
        PKScoreboardMovie = new Class'PKGFxUI_Scoreboard';
        PKScoreboardMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
        PKScoreboardMovie.SetTimingMode(1);
    }
    // End:0xDB
    if(!PKScoreboardMovie.bMovieIsOpen)
    {
        PKScoreboardMovie.Init(LocalPlayer(PlayerOwner.Player));
    }
    PainGFxHud(HudMovie).SetHUDElementsVisible(false);
    //return;    
}

exec function HideAndCloseScoreboard()
{
    // End:0x9B
    if((PKScoreboardMovie != none) && PKScoreboardMovie.bMovieIsOpen)
    {
        PKScoreboardMovie.PlayCloseAnimation();
        PKScoreboardMovie.Close(false);
        PainGFxHud(HudMovie).SetHUDElementsVisible(true);
    }
    //return;    
}

final function bool EndLevelStatsOpen()
{
    return EndStatsMovie != none;
    //return ReturnValue;    
}

simulated function ShowMPStatsScreen()
{
    // End:0x44
    if(!PainGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        return;
    }
    // End:0xD9
    if((bBlockScoreboard || PainGRI(WorldInfo.GRI).bMatchIsOver) || !PainGRI(WorldInfo.GRI).bMatchHasBegun)
    {
        return;
    }
    // End:0x119
    if((PKScoreboardMovie == none) || !PKScoreboardMovie.bMovieIsOpen)
    {
        SetShowScores(true);
    }
    //return;    
}

simulated function HideMPStatsScreen()
{
    // End:0x44
    if(!PainGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        return;
    }
    // End:0xD9
    if((bBlockScoreboard || PainGRI(WorldInfo.GRI).bMatchIsOver) || !PainGRI(WorldInfo.GRI).bMatchHasBegun)
    {
        return;
    }
    // End:0x117
    if((PKScoreboardMovie != none) && PKScoreboardMovie.bMovieIsOpen)
    {
        SetShowScores(false);
    }
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
        if((PainGRI_SP(WorldInfo.GRI) != none) && PainGRI_SP(WorldInfo.GRI).bForceNextLevel)
        {
            // End:0x140
            if(EndStatsMovie == none)
            {
                EndStatsMovie = new Class'PKGFxUI_EndStats';
                EndStatsMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
                EndStatsMovie.SetTimingMode(1);
            }
            // End:0x1A4
            if(EndStatsMovie.StartNextLevel())
            {
                PainGRI_SP(WorldInfo.GRI).bForceNextLevel = false;                
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

simulated function ShowEndStatsScreen()
{
    // End:0x71
    if(EndStatsMovie == none)
    {
        EndStatsMovie = new Class'PKGFxUI_EndStats';
        EndStatsMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
        EndStatsMovie.SetTimingMode(1);
    }
    EndStatsMovie.Init(LocalPlayer(PlayerOwner.Player));
    EndStatsMovie.PlayOpenAnimation();
    //return;    
}

simulated function ShowEndSurvivalSPScreen(int LevelIndex, bool bCompleted, int Kills, int InAdditinalScore, int InDescriptionId)
{
    // End:0x71
    if(SurvivalEndMovie == none)
    {
        SurvivalEndMovie = new Class'PKGFxUI_SurvivalComplete';
        SurvivalEndMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
        SurvivalEndMovie.SetTimingMode(1);
    }
    SetVisible(false);
    SurvivalEndMovie.Init(LocalPlayer(PlayerOwner.Player));
    SurvivalEndMovie.SetTexts(LevelIndex, bCompleted, Kills, InAdditinalScore, InDescriptionId);
    //return;    
}

simulated function CheckCardUnlockingStatusAndPlayAllEndLevelScreens()
{
    local PKPlayerController PC;
    local PainGRI_SP PKGRI;

    PC = PKPlayerController(PlayerOwner);
    PKGRI = PainGRI_SP(WorldInfo.GRI);
    // End:0x231
    if((int(PKGRI.UnlockCardStatusPerMap[PKGRI.ChapterNum].GoldenCard) != int(0)) && PC.ProfileSettings.HasUnlockedGoldCard(PKGRI.UnlockCardStatusPerMap[PKGRI.ChapterNum].GoldenCard))
    {
        TarotPopUp = new Class'PKGFxUI_TarotPopUp';
        TarotPopUp.Init(LocalPlayer(PlayerOwner.Player));
        TarotPopUp.__OnCloseComplete__Delegate = OnGoldenTarotPopUpComplete;
        TarotPopUp.SetGoldenCardAndPlay(PKGRI.UnlockCardStatusPerMap[PKGRI.ChapterNum].GoldenCard);        
    }
    else
    {
        // End:0x415
        if((int(PKGRI.UnlockCardStatusPerMap[PKGRI.ChapterNum].SilverCard) != int(0)) && PC.ProfileSettings.HasUnlockedSilverCard(PKGRI.UnlockCardStatusPerMap[PKGRI.ChapterNum].SilverCard))
        {
            TarotPopUp = new Class'PKGFxUI_TarotPopUp';
            TarotPopUp.Init(LocalPlayer(PlayerOwner.Player));
            TarotPopUp.__OnCloseComplete__Delegate = OnSilverTarotPopUpComplete;
            TarotPopUp.SetSilverCardAndPlay(PKGRI.UnlockCardStatusPerMap[PKGRI.ChapterNum].SilverCard);            
        }
        else
        {
            ShowEndStatsScreen();
        }
    }
    //return;    
}

simulated function OnGoldenTarotPopUpComplete()
{
    local PKPlayerController PC;
    local PainGRI_SP PKGRI;

    TarotPopUp.Close();
    TarotPopUp = none;
    PC = PKPlayerController(PlayerOwner);
    PKGRI = PainGRI_SP(WorldInfo.GRI);
    // End:0x25C
    if((int(PKGRI.UnlockCardStatusPerMap[PKGRI.ChapterNum].SilverCard) != int(0)) && PC.ProfileSettings.HasUnlockedSilverCard(PKGRI.UnlockCardStatusPerMap[PKGRI.ChapterNum].SilverCard))
    {
        TarotPopUp = new Class'PKGFxUI_TarotPopUp';
        TarotPopUp.Init(LocalPlayer(PlayerOwner.Player));
        TarotPopUp.__OnCloseComplete__Delegate = OnSilverTarotPopUpComplete;
        TarotPopUp.SetSilverCardAndPlay(PKGRI.UnlockCardStatusPerMap[PKGRI.ChapterNum].SilverCard);        
    }
    else
    {
        ShowEndStatsScreen();
    }
    //return;    
}

simulated function OnSilverTarotPopUpComplete()
{
    TarotPopUp.Close();
    TarotPopUp = none;
    ShowEndStatsScreen();
    //return;    
}

simulated function ShowInGameSPStatsScreen()
{
    // End:0x71
    if(StatsMovie == none)
    {
        StatsMovie = new Class'PKGFxUI_Stats';
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

simulated function ShowInGameStatsScreen()
{
    // End:0xA7
    if(((PainGRI(WorldInfo.GRI) == none) && int(WorldInfo.NetMode) == int(NM_Client)) || PainGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        ShowMPStatsScreen();        
    }
    else
    {
        ShowInGameSPStatsScreen();
    }
    //return;    
}

simulated function HideInGameStatsScreen()
{
    // End:0x4D
    if(PainGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        HideMPStatsScreen();        
    }
    else
    {
        HideInGameSPStatsScreen();
    }
    //return;    
}

simulated function ShowCredits()
{
    // End:0x27
    if(CreditsMovie == none)
    {
        CreditsMovie = new Class'PKGFxUI_Credits';
    }
    CreditsMovie.Init(LocalPlayer(PlayerOwner.Player));
    //return;    
}

simulated function ShowTarotMenu(optional bool bShowStartText = false)
{
    // End:0x9C
    if(TarotMovie == none)
    {
        TarotMovie = new Class'PKGFxUI_TarotCards';
        TarotMovie.bShowStartText = bShowStartText;
        TarotMovie.Init(LocalPlayer(PlayerOwner.Player));
    }
    //return;    
}

simulated function CloseTarotMenu()
{
    // End:0x3A
    if(TarotMovie != none)
    {
        TarotMovie.Close();
        TarotMovie = none;
    }
    //return;    
}

defaultproperties
{
    HUDClass=Class'PainGFxHud'
    bCrosshairShow=true
}