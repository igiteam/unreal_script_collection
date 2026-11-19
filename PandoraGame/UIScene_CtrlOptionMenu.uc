class UIScene_CtrlOptionMenu extends UIScene_BaseFrontEnd;

var transient UILabel AimAssistUIObject;
var const localized string AimAssistNone;
var const localized string AimAssistBasic;
var const localized string AimAssistAdvanced;

event InitScene()
{
    super.InitScene();
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    super.SceneActivated(bInitialActivation);
    HideBGImageIfMP();
    HandleMPBGOverlay();
    myPC.PlayAmBxScript("menu_background", 0);
    //return;    
}

event SceneDeactivated()
{
    super.SceneDeactivated();
    myPC.PauseAmBxAmbientLighting();
    //return;    
}

function OnLeftRight(int MenuIndex, bool bRight)
{
    //return;    
}

function bool ProcessCancelInput(const out InputEventParameters EventParms)
{
    // End:0x62
    if((IsInputCancel(EventParms)) || IsInputEscape(EventParms))
    {
        FadeOut(fadeOutTimeEd);
        // End:0x56
        if(myPC != none)
        {
            myPC.WriteProfile();
        }
        PreviousMenu();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Cleanup()
{
    super.Cleanup();
    //return;    
}
