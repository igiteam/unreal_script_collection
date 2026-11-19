class UIScene_MatchSetup extends UIScene_NetworkScene;

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

var const localized string SearchingString;
var transient PandoraDMSearch_DataStore DMSearchDataStore;
var OnlineGameSearchResult SearchResult;
var OnlineGameSearch Search;
var UIScene_ConfirmationDialog SearchingMsgBox;
var transient int GameMode;
var transient int NumGameResults;
var string NoMatchesFound_Title;
var string NoMatchesFound_Message;
var bool bBeingRestored;

function bool CBCheckNotLoggedin()
{
    local OnlineSubsystem.ELoginStatus eResult;

    eResult = GetLoginStatus(LocPlayer.ControllerId);
    // End:0x31
    if(int(eResult) != int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CBResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x126
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        // End:0x126
        if((GetWorldInfo().IsConsoleBuild() && !myGameInfo.bLanMatch) && int(GetLoginStatus(LocPlayer.ControllerId)) == int(2))
        {
            // End:0x126
            if(!HasOnlinePrivledges())
            {
                SceneClient.CloseScene(self);
                PreviousMenuScene.SetVisibility(true);
                PreviousMenuScene.FadeIn(fadeInTimeEd);
                ShowMsgBox(PlatformStrings $ "ErrorMessages.NoPrivileges>", PlatformStrings $ "ErrorMessages.NoPrivilegesTitle>");
                return;
            }
        }
    }
    // End:0x15C
    if(((int(eReturnValue) == int(4)) || int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        return;
    }
    SceneClient.CloseScene(self);
    PreviousMenuScene.SetVisibility(true);
    PreviousMenuScene.FadeIn(fadeInTimeEd);
    //return;    
}

function Restore()
{
    bBeingRestored = true;
    super(UIScene_BaseFrontEnd).Restore();
    //return;    
}

event InitScene()
{
    bBeingRestored = false;
    super(UIScene_BaseFrontEnd).InitScene();
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    super(UIScene_BaseFrontEnd).SceneActivated(bInitialActivation);
    // End:0x19
    if(myGameInfo == none)
    {
        return;
    }
    SearchingMsgBox = none;
    // End:0x103
    if(!bBeingRestored)
    {
        // End:0x103
        if(!GetWorldInfo().IsConsoleBuild(1) && !myGameInfo.bLanMatch)
        {
            // End:0x103
            if(int(GetLoginStatus(LocPlayer.ControllerId)) != int(2))
            {
                ShowMsgBox(PlatformStrings $ "OnlineGameType.ConnectingMessage>", "<Strings:PandoraGame.OnlineGameType.ConnectingTitle>", 4, CBResults, CBCheckNotLoggedin, 30);
            }
        }
    }
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    // End:0x0D
    if(myGameInfo == none)
    {
        return;
    }
    // End:0x3A
    if(MenuIndex == (MenuIndexByName("btnQuickMatch")))
    {
        JoinFirstOnlineGame();
    }
    //return;    
}

function bool PreOnClick(int MenuIndex)
{
    // End:0xF3
    if(GetWorldInfo().IsConsoleBuild(1))
    {
        // End:0xF3
        if((!GetPC().InLANGameOrMenu() && int(GetNATType()) == int(3)) && MenuIndex == (MenuIndexByName("btnCreateMatch")))
        {
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.StrictNAT_Message>", "<Strings:PandoraGame.ErrorMessages.StrictNAT_Title>", 0);
            return false;
        }
    }
    return super(UIScene_BaseFrontEnd).PreOnClick(MenuIndex);
    //return ReturnValue;    
}

function QuickMatchResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x24
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        return;
    }
    myGameInfo.GameInterface.CancelFindOnlineGames();
    myGameInfo.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
    // End:0x7D
    if(int(eReturnValue) == int(4))
    {
        return;
    }
    // End:0x8F
    if(int(eReturnValue) == int(3))
    {
        return;
    }
    // End:0x11E
    if(int(eReturnValue) == int(2))
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.searchcanceledmsg>", "<Strings:PandoraGame.ErrorMessages.searchcanceledtitle>");
    }
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

