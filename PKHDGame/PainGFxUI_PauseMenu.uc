class PainGFxUI_PauseMenu extends PKGfxMoviePlayer
    config(UI);

enum EPauseOptions
{
    EPO_Resume,                     // 0
    EPO_Options,                    // 1
    EPO_ReturnToMainMenu,           // 2
    EPO_LoadCheckpoint,             // 3
    EPO_RestartChapter,             // 4
    EPO_ChangeDifficulty,           // 5
    EPO_Respawn,                    // 6
    EPO_MAX                         // 7
};

var bool bOpenDifficultyMenuOnClose;
var bool bOpenOptionsOnClose;
var bool bTemporarilyHidden;
var transient bool bIsPlayingCloseAnimation;
var bool bWasHUDVisible;
var bool bIsMenuPPOverrideOn;
var PKGFxUI_PauseDifficultyMenu DifficultyMenu;
var PKGFxUI_Menu_Options_Base OptionsMenu;
var array<PainGFxUI_PauseMenu.EPauseOptions> PauseMenuOptions;
var const localized array<localized string> PauseMenuOptionText;
var const localized string DifficultyWarningMsg;
var const localized string LastheckpointWarningMsg;
var const localized string RestartWarningMsg;
var const localized string ExitWarningMsg;
var array<GFxClikWidget> PauseMenuButtons;
var GFxObject RootMC;
var GFxObject PauseMC;
var GFxObject OverlayMC;
var GFxObject KursorMC;
var PKGFxUI_Menu_Footer footer;
var PKGFxUI_Menu_PartyWindow PlayersWindow;
var PKGFxUI_Menu_PartyMenu PlayersMenu;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x0D
    if(bIsPlayingCloseAnimation)
    {
    }
    // End:0x3C
    if(GetLP().ControllerId != ControllerId)
    {
        return true;
    }
    // End:0x1AF
    if((GetPC().WorldInfo.IsConsoleBuild(1) && PlayersWindow != none) && !bIsPlayingCloseAnimation)
    {
        // End:0x1AF
        if(((ButtonName == 'XboxTypeS_X') && int(InputEvent) == int(1)) && PlayersMenu == none)
        {
            PlayersMenu = new Class'PKGFxUI_Menu_PartyMenu';
            PlayersMenu.SetTimingMode(1);
            PlayersMenu.SetPriority(69);
            PlayersMenu.ParentMenu = self;
            PlayersMenu.Init(GetLP().ViewportClient.FindPlayerByControllerId(ControllerId));
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function SetupMenuButtons()
{
    local PainGFxUI_PauseMenu.EPauseOptions PauseOption;
    local int Index;

    // End:0x162
    if(((int(GetPC().WorldInfo.NetMode) == int(NM_Client)) || (int(GetPC().WorldInfo.NetMode) == int(NM_ListenServer)) && !PainGRI(GetPC().WorldInfo.GRI).IsCoopMultiplayerGame()) || PainGRI(GetPC().WorldInfo.GRI).IsSingleSurvivalGame())
    {
        PauseMenuOptions.RemoveItem(3);
        PauseMenuOptions.RemoveItem(4);
        PauseMenuOptions.RemoveItem(5);        
    }
    else
    {
        // End:0x1C6
        if(!GetPC().IsPrimaryPlayer())
        {
            PauseMenuOptions.RemoveItem(3);
            PauseMenuOptions.RemoveItem(4);
            PauseMenuOptions.RemoveItem(2);
            PauseMenuOptions.RemoveItem(1);            
        }
        else
        {
            // End:0x22B
            if(PainGRI(GetPC().WorldInfo.GRI).IsCoopMultiplayerGame())
            {
                PauseMenuOptions.RemoveItem(3);
            }
        }
    }
    // End:0x251
    if(PauseMenuButtons.Length > 0)
    {
        PauseMenuButtons.Remove(0, PauseMenuButtons.Length);
    }
    Index = 0;
    // End:0x58D
    foreach PauseMenuOptions(PauseOption)
    {
        PauseMenuButtons[Index] = GFxClikWidget(PauseMC.GetObject("option" $ string(Index + 1), Class'GFxUI.GFxClikWidget'));
        PauseMenuButtons[Index].SetBool("visible", true);
        PauseMenuButtons[Index].SetString("label", PauseMenuOptionText[int(PauseOption)]);
        switch(PauseOption)
        {
            // End:0x3AA
            case 0:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressResumeButton);
                // End:0x581
                break;
            // End:0x3F8
            case 1:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressOptionsButton);
                // End:0x581
                break;
            // End:0x446
            case 2:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressExitButton);
                // End:0x581
                break;
            // End:0x494
            case 3:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressLoadCheckpointButton);
                // End:0x581
                break;
            // End:0x4E2
            case 4:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressRestartChapterButton);
                // End:0x581
                break;
            // End:0x530
            case 5:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressDifficultyButton);
                // End:0x581
                break;
            // End:0x57E
            case 6:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressRespawnButton);
                // End:0x581
                break;
            // End:0xFFFF
            default:
                break;
        }
        Index++;        
    }    
    //return;    
}

