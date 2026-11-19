class TurokGameViewportClient extends GameViewportClient within Engine
    transient
    native;

var @NULL mTurokFE;
var @NULL mStoryModeLoading;
var @NULL mMPEnterLoading;
var @NULL mMPExitLoading;
var @NULL mMPHostMigrationLoading;
var @NULL mBusyLoading;
var private const localized string mMigratingMessage;

event bool Init(out string OutError)
{
    local int interactionIdx;

    // End:0x13
    if(super.Init(OutError) == false)
    {
        return false;
    }
    mStoryModeLoading = new (self) Class'TurokFELoadingScreenStoryMode';
    mMPEnterLoading = new (self) Class'TurokFELoadingScreenMultiplayerEnter';
    mMPExitLoading = new (self) Class'TurokFELoadingScreenMultiplayerExit';
    mMPHostMigrationLoading = new (self) Class'TurokFELoadingScreenHostMigration';
    mBusyLoading = new (self) Class'TurokFELoadingScreenBusy';
    mTurokFE = new (self) Class'TurokFE';
    interactionIdx = GlobalInteractions.Find(switch(ViewportConsole)) + 1;
    {
        // End:0xF9
        if((InsertInteraction(mTurokFE, interactionIdx)) == -1)
        {
            OutError = "Failed to add interaction to GlobalInteractions array:" @ string(mTurokFE.Class);
            return false;
        }
        UIController.SceneClient.SceneControllerMgr = new (self) Class'TurokGameUISCManager';
        UIController.SceneClient.SceneControllerMgr.SetGlobalState();
        return true;
        //return ReturnValue;        
}

event GameSessionStarted(class<Class> GameType)
{
    local @NULL viewPortSize;

    super.GameSessionStarted(GameType);
    // End:0x13B
    if(UIController.SceneClient.SceneControllerMgr != none)
    {
        // End:0xAC
        if(class<TurokFEGame>(GameType) != none)
        {
            GetViewportSize(viewPortSize);
            // End:0x84
            if(Class'TurokEngine.TurokUI'.static.IsSD() == false)
            {
                UIController.SceneClient.SceneControllerMgr.SetFEState();                
            }
            else
            {
                UIController.SceneClient.SceneControllerMgr.SetFEState_SD();
            }            
        }
        else
        {
            GetViewportSize(viewPortSize);
            // End:0xF8
            if(Class'TurokEngine.TurokUI'.static.IsSD() == false)
            {
                UIController.SceneClient.SceneControllerMgr.SetInGameState();                
            }
            else
            {
                UIController.SceneClient.SceneControllerMgr.SetInGameState_SD();
            }
        }
        // End:0x13B
        if(mTurokFE != none)
        {
            mTurokFE.InitSceneControllerRefs();
        }
    }
    //return;    
}

event GameSessionEnded()
{
    super.GameSessionEnded();
    // End:0x24
    if(mTurokFE != none)
    {
        mTurokFE.ClearSceneControllerRefs();
    }
    // End:0x66
    if(UIController.SceneClient.SceneControllerMgr != none)
    {
        UIController.SceneClient.SceneControllerMgr.ClearState();
    }
    //return;    
}

function DrawTransition(@NULL Canvas)
{
    //return;    
}

event StartLoadingScreen(byte TransitionType)
{
    SetPauseMenuEnabledEvent(true);
    // End:0x3D
    if(int(TransitionType) == int(6))
    {
        // End:0x3A
        if(mMPHostMigrationLoading != none)
        {
            mMPHostMigrationLoading.Init(self);
        }        
    }
    else
    {
        // End:0xB2
        if(Class'Engine.Engine'.static.GetTurokNet().GetLobby() != none)
        {
            // End:0x90
            if(Class'TurokUtil'.static.IsMultiplayerGame())
            {
                // End:0x8D
                if(mMPExitLoading != none)
                {
                    mMPExitLoading.Init(self);
                }                
            }
            else
            {
                // End:0xAF
                if(mMPEnterLoading != none)
                {
                    mMPEnterLoading.Init(self);
                }
            }            
        }
        else
        {
            // End:0xD1
            if(mStoryModeLoading != none)
            {
                mStoryModeLoading.Init(self);
            }
        }
    }
    //return;    
}

event StartBusyScreen()
{
    // End:0x1F
    if(mBusyLoading != none)
    {
        mBusyLoading.Init(self);
    }
    //return;    
}

event SetPauseMenuEnabledEvent(bool enableInput)
{
    mTurokFE.SetPauseMenuEnabledTurokFE(enableInput);
    //return;    
}

event bool IsPauseMenuEnabled()
{
    return mTurokFE.mInputAllowed;
    //return ReturnValue;    
}
