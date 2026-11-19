class PKGFxUI_Menu_SurvivalSP extends PKGFxUI_Menu_Base
    config(UI);

enum eDescriptionID
{
    DID_None,                       // 0
    DID_SurviveWitLimitedTimeAndLives,// 1
    DID_FightAndSurviveWithonlyOneLife,// 2
    DID_BlastYourPathToTheBossAndFireHim,// 3
    DID_FightYourWayThroughTheMapWithLimitedAmmoAndLives,// 4
    DID_FinishTheMapWithoutDying,   // 5
    DID_WinTheBattleWithoutDying,   // 6
    DID_MAX                         // 7
};

enum eSVSPDifficulty
{
    SVSPD_Easy,                     // 0
    SVSPD_Medium,                   // 1
    SVSPD_Hard,                     // 2
    SVSPD_MAX                       // 3
};

struct native SVSPMapInfo
{
    var string RawMapName;
    var int TimeLimit;
    var int FragLimit;
    var int LivesLimit;
    var PKGFxUI_Menu_SurvivalSP.eSVSPDifficulty SVDifficulty;
    var int AdditionalScore;
    var PKGFxUI_Menu_SurvivalSP.eDescriptionID DescID;
    var PKAchievements.EPKGameAchievements AchievID;

    structdefaultproperties
    {
        RawMapName=""
        TimeLimit=0
        FragLimit=0
        LivesLimit=0
        SVDifficulty=eSVSPDifficulty.SVSPD_Easy
        AdditionalScore=0
        DescID=eDescriptionID.DID_None
        AchievID=EPKGameAchievements.EPKA_Invalid
    }
};

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject MapsTF;
var GFxObject ObjectiveTF;
var GFxObject ObjectiveDescTF;
var GFxObject DifficultyTF;
var GFxObject TimeTF;
var GFxObject CompletedTF;
var GFxObject WorkshopLogoMC;
var GFxObject WorkshopTF;
var GFxObject WorkshopNameTF;
var GFxObject AuthorHeaderTF;
var GFxObject AuthorTF;
var GFxClikWidget StartBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget MapList;
var GFxObject MapListDataProvider;
var array<UTUIDataProvider_MapInfo> Maps;
var const localized string TitleString;
var const localized string MapListString;
var const localized string ChallengeCompleted;
var const localized string MapDifficulty;
var int CurrentMapInfoIndex;
var const localized array<localized string> SVDescription;
var const localized array<localized string> SVDifficulties;
var array<SVSPMapInfo> MapsInfo;
//var delegate<MapListSort> __MapListSort__Delegate;

