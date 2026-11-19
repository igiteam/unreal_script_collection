class PKGameMenu extends PKGame
    config(Game)
    hidecategories(Navigation,Movement,Collision);

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

struct MMSaveSlotData
{
    var bool bIsCorrupted;
    var bool bIsLevelStart;
    var bool bContainsData;
    var PKTypes.EDifficultyLevel Difficulty;
    var byte ChapterNum;
    var int Day;
    var int Month;
    var int Year;
    var int SecondsSinceMidnight;

    structdefaultproperties
    {
        bIsCorrupted=false
        bIsLevelStart=false
        bContainsData=false
        Difficulty=EDifficultyLevel.DL_Daydream
        ChapterNum=0
        Day=0
        Month=0
        Year=0
        SecondsSinceMidnight=0
    }
};

var transient UIDataStore_OnlineGameSettings SettingsDataStore;
var PKTypes.EMultiGameMode MultiGameModeSelected;
var transient PKTypes.ELevelID LevelIDForCreateGame;
var PKTypes.ELevelID SelectedLevelID;
var transient bool bCreateLANGame;
var bool bPublicGameSelected;
var bool bLANSelected;
var bool bHasInactiveControllers;
var bool bSplitCoopPlayerDifficultySet;
var PKGFxUI_Menu_MultiServers uiClientJoin;

event InitGame(string Options, out string ErrorMessage)
{
    super.InitGame(Options, ErrorMessage);
    PKGameViewportClient(GetPlayerOwnerViewportClient()).bIsReturningToMainMenu = false;
    bSplitCoopPlayerDifficultySet = false;
    //return;    
}

function CleanupLocalPlayersForSP()
{
    local Engine Eng;
    local PKFrontEnd FrontEnd;
    local int I;

    Eng = Class'Engine.Engine'.static.GetEngine();
    I = 1;
    J0x34:

    // End:0xE2 [Loop If]
    if(I < Eng.GamePlayers.Length)
    {
        Eng.GamePlayers[0].ViewportClient.RemovePlayer(Eng.GamePlayers[I]);
        ++I;
        // [Loop Continue]
        goto J0x34;
    }
    FrontEnd = Class'PKFrontEnd'.static.GetFrontEnd();
    // End:0x13A
    if(FrontEnd != none)
    {
        FrontEnd.UpdatePlayersAndControllers(false);
    }
    //return;    
}

function LocalPlayer GetPlayerOwner(optional int PlayerIndex = 0)
{
    local UIInteraction UIController;
    local LocalPlayer Result;

    UIController = Class'Engine.UIRoot'.static.GetCurrentUIController();
    // End:0xF2
    if((PlayerIndex >= 0) && PlayerIndex < UIController.Outer.Outer.GamePlayers.Length)
    {
        Result = UIController.Outer.Outer.GamePlayers[PlayerIndex];
    }
    return Result;
    //return ReturnValue;    
}

function GameViewportClient GetPlayerOwnerViewportClient(optional int PlayerIndex = 0)
{
    local LocalPlayer LP;

    LP = GetPlayerOwner(PlayerIndex);
    // End:0x50
    if(LP != none)
    {
        return LP.ViewportClient;
    }
    return none;
    //return ReturnValue;    
}

function RestartPlayer(Controller NewPlayer)
{
    //return;    
}

function GenericPlayerInitialization(Controller C)
{
    local PlayerController PC;
    local UniqueNetId ZeroId;

    // End:0x22
    if(!bUseClassicHUD)
    {
        HUDType = Class'PainGFxMenuHudWrapper';
    }
    super(GameInfo).GenericPlayerInitialization(C);
    PC = PlayerController(C);
    // End:0xF6
    if(PC != none)
    {
        // End:0xF6
        if(PC.IsLocalPlayerController() && PC.PlayerReplicationInfo.UniqueId != ZeroId)
        {
            PKPartyPC(C).bSignedIn = true;
        }
    }
    //return;    
}

