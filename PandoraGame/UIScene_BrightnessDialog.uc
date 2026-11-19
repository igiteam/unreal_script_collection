class UIScene_BrightnessDialog extends UIScene_BaseFrontEnd;

/** INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(Menu) bool bIsChildOfOptionMenu;
var float SavedGamma;
var UISlider GammaSlider;
//var delegate<OnSceneClose> __OnSceneClose__Delegate;
//var delegate<OnFadeOutCompleted> __OnFadeOutCompleted__Delegate;

delegate OnSceneClose()
{
    //return;    
}

delegate bool OnFadeOutCompleted()
{
    //return ReturnValue;    
}

event InitScene()
{
    super.InitScene();
    // End:0x4C
    if((myPC != none) && myPC.ProfileSettings != none)
    {
        SavedGamma = myPC.ProfileSettings.GetGammaSetting();
    }
    //return;    
}

function SetButtonLabelDatastoreBinding(string Markup)
{
    local UILabel Lbl;

    Lbl = UILabel(FindChild('ButtonLabel', true));
    // End:0x3C
    if(Lbl != none)
    {
        Lbl.SetDataStoreBinding(Markup);
    }
    //return;    
}

event FadeCompleted()
{
    super(SPUIScene).FadeCompleted();
    // End:0x36
    if(Opacity <= 0.0000000)
    {
        SceneClient.CloseScene(self);
        OnSceneClose();
    }
    //return;    
}

function bool ProcessAcceptInput(const out InputEventParameters EventParms)
{
    local bool bOkToProcess;

    bOkToProcess = true;
    // End:0x25
    if(HandleBackButtonInput(EventParms))
    {
        bOkToProcess = false;        
    }
    else
    {
        // End:0x3A
        if(IsMouseOverBackButton())
        {
            bOkToProcess = false;
        }
    }
    // End:0x165
    if((IsInputLeftMouseDown(EventParms)) || IsInputAcceptNoMouse(EventParms))
    {
        // End:0x87
        if(IsMouseEvent(EventParms))
        {
            // End:0x87
            if(IsMouseOverSliderBar())
            {
                bOkToProcess = false;
            }
        }
        // End:0xB7
        if(bIsChildOfOptionMenu)
        {
            // End:0xA9
            if(bOkToProcess)
            {
                FadeOut(fadeOutTimeEd);
            }
            ProcessCancelInput(EventParms);            
        }
        else
        {
            // End:0x138
            if((LocPlayer != none) && LocPlayer.Actor != none)
            {
                // End:0x138
                if(bOkToProcess)
                {                    
                    LocPlayer.Actor.ConsoleCommand("Open pandoragame_p?LoadChapter=EP01_ChapterPoint");
                }
            }
        }
        // End:0x163
        if(bOkToProcess && myPC != none)
        {
            myPC.WriteProfile();
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessCancelInput(const out InputEventParameters EventParms)
{
    // End:0xC0
    if((IsInputCancel(EventParms)) || IsInputEscape(EventParms))
    {
        FadeOut(fadeOutTimeEd);
        super.ProcessCancelInput(EventParms);
        // End:0xBE
        if((myPC != none) && myPC.ProfileSettings != none)
        {
            myPC.ProfileSettings.SetGammaSetting(SavedGamma);
            myPC.ProfileSettings.SetProfileDirty(false);
            myPC.SetGamma(SavedGamma);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

event SceneActivated(bool bInitialActivation)
{
    super.SceneActivated(bInitialActivation);
    myPC.PlayAmBxScript("menu_brightness", 0);
    GammaSlider = FindChild('sldGamma', true);
    //return;    
}

event SceneDeactivated()
{
    super.SceneDeactivated();
    myPC.StopAmBxScript("menu_brightness");
    //return;    
}

function amBXPulseMenuItemChange()
{
    // End:0x2B
    if(bSceneUsesAmBxEffects)
    {
        myPC.PlayAmBxScript("menu_pulse", 70);
    }
    //return;    
}

function bool IsMouseOverSliderBar()
{
    local SPGameUISceneClient SPSceneClient;

    // End:0x70
    if(IsPCBuild())
    {
        SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
        // End:0x70
        if(PtIntersectsUIObject(GammaSlider, float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsMouseOverBackButton()
{
    local SPGameUISceneClient SPSceneClient;

    // End:0x7D
    if(IsPCBuild())
    {
        SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
        // End:0x7D
        if((btnBack != none) && PtIntersectsUIObject(btnBack, float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool MouseIsOverMenuButton()
{
    return true;
    //return ReturnValue;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x22
    if(IsPCBuild())
    {
        SetCurrentlyActivatedMenuItemToCurrentIndex();
    }
    // End:0x4B
    if(int(GetWorldInfo().NetMode) == int(NM_Standalone))
    {
        RestartAttractMode();
    }
    // End:0x280
    if(!bInputDisabled)
    {
        // End:0x230
        if(MenuItems.Length > 0)
        {
            switch(MenuStyle)
            {
                // End:0x86
                case 1:
                    // End:0x83
                    if(ProcessHorizontalMenuInput(EventParms))
                    {
                        return true;
                    }
                    // End:0xC1
                    break;
                // End:0xA2
                case 0:
                    // End:0x9F
                    if(ProcessVerticalMenuInput(EventParms))
                    {
                        return true;
                    }
                    // End:0xC1
                    break;
                // End:0xBE
                case 2:
                    // End:0xBB
                    if(ProcessCustomMenuInput(EventParms))
                    {
                        return true;
                    }
                    // End:0xC1
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x164
            if(MenuItems[CurrMenuItemIdx].EditBoxObj != none)
            {
                // End:0x164
                if((!IsInputEscape(EventParms) && !GetWorldInfo().IsConsoleBuild()) && !IsInputAccept(EventParms))
                {
                    // End:0x164
                    if((EventParms.InputKeyName != 'LeftMouseButton') && EventParms.InputKeyName != 'RightMouseButton')
                    {
                        return false;
                    }
                }
            }
            // End:0x21C
            if(((IsPCBuild() && bDisplayCursor) && IsMouseOverSliderBar()) || !IsMouseEvent(EventParms))
            {
                // End:0x1EE
                if((MenuItems[CurrMenuItemIdx].SliderObj != none) || MenuItems[CurrMenuItemIdx].SliderValueObj != none)
                {
                    // End:0x1EB
                    if(ProcessSliderInput(EventParms))
                    {
                        return true;
                    }                    
                }
                else
                {
                    // End:0x21C
                    if(MenuItems[CurrMenuItemIdx].bCallLeftRight)
                    {
                        // End:0x21C
                        if(ProcessLeftRightFuncs(EventParms))
                        {
                            return true;
                        }
                    }
                }
            }
            // End:0x230
            if(ProcessAcceptInput(EventParms))
            {
                return true;
            }
        }
        // End:0x244
        if(ProcessLoginInput(EventParms))
        {
            return true;
        }
        // End:0x258
        if(ProcessCancelInput(EventParms))
        {
            return true;
        }
        // End:0x26C
        if(ProcessEscapeInput(EventParms))
        {
            return true;
        }
        // End:0x280
        if(ProcessToggleInput(EventParms))
        {
            return true;
        }
    }
    return true;
    //return ReturnValue;    
}
