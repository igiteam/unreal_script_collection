class TurokFEMultiplayerSelectMapOverlay extends TurokUISceneController
    native;

const kM_Map1 = -1395284242;
const kM_Map2 = -666935768;
const kM_Map3 = 1649188121;
const kM_Map4 = -1362845342;
const kM_Map5 = -268005071;
const kM_Map6 = -993546992;
const kM_Map7 = 1189316650;
const kM_Map8 = 1491691727;
const kM_Map9 = 1377863887;
const kM_Map10 = -1423923007;

var bool bBlockInput;
var bool mLoadingImage;
var bool mLoadData;
var @NULL mList;
var @NULL mDescriptionLabel;
var @NULL mDownloadPackNeededTextLabel;
var @NULL mMapImages[4];
var float mImageFadeLength;
var int mLastListIndex;
var array mMapNames;
var string mLoadingImagePath;
var @NULL mOverlayEdges[2];
var float fLoadDelayLength;
var float fLoadDelayTime;
var float fLastInputTime;
var float fMaxUpdateTime;
var float fIncUpdateMaxTime;
var float fCurrentUpdateTime;
var @NULL TheMenu;

event SCInitialized()
{
    TheMenu = TurokUIMenu(Scene.FindChild(name("PCOptionsMenu"), true));
    TheMenu.SetItemDelegate(0, OnSave);
    TheMenu.SetItemDelegate(1, OnCancel);
    TheMenu.PostSetupInitialize();
    TheMenu.StartFadeIn();
    mLastListIndex = mList.GetSelectedDataIndex();
    //return;    
}

// Export UTurokFEMultiplayerSelectMapOverlay::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEMultiplayerSelectMapOverlay::execUpdateImage(FFrame&, void* const)
native function UpdateImage();

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

event SCCleanUpOnExit()
{
    local int I;

    // End:0x25
    if(mList != none)
    {
        mList.Deinitialize();
        mList = none;
    }
    mMapImages[0].ScriptCtrl = none;
    mMapImages[0] = none;
    mMapImages[1].ScriptCtrl = none;
    mMapImages[1] = none;
    mMapImages[2].ScriptCtrl = none;
    mMapImages[2] = none;
    mMapImages[3].ScriptCtrl = none;
    mMapImages[3] = none;
    mDescriptionLabel.ScriptCtrl = none;
    mDescriptionLabel = none;
    SceneClient = none;
    I = 0;
    J0xBA:

    // End:0xF6 [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0xBA;
    }
    //return;    
}

// Export UTurokFEMultiplayerSelectMapOverlay::execOnSave(FFrame&, void* const)
native function OnSave();

// Export UTurokFEMultiplayerSelectMapOverlay::execOnCancel(FFrame&, void* const)
native function OnCancel();

defaultproperties
{
    mImageFadeLength=0.1250000
    fLoadDelayLength=0.5000000
    fLoadDelayTime=0.5000000
    fMaxUpdateTime=300.0000000
    fIncUpdateMaxTime=30.0000000
    SceneName="TurokFEMultiplayer.SelectMap"
}