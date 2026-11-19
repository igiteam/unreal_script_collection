class UIScene_PC_AVOptionMenu extends UIScene_BaseFrontEnd
    native;

var int CurrentDisplayModesIndex;
var int PreviousDisplayModesIndex;
var PandoraProfileSettings.EPandoraCompositePerformaceLevel CurrentPerformanceIndex;
var int PreviousPerformanceIndex;
var bool bIsFullScreen;
var array<string> DisplayModes;
var array<string> PerformanceStrings;
var int iFullScreenIndex;
var UILabel lblResolution;
var UILabel lblVideoPeformance;
var UILabel lblFullScreen;

// Export UUIScene_PC_AVOptionMenu::execGetResolutionStrings(FFrame&, void* const)
native static function GetResolutionStrings(out array<string> ResolutionNames);

// Export UUIScene_PC_AVOptionMenu::execSelectScreenRes(FFrame&, void* const)
native static function SelectScreenRes(int Num, bool fullScreen);

event InitScene()
{
    local string textWithArrow;
    local int iSysConfigIndex, iScreenResolutionIndex;

    super.InitScene();
    iFullScreenIndex = MenuIndexByName("btnFullScreen");
    lblFullScreen = UILabel(FindChild(name("lblFullScreen"), true));
    CurrentDisplayModesIndex = GetCurrentDisplayResolution();
    PreviousDisplayModesIndex = CurrentDisplayModesIndex;
    bIsFullScreen = LocPlayer.ViewportClient.IsFullScreenViewport();
    lblFullScreen.SetDataStoreBinding(GetYesNoString(int(bIsFullScreen)));
    lblResolution = UILabel(FindChild(name("lblScrResolutionText"), true));
    textWithArrow = (LeftArrow $ DisplayModes[CurrentDisplayModesIndex]) $ RightArrow;
    lblResolution.SetDataStoreBinding(textWithArrow);
    CurrentPerformanceIndex = myPC.ProfileSettings.GetVideoPerformance();
    lblVideoPeformance = UILabel(FindChild(name("lblSysConfigText"), true));
    textWithArrow = (LeftArrow $ PerformanceStrings[int(CurrentPerformanceIndex) - int(1)]) $ RightArrow;
    lblVideoPeformance.SetDataStoreBinding(textWithArrow);
    // End:0x2E3
    if((myGameInfo != none) && !myGameInfo.IsInShellLevel(CurrLevelName))
    {
        iSysConfigIndex = MenuIndexByName("btnSysConfig");
        MenuItems[iSysConfigIndex].bDisabled = true;
        MenuItems[iSysConfigIndex].ButtonObj.SetEnabled(false);
        lblVideoPeformance.StringRenderComponent.SetColor(MakeLinearColor(0.2000000, 0.2000000, 0.2000000, 1.0000000));
        iScreenResolutionIndex = MenuIndexByName("btnScreenResolution");
        MenuItems[iScreenResolutionIndex].bDisabled = true;
        MenuItems[iScreenResolutionIndex].ButtonObj.SetEnabled(false);
        lblResolution.StringRenderComponent.SetColor(MakeLinearColor(0.2000000, 0.2000000, 0.2000000, 1.0000000));
    }
    //return;    
}