function bool JoinFirstOnlineGame()
{
    local PandoraDMOnlineGameSearch currSearch;
    local int nTime;

    // End:0x0D
    if(myGameInfo == none)
    {
        return false;
    }
    DMSearchDataStore = PandoraDMSearch_DataStore(SceneClient.DataStoreManager.FindDataStore('PandoraGameDMSearch'));
    DMSearchDataStore.SetCurrentByIndex(1);
    DMSearchDataStore.GameInterface.AddFindOnlineGamesCompleteDelegate(OnSearchComplete);
    currSearch = PandoraDMOnlineGameSearch(DMSearchDataStore.GetCurrentGameSearch());
    currSearch.bIsLanQuery = myGameInfo.bLanMatch;
    currSearch.bUsesArbitration = myGameInfo.bUsesArbitration;
    currSearch.SetStringSettingValue(32779, GameMode, false);
    currSearch.SetStringSettingValue(0, 0, false);
    currSearch.SetStringSettingValue(1, 0, false);
    currSearch.SetStringSettingValue(3, 0, false);
    DMSearchDataStore.ResetSearchCriteria();
    // End:0x194
    if(GetWorldInfo().IsConsoleBuild(1))
    {
        currSearch.LocalizedSettingsMappings.Remove(4, 1);
        currSearch.LocalizedSettings.Remove(4, 1);
    }
    DMSearchDataStore.bSkipBuildSearchResults = false;
    DMSearchDataStore.SubmitGameSearch(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(GetPC().GetUIPlayerIndex())));
    nTime = 30;
    // End:0x22E
    if(currSearch.bIsLanQuery)
    {
        // End:0x226
        if(GetWorldInfo().IsConsoleBuild(1))
        {
            nTime = 3;            
        }
        else
        {
            nTime = 10;
        }
    }
    SearchingMsgBox = ShowMsgBox("<Strings:PandoraGame.UIScene_MatchSetup.SearchingString>", "<Strings:PandoraGame.UIScene_MatchSetup.SearchingStringTitle>", 4, QuickMatchResults, None, nTime);
    return true;
    //return ReturnValue;    
}

function bool CBCheckNotJoined()
{
    return true;
    //return ReturnValue;    
}

function CBJoinedResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x24
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        return;
    }
    DMSearchDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnUpdateComplete);
    DMSearchDataStore.GameInterface.CancelFindOnlineGames();
    // End:0xF2
    if(int(eReturnValue) != int(4))
    {        
        myPC.ConsoleCommand("cancel");
        myPC.DestroySession();
        SceneClient.CloseScene(self);
        PreviousMenuScene.SetVisibility(true);
        PreviousMenuScene.FadeIn(fadeInTimeEd);
    }
    // End:0x18D
    if(int(eReturnValue) == int(3))
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.jointimeoutmsg>", "<Strings:PandoraGame.ErrorMessages.jointimeouttitle>", 0, DlgReturnToMainMenu, None, 0, 6);
    }
    // End:0x218
    if(int(eReturnValue) == int(2))
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.joincanceledmsg>", "<Strings:PandoraGame.ErrorMessages.joincanceledtitle>");
    }
    //return;    
}

function OnUpdateComplete(bool bWasSuccessful)
{
    Search = DMSearchDataStore.GetCurrentGameSearch();
    // End:0x44
    if(Search.bIsSearchInProgress && myGameInfo.bLanMatch)
    {
        return;
    }
    DMSearchDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnUpdateComplete);
    DMSearchDataStore.GameInterface.CancelFindOnlineGames();
    DMSearchDataStore.GameInterface.AddJoinOnlineGameCompleteDelegate(GameJoinDone);
    DMSearchDataStore.GameInterface.JoinOnlineGame(byte(LocPlayer.ControllerId), SearchResult);
    // DebugMode: 0
    assert(false);
    //return;    
}

