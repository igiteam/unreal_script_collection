class AdvGFxUI_Menu_MultiCustomSearch extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject AdvancedMC;
var GFxObject GameTypesMC;
var GFxObject MapsMC;
var GFxObject AdvancedBG;
var GFxClikWidget DeathmatchBtn;
var GFxClikWidget TeamDeathmatchBtn;
var GFxClikWidget CTFBtn;
var GFxClikWidget TreasureHuntBtn;
var GFxClikWidget TeamTreasureHuntBtn;
var GFxClikWidget LastManBtn;
var GFxObject TitleTF;
var GFxObject SubtitleTF;
var GFxClikWidget NewGameBtn;
var GFxClikWidget ShowAdvancedBtn;
var GFxClikWidget HideAdvancedBtn;
var GFxClikWidget ShowMapsBtn;
var GFxClikWidget HideMapsBtn;
var GFxClikWidget ShowGametypesBtn;
var GFxClikWidget HideGametypesBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget MapMainGfx;
var GFxClikWidget MapList;
var GFxClikWidget MapListScrollbar;
var GFxObject MapListDataProvider;
var GFxClikWidget InternetLANDropdown;
var bool bLANSelected;
var bool bPublicGame;
var transient bool bShowingAdvanced;
var transient bool bShowingMaps;
var transient bool bShowingGametypes;
var bool bTeamDamage;
var bool bTraps;
var bool bKillingSpree;
var bool bOracle;
var bool bRealism;
var array<UTUIDataProvider_MapInfo> Maps;
var array<string> DropMapNames;
var string SelectedMapName;
var int SelectedMapIndex;
var GFxClikWidget ServerNameInp;
var GFxClikWidget PasswordInp;
var GFxClikWidget ScoreLimitDropdown;
var GFxClikWidget TimeLimitInp;
var GFxClikWidget MaxPlayersInp;
var GFxClikWidget MapGfx;
var string ServerName;
var string Password;
var int ScoreLimit;
var int TimeLimit;
var int MaxPlayers;
var GFxClikWidget TeamDamageDropdown;
var GFxClikWidget RespawnInp;
var GFxClikWidget TrapsDropdown;
var GFxClikWidget KillingSpreeDropdown;
var GFxClikWidget OracleDropdown;
var GFxClikWidget RealismDropdown;
var GFxClikWidget MaxSpectatorsInp;
var int RespawnTime;
var int MaxSpectators;
var GFxObject MapsTF;
var GFxObject MapDescriptionTF;
var GFxObject GametypesTF;
var GFxObject AdvancedTF;
var GFxObject GameTypeTF;
var GFxObject ServerMapsTF;
var GFxObject LanInternetTF;
var GFxObject ServerNameTF;
var GFxObject PasswordTF;
var GFxObject TimelimitTF;
var GFxObject ScorelimitTF;
var GFxObject SpectatorsTF;
var GFxObject MaxPlayersTF;
var GFxObject TeamDamageTF;
var GFxObject RespawnTF;
var GFxObject TrapsTF;
var GFxObject KillingSpreeTF;
var GFxObject OracleTF;
var GFxObject RealismTF;
var const localized string TitleString;
var const localized string SearchString;
//var delegate<MapListSort> __MapListSort__Delegate;

