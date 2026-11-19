class PandoraProfileSettings extends OnlineProfileSettings
    native;

const PROP_NonStandardOptions = 0x10000006;
const PROP_DedicatedServer = 0x10000009;
const PROP_CustomMapName = 0x10000011;
const PROP_GameStatus = 0x10000012;
const PROP_LONGBOWACCURACYRATING = 0x30000003;
const GAME_STATUS_LOBBY = 0;
const GAME_STATUS_INPROGRESS = 1;
const GAME_STATUS_POSTGAME = 2;
const GAME_MODE = 0x0000800B;
const GAME_MODE_DM = 0;
const GAME_MODE_TDM = 1;
const CONTEXT_MAPNAME = 0;
const CONTEXT_NUMCREATURES = 1;
const CONTEXT_MATCHDURATION = 2;
const CONTEXT_ANIMUSLIMIT = 3;
const CONTEXT_FULLSERVER = 4;
const CONTEXT_FULLSERVER_NOTFULLSERVER = 0;
const CONTEXT_FULLSERVER_FULLSERVER = 1;
const CONTEXT_MAPNAME_MAP_ANY = 0;
const CONTEXT_MAPNAME_MP_DUR_WW = 1;
const CONTEXT_MAPNAME_WW_TESTMAP = 2;
const CONTEXT_MAPNAME_SUR_RABOUT_MTR = 3;
const CONTEXT_MAPNAME_WEREHOUSE_MTR = 4;
const CONTEXT_MAPNAME_THEKEEP_MTR = 5;
const CONTEXT_MAPNAME_DEN_MTR_MP = 6;
const CONTEXT_MAPNAME_NYSTREET_MTR_MP = 7;
const CONTEXT_MAPNAME_JOHNSPLAYGROUND = 8;
const CONTEXT_MAPNAME_DOUGLAND = 9;
const CONTEXT_NUMCREATURES_ANY = 0;
const CONTEXT_NUMCREATURES_NONE = 1;
const CONTEXT_NUMCREATURES_LOW = 2;
const CONTEXT_NUMCREATURES_MEDIUM = 3;
const CONTEXT_NUMCREATURES_HIGH = 4;
const CONTEXT_MATCHDURATION_ANY = 0;
const CONTEXT_MATCHDURATION_5MIN = 1;
const CONTEXT_MATCHDURATION_10MIN = 2;
const CONTEXT_MATCHDURATION_15MIN = 3;
const CONTEXT_MATCHDURATION_30MIN = 4;
const CONTEXT_MATCHDURATION_1HR = 5;
const CONTEXT_ANIMUSLIMIT_ANYPTS = 0;
const CONTEXT_ANIMUSLIMIT_100PTS = 1;
const CONTEXT_ANIMUSLIMIT_250PTS = 2;
const CONTEXT_ANIMUSLIMIT_500PTS = 3;
const CONTEXT_ANIMUSLIMIT_750PTS = 4;
const CONTEXT_ANIMUSLIMIT_1000PTS = 5;
const CONTEXT_PRESENCE_LEGENDARYMAIN = 0;
const CONTEXT_PRESENCE_LEGENDARYSP = 1;
const CONTEXT_PRESENCE_LEGENDARYMP = 2;
const CONTEXT_PRESENCE_INACTIVEPROFILE = 3;
const QUERY_DMSearch = 1;
const QUERY_PandoraCustomSearch = 2;
const ACHIEVEMENT_ACHIEVEMENT12 = 1;
const ACHIEVEMENT_ACHIEVEMENT13 = 2;
const ACHIEVEMENT_ACHIEVEMENT14 = 3;
const ACHIEVEMENT_ACHIEVEMENT15 = 4;
const ACHIEVEMENT_ACHIEVEMENT01 = 5;
const ACHIEVEMENT_ACHIEVEMENT16 = 6;
const ACHIEVEMENT_ACHIEVEMENT17 = 7;
const ACHIEVEMENT_ACHIEVEMENT02 = 8;
const ACHIEVEMENT_ACHIEVEMENT18 = 9;
const ACHIEVEMENT_ACHIEVEMENT19 = 10;
const ACHIEVEMENT_ACHIEVEMENT20 = 11;
const ACHIEVEMENT_ACHIEVEMENT21 = 12;
const ACHIEVEMENT_ACHIEVEMENT03 = 13;
const ACHIEVEMENT_ACHIEVEMENT22 = 14;
const ACHIEVEMENT_ACHIEVEMENT23 = 15;
const ACHIEVEMENT_ACHIEVEMENT24 = 16;
const ACHIEVEMENT_ACHIEVEMENT04 = 17;
const ACHIEVEMENT_ACHIEVEMENT25 = 18;
const ACHIEVEMENT_ACHIEVEMENT26 = 19;
const ACHIEVEMENT_ACHIEVEMENT27 = 20;
const ACHIEVEMENT_ACHIEVEMENT05 = 21;
const ACHIEVEMENT_ACHIEVEMENT28 = 22;
const ACHIEVEMENT_ACHIEVEMENT30 = 23;
const ACHIEVEMENT_ACHIEVEMENT06 = 24;
const ACHIEVEMENT_ACHIEVEMENT31 = 25;
const ACHIEVEMENT_ACHIEVEMENT32 = 26;
const ACHIEVEMENT_ACHIEVEMENT07 = 27;
const ACHIEVEMENT_ACHIEVEMENT33 = 28;
const ACHIEVEMENT_ACHIEVEMENT29 = 29;
const ACHIEVEMENT_ACHIEVEMENT34 = 30;
const ACHIEVEMENT_ACHIEVEMENT08 = 31;
const ACHIEVEMENT_ACHIEVEMENT09 = 32;
const ACHIEVEMENT_ACHIEVEMENT10 = 33;
const ACHIEVEMENT_ACHIEVEMENT11 = 34;
const ACHIEVEMENT_ACHIEVEMENT35 = 35;
const ACHIEVEMENT_ACHIEVEMENT36 = 36;
const ACHIEVEMENT_ACHIEVEMENT37 = 37;
const ACHIEVEMENT_ACHIEVEMENT38 = 38;
const ACHIEVEMENT_ACHIEVEMENT39 = 39;
const ACHIEVEMENT_ACHIEVEMENT40 = 40;
const ACHIEVEMENT_ACHIEVEMENT41 = 41;
const ACHIEVEMENT_ACHIEVEMENT42 = 42;
const ACHIEVEMENT_ACHIEVEMENT43 = 43;
const ACHIEVEMENT_ACHIEVEMENT45 = 44;
const ACHIEVEMENT_ACHIEVEMENT46 = 45;
const ACHIEVEMENT_ACHIEVEMENT44 = 46;
const ACHIEVEMENT_ACHIEVEMENT47 = 47;
const ACHIEVEMENT_ACHIEVEMENT48 = 48;
const ACHIEVEMENT_ACHIEVEMENT49 = 49;
const ACHIEVEMENT_ACHIEVEMENT50 = 50;
const HudOnOff = 40;
const PandoraStickConfig = 41;
const Subtitles = 42;
const MusicVolume = 43;
const FxVolume = 44;
const DialogueVolume = 45;
const ChapterUnlockMask = 46;
const ChapterUnlockedWithEasy = 47;
const ChapterUnlockedWithNormal = 48;
const ChapterUnlockedWithHard = 49;
const GammaSetting = 100;
const ControllerConfigType = 103;
const AudioMasterVol = 104;
const AudioMusicSetting = 111;
const PID_LocalUser = 124;
const PID_LoginName = 123;
const PID_LoginPassword = 122;
const PID_SaveLoginNamePassword = 121;
const PID_Achevement_flags = 199;
const PID_Achevement_41 = 241;
const PID_Achevement_42 = 242;
const PID_Achevement_43 = 243;
const PID_Achevement_44 = 244;
const PID_Achevement_45 = 245;
const PID_Achevement_46 = 246;
const PID_Achevement_47 = 247;
const PID_Achevement_48 = 248;
const PID_Achevement_49 = 249;
const PID_Achevement_50 = 250;
const PID_Achevement_37 = 251;
const PID_Achevement_38 = 252;
const PID_Achevement_39 = 253;
const SelectedDeviceID = 308;
const TelevisionType = 309;
const UnlockedPDACreatureMessageId = 310;
const UnlockedPDAEquipmentMessageId = 311;
const UnlockedPDAObjectiveMessageId = 312;
const UnlockedPDAPeopleMessageId = 313;
const PickedUpPDAMessageId = 314;
const UnlockedPDAMessageCount = 400;
const UnlockedPDAMessageDataId = 401;
const UnlockedWWTutorial = 402;
const VideoPerformance = 403;
const LookSensitivityInGame = 404;
const GameDifficultyInGame = 405;
const InvertYInGame = 406;
const AutoAimInGame = 407;
const UsingAmBx = 408;
const AMBX_FLAG_AMBX_ENABLED = 0x000001;
const AMBX_FLAG_FULL_RUMBLE = 0x000002;
const ChapterCompletedWithEasy = 409;
const ChapterCompletedWithNormal = 410;
const ChapterCompletedWithHard = 412;
const AmBxRumbleQuality = 413;
const MAX_VOLUME_VALUE = 10.0;

