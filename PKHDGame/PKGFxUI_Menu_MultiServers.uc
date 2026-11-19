class PKGFxUI_Menu_MultiServers extends PKGFxUI_Menu_Base
    config(UI);

const GS_USERNAME_MAXLENGTH = 15;
const GS_PASSWORD_MAXLENGTH = 30;
const GS_MESSAGE_MAXLENGTH = 255;
const GS_EMAIL_MAXLENGTH = 50;
const GS_CDKEY_PART_MAXLENGTH = 4;
const CONTEXT_PRESENCE_IDLE = 0;
const CONTEXT_PRESENCE_PARTY_PUBLIC_SEARCH = 1;
const CONTEXT_PRESENCE_PARTY_PUBLIC_WAIT = 2;
const CONTEXT_PRESENCE_PARTY_PRIVATE = 3;
const CONTEXT_PRESENCE_MENU = 4;
const CONTEXT_PRESENCE_SINGLE = 5;
const CONTEXT_PRESENCE_COOP = 6;
const CONTEXT_PRESENCE_COOP_PRIVATE = 7;
const CONTEXT_PRESENCE_MULTI = 8;
const CONTEXT_GAME_MODE = 0x0000800B;
const CONTEXT_GAME_MODE_DM = 0;
const CONTEXT_GAME_MODE_CAPTURETHEFLAG = 1;
const CONTEXT_GAME_MODE_WAR = 2;
const CONTEXT_GAME_MODE_VCTF = 3;
const CONTEXT_GAME_MODE_TDM = 4;
const CONTEXT_GAME_MODE_SURVIVAL = 5;
const CONTEXT_GAME_MODE_CUSTOM = 6;
const CONTEXT_GAME_MODE_CAMPAIGN = 7;
const CONTEXT_GAME_MODE_SV = 8;
const CONTEXT_GAME_MODE_PARTY = 9;
const CONTEXT_GAME_MODE_COOP = 10;
const CONTEXT_BOTSKILL = 0;
const CONTEXT_MAPNAME = 1;
const CONTEXT_PURESERVER = 6;
const CONTEXT_LOCKEDSERVER = 7;
const CONTEXT_VSBOTS = 8;
const CONTEXT_CAMPAIGN = 9;
const CONTEXT_FORCERESPAWN = 10;
const CONTEXT_ALLOWKEYBOARD = 11;
const CONTEXT_FULLSERVER = 12;
const CONTEXT_EMPTYSERVER = 13;
const CONTEXT_DEDICATEDSERVER = 14;
const CONTEXT_MAPNAME_CUSTOM = 0;
const CONTEXT_BOTSKILL_NOVICE = 0;
const CONTEXT_BOTSKILL_AVERAGE = 1;
const CONTEXT_BOTSKILL_EXPERIENCED = 2;
const CONTEXT_BOTSKILL_SKILLED = 3;
const CONTEXT_BOTSKILL_ADEPT = 4;
const CONTEXT_BOTSKILL_MASTERFUL = 5;
const CONTEXT_BOTSKILL_INHUMAN = 6;
const CONTEXT_BOTSKILL_GODLIKE = 7;
const CONTEXT_GOALSCORE_5 = 0;
const CONTEXT_GOALSCORE_10 = 1;
const CONTEXT_GOALSCORE_15 = 2;
const CONTEXT_GOALSCORE_20 = 3;
const CONTEXT_GOALSCORE_30 = 4;
const CONTEXT_NUMBOTS = 0;
const CONTEXT_NUMBOTS_1 = 1;
const CONTEXT_NUMBOTS_2 = 2;
const CONTEXT_NUMBOTS_3 = 3;
const CONTEXT_NUMBOTS_4 = 4;
const CONTEXT_NUMBOTS_5 = 5;
const CONTEXT_NUMBOTS_6 = 6;
const CONTEXT_NUMBOTS_7 = 7;
const CONTEXT_NUMBOTS_8 = 8;
const CONTEXT_TIMELIMIT_5 = 0;
const CONTEXT_TIMELIMIT_10 = 1;
const CONTEXT_TIMELIMIT_15 = 2;
const CONTEXT_TIMELIMIT_20 = 3;
const CONTEXT_TIMELIMIT_30 = 4;
const CONTEXT_PURESERVER_NO = 0;
const CONTEXT_PURESERVER_YES = 1;
const CONTEXT_PURESERVER_ANY = 2;
const CONTEXT_LOCKEDSERVER_NO = 0;
const CONTEXT_LOCKEDSERVER_YES = 1;
const CONTEXT_CAMPAIGN_NO = 0;
const CONTEXT_CAMPAIGN_YES = 1;
const CONTEXT_FORCERESPAWN_NO = 0;
const CONTEXT_FORCERESPAWN_YES = 1;
const CONTEXT_ALLOWKEYBOARD_NO = 0;
const CONTEXT_ALLOWKEYBOARD_YES = 1;
const CONTEXT_ALLOWKEYBOARD_ANY = 2;
const CONTEXT_FULLSERVER_NO = 0;
const CONTEXT_FULLSERVER_YES = 1;
const CONTEXT_EMPTYSERVER_NO = 0;
const CONTEXT_EMPTYSERVER_YES = 1;
const CONTEXT_DEDICATEDSERVER_NO = 0;
const CONTEXT_DEDICATEDSERVER_YES = 1;
const CONTEXT_VSBOTS_NONE = 0;
const CONTEXT_VSBOTS_1_TO_2 = 1;
const CONTEXT_VSBOTS_1_TO_1 = 2;
const CONTEXT_VSBOTS_3_TO_2 = 3;
const CONTEXT_VSBOTS_2_TO_1 = 4;
const CONTEXT_VSBOTS_3_TO_1 = 5;
const CONTEXT_VSBOTS_4_TO_1 = 6;
const PROPERTY_NUMBOTS = 0x100000F7;
const PROPERTY_GOALSCORE = 0x100000F8;
const PROPERTY_TIMELIMIT = 0x100000F9;
const PROPERTY_LEADERBOARDRATING = 0x20000004;
const PROPERTY_EPICMUTATORS = 0x10000105;
const PROPERTY_CUSTOMMAPNAME = 0x40000001;
const PROPERTY_CUSTOMGAMEMODE = 0x40000002;
const PROPERTY_SERVERDESCRIPTION = 0x40000003;
const PROPERTY_CUSTOMMUTATORS = 0x40000004;
const PROPERTY_SERVEROWNERID = 0x40000005;
const QUERY_DM = 0;
const QUERY_TDM = 1;
const QUERY_CTF = 2;
const QUERY_SV = 3;
const QUERY_WAR = 4;
const QUERY_DUEL = 5;
const QUERY_CAMPAIGN = 6;
const QUERY_VCTF = 7;
const STATS_VIEW_DM_PLAYER_ALLTIME = 1;
const STATS_VIEW_DM_RANKED_ALLTIME = 2;
const STATS_VIEW_DM_WEAPONS_ALLTIME = 3;
const STATS_VIEW_DM_VEHICLES_ALLTIME = 4;
const STATS_VIEW_DM_VEHICLEWEAPONS_ALLTIME = 5;
const STATS_VIEW_DM_VEHICLES_RANKED_ALLTIME = 6;
const STATS_VIEW_DM_VEHICLEWEAPONS_RANKED_ALLTIME = 7;
const STATS_VIEW_DM_WEAPONS_RANKED_ALLTIME = 8;
const SERVERBROWSER_SERVERTYPE_LAN = 0;
const SERVERBROWSER_SERVERTYPE_UNRANKED = 1;
const SERVERBROWSER_SERVERTYPE_RANKED = 2;
const SERVER_LIST_COUNT = 11;

enum EQueryCompletionAction
{
    QUERYACTION_None,               // 0
    QUERYACTION_Default,            // 1
    QUERYACTION_CloseScene,         // 2
    QUERYACTION_JoinServer,         // 3
    QUERYACTION_RefreshAll,         // 4
    QUERYACTION_MAX                 // 5
};

struct SteamServerData
{
    var string SteamServerId;
    var string Label;
    var string ServerName;
    var string Players;
    var string GameType;
    var string MapName;
    var string RawMapName;
    var string OwnerId;
    var int Ping;
    var bool bUsePassword;
    var OnlineGameSearchResult GameToJoin;

    structdefaultproperties
    {
        SteamServerId=""
        Label=""
        ServerName=""
        Players=""
        GameType=""
        MapName=""
        RawMapName=""
        OwnerId=""
        Ping=0
        bUsePassword=false
        GameToJoin=(GameSettings=none)
    }
};

struct ServerListItem
{
    var GFxObject ServerListRow;
    var GFxClikWidget ServerListBtn;
    var GFxObject ServerListLockMC;
    var GFxObject ServerListGametypeTF;
    var GFxObject ServerListMapTF;
    var GFxObject ServerListPlayersTF;
    var GFxObject ServerListPingTF;
    var int GameSearchIndex;

