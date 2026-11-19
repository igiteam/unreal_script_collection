//-----------------------------------------------------------
//base on HD_FrontEnd/HD_GFx_ExitMenu.fla
//-----------------------------------------------------------
class HDGFxChar extends HDGFxTweenableMoviePlayer;

var GFxObject RootMC;
var GFxObject CharMC;
var GFxObject TypeTextMC;
var string CommandString;
var string MessageString;

var PlayerController PC;

function bool Start(optional bool StartPaused = false)
{
	super.Start();
	PC =  GetPC();
	PC.PlayerInput.ResetInput();
	Advance(0);
//
	RootMC = GetVariableObject("_root");
	CharMC = RootMC.GetObject("InPut");
	TypeTextMC = RootMC.GetObject("TypeText");
	class'GameEngine'.static.EnableIME(True);
	return TRUE;
}

final function GFx_ConsoleCommand(string Cmd, optional bool bWriteToLog)
{
	PC.ConsoleCommand(Cmd, bWriteToLog);
}
// event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
//{
//    local bool bWasHandled;
//    local GFxObject HD_Title;
//    bWasHandled = false;
//    switch(WidgetName)
//    {
//    case ('remission'):
//
//        HD_Title = Widget.GetObject("label");
//        HD_Title.SetText(ContinueMission);
//        HD_Title = Widget.GetObject("textField");
//        HD_Title.SetText(ContinueMission);
//        bWasHandled = true;
//        break;
//
//    }
//
//    if (!bWasHandled)
//    {
//        bWasHandled = Super.WidgetInitialized(WidgetName, WidgetPath, Widget);
//    }
//
//    return bWasHandled;
//
//}
function CharSendMessage(optional string CharMessage)
{

	if(CharMessage == "")
	{
	 MessageString = CharMC.GetText();
	 CharMessage = MessageString;
	}
	class'GameEngine'.static.EnableIME(False);
	GFx_ConsoleCommand(CommandString$CharMessage);
	CharMC.SetText("");
	self.Close(TRUE);
	HDTEAMHUD(PC.myHUD).HDChar = None;
}