function bool Start(optional bool StartPaused = false)
{
    local int I;
    local array<string> GenericNoYes;
    local GFxObject OptionListProvider;

    super.Start(StartPaused);
    Advance(0.0000000);
    GenericNoYes[0] = Localize("Generic", "No", "ADVGame");
    GenericNoYes[1] = Localize("Generic", "Yes", "ADVGame");
    OptionListProvider = CreateArray();
    I = 0;
    J0xA0:

    // End:0x120 [Loop If]
    if(I < GenericNoYes.Length)
    {
        OptionListProvider.SetElementString(I, Class'Engine.UIRoot'.static.SafeCaps(GenericNoYes[I]));
        I++;
        // [Loop Continue]
        goto J0xA0;
    }
    bShowingAdvanced = false;
    bShowingGametypes = false;
    bShowingMaps = false;
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    SubtitleTF = TitleMC.GetObject("subtitle");
    AdvancedMC = ButtonsMC.GetObject("Advanced");
    AdvancedBG = AdvancedMC.GetObject("AdvancedBG");
    MapsMC = ButtonsMC.GetObject("mapsMC");
    GameTypesMC = ButtonsMC.GetObject("gametypeMC");
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("start_btn", Class'GFxUI.GFxClikWidget'));
    ShowAdvancedBtn = GFxClikWidget(ButtonsMC.GetObject("show_advanced", Class'GFxUI.GFxClikWidget'));
    HideAdvancedBtn = GFxClikWidget(AdvancedMC.GetObject("hide_btn", Class'GFxUI.GFxClikWidget'));
    ShowMapsBtn = GFxClikWidget(ButtonsMC.GetObject("show_maps", Class'GFxUI.GFxClikWidget'));
    HideMapsBtn = GFxClikWidget(MapsMC.GetObject("hidemaps_btn", Class'GFxUI.GFxClikWidget'));
    ShowGametypesBtn = GFxClikWidget(ButtonsMC.GetObject("show_gametype", Class'GFxUI.GFxClikWidget'));
    HideGametypesBtn = GFxClikWidget(GameTypesMC.GetObject("hidegametype_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x5E4
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    DeathmatchBtn = GFxClikWidget(GameTypesMC.GetObject("deathmatch_btn", Class'GFxUI.GFxClikWidget'));
    TeamDeathmatchBtn = GFxClikWidget(GameTypesMC.GetObject("teamdeathmatch_btn", Class'GFxUI.GFxClikWidget'));
    CTFBtn = GFxClikWidget(GameTypesMC.GetObject("capture_btn", Class'GFxUI.GFxClikWidget'));
    TreasureHuntBtn = GFxClikWidget(GameTypesMC.GetObject("treasurehunt_btn", Class'GFxUI.GFxClikWidget'));
    TeamTreasureHuntBtn = GFxClikWidget(GameTypesMC.GetObject("teamtreasurehunt_btn", Class'GFxUI.GFxClikWidget'));
    LastManBtn = GFxClikWidget(GameTypesMC.GetObject("lastman_btn", Class'GFxUI.GFxClikWidget'));
    MapsTF = MapsMC.GetObject("mapsTF");
    GametypesTF = GameTypesMC.GetObject("gametypesTF");
    AdvancedTF = AdvancedMC.GetObject("advancedTF");
    ServerNameTF = ButtonsMC.GetObject("servnameTF");
    LanInternetTF = ButtonsMC.GetObject("internetLANTF");
    TimelimitTF = ButtonsMC.GetObject("timelimitTF");
    ScorelimitTF = ButtonsMC.GetObject("fraglimitTF");
    MaxPlayersTF = ButtonsMC.GetObject("maxplayersTF");
    GameTypeTF = AdvancedMC.GetObject("gametypeTF");
    ServerMapsTF = AdvancedMC.GetObject("maplistTF");
    PasswordTF = AdvancedMC.GetObject("servpaswordTF");
    SpectatorsTF = AdvancedMC.GetObject("maxspectTF");
    RespawnTF = AdvancedMC.GetObject("respawntimeTF");
    TeamDamageTF = AdvancedMC.GetObject("teamdamageTF");
    TrapsTF = AdvancedMC.GetObject("trapsTF");
    KillingSpreeTF = AdvancedMC.GetObject("killingspreeTF");
    OracleTF = AdvancedMC.GetObject("oracleTF");
    RealismTF = AdvancedMC.GetObject("realismTF");
    InternetLANDropdown = GFxClikWidget(ButtonsMC.GetObject("internetLAN", Class'GFxUI.GFxClikWidget'));
    ScoreLimitDropdown = GFxClikWidget(ButtonsMC.GetObject("fraglimit", Class'GFxUI.GFxClikWidget'));
    TimeLimitInp = GFxClikWidget(ButtonsMC.GetObject("timelimit", Class'GFxUI.GFxClikWidget'));
    MaxPlayersInp = GFxClikWidget(ButtonsMC.GetObject("maxplayers", Class'GFxUI.GFxClikWidget'));
    ServerNameInp = GFxClikWidget(AdvancedMC.GetObject("servername", Class'GFxUI.GFxClikWidget'));
    PasswordInp = GFxClikWidget(AdvancedMC.GetObject("password", Class'GFxUI.GFxClikWidget'));
    MaxSpectatorsInp = GFxClikWidget(AdvancedMC.GetObject("maxspectators", Class'GFxUI.GFxClikWidget'));
    TeamDamageDropdown = GFxClikWidget(AdvancedMC.GetObject("teamdamage", Class'GFxUI.GFxClikWidget'));
    RespawnInp = GFxClikWidget(AdvancedMC.GetObject("respawntime", Class'GFxUI.GFxClikWidget'));
    TrapsDropdown = GFxClikWidget(AdvancedMC.GetObject("traps", Class'GFxUI.GFxClikWidget'));
    KillingSpreeDropdown = GFxClikWidget(AdvancedMC.GetObject("killingspree", Class'GFxUI.GFxClikWidget'));
    OracleDropdown = GFxClikWidget(AdvancedMC.GetObject("oracle", Class'GFxUI.GFxClikWidget'));
    RealismDropdown = GFxClikWidget(AdvancedMC.GetObject("realism", Class'GFxUI.GFxClikWidget'));
    MapList = GFxClikWidget(MapsMC.GetObject("list_helper", Class'GFxUI.GFxClikWidget'));
    MapListScrollbar = GFxClikWidget(MapsMC.GetObject("scroll1", Class'GFxUI.GFxClikWidget'));
    MapDescriptionTF = MapsMC.GetObject("mapdescriptionTF");
    MapGfx = GFxClikWidget(MapsMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    MapMainGfx = GFxClikWidget(ButtonsMC.GetObject("UILoaderMain", Class'GFxUI.GFxClikWidget'));
    InternetLANDropdown.SetObject("dataProvider", OptionListProvider);
    TeamDamageDropdown.SetObject("dataProvider", OptionListProvider);
    TrapsDropdown.SetObject("dataProvider", OptionListProvider);
    KillingSpreeDropdown.SetObject("dataProvider", OptionListProvider);
    OracleDropdown.SetObject("dataProvider", OptionListProvider);
    RealismDropdown.SetObject("dataProvider", OptionListProvider);
    InitDefaultOptions();
    RealismDropdown.SetBool("disabled", true);
    ShowMapsBtn.SetBool("visible", false);
    TitleTF.SetText(TitleString);
    NewGameBtn.SetString("label", SearchString);
    ShowAdvancedBtn.SetString("label", Class'AdvGFxUI_Menu_MultiHost'.default.AdvancedOptionsString);
    HideAdvancedBtn.SetString("label", Class'AdvGFxUI_Menu_MultiHost'.default.HideAdvancedOptionsString);
    ShowMapsBtn.SetString("label", Class'AdvGFxUI_Menu_MultiHost'.default.MapsOptionsString);
    HideMapsBtn.SetString("label", Class'AdvGFxUI_Menu_MultiHost'.default.HideMapsOptionsString);
    ShowGametypesBtn.SetString("label", Class'AdvGFxUI_Menu_MultiHost'.default.GametypesOptionsString);
    HideGametypesBtn.SetString("label", Class'AdvGFxUI_Menu_MultiHost'.default.HideGametypesOptionsString);
    DeathmatchBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(0).GameName);
    TeamDeathmatchBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(1).GameName);
    CTFBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(2).GameName);
    TreasureHuntBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(4).GameName);
    TeamTreasureHuntBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(6).GameName);
    LastManBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(5).GameName);
    // End:0x1744
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        InternetLANDropdown.SetBool("visible", false);
        LanInternetTF.SetText(" ");
        PasswordInp.SetBool("visible", false);
        PasswordTF.SetText(" ");
        SpectatorsTF.SetText(" ");
        MaxSpectatorsInp.SetVisible(false);
    }
    SetGameType(0);
    ShowAdvanced(false);
    ShowMaps(false);
    ShowGametypes(false);
    NewGameBtn.SetBool("focused", true);
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function InitDefaultOptions()
{
    InternetLANDropdown.SetFloat("selectedIndex", float(((bLANSelected) ? 1 : 0)));
    LoadProfileData();
    ScoreLimitDropdown.SetFloat("selectedIndex", 0.0000000);
    TimeLimitInp.SetInt("value", TimeLimit);
    MaxPlayersInp.SetInt("value", MaxPlayers);
    MaxSpectatorsInp.SetInt("value", MaxSpectators);
    RespawnInp.SetInt("value", RespawnTime);
    TeamDamageDropdown.SetFloat("selectedIndex", float(((bTeamDamage) ? 1 : 0)));
    TrapsDropdown.SetFloat("selectedIndex", float(((bTraps) ? 1 : 0)));
    KillingSpreeDropdown.SetFloat("selectedIndex", float(((bKillingSpree) ? 1 : 0)));
    OracleDropdown.SetFloat("selectedIndex", float(((bOracle) ? 1 : 0)));
    RealismDropdown.SetFloat("selectedIndex", float(((bRealism) ? 1 : 0)));
    //return;    
}