    structdefaultproperties
    {
        ServerListRow=none
        ServerListBtn=none
        ServerListLockMC=none
        ServerListGametypeTF=none
        ServerListMapTF=none
        ServerListPlayersTF=none
        ServerListPingTF=none
        GameSearchIndex=0
    }
};

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject ServersTF;
var GFxObject GameTypeTF;
var GFxClikWidget JoinBtn;
var GFxClikWidget RefreshBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget GameTypeDropdown;
var GFxObject GameTypeDataProvider;
var GFxClikWidget InternetLANCheckbox;
var bool bLANSelected;
var bool bSpectateSelected;
var bool bBackToCampaignMenu;
var bool bSearch1;
var bool bSearch2;
var bool bPingSort;
var bool bServerSort;
var bool bGameSort;
var bool bMapSort;
var bool bPlayersSort;
var bool bAutoShiftUp;
var bool bAutoShiftDown;
var GFxClikWidget SpectateCheckbox;
var GFxClikWidget PasswordInp;
var string Password;
var transient PKDataStore_GameSearch SearchDataStore;
var const transient name SearchDSName;
var transient array<OnlineGameSearchResult> ServerInfoList;
var transient UTUIDataStore_StringList StringListDataStore;
var transient OnlineSubsystem OnlineSub;
var transient OnlineGameInterface GameInterface;
var transient OnlineLobbyInterfaceSteamworks LobbyInterface;
var transient OnlineAuthInterface AuthInterface;
var transient int LastSelectedIndex;
var const localized string TitleString;
var const localized string GameTypeString;
var const localized string ServersString;
var const localized string JoinString;
var const localized string RefreshString;
var const localized string LanInternetString;
var const localized string SpectateString;
var const localized string AllGamesString;
var const localized string ServerNameTxt;
var const localized string PlayersTxt;
var const localized string MapNameTxt;
var const localized string GameTxt;
var const localized string PingTxt;
var int LatestSearchLenght;
var array<BasicLobbyInfo> Lobbies;
var string JoinSteamID;
var OnlineGameSearchResult GameToJoin;
var int ForceSelectedIndex;
var array<SteamServerData> SteamServerList;
var private transient PKGFxUI_Menu_MultiServers.EQueryCompletionAction QueryCompletionAction;
var GFxObject ServerListMC;
var GFxObject ServerNameHeaderTF;
var GFxObject GametypeHeaderTF;
var GFxObject MapHeaderTF;
var GFxObject PlayersHeaderTF;
var GFxObject PingHeaderTF;
var int CurrentRowShift;
var int LastSelectedSlot;
var float AutoShiftSlowDelay;
var float AutoShiftFastDelay;
var float AutoShiftSlowToFastDelay;
var transient float AutoShiftTimeElapsed;
var transient float AutoShiftLastTime;
var ServerListItem ServersList[11];
var int DLCIndex;
//var delegate<SortByServer> __SortByServer__Delegate;
//var delegate<SortByGame> __SortByGame__Delegate;
//var delegate<SortByMap> __SortByMap__Delegate;
//var delegate<SortByPlayers> __SortByPlayers__Delegate;
//var delegate<SortByPing> __SortByPing__Delegate;

function bool Start(optional bool StartPaused = false)
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry Registry;
    local PKGameSearchCommon CommonSearch;
    local int I;

    super.Start(StartPaused);
    Advance(0.0000000);
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0xDB
    if(DSClient != none)
    {
        SearchDataStore = PKDataStore_GameSearch(DSClient.FindDataStore(SearchDSName));
        StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));        
    }
    LatestSearchLenght = 0;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x19F
    if(OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        AuthInterface = OnlineSub.AuthInterface;
        LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    }
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("LanClient", "1");
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    ServersTF = ButtonsMC.GetObject("servernameTF");
    GameTypeTF = ButtonsMC.GetObject("gametypeTF");
    ServerListMC = ButtonsMC.GetObject("serverlist");
    ServerNameHeaderTF = ServerListMC.GetObject("labels").GetObject("server");
    GametypeHeaderTF = ServerListMC.GetObject("labels").GetObject("gametype");
    MapHeaderTF = ServerListMC.GetObject("labels").GetObject("map");
    PlayersHeaderTF = ServerListMC.GetObject("labels").GetObject("players");
    PingHeaderTF = ServerListMC.GetObject("labels").GetObject("ping");
    I = 0;
    J0x4E3:

    // End:0x803 [Loop If]
    if(I < 11)
    {
        ServersList[I].ServerListRow = ServerListMC.GetObject("row" $ string(I));
        ServersList[I].ServerListBtn = GFxClikWidget(ServersList[I].ServerListRow.GetObject("server", Class'GFxUI.GFxClikWidget'));
        ServersList[I].ServerListLockMC = ServersList[I].ServerListRow.GetObject("lock");
        ServersList[I].ServerListGametypeTF = ServersList[I].ServerListRow.GetObject("gametype");
        ServersList[I].ServerListMapTF = ServersList[I].ServerListRow.GetObject("map");
        ServersList[I].ServerListPlayersTF = ServersList[I].ServerListRow.GetObject("players");
        ServersList[I].ServerListPingTF = ServersList[I].ServerListRow.GetObject("ping");
        SetRowActive(I, false);
        I++;
        // [Loop Continue]
        goto J0x4E3;
    }
    JoinBtn = GFxClikWidget(ButtonsMC.GetObject("join_btn", Class'GFxUI.GFxClikWidget'));
    RefreshBtn = GFxClikWidget(ButtonsMC.GetObject("refresh_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x968
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    InternetLANCheckbox = GFxClikWidget(ButtonsMC.GetObject("InternetLAN", Class'GFxUI.GFxClikWidget'));
    InternetLANCheckbox.SetBool("selected", bLANSelected);
    SpectateCheckbox = GFxClikWidget(ButtonsMC.GetObject("spectate", Class'GFxUI.GFxClikWidget'));
    GameTypeTF.SetText(" ");
    GameTypeDropdown = GFxClikWidget(ButtonsMC.GetObject("gametype", Class'GFxUI.GFxClikWidget'));
    GameTypeDropdown.SetBool("visible", true);
    GameTypeTF.SetText(GameTypeString);
    UpdateGameTypeDropdownDataProvider();
    TitleTF.SetText(TitleString);
    ServersTF.SetText(ServersString);
    InternetLANCheckbox.SetString("label", LanInternetString);
    SpectateCheckbox.SetString("label", SpectateString);
    JoinBtn.SetString("label", JoinString);
    RefreshBtn.SetString("label", RefreshString);
    ServerNameHeaderTF.SetText(ServerNameTxt);
    GametypeHeaderTF.SetText(GameTxt);
    MapHeaderTF.SetText(MapNameTxt);
    PlayersHeaderTF.SetText(PlayersTxt);
    PingHeaderTF.SetText(PingTxt);
    ValidateServerType();
    bSearch1 = true;
    bSearch2 = true;
    CommonSearch = PKGameSearchCommon(SearchDataStore.GetCurrentGameSearch());
    // End:0xD4D
    if(CommonSearch != none)
    {
        CommonSearch.InitFilters();
    }
    bBackToCampaignMenu = false;
    SearchAllGames();
    GetMenuGame().StartDelayedGameSearch(0.9500000, self);
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    ButtonAliases.AddItem('GenericBack');
    FrontEnd.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function ValidateServerType()
{
    local int PlayerIndex, PlayerControllerId;

    PlayerIndex = GetPlayerIndex();
    PlayerControllerId = GetPlayerControllerId(PlayerIndex);
    // End:0x72
    if(!Class'Engine.UIInteraction'.static.IsLoggedIn(PlayerControllerId, true))
    {
        ForceLANOption(PlayerIndex);
    }
    //return;    
}

final function ForceLANOption(int PlayerIndex)
{
    local int I, ValueIndex;
    local name MatchTypeName;
    local PKGameSearchCustom CustomSearch;
    local array<UDKUIResourceDataProvider> Providers;
    local UTUIDataProvider_GameModeInfo Provider;

    MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'MatchType360' : 'MatchType');
    ValueIndex = StringListDataStore.GetCurrentValueIndex(MatchTypeName);
    // End:0xAC
    if(ValueIndex != 0)
    {
        StringListDataStore.SetCurrentValueIndex(MatchTypeName, 0);
    }
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_GameModeInfo', Providers);
    ValueIndex = -1;
    I = 0;
    J0xF7:

    // End:0x1A1 [Loop If]
    if(I < Providers.Length)
    {
        Provider = UTUIDataProvider_GameModeInfo(Providers[I]);
        // End:0x193
        if((Provider != none) && Provider.GameSearchClass == "PKGameSearchCustom")
        {
            ValueIndex = I;
            // [Explicit Break]
            goto J0x1A1;
        }
        ++I;
        // [Loop Continue]
        goto J0xF7;
    }
    J0x1A1:

    // End:0x28F
    if(ValueIndex != -1)
    {
        ValueIndex = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchCustom');
        // End:0x28F
        if(ValueIndex != -1)
        {
            CustomSearch = PKGameSearchCustom(SearchDataStore.GameSearchCfgList[ValueIndex].Search);
            CustomSearch.ResetFilters();
            SearchDataStore.SetCurrentByName('PKGameSearchCustom', true);
        }
    }
    //return;    
}

function RefreshServerListStart(optional int MaxResults = 50)
{
    local OnlineGameSearch GameSearch;
    local PKUIManager UIManager;
    local int ValueIndex;

    GameSearch = SearchDataStore.GetCurrentGameSearch();
    GameSearch.MaxSearchResults = MaxResults;
    ValueIndex = ((bLANSelected) ? 0 : 1);
    switch(ValueIndex)
    {
        // End:0xCE
        case 0:
            GameSearch.bIsLanQuery = true;
            GameSearch.bUsesArbitration = false;
            // End:0x188
            break;
        // End:0x13C
        case 2:
            // End:0x13C
            if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
            {
                GameSearch.bIsLanQuery = false;
                GameSearch.bUsesArbitration = true;
                // End:0x188
                break;
            }
        // End:0x185
        case 1:
            GameSearch.bIsLanQuery = false;
            GameSearch.bUsesArbitration = false;
            // End:0x188
            break;
        // End:0xFFFF
        default:
            break;
    }
    bSearch1 = false;
    bSearch2 = false;
    // End:0x21E
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1) || bLANSelected)
    {
        SubmitServerListQuery(Class'Engine.UIInteraction'.static.GetPlayerIndex(GetLP().ControllerId));        
    }
    else
    {
        SubmitServerListQuery(Class'Engine.UIInteraction'.static.GetPlayerIndex(GetLP().ControllerId));
        LookForLoobbies();
    }
    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x2D4
    if(UIManager != none)
    {
        UIManager.OpenUpdatingScene(,,, false);
    }
    //return;    
}

