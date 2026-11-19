class PKEngine extends EvilEngine
    transient
    native
    config(Engine);

enum EVideoOptionsSettings
{
    VOS_Custom,                     // 0
    VOS_VeryLow,                    // 1
    VOS_Low,                        // 2
    VOS_Medium,                     // 3
    VOS_High,                       // 4
    VOS_VeryHigh,                   // 5
    VOS_MAX                         // 6
};

enum EPKInputBlockType
{
    ePKIBT_CreateParty,             // 0
    ePKIBT_CancelMatchmaking,       // 1
    ePKIBT_Matchmaking,             // 2
    ePKIBT_UpdateParty,             // 3
    ePKIBT_DestroyParty,            // 4
    ePKIBT_MainMenuReturn,          // 5
    ePKIBT_DestroyPartyForLIVE,     // 6
    ePKIBT_PlaylistDownload,        // 7
    ePKIBT_PlayPopDownload,         // 8
    ePKIBT_DLCDownload,             // 9
    ePKIBT_ProfileRead,             // 10
    ePKIBT_ProfileSave,             // 11
    ePKIBT_StatsRead,               // 12
    ePKIBT_LANGameSearch,           // 13
    ePKIBT_BetaProfileRead,         // 14
    ePKIBT_SaveGameRead,            // 15
    ePKIBT_MAX                      // 16
};

struct native PKInputBlockDefaults
{
    var int Priority;
    var string TitleVariableName;
    var string DescVariableName;

    structdefaultproperties
    {
        Priority=0
        TitleVariableName=""
        DescVariableName=""
    }
};

struct native PKInputBlockData
{
    var PKEngine.EPKInputBlockType InputBlockType;
    var string TitleVariableName;
    var string DescVariableName;

    structdefaultproperties
    {
        InputBlockType=EPKInputBlockType.ePKIBT_CreateParty
        TitleVariableName=""
        DescVariableName=""
    }
};

var array<int> DLCIdentifiersToDLCNum;
var int TotalActiveSoulsLights;
var const int MaxTotalActiveSoulsLights;
var bool bWasUsingGamepad;
var array<MaterialInterface> MenuLevelPrestreamMaterials;
var int PKDMapIndex;
var array<string> PKDMaps;
var const array<PKInputBlockDefaults> InputBlockDefaults;
var transient array<PKInputBlockData> InputBlockDataList;
var transient array< delegate<OnInputBlockFinished> > InputBlockDelegates;
//var delegate<OnInputBlockFinished> __OnInputBlockFinished__Delegate;

delegate OnInputBlockFinished()
{
    //return;    
}

final function AddInputBlockFinishedDelegate(delegate<OnInputBlockFinished> InputBlockFinishedDelegate)
{
    // End:0x36
    if(InputBlockDelegates.Find(InputBlockFinishedDelegate) == -1)
    {
        InputBlockDelegates.AddItem(InputBlockFinishedDelegate);
    }
    //return;    
}

final function ClearInputBlockFinishedDelegate(delegate<OnInputBlockFinished> InputBlockFinishedDelegate)
{
    InputBlockDelegates.RemoveItem(InputBlockFinishedDelegate);
    //return;    
}

