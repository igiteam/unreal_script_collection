class EvilGFxUI_PauseMenu extends UTGFxTweenableMoviePlayer
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

var array<EvilGFxUI_PauseMenu.EPauseOptions> PauseMenuOptions;
var const localized array<localized string> PauseMenuOptionText;
var array<GFxClikWidget> PauseMenuButtons;
var GFxObject RootMC;
var GFxObject PauseMC;
var GFxObject OverlayMC;
var GFxObject KursorMC;
var transient bool bIsPlayingCloseAnimation;

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    PauseMC = RootMC.GetObject("pausemenu");
    KursorMC = RootMC.GetObject("cursor");
    // End:0x130
    if(GetPC().WorldInfo.IsConsoleBuild(0) || GetLP().bPCGamepadMode)
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
    AddCaptureKey('XboxTypeS_A');
    AddCaptureKey('XboxTypeS_Start');
    AddCaptureKey('Enter');
    bIsPlayingCloseAnimation = false;
    return true;
    //return ReturnValue;    
}

function SetupMenuButtons()
{
    local EvilGFxUI_PauseMenu.EPauseOptions PauseOption;
    local int Index;

    // End:0x26
    if(PauseMenuButtons.Length > 0)
    {
        PauseMenuButtons.Remove(0, PauseMenuButtons.Length);        
    }
    Index = 0;
    // End:0x362
    foreach PauseMenuOptions(PauseOption)
    {
        PauseMenuButtons[Index] = GFxClikWidget(PauseMC.GetObject("option" $ string(Index + 1), Class'GFxUI.GFxClikWidget'));
        PauseMenuButtons[Index].SetBool("visible", true);
        PauseMenuButtons[Index].SetString("label", PauseMenuOptionText[int(PauseOption)]);
        switch(PauseOption)
        {
            // End:0x17F
            case 0:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressResumeButton);
                // End:0x356
                break;
            // End:0x1CD
            case 1:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressOptionsButton);
                // End:0x356
                break;
            // End:0x21B
            case 2:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressExitButton);
                // End:0x356
                break;
            // End:0x269
            case 3:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressLoadCheckpointButton);
                // End:0x356
                break;
            // End:0x2B7
            case 4:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressRestartChapterButton);
                // End:0x356
                break;
            // End:0x305
            case 5:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressDifficultyButton);
                // End:0x356
                break;
            // End:0x353
            case 6:
                PauseMenuButtons[Index].AddEventListener('CLIK_click', OnPressRespawnButton);
                // End:0x356
                break;
            // End:0xFFFF
            default:
                break;
        }
        Index++;        
    }    
    //return;    
}

function OnPressResumeButton(EventData ev)
{
    //return;    
}

function OnPressOptionsButton(EventData ev)
{
    //return;    
}

function OnPressExitButton(EventData ev)
{
    //return;    
}

function OnPressLoadCheckpointButton(EventData ev)
{
    //return;    
}

function OnPressRestartChapterButton(EventData ev)
{
    //return;    
}

function OnPressDifficultyButton(EventData ev)
{
    //return;    
}

function OnPressRespawnButton(EventData ev)
{
    //return;    
}

function PlayOpenAnimation()
{
    //return;    
}

function PlayCloseAnimation()
{
    bIsPlayingCloseAnimation = true;
    //return;    
}

function OnPlayAnimationComplete()
{
    //return;    
}

function OnCloseAnimationComplete()
{
    //return;    
}

final function UT_ConsoleCommand(string Cmd, optional bool bWriteToLog)
{
    GetPC().Player.Actor.ConsoleCommand(Cmd, bWriteToLog);
    //return;    
}

defaultproperties
{
    bPauseGameWhileActive=true
    bCaptureInput=true
}