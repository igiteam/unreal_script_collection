class TurokFEPauseMenuBase extends TurokUIOverlayParent
    native;

const HASH_ACCEPT = -412331001;
const HASH_BACK = 675426377;

var private float HelpImageInitPosY;
var @NULL HelpImage;
var @NULL FirstHelpLabel;
var @NULL SecondHelpLabel;
var @NULL mSingleHelpImage;
var @NULL mDoubleHelpImage;
var @NULL mPS3SingleHelpImage;
var @NULL mPS3DoubleHelpImage;
var @NULL TheOptionsMenu;
var @NULL FirstObjectiveImage;
var @NULL FirstObjectiveTitle;
var @NULL FirstObjectiveText;
var @NULL SecondObjectiveImage;
var @NULL SecondObjectiveTitle;
var @NULL SecondObjectiveText;
var @NULL mPS3ButtonArt;
var private string mDialogToOpen;
var private byte mDialogToOpen_SceneStackType;
var array mInvites;

// Export UTurokFEPauseMenuBase::execSetDialogToOpenWhenWeOpen(FFrame&, void* const)
native function SetDialogToOpenWhenWeOpen(string dialogName, byte stackType);

// Export UTurokFEPauseMenuBase::execOpenSubDialogIfNecessary(FFrame&, void* const)
native function OpenSubDialogIfNecessary();

// Export UTurokFEPauseMenuBase::execSetNumHelpBarItems(FFrame&, void* const)
native function SetNumHelpBarItems(int NumItems);

// Export UTurokFEPauseMenuBase::execSetHelpBarText(FFrame&, void* const)
native function SetHelpBarText(int firstHash, int secondHash);

// Export UTurokFEPauseMenuBase::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEPauseMenuBase::execSetObjectives(FFrame&, void* const)
native function SetObjectives();

// Export UTurokFEPauseMenuBase::execSetNumObjectives(FFrame&, void* const)
native function SetNumObjectives(int numObjectives);

// Export UTurokFEPauseMenuBase::execSetObjective(FFrame&, void* const)
native function SetObjective(@NULL pTitle, @NULL pText, int titleHash, int textHash);

// Export UTurokFEPauseMenuBase::execSetObjectiveOne(FFrame&, void* const)
native function SetObjectiveOne(int titleHash, int textHash);

// Export UTurokFEPauseMenuBase::execSetObjectiveTwo(FFrame&, void* const)
native function SetObjectiveTwo(int titleHash, int textHash);

// Export UTurokFEPauseMenuBase::execRestartFromCheckpointOrChapterpoint(FFrame&, void* const)
native function bool RestartFromCheckpointOrChapterpoint();

// Export UTurokFEPauseMenuBase::execResetSoundState(FFrame&, void* const)
native function ResetSoundState();

event SCInitialized()
{
    TheOptionsMenu = TurokUIMenu(Scene.FindChild(name("MenuOptions")));
    // DebugMode: 0
    assert(TheOptionsMenu != none);
    //return;    
}

function PAUSEMENU_ResumeDelegate()
{
    CloseMenu(true);
    //return;    
}

function PAUSEMENU_Options_ControllerDelegate()
{
    local @NULL Overlay;

    // End:0x8B
    if(Class'Engine.Engine'.static.IsPC())
    {
        TurokFEOptionsControlsPC(SceneClient.SceneControllerMgr.FindSceneController("OptionsControlsPC")).SetOverlayParent(self);
        SetHasFocus(false);
        SceneClient.OpenSceneController("OptionsControlsPC", 1);
        return;
    }
    // End:0xE1
    if(!Class'Engine.Engine'.static.IsPS3())
    {
        Overlay = TurokFEPauseOptionsController(SceneClient.SceneControllerMgr.FindSceneController("PauseOptionsController"));        
    }
    else
    {
        Overlay = TurokFEPauseOptionsControllerPS3(SceneClient.SceneControllerMgr.FindSceneController("PauseOptionsControllerPS3"));
    }
    // DebugMode: 0
    assert(Overlay != none);
    Overlay.SetOverlayParent(self);
    SetHasFocus(false);
    // End:0x193
    if(!Class'Engine.Engine'.static.IsPS3())
    {
        SceneClient.OpenSceneController("PauseOptionsController", 1);        
    }
    else
    {
        SceneClient.OpenSceneController("PauseOptionsControllerPS3", 1);
    }
    //return;    
}