function InitializePlayersWindow()
{
    // End:0x71
    if(PlayersWindow == none)
    {
        PlayersWindow = new Class'PKGFxUI_Menu_PartyWindow';
        PlayersWindow.SetPriority(66);
        PlayersWindow.Init(GetLP());
    }
    //return;    
}

function InitializeFooter()
{
    // End:0x71
    if(footer == none)
    {
        footer = new Class'PKGFxUI_Menu_Footer';
        footer.SetPriority(67);
        footer.Init(GetLP());
    }
    //return;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    ButtonAliases.AddItem('GenericBack');
    footer.FooterUpdate(ButtonAliases);
    //return;    
}

function OnPressOptionsButton(EventData ev)
{
    bOpenOptionsOnClose = true;
    bTemporarilyHidden = true;
    PlayCloseAnimation();
    //return;    
}

function OnPressRespawnButton(EventData ev)
{
    PainGFxHudWrapper(GetPC().myHUD).UnPauseGame();
    GetPC().ServerRestartPlayer();
    //return;    
}

function OnPressResumeButton(EventData ev)
{
    PlayCloseAnimation();
    //return;    
}

function OnPressLoadCheckpointButton(EventData ev)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    Class'PKUIManager'.static.ShowUIMessage('PauseOptionConfirm', PauseMenuOptionText[3], LastheckpointWarningMsg, ButtonAliases, OnLoadCheckpointOptionSelected);
    //return;    
}

function bool OnLoadCheckpointOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local PKPlayerController PC;
    local EvilEngine Engine;

    // End:0x167
    if(SelectedInputAlias == 'GenericYes')
    {
        PC = PKPlayerController(GetPC());
        Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x148
        if((((PC != none) && Engine != none) && Engine.CurrentCheckpoint != none) && !Engine.CurrentCheckpoint.CheckpointIsEmpty())
        {
            PainGFxHudWrapper(GetPC().myHUD).UnPauseGame();
            PC.LoadCheckpoint();            
        }
        else
        {
            PC.RestartLevel();
        }
    }
    return true;
    //return ReturnValue;    
}

function OnPressRestartChapterButton(EventData ev)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    Class'PKUIManager'.static.ShowUIMessage('PauseOptionConfirm', PauseMenuOptionText[4], RestartWarningMsg, ButtonAliases, OnRestartChapterOptionSelected);
    //return;    
}

function bool OnRestartChapterOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x37
    if(SelectedInputAlias == 'GenericYes')
    {
        GetPC().RestartLevel();
    }
    return true;
    //return ReturnValue;    
}

function OnPressDifficultyButton(EventData ev)
{
    bOpenDifficultyMenuOnClose = true;
    bTemporarilyHidden = true;
    PlayCloseAnimation();
    //return;    
}

function OnPressExitButton(EventData ev)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    Class'PKUIManager'.static.ShowUIMessage('PauseOptionConfirm', PauseMenuOptionText[2], ExitWarningMsg, ButtonAliases, OnExitOptionSelected);
    //return;    
}

function bool OnExitOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x41
    if(SelectedInputAlias == 'GenericYes')
    {
        PKPlayerController(GetPC()).ReturnToMainMenu(false);
    }
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    local PKPostProcessManager PP;
    local WorldInfo WI;

    PauseMC.GotoAndPlay("open");
    // End:0x133
    if(!bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x133
        if(PP != none)
        {
            PP.SetMenuOverride(true, 0.4000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = true;
        }
    }
    //return;    
}