function RefreshServerList(optional int MaxResults = 50)
{
    local OnlineGameSearch GameSearch;
    local PKUIManager UIManager;
    local int ValueIndex;

    // End:0x325
    if(!SearchDataStore.HasOutstandingQueries())
    {
        GameSearch = SearchDataStore.GetCurrentGameSearch();
        GameSearch.MaxSearchResults = MaxResults;
        ValueIndex = ((bLANSelected) ? 0 : 1);
        switch(ValueIndex)
        {
            // End:0xF3
            case 0:
                GameSearch.bIsLanQuery = true;
                GameSearch.bUsesArbitration = false;
                // End:0x1AD
                break;
            // End:0x161
            case 2:
                // End:0x161
                if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
                {
                    GameSearch.bIsLanQuery = false;
                    GameSearch.bUsesArbitration = true;
                    // End:0x1AD
                    break;
                }
            // End:0x1AA
            case 1:
                GameSearch.bIsLanQuery = false;
                GameSearch.bUsesArbitration = false;
                // End:0x1AD
                break;
            // End:0xFFFF
            default:
                break;
        }
        DumpGameSearchData(GameSearch);
        SteamServerList.Length = 0;
        RebuildServerList();
        bSearch1 = false;
        bSearch2 = false;
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x252
        if(UIManager != none)
        {
            UIManager.OpenUpdatingScene(,,, false);
        }
        // End:0x2D0
        if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1) || bLANSelected)
        {
            SubmitServerListQuery(Class'Engine.UIInteraction'.static.GetPlayerIndex(GetLP().ControllerId));            
        }
        else
        {
            SubmitServerListQuery(Class'Engine.UIInteraction'.static.GetPlayerIndex(GetLP().ControllerId));
            LookForLoobbies();
        }        
    }
    else
    {
        CancelQuery();
    }
    //return;    
}

function SubmitServerListQuery(int PlayerIndex)
{
    GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    // End:0xD0
    if(!GameInterface.FindOnlineGames(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex)), SearchDataStore.GetCurrentGameSearch()))
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    }
    //return;    
}

function UpdateGameTypeDropdownDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    ListCounter = 0;
    DataProvider = CreateArray();
    TempObj = CreateObject("Object");
    TempObj.SetString("label", AllGamesString);
    DataProvider.SetElementObject(ListCounter++, TempObj);
    I = 0;
    J0xE7:

    // End:0x1D5 [Loop If]
    if(I < Class'PKGFxUI_Menu_MultiHost'.default.SupportedGameTypes.Length)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", Class'PKGFxUI_Menu_MultiHost'.default.SupportedGameTypes[I].Typename);
        DataProvider.SetElementObject(ListCounter++, TempObj);
        I++;
        // [Loop Continue]
        goto J0xE7;
    }
    GameTypeDropdown.SetObject("dataProvider", DataProvider);
    GameTypeDataProvider = GameTypeDropdown.GetObject("dataProvider");
    Registry.SetData("SelectedGameModePrefix", Class'PKGFxUI_Menu_MultiHost'.default.SupportedGameTypes[0].TypePrefix);
    Registry.SetData("SelectedGameMode", Class'PKGFxUI_Menu_MultiHost'.default.SupportedGameTypes[0].TypeClass);
    //return;    
}

function UpdateListDataProvider()
{
    // End:0x40
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1) || bLANSelected)
    {
        UpdateListDataProviderLAN();        
    }
    else
    {
        UpdateListDataProviderDedicated();
    }
    //return;    
}

static function string GetLocalizedGameType(string GameType)
{
    // End:0x3B
    if(InStr(GameType, "CTF") >= 0)
    {
        return Class'PKGFxUI_Menu_Leaderboard'.default.TitleCTF;        
    }
    else
    {
        // End:0x81
        if(InStr(GameType, "TeamDeathmatch") >= 0)
        {
            return Class'PKGFxUI_Menu_Leaderboard'.default.TitleTDM;            
        }
        else
        {
            // End:0xC1
            if(InStr(GameType, "Survival") >= 0)
            {
                return Class'PKGFxUI_Menu_Leaderboard'.default.TitleSV;                
            }
            else
            {
                // End:0x103
                if(InStr(GameType, "Deathmatch") >= 0)
                {
                    return Class'PKGFxUI_Menu_Leaderboard'.default.TitleDM;                    
                }
                else
                {
                    // End:0x15A
                    if(InStr(GameType, "Coop") >= 0)
                    {
                        return Localize("PKGFxUI_Menu_MultiHost", "CoopModeString", "PKHDGame");
                    }
                }
            }
        }
    }
    return "none";
    //return ReturnValue;    
}

function string GetMapFriendlyName(string Map)
{
    local int I, P, StartIndex, EndIndex;
    local array<string> LocPieces;
    local array<UDKUIResourceDataProvider> LocalMapList;

    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', LocalMapList);
    I = 0;
    J0x3C:

    // End:0x240 [Loop If]
    if(I < LocalMapList.Length)
    {
        // End:0x232
        if(UTUIDataProvider_MapInfo(LocalMapList[I]).MapName ~= Map)
        {
            StartIndex = InStr(Caps(UTUIDataProvider_MapInfo(LocalMapList[I]).FriendlyName), "<STRINGS:");
            // End:0xF6
            if(StartIndex == -1)
            {
                // [Explicit Break]
                goto J0x240;
            }
            Map = Right(UTUIDataProvider_MapInfo(LocalMapList[I]).FriendlyName, (Len(UTUIDataProvider_MapInfo(LocalMapList[I]).FriendlyName) - StartIndex) - 9);
            EndIndex = InStr(Map, ">");
            // End:0x228
            if(EndIndex != -1)
            {
                Map = Left(Map, EndIndex);
                ParseStringIntoArray(Map, LocPieces, ".", true);
                // End:0x228
                if(LocPieces.Length >= 3)
                {
                    Map = Localize(LocPieces[1], LocPieces[2], LocPieces[0]);
                }
            }
            return Map;
        }
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    J0x240:

    P = InStr(Map, "-");
    // End:0x29C
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    P = InStr(Map, "-");
    // End:0x2F8
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    Map = Left(Map, Len(Map) - 2);
    return Map;
    //return ReturnValue;    
}

function UpdateListDataProviderLAN()
{
    local byte I;
    local OnlineGameSearch LatestGameSearch;
    local int Index, passwd, SelectedIndex;
    local string txt, GameType, game2search;
    local bool bSearchCompleted;

    bSearchCompleted = !SearchDataStore.HasOutstandingQueries();
    ServerInfoList.Length = 0;
    LatestGameSearch = SearchDataStore.GetCurrentGameSearch();
    // End:0xCC3
    if(LatestGameSearch != none)
    {
        // End:0x9A
        if(ForceSelectedIndex > -1)
        {
            SelectedIndex = ForceSelectedIndex;            
        }
        else
        {
            SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex"));
        }
        switch(SelectedIndex)
        {
            // End:0x103
            case 0:
                game2search = "PKGameAll";
                // End:0x1B5
                break;
            // End:0x126
            case 1:
                game2search = "PKGameDeathmatch";
                // End:0x1B5
                break;
            // End:0x14E
            case 2:
                game2search = "PKGameTeamDeathmatch";
                // End:0x1B5
                break;
            // End:0x16B
            case 3:
                game2search = "PKGameCTF";
                // End:0x1B5
                break;
            // End:0x18D
            case 4:
                game2search = "PKGameSurvival";
                // End:0x1B5
                break;
            // End:0x1B2
            case 5:
                game2search = "PKGameCooperative";
                // End:0x1B5
                break;
            // End:0xFFFF
            default:
                break;
        }
        LatestSearchLenght = LatestGameSearch.Results.Length;
        Index = 0;
        I = 0;
        J0x1F5:

        // End:0xC9D [Loop If]
        if(int(I) < LatestGameSearch.Results.Length)
        {
            GameType = LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('CustomGameMode');
            // End:0xC8F
            if(((game2search == "PKGameAll") && InStr(GameType, "Coop") < 0) || InStr(GameType, game2search) >= 0)
            {
                GameType = GetLocalizedGameType(GameType);
                txt = ((LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName != "") ? LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName : Localize("PKGFxUI_Menu_MultiHost", "ServerNameLabelString", "PKHDGame"));                
                txt $= ((("    " $ GameType) $ "    ") $ LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('CustomMapName'));                
                txt $= ((("    " $ string(LatestGameSearch.Results[int(I)].GameSettings.PingInMs)) $ "    ") $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections - LatestGameSearch.Results[int(I)].GameSettings.NumOpenPublicConnections));                
                txt $= ("/" $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections));
                SteamServerList.Add(1);
                Index = SteamServerList.Length - 1;
                SteamServerList[Index].Label = txt;
                SteamServerList[Index].ServerName = ((LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName != "") ? LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName : Localize("PKGFxUI_Menu_MultiHost", "ServerNameLabelString", "PKHDGame"));
                SteamServerList[Index].Players = (("    " $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections - LatestGameSearch.Results[int(I)].GameSettings.NumOpenPublicConnections)) $ "/") $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections);
                SteamServerList[Index].SteamServerId = PKGameSettingsCommon(LatestGameSearch.Results[int(I)].GameSettings).SteamServerId;
                SteamServerList[Index].GameType = GameType;
                SteamServerList[Index].Ping = LatestGameSearch.Results[int(I)].GameSettings.PingInMs;
                SteamServerList[Index].OwnerId = LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('OwnerId');
                SteamServerList[Index].MapName = GetMapFriendlyName(LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('CustomMapName'));
                SteamServerList[Index].RawMapName = LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('CustomMapName');
                SteamServerList[Index].GameToJoin = LatestGameSearch.Results[int(I)];
                // End:0xC66
                if(!PKGameSettingsCommon(LatestGameSearch.Results[int(I)].GameSettings).GetStringSettingValue(7, passwd) || passwd == 1)
                {
                    SteamServerList[Index].bUsePassword = true;                    
                }
                else
                {
                    SteamServerList[Index].bUsePassword = false;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x1F5;
        }
        // End:0xCB6
        if(bSearchCompleted)
        {
            bSearch2 = true;
        }
        RebuildServerList();        
    }
    //return;    
}

