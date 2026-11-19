class PKGFxUI_Menu_MultiHost extends PKGFxUI_Menu_Base
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
const SERVERTYPE_LAN = 0;
const SERVERTYPE_UNRANKED = 1;
const SERVERTYPE_RANKED = 2;
const MAXIMUM_PLAYER_COUNT = 16;

struct TGameTypeInfo
{
    var const localized string Typename;
    var string TypeClass;
    var string TypePrefix;
    var string TypeSettings;

    structdefaultproperties
    {
        Typename=""
        TypeClass=""
        TypePrefix=""
        TypeSettings=""
    }
};

var transient string DefaultMapName;
var transient string DefaultGameMode;
var transient string DefaultGameModeSettings;
var transient string DefaultMapImage;
var transient string DefaultGameModePrefixes;
var transient UIDataStore_OnlineGameSettings SettingsDataStore;
var transient UTUIDataStore_StringList StringListDataStore;
var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject SubTitleMC;
var GFxObject AdvancedMC;
var GFxObject AdvancedBG;
var GFxObject ListMC;
var GFxObject TitleTF;
var GFxObject SubTitleTF;
var GFxObject SelectedTF;
var GFxObject Tile0;
var GFxObject Tile1;
var GFxObject Tile2;
var GFxObject Tile3;
var GFxObject Tile4;
var GFxClikWidget NewGameBtn;
var GFxClikWidget ShowAdvancedBtn;
var GFxClikWidget HideAdvancedBtn;
var GFxClikWidget BackBtn;
var GFxObject WorkshopWindow;
var GFxObject WorkshopLogoMC;
var GFxObject WorkshopTF;
var GFxObject WorkshopNameTF;
var GFxObject AuthorHeaderTF;
var GFxObject AuthorTF;
var GFxClikWidget MapList;
var GFxClikWidget MapListCycle;
var GFxObject MapListDataProvider;
var GFxClikWidget InternetLANCheckbox;
var bool bLANSelected;
var bool bPublicGame;
var transient bool bShowingAdvanced;
var bool bTeamDamage;
var bool bWeaponStay;
var bool bPowerUps;
var bool bPowerupsDrop;
var bool bAllowBunny;
var bool bBrightSkin;
var bool bRocketJump;
var GFxClikWidget GameTypeDropdown;
var GFxObject GameTypeDataProvider;
var int LastSelectedGame;
var array<TGameTypeInfo> SupportedGameTypes;
var array<UTUIDataProvider_MapInfo> Maps;
var array<string> DropMapNames;
var array<string> CycleMapList;
var transient int LastSelectedIndex;
var GFxClikWidget ServerNameInp;
var GFxClikWidget PasswordInp;
var GFxClikWidget FragLimitInp;
var GFxClikWidget TimeLimitInp;
var GFxClikWidget MaxPlayersInp;
var GFxClikWidget MaxSpectatorsInp;
var string ServerName;
var string Password;
var int FragLimit;
var int TimeLimit;
var int MaxPlayers;
var int MaxSpectators;
var GFxClikWidget TeamDamageChk;
var GFxClikWidget WeaponStayChk;
var GFxClikWidget WeaponRespawnInp;
var GFxClikWidget PowerupsChk;
var GFxClikWidget PowerupsDropChk;
var GFxClikWidget BunnyChk;
var GFxClikWidget BrightskinChk;
var GFxClikWidget RocketJumpChk;
var int WeaponRespawnTime;
var GFxObject MapsTF;
var GFxObject GameTypeTF;
var GFxObject ServerMapsTF;
var GFxObject ServerNameTF;
var GFxObject PasswordTF;
var GFxObject TimelimitTF;
var GFxObject FraglimitTF;
var GFxObject SpectatorsTF;
var GFxObject MaxPlayersTF;
var GFxObject WeaponRespawnTF;
var const localized string TitleString;
var const localized string NewGameString;
var const localized string GameTypeString;
var const localized string LanInternetString;
var const localized string PublicGameString;
var const localized string MapListString;
var const localized string ServerMapListString;
var const localized string ServerNameString;
var const localized string ServerNameLabelString;
var const localized string ServerPasswordString;
var const localized string TimeLimitString;
var const localized string FragLimitString;
var const localized string FlagLimitString;
var const localized string MaxSpectatorsString;
var const localized string MaxPlayersString;
var const localized string WeaponResTimeString;
var const localized string AdvancedOptionsString;
var const localized string HideAdvancedOptionsString;
var const localized string PowerDropsString;
var const localized string BrightskinString;
var const localized string TeamDamageString;
var const localized string WeaponStayString;
var const localized string BunnyHoppingString;
var const localized string PowerupsString;
var const localized string FwdRocketJumpString;
var int CycleCounter;
var transient OnlineSubsystem OnlineSub;
var transient OnlineGameInterface GameInterface;
var transient OnlineLobbyInterfaceSteamworks LobbyInterface;
//var delegate<MapListSort> __MapListSort__Delegate;

