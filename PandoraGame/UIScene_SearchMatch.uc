class UIScene_SearchMatch extends UIScene_BaseFrontEnd;

const PROP_NonStandardOptions = 0x10000006;
const PROP_DedicatedServer = 0x10000009;
const PROP_CustomMapName = 0x10000011;
const PROP_GameStatus = 0x10000012;
const PROP_LONGBOWACCURACYRATING = 0x30000003;
const GAME_STATUS_LOBBY = 0;
const GAME_STATUS_INPROGRESS = 1;
const GAME_STATUS_POSTGAME = 2;
const GAME_MODE = 0x0000800B;
const GAME_MODE_DM = 0;
const GAME_MODE_TDM = 1;
const CONTEXT_MAPNAME = 0;
const CONTEXT_NUMCREATURES = 1;
const CONTEXT_MATCHDURATION = 2;
const CONTEXT_ANIMUSLIMIT = 3;
const CONTEXT_FULLSERVER = 4;
const CONTEXT_FULLSERVER_NOTFULLSERVER = 0;
const CONTEXT_FULLSERVER_FULLSERVER = 1;
const CONTEXT_MAPNAME_MAP_ANY = 0;
const CONTEXT_MAPNAME_MP_DUR_WW = 1;
const CONTEXT_MAPNAME_WW_TESTMAP = 2;
const CONTEXT_MAPNAME_SUR_RABOUT_MTR = 3;
const CONTEXT_MAPNAME_WEREHOUSE_MTR = 4;
const CONTEXT_MAPNAME_THEKEEP_MTR = 5;
const CONTEXT_MAPNAME_DEN_MTR_MP = 6;
const CONTEXT_MAPNAME_NYSTREET_MTR_MP = 7;
const CONTEXT_MAPNAME_JOHNSPLAYGROUND = 8;
const CONTEXT_MAPNAME_DOUGLAND = 9;
const CONTEXT_NUMCREATURES_ANY = 0;
const CONTEXT_NUMCREATURES_NONE = 1;
const CONTEXT_NUMCREATURES_LOW = 2;
const CONTEXT_NUMCREATURES_MEDIUM = 3;
const CONTEXT_NUMCREATURES_HIGH = 4;
const CONTEXT_MATCHDURATION_ANY = 0;
const CONTEXT_MATCHDURATION_5MIN = 1;
const CONTEXT_MATCHDURATION_10MIN = 2;
const CONTEXT_MATCHDURATION_15MIN = 3;
const CONTEXT_MATCHDURATION_30MIN = 4;
const CONTEXT_MATCHDURATION_1HR = 5;
const CONTEXT_ANIMUSLIMIT_ANYPTS = 0;
const CONTEXT_ANIMUSLIMIT_100PTS = 1;
const CONTEXT_ANIMUSLIMIT_250PTS = 2;
const CONTEXT_ANIMUSLIMIT_500PTS = 3;
const CONTEXT_ANIMUSLIMIT_750PTS = 4;
const CONTEXT_ANIMUSLIMIT_1000PTS = 5;
const CONTEXT_PRESENCE_LEGENDARYMAIN = 0;
const CONTEXT_PRESENCE_LEGENDARYSP = 1;
const CONTEXT_PRESENCE_LEGENDARYMP = 2;
const CONTEXT_PRESENCE_INACTIVEPROFILE = 3;
const QUERY_DMSearch = 1;
const QUERY_PandoraCustomSearch = 2;
const ACHIEVEMENT_ACHIEVEMENT12 = 1;
const ACHIEVEMENT_ACHIEVEMENT13 = 2;
const ACHIEVEMENT_ACHIEVEMENT14 = 3;
const ACHIEVEMENT_ACHIEVEMENT15 = 4;
const ACHIEVEMENT_ACHIEVEMENT01 = 5;
const ACHIEVEMENT_ACHIEVEMENT16 = 6;
const ACHIEVEMENT_ACHIEVEMENT17 = 7;
const ACHIEVEMENT_ACHIEVEMENT02 = 8;
const ACHIEVEMENT_ACHIEVEMENT18 = 9;
const ACHIEVEMENT_ACHIEVEMENT19 = 10;
const ACHIEVEMENT_ACHIEVEMENT20 = 11;
const ACHIEVEMENT_ACHIEVEMENT21 = 12;
const ACHIEVEMENT_ACHIEVEMENT03 = 13;
const ACHIEVEMENT_ACHIEVEMENT22 = 14;
const ACHIEVEMENT_ACHIEVEMENT23 = 15;
const ACHIEVEMENT_ACHIEVEMENT24 = 16;
const ACHIEVEMENT_ACHIEVEMENT04 = 17;
const ACHIEVEMENT_ACHIEVEMENT25 = 18;
const ACHIEVEMENT_ACHIEVEMENT26 = 19;
const ACHIEVEMENT_ACHIEVEMENT27 = 20;
const ACHIEVEMENT_ACHIEVEMENT05 = 21;
const ACHIEVEMENT_ACHIEVEMENT28 = 22;
const ACHIEVEMENT_ACHIEVEMENT30 = 23;
const ACHIEVEMENT_ACHIEVEMENT06 = 24;
const ACHIEVEMENT_ACHIEVEMENT31 = 25;
const ACHIEVEMENT_ACHIEVEMENT32 = 26;
const ACHIEVEMENT_ACHIEVEMENT07 = 27;
const ACHIEVEMENT_ACHIEVEMENT33 = 28;
const ACHIEVEMENT_ACHIEVEMENT29 = 29;
const ACHIEVEMENT_ACHIEVEMENT34 = 30;
const ACHIEVEMENT_ACHIEVEMENT08 = 31;
const ACHIEVEMENT_ACHIEVEMENT09 = 32;
const ACHIEVEMENT_ACHIEVEMENT10 = 33;
const ACHIEVEMENT_ACHIEVEMENT11 = 34;
const ACHIEVEMENT_ACHIEVEMENT35 = 35;
const ACHIEVEMENT_ACHIEVEMENT36 = 36;
const ACHIEVEMENT_ACHIEVEMENT37 = 37;
const ACHIEVEMENT_ACHIEVEMENT38 = 38;
const ACHIEVEMENT_ACHIEVEMENT39 = 39;
const ACHIEVEMENT_ACHIEVEMENT40 = 40;
const ACHIEVEMENT_ACHIEVEMENT41 = 41;
const ACHIEVEMENT_ACHIEVEMENT42 = 42;
const ACHIEVEMENT_ACHIEVEMENT43 = 43;
const ACHIEVEMENT_ACHIEVEMENT45 = 44;
const ACHIEVEMENT_ACHIEVEMENT46 = 45;
const ACHIEVEMENT_ACHIEVEMENT44 = 46;
const ACHIEVEMENT_ACHIEVEMENT47 = 47;
const ACHIEVEMENT_ACHIEVEMENT48 = 48;
const ACHIEVEMENT_ACHIEVEMENT49 = 49;
const ACHIEVEMENT_ACHIEVEMENT50 = 50;

