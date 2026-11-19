class PandoraCheckpointManager extends Actor
    native
    config(Game)
    notplaceable;

struct native CheckpointPreloadData
{
    var init string PersistentLevelName;
    var init string CheckpointName;
    var init string CheckpointPackageName;
    var init string CheckpointMapName;

    structdefaultproperties
    {
        PersistentLevelName=""
        CheckpointName=""
        CheckpointPackageName=""
        CheckpointMapName=""
    }
};

struct native myCheckpoint
{
    var array<byte> CheckpointData;
    var string Filename;

    structdefaultproperties
    {
        CheckpointData=none
        Filename=""
    }
};

var config string MainCheckpointDir;
var config string DebugCheckpointDir;
var bool bLoadingCheckpoint;
var PandoraCheckpoint CurrCheckpoint;
var int IgnorePostLoadCPLEventCount;
var array<byte> CheckpointData;
var private int CheckpointVersion;
var private const localized string SaveGameFriendlyName;
var array<myCheckpoint> CheckpointsToSave;

// Export UPandoraCheckpointManager::execGenerateCheckpointData(FFrame&, void* const)
native function bool GenerateCheckpointData();

// Export UPandoraCheckpointManager::execSaveCheckpointData(FFrame&, void* const)
native function bool SaveCheckpointData(optional string OverrideFilename, optional array<byte> myCheckpointData);

// Export UPandoraCheckpointManager::execProcessPlayerLoadout(FFrame&, void* const)
native function bool ProcessPlayerLoadout(array<byte> LoadOutData);

// Export UPandoraCheckpointManager::execLoadCheckpointData(FFrame&, void* const)
native function bool LoadCheckpointData(optional string OverrideFilename);

// Export UPandoraCheckpointManager::execLoadCheckpointDataExplicit(FFrame&, void* const)
native function bool LoadCheckpointDataExplicit(string Filename);

// Export UPandoraCheckpointManager::execDelayedLoadCheckpoint(FFrame&, void* const)
native function DelayedLoadCheckpoint(PandoraPlayerController Caller, optional bool bLoadFromMainMenu = false);

// Export UPandoraCheckpointManager::execHasCheckpoint(FFrame&, void* const)
native function bool HasCheckpoint();

// Export UPandoraCheckpointManager::execToggleCheckpointMethod(FFrame&, void* const)
native function ToggleCheckpointMethod();

// Export UPandoraCheckpointManager::execIsCheckpointInCurrentPMap(FFrame&, void* const)
native function bool IsCheckpointInCurrentPMap();

// Export UPandoraCheckpointManager::execGetLinearOrderFromChapterNumber(FFrame&, void* const)
native static final function int GetLinearOrderFromChapterNumber(int ChapterNumber, bool bUseZeroBasedChapterNumber);

// Export UPandoraCheckpointManager::execGetChapterNumberFromLinearOrder(FFrame&, void* const)
native static final function int GetChapterNumberFromLinearOrder(int LinearOrderNumber, bool bUseZeroBasedChapterNumber);

// Export UPandoraCheckpointManager::execGetCheckpointPreloadDataFromFile(FFrame&, void* const)
native static final function bool GetCheckpointPreloadDataFromFile(string Filename, out CheckpointPreloadData PreloadData);

// Export UPandoraCheckpointManager::execLoadMapAndCheckpoint(FFrame&, void* const)
native static final function bool LoadMapAndCheckpoint(string MapName, string CheckpointFilename);

// Export UPandoraCheckpointManager::execLoadCheckpointWithMap(FFrame&, void* const)
native static final function bool LoadCheckpointWithMap(string Filename);

// Export UPandoraCheckpointManager::execGetMainCheckpointDir(FFrame&, void* const)
native static function string GetMainCheckpointDir();

// Export UPandoraCheckpointManager::execGetDebugCheckpointDir(FFrame&, void* const)
native static function string GetDebugCheckpointDir();

// Export UPandoraCheckpointManager::execGetBaseCheckpointFilename(FFrame&, void* const)
native function string GetBaseCheckpointFilename();

// Export UPandoraCheckpointManager::execMEMDEBUG_StreamNextChapter(FFrame&, void* const)
native function bool MEMDEBUG_StreamNextChapter();

// Export UPandoraCheckpointManager::execInitCheckpointManager(FFrame&, void* const)
native function InitCheckpointManager();

// Export UPandoraCheckpointManager::execSavedGameExists(FFrame&, void* const)
native function SavedGameExists(out int IsDone, out int DoseExist, out int bDamaged);

// Export UPandoraCheckpointManager::execSavedGameFileExists(FFrame&, void* const)
native function SavedGameFileExists(int InPlayerID, string InFilename, out int IsDone, out int DoseExist, out int bDamaged);

// Export UPandoraCheckpointManager::execCheckDeviceSpace(FFrame&, void* const)
native function CheckDeviceSpace(int DeviceID, int RequiredSpace, out int bHasSpace);

function PostBeginPlay()
{
    InitCheckpointManager();
    //return;    
}

function SetNewCheckpoint(PandoraCheckpoint NewCheckpoint, optional bool bSkipSavingToDevice)
{
    CurrCheckpoint = NewCheckpoint;
    GenerateCheckpointData();
    // End:0x2F
    if(bSkipSavingToDevice == false)
    {
        SaveCheckpoint();        
    }
    //return;    
}

event SaveCheckpoint()
{
    local myCheckpoint localData;
    local string defaultName;
    local int Idx;

    // End:0x112
    if(CurrCheckpoint != none)
    {
        localData.CheckpointData = CheckpointData;
        defaultName = localData.Filename;
        // End:0x77
        if(CurrCheckpoint.bIsLevelBeginning)
        {
            localData.Filename = CurrCheckpoint.ChapterPointFileName;
            CheckpointsToSave.AddItem(localData);
        }
        localData.Filename = defaultName;
        Idx = 0;
        J0x94:

        // End:0x102 [Loop If]
        if(Idx < CheckpointsToSave.Length)
        {
            // End:0xF8
            if(CheckpointsToSave[Idx].Filename == localData.Filename)
            {
                CheckpointsToSave[Idx].CheckpointData = localData.CheckpointData;
                return;
            }
            Idx++;
            // [Loop Continue]
            goto J0x94;
        }
        CheckpointsToSave.AddItem(localData);        
    }
    //return;    
}