function bool Start(optional bool StartPaused = false)
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry Registry;
    local int SelectedIndex;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0xF1
    if(DSClient != none)
    {
        SettingsDataStore = UIDataStore_OnlineGameSettings(DSClient.FindDataStore('PKGameSettings'));
        StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
    }
    SettingsDataStore.SetCurrentByName(name(DefaultGameModeSettings));
    Registry.SetData("SelectedGameModePrefix", DefaultGameModePrefixes);
    Registry.SetData("SelectedGameMode", DefaultGameMode);
    Registry.SetData("SelectedMap", DefaultMapName);
    Registry.SetData("SelectedMapImage", DefaultMapImage);
    Registry.SetData("ServerPassword", "");
    super.Start(StartPaused);
    Advance(0.0000000);
    CycleMapList.Length = 0;
    CycleCounter = 0;
    bShowingAdvanced = false;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x30C
    if(OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    }
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    SubTitleMC = TitleMC.GetObject("mc_subtitle");
    ListMC = ButtonsMC.GetObject("list");
    TitleTF = TitleMC.GetObject("textField");
    SubTitleTF = SubTitleMC.GetObject("textField");
    SelectedTF = ListMC.GetObject("textField");
    Tile0 = ListMC.GetObject("tile0");
    Tile1 = ListMC.GetObject("tile1");
    Tile2 = ListMC.GetObject("tile2");
    Tile3 = ListMC.GetObject("tile3");
    Tile4 = ListMC.GetObject("tile4");
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("start_btn", Class'GFxUI.GFxClikWidget'));
    ShowAdvancedBtn = GFxClikWidget(ButtonsMC.GetObject("show_advanced", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x6D3
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    AdvancedMC = ButtonsMC.GetObject("Advanced");
    AdvancedBG = AdvancedMC.GetObject("AdvancedBG");
    HideAdvancedBtn = GFxClikWidget(AdvancedMC.GetObject("hide_btn", Class'GFxUI.GFxClikWidget'));
    GameTypeTF = ButtonsMC.GetObject("gametypeTF");
    MapsTF = ButtonsMC.GetObject("mapsTF");
    ServerMapsTF = ButtonsMC.GetObject("maplistTF");
    ServerNameTF = ButtonsMC.GetObject("servnameTF");
    PasswordTF = ButtonsMC.GetObject("servpaswordTF");
    TimelimitTF = ButtonsMC.GetObject("timelimitTF");
    FraglimitTF = ButtonsMC.GetObject("fraglimitTF");
    SpectatorsTF = ButtonsMC.GetObject("maxspectTF");
    MaxPlayersTF = ButtonsMC.GetObject("maxplayersTF");
    WeaponRespawnTF = AdvancedMC.GetObject("weaponsrespawntimeTF");
    ServerNameInp = GFxClikWidget(ButtonsMC.GetObject("servername", Class'GFxUI.GFxClikWidget'));
    PasswordInp = GFxClikWidget(ButtonsMC.GetObject("password", Class'GFxUI.GFxClikWidget'));
    FragLimitInp = GFxClikWidget(ButtonsMC.GetObject("fraglimit", Class'GFxUI.GFxClikWidget'));
    TimeLimitInp = GFxClikWidget(ButtonsMC.GetObject("timelimit", Class'GFxUI.GFxClikWidget'));
    MaxPlayersInp = GFxClikWidget(ButtonsMC.GetObject("maxplayers", Class'GFxUI.GFxClikWidget'));
    MaxSpectatorsInp = GFxClikWidget(ButtonsMC.GetObject("maxspectators", Class'GFxUI.GFxClikWidget'));
    TeamDamageChk = GFxClikWidget(AdvancedMC.GetObject("teamdamage", Class'GFxUI.GFxClikWidget'));
    WeaponStayChk = GFxClikWidget(AdvancedMC.GetObject("weaponsstay", Class'GFxUI.GFxClikWidget'));
    WeaponRespawnInp = GFxClikWidget(AdvancedMC.GetObject("weaponsrespawntime", Class'GFxUI.GFxClikWidget'));
    PowerupsChk = GFxClikWidget(AdvancedMC.GetObject("powerups", Class'GFxUI.GFxClikWidget'));
    PowerupsDropChk = GFxClikWidget(AdvancedMC.GetObject("powerupsdrop", Class'GFxUI.GFxClikWidget'));
    BunnyChk = GFxClikWidget(AdvancedMC.GetObject("bunny", Class'GFxUI.GFxClikWidget'));
    BrightskinChk = GFxClikWidget(AdvancedMC.GetObject("brightskin", Class'GFxUI.GFxClikWidget'));
    RocketJumpChk = GFxClikWidget(AdvancedMC.GetObject("rocketjump", Class'GFxUI.GFxClikWidget'));
    InternetLANCheckbox = GFxClikWidget(ButtonsMC.GetObject("InternetLAN", Class'GFxUI.GFxClikWidget'));
    GameTypeDropdown = GFxClikWidget(ButtonsMC.GetObject("gametype", Class'GFxUI.GFxClikWidget'));
    MapList = GFxClikWidget(ButtonsMC.GetObject("list_helper", Class'GFxUI.GFxClikWidget'));
    MapListCycle = GFxClikWidget(ButtonsMC.GetObject("list_helper2", Class'GFxUI.GFxClikWidget'));
    InitDefaultOptions();
    UpdateGameTypeDropdownDataProvider();
    UpdateListDataProvider();
    ValidateServerType();
    TitleTF.SetText(TitleString);
    MapsTF.SetText(MapListString);
    ServerMapsTF.SetText(ServerMapListString);
    PasswordTF.SetText(ServerPasswordString);
    GameTypeTF.SetText(GameTypeString);
    TimelimitTF.SetText(TimeLimitString);
    FraglimitTF.SetText(FragLimitString);
    SpectatorsTF.SetText(MaxSpectatorsString);
    MaxPlayersTF.SetText(MaxPlayersString);
    TeamDamageChk.SetString("label", TeamDamageString);
    WeaponStayChk.SetString("label", WeaponStayString);
    PowerupsChk.SetString("label", PowerupsString);
    PowerupsDropChk.SetString("label", PowerDropsString);
    BunnyChk.SetString("label", BunnyHoppingString);
    BrightskinChk.SetString("label", BrightskinString);
    RocketJumpChk.SetString("label", FwdRocketJumpString);
    InternetLANCheckbox.SetString("label", LanInternetString);
    NewGameBtn.SetString("label", NewGameString);
    ShowAdvancedBtn.SetString("label", AdvancedOptionsString);
    HideAdvancedBtn.SetString("label", HideAdvancedOptionsString);
    WorkshopWindow = ButtonsMC.GetObject("map_desc");
    WorkshopWindow.SetVisible(false);
    WorkshopLogoMC = WorkshopWindow.GetObject("workshopLogoMC");
    WorkshopTF = WorkshopWindow.GetObject("workshopTF");
    WorkshopTF.SetText(Localize("Workshop", "PackageName", "PKHDGame"));
    AuthorHeaderTF = WorkshopWindow.GetObject("authorHeaderTF");
    AuthorHeaderTF.SetText("authorHeaderTF");
    WorkshopNameTF = WorkshopWindow.GetObject("workshopNameTF");
    WorkshopNameTF.SetText(Localize("Workshop", "Author", "PKHDGame"));
    AuthorTF = WorkshopWindow.GetObject("authorTF");
    AuthorTF.SetText("authorTF");
    // End:0x150C
    if(int(GetPC().WorldInfo.NetMode) == int(NM_Client))
    {
        MapList.SetVisible(false);
    }
    // End:0x1633
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        InternetLANCheckbox.SetBool("visible", false);
        PasswordInp.SetBool("visible", false);
        GameTypeTF.SetText(" ");
        PasswordTF.SetText(" ");
        GameTypeDropdown.SetBool("visible", false);
        ShowAdvancedBtn.SetBool("visible", false);        
    }
    else
    {
        SubTitleMC.SetVisible(false);
    }
    // End:0x16AE
    if(int(GetMenuGame().MultiGameModeSelected) != int(0))
    {
        SetGameType(int(GetMenuGame().MultiGameModeSelected) - int(1));
    }
    ShowAdvanced(false);
    SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex"));
    LoadMapList(SelectedIndex);
    BuildMapList(SelectedIndex);
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    ButtonAliases.AddItem('GenericBack');
    // End:0x8D
    if(GetPC().WorldInfo.IsConsoleBuild(0) && !bShowingAdvanced)
    {
        ButtonAliases.AddItem('HostShowAdvanced');
    }
    FrontEnd.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function InitDefaultOptions()
{
    local int Id;
    local PKGameSettingsCommon GameSettings;

    GameSettings = PKGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    InternetLANCheckbox.SetBool("selected", bLANSelected);
    // End:0xA9
    if(PKGameCTFSettings(GameSettings) != none)
    {
        FraglimitTF.SetText(FlagLimitString);        
    }
    else
    {
        FraglimitTF.SetText(FragLimitString);
    }
    // End:0x137
    if(GameSettings.GetPropertyId('GoalScore', Id))
    {
        GameSettings.GetIntProperty(Id, FragLimit);
    }
    // End:0x19C
    if(GameSettings.GetPropertyId('TimeLimit', Id))
    {
        GameSettings.GetIntProperty(Id, TimeLimit);
    }
    LoadProfileData();
    FragLimitInp.SetInt("value", FragLimit);
    TimeLimitInp.SetInt("value", TimeLimit);
    MaxPlayersInp.SetInt("value", MaxPlayers);
    MaxSpectatorsInp.SetInt("value", MaxSpectators);
    WeaponRespawnInp.SetInt("value", WeaponRespawnTime);
    TeamDamageChk.SetBool("selected", bTeamDamage);
    WeaponStayChk.SetBool("selected", bWeaponStay);
    PowerupsChk.SetBool("selected", bPowerUps);
    PowerupsDropChk.SetBool("selected", bPowerupsDrop);
    BunnyChk.SetBool("selected", bAllowBunny);
    BrightskinChk.SetBool("selected", bBrightSkin);
    RocketJumpChk.SetBool("selected", bRocketJump);
    //return;    
}

function LoadProfileData()
{
    // End:0x325
    if((PKPlayerController(GetPC()) != none) && PKPlayerController(GetPC()).CanReadProfileMP())
    {
        ServerName = PKPlayerController(GetPC()).GetStringValueMP(75);
        FragLimit = PKPlayerController(GetPC()).GetIntValueMP(69);
        TimeLimit = PKPlayerController(GetPC()).GetIntValueMP(70);
        MaxPlayers = PKPlayerController(GetPC()).GetIntValueMP(71);
        MaxSpectators = PKPlayerController(GetPC()).GetIntValueMP(72);
        WeaponRespawnTime = PKPlayerController(GetPC()).GetIntValueMP(73);
        bPublicGame = PKPlayerController(GetPC()).GetPublicGameMP();
        bTeamDamage = PKPlayerController(GetPC()).GetTeamDamageMP();
        bWeaponStay = PKPlayerController(GetPC()).GetWeaponStayMP();
        bPowerUps = PKPlayerController(GetPC()).GetPowerupsMP();
        bPowerupsDrop = PKPlayerController(GetPC()).GetPowerupsDropMP();
        bAllowBunny = PKPlayerController(GetPC()).GetAllowBunnyMP();
        bBrightSkin = PKPlayerController(GetPC()).GetBrightskinMP();
        bRocketJump = PKPlayerController(GetPC()).GetRocketJumpMP();
    }
    //return;    
}

function SaveProfileData()
{
    PKPlayerController(GetPC()).SetStringValueMP(75, ServerName);
    PKPlayerController(GetPC()).SetIntValueMP(69, FragLimit);
    PKPlayerController(GetPC()).SetIntValueMP(70, TimeLimit);
    PKPlayerController(GetPC()).SetIntValueMP(71, MaxPlayers);
    PKPlayerController(GetPC()).SetIntValueMP(72, MaxSpectators);
    PKPlayerController(GetPC()).SetIntValueMP(73, WeaponRespawnTime);
    PKPlayerController(GetPC()).SetFlagsMP(bPublicGame, bTeamDamage, bWeaponStay, bPowerUps, bPowerupsDrop, bAllowBunny, bBrightSkin, bRocketJump);
    //return;    
}

function ValidateServerType()
{
    local int PlayerIndex, ValueIndex, PlayerControllerId;
    local name MatchTypeName;

    MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'ServerType360' : 'ServerType');
    PlayerIndex = Class'Engine.UIInteraction'.static.GetPlayerIndex(GetLP().ControllerId);
    PlayerControllerId = Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
    // End:0x154
    if(!Class'Engine.UIInteraction'.static.IsLoggedIn(PlayerControllerId, true))
    {
        ValueIndex = StringListDataStore.GetCurrentValueIndex(MatchTypeName);
        // End:0x154
        if(ValueIndex != 0)
        {
            StringListDataStore.SetCurrentValueIndex(MatchTypeName, 0);
        }
    }
    //return;    
}

