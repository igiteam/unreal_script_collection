class UIScene_Busy extends PKGfxMoviePlayer
    config(UI);

var string WaitingString;
var string ExplanationString;
var GFxObject RootMC;
var config float MinWaitTime;
var float WaitTimeRemaining;
var bool bReadyToClose;
var bool bPendingClose;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local PKFrontEnd FrontEnd;

    FrontEnd = Class'PKFrontEnd'.static.GetFrontEnd();
    // End:0xE6
    if((int(InputEvent) == int(0)) && FrontEnd.CurrentScene == FrontEnd.MultiServersMenu)
    {
        // End:0xE6
        if(ButtonName == 'Escape')
        {
            FrontEnd.CurrentScene.FilterButtonInput(ControllerId, ButtonName, InputEvent);
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
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
    local PKUIManager UIManager;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
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
    local PKEngine GEngine;

    // End:0xDE
    if(!bPendingClose)
    {
        // End:0xD2
        if((WaitTimeRemaining <= float(0)) || MinWaitTime <= float(0))
        {
            GEngine = PKEngine(Class'Engine.Engine'.static.GetEngine());
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
    WaitingString="UpdatingTitle"
    MinWaitTime=1.0000000
    MovieInfo=SwfMovie'PKHD_UI.ui_loading'
    Priority=100
    OnPostAdvance=UpdateBusy
}