function UpdateListDataProviderLobby()
{
    local byte I;
    local int Index, SelectedIndex;
    local string txt, steamId, GameType, game2search, PlayerNick, locGameType;

    ServerInfoList.Length = 0;
    PlayerNick = OnlineSubsystemSteamworks(OnlineSub).GetPlayerNickname(byte(GetLP().ControllerId));
    LatestSearchLenght = Lobbies.Length;
    // End:0x9C
    if(ForceSelectedIndex > -1)
    {
        SelectedIndex = ForceSelectedIndex;        
    }
    else
    {
        SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex"));
    }
    switch(SelectedIndex)
    {
        // End:0x105
        case 0:
            game2search = "PKGameAll";
            // End:0x1B7
            break;
        // End:0x128
        case 1:
            game2search = "PKGameDeathmatch";
            // End:0x1B7
            break;
        // End:0x150
        case 2:
            game2search = "PKGameTeamDeathmatch";
            // End:0x1B7
            break;
        // End:0x16D
        case 3:
            game2search = "PKGameCTF";
            // End:0x1B7
            break;
        // End:0x18F
        case 4:
            game2search = "PKGameSurvival";
            // End:0x1B7
            break;
        // End:0x1B4
        case 5:
            game2search = "PKGameCooperative";
            // End:0x1B7
            break;
        // End:0xFFFF
        default:
            break;
    }
    I = 0;
    J0x1C3:

    // End:0x981 [Loop If]
    if(int(I) < Lobbies.Length)
    {
        GameType = Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "GAMETYPE");
        // End:0x973
        if(((game2search == "PKGameAll") && InStr(GameType, "Coop") < 0) || InStr(GameType, game2search) >= 0)
        {
            locGameType = GetLocalizedGameType(GameType);
            // End:0x2FD
            if((locGameType == "none") || Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "SERVERNAME") == PlayerNick)
            {                
            }
            else
            {
                steamId = Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "STEAMID");
                // End:0x973
                if(SteamServerList.Find('SteamServerId', steamId) == -1)
                {
                    txt = OnlineSub.UniqueNetIdToStringDEC(PKPlayerController(GetPC()).LobbyUID);
                    // End:0x40C
                    if(Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "STEAMID") == txt)
                    {                        
                    }
                    else
                    {
                        txt = Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "SERVERNAME");
                        txt = ((txt != "") ? txt : Localize("PKGFxUI_Menu_MultiHost", "ServerNameLabelString", "PKHDGame"));                        
                        txt $= ((("     " $ locGameType) $ "     ") $ Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "MAPNAME"));                        
                        txt $= ("     N/A     " $ Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "PLAYERS"));                        
                        txt $= ((Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "USEPASSWORD") == "1") ? "  (*)" : "");
                        SteamServerList.Add(1);
                        Index = SteamServerList.Length - 1;
                        SteamServerList[Index].Label = txt;
                        SteamServerList[Index].ServerName = Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "SERVERNAME");
                        SteamServerList[Index].Players = Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "PLAYERS");
                        SteamServerList[Index].GameType = locGameType;
                        SteamServerList[Index].SteamServerId = steamId;
                        SteamServerList[Index].OwnerId = Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "OWNERID");
                        SteamServerList[Index].Ping = 0;
                        SteamServerList[Index].MapName = GetMapFriendlyName(Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "MAPNAME"));
                        SteamServerList[Index].RawMapName = Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "MAPNAME");
                        // End:0x94A
                        if(Class'PKPlayerController'.static.GetLobbyData(Lobbies[int(I)], "USEPASSWORD") == "1")
                        {
                            SteamServerList[Index].bUsePassword = true;                            
                        }
                        else
                        {
                            SteamServerList[Index].bUsePassword = false;
                        }
                    }
                }
            }
        }
        I++;
        // [Loop Continue]
        goto J0x1C3;
    }
    bSearch1 = true;
    RebuildServerList();
    //return;    
}

function UpdateListDataProviderDedicated()
{
    local byte I;
    local OnlineGameSearch LatestGameSearch;
    local int Index, passwd, SelectedIndex;
    local string txt, GameType, game2search;
    local bool bSearchCompleted;

    bSearchCompleted = !SearchDataStore.HasOutstandingQueries();
    ServerInfoList.Length = 0;
    LatestGameSearch = SearchDataStore.GetCurrentGameSearch();
    // End:0xD64
    if(LatestGameSearch != none)
    {
        // End:0x9A
        if(ForceSelectedIndex > -1)
        {
            SelectedIndex = ForceSelectedIndex;            
        }
        else
        {
            SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex"));
        }
        switch(SelectedIndex)
        {
            // End:0x103
            case 0:
                game2search = "PKGameAll";
                // End:0x1B5
                break;
            // End:0x126
            case 1:
                game2search = "PKGameDeathmatch";
                // End:0x1B5
                break;
            // End:0x14E
            case 2:
                game2search = "PKGameTeamDeathmatch";
                // End:0x1B5
                break;
            // End:0x16B
            case 3:
                game2search = "PKGameCTF";
                // End:0x1B5
                break;
            // End:0x18D
            case 4:
                game2search = "PKGameSurvival";
                // End:0x1B5
                break;
            // End:0x1B2
            case 5:
                game2search = "PKGameCooperative";
                // End:0x1B5
                break;
            // End:0xFFFF
            default:
                break;
        }
        LatestSearchLenght = LatestGameSearch.Results.Length;
        Index = 0;
        I = 0;
        J0x1F5:

        // End:0xD3E [Loop If]
        if(int(I) < LatestGameSearch.Results.Length)
        {
            GameType = LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('CustomGameMode');
            // End:0xD30
            if(((game2search == "PKGameAll") && InStr(GameType, "Coop") < 0) || InStr(GameType, game2search) >= 0)
            {
                Index = SteamServerList.Find('SteamServerId', PKGameSettingsCommon(LatestGameSearch.Results[int(I)].GameSettings).SteamServerId);
                // End:0x37D
                if(Index >= 0)
                {
                    SteamServerList.Remove(Index, 1);
                }
                GameType = GetLocalizedGameType(GameType);
                txt = ((LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName != "") ? LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName : Localize("PKGFxUI_Menu_MultiHost", "ServerNameLabelString", "PKHDGame"));                
                txt $= ((("    " $ GameType) $ "    ") $ LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('CustomMapName'));                
                txt $= ((("    " $ string(LatestGameSearch.Results[int(I)].GameSettings.PingInMs)) $ "    ") $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections - LatestGameSearch.Results[int(I)].GameSettings.NumOpenPublicConnections));                
                txt $= (" / " $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections));
                SteamServerList.Add(1);
                Index = SteamServerList.Length - 1;
                SteamServerList[Index].Label = txt;
                SteamServerList[Index].ServerName = ((LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName != "") ? LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName : Localize("PKGFxUI_Menu_MultiHost", "ServerNameLabelString", "PKHDGame"));
                SteamServerList[Index].Players = (("    " $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections - LatestGameSearch.Results[int(I)].GameSettings.NumOpenPublicConnections)) $ "/") $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections);
                SteamServerList[Index].SteamServerId = PKGameSettingsCommon(LatestGameSearch.Results[int(I)].GameSettings).SteamServerId;
                SteamServerList[Index].GameType = GameType;
                SteamServerList[Index].Ping = LatestGameSearch.Results[int(I)].GameSettings.PingInMs;
                SteamServerList[Index].OwnerId = LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('OwnerId');
                SteamServerList[Index].MapName = GetMapFriendlyName(LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('CustomMapName'));
                SteamServerList[Index].RawMapName = LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('CustomMapName');
                SteamServerList[Index].GameToJoin = LatestGameSearch.Results[int(I)];
                // End:0xD07
                if(!PKGameSettingsCommon(LatestGameSearch.Results[int(I)].GameSettings).GetStringSettingValue(7, passwd) || passwd == 1)
                {
                    SteamServerList[Index].bUsePassword = true;                    
                }
                else
                {
                    SteamServerList[Index].bUsePassword = false;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x1F5;
        }
        // End:0xD57
        if(bSearchCompleted)
        {
            bSearch2 = true;
        }
        RebuildServerList();        
    }
    //return;    
}