function SetupGameSettings()
{
    local int ValueIndex, propId;
    local PKGameSettingsCommon GameSettings;
    local string SelectedMap, SelectedGameMode, ServerPassword;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GameSettings = PKGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    // End:0xC7
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
    {
        ValueIndex = StringListDataStore.GetCurrentValueIndex('ServerType360');        
    }
    else
    {
        ValueIndex = StringListDataStore.GetCurrentValueIndex('ServerType');
    }
    ValueIndex = ((bLANSelected) ? 0 : 1);
    switch(ValueIndex)
    {
        // End:0x170
        case 0:
            GameSettings.bIsLanMatch = true;
            GameSettings.bUsesArbitration = false;
            // End:0x226
            break;
        // End:0x1B9
        case 1:
            GameSettings.bIsLanMatch = false;
            GameSettings.bUsesArbitration = false;
            // End:0x226
            break;
        // End:0x223
        case 2:
            GameSettings.bIsLanMatch = false;
            GameSettings.bUsesArbitration = true;
            GameSettings.NumPrivateConnections = 0;
            // End:0x226
            break;
        // End:0xFFFF
        default:
            break;
    }
    GameSettings.NumPrivateConnections = 0;
    GameSettings.NumPublicConnections = MaxPlayers;
    GameSettings.MaxPlayers = MaxPlayers;
    GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections;
    GameSettings.NumOpenPrivateConnections = GameSettings.NumPrivateConnections;
    Registry.GetData("SelectedMap", SelectedMap);
    Registry.GetData("SelectedGameMode", SelectedGameMode);
    SelectedMap = CycleMapList[0];
    GameSettings.SetPropertyFromStringByName('CustomMapName', SelectedMap);
    GameSettings.SetPropertyFromStringByName('CustomGameMode', SelectedGameMode);
    // End:0x481
    if(Registry.GetData("ServerPassword", ServerPassword))
    {
        ServerPassword = XORString(ServerPassword, 17);
        GameSettings.SetPropertyFromStringByName('OwnerId', ServerPassword);
    }
    Registry.GetData("ServerMOTD", Class'EvilGame.EvilGameReplicationInfo'.default.MessageOfTheDay);
    GameSettings.bShouldAdvertise = true;
    // End:0x550
    if(GameSettings.GetPropertyId('GoalScore', propId))
    {
        GameSettings.SetIntProperty(propId, FragLimit);
    }
    // End:0x5B5
    if(GameSettings.GetPropertyId('TimeLimit', propId))
    {
        GameSettings.SetIntProperty(propId, TimeLimit);
    }
    SaveProfileData();
    //return;    
}

