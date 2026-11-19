class PKGFxUI_Menu_CommunitySP extends PKGFxUI_Menu_Base
    config(UI);

struct MapCollection
{
    var PKWorkshopPackageResourceDataProvider WorkshopProvider;
    var array<UTUIDataProvider_MapInfo> Maps;

    structdefaultproperties
    {
        WorkshopProvider=none
        Maps=none
    }
};

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject MapsTF;
var GFxObject MapTF;
var GFxObject MapDescTF;
var GFxClikWidget StartBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget GetMapsBtn;
var GFxClikWidget CoopBtn;
var GFxClikWidget CreateCoopBtn;
var GFxClikWidget NewGameBtn;
var GFxClikWidget TarotBtn;
var GFxClikWidget MapsBtn[5];
var GFxObject LevelSelectTF;
var GFxObject AuthorTF;
var GFxObject DLCtitleTF;
var GFxClikWidget MapList;
var GFxObject MapListDataProvider;
var array<UTUIDataProvider_MapInfo> Maps;
var const localized string TitleString;
var const localized string MapListString;
var const localized string GetMapsString;
var array<MapCollection> WorkshopCollection;
var int CurrentSelectedMapCollection;
var int CurrentSelectedMapIndex;
//var delegate<MapListSort> __MapListSort__Delegate;

function GetMapsFromWorkshop()
{
    local PKEngine Engine;

    Engine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SteamActivateGameOverlayToCommunitySP();
    //return;    
}

