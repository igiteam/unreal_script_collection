class AdvGameMenu extends ADVGame
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var OnlinePlaylistManager PlaylistMan;
var transient UIDataStore_OnlineGameSettings SettingsDataStore;
var AdvTypes.EMultiGameMode MultiGameModeSelected;
var transient AdvTypes.ELevelID LevelIDForCreateGame;
var AdvTypes.ELevelID SelectedLevelID;
var OnlineSubsystem.ENATType NatType;
var config OnlineSubsystem.ENATType CanHostVersusNatType;
var transient bool bCreateLANGame;
var bool bPublicGameSelected;
var bool bLANSelected;
var bool bHasInactiveControllers;
var transient string SavedURL;
var AdvGFxUI_Menu_MultiServers uiClientJoin;
var int SelectedPuzzleDifficultyLevel;
var int SelectedFightDifficultyLevel;
//var delegate<PartySuccessfullyCreatedNotify> __PartySuccessfullyCreatedNotify__Delegate;
//var delegate<OnCreateGameComplete> __OnCreateGameComplete__Delegate;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetDirty
        MultiGameModeSelected;
}

delegate PartySuccessfullyCreatedNotify()
{
    //return;    
}

function PartyFailedCreationNotify()
{
    local AdvPlayerController APC;

    APC = AdvPlayerController(WorldInfo.GetALocalPlayerController());
    // End:0x10D
    if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(GetPlayerOwner().ControllerId))) == int(2)) && OnlineSub.SystemInterface.HasLinkConnection())
    {
        APC.ShowOSSConnectionLostMessage();
        APC.ReturnToMainMenu(false);
    }
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    super.InitGame(Options, ErrorMessage);
    // End:0x66
    if(OnlineSub != none)
    {
        PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
    }
    UpdateNatType();
    ADVGameViewportClient(GetPlayerOwnerViewportClient()).bIsReturningToMainMenu = false;
    //return;    
}

function UpdateNatType()
{
    local AdvPartyGRI PartyGRI;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x18E
    if(OnlineSub != none)
    {
        // End:0xAF
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            NatType = OnlineSub.SystemInterface.GetNATType();            
        }
        else
        {
            NatType = 1;
        }
        PartyGRI = AdvPartyGRI(WorldInfo.GRI);
        // End:0x18E
        if((PartyGRI != none) && int(PartyGRI.Role) == int(ROLE_Authority))
        {
            PartyGRI.HostNATType = NatType;
            PartyGRI.bNetDirty = true;
            PartyGRI.OnHostNATTypeChange();
        }
    }
    //return;    
}

function CleanupLocalPlayersForSP()
{
    local Engine Eng;
    local AdvFrontEnd Frontend;
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
    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0x13A
    if(Frontend != none)
    {
        Frontend.UpdatePlayersAndControllers(false);
    }
    //return;    
}

function StartOnlineGame()
{
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
    // End:0x22
    if(!bUseClassicHUD)
    {
        HUDType = Class'AdvGFxMenuHudWrapper';
    }
    super(GameInfo).GenericPlayerInitialization(C);
    //return;    
}

function ContinueGameFromCheckpoint(bool bIsLevelStart, int SelectedChapter, EvilTypesNative.EDifficultyLevel PuzzleDifficulty, EvilTypesNative.EDifficultyLevel FightDifficulty)
{
    local EvilEngine Engine;
    local AdvPlayerController PKPC;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x2A5
    if((Engine.CurrentCheckpoint != none) && bIsLevelStart || !Engine.CurrentCheckpoint.CheckpointIsEmpty())
    {
        PKPC = AdvPlayerController(WorldInfo.GetALocalPlayerController());
        PKPC.ClientShowLevelLoadingMovieByChapter(SelectedChapter);
        SavedURL = "ADVGame_P?game=ADVGame.ADVGameSP";        
        SavedURL $= ("?chapter=" $ string(SelectedChapter));
        // End:0x18B
        if(!bIsLevelStart)
        {            
            SavedURL $= "?loadcheckpoint";            
        }
        else
        {            
            SavedURL $= ("?PuzzleDifficultyLevel=" $ string(int(PuzzleDifficulty)));            
            SavedURL $= ("?FightDifficultyLevel=" $ string(int(FightDifficulty)));
        }        
        SavedURL $= ("?gamepad=" $ ((WorldInfo.GetALocalPlayerController().PlayerInput.bUsingGamepad) ? "1" : "0"));
        WorldInfo.ServerTravel(SavedURL, true, true);
    }
    //return;    
}

function CreateCampaignSession()
{
    GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyGameComplete);
    GameInterface.DestroyOnlineGame('Party');
    //return;    
}

function OnDestroyPartyGameComplete(name SessionName, bool bWasSuccessful)
{
    GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyGameComplete);
    GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroySessionGameComplete);
    GameInterface.DestroyOnlineGame('Game');
    //return;    
}