static function string ReplaceInvalidPasswordCharacters(string PasswordString, optional string InvalidChars = " \"/:?,=%#", optional string ValidChars = "abcdefghi")
{
    local int I;

    I = 0;
    J0x29:

    // End:0x90 [Loop If]
    if(I < Len(InvalidChars))
    {
        PasswordString = Repl(PasswordString, Mid(InvalidChars, I, 1), Mid(ValidChars, I, 1));
        I++;
        // [Loop Continue]
        goto J0x29;
    }
    return PasswordString;
    //return ReturnValue;    
}

function OnGameCreated(name SessionName, bool bWasSuccessful)
{
    local OnlineGameSettings LocalGameSettings;
    local string TravelURL, Mutators;
    local int OutValue;
    local string OutStringValue, GameClass;
    local UIDataStore_Registry Registry;
    local array<string> MapNames;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    // End:0x855
    if(OnlineSub != none)
    {
        // End:0x852
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameInterface.ClearCreateOnlineGameCompleteDelegate(OnGameCreated);
            // End:0x84F
            if(bWasSuccessful)
            {
                LocalGameSettings = SettingsDataStore.GetCurrentGameSettings();
                LocalGameSettings.bIsDedicated = StringListDataStore.GetCurrentValueIndex('DedicatedServer') == 1;
                LocalGameSettings.BuildURL(TravelURL);
                // End:0x1F5
                if(Registry.GetData("ServerPassword", OutStringValue) && Len(OutStringValue) > 0)
                {                    
                    TravelURL $= ("?GamePassword=" $ (XORString(OutStringValue, 17)));
                    LocalGameSettings.SetStringSettingValue(7, 1, false);                    
                }
                else
                {
                    LocalGameSettings.SetStringSettingValue(7, 0, false);
                }
                // End:0x278
                if(LocalGameSettings.GetIntProperty(268435703, OutValue))
                {                    
                    TravelURL $= ("?NumPlay=" $ string(OutValue + 1));
                }
                Registry.GetData("SelectedGameMode", OutStringValue);                
                TravelURL $= ("?game=" $ OutStringValue);
                GameClass = Right(OutStringValue, Len(OutStringValue) - 16);
                Mutators = Class'EvilGame.GFxUDKFrontEnd_Mutators'.static.GetEnabledMutators();
                // End:0x363
                if(Len(Mutators) > 0)
                {                    
                    TravelURL $= ("?mutator=" $ Mutators);
                }                
                TravelURL $= ("?TeamDamage=" $ string(bTeamDamage));                
                TravelURL $= ("?PowerUps=" $ string(bPowerUps));                
                TravelURL $= ("?WeaponStay=" $ string(bWeaponStay));                
                TravelURL $= ("?WeaponRespawnTime=" $ string(WeaponRespawnTime));                
                TravelURL $= ("?PowerupsDrop=" $ string(bPowerupsDrop));                
                TravelURL $= ("?AllowBunny=" $ string(bAllowBunny));                
                TravelURL $= ("?Brightskin=" $ string(bBrightSkin));                
                TravelURL $= ("?RocketJump=" $ string(bRocketJump));
                Registry.GetData("SelectedMap", OutStringValue);
                switch(GameClass)
                {
                    // End:0x5B8
                    case "PKGameDeathmatch_Content":
                        PKPlayerController(GetPC()).SetIntValueMP(87, 1);
                        MapNames = Class'PKGameMP_Base'.default.DeathmatchRotationMaps;
                        SaveMapList(0);
                        // End:0x77E
                        break;
                    // End:0x63C
                    case "PKGameTeamDeathmatch_Content":
                        PKPlayerController(GetPC()).SetIntValueMP(87, 2);
                        MapNames = Class'PKGameMP_Base'.default.TeamDeathmatchRotationMaps;
                        SaveMapList(1);
                        // End:0x77E
                        break;
                    // End:0x6B6
                    case "PKGameCTF_Content":
                        PKPlayerController(GetPC()).SetIntValueMP(87, 3);
                        MapNames = Class'PKGameMP_Base'.default.CtfRorationMaps;
                        SaveMapList(2);
                        // End:0x77E
                        break;
                    // End:0x735
                    case "PKGameSurvival_Content":
                        PKPlayerController(GetPC()).SetIntValueMP(87, 4);
                        MapNames = Class'PKGameMP_Base'.default.SurvivalRotationMaps;
                        SaveMapList(3);
                        // End:0x77E
                        break;
                    // End:0x77B
                    case "PKGameCooperative":
                        PKPlayerController(GetPC()).SetIntValueMP(87, 5);
                        // End:0x77E
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                PKPlayerController(GetPC()).SetIntValueMP(86, 1);
                // End:0x7DD
                if(!bLANSelected)
                {                    
                    TravelURL $= "?steamsockets";
                }
                TravelURL = (("" $ MapNames[0]) $ TravelURL) $ "?listen";
                Class'Engine.WorldInfo'.static.GetWorldInfo().ServerTravel(TravelURL, true);                
            }            
        }        
    }
    //return;    
}

function SaveMapList(int SelectedIndex)
{
    Class'PKGameMP_Base'.static.StaticSaveConfig();
    //return;    
}

function LoadMapList(int SelectedIndex)
{
    LoadMapListFromPData(SelectedIndex);
    //return;    
}

function SaveMapListToPData(int GameTypeId)
{
    Class'PKGameMP_Base'.static.StaticSaveConfig();
    //return;    
}