function LoadProfileData()
{
    // End:0x288
    if((AdvPlayerController(GetPC()) != none) && AdvPlayerController(GetPC()).CanReadProfileMP())
    {
        ServerName = AdvPlayerController(GetPC()).GetStringValueMP(75);
        TimeLimit = AdvPlayerController(GetPC()).GetIntValueMP(70);
        MaxPlayers = AdvPlayerController(GetPC()).GetIntValueMP(71);
        MaxSpectators = AdvPlayerController(GetPC()).GetIntValueMP(72);
        RespawnTime = AdvPlayerController(GetPC()).GetIntValueMP(73);
        bPublicGame = AdvPlayerController(GetPC()).GetPublicGameMP();
        bTeamDamage = AdvPlayerController(GetPC()).GetTeamDamageMP();
        bTraps = AdvPlayerController(GetPC()).GetTrapsMP();
        bKillingSpree = AdvPlayerController(GetPC()).GetKillingSpreeMP();
        bOracle = AdvPlayerController(GetPC()).GetOracleMP();
        bRealism = AdvPlayerController(GetPC()).GetRealismMP();
    }
    //return;    
}

function SaveProfileData()
{
    AdvPlayerController(GetPC()).SetStringValueMP(75, ServerName);
    AdvPlayerController(GetPC()).SetIntValueMP(70, TimeLimit);
    AdvPlayerController(GetPC()).SetIntValueMP(71, MaxPlayers);
    AdvPlayerController(GetPC()).SetIntValueMP(72, MaxSpectators);
    AdvPlayerController(GetPC()).SetIntValueMP(73, RespawnTime);
    AdvPlayerController(GetPC()).SetFlagsMP(bPublicGame, bTeamDamage, bTraps, bKillingSpree, bOracle, bRealism);
    //return;    
}

function UpdateListDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;
    local array<UDKUIResourceDataProvider> ProviderList;
    local array<UTUIDataProvider_MapInfo> LocalMapList;
    local string FriendlyName;
    local bool bFriendlyFound;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Maps.Length = 0;
    LocalMapList.Length = 0;
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x90:

    // End:0x12A [Loop If]
    if(I < ProviderList.Length)
    {
        // End:0xF3
        if(DropMapNames.Find(UTUIDataProvider_MapInfo(ProviderList[I]).MapName) != )
        {                        
        }
        else
        {
            LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));            
        }
        I++;
        // [Loop Continue]
        goto J0x90;
    }
    // End:0x13C
    if(LocalMapList.Length == 0)
    {
        return;
    }
    LocalMapList.Sort(MapListSort);    
    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x184:

    // End:0x419 [Loop If]
    if(I < LocalMapList.Length)
    {
        // End:0x40B
        if(!LocalMapList[I].ShouldBeFiltered())
        {
            Maps.AddItem(LocalMapList[I]);            
            bFriendlyFound = GetMapFriendlyName(LocalMapList[I].MapName, FriendlyName);
            // End:0x262
            if(!bFriendlyFound)
            {
                Maps.RemoveItem(LocalMapList[I]);                                
            }
            else
            {
                TempObj = CreateObject("Object");
                TempObj.SetString("label", Caps(FriendlyName));
                TempObj.SetString("players", LocalMapList[I].NumPlayers);
                // End:0x38E
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
        }
        I++;
        // [Loop Continue]
        goto J0x184;
    }
    MapList.SetObject("dataProvider", DataProvider);
    MapListDataProvider = MapList.GetObject("dataProvider");
    MapList.SetFloat("selectedIndex", 0.0000000);
    SelectedMapIndex = 0;
    SelectedMapName = Maps[0].MapName;
    Registry.SetData("SelectedMap", Maps[0].MapName);
    MapMainGfx.SetString("source", GetMapTextureURL(0));
    //return;    
}