function SetRowActive(int I, bool bActive)
{
    // End:0xA8
    if(I < 11)
    {
        ServersList[I].ServerListBtn.SetBool("disabled", !bActive);
        ServersList[I].ServerListRow.SetVisible(bActive);
    }
    //return;    
}

function RebuildServerList()
{
    local byte I;
    local PKUIManager UIManager;

    // End:0x33
    if(!bLANSelected && !bSearch1 || !bSearch2)
    {
        return;
    }
    ServerInfoList.Length = 0;
    I = 0;
    J0x4B:

    // End:0x3B3 [Loop If]
    if(int(I) < 11)
    {
        // End:0x38F
        if(int(I) < (SteamServerList.Length - CurrentRowShift))
        {
            SetRowActive(int(I), true);
            ServersList[int(I)].GameSearchIndex = int(I) + CurrentRowShift;
            ServersList[int(I)].ServerListBtn.SetString("label", SteamServerList[int(I) + CurrentRowShift].ServerName);
            ServersList[int(I)].ServerListLockMC.SetVisible(SteamServerList[int(I) + CurrentRowShift].bUsePassword);
            ServersList[int(I)].ServerListGametypeTF.SetText(SteamServerList[int(I) + CurrentRowShift].GameType);
            ServersList[int(I)].ServerListMapTF.SetText(SteamServerList[int(I) + CurrentRowShift].MapName);
            ServersList[int(I)].ServerListPlayersTF.SetText(SteamServerList[int(I) + CurrentRowShift].Players);
            ServersList[int(I)].ServerListPingTF.SetText(string(SteamServerList[int(I) + CurrentRowShift].Ping));            
        }
        else
        {
            SetRowActive(int(I), false);
        }
        I++;
        // [Loop Continue]
        goto J0x4B;
    }
    // End:0x44C
    if(LastSelectedSlot < (SteamServerList.Length - CurrentRowShift))
    {
        ServersList[LastSelectedSlot].ServerListBtn.SetBool("focused", true);
        LastSelectedIndex = ServersList[LastSelectedSlot].GameSearchIndex;
    }
    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x4AD
    if(UIManager != none)
    {
        UIManager.CloseUpdatingScene(false);
    }
    //return;    
}

function int GetPlayerIndex()
{
    local int PlayerIndex;
    local LocalPlayer LP;

    LP = GetLP();
    // End:0x6A
    if(LP != none)
    {
        PlayerIndex = Class'Engine.UIInteraction'.static.GetPlayerIndex(LP.ControllerId);
    }
    return PlayerIndex;
    //return ReturnValue;    
}

function int GetPlayerControllerId(int PlayerIndex)
{
    return Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
    //return ReturnValue;    
}

function Cleanup()
{
    local PKGameMenu MenuGame;
    local PKUIManager UIManager;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x61
    if(UIManager != none)
    {
        UIManager.CloseUpdatingScene(false);
    }
    // End:0xE3
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    }
    // End:0x111
    if(SearchDataStore != none)
    {
        SearchDataStore.ClearAllSearchResults();
    }
    MenuGame = PKGameMenu(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    // End:0x1A5
    if(MenuGame != none)
    {
        MenuGame.CleanupGameSearchRefreshing();
        MenuGame.CleanupDelayedGameSearch();
    }
    //return;    
}

function CancelQuery(optional PKGFxUI_Menu_MultiServers.EQueryCompletionAction DesiredCancelAction = 1)
{
    // End:0xF4
    if(int(QueryCompletionAction) == int(0))
    {
        QueryCompletionAction = DesiredCancelAction;
        // End:0xB5
        if((SearchDataStore == none) || SearchDataStore.HasOutstandingQueries())
        {
            GameInterface.AddCancelFindOnlineGamesCompleteDelegate(OnCancelSearchComplete);
            GameInterface.CancelFindOnlineGames();            
        }
        else
        {
            // End:0xE5
            if(SearchDataStore.HasExistingSearchResults())
            {
                OnCancelSearchComplete(true);                
            }
            else
            {
                QueryCompletionAction = 0;
            }
        }        
    }
    //return;    
}

function OnCancelSearchComplete(bool bWasSuccessful)
{
    local PKGFxUI_Menu_MultiServers.EQueryCompletionAction CurrentAction;
    local PKUIManager UIManager;

    GameInterface.ClearCancelFindOnlineGamesCompleteDelegate(OnCancelSearchComplete);
    // End:0xFA
    if(bWasSuccessful)
    {
        CurrentAction = QueryCompletionAction;
        QueryCompletionAction = 0;
        switch(CurrentAction)
        {
            // End:0x78
            case 2:
                // End:0x99
                break;
            // End:0x80
            case 3:
                // End:0x99
                break;
            // End:0x93
            case 4:
                RefreshServerList();
                // End:0x99
                break;
            // End:0xFFFF
            default:
                // End:0x99
                break;
                break;
        }
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0xFA
        if(UIManager != none)
        {
            UIManager.CloseUpdatingScene(false);
        }
    }
    //return;    
}

function OnFindOnlineGamesCompleteDelegate(bool bWasSuccessful)
{
    local bool bSearchCompleted;

    bSearchCompleted = !SearchDataStore.HasOutstandingQueries();
    // End:0x8B
    if(bSearchCompleted)
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
        LastSelectedSlot = 0;
        CurrentRowShift = 0;
        UpdateListDataProvider();
    }
    //return;    
}

function OnServerConnectionClose(Player ServerConnection)
{
    AuthInterface.ClearServerConnectionCloseDelegate(OnServerConnectionClose);
    //return;    
}

function OnJoinGameComplete(name SessionName, bool bSuccessful)
{
    local OnlineGameSettings gSettings;
    local string URL, pwd;

    // End:0x22E
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        // End:0x1C7
        if(bSuccessful)
        {
            CloseOnJoin();
            Cleanup();
            // End:0x1C4
            if(GameInterface.GetResolvedConnectString('Game', URL))
            {
                gSettings = GameInterface.GetGameSettings('Game');
                // End:0xE6
                if(gSettings != none)
                {
                    pwd = gSettings.GetPropertyAsString(1073741827);
                }
                // End:0x122
                if(pwd != "")
                {                    
                    URL $= ("?Password=" $ pwd);
                }
                URL = "open " $ URL;
                // End:0x172
                if(bSpectateSelected)
                {                    
                    URL $= "?SpectatorOnly=1";
                }
                PKEngine(Class'PKEngine'.static.GetEngine()).SetCanBreakFullscreenMovie(true);
                ConsoleCommand(URL);
            }            
        }
        else
        {
            GameInterface.DestroyOnlineGame('Game');
            ShowContentErrorMsg();
        }
        GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinGameComplete);        
    }
    else
    {
        ShowContentErrorMsg();
    }
    //return;    
}

