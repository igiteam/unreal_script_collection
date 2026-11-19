class PKGFxUI_Menu_MapSelect extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject ListMC;
var GFxObject TitleTF;
var GFxObject MapSelectTF;
var GFxObject BlackTarotTF;
var GFxObject Chapter1TF;
var GFxObject Chapter2TF;
var GFxObject Chapter3TF;
var GFxObject Chapter4TF;
var GFxObject BonusTF;
var GFxClikWidget NewGameBtn;
var GFxClikWidget TarotBtn;
var GFxClikWidget StatsBtn;
var GFxClikWidget DLCBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget PublicChk;
var GFxClikWidget LANInternetChk;
var array<GFxClikWidget> MapList;
var array<UTUIDataProvider_MapInfo> Maps;
var const localized string TitleString;
var const localized string NewGameString;
var const localized string MapSelectString;
var const localized string LevelSelectString;
var const localized string Chapter1String;
var const localized string Chapter2String;
var const localized string Chapter3String;
var const localized string Chapter4String;
var const localized string BonusLevelStrig;
var const localized string BlackTarrotStr;
var const localized string PublicGameStr;
var const localized string LANInternetStr;
var const localized string DLCMapsLabel;
var PKGFxUI_Stats StatsScreen;
var bool bStatsScreenIsOpen;
var GFxClikWidget HalloweenDLC;
var GFxClikWidget XmassDLC;
var GFxClikWidget KonklaweDLC;
var GFxClikWidget EasterDLC;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x4A
    if((ButtonName == 'XboxTypeS_Y') && int(InputEvent) == int(0))
    {
        Action = "tarot";
        PlayCloseAnimation();
        return true;
    }
    return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

function SelectHalloweenDLC()
{
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GetMenuGame().SelectedLevelID = 20;
    // End:0x90
    if(666 != FrontEnd.LastSelectedMapButtonIndex)
    {
        CheckForAutoTarotMenu();
    }
    Registry.SetData("SelectedMap", "SP-Halloween_P");
    FrontEnd.LastSelectedMapButtonIndex = 666;
    //return;    
}

function OnHalloweenDLCSelected()
{
    // End:0x9B
    if((GetPC().PlayerInput.bUsingGamepad || Class'Engine.WorldInfo'.static.IsConsoleBuild(0)) && HalloweenDLC.GetInt("focused") > 0)
    {
        OnNewGameBtn();        
    }
    else
    {
        // End:0xD6
        if(HalloweenDLC.GetInt("focused") > 0)
        {
            SelectHalloweenDLC();            
        }
        else
        {
            OnHalloweenDLCFocus();
        }
    }
    //return;    
}

function OnHalloweenDLCFocus()
{
    SelectHalloweenDLC();
    OnStatsOut();
    OnStatsOver();
    //return;    
}

function SelectXmassDLC()
{
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GetMenuGame().SelectedLevelID = 21;
    // End:0x90
    if(667 != FrontEnd.LastSelectedMapButtonIndex)
    {
        CheckForAutoTarotMenu();
    }
    Registry.SetData("SelectedMap", "SP-XmassStation_P");
    FrontEnd.LastSelectedMapButtonIndex = 667;
    //return;    
}

function OnXmassDLCSelected()
{
    // End:0x9B
    if((GetPC().PlayerInput.bUsingGamepad || Class'Engine.WorldInfo'.static.IsConsoleBuild(0)) && XmassDLC.GetInt("focused") > 0)
    {
        OnNewGameBtn();        
    }
    else
    {
        // End:0xD6
        if(XmassDLC.GetInt("focused") > 0)
        {
            SelectXmassDLC();            
        }
        else
        {
            OnXmassDLCFocus();
        }
    }
    //return;    
}

function OnXmassDLCFocus()
{
    SelectXmassDLC();
    OnStatsOut();
    OnStatsOver();
    //return;    
}

function SelectKonklaweDLC()
{
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GetMenuGame().SelectedLevelID = 39;
    // End:0x90
    if(668 != FrontEnd.LastSelectedMapButtonIndex)
    {
        CheckForAutoTarotMenu();
    }
    Registry.SetData("SelectedMap", "SP-Conclave");
    FrontEnd.LastSelectedMapButtonIndex = 668;
    //return;    
}