function OnDestroySessionGameComplete(name SessionName, bool bWasSuccessful)
{
    local bool bIsNotSignedIn;
    local AdvGameCampaignSettings settingsA;
    local int ControllerId;

    GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroySessionGameComplete);
    GameInterface.AddCreateOnlineGameCompleteDelegate(OnSingleGameCreated);
    settingsA = new Class'AdvGameCampaignSettings';
    ControllerId = AdvLocalPlayer(AdvEngine(Class'AdvEngine'.static.GetEngine()).GamePlayers[0]).ControllerId;
    bIsNotSignedIn = int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerId))) == int(0);
    // End:0x157
    if(bIsNotSignedIn)
    {
        OnSingleGameCreated('Game', false);
        return;
    }
    // End:0x1CB
    if(GameInterface.CreateOnlineGame(byte(ControllerId), 'Game', settingsA) == false)
    {
        GameInterface.ClearCreateOnlineGameCompleteDelegate(OnSingleGameCreated);
    }
    //return;    
}

function OnSingleGameCreated(name SessionName, bool bWasSuccessful)
{
    GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyGameComplete);
    GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroySessionGameComplete);
    GameInterface.ClearCreateOnlineGameCompleteDelegate(OnSingleGameCreated);
    Class'Engine.WorldInfo'.static.GetWorldInfo().ServerTravel(SavedURL, true, true);
    //return;    
}

function CreateSPGame(AdvTypes.ELevelID InSelectedLevelID)
{
    local AdvPlayerController PKPC;
    local int SelectedLevel;

    SelectedLevel = int(InSelectedLevelID);
    CleanupLocalPlayersForSP();
    PKPC = AdvPlayerController(WorldInfo.GetALocalPlayerController());
    PKPC.ClientShowLevelLoadingMovieByChapter(SelectedLevel);
    SavedURL = (("ADVGame_P?game=ADVGame." $ "ADVGameSP") $ "?chapter=") $ string(SelectedLevel);    
    SavedURL $= ("?gamepad=" $ ((WorldInfo.GetALocalPlayerController().PlayerInput.bUsingGamepad) ? "1" : "0"));    
    SavedURL $= ("?PuzzleDifficultyLevel=" $ string(SelectedPuzzleDifficultyLevel));    
    SavedURL $= ("?FightDifficultyLevel=" $ string(SelectedFightDifficultyLevel));    
    SavedURL $= "?RestoreDefaultWeapons=1";
    Class'Engine.WorldInfo'.static.GetWorldInfo().ServerTravel(SavedURL, true, true);
    //return;    
}

function SetupGameSearchRefreshing(float Time, AdvGFxUI_Menu_MultiServers uiClient)
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

function SetupLatentGameSearch(float Time, AdvGFxUI_Menu_MultiServers uiClient)
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

function AdvPlayerController FindPlayerControllerByControllerId(int ControllerId)
{
    local AdvPlayerController PC, ResultPC;

    ResultPC = none;
    // End:0xA0
    foreach WorldInfo.LocalPlayerControllers(Class'AdvPlayerController', PC)
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

function AdvPlayerController GetPCFromControllerId(int ControllerId)
{
    local LocalPlayer LP;
    local int PlayerIndex;

    PlayerIndex = Class'Engine.UIInteraction'.static.GetPlayerIndex(ControllerId);
    LP = GetPlayerOwner(PlayerIndex);
    return AdvPlayerController(LP.Actor);
    //return ReturnValue;    
}

function int GetLoggedInPlayerCount()
{
    local int Index, Count, MaxToCheck;

    MaxToCheck = OnlineSub.GetNumSupportedLogins();
    Index = 0;
    J0x34:

    // End:0xAF [Loop If]
    if(Index < MaxToCheck)
    {
        // End:0xA1
        if(int(OnlineSub.PlayerInterface.GetLoginStatus(byte(Index))) != int(0))
        {
            Count++;
        }
        Index++;
        // [Loop Continue]
        goto J0x34;
    }
    return Count;
    //return ReturnValue;    
}

function bool CanInviteToMatch()
{
    local AdvFrontEnd Frontend;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0x3A
    if(Frontend == none)
    {
        return true;
    }
    return int(AdvGRI(GameReplicationInfo).GetCurrentPartyType()) != int(2);
    //return ReturnValue;    
}

function ClearOnlineDelegates()
{
    // End:0x87
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild() || (OnlineSub != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePartyComplete);
    }
    //return;    
}

function AdvProfileSettings GetProfile(int ControllerId)
{
    local LocalPlayer LP;
    local AdvPlayerController PlayerOwner;
    local int PlayerIndex;

    PlayerIndex = Class'Engine.UIInteraction'.static.GetPlayerIndex(ControllerId);
    LP = GetPlayerOwner(PlayerIndex);
    PlayerOwner = AdvPlayerController(LP.Actor);
    return PlayerOwner.ProfileSettings;
    //return ReturnValue;    
}

