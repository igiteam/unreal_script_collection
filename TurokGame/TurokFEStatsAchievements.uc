class TurokFEStatsAchievements extends TurokUISceneController
    native;

const M_Points = -988843423;

var private @NULL mAchievements;
var private @NULL mTurokSPStats;
var private @NULL mTurokMPStats;
var @NULL m_OverlayParent;
var transient bool SuppressMouseWheel;
var @NULL LockIcon;
var @NULL mOverlayEdges[2];
var @NULL mGamertag;
var @NULL CurrentAchievementPoints;
var @NULL LockBlurb;
var @NULL TheList;
var @NULL TheMenu;
var bool bDataSetup;
var bool mLoadData;
var @NULL CurTex;
var string TextureToLoad;
var string TextureLastLoaded;
var int PrevSelectedSlotIndex;
var float fLoadDelayLength;
var float fLoadDelayTime;

// Export UTurokFEStatsAchievements::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEStatsAchievements::execStartUpdateAchievementImage(FFrame&, void* const)
native function StartUpdateAchievementImage();

// Export UTurokFEStatsAchievements::execAddAchievement(FFrame&, void* const)
native function AddAchievement(int Index);

// Export UTurokFEStatsAchievements::execSetupAchievementsList(FFrame&, void* const)
native function SetupAchievementsList();

// Export UTurokFEStatsAchievements::execUpdateAchievementText(FFrame&, void* const)
native function UpdateAchievementText();

event SCInitialized()
{
    LockIcon = UIImage(Scene.FindChild(name("LockIcon")));
    // End:0x32
    if(LockIcon != none)
    {
    }
    CurrentAchievementPoints = UILabel(Scene.FindChild(name("CurrentPointsText")));
    // End:0x6D
    if(CurrentAchievementPoints != none)
    {
    }
    LockBlurb = UILabel(Scene.FindChild(name("UnlockText")));
    // End:0xA1
    if(LockBlurb != none)
    {
    }
    TheList = TurokUIList(Scene.FindChild(name("TheList")));
    // End:0xD2
    if(TheList != none)
    {
    }
    TheMenu = TurokUIMenu(Scene.FindChild(name("PCOptionsMenu"), true));
    TheMenu.SetItemDelegate(0, CloseMenu);
    TheMenu.PostSetupInitialize();
    TheMenu.StartFadeIn();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
    //return;    
}

event SCTick(float DeltaTime)
{
    // End:0x42
    if((LockIcon != none) && LockIcon.ScriptCtrl != none)
    {
        LockIcon.ScriptCtrl.Tick(LockIcon);
    }
    // End:0x84
    if((CurrentAchievementPoints != none) && CurrentAchievementPoints.ScriptCtrl != none)
    {
        CurrentAchievementPoints.ScriptCtrl.Tick(CurrentAchievementPoints);
    }
    // End:0xC6
    if((LockBlurb != none) && LockBlurb.ScriptCtrl != none)
    {
        LockBlurb.ScriptCtrl.Tick(LockBlurb);
    }
    // End:0xE4
    if(TheList != none)
    {
        TheList.Tick();
    }
    // End:0x102
    if(TheMenu != none)
    {
        TheMenu.Tick();
    }
    mGamertag.Tick();
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    // End:0x22
    if(LockIcon != none)
    {
        LockIcon.ScriptCtrl = none;
        LockIcon = none;
    }
    // End:0x44
    if(CurrentAchievementPoints != none)
    {
        CurrentAchievementPoints.ScriptCtrl = none;
        CurrentAchievementPoints = none;
    }
    // End:0x66
    if(LockBlurb != none)
    {
        LockBlurb.ScriptCtrl = none;
        LockBlurb = none;
    }
    // End:0x8B
    if(TheList != none)
    {
        TheList.Deinitialize();
        TheList = none;
    }
    mAchievements = none;
    mTurokSPStats = none;
    mTurokMPStats = none;
    I = 0;
    J0xA7:

    // End:0xE3 [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0xA7;
    }
    mGamertag = none;
    //return;    
}

// Export UTurokFEStatsAchievements::execCloseMenu(FFrame&, void* const)
native function CloseMenu();

// Export UTurokFEStatsAchievements::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

// Export UTurokFEStatsAchievements::execSetOverlayParent(FFrame&, void* const)
native function SetOverlayParent(@NULL pOverlayParent);

defaultproperties
{
    PrevSelectedSlotIndex=-1
    fLoadDelayLength=0.5000000
    SceneName="TurokFEStats.Achievements.Achievements"
}