struct MenuSubOption
{
    var string DisplayName;
    var int ContextID;

    structdefaultproperties
    {
        DisplayName=""
        ContextID=0
    }
};

struct MenuSubOptionList
{
    var int CurOption;
    var string ListDisplayName;
    var string ItemName;
    var int ContextID;
    var bool bUsesContext;
    var array<MenuSubOption> SubOptions;

    structdefaultproperties
    {
        CurOption=0
        ListDisplayName=""
        ItemName=""
        ContextID=0
        bUsesContext=true
        SubOptions=none
    }
};

var array<MenuSubOptionList> OptionLists;
var UIScene_PandoraJoinMatch JoinMatchUI;
var bool bMapListUpdated;
var UIDataStore_GameResource GameResourceDataStore;
var int NumberOfMaps;

function LoadChildScenes()
{
    // End:0x3F
    if(JoinMatchUI == none)
    {
        JoinMatchUI = UIScene_PandoraJoinMatch(DynamicLoadObject("PandoraShell.JoinMatch_Menu", Class'UIScene_PandoraJoinMatch'));
    }
    // End:0x4A
    if(JoinMatchUI == none)
    {
    }
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    // End:0x61
    if(MenuIndex == (MenuIndexByName("btnSearch")))
    {
        PlayUISound('Clicked');
        JoinMatchUI.bUseCustomSearch = true;
        JoinMatchUI.SearchMatch = self;
        OpenSubScene(JoinMatchUI);
    }
    //return;    
}