function PAUSEMENU_Options_AudioDelegate()
{
    // End:0x81
    if(Class'Engine.Engine'.static.IsPC())
    {
        TurokFEOptionsAudio(SceneClient.SceneControllerMgr.FindSceneController("OptionsAudio")).SetOverlayParent(self);
        SetHasFocus(false);
        SceneClient.OpenSceneController("OptionsAudio", 1);
        return;
    }
    //return;    
}

function PAUSEMENU_Options_AdvancedDelegate()
{
    local @NULL Overlay;

    // End:0x87
    if(Class'Engine.Engine'.static.IsPC())
    {
        TurokFEOptionsAdvanced(SceneClient.SceneControllerMgr.FindSceneController("OptionsAdvanced")).SetOverlayParent(self);
        SetHasFocus(false);
        SceneClient.OpenSceneController("OptionsAdvanced", 1);
        return;
    }
    Overlay = TurokFEPauseOptionsAdvanced(SceneClient.SceneControllerMgr.FindSceneController("PauseOptionsAdvanced"));
    // DebugMode: 0
    assert(Overlay != none);
    Overlay.SetOverlayParent(self);
    SetHasFocus(false);
    SceneClient.OpenSceneController("PauseOptionsAdvanced", 1);
    //return;    
}

function TakeFocus()
{
    SetHasFocus(true);
    //return;    
}

function Quit()
{
    SetHasFocus(true);
    CloseMenu(false);
    //return;    
}

event CloseMenu(bool isResume)
{
    Class'TurokEngine.TurokUI'.static.ClosePauseMenu(isResume);
    //return;    
}

// Export UTurokFEPauseMenuBase::execSetHasFocus(FFrame&, void* const)
native function SetHasFocus(bool bFocus);

// Export UTurokFEPauseMenuBase::execCleanUpNative(FFrame&, void* const)
native function CleanUpNative();

event SCCleanUpOnExit()
{
    TheOptionsMenu.Deinitialize();
    TheOptionsMenu = none;
    HelpImage = none;
    FirstHelpLabel = none;
    SecondHelpLabel = none;
    FirstObjectiveImage = none;
    FirstObjectiveTitle = none;
    FirstObjectiveText = none;
    SecondObjectiveImage = none;
    SecondObjectiveTitle = none;
    SecondObjectiveText = none;
    SceneClient = none;
    //return;    
}

// Export UTurokFEPauseMenuBase::execProcessInvites(FFrame&, void* const)
native function ProcessInvites();

// Export UTurokFEPauseMenuBase::execAcceptInviteNative(FFrame&, void* const)
native function AcceptInviteNative();

// Export UTurokFEPauseMenuBase::execDeclineInviteNative(FFrame&, void* const)
native function DeclineInviteNative();

function PAUSEMENU_AcceptInviteDelegate()
{
    AcceptInviteNative();
    //return;    
}

function PAUSEMENU_DeclineInviteDelegate()
{
    SceneClient.GoBackSceneController(2);
    DeclineInviteNative();
    //return;    
}

function PAUSEMENU_AcceptInviteFailedDelegate()
{
    ProcessInvites();
    //return;    
}

defaultproperties
{
    mSingleHelpImage=Texture2D'TurokFEPauseMenuFlow.Help_360_Pause_B'
    mDoubleHelpImage=Texture2D'TurokFEPauseMenuFlow.Help_360_Pause_A_B'
    mPS3SingleHelpImage=Texture2D'TurokFEPauseMenuFlow.Help_PS3_Pause_Circle'
    mPS3DoubleHelpImage=Texture2D'TurokFEPauseMenuFlow.Help_PS3_Pause_X_Circle'
    mPS3ButtonArt=Texture2D'TurokFEPauseMenuFlow.Help_PS3_Pause_X_Circle'
}