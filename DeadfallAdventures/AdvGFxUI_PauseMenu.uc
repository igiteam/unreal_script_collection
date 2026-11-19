class AdvGFxUI_PauseMenu extends AdvGfxMoviePlayer
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
var bool bCanOpenPartyMenu;
var transient bool bIsPlayingCloseAnimation;
var bool bWasHUDVisible;
var bool bIsMenuPPOverrideOn;
var AdvGFxUI_PauseDifficultyMenu DifficultyMenu;
var AdvGFxUI_Menu_Options_Base OptionsMenu;
var array<AdvGFxUI_PauseMenu.EPauseOptions> PauseMenuOptions;
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
var AdvGFxUI_Menu_Footer footer;
var AdvGFxUI_Menu_PartyWindow PlayersWindow;
var AdvGFxUI_Menu_PartyMenu PlayersMenu;
var UIScene_MessageBox LoadCheckpointConfirmation;

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
    // End:0xA1
    if(Class'AdvFrontEnd'.static.IsGamepadKey(ButtonName))
    {
        GetPC().PlayerInput.bUsingGamepad = true;        
    }
    else
    {
        GetPC().PlayerInput.bUsingGamepad = false;
    }
    // End:0x14B
    if((AdvUIManager(Class'Engine.UIManager'.static.GetUIManager()) != none) && AdvUIManager(Class'Engine.UIManager'.static.GetUIManager()).IsAnyUIMessageActive())
    {
        return true;
    }
    // End:0x190
    if((int(InputEvent) == int(2)) && !Class'AdvFrontEnd'.static.IsDirectionalInput(ButtonName))
    {
        return true;
    }
    // End:0x1FB
    if(GetPC().WorldInfo.IsConsoleBuild(1) && !Class'AdvFrontEnd'.static.IsGamepadKey(ButtonName))
    {
        return true;
    }
    // End:0x2E3
    if((((GetPC().WorldInfo.IsConsoleBuild(1) && PlayersWindow != none) && !Class'Engine.Engine'.static.IsSplitScreen()) && !bIsPlayingCloseAnimation) && !bTemporarilyHidden)
    {
        // End:0x2E3
        if(((ButtonName == 'XboxTypeS_X') && int(InputEvent) == int(0)) && PlayersMenu == none)
        {
            ShowPlayersMenu(ControllerId, 0);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function ShowPlayersMenu(int ControllerId, AdvGFxUI_Menu_PartyMenu.PartyMenuFunction MenuFunction)
{
    PlayersMenu = new Class'AdvGFxUI_Menu_PartyMenu';
    PlayersMenu.SetTimingMode(1);
    PlayersMenu.SetPriority(70);
    PlayersMenu.ParentMenu = self;
    PlayersMenu.Init(GetLP().ViewportClient.FindPlayerByControllerId(ControllerId));
    PlayersMenu.SetMenuFunction(MenuFunction);
    PlayersMenu.UpdatePlayersPanel();
    //return;    
}

function HideAllButtonsAndFooter()
{
    local AdvGFxUI_PauseMenu.EPauseOptions PauseOption;
    local int Index;

    Index = 0;
    // End:0x61
    foreach PauseMenuOptions(PauseOption)
    {
        PauseMenuButtons[Index].SetBool("visible", false);
        Index++;        
    }    
    // End:0x9C
    if(footer != none)
    {
        footer.Close();
        footer = none;
    }
    //return;    
}

function SetupMenuButtons()
{
    local AdvGFxUI_PauseMenu.EPauseOptions PauseOption;
    local int Index;

    // End:0x117
    if(((AdvGRI_SP(GetPC().WorldInfo.GRI) != none) && AdvGRI_SP(GetPC().WorldInfo.GRI).ChapterNum == 16) && AdvGRI_SP(GetPC().WorldInfo.GRI).ChapterNum == 17)
    {
        PauseMenuOptions.RemoveItem(3);        
        PauseMenuOptions.RemoveItem(4);        
    }
    // End:0x1C7
    if((int(GetPC().WorldInfo.NetMode) == int(NM_Client)) || int(GetPC().WorldInfo.NetMode) == int(NM_ListenServer))
    {
        PauseMenuOptions.RemoveItem(3);        
        PauseMenuOptions.RemoveItem(4);        
        PauseMenuOptions.RemoveItem(5);                
    }
    else
    {
        // End:0x219
        if(!GetPC().IsPrimaryPlayer())
        {
            PauseMenuOptions.RemoveItem(3);            
            PauseMenuOptions.RemoveItem(4);            
            PauseMenuOptions.RemoveItem(2);            
        }
    }
    // End:0x23F
    if(PauseMenuButtons.Length > 0)
    {
        PauseMenuButtons.Remove(0, PauseMenuButtons.Length);        
    }
    Index = 0;
    // End:0x57B
    foreach PauseMenuOptions(PauseOption)
    {
        PauseMenuButtons[Index] = GFxClikWidget(PauseMC.GetObject("option" $ string(Index + 1), Class'GFxUI.GFxClikWidget'));
        PauseMenuButtons[Index].SetBool("visible", true);
        PauseMenuButtons[Index].SetString("label", PauseMenuOptionText[int(PauseOption)]);
        switch(PauseOption)
        {
            // End:0x398
            case 0:
                PauseMenuButtons[Index].AddEventListener('CLIK_press', OnPressResumeButton);
                // End:0x56F
                break;
            // End:0x3E6
            case 1:
                PauseMenuButtons[Index].AddEventListener('CLIK_press', OnPressOptionsButton);
                // End:0x56F
                break;
            // End:0x434
            case 2:
                PauseMenuButtons[Index].AddEventListener('CLIK_press', OnPressExitButton);
                // End:0x56F
                break;
            // End:0x482
            case 3:
                PauseMenuButtons[Index].AddEventListener('CLIK_press', OnPressLoadCheckpointButton);
                // End:0x56F
                break;
            // End:0x4D0
            case 4:
                PauseMenuButtons[Index].AddEventListener('CLIK_press', OnPressRestartChapterButton);
                // End:0x56F
                break;
            // End:0x51E
            case 5:
                PauseMenuButtons[Index].AddEventListener('CLIK_press', OnPressDifficultyButton);
                // End:0x56F
                break;
            // End:0x56C
            case 6:
                PauseMenuButtons[Index].AddEventListener('CLIK_press', OnPressRespawnButton);
                // End:0x56F
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
    // End:0x80
    if((PlayersWindow == none) && bCanOpenPartyMenu)
    {
        PlayersWindow = new Class'AdvGFxUI_Menu_PartyWindow';
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
        footer = new Class'AdvGFxUI_Menu_Footer';
        footer.SetPriority(70);
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
    AdvGFxHudWrapper(GetPC().myHUD).UnPauseGame();
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
    Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', PauseMenuOptionText[3], LastheckpointWarningMsg, ButtonAliases, OnLoadCheckpointOptionSelected, GetLP(), LoadCheckpointConfirmation,,, false,,, true);
    ev.Target.SetBool("focused", false);
    ev.Target.SetBool("focused", true);
    //return;    
}

function bool OnLoadCheckpointOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPlayerController PC;
    local AdvEngine Engine;

    // End:0x1F0
    if(SelectedInputAlias == 'GenericYes')
    {
        PC = AdvPlayerController(GetPC());
        Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
        Engine.ClearTemporaryCheckpointData();
        // End:0x1D1
        if((((PC != none) && Engine != none) && Engine.CurrentCheckpoint != none) && !Engine.CurrentCheckpoint.CheckpointIsEmpty())
        {
            AdvGFxHudWrapper(GetPC().myHUD).UnPauseGame();
            AdvGFxHudWrapper(GetPC().myHUD).AdvPauseMenuMovie = none;
            Close(true);
            LoadCheckpointConfirmation.Close(true);
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
    Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', PauseMenuOptionText[4], RestartWarningMsg, ButtonAliases, OnRestartChapterOptionSelected, GetLP(),,,, false,,, true);
    ev.Target.SetBool("focused", false);
    ev.Target.SetBool("focused", true);
    //return;    
}

function bool OnRestartChapterOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvEngine Engine;

    // End:0x88
    if(SelectedInputAlias == 'GenericYes')
    {
        Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
        Engine.ClearTemporaryCheckpointData();
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

    // End:0x125
    if(AdvGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame())
    {
        ButtonAliases.AddItem('GenericContinue');        
        ButtonAliases.AddItem('GenericBack');        
        Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', PauseMenuOptionText[2], Localize("MessageBoxStrings", "ReturnToMainMenu_Message", "ADVGame"), ButtonAliases, OnExitOptionSelected, GetLP(),,,, false,,, true);        
    }
    else
    {
        ButtonAliases.AddItem('GenericYes');        
        ButtonAliases.AddItem('GenericNo');        
        Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', PauseMenuOptionText[2], ExitWarningMsg, ButtonAliases, OnExitOptionSelected, GetLP(),,,, false,,, true);
    }
    ev.Target.SetBool("focused", false);
    ev.Target.SetBool("focused", true);
    //return;    
}

function bool OnExitOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0xE6
    if((SelectedInputAlias == 'GenericYes') || SelectedInputAlias == 'GenericContinue')
    {
        // End:0xB2
        if(AdvGRI(GetPC().WorldInfo.GRI).IsSurvivalGame())
        {
            AdvPlayerController(GetPC()).ExitFromMPGame();            
        }
        else
        {
            AdvPlayerController(GetPC()).ReturnToMainMenu(false);
        }
        HideAllButtonsAndFooter();
    }
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    PauseMC.GotoAndPlay("open");
    //return;    
}

function PlayCloseAnimation()
{
    // End:0x0F
    if(bIsPlayingCloseAnimation)
    {
        return;
    }
    bIsPlayingCloseAnimation = true;
    PauseMC.GotoAndPlay("close");
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
            DifficultyMenu = new Class'AdvGFxUI_PauseDifficultyMenu';
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
        // End:0x32D
        if(bOpenOptionsOnClose)
        {
            bOpenOptionsOnClose = false;
            // End:0x265
            if(OptionsMenu == none)
            {
                OptionsMenu = new Class'AdvGFxUI_Menu_OptionsMenu';
                OptionsMenu.SetPriority(69);
                // End:0x245
                if(AdvGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen())
                {
                    OptionsMenu.bPauseGameWhileActive = true;
                }
                OptionsMenu.ParentMenu = self;
            }
            // End:0x32A
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
            // End:0x348
            if(bTemporarilyHidden)
            {
                Close(false);                
            }
            else
            {
                AdvGFxHudWrapper(GetPC().myHUD).UnPauseGame();
                Close(false);
            }
        }
    }
    //return;    
}

event OnClose()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;

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
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x157
    if(OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x157
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.ClearWriteProfileSettingsCompleteDelegate(byte(GetLP().ControllerId), OnProfileWriteComplete);
        }
    }
    AdvGFxHudWrapper(GetPC().myHUD).HudMovie.SetHUDElementsVisible(true);
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
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;

    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    PauseMC = RootMC.GetObject("pausemenu");
    KursorMC = RootMC.GetObject("cursor");
    // End:0x139
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        KursorMC.SetVisible(false);
        bIgnoreMouseInput = true;        
    }
    else
    {
        KursorMC.SetVisible(EvilGFxHudWrapper(GetPC().myHUD).bShowCursor);
        bIgnoreMouseInput = !EvilGFxHudWrapper(GetPC().myHUD).bShowCursor;
    }
    SetupMenuButtons();
    // End:0x287
    if(GetPC().WorldInfo.IsConsoleBuild(1) && AdvGRI(GetPC().WorldInfo.GRI).IsMultiplayerGame())
    {
        InitializePlayersWindow();
    }
    // End:0x303
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        InitializeFooter();
        UpdateFooter();
    }
    ResetCaptureKeys();
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x3DF
    if(OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x3DF
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.AddWriteProfileSettingsCompleteDelegate(byte(GetLP().ControllerId), OnProfileWriteComplete);
        }
    }
    return true;
    //return ReturnValue;    
}

function OnProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
    Class'AdvUIManager'.static.CloseUpdatingScene();
    //return;    
}

function bool ActivatePauseScene(LocalPlayer LP)
{
    local EvilLocalPlayer ELP;
    local WorldInfo WI;
    local bool bWasUsingGamepad;

    // End:0x114
    if(!bTemporarilyHidden && bIsMenuPPOverrideOn)
    {
        ELP = EvilPlayerController(GetPC()).GetELP();
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x108
        if(ELP != none)
        {
            ELP.SetMenuOverride(false, 0.0000000, (WI.Game != none) && WI.Game.bPauseable);
        }
        bIsMenuPPOverrideOn = false;
    }
    bWasUsingGamepad = GetPC().PlayerInput.bUsingGamepad;
    FlushPlayerInput(false);
    GetPC().PlayerInput.bUsingGamepad = bWasUsingGamepad;
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
    local AdvUIManager UIManager;
    local UIScene_MessageBox MsgBox;
    local AdvPlayerController PC;
    local AdvGFxUI_PauseMenu OtherPauseMenu;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
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
    foreach GetPC().LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        // End:0x10C
        if(PC == (GetPC()))
        {
            continue;            
        }
        OtherPauseMenu = ((AdvGFxHudWrapper(PC.myHUD) != none) ? AdvGFxHudWrapper(PC.myHUD).AdvPauseMenuMovie : none);
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
    PauseMenuOptions[0]=174
    PauseMenuOptions[1]=31
    PauseMenuOptions[2]=0
    PauseMenuOptions[3]=0
    PauseMenuOptions[4]=0
    PauseMenuOptionText[0]="Resume Game"
    PauseMenuOptionText[1]="Options"
    PauseMenuOptionText[2]="Return to main menu"
    PauseMenuOptionText[3]="Load last Checkpoint"
    PauseMenuOptionText[4]="Restart Level"
    PauseMenuOptionText[5]="Change Difficulty"
    PauseMenuOptionText[6]="Respawn"
    DifficultyWarningMsg="ARE YOU SURE YOU WANT TO CHANGE DIFFICULTY?"
    LastheckpointWarningMsg="YOU WILL LOSE ANY UNSAVED PROGRESS. ARE YOU SURE YOU WANT TO LOAD LAST CHECKPOINT?"
    RestartWarningMsg="YOU WILL LOSE ANY UNSAVED PROGRESS. ARE YOU SURE YOU WANT TO RESTART CURRENT LEVEL?"
    ExitWarningMsg="ARE YOU SURE YOU WANT TO EXIT THE CURRENT LEVEL?"
    MovieInfo=SwfMovie'UI_AdvCommon.AdvPausemenu'
    bPauseGameWhileActive=true
    bOnlyOwnerFocusable=true
    bCaptureInput=true
    bHideLesserMovies=true
    SoundThemes=/* Array type was not detected. */
    Priority=65
}