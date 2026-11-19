class UIScene_PandoraJoinMatch extends UIScene_NetworkScene;

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

var transient UIList ServerListUIObject;
var transient UILabel GameModeUIObject;
var transient UILabel ServerNameUIObject;
var transient UILabel MapNameUIObject;
var transient UILabel PublicSlotsUIObject;
var transient UILabel GameStatusUIObject;
var transient UIScene JoiningScene;
var transient UIDataStore_OnlineGameSearch SearchingDataStore;
var transient PandoraDMSearch_DataStore DMSearchDataStore;
var transient OnlineGameSearchResult SearchResult;
var const localized string SearchingString;
var transient int GameMode;
var transient int CurrListIndex;
var transient int NumGameResults;
var string NoMatchesFound_Title;
var string NoMatchesFound_Message;
var bool bUseCustomSearch;
var bool bSearchInProgress;
var bool bIngoreInput;
var UIScene_SearchMatch SearchMatch;
var UIScene_ConfirmationDialog SearchingMsgBox;
var SPUIButtonBar bbHelperText;
var IntPoint LastMousePos;

function GameJoinDone(bool bWasSuccessful)
{
    local string URL, PCLANProfileName;

    // End:0x236
    if(bWasSuccessful)
    {
        // End:0x236
        if((myPC.OnlineSub != none) && NotEqual_InterfaceInterface(myPC.OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            // End:0x20C
            if(myPC.OnlineSub.GameInterface.GetResolvedConnectString(URL))
            {
                // End:0x199
                if(IsPCBuild())
                {
                    // End:0x12F
                    if(myGameInfo.bLanMatch)
                    {
                        myPC.ProfileSettings.GetSavedLocalPlayerName(PCLANProfileName);                        
                        myPC.ConsoleCommand((("open " $ URL) $ "?GameType=PandoraGameContent.PandoraMonsterMachine?Team=255?Name=") $ PCLANProfileName);                        
                    }
                    else
                    {                        
                        myPC.ConsoleCommand(("open " $ URL) $ "?GameType=PandoraGameContent.PandoraMonsterMachine?Team=255");
                    }                    
                }
                else
                {                    
                    myPC.ConsoleCommand(("open " $ URL) $ "?GameType=PandoraGameContent.PandoraMonsterMachine?Team=255?Name=Player");
                }
            }
            myPC.OnlineSub.GameInterface.FreeSearchResults();
        }
    }
    SearchingDataStore.GameInterface.ClearJoinOnlineGameCompleteDelegate(GameJoinDone);
    //return;    
}

function bool CBCheckSearching()
{
    // End:0x0B
    if(bSearchInProgress)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnSearchComplete(bool bWasSuccessful)
{
    local OnlineGameSearch GameSearch;

    NumGameResults = DMSearchDataStore.GameSearchCfgList[DMSearchDataStore.ActiveSearchIndex].SearchResults.Length;
    GameSearch = SearchingDataStore.GetCurrentGameSearch();
    // End:0x75
    if(GameSearch.bIsSearchInProgress && myGameInfo.bLanMatch)
    {
        return;
    }
    SearchingDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
    // End:0xE8
    if(bWasSuccessful == true)
    {
        // End:0xCC
        if(NumGameResults > 0)
        {
            CurrHelperText.SetVisibility(true);            
        }
        else
        {
            ShowMsgBox(NoMatchesFound_Message, NoMatchesFound_Title);
        }        
    }
    SetColumnHeaders();
    bSearchInProgress = false;
    //return;    
}

function SearchingKeyResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x24
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        return;
    }
    // End:0x51
    if(SearchingMsgBox != none)
    {
        SearchingMsgBox.CloseScene(SearchingMsgBox);
        SearchingMsgBox = none;
    }
    // End:0xA8
    if(int(eReturnValue) != int(4))
    {
        myGameInfo.GameInterface.CancelFindOnlineGames();
        myGameInfo.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
    }
    bSearchInProgress = false;
    // End:0x13F
    if(int(eReturnValue) == int(2))
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.searchcanceledmsg>", "<Strings:PandoraGame.ErrorMessages.searchcanceledtitle>");
    }
    // End:0x175
    if((int(eReturnValue) == int(3)) && NumGameResults == 0)
    {
        ShowMsgBox(NoMatchesFound_Message, NoMatchesFound_Title);
    }
    //return;    
}

