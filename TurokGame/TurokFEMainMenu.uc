class TurokFEMainMenu extends TurokUIOverlayParent
    native;

const PC_MAX_PROFILES = 5;
const MaxMenuDepth = 3;

enum eMainMenuButtons
{
    FE_MMB_STORYMODE,               // 0
    FE_MMB_MULTIPLAYER,             // 1
    FE_MMB_OPTIONS,                 // 2
    FE_MMB_PROFILE,                 // 3
    FE_MMB_STATS,                   // 4
    FE_MMB_EXTRAS,                  // 5
    FE_MMB_EXIT,                    // 6
    FE_MMB_MAX                      // 7
};

enum eMainMenuButtons_StoryMode
{
    FE_MMB_STORYMODE_CONTINUE,      // 0
    FE_MMB_STORYMODE_NEW,           // 1
    FE_MMB_STORYMODE_LOAD,          // 2
    FE_MMB_STORYMODE_MAX            // 3
};

enum eMainMenuButtons_StoryMode_New
{
    FE_MMB_STORYMODE_NEW_EASY,      // 0
    FE_MMB_STORYMODE_NEW_MEDIUM,    // 1
    FE_MMB_STORYMODE_NEW_HARD,      // 2
    FE_MMB_STORYMODE_NEW_MAX        // 3
};

enum eMainMenuButtons_StoryMode_Load
{
    FE_MMB_STORYMODE_LOAD_EASY,     // 0
    FE_MMB_STORYMODE_LOAD_MEDIUM,   // 1
    FE_MMB_STORYMODE_LOAD_HARD,     // 2
    FE_MMB_STORYMODE_LOAD_MAX       // 3
};

enum eMainMenuButtons_Multiplayer
{
    FE_MMB_MULTIPLAYER_UNRANKED_MATCH,// 0
    FE_MMB_MULTIPLAYER_RANKED_MATCH,// 1
    FE_MMB_MULTIPLAYER_PRIVATE_MATCH,// 2
    FE_MMB_MULTIPLAYER_FRIENDS,     // 3
    FE_MMB_MULTIPLAYER_HOST_LAN,    // 4
    FE_MMB_MULTIPLAYER_JOIN_LAN,    // 5
    FE_MMB_MULTIPLAYER_MAX          // 6
};

enum eMainMenuButtons_Multiplayer_Unranked
{
    FE_MMB_MULTIPLAYER_UNRANKED_QUICKMATCH,// 0
    FE_MMB_MULTIPLAYER_UNRANKED_CUSTOMMATCH,// 1
    FE_MMB_MULTIPLAYER_UNRANKED_MAX // 2
};

enum eMainMenuButtons_Multiplayer_Ranked
{
    FE_MMB_MULTIPLAYER_RANKED_QUICKMATCH,// 0
    FE_MMB_MULTIPLAYER_RANKED_CUSTOMMATCH,// 1
    FE_MMB_MULTIPLAYER_RANKED_MAX   // 2
};

enum eMainMenuButtons_Options
{
    FE_MMB_OPTIONS_CONTROLLER,      // 0
    FE_MMB_OPTIONS_MOUSE,           // 1
    FE_MMB_OPTIONS_AUDIO,           // 2
    FE_MMB_OPTIONS_VIDEO,           // 3
    FE_MMB_OPTIONS_AUTOSAVE,        // 4
    FE_MMB_OPTIONS_MAX              // 5
};

enum eMainMenuButtons_Profile
{
    FE_MMB_PROFILE_EDIT,            // 0
    FE_MMB_PROFILE_SWITCH,          // 1
    FE_MMB_PROFILE_NEW,             // 2
    FE_MMB_PROFILE_MAX              // 3
};

enum eMainMenuButtons_Options_AutoSave
{
    FE_MMB_OPTIONS_AUTOSAVE_ON,     // 0
    FE_MMB_OPTIONS_AUTOSAVE_OFF,    // 1
    FE_MMB_OPTIONS_AUTOSAVE_MAX     // 2
};

enum eMainMenuButtons_Stats
{
    FE_MMB_STATS_ACHIEVEMENTS,      // 0
    FE_MMB_STATS_STORYMODE,         // 1
    FE_MMB_STATS_MULTIPLAYER,       // 2
    FE_MMB_STATS_LEADERBOARDS,      // 3
    FE_MMB_STATS_MAX                // 4
};

enum eMainMenuButtons_Extras
{
    FE_MMB_EXTRAS_CREDITS,          // 0
    FE_MMB_EXTRAS_DOWNLOADS,        // 1
    FE_MMB_EXTRAS_MAX               // 2
};

enum eMainMenuDepths
{
    FE_MMD_LEVEL_FIRST,             // 0
    FE_MMD_LEVEL_SECOND,            // 1
    FE_MMD_LEVEL_THIRD,             // 2
    FE_MMD_LEVEL_MAX                // 3
};

enum eMainMenuSignInFlow
{
    FE_MAINMENU_SIGNIN_NONE,        // 0
    FE_MAINMENU_SIGNIN_STORYMODE_CONTINUE,// 1
    FE_MAINMENU_SIGNIN_STORYMODE_NEWEASY,// 2
    FE_MAINMENU_SIGNIN_STORYMODE_NEWMEDIUM,// 3
    FE_MAINMENU_SIGNIN_STORYMODE_NEWHARD,// 4
    FE_MAINMENU_SIGNIN_STORYMODE_LOADEASY,// 5
    FE_MAINMENU_SIGNIN_STORYMODE_LOADMEDIUM,// 6
    FE_MAINMENU_SIGNIN_STORYMODE_LOADHARD,// 7
    FE_MAINMENU_SIGNIN_OPTIONS_AUDIO,// 8
    FE_MAINMENU_SIGNIN_OPTIONS_VIDEO,// 9
    FE_MAINMENU_SIGNIN_OPTIONS_MOUSE,// 10
    FE_MAINMENU_SIGNIN_OPTIONS_CONTROLLER,// 11
    FE_MAINMENU_SIGNIN_OPTIONS_AUTOSAVE_ON,// 12
    FE_MAINMENU_SIGNIN_OPTIONS_AUTOSAVE_OFF,// 13
    FE_MAINMENU_SIGNIN_MULTIPLAYER, // 14
    FE_MAINMENU_SIGNIN_MULTIPLAYER_PRIVATE,// 15
    FE_MAINMENU_SIGNIN_MULTIPLAYER_UNRANKED_QUICK,// 16
    FE_MAINMENU_SIGNIN_MULTIPLAYER_UNRANKED_CUSTOM,// 17
    FE_MAINMENU_SIGNIN_MULTIPLAYER_RANKED_QUICK,// 18
    FE_MAINMENU_SIGNIN_MULTIPLAYER_RANKED_CUSTOM,// 19
    FE_MAINMENU_SIGNIN_MULTIPLAYER_INVITE,// 20
    FE_MAINMENU_SIGNIN_MULTIPLAYER_HOSTLAN,// 21
    FE_MAINMENU_SIGNIN_MULTIPLAYER_JOINLAN,// 22
    FE_MAINMENU_SIGNIN_STATS_STORYMODE,// 23
    FE_MAINMENU_SIGNIN_STATS_MULTIPLAYER,// 24
    FE_MAINMENU_SIGNIN_STATS_ACHIEVEMENTS,// 25
    FE_MAINMENU_SIGNIN_STATS_LEADERBOARDS,// 26
    FE_MAINMENU_SIGNIN_MAX          // 27
};

