class TurokFEMultiplayerSelectorOverlay extends TurokUISceneController
    abstract
    native;

const kM_Unlimited = 1349111180;

var @NULL mSelectorLabel;
var @NULL mLeftArrow;
var @NULL mRightArrow;
var @NULL mInactiveArrow;
var @NULL mActiveArrow;
var @NULL mOverlayEdges[2];
var protected byte kGameSettingID;
var private int mSelectedIndex;
var protected bool mBlockInput;
var @NULL TheMenu;

// Export UTurokFEMultiplayerSelectorOverlay::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event SCInitialized()
{
    TheMenu = TurokUIMenu(Scene.FindChild(name("PCOptionsMenu"), true));
    TheMenu.SetItemDelegate(0, OnSave);
    TheMenu.SetItemDelegate(1, OnCancel);
    TheMenu.PostSetupInitialize();
    TheMenu.StartFadeIn();
    InitSelector();
    //return;    
}

event SCTick(float DeltaTime)
{
    super.SCTick(DeltaTime);
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    SceneClient = none;
    I = 0;
    J0x0E:

    // End:0x4A [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x0E;
    }
    //return;    
}

event HasFocus()
{
    super.HasFocus();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Hide();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Show(false);
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(1, -102177158);
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
    //return;    
}

// Export UTurokFEMultiplayerSelectorOverlay::execInitSelector(FFrame&, void* const)
protected native function InitSelector();

// Export UTurokFEMultiplayerSelectorOverlay::execScroll(FFrame&, void* const)
protected native function bool Scroll(int Direction);

// Export UTurokFEMultiplayerSelectorOverlay::execClick(FFrame&, void* const)
protected native function Click();

// Export UTurokFEMultiplayerSelectorOverlay::execGoBackScreen(FFrame&, void* const)
protected native function GoBackScreen();

// Export UTurokFEMultiplayerSelectorOverlay::execUpdateValueLabel(FFrame&, void* const)
protected native function UpdateValueLabel();

// Export UTurokFEMultiplayerSelectorOverlay::execGetGameSettingsValue(FFrame&, void* const)
protected native function int GetGameSettingsValue();

// Export UTurokFEMultiplayerSelectorOverlay::execSetGameSettingsValue(FFrame&, void* const)
protected native function SetGameSettingsValue();

// Export UTurokFEMultiplayerSelectorOverlay::execGetValueAt(FFrame&, void* const)
protected native function int GetValueAt(int Index);

// Export UTurokFEMultiplayerSelectorOverlay::execGetMaxIndex(FFrame&, void* const)
protected native function int GetMaxIndex();

// Export UTurokFEMultiplayerSelectorOverlay::execGetMinIndex(FFrame&, void* const)
protected native function int GetMinIndex();

// Export UTurokFEMultiplayerSelectorOverlay::execOnSave(FFrame&, void* const)
native function OnSave();

// Export UTurokFEMultiplayerSelectorOverlay::execOnCancel(FFrame&, void* const)
native function OnCancel();

function IntroComplete()
{
    mBlockInput = false;
    //return;    
}

function ExitComplete()
{
    SceneClient.GoBackSceneController(1);
    //return;    
}

defaultproperties
{
    mInactiveArrow=Texture2D'TurokFEWidgets.OptionList.NavArrow_Horizontal_Off'
    mActiveArrow=Texture2D'TurokFEWidgets.OptionList.NavArrow_Horizontal_On'
}