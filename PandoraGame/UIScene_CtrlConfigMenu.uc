class UIScene_CtrlConfigMenu extends UIScene_BaseFrontEnd;

struct CtrlLabelInfo
{
    /** INCLUDES MACROS STRUCT DECLARATIONS */
    var() name ButtonLabelName;
    /** INCLUDES MACROS STRUCT DECLARATIONS */
    var() name ButtonName;
    var transient UILabel ButtonLabel;

    structdefaultproperties
    {
        ButtonLabelName="None"
        ButtonName="None"
        ButtonLabel=none
    }
};

var transient UILabel CtrlConfigText;
var transient UILabel lblBackButton;
var const localized string Ctrl_Default;
var const localized string Ctrl_Legacy;
var const localized string Ctrl_SouthPaw;
var const localized string Ctrl_LegacySouthPaw;
var const localized string Ctrl_Tactical;
var const localized string Ctrl_Assault;
var const localized string MP_BackButtonMarkup;
var(Menu) array<CtrlLabelInfo> CtrlLabels;

event InitScene()
{
    local int CurrStickConfig;

    super.InitScene();
    CtrlConfigText = UILabel(FindChild('lblCtrlConfigText', true));
    CurrStickConfig = int(myPC.ProfileSettings.GetStickConfigOption());
    CtrlConfigText.SetDataStoreBinding(GetCtrlConfigString(CurrStickConfig));
    lblBackButton = UILabel(FindChild('lblBack', true));
    // End:0xC9
    if((myPC != none) && int(myPC.WorldInfo.NetMode) != int(NM_Standalone))
    {
        lblBackButton.SetDataStoreBinding(MP_BackButtonMarkup);
    }
    UpdateCtrlLabels(CurrStickConfig, false);
    //return;    
}

function name GetUIBGImageName()
{
    return 'ShineOverlay';
    //return ReturnValue;    
}

event SceneActivated(bool bInitialActivation)
{
    HideBGImageIfMP();
    HandleMPBGOverlay();
    //return;    
}

function UpdateCtrlLabels(int ConfigId, optional bool bInit = true)
{
    local int I, J;
    local array<ButtonBindingInfo> currConfig;
    local PandoraPlayerInput Input;
    local string strToProcess, strModified;

    // End:0x12
    if(myPC == none)
    {
        return;
    }
    Input = PandoraPlayerInput(myPC.PlayerInput);
    switch(ConfigId)
    {
        // End:0x51
        case 2:
            currConfig = Input.PandoraLegacyCtrlConfig;
            // End:0xE3
            break;
        // End:0x6D
        case 1:
            currConfig = Input.PandoraSouthPawCtrlConfig;
            // End:0xE3
            break;
        // End:0x8A
        case 3:
            currConfig = Input.PandoraLegacySouthPawCtrlConfig;
            // End:0xE3
            break;
        // End:0xA7
        case 4:
            currConfig = Input.PandoraTacticalCtrlConfig;
            // End:0xE3
            break;
        // End:0xC4
        case 5:
            currConfig = Input.PandoraAssaultCtrlConfig;
            // End:0xE3
            break;
        // End:0xC8
        case 0:
        // End:0xFFFF
        default:
            currConfig = Input.PandoraDefaultCtrlConfig;
            // End:0xE3
            break;
            break;
    }
    // End:0x148
    if(!bInit)
    {
        I = 0;
        J0xF5:

        // End:0x148 [Loop If]
        if(I < CtrlLabels.Length)
        {
            CtrlLabels[I].ButtonLabel = UILabel(FindChild(CtrlLabels[I].ButtonLabelName, true));
            I++;
            // [Loop Continue]
            goto J0xF5;
        }
    }
    I = 0;
    J0x14F:

    // End:0x2F5 [Loop If]
    if(I < CtrlLabels.Length)
    {
        J = 0;
        J0x166:

        // End:0x2EB [Loop If]
        if(J < currConfig.Length)
        {
            // End:0x2E1
            if(CtrlLabels[I].ButtonName == currConfig[J].Name)
            {
                // End:0x2DE
                if(CtrlLabels[I].ButtonLabel != none)
                {
                    // End:0x2BA
                    if(Len(currConfig[J].Command) > 0)
                    {
                        CtrlLabels[I].ButtonLabel.SetDataStoreBinding(currConfig[J].Description);
                        strToProcess = CtrlLabels[I].ButtonLabel.GetValue();
                        // End:0x270
                        if(IsPCBuild())
                        {
                            strModified = Input.ProcessButtonToFontMapping(strToProcess, true);                            
                        }
                        else
                        {
                            strModified = Input.ProcessButtonToFontMapping(strToProcess);
                        }
                        CtrlLabels[I].ButtonLabel.SetDataStoreBinding(strModified);                        
                    }
                    else
                    {
                        CtrlLabels[I].ButtonLabel.SetDataStoreBinding("");
                    }
                }
                // [Explicit Break]
                goto J0x2EB;
            }
            J++;
            // [Loop Continue]
            goto J0x166;
        }
        J0x2EB:

        I++;
        // [Loop Continue]
        goto J0x14F;
    }
    //return;    
}