function SetGameSearch()
{
    local int I, SelectedIndex;

    // End:0x29
    if(ForceSelectedIndex > -1)
    {
        SelectedIndex = ForceSelectedIndex;        
    }
    else
    {
        SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex"));
    }
    switch(SelectedIndex)
    {
        // End:0x86
        case 0:
            SearchAllGames();
            return;
        // End:0xBF
        case 1:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchDeathmatch');
            // End:0x1AA
            break;
        // End:0xF9
        case 2:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchTeamDeathmatch');
            // End:0x1AA
            break;
        // End:0x133
        case 3:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchCTF');
            // End:0x1AA
            break;
        // End:0x16D
        case 4:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchSurvival');
            // End:0x1AA
            break;
        // End:0x1A7
        case 5:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchCoop');
            // End:0x1AA
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x1E9
    if(I != -1)
    {
        SearchDataStore.SetCurrentByIndex(I, true);        
    }
    //return;    
}

function OnGameTypeDropdownChange(EventData ev)
{
    SetGameSearch();
    GetMenuGame().StartDelayedGameSearch(0.7500000, self);
    //return;    
}

function OnLANInternetSelect(EventData ev)
{
    local name MatchTypeName;
    local DataStoreClient DSClient;

    bLANSelected = InternetLANCheckbox.GetBool("selected");
    MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'ServerType360' : 'ServerType');
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
    StringListDataStore.SetCurrentValueIndex(MatchTypeName, ((bLANSelected) ? 0 : 1));
    SetGameSearch();
    RefreshServerList();
    //return;    
}

function OnSpectateSelect(EventData ev)
{
    bSpectateSelected = SpectateCheckbox.GetBool("selected");
    //return;    
}

function OnServerFocus(int Index)
{
    LastSelectedSlot = Index;
    LastSelectedIndex = ServersList[Index].GameSearchIndex;
    //return;    
}

function OnServerSelect(int Index)
{
    // End:0xA6
    if((LatestSearchLenght > 0) && LatestSearchLenght > LastSelectedIndex)
    {
        // End:0xA6
        if(GetPC().WorldInfo.IsConsoleBuild(0) || GetPC().PlayerInput.bUsingGamepad)
        {
            TryToJoin();
        }
    }
    //return;    
}

function ButtonLabelOn1(EventData ev)
{
    SteamServerList.Sort(SortByServer);
    RebuildServerList();
    bServerSort = !bServerSort;
    //return;    
}

function ButtonLabelOn2(EventData ev)
{
    SteamServerList.Sort(SortByGame);
    RebuildServerList();
    bGameSort = !bGameSort;
    //return;    
}

function ButtonLabelOn3(EventData ev)
{
    SteamServerList.Sort(SortByMap);
    RebuildServerList();
    bMapSort = !bMapSort;
    //return;    
}

function ButtonLabelOn4(EventData ev)
{
    SteamServerList.Sort(SortByPlayers);
    RebuildServerList();
    bPlayersSort = !bPlayersSort;
    //return;    
}

function ButtonLabelOn5(EventData ev)
{
    SteamServerList.Sort(SortByPing);
    RebuildServerList();
    bPingSort = !bPingSort;
    //return;    
}

delegate int SortByServer(SteamServerData A, SteamServerData B)
{
    return ((bServerSort) ? ((A.ServerName > B.ServerName) ? -1 : 0) : ((A.ServerName < B.ServerName) ? -1 : 0));
    //return ReturnValue;    
}

delegate int SortByGame(SteamServerData A, SteamServerData B)
{
    return ((bGameSort) ? ((A.GameType > B.GameType) ? -1 : 0) : ((A.GameType < B.GameType) ? -1 : 0));
    //return ReturnValue;    
}

delegate int SortByMap(SteamServerData A, SteamServerData B)
{
    return ((bMapSort) ? ((A.MapName > B.MapName) ? -1 : 0) : ((A.MapName < B.MapName) ? -1 : 0));
    //return ReturnValue;    
}

delegate int SortByPlayers(SteamServerData A, SteamServerData B)
{
    return ((bPlayersSort) ? ((A.Players > B.Players) ? -1 : 0) : ((A.Players < B.Players) ? -1 : 0));
    //return ReturnValue;    
}

delegate int SortByPing(SteamServerData A, SteamServerData B)
{
    return ((bPingSort) ? ((A.Ping > B.Ping) ? -1 : 0) : ((A.Ping < B.Ping) ? -1 : 0));
    //return ReturnValue;    
}

function ArrowUpOn(EventData ev)
{
    bAutoShiftUp = true;
    //return;    
}

function ArrowUpOut(EventData ev)
{
    bAutoShiftUp = false;
    //return;    
}

function ArrowDownOn(EventData ev)
{
    bAutoShiftDown = true;
    //return;    
}

function ArrowDownOut(EventData ev)
{
    bAutoShiftDown = false;
    //return;    
}

function OnBack(EventData ev)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnJoinBtn(EventData ev)
{
    // End:0x34
    if((SteamServerList.Length > 0) && SteamServerList.Length > LastSelectedIndex)
    {
        TryToJoin();
    }
    //return;    
}

function OnRefreshBtn(EventData ev)
{
    RefreshServerList();
    //return;    
}

function CloseOnJoin()
{
    Action = "join";
    PlayCloseAnimation();
    //return;    
}

final function ShowJoinErrorMsg()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x116
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');
        UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "InviteJoinFailed_Title", "PKHDGame"), Localize("KGFxUI_PreGameLobby", "UnableToJoinGameString", "PKHDGame"), ButtonAliases,,,,,, false, false);
    }
    //return;    
}

final function ShowConnectionErrorMsg()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x118
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');
        UIManager.ShowUIMessage('ConnectionError', Localize("PKGFxUI_MPLobbyMsg", "ErrorTitle", "PKHDGame"), Localize("PKGFxUI_MPLobbyMsg", "ServerUnableToJoinMessage", "PKHDGame"), ButtonAliases, None,,,,, false, false);
    }
    //return;    
}

final function ShowContentErrorMsg()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x11D
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');
        UIManager.ShowUIMessage('ConnectionError', Localize("KGFxUI_PreGameLobby", "ContentMismatchTitle", "PKHDGame"), Localize("KGFxUI_PreGameLobby", "JIPContentMismatch", "PKHDGame"), ButtonAliases, None,,,,, false, false);
    }
    //return;    
}

function ConfigForSearchingOnlyForCoopGames()
{
    SpectateCheckbox.SetString("label", "");
    SpectateCheckbox.SetVisible(false);
    ForceSelectedIndex = 5;
    SetGameSearch();
    RefreshServerList();
    GameTypeDropdown.SetBool("visible", false);
    GameTypeTF.SetText(" ");
    bBackToCampaignMenu = true;
    //return;    
}

function SearchAllGames()
{
    local int I;
    local PKGameSearchCustom CustomSearch;

    I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchCustom');
    // End:0xDE
    if(I != -1)
    {
        CustomSearch = PKGameSearchCustom(SearchDataStore.GameSearchCfgList[I].Search);
        CustomSearch.ResetFilters();
        SearchDataStore.SetCurrentByName('PKGameSearchCustom', true);        
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0xA5
        case "back":
            GetMenuGame().MultiGameModeSelected = 0;
            // End:0x78
            if(bBackToCampaignMenu)
            {
                bTransitionResult = FrontEnd.OpenCampaignCoopScreen();                
            }
            else
            {
                bTransitionResult = FrontEnd.OpenMultiMenuScreen();
            }
            // End:0xC2
            break;
        // End:0xBC
        case "join":
            Close(true);
            // End:0xC2
            break;
        // End:0xFFFF
        default:
            // End:0xC2
            break;
            break;
    }
    Cleanup();
    // End:0xF8
    if(bTransitionResult)
    {
        FrontEnd.CloseMultiServersScreen();
    }
    Action = "";
    //return;    
}

function bool OnMissingDLCFound(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x5E
    if(SelectedInputAlias == 'GenericOpenSteamStore')
    {
        PKEngine(Class'Engine.Engine'.static.GetEngine()).ShowDLCStore(DLCIndex);
    }
    DLCIndex = -1;
    return true;
    //return ReturnValue;    
}