function SetSplitCoopPlayerDifficulty(PKTypes.EDifficultyLevel InDifficulty)
{
    bSplitCoopPlayerDifficultySet = true;
    SplitCoopPlayerDifficulty = InDifficulty;
    //return;    
}

function StartOnlineGame()
{
    //return;    
}

function ContinueGameFromCheckpoint(bool bIsLevelStart, int SelectedChapter)
{
    local EvilEngine Engine;
    local string URL;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x22B
    if((Engine.CurrentCheckpoint != none) && bIsLevelStart || !Engine.CurrentCheckpoint.CheckpointIsEmpty())
    {
        // End:0xFB
        if((SelectedChapter >= 28) && SelectedChapter <= 32)
        {
            URL = "PKHDGame_P?game=PKHDGameDLC5.PKGameSP_DLC5";            
        }
        else
        {
            URL = "PKHDGame_P?game=PKHDGame.PKGameSP";
        }        
        URL $= ("?chapter=" $ string(SelectedChapter));
        // End:0x18A
        if(!bIsLevelStart)
        {            
            URL $= "?loadcheckpoint";
        }        
        URL $= ("?gamepad=" $ ((WorldInfo.GetALocalPlayerController().PlayerInput.bUsingGamepad) ? "1" : "0"));
        WorldInfo.ServerTravel(URL, true, true);
    }
    //return;    
}

function SetupCoopGameSettings()
{
    local int ValueIndex;
    local DataStoreClient DSClient;
    local PKGameSettingsCommon GameSettings;
    local string MapName, GameNameString;

    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x9C
    if(DSClient != none)
    {
        SettingsDataStore = UIDataStore_OnlineGameSettings(DSClient.FindDataStore('PKGameSettings'));
        SettingsDataStore.SetCurrentByName('PKGameSettingsCoop');
    }
    GameSettings = PKGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    ValueIndex = ((bCreateLANGame) ? 0 : 1);
    switch(ValueIndex)
    {
        // End:0x145
        case 0:
            GameSettings.bIsLanMatch = true;
            GameSettings.bUsesArbitration = false;
            // End:0x1FB
            break;
        // End:0x18E
        case 1:
            GameSettings.bIsLanMatch = false;
            GameSettings.bUsesArbitration = false;
            // End:0x1FB
            break;
        // End:0x1F8
        case 2:
            GameSettings.bIsLanMatch = false;
            GameSettings.bUsesArbitration = true;
            GameSettings.NumPrivateConnections = 0;
            // End:0x1FB
            break;
        // End:0xFFFF
        default:
            break;
    }
    GameSettings.MaxPlayers = 2;
    GameSettings.NumPrivateConnections = Clamp(GameSettings.NumPrivateConnections, 0, GameSettings.MaxPlayers - 1);
    GameSettings.NumPublicConnections = GameSettings.MaxPlayers - GameSettings.NumPrivateConnections;
    GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections;
    GameSettings.NumOpenPrivateConnections = GameSettings.NumPrivateConnections;
    MapName = GetStringFromMarkup("SelectedMap");
    GameNameString = "PKHDGame.PKGameCooperative";
    GameSettings.SetPropertyFromStringByName('CustomMapName', MapName);
    GameSettings.SetPropertyFromStringByName('CustomGameMode', GameNameString);
    //return;    
}