delegate int MapListSort(UTUIDataProvider_MapInfo A, UTUIDataProvider_MapInfo B)
{
    return ((A.MapName > B.MapName) ? -1 : 0);
    //return ReturnValue;    
}

function OnInternetLANSelect(EventData ev)
{
    bLANSelected = bool(InternetLANDropdown.GetFloat("selectedIndex"));
    //return;    
}

function SetGameType(AdvTypes.EMultiGameMode eMultiMode)
{
    local UIDataStore_Registry Registry;
    local AdvGameInfoSummary GameSummaryInfo;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GameSummaryInfo = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(eMultiMode);
    Registry.SetData("SelectedGameModePrefix", GameSummaryInfo.MapPrefix);
    Registry.SetData("SelectedGameMode", GameSummaryInfo.ClassName);
    GetMenuGame().MultiGameModeSelected = eMultiMode;
    SubtitleTF.SetText(GameSummaryInfo.GameName);
    //return;    
}

function OnListSelect(int Index)
{
    local EventData ev;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    // End:0x56
    if(Index >= Maps.Length)
    {
        return;
    }
    SelectedMapName = Maps[Index].MapName;
    SelectedMapIndex = Index;
    Registry.SetData("SelectedMap", SelectedMapName);
    MapMainGfx.SetString("source", GetMapTextureURL(SelectedMapIndex));
    OnBack(ev);
    //return;    
}

function OnListChange(int Index)
{
    OnListOver(Index);
    //return;    
}

function OnListOver(int Index)
{
    // End:0x2B
    if(!bShowingMaps || Index >= Maps.Length)
    {
        return;
    }
    MapGfx.SetString("source", GetMapTextureURL(Index));
    //return;    
}

function OnServerNameChanged(EventData ev)
{
    ServerName = ServerNameInp.GetString("text");
    //return;    
}

function OnPasswordChanged(EventData ev)
{
    Password = PasswordInp.GetString("text");
    //return;    
}

function OnFragLimitChanged(EventData ev)
{
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

function OnTeamDamageChanged(EventData ev)
{
    bTeamDamage = bool(TeamDamageDropdown.GetFloat("selectedIndex"));
    //return;    
}

function OnTrapsChanged(EventData ev)
{
    bTraps = bool(TrapsDropdown.GetFloat("selectedIndex"));
    //return;    
}

function OnKillingSpreeChanged(EventData ev)
{
    bKillingSpree = bool(KillingSpreeDropdown.GetFloat("selectedIndex"));
    //return;    
}

function OnOracleChanged(EventData ev)
{
    bOracle = bool(OracleDropdown.GetFloat("selectedIndex"));
    //return;    
}

function OnRealismChanged(EventData ev)
{
    bRealism = bool(RealismDropdown.GetFloat("selectedIndex"));
    //return;    
}

function OnRespawnLimitChanged(EventData ev)
{
    RespawnTime = RespawnInp.GetInt("value");
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
    // End:0x34
    if(bShowingGametypes)
    {
        ShowGametypes(false);
        return;
    }
    // End:0x4E
    if(bShowingMaps)
    {
        ShowMaps(false);
        return;
    }
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

function OnShowMaps(EventData ev)
{
    // End:0x1A
    if(!bShowingMaps)
    {
        ShowMaps(true);
    }
    //return;    
}

function OnShowGameType(EventData ev)
{
    // End:0x1A
    if(!bShowingGametypes)
    {
        ShowGametypes(true);
    }
    //return;    
}

function OnHideMaps(EventData ev)
{
    // End:0x18
    if(bShowingMaps)
    {
        ShowMaps(false);
    }
    //return;    
}

function OnHidegametypeBtn(EventData ev)
{
    // End:0x18
    if(bShowingGametypes)
    {
        ShowGametypes(false);
    }
    //return;    
}

function OnDeathBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(0))
    {
        SetGameType(0);
    }
    OnBack(ev);
    //return;    
}

function OnTeamDeathBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(1))
    {
        SetGameType(1);
    }
    OnBack(ev);
    //return;    
}

function OnCaptureBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(2))
    {
        SetGameType(2);
    }
    OnBack(ev);
    //return;    
}

function OnTreasureBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(4))
    {
        SetGameType(4);
    }
    OnBack(ev);
    //return;    
}

function OnTeamTreasureBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(6))
    {
        SetGameType(6);
    }
    OnBack(ev);
    //return;    
}

function OnLastManBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(5))
    {
        SetGameType(5);
    }
    OnBack(ev);
    //return;    
}

function OnNewGameBtn(EventData ev)
{
    Action = "newgame";
    PlayCloseAnimation();
    //return;    
}

function ShowAdvanced(bool bShow)
{
    bShowingAdvanced = bShow;
    // End:0x46F
    if(bShow)
    {
        ShowAdvancedBtn.SetBool("focused", false);
        ShowAdvancedBtn.SetBool("disabled", true);
        ShowMapsBtn.SetBool("disabled", true);
        ShowGametypesBtn.SetBool("disabled", true);
        NewGameBtn.SetBool("disabled", true);
        BackBtn.SetBool("disabled", true);
        InternetLANDropdown.SetBool("visible", false);
        TeamDamageDropdown.SetBool("visible", true);
        TrapsDropdown.SetBool("visible", true);
        KillingSpreeDropdown.SetBool("visible", true);
        OracleDropdown.SetBool("visible", true);
        RealismDropdown.SetBool("visible", true);
        AdvancedTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.AdvancedString);
        TeamDamageTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.TeamDamageString);
        TrapsTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.TrapString);
        KillingSpreeTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.KillingSpreeString);
        OracleTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.OracleString);
        RealismTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.RealismString);
        // End:0x41C
        if(!GetPC().WorldInfo.IsConsoleBuild(0) && !AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            HideAdvancedBtn.SetBool("visible", true);
        }
        TrapsDropdown.SetBool("focused", true);
        AdvancedBG.GotoAndPlay("fadein");        
    }
    else
    {
        ShowAdvancedBtn.SetBool("disabled", false);
        ShowMapsBtn.SetBool("disabled", false);
        ShowGametypesBtn.SetBool("disabled", false);
        NewGameBtn.SetBool("disabled", false);
        BackBtn.SetBool("disabled", false);
        ScoreLimitDropdown.SetBool("visible", false);
        TimeLimitInp.SetBool("visible", false);
        MaxPlayersInp.SetBool("visible", false);
        MaxSpectatorsInp.SetBool("visible", false);
        TeamDamageDropdown.SetBool("visible", false);
        RespawnInp.SetBool("visible", false);
        TrapsDropdown.SetBool("visible", false);
        KillingSpreeDropdown.SetBool("visible", false);
        OracleDropdown.SetBool("visible", false);
        RealismDropdown.SetBool("visible", false);
        AdvancedTF.SetText(" ");
        TeamDamageTF.SetText(" ");
        RespawnTF.SetText(" ");
        TrapsTF.SetText(" ");
        KillingSpreeTF.SetText(" ");
        OracleTF.SetText(" ");
        RealismTF.SetText(" ");
        LanInternetTF.SetText(" ");
        TimelimitTF.SetText(" ");
        ScorelimitTF.SetText(" ");
        SpectatorsTF.SetText(" ");
        MaxPlayersTF.SetText(" ");
        HideAdvancedBtn.SetBool("visible", false);
        // End:0x94B
        if(!GetPC().WorldInfo.IsConsoleBuild(0))
        {
            LanInternetTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.LanInternetString);
            InternetLANDropdown.SetBool("visible", true);
        }
        ShowAdvancedBtn.SetBool("focused", true);
        AdvancedBG.GotoAndPlay("fadeout");
    }
    // End:0x9CA
    if(Frontend.footer != none)
    {
        UpdateFooter();
    }
    //return;    
}