function string BuildURL()
{
    local UIDataStore_Registry Registry;
    local string _url, _MapName;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.GetData("SelectedMap", _MapName);
    _url = _MapName;    
    _url $= "?MaxPlayers=0?NumPublicConnections=0?NumPrivateConnections=0?NumOpenPublicConnections=0?NumOpenPrivateConnections=0?bShouldAdvertise=False";    
    _url $= "?bIsLanMatch=False?bUsesStats=True?bAllowJoinInProgress=False?bAllowInvites=False?bUsesPresence=False?bAllowJoinViaPresence=False?bAllowJoinViaPresenceFriendsOnly=False";    
    _url $= "?bUsesArbitration=False?bAntiCheatProtected=False?bIsDedicated=False?";    
    _url $= ("?CustomMapName=" $ _MapName);    
    _url $= "?CustomGameMode=PKHDGame.PKGameSP?game=PKHDGame.PKGameSP";    
    _url $= ("?gamepad=" $ ((Class'Engine.WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().PlayerInput.bUsingGamepad) ? "1" : "0"));
    return _url;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    local int I;

    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    MapsTF = ButtonsMC.GetObject("mapsTF");
    MapTF = ButtonsMC.GetObject("mapnameTF");
    GetMapsBtn = GFxClikWidget(ButtonsMC.GetObject("getmap_btn", Class'GFxUI.GFxClikWidget'));
    GetMapsBtn.SetBool("visible", true);
    GetMapsBtn.SetString("label", GetMapsString);
    CoopBtn = GFxClikWidget(ButtonsMC.GetObject("coop_btn", Class'GFxUI.GFxClikWidget'));
    CoopBtn.SetString("label", "CoopBtn");
    CreateCoopBtn = GFxClikWidget(ButtonsMC.GetObject("createcoop_btn", Class'GFxUI.GFxClikWidget'));
    CreateCoopBtn.SetString("label", "createcoop_btn");
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("newgame_btn", Class'GFxUI.GFxClikWidget'));
    NewGameBtn.SetString("label", "newgame_btn");
    TarotBtn = GFxClikWidget(ButtonsMC.GetObject("createcoop_btn", Class'GFxUI.GFxClikWidget'));
    I = 0;
    J0x391:

    // End:0x482 [Loop If]
    if(I < 5)
    {
        MapsBtn[I] = GFxClikWidget(ButtonsMC.GetObject("map" $ string(I + 1), Class'GFxUI.GFxClikWidget'));
        MapsBtn[I].SetBool("visible", true);
        MapsBtn[I].SetString("label", "map" $ string(I + 1));
        I++;
        // [Loop Continue]
        goto J0x391;
    }
    StartBtn = GFxClikWidget(ButtonsMC.GetObject("start_btn", Class'GFxUI.GFxClikWidget'));
    StartBtn.SetString("label", Class'PKGFxUI_Menu_MapSelect'.default.NewGameString);
    // End:0x570
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        StartBtn.SetBool("visible", false);
    }
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x648
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    LevelSelectTF = ButtonsMC.GetObject("LevelSelectTF");
    LevelSelectTF.SetText(Localize("Workshop", "Author", "PKHDGame"));
    AuthorTF = ButtonsMC.GetObject("authorTF");
    AuthorTF.SetText(Localize("Workshop", "Author", "PKHDGame"));
    DLCtitleTF = ButtonsMC.GetObject("dlctitleTF");
    DLCtitleTF.SetText("DLCtitleTF");
    MapList = GFxClikWidget(ButtonsMC.GetObject("list_helper", Class'GFxUI.GFxClikWidget'));
    UpdateListDataProvider();
    OnListChange(0);
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

function UpdateListDataProvider()
{
    local int I, J, Z;
    local array<UDKUIResourceDataProvider> ProviderList;
    local MapCollection mapColl;
    local UTUIDataProvider_MapInfo MapInfo;

    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'PKWorkshopPackageResourceDataProvider', ProviderList);
    I = 0;
    J0x3C:

    // End:0xE9 [Loop If]
    if(I < ProviderList.Length)
    {
        mapColl.WorkshopProvider = PKWorkshopPackageResourceDataProvider(ProviderList[I]);
        // End:0xDB
        if(mapColl.WorkshopProvider.RawSinglePlayerMapNames.Length > 0)
        {
            WorkshopCollection.AddItem(mapColl);
        }
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x125:

    // End:0x2C7 [Loop If]
    if(I < ProviderList.Length)
    {
        MapInfo = UTUIDataProvider_MapInfo(ProviderList[I]);
        // End:0x18A
        if(!MapInfo.FromWorkshop)
        {            
        }
        else
        {
            J = 0;
            J0x195:

            // End:0x2B9 [Loop If]
            if(J < WorkshopCollection.Length)
            {
                Z = 0;
                J0x1B8:

                // End:0x2AB [Loop If]
                if(Z < WorkshopCollection[J].WorkshopProvider.RawSinglePlayerMapNames.Length)
                {
                    // End:0x29D
                    if(MapInfo.MapName ~= WorkshopCollection[J].WorkshopProvider.RawSinglePlayerMapNames[Z])
                    {
                        WorkshopCollection[J].Maps.AddItem(MapInfo);
                    }
                    Z++;
                    // [Loop Continue]
                    goto J0x1B8;
                }
                J++;
                // [Loop Continue]
                goto J0x195;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x125;
    }
    FillDataWithColletionIndex(0);
    //return;    
}

function HideAllMapControlls()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x5C [Loop If]
    if(I < 5)
    {
        MapsBtn[I].SetBool("visible", false);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function FillDataWithColletionIndex(int Index)
{
    local int I;
    local OnlineSubsystemSteamworks steam;
    local WorkshopPackageInfo wsPackageInfo;
    local PKWorkshopPackageResourceDataProvider WorkshopProvider;

    HideAllMapControlls();
    CurrentSelectedMapCollection = Index;
    WorkshopProvider = WorkshopCollection[Index].WorkshopProvider;
    steam = OnlineSubsystemSteamworks(Class'Engine.GameEngine'.static.GetOnlineSubsystem());
    wsPackageInfo = steam.FindWorkshopPackageInfoForGivenPackageName(WorkshopProvider.PackageName);
    DLCtitleTF.SetText("");
    LevelSelectTF.SetText((Localize("Workshop", "Author", "PKHDGame")) @ WorkshopProvider.Author);
    AuthorTF.SetText(wsPackageInfo.EntryTitle);
    I = 0;
    J0x195:

    // End:0x28B [Loop If]
    if(I < WorkshopCollection[Index].Maps.Length)
    {
        MapsBtn[I].SetBool("visible", true);
        MapsBtn[I].SetString("label", GetMapFriendlyName(WorkshopCollection[Index].Maps[I].FriendlyName));
        I++;
        // [Loop Continue]
        goto J0x195;
    }
    //return;    
}

delegate int MapListSort(UTUIDataProvider_MapInfo A, UTUIDataProvider_MapInfo B)
{
    return ((A.MapName > B.MapName) ? -1 : 0);
    //return ReturnValue;    
}

function OnBack(EventData ev)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnNewGameBtn(EventData ev)
{
    //return;    
}

function OnGetMapBtn(EventData ev)
{
    //return;    
}

function OnCoopBtn(EventData ev)
{
    //return;    
}

function OnCreateCoopBtn(EventData ev)
{
    //return;    
}

function OnTarotBtn(EventData ev)
{
    //return;    
}

function OnMapFocus(int Index)
{
    //return;    
}

function OnMapSelected(int Index)
{
    CurrentSelectedMapIndex = Index;
    //return;    
}

function OnListSelect(int Index)
{
    //return;    
}

function OnListChange(int Index)
{
    //return;    
}

function OnListOver(int Index)
{
    //return;    
}

function OnShowAdvancedOptions(EventData ev)
{
    GetMapsFromWorkshop();
    //return;    
}

function OnNextSection(EventData ev)
{
    ++CurrentSelectedMapCollection;
    // End:0x3D
    if(CurrentSelectedMapCollection >= (WorkshopCollection.Length - 1))
    {
        CurrentSelectedMapCollection = WorkshopCollection.Length - 1;
    }
    FillDataWithColletionIndex(CurrentSelectedMapCollection);
    //return;    
}

function OnPrevSection(EventData ev)
{
    // End:0x1C
    if(--CurrentSelectedMapCollection < 0)
    {
        CurrentSelectedMapCollection = 0;
    }
    FillDataWithColletionIndex(CurrentSelectedMapCollection);
    //return;    
}

function OnListRollOver(int I)
{
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;
    local string GameExec;

    switch(Action)
    {
        // End:0x49
        case "back":
            bTransitionResult = FrontEnd.OpenCampaignScreen();
            // End:0xD2
            break;
        // End:0xCC
        case "newgame":
            GetMenuGame().CleanupLocalPlayersForSP();
            GameExec = BuildURL();
            Class'Engine.WorldInfo'.static.GetWorldInfo().ServerTravel(GameExec, true, true);
            // End:0xD2
            break;
        // End:0xFFFF
        default:
            // End:0xD2
            break;
            break;
    }
    // End:0xFE
    if(bTransitionResult)
    {
        FrontEnd.CloseCommunitySPScreen();
    }
    Action = "";
    //return;    
}

function string GetMapFriendlyName(string Map)
{
    local int StartIndex, EndIndex;
    local array<string> LocPieces;

    StartIndex = InStr(Caps(Map), "<STRINGS:");
    // End:0x38
    if(StartIndex == -1)
    {
    }
    Map = Right(Map, (Len(Map) - StartIndex) - 9);
    EndIndex = InStr(Map, ">");
    // End:0x11A
    if(EndIndex != -1)
    {
        Map = Left(Map, EndIndex);
        ParseStringIntoArray(Map, LocPieces, ".", true);
        // End:0x11A
        if(LocPieces.Length >= 3)
        {
            Map = Localize(LocPieces[1], LocPieces[2], LocPieces[0]);
        }
    }
    // End:0x135
    if(Len(Map) > 0)
    {
        return Map;
    }
    return Map;
    //return ReturnValue;    
}

defaultproperties
{
    TitleString="Select Community Level"
    MapListString="Levels"
    GetMapsString="Get Maps from Workshop"
    MovieInfo=SwfMovie'PKHD_UI.PKCommunitySingle'
}