class AdvEngine extends EvilEngine
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

enum EEngineState
{
    ES_Invalid,                     // 0
    ES_AtIS,                        // 1
    ES_AtInitialSequence,           // 2
    ES_StartingMultiplayerGame,     // 3
    ES_MAX                          // 4
};

struct native MMSaveSlotData
{
    var bool bIsCorrupted;
    var bool bIsLevelStart;
    var bool bContainsData;
    var int Day;
    var int Month;
    var int Year;
    var int SecondsSinceMidnight;
    var EvilHeaderData HeaderData;

    structdefaultproperties
    {
        bIsCorrupted=false
        bIsLevelStart=false
        bContainsData=false
        Day=0
        Month=0
        Year=0
        SecondsSinceMidnight=0
        HeaderData=(GameplayTime=0,LastSaveTime=0,CompletedLevelsMaskA=0,CompletedLevelsMaskB=0,CompletedLevelsMaskC=0,UniqueCollectedTreasures=none,ChapterNum=0,Difficulty=0,DifficultyOther=0,TreasuresCollectedInfoA=0,TreasuresCollectedInfoB=0,UpgradesInfoA=0,UpgradesInfoB=0,CollectedTreasuresMaps=0,LevelInitialUniqueCollectedTreasures=none,LevelInitialTreasuresCollectedInfoA=0,LevelInitialTreasuresCollectedInfoB=0,LevelInitialUpgradesInfoA=0,LevelInitialUpgradesInfoB=0,Inventory=none,InventoryAmmo=none)
    }
};

struct native DLCIDToOfferID
{
    var int DLCID;
    var int XBOXOfferID;
    var string PS3OfferID;

    structdefaultproperties
    {
        DLCID=0
        XBOXOfferID=0
        PS3OfferID=""
    }
};

struct native AdvDLCInfo
{
    var int DLCIndex;
    var string FriendlyName;
    var bool bContainsSinglePlayerMaps;
    var bool bContainsMultiplayerMaps;
    var array<AdvTypes.ELevelID> LevelIDS;

    structdefaultproperties
    {
        DLCIndex=0
        FriendlyName=""
        bContainsSinglePlayerMaps=false
        bContainsMultiplayerMaps=false
        LevelIDS=none
    }
};

struct native TreasureTypeAndIdToBitField
{
    var() AdvTypes.ELevelID LevelID;
    var() array<string> TreasureID;

    structdefaultproperties
    {
        LevelID=ELevelID.LID_Invalid
        TreasureID=none
    }
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
    var AdvEngine.EPKInputBlockType InputBlockType;
    var string TitleVariableName;
    var string DescVariableName;

    structdefaultproperties
    {
        InputBlockType=EPKInputBlockType.ePKIBT_CreateParty
        TitleVariableName=""
        DescVariableName=""
    }
};

struct native PKInviteCache
{
    var transient UniqueNetId InviteSender;
    var transient OnlineGameSearchResult InviteData;

    structdefaultproperties
    {
        InviteSender=(Uid=none)
        InviteData=(GameSettings=none)
    }
};

struct native LevelsRemap
{
    var AdvTypes.ELevelID Current;
    var AdvTypes.ELevelID Next;
    var byte PADA;
    var byte PADB;

    structdefaultproperties
    {
        Current=ELevelID.LID_Invalid
        Next=ELevelID.LID_Invalid
        PADA=0
        PADB=0
    }
};

struct native AchievementIDToPlatformAchievementID
{
    var AdvAchievements.EPKGameAchievements GameID;
    var byte XBoxID;
    var byte PS3ID;
    var byte PADA;

    structdefaultproperties
    {
        GameID=EPKGameAchievements.EADVA_Invalid
        XBoxID=0
        PS3ID=0
        PADA=0
    }
};

var bool bWasUsingGamepad;
var() bool bShowTutorialMessages;
var const bool bLoadingScreenActive;
var bool bLoadFromInvite;
var bool bCheckMapLoadTime;
var bool bDownloadPlaylistOnlyOnce;
var const transient bool bFlashlightUseMaterialFunction;
var const transient bool bFlashlight3rdPersonSpotlight;
var bool bFilledTemporaryOptions;
var array<MaterialInterface> MenuLevelPrestreamMaterials;
var float MapLoadStartTime;
var float MaxLoadTime;
var float LastTimeVal;
var MMSaveSlotData SaveSlotData[3];
var array<string> TemporaryCollectedTreasureIDs;
var config array<config DLCIDToOfferID> DLCIDsToOfferIDs;
var config array<config AdvDLCInfo> DLCInformations;
var array<int> InstalledDLCS;
var config array<config TreasureTypeAndIdToBitField> TreasureMapping;
var const transient float FlashlightRadiusScale;
var float MasterVolume;
var float MusicVolume;
var float EffectsVolume;
var float VoiceVolume;
var float Gamma;
var int Subtitles;
var float Sensitivity;
var int LookInversion;
var int Vibration;
var int ButtonLayout;
var int AimZoomToggle;
var int Crosshair;
var const array<PKInputBlockDefaults> InputBlockDefaults;
var transient array<PKInputBlockData> InputBlockDataList;
var transient array< delegate<OnInputBlockFinished> > InputBlockDelegates;
var config array<config LevelsRemap> NextLevelMap;
var config array<config AchievementIDToPlatformAchievementID> AchievementsRemap;
var PKInviteCache InviteCache[4];
var AdvEngine.EEngineState EngineState;
var array<string> AdvMapsArray;
var string AdvMapsString;
//var delegate<OnInputBlockFinished> __OnInputBlockFinished__Delegate;

delegate OnInputBlockFinished()
{
    //return;    
}

