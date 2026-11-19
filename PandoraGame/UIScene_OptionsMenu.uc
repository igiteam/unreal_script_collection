class UIScene_OptionsMenu extends UIScene_BaseFrontEnd;

var int DatafileSize;
var transient UILabel DifficultyUIObject;
var const localized string DifficultyEasy;
var const localized string DifficultyMedium;
var const localized string DifficultyHard;
var transient string SetDefaults_Title;

function string GetDifficultyString()
{
    local string NewString;

    // End:0xAA
    if(((myGameInfo != none) && !myGameInfo.IsInShellLevel(CurrLevelName)) || int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        switch(myPC.ProfileSettings.GetGameDifficulty())
        {
            // End:0x7F
            case 0:
                NewString = DifficultyMedium;
                // End:0xA7
                break;
            // End:0x91
            case 1:
                NewString = DifficultyEasy;
                // End:0xA7
                break;
            // End:0xA4
            case 2:
                NewString = DifficultyHard;
                // End:0xA7
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        switch(myPC.ProfileSettings.GetGameDifficulty())
        {
            // End:0xEB
            case 0:
                NewString = (LeftArrow $ DifficultyMedium) $ RightArrow;
                // End:0x12F
                break;
            // End:0x10B
            case 1:
                NewString = (LeftArrow $ DifficultyEasy) $ RightArrow;
                // End:0x12F
                break;
            // End:0x12C
            case 2:
                NewString = (LeftArrow $ DifficultyHard) $ RightArrow;
                // End:0x12F
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    return NewString;
    //return ReturnValue;    
}

function OnLeftRight(int MenuIndex, bool bRight)
{
    local int CurrDifficulty;

    // End:0x77
    if((((myGameInfo != none) && !myGameInfo.IsInShellLevel(CurrLevelName)) && MenuIndex == (MenuIndexByName("btnGameDifficulty"))) || int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        return;
    }
    CurrDifficulty = myPC.ProfileSettings.GetGameDifficulty();
    // End:0x179
    if(MenuIndex == (MenuIndexByName("btnGameDifficulty")))
    {
        // End:0x105
        if(bRight)
        {
            switch(CurrDifficulty)
            {
                // End:0xE2
                case 0:
                    CurrDifficulty = 2;
                    // End:0x102
                    break;
                // End:0xF0
                case 1:
                    CurrDifficulty = 0;
                    // End:0x102
                    break;
                // End:0xFF
                case 2:
                    CurrDifficulty = 1;
                    // End:0x102
                    break;
                // End:0xFFFF
                default:
                    break;
            }            
        }
        else
        {
            switch(CurrDifficulty)
            {
                // End:0x11B
                case 0:
                    CurrDifficulty = 1;
                    // End:0x13C
                    break;
                // End:0x12A
                case 1:
                    CurrDifficulty = 2;
                    // End:0x13C
                    break;
                // End:0x139
                case 2:
                    CurrDifficulty = 0;
                    // End:0x13C
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        myPC.ProfileSettings.SetGameDifficulty(CurrDifficulty);
        DifficultyUIObject.SetValue(GetDifficultyString());
    }
    //return;    
}

function OnSliderChangeByMousePress(int MenuIndex, const out InputEventParameters EventParms)
{
    local bool brightOfCenter;

    // End:0x56
    if(((myGameInfo != none) && !myGameInfo.IsInShellLevel(CurrLevelName)) && MenuIndex == (MenuIndexByName("btnGameDifficulty")))
    {
        return;
    }
    // End:0xB0
    if(MenuIndex == (MenuIndexByName("btnGameDifficulty")))
    {
        brightOfCenter = IsMouseRightOfLabelCenter(DifficultyUIObject, EventParms);
        OnLeftRight(MenuIndex, brightOfCenter);        
    }
    else
    {
        super.OnSliderChangeByMousePress(MenuIndex, EventParms);
    }
    //return;    
}

event InitScene()
{
    local int I, Idx;

    super.InitScene();
    DifficultyUIObject = UILabel(FindChild('lblDifficultyText', true));
    DifficultyUIObject.SetDataStoreBinding(GetDifficultyString());
    // End:0xBC
    if(((myGameInfo != none) && !myGameInfo.IsInShellLevel(CurrLevelName)) || int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        DifficultyUIObject.StringRenderComponent.SetColor(MakeLinearColor(0.2000000, 0.2000000, 0.2000000, 1.0000000));
    }
    // End:0x1FA
    if((Class'Engine.WorldInfo'.static.IsConsoleBuild(2) || int(GetWorldInfo().NetMode) != int(NM_Standalone)) || Class'Engine.WorldInfo'.static.IsConsoleBuild(NM_DedicatedServer) && Class'Engine.Engine'.static.IsSPDemoBuild())
    {
        Idx = MenuIndexByName("btnDeviceSelect");
        // End:0x1FA
        if(Idx != -1)
        {
            MenuItems[Idx].ButtonObj.SetVisibility(false);
            MenuItems[Idx].bDisabled = true;
            I = MenuItems.Length - 2;
            J0x19D:

            // End:0x1FA [Loop If]
            if(I > Idx)
            {
                MenuItems[I].MenuItemUIObject.Position = MenuItems[I - 1].MenuItemUIObject.Position;
                I--;
                // [Loop Continue]
                goto J0x19D;
            }
        }
    }
    MenuItems[MenuIndexByName("btnCheatMenu")].ButtonObj.SetVisibility(false);
    MenuItems[MenuIndexByName("btnCheatMenu")].bDisabled = true;
    HideBGImageIfMP();
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    local OnlineSubsystem.ELoginStatus Status;

    super.OnClick(OpenedScene, MenuIndex);
    Status = GetLoginStatus(LocPlayer.ControllerId);
    // End:0xB2
    if(MenuIndex == (MenuIndexByName("btnCheatMenu")))
    {
        PlayUISound('SceneOpened');
        // End:0xB2
        if((LocPlayer != none) && LocPlayer.Actor != none)
        {            
            LocPlayer.Actor.ConsoleCommand("QuickMenu");
        }
    }
    switch(Status)
    {
        // End:0xBF
        case 1:
        // End:0x11C
        case 2:
            // End:0x119
            if((MenuIndex == (MenuIndexByName("btnDeviceSelect"))) && myPC != none)
            {
                myPC.SelectDevice(DatafileSize, NotifyDeviceSelectComplete);
            }
            // End:0x181
            break;
        // End:0xFFFF
        default:
            // End:0x17E
            if((MenuIndex == (MenuIndexByName("btnDeviceSelect"))) || MenuIndex == (MenuIndexByName("btnReset")))
            {
                ShowMsgBox(NeedProfile_Message, NeedProfile_Title, 0);
            }
            // End:0x181
            break;
            break;
    }
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

function OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
    // End:0x43
    if(bWasSuccessful)
    {
        // End:0x1E
        if(myPC != none)
        {
            ResetProfileSettings();
        }
        // End:0x43
        if(DifficultyUIObject != none)
        {
            DifficultyUIObject.SetValue(GetDifficultyString());
        }
    }
    //return;    
}

function OnSetDefaultsMsgResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    //return;    
}