function LoadMapListFromPData(int GameTypeId)
{
    switch(GameTypeId)
    {
        // End:0x42
        case 0:
            CycleMapList = Class'PKGameMP_Base'.default.DeathmatchRotationMaps;
            // End:0xD4
            break;
        // End:0x71
        case 1:
            CycleMapList = Class'PKGameMP_Base'.default.TeamDeathmatchRotationMaps;
            // End:0xD4
            break;
        // End:0xA1
        case 2:
            CycleMapList = Class'PKGameMP_Base'.default.CtfRorationMaps;
            // End:0xD4
            break;
        // End:0xD1
        case 3:
            CycleMapList = Class'PKGameMP_Base'.default.SurvivalRotationMaps;
            // End:0xD4
            break;
        // End:0xFFFF
        default:
            break;
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
    I = 0;
    J0x66:

    // End:0x12A [Loop If]
    if(I < SupportedGameTypes.Length)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", SupportedGameTypes[I].Typename);
        DataProvider.SetElementObject(ListCounter++, TempObj);
        I++;
        // [Loop Continue]
        goto J0x66;
    }
    GameTypeDropdown.SetObject("dataProvider", DataProvider);
    GameTypeDataProvider = GameTypeDropdown.GetObject("dataProvider");
    Registry.SetData("SelectedGameModePrefix", SupportedGameTypes[0].TypePrefix);
    Registry.SetData("SelectedGameMode", SupportedGameTypes[0].TypeClass);
    //return;    
}

function UpdateListDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, DataProviderCycle, TempObj;
    local array<UDKUIResourceDataProvider> ProviderList;
    local array<UTUIDataProvider_MapInfo> LocalMapList;
    local UIDataStore_Registry Registry;
    local PKPlayerController PC;

    PC = PKPlayerController(GetPC());
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Maps.Length = 0;
    LocalMapList.Length = 0;
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0xAD:

    // End:0x1A1 [Loop If]
    if(I < ProviderList.Length)
    {
        // End:0x11F
        if(!PC.CheckIfUserHasRightsToThatSpecificMap(Caps(UTUIDataProvider_MapInfo(ProviderList[I]).MapName)))
        {            
        }
        else
        {
            // End:0x16A
            if(DropMapNames.Find(UTUIDataProvider_MapInfo(ProviderList[I]).MapName) != -1)
            {                
            }
            else
            {
                LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));
            }
        }
        I++;
        // [Loop Continue]
        goto J0xAD;
    }
    // End:0x1B3
    if(LocalMapList.Length == 0)
    {
        return;
    }
    LocalMapList.Sort(MapListSort);
    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x1FB:

    // End:0x4D0 [Loop If]
    if(I < LocalMapList.Length)
    {
        // End:0x4C2
        if(!LocalMapList[I].ShouldBeFiltered())
        {
            Maps.AddItem(LocalMapList[I]);
            TempObj = CreateObject("Object");
            // End:0x30E
            if(LocalMapList[I].FromWorkshop)
            {
                TempObj.SetString("label", Caps("*" $ (GetMapFriendlyName(LocalMapList[I].MapName))));                
            }
            else
            {
                TempObj.SetString("label", Caps(GetMapFriendlyName(LocalMapList[I].MapName)));
            }
            TempObj.SetString("players", LocalMapList[I].NumPlayers);
            // End:0x445
            if(LocalMapList[I].PreviewImageMarkup != "")
            {
                TempObj.SetString("image", "img://" $ LocalMapList[I].PreviewImageMarkup);                
            }
            else
            {
                TempObj.SetString("image", "img://" $ "UDKFrontEnd.gm_map_none");
            }
            DataProvider.SetElementObject(ListCounter++, TempObj);
        }
        I++;
        // [Loop Continue]
        goto J0x1FB;
    }
    MapList.SetObject("dataProvider", DataProvider);
    MapListDataProvider = MapList.GetObject("dataProvider");
    DataProviderCycle = CreateArray();
    MapListCycle.SetObject("dataProvider", DataProviderCycle);
    MapList.SetFloat("selectedIndex", 0.0000000);
    Registry.SetData("SelectedMap", Maps[0].MapName);
    //return;    
}

delegate int MapListSort(UTUIDataProvider_MapInfo A, UTUIDataProvider_MapInfo B)
{
    return ((A.MapName > B.MapName) ? -1 : 0);
    //return ReturnValue;    
}

function OnInternetLANSelect(EventData ev)
{
    local name MatchTypeName;
    local DataStoreClient DSClient;

    bLANSelected = InternetLANCheckbox.GetBool("selected");
    MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'ServerType360' : 'ServerType');
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
    StringListDataStore.SetCurrentValueIndex(MatchTypeName, ((bLANSelected) ? 0 : 1));
    //return;    
}

function SetGameType(int SelectedIndex)
{
    local int Id;
    local PKGameSettingsCommon GameSettings;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    LastSelectedGame = int(GameTypeDropdown.GetFloat("selectedIndex"));
    // End:0xA0
    if(LastSelectedGame != SelectedIndex)
    {
        SaveMapList(LastSelectedGame);
    }
    GameTypeDropdown.SetFloat("selectedIndex", float(SelectedIndex));
    SettingsDataStore.SetCurrentByName(name(SupportedGameTypes[SelectedIndex].TypeSettings));
    Registry.SetData("SelectedGameModePrefix", SupportedGameTypes[SelectedIndex].TypePrefix);
    Registry.SetData("SelectedGameMode", SupportedGameTypes[SelectedIndex].TypeClass);
    UpdateListDataProvider();
    CycleMapList.Length = 0;
    LoadMapList(SelectedIndex);
    BuildMapList(SelectedIndex);
    GameSettings = PKGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    // End:0x286
    if(PKGameCTFSettings(GameSettings) != none)
    {
        FraglimitTF.SetText(FlagLimitString);        
    }
    else
    {
        FraglimitTF.SetText(FragLimitString);
    }
    // End:0x314
    if(GameSettings.GetPropertyId('GoalScore', Id))
    {
        GameSettings.GetIntProperty(Id, FragLimit);
    }
    FragLimitInp.SetInt("value", FragLimit);
    // End:0x3A8
    if(GameSettings.GetPropertyId('TimeLimit', Id))
    {
        GameSettings.GetIntProperty(Id, TimeLimit);
    }
    TimeLimitInp.SetInt("value", TimeLimit);
    MaxPlayersInp.SetInt("maximum", GameSettings.MaxPlayers);
    MaxPlayersInp.SetInt("value", GameSettings.MaxPlayers);
    //return;    
}

