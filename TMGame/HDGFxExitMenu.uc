//-----------------------------------------------------------
//base on HD_FrontEnd/HD_GFx_ExitMenu.fla
//-----------------------------------------------------------
class HDGFxExitMenu extends HDGFxTweenableMoviePlayer;

var GFxObject RootMC;
var GFxObject ExitMenuMC;
var GFxObject ButtonListMC;

var localized string ContinueMission;
var localized string RestarMission;
var localized string BackMainMenu;
var localized string ExitGame;

var PlayerController PC;

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0);
//
    RootMC = GetVariableObject("_root");
    ExitMenuMC = RootMC.GetObject("exitmenu");
    ButtonListMC = ExitMenuMC.GetObject("buttonlist");

    PC =  GetPC();
    PC.PlayerInput.ResetInput();
    PlayOpenAnimation();
    return TRUE;
}

function PlayOpenAnimation()
{
    ButtonListMC.GotoAndPlay("open");
}

function PlayCloseAnimation()
{
    ButtonListMC.GotoAndPlay("close");
}

function OnOpenAnimationComplete()
{
    PC.SetPause(TRUE);
}

function OnCloseAnimationComplete()
{

    HDHUD(GetPC().MyHUD).CompleteExitMenuClose();
    self.Close(FALSE);
    PC.SetPause(FALSE);
}
function PressRemission()
{
    PlayCloseAnimation();
    if( PC.IsDead()&& TGGameSP_Base( PC.WorldInfo.Game ) != none )
     PC.ServerRestartPlayer();
}

function PressRestart()
{
    PlayCloseAnimation();
    PC.RestartLevel();
}

function PressBackmain()
{
    local HDBaseGame theGame;

    theGame = HDBaseGame( PC.WorldInfo.Game );
    if( theGame != none )
    {
        theGame.DestroyCurrentLanGame();
    }

    GFx_ConsoleCommand("open TMFrontEnd");
}

function PressExitgame()
{
    local LoginPlayerManager PlayerManager;

    PlayerManager = class'GameEngine'.static.GetPlayerManager();

    PlayerManager.currentPlayerName = "";
    PlayerManager.SaveConfig ();

    GFx_ConsoleCommand("EXIT");
}
/*
    Launch a console command using the PlayerOwner.
    Will fail if PlayerOwner is undefined.
*/
final function GFx_ConsoleCommand(string Cmd, optional bool bWriteToLog)
{
    PC.Player.Actor.ConsoleCommand(Cmd, bWriteToLog);
}
 event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;
    local GFxObject HD_Title;
    bWasHandled = false;
    switch(WidgetName)
    {
    case ('remission'):

        HD_Title = Widget.GetObject("label");
        HD_Title.SetText(ContinueMission);
        HD_Title = Widget.GetObject("textField");
        HD_Title.SetText(ContinueMission);
        bWasHandled = true;
        break;

    case ('restart'):

        HD_Title = Widget.GetObject("label");
        HD_Title.SetText(RestarMission);
        HD_Title = Widget.GetObject("textField");
        HD_Title.SetText(RestarMission);
        bWasHandled = true;
        break;

    case ('backmain'):

        HD_Title = Widget.GetObject("label");
        HD_Title.SetText(BackMainMenu);
        HD_Title = Widget.GetObject("textField");
        HD_Title.SetText(BackMainMenu);
        bWasHandled = true;
        break;

    case ('exitgame'):

        HD_Title = Widget.GetObject("label");
        HD_Title.SetText(ExitGame);
        HD_Title = Widget.GetObject("textField");
        HD_Title.SetText(ExitGame);
        bWasHandled = true;
        break;

    }

    if (!bWasHandled)
    {
        bWasHandled = Super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    }

    return bWasHandled;

}

