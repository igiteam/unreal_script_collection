class MOHAProfileSettings extends OnlineProfileSettings
    native;

const ToggleCompass = 26;
const SelectedDeviceID = 27;
const VideoBrightness = 28;
const AudioMusicVolume = 29;
const AudioSFXVolume = 30;
const Subtitles = 31;
const ControllerScheme = 32;
const LevelUnlockMask = 33;
const GameDifficultyUnlockLevel1 = 34;
const GameDifficultyUnlockLevel2 = 35;
const GameDifficultyUnlockLevel3 = 36;
const GameDifficultyUnlockLevel4 = 37;
const GameDifficultyUnlockLevel5 = 38;
const GameDifficultyUnlockLevel6 = 39;
const AutosaveAccepted = 40;
const GameComplete = 41;
const SprintEffects = 42;
const MAX_VOLUME_VALUE = 10.00;

enum EProfileControllerSchemeOptions
{
    PCO_Default,                    // 0
    PCO_Gears,                      // 1
    PCO_Halo,                       // 2
    PCO_MAX                         // 3
};

var bool bIsInitialized;

// Export UMOHAProfileSettings::execGetProfileSettingMappings(FFrame&, void* const)
native function bool GetProfileSettingMappings(int ProfileSettingId, out array<IdToStringMapping> Values);

// Export UMOHAProfileSettings::execGetProfileSettingValueMappingIndex(FFrame&, void* const)
native function bool GetProfileSettingValueMappingIndex(int ProfileSettingId, out int ValueIndex);

// Export UMOHAProfileSettings::execGetProfileSettingValueEx(FFrame&, void* const)
native function bool GetProfileSettingValueEx(int ProfileSettingId, out string Value, out int IndexValue);

// Export UMOHAProfileSettings::execGetProfileSettingValueByNameEx(FFrame&, void* const)
native function bool GetProfileSettingValueByNameEx(name ProfileSettingName, out string Value, out int IndexValue);

// Export UMOHAProfileSettings::execSetProfileSettingValue(FFrame&, void* const)
native function bool SetProfileSettingValue(int ProfileSettingId, const out string NewValue);

