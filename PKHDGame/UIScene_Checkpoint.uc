class UIScene_Checkpoint extends UIScene_Busy
    config(UI);

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    WaitingString="SavingContent_CheckpointTitle"
    ExplanationString="SavingContent_Message"
    bAllowInput=false
    bAllowFocus=false
    Priority=60
}