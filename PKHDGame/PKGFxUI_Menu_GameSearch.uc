class PKGFxUI_Menu_GameSearch extends PKGFxUI_Menu_Base
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

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget JoinBtn;
var GFxClikWidget SearchBtn;
var GFxClikWidget MapImage;
var GFxObject Steps[4];
var GFxObject StepsTF[4];
var GFxObject MapNameTF;
var GFxObject GameTypeTF;
var GFxObject PlayersTF;
var GFxObject HostnameTF;
var const localized string TitleString;
var const localized string JoinString;
var const localized string SearchString;
var const localized string MapName;
var const localized string GameType;
var const localized string Players;
var const localized string Hostname;
var transient PKDataStore_GameSearch SearchDataStore;
var const transient name SearchDSName;
var transient array<OnlineGameSearchResult> ServerInfoList;
var transient OnlineSubsystem OnlineSub;
var transient OnlineGameInterface GameInterface;
var transient OnlineAuthInterface AuthInterface;
var transient int LastSelectedIndex;
var int LatestSearchLenght;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    JoinBtn = GFxClikWidget(ButtonsMC.GetObject("join_btn", Class'GFxUI.GFxClikWidget'));
    SearchBtn = GFxClikWidget(ButtonsMC.GetObject("search_btn", Class'GFxUI.GFxClikWidget'));
    MapImage = GFxClikWidget(ButtonsMC.GetObject("mapgfx", Class'GFxUI.GFxClikWidget'));
    Steps[0] = ButtonsMC.GetObject("step1");
    StepsTF[0] = Steps[0].GetObject("status").GetObject("textField");
    Steps[1] = ButtonsMC.GetObject("step2");
    StepsTF[1] = Steps[1].GetObject("status").GetObject("textField");
    Steps[2] = ButtonsMC.GetObject("step3");
    StepsTF[2] = Steps[2].GetObject("status").GetObject("textField");
    Steps[3] = ButtonsMC.GetObject("step4");
    StepsTF[3] = Steps[3].GetObject("status").GetObject("textField");
    MapNameTF = ButtonsMC.GetObject("mapname").GetObject("textField");
    GameTypeTF = ButtonsMC.GetObject("gametype").GetObject("textField");
    PlayersTF = ButtonsMC.GetObject("playersnumber").GetObject("textField");
    HostnameTF = ButtonsMC.GetObject("hostname").GetObject("textField");
    TitleTF.SetText(TitleString);
    JoinBtn.SetString("label", JoinString);
    SearchBtn.SetString("label", SearchString);
    MapNameTF.SetText(MapName);
    GameTypeTF.SetText(GameType);
    PlayersTF.SetText(Players);
    HostnameTF.SetText(Hostname);
    InitSearchSubs();
    SearchAnotherServer();
    UpdatePartyWindowShouldDisplay();
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

function UpdatePartyWindowShouldDisplay()
{
    // End:0x60
    if(((GetMenuGame()) != none) && int(GetMenuGame().MultiGameModeSelected) == int(5))
    {
        bCanOpenPartyMenu = false;
        bCanOpenChangePartyType = false;
        bDisplayPartyWindow = false;
    }
    //return;    
}

function OnBack(EventData ev)
{
    // End:0x4C
    if(int(GetMenuGame().MultiGameModeSelected) == int(5))
    {
        GetMenuGRI().CurrentPartyType = 2;
    }
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnJoinBtn(EventData ev)
{
    TryToJoin();
    //return;    
}

function OnSearchBtn(EventData ev)
{
    SearchAnotherServer();
    //return;    
}

final function ShowJoinErrorMsg()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x126
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');
        UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "InviteJoinFailed_Title", "PKHDGame"), Localize("KGFxUI_PreGameLobby", "UnableToJoinGameString", "PKHDGame"), ButtonAliases, None,,,,, false, false);
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