function string GetOptionString(int Idx)
{
    return OptionLists[Idx].ListDisplayName @ OptionLists[Idx].SubOptions[OptionLists[Idx].CurOption].DisplayName;
    //return ReturnValue;    
}

function UpdateOptionListDisplay()
{
    local int I;

    // End:0x13
    if(MenuItems.Length < OptionLists.Length)
    {
        return;
    }
    I = 0;
    J0x1A:

    // End:0x99 [Loop If]
    if(I < MenuItems.Length)
    {
        // End:0x8F
        if(MenuItems[I].nOptionIndex != -1)
        {
            MenuItems[I].ButtonObj.SetCaption(GetOptionString(MenuItems[I].nOptionIndex));
        }
        I++;
        // [Loop Continue]
        goto J0x1A;
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x8A
    if(IsPCBuild() && bDisplayCursor)
    {
        // End:0x8A
        if(((EventParms.InputKeyName == 'LeftMouseButton') && int(EventParms.EventType) == int(1)) && MouseIsOverMenuButton())
        {
            // End:0x8A
            if(CurrMenuItemIdx > 0)
            {
                OnLeftRight(CurrMenuItemIdx, true);
                return true;
            }
        }
    }
    return super.CustomInputKey(EventParms);
    //return ReturnValue;    
}

function OnLeftRight(int MenuIndex, bool bRight)
{
    // End:0x13
    if(MenuItems.Length < OptionLists.Length)
    {
        return;
    }
    // End:0x35
    if(MenuItems[MenuIndex].nOptionIndex == -1)
    {
        return;
    }
    // End:0xF7
    if(bRight)
    {
        PlayUISound('NavigateRight');
        OptionLists[MenuItems[MenuIndex].nOptionIndex].CurOption++;
        // End:0xF4
        if(OptionLists[MenuItems[MenuIndex].nOptionIndex].CurOption >= OptionLists[MenuItems[MenuIndex].nOptionIndex].SubOptions.Length)
        {
            OptionLists[MenuItems[MenuIndex].nOptionIndex].CurOption = 0;
        }        
    }
    else
    {
        PlayUISound('NavigateLeft');
        OptionLists[MenuItems[MenuIndex].nOptionIndex].CurOption--;
        // End:0x1B0
        if(OptionLists[MenuItems[MenuIndex].nOptionIndex].CurOption < 0)
        {
            OptionLists[MenuItems[MenuIndex].nOptionIndex].CurOption = OptionLists[MenuItems[MenuIndex].nOptionIndex].SubOptions.Length - 1;
        }
    }
    MenuItems[MenuIndex].ButtonObj.SetCaption(GetOptionString(MenuItems[MenuIndex].nOptionIndex));
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    local int I;
    local UILabel lblTitle;

    super.SceneActivated(bInitialActivation);
    I = 0;
    J0x13:

    // End:0x64 [Loop If]
    if(I < OptionLists.Length)
    {
        MenuItems[MenuIndexByName(OptionLists[I].ItemName)].nOptionIndex = I;
        I++;
        // [Loop Continue]
        goto J0x13;
    }
    lblTitle = UILabel(FindChild('lblTitle', true));
    lblTitle.SetValue(PlatformStrings $ "UIScene_SearchMatch_Menu.MatchmakingSearch>");
    GameResourceDataStore = UIDataStore_GameResource(GetCurrentUIController().DataStoreManager.FindDataStore('GameResources'));
    NumberOfMaps = GameResourceDataStore.GetProviderCount('MultiplayerMaps');
    LoadChildScenes();
    PopulateMapSubOptions();
    UpdateOptionListDisplay();
    //return;    
}

function AssignGameSearch(PandoraDMOnlineGameSearch SearchObj)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x9E [Loop If]
    if(I < OptionLists.Length)
    {
        // End:0x94
        if(OptionLists[I].bUsesContext)
        {
            SearchObj.SetStringSettingValue(OptionLists[I].ContextID, OptionLists[I].SubOptions[OptionLists[I].CurOption].ContextID, false);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function int GetOptionValueContext(int OptionContext)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x7A [Loop If]
    if(I < OptionLists.Length)
    {
        // End:0x70
        if(OptionLists[I].ContextID == OptionContext)
        {
            return OptionLists[I].SubOptions[OptionLists[I].CurOption].ContextID;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return ReturnValue;    
}

function int GetOptionValueIndexFromContext(int OptionContext)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x58 [Loop If]
    if(I < OptionLists.Length)
    {
        // End:0x4E
        if(OptionLists[I].ContextID == OptionContext)
        {
            return OptionLists[I].CurOption;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return ReturnValue;    
}

function int GetOptionValueContextFromContext(int OptionContext)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x7A [Loop If]
    if(I < OptionLists.Length)
    {
        // End:0x70
        if(OptionLists[I].ContextID == OptionContext)
        {
            return OptionLists[I].SubOptions[OptionLists[I].CurOption].ContextID;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return ReturnValue;    
}

function AssignSearchCriteria(PandoraDMSearch_DataStore SearchDataStore)
{
    local int MapID, CreatureDensity, AnimusLimit;

    MapID = GetOptionValueContextFromContext(0);
    AnimusLimit = GetOptionValueContextFromContext(3);
    CreatureDensity = GetOptionValueContextFromContext(1);
    SearchDataStore.SetSearchCriteria(MapID, CreatureDensity, AnimusLimit);
    //return;    
}

function PopulateMapSubOptions()
{
    local PandoraGRI PGRI;
    local int I, NewOptionID, MapContext;
    local UIProviderScriptFieldValue FriendlyMapNameValue, DebugMapValue;

    // End:0x0B
    if(bMapListUpdated)
    {
        return;
    }
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x18B
    if(PGRI != none)
    {
        MapContext = 1;
        I = 0;
        J0x43:

        // End:0x180 [Loop If]
        if(I < NumberOfMaps)
        {
            GameResourceDataStore.GetProviderFieldValue('MultiplayerMaps', 'bDebugMap', I, DebugMapValue);
            // End:0xB4
            if(!PGRI.bAllowDebugMaps && bool(DebugMapValue.StringValue))
            {
                MapContext++;
                // [Explicit Continue]
                goto J0x176;
            }
            GameResourceDataStore.GetProviderFieldValue('MultiplayerMaps', 'FriendlyMapName', I, FriendlyMapNameValue);
            NewOptionID = OptionLists[0].SubOptions.Length;
            OptionLists[0].SubOptions.Insert(NewOptionID, 1);
            OptionLists[0].SubOptions[NewOptionID].DisplayName = FriendlyMapNameValue.StringValue;
            OptionLists[0].SubOptions[NewOptionID].ContextID = MapContext;
            MapContext++;
            J0x176:

            I++;
            // [Loop Continue]
            goto J0x43;
        }
        bMapListUpdated = true;        
    }
    else
    {
        bMapListUpdated = false;
    }
    //return;    
}