function OnKonklaweDLCSelected()
{
    // End:0x9B
    if((GetPC().PlayerInput.bUsingGamepad || Class'Engine.WorldInfo'.static.IsConsoleBuild(0)) && KonklaweDLC.GetInt("focused") > 0)
    {
        OnNewGameBtn();        
    }
    else
    {
        // End:0xD6
        if(KonklaweDLC.GetInt("focused") > 0)
        {
            SelectKonklaweDLC();            
        }
        else
        {
            OnKonklaweDLCFocus();
        }
    }
    //return;    
}

function OnKonklaweDLCFocus()
{
    SelectKonklaweDLC();
    OnStatsOut();
    OnStatsOver();
    //return;    
}

function SelectEasterDLC()
{
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GetMenuGame().SelectedLevelID = 40;
    // End:0x90
    if(669 != FrontEnd.LastSelectedMapButtonIndex)
    {
        CheckForAutoTarotMenu();
    }
    Registry.SetData("SelectedMap", "SP-Easter_P");
    FrontEnd.LastSelectedMapButtonIndex = 669;
    //return;    
}

function OnEasterDLCSelected()
{
    // End:0x9B
    if((GetPC().PlayerInput.bUsingGamepad || Class'Engine.WorldInfo'.static.IsConsoleBuild(0)) && EasterDLC.GetInt("focused") > 0)
    {
        OnNewGameBtn();        
    }
    else
    {
        // End:0xD6
        if(EasterDLC.GetInt("focused") > 0)
        {
            SelectEasterDLC();            
        }
        else
        {
            OnEasterDLCFocus();
        }
    }
    //return;    
}

function OnEasterDLCFocus()
{
    SelectEasterDLC();
    OnStatsOut();
    OnStatsOver();
    //return;    
}