function PerformSearch()
{
    local PandoraDMOnlineGameSearch currSearch;
    local int nTimeout;

    // End:0x150
    if(bUseCustomSearch)
    {
        DMSearchDataStore = PandoraDMSearch_DataStore(SceneClient.DataStoreManager.FindDataStore('PandoraGameDMSearch'));
        DMSearchDataStore.SetCurrentByIndex(1);
        SearchingDataStore = UIDataStore_OnlineGameSearch(ServerListUIObject.DataSource.ResolvedDataStore);
        SearchingDataStore.GameInterface.AddFindOnlineGamesCompleteDelegate(OnSearchComplete);
        currSearch = PandoraDMOnlineGameSearch(SearchingDataStore.GetCurrentGameSearch());
        currSearch.bIsLanQuery = myGameInfo.bLanMatch;
        currSearch.bUsesArbitration = myGameInfo.bUsesArbitration;
        currSearch.SetStringSettingValue(32779, GameMode, false);
        SearchMatch.AssignSearchCriteria(DMSearchDataStore);
        SearchMatch.AssignGameSearch(currSearch);        
    }
    else
    {
        DMSearchDataStore = PandoraDMSearch_DataStore(SceneClient.DataStoreManager.FindDataStore('PandoraGameDMSearch'));
        DMSearchDataStore.SetCurrentByIndex(0);
        SearchingDataStore = UIDataStore_OnlineGameSearch(ServerListUIObject.DataSource.ResolvedDataStore);
        SearchingDataStore.GameInterface.AddFindOnlineGamesCompleteDelegate(OnSearchComplete);
        currSearch = PandoraDMOnlineGameSearch(SearchingDataStore.GetCurrentGameSearch());
        currSearch.bIsLanQuery = myGameInfo.bLanMatch;
        currSearch.bUsesArbitration = myGameInfo.bUsesArbitration;
        currSearch.SetStringSettingValue(32779, GameMode, false);
        DMSearchDataStore.ResetSearchCriteria();
    }
    // End:0x2B6
    if(GetWorldInfo().IsConsoleBuild(1))
    {
        currSearch.LocalizedSettingsMappings.Remove(4, 1);
        currSearch.LocalizedSettings.Remove(4, 1);
    }
    DMSearchDataStore.bSkipBuildSearchResults = false;
    DMSearchDataStore.SubmitGameSearch(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(GetPC().GetUIPlayerIndex())));
    bSearchInProgress = true;
    // End:0x353
    if(GetWorldInfo().IsConsoleBuild(1))
    {
        // End:0x348
        if(currSearch.bIsLanQuery)
        {
            nTimeout = 3;            
        }
        else
        {
            nTimeout = 10;
        }        
    }
    else
    {
        nTimeout = 15;
    }
    // End:0x41A
    if(currSearch.bIsLanQuery)
    {
        SearchingMsgBox = ShowMsgBox("<Strings:PandoraGame.UIScene_MatchSetup.SearchingString>", "<Strings:PandoraGame.UIScene_PandoraJoinMatch.SearchingStringTitle>", 4, SearchingKeyResults, CBCheckSearching, nTimeout);        
    }
    else
    {
        SearchingMsgBox = ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraJoinMatch.SearchingString>", "<Strings:PandoraGame.UIScene_PandoraJoinMatch.SearchingStringTitle>", 4, SearchingKeyResults, CBCheckSearching, nTimeout);
    }
    // End:0x519
    if(GameMode == 0)
    {
        GameModeUIObject.SetDataStoreBinding("<Strings:PandoraGame.OnlineGameType.DeathMatch>");        
    }
    else
    {
        GameModeUIObject.SetDataStoreBinding("<Strings:PandoraGame.OnlineGameType.TeamDeathMatch>");
    }
    ServerListUIObject.RefreshSubscriberValue(-1);
    SetColumnHeaders();
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    super(UIScene_BaseFrontEnd).SceneActivated(bInitialActivation);
    CurrListIndex = 0;
    bIngoreInput = false;
    // End:0x28
    if(!bInitialActivation)
    {
        return;
    }
    ServerListUIObject = UIList(FindChild('lstServer', true));
    GameModeUIObject = UILabel(FindChild('lblGameMode', true));
    ServerNameUIObject = UILabel(FindChild('Title_1', true));
    MapNameUIObject = UILabel(FindChild('Title_2', true));
    PublicSlotsUIObject = UILabel(FindChild('Title_3', true));
    GameStatusUIObject = UILabel(FindChild('Title_4', true));
    ServerListUIObject.EnableColumnHeaderRendering(false);
    ServerListUIObject.bAllowColumnResizing = false;
    ServerListUIObject.SetHotTracking(true);
    ServerNameUIObject.SetDataStoreBinding(PlatformStrings $ "UIScene_PandoraJoinMatch.OwningPlayerName>");
    ServerNameUIObject.SetVisibility(true);
    MapNameUIObject.SetDataStoreBinding(PlatformStrings $ "UIScene_PandoraJoinMatch.CustomMapName>");
    MapNameUIObject.SetVisibility(true);
    PublicSlotsUIObject.SetDataStoreBinding(PlatformStrings $ "UIScene_PandoraJoinMatch.PlayerRatio>");
    PublicSlotsUIObject.SetVisibility(true);
    GameStatusUIObject.SetDataStoreBinding(PlatformStrings $ "UIScene_PandoraJoinMatch.GameStatus>");
    GameStatusUIObject.SetVisibility(true);
    PerformSearch();
    bbHelperText = SPUIButtonBar(FindChild('lblHelperText', true));
    // End:0x2CA
    if(IsSystemLinkMatch())
    {
        bbHelperText.SetDataStoreBinding(PlatformStrings $ "HelperText.SelectRefreshBackBarSysLink>");        
    }
    else
    {
        bbHelperText.SetDataStoreBinding(PlatformStrings $ "HelperText.SelectRefreshBackBar>");
    }
    ServerListUIObject.ActivateStateByClass(Class'Engine.UIState_Active', 0);
    //return;    
}