enum EPandoraStickConfigOpts
{
    PSCO_Default,                   // 0
    PSCO_SouthPaw,                  // 1
    PSCO_Legacy,                    // 2
    PSCO_LegacySouthPaw,            // 3
    PSCO_Tactical,                  // 4
    PSCO_Assault,                   // 5
    PSCO_MAX                        // 6
};

enum EPandoraOptsYesNo
{
    POYN_Yes,                       // 0
    POYN_No,                        // 1
    POYN_MAX                        // 2
};

enum EPandoraOptsOnOff
{
    POOO_Off,                       // 0
    POOO_On,                        // 1
    POOO_MAX                        // 2
};

enum ETVType
{
    TVT_Default,                    // 0
    TVT_Soft,                       // 1
    TVT_Lucent,                     // 2
    TVT_Vibrant,                    // 3
    TVT_MAX                         // 4
};

enum EPandoraOptsDegree
{
    POD_Low,                        // 0
    POD_Medium,                     // 1
    POD_High,                       // 2
    POD_MAX                         // 3
};

enum EPandoraCompositePerformaceLevel
{
    PCPL_NOT_SUPPORTED,             // 0
    PCPL_VERY_LOW,                  // 1
    PCPL_LOW,                       // 2
    PCPL_MEDIUM,                    // 3
    PCPL_HIGH,                      // 4
    PCPL_VERY_HIGH,                 // 5
    PCPL_MAX                        // 6
};