function ChangeMatchModeSettings(AdvPartyGameSettings PartySettings, int MatchMode, AdvProfileSettings Profile)
{
    local AdvPartyGRI PartyGRI;
    local int MaxPartySize;

    PartyGRI = AdvPartyGRI(WorldInfo.GRI);
    switch(MatchMode)
    {
        // End:0xFFFF
        default:
            OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
            // End:0x1EA
            if(((OnlineSub != none) && PartyGRI != none) && Profile != none)
            {
                PartyGRI.TeamSize = 4;
                PartyGRI.TeamCount = 1;
                MaxPartySize = 8;
                // End:0x1C2
                if((PartyGRI.TeamSize == 0) || PartyGRI.TeamCount == 0)
                {
                    PartyGRI.TeamSize = 4;
                    PartyGRI.TeamCount = 2;
                    MaxPartySize = PartyGRI.TeamSize * PartyGRI.TeamCount;
                }
                PartyGRI.UpdateMaxPartySize(MaxPartySize);
            }
            MaxPlayers = 8;
            // End:0x24D
            if(PartySettings != none)
            {
                PartySettings.NumPublicConnections = MaxPlayers;
                PartySettings.NumPrivateConnections = 0;
            }
            // End:0x250
            break;
            break;
    }
    //return;    
}

function ChangePartySettings(AdvPartyGameSettings PartySettings, int PartyType)
{
    local AdvFrontEnd Frontend;
    local AdvGRI GRI;
    local bool bCanJIP;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    GRI = AdvGRI(WorldInfo.GRI);
    ScriptTrace();
    // End:0x292
    if(PartySettings != none)
    {
        // End:0x1E0
        if((CanInviteToMatch()) && PartySettings.NumOpenPublicConnections > 0)
        {
            bCanJIP = (PartyType == 1) && (Frontend == none) || GRI.bIsPregameLobbyGame;
            PartySettings.bAllowInvites = true;
            PartySettings.bAllowJoinViaPresence = bCanJIP && !GRI.IsPrivateCustomGame();
            PartySettings.bAllowJoinViaPresenceFriendsOnly = bCanJIP && !GRI.IsPrivateCustomGame();
            PartySettings.bAllowJoinInProgress = bCanJIP;            
        }
        else
        {
            PartySettings.bAllowInvites = false;
            PartySettings.bAllowJoinViaPresence = false;
            PartySettings.bAllowJoinViaPresenceFriendsOnly = false;
            PartySettings.bAllowJoinInProgress = false;
        }
        PartySettings.SetStringSettingValue(88, PartyType);        
    }
    //return;    
}

function bool InitializePartySettingsFromProfile(AdvPartyGameSettings Party, int ControllerIndex, bool bIsLAN, optional bool bIsRecreating)
{
    local AdvProfileSettings Profile;
    local int MatchMode, PartyType;

    // End:0xEF
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        Profile = GetProfile(ControllerIndex);
        // End:0xEC
        if(Profile != none)
        {
            MatchMode = 0;
            ChangeMatchModeSettings(Party, MatchMode, Profile);
            PartyType = int(Profile.GetPartyType());
            ChangePartySettings(Party, PartyType);
            return true;
        }        
    }
    return false;
    //return ReturnValue;    
}

function bool AllPlayersAllowedOnPlaylist(int plId)
{
    local int PlaylistMatchType;
    local bool bResult;

    bResult = true;
    // End:0x5D
    if(PlaylistMan != none)
    {
        PlaylistMatchType = PlaylistMan.GetMatchType(plId);
        // End:0x5D
        if(PlaylistMatchType == 2)
        {
        }
    }
    return bResult;
    //return ReturnValue;    
}

function CreateParty(int ControllerIndex, optional bool bIsLAN)
{
    local AdvProfileSettings Profile;
    local AdvPartyGameSettings Party;

    Profile = GetProfile(ControllerIndex);
    // End:0x1AC
    if(Profile != none)
    {
        Party = new Class'AdvPartyGameSettings';
        // End:0xB4
        if(bIsLAN)
        {
            Party.bShouldAdvertise = true;
            Party.NumPublicConnections = 10;
            Party.NumPrivateConnections = 0;
        }
        // End:0x198
        if(InitializePartySettingsFromProfile(Party, ControllerIndex, bIsLAN))
        {
            GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreatePartyComplete);
            // End:0x195
            if(GameInterface.CreateOnlineGame(byte(ControllerIndex), 'Party', Party))
            {
                // End:0x195
                if(Class'Engine.WorldInfo'.static.IsConsoleBuild())
                {
                    Class'AdvEngine'.static.OpenInputBlockingScene(0);
                }
            }            
        }
        else
        {
            OnCreatePartyComplete('Party', false);
        }
    }
    //return;    
}