event SceneDeactivated()
{
    super(UIScene_BaseFrontEnd).SceneDeactivated();
    //return;    
}

function SetColumnHeaders()
{
    local string sTemp;

    Class'Engine.UIRoot'.static.GetDataStoreStringValue(PlatformStrings $ "UIScene_PandoraJoinMatch.OwningPlayerName>", sTemp);
    SetUlistHeaders(ServerListUIObject, name("OwningPlayerName"), sTemp, 0);
    Class'Engine.UIRoot'.static.GetDataStoreStringValue(PlatformStrings $ "UIScene_PandoraJoinMatch.CustomMapName>", sTemp);
    SetUlistHeaders(ServerListUIObject, name("CustomMapName"), sTemp, 1);
    Class'Engine.UIRoot'.static.GetDataStoreStringValue(PlatformStrings $ "UIScene_PandoraJoinMatch.PlayerRatio>", sTemp);
    SetUlistHeaders(ServerListUIObject, name("PlayerRatio"), sTemp, 2);
    Class'Engine.UIRoot'.static.GetDataStoreStringValue(PlatformStrings $ "UIScene_PandoraJoinMatch.GameStatus>", sTemp);
    SetUlistHeaders(ServerListUIObject, name("GameStatus"), sTemp, 3);
    //return;    
}

function bool CBCheckNotJoined()
{
    return true;
    //return ReturnValue;    
}

function CBResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x24
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        return;
    }
    // End:0x51
    if(JoiningScene != none)
    {
        JoiningScene.CloseScene(JoiningScene);
        JoiningScene = none;
    }
    SearchingDataStore.GameInterface.CancelFindOnlineGames();
    SearchingDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnUpdateComplete);
    // End:0x10B
    if(int(eReturnValue) != int(4))
    {        
        myPC.ConsoleCommand("cancel");
        SceneClient.CloseScene(self);
        PreviousMenuScene.SetVisibility(true);
        PreviousMenuScene.FadeIn(fadeInTimeEd);
    }
    // End:0x1A6
    if(int(eReturnValue) == int(3))
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.jointimeoutmsg>", "<Strings:PandoraGame.ErrorMessages.jointimeouttitle>", 0, DlgReturnToMainMenu, None, 0, 6);
    }
    // End:0x231
    if(int(eReturnValue) == int(2))
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.joincanceledmsg>", "<Strings:PandoraGame.ErrorMessages.joincanceledtitle>");
    }
    myPC.DestroySession();
    //return;    
}

simulated function DlgReturnToMainMenu(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x12
    if(int(eReturnValue) == int(4))
    {
        return;
    }
    myPC.DestroySession();
    myPC.ClientTravel("pandorastart", 0);
    //return;    
}