function ShowMaps(bool bShow)
{
    bShowingMaps = bShow;
    // End:0x353
    if(bShow)
    {
        ShowMapsBtn.SetBool("focused", false);
        ShowAdvancedBtn.SetBool("disabled", true);
        ShowMapsBtn.SetBool("disabled", true);
        ShowGametypesBtn.SetBool("disabled", true);
        NewGameBtn.SetBool("disabled", true);
        BackBtn.SetBool("disabled", true);
        InternetLANDropdown.SetBool("visible", false);
        MapGfx.SetBool("visible", true);
        MapList.SetBool("visible", true);
        MapListScrollbar.SetBool("visible", true);
        MapGfx.SetString("source", GetMapTextureURL(int(MapList.GetFloat("selectedIndex"))));
        MapsTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.MapListString);
        MapDescriptionTF.SetText("Map description");
        // End:0x327
        if(!GetPC().WorldInfo.IsConsoleBuild(0) && !AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            HideMapsBtn.SetBool("visible", true);
        }
        MapList.SetBool("focused", true);        
    }
    else
    {
        ShowAdvancedBtn.SetBool("disabled", false);
        ShowMapsBtn.SetBool("disabled", false);
        ShowGametypesBtn.SetBool("disabled", false);
        NewGameBtn.SetBool("disabled", false);
        BackBtn.SetBool("disabled", false);
        MapList.SetBool("visible", false);
        MapListScrollbar.SetBool("visible", false);
        MapGfx.SetBool("visible", false);
        MapsTF.SetText(" ");
        MapDescriptionTF.SetText(" ");
        HideMapsBtn.SetBool("visible", false);
        // End:0x5B2
        if(!GetPC().WorldInfo.IsConsoleBuild(0))
        {
            LanInternetTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.LanInternetString);
            InternetLANDropdown.SetBool("visible", true);
        }
        ShowMapsBtn.SetBool("focused", true);
    }
    // End:0x609
    if(Frontend.footer != none)
    {
        UpdateFooter();
    }
    //return;    
}

