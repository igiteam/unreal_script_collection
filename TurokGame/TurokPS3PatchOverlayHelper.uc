class TurokPS3PatchOverlayHelper extends Object
    native;

enum EPatchStatus
{
    EPS_None,                       // 0
    EPS_Succeeded,                  // 1
    EPS_Failed,                     // 2
    EPS_MAX                         // 3
};

var private @NULL mDialogSceneController;
var private byte mStatus;

// Export UTurokPS3PatchOverlayHelper::execStartPatchDownload(FFrame&, void* const)
private native final function StartPatchDownload();

// Export UTurokPS3PatchOverlayHelper::execPatchAvailable(FFrame&, void* const)
native function PatchAvailable(bool bIsAvailable);

// Export UTurokPS3PatchOverlayHelper::execPatchFinished(FFrame&, void* const)
native function PatchFinished(bool bWasSuccessful);

// Export UTurokPS3PatchOverlayHelper::execDeinitialize(FFrame&, void* const)
native function Deinitialize();

// Export UTurokPS3PatchOverlayHelper::execFinishPatchFlow(FFrame&, void* const)
native function FinishPatchFlow();

event ShowFinishedDialog(byte Status)
{
    local @NULL dlg;

    mStatus = Status;
    mDialogSceneController.CloseOverlay();
    dlg = TurokUIDialog(Class'TurokEngine.TurokUI'.static.GetEngine().GameViewport.UIController.SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    dlg.OpenPopup(Class'TurokEngine.TurokUI'.static.GetEngine().GameViewport.UIController.SceneClient, 1, 0, GetStatusMessageHash(Status), 2027339173, 0, 0, FinishPatchFlow, None, None);
    //return;    
}

event ShowPatchDialog()
{
    local @NULL dlg;

    mDialogSceneController.OpenOverlay();
    dlg = TurokUIDialog(Class'TurokEngine.TurokUI'.static.GetEngine().GameViewport.UIController.SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    dlg.OpenPopup(Class'TurokEngine.TurokUI'.static.GetEngine().GameViewport.UIController.SceneClient, 2, 0, 1558885910, 544201488, -1644903683, 0, PressedDialogYes, PressedDialogNo, None);
    //return;    
}

function PressedDialogYes()
{
    Class'TurokEngine.TurokUI'.static.GetEngine().GameViewport.UIController.SceneClient.OpenSceneController("PS3Patch", 1);
    StartPatchDownload();
    //return;    
}

function PressedDialogNo()
{
    Deinitialize();
    //return;    
}

private final function int GetStatusMessageHash(byte Status)
{
    switch(Status)
    {
        // End:0x12
        case 1:
            return -1831520541;
        // End:0x1D
        case 2:
            return 2120113120;
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    //return ReturnValue;    
}
