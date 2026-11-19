class TurokFEMultiplayerJoinLanGame extends TurokFEPauseOptionsOverlay
    native;

enum eMultiplayerJoinLanGameSelections
{
    OJLG_TEAM,                      // 0
    OJLG_JOIN,                      // 1
    OJLG_EXIT,                      // 2
    OJLG_MAX                        // 3
};

enum eMultiplayerJoinLanGameState
{
    OJLGS_NONE,                     // 0
    OJLGS_SEARCHING,                // 1
    OJLGS_NOTFOUND,                 // 2
    OJLGS_WAITTOSTART,              // 3
    OJLGS_HOSTDISCONNECTED,         // 4
    OJLGS_ERROR,                    // 5
    OJLGS_MAX                       // 6
};

var bool bBlockInput;
var @NULL TeamOptionsList;
var @NULL OptionsMenu;
var @NULL mOverlayEdges[2];
var @NULL mGamertag;
var transient byte CurrentState;
var private @NULL mLanJoin;
var int currentTeamSelection;
var float mMessageDisplayedTime;

// Export UTurokFEMultiplayerJoinLanGame::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEMultiplayerJoinLanGame::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

event SCInitialized()
{
    local class<Class> MPClass;

    bBlockInput = true;
    InitData();
    TeamOptionsList = TurokUIList(Scene.FindChild(name("TeamOptionsList")));
    // DebugMode: 0
    assert(TeamOptionsList != none);
    OptionsMenu = TurokUIMenu(Scene.FindChild(name("JoinLanGameMenu")));
    // DebugMode: 0
    assert(OptionsMenu != none);
    OptionsMenu.SetItemHighlightDelegate(0, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(2, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(1, OnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(0, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(2, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(1, OnUnHighlightMain);
    OptionsMenu.SetItemDelegate(2, Menu_Exit);
    OptionsMenu.SetItemDelegate(1, Menu_Join);
    OptionsMenu.PostSetupInitialize();
    OptionsMenu.StartFadeIn();
    MPClass = class<TurokFEMPLanJoin>(DynamicLoadObject("TurokGame.TurokFEMPLanJoin", Class'Core.Class'));
    // DebugMode: 0
    assert(MPClass != none);
    mLanJoin = new (self) MPClass;
    mLanJoin.Initialize();
    currentTeamSelection = -1;
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    // DebugMode: 0
    assert(OptionsMenu != none);
    OptionsMenu.ScriptCtrl = none;
    OptionsMenu = none;
    SceneClient = none;
    I = 0;
    J0x31:

    // End:0x6D [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x31;
    }
    mGamertag = none;
    mLanJoin.Deinitialize();
    //return;    
}

event bool SCInputKey_MultiplayerJoinLanGame(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    EatInput = true;
    // End:0xA3
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x40
            case 'XboxTypeS_Back':
                // End:0x40
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0xA3
                    break;
                }
            // End:0x4C
            case 'XboxTypeS_B':
            // End:0x58
            case 'MouseXButton1':
            // End:0x64
            case 'BackSpace':
            // End:0xA0
            case 'Escape':
                Class'TurokEngine.TurokUI'.static.GetFEAudio().PlayFESound(4);
                CloseMenu();
                // End:0xA3
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        // End:0x123
        if(OptionsMenu != none)
        {
            // End:0xDA
            if(OptionsMenu.ProcessInput(ControllerId, Key, Event, AmountDepressed))
            {
                return true;
            }
            switch(OptionsMenu.SelectedItemIndex)
            {
                // End:0x11D
                case 0:
                    // End:0x11A
                    if(TeamOptionsList.ProcessInput(ControllerId, Key, Event, AmountDepressed))
                    {
                        return true;
                    }
                    // End:0x123
                    break;
                // End:0xFFFF
                default:
                    // End:0x123
                    break;
                    break;
            }
        }
        return EatInput;
        //return ReturnValue;        
    }
}

function IntroComplete()
{
    bBlockInput = false;
    //return;    
}

function ExitComplete()
{
    SceneClient.GoBackSceneController(0);
    //return;    
}

function OnHighlightMain()
{
    local @NULL the_tex, slot_label;

    // End:0xDF
    if(OptionsMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1a", Class'Engine.Texture'));
        OptionsMenu.GetSelectedItem().mMaskBackground = the_tex;
        slot_label = none;
        switch(OptionsMenu.SelectedItemIndex)
        {
            // End:0xAD
            case 0:
                slot_label = TeamOptionsList.GetSlotLabel(0);
                TeamOptionsList.Focus();
                // End:0xB3
                break;
            // End:0xFFFF
            default:
                // End:0xB3
                break;
                break;
        }
        // End:0xDF
        if(slot_label != none)
        {
            slot_label.mFontColor = MakeColor(byte(255), 161, 0, byte(255));
        }
    }
    //return;    
}

function OnUnHighlightMain()
{
    local @NULL the_tex, slot_label;

    // End:0xDD
    if(OptionsMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1b", Class'Engine.Texture'));
        OptionsMenu.GetSelectedItem().mMaskBackground = the_tex;
        slot_label = none;
        switch(OptionsMenu.SelectedItemIndex)
        {
            // End:0xAD
            case 0:
                slot_label = TeamOptionsList.GetSlotLabel(0);
                TeamOptionsList.UnFocus();
                // End:0xB3
                break;
            // End:0xFFFF
            default:
                // End:0xB3
                break;
                break;
        }
        // End:0xDD
        if(slot_label != none)
        {
            slot_label.mFontColor = MakeColor(93, 52, 24, byte(255));
        }
    }
    //return;    
}

function Menu_Join()
{
    mLanJoin.SearchGames();
    OptionsMenu.DisableItem(1, true);
    //return;    
}

function Menu_Exit()
{
    mLanJoin.LeaveGame();
    CloseMenu();
    //return;    
}

function InitData()
{
    //return;    
}

event JoinLanReset()
{
    mLanJoin.Reset();
    OptionsMenu.EnableItem(0);
    OptionsMenu.EnableItem(1);
    UpdateTeamSelector();
    //return;    
}

// Export UTurokFEMultiplayerJoinLanGame::execSetJoinTeam(FFrame&, void* const)
native function SetJoinTeam(int Team);

// Export UTurokFEMultiplayerJoinLanGame::execUpdateTeam(FFrame&, void* const)
native function UpdateTeam();

// Export UTurokFEMultiplayerJoinLanGame::execUpdateTeamSelector(FFrame&, void* const)
native event UpdateTeamSelector();

// Export UTurokFEMultiplayerJoinLanGame::execGetCurrentState(FFrame&, void* const)
native function byte GetCurrentState();

// Export UTurokFEMultiplayerJoinLanGame::execSetCurrentState(FFrame&, void* const)
native function SetCurrentState(byte State);

defaultproperties
{
    SceneName="TurokFEMultiplayer.JoinLanGame"
}