var bool bForceProfileWrite;
var bool bProfileDirty;
var bool bProfileBusy;
var int nWriteTime;

// Export UPandoraProfileSettings::execGetProfileSettingMappings(FFrame&, void* const)
native function bool GetProfileSettingMappings(int ProfileSettingId, out array<IdToStringMapping> Values);

// Export UPandoraProfileSettings::execGetProfileSettingValueMappingIndex(FFrame&, void* const)
native function bool GetProfileSettingValueMappingIndex(int ProfileSettingId, out int ValueIndex);

// Export UPandoraProfileSettings::execGetVideoPerformanceFromAppCompat(FFrame&, void* const)
native function int GetVideoPerformanceFromAppCompat();

// Export UPandoraProfileSettings::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

function bool IsProfileDirty()
{
    return bProfileDirty;
    //return ReturnValue;    
}

function bool OkToWriteProfile()
{
    local int nCurrentTime, ProfileSaveTime;

    nCurrentTime = int(GetWorldInfo().RealTimeSeconds);
    // End:0x23
    if(bProfileBusy)
    {
        return false;
    }
    // End:0x3C
    if(!GetWorldInfo().IsConsoleBuild())
    {
        return true;
    }
    // End:0x5D
    if(GetWorldInfo().IsConsoleBuild(2))
    {
        ProfileSaveTime = 6;        
    }
    else
    {
        ProfileSaveTime = 300;
    }
    // End:0x80
    if((nCurrentTime - nWriteTime) > ProfileSaveTime)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function SetProfileForceWrite(bool ShouldForce)
{
    bForceProfileWrite = ShouldForce;
    //return;    
}

function SetProfileDirty(bool nDirty)
{
    // End:0x14
    if(nDirty)
    {
        bProfileDirty = true;        
    }
    else
    {
        bProfileDirty = false;
    }
    //return;    
}

function SetProfileBusy(bool nBusy)
{
    // End:0x14
    if(nBusy)
    {
        bProfileBusy = true;        
    }
    else
    {
        bProfileBusy = false;
    }
    //return;    
}

function int GetAutoAim()
{
    local int Value;

    GetProfileSettingValueId(407, Value);
    // End:0x55
    if(Value == -1)
    {
        GetProfileSettingValueId(16, Value);
        SetProfileSettingValueId(407, Value);
        SetProfileDirty(true);
    }
    return Value;
    //return ReturnValue;    
}

function SetGameInfoDifficulty(int Value)
{
    local PandoraGameInfo.EGameDifficulty eDiff;

    switch(Value)
    {
        // End:0x17
        case 1:
            eDiff = 0;
            // End:0x39
            break;
        // End:0x27
        case 2:
            eDiff = 2;
            // End:0x39
            break;
        // End:0x2B
        case 0:
        // End:0xFFFF
        default:
            eDiff = 1;
            // End:0x39
            break;
            break;
    }
    PandoraGameInfo(GetWorldInfo().Game).currGameDifficulty = eDiff;
    //return;    
}

function int GetGameDifficulty()
{
    local int Value;

    GetProfileSettingValueId(405, Value);
    // End:0x45
    if(Value == -1)
    {
        GetProfileSettingValueId(12, Value);
        SetGameDifficulty(Value);
    }
    SetGameInfoDifficulty(Value);
    return Value;
    //return ReturnValue;    
}

function SetGameDifficulty(int Value)
{
    SetGameInfoDifficulty(Value);
    SetProfileSettingValueId(405, Value);
    SetProfileDirty(true);
    //return;    
}

function bool GetInvertMouseOption()
{
    local bool retval;
    local int Value;

    GetProfileSettingValueId(406, Value);
    // End:0x55
    if(Value == -1)
    {
        GetProfileSettingValueId(2, Value);
        SetProfileSettingValueId(406, Value);
        SetProfileDirty(true);
    }
    switch(Value)
    {
        // End:0x6C
        case 1:
            retval = true;
            // End:0x7E
            break;
        // End:0x70
        case 0:
        // End:0xFFFF
        default:
            retval = false;
            // End:0x7E
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function SetInvertMouseOption(bool bInvertY)
{
    // End:0x1C
    if(bInvertY)
    {
        SetProfileSettingValueId(406, 1);        
    }
    else
    {
        SetProfileSettingValueId(406, 0);
    }
    SetProfileDirty(true);
    //return;    
}

function bool GetControllerVibrationOption()
{
    local bool retval;
    local int Value;

    GetProfileSettingValueId(1, Value);
    switch(Value)
    {
        // End:0x29
        case 3:
            retval = true;
            // End:0x46
            break;
        // End:0x38
        case 0:
            retval = false;
            // End:0x46
            break;
        // End:0xFFFF
        default:
            retval = true;
            // End:0x46
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function SetControllerVibrationOption(bool bVibration)
{
    // End:0x19
    if(bVibration)
    {
        SetProfileSettingValueId(1, 3);        
    }
    else
    {
        SetProfileSettingValueId(1, 0);
    }
    SetProfileDirty(true);
    //return;    
}

function bool GetHUDOption()
{
    local bool retval;
    local int Value;

    GetProfileSettingValueId(40, Value);
    switch(Value)
    {
        // End:0x29
        case 1:
            retval = true;
            // End:0x46
            break;
        // End:0x38
        case 0:
            retval = false;
            // End:0x46
            break;
        // End:0xFFFF
        default:
            retval = false;
            // End:0x46
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function SetHUDOption(bool bHudFade)
{
    // End:0x19
    if(bHudFade)
    {
        SetProfileSettingValueId(40, 1);        
    }
    else
    {
        SetProfileSettingValueId(40, 0);
    }
    SetProfileDirty(true);
    //return;    
}

function bool GetSubtitleConfigOption()
{
    local bool retval;
    local int Value;

    GetProfileSettingValueId(42, Value);
    switch(Value)
    {
        // End:0x29
        case 1:
            retval = true;
            // End:0x46
            break;
        // End:0x38
        case 0:
            retval = false;
            // End:0x46
            break;
        // End:0xFFFF
        default:
            retval = false;
            // End:0x46
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function SetSubtitleConfigOption(bool bShowSubTitle)
{
    // End:0x19
    if(bShowSubTitle)
    {
        SetProfileSettingValueId(42, 1);        
    }
    else
    {
        SetProfileSettingValueId(42, 0);
    }
    SetProfileDirty(true);
    //return;    
}

function PandoraProfileSettings.EPandoraStickConfigOpts GetStickConfigOption()
{
    local PandoraProfileSettings.EPandoraStickConfigOpts retval;
    local int Value;

    GetProfileSettingValueId(41, Value);
    switch(Value)
    {
        // End:0x2A
        case 2:
            retval = 2;
            // End:0x7B
            break;
        // End:0x39
        case 1:
            retval = 1;
            // End:0x7B
            break;
        // End:0x49
        case 3:
            retval = 3;
            // End:0x7B
            break;
        // End:0x59
        case 4:
            retval = 4;
            // End:0x7B
            break;
        // End:0x69
        case 5:
            retval = 5;
            // End:0x7B
            break;
        // End:0x6D
        case 0:
        // End:0xFFFF
        default:
            retval = 0;
            // End:0x7B
            break;
            break;
    }
    return retval;
    //return ReturnValue;    
}

function SetStickConfigOption(int newConfig)
{
    SetProfileSettingValueId(41, newConfig);
    SetProfileDirty(true);
    //return;    
}

function int GetControllerSensitivityValue()
{
    local int Value;

    GetProfileSettingValueInt(404, Value);
    // End:0x8C
    if(Value == -1)
    {
        GetProfileSettingValueId(13, Value);
        switch(Value)
        {
            // End:0x4B
            case 1:
                Value = 1;
                // End:0x6D
                break;
            // End:0x5B
            case 2:
                Value = 9;
                // End:0x6D
                break;
            // End:0x5F
            case 0:
            // End:0xFFFF
            default:
                Value = 5;
                // End:0x6D
                break;
                break;
        }
        SetProfileSettingValueInt(404, Value);
        SetProfileDirty(true);
    }
    return Value;
    //return ReturnValue;    
}

function SetControllerSensitivityValue(int newSensitivity)
{
    GetProfileSettingValueInt(404, newSensitivity);
    SetProfileDirty(true);
    //return;    
}

function float GetDialogVolume()
{
    local float retval;
    local int Value;

    GetProfileSettingValueInt(45, Value);
    // End:0x33
    if(Value != 0)
    {
        retval = float(Value) / 10.0000000;        
    }
    else
    {
        retval = 0.0000000;
    }
    return retval;
    //return ReturnValue;    
}

function float GetFxVolume()
{
    local float retval;
    local int Value;

    GetProfileSettingValueInt(44, Value);
    // End:0x33
    if(Value != 0)
    {
        retval = float(Value) / 10.0000000;        
    }
    else
    {
        retval = 0.0000000;
    }
    return retval;
    //return ReturnValue;    
}

function float GetMusicVolume()
{
    local float retval;
    local int Value;

    GetProfileSettingValueInt(43, Value);
    // End:0x33
    if(Value != 0)
    {
        retval = float(Value) / 10.0000000;        
    }
    else
    {
        retval = 0.0000000;
    }
    return retval;
    //return ReturnValue;    
}

function float GetMasterVol()
{
    local int Value;

    GetProfileSettingValueInt(104, Value);
    return float(Value) / 10.0000000;
    //return ReturnValue;    
}

function SetMasterVol(float newVol)
{
    SetProfileSettingValueInt(104, int(newVol * 10.0000000));
    SetProfileDirty(true);
    //return;    
}

function UnlockChapter(int ChapterNum, optional int overRideDifficulty = -1)
{
    local int ChapterUnlocked, ChapterUnlockedId, CurGameDifficulty;

    // End:0x26
    if(overRideDifficulty != -1)
    {
        CurGameDifficulty = overRideDifficulty;        
    }
    else
    {
        CurGameDifficulty = GetGameDifficulty();
    }
    switch(CurGameDifficulty)
    {
        // End:0x4D
        case 0:
            ChapterUnlockedId = 48;
            // End:0x6F
            break;
        // End:0x5D
        case 2:
            ChapterUnlockedId = 49;
            // End:0x6F
            break;
        // End:0x61
        case 1:
        // End:0xFFFF
        default:
            ChapterUnlockedId = 47;
            // End:0x6F
            break;
            break;
    }
    GetProfileSettingValueInt(ChapterUnlockedId, ChapterUnlocked);
    // End:0xD2
    if(((ChapterUnlocked >> (ChapterNum - 1)) & 1) == 0)
    {
        ChapterUnlocked = ChapterUnlocked | (1 << (ChapterNum - 1));
        SetProfileSettingValueInt(ChapterUnlockedId, ChapterUnlocked);
        SetProfileDirty(true);
    }
    //return;    
}

function int GetChapterUnlocked()
{
    local int ChapterUnlocked, ChapterUnlockedId;

    switch(GetGameDifficulty())
    {
        // End:0x1C
        case 0:
            ChapterUnlockedId = 48;
            // End:0x3E
            break;
        // End:0x2C
        case 2:
            ChapterUnlockedId = 49;
            // End:0x3E
            break;
        // End:0x30
        case 1:
        // End:0xFFFF
        default:
            ChapterUnlockedId = 47;
            // End:0x3E
            break;
            break;
    }
    GetProfileSettingValueInt(ChapterUnlockedId, ChapterUnlocked);
    return ChapterUnlocked;
    //return ReturnValue;    
}

function CompleteChapter(int ChapterNum, optional int overRideDifficulty = -1)
{
    local int ChapterCompleted, ChapterCompletedId, CurGameDifficulty;

    // End:0x26
    if(overRideDifficulty != -1)
    {
        CurGameDifficulty = overRideDifficulty;        
    }
    else
    {
        CurGameDifficulty = GetGameDifficulty();
    }
    switch(CurGameDifficulty)
    {
        // End:0x50
        case 0:
            ChapterCompletedId = 410;
            // End:0x78
            break;
        // End:0x63
        case 2:
            ChapterCompletedId = 412;
            // End:0x78
            break;
        // End:0x67
        case 1:
        // End:0xFFFF
        default:
            ChapterCompletedId = 409;
            // End:0x78
            break;
            break;
    }
    GetProfileSettingValueInt(ChapterCompletedId, ChapterCompleted);
    // End:0xDB
    if(((ChapterCompleted >> (ChapterNum - 1)) & 1) == 0)
    {
        ChapterCompleted = ChapterCompleted | (1 << (ChapterNum - 1));
        SetProfileSettingValueInt(ChapterCompletedId, ChapterCompleted);
        SetProfileDirty(true);
    }
    //return;    
}

function int GetChapterCompleted()
{
    local int ChapterCompleted, ChapterCompletedId;

    switch(GetGameDifficulty())
    {
        // End:0x1F
        case 0:
            ChapterCompletedId = 410;
            // End:0x47
            break;
        // End:0x32
        case 2:
            ChapterCompletedId = 412;
            // End:0x47
            break;
        // End:0x36
        case 1:
        // End:0xFFFF
        default:
            ChapterCompletedId = 409;
            // End:0x47
            break;
            break;
    }
    GetProfileSettingValueInt(ChapterCompletedId, ChapterCompleted);
    return ChapterCompleted;
    //return ReturnValue;    
}

// Export UPandoraProfileSettings::execReallyUnlockChapter(FFrame&, void* const)
native function bool ReallyUnlockChapter(int ChapterNum);

// Export UPandoraProfileSettings::execIsChapterUnlocked(FFrame&, void* const)
native function bool IsChapterUnlocked(int ChapterNum);

function float GetGammaSetting()
{
    local int Value;
    local float MappedValue;

    GetProfileSettingValueInt(100, Value);
    MappedValue = (float(Value) / 20.0000000) + 1.0000000;
    // End:0x57
    if((MappedValue < 1.0000000) || MappedValue > 3.0000000)
    {
        MappedValue = 1.9000000;
    }
    return MappedValue;
    //return ReturnValue;    
}

function SetGammaSetting(float newGamma)
{
    local float MappedValue;

    MappedValue = ((newGamma - 1.0000000) * 20.0000000) + 0.5000000;
    SetProfileSettingValueInt(100, int(MappedValue));
    SetProfileDirty(true);
    //return;    
}

function PandoraProfileSettings.ETVType GetTVType()
{
    local int Value;

    GetProfileSettingValueId(309, Value);
    return byte(Value);
    //return ReturnValue;    
}

function SetCurrentDeviceID(int DeviceID)
{
    SetProfileSettingValueInt(308, DeviceID);
    SetProfileDirty(true);
    //return;    
}

function int GetCurrentDeviceID()
{
    local int DeviceID;

    GetProfileSettingValueInt(308, DeviceID);
    return DeviceID;
    //return ReturnValue;    
}

function bool IsMusicEnabled()
{
    local int Value;

    GetProfileSettingValueId(111, Value);
    // End:0x22
    if(Value == 1)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

// Export UPandoraProfileSettings::execUnlockChapterByDifficulty(FFrame&, void* const)
native function UnlockChapterByDifficulty(int ChapterNum, int Difficulty);

// Export UPandoraProfileSettings::execHasCompletedAct(FFrame&, void* const)
native function bool HasCompletedAct(int ActNum, int Difficulty);

// Export UPandoraProfileSettings::execHasCompletedGame(FFrame&, void* const)
native function bool HasCompletedGame();

// Export UPandoraProfileSettings::execSetToDefaults(FFrame&, void* const)
native function SetToDefaults();

function int GetUnlockedPDACreatureMessageCount()
{
    local int Value;

    GetProfileSettingValueInt(310, Value);
    return Value;
    //return ReturnValue;    
}

function int GetUnlockedPDAObjectiveMessageCount()
{
    local int Value;

    GetProfileSettingValueInt(312, Value);
    return Value;
    //return ReturnValue;    
}

function int GetUnlockedPDAEquipmentMessageCount()
{
    local int Value;

    GetProfileSettingValueInt(311, Value);
    return Value;
    //return ReturnValue;    
}

function int GetUnlockedPDAPeopleMessageCount()
{
    local int Value;

    GetProfileSettingValueInt(313, Value);
    return Value;
    //return ReturnValue;    
}

function int GetPickedUpPDAMessageCount()
{
    local int Value;

    GetProfileSettingValueInt(314, Value);
    return Value;
    //return ReturnValue;    
}

function SetPickedUpPDAMessageCount(int Count)
{
    SetProfileSettingValueInt(314, Count);
    SetProfileDirty(true);
    //return;    
}

function SetUnlockedPDACreatureMessageCount(int Count)
{
    SetProfileSettingValueInt(310, Count);
    SetProfileDirty(true);
    //return;    
}

function SetUnlockedPDAObjectiveMessageCount(int Count)
{
    SetProfileSettingValueInt(312, Count);
    SetProfileDirty(true);
    //return;    
}

function SetUnlockedPDAEquipmentMessageCount(int Count)
{
    SetProfileSettingValueInt(311, Count);
    SetProfileDirty(true);
    //return;    
}

function SetUnlockedPDAPeopleMessageCount(int Count)
{
    SetProfileSettingValueInt(313, Count);
    SetProfileDirty(true);
    //return;    
}

function SetMusicSetting(bool bEnabled)
{
    // End:0x19
    if(bEnabled)
    {
        SetProfileSettingValueId(111, 1);        
    }
    else
    {
        SetProfileSettingValueId(111, 0);
    }
    SetProfileDirty(true);
    //return;    
}

function bool GetSavedLocalPlayerName(out string LoginName)
{
    local bool bResult;

    bResult = GetProfileSettingValue(124, LoginName);
    return bResult;
    //return ReturnValue;    
}

function bool GetSavedPlayerName(out string LoginName)
{
    local bool bResult;

    bResult = GetProfileSettingValue(123, LoginName);
    return bResult;
    //return ReturnValue;    
}

function bool GetSavedPlayerPassword(out string loginpassword)
{
    local bool bResult;

    bResult = GetProfileSettingValue(122, loginpassword);
    return bResult;
    //return ReturnValue;    
}

function bool SetLocalPlayerName(string LoginName)
{
    local bool bResult;

    bResult = SetProfileSettingValue(124, LoginName);
    SetProfileDirty(true);
    return bResult;
    //return ReturnValue;    
}

function bool SetPlayerName(string LoginName)
{
    local bool bResult;

    bResult = SetProfileSettingValue(123, LoginName);
    SetProfileDirty(true);
    return bResult;
    //return ReturnValue;    
}

function bool SetPlayerPassword(string loginpassword)
{
    local bool bResult;

    bResult = SetProfileSettingValue(122, loginpassword);
    SetProfileDirty(true);
    return bResult;
    //return ReturnValue;    
}

function int GetNamePassSaveSettings()
{
    local int Value;

    GetProfileSettingValueInt(121, Value);
    return Value;
    //return ReturnValue;    
}

function bool SetNamePassSaveSettings(int Settings)
{
    local bool bResult;

    bResult = SetProfileSettingValueInt(121, Settings);
    SetProfileDirty(true);
    return bResult;
    //return ReturnValue;    
}

// Export UPandoraProfileSettings::execSetProfileSettingValueBlob(FFrame&, void* const)
native function SetProfileSettingValueBlob(int ProfileSettingId, array<byte> Data);

// Export UPandoraProfileSettings::execGetProfileSettingValueBlob(FFrame&, void* const)
native function GetProfileSettingValueBlob(int ProfileSettingId, out array<byte> Data);

function SaveUnlockedPDAMessageData(array<byte> MsgData)
{
    SetProfileSettingValueBlob(401, MsgData);
    SetProfileDirty(true);
    //return;    
}

function GetUnlockedPDAMessageData(out array<byte> MsgData)
{
    GetProfileSettingValueBlob(401, MsgData);
    //return;    
}

function int GetUnlockedWWTutorial()
{
    local int Value;

    GetProfileSettingValueInt(402, Value);
    return Value;
    //return ReturnValue;    
}

function bool SetUnlockedWWTutorial(int Value)
{
    local bool bResult;

    bResult = SetProfileSettingValueInt(402, Value);
    return bResult;
    //return ReturnValue;    
}

// Export UPandoraProfileSettings::execSetProfileSettingBitFlag(FFrame&, void* const)
native function bool SetProfileSettingBitFlag(int ProfileSettingId, int BitOffset);

// Export UPandoraProfileSettings::execGetProfileSettingBitFlag(FFrame&, void* const)
native function bool GetProfileSettingBitFlag(int ProfileSettingId, int BitOffset);

function bool GetAchievementFlag(int AchievmentIDFromSPA)
{
    local bool nFlag;

    nFlag = GetProfileSettingBitFlag(199, AchievmentIDFromSPA);
    return nFlag;
    //return ReturnValue;    
}

function ProfileUnlockAchievement(int AchievmentIDFromSPA, int ControllerId)
{
    local bool nFlag;
    local OnlineSubsystem OnlineSub;

    nFlag = GetProfileSettingBitFlag(199, AchievmentIDFromSPA);
    // End:0x23
    if(nFlag)
    {
        return;
    }
    nFlag = SetProfileSettingBitFlag(199, AchievmentIDFromSPA);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    SetProfileDirty(true);
    // End:0x7F
    if(!GetWorldInfo().IsConsoleBuild(2))
    {
        SetProfileForceWrite(true);
    }
    // End:0xD3
    if(OnlineSub != none)
    {
        // End:0xD3
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            OnlineSub.PlayerInterfaceEx.UnlockAchievement(byte(ControllerId), AchievmentIDFromSPA);
        }
    }
    //return;    
}

function Achievement_SinglePlayerAnimusPulseUsed(int ControllerId)
{
    local int curCount;

    // End:0x11
    if(GetAchievementFlag(39))
    {
        return;
    }
    GetProfileSettingValueInt(253, curCount);
    curCount++;
    SetProfileSettingValueInt(253, curCount);
    SetProfileDirty(true);
    // End:0x62
    if(curCount >= 10)
    {
        ProfileUnlockAchievement(39, ControllerId);
    }
    //return;    
}

function Achievement_SinglePlayerFireAxeKill(int ControllerId)
{
    local int curCount;

    // End:0x11
    if(GetAchievementFlag(38))
    {
        return;
    }
    GetProfileSettingValueInt(252, curCount);
    curCount++;
    SetProfileSettingValueInt(252, curCount);
    SetProfileDirty(true);
    // End:0x62
    if(curCount >= 25)
    {
        ProfileUnlockAchievement(38, ControllerId);
    }
    //return;    
}

function Achievement_SinglePlayerFiredWeapon(int ControllerId, SPEquippedWeaponNode.SPWeaponType eWeaponNumber)
{
    local int nWeaponNumber, allWeaponBits, curWeaponBit, curBits;

    // End:0x11
    if(GetAchievementFlag(37))
    {
        return;
    }
    nWeaponNumber = int(eWeaponNumber);
    allWeaponBits = (((((((1 << 7) | (1 << 8)) | (1 << 4)) | (1 << 2)) | (1 << 6)) | (1 << 10)) | (1 << 5)) | (1 << 3);
    curWeaponBit = 1 << nWeaponNumber;
    // End:0x7C
    if((allWeaponBits & curWeaponBit) == 0)
    {
        return;
    }
    GetProfileSettingValueInt(251, curBits);
    // End:0xA1
    if((curWeaponBit & curBits) != 0)
    {
        return;
    }
    curBits = curBits | curWeaponBit;
    SetProfileSettingValueInt(251, curBits);
    SetProfileDirty(true);
    // End:0xEF
    if(curBits == allWeaponBits)
    {
        ProfileUnlockAchievement(37, ControllerId);
    }
    //return;    
}

function Achievement_FiredWeapon(int ControllerId, SPEquippedWeaponNode.SPWeaponType eWeaponNumber)
{
    local bool bFlag;
    local int nsFlag;
    local bool bAchieved;
    local int nWeaponNumber, I, AllWeapons;

    bAchieved = false;
    AllWeapons = ((((((1 << 7) | (1 << 8)) | (1 << 4)) | (1 << 2)) | (1 << 6)) | (1 << 10)) | (1 << 11);
    nWeaponNumber = int(eWeaponNumber);
    // End:0x5B
    if(GetAchievementFlag(42))
    {
        return;
    }
    bFlag = SetProfileSettingBitFlag(242, nWeaponNumber);
    // End:0xED
    if(bFlag)
    {
        bAchieved = true;
        SetProfileDirty(true);
        I = 0;
        J0x96:

        // End:0xED [Loop If]
        if(I < 32)
        {
            nsFlag = AllWeapons & (1 << I);
            // End:0xE3
            if(nsFlag != 0)
            {
                // End:0xE3
                if(!GetProfileSettingBitFlag(242, I))
                {
                    bAchieved = false;
                    // [Explicit Break]
                    goto J0xED;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x96;
        }
    }
    J0xED:

    // End:0x107
    if(bAchieved)
    {
        ProfileUnlockAchievement(42, ControllerId);
    }
    //return;    
}

function Achievements_EndOfRankedGame(int ControllerId, bool bStarted, bool bDied, bool bWon, bool bFirstPlace, int nWerewolfKills, int nPlayerKills, int nTeamA, int nTeamB, int nAnimus)
{
    local int wincount, GameCount;

    // End:0x2B
    if(!GetAchievementFlag(41))
    {
        // End:0x2B
        if(bStarted)
        {
            ProfileUnlockAchievement(41, ControllerId);
        }
    }
    // End:0xA0
    if(!GetAchievementFlag(47))
    {
        GetProfileSettingValueInt(247, wincount);
        // End:0x7D
        if(bFirstPlace)
        {
            wincount++;
            // End:0x7A
            if(wincount >= 10)
            {
                ProfileUnlockAchievement(47, ControllerId);
            }            
        }
        else
        {
            wincount = 0;
        }
        SetProfileSettingValueInt(247, wincount);
        SetProfileDirty(true);
    }
    // End:0x102
    if(!GetAchievementFlag(49))
    {
        GetProfileSettingValueInt(249, GameCount);
        GameCount++;
        // End:0xE6
        if(GameCount >= 200)
        {
            ProfileUnlockAchievement(49, ControllerId);
        }
        SetProfileSettingValueInt(249, GameCount);
        SetProfileDirty(true);
    }
    // End:0x16D
    if(!GetAchievementFlag(50))
    {
        GetProfileSettingValueInt(250, GameCount);
        // End:0x151
        if(bWon)
        {
            GameCount++;
            // End:0x151
            if(GameCount >= 50)
            {
                ProfileUnlockAchievement(50, ControllerId);
            }
        }
        SetProfileSettingValueInt(250, GameCount);
        SetProfileDirty(true);
    }
    // End:0x21B
    if(!bDied && bStarted)
    {
        // End:0x1B1
        if(!GetAchievementFlag(44))
        {
            // End:0x1B1
            if(nWerewolfKills >= 10)
            {
                ProfileUnlockAchievement(44, ControllerId);
            }
        }
        // End:0x1DF
        if(!GetAchievementFlag(45))
        {
            // End:0x1DF
            if(nPlayerKills >= 10)
            {
                ProfileUnlockAchievement(45, ControllerId);
            }
        }
        // End:0x21B
        if((nTeamA == 4) && nTeamB == 4)
        {
            // End:0x21B
            if(!GetAchievementFlag(48))
            {
                ProfileUnlockAchievement(48, ControllerId);
            }
        }
    }
    // End:0x2C3
    if((nTeamA == 4) && nTeamB == 4)
    {
        // End:0x263
        if(!GetAchievementFlag(43))
        {
            // End:0x263
            if(nAnimus >= 50)
            {
                ProfileUnlockAchievement(43, ControllerId);
            }
        }
        // End:0x2C3
        if(!GetAchievementFlag(46))
        {
            // End:0x2C3
            if((((bStarted && bWon) && nPlayerKills >= 10) && nWerewolfKills >= 10) && nAnimus >= 25)
            {
                ProfileUnlockAchievement(46, ControllerId);
            }
        }
    }
    //return;    
}

function PandoraProfileSettings.EPandoraCompositePerformaceLevel GetVideoPerformance()
{
    local int Value;

    GetProfileSettingValueInt(403, Value);
    // End:0x47
    if(Value == -1)
    {
        Value = GetVideoPerformanceFromAppCompat();
        SetProfileSettingValueInt(403, Value);
    }
    return byte(Value);
    //return ReturnValue;    
}

function SetVideoPerformance(PandoraProfileSettings.EPandoraCompositePerformaceLevel NewPerformanceValue)
{
    SetProfileSettingValueInt(403, int(NewPerformanceValue));
    SetProfileDirty(true);
    //return;    
}

function Achievement_BookWorm(int ControllerId)
{
    // End:0x11
    if(GetAchievementFlag(35))
    {
        return;
    }
    ProfileUnlockAchievement(35, ControllerId);
    //return;    
}

function Achievement_MintInBox(int ControllerId)
{
    // End:0x11
    if(GetAchievementFlag(36))
    {
        return;
    }
    ProfileUnlockAchievement(36, ControllerId);
    //return;    
}

// Export UPandoraProfileSettings::execGetIfCanUseAmBx(FFrame&, void* const)
native function bool GetIfCanUseAmBx();

function bool IsAmBxEnabled()
{
    local int Value;

    // End:0x22
    if(GetIfCanUseAmBx())
    {
        GetProfileSettingValueId(408, Value);
    }
    // End:0x35
    if((Value & 1) == 1)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool IsAmBxFullRumbleEnabled()
{
    local int Value;

    // End:0x22
    if(GetIfCanUseAmBx())
    {
        GetProfileSettingValueId(408, Value);
    }
    // End:0x37
    if((Value & 2) == 2)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function TurnProfilesUseOfAmBxOn()
{
    local int Value;

    GetProfileSettingValueId(408, Value);
    SetProfileSettingValueId(408, Value | 1);
    SetProfileDirty(true);
    //return;    
}

function TurnProfilesUseOfAmBxOff()
{
    local int Value;

    GetProfileSettingValueId(408, Value);
    SetProfileSettingValueId(408, Value & ~1);
    SetProfileDirty(true);
    //return;    
}

function PandoraProfileSettings.EPandoraOptsDegree GetAmBxRumbleQuality()
{
    local int Value;

    GetProfileSettingValueId(413, Value);
    return byte(Value);
    //return ReturnValue;    
}

function SetAmBxRumbleQuality(PandoraProfileSettings.EPandoraOptsDegree opt)
{
    SetProfileSettingValueId(413, int(opt));
    //return;    
}

defaultproperties
{
    VersionNumber=41
    ProfileSettingIds=/* Array type was not detected. */
    DefaultSettings=/* Array type was not detected. */
    ProfileMappings=/* Array type was not detected. */
}