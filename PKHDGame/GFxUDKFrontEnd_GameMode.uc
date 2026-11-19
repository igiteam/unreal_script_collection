class GFxUDKFrontEnd_GameMode extends GFxUDKFrontEnd_Screen within GFxMoviePlayer
    config(UI);

var transient UIDataStore_OnlineGameSettings SettingsDataStore;
var transient UTUIDataStore_StringList StringListDataStore;
var transient string GameMode;
var transient string MapName;
var GFxClikWidget ListMC;
var GFxObject ListDataProvider;
var GFxObject MenuMC;
var GFxClikWidget ImgScrollerMC;
var array<UTUIDataProvider_GameModeInfo> GameModeList;

function OnViewLoaded()
{
    local byte I;
    local DataStoreClient DSClient;
    local array<UDKUIResourceDataProvider> ProviderList;

    super(GFxUDKFrontEnd_View).OnViewLoaded();
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    SettingsDataStore = UIDataStore_OnlineGameSettings(DSClient.FindDataStore('UTGameSettings'));
    StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
    Class'UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'UTUIDataProvider_GameModeInfo', ProviderList);
    I = 0;
    J0xE8:

    // End:0x13C [Loop If]
    if(int(I) < ProviderList.Length)
    {
        GameModeList.InsertItem(0, UTUIDataProvider_GameModeInfo(ProviderList[int(I)]));
        I++;
        // [Loop Continue]
        goto J0xE8;
    }
    //return;    
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    super(GFxUDKFrontEnd_View).OnTopMostView(bPlayOpenAnimation);
    MenuManager.SetSelectionFocus(ListMC);
    UpdateDescription();
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    ListMC.SetBool("disabled", bDisableComponents);
    BackBtn.SetBool("disabled", bDisableComponents);
    //return;    
}

final function OnGameModeSelected(string InGameMode, string InDefaultMap, optional string InGameSettingsClass = "")
{
    local string MapImageMarkup;
    local UIDataStore_Registry Registry;

    GameMode = InGameMode;
    MapName = InDefaultMap;
    SettingsDataStore.SetCurrentByName(name(InGameSettingsClass));
    MapImageMarkup = Class'GFxUDKFrontEnd_MapSelect'.static.GetImageMarkupByMapName(InDefaultMap);
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("SelectedGameMode", InGameMode);
    Registry.SetData("SelectedMap", InDefaultMap);
    Registry.SetData("SelectedMapImage", MapImageMarkup);
    Class'GFxUDKFrontEnd_Mutators'.static.ApplyGameModeFilter();
    //return;    
}

final function OnGameModeChange(int SelectedIndex)
{
    local string LocalGameMode, DefaultMap, Prefixes, GameSettingsClass;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    LocalGameMode = GameModeList[SelectedIndex].GameMode;
    DefaultMap = GameModeList[SelectedIndex].DefaultMap;
    Prefixes = GameModeList[SelectedIndex].Prefixes;
    GameSettingsClass = GameModeList[SelectedIndex].GameSettingsClass;
    Registry.SetData("SelectedGameModePrefix", Prefixes);
    OnGameModeSelected(LocalGameMode, DefaultMap, GameSettingsClass);
    //return;    
}

function OnListItemPress(EventData ev)
{
    local int SelectedIndex;

    SelectedIndex = ev.Index;
    OnGameModeChange(SelectedIndex);
    MenuManager.PopView();
    //return;    
}

function OnListChange(EventData ev)
{
    UpdateDescription();
    //return;    
}

function UpdateDescription()
{
    local int SelectedIndex;
    local string Description;

    SelectedIndex = int(ListMC.GetFloat("selectedIndex"));
    Description = "";
    // End:0xA1
    if((SelectedIndex >= 0) && SelectedIndex < GameModeList.Length)
    {
        Description = GameModeList[SelectedIndex].Description;
    }
    InfoTxt.SetText(Description);
    //return;    
}

function UpdateListDataProvider()
{
    local byte I;
    local GFxObject DataProvider, TempObj;
    local string FriendlyGameModeName;

    DataProvider = Outer.CreateArray();
    I = 0;
    J0x35:

    // End:0x1CE [Loop If]
    if(int(I) < GameModeList.Length)
    {
        TempObj = Outer.CreateObject("Object");
        FriendlyGameModeName = Class'GFxUDKFrontEnd_LaunchGame'.static.GetGameModeFriendlyString(GameModeList[int(I)].GameMode);
        TempObj.SetString("label", Caps(FriendlyGameModeName));
        TempObj.SetString("image", "img://" $ GameModeList[int(I)].PreviewImageMarkup);
        TempObj.SetString("players", "");
        DataProvider.SetElementObject(int(I), TempObj);
        I++;
        // [Loop Continue]
        goto J0x35;
    }
    ListMC.SetObject("dataProvider", DataProvider);
    ListDataProvider = ListMC.GetObject("dataProvider");
    ListMC.SetFloat("selectedIndex", 0.0000000);
    ListMC.AddEventListener('CLIK_itemPress', OnListItemPress);
    ListMC.AddEventListener('CLIK_change', OnListChange);
    ImgScrollerMC.SetObject("dataProvider", DataProvider);
    ImgScrollerMC.SetFloat("selectedIndex", 0.0000000);
    //return;    
}

final function SetImgScroller(GFxClikWidget InImgScroller)
{
    ActionScriptVoid("setImgScroller");
    //return;    
}

function ASSetList(GFxObject List)
{
    ActionScriptVoid("setList");
    //return;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    switch(WidgetName)
    {
        // End:0xE0
        case 'List':
            // End:0xDD
            if(ListMC == none)
            {
                ListMC = GFxClikWidget(Widget);
                ASSetList(ListMC);
                UpdateListDataProvider();
                ListMC.AddEventListener('CLIK_focusIn', OnListChange);
                SetImgScroller(ImgScrollerMC);
                return true;
            }
            // End:0x137
            break;
        // End:0x104
        case 'menu':
            MenuMC = Widget;
            return true;
            // End:0x137
            break;
        // End:0x131
        case 'imgScroller':
            ImgScrollerMC = GFxClikWidget(Widget);
            return true;
            // End:0x137
            break;
        // End:0xFFFF
        default:
            // End:0x137
            break;
            break;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    CancelButtonHelpText="CANCEL"
    SubWidgetBindings=/* Array type was not detected. */
}