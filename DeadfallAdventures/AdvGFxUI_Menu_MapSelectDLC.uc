class AdvGFxUI_Menu_MapSelectDLC extends AdvGFxUI_Menu_Base
    config(UI);

const MAX_DLC = 10;
const MAX_MAPSPERDLC = 5;

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject MapDescMC;
var GFxObject TitleTF;
var GFxObject MapSelectTF;
var GFxObject MapNameTF;
var GFxObject MapDescTF;
var GFxClikWidget MapGfx;
var GFxClikWidget NewGameBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget HideBtn;
var array<GFxClikWidget> DLCList;
var array<int> DLCIndexes;
var array<GFxClikWidget> MapList;
var array<UTUIDataProvider_MapInfo> Maps;
var const localized string TitleString;
var int CurrentDLCIndex;
var bool bMapsVisible;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

function string GetFriendlyDLCName(int DLCIndex)
{
    local string DLCName;
    local AdvEngine Eng;
    local int I;

    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    I = 0;
    J0x3D:

    // End:0x12B [Loop If]
    if(I < Eng.DLCInformations.Length)
    {
        // End:0x11D
        if(Eng.DLCInformations[I].DLCIndex == DLCIndex)
        {
            DLCName = Localize("DLCFriendlyNames", Eng.DLCInformations[I].FriendlyName, "ADVGame");
        }
        I++;
        // [Loop Continue]
        goto J0x3D;
    }
    return DLCName;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    local int I, J, LastDLCChecked;
    local AdvEngine Eng;

    super.Start(StartPaused);
    Advance(0.0000000);
    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    ButtonsMC = MenuMC.GetObject("buttons");
    MapDescMC = ButtonsMC.GetObject("mapdescMC");
    MapSelectTF = ButtonsMC.GetObject("LevelSelectTF");
    MapNameTF = MapDescMC.GetObject("mapnameTF");
    MapDescTF = MapDescMC.GetObject("descTF");
    MapGfx = GFxClikWidget(MapDescMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("newgame_btn", Class'GFxUI.GFxClikWidget'));
    HideBtn = GFxClikWidget(ButtonsMC.GetObject("hide_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    NewGameBtn.SetString("label", Class'AdvGFxUI_Menu_MapSelect'.default.NewGameString);
    BackBtn.SetString("label", back);
    HideBtn.SetString("label", back);
    // End:0x407
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
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
    HideBtn.SetBool("visible", false);
    I = 0;
    J0x50C:

    // End:0x5B7 [Loop If]
    if(I < 10)
    {
        DLCList[I] = GFxClikWidget(ButtonsMC.GetObject("DLC" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        DLCList[I].SetBool("visible", false);
        I++;
        // [Loop Continue]
        goto J0x50C;
    }
    I = 0;
    J0x5C2:

    // End:0x66D [Loop If]
    if(I < 5)
    {
        MapList[I] = GFxClikWidget(ButtonsMC.GetObject("map" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        MapList[I].SetBool("visible", false);
        I++;
        // [Loop Continue]
        goto J0x5C2;
    }
    LastDLCChecked = 0;
    I = 0;
    J0x683:

    // End:0x8D5 [Loop If]
    if(I < 10)
    {
        DLCIndexes[I] = -1;
        J = LastDLCChecked;
        J0x6BF:

        // End:0x8C7 [Loop If]
        if(J < Eng.DLCInformations.Length)
        {
            // End:0x8B9
            if(Eng.IsDLCContainsSinglePlayerMaps(Eng.DLCInformations[J].DLCIndex) && Eng.IsDLCInstalled(Eng.DLCInformations[J].DLCIndex))
            {
                DLCList[I].SetBool("visible", true);
                DLCList[I].SetString("label", GetFriendlyDLCName(Eng.DLCInformations[J].DLCIndex));
                DLCIndexes[I] = Eng.DLCInformations[J].DLCIndex;
                LastDLCChecked = J + 1;
                // [Explicit Break]
                goto J0x8C7;
            }
            J++;
            // [Loop Continue]
            goto J0x6BF;
        }
        J0x8C7:

        I++;
        // [Loop Continue]
        goto J0x683;
    }
    ShowMaps(false);
    MapSelectTF.SetText(TitleString);
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

function bool CheckIfLevelIsUnlocked(AdvTypes.ELevelID LevelID)
{
    local AdvEngine Engine;
    local bool bLevelIsCompletedInSingleCampaign;

    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0xA3
    if(Engine.CurrentCheckpoint != none)
    {
        bLevelIsCompletedInSingleCampaign = Engine.CurrentCheckpoint.IsLevelCompleted(int(LevelID));        
    }
    else
    {
        bLevelIsCompletedInSingleCampaign = false;
    }
    return bLevelIsCompletedInSingleCampaign;
    //return ReturnValue;    
}

function UpdateMapList(bool bDontChangeSelectedLevelID)
{
    local int I, ListCounter, Index, LocalIndexOfSelectedLID;
    local bool bFoundMapInOnlyList;
    local array<UDKUIResourceDataProvider> ProviderList;
    local array<UTUIDataProvider_MapInfo> LocalMapList;
    local UTUIDataProvider_MapInfo ItMapInfo;
    local UIDataStore_Registry Registry;
    local array<AdvTypes.ELevelID> LevelsInDLC;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("SelectedGameModePrefix", "SP");
    I = 0;
    J0x82:

    // End:0x10F [Loop If]
    if(I < MapList.Length)
    {
        MapList[I].SetBool("disabled", true);
        MapList[I].SetBool("visible", false);
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
    Class'AdvEngine'.static.CopyLevelsForDLCToArray(CurrentDLCIndex, LevelsInDLC);
    ListCounter = 0;
    LocalIndexOfSelectedLID = 0;
    I = 0;
    J0x216:

    // End:0x4B6 [Loop If]
    if(I < LevelsInDLC.Length)
    {
        bFoundMapInOnlyList = false;
        // End:0x2C2
        foreach LocalMapList(ItMapInfo, Index)
        {
            // End:0x2C1
            if(Class'EvilGame.EvilTypesNative'.default.ChapterLevelNames[int(LevelsInDLC[I])] == name(ItMapInfo.MapName))
            {
                bFoundMapInOnlyList = true;                
            }
            else
            {                
            }
        }        
        // End:0x4A8
        if(bFoundMapInOnlyList && !LocalMapList[Index].ShouldBeFiltered())
        {
            MapList[ListCounter].SetBool("visible", true);
            MapList[ListCounter].SetBool("disabled", !(I == 0) || CheckIfLevelIsUnlocked(LevelsInDLC[I - 1]));
            MapList[ListCounter].SetBool("focused", false);
            Maps.AddItem(LocalMapList[Index]);            
            MapList[ListCounter].SetString("label", GetMapFriendlyName(LocalMapList[Index].MapName));
            // End:0x49D
            if(int(GetMenuGame().SelectedLevelID) == int(LevelsInDLC[I]))
            {
                LocalIndexOfSelectedLID = ListCounter;
            }
            ListCounter++;
        }
        I++;
        // [Loop Continue]
        goto J0x216;
    }
    // End:0x583
    if(Maps.Length > 0)
    {
        // End:0x53A
        if(!bDontChangeSelectedLevelID || int(GetMenuGame().SelectedLevelID) == int(0))
        {
            MapList[0].SetBool("focused", true);
            OnMapFocus(1);            
        }
        else
        {
            MapList[LocalIndexOfSelectedLID].SetBool("focused", true);
            OnMapFocus(LocalIndexOfSelectedLID + 1);
        }
    }
    //return;    
}

function ShowMaps(bool bShow)
{
    local int I;

    bMapsVisible = bShow;
    MapDescMC.SetVisible(bShow);
    // End:0xB6
    if(bShow)
    {
        UpdateMapList(false);
        I = 0;
        J0x61:

        // End:0xB3 [Loop If]
        if(I < 10)
        {
            DLCList[I].SetBool("disabled", true);
            I++;
            // [Loop Continue]
            goto J0x61;
        }        
    }
    else
    {
        I = 0;
        J0xC1:

        // End:0x167 [Loop If]
        if(I < 10)
        {
            DLCList[I].SetBool("disabled", false);
            // End:0x159
            if(DLCIndexes[I] == CurrentDLCIndex)
            {
                DLCList[I].SetBool("focused", true);
            }
            I++;
            // [Loop Continue]
            goto J0xC1;
        }
        I = 0;
        J0x172:

        // End:0x1C3 [Loop If]
        if(I < 5)
        {
            MapList[I].SetBool("visible", false);
            I++;
            // [Loop Continue]
            goto J0x172;
        }
    }
    // End:0x262
    if(!GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        NewGameBtn.SetBool("disabled", !bShow);
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
    MapNameTF.SetText(GetMapFriendlyName(SelectedMapName));
    MapDescTF.SetText(Maps[Index - 1].Description);
    // End:0x205
    if(Maps[Index - 1].PreviewImageMarkup != "")
    {
        MapGfx.SetString("source", "img://" $ Maps[Index - 1].PreviewImageMarkup);        
    }
    else
    {
        MapGfx.SetString("source", "img://" $ "UDKFrontEnd.gm_map_none");
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

function SelectDLC(int Index)
{
    // End:0x53
    if((Index < 10) && DLCIndexes[Index] >= 0)
    {
        CurrentDLCIndex = DLCIndexes[Index];
        ShowMaps(true);
    }
    //return;    
}

function OnDLC1Btn(EventData ev)
{
    SelectDLC(0);
    //return;    
}

function OnDLC2Btn(EventData ev)
{
    SelectDLC(1);
    //return;    
}

function OnDLC3Btn(EventData ev)
{
    SelectDLC(2);
    //return;    
}

function OnDLC4Btn(EventData ev)
{
    SelectDLC(3);
    //return;    
}

function OnDLC5Btn(EventData ev)
{
    SelectDLC(4);
    //return;    
}

function OnDLC6Btn(EventData ev)
{
    SelectDLC(5);
    //return;    
}

function OnDLC7Btn(EventData ev)
{
    SelectDLC(6);
    //return;    
}

function OnDLC8Btn(EventData ev)
{
    SelectDLC(7);
    //return;    
}

function OnDLC9Btn(EventData ev)
{
    SelectDLC(8);
    //return;    
}

function OnDLC10Btn(EventData ev)
{
    SelectDLC(9);
    //return;    
}

function OnDLC1BtnFocus(EventData ev)
{
    //return;    
}

function OnDLC2BtnFocus(EventData ev)
{
    //return;    
}

function OnDLC3BtnFocus(EventData ev)
{
    //return;    
}

function OnDLC4BtnFocus(EventData ev)
{
    //return;    
}

function OnDLC5BtnFocus(EventData ev)
{
    //return;    
}

function OnDLC6BtnFocus(EventData ev)
{
    //return;    
}

function OnDLC7BtnFocus(EventData ev)
{
    //return;    
}

function OnDLC8BtnFocus(EventData ev)
{
    //return;    
}

function OnDLC9BtnFocus(EventData ev)
{
    //return;    
}

function OnDLC10BtnFocus(EventData ev)
{
    //return;    
}

function OnBack(EventData ev)
{
    // End:0x1B
    if(bMapsVisible)
    {
        ShowMaps(false);        
    }
    else
    {
        Action = "back";
        PlayCloseAnimation();
    }
    //return;    
}

function hide_btn(EventData ev)
{
    OnBack(ev);
    //return;    
}

function OnNewGameBtn()
{
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
        // End:0x8C
        case "back":
            GetMenuGame().SelectedLevelID = 0;
            Frontend.bShouldReturnToMapSelectDLC = false;
            bTransitionResult = Frontend.OpenCampaignScreen();
            // End:0xCB
            break;
        // End:0xC5
        case "newgame":
            bTransitionResult = Frontend.OpenDifficultyScreen();
            // End:0xCB
            break;
        // End:0xFFFF
        default:
            // End:0xCB
            break;
            break;
    }
    // End:0xF7
    if(bTransitionResult)
    {
        Frontend.CloseMapSelectDLC();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="DLC Levels"
    MovieInfoPath="UI_AdvUI.AdvMapSelectDLC"
}