function bool IsThisMapAllowedOnJanuaryFreeWeekend(string MapName)
{
    // End:0xCC
    if((((((Caps(MapName) == "SP-CEMETERY_P") || Caps(MapName) == "SP-CATHEDRAL_P") || Caps(MapName) == "SP-ATRIUMCOMPLEX_P") || Caps(MapName) == "SP-ENCLAVE_P") || Caps(MapName) == "SP-TUTORIAL_P") || Caps(MapName) == "SP-TUTORIAL1_P")
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function TryToJoin()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local array<string> StrArr;
    local string pwd, sDLCIndex;
    local PKPlayerController PC;

    PC = PKPlayerController(GetPC());
    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    DLCIndex = -1;
    // End:0x4D2
    if(bBackToCampaignMenu && !(LastSelectedIndex >= SteamServerList.Length) || LastSelectedIndex < 0)
    {
        // End:0x42A
        if(InStr(SteamServerList[LastSelectedIndex].RawMapName, "DLC") != -1)
        {
            StrArr = SplitString(SteamServerList[LastSelectedIndex].RawMapName, "_");
            // End:0x42A
            if(StrArr.Length > 2)
            {
                sDLCIndex = StrArr[2];
                DLCIndex = int(sDLCIndex);
                // End:0x318
                if((((((((DLCIndex == 1) && int(PC.IsDLCInstalled(8)) == int(1)) || (DLCIndex == 2) && int(PC.IsDLCInstalled(9)) == int(1)) || (DLCIndex == 3) && int(PC.IsDLCInstalled(10)) == int(1)) || (DLCIndex == 4) && int(PC.IsDLCInstalled(11)) == int(1)) || (DLCIndex == 5) && int(PC.IsDLCInstalled(12)) == int(1)) || (DLCIndex == 6) && int(PC.IsDLCInstalled(13)) == int(1)) || (DLCIndex == 7) && int(PC.IsDLCInstalled(14)) == int(1))
                {
                    DLCIndex = -1;
                }
                // End:0x42A
                if(DLCIndex > 0)
                {
                    ButtonAliases.AddItem('GenericOpenSteamStore');
                    ButtonAliases.AddItem('GenericCancel');
                    UIManager.ShowUIMessage('MissingDLC', Localize("MessageBoxErrorStrings", "DLCRemovedAtMenuTitle", "PKHDGame"), Localize("MessageBoxErrorStrings", "DLCNeeded_Message", "PKHDGame"), ButtonAliases, OnMissingDLCFound, GetLP(),,,,, false);
                    return;
                }
            }
        }
        // End:0x4D2
        if((!IsThisMapAllowedOnJanuaryFreeWeekend(SteamServerList[LastSelectedIndex].RawMapName) && PC.IsFreeJanuaryWeekendSubscribed()) && bBackToCampaignMenu)
        {
            PKGameViewportClient(GetLP().ViewportClient).ShowJanuarySubscriptionWindow();
            return;
        }
    }
    JoinBtn.SetBool("disabled", true);
    // End:0x518
    if(!bLANSelected)
    {
        JoinByLobby();        
    }
    else
    {
        // End:0x696
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            // End:0x689
            if(LastSelectedIndex >= 0)
            {
                GameToJoin = SteamServerList[LastSelectedIndex].GameToJoin;
                // End:0x672
                if(GameToJoin.GameSettings != none)
                {
                    pwd = GameToJoin.GameSettings.GetPropertyAsString(1073741827);
                    // End:0x664
                    if(pwd == "PWD")
                    {
                        ButtonAliases.AddItem('GenericAccept');
                        UIManager.ShowPasswordBox('PasswordWindow', "Password", "", ButtonAliases, OnPasswordEnteredLAN, GetLP(),,,, false, false);
                        return;
                    }
                    JoinLanWorker();                    
                }
                else
                {
                    OnJoinGameComplete('Game', false);
                }                
            }
            else
            {
                ShowConnectionErrorMsg();
            }            
        }
        else
        {
            ShowConnectionErrorMsg();
        }
    }
    JoinBtn.SetBool("disabled", false);
    //return;    
}

function JoinLanWorker(optional string InServerPassword = "")
{
    GameInterface.DestroyOnlineGame('Game');
    GameToJoin.GameSettings.SetStringProperty(1073741827, InServerPassword);
    GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
    // End:0xE3
    if(!GameInterface.JoinOnlineGame(0, 'Game', GameToJoin))
    {
        ShowJoinErrorMsg();
    }
    //return;    
}

function bool AllowJoinServer()
{
    local bool bResult;

    bResult = true;
    // End:0x6C
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        // End:0x6C
        if((SearchDataStore != none) && SearchDataStore.HasOutstandingQueries())
        {
            bResult = false;
        }
    }
    return bResult;
    //return ReturnValue;    
}

function JoinByLobby()
{
    local bool bNeedPassword;
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x2B
    if((LastSelectedIndex >= SteamServerList.Length) || LastSelectedIndex < 0)
    {
        return;
    }
    GameInterface.DestroyOnlineGame('Game');
    JoinSteamID = SteamServerList[LastSelectedIndex].SteamServerId;
    bNeedPassword = SteamServerList[LastSelectedIndex].bUsePassword;
    // End:0x1A5
    if(bNeedPassword)
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        ButtonAliases.AddItem('GenericAccept');
        UIManager.ShowPasswordBox('PasswordWindow', Localize("PKGFxUI_Menu_MultiHost", "ServerPasswordString", "PKHDGame"), "", ButtonAliases, OnPasswordEntered, GetLP(),,,, false, false);        
    }
    else
    {
        JoinLobbyWorker();
    }
    //return;    
}

function JoinLobbyWorker(optional string InServerPassword = "")
{
    local string URL;

    GetPKPC().ClientShowLevelLoadingMovie();
    URL = "open steam." $ JoinSteamID;
    // End:0x84
    if(InServerPassword != "")
    {        
        URL $= ("?Password=" $ InServerPassword);
    }
    ConsoleCommand(URL);
    Cleanup();
    JoinSteamID = "";
    //return;    
}

function ShowWrongPasswordInfo()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    ButtonAliases.AddItem('GenericAccept');
    UIManager.ShowUIMessage('ConnectionError', Localize("PKGFxUI_Menu_MultiHost", "ServerPasswordString", "PKHDGame"), Localize("AccessControl", "WrongPassword", "Engine"), ButtonAliases, None, GetLP(),,,, false, false);
    JoinBtn.SetBool("disabled", false);
    //return;    
}

function bool OnPasswordEntered(UIScene_PasswordBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local string pwd;

    pwd = Class'PKGFxUI_Menu_MultiHost'.static.XORString(Sender.GetPasswordText(), 17);
    // End:0x94
    if(SteamServerList[LastSelectedIndex].OwnerId == pwd)
    {
        JoinLobbyWorker(pwd);        
    }
    else
    {
        ShowWrongPasswordInfo();
    }
    return true;
    //return ReturnValue;    
}

function bool OnPasswordEnteredLAN(UIScene_PasswordBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local string pwd;

    pwd = Class'PKGFxUI_Menu_MultiHost'.static.XORString(Sender.GetPasswordText(), 17);
    // End:0x94
    if(SteamServerList[LastSelectedIndex].OwnerId == pwd)
    {
        JoinLanWorker(pwd);        
    }
    else
    {
        ShowWrongPasswordInfo();
    }
    return true;
    //return ReturnValue;    
}

exec function LookForLoobbies()
{
    local array<LobbyFilter> Filters;
    local PKGameSearchCommon LatestGameSearch;
    local int SelectedIndex;
    local string GameType;

    SetGameSearch();
    LatestGameSearch = PKGameSearchCommon(SearchDataStore.GetCurrentGameSearch());
    Lobbies.Length = 0;
    LobbyInterface.AddFindLobbiesCompleteDelegate(OnFindLobbiesComplete);
    SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex"));
    GameType = LatestGameSearch.GameClass;
    // End:0x178
    if(SelectedIndex > 0)
    {
        Filters.Add(1);
        Filters[0].Key = "GAMETYPE";
        Filters[0].Value = Right(GameType, Len(GameType) - 9);
        Filters[0].Operator = 0;
    }
    LobbyInterface.FindLobbies(32, Filters);
    //return;    
}

function OnFindLobbiesComplete(bool bWasSuccessful, const out array<BasicLobbyInfo> LobbyList)
{
    local BasicLobbyInfo LobbyInfo;
    local LobbyMetaData LobbyData;

    // End:0x5A
    foreach LobbyList(LobbyInfo)
    {
        Lobbies.AddItem(LobbyInfo);
        // End:0x58
        foreach LobbyInfo.LobbySettings(LobbyData)
        {            
        }                
    }    
    LobbyInterface.ClearFindLobbiesCompleteDelegate(OnFindLobbiesComplete);
    LastSelectedSlot = 0;
    CurrentRowShift = 0;
    UpdateListDataProviderLobby();
    //return;    
}

