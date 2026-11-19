class PKGFxUI_Menu_MapSelectDLC extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject ListMC;
var GFxObject TitleTF;
var GFxObject MapSelectTF;
var GFxObject BlackTarotTF;
var GFxClikWidget NewGameBtn;
var GFxClikWidget TarotBtn;
var GFxClikWidget StatsBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget PublicChk;
var GFxClikWidget LANInternetChk;
var array<GFxClikWidget> MapList;
var array<UTUIDataProvider_MapInfo> Maps;
var const localized string TitleString;
var PKGFxUI_Stats StatsScreen;
var bool bStatsScreenIsOpen;
var int DLCIndex;

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

function bool Start(optional bool StartPaused = false)
{
    local int I;

    super.Start(StartPaused);
    Advance(0.0000000);
    // End:0xC1
    if(FrontEnd.bShouldInstantLoadAfterTarot && int(GetMenuGame().SelectedLevelID) != int(0))
    {
        // End:0xC1
        if(CheckIfUserHasRightsToPlayThisLevelAndShowMessage(GetMenuGame().SelectedLevelID))
        {
            Action = "newgame";
            OnCloseAnimationComplete();
            return true;
        }
    }
    ButtonsMC = MenuMC.GetObject("buttons");
    ListMC = ButtonsMC.GetObject("list");
    MapSelectTF = ButtonsMC.GetObject("LevelSelectTF");
    BlackTarotTF = ButtonsMC.GetObject("balacktarrot_TF");
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("newgame_btn", Class'GFxUI.GFxClikWidget'));
    TarotBtn = GFxClikWidget(ButtonsMC.GetObject("Tarot").GetObject("TarotBtn", Class'GFxUI.GFxClikWidget'));
    StatsBtn = GFxClikWidget(ButtonsMC.GetObject("Stats").GetObject("StatsBtn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x37E
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    PublicChk = GFxClikWidget(ButtonsMC.GetObject("public_chk", Class'GFxUI.GFxClikWidget'));
    LANInternetChk = GFxClikWidget(ButtonsMC.GetObject("LANInternet_chk", Class'GFxUI.GFxClikWidget'));
    I = 0;
    J0x41C:

    // End:0x494 [Loop If]
    if(I < 17)
    {
        MapList[I] = GFxClikWidget(ButtonsMC.GetObject("map" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        I++;
        // [Loop Continue]
        goto J0x41C;
    }
    UpdateMapList(int(GetMenuGame().SelectedLevelID) != int(0));
    MapList[LidIndexToMapControllIndex(GetMenuGame().SelectedLevelID)].SetBool("focused", true);
    OnMapFocus((LidIndexToMapControllIndex(GetMenuGame().SelectedLevelID)) + 1);
    MapSelectTF.SetText(TitleString);
    BlackTarotTF.SetText(Class'PKGFxUI_Menu_MapSelect'.default.BlackTarrotStr);
    NewGameBtn.SetString("label", Class'PKGFxUI_Menu_MapSelect'.default.NewGameString);
    // End:0x66A
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
    LANInternetChk.SetString("label", Class'PKGFxUI_Menu_MapSelect'.default.LANInternetStr);
    // End:0x7C2
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
    ButtonAliases.AddItem('TarotMenu');
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

function int LidIndexToMapControllIndex(PKTypes.ELevelID lid)
{
    // End:0x29
    if(int(lid) >= int(22))
    {
        return int(lid) - int(22);        
    }
    else
    {
        return int(lid) - int(1);
    }
    //return ReturnValue;    
}

function bool IsThisFirstMapOfTheDLC(PKTypes.ELevelID levelid)
{
    return ((((int(levelid) == int(22)) || int(levelid) == int(25)) || int(levelid) == int(28)) || int(levelid) == int(33)) || int(levelid) == int(36);
    //return ReturnValue;    
}

function PKTypes.EDLCIdentifiers GetDLCIDForMapID(PKTypes.ELevelID levelid)
{
    local PKTypes.EDLCIdentifiers Result;

    Result = 0;
    // End:0x5B
    if(((int(levelid) == int(22)) || int(levelid) == int(24)) || int(levelid) == int(23))
    {
        Result = 9;        
    }
    else
    {
        // End:0xAA
        if(((int(levelid) == int(25)) || int(levelid) == int(26)) || int(levelid) == int(27))
        {
            Result = 10;            
        }
        else
        {
            // End:0x125
            if(((((int(levelid) == int(29)) || int(levelid) == int(30)) || int(levelid) == int(32)) || int(levelid) == int(28)) || int(levelid) == int(31))
            {
                Result = 12;                
            }
            else
            {
                // End:0x174
                if(((int(levelid) == int(33)) || int(levelid) == int(34)) || int(levelid) == int(35))
                {
                    Result = 13;                    
                }
                else
                {
                    // End:0x1C0
                    if(((int(levelid) == int(36)) || int(levelid) == int(37)) || int(levelid) == int(38))
                    {
                        Result = 14;
                    }
                }
            }
        }
    }
    return Result;
    //return ReturnValue;    
}

function bool OnMissingDLCFound(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x60
    if(SelectedInputAlias == 'GenericOpenSteamStore')
    {
        PKEngine(Class'Engine.Engine'.static.GetEngine()).ShowDLCStoreByDLCIdentifier(byte(DLCIndex));
    }
    DLCIndex = -1;
    return true;
    //return ReturnValue;    
}

function GetDLCPromoKeyAndSectionFromLockitForDLCID(PKTypes.EDLCIdentifiers DLCID, out string Key, out string Section)
{
    Key = "DLCNeeded_Message";
    Section = "PKGFxUI_Menu_MainMenu";
    switch(DLCID)
    {
        // End:0x6F
        case 8:
            Key = "DLC1String";
            // End:0x126
            break;
        // End:0x8D
        case 9:
            Key = "DLC2String";
            // End:0x126
            break;
        // End:0xAB
        case 10:
            Key = "DLC3String";
            // End:0x126
            break;
        // End:0xC9
        case 11:
            Key = "DLC4String";
            // End:0x126
            break;
        // End:0xE7
        case 12:
            Key = "DLC5String";
            // End:0x126
            break;
        // End:0x105
        case 13:
            Key = "DLC6String";
            // End:0x126
            break;
        // End:0x123
        case 14:
            Key = "DLC7String";
            // End:0x126
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function bool CheckIfUserHasRightsToPlayThisLevelAndShowMessage(PKTypes.ELevelID levelid)
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local PKTypes.EDLCIdentifiers DLCID;
    local PKPlayerController PC;
    local string Key, Section;

    PC = PKPlayerController(GetPC());
    DLCID = GetDLCIDForMapID(levelid);
    // End:0x1C3
    if(int(PC.IsDLCInstalled(DLCID)) == int(0))
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        ButtonAliases.AddItem('GenericOpenSteamStore');
        ButtonAliases.AddItem('GenericCancel');
        DLCIndex = int(DLCID);
        GetDLCPromoKeyAndSectionFromLockitForDLCID(DLCID, Key, Section);
        UIManager.ShowUIMessage('MissingDLC', Localize("MessageBoxErrorStrings", "DLCRemovedAtMenuTitle", "PKHDGame"), Localize(Section, Key, "PKHDGame"), ButtonAliases, OnMissingDLCFound, GetLP(),,,,, false);
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool ChecklevelIsUnlocked(PKTypes.ELevelID levelid, optional bool bIgnoreFirstMapChecking = false)
{
    local PKEngine Eng;
    local PKPlayerController PKPC;
    local bool bUnlocked, bIsSingleMode, bIsCoopMode, bIsSplitScreenMode;

    PKPC = PKPlayerController(GetPC());
    Eng = PKEngine(Class'PKEngine'.static.GetEngine());
    // End:0x89
    if((Eng != none) && Eng.HasAllLevelsCommandline())
    {
        return true;
    }
    // End:0xB2
    if((IsThisFirstMapOfTheDLC(levelid)) && !bIgnoreFirstMapChecking)
    {
        return true;
    }
    bIsSingleMode = int(GetMenuGame().MultiGameModeSelected) == int(0);
    bIsCoopMode = GetMenuGame().bPublicGameSelected || int(GetMenuGame().MultiGameModeSelected) == int(6);
    bIsSplitScreenMode = int(GetMenuGame().MultiGameModeSelected) == int(6);
    // End:0x1C6
    if(bIsSingleMode)
    {
        bUnlocked = PKPC.PersistentData.IsLevelCompleted(levelid, false);        
    }
    else
    {
        // End:0x271
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

function UpdateMapList(bool bDontChangeSelectedLevelID)
{
    local int I, ListCounter, Index;
    local bool bFoundMapInOnlyList;
    local array<UDKUIResourceDataProvider> ProviderList;
    local array<UTUIDataProvider_MapInfo> LocalMapList;
    local UTUIDataProvider_MapInfo ItMapInfo, DummyMap;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("SelectedGameModePrefix", "SP");
    DummyMap = new (self) Class'EvilGame.UTUIDataProvider_MapInfo';
    I = 0;
    J0x9A:

    // End:0x127 [Loop If]
    if(I < MapList.Length)
    {
        MapList[I].SetBool("disabled", true);
        MapList[I].SetBool("visible", false);
        I++;
        // [Loop Continue]
        goto J0x9A;
    }
    Maps.Length = 0;
    LocalMapList.Length = 0;
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x17B:

    // End:0x1CA [Loop If]
    if(I < ProviderList.Length)
    {
        LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));
        I++;
        // [Loop Continue]
        goto J0x17B;
    }
    // End:0x1DC
    if(LocalMapList.Length == 0)
    {
        return;
    }
    ListCounter = 0;
    I = 22;
    J0x1F3:

    // End:0x57F [Loop If]
    if(I < 39)
    {
        bFoundMapInOnlyList = false;
        // End:0x296
        if((int(GetMenuGame().MultiGameModeSelected) == int(6)) && ((((I == 28) || I == 29) || I == 30) || I == 31) || I == 32)
        {            
        }
        else
        {
            // End:0x344
            foreach LocalMapList(ItMapInfo, Index)
            {
                // End:0x343
                if((I <= (Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames.Length - 1)) && Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames[I] == name(ItMapInfo.MapName))
                {
                    bFoundMapInOnlyList = true;                    
                }
                else
                {                    
                }
            }            
            // End:0x571
            if(bFoundMapInOnlyList && !LocalMapList[Index].ShouldBeFiltered())
            {
                MapList[ListCounter].SetBool("visible", true);
                MapList[ListCounter].SetBool("disabled", !(bFoundMapInOnlyList && ChecklevelIsUnlocked(byte(I))) || ChecklevelIsUnlocked(byte(I - 1), true));
                // End:0x550
                if(bFoundMapInOnlyList)
                {
                    // End:0x4C8
                    if(!bDontChangeSelectedLevelID)
                    {
                        Registry.SetData("SelectedMap", LocalMapList[Index].MapName);
                        GetMenuGame().SelectedLevelID = byte(I);
                    }
                    Maps.AddItem(LocalMapList[Index]);
                    MapList[ListCounter].SetString("label", Caps(GetMapFriendlyName(LocalMapList[Index].MapName)));                    
                }
                else
                {
                    Maps.AddItem(DummyMap);
                }
                ListCounter++;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x1F3;
    }
    // End:0x627
    if(Maps.Length > 0)
    {
        // End:0x627
        if(int(GetMenuGame().SelectedLevelID) == int(0))
        {
            Registry.SetData("SelectedMap", Maps[0].MapName);
            GetMenuGame().SelectedLevelID = 24;
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
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnNewGameBtn()
{
    // End:0x49
    if(CheckIfUserHasRightsToPlayThisLevelAndShowMessage(GetMenuGame().SelectedLevelID))
    {
        Action = "newgame";
        PlayCloseAnimation();
    }
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
        StatsScreen.Init(GetLP());
        StatsScreen.SetCoopMode(GetMenuGame().bPublicGameSelected || int(GetMenuGame().MultiGameModeSelected) == int(6));
        StatsScreen.SetLevelIDOverride(GetMenuGame().SelectedLevelID);
        StatsScreen.PlayOpenAnimation();
        StatsScreen.SetPriority(10);
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
    super.PlayCloseAnimation();
    // End:0x74
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
        // End:0xDB
        case "back":
            GetMenuGame().SelectedLevelID = 0;
            FrontEnd.bShouldReturnToMapSelectDLC = false;
            // End:0xAE
            if(FrontEnd.bShouldReturnToCampaignMenuAfterDLC)
            {
                bTransitionResult = FrontEnd.OpenCampaignScreen();                
            }
            else
            {
                bTransitionResult = FrontEnd.OpenMapSelectScreen();
            }
            // End:0x227
            break;
        // End:0x19D
        case "newgame":
            // End:0x149
            if(!FrontEnd.bTarotCardMenuVisited)
            {
                Action = "tarot";
                FrontEnd.bShouldInstantLoadAfterTarot = true;
                OnCloseAnimationComplete();
                return;
            }
            bTransitionResult = FrontEnd.OpenDifficultyScreen(int(GetMenuGame().MultiGameModeSelected) == int(6));
            // End:0x227
            break;
        // End:0x221
        case "tarot":
            bTransitionResult = FrontEnd.OpenTarotScreen(FrontEnd.bShouldInstantLoadAfterTarot);
            // End:0x21E
            if(bTransitionResult)
            {
                FrontEnd.bTarotCardMenuVisited = true;
            }
            // End:0x227
            break;
        // End:0xFFFF
        default:
            // End:0x227
            break;
            break;
    }
    // End:0x253
    if(bTransitionResult)
    {
        FrontEnd.CloseMapSelectDLC();
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
    TitleString="DLC Levels"
    MovieInfo=SwfMovie'PKHD_UI.PKMapSelectDLC'
}