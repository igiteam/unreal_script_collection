class UIScene_Checkpoint extends UIScene_Busy
    config(UI);

simulated function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    // End:0x4F
    if(WaitingString == "")
    {
        TitleTF.SetText(" ");        
    }
    else
    {        
        WaitingString $= Class'AdvFrontEnd'.static.GetLocKeySuffix();
        TitleTF.SetText(Localize(LocSectionForMessages, WaitingString, "ADVGame"));
    }
    return true;
    //return ReturnValue;    
}

function CloseWaitScreen()
{
    local EvilPlayerController PC;

    // End:0x69
    if(!bPendingClose && bReadyToClose)
    {
        PC = EvilPlayerController(GetPC());
        // End:0x69
        if(PC != none)
        {
            PC.NotifyCheckpointMessageFinished();
        }
    }
    super.CloseWaitScreen();
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    WaitingString="CheckpointSavedString"
    LocSectionForMessages="AdvPlayerController"
    bAllowInput=false
    bAllowFocus=false
    bCaptureInput=false
    Priority=60
}