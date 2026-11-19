class TurokPS3PatchOverlay extends TurokUISceneController
    native;

var string mDisplayText;
var @NULL mDisplayLabel;
var float mTimer;
var float mUpdateFrequency;
var private bool mbCloseRequested;
var private @NULL mHelper;

// Export UTurokPS3PatchOverlay::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokPS3PatchOverlay::execUpdateStatus(FFrame&, void* const)
native function UpdateStatus();

// Export UTurokPS3PatchOverlay::execGetHelper(FFrame&, void* const)
native function @NULL GetHelper();

// Export UTurokPS3PatchOverlay::execDeinitialize(FFrame&, void* const)
native function Deinitialize();

// Export UTurokPS3PatchOverlay::execCloseOverlay(FFrame&, void* const)
native function CloseOverlay();

// Export UTurokPS3PatchOverlay::execOpenOverlay(FFrame&, void* const)
native function OpenOverlay();

event SCCleanUpOnExit()
{
    // End:0x22
    if(mDisplayLabel != none)
    {
        mDisplayLabel.ScriptCtrl = none;
        mDisplayLabel = none;
    }
    //return;    
}

event CloseSceneController()
{
    SceneClient.GoBackSceneController(1);
    //return;    
}

defaultproperties
{
    mUpdateFrequency=3.0000000
    SceneName="TurokFEBootFlow.PS3PatchOverlay"
}