enum eMainMenuProfileWriteFlow
{
    FE_MAINMENU_PROFILEWRITE_NONE,  // 0
    FE_MAINMENU_PROFILEWRITE_NEWGAME,// 1
    FE_MAINMENU_PROFILEWRITE_LOADGAME,// 2
    FE_MAINMENU_PROFILEWRITE_MAX    // 3
};

enum eMainMenuExitFlow
{
    FE_MAINMENU_EXIT_CONTINUE,      // 0
    FE_MAINMENU_EXIT_NEWGAME,       // 1
    FE_MAINMENU_EXIT_MAX            // 2
};

var bool bBlockInput;
var bool bHardModeUnlocked;
var private bool mPendingProfileWrite;
var private bool mPendingSignIn;
var bool mIsExitFlow;
var bool mbIsInitializing;
var string NextScreen;
var int ActiveControllerID;
var int LastSelection[3];
var @NULL CurrentProfileText;
var @NULL TheMenu;
var private byte mNoProfileNewDifficulty;
var private byte mLoadDifficulty;
var private byte mPendingProfileWriteFlow;
var private byte mPendingSignInFlow;
var private byte mNewOverwriteFlow;
var byte mExitFlowCondition;
var private int mPendingControllerId;
var string mNewFlowConsoleString;
var float mFadeMusicDelay;
var float mFadeMusicDelayTimer;
var @NULL mBackgroundMovie;
//var delegate<@NULL> __WriteProfile__Delegate;

// Export UTurokFEMainMenu::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEMainMenu::execHandleInviteFlow(FFrame&, void* const)
native function HandleInviteFlow();

// Export UTurokFEMainMenu::execSetMoviePauseState(FFrame&, void* const)
native function SetMoviePauseState(bool bPaused);

// Export UTurokFEMainMenu::execMemcardSetAutosave(FFrame&, void* const)
native function MemcardSetAutosave(bool bEnabled);

// Export UTurokFEMainMenu::execMemcardLoadCheckpoint(FFrame&, void* const)
native function MemcardLoadCheckpoint();

// Export UTurokFEMainMenu::execPerformBootFlowIfNeeded(FFrame&, void* const)
native function PerformBootFlowIfNeeded();

// Export UTurokFEMainMenu::execStopMovie(FFrame&, void* const)
native function StopMovie();

// Export UTurokFEMainMenu::execFadeFEMusic(FFrame&, void* const)
native function FadeFEMusic();

// Export UTurokFEMainMenu::execenableInput(FFrame&, void* const)
native function enableInput();

function AssignIntroImageAnims(@NULL ToAnternimate)
{
    local @NULL script, anim_clr;

    anim_clr.R = byte(255);
    anim_clr.G = byte(255);
    anim_clr.B = byte(255);
    anim_clr.A = byte(255);
    // DebugMode: 0
    assert(ToAnternimate != none);
    Class'TurokEngine.TurokUI'.static.InitScriptCtrl(ToAnternimate);
    // End:0x1D6
    if(ToAnternimate.ScriptCtrl != none)
    {
        script = Class'TurokEngine.TurokUI'.static.AddScript(ToAnternimate, "intro");
        // End:0x120
        if(script != none)
        {
            script.AddColorKey(0.0000000, anim_clr);
            anim_clr.A = byte(255);
            script.AddColorKey(1.0000000, anim_clr).SetDelegate(IntroComplete);
        }
        script = Class'TurokEngine.TurokUI'.static.AddScript(ToAnternimate, "exit");
        // End:0x1B7
        if(script != none)
        {
            script.AddColorKey(0.0000000, anim_clr);
            anim_clr.A = byte(255);
            script.AddColorKey(1.0000000, anim_clr).SetDelegate(ExitComplete);
        }
        Class'TurokEngine.TurokUI'.static.PlayScript(ToAnternimate, "intro");
    }
    //return;    
}

function OnHighlightMain()
{
    local @NULL the_tex;

    // End:0x62
    if(TheMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1a", Class'Engine.Texture'));
        TheMenu.GetSelectedItem().mMaskBackground = the_tex;
    }
    //return;    
}

function OnHighlightMainStoryMode()
{
    UpdateStoryModeSaveGameStatus();
    OnHighlightMain();
    //return;    
}

function OnUnHighlightMain()
{
    local @NULL the_tex;

    // End:0x62
    if(TheMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1b", Class'Engine.Texture'));
        TheMenu.GetSelectedItem().mMaskBackground = the_tex;
    }
    //return;    
}

function OnHighlightSub()
{
    local @NULL the_tex;

    // End:0x79
    if(TheMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture3a", Class'Engine.Texture'));
        TheMenu.GetSelectedItem().SubMenu.GetSelectedItem().mMaskBackground = the_tex;
    }
    //return;    
}

function OnUnHighlightSub()
{
    local @NULL the_tex;

    // End:0x79
    if(TheMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture3b", Class'Engine.Texture'));
        TheMenu.GetSelectedItem().SubMenu.GetSelectedItem().mMaskBackground = the_tex;
    }
    //return;    
}

function OnHighlightSubSub()
{
    local @NULL the_tex;

    // End:0x90
    if(TheMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture3a", Class'Engine.Texture'));
        TheMenu.GetSelectedItem().SubMenu.GetSelectedItem().SubMenu.GetSelectedItem().mMaskBackground = the_tex;
    }
    //return;    
}

function OnUnHighlightSubSub()
{
    local @NULL the_tex;

    // End:0x90
    if(TheMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture3b", Class'Engine.Texture'));
        TheMenu.GetSelectedItem().SubMenu.GetSelectedItem().SubMenu.GetSelectedItem().mMaskBackground = the_tex;
    }
    //return;    
}

function ShrinkifyTheMainMenu()
{
    // End:0x14
    if(Class'Engine.Engine'.static.IsPC())
    {
        return;
    }
    // End:0x7A
    if(TheMenu != none)
    {
        TheMenu.StartShrinkification(true);
        TheMenu.GetSelectedItem().SubMenu.StartCounterShrinkification(true, TheMenu.SelectedShrinkMoveX, TheMenu.SelectedShrinkMoveY);
    }
    //return;    
}

function UnShrinkifyTheMainMenu()
{
    // End:0x14
    if(Class'Engine.Engine'.static.IsPC())
    {
        return;
    }
    // End:0x7A
    if(TheMenu != none)
    {
        TheMenu.StartShrinkification(false);
        TheMenu.GetSelectedItem().SubMenu.StartCounterShrinkification(false, TheMenu.SelectedShrinkMoveX, TheMenu.SelectedShrinkMoveY);
    }
    //return;    
}

event UpdateStoryModeSaveGameStatus()
{
    local @NULL sub_menu;

    sub_menu = TheMenu.GetSubMenu(0);
    // End:0x47
    if(Class'TurokEngine.TurokUI'.static.DoesSavedCheckpointExist())
    {
        sub_menu.EnableItem(0);        
    }
    else
    {
        sub_menu.DisableItem(0, true);
    }
    // End:0xA7
    if((Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile() != none) || Class'Engine.Engine'.static.IsPC())
    {
        sub_menu.EnableItem(2);        
    }
    else
    {
        sub_menu.DisableItem(2, true);
    }
    //return;    
}