final function AddInputBlockFinishedDelegate(delegate<OnInputBlockFinished> InputBlockFinishedDelegate)
{
    // End:0x36
    if(InputBlockDelegates.Find(InputBlockFinishedDelegate) == )
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

static function OpenInputBlockingScene(AdvEngine.EPKInputBlockType BlockType, optional string TitleVarName = "", optional string DescVarName = "")
{
    local int Idx;
    local AdvUIManager Manager;
    local AdvEngine GEngine;
    local int NewIdx;

    Manager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    GEngine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x3D5
    if((Manager != none) && GEngine != none)
    {
        Idx = GEngine.InputBlockDataList.Find('InputBlockType', BlockType);        
        // End:0x385
        if(Idx == -1)
        {
            NewIdx = GEngine.InputBlockDataList.Length;
            GEngine.InputBlockDataList.Length = NewIdx + 1;
            GEngine.InputBlockDataList[NewIdx].InputBlockType = BlockType;
            GEngine.InputBlockDataList[NewIdx].TitleVariableName = ((TitleVarName == "") ? GEngine.InputBlockDefaults[int(BlockType)].TitleVariableName : TitleVarName);
            GEngine.InputBlockDataList[NewIdx].DescVariableName = ((DescVarName == "") ? GEngine.InputBlockDefaults[int(BlockType)].DescVariableName : DescVarName);
            // End:0x363
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
            J0x390:

            // End:0x3CB [Loop If]
            if(Idx < GEngine.InputBlockDataList.Length)
            {
                Idx++;
                // [Loop Continue]
                goto J0x390;
            }
            ScriptTrace();
        }
    }
    //return;    
}

static function CloseInputBlockingScene(AdvEngine.EPKInputBlockType BlockType)
{
    local int Idx;
    local AdvUIManager Manager;
    local AdvEngine GEngine;

    Manager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    GEngine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
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
    local AdvUIManager Manager;
    local AdvEngine GEngine;

    Manager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    GEngine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0xC5
    if((Manager != none) && GEngine != none)
    {
        GEngine.InputBlockDataList.Length = 0;
        Manager.CloseUpdatingScene();
    }
    //return;    
}

static function bool IsInputBlockingSceneInList(AdvEngine.EPKInputBlockType BlockType)
{
    local AdvEngine GEngine;

    GEngine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x7D
    if(GEngine != none)
    {
        return GEngine.InputBlockDataList.Find('InputBlockType', BlockType) != ;        
    }
    return false;
    //return ReturnValue;    
}

function UpdateInputBlockingScene()
{
    local int Idx, HighestPriorityIdx;
    local AdvUIManager Manager;

    Manager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
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
    local int I;
    local bool bCheckpoint;

    WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    bCheckpoint = int(PendingCheckpointAction) == int(1);
    bWasUsingGamepad = ((WorldInfo != none) ? WorldInfo.IsConsoleBuild() : false);
    bLoadFromInvite = false;
    // End:0x220
    if(!bCheckpoint)
    {
        I = 0;
        J0xA8:

        // End:0x21D [Loop If]
        if(I < LoadURL.Op.Length)
        {
            // End:0x119
            if(LoadURL.Op[I] ~= "bIsFromInvite")
            {
                bLoadFromInvite = true;
            }
            // End:0x19C
            if((Left(LoadURL.Op[I], 14) == "loadcheckpoint") && Right(LoadURL.Op[I], 2) != "=0")
            {
                bCheckpoint = true;                
            }
            else
            {
                // End:0x20F
                if(Left(LoadURL.Op[I], 7) == "gamepad")
                {
                    bWasUsingGamepad = Right(LoadURL.Op[I], 2) == "=1";
                }
            }
            ++I;
            // [Loop Continue]
            goto J0xA8;
        }        
    }
    else
    {
        FramesUntilIntroMayBeSkipped = 0;
    }
    //return;    
}

// Export UAdvEngine::execSteamActivateGameOverlayToStore(FFrame&, void* const)
native final function SteamActivateGameOverlayToStore(int AppID, int Flags);

// Export UAdvEngine::execSteamActivateGameOverlayToBuyFullGame(FFrame&, void* const)
native final function SteamActivateGameOverlayToBuyFullGame();

event PostLoadMap()
{
    local WorldInfo WorldInfo;
    local AdvPlayerController PC;
    local MaterialInterface MI;
    local array<Sequence> RS;
    local Sequence Seq;
    local array<SequenceObject> SeqObjs;

    WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x8F
    if(int(WorldInfo.NetMode) < int(NM_Client))
    {
        AdvGRI(WorldInfo.GRI).GetTotalStatisticsFromMapInfo();
    }
    // End:0x1EE
    if(bPastFirstLoad)
    {
        // End:0x1EB
        if(FramesUntilIntroMayBeSkipped == 0)
        {
            RS = WorldInfo.GetAllRootSequences();
            // End:0x1EA
            foreach RS(Seq)
            {
                Seq.FindSeqObjectsByClass(Class'SeqAct_StopLoadingMovie', true, SeqObjs);
                // End:0x1E9
                if(SeqObjs.Length < 1)
                {
                    Seq.FindSeqObjectsByClass(Class'GameFramework.SeqAct_ControlGameMovie', true, SeqObjs);
                    // End:0x1E9
                    if(SeqObjs.Length < 1)
                    {
                        // End:0x1E5
                        foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
                        {
                            // End:0x1E4
                            if(PC.IsLocalController())
                            {
                                PC.ClientStopLevelLoadingMovie();
                            }                            
                        }                        
                        // [Explicit Continue]
                        goto J0x1EA;
                    }
                }                
            }
            J0x1EA:
            
        }        
    }
    else
    {
        // End:0x231
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
    local LocalPlayer LP;

    SetMovieIsSkippable(true);
    RemoveAllOverlays();
    SkipText = Localize("MovieOverlay", "SkipMovie", "ADVGame");
    // End:0x5B
    if(bWasUsingGamepad)
    {        
    }
    else
    {
        AddOverlay(GetSubtitleFont(), ((Localize("GameMappedStrings", "GMS_LeftMouseButton", "ADVGame")) @ "-") @ SkipText, 0.0000000, 0.0000000, 1.0000000, 1.0000000, false);
    }
    // End:0x1DD
    foreach GamePlayers(LP)
    {
        // End:0x1DC
        if(((GetOnlineSubsystem() != none) && NotEqual_InterfaceInterface(GetOnlineSubsystem().SystemInterface, OnlineSystemInterface(none))) && !GetOnlineSubsystem().SystemInterface.IsControllerConnected(LP.ControllerId))
        {
            LP.Actor.OnControllerChanged(LP.ControllerId, false);
        }        
    }    
    //return;    
}

event NotifyLoadingFinished()
{
    local LocalPlayer LP;
    local WorldInfo WorldInfo;
    local AdvGameSP ADVGame;

    // End:0x10E
    foreach GamePlayers(LP)
    {
        // End:0x10D
        if(((GetOnlineSubsystem() != none) && NotEqual_InterfaceInterface(GetOnlineSubsystem().SystemInterface, OnlineSystemInterface(none))) && !GetOnlineSubsystem().SystemInterface.IsControllerConnected(LP.ControllerId))
        {
            LP.Actor.OnControllerChanged(LP.ControllerId, false);
        }        
    }    
    WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    ADVGame = AdvGameSP(WorldInfo.Game);
    // End:0x1B6
    if(ADVGame != none)
    {
        ADVGame.UnpauseAfterKeyPress();
        ADVGame.LoadingScreenFinished();
    }
    //return;    
}

function RestartGame()
{
    local AdvUIManager UIManager;
    local AdvFrontEnd Frontend;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0x8B
    if(UIManager != none)
    {
        UIManager.CloseAllUIMessageBoxes();
    }
    // End:0xB9
    if(Frontend != none)
    {
        Frontend.Close();
    }
    super.RestartGame();
    //return;    
}

function bool GetInviteCache(UniqueNetId UserId, out OnlineGameSearchResult retData)
{
    local int I;
    local UniqueNetId ZeroId;
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    I = 0;
    J0x34:

    // End:0x167 [Loop If]
    if(I < 4)
    {
        // End:0x159
        if(InviteCache[I].InviteSender != ZeroId && InviteCache[I].InviteSender == UserId)
        {
            retData = InviteCache[I].InviteData;
            InviteCache[I].InviteSender = ZeroId;
            OnlineSub.DumpGameSettings(retData.GameSettings);
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x34;
    }
    return false;
    //return ReturnValue;    
}

function SetInviteCache(UniqueNetId UserId, const out OnlineGameSearchResult InviteData)
{
    local int I;
    local UniqueNetId ZeroId;
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    I = 0;
    J0x34:

    // End:0x147 [Loop If]
    if(I < 4)
    {
        // End:0x139
        if(InviteCache[I].InviteSender == UserId)
        {
            InviteCache[I].InviteSender = UserId;
            InviteCache[I].InviteData = InviteData;
            OnlineSub.DumpGameSettings(InviteCache[I].InviteData.GameSettings);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x34;
    }
    I = 0;
    J0x152:

    // End:0x265 [Loop If]
    if(I < 4)
    {
        // End:0x257
        if(InviteCache[I].InviteSender == ZeroId)
        {
            InviteCache[I].InviteSender = UserId;
            InviteCache[I].InviteData = InviteData;
            OnlineSub.DumpGameSettings(InviteCache[I].InviteData.GameSettings);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x152;
    }
    //return;    
}

function SetCheckMapLoading(bool Flag)
{
    // End:0x8B
    if(Flag != bCheckMapLoadTime)
    {
        bCheckMapLoadTime = Flag;
        // End:0x8B
        if(bCheckMapLoadTime)
        {
            MapLoadStartTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
            LastTimeVal = 0.0000000;            
        }
    }
    //return;    
}

static simulated function AdvTypes.ELevelID ComputeNextLevelID(AdvTypes.ELevelID Current)
{
    local int Index;

    Index = default.NextLevelMap.Find('Current', Current);    
    return ((Index == -1) ? 0 : default.NextLevelMap[Index].Next);
    //return ReturnValue;    
}

static simulated function byte GetTrueAchievementIDForXBOX(byte AchievID)
{
    local int Index;

    Index = default.AchievementsRemap.Find('GameID', AchievID);    
    return ((Index == -1) ? 255 : default.AchievementsRemap[Index].XBoxID);
    //return ReturnValue;    
}

static simulated function byte GetTrueAchievementIDForPS3(byte AchievID)
{
    local int Index;

    Index = default.AchievementsRemap.Find('GameID', AchievID);    
    return ((Index == -1) ? 255 : default.AchievementsRemap[Index].PS3ID);
    //return ReturnValue;    
}

static simulated function CopyLevelsForDLCToArray(int DLCIndex, out array<AdvTypes.ELevelID> retArr)
{
    local int Index, J;

    retArr.Length = 0;
    Index = 0;
    J0x17:

    // End:0xFF [Loop If]
    if(Index < default.DLCInformations.Length)
    {
        // End:0xF1
        if(default.DLCInformations[Index].DLCIndex == DLCIndex)
        {
            J = 0;
            J0x6E:

            // End:0xEE [Loop If]
            if(J < default.DLCInformations[Index].LevelIDS.Length)
            {
                retArr.AddItem(default.DLCInformations[Index].LevelIDS[J]);                
                J++;
                // [Loop Continue]
                goto J0x6E;
            }
            // [Explicit Break]
            goto J0xFF;
        }
        Index++;
        // [Loop Continue]
        goto J0x17;
    }
    J0xFF:

    //return;    
}

function bool IsDLCContainsSinglePlayerMaps(int DLCID)
{
    local int _DLCId, I;

    I = 0;
    J0x0B:

    // End:0xA0 [Loop If]
    if(I < DLCInformations.Length)
    {
        _DLCId = DLCInformations[I].DLCIndex;
        // End:0x92
        if(_DLCId == DLCID)
        {
            return DLCInformations[I].bContainsSinglePlayerMaps;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return false;
    //return ReturnValue;    
}

function bool IsDLCInstalled(int DLCIndex)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x54 [Loop If]
    if(I < InstalledDLCS.Length)
    {
        // End:0x46
        if(InstalledDLCS[I] == DLCIndex)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return false;
    //return ReturnValue;    
}

function bool UserHasDLC(int DLCIndex, AdvPlayerController PC)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x7F [Loop If]
    if(I < DLCInformations.Length)
    {
        // End:0x71
        if((DLCInformations[I].DLCIndex == DLCIndex) && IsDLCInstalled(DLCIndex))
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    // End:0xB6
    if(int(PC.IsDLCInstalled(byte(DLCIndex))) == int(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function int GetXboxOfferIDForDLCID(int DLCID)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x8C [Loop If]
    if(I < DLCIDsToOfferIDs.Length)
    {
        // End:0x7E
        if(DLCID == DLCIDsToOfferIDs[I].DLCID)
        {
            return DLCIDsToOfferIDs[I].XBOXOfferID;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return 0;
    //return ReturnValue;    
}

function string GetPS3OfferIDForDLCID(int DLCID)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x8C [Loop If]
    if(I < DLCIDsToOfferIDs.Length)
    {
        // End:0x7E
        if(DLCID == DLCIDsToOfferIDs[I].DLCID)
        {
            return DLCIDsToOfferIDs[I].PS3OfferID;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return "";
    //return ReturnValue;    
}

static function AdvLocalPlayer GetLocalPlayerByIndex(int Index)
{
    local AdvEngine Eng;

    Eng = AdvEngine(GetEngine());
    // End:0x7C
    if(Eng.GamePlayers.Length > Index)
    {
        return AdvLocalPlayer(Eng.GamePlayers[Index]);
    }
    return none;
    //return ReturnValue;    
}

static simulated event SetEngineState(AdvEngine.EEngineState NewState)
{
    AdvEngine(Class'AdvEngine'.static.GetEngine()).EngineState = NewState;
    //return;    
}

static simulated event AdvEngine.EEngineState GetEngineState()
{
    return AdvEngine(Class'AdvEngine'.static.GetEngine()).EngineState;
    //return ReturnValue;    
}

// Export UAdvEngine::execGetPendinglevelURL(FFrame&, void* const)
native function URL GetPendinglevelURL();

// Export UAdvEngine::execIsPlayingLoadingMovie(FFrame&, void* const)
native function bool IsPlayingLoadingMovie();

// Export UAdvEngine::execSetGameRenderingEnabled(FFrame&, void* const)
native final function SetGameRenderingEnabled(bool bEnabled);

// Export UAdvEngine::execTUTest_GetTitleUpdateVersion(FFrame&, void* const)
native function string TUTest_GetTitleUpdateVersion();

// Export UAdvEngine::execStopFF(FFrame&, void* const)
native function StopFF();

function OnWriteSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
    local byte bIsValid;
    local array<byte> SaveData;
    local byte bIsLevelStart;
    local CheckpointTime CheckpointTimestamp;
    local EvilHeaderData HeaderData;
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    OnlineSub.ContentInterface.GetSaveGameData(LocalUserNum, DeviceID, FriendlyName, Filename, SaveFileName, bIsValid, SaveData);
    // End:0x28F
    if(bool(bIsValid) && SaveData.Length > 0)
    {
        // End:0x28F
        if(ParseCheckpointData(SaveData, SelectedSaveSlot, bIsLevelStart, CheckpointTimestamp, HeaderData))
        {
            SaveSlotData[SelectedSaveSlot].bContainsData = true;
            SaveSlotData[SelectedSaveSlot].bIsLevelStart = bool(bIsLevelStart);
            SaveSlotData[SelectedSaveSlot].SecondsSinceMidnight = CheckpointTimestamp.SecondsSinceMidnight;
            SaveSlotData[SelectedSaveSlot].Day = CheckpointTimestamp.Day;
            SaveSlotData[SelectedSaveSlot].Month = CheckpointTimestamp.Month;
            SaveSlotData[SelectedSaveSlot].Year = CheckpointTimestamp.Year;
            SaveSlotData[SelectedSaveSlot].HeaderData = HeaderData;
        }
    }
    super.OnWriteSaveGameDataComplete(bWasSuccessful, LocalUserNum, DeviceID, FriendlyName, Filename, SaveFileName);
    //return;    
}

function ClearCollectedTreasures()
{
    // End:0x43
    if(CurrentCheckpoint != none)
    {
        CurrentCheckpoint.HeaderData.UniqueCollectedTreasures.Length = 0;
    }
    SaveSlotData[SelectedSaveSlot].HeaderData.UniqueCollectedTreasures.Length = 0;
    //return;    
}

function ClearCollectedTreasuresFromLevel(AdvTypes.ELevelID LevelID)
{
    local int I, TreasureMappingIndex;
    local string TreasureID;

    I = 0;
    J0x0B:

    // End:0x7F [Loop If]
    if(I < TreasureMapping.Length)
    {
        // End:0x71
        if(int(LevelID) == int(TreasureMapping[I].LevelID))
        {
            TreasureMappingIndex = I;
            // [Explicit Break]
            goto J0x7F;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x7F:

    I = 0;
    J0x8A:

    // End:0x26A [Loop If]
    if(I < TreasureMapping[TreasureMappingIndex].TreasureID.Length)
    {
        TreasureID = TreasureMapping[TreasureMappingIndex].TreasureID[I];
        // End:0x18F
        if(SaveSlotData[SelectedSaveSlot].HeaderData.UniqueCollectedTreasures.Find(TreasureID) != )
        {            
            SaveSlotData[SelectedSaveSlot].HeaderData.UniqueCollectedTreasures.RemoveItem(TreasureID);            
        }
        // End:0x226
        if((CurrentCheckpoint != none) && CurrentCheckpoint.HeaderData.UniqueCollectedTreasures.Find(TreasureID) != )
        {            
            CurrentCheckpoint.HeaderData.UniqueCollectedTreasures.RemoveItem(TreasureID);            
        }
        // End:0x25C
        if(TemporaryCollectedTreasureIDs.Find(TreasureID) != )
        {            
            TemporaryCollectedTreasureIDs.RemoveItem(TreasureID);            
        }
        I++;
        // [Loop Continue]
        goto J0x8A;
    }
    //return;    
}

function SetCollectedTreasure(string TreasureID)
{
    // End:0x36
    if(TemporaryCollectedTreasureIDs.Find(TreasureID) == )
    {        
        TemporaryCollectedTreasureIDs.AddItem(TreasureID);        
    }
    //return;    
}

function int SetCollectedTreasureMap(AdvTypes.ELevelID inLevelID)
{
    // End:0xE1
    if(!SaveSlotData[SelectedSaveSlot].bIsCorrupted && SaveSlotData[SelectedSaveSlot].bContainsData)
    {
        SaveSlotData[SelectedSaveSlot].HeaderData.CollectedTreasuresMaps = SaveSlotData[SelectedSaveSlot].HeaderData.CollectedTreasuresMaps | (1 << (int(inLevelID) % int(32)));
    }
    // End:0x169
    if(CurrentCheckpoint != none)
    {
        CurrentCheckpoint.HeaderData.CollectedTreasuresMaps = CurrentCheckpoint.HeaderData.CollectedTreasuresMaps | (1 << (int(inLevelID) % int(32)));
    }
    return 0;
    //return ReturnValue;    
}

function int GetCollectetTreasuresMaps(int Slot)
{
    // End:0x92
    if(!SaveSlotData[Slot].bIsCorrupted && SaveSlotData[Slot].bContainsData)
    {
        return SaveSlotData[Slot].HeaderData.CollectedTreasuresMaps;
    }
    // End:0xD3
    if(CurrentCheckpoint != none)
    {
        return CurrentCheckpoint.HeaderData.CollectedTreasuresMaps;
    }
    return 0;
    //return ReturnValue;    
}

function bool IsTreasureCollected(string TreasureID)
{
    // End:0xC8
    if(!SaveSlotData[SelectedSaveSlot].bIsCorrupted && SaveSlotData[SelectedSaveSlot].bContainsData)
    {
        return (SaveSlotData[SelectedSaveSlot].HeaderData.UniqueCollectedTreasures.Find(TreasureID) != ) || ;
        TemporaryCollectedTreasureIDs.Find(TreasureID) != ;                
    }
    // End:0x13F
    if(CurrentCheckpoint != none)
    {
        return (CurrentCheckpoint.HeaderData.UniqueCollectedTreasures.Find(TreasureID) != ) || ;
        TemporaryCollectedTreasureIDs.Find(TreasureID) != ;                
    }
    return false;
    //return ReturnValue;    
}

function RestoreTreasuresAndUpgradesInfoFromInitialLevelData()
{
    // End:0x1FE
    if(CurrentCheckpoint != none)
    {
        CurrentCheckpoint.HeaderData.TreasuresCollectedInfoA = CurrentCheckpoint.HeaderData.LevelInitialTreasuresCollectedInfoA;
        CurrentCheckpoint.HeaderData.TreasuresCollectedInfoB = CurrentCheckpoint.HeaderData.LevelInitialTreasuresCollectedInfoB;
        CurrentCheckpoint.HeaderData.UpgradesInfoA = CurrentCheckpoint.HeaderData.LevelInitialUpgradesInfoA;
        CurrentCheckpoint.HeaderData.UpgradesInfoB = CurrentCheckpoint.HeaderData.LevelInitialUpgradesInfoB;
        CurrentCheckpoint.HeaderData.UniqueCollectedTreasures = CurrentCheckpoint.HeaderData.LevelInitialUniqueCollectedTreasures;
    }
    SaveSlotData[SelectedSaveSlot].HeaderData.TreasuresCollectedInfoA = SaveSlotData[SelectedSaveSlot].HeaderData.LevelInitialTreasuresCollectedInfoA;
    SaveSlotData[SelectedSaveSlot].HeaderData.TreasuresCollectedInfoB = SaveSlotData[SelectedSaveSlot].HeaderData.LevelInitialTreasuresCollectedInfoB;
    SaveSlotData[SelectedSaveSlot].HeaderData.UpgradesInfoA = SaveSlotData[SelectedSaveSlot].HeaderData.LevelInitialUpgradesInfoA;
    SaveSlotData[SelectedSaveSlot].HeaderData.UpgradesInfoB = SaveSlotData[SelectedSaveSlot].HeaderData.LevelInitialUpgradesInfoB;
    SaveSlotData[SelectedSaveSlot].HeaderData.UniqueCollectedTreasures = SaveSlotData[SelectedSaveSlot].HeaderData.LevelInitialUniqueCollectedTreasures;
    TemporaryCollectedTreasureIDs.Length = 0;
    //return;    
}

function ClearTemporaryCheckpointData()
{
    TemporaryCollectedTreasureIDs.Length = 0;
    //return;    
}

exec function DebugSetCollectedTreasure(string TreasureID)
{
    SetCollectedTreasure(TreasureID);
    //return;    
}

function ClearSavedSlotData(int Slot)
{
    SaveSlotData[Slot].bContainsData = false;
    SaveSlotData[Slot].bIsCorrupted = false;
    SaveSlotData[Slot].Day = 0;
    SaveSlotData[Slot].Year = 0;
    SaveSlotData[Slot].Month = 0;
    SaveSlotData[Slot].SecondsSinceMidnight = 0;
    Class'EvilGame.Checkpoint'.static.StaticInvalidateCheckpointData(SaveSlotData[Slot].HeaderData);
    //return;    
}

function SetAllowSaveFirstCheckpoint(bool InState)
{
    bAllowSaveFirstCheckpoint = InState;
    //return;    
}

function bool GetAllowSaveFirstCheckpoint()
{
    return bAllowSaveFirstCheckpoint;
    //return ReturnValue;    
}

function FillTemporarySettingsFromProfile()
{
    local AdvPlayerController PC;
    local AdvLocalPlayer LP;

    LP = AdvLocalPlayer(GamePlayers[0]);
    PC = AdvPlayerController(LP.Actor);
    // End:0x3C2
    if((PC != none) && PC.ProfileSettings != none)
    {
        MasterVolume = PC.ProfileSettings.GetMasterVolume(true);
        MusicVolume = PC.ProfileSettings.GetMusicVolume(true);
        EffectsVolume = PC.ProfileSettings.GetSFXVolume(true);
        VoiceVolume = PC.ProfileSettings.GetVoiceVolume(true);
        Gamma = PC.ProfileSettings.GetGamma(true);
        Subtitles = int(PC.ProfileSettings.GetShowSubtitles(true));
        Sensitivity = PC.ProfileSettings.GetSensitivity(true);
        LookInversion = int(PC.ProfileSettings.GetInvertY(true));
        Vibration = int(PC.ProfileSettings.GetControllerVibrationOption(true));
        AimZoomToggle = int(PC.ProfileSettings.GetAimZoomToggle(true));
        ButtonLayout = int(PC.ProfileSettings.GetStickConfigOption(true));
        Crosshair = PC.ProfileSettings.GetCrosshairType(true);
        bShowTutorialMessages = PC.ProfileSettings.GetShowTutorials(true);
    }
    //return;    
}

static function int ConvertLidEnumToDLCIndex(AdvTypes.ELevelID LevelID)
{
    local int Result;
    local string estr;
    local array<string> Indices;

    Result = -1;
    estr = string(GetEnum(Enum'AdvTypes.ELevelID', int(LevelID)));
    Indices = SplitString(estr, "_");
    // End:0x9A
    if(Indices.Length == 3)
    {
        estr = Mid(Indices[1], 3);
        Result = int(estr);
    }
    return Result;
    //return ReturnValue;    
}

function SetShowTutorials(bool bShow)
{
    bShowTutorialMessages = bShow;
    //return;    
}

function bool IsTutorialsVisible()
{
    return bShowTutorialMessages;
    //return ReturnValue;    
}

event bool CheckIfEngineShouldBreakMapLoading(URL LoadURL, string ChapterId, PendingLevel Pending, out string RetTitle, out string RetError)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GamePlayers[0].Actor);
    // End:0xB8
    if((((PC != none) && PC.IsFreeWeekendSubscribed()) && int(ChapterId) > 5) && int(ChapterId) <= 17)
    {
        RetError = "Empty";
        RetTitle = "FreeWeekend";
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    bShowTutorialMessages=true
    MaxLoadTime=40.0000000
    DLCIDsToOfferIDs[0]=(DLCID=1,XBOXOfferID=-233002496,PS3OfferID="")
    DLCIDsToOfferIDs[1]=(DLCID=2,XBOXOfferID=192266240,PS3OfferID="")
    DLCIDsToOfferIDs[2]=(DLCID=3,XBOXOfferID=297819136,PS3OfferID="")
    DLCIDsToOfferIDs[3]=(DLCID=4,XBOXOfferID=-1415896576,PS3OfferID="")
    DLCIDsToOfferIDs[4]=(DLCID=5,XBOXOfferID=-839134720,PS3OfferID="")
    DLCIDsToOfferIDs[5]=(DLCID=6,XBOXOfferID=-58887680,PS3OfferID="")
    DLCIDsToOfferIDs[6]=(DLCID=7,XBOXOfferID=-1529266688,PS3OfferID="")
    DLCIDsToOfferIDs[7]=(DLCID=8,XBOXOfferID=-1425368064,PS3OfferID="")
    DLCIDsToOfferIDs[8]=(DLCID=9,XBOXOfferID=796473856,PS3OfferID="")
    DLCIDsToOfferIDs[9]=(DLCID=10,XBOXOfferID=314340864,PS3OfferID="")
    TreasureMapping[0]=(LevelID=ELevelID.LID_SaharaOutdoor,TreasureID=TreasureID[0]="SO_LIF_01"
    TreasureID[1]="SO_LIF_02"
    TreasureID[2]="SO_LIF_03"
    TreasureID[3]="SO_LIF_04"
    TreasureID[4]="SO_LIF_05")
    TreasureMapping[1]=(LevelID=ELevelID.LID_SaharaIndoor,TreasureID=TreasureID[0]="SI_WAR_02"
    TreasureID[1]="SI_LIF_03"
    TreasureID[2]="SI_LIF_01"
    TreasureID[3]="SI_LIF_04"
    TreasureID[4]="SI_WAR_05"
    TreasureID[5]="SI_LIG_06"
    TreasureID[6]="SI_LIG_07"
    TreasureID[7]="SI_LIF_08"
    TreasureID[8]="SI_LIF_09"
    TreasureID[9]="SI_LIG_10"
    TreasureID[10]="SI_WAR_11"
    TreasureID[11]="SI_WAR_12"
    TreasureID[12]="SI_WAR_13"
    TreasureID[13]="SI_LIG_14")
    TreasureMapping[2]=(LevelID=ELevelID.LID_ArcticBase,TreasureID=TreasureID[0]="AB1_LIF_01"
    TreasureID[1]="AB1_WAR_02"
    TreasureID[2]="AB1_LIF_02"
    TreasureID[3]="AB1_WAR_01"
    TreasureID[4]="AB1_LIG_02"
    TreasureID[5]="AB1_LIG_01")
    TreasureMapping[3]=(LevelID=ELevelID.LID_ArcticBase2,TreasureID=TreasureID[0]="AB2_LIG_01"
    TreasureID[1]="AB2_LIF_02"
    TreasureID[2]="AB2_LIG_02"
    TreasureID[3]="AB2_WAR_03"
    TreasureID[4]="AB2_LIG_03"
    TreasureID[5]="AB2_WAR_02"
    TreasureID[6]="AB2_LIF_03"
    TreasureID[7]="AB2_WAR_01"
    TreasureID[8]="AB2_LIF_01")
    TreasureMapping[4]=(LevelID=ELevelID.LID_ArcticTemple,TreasureID=TreasureID[0]="AT_LIF_01"
    TreasureID[1]="AT_LIG_01"
    TreasureID[2]="AT_WAR_01"
    TreasureID[3]="AT_LIG_02"
    TreasureID[4]="AT_LIF_02"
    TreasureID[5]="AT_WAR_02"
    TreasureID[6]="AT_WAR_03"
    TreasureID[7]="AT_LIG_03"
    TreasureID[8]="AT_LIF_03"
    TreasureID[9]="AT_WAR_04"
    TreasureID[10]="AT_LIF_04"
    TreasureID[11]="AT_LIG_04"
    TreasureID[12]="AT_WAR_05"
    TreasureID[13]="AT_LIF_05")
    TreasureMapping[5]=(LevelID=ELevelID.LID_PetraMines,TreasureID=TreasureID[0]="AM_WAR_02"
    TreasureID[1]="AM_LIF_03"
    TreasureID[2]="AM_LIF_02"
    TreasureID[3]="AM_LIG_03"
    TreasureID[4]="AM_WAR_01"
    TreasureID[5]="AM_LIG_02"
    TreasureID[6]="AM_LIG_01"
    TreasureID[7]="AM_LIF_01")
    TreasureMapping[6]=(LevelID=ELevelID.LID_MayanJungle,TreasureID=TreasureID[0]="MJ_WAR_01"
    TreasureID[1]="MJ_LIG_01"
    TreasureID[2]="MJ_LIF_01"
    TreasureID[3]="MJ_WAR_02"
    TreasureID[4]="MJ_LIG_02"
    TreasureID[5]="MJ_WAR_03"
    TreasureID[6]="MJ_LIF_02"
    TreasureID[7]="MJ_LIG_03"
    TreasureID[8]="MJ_LIF_03"
    TreasureID[9]="MJ_WAR_04"
    TreasureID[10]="MJ_WAR_05"
    TreasureID[11]="MJ_LIF_04"
    TreasureID[12]="MJ_LIG_04")
    TreasureMapping[7]=(LevelID=ELevelID.LID_MayanUnderground,TreasureID=TreasureID[0]="MU_WAR_02"
    TreasureID[1]="MU_WAR_04"
    TreasureID[2]="MU_LIF_02"
    TreasureID[3]="MU_WAR_03"
    TreasureID[4]="MU_WAR_01"
    TreasureID[5]="MU_LIF_01"
    TreasureID[6]="MU_LIF_03"
    TreasureID[7]="MU_LIG_01"
    TreasureID[8]="MU_LIG_02"
    TreasureID[9]="MU_LIG_03"
    TreasureID[10]="MU_LIG_04"
    TreasureID[11]="MU_LIG_05"
    TreasureID[12]="MU_LIG_06"
    TreasureID[13]="MU_LIF_04")
    TreasureMapping[8]=(LevelID=ELevelID.LID_MayanCity,TreasureID=TreasureID[0]="MC_LIF_05"
    TreasureID[1]="MC_LIF_04"
    TreasureID[2]="MC_LIG_04"
    TreasureID[3]="MC_LIG_05"
    TreasureID[4]="MC_LIF_03"
    TreasureID[5]="MC_WAR_04"
    TreasureID[6]="MC_WAR_05"
    TreasureID[7]="MC_WAR_02"
    TreasureID[8]="MC_WAR_03"
    TreasureID[9]="MC_WAR_06"
    TreasureID[10]="MC_LIG_03"
    TreasureID[11]="MC_WAR_01"
    TreasureID[12]="MC_LIG_02"
    TreasureID[13]="MC_LIF_01"
    TreasureID[14]="MC_LIF_02"
    TreasureID[15]="MC_LIG_01")
    TreasureMapping[9]=(LevelID=ELevelID.LID_MayanTemple,TreasureID=TreasureID[0]="MT_LIF_03"
    TreasureID[1]="MT_LIG_03"
    TreasureID[2]="MT_WAR_03"
    TreasureID[3]="MT_LIF_02"
    TreasureID[4]="MT_LIG_02"
    TreasureID[5]="MT_WAR_02"
    TreasureID[6]="MT_LIF_01"
    TreasureID[7]="MT_WAR_01"
    TreasureID[8]="MT_LIG_01")
    TreasureMapping[10]=(LevelID=ELevelID.LID_Xibalba,TreasureID=TreasureID[0]="X_WAR_01"
    TreasureID[1]="X_LIG_04"
    TreasureID[2]="X_LIF_01"
    TreasureID[3]="X_LIG_03"
    TreasureID[4]="X_WAR_03"
    TreasureID[5]="X_WAR_02"
    TreasureID[6]="X_LIG_01"
    TreasureID[7]="X_LIF_04"
    TreasureID[8]="X_LIF_05")
    MasterVolume=0.8000000
    MusicVolume=0.6000000
    EffectsVolume=0.8000000
    VoiceVolume=0.8500000
    Gamma=0.6000000
    Subtitles=1
    Sensitivity=1.0000000
    Vibration=3
    AimZoomToggle=1
    InputBlockDefaults[0]=(Priority=90,TitleVariableName="CreatePartyDesc",DescVariableName="CreatePartyDesc")
    InputBlockDefaults[1]=(Priority=100,TitleVariableName="CancelMatchmakingDesc",DescVariableName="")
    InputBlockDefaults[2]=(Priority=100,TitleVariableName="MatchmakingDesc",DescVariableName="")
    InputBlockDefaults[3]=(Priority=90,TitleVariableName="UpdatePartyDesc",DescVariableName="")
    InputBlockDefaults[4]=(Priority=90,TitleVariableName="DestroyPartyDesc",DescVariableName="")
    InputBlockDefaults[5]=(Priority=90,TitleVariableName="MainMenuReturnDesc",DescVariableName="MainMenuReturnDesc")
    InputBlockDefaults[6]=(Priority=90,TitleVariableName="DestroyPartyForLIVEDesc",DescVariableName="")
    InputBlockDefaults[7]=(Priority=10,TitleVariableName="PlaylistDownloadDesc",DescVariableName="PlaylistDownloadDesc")
    InputBlockDefaults[8]=(Priority=0,TitleVariableName="PlayPopDownloadDesc",DescVariableName="")
    InputBlockDefaults[9]=(Priority=20,TitleVariableName="DLCDownloadDesc",DescVariableName="DLCDownloadDesc")
    InputBlockDefaults[10]=(Priority=100,TitleVariableName="ProfileReadDesc",DescVariableName="ProfileReadDesc")
    InputBlockDefaults[11]=(Priority=100,TitleVariableName="ProfileSaveDesc",DescVariableName="")
    InputBlockDefaults[12]=(Priority=100,TitleVariableName="StatsReadDesc",DescVariableName="")
    InputBlockDefaults[13]=(Priority=100,TitleVariableName="LANGameSearchDesc",DescVariableName="")
    InputBlockDefaults[14]=(Priority=100,TitleVariableName="BetaUnlocksDesc",DescVariableName="")
    InputBlockDefaults[15]=(Priority=100,TitleVariableName="SaveGameReadDesc",DescVariableName="")
    NextLevelMap[0]=(Current=ELevelID.LID_Invalid,Next=ELevelID.LID_Invalid,PADA=0,PADB=0)
    NextLevelMap[1]=(Current=ELevelID.LID_SaharaIntro,Next=ELevelID.LID_ArabicRoom,PADA=0,PADB=0)
    NextLevelMap[2]=(Current=ELevelID.LID_ArabicRoom,Next=ELevelID.LID_SaharaOutdoor,PADA=0,PADB=0)
    NextLevelMap[3]=(Current=ELevelID.LID_SaharaOutdoor,Next=ELevelID.LID_SaharaIndoor,PADA=0,PADB=0)
    NextLevelMap[4]=(Current=ELevelID.LID_SaharaIndoor,Next=ELevelID.LID_SanFrancisco,PADA=0,PADB=0)
    NextLevelMap[5]=(Current=ELevelID.LID_SanFrancisco,Next=ELevelID.LID_ArcticBase,PADA=0,PADB=0)
    NextLevelMap[6]=(Current=ELevelID.LID_ArcticBase,Next=ELevelID.LID_ArcticBase2,PADA=0,PADB=0)
    NextLevelMap[7]=(Current=ELevelID.LID_ArcticBase2,Next=ELevelID.LID_ArcticTemple,PADA=0,PADB=0)
    NextLevelMap[8]=(Current=ELevelID.LID_ArcticTemple,Next=ELevelID.LID_PetraMines,PADA=0,PADB=0)
    NextLevelMap[9]=(Current=ELevelID.LID_PetraMines,Next=ELevelID.LID_MayanJungleIntro,PADA=0,PADB=0)
    NextLevelMap[10]=(Current=ELevelID.LID_MayanJungleIntro,Next=ELevelID.LID_MayanJungle,PADA=0,PADB=0)
    NextLevelMap[11]=(Current=ELevelID.LID_MayanJungle,Next=ELevelID.LID_MayanUnderground,PADA=0,PADB=0)
    NextLevelMap[12]=(Current=ELevelID.LID_MayanUnderground,Next=ELevelID.LID_MayanCity,PADA=0,PADB=0)
    NextLevelMap[13]=(Current=ELevelID.LID_MayanCity,Next=ELevelID.LID_MayanTemple,PADA=0,PADB=0)
    NextLevelMap[14]=(Current=ELevelID.LID_MayanTemple,Next=ELevelID.LID_Xibalba,PADA=0,PADB=0)
    NextLevelMap[15]=(Current=ELevelID.LID_Xibalba,Next=ELevelID.LID_SanFrancisco2,PADA=0,PADB=0)
    NextLevelMap[16]=(Current=ELevelID.LID_SanFrancisco2,Next=ELevelID.LID_ArabicRoom2,PADA=0,PADB=0)
    NextLevelMap[17]=(Current=ELevelID.LID_ArabicRoom2,Next=ELevelID.LID_Invalid,PADA=0,PADB=0)
    AchievementsRemap[0]=(GameID=EPKGameAchievements.EADVA_Invalid,XBoxID=255,PS3ID=0,PADA=0)
    AchievementsRemap[1]=(GameID=EPKGameAchievements.EADVA_FINISH_CAMPAIGN,XBoxID=1,PS3ID=0,PADA=0)
    AchievementsRemap[2]=(GameID=EPKGameAchievements.EADVA_SAHARAOUTDOOR_FIND_ENTRANCE_TO_PYRAMID,XBoxID=2,PS3ID=0,PADA=0)
    AchievementsRemap[3]=(GameID=EPKGameAchievements.EADVA_SAHARAINDOOR_FINISHLEVEL,XBoxID=3,PS3ID=0,PADA=0)
    AchievementsRemap[4]=(GameID=EPKGameAchievements.EADVA_ARCTICBASE_FINISHLEVEL,XBoxID=4,PS3ID=0,PADA=0)
    AchievementsRemap[5]=(GameID=EPKGameAchievements.EADVA_ARCTICBASE2_FINISHLEVEL,XBoxID=5,PS3ID=0,PADA=0)
    AchievementsRemap[6]=(GameID=EPKGameAchievements.EADVA_ARCTICTEMPLE_FINISHLEVEL,XBoxID=6,PS3ID=0,PADA=0)
    AchievementsRemap[7]=(GameID=EPKGameAchievements.EADVA_ARCTICMINES_FINISHLEVEL,XBoxID=7,PS3ID=0,PADA=0)
    AchievementsRemap[8]=(GameID=EPKGameAchievements.EADVA_MAYANJUNGLE_FINISHLEVEL,XBoxID=8,PS3ID=0,PADA=0)
    AchievementsRemap[9]=(GameID=EPKGameAchievements.EADVA_MAYANUNDERGROUND_FINISHLEVEL,XBoxID=9,PS3ID=0,PADA=0)
    AchievementsRemap[10]=(GameID=EPKGameAchievements.EADVA_MAYANCITY_FINISHLEVEL,XBoxID=10,PS3ID=0,PADA=0)
    AchievementsRemap[11]=(GameID=EPKGameAchievements.EADVA_XIXALBA_BEAT_GUARDIAN,XBoxID=11,PS3ID=0,PADA=0)
    AchievementsRemap[12]=(GameID=EPKGameAchievements.EADVA_XIBALBA_KILL_HAGEN,XBoxID=12,PS3ID=0,PADA=0)
    AchievementsRemap[13]=(GameID=EPKGameAchievements.EADVA_COLLECT_5_POWER_OF_LIGHT,XBoxID=13,PS3ID=0,PADA=0)
    AchievementsRemap[14]=(GameID=EPKGameAchievements.EADVA_COLLECT_10_POWER_OF_LIFE,XBoxID=14,PS3ID=0,PADA=0)
    AchievementsRemap[15]=(GameID=EPKGameAchievements.EADVA_COLLECT_15_POWER_OF_WARRIOR,XBoxID=15,PS3ID=0,PADA=0)
    AchievementsRemap[16]=(GameID=EPKGameAchievements.EADVA_COLLECT_50_TREASURES,XBoxID=16,PS3ID=0,PADA=0)
    AchievementsRemap[17]=(GameID=EPKGameAchievements.EADVA_KILL_50_ENEMIES_USING_TRAPS,XBoxID=255,PS3ID=0,PADA=0)
    AchievementsRemap[18]=(GameID=EPKGameAchievements.EADVA_KILL_100_MUMMIES,XBoxID=255,PS3ID=0,PADA=0)
    AchievementsRemap[19]=(GameID=EPKGameAchievements.EADVA_COLLECT_7_TREASURE_MAPS,XBoxID=255,PS3ID=0,PADA=0)
    AchievementsRemap[20]=(GameID=EPKGameAchievements.EADVA_KILL_25_ENEMIES_USING_DYNAMITE,XBoxID=255,PS3ID=0,PADA=0)
    AchievementsRemap[21]=(GameID=EPKGameAchievements.EADVA_SAHARAOUTDOOR_FIND_FIRST_SECRET,XBoxID=21,PS3ID=0,PADA=0)
    AchievementsRemap[22]=(GameID=EPKGameAchievements.EADVA_SAHARAINDOOR_ESCAPE_FROM_GAS_TRAP,XBoxID=22,PS3ID=0,PADA=0)
    AchievementsRemap[23]=(GameID=EPKGameAchievements.EADVA_ARCTICBASE_DISABLE_CRUSHING_TRAP,XBoxID=23,PS3ID=0,PADA=0)
    AchievementsRemap[24]=(GameID=EPKGameAchievements.EADVA_ARCTICBASE2_SOLVE_FINAL_PUZZLE_COLLECT_SPECIAL_TREASURE,XBoxID=24,PS3ID=0,PADA=0)
    AchievementsRemap[25]=(GameID=EPKGameAchievements.EADVA_ARCTICMINES_SOLVE_CARTS_PUZZLE,XBoxID=25,PS3ID=0,PADA=0)
    AchievementsRemap[26]=(GameID=EPKGameAchievements.EADVA_MAYANJUNGLE_EXPLORE_SECRET_CAVE,XBoxID=26,PS3ID=0,PADA=0)
    AchievementsRemap[27]=(GameID=EPKGameAchievements.EADVA_MAYANUNDERGROUND_SOLVE_ELEVATOR_PUZZLE,XBoxID=27,PS3ID=0,PADA=0)
    AchievementsRemap[28]=(GameID=EPKGameAchievements.EADVA_MAYANCITY_DRAG_TREASURE_FROM_MUMMY_HAND,XBoxID=28,PS3ID=0,PADA=0)
    AchievementsRemap[29]=(GameID=EPKGameAchievements.EADVA_MAYANTEMPLE_OPEN_LOCKER_WITH_TREASURE,XBoxID=29,PS3ID=0,PADA=0)
    AchievementsRemap[30]=(GameID=EPKGameAchievements.EADVA_XIBALBA_ESCAPE_FROM_CRUSHER_TRAP,XBoxID=30,PS3ID=0,PADA=0)
    AchievementsRemap[31]=(GameID=EPKGameAchievements.EADVA_ARCTIC_TEMPLE_SOLVE_SLIDING_PUZZLE,XBoxID=31,PS3ID=0,PADA=0)
    AchievementsRemap[32]=(GameID=EPKGameAchievements.EADVA_MP_FIRST_KILL,XBoxID=32,PS3ID=0,PADA=0)
    AchievementsRemap[33]=(GameID=EPKGameAchievements.EADVA_MP_ACHIEVE_BEST_SCORE,XBoxID=33,PS3ID=0,PADA=0)
    AchievementsRemap[34]=(GameID=EPKGameAchievements.EADVA_MP_ACHIEVE_BEST_KD,XBoxID=34,PS3ID=0,PADA=0)
    AchievementsRemap[35]=(GameID=EPKGameAchievements.EADVA_MP_FINISH_MATCH_WITHOUT_DYING,XBoxID=35,PS3ID=0,PADA=0)
    AchievementsRemap[36]=(GameID=EPKGameAchievements.EADVA_MPTH_COLLECT_100_GOLD_STATUES,XBoxID=36,PS3ID=0,PADA=0)
    AchievementsRemap[37]=(GameID=EPKGameAchievements.EADVA_MPTH_COLLECT_50_SILVER_STATUES,XBoxID=37,PS3ID=0,PADA=0)
    AchievementsRemap[38]=(GameID=EPKGameAchievements.EADVA_MP_KILL_100_PLAYER_USING_TRAPS,XBoxID=38,PS3ID=0,PADA=0)
    AchievementsRemap[39]=(GameID=EPKGameAchievements.EADVA_MP_UNLOCK_ALL_WEAPONS,XBoxID=39,PS3ID=0,PADA=0)
    AchievementsRemap[40]=(GameID=EPKGameAchievements.EADVA_MP_UNLOCK_ALL_CHARACTERS,XBoxID=40,PS3ID=0,PADA=0)
    AchievementsRemap[41]=(GameID=EPKGameAchievements.EADVA_MPTH_EARN_200_BLESSINGS,XBoxID=41,PS3ID=0,PADA=0)
    AchievementsRemap[42]=(GameID=EPKGameAchievements.EADVA_MP_OBTAIN_ALL_KILLING_SPREES,XBoxID=42,PS3ID=0,PADA=0)
    AchievementsRemap[43]=(GameID=EPKGameAchievements.EADVA_MP_UNLOCK_ALL_AUTOMATIC_UPGRADES,XBoxID=43,PS3ID=0,PADA=0)
    AchievementsRemap[44]=(GameID=EPKGameAchievements.EADVA_MP_ACHIEVE_HIGHEST_MULTIPLAYER_RANK,XBoxID=44,PS3ID=0,PADA=0)
    AchievementsRemap[45]=(GameID=EPKGameAchievements.EADVA_MPLMS_WIN_10_MATCHES,XBoxID=45,PS3ID=0,PADA=0)
    AchievementsRemap[46]=(GameID=EPKGameAchievements.EADVA_MPDM_KILL_ALL_OPPONENTS,XBoxID=46,PS3ID=0,PADA=0)
    AchievementsRemap[47]=(GameID=EPKGameAchievements.EADVA_MP_FINISH_MATCH_USING_CUSTOM_CLASS,XBoxID=47,PS3ID=0,PADA=0)
    AchievementsRemap[48]=(GameID=EPKGameAchievements.EADVA_MPSV_SURVIVE_100_WAVES,XBoxID=48,PS3ID=0,PADA=0)
    AchievementsRemap[49]=(GameID=EPKGameAchievements.EADVA_MPSV_Kill_3_ENEMIES_BY_FIRE_TRAP,XBoxID=49,PS3ID=0,PADA=0)
    AchievementsRemap[50]=(GameID=EPKGameAchievements.EADVA_MPSV_KILL_500_TREETERS,XBoxID=50,PS3ID=0,PADA=0)
    CheckpointClass=Class'AdvCheckpoint'
}