function PlayCloseAnimation()
{
    local PKPostProcessManager PP;
    local WorldInfo WI;

    // End:0x0F
    if(bIsPlayingCloseAnimation)
    {
        return;
    }
    bIsPlayingCloseAnimation = true;
    PauseMC.GotoAndPlay("close");
    // End:0x15E
    if(!bTemporarilyHidden && bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x15E
        if(PP != none)
        {
            PP.SetMenuOverride(false, 0.4000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

function OnPlayAnimationComplete()
{
    //return;    
}

function OnCloseAnimationComplete()
{
    local float X, Y;

    // End:0x149
    if(bOpenDifficultyMenuOnClose)
    {
        bOpenDifficultyMenuOnClose = false;
        // End:0x81
        if(DifficultyMenu == none)
        {
            DifficultyMenu = new Class'PKGFxUI_PauseDifficultyMenu';
            DifficultyMenu.SetTimingMode(1);
            DifficultyMenu.ParentMenu = self;
        }
        // End:0x146
        if(DifficultyMenu != none)
        {
            DifficultyMenu.ActivatePauseScene(GetLP());
            KursorMC.GetPosition(X, Y);
            DifficultyMenu.KursorMC.SetPosition(X, Y);
            Close(false);
            ToggleHostPausedMessages(false);
        }        
    }
    else
    {
        // End:0x3C6
        if(bOpenOptionsOnClose)
        {
            bOpenOptionsOnClose = false;
            // End:0x2FE
            if(OptionsMenu == none)
            {
                OptionsMenu = new Class'PKGFxUI_Menu_OptionsMenu';
                OptionsMenu.SetPriority(69);
                // End:0x2DE
                if((PainGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen()) || PainGRI(GetPC().WorldInfo.GRI).IsCoopMultiplayerGame() && int(GetPC().WorldInfo.NetMode) == int(NM_ListenServer))
                {
                    OptionsMenu.bPauseGameWhileActive = true;
                }
                OptionsMenu.ParentMenu = self;
            }
            // End:0x3C3
            if(OptionsMenu != none)
            {
                OptionsMenu.Init(GetLP());
                KursorMC.GetPosition(X, Y);
                OptionsMenu.KursorMC.SetPosition(X, Y);
                Close(false);
                ToggleHostPausedMessages(false);
            }            
        }
        else
        {
            // End:0x3ED
            if(bTemporarilyHidden)
            {
                bPauseGameWhileActive = true;
                Close(false);                
            }
            else
            {
                bPauseGameWhileActive = true;
                PainGFxHudWrapper(GetPC().myHUD).UnPauseGame();
                Close(false);
            }
        }
    }
    //return;    
}

event OnClose()
{
    local PKPostProcessManager PP;
    local WorldInfo WI;

    // End:0x3A
    if(PlayersWindow != none)
    {
        PlayersWindow.Close();
        PlayersWindow = none;
    }
    // End:0x4B
    if(OptionsMenu != none)
    {
        return;
    }
    // End:0x85
    if(footer != none)
    {
        footer.Close();
        footer = none;
    }
    // End:0x1A2
    if(!bTemporarilyHidden && bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x1A2
        if(PP != none)
        {
            PP.SetMenuOverride(false, 0.0000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = false;
        }
    }
    PainGFxHudWrapper(GetPC().myHUD).HudMovie.SetHUDElementsVisible(true);
    //return;    
}

function ResetCaptureKeys()
{
    local int I;

    ClearCaptureKeys();
    I = 0;
    J0x15:

    // End:0x58 [Loop If]
    if(I < CaptureKeys.Length)
    {
        AddCaptureKey(CaptureKeys[I]);
        I++;
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    PauseMC = RootMC.GetObject("pausemenu");
    KursorMC = RootMC.GetObject("cursor");
    // End:0xFF
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        KursorMC.SetVisible(false);        
    }
    else
    {
        KursorMC.SetVisible(EvilGFxHudWrapper(GetPC().myHUD).bShowCursor);
    }
    SetupMenuButtons();
    // End:0x261
    if(PainGRI(GetPC().WorldInfo.GRI).IsMultiplayerGame() || PainGRI(GetPC().WorldInfo.GRI).IsCoopMultiplayerGame() && int(GetPC().WorldInfo.NetMode) == int(NM_Client))
    {
        bPauseGameWhileActive = false;
    }
    // End:0x355
    if(GetPC().WorldInfo.IsConsoleBuild(1) && PainGRI(GetPC().WorldInfo.GRI).IsCoopMultiplayerGame() || PainGRI(GetPC().WorldInfo.GRI).IsMultiplayerGame())
    {
        InitializePlayersWindow();
    }
    // End:0x3A3
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        InitializeFooter();
        UpdateFooter();
    }
    ResetCaptureKeys();
    return true;
    //return ReturnValue;    
}

function bool ActivatePauseScene(LocalPlayer LP)
{
    local PKPostProcessManager PP;
    local WorldInfo WI;

    // End:0x11D
    if(!bTemporarilyHidden && bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x111
        if(PP != none)
        {
            PP.SetMenuOverride(false, 0.0000000, (WI.Game != none) && WI.Game.bPauseable);
        }
        bIsMenuPPOverrideOn = false;
    }
    FlushPlayerInput(false);
    Init(LP);
    PlayOpenAnimation();
    bIsPlayingCloseAnimation = false;
    bTemporarilyHidden = false;
    ToggleHostPausedMessages(true);
    return true;
    //return ReturnValue;    
}

final function UT_ConsoleCommand(string Cmd, optional bool bWriteToLog)
{
    GetPC().Player.Actor.ConsoleCommand(Cmd, bWriteToLog);
    //return;    
}

function Tick(float DeltaTime)
{
    super(UTGFxTweenableMoviePlayer).Tick(DeltaTime);
    // End:0x4A
    if(PlayersWindow != none)
    {
        PlayersWindow.Tick(DeltaTime);
    }
    // End:0x81
    if(PlayersMenu != none)
    {
        PlayersMenu.Tick(DeltaTime);
    }
    //return;    
}

singular function ToggleHostPausedMessages(bool bNewVisible)
{
    local PKUIManager UIManager;
    local UIScene_MessageBox MsgBox;
    local PKPlayerController PC;
    local PainGFxUI_PauseMenu OtherPauseMenu;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0xBA
    foreach UIManager.OpenMessageBoxes(MsgBox)
    {
        // End:0x8E
        if(MsgBox.MessageName != 'HostPaused')
        {
            continue;            
        }
        else
        {
            MsgBox.SetTemporarilyHidden(!bNewVisible);            
        }
    }    
    // End:0x298
    foreach GetPC().LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        // End:0x10C
        if(PC == (GetPC()))
        {
            continue;            
        }
        OtherPauseMenu = ((PainGFxHudWrapper(PC.myHUD) != none) ? PainGFxHudWrapper(PC.myHUD).PKPauseMenuMovie : none);
        // End:0x297
        if(OtherPauseMenu != none)
        {
            // End:0x235
            if(bNewVisible)
            {
                // End:0x232
                if(OtherPauseMenu.bTemporarilyHidden)
                {
                    OtherPauseMenu.ActivatePauseScene(Class'Engine.Engine'.static.GetEngine().GamePlayers[OtherPauseMenu.LocalPlayerOwnerIndex]);
                }
                // End:0x297
                continue;
            }
            // End:0x297
            if(OtherPauseMenu.bMovieIsOpen)
            {
                OtherPauseMenu.bTemporarilyHidden = true;
                OtherPauseMenu.PlayCloseAnimation();
            }
        }        
    }    
    //return;    
}

defaultproperties
{
    PauseMenuOptions[0]=.EPO_Resume
    PauseMenuOptions[1]=.EPO_LoadCheckpoint
    PauseMenuOptions[2]=.EPO_RestartChapter
    PauseMenuOptions[3]=.EPO_Options
    PauseMenuOptions[4]=.EPO_ReturnToMainMenu
    PauseMenuOptionText[0]="Resume Game"
    PauseMenuOptionText[1]="Options"
    PauseMenuOptionText[2]="Return to main menu"
    PauseMenuOptionText[3]="Load last Checkpoint"
    PauseMenuOptionText[4]="Restart Chapter"
    PauseMenuOptionText[5]="Change Difficulty"
    PauseMenuOptionText[6]="Respawn"
    DifficultyWarningMsg="ARE YOU SURE YOU WANT TO CHANGE DIFFICULTY?"
    LastheckpointWarningMsg="YOU WILL LOSE ANY UNSAVED PROGRESS. ARE YOU SURE YOU WANT TO LOAD LAST CHECKPOINT?"
    RestartWarningMsg="YOU WILL LOSE ANY UNSAVED PROGRESS. ARE YOU SURE YOU WANT TO RESTART CURRENT LEVEL?"
    ExitWarningMsg="ARE YOU SURE YOU WANT TO EXIT THE CURRENT LEVEL?"
    MovieInfo=SwfMovie'PKHD_UI.PKPausemenu'
    bPauseGameWhileActive=true
    bOnlyOwnerFocusable=true
    bCaptureInput=true
    bHideLesserMovies=true
    SoundThemes=/* Array type was not detected. */
    Priority=65
}