function DetectAndSetAutosaveState()
{
    local @NULL Profile;
    local int autosaveVal;
    local @NULL sub_sub_menu;

    sub_sub_menu = TheMenu.GetSubMenu(2).GetSubMenu(4);
    Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
    // End:0xDA
    if(Profile != none)
    {
        Profile.GetProfileSettingValueId(60, autosaveVal);
        // End:0xAE
        if(autosaveVal == 0)
        {
            sub_sub_menu.SelectedItemIndex = 1;
            sub_sub_menu.Items[0].bHighlighted = false;            
        }
        else
        {
            sub_sub_menu.SelectedItemIndex = 0;
            sub_sub_menu.Items[1].bHighlighted = false;
        }
    }
    //return;    
}

event SetAutosaveSubmenuState()
{
    local @NULL sub_menu;

    sub_menu = TheMenu.GetSubMenu(2);
    // End:0x7A
    if((Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile() != none) || Class'Engine.Engine'.static.IsPC())
    {
        sub_menu.EnableItem(4);
        sub_menu.SetMenuVisibility(false);        
    }
    else
    {
        sub_menu.DisableItem(4, true);
    }
    DetectAndSetAutosaveState();
    //return;    
}

event SCInitialized()
{
    local @NULL sub_menu, sub_sub_menu, db;

    Class'TurokEngine.TurokUIHelpBar'.static.Instance().enableInput(true);
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Show();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(1, -102177158);
    bBlockInput = true;
    ActiveControllerID = -1;
    PostSignInCleanup();
    SceneClient.SceneControllerMgr.mHasVisitedMainMenu = true;
    TheMenu = TurokUIMenu(Scene.FindChild(name("TheMenu")));
    TheMenu.bHidden = true;
    // DebugMode: 0
    assert(TheMenu != none);
    TheMenu.SetItemHighlightDelegate(0, OnHighlightMainStoryMode);
    TheMenu.SetItemHighlightDelegate(1, OnHighlightMain);
    TheMenu.SetItemHighlightDelegate(2, OnHighlightMain);
    TheMenu.SetItemHighlightDelegate(3, OnHighlightMain);
    TheMenu.SetItemHighlightDelegate(4, OnHighlightMain);
    TheMenu.SetItemHighlightDelegate(5, OnHighlightMain);
    TheMenu.SetItemHighlightDelegate(6, OnHighlightMain);
    TheMenu.SetItemUnhighlightDelegate(0, OnUnHighlightMain);
    TheMenu.SetItemUnhighlightDelegate(1, OnUnHighlightMain);
    TheMenu.SetItemUnhighlightDelegate(2, OnUnHighlightMain);
    TheMenu.SetItemUnhighlightDelegate(3, OnUnHighlightMain);
    TheMenu.SetItemUnhighlightDelegate(4, OnUnHighlightMain);
    TheMenu.SetItemUnhighlightDelegate(5, OnUnHighlightMain);
    TheMenu.SetItemUnhighlightDelegate(6, OnUnHighlightMain);
    TheMenu.SetItemDelegate(3, Menu_Profile);
    TheMenu.SetItemDelegate(6, Menu_Exit);
    sub_menu = TheMenu.GetSubMenu(0);
    // End:0x700
    if(sub_menu != none)
    {
        sub_menu.__OnOpenSubMenu__Delegate = ShrinkifyTheMainMenu;
        sub_menu.SetItemHighlightDelegate(0, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(1, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(2, OnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(2, OnUnHighlightSub);
        // End:0x40C
        if(Class'Engine.Engine'.static.IsPC())
        {
            sub_menu.Items[1].bGrowOnOpenSub = false;
            sub_menu.Items[2].bGrowOnOpenSub = false;
        }
        UpdateStoryModeSaveGameStatus();
        sub_menu.SetItemDelegate(0, StoryMode_Continue);
        sub_sub_menu = sub_menu.GetSubMenu(1);
        // End:0x599
        if(sub_sub_menu != none)
        {
            sub_sub_menu.__OnCloseSubMenu__Delegate = UnShrinkifyTheMainMenu;
            sub_sub_menu.SetItemHighlightDelegate(0, OnHighlightSubSub);
            sub_sub_menu.SetItemHighlightDelegate(1, OnHighlightSubSub);
            sub_sub_menu.SetItemHighlightDelegate(2, OnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(2, OnUnHighlightSubSub);
            sub_sub_menu.SetItemDelegate(0, StoryMode_New_Easy);
            sub_sub_menu.SetItemDelegate(1, StoryMode_New_Medium);
            sub_sub_menu.SetItemDelegate(2, StoryMode_New_Hard);
            // End:0x599
            if(!bHardModeUnlocked)
            {
                sub_sub_menu.DisableItem(2, true);
            }
        }
        sub_sub_menu = sub_menu.GetSubMenu(2);
        // End:0x700
        if(sub_sub_menu != none)
        {
            sub_sub_menu.__OnCloseSubMenu__Delegate = UnShrinkifyTheMainMenu;
            sub_sub_menu.SetItemHighlightDelegate(0, OnHighlightSubSub);
            sub_sub_menu.SetItemHighlightDelegate(1, OnHighlightSubSub);
            sub_sub_menu.SetItemHighlightDelegate(2, OnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(2, OnUnHighlightSubSub);
            sub_sub_menu.SetItemDelegate(0, StoryMode_Load_Easy);
            sub_sub_menu.SetItemDelegate(1, StoryMode_Load_Medium);
            sub_sub_menu.SetItemDelegate(2, StoryMode_Load_Hard);
            // End:0x700
            if(!bHardModeUnlocked)
            {
                sub_sub_menu.DisableItem(2, true);
            }
        }
    }
    sub_menu = TheMenu.GetSubMenu(1);
    // End:0xBC9
    if(sub_menu != none)
    {
        sub_menu.__OnOpenSubMenu__Delegate = ShrinkifyTheMainMenu;
        sub_menu.SetItemHighlightDelegate(0, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(1, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(2, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(3, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(4, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(5, OnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(2, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(3, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(4, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(5, OnUnHighlightSub);
        sub_menu.SetItemDelegate(2, Multiplayer_Private);
        sub_menu.SetItemDelegate(3, Multiplayer_Friends);
        sub_menu.SetItemDelegate(4, Multiplayer_HostLan);
        sub_menu.SetItemDelegate(5, Multiplayer_JoinLan);
        // End:0x947
        if(Class'Engine.Engine'.static.IsPC())
        {
            sub_menu.Items[0].bGrowOnOpenSub = false;
        }
        sub_sub_menu = sub_menu.GetSubMenu(0);
        // End:0xA32
        if(sub_sub_menu != none)
        {
            sub_sub_menu.__OnCloseSubMenu__Delegate = UnShrinkifyTheMainMenu;
            sub_sub_menu.SetItemHighlightDelegate(0, OnHighlightSubSub);
            sub_sub_menu.SetItemHighlightDelegate(1, OnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSubSub);
            sub_sub_menu.SetItemDelegate(0, Multiplayer_Unranked_Quick);
            sub_sub_menu.SetItemDelegate(1, Multiplayer_Unranked_Custom);
        }
        sub_sub_menu = sub_menu.GetSubMenu(1);
        // End:0xB1D
        if(sub_sub_menu != none)
        {
            sub_sub_menu.__OnCloseSubMenu__Delegate = UnShrinkifyTheMainMenu;
            sub_sub_menu.SetItemHighlightDelegate(0, OnHighlightSubSub);
            sub_sub_menu.SetItemHighlightDelegate(1, OnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSubSub);
            sub_sub_menu.SetItemDelegate(0, Multiplayer_Ranked_Quick);
            sub_sub_menu.SetItemDelegate(1, Multiplayer_Ranked_Custom);
        }
        // End:0xB48
        if(Class'Engine.Engine'.static.IsPC())
        {
            sub_menu.DisableItem(2, false);            
        }
        else
        {
            sub_menu.DisableItem(4, false);
            sub_menu.DisableItem(5, false);
        }
        // End:0xB9E
        if(Class'Engine.Engine'.static.IsXenon() == false)
        {
            sub_menu.DisableItem(1, false);
        }
        // End:0xBC9
        if(Class'Engine.Engine'.static.IsPS3() == false)
        {
            sub_menu.DisableItem(3, false);
        }
    }
    sub_menu = TheMenu.GetSubMenu(2);
    // End:0xEE8
    if(sub_menu != none)
    {
        sub_menu.__OnOpenSubMenu__Delegate = ShrinkifyTheMainMenu;
        sub_menu.SetItemHighlightDelegate(0, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(2, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(3, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(1, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(4, OnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(2, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(3, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(4, OnUnHighlightSub);
        sub_menu.SetItemDelegate(0, Options_Controller);
        sub_menu.SetItemDelegate(2, Options_Audio);
        sub_menu.SetItemDelegate(3, Options_Video);
        sub_menu.SetItemDelegate(1, Options_Mouse);
        sub_menu.SetItemDelegate(4, Options_Autosave);
        // End:0xDF2
        if(Class'Engine.Engine'.static.IsPC())
        {
            sub_menu.Items[4].bGrowOnOpenSub = false;
        }
        sub_sub_menu = sub_menu.GetSubMenu(4);
        // End:0xEDE
        if(sub_sub_menu != none)
        {
            sub_sub_menu.__OnCloseSubMenu__Delegate = UnShrinkifyTheMainMenu;
            sub_sub_menu.SetItemHighlightDelegate(0, OnHighlightSubSub);
            sub_sub_menu.SetItemHighlightDelegate(1, OnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSubSub);
            sub_sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSubSub);
            sub_sub_menu.SetItemDelegate(0, Options_AutoSave_On);
            sub_sub_menu.SetItemDelegate(1, Options_AutoSave_Off);
        }
        SetAutosaveSubmenuState();
    }
    sub_menu = TheMenu.GetSubMenu(3);
    // End:0x102E
    if(sub_menu != none)
    {
        sub_menu.__OnOpenSubMenu__Delegate = ShrinkifyTheMainMenu;
        sub_menu.SetItemHighlightDelegate(0, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(1, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(2, OnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(2, OnUnHighlightSub);
        sub_menu.SetItemDelegate(0, Profile_Edit);
        sub_menu.SetItemDelegate(1, Profile_Switch);
        sub_menu.SetItemDelegate(2, Profile_New);
    }
    sub_menu = TheMenu.GetSubMenu(4);
    // End:0x11E1
    if(sub_menu != none)
    {
        sub_menu.SetItemHighlightDelegate(0, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(1, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(2, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(3, OnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(2, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(3, OnUnHighlightSub);
        sub_menu.SetItemDelegate(0, Stats_Achievements);
        sub_menu.SetItemDelegate(1, Stats_Storymode);
        sub_menu.SetItemDelegate(2, Stats_Multiplayer);
        sub_menu.SetItemDelegate(3, Stats_Leaderboards);
        sub_menu.DisableItem(1, false);
        sub_menu.DisableItem(3, false);
    }
    sub_menu = TheMenu.GetSubMenu(5);
    // End:0x1310
    if(sub_menu != none)
    {
        sub_menu.SetItemHighlightDelegate(0, OnHighlightSub);
        sub_menu.SetItemHighlightDelegate(1, OnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(0, OnUnHighlightSub);
        sub_menu.SetItemUnhighlightDelegate(1, OnUnHighlightSub);
        sub_menu.SetItemDelegate(0, Extras_Credits);
        sub_menu.SetItemDelegate(1, Extras_Downloads);
        // End:0x12DC
        if(Class'Engine.Engine'.static.IsPS3())
        {
            sub_menu.DisableItem(1, false);
        }
        // End:0x1310
        if(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile() == none)
        {
            sub_menu.DisableItem(1, true);
        }
    }
    TheMenu.PostSetupInitialize();
    RestorePreviousSelection();
    TheMenu.StartFadeIn();
    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    // End:0x1373
    if(db.HasPendingInvite())
    {
        SignIn(20);
    }
    bBlockInput = false;
    mFadeMusicDelay = 0.5000000;
    mFadeMusicDelayTimer = 0.0000000;
    mIsExitFlow = false;
    //return;    
}

// Export UTurokFEMainMenu::execRestorePreviousSelection(FFrame&, void* const)
native function RestorePreviousSelection();

function StorePreviousSelection(int cur_depth)
{
    local @NULL menu;
    local int I;

    menu = TheMenu;
    // End:0x18
    if(menu == none)
    {
        return;
    }
    I = 0;
    J0x1F:

    // End:0xA3 [Loop If]
    if(I < 3)
    {
        // End:0x88
        if((menu != none) && I <= cur_depth)
        {
            LastSelection[I] = menu.SelectedItemIndex;
            menu = menu.GetSubMenu(LastSelection[I]);
            // [Explicit Continue]
            goto J0x99;
        }
        LastSelection[I] = -1;
        J0x99:

        ++I;
        // [Loop Continue]
        goto J0x1F;
    }
    //return;    
}

event SCTick(float DeltaTime)
{
    TheMenu.Tick();
    // End:0xDB
    if(mIsExitFlow)
    {
        // End:0x5F
        if(int(mExitFlowCondition) == int(0))
        {
            // End:0x50
            if(mFadeMusicDelayTimer > mFadeMusicDelay)
            {
                MemcardLoadCheckpoint();
                mIsExitFlow = false;                
            }
            else
            {
                mFadeMusicDelayTimer += DeltaTime;
            }            
        }
        else
        {
            // End:0xDB
            if(int(mExitFlowCondition) == int(1))
            {
                // End:0xCF
                if(mFadeMusicDelayTimer > mFadeMusicDelay)
                {
                    SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand(mNewFlowConsoleString);
                    SceneClient.ClearAllSceneStacks();
                    mIsExitFlow = false;                    
                }
                else
                {
                    mFadeMusicDelayTimer += DeltaTime;
                }
            }
        }
    }
    //return;    
}

event SCCleanUpOnExit()
{
    TheMenu.Deinitialize();
    TheMenu = none;
    SceneClient = none;
    //return;    
}

event bool SCInputKey_MainMenu(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    // End:0x0B
    if(bBlockInput)
    {
        return true;
    }
    ActiveControllerID = ControllerId;
    EatInput = false;
    SetupHelpBarOnInput(Key, Event);
    // End:0x6A
    if(TheMenu.ProcessInput(ControllerId, Key, Event, AmountDepressed))
    {
        StorePreviousSelection(3);
        return true;
    }
    // End:0x114
    if(((((Key == 'XboxTypeS_B') || Key == 'BackSpace') || Key == 'Escape') || Key == 'MouseXButton1') && int(Event) == int(0))
    {
        // End:0x114
        if((TheMenu.SelectedItemIndex == 2) && TheMenu.GetSubMenu(2).SelectedItemIndex == 4)
        {
            DetectAndSetAutosaveState();
        }
    }
    return EatInput;
    //return ReturnValue;    
}

event HasFocus()
{
    local bool storymode_new_open, storymode_load_open, options_autosave_open, mp_public_open, mp_ranked_open;

    // End:0x0B
    if(mbIsInitializing)
    {
        return;
    }
    super(TurokUISceneController).HasFocus();
    // End:0x212
    if(TheMenu != none)
    {
        TheMenu.bHidden = false;
        storymode_new_open = TheMenu.GetSubMenu(0).GetSubMenu(1).bIsOpen;
        storymode_load_open = TheMenu.GetSubMenu(0).GetSubMenu(2).bIsOpen;
        options_autosave_open = TheMenu.GetSubMenu(2).GetSubMenu(4).bIsOpen;
        mp_public_open = TheMenu.GetSubMenu(1).GetSubMenu(0).bIsOpen;
        mp_ranked_open = TheMenu.GetSubMenu(1).GetSubMenu(1).bIsOpen;
        // End:0x1D1
        if((((storymode_new_open || storymode_load_open) || options_autosave_open) || mp_public_open) || mp_ranked_open)
        {
            Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
            Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(1, -102177158);
            Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);            
        }
        else
        {
            Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
            Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(1, -102177158);
        }
    }
    //return;    
}

function SetupHelpBarOnInput(name Key, byte Event)
{
    local bool storymode_new_open, storymode_load_open, options_autosave_open, mp_public_open, mp_ranked_open;

    local int storymode_index, options_index, multiplayer_index;

    // End:0xBA
    if(((((Key == 'XboxTypeS_B') || Key == 'BackSpace') || Key == 'Escape') || Key == 'MouseXButton1') && (int(Event) == int(0)) || int(Event) == int(2))
    {
        Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
        Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(1, -102177158);        
    }
    else
    {
        // End:0x3A1
        if(((Key == 'XboxTypeS_A') || Key == 'Enter') && (int(Event) == int(0)) || int(Event) == int(2))
        {
            storymode_index = TheMenu.GetSubMenu(0).SelectedItemIndex;
            options_index = TheMenu.GetSubMenu(2).SelectedItemIndex;
            multiplayer_index = TheMenu.GetSubMenu(1).SelectedItemIndex;
            storymode_new_open = TheMenu.GetSubMenu(0).GetSubMenu(1).bIsOpen;
            storymode_load_open = TheMenu.GetSubMenu(0).GetSubMenu(2).bIsOpen;
            options_autosave_open = TheMenu.GetSubMenu(2).GetSubMenu(4).bIsOpen;
            mp_public_open = TheMenu.GetSubMenu(1).GetSubMenu(0).bIsOpen;
            mp_ranked_open = TheMenu.GetSubMenu(1).GetSubMenu(1).bIsOpen;
            // End:0x3A1
            if(((((!storymode_new_open && !storymode_load_open) && TheMenu.SelectedItemIndex == 0) && (storymode_index == 1) || storymode_index == 2) || (!options_autosave_open && TheMenu.SelectedItemIndex == 2) && options_index == 4) || ((!mp_public_open && !mp_ranked_open) && TheMenu.SelectedItemIndex == 1) && (multiplayer_index == 0) || multiplayer_index == 1)
            {
                Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
                Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(1, -102177158);
                Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
            }
        }
    }
    //return;    
}

function DoNothing()
{
    //return;    
}

function IntroComplete()
{
    bBlockInput = false;
    //return;    
}

function ExitComplete()
{
    StopMovie();
    SceneClient.OpenSceneController(NextScreen, 0);
    //return;    
}

function CloseMenu()
{
    TheMenu.StartFadeOut();
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

function byte GetLoadDifficulty()
{
    return mLoadDifficulty;
    //return ReturnValue;    
}

delegate WriteProfile(byte mode)
{
    local @NULL db;

    // End:0x0B
    if(mPendingProfileWrite)
    {
        return;
    }
    mPendingProfileWrite = true;
    mPendingProfileWriteFlow = mode;
    // End:0x45
    if(Class'Engine.Engine'.static.IsPC())
    {
        FEMainMenu_OnProfileWrite(byte(ActiveControllerID), true);        
    }
    else
    {
        db = Class'Engine.TurokOnlineDashboard'.static.Instance();
        db.WriteSignedInProfile(FEMainMenu_OnProfileWrite);
    }
    //return;    
}

function FEMainMenu_OnProfileWrite(byte ControllerId, bool bSuccessful)
{
    local byte profileWriteFlow;
    local @NULL Profile;
    local string difficulty;

    profileWriteFlow = mPendingProfileWriteFlow;
    mPendingProfileWriteFlow = 0;
    mPendingProfileWrite = false;
    // End:0x29
    if(bSuccessful == false)
    {
        return;
    }
    switch(profileWriteFlow)
    {
        // End:0x188
        case 1:
            Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
            // End:0xB4
            if(Profile != none)
            {
                switch(GetDifficulty())
                {
                    // End:0x81
                    case 1:
                        difficulty = "1";
                        // End:0xB1
                        break;
                    // End:0x92
                    case 0:
                        difficulty = "0";
                        // End:0xB1
                        break;
                    // End:0xA3
                    case 2:
                        difficulty = "2";
                        // End:0xB1
                        break;
                    // End:0xFFFF
                    default:
                        difficulty = "";
                        // End:0xB1
                        break;
                        break;
                }                
            }
            else
            {
                switch(mNoProfileNewDifficulty)
                {
                    // End:0xCC
                    case 0:
                        difficulty = "1";
                        // End:0xFC
                        break;
                    // End:0xDD
                    case 1:
                        difficulty = "0";
                        // End:0xFC
                        break;
                    // End:0xEE
                    case 2:
                        difficulty = "2";
                        // End:0xFC
                        break;
                    // End:0xFFFF
                    default:
                        difficulty = "";
                        // End:0xFC
                        break;
                        break;
                }
            }
            StopMovie();
            GetEngine().GamePlayers[0].LockControllerPort(ActiveControllerID);
            mNewFlowConsoleString = "DEFER LOADCHAPTERPOINT 120 " $ difficulty;
            mExitFlowCondition = 1;
            mIsExitFlow = true;
            bBlockInput = true;
            mFadeMusicDelayTimer = 0.0000000;
            FadeFEMusic();
            // End:0x1B6
            break;
        // End:0x1B3
        case 2:
            SceneClient.OpenSceneController("LoadMission", 1);
            // End:0x1B6
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function AutosaveChange_OnComplete(byte ControllerId, bool bSuccessful)
{
    //return;    
}

// Export UTurokFEMainMenu::execEnterLobby(FFrame&, void* const)
native function EnterLobby(byte ControllerId, byte LobbyMode);

// Export UTurokFEMainMenu::execEnterQuickMatch(FFrame&, void* const)
native function EnterQuickMatch(byte ControllerId, byte LobbyMode);

function SelectNewGame()
{
    local @NULL Profile;
    local int autosaveVal;

    Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
    // End:0x88
    if(Profile != none)
    {
        Profile.GetProfileSettingValueId(60, autosaveVal);
        // End:0x74
        if(autosaveVal == 0)
        {
            mPendingProfileWriteFlow = mNewOverwriteFlow;
            FEMainMenu_OnProfileWrite(byte(ActiveControllerID), true);            
        }
        else
        {
            WriteProfile(mNewOverwriteFlow);
        }
    }
    mNewOverwriteFlow = 0;
    //return;    
}

function CheckAndWarnUserDestructiveAction(byte mode)
{
    local @NULL Profile;
    local int autosaveVal;
    local @NULL dlg;

    mNewOverwriteFlow = mode;
    // End:0xFC
    if(Class'TurokEngine.TurokUI'.static.DoesSavedCheckpointExist())
    {
        Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
        // End:0xF9
        if(Profile != none)
        {
            Profile.GetProfileSettingValueId(60, autosaveVal);
            // End:0xEF
            if(autosaveVal == 1)
            {
                dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
                dlg.OpenPopup(SceneClient, 2, 0, -267399611, -1009468167, 423868988, 0, SelectNewGame, DoNothing, None, 1);                
            }
            else
            {
                SelectNewGame();
            }
        }        
    }
    else
    {
        SelectNewGame();
    }
    //return;    
}

function PostSignInAction(optional byte ControllerId)
{
    local @NULL Profile, db;
    local bool bSignInWasSuccessful;

    bSignInWasSuccessful = Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile() != none;
    switch(mPendingSignInFlow)
    {
        // End:0x88
        case 1:
            GetEngine().GamePlayers[0].LockControllerPort(ActiveControllerID);
            mExitFlowCondition = 0;
            mIsExitFlow = true;
            bBlockInput = true;
            mFadeMusicDelayTimer = 0.0000000;
            FadeFEMusic();
            // End:0x737
            break;
        // End:0xD6
        case 2:
            SetDifficulty(1);
            // End:0xB1
            if(bSignInWasSuccessful)
            {
                CheckAndWarnUserDestructiveAction(1);                
            }
            else
            {
                mPendingProfileWriteFlow = 1;
                mNoProfileNewDifficulty = 0;
                FEMainMenu_OnProfileWrite(byte(ActiveControllerID), true);
            }
            // End:0x737
            break;
        // End:0x124
        case 3:
            SetDifficulty(0);
            // End:0xFF
            if(bSignInWasSuccessful)
            {
                CheckAndWarnUserDestructiveAction(1);                
            }
            else
            {
                mPendingProfileWriteFlow = 1;
                mNoProfileNewDifficulty = 1;
                FEMainMenu_OnProfileWrite(byte(ActiveControllerID), true);
            }
            // End:0x737
            break;
        // End:0x172
        case 4:
            SetDifficulty(2);
            // End:0x14D
            if(bSignInWasSuccessful)
            {
                CheckAndWarnUserDestructiveAction(1);                
            }
            else
            {
                mPendingProfileWriteFlow = 1;
                mNoProfileNewDifficulty = 2;
                FEMainMenu_OnProfileWrite(byte(ActiveControllerID), true);
            }
            // End:0x737
            break;
        // End:0x19C
        case 5:
            mPendingProfileWriteFlow = 2;
            mLoadDifficulty = 0;
            FEMainMenu_OnProfileWrite(byte(ActiveControllerID), true);
            // End:0x737
            break;
        // End:0x1C6
        case 6:
            mPendingProfileWriteFlow = 2;
            mLoadDifficulty = 1;
            FEMainMenu_OnProfileWrite(byte(ActiveControllerID), true);
            // End:0x737
            break;
        // End:0x1F0
        case 7:
            mPendingProfileWriteFlow = 2;
            mLoadDifficulty = 2;
            FEMainMenu_OnProfileWrite(byte(ActiveControllerID), true);
            // End:0x737
            break;
        // End:0x209
        case 16:
            EnterQuickMatch(ControllerId, 1);
            // End:0x737
            break;
        // End:0x222
        case 17:
            EnterLobby(ControllerId, 1);
            // End:0x737
            break;
        // End:0x23B
        case 18:
            EnterQuickMatch(ControllerId, 2);
            // End:0x737
            break;
        // End:0x254
        case 19:
            EnterLobby(ControllerId, 2);
            // End:0x737
            break;
        // End:0x26D
        case 15:
            EnterLobby(ControllerId, 3);
            // End:0x737
            break;
        // End:0x286
        case 21:
            EnterLobby(ControllerId, 5);
            // End:0x737
            break;
        // End:0x2B4
        case 23:
            SceneClient.OpenSceneController("StoryModeStats", 1);
            // End:0x737
            break;
        // End:0x2E7
        case 24:
            SceneClient.OpenSceneController("PersonalMultiplayer", 1);
            // End:0x737
            break;
        // End:0x313
        case 25:
            SceneClient.OpenSceneController("Achievements", 1);
            // End:0x737
            break;
        // End:0x33F
        case 26:
            SceneClient.OpenSceneController("Leaderboards", 1);
            // End:0x737
            break;
        // End:0x351
        case 20:
            HandleInviteFlow();
            // End:0x737
            break;
        // End:0x3C6
        case 8:
            TurokFEOptionsAudio(SceneClient.SceneControllerMgr.FindSceneController("OptionsAudio")).SetOverlayParent(self);
            SetHasFocus(false);
            SceneClient.OpenSceneController("OptionsAudio", 1);
            // End:0x737
            break;
        // End:0x43B
        case 9:
            TurokFEOptionsVideo(SceneClient.SceneControllerMgr.FindSceneController("OptionsVideo")).SetOverlayParent(self);
            SetHasFocus(false);
            SceneClient.OpenSceneController("OptionsVideo", 1);
            // End:0x737
            break;
        // End:0x4B6
        case 10:
            TurokFEOptionsAdvanced(SceneClient.SceneControllerMgr.FindSceneController("OptionsAdvanced")).SetOverlayParent(self);
            SetHasFocus(false);
            SceneClient.OpenSceneController("OptionsAdvanced", 1);
            // End:0x737
            break;
        // End:0x655
        case 11:
            // End:0x547
            if(Class'Engine.Engine'.static.IsPC())
            {
                TurokFEOptionsControlsPC(SceneClient.SceneControllerMgr.FindSceneController("OptionsControlsPC")).SetOverlayParent(self);
                SetHasFocus(false);
                SceneClient.OpenSceneController("OptionsControlsPC", 1);                
            }
            else
            {
                // End:0x5D5
                if(!Class'Engine.Engine'.static.IsPS3())
                {
                    TurokFEOptionsController(SceneClient.SceneControllerMgr.FindSceneController("OptionsController")).SetOverlayParent(self);
                    SetHasFocus(false);
                    SceneClient.OpenSceneController("OptionsController", 1);                    
                }
                else
                {
                    TurokFEOptionsControllerPS3(SceneClient.SceneControllerMgr.FindSceneController("OptionsControllerPS3")).SetOverlayParent(self);
                    SetHasFocus(false);
                    SceneClient.OpenSceneController("OptionsControllerPS3", 1);
                }
            }
            // End:0x737
            break;
        // End:0x6FE
        case 12:
            Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
            // End:0x6D7
            if(Profile != none)
            {
                MemcardSetAutosave(true);
                Profile.SetProfileSettingValueId(60, 1);
                db = Class'Engine.TurokOnlineDashboard'.static.Instance();
                db.WriteSignedInProfile(AutosaveChange_OnComplete);
            }
            TheMenu.ProcessInput(ActiveControllerID, 'XboxTypeS_B', 0);
            // End:0x737
            break;
        // End:0x734
        case 13:
            FEMainMenu_OnAutoSaveDisable();
            TheMenu.ProcessInput(ActiveControllerID, 'XboxTypeS_B', 0);
            // End:0x737
            break;
        // End:0xFFFF
        default:
            break;
    }
    PostSignInCleanup();
    //return;    
}

function PostSignInCleanup()
{
    mPendingSignInFlow = 0;
    mPendingSignIn = false;
    //return;    
}

function FEMainMenu_SaveAutosaveSettings()
{
    local @NULL Profile, db;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    Profile = TurokOnlineProfile(db.GetSignedInProfile());
    // End:0x73
    if(Profile != none)
    {
        MemcardSetAutosave(false);
        Profile.SetProfileSettingValueId(60, 0);
        db.WriteSignedInProfile(AutosaveChange_OnComplete);
    }
    DetectAndSetAutosaveState();
    //return;    
}

function FEMainMenu_OnAutoSaveDisable()
{
    local @NULL dlg;

    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    dlg.OpenPopup(SceneClient, 2, 0, 947404306, -1009468167, 423868988, 0, FEMainMenu_SaveAutosaveSettings, DetectAndSetAutosaveState, None, 1);
    //return;    
}

function FEMainMenu_OnContinue()
{
    mPendingControllerId = -1;
    PostSignInAction(byte(mPendingControllerId));
    //return;    
}

function FEMainMenu_OnSignIn(byte ControllerId, byte resultCode)
{
    local @NULL dlg;
    local byte signinResult;
    local @NULL db;

    signinResult = resultCode;
    // End:0x396
    if(int(signinResult) != int(0))
    {
        mPendingControllerId = int(ControllerId);
        dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
        // End:0xB6
        if(int(mPendingSignInFlow) <= int(4))
        {
            dlg.OpenPopup(SceneClient, 3, 0, -421394269, 477322111, 417972563, 1033452631, ReAttemptSignIn, FEMainMenu_OnContinue, PostSignInCleanup);            
        }
        else
        {
            // End:0x111
            if(int(mPendingSignInFlow) <= int(7))
            {
                dlg.OpenPopup(SceneClient, 2, 0, 493123056, 477322111, 1033452631, 0, ReAttemptSignIn, PostSignInCleanup, None);                
            }
            else
            {
                // End:0x171
                if((SignInRequiresLive(mPendingSignInFlow)) == false)
                {
                    dlg.OpenPopup(SceneClient, 2, 0, 409862522, 477322111, 1033452631, 0, ReAttemptSignIn, PostSignInCleanup, None);                    
                }
                else
                {
                    // End:0x220
                    if(int(signinResult) == int(3))
                    {
                        // End:0x1DA
                        if(Class'Engine.Engine'.static.IsPS3())
                        {
                            dlg.OpenPopup(SceneClient, 2, 0, -1206149367, 2027339173, 0, 0, PostSignInCleanup, None, None);                            
                        }
                        else
                        {
                            dlg.OpenPopup(SceneClient, 1, 0, -912032082, 2027339173, 0, 0, PostSignInCleanup, None, None);
                        }                        
                    }
                    else
                    {
                        // End:0x333
                        if(int(signinResult) == int(2))
                        {
                            // End:0x28B
                            if(int(mPendingSignInFlow) == int(26))
                            {
                                dlg.OpenPopup(SceneClient, 2, 0, 1235155434, 477322111, 1033452631, 0, ReAttemptSignIn, PostSignInCleanup, None);                                
                            }
                            else
                            {
                                // End:0x2E8
                                if(Class'Engine.Engine'.static.IsPS3())
                                {
                                    dlg.OpenPopup(SceneClient, 2, 0, 1203839422, 477322111, 1033452631, 0, ReAttemptSignIn, PostSignInCleanup, None);                                    
                                }
                                else
                                {
                                    dlg.OpenPopup(SceneClient, 2, 0, 1193524337, 477322111, 1033452631, 0, ReAttemptSignIn, PostSignInCleanup, None);
                                }
                            }                            
                        }
                        else
                        {
                            // End:0x389
                            if(int(signinResult) == int(1))
                            {
                                dlg.OpenPopup(SceneClient, 1, 0, 1203839422, 2027339173, 0, 0, PostSignInCleanup, None, None);                                
                            }
                            else
                            {
                                PostSignInCleanup();
                            }
                        }
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x4B7
        if(Class'Engine.Engine'.static.IsPC())
        {
            // End:0x4B7
            if(((((int(mPendingSignInFlow) == int(16)) || int(mPendingSignInFlow) == int(17)) || int(mPendingSignInFlow) == int(18)) || int(mPendingSignInFlow) == int(19)) || int(mPendingSignInFlow) == int(15))
            {
                db = Class'Engine.TurokOnlineDashboard'.static.Instance();
                // End:0x4B7
                if(!db.CanUserChat(ControllerId))
                {
                    mPendingSignInFlow = 0;
                    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
                    mPendingControllerId = int(ControllerId);
                    dlg.OpenPopup(SceneClient, 1, 0, 1971433271, 2027339173, 0, 0, ReAttemptSignIn, None, None);
                    return;
                }
            }
        }
        PostSignInAction(ControllerId);
    }
    //return;    
}

protected function ContinueFromChatRestrictionDialog()
{
    switch(mPendingSignInFlow)
    {
        // End:0x22
        case 16:
            EnterQuickMatch(byte(mPendingControllerId), 1);
            // End:0x7E
            break;
        // End:0x3D
        case 17:
            EnterLobby(byte(mPendingControllerId), 1);
            // End:0x7E
            break;
        // End:0x58
        case 18:
            EnterQuickMatch(byte(mPendingControllerId), 2);
            // End:0x7E
            break;
        // End:0x73
        case 19:
            EnterLobby(byte(mPendingControllerId), 2);
            // End:0x7E
            break;
        // End:0xFFFF
        default:
            // DebugMode: 0
            assert(false);
            // End:0x7E
            break;
            break;
    }
    //return;    
}

protected function ReAttemptSignIn()
{
    local byte signInFlowType;

    signInFlowType = mPendingSignInFlow;
    PostSignInCleanup();
    SignIn(signInFlowType);
    //return;    
}

protected event SignIn(byte mode)
{
    local @NULL db;
    local bool bOnlineSignIn;
    local byte bInviteController, bInviteParty;

    // End:0x0B
    if(mPendingSignIn)
    {
        return;
    }
    mPendingSignIn = true;
    mPendingSignInFlow = mode;
    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    // End:0x69
    if(int(mode) == int(20))
    {
        db.GetPendingInvite(bInviteController, bInviteParty);
        ActiveControllerID = int(bInviteController);
    }
    bOnlineSignIn = SignInRequiresLive(mode);
    db.super(TurokFEMainMenu).SignIn(byte(ActiveControllerID), bOnlineSignIn, FEMainMenu_OnSignIn);
    //return;    
}

protected function bool SignInRequiresLive(byte mode)
{
    return (((((((int(mode) == int(14)) || int(mode) == int(15)) || int(mode) == int(16)) || int(mode) == int(17)) || int(mode) == int(18)) || int(mode) == int(19)) || int(mode) == int(26)) || int(mode) == int(20);
    //return ReturnValue;    
}

// Export UTurokFEMainMenu::execStoryMode_SignIn(FFrame&, void* const)
native function StoryMode_SignIn(byte signInFlowType);

function StoryMode_Continue()
{
    StoryMode_SignIn(1);
    //return;    
}

function StoryMode_New_Easy()
{
    StoryMode_SignIn(2);
    //return;    
}

function StoryMode_New_Medium()
{
    StoryMode_SignIn(3);
    //return;    
}

function StoryMode_New_Hard()
{
    StoryMode_SignIn(4);
    //return;    
}

function StoryMode_Load_Easy()
{
    SignIn(5);
    //return;    
}

function StoryMode_Load_Medium()
{
    SignIn(6);
    //return;    
}

function StoryMode_Load_Hard()
{
    SignIn(7);
    //return;    
}

function Multiplayer_Private()
{
    SignIn(15);
    //return;    
}

function Multiplayer_Unranked_Quick()
{
    SignIn(16);
    //return;    
}

function Multiplayer_Unranked_Custom()
{
    SignIn(17);
    //return;    
}

function Multiplayer_Ranked_Quick()
{
    SignIn(18);
    //return;    
}

function Multiplayer_Ranked_Custom()
{
    SignIn(19);
    //return;    
}

function Multiplayer_Friends()
{
    local @NULL db;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    db.ShowFriendsGUI(0);
    //return;    
}

function Multiplayer_HostLan()
{
    SignIn(21);
    //return;    
}

function Multiplayer_JoinLan()
{
    TurokFEMultiplayerJoinLanGame(SceneClient.SceneControllerMgr.FindSceneController("JoinLanGame")).SetOverlayParent(self);
    SetHasFocus(false);
    SceneClient.OpenSceneController("JoinLanGame", 1);
    //return;    
}

function Options_Controller()
{
    // End:0x8C
    if(Class'Engine.Engine'.static.IsPC())
    {
        TurokFEOptionsControlsPC(SceneClient.SceneControllerMgr.FindSceneController("OptionsControlsPC")).SetOverlayParent(self);
        SetHasFocus(false);
        SceneClient.OpenSceneController("OptionsControlsPC", 1);        
    }
    else
    {
        // End:0x11A
        if(!Class'Engine.Engine'.static.IsPS3())
        {
            TurokFEOptionsController(SceneClient.SceneControllerMgr.FindSceneController("OptionsController")).SetOverlayParent(self);
            SetHasFocus(false);
            SceneClient.OpenSceneController("OptionsController", 1);            
        }
        else
        {
            TurokFEOptionsControllerPS3(SceneClient.SceneControllerMgr.FindSceneController("OptionsControllerPS3")).SetOverlayParent(self);
            SetHasFocus(false);
            SceneClient.OpenSceneController("OptionsControllerPS3", 1);
        }
    }
    //return;    
}

function Options_Audio()
{
    TurokFEOptionsAudio(SceneClient.SceneControllerMgr.FindSceneController("OptionsAudio")).SetOverlayParent(self);
    SetHasFocus(false);
    SceneClient.OpenSceneController("OptionsAudio", 1);
    //return;    
}

function Options_Video()
{
    TurokFEOptionsVideo(SceneClient.SceneControllerMgr.FindSceneController("OptionsVideo")).SetOverlayParent(self);
    SetHasFocus(false);
    SceneClient.OpenSceneController("OptionsVideo", 1);
    //return;    
}

function Options_Mouse()
{
    TurokFEOptionsAdvanced(SceneClient.SceneControllerMgr.FindSceneController("OptionsAdvanced")).SetOverlayParent(self);
    SetHasFocus(false);
    SceneClient.OpenSceneController("OptionsAdvanced", 1);
    //return;    
}

function Profile_Edit()
{
    TurokFEOptionsProfile(SceneClient.SceneControllerMgr.FindSceneController("OptionsProfile")).SetOverlayParent(self);
    TurokFEOptionsProfile(SceneClient.SceneControllerMgr.FindSceneController("OptionsProfile")).SetCreatingProfile(false);
    SetHasFocus(false);
    SceneClient.OpenSceneController("OptionsProfile", 1);
    //return;    
}

function Profile_Switch()
{
    TurokFEProfileSelectProfileOverlay(SceneClient.SceneControllerMgr.FindSceneController("ProfileSelect")).SetOverlayParent(self);
    SetHasFocus(false);
    SceneClient.OpenSceneController("ProfileSelect", 1);
    //return;    
}

function DontCreateProfile()
{
    SetHasFocus(true);
    //return;    
}

event AlertTooManyProfiles()
{
    local @NULL dlg;

    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    SetHasFocus(false);
    dlg.OpenPopup(SceneClient, 1, 0, 1038720779, 2027339173, 0, 0, DontCreateProfile, None, None, 0);
    //return;    
}

// Export UTurokFEMainMenu::execCreateProfile(FFrame&, void* const)
native function int CreateProfile();

// Export UTurokFEMainMenu::execProfile_New(FFrame&, void* const)
native function Profile_New();

function CloseAutoSaveWarningDialog()
{
    //return;    
}

function Options_Autosave()
{
    //return;    
}

function Options_AutoSave_On()
{
    SignIn(12);
    //return;    
}

function Options_AutoSave_Off()
{
    SignIn(13);
    //return;    
}

function Menu_Profile()
{
    //return;    
}

function Stats_Achievements()
{
    TurokFEStatsAchievements(SceneClient.SceneControllerMgr.FindSceneController("Achievements")).SetOverlayParent(self);
    SetHasFocus(false);
    SceneClient.OpenSceneController("Achievements", 1);
    //return;    
}

function Stats_Storymode()
{
    SignIn(23);
    //return;    
}

function Stats_Multiplayer()
{
    SignIn(24);
    //return;    
}

function Stats_Leaderboards()
{
    SignIn(26);
    //return;    
}

function Extras_Credits()
{
    TheMenu.bHidden = true;
    SceneClient.OpenSceneController("Credits", 1);
    //return;    
}

function Extras_Downloads()
{
    local @NULL db;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    db.ShowMarketplace(ActiveControllerID);
    //return;    
}

function DoExit()
{
    SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand("Exit");
    //return;    
}

function DontExit()
{
    SetHasFocus(true);
    //return;    
}

function Menu_Exit()
{
    local @NULL dlg;

    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    SetHasFocus(false);
    dlg.OpenPopup(SceneClient, 2, 0, -484960627, -1009468167, 423868988, 0, DoExit, DontExit, None, 1);
    //return;    
}

defaultproperties
{
    LastSelection[0]=-1
    LastSelection[1]=-1
    LastSelection[2]=-1
    mPendingControllerId=-1
    mFadeMusicDelay=0.5000000
    SceneName="TurokFEBootFlow.MainMenu"
}