function OnCreatePartyComplete(name SessionName, bool bWasSuccessful)
{
    local AdvProfileSettings Profile;
    local LocalPlayer LP;
    local AdvPlayerController PC, PCIter;
    local AdvFrontEnd Frontend;

    // End:0x267
    if(SessionName == 'Party')
    {
        // End:0x68
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePartyComplete);
        }
        // End:0xAC
        if(Class'Engine.WorldInfo'.static.IsConsoleBuild())
        {
            Class'AdvEngine'.static.CloseInputBlockingScene(0);
        }
        LP = GetPlayerOwner();
        PC = AdvPlayerController(LP.Actor);
        // End:0x213
        if(bWasSuccessful)
        {
            // End:0x13E
            if((LP != none) && PC != none)
            {
                PC.CreatePersistentPartyHostBeacon();
            }
            CleanupLocalPlayersForSP();
            // End:0x1AA
            foreach LocalPlayerControllers(Class'AdvPlayerController', PCIter)
            {
                // End:0x1A9
                if(PCIter.IsPrimaryPlayer())
                {
                    PCIter.ClientRegisterWithParty(true);
                }                
            }            
            PartySuccessfullyCreatedNotify();
            UpdateGameSettingsCounts();
            Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
            Frontend.AcceptDeferredInvite();            
        }
        else
        {
            Profile = PC.ProfileSettings;
            // End:0x25D
            if(Profile != none)
            {
                CreateLocalParty(Profile);
            }
            PartyFailedCreationNotify();
        }
    }
    //return;    
}

function CreateLocalParty(AdvProfileSettings Profile)
{
    local AdvPlayerController PCIter;

    Profile.SetProfileSettingValueId(89, 7);
    // End:0x85
    foreach LocalPlayerControllers(Class'AdvPlayerController', PCIter)
    {
        // End:0x84
        if(PCIter.IsPrimaryPlayer())
        {
            PCIter.ClientRegisterWithParty(true);
        }        
    }    
    //return;    
}

event PostLogin(PlayerController NewPlayer)
{
    local AdvPlayerController PC;

    super.PostLogin(NewPlayer);
    PC = AdvPlayerController(NewPlayer);
    // End:0x51
    if(PC != none)
    {
        SetPartyRichPresenceString(PC);
    }
    //return;    
}

function int GetPartyRichPresenceString()
{
    local AdvFrontEnd Frontend;
    local int StringToUse;
    local AdvGRI GRI;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0x47
    if(Frontend == none)
    {
        StringToUse = 4;        
    }
    else
    {
        // End:0xBC
        if((Frontend.GameSearchMenu != none) && Frontend.CurrentScene == Frontend.GameSearchMenu)
        {
            StringToUse = 1;            
        }
        else
        {
            // End:0x259
            if((((AdvFrontEndParty(Frontend) != none) && AdvFrontEndParty(Frontend).PregameLobby != none) && Frontend.CurrentScene == AdvFrontEndParty(Frontend).PregameLobby) || ((AdvFrontEndParty(Frontend) != none) && AdvFrontEndParty(Frontend).ClientLobby != none) && Frontend.CurrentScene == AdvFrontEndParty(Frontend).ClientLobby)
            {
                GRI = GetGRI();
                StringToUse = ((GRI.IsPrivateCustomGame() && int(GRI.GetCurrentPartyType()) == int(0)) ? 3 : 2);                
            }
            else
            {
                StringToUse = 4;
            }
        }
    }
    return StringToUse;
    //return ReturnValue;    
}

function SetPartyRichPresenceString(AdvPlayerController PC)
{
    PC.SetRichPresenceString(GetPartyRichPresenceString());
    //return;    
}

function SetPresenceByPartyType()
{
    SetClientsRichPresenceStrings(GetPartyRichPresenceString());
    //return;    
}

delegate OnCreateGameComplete(name SessionName, bool bWasSuccessful)
{
    //return;    
}

function bool AllowPausing(optional PlayerController PC)
{
    return bPauseable;
    //return ReturnValue;    
}

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
    return true;
    //return ReturnValue;    
}

event Broadcast(Actor Sender, coerce string msg, optional name Type)
{
    //return;    
}

function BroadcastTeam(Controller Sender, coerce string msg, optional name Type)
{
    //return;    
}

auto state PendingMatch
{Begin:

    stop;                
}

defaultproperties
{
    MultiGameModeSelected=EMultiGameMode.EMGM_NONE
    Acronym="UI"
    MapPrefixes=/* Array type was not detected. */
    ConsolePlayerControllerClass=Class'ADVPartyPC'
    bPauseable=false
    PlayerControllerClass=Class'ADVPartyPC'
}