function int GetCurrentDisplayResolution()
{
    local Vector2D ViewportSize;
    local string VideoResolutionStr;
    local int I, OptionalResolution;

    GetResolutionStrings(DisplayModes);
    LocPlayer.ViewportClient.GetViewportSize(ViewportSize);
    VideoResolutionStr = (string(int(ViewportSize.X)) $ " x ") $ string(int(ViewportSize.Y));
    I = 0;
    J0x6C:

    // End:0xC7 [Loop If]
    if(I < DisplayModes.Length)
    {
        // End:0xA2
        if(DisplayModes[I] == "800 x 600")
        {
            OptionalResolution = I;
        }
        // End:0xBD
        if(DisplayModes[I] == VideoResolutionStr)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x6C;
    }
    return OptionalResolution;
    //return ReturnValue;    
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

function bool DummyOnMessFnToMakeMessageBoxHappy()
{
    return true;
    //return ReturnValue;    
}

function ResolutionChangedConfirm(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x36
    if(((int(eReturnValue) == int(1)) || int(eReturnValue) == int(4)) || int(eReturnValue) == int(0))
    {
        return;
    }
    SelectScreenRes(PreviousDisplayModesIndex, bIsFullScreen);
    //return;    
}

function Cleanup()
{
    local bool bPrevFullScreen;

    bPrevFullScreen = LocPlayer.ViewportClient.IsFullScreenViewport();
    // End:0x109
    if((PreviousDisplayModesIndex != CurrentDisplayModesIndex) || bPrevFullScreen != bIsFullScreen)
    {
        SelectScreenRes(CurrentDisplayModesIndex, bIsFullScreen);
        ShowMsgBox("<Strings:PandoraGame.UIScene_ConfirmationDialog.ResolutionChangedMsg>", "<Strings:PandoraGame.UIScene_ConfirmationDialog.ResolutionChangedTitle>", 6, ResolutionChangedConfirm, DummyOnMessFnToMakeMessageBoxHappy, 15);
    }
    super.Cleanup();
    //return;    
}

function OnLeftRight(int MenuIndex, bool bRight)
{
    local int currentDisplayModesIndexInt;
    local string textWithArrow;

    // End:0xAF
    if(MenuIndex == (MenuIndexByName("btnScreenResolution")))
    {
        // End:0x56
        if(bRight)
        {
            CurrentDisplayModesIndex++;
            // End:0x53
            if(CurrentDisplayModesIndex > (DisplayModes.Length - 1))
            {
                CurrentDisplayModesIndex = 0;
            }            
        }
        else
        {
            CurrentDisplayModesIndex--;
            // End:0x77
            if(CurrentDisplayModesIndex < 0)
            {
                CurrentDisplayModesIndex = DisplayModes.Length - 1;
            }
        }
        textWithArrow = (LeftArrow $ DisplayModes[CurrentDisplayModesIndex]) $ RightArrow;
        lblResolution.SetDataStoreBinding(textWithArrow);        
    }
    else
    {
        // End:0x1D2
        if(MenuIndex == (MenuIndexByName("btnSysConfig")))
        {
            currentDisplayModesIndexInt = int(CurrentPerformanceIndex);
            // End:0x108
            if(bRight)
            {
                currentDisplayModesIndexInt++;
                // End:0x105
                if(currentDisplayModesIndexInt > PerformanceStrings.Length)
                {
                    currentDisplayModesIndexInt = 1;
                }                
            }
            else
            {
                currentDisplayModesIndexInt--;
                // End:0x126
                if(currentDisplayModesIndexInt < 1)
                {
                    currentDisplayModesIndexInt = PerformanceStrings.Length;
                }
            }
            CurrentPerformanceIndex = byte(currentDisplayModesIndexInt);
            myPC.ProfileSettings.SetVideoPerformance(CurrentPerformanceIndex);
            myPC.SetPerformanceSettings(int(CurrentPerformanceIndex));
            myPC.TriggerEventClass(Class'SeqEvent_PerformanceSettingsChanged', myPC);
            textWithArrow = (LeftArrow $ PerformanceStrings[int(CurrentPerformanceIndex) - int(1)]) $ RightArrow;
            lblVideoPeformance.SetDataStoreBinding(textWithArrow);            
        }
        else
        {
            // End:0x22F
            if(MenuIndex == (MenuIndexByName("btnFullScreen")))
            {
                bIsFullScreen = ((bIsFullScreen) ? false : true);
                lblFullScreen.SetDataStoreBinding(GetYesNoString(int(bIsFullScreen)));                
            }
            else
            {
                super.OnLeftRight(MenuIndex, bRight);
            }
        }
    }
    //return;    
}

function OnSliderChangeByMousePress(int MenuIndex, const out InputEventParameters EventParms)
{
    local bool brightOfCenter;

    // End:0x5C
    if(MenuIndex == (MenuIndexByName("btnScreenResolution")))
    {
        brightOfCenter = IsMouseRightOfLabelCenter(lblResolution, EventParms);
        OnLeftRight(MenuIndex, brightOfCenter);        
    }
    else
    {
        // End:0xB1
        if(MenuIndex == (MenuIndexByName("btnSysConfig")))
        {
            brightOfCenter = IsMouseRightOfLabelCenter(lblResolution, EventParms);
            OnLeftRight(MenuIndex, brightOfCenter);            
        }
        else
        {
            super.OnSliderChangeByMousePress(MenuIndex, EventParms);
        }
    }
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    // End:0x58
    if(iFullScreenIndex == MenuIndex)
    {
        MenuItems[iFullScreenIndex].CheckboxObj.SetValue(!MenuItems[iFullScreenIndex].CheckboxObj.IsChecked());
    }
    super.OnClick(OpenedScene, MenuIndex);
    //return;    
}