function OnCoopGameCreated(name SessionName, bool bWasSuccessful)
{
    local OnlineGameSettings LocalGameSettings;
    local string TravelURL;

    // End:0x27F
    if(OnlineSub != none)
    {
        // End:0x27C
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCoopGameCreated);
            // End:0x279
            if(bWasSuccessful)
            {
                LocalGameSettings = SettingsDataStore.GetCurrentGameSettings();
                LocalGameSettings.bIsDedicated = false;
                LocalGameSettings.SetStringSettingValue(7, 0, false);
                TravelURL = ((("PKHDGame_P?game=" $ (((int(LevelIDForCreateGame) >= int(28)) && int(LevelIDForCreateGame) <= int(32)) ? "PKHDGameDLC5.PKGameCooperative_DLC5" : "PKHDGame.PKGameCooperative")) $ "?chapter=") $ string(int(LevelIDForCreateGame))) $ "?listen";                
                TravelURL $= ("?gamepad=" $ ((WorldInfo.GetALocalPlayerController().PlayerInput.bUsingGamepad) ? "1" : "0"));
                // End:0x236
                if(!bCreateLANGame)
                {                    
                    TravelURL $= "?steamsockets";
                }
                Class'Engine.WorldInfo'.static.GetWorldInfo().ServerTravel(TravelURL, true, true);                
            }            
        }        
    }
    //return;    
}

function CreateCoopGame(PKTypes.ELevelID InSelectedLevelID, bool bIsLANGame)
{
    // End:0x110
    if(OnlineSub != none)
    {
        // End:0x10D
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            LevelIDForCreateGame = InSelectedLevelID;
            bCreateLANGame = bIsLANGame;
            SetupCoopGameSettings();
            GameInterface.AddCreateOnlineGameCompleteDelegate(OnCoopGameCreated);
            // End:0x10A
            if(SettingsDataStore.CreateGame(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(0))) == false)
            {
                GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCoopGameCreated);
            }            
        }        
    }
    //return;    
}

function CreateSPGame(PKTypes.ELevelID InSelectedLevelID)
{
    local string GameExec;
    local int DifficultyNotSetValue;

    DifficultyNotSetValue = -1;
    // End:0x2D
    if(int(MultiGameModeSelected) != int(6))
    {
        CleanupLocalPlayersForSP();
    }
    // End:0xDE
    if((int(InSelectedLevelID) >= int(28)) && int(InSelectedLevelID) <= int(32))
    {
        GameExec = (("PKHDGame_P?game=PKHDGameDLC5." $ ((int(MultiGameModeSelected) == int(6)) ? "PKGameCooperative_DLC5" : "PKGameSP_DLC5")) $ "?chapter=") $ string(int(InSelectedLevelID));        
    }
    else
    {
        GameExec = (("PKHDGame_P?game=PKHDGame." $ ((int(MultiGameModeSelected) == int(6)) ? "PKGameCooperative" : "PKGameSP")) $ "?chapter=") $ string(int(InSelectedLevelID));
    }    
    GameExec $= ((("?gamepad=" $ ((WorldInfo.GetALocalPlayerController().PlayerInput.bUsingGamepad) ? "1" : "0")) $ "?coopdifficulty=") $ string(((bSplitCoopPlayerDifficultySet) ? int(SplitCoopPlayerDifficulty) : DifficultyNotSetValue)));
    Class'Engine.WorldInfo'.static.GetWorldInfo().ServerTravel(GameExec, true, true);
    bSplitCoopPlayerDifficultySet = false;
    //return;    
}

function StartDelayedGameSearch(float Time, PKGFxUI_Menu_MultiServers uiClient)
{
    uiClientJoin = uiClient;
    CleanupDelayedGameSearch();
    SetTimer(Time, false, 'DelayedGameSearch');
    //return;    
}

function CleanupDelayedGameSearch()
{
    // End:0x2B
    if(IsTimerActive('DelayedGameSearch'))
    {
        ClearTimer('DelayedGameSearch');
    }
    //return;    
}

function DelayedGameSearch()
{
    uiClientJoin.LastSelectedSlot = 0;
    uiClientJoin.CurrentRowShift = 0;
    uiClientJoin.RefreshServerList();
    //return;    
}

function SetupGameSearchRefreshing(float Time, PKGFxUI_Menu_MultiServers uiClient)
{
    uiClientJoin = uiClient;
    SetTimer(Time, true, 'GameSearchRefresh');
    //return;    
}