function TryToJoin()
{
    local OnlineGameSearchResult GameToJoin;

    JoinBtn.SetBool("disabled", true);
    // End:0x18A
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        // End:0x17D
        if((LastSelectedIndex >= 0) && SearchDataStore.GetSearchResultFromIndex(LastSelectedIndex, GameToJoin))
        {
            // End:0x166
            if(GameToJoin.GameSettings != none)
            {
                GameInterface.DestroyOnlineGame('Game');
                GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
                // End:0x163
                if(!GameInterface.JoinOnlineGame(byte(GetLP().ControllerId), 'Game', GameToJoin))
                {
                }                
            }
            else
            {
                OnJoinGameComplete('Game', false);
            }            
        }
        else
        {
            ShowJoinErrorMsg();
        }        
    }
    JoinBtn.SetBool("disabled", false);
    //return;    
}

function SearchAnotherServer()
{
    SetGameSearch();
    RefreshServerList();
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x157
        case "back":
            switch(GetMenuGame().MultiGameModeSelected)
            {
                // End:0x99
                case 5:
                    GetMenuGame().MultiGameModeSelected = 0;
                    bTransitionResult = FrontEnd.OpenCampaignCoopScreen();
                    // End:0x154
                    break;
                // End:0xCB
                case 0:
                    bTransitionResult = FrontEnd.OpenMultiMenuXboxScreen();
                    // End:0x154
                    break;
                // End:0xFFFF
                default:
                    bTransitionResult = FrontEnd.OpenMultiMenuXboxCreateJoinScreen(Class'PKGFxUI_Menu_MultiHost'.default.SupportedGameTypes[int(GetMenuGame().MultiGameModeSelected) - int(1)].Typename);
                    // End:0x154
                    break;
                    break;
            }
            // End:0x169
            break;
        // End:0x163
        case "join":
            // End:0x169
            break;
        // End:0xFFFF
        default:
            // End:0x169
            break;
            break;
    }
    // End:0x195
    if(bTransitionResult)
    {
        FrontEnd.CloseGameSearchScreen();
    }
    Action = "";
    //return;    
}

function InitSearchSubs()
{
    local DataStoreClient DSClient;

    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x74
    if(DSClient != none)
    {
        SearchDataStore = PKDataStore_GameSearch(DSClient.FindDataStore(SearchDSName));
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xFC
    if(OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        AuthInterface = OnlineSub.AuthInterface;
    }
    //return;    
}

function Cleanup()
{
    local PKGameMenu MenuGame;

    // End:0x51
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    }
    // End:0x7F
    if(SearchDataStore != none)
    {
        SearchDataStore.ClearAllSearchResults();
    }
    MenuGame = PKGameMenu(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    // End:0xF4
    if(MenuGame != none)
    {
        MenuGame.CleanupGameSearchRefreshing();
    }
    //return;    
}

function RefreshServerList(optional int MaxResults = 25)
{
    local OnlineGameSearch GameSearch;
    local int ValueIndex;

    // End:0x18B
    if(!SearchDataStore.HasOutstandingQueries())
    {
        GameSearch = SearchDataStore.GetCurrentGameSearch();
        GameSearch.MaxSearchResults = MaxResults;
        ValueIndex = 1;
        switch(ValueIndex)
        {
            // End:0xE4
            case 2:
                GameSearch.bIsLanQuery = false;
                GameSearch.bUsesArbitration = true;
                // End:0x130
                break;
            // End:0x12D
            case 1:
                GameSearch.bIsLanQuery = false;
                GameSearch.bUsesArbitration = false;
                // End:0x130
                break;
            // End:0xFFFF
            default:
                break;
        }
        DumpGameSearchData(GameSearch);
        SubmitServerListQuery(Class'Engine.UIInteraction'.static.GetPlayerIndex(GetLP().ControllerId));
    }
    //return;    
}

function SubmitServerListQuery(int PlayerIndex)
{
    local OnlineGameSearch GameSearch;

    GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    GameSearch = SearchDataStore.GetCurrentGameSearch();
    SearchDataStore.InvalidateCurrentSearchResults();
    // End:0x102
    if(!GameInterface.FindOnlineGames(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex)), GameSearch))
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    }
    //return;    
}

function OnFindOnlineGamesCompleteDelegate(bool bWasSuccessful)
{
    local bool bSearchCompleted;

    bSearchCompleted = !SearchDataStore.HasOutstandingQueries();
    // End:0x75
    if(bSearchCompleted)
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
        UpdateServerData();
    }
    //return;    
}