function OnUpdateComplete(bool bWasSuccessful)
{
    SearchingDataStore.GameInterface.CancelFindOnlineGames();
    SearchingDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnUpdateComplete);
    SearchingDataStore.GameInterface.AddJoinOnlineGameCompleteDelegate(GameJoinDone);
    SearchingDataStore.GameInterface.JoinOnlineGame(byte(LocPlayer.ControllerId), SearchResult);
    //return;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    local SPGameUISceneClient SPSceneClient;

    super(UIScene_BaseFrontEnd).UpdateScene(DeltaTime, WorldInfo);
    // End:0xD7
    if(!WorldInfo.IsConsoleBuild())
    {
        SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
        // End:0xD7
        if((LastMousePos.X != SPSceneClient.MousePosition.X) || LastMousePos.Y != SPSceneClient.MousePosition.Y)
        {
            LastMousePos = SPSceneClient.MousePosition;
            ServerListUIObject.ActivateStateByClass(Class'Engine.UIState_Active', 0);
            MouseIsOverMenuButton();
        }
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    local SPUIDataProvider_SearchResult Provider;

    UpDateUsingGamePadForPC(EventParms);
    // End:0x1A
    if(bIngoreInput)
    {
        return true;
    }
    Provider = SPUIDataProvider_SearchResult(DMSearchDataStore.GameSearchCfgList[DMSearchDataStore.ActiveSearchIndex].SearchResults[CurrListIndex]);
    // End:0xCC
    if(IsInputAltAccept(EventParms))
    {
        PlayUISound('Clicked');
        // End:0xA6
        if(!SearchingDataStore.GetSearchResultFromIndex(Provider.SB_Index, SearchResult))
        {
            return true;
        }
        ShowGamerCardByUID(SearchResult.GameSettings.OwningPlayerId);
        return true;
    }
    // End:0x139
    if(IsInputAlt2Accept(EventParms))
    {
        bSearchInProgress = false;
        SearchingDataStore.GameInterface.CancelFindOnlineGames();
        SearchingDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
        PerformSearch();
        return true;
    }
    // End:0x194
    if(IsInputNavUp(EventParms))
    {
        PlayUISound('ListUp');
        CurrListIndex--;
        // End:0x17B
        if(CurrListIndex < 0)
        {
            CurrListIndex = NumGameResults - 1;
        }
        ServerListUIObject.SetIndex(CurrListIndex);
        return true;
    }
    // End:0x1EC
    if(IsInputNavDown(EventParms))
    {
        PlayUISound('ListDown');
        CurrListIndex++;
        // End:0x1D3
        if(CurrListIndex >= NumGameResults)
        {
            CurrListIndex = 0;
        }
        ServerListUIObject.SetIndex(CurrListIndex);
        return true;
    }
    // End:0x408
    if(IsInputAccept(EventParms))
    {
        // End:0x406
        if(NumGameResults > 0)
        {
            PlayUISound('Clicked');
            Provider = SPUIDataProvider_SearchResult(DMSearchDataStore.GameSearchCfgList[DMSearchDataStore.ActiveSearchIndex].SearchResults[CurrListIndex]);
            // End:0x406
            if(SearchingDataStore.GetSearchResultFromIndex(Provider.SB_Index, SearchResult))
            {
                bIngoreInput = true;
                SearchingDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
                JoiningScene = ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraJoinMatch.ConnectingMessage>", "<Strings:PandoraGame.UIScene_PandoraJoinMatch.Connectingtitle>", 4, CBResults, CBCheckNotJoined, 30);
                DMSearchDataStore.bSkipBuildSearchResults = true;
                SearchingDataStore.GameInterface.AddFindOnlineGamesCompleteDelegate(OnUpdateComplete);
                SearchingDataStore.GameInterface.QueryNonAdvertisedData(SearchResult.GameSettings.SB_Index, 1);
                // End:0x406
                if(GetWorldInfo().IsConsoleBuild(1) || myGameInfo.bLanMatch)
                {
                    OnUpdateComplete(true);
                }
            }
        }
        return true;
    }
    // End:0x4C8
    if((IsInputCancel(EventParms)) || IsInputEscape(EventParms))
    {
        // End:0x4C6
        if(PreviousMenuScene != none)
        {
            SearchingDataStore.GameInterface.CancelFindOnlineGames();
            PlayUISound('SceneClosed');
            SearchingDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
            ActivateRemoteEvent(OnExitRemoteEventName);
            SceneClient.CloseScene(self);
            PreviousMenuScene.SetVisibility(true);
        }
        return true;
    }
    return super(UIScene_BaseFrontEnd).CustomInputKey(EventParms);
    //return ReturnValue;    
}

function bool MouseIsOverMenuButton()
{
    local int MouseIndex;

    MouseIndex = ServerListUIObject.CalculateIndexFromCursorLocation();
    // End:0x4E
    if(MouseIndex > -1)
    {
        CurrListIndex = MouseIndex;
        ServerListUIObject.SetIndex(CurrListIndex);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
    SceneClient.CloseScene(self);
    //return;    
}
