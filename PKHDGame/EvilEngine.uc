class EvilEngine extends GameEngine
    transient
    native
    config(Engine);

const MAX_DATASIZE_FOR_ALL_CHECKPOINTS = 500000;

enum ECheckpointAction
{
    Checkpoint_Default,             // 0
    Checkpoint_Load,                // 1
    Checkpoint_Save,                // 2
    Checkpoint_MAX                  // 3
};

var class<Checkpoint> CheckpointClass;
var native Pointer NewSystemSettingData;
var native Pointer OldSystemSettingData;
var const bool bPastFirstLoad;
var bool bPendingCheckpointIsLevelStart;
var bool bShouldWriteCheckpointToDisk;
var config bool bUseMaskedHairInGame;
var transient bool bIsTickingCIV;
var bool bIsUtilityMounted;
var const bool bNeedsSerialNumCheck;
var Vector PendingCheckpointLocation;
var EvilEngine.ECheckpointAction PendingCheckpointAction;
var const array<LevelRecord> PostCheckpointStreamingUpdates;
var protectedwrite Checkpoint CurrentCheckpoint;
var int CurrentUserID;
var protectedwrite int CurrentDeviceID;
var config int FailureMemoryHackThreshold;
var transient float TimeBetweenCIVTicks;
var transient float LastCIVCheckTime;
var native const transient Pointer OverlappedCIV;
var native const transient Pointer PreviousWeaponConfigFile;
var native const transient Pointer PreviousPawnConfigFile;
var const transient string LastIniChange;
var const transient string DVDSerialNumber;
var int FramesUntilIntroMayBeSkipped;

final function SetCurrentDeviceID(int NewDeviceID)
{
    CurrentDeviceID = NewDeviceID;
    //return;    
}

// Export UEvilEngine::execSaveCheckpoint(FFrame&, void* const)
protected native final function SaveCheckpoint(Vector CheckpointLocation);

// Export UEvilEngine::execLoadCheckpoint(FFrame&, void* const)
protected native final function LoadCheckpoint();

// Export UEvilEngine::execSetCheckpoint(FFrame&, void* const)
native function SetCheckpoint(int SlotIndex, const out array<byte> CheckpointData);

// Export UEvilEngine::execParseCheckpointData(FFrame&, void* const)
native function bool ParseCheckpointData(const out array<byte> CheckpointData, int SlotIndex, out byte bIsLevelStart, out int CheckpointChapter, out byte CheckpointDifficulty, out CheckpointTime CheckpointTimestamp);

// Export UEvilEngine::execGetSaveDataFromFile(FFrame&, void* const)
native function bool GetSaveDataFromFile(string Filename, string SaveFileName, out byte bIsValid, out array<byte> SaveGameData);

// Export UEvilEngine::execGetRequiredFreeSpace(FFrame&, void* const)
native final function int GetRequiredFreeSpace(optional int DeviceID = CurrentDeviceID, optional int UserId = CurrentUserID);

event bool IsCurrentDeviceValid(optional int SizeNeeded)
{
    local OnlineSubsystem OnlineSub;
    local bool bResult;

    OnlineSub = GetOnlineSubsystem();
    // End:0xAD
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        bResult = OnlineSub.PlayerInterfaceEx.IsDeviceValid(CurrentDeviceID, SizeNeeded);
    }
    return bResult;
    //return ReturnValue;    
}

event WriteCheckpointData(const out array<byte> SaveGameData)
{
    local OnlineSubsystem OnlineSub;
    local string SaveFileName;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x189
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
    {
        OnlineSub.ContentInterface.AddWriteSaveGameDataComplete(byte(CurrentUserID), OnWriteSaveGameDataComplete);
        SaveFileName = ("PKCheckpoint" $ string(CurrentCheckpoint.SlotIndex)) $ ".sav";
        OnlineSub.ContentInterface.WriteSaveGameData(byte(CurrentUserID), CurrentDeviceID, Class'Checkpoint'.default.DisplayName, "PKCheckpoint", SaveFileName, SaveGameData);
    }
    //return;    
}

function OnWriteSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x124
    if(OnlineSub != none)
    {
        // End:0x124
        if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)) && InStr(Filename, "PKCheckpoint") != -1)
        {
            OnlineSub.ContentInterface.ClearWriteSaveGameDataComplete(byte(CurrentUserID), OnWriteSaveGameDataComplete);
            OnlineSub.ContentInterface.ClearSaveGames(LocalUserNum);
        }
    }
    //return;    
}

// Export UEvilEngine::execCheckCIV(FFrame&, void* const)
native final function CheckCIV();

// Export UEvilEngine::execStopAllSounds(FFrame&, void* const)
native final function StopAllSounds(optional bool bShouldStopUISounds = false);

// Export UEvilEngine::execReadDVDSerialNumber(FFrame&, void* const)
native final function ReadDVDSerialNumber();

// Export UEvilEngine::execGetStartupLoginControllerId(FFrame&, void* const)
native final function int GetStartupLoginControllerId();

event PostInit()
{
    //return;    
}

event class<Checkpoint> GetCheckpointClass()
{
    return CheckpointClass;
    //return ReturnValue;    
}

event MapLoading(URL LoadURL, PendingLevel Pending, string Error)
{
    //return;    
}

event PostLoadMap()
{
    //return;    
}

event bool CheckIfEngineShouldBreakMapLoading(URL LoadURL, string ChapterId, PendingLevel Pending, out string RetTitle, out string RetError)
{
    return false;
    //return ReturnValue;    
}

event NotifyIntroMayBeSkipped()
{
    //return;    
}