function string BuildURL()
{
    local UIDataStore_Registry Registry;
    local string _url;
    local int _goalScore, _timeLimit, _livesLimit;
    local string _MapName;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.GetData("SelectedMap", _MapName);
    _goalScore = 30;
    _timeLimit = 30;
    _livesLimit = 3;
    // End:0x134
    if(CurrentMapInfoIndex >= 0)
    {
        _goalScore = MapsInfo[CurrentMapInfoIndex].FragLimit;
        _timeLimit = MapsInfo[CurrentMapInfoIndex].TimeLimit;
        _livesLimit = MapsInfo[CurrentMapInfoIndex].LivesLimit;
    }
    _url = _MapName;    
    _url $= "?MaxPlayers=0?NumPublicConnections=0?NumPrivateConnections=0?NumOpenPublicConnections=0?NumOpenPrivateConnections=0?bShouldAdvertise=False";    
    _url $= "?bIsLanMatch=False?bUsesStats=True?bAllowJoinInProgress=False?bAllowInvites=False?bUsesPresence=False?bAllowJoinViaPresence=False?bAllowJoinViaPresenceFriendsOnly=False";    
    _url $= "?bUsesArbitration=False?bAntiCheatProtected=False?bIsDedicated=False?";    
    _url $= ("?CustomMapName=" $ _MapName);    
    _url $= "?CustomGameMode=PKHDGame.PKGameSingleSurvival?game=PKHDGame.PKGameSingleSurvival";    
    _url $= ("?gamepad=" $ ((Class'Engine.WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().PlayerInput.bUsingGamepad) ? "1" : "0"));    
    _url $= ("?GoalScore=" $ string(_goalScore));    
    _url $= ("?TimeLimit=" $ string(_timeLimit));    
    _url $= ("?MaxLives=" $ string(_livesLimit));    
    _url $= ("?SVDifficulty=" $ string(int(MapsInfo[CurrentMapInfoIndex].SVDifficulty)));    
    _url $= ("?AdditionalScore=" $ string(MapsInfo[CurrentMapInfoIndex].AdditionalScore));    
    _url $= ("?DescriptionID=" $ string(int(MapsInfo[CurrentMapInfoIndex].DescID)));    
    _url $= ("?AchievID=" $ string(int(MapsInfo[CurrentMapInfoIndex].AchievID)));    
    _url $= ("?SPSVMapInfoIndex=" $ string(CurrentMapInfoIndex));
    return _url;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    MapsTF = ButtonsMC.GetObject("mapsTF");
    ObjectiveTF = ButtonsMC.GetObject("ObjectiveTF");
    ObjectiveDescTF = ButtonsMC.GetObject("ObjectiveDescTF");
    DifficultyTF = ButtonsMC.GetObject("DifficultyTF");
    TimeTF = ButtonsMC.GetObject("TimeTF");
    CompletedTF = ButtonsMC.GetObject("CompletedTF");
    WorkshopLogoMC = ButtonsMC.GetObject("workshopLogoMC");
    WorkshopLogoMC.SetVisible(false);
    WorkshopTF = ButtonsMC.GetObject("workshopTF");
    WorkshopTF.SetText(Localize("Workshop", "Author", "PKHDGame"));
    WorkshopNameTF = ButtonsMC.GetObject("workshopNameTF");
    WorkshopNameTF.SetText("dupa" @ (Localize("Workshop", "PackageName", "PKHDGame")));
    AuthorHeaderTF = ButtonsMC.GetObject("authorHeaderTF");
    AuthorHeaderTF.SetText(Localize("Workshop", "PackageName", "PKHDGame"));
    AuthorTF = ButtonsMC.GetObject("authorTF");
    AuthorTF.SetBool("visible", false);
    StartBtn = GFxClikWidget(ButtonsMC.GetObject("start_btn", Class'GFxUI.GFxClikWidget'));
    StartBtn.SetString("label", Class'PKGFxUI_Menu_MapSelect'.default.NewGameString);
    // End:0x539
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        StartBtn.SetBool("visible", false);
    }
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x611
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    MapList = GFxClikWidget(ButtonsMC.GetObject("list_helper", Class'GFxUI.GFxClikWidget'));
    UpdateListDataProvider();
    TitleTF.SetText(TitleString);
    MapsTF.SetText(MapListString);
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
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;
    local array<UDKUIResourceDataProvider> ProviderList;
    local array<UTUIDataProvider_MapInfo> LocalMapList;
    local UTUIDataProvider_MapInfo tmpMap;
    local UIDataStore_Registry Registry;
    local PKPlayerController PC;
    local SVSPMapInfo WorkshopMap;

    PC = PKPlayerController(GetPC());
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("SelectedGameModePrefix", "SV");
    Maps.Length = 0;
    LocalMapList.Length = 0;
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0xE8:

    // End:0x3F4 [Loop If]
    if(I < ProviderList.Length)
    {
        tmpMap = UTUIDataProvider_MapInfo(ProviderList[I]);
        // End:0x3E6
        if(tmpMap.FromWorkshop && tmpMap.SoloSurvivalSupported)
        {
            WorkshopMap.RawMapName = tmpMap.MapName;
            WorkshopMap.TimeLimit = tmpMap.SoloSVTimeLimit;
            WorkshopMap.FragLimit = tmpMap.SoloSVFragLimit;
            WorkshopMap.LivesLimit = tmpMap.SoloSVLivesLimit;
            WorkshopMap.SVDifficulty = byte(tmpMap.SoloSVDiffuculty);
            WorkshopMap.AdditionalScore = tmpMap.SoloSVAddiditonalScore;
            WorkshopMap.AchievID = 0;
            switch(WorkshopMap.SVDifficulty)
            {
                // End:0x33C
                case 0:
                    WorkshopMap.AdditionalScore = 100;
                    // End:0x390
                    break;
                // End:0x363
                case 1:
                    WorkshopMap.AdditionalScore = 200;
                    // End:0x390
                    break;
                // End:0x38D
                case 2:
                    WorkshopMap.AdditionalScore = 500;
                    // End:0x390
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            WorkshopMap.DescID = byte(tmpMap.SoloSVDescription + 1);
            MapsInfo.AddItem(WorkshopMap);
        }
        I++;
        // [Loop Continue]
        goto J0xE8;
    }
    I = 0;
    J0x3FF:

    // End:0x4DF [Loop If]
    if(I < ProviderList.Length)
    {
        tmpMap = UTUIDataProvider_MapInfo(ProviderList[I]);
        // End:0x474
        if((TryFindMapsInfoIndexForGivenMapName(Caps(tmpMap.MapName))) == -1)
        {            
        }
        else
        {
            // End:0x4BB
            if(!PC.CheckIfUserHasRightsToThatSpecificMap(Caps(tmpMap.MapName)))
            {                
            }
            else
            {
                LocalMapList.AddItem(tmpMap);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x3FF;
    }
    // End:0x4F1
    if(LocalMapList.Length == 0)
    {
        return;
    }
    LocalMapList.Sort(MapListSort);
    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x539:

    // End:0x801 [Loop If]
    if(I < LocalMapList.Length)
    {
        tmpMap = LocalMapList[I];
        // End:0x7F3
        if(!tmpMap.ShouldBeFiltered())
        {
            Maps.AddItem(tmpMap);
            TempObj = CreateObject("Object");
            TempObj.SetBool("html", true);
            // End:0x667
            if(tmpMap.FromWorkshop)
            {
                TempObj.SetString("label", Caps("*" $ (GetMapFriendlyName(tmpMap.MapName))));                
            }
            else
            {
                TempObj.SetString("label", Caps(GetMapFriendlyName(tmpMap.MapName)));
            }
            TempObj.SetString("players", tmpMap.NumPlayers);
            // End:0x776
            if(tmpMap.PreviewImageMarkup != "")
            {
                TempObj.SetString("image", "img://" $ tmpMap.PreviewImageMarkup);                
            }
            else
            {
                TempObj.SetString("image", "img://" $ "UDKFrontEnd.gm_map_none");
            }
            DataProvider.SetElementObject(ListCounter++, TempObj);
        }
        I++;
        // [Loop Continue]
        goto J0x539;
    }
    MapList.SetObject("dataProvider", DataProvider);
    MapListDataProvider = MapList.GetObject("dataProvider");
    MapList.SetFloat("selectedIndex", 0.0000000);
    Registry.SetData("SelectedMap", Maps[0].MapName);
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

function OnStart(EventData ev)
{
    Action = "newgame";
    PlayCloseAnimation();
    //return;    
}

function OnListSelect(int Index)
{
    // End:0x1A
    if(Index >= Maps.Length)
    {
        return;
    }
    // End:0x95
    if(GetPC().PlayerInput.bUsingGamepad || Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
    {
        Action = "newgame";
        PlayCloseAnimation();
    }
    //return;    
}

function OnListChange(int Index)
{
    local UIDataStore_Registry Registry;

    // End:0x1A
    if(Index >= Maps.Length)
    {
        return;
    }
    OnListOver(Index);
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("SelectedMap", Maps[Index].MapName);
    CurrentMapInfoIndex = TryFindMapsInfoIndexForGivenMapName(Maps[Index].MapName);
    //return;    
}

function OnListOver(int Index)
{
    local PKPlayerController PC;
    local int LocalMapInfoIndex;
    local UTUIDataProvider_MapInfo tmpMap;
    local OnlineSubsystemSteamworks steam;
    local WorkshopPackageInfo wsPackageInfo;

    steam = OnlineSubsystemSteamworks(Class'Engine.GameEngine'.static.GetOnlineSubsystem());
    // End:0x4C
    if(Index >= Maps.Length)
    {
        return;
    }
    tmpMap = Maps[Index];
    PC = PKPlayerController(GetPC());
    LocalMapInfoIndex = TryFindMapsInfoIndexForGivenMapName(tmpMap.MapName);
    ObjectiveTF.SetText(Caps(GetMapFriendlyName(tmpMap.MapName)));
    ObjectiveDescTF.SetText(SVDescription[int(MapsInfo[LocalMapInfoIndex].DescID)]);
    DifficultyTF.SetText((MapDifficulty $ ":") @ SVDifficulties[int(MapsInfo[LocalMapInfoIndex].SVDifficulty)]);
    TimeTF.SetText((Class'PainGFxHud'.default.TimeString $ ":") @ Class'PKGFxUI_Scoreboard'.static.FormatTime(MapsInfo[LocalMapInfoIndex].TimeLimit * 60));
    // End:0x2B0
    if(PC.PersistentData.IsSPSurvivalLevelCompleted(LocalMapInfoIndex))
    {
        CompletedTF.SetText(ChallengeCompleted);        
    }
    else
    {
        CompletedTF.SetText("");
    }
    // End:0x47C
    if(tmpMap.FromWorkshop && tmpMap.SoloSurvivalSupported)
    {
        wsPackageInfo = steam.FindWorkshopPackageInfoForGivenPackageName(tmpMap.WorkshopPackageName);
        WorkshopTF.SetVisible(true);
        WorkshopNameTF.SetVisible(true);
        AuthorHeaderTF.SetVisible(true);
        AuthorTF.SetVisible(true);
        AuthorTF.SetText(wsPackageInfo.EntryTitle);
        WorkshopNameTF.SetText(tmpMap.Author);
        WorkshopLogoMC.SetVisible(true);        
    }
    else
    {
        WorkshopTF.SetVisible(false);
        WorkshopNameTF.SetVisible(false);
        AuthorHeaderTF.SetVisible(false);
        AuthorTF.SetVisible(false);
        WorkshopLogoMC.SetVisible(false);
    }
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
        FrontEnd.CloseSurvivalSP();
    }
    Action = "";
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

function int TryFindMapsInfoIndexForGivenMapName(string MapName)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x73 [Loop If]
    if(I < MapsInfo.Length)
    {
        // End:0x65
        if(Caps(MapsInfo[I].RawMapName) ~= Caps(MapName))
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return -1;
    //return ReturnValue;    
}

defaultproperties
{
    TitleString="Solo Survival"
    MapListString="Survival Maps"
    ChallengeCompleted="Challenge completed!"
    MapDifficulty="Map difficulty"
    SVDescription[0]="None"
    SVDescription[1]="Survive with limited time and lives."
    SVDescription[2]="Fight and survive with only one life."
    SVDescription[3]="Blast your path to the Boss and fire him."
    SVDescription[4]="Fight your way through the map with limited ammo and lives."
    SVDescription[5]="Finish the map without dying."
    SVDescription[6]="Win the battle without dying."
    SVDifficulties[0]="Easy"
    SVDifficulties[1]="Medium"
    SVDifficulties[2]="Hard"
    MapsInfo[0]=(RawMapName="SV-AtriumComplex",TimeLimit=5,FragLimit=0,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Easy,AdditionalScore=100,DescID=eDescriptionID.DID_SurviveWitLimitedTimeAndLives,AchievID=EPKGameAchievements.EPKA_CHALLENGE_ATRIUMCOMPLEX)
    MapsInfo[1]=(RawMapName="SV-CityOnWater",TimeLimit=5,FragLimit=0,LivesLimit=1,SVDifficulty=eSVSPDifficulty.SVSPD_Easy,AdditionalScore=100,DescID=eDescriptionID.DID_FightAndSurviveWithonlyOneLife,AchievID=EPKGameAchievements.EPKA_CHALLENGE_CITYONWATER)
    MapsInfo[2]=(RawMapName="SV-Opera",TimeLimit=4,FragLimit=0,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Easy,AdditionalScore=100,DescID=eDescriptionID.DID_SurviveWitLimitedTimeAndLives,AchievID=EPKGameAchievements.EPKA_CHALLENGE_OPERA)
    MapsInfo[3]=(RawMapName="SV-TrainStation",TimeLimit=5,FragLimit=0,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Easy,AdditionalScore=100,DescID=eDescriptionID.DID_SurviveWitLimitedTimeAndLives,AchievID=EPKGameAchievements.EPKA_CHALLENGE_TRAINSTATION)
    MapsInfo[4]=(RawMapName="SV-Unseen_HD",TimeLimit=3,FragLimit=0,LivesLimit=1,SVDifficulty=eSVSPDifficulty.SVSPD_Easy,AdditionalScore=100,DescID=eDescriptionID.DID_FightAndSurviveWithonlyOneLife,AchievID=EPKGameAchievements.EPKA_CHALLENGE_UNSEEN)
    MapsInfo[5]=(RawMapName="SV-Chaos_HD_DLC_1",TimeLimit=25,FragLimit=350,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Medium,AdditionalScore=200,DescID=eDescriptionID.DID_BlastYourPathToTheBossAndFireHim,AchievID=EPKGameAchievements.EPKA_CHALLENGE_CHAOS)
    MapsInfo[6]=(RawMapName="SV-Illuminati_HD_DLC_1",TimeLimit=25,FragLimit=350,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Medium,AdditionalScore=200,DescID=eDescriptionID.DID_BlastYourPathToTheBossAndFireHim,AchievID=EPKGameAchievements.EPKA_CHALLENGE_ILLUMINATI)
    MapsInfo[7]=(RawMapName="SV-Inhumator_DLC_1",TimeLimit=10,FragLimit=150,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Medium,AdditionalScore=200,DescID=eDescriptionID.DID_BlastYourPathToTheBossAndFireHim,AchievID=EPKGameAchievements.EPKA_CHALLENGE_INHUMATOR)
    MapsInfo[8]=(RawMapName="SV-Psycho_HD_DLC_1",TimeLimit=4,FragLimit=0,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Easy,AdditionalScore=100,DescID=eDescriptionID.DID_SurviveWitLimitedTimeAndLives,AchievID=EPKGameAchievements.EPKA_CHALLENGE_PSYCHO)
    MapsInfo[9]=(RawMapName="SV-Fragenstein_HD_DLC_3",TimeLimit=5,FragLimit=0,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Easy,AdditionalScore=100,DescID=eDescriptionID.DID_SurviveWitLimitedTimeAndLives,AchievID=EPKGameAchievements.EPKA_CHALLENGE_FRAGENSTEIN)
    MapsInfo[10]=(RawMapName="SV-Community1_HD_DLC_4",TimeLimit=20,FragLimit=350,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Hard,AdditionalScore=500,DescID=eDescriptionID.DID_FightYourWayThroughTheMapWithLimitedAmmoAndLives,AchievID=EPKGameAchievements.EPKA_CHALLENGE_COMMUNITY_BLINK)
    MapsInfo[11]=(RawMapName="SV-Community2_HD_DLC_4",TimeLimit=20,FragLimit=350,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Hard,AdditionalScore=500,DescID=eDescriptionID.DID_FightYourWayThroughTheMapWithLimitedAmmoAndLives,AchievID=EPKGameAchievements.EPKA_CHALLENGE_COMMUNITY_MEATLESS)
    MapsInfo[12]=(RawMapName="SV-Community3_HD_DLC_4",TimeLimit=20,FragLimit=350,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Hard,AdditionalScore=500,DescID=eDescriptionID.DID_FightYourWayThroughTheMapWithLimitedAmmoAndLives,AchievID=EPKGameAchievements.EPKA_CHALLENGE_COMMUNITY_MINES)
    MapsInfo[13]=(RawMapName="SV-Community4_HD_DLC_4",TimeLimit=20,FragLimit=350,LivesLimit=1,SVDifficulty=eSVSPDifficulty.SVSPD_Hard,AdditionalScore=500,DescID=eDescriptionID.DID_FinishTheMapWithoutDying,AchievID=EPKGameAchievements.EPKA_CHALLENGE_COMMUNITY_PRISON)
    MapsInfo[14]=(RawMapName="SV-SnowTown_DLC_4",TimeLimit=20,FragLimit=253,LivesLimit=1,SVDifficulty=eSVSPDifficulty.SVSPD_Hard,AdditionalScore=500,DescID=eDescriptionID.DID_FinishTheMapWithoutDying,AchievID=EPKGameAchievements.EPKA_CHALLENGE_COMMUNITY_SNOWTOWN)
    MapsInfo[15]=(RawMapName="SV-Factory_DLC_7",TimeLimit=20,FragLimit=300,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Medium,AdditionalScore=200,DescID=eDescriptionID.DID_SurviveWitLimitedTimeAndLives,AchievID=EPKGameAchievements.EPKA_CHALLENGE_FACTORY)
    MapsInfo[16]=(RawMapName="SV-HalloweenHouse",TimeLimit=15,FragLimit=150,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Easy,AdditionalScore=100,DescID=eDescriptionID.DID_SurviveWitLimitedTimeAndLives,AchievID=EPKGameAchievements.EPKA_CHALLENGE_HALLOWEEN_TOWN)
    MapsInfo[17]=(RawMapName="SV-OrientalFortress",TimeLimit=15,FragLimit=250,LivesLimit=3,SVDifficulty=eSVSPDifficulty.SVSPD_Medium,AdditionalScore=200,DescID=eDescriptionID.DID_SurviveWitLimitedTimeAndLives,AchievID=EPKGameAchievements.EPKA_Invalid)
    MovieInfo=SwfMovie'PKHD_UI.PKSurvivalSP'
}