class TurokUIHelpBar extends TurokUISceneController
    native;

const MAX_HELP_BAR_ITEMS = 9;

enum eHelpBarButton
{
    eHelpBarButton_ToggleButton,    // 0
    eHelpBarButton_A,               // 1
    eHelpBarButton_B,               // 2
    eHelpBarButton_X,               // 3
    eHelpBarButton_Y,               // 4
    eHelpBarButton_LTRT,            // 5
    eHelpBarButton_LB,              // 6
    eHelpBarButton_RB,              // 7
    eHelpBarButton_Start,           // 8
    eHelpBarButton_NumTypes,        // 9
    eHelpBarButton_MAX              // 10
};

var private @NULL mStaticReferenceScene;
var private @NULL mButtons[9];
var private bool mIsHidden;
var private bool mIsInitialized;
var private bool mHelpActive;
var private bool mInputEnabled;
var @NULL mFont;
var @NULL mXBox360ButtonArt[9];
var @NULL mPS3ButtonArt[9];

// Export UTurokUIHelpBar::execInstance(FFrame&, void* const)
native static final function @NULL Instance();

// Export UTurokUIHelpBar::execInitialize(FFrame&, void* const)
native function Initialize(@NULL pScene, @NULL pSceneClient);

// Export UTurokUIHelpBar::execDeinitialize(FFrame&, void* const)
native function Deinitialize();

// Export UTurokUIHelpBar::execShutDown(FFrame&, void* const)
native function ShutDown();

// Export UTurokUIHelpBar::execReset(FFrame&, void* const)
native function Reset();

// Export UTurokUIHelpBar::execSetButton(FFrame&, void* const)
native function SetButton(byte Button, int hash_id);

// Export UTurokUIHelpBar::execShow(FFrame&, void* const)
native function Show(optional bool bShowAllButtons, optional bool bShowImmediately);

// Export UTurokUIHelpBar::execHide(FFrame&, void* const)
native function Hide(optional bool bImmediately);

// Export UTurokUIHelpBar::execenableInput(FFrame&, void* const)
native function enableInput(bool Enabled);

// Export UTurokUIHelpBar::execTick(FFrame&, void* const)
native function Tick(float elapsed);

// Export UTurokUIHelpBar::execRepositionButtons(FFrame&, void* const)
private native final function RepositionButtons();

// Export UTurokUIHelpBar::execGetTextureFromEnum(FFrame&, void* const)
private native final function @NULL GetTextureFromEnum(byte Button);

event SCCleanUpOnExit()
{
    Deinitialize();
    //return;    
}

defaultproperties
{
    mStaticReferenceScene=UIScene'TurokFEHelpBar.HelpBar'
    mIsHidden=true
    mInputEnabled=true
    mFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mXBox360ButtonArt[0]=Texture2D'TurokFEHelpBar.Help_360_StickR_help'
    mXBox360ButtonArt[1]=Texture2D'TurokFEHelpBar.Help_360_A_HD'
    mXBox360ButtonArt[2]=Texture2D'TurokFEHelpBar.Help_360_B_HD'
    mXBox360ButtonArt[3]=Texture2D'TurokFEHelpBar.Help_360_X_HD'
    mXBox360ButtonArt[4]=Texture2D'TurokFEHelpBar.Help_360_Y_HD'
    mXBox360ButtonArt[5]=Texture2D'TurokFEHelpBar.Help_360_LTRT_HD'
    mXBox360ButtonArt[6]=Texture2D'TurokFEHelpBar.Help_360_LB_HD'
    mXBox360ButtonArt[7]=Texture2D'TurokFEHelpBar.Help_360_RB_HD'
    mXBox360ButtonArt[8]=Texture2D'TurokFEHelpBar.Help_360_Start_HD'
    mPS3ButtonArt[0]=Texture2D'TurokFEHelpBar.Help_PS3_R3_HD'
    mPS3ButtonArt[1]=Texture2D'TurokFEHelpBar.Help_PS3_X_HD'
    mPS3ButtonArt[2]=Texture2D'TurokFEHelpBar.Help_PS3_Circle_HD'
    mPS3ButtonArt[3]=Texture2D'TurokFEHelpBar.Help_PS3_Square_HD'
    mPS3ButtonArt[4]=Texture2D'TurokFEHelpBar.Help_PS3_Triangle_HD'
    mPS3ButtonArt[5]=Texture2D'TurokFEHelpBar.Help_PS3_L2R2_HD'
    mPS3ButtonArt[6]=Texture2D'TurokFEHelpBar.Help_PS3_L1_HD'
    mPS3ButtonArt[7]=Texture2D'TurokFEHelpBar.Help_PS3_R1_HD'
    mPS3ButtonArt[8]=Texture2D'TurokFEHelpBar.Help_PS3_Start_HD'
    SceneName="TurokFEHelpBar.HelpBar"
}