final function DumpGameSearchData(OnlineGameSearch GameSearch)
{
    local int I, J, OutVal;
    local string LogStr;

    I = 0;
    J0x0B:

    // End:0x46 [Loop If]
    if(I < GameSearch.NamedProperties.Length)
    {
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x51:

    // End:0x99A [Loop If]
    if(I < GameSearch.FilterQuery.OrClauses.Length)
    {
        J = 0;
        J0x9C:

        // End:0x98C [Loop If]
        if(J < GameSearch.FilterQuery.OrClauses[I].OrParams.Length)
        {
            LogStr = ("----" @ string(J)) $ ": Name";
            // End:0x431
            if(int(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryType) == int(0))
            {                
                LogStr @= ("(property):" @ string(GameSearch.GetPropertyName(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)));                
                LogStr @= (("(p" $ string(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)) $ ")");                
                LogStr $= (", ColumnName:" @ GameSearch.GetPropertyColumnHeader(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId));                
                LogStr $= (", Value:" @ GameSearch.GetPropertyAsString(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId));                
            }
            else
            {
                // End:0x79F
                if(int(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryType) == int(1))
                {                    
                    LogStr @= ("(localized):" @ string(GameSearch.GetStringSettingName(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)));                    
                    LogStr @= (("(s" $ string(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)) $ ")");                    
                    LogStr $= (", ColumnName:" @ GameSearch.GetStringSettingColumnHeader(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId));
                    // End:0x75A
                    if(GameSearch.GetStringSettingValue(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId, OutVal))
                    {                        
                        LogStr $= (", Value:" @ string(OutVal));                        
                    }
                    else
                    {                        
                        LogStr $= ", Value: Unknown (failed to retrieve value)";
                    }                    
                }
                else
                {                    
                    LogStr @= ("(object)" @ string(GameSearch.FilterQuery.OrClauses[I].OrParams[J].ObjectPropertyName));                    
                    LogStr $= (", Value:" @ GameSearch.GetPropertyAsStringByName(GameSearch.FilterQuery.OrClauses[I].OrParams[J].ObjectPropertyName));
                }
            }            
            LogStr $= (", SortType:" @ string(GetEnum(Enum'Engine.OnlineGameSearch.EOnlineGameSearchComparisonType', int(GameSearch.FilterQuery.OrClauses[I].OrParams[J].ComparisonType))));
            ++J;
            // [Loop Continue]
            goto J0x9C;
        }
        ++I;
        // [Loop Continue]
        goto J0x51;
    }
    I = 0;
    J0x9A5:

    // End:0x10FE [Loop If]
    if(I < GameSearch.FilterQuery.SortClauses.Length)
    {
        LogStr = ("---" @ string(J)) $ ": Name";
        // End:0xC8B
        if(int(GameSearch.FilterQuery.SortClauses[I].EntryType) == int(0))
        {            
            LogStr @= ("(property):" @ string(GameSearch.GetPropertyName(GameSearch.FilterQuery.SortClauses[I].EntryId)));            
            LogStr @= (("(p" $ string(GameSearch.FilterQuery.SortClauses[I].EntryId)) $ ")");            
            LogStr $= (", ColumnName:" @ GameSearch.GetPropertyColumnHeader(GameSearch.FilterQuery.SortClauses[I].EntryId));            
            LogStr $= (", Value:" @ GameSearch.GetPropertyAsString(GameSearch.FilterQuery.SortClauses[I].EntryId));            
        }
        else
        {
            // End:0xF68
            if(int(GameSearch.FilterQuery.SortClauses[I].EntryType) == int(1))
            {                
                LogStr @= ("(localized):" @ string(GameSearch.GetStringSettingName(GameSearch.FilterQuery.SortClauses[I].EntryId)));                
                LogStr @= (("(s" $ string(GameSearch.FilterQuery.SortClauses[I].EntryId)) $ ")");                
                LogStr $= (", ColumnName:" @ GameSearch.GetStringSettingColumnHeader(GameSearch.FilterQuery.SortClauses[I].EntryId));
                // End:0xF23
                if(GameSearch.GetStringSettingValue(GameSearch.FilterQuery.SortClauses[I].EntryId, OutVal))
                {                    
                    LogStr $= (", Value:" @ string(OutVal));                    
                }
                else
                {                    
                    LogStr $= ", Value: Unknown (failed to retrieve value)";
                }                
            }
            else
            {                
                LogStr @= ("(object)" @ string(GameSearch.FilterQuery.SortClauses[I].ObjectPropertyName));                
                LogStr $= (", Value:" @ GameSearch.GetPropertyAsStringByName(GameSearch.FilterQuery.SortClauses[I].ObjectPropertyName));
            }
        }        
        LogStr $= (", SortType:" @ string(GetEnum(Enum'Engine.OnlineGameSearch.EOnlineGameSearchSortType', int(GameSearch.FilterQuery.SortClauses[I].SortType))));
        ++I;
        // [Loop Continue]
        goto J0x9A5;
    }
    //return;    
}

function ShiftServerListUp()
{
    // End:0x1C
    if(--CurrentRowShift < 0)
    {
        CurrentRowShift = 0;
    }
    RebuildServerList();
    //return;    
}

function ShiftServerListDown()
{
    // End:0x36
    if(++CurrentRowShift > (SteamServerList.Length - 11))
    {
        CurrentRowShift = SteamServerList.Length - 11;
    }
    RebuildServerList();
    //return;    
}

function SetServerListFocus(int CurrentSelectedSlot)
{
    ServersList[CurrentSelectedSlot].ServerListBtn.SetBool("focused", true);
    LastSelectedIndex = ServersList[CurrentSelectedSlot].GameSearchIndex;
    LastSelectedSlot = CurrentSelectedSlot;
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local int CurrentSelectedSlot;
    local PKUIManager UIManager;

    CurrentSelectedSlot = LastSelectedSlot;
    // End:0x158
    if(((int(InputEvent) == int(0)) && !bAutoShiftUp) && !bAutoShiftDown)
    {
        // End:0xF9
        if(ButtonName == 'MouseScrollDown')
        {
            // End:0xC6
            if((++CurrentSelectedSlot >= 11) || CurrentSelectedSlot >= SteamServerList.Length)
            {
                // End:0xB7
                if(SteamServerList.Length <= 11)
                {
                    CurrentSelectedSlot = SteamServerList.Length - 1;                    
                }
                else
                {
                    CurrentSelectedSlot = 11 - 1;
                }
            }
            // End:0xE3
            if(LastSelectedSlot == (11 - 1))
            {
                ShiftServerListDown();
            }
            SetServerListFocus(CurrentSelectedSlot);            
        }
        else
        {
            // End:0x158
            if(ButtonName == 'MouseScrollUp')
            {
                // End:0x12C
                if(--CurrentSelectedSlot < 0)
                {
                    CurrentSelectedSlot = 0;
                }
                // End:0x145
                if(LastSelectedSlot == 0)
                {
                    ShiftServerListUp();
                }
                SetServerListFocus(CurrentSelectedSlot);
            }
        }
    }
    // End:0x2CC
    if((((int(InputEvent) == int(0)) || int(InputEvent) == int(2)) && !bAutoShiftUp) && !bAutoShiftDown)
    {
        // End:0x242
        if(((((ButtonName == 'XboxTypeS_DPad_Down') || ButtonName == 'Gamepad_LeftStick_Down') || ButtonName == 'Down') && CurrentSelectedSlot == (11 - 1)) && CurrentRowShift < (SteamServerList.Length - 11))
        {
            ShiftServerListDown();
            SetServerListFocus(CurrentSelectedSlot);
            return true;            
        }
        else
        {
            // End:0x2CC
            if(((((ButtonName == 'XboxTypeS_DPad_Up') || ButtonName == 'Gamepad_LeftStick_Up') || ButtonName == 'Up') && CurrentSelectedSlot == 0) && CurrentRowShift > 0)
            {
                ShiftServerListUp();
                SetServerListFocus(CurrentSelectedSlot);
                return true;
            }
        }
    }
    // End:0x38A
    if((int(InputEvent) == int(0)) && SearchDataStore.HasOutstandingQueries())
    {
        // End:0x38A
        if(ButtonName == 'Escape')
        {
            UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
            // End:0x37D
            if(UIManager != none)
            {
                UIManager.CloseUpdatingScene(false);
            }
            CancelQuery();
            return true;
        }
    }
    return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    local float AutoShiftCurrentDelay;

    // End:0x2D
    if(AutoShiftTimeElapsed > AutoShiftSlowToFastDelay)
    {
        AutoShiftCurrentDelay = AutoShiftFastDelay;        
    }
    else
    {
        AutoShiftCurrentDelay = AutoShiftSlowDelay;
    }
    // End:0x10C
    if(bAutoShiftUp)
    {
        // End:0xF5
        if((Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds - AutoShiftLastTime) > AutoShiftCurrentDelay)
        {
            ShiftServerListUp();
            SetServerListFocus(LastSelectedSlot);
            AutoShiftLastTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
        }
        AutoShiftTimeElapsed += DeltaTime;        
    }
    else
    {
        // End:0x1F6
        if(bAutoShiftDown)
        {
            // End:0x1DF
            if(((Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds - AutoShiftLastTime) > AutoShiftCurrentDelay) && CurrentRowShift < (SteamServerList.Length - 11))
            {
                ShiftServerListDown();
                SetServerListFocus(LastSelectedSlot);
                AutoShiftLastTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
            }
            AutoShiftTimeElapsed += DeltaTime;            
        }
        else
        {
            AutoShiftTimeElapsed = 0.0000000;
        }
    }
    super.Tick(DeltaTime);
    //return;    
}

defaultproperties
{
    SearchDSName="PKGameSearch_Base"
    LastSelectedIndex=-1
    TitleString="Servers"
    GameTypeString="Game Type"
    ServersString="Server list"
    JoinString="Join server"
    RefreshString="Refresh list"
    LanInternetString="Only lan Games"
    SpectateString="Join As Spectator"
    AllGamesString="All games"
    ServerNameTxt="Server Name"
    PlayersTxt="Players"
    MapNameTxt="Map"
    GameTxt="Game"
    PingTxt="Ping"
    LatestSearchLenght=-1
    ForceSelectedIndex=-1
    AutoShiftSlowDelay=0.0500000
    AutoShiftFastDelay=0.0100000
    AutoShiftSlowToFastDelay=2.0000000
    MovieInfo=SwfMovie'PKHD_UI.PKMultiServers'
}