// Export UEvilEngine::execInitializeNewSystemSettings(FFrame&, void* const)
native function InitializeNewSystemSettings();

// Export UEvilEngine::execGetScreenResolutions(FFrame&, void* const)
native function array<string> GetScreenResolutions(out int SelectedIndex);

// Export UEvilEngine::execSetScreenResolution(FFrame&, void* const)
native function SetScreenResolution(string ScreenResolution);

// Export UEvilEngine::execGetIsFullScreen(FFrame&, void* const)
native function bool GetIsFullScreen();

// Export UEvilEngine::execSetFullScreen(FFrame&, void* const)
native function SetFullScreen(bool bFullScreen);

function int GetGraphicsQuality()
{
    local int Level, Temp;

    Temp = GetTextureQuality();
    Level = Temp;
    Temp = GetShadowQuality();
    // End:0x54
    if(Temp != Level)
    {
        return 0;
    }
    Temp = GetGeometryQuality();
    // End:0x81
    if(Temp != Level)
    {
        return 0;
    }
    Temp = GetLightingQuality();
    // End:0xAE
    if(Temp != Level)
    {
        return 0;
    }
    Temp = GetEffectsQuality();
    // End:0xDB
    if(Temp != Level)
    {
        return 0;
    }
    Temp = GetPostprocessQuality();
    // End:0x108
    if(Temp != Level)
    {
        return 0;
    }
    return Temp;
    //return ReturnValue;    
}

// Export UEvilEngine::execGetTextureQuality(FFrame&, void* const)
native function int GetTextureQuality();

// Export UEvilEngine::execGetShadowQuality(FFrame&, void* const)
native function int GetShadowQuality();

// Export UEvilEngine::execGetGeometryQuality(FFrame&, void* const)
native function int GetGeometryQuality();

// Export UEvilEngine::execGetLightingQuality(FFrame&, void* const)
native function int GetLightingQuality();

// Export UEvilEngine::execGetEffectsQuality(FFrame&, void* const)
native function int GetEffectsQuality();

// Export UEvilEngine::execGetPostprocessQuality(FFrame&, void* const)
native function int GetPostprocessQuality();

// Export UEvilEngine::execGetVSync(FFrame&, void* const)
native function bool GetVSync();

// Export UEvilEngine::execGetFramerateSmoothing(FFrame&, void* const)
native function bool GetFramerateSmoothing();

function SetGraphicsQuality(int Level)
{
    SetTextureQuality(Level);
    SetShadowQuality(Level);
    SetGeometryQuality(Level);
    SetLightingQuality(Level);
    SetEffectsQuality(Level);
    SetPostprocessQuality(Level);
    //return;    
}

// Export UEvilEngine::execSetTextureQuality(FFrame&, void* const)
native function SetTextureQuality(int Level);

// Export UEvilEngine::execSetShadowQuality(FFrame&, void* const)
native function SetShadowQuality(int Level);

// Export UEvilEngine::execSetGeometryQuality(FFrame&, void* const)
native function SetGeometryQuality(int Level);

// Export UEvilEngine::execSetLightingQuality(FFrame&, void* const)
native function SetLightingQuality(int Level);

// Export UEvilEngine::execSetEffectsQuality(FFrame&, void* const)
native function SetEffectsQuality(int Level);

// Export UEvilEngine::execSetPostprocessQuality(FFrame&, void* const)
native function SetPostprocessQuality(int Level);

// Export UEvilEngine::execSetVSync(FFrame&, void* const)
native function SetVSync(bool bEnabled);

// Export UEvilEngine::execSetFramerateSmoothing(FFrame&, void* const)
native function SetFramerateSmoothing(bool bEnabled);

// Export UEvilEngine::execUpdateVideoSettings(FFrame&, void* const)
native function bool UpdateVideoSettings();

// Export UEvilEngine::execAcceptVideoSettings(FFrame&, void* const)
native function AcceptVideoSettings();

// Export UEvilEngine::execRollbackVideoSettings(FFrame&, void* const)
native function RollbackVideoSettings();

// Export UEvilEngine::execAlienwareTurnOffLights(FFrame&, void* const)
native function AlienwareTurnOffLights();

// Export UEvilEngine::execAlienwareSetLights(FFrame&, void* const)
native function AlienwareSetLights(Color LightColor);

// Export UEvilEngine::execAlienwareGetDefaultLights(FFrame&, void* const)
native function AlienwareGetDefaultLights();

// Export UEvilEngine::execAlienwareSetDefaultLights(FFrame&, void* const)
native function AlienwareSetDefaultLights();

// Export UEvilEngine::execResetVideoSetting(FFrame&, void* const)
native function bool ResetVideoSetting(optional int CompatLevel = 0);

// Export UEvilEngine::execAreSettingsDifferent(FFrame&, void* const)
native function bool AreSettingsDifferent();

// Export UEvilEngine::execRestartGame(FFrame&, void* const)
native function RestartGame();

// Export UEvilEngine::execOpenPainkillerBetaWWW(FFrame&, void* const)
native function OpenPainkillerBetaWWW();

// Export UEvilEngine::execSetMovieIsSkippable(FFrame&, void* const)
native function SetMovieIsSkippable(bool bNewIsSkippable);

// Export UEvilEngine::execIsLowViolence(FFrame&, void* const)
native static final function bool IsLowViolence();

defaultproperties
{
    bShouldWriteCheckpointToDisk=true
    bNeedsSerialNumCheck=true
    CurrentDeviceID=-1
    TimeBetweenCIVTicks=0.5000000
}