function OnGameTypeDropdownChange(EventData ev)
{
    local int SelectedIndex, Id;
    local PKGameSettingsCommon GameSettings;
    local UIDataStore_Registry Registry;

    SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex"));
    // End:0x64
    if(LastSelectedGame != SelectedIndex)
    {
        SaveMapList(LastSelectedGame);
    }
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    SettingsDataStore.SetCurrentByName(name(SupportedGameTypes[SelectedIndex].TypeSettings));
    Registry.SetData("SelectedGameModePrefix", SupportedGameTypes[SelectedIndex].TypePrefix);
    Registry.SetData("SelectedGameMode", SupportedGameTypes[SelectedIndex].TypeClass);
    UpdateListDataProvider();
    CycleMapList.Length = 0;
    LoadMapList(SelectedIndex);
    BuildMapList(SelectedIndex);
    GameSettings = PKGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    // End:0x24D
    if(PKGameCTFSettings(GameSettings) != none)
    {
        FraglimitTF.SetText(FlagLimitString);        
    }
    else
    {
        FraglimitTF.SetText(FragLimitString);
    }
    // End:0x2DB
    if(GameSettings.GetPropertyId('GoalScore', Id))
    {
        GameSettings.GetIntProperty(Id, FragLimit);
    }
    FragLimitInp.SetInt("value", FragLimit);
    // End:0x36F
    if(GameSettings.GetPropertyId('TimeLimit', Id))
    {
        GameSettings.GetIntProperty(Id, TimeLimit);
    }
    TimeLimitInp.SetInt("value", TimeLimit);
    MaxPlayersInp.SetInt("maximum", GameSettings.MaxPlayers);
    MaxPlayersInp.SetInt("value", GameSettings.MaxPlayers);
    LastSelectedGame = SelectedIndex;
    //return;    
}

