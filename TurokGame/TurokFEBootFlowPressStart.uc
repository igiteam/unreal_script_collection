class TurokFEBootFlowPressStart extends TurokUISceneController
    native;

var float Timer;
var @NULL Movie;
var @NULL mMovieTexture;
var bool mPressedStart;
var bool mDemoLoopTimerIsActive;
var float mDemoLoopTriggerTime;
var float mTimeSinceLastInput;
var byte mControllerId;
var @NULL mPS3StartButtonImage;
var @NULL mXbox360StartButtonImage;

// Export UTurokFEBootFlowPressStart::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEBootFlowPressStart::execSignInComplete(FFrame&, void* const)
native function SignInComplete(byte ControllerId, byte resultCode);

// Export UTurokFEBootFlowPressStart::execAttemptSignIn(FFrame&, void* const)
native function AttemptSignIn();

// Export UTurokFEBootFlowPressStart::execGoNextScene(FFrame&, void* const)
native function GoNextScene();

// Export UTurokFEBootFlowPressStart::execPressedStart(FFrame&, void* const)
native function PressedStart();

// Export UTurokFEBootFlowPressStart::execStartMusic(FFrame&, void* const)
native function StartMusic();

// Export UTurokFEBootFlowPressStart::execStopMusic(FFrame&, void* const)
native function StopMusic();

// Export UTurokFEBootFlowPressStart::execRestartMovie(FFrame&, void* const)
native function RestartMovie();

event SCInitialized()
{
    local @NULL helper;
    local int profile_message;
    local @NULL dlg;

    Class'TurokEngine.TurokUIHelpBar'.static.Instance().enableInput(false);
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Hide(true);
    // End:0x10B
    if(Class'Engine.Engine'.static.IsPS3() == true)
    {
        helper = TurokPS3PatchOverlay(SceneClient.SceneControllerMgr.FindSceneController("PS3Patch")).GetHelper();
        Class'Engine.TurokOnlineDashboard'.static.Instance().SetOnPatchAvailableDelegate(helper.PatchAvailable);
        Class'Engine.TurokOnlineDashboard'.static.Instance().SetOnPatchDownloadDelegate(helper.PatchFinished);
    }
    // End:0x24A
    if(SceneClient.SceneControllerMgr.mDisplayProfileChangedWarning == true)
    {
        // End:0x152
        if(SceneClient.SceneControllerMgr.mProfileChangedLostConnection)
        {
            profile_message = -1604944063;            
        }
        else
        {
            // End:0x17B
            if(SceneClient.SceneControllerMgr.mProfileChangedLostConnectionGameWasRanked)
            {
                profile_message = 1525671642;                
            }
            else
            {
                // End:0x1A4
                if(SceneClient.SceneControllerMgr.mDisplayProfileChangedWarningGameWasRanked)
                {
                    profile_message = 193307896;                    
                }
                else
                {
                    // End:0x1CD
                    if(SceneClient.SceneControllerMgr.mProfileChangedDownloadableContentChanged)
                    {
                        profile_message = -1937137262;                        
                    }
                    else
                    {
                        profile_message = -1459672652;
                    }
                }
            }
        }
        dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
        dlg.OpenPopup(SceneClient, 1, 0, profile_message, 2027339173, 0, 0, LoginNotificationOK, None, None, 0, true);
    }
    //return;    
}

function LoginNotificationOK()
{
    SceneClient.SceneControllerMgr.mDisplayProfileChangedWarning = false;
    SceneClient.SceneControllerMgr.mDisplayProfileChangedWarningGameWasRanked = false;
    SceneClient.SceneControllerMgr.mProfileChangedLostConnection = false;
    SceneClient.SceneControllerMgr.mProfileChangedLostConnectionGameWasRanked = false;
    SceneClient.SceneControllerMgr.mProfileChangedDownloadableContentChanged = false;
    //return;    
}

// Export UTurokFEBootFlowPressStart::execResetDemoLoopTimer(FFrame&, void* const)
native function ResetDemoLoopTimer();

// Export UTurokFEBootFlowPressStart::execStartDemoLoopTimer(FFrame&, void* const)
native function StartDemoLoopTimer();

// Export UTurokFEBootFlowPressStart::execStopDemoLoopTimer(FFrame&, void* const)
native function StopDemoLoopTimer();

// Export UTurokFEBootFlowPressStart::execStartDemoLoop(FFrame&, void* const)
native function StartDemoLoop();

event SCCleanUpOnExit()
{
    SceneClient = none;
    //return;    
}

defaultproperties
{
    mDemoLoopTriggerTime=90.0000000
    SceneName="TurokFEBootFlow.PressStart"
}