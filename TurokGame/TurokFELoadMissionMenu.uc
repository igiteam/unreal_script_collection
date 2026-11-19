class TurokFELoadMissionMenu extends TurokUISceneController
    native;

enum LoadMissionMenuOptions
{
    LMMO_LOAD,                      // 0
    LMMO_CANCEL,                    // 1
    LMMO_MAX                        // 2
};

struct native BGArtTextures
{
    var @NULL m_Background[2];
    var @NULL m_Foreground[2];

    structdefaultproperties
    {
        m_Background[0]=none
        m_Background[1]=none
        m_Foreground[0]=none
        m_Foreground[1]=none
    }
};

var bool mBlockInput;
var bool mDoneLoading;
var bool mDoneFadeOut;
var bool mExitToMainMenu;
var bool mPendingProfileWrite;
var bool mLoadData;
var bool mFadeInDelayDone;
var bool mFadeOutStarted;
var bool mFadeOutDone;
var bool mIsExitFlow;
var @NULL mOverlayEdges[2];
var @NULL mGamertag;
var @NULL mChapterTitleText;
var @NULL mStaticImages[5];
var @NULL mBGArt[2];
var @NULL mFGArt[2];
var @NULL mBGArtBuffer[2];
var @NULL mFGArtBuffer[2];
var array mBGArtTextures;
var @NULL TheSlider;
var @NULL TheMenu;
var int curSliderVal;
var string curLoadString;
var int ActiveControllerID;
var byte mDifficulty;
var float fLoadDelayLength;
var float fLoadDelayTime;
var float fFadeInDelay;
var float fFadeInDelayLength;
var string mNewFlowConsoleString;
var float mFadeMusicDelay;
var float mFadeMusicDelayTimer;
var transient bool SuppressMouseWheel;

// Export UTurokFELoadMissionMenu::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFELoadMissionMenu::execLevelChanged(FFrame&, void* const)
native function LevelChanged();

// Export UTurokFELoadMissionMenu::execFadeOutComplete(FFrame&, void* const)
native function FadeOutComplete();

// Export UTurokFELoadMissionMenu::execSceneFadeInComplete(FFrame&, void* const)
native function SceneFadeInComplete();

// Export UTurokFELoadMissionMenu::execSceneFadeOutComplete(FFrame&, void* const)
native function SceneFadeOutComplete();

// Export UTurokFELoadMissionMenu::execDelayedFadeOutComplete(FFrame&, void* const)
native function DelayedFadeOutComplete();

// Export UTurokFELoadMissionMenu::execFadeFEMusic(FFrame&, void* const)
native function FadeFEMusic();

event SetFadeOutCompleteDelegate(@NULL script, @NULL myColor, float Time)
{
    script.AddColorKey(Time, myColor).SetDelegate(FadeOutComplete);
    //return;    
}

event SetSceneFadeInCompleteDelegate(@NULL script, @NULL myColor, float Time)
{
    script.AddColorKey(Time, myColor).SetDelegate(SceneFadeInComplete);
    //return;    
}

event SetSceneFadeOutCompleteDelegate(@NULL script, @NULL myColor, float Time)
{
    script.AddColorKey(Time, myColor).SetDelegate(SceneFadeOutComplete);
    //return;    
}