function OnLeftRight(int MenuIndex, bool bRight)
{
    local PandoraProfileSettings.EPandoraStickConfigOpts CurrStickConfig;
    local int ConfigTemp;

    CurrStickConfig = myPC.ProfileSettings.GetStickConfigOption();
    // End:0x108
    if(MenuIndex == (MenuIndexByName("btnCtrlConfig")))
    {
        // End:0x7D
        if(bRight)
        {
            CurrStickConfig = byte(int(CurrStickConfig) + 1);
            // End:0x7A
            if(int(CurrStickConfig) >= int(6))
            {
                CurrStickConfig = 0;
            }            
        }
        else
        {
            ConfigTemp = int(CurrStickConfig) - 1;
            // End:0xA3
            if(ConfigTemp < 0)
            {
                CurrStickConfig = 5;                
            }
            else
            {
                CurrStickConfig = byte(ConfigTemp);
            }
        }
        myPC.ProfileSettings.SetStickConfigOption(int(CurrStickConfig));
        CtrlConfigText.SetValue(GetCtrlConfigString(int(CurrStickConfig)));
        UpdateCtrlLabels(int(CurrStickConfig));
    }
    //return;    
}

function OnSliderChangeByMousePress(int MenuIndex, const out InputEventParameters EventParms)
{
    local bool brightOfCenter;

    // End:0x53
    if(MenuIndex == (MenuIndexByName("btnCtrlConfig")))
    {
        brightOfCenter = IsMouseRightOfLabelCenter(CtrlConfigText, EventParms);
        OnLeftRight(MenuIndex, brightOfCenter);
    }
    //return;    
}

function Cleanup()
{
    super.Cleanup();
    //return;    
}

function bool ProcessCancelInput(const out InputEventParameters EventParms)
{
    // End:0xD7
    if((IsInputCancel(EventParms)) || IsInputEscape(EventParms))
    {
        FadeOut(fadeOutTimeEd);
        // End:0x6A
        if(myPC != none)
        {
            myPC.WriteProfile();
            myPC.UpdateLocalCacheOfProfileSettings();
        }
        // End:0xD5
        if(PreviousMenuScene != none)
        {
            PlayUISound('SceneClosed');
            ActivateRemoteEvent(OnExitRemoteEventName);
            SceneClient.CloseScene(self);
            PreviousMenuScene.SetVisibility(true);
            PreviousMenuScene.FadeIn(fadeInTimeEd);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function string GetCtrlConfigString(int ctrlConfigValue)
{
    local string NewString;

    switch(ctrlConfigValue)
    {
        // End:0x28
        case 0:
            NewString = (LeftArrow $ Ctrl_Default) $ RightArrow;
            // End:0xCF
            break;
        // End:0x49
        case 2:
            NewString = (LeftArrow $ Ctrl_Legacy) $ RightArrow;
            // End:0xCF
            break;
        // End:0x69
        case 1:
            NewString = (LeftArrow $ Ctrl_SouthPaw) $ RightArrow;
            // End:0xCF
            break;
        // End:0x8A
        case 3:
            NewString = (LeftArrow $ Ctrl_LegacySouthPaw) $ RightArrow;
            // End:0xCF
            break;
        // End:0xAB
        case 4:
            NewString = (LeftArrow $ Ctrl_Tactical) $ RightArrow;
            // End:0xCF
            break;
        // End:0xCC
        case 5:
            NewString = (LeftArrow $ Ctrl_Assault) $ RightArrow;
            // End:0xCF
            break;
        // End:0xFFFF
        default:
            break;
    }
    return NewString;
    //return ReturnValue;    
}
