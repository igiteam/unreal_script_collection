class UIScene_Busy extends AdvGfxMoviePlayer
    config(UI);

var string WaitingString;
var string ExplanationString;
var string LocSectionForMessages;
var GFxObject RootMC;
var GFxObject TickerMC;
var GFxObject TextMC;
var GFxObject TitleTF;
var GFxObject MessageTF;
var config float MinWaitTime;
var float WaitTimeRemaining;
var bool bReadyToClose;
var bool bPendingClose;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    return true;
    //return ReturnValue;    
}

simulated function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    TickerMC = RootMC.GetObject("uiload");
    TextMC = RootMC.GetObject("loadtext");
    TitleTF = TextMC.GetObject("titletf");
    MessageTF = TextMC.GetObject("textField");
    // End:0x148
    if(WaitingString == "")
    {
        TitleTF.SetText(" ");        
    }
    else
    {
        TitleTF.SetText(Localize(LocSectionForMessages, WaitingString, "ADVGame"));
    }
    WaitTimeRemaining = MinWaitTime;
    return true;
    //return ReturnValue;    
}

function SetVisible(bool bVisible)
{
    RootMC.super(UIScene_Busy).SetVisible(bVisible);
    //return;    
}

event OnClose()
{
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x61
    if(UIManager != none)
    {
        UIManager.UpdatingSceneClosed(self);
    }
    super(GFxMoviePlayer).OnClose();
    //return;    
}

function CloseWaitScreen()
{
    local AdvEngine GEngine;

    // End:0xDE
    if(!bPendingClose)
    {
        // End:0xD2
        if((WaitTimeRemaining <= float(0)) || MinWaitTime <= float(0))
        {
            GEngine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
            // End:0xCF
            if(GEngine.InputBlockDataList.Length == 0)
            {
                bPendingClose = true;
                Close();
                // End:0xCF
                if(GEngine != none)
                {
                    GEngine.InputBlockingSceneClosing();
                }
            }            
        }
        else
        {
            bReadyToClose = true;
        }
    }
    //return;    
}

final function UpdateBusyStrings(string NewWaitString, string NewExplanationString)
{
    WaitingString = NewWaitString;
    ExplanationString = NewExplanationString;
    // End:0x5C
    if(WaitingString == "")
    {
        TitleTF.SetText(" ");        
    }
    else
    {
        TitleTF.SetText(Localize(LocSectionForMessages, WaitingString, "ADVGame"));
    }
    //return;    
}

final function UpdateBusy(float DeltaTime)
{
    // End:0x5C
    if(!bPendingClose)
    {
        // End:0x5C
        if(WaitTimeRemaining > float(0))
        {
            WaitTimeRemaining -= DeltaTime;
            // End:0x5C
            if(WaitTimeRemaining <= float(0))
            {
                // End:0x5C
                if(bReadyToClose)
                {
                    CloseWaitScreen();
                }
            }
        }
    }
    //return;    
}

defaultproperties
{
    LocSectionForMessages="UpdatingStrings"
    MinWaitTime=1.0000000
    MovieInfo=SwfMovie'UI_AdvCommon.ui_loading'
    bCaptureInput=true
    Priority=100
    OnPostAdvance=UpdateBusy
}