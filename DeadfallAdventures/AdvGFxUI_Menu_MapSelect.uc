class AdvGFxUI_Menu_MapSelect extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject ListMC;
var GFxObject MapDescMC;
var GFxObject TitleTF;
var GFxObject MapSelectTF;
var GFxObject MapNameTF;
var GFxObject LifeTreasuresTF;
var GFxObject LifeTreasuresN;
var GFxObject LightTreasuresTF;
var GFxObject LightTreasuresN;
var GFxObject WarriorTreasuresTF;
var GFxObject WarriorTreasuresN;
var GFxClikWidget MapGfx;
var GFxClikWidget NewGameBtn;
var GFxClikWidget DLCBtn;
var GFxClikWidget BackBtn;
var array<AdvTypes.ELevelID> OnlyMapsList;
var array<GFxClikWidget> MapList;
var array<UTUIDataProvider_MapInfo> Maps;
var const localized string TitleString;
var const localized string NewGameString;
var const localized string MapSelectString;
var const localized string LevelSelectString;
var const localized string PublicGameStr;
var const localized string LANInternetStr;
var const localized string DLCMapsLabel;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    local int I;

    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    ListMC = ButtonsMC.GetObject("list");
    MapSelectTF = ButtonsMC.GetObject("LevelSelectTF");
    MapDescMC = ButtonsMC.GetObject("mapdescMC");
    MapNameTF = MapDescMC.GetObject("mapnameTF");
    LifeTreasuresTF = MapDescMC.GetObject("treasureHealthTF");
    LifeTreasuresN = MapDescMC.GetObject("treasureHealthNumberTF");
    LightTreasuresTF = MapDescMC.GetObject("treasureLightTF");
    LightTreasuresN = MapDescMC.GetObject("treasureLightNumberTF");
    WarriorTreasuresTF = MapDescMC.GetObject("treasureWarriorTF");
    WarriorTreasuresN = MapDescMC.GetObject("treasureWarriorNumberTF");
    LifeTreasuresN.SetInt("_x", LifeTreasuresN.GetInt("_x") - 15);
    LifeTreasuresN.SetInt("_width", LifeTreasuresN.GetInt("_width") + 40);
    LightTreasuresN.SetInt("_x", LightTreasuresN.GetInt("_x") - 15);
    LightTreasuresN.SetInt("_width", LightTreasuresN.GetInt("_width") + 40);
    WarriorTreasuresN.SetInt("_x", WarriorTreasuresN.GetInt("_x") - 15);
    WarriorTreasuresN.SetInt("_width", WarriorTreasuresN.GetInt("_width") + 40);
    MapGfx = GFxClikWidget(MapDescMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("newgame_btn", Class'GFxUI.GFxClikWidget'));
    DLCBtn = GFxClikWidget(ButtonsMC.GetObject("dlc_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x653
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    I = 0;
    J0x65E:

    // End:0x6D6 [Loop If]
    if(I < 11)
    {
        MapList[I] = GFxClikWidget(ButtonsMC.GetObject("map" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        I++;
        // [Loop Continue]
        goto J0x65E;
    }
    UpdateMapList(int(GetMenuGame().SelectedLevelID) != int(0));
    MapList[LidIndexToMapControllIndex(GetMenuGame().SelectedLevelID)].SetBool("focused", true);
    OnMapFocus((LidIndexToMapControllIndex(GetMenuGame().SelectedLevelID)) + 1);
    MapSelectTF.SetText(LevelSelectString);
    LifeTreasuresTF.SetText(((Localize("Treasures", string(GetEnum(Enum'AdvTypes.ETreasureType', 0)), "ADVGame")) @ "-") @ Class'AdvGFxUI_Upgrades'.default.TreasuresColectedString);
    WarriorTreasuresTF.SetText(((Localize("Treasures", string(GetEnum(Enum'AdvTypes.ETreasureType', 2)), "ADVGame")) @ "-") @ Class'AdvGFxUI_Upgrades'.default.TreasuresColectedString);
    LightTreasuresTF.SetText(((Localize("Treasures", string(GetEnum(Enum'AdvTypes.ETreasureType', 1)), "ADVGame")) @ "-") @ Class'AdvGFxUI_Upgrades'.default.TreasuresColectedString);
    NewGameBtn.SetString("label", NewGameString);
    // End:0x9FF
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        NewGameBtn.SetBool("visible", false);
        KursorMC.SetVisible(false);
        bIgnoreMouseInput = true;        
    }
    else
    {
        NewGameBtn.SetBool("visible", true);
        KursorMC.SetVisible(AdvGFxHudWrapper(GetPC().myHUD).bShowCursor);
        bIgnoreMouseInput = !AdvGFxHudWrapper(GetPC().myHUD).bShowCursor;
    }
    DLCBtn.SetBool("visible", false);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
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

function bool ChecklevelIsUnlocked(AdvTypes.ELevelID LevelID)
{
    local AdvEngine Engine;
    local bool bUnlocked;

    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0xA0
    if(Engine.CurrentCheckpoint != none)
    {
        bUnlocked = Engine.CurrentCheckpoint.IsLevelCompleted(int(LevelID));
    }
    return bUnlocked;
    //return ReturnValue;    
}

function bool CheckLevelIsInCurrentCheckpoint(AdvTypes.ELevelID LevelID)
{
    local AdvEngine Engine;

    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0xAC
    if(Engine.CurrentCheckpoint != none)
    {
        return int(Engine.CurrentCheckpoint.HeaderData.ChapterNum) == int(LevelID);
    }
    return false;
    //return ReturnValue;    
}

function int LidIndexToMapControllIndex(AdvTypes.ELevelID lid)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x94 [Loop If]
    if(I < Maps.Length)
    {
        // End:0x86
        if(Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames[int(lid)] == name(Maps[I].MapName))
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return ReturnValue;    
}

function UpdateMapList(bool bDontChangeSelectedLevelID)
{
    local int I, ListCounter, Index;
    local bool bFoundMapInLocalMapList;
    local array<UDKUIResourceDataProvider> ProviderList;
    local array<UTUIDataProvider_MapInfo> LocalMapList;
    local UTUIDataProvider_MapInfo ItMapInfo;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("SelectedGameModePrefix", "SP");
    I = 0;
    J0x82:

    // End:0x10F [Loop If]
    if(I < MapList.Length)
    {
        MapList[I].SetBool("disabled", true);
        MapList[I].SetString("label", "");
        I++;
        // [Loop Continue]
        goto J0x82;
    }
    Maps.Length = 0;
    LocalMapList.Length = 0;
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x163:

    // End:0x1B2 [Loop If]
    if(I < ProviderList.Length)
    {
        LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));        
        I++;
        // [Loop Continue]
        goto J0x163;
    }
    // End:0x1C4
    if(LocalMapList.Length == 0)
    {
        return;
    }
    ListCounter = 0;
    I = 0;
    J0x1DA:

    // End:0x508 [Loop If]
    if(I < OnlyMapsList.Length)
    {
        bFoundMapInLocalMapList = false;
        // End:0x286
        foreach LocalMapList(ItMapInfo, Index)
        {
            // End:0x285
            if(Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames[int(OnlyMapsList[I])] == name(ItMapInfo.MapName))
            {
                bFoundMapInLocalMapList = true;                
            }
            else
            {                
            }
        }        
        // End:0x299
        if(!bFoundMapInLocalMapList)
        {            
        }
        else
        {
            // End:0x4FA
            if(!LocalMapList[Index].ShouldBeFiltered())
            {
                // End:0x3A2
                if(((I != 0) && !AdvEngine(Class'Engine.Engine'.static.GetEngine()).HasAllLevelsCommandline()) && !(ChecklevelIsUnlocked(byte(int(OnlyMapsList[I]) - int(1)))) || CheckLevelIsInCurrentCheckpoint(OnlyMapsList[I]))
                {
                    MapList[ListCounter].SetBool("disabled", true);                    
                }
                else
                {
                    MapList[ListCounter].SetBool("disabled", false);
                    // End:0x46C
                    if(!bDontChangeSelectedLevelID)
                    {
                        Registry.SetData("SelectedMap", LocalMapList[Index].MapName);
                        GetMenuGame().SelectedLevelID = OnlyMapsList[I];
                    }
                }
                Maps.AddItem(LocalMapList[Index]);                
                MapList[ListCounter].SetString("label", GetMapFriendlyName(LocalMapList[Index].MapName));
                ListCounter++;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x1DA;
    }
    // End:0x5F4
    if(Maps.Length > 0)
    {
        // End:0x5F4
        if(int(GetMenuGame().SelectedLevelID) == int(0))
        {
            Registry.SetData("SelectedMap", Maps[0].MapName);
            GetMenuGame().SelectedLevelID = byte(Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames.Find(name(Maps[0].MapName)));            
        }
    }
    //return;    
}

function UpdateTreasuresCountForLevel(AdvTypes.ELevelID LevelID)
{
    local int TreasuresCollected[ETreasureType], TreasuresAll, I, TreasureMappingIndex;
    local AdvTypes.ETreasureType TreasureType;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    I = 0;
    J0x3D:

    // End:0xDB [Loop If]
    if(I < Eng.TreasureMapping.Length)
    {
        // End:0xCD
        if(int(LevelID) == int(Eng.TreasureMapping[I].LevelID))
        {
            TreasureMappingIndex = I;
            // [Explicit Break]
            goto J0xDB;
        }
        I++;
        // [Loop Continue]
        goto J0x3D;
    }
    J0xDB:

    I = 0;
    J0xE6:

    // End:0x241 [Loop If]
    if(I < Eng.TreasureMapping[TreasureMappingIndex].TreasureID.Length)
    {
        TreasureType = Class'AdvTreasureTrigger_Base'.static.GetTreasureTypeFromID(Eng.TreasureMapping[TreasureMappingIndex].TreasureID[I]);
        TreasuresAll[int(TreasureType)]++;
        // End:0x233
        if(Eng.IsTreasureCollected(Eng.TreasureMapping[TreasureMappingIndex].TreasureID[I]))
        {
            TreasuresCollected[int(TreasureType)]++;
        }
        I++;
        // [Loop Continue]
        goto J0xE6;
    }
    LifeTreasuresN.SetText((string(TreasuresCollected[0]) $ "/") $ string(TreasuresAll[0]));
    WarriorTreasuresN.SetText((string(TreasuresCollected[2]) $ "/") $ string(TreasuresAll[2]));
    LightTreasuresN.SetText((string(TreasuresCollected[1]) $ "/") $ string(TreasuresAll[1]));
    //return;    
}

function SelectMap(int Index)
{
    local string SelectedMapName;
    local UIDataStore_Registry Registry;

    AdvEngine(Class'Engine.Engine'.static.GetEngine()).SetAllowSaveFirstCheckpoint(true);
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    SelectedMapName = Maps[Index - 1].MapName;
    GetMenuGame().SelectedLevelID = byte(Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames.Find(name(SelectedMapName)));    
    Registry.SetData("SelectedMap", SelectedMapName);
    MapNameTF.SetText(GetMapFriendlyName(SelectedMapName));
    // End:0x1F9
    if(Maps[Index - 1].PreviewImageMarkup != "")
    {
        MapGfx.SetString("source", "img://" $ Maps[Index - 1].PreviewImageMarkup);        
    }
    else
    {
        MapGfx.SetString("source", "img://" $ "UDKFrontEnd.gm_map_none");
    }
    UpdateTreasuresCountForLevel(GetMenuGame().SelectedLevelID);
    // End:0x2B7
    if(SelectedMapName ~= "SP-02-SaharaOutdoor_P")
    {
        GetMenuGame().SelectedLevelID = 1;        
    }
    else
    {
        // End:0x2FE
        if(SelectedMapName ~= "SP-06-ArcticBase_P")
        {
            GetMenuGame().SelectedLevelID = 5;            
        }
        else
        {
            // End:0x343
            if(SelectedMapName ~= "SP-08-MayanJungle_P")
            {
                GetMenuGame().SelectedLevelID = 10;
            }
        }
    }
    //return;    
}

function OnMapSelected(int Index)
{
    // End:0x9C
    if((AdvPlayerController(GetPC()).IsPCGamepadMode() || Class'Engine.WorldInfo'.static.IsConsoleBuild(0)) && MapList[Index - 1].GetInt("focused") > 0)
    {
        OnNewGameBtn();        
    }
    else
    {
        // End:0xED
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
    //return;    
}

function OnPublicSelect(EventData ev)
{
    //return;    
}

function OnLANInternetSelect(EventData ev)
{
    //return;    
}

function OnBack(EventData ev)
{
    GetMenuGRI().SetCurrentPartyType(2, none);
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
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPC());
    // End:0xD7
    if((PC.IsFreeWeekendSubscribed() && int(GetMenuGame().SelectedLevelID) > int(5)) && int(GetMenuGame().SelectedLevelID) <= int(17))
    {
        ADVGameViewportClient(GetLP().ViewportClient).ShowFreeWeekendSubscriptionWindow();
        return;
    }
    Action = "newgame";
    PlayCloseAnimation();
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

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x6B
        case "back":
            bTransitionResult = Frontend.OpenCampaignScreen();
            GetMenuGame().SelectedLevelID = 0;
            // End:0x101
            break;
        // End:0xA4
        case "newgame":
            bTransitionResult = Frontend.OpenDifficultyScreen();
            // End:0x101
            break;
        // End:0xFB
        case "dlc":
            GetMenuGame().SelectedLevelID = 0;
            bTransitionResult = Frontend.OpenMapSelectDLC();
            // End:0x101
            break;
        // End:0xFFFF
        default:
            // End:0x101
            break;
            break;
    }
    // End:0x12D
    if(bTransitionResult)
    {
        Frontend.CloseMapSelectScreen();
    }
    Action = "";
    //return;    
}

function OnLeaveParty()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local bool bHasParty, bIsLeader;

    bHasParty = AdvPlayerController(GetPC()).HasParty();
    bIsLeader = GetPC().IsPartyLeader();
    // End:0x1B2
    if(bIsLeader && bHasParty)
    {
        ButtonAliases.AddItem('AcceptLeave');        
        ButtonAliases.AddItem('CancelStay');        
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        UIManager.ShowUIMessage('ConfirmQuit', "<Strings:ADVGame.MessageBoxStrings.LeavePregameLobby_Title>", "<Strings:ADVGame.MessageBoxStrings.LeavePregameLobby_MemberMessage>", ButtonAliases, OnLeaveParty_Confirmed, GetLP());        
    }
    else
    {
        GetMenuGRI().SetCurrentPartyType(2, none);
        Action = "back";
        GetMenuGame().CleanupLocalPlayersForSP();
        PlayCloseAnimation();
    }
    //return;    
}

function bool OnLeaveParty_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0xF4
    if(SelectedInputAlias == 'AcceptLeave')
    {
        Frontend.GetPartyGame().DestroyParty();
        AdvPlayerController(GetPC()).DisbandParty();
        Frontend.bStartPartySession = true;
        GetMenuGRI().SetCurrentPartyType(2, none);
        Action = "back";
        GetMenuGame().CleanupLocalPlayersForSP();
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    OnlyMapsList[0]=126
    OnlyMapsList[1]=45
    OnlyMapsList[2]=0
    OnlyMapsList[3]=0
    OnlyMapsList[4]=0
    OnlyMapsList[5]=0
    OnlyMapsList[6]=0
    OnlyMapsList[7]=0
    OnlyMapsList[8]=124
    OnlyMapsList[9]=45
    OnlyMapsList[10]=0
    TitleString="Map Select"
    NewGameString="Play Level"
    LevelSelectString="Select Level"
    LANInternetStr="LAN Games"
    MovieInfoPath="UI_AdvUI.AdvMapSelect"
}