function OnJoinGameComplete(name SessionName, bool bSuccessful)
{
    local string URL;

    // End:0x105
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        // End:0x9E
        if(bSuccessful)
        {
            Cleanup();
            // End:0x9B
            if(GameInterface.GetResolvedConnectString('Game', URL))
            {
                URL = "open " $ URL;
                ConsoleCommand(URL);
            }            
        }
        else
        {
            GameInterface.DestroyOnlineGame('Game');
            ShowConnectionErrorMsg();
        }
        GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinGameComplete);        
    }
    else
    {
        ShowJoinErrorMsg();
    }
    //return;    
}

function UpdateServerData()
{
    local OnlineGameSearch LatestGameSearch;
    local string sMapName, sGameType, sPlayers, sHostname;
    local array<name> ButtonAliases;

    LatestGameSearch = SearchDataStore.GetCurrentGameSearch();
    // End:0x13F
    if(LatestGameSearch.Results.Length <= 0)
    {
        ButtonAliases.AddItem('GenericAccept');
        PKUIManager(Class'Engine.UIManager'.static.GetUIManager()).ShowUIMessage('NoGamesFound', Localize("KGFxUI_PreGameLobby", "LookingForMatch", "PKHDGame"), Localize("KGFxUI_PreGameLobby", "NoGamesFoundString", "PKHDGame"), ButtonAliases,, GetLP());
        return;
    }
    LastSelectedIndex++;
    // End:0x182
    if(LastSelectedIndex >= LatestGameSearch.Results.Length)
    {
        LastSelectedIndex = 0;
    }
    sMapName = LatestGameSearch.Results[LastSelectedIndex].GameSettings.GetPropertyAsString(1073741825);
    sPlayers = (string(LatestGameSearch.Results[LastSelectedIndex].GameSettings.NumPublicConnections - LatestGameSearch.Results[LastSelectedIndex].GameSettings.NumOpenPublicConnections) $ "/") $ string(LatestGameSearch.Results[LastSelectedIndex].GameSettings.NumPublicConnections);
    sGameType = LatestGameSearch.Results[LastSelectedIndex].GameSettings.GetPropertyAsString(1073741826);
    sGameType = Right(sGameType, 22);
    sGameType = Left(sGameType, Len(sGameType) - 8);
    sHostname = LatestGameSearch.Results[LastSelectedIndex].GameSettings.OwningPlayerName;
    MapNameTF.SetText(sMapName);
    GameTypeTF.SetText(sGameType);
    PlayersTF.SetText(sPlayers);
    HostnameTF.SetText(sHostname);
    //return;    
}

function SetGameSearch(optional int ForceSelectedIndex = -1)
{
    local int I, SelectedIndex;

    // End:0x2E
    if(ForceSelectedIndex >= 0)
    {
        SelectedIndex = ForceSelectedIndex;        
    }
    else
    {
        SelectedIndex = int(GetMenuGame().MultiGameModeSelected);
    }
    switch(SelectedIndex)
    {
        // End:0xA5
        case 1:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchDeathmatch');
            // End:0x1C9
            break;
        // End:0xDF
        case 2:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchTeamDeathmatch');
            // End:0x1C9
            break;
        // End:0x119
        case 3:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchCTF');
            // End:0x1C9
            break;
        // End:0x153
        case 4:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchSurvival');
            // End:0x1C9
            break;
        // End:0x18D
        case 5:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchCoop');
            // End:0x1C9
            break;
        // End:0x191
        case 0:
        // End:0xFFFF
        default:
            I = SearchDataStore.FindSearchConfigurationIndex('PKGameSearchCustom');
            // End:0x1C9
            break;
            break;
    }
    // End:0x208
    if(I != -1)
    {
        SearchDataStore.SetCurrentByIndex(I, true);        
    }
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

defaultproperties
{
    TitleString="Matchmaking"
    JoinString="Join Game"
    SearchString="Search Other Game"
    MapName="Map Name:"
    GameType="Game Type:"
    Players="Players:"
    Hostname="Host Name:"
    SearchDSName="PKGameSearch_Base"
    bCanOpenPartyMenu=true
    bCanOpenChangePartyType=true
    bDisplayPartyWindow=true
    MovieInfo=SwfMovie'PKHD_UI.PKGameSearch'
}