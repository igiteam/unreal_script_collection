class GFxUI_PauseMenu extends UTGFxTweenableMoviePlayer
    config(UI);

var GFxObject RootMC;
var GFxObject PauseMC;
var GFxObject OverlayMC;
var GFxObject Btn_Resume_Wrapper;
var GFxObject Btn_Exit_Wrapper;
var GFxClikWidget Btn_ResumeMC;
var GFxClikWidget Btn_ExitMC;
var const localized string ResumeString;
var const localized string ExitString;

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    PauseMC = RootMC.GetObject("pausemenu");
    Btn_Resume_Wrapper = PauseMC.GetObject("resume");
    Btn_Exit_Wrapper = PauseMC.GetObject("exit");
    Btn_ResumeMC = GFxClikWidget(Btn_Resume_Wrapper.GetObject("btn", Class'GFxUI.GFxClikWidget'));
    Btn_ExitMC = GFxClikWidget(Btn_Exit_Wrapper.GetObject("btn", Class'GFxUI.GFxClikWidget'));
    Btn_ExitMC.SetString("label", ExitString);
    Btn_ResumeMC.SetString("label", ResumeString);
    Btn_ExitMC.AddEventListener('CLIK_press', OnPressExitButton);
    Btn_ResumeMC.AddEventListener('CLIK_press', OnPressResumeButton);
    AddCaptureKey('XboxTypeS_A');
    AddCaptureKey('XboxTypeS_Start');
    AddCaptureKey('Enter');
    return true;
    //return ReturnValue;    
}

function OnPressResumeButton(EventData ev)
{
    PlayCloseAnimation();
    //return;    
}

function OnPressExitButton(EventData ev)
{
    UTPlayerController(GetPC()).QuitToMainMenu();
    //return;    
}

function PlayOpenAnimation()
{
    PauseMC.GotoAndPlay("open");
    //return;    
}

function PlayCloseAnimation()
{
    PauseMC.GotoAndPlay("close");
    //return;    
}

function OnPlayAnimationComplete()
{
    //return;    
}

function OnCloseAnimationComplete()
{
    UTHUDBase(GetPC().myHUD).CompletePauseMenuClose();
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