final function TriggerInputBlockFinishedDelegates()
{
    local int DelegateIdx;
    local delegate<OnInputBlockFinished> OnInputBlockFinishedDelegate;

    DelegateIdx = 0;
    J0x0B:

    // End:0x61 [Loop If]
    if(DelegateIdx < InputBlockDelegates.Length)
    {
        OnInputBlockFinishedDelegate = InputBlockDelegates[DelegateIdx];
        OnInputBlockFinished();
        DelegateIdx++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

static function OpenInputBlockingScene(PKEngine.EPKInputBlockType BlockType, optional string TitleVarName = "", optional string DescVarName = "")
{
    local int Idx;
    local PKUIManager Manager;
    local PKEngine GEngine;
    local int NewIdx;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    GEngine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x3D3
    if((Manager != none) && GEngine != none)
    {
        Idx = GEngine.InputBlockDataList.Find('InputBlockType', BlockType);
        // End:0x383
        if(Idx == -1)
        {
            NewIdx = GEngine.InputBlockDataList.Length;
            GEngine.InputBlockDataList.Length = NewIdx + 1;
            GEngine.InputBlockDataList[NewIdx].InputBlockType = BlockType;
            GEngine.InputBlockDataList[NewIdx].TitleVariableName = ((TitleVarName == "") ? GEngine.InputBlockDefaults[int(BlockType)].TitleVariableName : TitleVarName);
            GEngine.InputBlockDataList[NewIdx].DescVariableName = ((DescVarName == "") ? GEngine.InputBlockDefaults[int(BlockType)].DescVariableName : DescVarName);
            // End:0x361
            if(Manager.UpdatingScene == none)
            {
                Manager.OpenUpdatingScene(GEngine.InputBlockDataList[NewIdx].TitleVariableName, GEngine.InputBlockDataList[NewIdx].DescVariableName);                
            }
            else
            {
                GEngine.UpdateInputBlockingScene();
            }            
        }
        else
        {
            Idx = 0;
            J0x38E:

            // End:0x3C9 [Loop If]
            if(Idx < GEngine.InputBlockDataList.Length)
            {
                Idx++;
                // [Loop Continue]
                goto J0x38E;
            }
            ScriptTrace();
        }
    }
    //return;    
}

static function CloseInputBlockingScene(PKEngine.EPKInputBlockType BlockType)
{
    local int Idx;
    local PKUIManager Manager;
    local PKEngine GEngine;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    GEngine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x1B9
    if((Manager != none) && GEngine != none)
    {
        Idx = GEngine.InputBlockDataList.Find('InputBlockType', BlockType);
        // End:0x169
        if(Idx != -1)
        {
            GEngine.InputBlockDataList.Remove(Idx, 1);
            // End:0x147
            if(GEngine.InputBlockDataList.Length == 0)
            {
                Manager.CloseUpdatingScene();                
            }
            else
            {
                GEngine.UpdateInputBlockingScene();
            }            
        }
        else
        {
            Idx = 0;
            J0x174:

            // End:0x1AF [Loop If]
            if(Idx < GEngine.InputBlockDataList.Length)
            {
                Idx++;
                // [Loop Continue]
                goto J0x174;
            }
            ScriptTrace();
        }
    }
    //return;    
}

static function ClearInputBlockingScenes()
{
    local PKUIManager Manager;
    local PKEngine GEngine;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    GEngine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0xC5
    if((Manager != none) && GEngine != none)
    {
        GEngine.InputBlockDataList.Length = 0;
        Manager.CloseUpdatingScene();
    }
    //return;    
}

static function bool IsInputBlockingSceneInList(PKEngine.EPKInputBlockType BlockType)
{
    local PKEngine GEngine;

    GEngine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x7D
    if(GEngine != none)
    {
        return GEngine.InputBlockDataList.Find('InputBlockType', BlockType) != -1;
    }
    return false;
    //return ReturnValue;    
}

function UpdateInputBlockingScene()
{
    local int Idx, HighestPriorityIdx;
    local PKUIManager Manager;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x18A
    if(Manager != none)
    {
        HighestPriorityIdx = 0;
        Idx = 1;
        J0x57:

        // End:0x11F [Loop If]
        if(Idx < InputBlockDataList.Length)
        {
            // End:0x111
            if(InputBlockDefaults[int(InputBlockDataList[HighestPriorityIdx].InputBlockType)].Priority < InputBlockDefaults[int(InputBlockDataList[Idx].InputBlockType)].Priority)
            {
                HighestPriorityIdx = Idx;
            }
            Idx++;
            // [Loop Continue]
            goto J0x57;
        }
        Manager.UpdateUpdatingScene(InputBlockDataList[HighestPriorityIdx].TitleVariableName, InputBlockDataList[HighestPriorityIdx].DescVariableName);
    }
    //return;    
}

function InputBlockingSceneClosing()
{
    // End:0x1A
    if(InputBlockDataList.Length == 0)
    {
        TriggerInputBlockFinishedDelegates();
    }
    //return;    
}

event MapLoading(URL LoadURL, PendingLevel Pending, string Error)
{
    local WorldInfo WorldInfo;
    local PKPlayerController PC;
    local int I;
    local bool bCheckpoint, bFirstLevel;

    WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    bCheckpoint = int(PendingCheckpointAction) == int(1);
    bWasUsingGamepad = ((WorldInfo != none) ? WorldInfo.IsConsoleBuild() : false);
    TotalActiveSoulsLights = 0;
    // End:0x275
    if(!bCheckpoint)
    {
        I = 0;
        J0xA7:

        // End:0x275 [Loop If]
        if(I < LoadURL.Op.Length)
        {
            // End:0x12C
            if(InStr(LoadURL.Op[I], "PKGameCooperative", true, true) != -1)
            {
                bFirstLevel = false;
                // [Explicit Break]
                goto J0x275;                
            }
            else
            {
                // End:0x171
                if(LoadURL.Op[I] == "chapter=1")
                {
                    bFirstLevel = true;                    
                }
                else
                {
                    // End:0x1F4
                    if((Left(LoadURL.Op[I], 14) == "loadcheckpoint") && Right(LoadURL.Op[I], 2) != "=0")
                    {
                        bCheckpoint = true;                        
                    }
                    else
                    {
                        // End:0x267
                        if(Left(LoadURL.Op[I], 7) == "gamepad")
                        {
                            bWasUsingGamepad = Right(LoadURL.Op[I], 2) == "=1";
                        }
                    }
                }
            }
            ++I;
            // [Loop Continue]
            goto J0xA7;
        }
    }
    J0x275:

    // End:0x34D
    if((bFirstLevel && !bCheckpoint) && WorldInfo != none)
    {
        // End:0x33D
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
        {
            PC.ClientStopMovie(0.0000000, false, true, true);
            PC.ClientPlayMovie("PKHD_Intro_LOC", -1, -1, false, true, false);            
        }        
        FramesUntilIntroMayBeSkipped = 5;        
    }
    else
    {
        FramesUntilIntroMayBeSkipped = 0;
    }
    //return;    
}

event PostLoadMap()
{
    local WorldInfo WorldInfo;
    local PlayerController PC;
    local MaterialInterface MI;

    WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x8F
    if(int(WorldInfo.NetMode) < int(NM_Client))
    {
        PainGRI(WorldInfo.GRI).GetTotalStatisticsFromMapInfo();
    }
    // End:0x10C
    if(bPastFirstLoad)
    {
        // End:0x109
        if(FramesUntilIntroMayBeSkipped == 0)
        {
            // End:0x108
            foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
            {
                PKPlayerController(PC).StartupStopLoadingMovie();                
            }            
        }        
    }
    else
    {
        // End:0x14F
        foreach MenuLevelPrestreamMaterials(MI)
        {
            MI.SetForceMipLevelsToBeResident(false, false, 5.0000000, -1);            
        }        
    }
    //return;    
}

event NotifyIntroMayBeSkipped()
{
    local string SkipText;

    SetMovieIsSkippable(true);
    RemoveAllOverlays();
    SkipText = Localize("MovieOverlay", "SkipMovie", "PKHDGame");
    // End:0xC2
    if(bWasUsingGamepad)
    {
        AddOverlay(Font'ui_fonts.Fonts.UI_Fonts_Xbox18', "<", 0.0000000, 0.0000000, 0.5000000, 0.5000000, false);
        AddOverlay(GetSubtitleFont(), "     " $ SkipText, 0.0000000, 0.0000000, 1.0000000, 1.0000000, false);        
    }
    else
    {
        AddOverlay(GetSubtitleFont(), ((Localize("GameMappedStrings", "GMS_LeftMouseButton", "PKHDGame")) @ "-") @ SkipText, 0.0000000, 0.0000000, 1.0000000, 1.0000000, false);
    }
    //return;    
}

function RestartGame()
{
    local PKUIManager UIManager;
    local PKFrontEnd FrontEnd;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    FrontEnd = Class'PKFrontEnd'.static.GetFrontEnd();
    // End:0x8B
    if(UIManager != none)
    {
        UIManager.CloseAllUIMessageBoxes();
    }
    // End:0xB9
    if(FrontEnd != none)
    {
        FrontEnd.Close();
    }
    super.RestartGame();
    //return;    
}

event bool CheckIfEngineShouldBreakMapLoading(URL LoadURL, string ChapterId, PendingLevel Pending, out string RetTitle, out string RetError)
{
    local PKPlayerController PC;

    PC = PKPlayerController(GamePlayers[0].Actor);
    // End:0xB9
    if(((PC != none) && PC.IsFreeJanuaryWeekendSubscribed()) && int(ChapterId) > 4)
    {
        RetError = "pocaluj mnie w dupe";
        RetTitle = "JanuaryFreeWeekend";
        return true;
    }
    return false;
    //return ReturnValue;    
}

// Export UPKEngine::execSteamActivateGameOverlayToStore(FFrame&, void* const)
native final function SteamActivateGameOverlayToStore(int AppID, int Flags);

// Export UPKEngine::execSteamActivateGameOverlayToBuyFullGame(FFrame&, void* const)
native final function SteamActivateGameOverlayToBuyFullGame();

// Export UPKEngine::execSteamActivateGameOverlayToCommunitySP(FFrame&, void* const)
native final function SteamActivateGameOverlayToCommunitySP();

// Export UPKEngine::execSteamActivateGameOverlayToCommunity(FFrame&, void* const)
native final function SteamActivateGameOverlayToCommunity();

static final function ShowDLCStore(int DLCIndex)
{
    local PKEngine Eng;

    Eng = PKEngine(Class'PKEngine'.static.GetEngine());
    switch(DLCIndex)
    {
        // End:0x72
        case 1:
            Eng.SteamActivateGameOverlayToStore(229190, 2);
            // End:0x189
            break;
        // End:0xA0
        case 2:
            Eng.SteamActivateGameOverlayToStore(229210, 2);
            // End:0x189
            break;
        // End:0xCE
        case 3:
            Eng.SteamActivateGameOverlayToStore(229230, 2);
            // End:0x189
            break;
        // End:0xFC
        case 4:
            Eng.SteamActivateGameOverlayToStore(229250, 2);
            // End:0x189
            break;
        // End:0x12A
        case 5:
            Eng.SteamActivateGameOverlayToStore(229270, 2);
            // End:0x189
            break;
        // End:0x158
        case 6:
            Eng.SteamActivateGameOverlayToStore(229290, 2);
            // End:0x189
            break;
        // End:0x186
        case 7:
            Eng.SteamActivateGameOverlayToStore(229310, 2);
            // End:0x189
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

static function ShowDLCStoreByDLCIdentifier(PKTypes.EDLCIdentifiers DLCID)
{
    local PKEngine Eng;

    Eng = PKEngine(Class'PKEngine'.static.GetEngine());
    switch(DLCID)
    {
        // End:0x73
        case 8:
            Eng.SteamActivateGameOverlayToStore(229190, 2);
            // End:0x18A
            break;
        // End:0xA1
        case 9:
            Eng.SteamActivateGameOverlayToStore(229210, 2);
            // End:0x18A
            break;
        // End:0xCF
        case 10:
            Eng.SteamActivateGameOverlayToStore(229230, 2);
            // End:0x18A
            break;
        // End:0xFD
        case 11:
            Eng.SteamActivateGameOverlayToStore(229250, 2);
            // End:0x18A
            break;
        // End:0x12B
        case 12:
            Eng.SteamActivateGameOverlayToStore(229270, 2);
            // End:0x18A
            break;
        // End:0x159
        case 13:
            Eng.SteamActivateGameOverlayToStore(229290, 2);
            // End:0x18A
            break;
        // End:0x187
        case 14:
            Eng.SteamActivateGameOverlayToStore(229310, 2);
            // End:0x18A
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function SetCanBreakFullscreenMovie(bool Flag)
{
    bCanBreakFullScreenMovie = Flag;
    //return;    
}

// Export UPKEngine::execSwitchPadLayoutToDefault(FFrame&, void* const)
native function SwitchPadLayoutToDefault();

// Export UPKEngine::execSwitchPadLayoutForSplitScreen(FFrame&, void* const)
native function SwitchPadLayoutForSplitScreen();

// Export UPKEngine::execHasAllLevelsCommandline(FFrame&, void* const)
native function bool HasAllLevelsCommandline();

defaultproperties
{
    DLCIdentifiersToDLCNum[0]=-1
    DLCIdentifiersToDLCNum[1]=-1
    DLCIdentifiersToDLCNum[2]=-1
    DLCIdentifiersToDLCNum[3]=-1
    DLCIdentifiersToDLCNum[4]=-1
    DLCIdentifiersToDLCNum[5]=-1
    DLCIdentifiersToDLCNum[6]=-1
    DLCIdentifiersToDLCNum[7]=-1
    DLCIdentifiersToDLCNum[8]=1
    DLCIdentifiersToDLCNum[9]=2
    DLCIdentifiersToDLCNum[10]=3
    DLCIdentifiersToDLCNum[11]=4
    DLCIdentifiersToDLCNum[12]=5
    DLCIdentifiersToDLCNum[13]=6
    DLCIdentifiersToDLCNum[14]=7
    DLCIdentifiersToDLCNum[15]=8
    DLCIdentifiersToDLCNum[16]=9
    DLCIdentifiersToDLCNum[17]=10
    DLCIdentifiersToDLCNum[18]=11
    DLCIdentifiersToDLCNum[19]=12
    DLCIdentifiersToDLCNum[20]=13
    DLCIdentifiersToDLCNum[21]=14
    DLCIdentifiersToDLCNum[22]=15
    DLCIdentifiersToDLCNum[23]=16
    DLCIdentifiersToDLCNum[24]=17
    DLCIdentifiersToDLCNum[25]=18
    DLCIdentifiersToDLCNum[26]=19
    MaxTotalActiveSoulsLights=666
    MenuLevelPrestreamMaterials[0]=MaterialInstanceConstant'MaterialsBase_gib.Materials.mi_wp_SoulReaper_02_01fade'
    MenuLevelPrestreamMaterials[1]=MaterialInstanceConstant'MaterialsBase_gib.Materials.mi_wp_SoulReaper_01_01fade'
    InputBlockDefaults[0]=(Priority=90,TitleVariableName="CreatePartyTitle",DescVariableName="CreatePartyDesc")
    InputBlockDefaults[1]=(Priority=100,TitleVariableName="CancelMatchmakingTitle",DescVariableName="CancelMatchmakingDesc")
    InputBlockDefaults[2]=(Priority=100,TitleVariableName="MatchmakingTitle",DescVariableName="MatchmakingDesc")
    InputBlockDefaults[3]=(Priority=90,TitleVariableName="UpdatePartyTitle",DescVariableName="UpdatePartyDesc")
    InputBlockDefaults[4]=(Priority=90,TitleVariableName="DestroyPartyTitle",DescVariableName="DestroyPartyDesc")
    InputBlockDefaults[5]=(Priority=90,TitleVariableName="MainMenuReturnTitle",DescVariableName="MainMenuReturnDesc")
    InputBlockDefaults[6]=(Priority=90,TitleVariableName="DestroyPartyForLIVETitle",DescVariableName="DestroyPartyForLIVEDesc")
    InputBlockDefaults[7]=(Priority=10,TitleVariableName="PlaylistDownloadTitle",DescVariableName="PlaylistDownloadDesc")
    InputBlockDefaults[8]=(Priority=0,TitleVariableName="PlayPopDownloadTitle",DescVariableName="PlayPopDownloadDesc")
    InputBlockDefaults[9]=(Priority=20,TitleVariableName="DLCDownloadTitle",DescVariableName="DLCDownloadDesc")
    InputBlockDefaults[10]=(Priority=100,TitleVariableName="ProfileReadTitle",DescVariableName="ProfileReadDesc")
    InputBlockDefaults[11]=(Priority=100,TitleVariableName="ProfileSaveTitle",DescVariableName="ProfileSaveDesc")
    InputBlockDefaults[12]=(Priority=100,TitleVariableName="StatsReadTitle",DescVariableName="StatsReadDesc")
    InputBlockDefaults[13]=(Priority=100,TitleVariableName="LANGameSearchTitle",DescVariableName="LANGameSearchDesc")
    InputBlockDefaults[14]=(Priority=100,TitleVariableName="BetaUnlocksTitle",DescVariableName="BetaUnlocksDesc")
    InputBlockDefaults[15]=(Priority=100,TitleVariableName="SaveGameReadTitle",DescVariableName="SaveGameReadDesc")
    CheckpointClass=Class'PKCheckpoint'
}