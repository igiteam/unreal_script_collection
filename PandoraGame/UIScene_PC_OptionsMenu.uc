class UIScene_PC_OptionsMenu extends UIScene_OptionsMenu;

var UILabel lblamBX;
var UILabel lblamBXRumble;

event InitScene()
{
    super.InitScene();
    //return;    
}

function AssignAmBxRumbleQualitySetting()
{
    switch(myPC.ProfileSettings.GetAmBxRumbleQuality())
    {
        // End:0x29
        case 0:
            // End:0x3C
            break;
        // End:0x31
        case 1:
            // End:0x3C
            break;
        // End:0x39
        case 2:
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    local int amBxButtonIndex, amBxRumbleButtonIndex;

    super(UIScene_BaseFrontEnd).SceneActivated(bInitialActivation);
    lblamBX = UILabel(FindChild(name("lblamBX"), true));
    lblamBXRumble = UILabel(FindChild(name("lblamBXRumble"), true));
    myPC.PlayAmBxScript("menu_background", 0);
    // End:0x22A
    if(myPC.ProfileSettings.GetIfCanUseAmBx())
    {
        // End:0xC8
        if(myPC.DoesThePlayerWantToUseAmBx())
        {
            lblamBX.SetValue(GetYesNoString(1));            
        }
        else
        {
            lblamBX.SetValue(GetYesNoString(0));
        }
        amBxButtonIndex = MenuIndexByName("btnAmBx");
        MenuItems[amBxButtonIndex].bDisabled = false;
        MenuItems[amBxButtonIndex].ButtonObj.SetEnabled(true);
        lblamBX.StringRenderComponent.Fade(1.0000000, 1.0000000, 1.0000000);
        lblamBXRumble.SetValue(GetDegreeString(int(myPC.ProfileSettings.GetAmBxRumbleQuality())));
        amBxRumbleButtonIndex = MenuIndexByName("btnAmBxRumble");
        MenuItems[amBxRumbleButtonIndex].bDisabled = false;
        MenuItems[amBxRumbleButtonIndex].ButtonObj.SetEnabled(true);
        lblamBXRumble.StringRenderComponent.Fade(1.0000000, 1.0000000, 1.0000000);        
    }
    else
    {
        lblamBX.SetValue(GetYesNoString(0));
        amBxButtonIndex = MenuIndexByName("btnAmBx");
        MenuItems[amBxButtonIndex].bDisabled = true;
        MenuItems[amBxButtonIndex].ButtonObj.SetEnabled(false);
        lblamBX.StringRenderComponent.Fade(1.0000000, 0.3000000, 0.0000000);
        MenuItems[amBxButtonIndex].ButtonObj.StringRenderComponent.Fade(1.0000000, 0.3000000, 0.0000000);
        lblamBXRumble.SetValue(GetDegreeString(int(myPC.ProfileSettings.GetAmBxRumbleQuality())));
        amBxRumbleButtonIndex = MenuIndexByName("btnAmBxRumble");
        MenuItems[amBxRumbleButtonIndex].bDisabled = true;
        MenuItems[amBxRumbleButtonIndex].ButtonObj.SetEnabled(false);
        lblamBXRumble.StringRenderComponent.Fade(1.0000000, 0.3000000, 0.0000000);
        MenuItems[amBxRumbleButtonIndex].ButtonObj.StringRenderComponent.Fade(1.0000000, 0.3000000, 0.0000000);
    }
    InitMenuItems();
    //return;    
}

function bool UpdateSliderData(int Idx)
{
    // End:0x1B5
    if((Idx == (MenuIndexByName("btnAmBx"))) && myPC.ProfileSettings.GetIfCanUseAmBx())
    {
        // End:0x11A
        if(myPC.DoesThePlayerWantToUseAmBx())
        {
            myPC.PlayAmBxScript("Event_fade_to_black", 0);
            myPC.ForceStopAmBxScript("MenuStopAll");
            myPC.HideAllAmbxObjects();
            lblamBX.SetValue(GetYesNoString(0));
            myPC.UpdateAmBXRumbleSettings();
            myPC.ProfileSettings.TurnProfilesUseOfAmBxOff();
            myPC.SetThePlayerToNOT_UseAmBx();            
        }
        else
        {
            myPC.ProfileSettings.TurnProfilesUseOfAmBxOn();
            myPC.SetThePlayerToUseAmBx();
            myPC.UpdateAmBXRumbleSettings();
            myPC.ShowAllAmbxObjects();
            myPC.PlayAmBxScript("menu_background", 0);
            lblamBX.SetValue(GetYesNoString(1));
        }
    }
    // End:0x311
    if((Idx == (MenuIndexByName("btnAmBxRumble"))) && myPC.ProfileSettings.GetIfCanUseAmBx())
    {
        // End:0x24E
        if(myPC.DoesThePlayerWantToUseAmBxFullRumble() && myPC.DoesThePlayerWantToUseAmBxMediumRumble())
        {
            myPC.ProfileSettings.SetAmBxRumbleQuality(1);            
        }
        else
        {
            // End:0x2A3
            if(myPC.DoesThePlayerWantToUseAmBxMediumRumble() && !myPC.DoesThePlayerWantToUseAmBxFullRumble())
            {
                myPC.ProfileSettings.SetAmBxRumbleQuality(0);                
            }
            else
            {
                myPC.ProfileSettings.SetAmBxRumbleQuality(2);
            }
        }
        myPC.UpdateAmBXRumbleSettings();
        lblamBXRumble.SetValue(GetDegreeString(int(myPC.ProfileSettings.GetAmBxRumbleQuality())));
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessSliderInput(const out InputEventParameters EventParms)
{
    super(UIScene_BaseFrontEnd).ProcessSliderInput(EventParms);
    // End:0x35
    if(int(EventParms.EventType) == int(0))
    {
        UpdateSliderData(CurrMenuItemIdx);
    }
    return false;
    //return ReturnValue;    
}

function OnLeftRight(int MenuIndex, bool bRight)
{
    super.OnLeftRight(MenuIndex, bRight);
    UpdateSliderData(MenuIndex);
    //return;    
}

function OnSliderChangeByMousePress(int MenuIndex, const out InputEventParameters EventParms)
{
    local bool brightOfCenter;

    // End:0x73
    if((MenuIndex == (MenuIndexByName("btnAmBx"))) && myPC.ProfileSettings.GetIfCanUseAmBx())
    {
        brightOfCenter = IsMouseRightOfLabelCenter(lblamBX, EventParms);
        OnLeftRight(MenuIndex, brightOfCenter);        
    }
    else
    {
        // End:0xEC
        if((MenuIndex == (MenuIndexByName("btnAmBxRumble"))) && myPC.ProfileSettings.GetIfCanUseAmBx())
        {
            brightOfCenter = IsMouseRightOfLabelCenter(lblamBXRumble, EventParms);
            OnLeftRight(MenuIndex, brightOfCenter);            
        }
        else
        {
            super.OnSliderChangeByMousePress(MenuIndex, EventParms);
        }
    }
    //return;    
}

function bool OnBackButtonClicked(UIScreenObject EventObject, int PlayerIndex)
{
    myPC.WriteProfile();
    myPC.PauseAmBxAmbientLighting();
    return super(UIScene_BaseFrontEnd).OnBackButtonClicked(EventObject, PlayerIndex);
    //return ReturnValue;    
}