function CleanupGameSearchRefreshing()
{
    ClearTimer('GameSearchRefresh');
    //return;    
}

function SetupLatentGameSearch(float Time, PKGFxUI_Menu_MultiServers uiClient)
{
    uiClientJoin = uiClient;
    SetTimer(Time, false, 'LatentGameSearch');
    //return;    
}

function GameSearchRefresh()
{
    local OnlineGameSearch LatestGameSearch;

    LatestGameSearch = uiClientJoin.SearchDataStore.GetCurrentGameSearch();
    // End:0xDF
    if(LatestGameSearch.Results.Length != uiClientJoin.LatestSearchLenght)
    {
        uiClientJoin.LastSelectedSlot = 0;
        uiClientJoin.CurrentRowShift = 0;
        uiClientJoin.UpdateListDataProvider();
    }
    //return;    
}

function LatentGameSearch()
{
    uiClientJoin.LastSelectedSlot = 0;
    uiClientJoin.CurrentRowShift = 0;
    uiClientJoin.UpdateListDataProvider();
    //return;    
}

function PKPlayerController FindPlayerControllerByControllerId(int ControllerId)
{
    local PKPlayerController PC, ResultPC;

    ResultPC = none;
    // End:0xA0
    foreach WorldInfo.LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        // End:0x9F
        if(LocalPlayer(PC.Player).ControllerId == ControllerId)
        {
            ResultPC = PC;
            // End:0xA0
            break;
        }        
    }    
    return ResultPC;
    //return ReturnValue;    
}

static function string GetStringFromMarkup(string MarkupString)
{
    local UIDataStore_Registry Registry;
    local string Retval;

    Retval = "";
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.GetData(MarkupString, Retval);
    return Retval;
    //return ReturnValue;    
}

event PostLogin(PlayerController NewPlayer)
{
    local PKPlayerController PC;

    super.PostLogin(NewPlayer);
    PC = PKPlayerController(NewPlayer);
    // End:0x51
    if(PC != none)
    {
        SetPartyRichPresenceString(PC);
    }
    //return;    
}

function SetPartyRichPresenceString(PKPlayerController PC)
{
    local PKFrontEnd FrontEnd;
    local int StringToUse;

    FrontEnd = Class'PKFrontEnd'.static.GetFrontEnd();
    // End:0x47
    if(FrontEnd == none)
    {
        StringToUse = 4;        
    }
    else
    {
        switch(GetGRI().CurrentPartyType)
        {
            // End:0x12A
            case 1:
                // End:0xEA
                if((FrontEnd.GameSearchMenu != none) && FrontEnd.CurrentScene == FrontEnd.GameSearchMenu)
                {
                    StringToUse = 1;                    
                }
                else
                {
                    // End:0x11B
                    if(FrontEnd.bOnMPScreens)
                    {
                        StringToUse = 2;                        
                    }
                    else
                    {
                        StringToUse = 4;
                    }
                }
                // End:0x186
                break;
            // End:0x12F
            case 0:
            // End:0x174
            case 2:
                // End:0x165
                if(FrontEnd.bOnMPScreens)
                {
                    StringToUse = 3;                    
                }
                else
                {
                    StringToUse = 4;
                }
                // End:0x186
                break;
            // End:0xFFFF
            default:
                StringToUse = 4;
                // End:0x186
                break;
                break;
        }
    }
    PC.SetRichPresenceString(StringToUse);
    //return;    
}

event Broadcast(Actor Sender, coerce string msg, optional name Type)
{
    //return;    
}

function BroadcastTeam(Controller Sender, coerce string msg, optional name Type)
{
    //return;    
}

defaultproperties
{
    Acronym="UI"
    MapPrefixes=/* Array type was not detected. */
    ConsolePlayerControllerClass=Class'PKPartyPC'
    PlayerControllerClass=Class'PKPartyPC'
}