event SCInitialized()
{
    local @NULL Profile;
    local int minSliderVal, maxSliderVal, capValue, string_hash;
    local byte loadDifficulty;
    local @NULL mainMenu;

    super.SCInitialized();
    ActiveControllerID = -1;
    mainMenu = TurokFEMainMenu(SceneClient.SceneControllerMgr.FindSceneController("MainMenu"));
    loadDifficulty = mainMenu.GetLoadDifficulty();
    switch(loadDifficulty)
    {
        // End:0x72
        case 0:
            mDifficulty = 1;
            // End:0x95
            break;
        // End:0x82
        case 1:
            mDifficulty = 0;
            // End:0x95
            break;
        // End:0x92
        case 2:
            mDifficulty = 2;
            // End:0x95
            break;
        // End:0xFFFF
        default:
            break;
    }
    Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
    Profile.GetFurthestReachedLevel(mDifficulty, capValue);
    capValue = Class'TurokEngine.TurokUI'.static.GetEngine().mChapterpointManager.GetIndexFromChapterpointId(capValue);
    TheSlider = TurokUISlider(Scene.FindChild(name("LevelChooser"), true));
    minSliderVal = 1;
    maxSliderVal = Class'TurokEngine.TurokUI'.static.GetEngine().mChapterpointManager.GetNumberOfChapterpoints();
    TheSlider.SetNumNotches(maxSliderVal);
    TheSlider.PostSetupInitialize(float(minSliderVal), float(maxSliderVal), float(capValue + 1));
    TheSlider.SetSliderCapNotch(capValue);
    TheMenu = TurokUIMenu(Scene.FindChild(name("PCOptionsMenu"), true));
    TheMenu.SetItemDelegate(0, CheckAndWarnUserDestructiveAction);
    TheMenu.SetItemDelegate(1, OnCancel);
    TheMenu.PostSetupInitialize();
    TheMenu.StartFadeIn();
    string_hash = Class'TurokEngine.TurokUI'.static.GetEngine().GetLocalization().HashAHashString("O_ChapterName" $ string(capValue));
    mChapterTitleText.SetDataStoreBinding(Class'TurokEngine.TurokUI'.static.GetLocalizedString(string_hash));
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(1, -412331001);
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
    mFadeMusicDelay = 0.5000000;
    mFadeMusicDelayTimer = 0.0000000;
    mIsExitFlow = false;
    //return;    
}

event SCTick(float DeltaTime)
{
    super.SCTick(DeltaTime);
    mGamertag.Tick();
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    SceneClient = none;
    mDoneLoading = false;
    mDoneFadeOut = false;
    TheSlider = none;
    mChapterTitleText = none;
    I = 0;
    J0x2C:

    // End:0x68 [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        I++;
        // [Loop Continue]
        goto J0x2C;
    }
    I = 0;
    J0x6F:

    // End:0xA8 [Loop If]
    if(I < 5)
    {
        mStaticImages[I].ScriptCtrl = none;
        mStaticImages[I] = none;
        I++;
        // [Loop Continue]
        goto J0x6F;
    }
    // End:0xFD
    if(mBGArt[0] != none)
    {
        mBGArt[0].ScriptCtrl = none;
        mBGArt[1].ScriptCtrl = none;
        mFGArt[0].ScriptCtrl = none;
        mFGArt[1].ScriptCtrl = none;
    }
    mBGArt[0] = none;
    mBGArt[1] = none;
    mFGArt[0] = none;
    mFGArt[1] = none;
    curSliderVal = -1;
    curLoadString = "";
    mGamertag = none;
    //return;    
}

function SetDifficulty(byte difficulty)
{
    local @NULL Profile;

    Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
    // End:0x4B
    if(Profile != none)
    {
        Profile.SetProfileSettingValueId(12, int(difficulty));
    }
    //return;    
}

function byte GetDifficulty()
{
    local @NULL Profile;
    local int temp_int;

    Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
    Profile.GetProfileSettingValueId(12, temp_int);
    return byte(temp_int);
    //return ReturnValue;    
}

function WriteProfile()
{
    local @NULL db;

    // End:0x0B
    if(mPendingProfileWrite)
    {
        return;
    }
    mPendingProfileWrite = true;
    // End:0x3A
    if(Class'Engine.Engine'.static.IsPC())
    {
        FELoadMission_OnProfileWrite(byte(ActiveControllerID), true);        
    }
    else
    {
        db = Class'Engine.TurokOnlineDashboard'.static.Instance();
        db.WriteSignedInProfile(FELoadMission_OnProfileWrite);
    }
    //return;    
}