function bool Start(optional bool StartPaused = false)
{
    local int I;
    local PKPlayerController PC;

    super.Start(StartPaused);
    Advance(0.0000000);
    PC = PKPlayerController(GetPC());
    // End:0xB2
    if(FrontEnd.bShouldInstantLoadAfterTarot && int(GetMenuGame().SelectedLevelID) != int(0))
    {
        Action = "newgame";
        OnCloseAnimationComplete();
        return true;
    }
    // End:0xFE
    if(int(GetMenuGame().SelectedLevelID) == int(17))
    {
        GetMenuGame().SelectedLevelID = 1;
    }
    ButtonsMC = MenuMC.GetObject("buttons");
    ListMC = ButtonsMC.GetObject("list");
    MapSelectTF = ButtonsMC.GetObject("LevelSelectTF");
    Chapter1TF = ButtonsMC.GetObject("chapter1TF");
    Chapter2TF = ButtonsMC.GetObject("chapter2TF");
    Chapter3TF = ButtonsMC.GetObject("chapter3TF");
    Chapter4TF = ButtonsMC.GetObject("chapter4TF");
    BonusTF = ButtonsMC.GetObject("BonusTF");
    BlackTarotTF = ButtonsMC.GetObject("balacktarrot_TF");
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("newgame_btn", Class'GFxUI.GFxClikWidget'));
    TarotBtn = GFxClikWidget(ButtonsMC.GetObject("Tarot").GetObject("TarotBtn", Class'GFxUI.GFxClikWidget'));
    StatsBtn = GFxClikWidget(ButtonsMC.GetObject("Stats").GetObject("StatsBtn", Class'GFxUI.GFxClikWidget'));
    DLCBtn = GFxClikWidget(ButtonsMC.GetObject("dlc_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x50A
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    PublicChk = GFxClikWidget(ButtonsMC.GetObject("public_chk", Class'GFxUI.GFxClikWidget'));
    LANInternetChk = GFxClikWidget(ButtonsMC.GetObject("LANInternet_chk", Class'GFxUI.GFxClikWidget'));
    I = 0;
    J0x5A8:

    // End:0x620 [Loop If]
    if(I < 14)
    {
        MapList[I] = GFxClikWidget(ButtonsMC.GetObject("map" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        I++;
        // [Loop Continue]
        goto J0x5A8;
    }
    UpdateMapList(int(GetMenuGame().SelectedLevelID) != int(0));
    MapList[LidIndexToMapControllIndex(GetMenuGame().SelectedLevelID)].SetBool("focused", true);
    OnMapFocus((LidIndexToMapControllIndex(GetMenuGame().SelectedLevelID)) + 1);
    MapSelectTF.SetText(LevelSelectString);
    Chapter1TF.SetText(Chapter1String);
    Chapter2TF.SetText(Chapter2String);
    Chapter3TF.SetText(Chapter3String);
    Chapter4TF.SetText(Chapter4String);
    BonusTF.SetText(BonusLevelStrig);
    BlackTarotTF.SetText(BlackTarrotStr);
    HalloweenDLC = GFxClikWidget(ButtonsMC.GetObject("halloween", Class'GFxUI.GFxClikWidget'));
    HalloweenDLC.SetString("label", Caps(Localize("FriendlyMapNames", "Halloween", "PKHDGame")));
    // End:0x8F8
    if(int(PKPlayerController(GetPC()).IsDLCInstalled(4)) == int(1))
    {
        HalloweenDLC.SetBool("visible", true);
    }
    XmassDLC = GFxClikWidget(ButtonsMC.GetObject("xmass", Class'GFxUI.GFxClikWidget'));
    XmassDLC.SetString("label", Caps(Localize("FriendlyMapNames", "XmassStation", "PKHDGame")));
    // End:0x9F6
    if(int(PKPlayerController(GetPC()).IsDLCInstalled(5)) == int(1))
    {
        XmassDLC.SetBool("visible", true);
    }
    KonklaweDLC = GFxClikWidget(ButtonsMC.GetObject("konklawe", Class'GFxUI.GFxClikWidget'));
    KonklaweDLC.SetString("label", Caps(Localize("FriendlyMapNames", "Conclave", "PKHDGame")));
    KonklaweDLC.SetBool("visible", true);
    EasterDLC = GFxClikWidget(ButtonsMC.GetObject("easter", Class'GFxUI.GFxClikWidget'));
    EasterDLC.SetString("label", Caps(Localize("FriendlyMapNames", "EasterEgg", "PKHDGame")));
    EasterDLC.SetBool("visible", true);
    NewGameBtn.SetString("label", NewGameString);
    // End:0xC23
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
    {
        NewGameBtn.SetBool("visible", false);
        KursorMC.SetVisible(false);        
    }
    else
    {
        NewGameBtn.SetBool("visible", true);
        KursorMC.SetVisible(PainGFxHudWrapper(GetPC().myHUD).bShowCursor);
    }
    DLCBtn.SetString("label", DLCMapsLabel);
    // End:0xD27
    if(PC.IsAnyCampaignDLCAvailable())
    {
        DLCBtn.SetBool("visible", true);        
    }
    else
    {
        DLCBtn.SetBool("visible", false);
    }
    PublicChk.SetString("label", PublicGameStr);
    LANInternetChk.SetString("label", LANInternetStr);
    PublicChk.SetBool("visible", false);
    // End:0xE66
    if(GetPC().WorldInfo.IsConsoleBuild(0) || !GetMenuGame().bPublicGameSelected)
    {
        LANInternetChk.SetBool("visible", false);        
    }
    else
    {
        LANInternetChk.SetBool("visible", true);
        LANInternetChk.SetBool("selected", GetMenuGame().bLANSelected);
    }
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
    // End:0xEB
    if((GetMenuGame()) != none)
    {
        // End:0x9D
        if(GetPC().WorldInfo.IsConsoleBuild(0) && int(GetMenuGame().MultiGameModeSelected) == int(5))
        {
            bCanOpenPartyMenu = true;
            bCanOpenChangePartyType = true;
            bDisplayPartyWindow = true;            
        }
        else
        {
            // End:0xEB
            if(int(GetMenuGame().MultiGameModeSelected) == int(6))
            {
                bCanOpenPartyMenu = false;
                bCanOpenChangePartyType = false;
                bDisplayPartyWindow = true;
            }
        }
    }
    //return;    
}

function bool ChecklevelIsUnlocked(PKTypes.ELevelID levelid)
{
    local PKEngine Eng;
    local PKPlayerController PKPC;
    local bool bUnlocked, bIsSingleMode, bIsCoopMode, bIsSplitScreenMode;

    PKPC = PKPlayerController(GetPC());
    bIsSingleMode = int(GetMenuGame().MultiGameModeSelected) == int(0);
    bIsCoopMode = GetMenuGame().bPublicGameSelected || int(GetMenuGame().MultiGameModeSelected) == int(6);
    bIsSplitScreenMode = int(GetMenuGame().MultiGameModeSelected) == int(6);
    Eng = PKEngine(Class'PKEngine'.static.GetEngine());
    // End:0x13F
    if((Eng != none) && Eng.HasAllLevelsCommandline())
    {
        return true;
    }
    // End:0x198
    if(bIsSingleMode)
    {
        bUnlocked = PKPC.PersistentData.IsLevelCompleted(levelid, false);        
    }
    else
    {
        // End:0x243
        if(bIsSplitScreenMode || bIsCoopMode)
        {
            bUnlocked = PKPC.PersistentData.IsLevelCompleted(levelid, false) || PKPC.PersistentData.IsLevelCompleted(levelid, true);            
        }
        else
        {
            bUnlocked = false;
        }
    }
    return bUnlocked;
    //return ReturnValue;    
}

function int LidIndexToMapControllIndex(PKTypes.ELevelID lid)
{
    // End:0x29
    if(int(lid) <= int(13))
    {
        return int(lid) - int(1);        
    }
    else
    {
        // End:0x43
        if(int(lid) == int(14))
        {
            return 13;            
        }
        else
        {
            // End:0x5D
            if(int(lid) == int(16))
            {
                return 13;                
            }
            else
            {
                // End:0x77
                if(int(lid) == int(15))
                {
                    return 13;                    
                }
                else
                {
                    return -1;
                }
            }
        }
    }
    //return ReturnValue;    
}

function UpdateMapList(bool bDontChangeSelectedLevelID)
{
    local PKTypes.ELevelID BonusMapID;
    local bool bIgnoreMapCheckInProfile;
    local int I, ListCounter, Index;
    local bool bFoundMapInOnlyList;
    local array<UDKUIResourceDataProvider> ProviderList;
    local array<UTUIDataProvider_MapInfo> LocalMapList;
    local UTUIDataProvider_MapInfo ItMapInfo;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("SelectedGameModePrefix", "SP");
    I = 0;
    J0x82:

    // End:0xDC [Loop If]
    if(I < MapList.Length)
    {
        MapList[I].SetBool("disabled", true);
        I++;
        // [Loop Continue]
        goto J0x82;
    }
    Maps.Length = 0;
    LocalMapList.Length = 0;
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x130:

    // End:0x17F [Loop If]
    if(I < ProviderList.Length)
    {
        LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));
        I++;
        // [Loop Continue]
        goto J0x130;
    }
    // End:0x191
    if(LocalMapList.Length == 0)
    {
        return;
    }
    bIgnoreMapCheckInProfile = false;
    ListCounter = 0;
    I = 1;
    J0x1B3:

    // End:0x47C [Loop If]
    if(I <= 13)
    {
        bFoundMapInOnlyList = false;
        // End:0x24B
        foreach LocalMapList(ItMapInfo, Index)
        {
            // End:0x24A
            if(Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames[I] == name(ItMapInfo.MapName))
            {
                bFoundMapInOnlyList = true;                
            }
            else
            {                
            }
        }        
        // End:0x25E
        if(!bFoundMapInOnlyList)
        {            
        }
        else
        {
            // End:0x46E
            if(!LocalMapList[Index].ShouldBeFiltered())
            {
                // End:0x31C
                if(((I != 1) && !(ChecklevelIsUnlocked(byte(I))) || ChecklevelIsUnlocked(byte(I - 1))) && !bIgnoreMapCheckInProfile)
                {
                    MapList[ListCounter].SetBool("disabled", true);                    
                }
                else
                {
                    MapList[ListCounter].SetBool("disabled", false);
                    // End:0x3DE
                    if(!bDontChangeSelectedLevelID)
                    {
                        Registry.SetData("SelectedMap", LocalMapList[Index].MapName);
                        GetMenuGame().SelectedLevelID = byte(I);
                    }
                }
                Maps.AddItem(LocalMapList[Index]);
                MapList[ListCounter].SetString("label", Caps(GetMapFriendlyName(LocalMapList[Index].MapName)));
                ListCounter++;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x1B3;
    }
    // End:0x6D8
    if(ChecklevelIsUnlocked(13))
    {
        // End:0x4BE
        if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
        {
            BonusMapID = 14;            
        }
        else
        {
            // End:0x4F1
            if(Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
            {
                BonusMapID = 15;                
            }
            else
            {
                BonusMapID = 16;
            }
        }
        // End:0x57B
        foreach LocalMapList(ItMapInfo, Index)
        {
            // End:0x57A
            if(Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames[int(BonusMapID)] == name(ItMapInfo.MapName))
            {
                bFoundMapInOnlyList = true;                
            }
            else
            {                
            }
        }        
        MapList[LidIndexToMapControllIndex(BonusMapID)].SetBool("disabled", false);
        // End:0x646
        if(!bDontChangeSelectedLevelID)
        {
            Registry.SetData("SelectedMap", LocalMapList[Index].MapName);
            GetMenuGame().SelectedLevelID = BonusMapID;
        }
        MapList[LidIndexToMapControllIndex(BonusMapID)].SetString("label", Caps(GetMapFriendlyName(LocalMapList[Index].MapName)));
        Maps.AddItem(LocalMapList[Index]);        
    }
    // End:0x780
    if(Maps.Length > 0)
    {
        // End:0x780
        if(int(GetMenuGame().SelectedLevelID) == int(0))
        {
            Registry.SetData("SelectedMap", Maps[0].MapName);
            GetMenuGame().SelectedLevelID = 1;
        }
    }
    //return;    
}

function CheckForAutoTarotMenu()
{
    local PKPlayerController PKPC;

    PKPC = PKPlayerController(GetPC());
    // End:0xB7
    if((PKPC.ProfileSettings.GetGoldCardUnlockMaskValue() > 0) || PKPC.ProfileSettings.GetSilverCardUnlockMaskValue() > 0)
    {
        FrontEnd.bTarotCardMenuVisited = false;        
    }
    else
    {
        FrontEnd.bTarotCardMenuVisited = true;
    }
    //return;    
}

function SelectMap(int Index)
{
    local string SelectedMapName;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    SelectedMapName = Maps[Index - 1].MapName;
    GetMenuGame().SelectedLevelID = byte(Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames.Find(name(SelectedMapName)));
    Registry.SetData("SelectedMap", SelectedMapName);
    // End:0x12B
    if(Index != FrontEnd.LastSelectedMapButtonIndex)
    {
        CheckForAutoTarotMenu();
    }
    FrontEnd.LastSelectedMapButtonIndex = Index;
    //return;    
}

function OnMapSelected(int Index)
{
    // End:0xA8
    if((GetPC().PlayerInput.bUsingGamepad || Class'Engine.WorldInfo'.static.IsConsoleBuild(0)) && MapList[Index - 1].GetInt("focused") > 0)
    {
        OnNewGameBtn();        
    }
    else
    {
        // End:0xF9
        if(MapList[Index - 1].GetInt("focused") > 0)
        {
            SelectMap(Index);            
        }
        else
        {
            OnMapFocus(Index);
        }
    }
    //return;    
}

function OnMapFocus(int Index)
{
    SelectMap(Index);
    OnStatsOut();
    OnStatsOver();
    //return;    
}

function OnPublicSelect(EventData ev)
{
    //return;    
}

function OnLANInternetSelect(EventData ev)
{
    GetMenuGame().bLANSelected = LANInternetChk.GetBool("selected");
    //return;    
}

function OnBack(EventData ev)
{
    GetMenuGRI().CurrentPartyType = 2;
    Action = "back";
    PlayCloseAnimation();
    GetMenuGame().CleanupLocalPlayersForSP();
    //return;    
}

function OnDLC()
{
    Action = "dlc";
    PlayCloseAnimation();
    //return;    
}

function OnNewGameBtn()
{
    Action = "newgame";
    PlayCloseAnimation();
    //return;    
}

function OnTarotBtn(EventData ev)
{
    Action = "tarot";
    PlayCloseAnimation();
    //return;    
}

function OnStatsOver()
{
    // End:0x19D
    if(!bStatsScreenIsOpen)
    {
        // End:0x7F
        if(StatsScreen == none)
        {
            StatsScreen = new Class'PKGFxUI_Stats';
            StatsScreen.LocalPlayerOwnerIndex = LocalPlayerOwnerIndex;
            StatsScreen.SetTimingMode(1);
        }
        StatsScreen.SetPriority(68);
        StatsScreen.Init(GetLP());
        StatsScreen.SetCoopMode(GetMenuGame().bPublicGameSelected || int(GetMenuGame().MultiGameModeSelected) == int(6));
        StatsScreen.SetLevelIDOverride(GetMenuGame().SelectedLevelID);
        StatsScreen.PlayOpenAnimation();
        bStatsScreenIsOpen = true;
    }
    //return;    
}

function OnStatsOut()
{
    // End:0x6A
    if((StatsScreen != none) && bStatsScreenIsOpen)
    {
        StatsScreen.PlayCloseAnimation();
        StatsScreen.SetLevelIDOverride(0);
        bStatsScreenIsOpen = false;
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

function PlayCloseAnimation()
{
    local PKPlayerController PC;

    // End:0xC2
    if(Action == "newgame")
    {
        PC = PKPlayerController(GetPC());
        // End:0xC2
        if(PC.IsFreeJanuaryWeekendSubscribed() && int(GetMenuGame().SelectedLevelID) > int(4))
        {
            PKGameViewportClient(GetLP().ViewportClient).ShowJanuarySubscriptionWindow();
            return;
        }
    }
    super.PlayCloseAnimation();
    // End:0x136
    if((StatsScreen != none) && bStatsScreenIsOpen)
    {
        StatsScreen.PlayCloseAnimation();
        StatsScreen.SetLevelIDOverride(0);
        bStatsScreenIsOpen = false;
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x110
        case "back":
            // End:0xC1
            if((int(GetMenuGame().MultiGameModeSelected) == int(5)) || int(GetMenuGame().MultiGameModeSelected) == int(6))
            {
                GetMenuGame().MultiGameModeSelected = 0;
                bTransitionResult = FrontEnd.OpenCampaignCoopScreen();                
            }
            else
            {
                bTransitionResult = FrontEnd.OpenCampaignScreen();
            }
            GetMenuGame().SelectedLevelID = 0;
            // End:0x2D4
            break;
        // End:0x1D2
        case "newgame":
            // End:0x17E
            if(!FrontEnd.bTarotCardMenuVisited)
            {
                Action = "tarot";
                FrontEnd.bShouldInstantLoadAfterTarot = true;
                OnCloseAnimationComplete();
                return;
            }
            bTransitionResult = FrontEnd.OpenDifficultyScreen(int(GetMenuGame().MultiGameModeSelected) == int(6));
            // End:0x2D4
            break;
        // End:0x256
        case "tarot":
            bTransitionResult = FrontEnd.OpenTarotScreen(FrontEnd.bShouldInstantLoadAfterTarot);
            // End:0x253
            if(bTransitionResult)
            {
                FrontEnd.bTarotCardMenuVisited = true;
            }
            // End:0x2D4
            break;
        // End:0x2CE
        case "dlc":
            GetMenuGame().SelectedLevelID = 0;
            FrontEnd.bShouldReturnToCampaignMenuAfterDLC = false;
            bTransitionResult = FrontEnd.OpenMapSelectDLC();
            // End:0x2D4
            break;
        // End:0xFFFF
        default:
            // End:0x2D4
            break;
            break;
    }
    // End:0x300
    if(bTransitionResult)
    {
        FrontEnd.CloseMapSelectScreen();
    }
    bStatsScreenIsOpen = false;
    Action = "";
    //return;    
}

event OnCleanup()
{
    super.OnCleanup();
    // End:0x44
    if(StatsScreen != none)
    {
        StatsScreen.Close();
        StatsScreen = none;
    }
    //return;    
}

defaultproperties
{
    TitleString="Map Select"
    NewGameString="Play Level"
    MapSelectString="SELECT CHAPTER"
    LevelSelectString="Select Level"
    Chapter1String="Chapter I"
    Chapter2String="Chapter II"
    Chapter3String="Chapter III"
    Chapter4String="Chapter IV"
    BonusLevelStrig="Bonus"
    BlackTarrotStr="Black Tarot"
    PublicGameStr="Others Can Join"
    LANInternetStr="Only LAN Game"
    DLCMapsLabel="Show DLC Levels"
    MovieInfo=SwfMovie'PKHD_UI.PKMapSelect'
}