function AddMapForGivenGameType(string MapName, int GameTypeIndex)
{
    switch(GameTypeIndex)
    {
        // End:0x45
        case 0:
            Class'PKGameMP_Base'.default.DeathmatchRotationMaps.AddItem(MapName);
            // End:0xE0
            break;
        // End:0x77
        case 1:
            Class'PKGameMP_Base'.default.TeamDeathmatchRotationMaps.AddItem(MapName);
            // End:0xE0
            break;
        // End:0xAA
        case 2:
            Class'PKGameMP_Base'.default.CtfRorationMaps.AddItem(MapName);
            // End:0xE0
            break;
        // End:0xDD
        case 3:
            Class'PKGameMP_Base'.default.SurvivalRotationMaps.AddItem(MapName);
            // End:0xE0
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function RemoveMapForGivenGameType(int mapindex, int GameTypeIndex)
{
    switch(GameTypeIndex)
    {
        // End:0x44
        case 0:
            Class'PKGameMP_Base'.default.DeathmatchRotationMaps.Remove(mapindex, 1);
            // End:0xDC
            break;
        // End:0x75
        case 1:
            Class'PKGameMP_Base'.default.TeamDeathmatchRotationMaps.Remove(mapindex, 1);
            // End:0xDC
            break;
        // End:0xA7
        case 2:
            Class'PKGameMP_Base'.default.CtfRorationMaps.Remove(mapindex, 1);
            // End:0xDC
            break;
        // End:0xD9
        case 3:
            Class'PKGameMP_Base'.default.SurvivalRotationMaps.Remove(mapindex, 1);
            // End:0xDC
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function int GetMapArrayLengthForGivenGameType(int GameTypeIndex)
{
    switch(GameTypeIndex)
    {
        // End:0x37
        case 0:
            return Class'PKGameMP_Base'.default.DeathmatchRotationMaps.Length;
        // End:0x5B
        case 1:
            return Class'PKGameMP_Base'.default.TeamDeathmatchRotationMaps.Length;
        // End:0x80
        case 2:
            return Class'PKGameMP_Base'.default.TeamDeathmatchRotationMaps.Length;
        // End:0xA5
        case 3:
            return Class'PKGameMP_Base'.default.TeamDeathmatchRotationMaps.Length;
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    //return ReturnValue;    
}

function OnListChange(EventData ev)
{
    local int SelectedIndex;
    local string SelectedMapName;

    SelectedIndex = int(MapList.GetFloat("selectedIndex"));
    // End:0x54
    if(SelectedIndex >= Maps.Length)
    {
        return;
    }
    SelectedMapName = Maps[SelectedIndex].MapName;
    AddMapForGivenGameType(SelectedMapName, LastSelectedGame);
    CycleMapList.AddItem(SelectedMapName);
    BuildMapList(SelectedIndex);
    //return;    
}

function OnListChange2(EventData ev)
{
    local int SelectedIndex;
    local string SelectedMapName;

    SelectedIndex = int(MapListCycle.GetFloat("selectedIndex"));
    // End:0x5D
    if(SelectedIndex >= (GetMapArrayLengthForGivenGameType(LastSelectedGame)))
    {
        return;
    }
    SelectedMapName = Maps[SelectedIndex].MapName;
    RemoveMapForGivenGameType(SelectedIndex, LastSelectedGame);
    CycleMapList.Remove(SelectedIndex, 1);
    BuildMapList(SelectedIndex);
    //return;    
}

function BuildMapList(int SelectedIndex)
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;

    DataProvider = CreateArray();
    ListCounter = 0;
    I = 0;
    J0x2A:

    // End:0xE7 [Loop If]
    if(I < CycleMapList.Length)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", Caps(GetMapFriendlyName(CycleMapList[I])));
        DataProvider.SetElementObject(ListCounter++, TempObj);
        I++;
        // [Loop Continue]
        goto J0x2A;
    }
    MapListCycle.SetObject("dataProvider", DataProvider);
    MapListCycle.SetFloat("selectedIndex", 0.0000000);
    //return;    
}

function OnListRollOver(int I)
{
    local UTUIDataProvider_MapInfo tmMap;
    local OnlineSubsystemSteamworks steam;
    local WorkshopPackageInfo wsPackageInfo;

    steam = OnlineSubsystemSteamworks(Class'Engine.GameEngine'.static.GetOnlineSubsystem());
    // End:0x67
    if(Maps.Length > I)
    {
        tmMap = Maps[I];
    }
    // End:0x19C
    if(tmMap != none)
    {
        // End:0x17C
        if(tmMap.FromWorkshop)
        {
            wsPackageInfo = steam.FindWorkshopPackageInfoForGivenPackageName(tmMap.WorkshopPackageName);
            WorkshopWindow.SetVisible(true);
            AuthorHeaderTF.SetText(wsPackageInfo.EntryTitle);
            AuthorTF.SetText(tmMap.Author);            
        }
        else
        {
            WorkshopWindow.SetVisible(false);
        }
    }
    //return;    
}

function OnItemRollOut(EventData ev)
{
    //return;    
}

function OnServerNameChanged(EventData ev)
{
    ServerName = ServerNameInp.GetString("text");
    //return;    
}

function OnPasswordChanged(EventData ev)
{
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Password = PasswordInp.GetString("text");
    Registry.SetData("ServerPassword", Password);
    //return;    
}

function OnFragLimitChanged(EventData ev)
{
    FragLimit = FragLimitInp.GetInt("value");
    //return;    
}

function OnTimeLimitChanged(EventData ev)
{
    TimeLimit = TimeLimitInp.GetInt("value");
    //return;    
}

function OnMaxPlayersChanged(EventData ev)
{
    MaxPlayers = MaxPlayersInp.GetInt("value");
    //return;    
}

function OnMaxSpectatorsChanged(EventData ev)
{
    MaxSpectators = MaxSpectatorsInp.GetInt("value");
    //return;    
}

function OnTeamDamageSelect(EventData ev)
{
    bTeamDamage = TeamDamageChk.GetBool("selected");
    //return;    
}

function OnWeaponsStaySelect(EventData ev)
{
    bWeaponStay = WeaponStayChk.GetBool("selected");
    //return;    
}

function OnWeaponsRespawnLimitChanged(EventData ev)
{
    WeaponRespawnTime = WeaponRespawnInp.GetInt("value");
    //return;    
}

function OnPowerupsSelect(EventData ev)
{
    bPowerUps = PowerupsChk.GetBool("selected");
    //return;    
}

function OnPowerupsDropSelect(EventData ev)
{
    bPowerupsDrop = PowerupsDropChk.GetBool("selected");
    //return;    
}

function OnBunnySelect(EventData ev)
{
    bAllowBunny = BunnyChk.GetBool("selected");
    //return;    
}

function OnBrightskinSelect(EventData ev)
{
    bBrightSkin = BrightskinChk.GetBool("selected");
    //return;    
}

function OnRocketJumpSelect(EventData ev)
{
    bRocketJump = RocketJumpChk.GetBool("selected");
    //return;    
}

function OnSelect(EventData ev)
{
    OnListChange(ev);
    // End:0x48
    if((GetMapArrayLengthForGivenGameType(LastSelectedGame)) > 0)
    {
        Action = "select";
        PlayCloseAnimation();
    }
    //return;    
}

function OnBack(EventData ev)
{
    // End:0x1A
    if(bShowingAdvanced)
    {
        ShowAdvanced(false);
        return;
    }
    SaveMapList(LastSelectedGame);
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnShowAdvancedOptions(EventData ev)
{
    // End:0x1A
    if(!bShowingAdvanced)
    {
        ShowAdvanced(true);
    }
    //return;    
}

function OnNewGameBtn(EventData ev)
{
    // End:0x36
    if((GetMapArrayLengthForGivenGameType(LastSelectedGame)) > 0)
    {
        Action = "newgame";
        PlayCloseAnimation();
    }
    //return;    
}

function ShowAdvanced(bool bShow)
{
    bShowingAdvanced = bShow;
    // End:0x443
    if(bShow)
    {
        PasswordInp.SetBool("disabled", true);
        FragLimitInp.SetBool("disabled", true);
        TimeLimitInp.SetBool("disabled", true);
        MaxPlayersInp.SetBool("disabled", true);
        MaxSpectatorsInp.SetBool("disabled", true);
        ShowAdvancedBtn.SetBool("disabled", true);
        InternetLANCheckbox.SetBool("disabled", true);
        GameTypeDropdown.SetBool("disabled", true);
        NewGameBtn.SetBool("disabled", true);
        BackBtn.SetBool("disabled", true);
        MapList.SetBool("disabled", true);
        MapListCycle.SetBool("disabled", true);
        TeamDamageChk.SetBool("visible", true);
        WeaponStayChk.SetBool("visible", true);
        WeaponRespawnInp.SetBool("visible", true);
        PowerupsChk.SetBool("visible", true);
        PowerupsDropChk.SetBool("visible", true);
        BunnyChk.SetBool("visible", true);
        BrightskinChk.SetBool("visible", true);
        RocketJumpChk.SetBool("visible", true);
        WeaponRespawnTF.SetText(WeaponResTimeString);
        // End:0x3F0
        if(!GetPC().WorldInfo.IsConsoleBuild(0))
        {
            HideAdvancedBtn.SetBool("visible", true);
        }
        PowerupsDropChk.SetBool("focused", true);
        AdvancedBG.GotoAndPlay("fadein");        
    }
    else
    {
        PasswordInp.SetBool("disabled", false);
        FragLimitInp.SetBool("disabled", false);
        TimeLimitInp.SetBool("disabled", false);
        MaxPlayersInp.SetBool("disabled", false);
        MaxSpectatorsInp.SetBool("disabled", false);
        ShowAdvancedBtn.SetBool("disabled", false);
        InternetLANCheckbox.SetBool("disabled", false);
        GameTypeDropdown.SetBool("disabled", false);
        NewGameBtn.SetBool("disabled", false);
        BackBtn.SetBool("disabled", false);
        MapList.SetBool("disabled", false);
        MapListCycle.SetBool("disabled", false);
        TeamDamageChk.SetBool("visible", false);
        WeaponStayChk.SetBool("visible", false);
        WeaponRespawnInp.SetBool("visible", false);
        PowerupsChk.SetBool("visible", false);
        PowerupsDropChk.SetBool("visible", false);
        BunnyChk.SetBool("visible", false);
        BrightskinChk.SetBool("visible", false);
        RocketJumpChk.SetBool("visible", false);
        WeaponRespawnTF.SetText(" ");
        HideAdvancedBtn.SetBool("visible", false);
        NewGameBtn.SetBool("focused", true);
        AdvancedBG.GotoAndPlay("fadeout");
    }
    // End:0x84E
    if(FrontEnd.footer != none)
    {
        UpdateFooter();
    }
    //return;    
}

function string GetMapFriendlyName(string Map)
{
    local int I, P, StartIndex, EndIndex;
    local array<string> LocPieces;

    I = 0;
    J0x0B:

    // End:0x1EB [Loop If]
    if(I < Maps.Length)
    {
        // End:0x1DD
        if(Maps[I].MapName ~= Map)
        {
            StartIndex = InStr(Caps(Maps[I].FriendlyName), "<STRINGS:");
            // End:0xB3
            if(StartIndex == -1)
            {
                // [Explicit Break]
                goto J0x1EB;
            }
            Map = Right(Maps[I].FriendlyName, (Len(Maps[I].FriendlyName) - StartIndex) - 9);
            EndIndex = InStr(Map, ">");
            // End:0x1D3
            if(EndIndex != -1)
            {
                Map = Left(Map, EndIndex);
                ParseStringIntoArray(Map, LocPieces, ".", true);
                // End:0x1D3
                if(LocPieces.Length >= 3)
                {
                    Map = Localize(LocPieces[1], LocPieces[2], LocPieces[0]);
                }
            }
            return Map;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x1EB:

    P = InStr(Map, "-");
    // End:0x247
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    P = InStr(Map, "-");
    // End:0x2A3
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    Map = Left(Map, Len(Map) - 2);
    return Map;
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

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x116
        case "back":
            // End:0xC7
            if(GetPC().WorldInfo.IsConsoleBuild(0))
            {
                bTransitionResult = FrontEnd.OpenMultiMenuXboxCreateJoinScreen(SupportedGameTypes[int(GetMenuGame().MultiGameModeSelected) - int(1)].Typename);                
            }
            else
            {
                GetMenuGame().MultiGameModeSelected = 0;
                bTransitionResult = FrontEnd.OpenMultiMenuScreen();
            }
            // End:0x3AC
            break;
        // End:0x236
        case "newgame":
            // End:0x233
            if(OnlineSub != none)
            {
                // End:0x230
                if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
                {
                    GameInterface.DestroyOnlineGame('Game');
                    SetupGameSettings();
                    GameInterface.AddCreateOnlineGameCompleteDelegate(OnGameCreated);
                    // End:0x22D
                    if(SettingsDataStore.CreateGame(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(0))) == false)
                    {
                        GameInterface.ClearCreateOnlineGameCompleteDelegate(OnGameCreated);
                    }                    
                }                
            }
            // End:0x3AC
            break;
        // End:0x3A6
        case "select":
            OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
            // End:0x3A3
            if(OnlineSub != none)
            {
                GameInterface = OnlineSub.GameInterface;
                // End:0x3A0
                if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
                {
                    GameInterface.DestroyOnlineGame('Game');
                    SetupGameSettings();
                    GameInterface.AddCreateOnlineGameCompleteDelegate(OnGameCreated);
                    // End:0x39D
                    if(SettingsDataStore.CreateGame(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(0))) == false)
                    {
                        GameInterface.ClearCreateOnlineGameCompleteDelegate(OnGameCreated);
                    }                    
                }                
            }
            // End:0x3AC
            break;
        // End:0xFFFF
        default:
            // End:0x3AC
            break;
            break;
    }
    // End:0x3D8
    if(bTransitionResult)
    {
        FrontEnd.CloseMultiHostScreen();
    }
    Action = "";
    //return;    
}

function OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
    //return;    
}

function CreateLobby(int NumPlayers, string steamId)
{
    local array<LobbyMetaData> InitialSettings;

    InitialSettings.Add(1);
    InitialSettings[0].Key = "STEAMID";
    InitialSettings[0].Value = steamId;
    LobbyInterface.AddCreateLobbyCompleteDelegate(OnCreateLobbyComplete);
    // End:0xC2
    if(LobbyInterface.CreateLobby(NumPlayers, 0, InitialSettings))
    {
    }
    //return;    
}

function OnCreateLobbyComplete(bool bWasSuccessful, UniqueNetId LobbyId, string Error)
{
    LobbyInterface.ClearCreateLobbyCompleteDelegate(OnCreateLobbyComplete);
    //return;    
}

static function string XORString(string srcStr, byte Key)
{
    local int I;
    local byte S;
    local string Retval;

    I = 0;
    J0x0B:

    // End:0x84 [Loop If]
    if(I < Len(srcStr))
    {
        S = byte(Asc(Mid(srcStr, I, 1)));
        Retval = Retval $ Chr(int(S) ^ int(Key));
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    return ReplaceInvalidPasswordCharacters(Retval);
    //return ReturnValue;    
}

defaultproperties
{
    DefaultMapName="DM-Unseen_HD"
    DefaultGameMode="PKHDGameContent.PKGameDeathmatch_Content"
    DefaultGameModeSettings="PKGameSettingsDeathMatch"
    DefaultMapImage="UI_FrontEnd_Art.MapPics.___map-pic-dm-deck"
    DefaultGameModePrefixes="DM"
    bPublicGame=true
    bWeaponStay=true
    bPowerUps=true
    bAllowBunny=true
    bBrightSkin=true
    bRocketJump=true
    SupportedGameTypes[0]=(Typename="Deathmatch",TypeClass="PKHDGameContent.PKGameDeathmatch_Content",TypePrefix="DM",TypeSettings="PKGameSettingsDeathMatch")
    SupportedGameTypes[1]=(Typename="Team Deathmatch",TypeClass="PKHDGameContent.PKGameTeamDeathmatch_Content",TypePrefix="DM",TypeSettings="PKGameSettingsTeamDeathMatch")
    SupportedGameTypes[2]=(Typename="Capture The Flag",TypeClass="PKHDGameContent.PKGameCTF_Content",TypePrefix="CTF",TypeSettings="PKGameSettingsCTF")
    SupportedGameTypes[3]=(Typename="Survival",TypeClass="PKHDGameContent.PKGameSurvival_Content",TypePrefix="SV",TypeSettings="PKGameSettingsSurvival")
    FragLimit=30
    TimeLimit=20
    MaxPlayers=32
    MaxSpectators=4
    WeaponRespawnTime=30
    TitleString="Host setup"
    NewGameString="Start Game"
    GameTypeString="Game Type"
    LanInternetString="Lan Game"
    PublicGameString="Public Server"
    MapListString="Maps"
    ServerMapListString="Server Map List"
    ServerNameString="Server Name"
    ServerNameLabelString="Unknown Server"
    ServerPasswordString="Server Password"
    TimeLimitString="Time Limit"
    FragLimitString="Frag Limit"
    FlagLimitString="Capture Limit"
    MaxSpectatorsString="Max Spectators"
    MaxPlayersString="Max Players"
    WeaponResTimeString="Weapons Respawn Time"
    AdvancedOptionsString="Show Advanced"
    HideAdvancedOptionsString="Hide Advanced"
    PowerDropsString="Powerups Drop"
    BrightskinString="Brightskins"
    TeamDamageString="Team Damage"
    WeaponStayString="Weapon Stay"
    BunnyHoppingString="Bunny Hopping"
    PowerupsString="Powerups"
    FwdRocketJumpString="Forward Rocket Jump"
    MovieInfo=SwfMovie'PKHD_UI.PKMultiHost'
}