function FELoadMission_OnProfileWrite(byte ControllerId, bool bSuccessful)
{
    local string difficulty;
    local int chapterpoint_id;
    local @NULL mainMenu;

    mPendingProfileWrite = false;
    // End:0x1E
    if(bSuccessful == false)
    {
        mBlockInput = false;
        return;
    }
    chapterpoint_id = Class'TurokEngine.TurokUI'.static.GetEngine().mChapterpointManager.GetChapterpointIdFromIndex(int(TheSlider.GetValue() - float(1)));
    switch(mDifficulty)
    {
        // End:0x7C
        case 1:
            difficulty = "1";
            // End:0xAC
            break;
        // End:0x8D
        case 0:
            difficulty = "0";
            // End:0xAC
            break;
        // End:0x9E
        case 2:
            difficulty = "2";
            // End:0xAC
            break;
        // End:0xFFFF
        default:
            difficulty = "";
            // End:0xAC
            break;
            break;
    }
    mainMenu = TurokFEMainMenu(SceneClient.SceneControllerMgr.FindSceneController("MainMenu"));
    mainMenu.StopMovie();
    GetEngine().GamePlayers[0].LockControllerPort(ActiveControllerID);
    mNewFlowConsoleString = (("DEFER LOADCHAPTERPOINT " $ string(chapterpoint_id)) $ " ") $ difficulty;
    mIsExitFlow = true;
    mBlockInput = true;
    mFadeMusicDelayTimer = 0.0000000;
    FadeFEMusic();
    //return;    
}

event LoadSelectedLevel()
{
    local @NULL Profile;
    local int autosaveVal;

    mBlockInput = true;
    SetDifficulty(mDifficulty);
    Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
    // End:0x8A
    if(Profile != none)
    {
        Profile.GetProfileSettingValueId(60, autosaveVal);
        // End:0x80
        if(autosaveVal == 0)
        {
            FELoadMission_OnProfileWrite(byte(ActiveControllerID), true);            
        }
        else
        {
            WriteProfile();
        }
    }
    //return;    
}

event ExitFlowLoadChapter()
{
    SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand(mNewFlowConsoleString);
    SceneClient.ClearAllSceneStacks();
    mBlockInput = false;
    //return;    
}

function DoNothing()
{
    //return;    
}

event CheckAndWarnUserDestructiveAction()
{
    local @NULL Profile;
    local int autosaveVal;
    local @NULL dlg;

    // End:0xF1
    if(Class'TurokEngine.TurokUI'.static.DoesSavedCheckpointExist())
    {
        Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
        // End:0xEE
        if(Profile != none)
        {
            Profile.GetProfileSettingValueId(60, autosaveVal);
            // End:0xE4
            if(autosaveVal == 1)
            {
                dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
                dlg.OpenPopup(SceneClient, 2, 0, 1475143365, -1009468167, 423868988, 0, LoadSelectedLevel, DoNothing, None, 1);                
            }
            else
            {
                LoadSelectedLevel();
            }
        }        
    }
    else
    {
        LoadSelectedLevel();
    }
    //return;    
}

function OnCancel()
{
    mExitToMainMenu = true;
    CloseMenu();
    //return;    
}

// Export UTurokFELoadMissionMenu::execCloseMenu(FFrame&, void* const)
native function CloseMenu();

// Export UTurokFELoadMissionMenu::execUpdateText(FFrame&, void* const)
native function UpdateText();

defaultproperties
{
    mBlockInput=true
    mFadeInDelayDone=true
    curSliderVal=-1
    ActiveControllerID=-1
    fLoadDelayLength=0.5000000
    fFadeInDelayLength=0.1000000
    mFadeMusicDelay=0.5000000
    SceneName="TurokFEStoryModeFlow.LoadMission.LoadMissionMenu"
}