function ShowGametypes(bool bShow)
{
    bShowingGametypes = bShow;
    // End:0x45F
    if(bShow)
    {
        ShowGametypesBtn.SetBool("focused", false);
        ShowAdvancedBtn.SetBool("disabled", true);
        ShowMapsBtn.SetBool("disabled", true);
        ShowGametypesBtn.SetBool("disabled", true);
        NewGameBtn.SetBool("disabled", true);
        BackBtn.SetBool("disabled", true);
        InternetLANDropdown.SetBool("visible", false);
        DeathmatchBtn.SetBool("visible", true);
        TeamDeathmatchBtn.SetBool("visible", true);
        CTFBtn.SetBool("visible", true);
        TreasureHuntBtn.SetBool("visible", true);
        TeamTreasureHuntBtn.SetBool("visible", true);
        LastManBtn.SetBool("visible", true);
        GametypesTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.GametypesString);
        // End:0x30F
        if(!GetPC().WorldInfo.IsConsoleBuild(0) && !AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            HideGametypesBtn.SetBool("visible", true);
        }
        switch(GetMenuGame().MultiGameModeSelected)
        {
            // End:0x369
            case 1:
                TeamDeathmatchBtn.SetBool("focused", true);
                // End:0x45C
                break;
            // End:0x39A
            case 2:
                CTFBtn.SetBool("focused", true);
                // End:0x45C
                break;
            // End:0x3CB
            case 4:
                TreasureHuntBtn.SetBool("focused", true);
                // End:0x45C
                break;
            // End:0x3FC
            case 6:
                TeamTreasureHuntBtn.SetBool("focused", true);
                // End:0x45C
                break;
            // End:0x42D
            case 5:
                LastManBtn.SetBool("focused", true);
                // End:0x45C
                break;
            // End:0xFFFF
            default:
                DeathmatchBtn.SetBool("focused", true);
                // End:0x45C
                break;
                break;
        }        
    }
    else
    {
        ShowAdvancedBtn.SetBool("disabled", false);
        ShowMapsBtn.SetBool("disabled", false);
        ShowGametypesBtn.SetBool("disabled", false);
        NewGameBtn.SetBool("disabled", false);
        BackBtn.SetBool("disabled", false);
        DeathmatchBtn.SetBool("visible", false);
        TeamDeathmatchBtn.SetBool("visible", false);
        CTFBtn.SetBool("visible", false);
        TreasureHuntBtn.SetBool("visible", false);
        TeamTreasureHuntBtn.SetBool("visible", false);
        LastManBtn.SetBool("visible", false);
        GametypesTF.SetText(" ");
        HideGametypesBtn.SetBool("visible", false);
        // End:0x716
        if(!GetPC().WorldInfo.IsConsoleBuild(0))
        {
            LanInternetTF.SetText(Class'AdvGFxUI_Menu_MultiHost'.default.LanInternetString);
            InternetLANDropdown.SetBool("visible", true);
        }
        ShowGametypesBtn.SetBool("focused", true);
    }
    // End:0x76D
    if(Frontend.footer != none)
    {
        UpdateFooter();
    }
    //return;    
}

function bool GetMapFriendlyName(string Map, out string FriendlyName)
{
    local int I, P, StartIndex, EndIndex;
    local array<string> LocPieces;

    I = 0;
    J0x0B:

    // End:0x1F6 [Loop If]
    if(I < Maps.Length)
    {
        // End:0x1E8
        if(Maps[I].MapName ~= Map)
        {
            StartIndex = InStr(Caps(Maps[I].FriendlyName), "<STRINGS:");
            // End:0xB3
            if(StartIndex == -1)
            {
                // [Explicit Break]
                goto J0x1F6;
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
            FriendlyName = Map;
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x1F6:

    P = InStr(Map, "-");
    // End:0x252
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    P = InStr(Map, "-");
    // End:0x2AE
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    Map = Left(Map, Len(Map) - 2);
    FriendlyName = Map;
    return false;
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
    local AdvPartyGRI GRI;

    GRI = AdvPartyGRI(GetMenuGRI());
    switch(Action)
    {
        // End:0xAA
        case "back":
            GRI.SetCurrentPartyType(2, none);
            GetMenuGame().MultiGameModeSelected = 7;
            bTransitionResult = Frontend.OpenMultiMenuGametypeScreen();
            // End:0x130
            break;
        // End:0x12A
        case "newgame":
            SaveProfileData();
            // End:0xFD
            if(GetPC().WorldInfo.IsConsoleBuild(0))
            {                
            }
            else
            {
                bTransitionResult = Frontend.OpenMultiServersScreen();
            }
            // End:0x130
            break;
        // End:0xFFFF
        default:
            // End:0x130
            break;
            break;
    }
    // End:0x15C
    if(bTransitionResult)
    {
        Frontend.CloseMultiCustomSearchScreen();
    }
    Action = "";
    //return;    
}

function string GetMapTextureURL(int MapIndex)
{
    local GFxObject tmpObject;

    tmpObject = MapListDataProvider.GetElementObject(MapIndex);
    // End:0x69
    if(tmpObject != none)
    {
        return tmpObject.GetString("image");
    }
    return "img://" $ "UDKFrontEnd.gm_map_none";
    //return ReturnValue;    
}

defaultproperties
{
    bPublicGame=true
    bTraps=true
    bKillingSpree=true
    bOracle=true
    TimeLimit=20
    MaxPlayers=16
    RespawnTime=5
    MaxSpectators=4
    TitleString="Custom Search"
    SearchString="Start Search"
    MovieInfoPath="UI_AdvUI.AdvMultiHost"
}