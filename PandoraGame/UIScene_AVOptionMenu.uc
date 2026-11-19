class UIScene_AVOptionMenu extends UIScene_BaseFrontEnd;

function bool ProcessAcceptInput(const out InputEventParameters EventParms)
{
    // End:0x9F
    if(IsInputAccept(EventParms))
    {
        // End:0x32
        if(myPC != none)
        {
            myPC.WriteProfile();
        }
        // End:0x9D
        if(PreviousMenuScene != none)
        {
            PlayUISound('SceneClosed');
            ActivateRemoteEvent(OnExitRemoteEventName);
            SceneClient.CloseScene(self);
            PreviousMenuScene.SetVisibility(true);
            PreviousMenuScene.FadeIn(fadeInTimeEd);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessCancelInput(const out InputEventParameters EventParms)
{
    // End:0xC2
    if((IsInputCancel(EventParms)) || IsInputEscape(EventParms))
    {
        FadeOut(fadeOutTimeEd);
        // End:0x55
        if(myPC != none)
        {
            myPC.RestoreProfileFromLocalProfileSettings();
        }
        // End:0xC0
        if(PreviousMenuScene != none)
        {
            PlayUISound('SceneClosed');
            ActivateRemoteEvent(OnExitRemoteEventName);
            SceneClient.CloseScene(self);
            PreviousMenuScene.SetVisibility(true);
            PreviousMenuScene.FadeIn(fadeInTimeEd);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Cleanup()
{
    super.Cleanup();
    //return;    
}
