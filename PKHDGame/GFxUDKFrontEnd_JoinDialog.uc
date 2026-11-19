class GFxUDKFrontEnd_JoinDialog extends GFxUDKFrontEnd_Dialog within GFxMoviePlayer;

var GFxClikWidget ServerInfoListMC;
var GFxClikWidget MutatorListMC;
var GFxClikWidget JoinBtn;
var GFxClikWidget SpectateBtn;

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    // End:0x3C
    if(MenuManager != none)
    {
        MenuManager.SetSelectionFocus(JoinBtn);
    }
    BackBtn.SetString("label", "BACK");
    BackBtn.RemoveAllEventListeners("CLIK_press");
    BackBtn.RemoveAllEventListeners("press");
    BackBtn.AddEventListener('CLIK_press', Select_Back);
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    AcceptBtn.SetBool("disabled", bDisableComponents);
    BackBtn.SetBool("disabled", bDisableComponents);
    //return;    
}

function PopulateServerInfo(OnlineGameSettings GameSettings)
{
    local byte I, DPArrayIndex;
    local int CurrentPlayers, MaxPlayers;
    local string PlayersString;
    local GFxObject DataProvider, TempObj;
    local array<ASValue> args;
    local ASValue asval;
    local UTGameSettingsCommon UTGameSettings;
    local int Index, SettingId, PropertyId;
    local string SettingValue, SettingName, PropertyValue, PropertyName;

    DPArrayIndex = 0;
    TitleTxt.SetText(GameSettings.OwningPlayerName);
    UTGameSettings = UTGameSettingsCommon(GameSettings);
    DataProvider = Outer.CreateArray();
    TempObj = Outer.CreateObject("Object");
    TempObj.SetString("label", "PLAYERS");
    CurrentPlayers = GameSettings.NumPublicConnections - GameSettings.NumOpenPublicConnections;
    MaxPlayers = GameSettings.NumPublicConnections;
    PlayersString = (string(CurrentPlayers) $ "/") $ string(MaxPlayers);
    TempObj.SetString("value", PlayersString);
    DataProvider.SetElementObject(int(DPArrayIndex++), TempObj);
    TempObj = Outer.CreateObject("Object");
    TempObj.SetString("label", "PING");
    TempObj.SetString("value", string(GameSettings.PingInMs));
    DataProvider.SetElementObject(int(DPArrayIndex++), TempObj);
    TempObj = Outer.CreateObject("Object");
    TempObj.SetString("label", "MATCH QUALITY");
    TempObj.SetString("value", string(GameSettings.MatchQuality));
    DataProvider.SetElementObject(int(DPArrayIndex++), TempObj);
    I = 0;
    J0x3BB:

    // End:0x5EB [Loop If]
    if(int(I) < UTGameSettings.PropertyMappings.Length)
    {
        PropertyId = UTGameSettings.Properties[int(I)].PropertyId;
        // End:0x5DD
        if(((PropertyId == 268435704) || PropertyId == 268435705) || PropertyId == 268435703)
        {
            TempObj = Outer.CreateObject("Object");
            PropertyName = Caps(string(UTGameSettings.PropertyMappings[int(I)].Name));
            PropertyValue = string(UTGameSettings.Properties[int(I)].Data.Value1);
            TempObj.SetString("label", PropertyName);
            TempObj.SetString("value", PropertyValue);
            DataProvider.SetElementObject(int(DPArrayIndex++), TempObj);
        }
        I++;
        // [Loop Continue]
        goto J0x3BB;
    }
    I = 0;
    J0x5F7:

    // End:0x87F [Loop If]
    if(int(I) < UTGameSettings.LocalizedSettings.Length)
    {
        SettingId = UTGameSettings.LocalizedSettings[int(I)].Id;
        // End:0x871
        if((((SettingId != 0) && SettingId != 0) && SettingId != 12) && SettingId != 13)
        {
            TempObj = Outer.CreateObject("Object");
            Index = UTGameSettings.LocalizedSettings[int(I)].ValueIndex;
            SettingName = Caps(string(UTGameSettings.LocalizedSettingsMappings[int(I)].Name));
            SettingValue = string(UTGameSettings.LocalizedSettingsMappings[int(I)].ValueMappings[Index].Name);
            TempObj.SetString("label", SettingName);
            TempObj.SetString("value", SettingValue);
            DataProvider.SetElementObject(int(DPArrayIndex++), TempObj);
        }
        I++;
        // [Loop Continue]
        goto J0x5F7;
    }
    ServerInfoListMC.SetObject("dataProvider", DataProvider);
    asval.Type = 4;
    asval.S = "";
    args[0] = asval;    
    ServerInfoListMC.Invoke("validateNow", args);
    //return;    
}

function SetJoinButtonPress(delegate<EventListener> JoinButtonListener)
{
    JoinBtn.RemoveAllEventListeners("CLIK_press");
    JoinBtn.RemoveAllEventListeners("press");
    JoinBtn.AddEventListener('CLIK_press', JoinButtonListener);
    //return;    
}

function SetSpectateButtonPress(delegate<EventListener> SpectateButtonListener)
{
    SpectateBtn.RemoveAllEventListeners("CLIK_press");
    SpectateBtn.RemoveAllEventListeners("press");
    SpectateBtn.AddEventListener('CLIK_press', SpectateButtonListener);
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;

    bWasHandled = false;
    bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    // End:0x4B
    if(bWasHandled)
    {
        return true;
    }
    switch(WidgetName)
    {
        // End:0x9C
        case 'serverinfo_label':
            Widget.SetText("SERVER INFO");
            return true;
            // End:0x25A
            break;
        // End:0xD8
        case 'serverinfo_list':
            // End:0xD5
            if(ServerInfoListMC == none)
            {
                ServerInfoListMC = GFxClikWidget(Widget);
                return true;
            }
            // End:0x25A
            break;
        // End:0x113
        case 'mutatorinfo_label':
            Widget.SetText("MUTATORS");
            return true;
            // End:0x25A
            break;
        // End:0x14F
        case 'mutatorinfo_list':
            // End:0x14C
            if(MutatorListMC == none)
            {
                MutatorListMC = GFxClikWidget(Widget);
                return true;
            }
            // End:0x25A
            break;
        // End:0x1D2
        case 'join':
            JoinBtn = GFxClikWidget(Widget.GetObject("btn", Class'GFxUI.GFxClikWidget'));
            JoinBtn.SetString("label", "JOIN GAME");
            return true;
            // End:0x25A
            break;
        // End:0x254
        case 'spectate':
            SpectateBtn = GFxClikWidget(Widget.GetObject("btn", Class'GFxUI.GFxClikWidget'));
            SpectateBtn.SetString("label", "SPECTATE");
            return true;
            // End:0x25A
            break;
        // End:0xFFFF
        default:
            // End:0x25A
            break;
            break;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    SubWidgetBindings=/* Array type was not detected. */
}