function bool GetInvertMouseOption()
{
    local bool retval;
    local int Value;

    GetProfileSettingValueId(2, Value);
    switch(Value)
    {
        // End:0x27
        case 1:
            retval = true;
            // End:0x44
            break;
        // End:0x36
        case 0:
            retval = false;
            // End:0x44
            break;
        // End:0xFFFF
        default:
            retval = false;
            // End:0x44
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function bool GetControllerVibrationOption()
{
    local bool retval;
    local int Value;

    GetProfileSettingValueId(1, Value);
    switch(Value)
    {
        // End:0x27
        case 3:
            retval = true;
            // End:0x44
            break;
        // End:0x36
        case 0:
            retval = false;
            // End:0x44
            break;
        // End:0xFFFF
        default:
            retval = true;
            // End:0x44
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function bool GetToggleCompassOption()
{
    local bool retval;
    local int Value;

    GetProfileSettingValueId(26, Value);
    switch(Value)
    {
        // End:0x27
        case 1:
            retval = true;
            // End:0x44
            break;
        // End:0x36
        case 0:
            retval = false;
            // End:0x44
            break;
        // End:0xFFFF
        default:
            retval = true;
            // End:0x44
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function MOHAProfileSettings.EProfileControllerSchemeOptions GetControllerSchemeOption()
{
    local MOHAProfileSettings.EProfileControllerSchemeOptions retval;
    local int Value;

    GetProfileSettingValueId(32, Value);
    switch(Value)
    {
        // End:0x27
        case 0:
            retval = 0;
            // End:0x54
            break;
        // End:0x36
        case 1:
            retval = 1;
            // End:0x54
            break;
        // End:0x46
        case 2:
            retval = 2;
            // End:0x54
            break;
        // End:0xFFFF
        default:
            retval = 0;
            // End:0x54
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function float GetAimSensitivityOption()
{
    local int Value;

    GetProfileSettingValueInt(13, Value);
    return float(Value) / 100.0000000;
    //return ReturnValue;    
}

function float GetAudioMusicVolume()
{
    local int retval;

    GetProfileSettingValueInt(29, retval);
    return float(retval) / 10.0000000;
    //return ReturnValue;    
}

function float GetAudioSFXVolume()
{
    local int retval;

    GetProfileSettingValueInt(30, retval);
    return float(retval) / 10.0000000;
    //return ReturnValue;    
}

function bool GetSubtitleConfigOption()
{
    local bool retval;
    local int Value;

    GetProfileSettingValueId(31, Value);
    switch(Value)
    {
        // End:0x27
        case 1:
            retval = true;
            // End:0x44
            break;
        // End:0x36
        case 0:
            retval = false;
            // End:0x44
            break;
        // End:0xFFFF
        default:
            retval = false;
            // End:0x44
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function int GetDifficultyOption()
{
    local int retval;

    GetProfileSettingValueId(12, retval);
    switch(retval)
    {
        // End:0x26
        case 1:
            retval = 1;
            // End:0x51
            break;
        // End:0x34
        case 0:
            retval = 0;
            // End:0x51
            break;
        // End:0x44
        case 2:
            retval = 2;
            // End:0x51
            break;
        // End:0xFFFF
        default:
            retval = 0;
            // End:0x51
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function float GetGammaSetting()
{
    local int Value;
    local float MappedValue;

    GetProfileSettingValueInt(28, Value);
    MappedValue = ((float(Value) / 10.0000000) * 2.0000000) + 1.0000000;
    // End:0x5E
    if((MappedValue < 1.0000000) || MappedValue > 3.0000000)
    {
        MappedValue = 2.2000000;
    }
    return MappedValue;
    //return ReturnValue;    
}

function bool GetSprintEffectsOption()
{
    local bool retval;
    local int Value;

    GetProfileSettingValueId(42, Value);
    switch(Value)
    {
        // End:0x27
        case 1:
            retval = true;
            // End:0x44
            break;
        // End:0x36
        case 0:
            retval = false;
            // End:0x44
            break;
        // End:0xFFFF
        default:
            retval = false;
            // End:0x44
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function SetCurrentDeviceID(int DeviceID)
{
    SetProfileSettingValueInt(27, DeviceID);
    //return;    
}

function bool SettingsHaveBeenLoaded()
{
    return bIsInitialized;
    //return ReturnValue;    
}

// Export UMOHAProfileSettings::execUnlockLevelByDifficulty(FFrame&, void* const)
native function UnlockLevelByDifficulty(int ChapterNum, int Difficulty);

// Export UMOHAProfileSettings::execIsLevelUnlocked(FFrame&, void* const)
native function bool IsLevelUnlocked(int LevelNum, int Difficulty);

// Export UMOHAProfileSettings::execHasCompletedLevel(FFrame&, void* const)
native function bool HasCompletedLevel(int LevelNum, int nDifficulty);

// Export UMOHAProfileSettings::execSetGameComplete(FFrame&, void* const)
native function SetGameComplete(int Difficulty);

// Export UMOHAProfileSettings::execGetGameComplete(FFrame&, void* const)
native function bool GetGameComplete(int Difficulty);

// Export UMOHAProfileSettings::execSetToDefaults(FFrame&, void* const)
native function SetToDefaults();

// Export UMOHAProfileSettings::execDumpProfileSettings(FFrame&, void* const)
native function DumpProfileSettings();

// Export UMOHAProfileSettings::execDumpLevelUnlockSettings(FFrame&, void* const)
native function DumpLevelUnlockSettings();

defaultproperties
{
    VersionNumber=12
    ProfileSettingIds=/* Array type was not detected. */
    DefaultSettings=/* Array type was not detected. */
    ProfileMappings=/* Array type was not detected. */
}