function OnSearchComplete(bool bWasSuccessful)
{
    local SPUIDataProvider_SearchResult Provider;

    Search = DMSearchDataStore.GetCurrentGameSearch();
    NumGameResults = DMSearchDataStore.GameSearchCfgList[DMSearchDataStore.ActiveSearchIndex].SearchResults.Length;
    // End:0x75
    if(Search.bIsSearchInProgress && myGameInfo.bLanMatch)
    {
        return;
    }
    Opacity = 1.0000000;
    // End:0xAD
    if(SearchingMsgBox != none)
    {
        SearchingMsgBox.CloseScene(SearchingMsgBox);
        SearchingMsgBox = none;
    }
    // End:0x2C8
    if(myPC.OnlineSub != none)
    {
        DMSearchDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
        // End:0x2AF
        if(NumGameResults > 0)
        {
            Provider = SPUIDataProvider_SearchResult(DMSearchDataStore.GameSearchCfgList[DMSearchDataStore.ActiveSearchIndex].SearchResults[0]);
            SearchResult = Search.Results[Provider.SB_Index];
            DMSearchDataStore.bSkipBuildSearchResults = true;
            DMSearchDataStore.GameInterface.AddFindOnlineGamesCompleteDelegate(OnUpdateComplete);
            // End:0x1CF
            if(!myGameInfo.bLanMatch)
            {
                DMSearchDataStore.GameInterface.QueryNonAdvertisedData(Provider.SB_Index, 1);
            }
            ShowMsgBox("<Strings:PandoraGame.UIScene_PandoraJoinMatch.ConnectingMessage>", "<Strings:PandoraGame.UIScene_PandoraJoinMatch.Connectingtitle>", 4, CBJoinedResults, CBCheckNotJoined, 30);
            // End:0x2AC
            if(GetWorldInfo().IsConsoleBuild(1) || myGameInfo.bLanMatch)
            {
                OnUpdateComplete(true);
            }            
        }
        else
        {
            ShowMsgBox(NoMatchesFound_Message, NoMatchesFound_Title);
        }
    }
    //return;    
}

function GameJoinDone(bool bWasSuccessful)
{
    local string URL, PCLANProfileName;

    // End:0x2BD
    if(bWasSuccessful)
    {
        // End:0x2BD
        if((myPC.OnlineSub != none) && NotEqual_InterfaceInterface(myPC.OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            // End:0x293
            if(myPC.OnlineSub.GameInterface.GetResolvedConnectString(URL))
            {
                // End:0x1F3
                if(IsPCBuild())
                {
                    // End:0x15C
                    if(myGameInfo.bLanMatch)
                    {
                        myPC.ProfileSettings.GetSavedLocalPlayerName(PCLANProfileName);                        
                        myPC.ConsoleCommand((("open " $ URL) $ "?Game=PandorGameContent.PandoraMonsterMachine?GameType=PandoraGameContent.PandoraMonsterMachine?Team=255?Name=") $ PCLANProfileName);                        
                    }
                    else
                    {                        
                        myPC.ConsoleCommand(("open " $ URL) $ "?Game=PandorGameContent.PandoraMonsterMachine?GameType=PandoraGameContent.PandoraMonsterMachine?Team=255");
                    }                    
                }
                else
                {                    
                    myPC.ConsoleCommand(("open " $ URL) $ "?Game=PandorGameContent.PandoraMonsterMachine?GameType=PandoraGameContent.PandoraMonsterMachine?Team=255?Name=Player");
                }
            }
            myPC.OnlineSub.GameInterface.FreeSearchResults();
        }
    }
    myGameInfo.GameInterface.ClearJoinOnlineGameCompleteDelegate(GameJoinDone);
    //return;    
}
