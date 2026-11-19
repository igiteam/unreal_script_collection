class AdvProfileSettings extends OnlineProfileSettings
    native;

enum ReadedFromProfileBitField
{
    RFPBF_ControllerVibration,      // 0
    RFPBF_YInversion,               // 1
    RFPBF_ControllerSensitivity,    // 2
    RFPBF_MovementControl,          // 3
    RFPBF_MAX                       // 4
};

enum EStickConfigOpts
{
    WSCO_Default,                   // 0
    WSCO_Legacy,                    // 1
    WSCO_SouthPaw,                  // 2
    WSCO_LegacySouthpaw,            // 3
    WSCO_MAX                        // 4
};

var const int FirstPersistentDataID;
var const int LastPersistentDataID;
var const array<int> PersistentProfileIDs;

// Export UAdvProfileSettings::execGetProfileSettingValueBlob(FFrame&, void* const)
native function bool GetProfileSettingValueBlob(int ProfileSettingId, out array<byte> Value);

// Export UAdvProfileSettings::execSetProfileSettingValueBlob(FFrame&, void* const)
native function bool SetProfileSettingValueBlob(int ProfileSettingId, array<byte> Value);

// Export UAdvProfileSettings::execGetKeyBindings(FFrame&, void* const)
native function GetKeyBindings(int ProfileSettingId, out array<BindingInfo> outBindingData, out int BindingHash);

// Export UAdvProfileSettings::execSetKeyBindings(FFrame&, void* const)
native function SetKeyBindings(int ProfileSettingId, out array<BindingInfo> BindingData);

// Export UAdvProfileSettings::execGetWeaponLevels(FFrame&, void* const)
native function GetWeaponLevels(int ProfileSettingId, out array<int> outWeaponData);

// Export UAdvProfileSettings::execSetWeaponLevels(FFrame&, void* const)
native function SetWeaponLevels(int ProfileSettingId, out array<int> WeaponData);

// Export UAdvProfileSettings::execGetCustomMessages(FFrame&, void* const)
native function GetCustomMessages(int ProfileSettingId, out array<string> outMessageData);

// Export UAdvProfileSettings::execSetCustomMessages(FFrame&, void* const)
native function SetCustomMessages(int ProfileSettingId, out array<string> MessageData);

function bool IsPrimaryControllerLoggedIn()
{
    local bool bResult;
    local OnlineSubsystem OnlineSub;
    local AdvEngine Eng;
    local AdvLocalPlayer LP;

    // End:0x27
    filtereditoronly
    {
        // End:0x27
        if(Class'Engine.Engine'.static.IsEditor())
        {
            return true;
        }
    }
    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    LP = AdvLocalPlayer(Eng.GamePlayers[0]);
    bResult = false;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x16F
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        bResult = int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) > int(0);
    }
    return bResult;
    //return ReturnValue;    
}

simulated function ClearData()
{
    SetToDefaults();
    //return;    
}

simulated function ClearDataOnSignThePact()
{
    //return;    
}

static final function bool BitIsSet(int IntegerValue, int BitIndex)
{
    return (IntegerValue & (1 << BitIndex)) != 0;
    //return ReturnValue;    
}

static final function GetBytesArrayFromInt(int IntVal, out byte ByteVal[4])
{
    local int ByteMask;

    ByteMask = 255;
    ByteVal[0] = byte((IntVal >> 24) & ByteMask);
    ByteVal[1] = byte((IntVal >> 16) & ByteMask);
    ByteVal[2] = byte((IntVal >> 8) & ByteMask);
    ByteVal[3] = byte(IntVal & ByteMask);
    //return;    
}

static final function SetBytesArrayIntoInt(byte ByteVal[4], out int IntVal)
{
    IntVal = (((int(ByteVal[0]) << 24) | (int(ByteVal[1]) << 16)) | (int(ByteVal[2]) << 8)) | int(ByteVal[3]);
    //return;    
}

static function string IntToBinaryString(int InInt)
{
    local int I;
    local string ret;

    I = 32 - 1;
    J0x0F:

    // End:0x7C [Loop If]
    if(I >= 0)
    {
        // End:0x56
        if((InInt & (1 << I)) != 0)
        {
            ret = ret $ "1";            
        }
        else
        {
            ret = ret $ "0";
        }
        I--;
        // [Loop Continue]
        goto J0x0F;
    }
    return ret;
    //return ReturnValue;    
}

function int GetLevelsUnlockedMaskValueForAchiev(AdvTypes.ELevelID inLevelID)
{
    local int UnlockMaskValue;

    // End:0x2C
    if(int(inLevelID) < int(32))
    {
        GetProfileSettingValueInt(111, UnlockMaskValue);        
    }
    else
    {
        GetProfileSettingValueInt(110, UnlockMaskValue);
    }
    return UnlockMaskValue;
    //return ReturnValue;    
}

function bool MarkLevelAsCompletedForAchiev(AdvTypes.ELevelID inLevelID)
{
    local bool bResult;
    local int UnlockMaskValue, ProfileId;

    // End:0x23
    if(int(inLevelID) < int(32))
    {
        ProfileId = 111;        
    }
    else
    {
        ProfileId = 110;
    }
    UnlockMaskValue = GetLevelsUnlockedMaskValueForAchiev(inLevelID);
    bResult = SetProfileSettingValueInt(ProfileId, UnlockMaskValue | (1 << (int(inLevelID) % int(32))));
    return bResult;
    //return ReturnValue;    
}

function int GetCollectedTreasureMaps()
{
    local int UnlockMaskValue;

    GetProfileSettingValueInt(153, UnlockMaskValue);
    return UnlockMaskValue;
    //return ReturnValue;    
}

function MarkTreasureMapAsCollected(AdvTypes.ELevelID inLevelID)
{
    local int UnlockMaskValue, ProfileId;

    ProfileId = 153;
    UnlockMaskValue = GetCollectedTreasureMaps();
    SetProfileSettingValueInt(ProfileId, UnlockMaskValue | (1 << (int(inLevelID) % int(32))));
    //return;    
}

function bool HasConfiguredVideoSettings()
{
    local int Value;

    // End:0x25
    if(GetProfileSettingValueInt(52, Value))
    {
        return Value == 1;
    }
    return true;
    //return ReturnValue;    
}

function MarkAsConfiguredVideoSettings()
{
    SetProfileSettingValueInt(52, 1);
    //return;    
}

function int GetAchievementMaskProfileIDPerAchievID(int AchievID)
{
    local int maskID;

    // End:0x1F
    if(AchievID < 32)
    {
        maskID = 112;        
    }
    else
    {
        // End:0x42
        if(AchievID < (32 * 2))
        {
            maskID = 113;            
        }
        else
        {
            maskID = 114;
        }
    }
    return maskID;
    //return ReturnValue;    
}

function bool MarkAchievementAsUnlocked(int AchievID, AdvPlayerController PC, optional bool bSaveProfile = false)
{
    local int maskID;
    local bool bResult;
    local int MaskValue;

    maskID = GetAchievementMaskProfileIDPerAchievID(AchievID);
    bResult = GetProfileSettingValueInt(maskID, MaskValue);
    bResult = SetProfileSettingValueInt(maskID, MaskValue | (1 << (AchievID % 32)));
    // End:0xB0
    if(bSaveProfile)
    {
        PC.ClientSaveAllPlayerData();
    }
    return bResult;
    //return ReturnValue;    
}

function ResetAchievementsMasks()
{
    SetProfileSettingValueInt(112, 0);
    SetProfileSettingValueInt(113, 0);
    SetProfileSettingValueInt(114, 0);
    //return;    
}

function bool IsAchievementUnlocked(int AchievID)
{
    local int maskID, MaskValue;
    local bool bResult;

    maskID = GetAchievementMaskProfileIDPerAchievID(AchievID);
    GetProfileSettingValueInt(maskID, MaskValue);
    bResult = BitIsSet(MaskValue, AchievID % 32);
    return bResult;
    //return ReturnValue;    
}

function bool GetShowSubtitles(optional bool bForceReadFromProfile = false)
{
    local int Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueInt(55, Value);        
    }
    else
    {
        Value = Eng.Subtitles;
    }
    return ((Value == 1) ? true : false);
    //return ReturnValue;    
}

function bool GetShowTutorials(optional bool bForceReadFromProfile = false)
{
    local int Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueInt(82, Value);        
    }
    else
    {
        return Eng.IsTutorialsVisible();
    }
    return ((Value == 1) ? true : false);
    //return ReturnValue;    
}

function int GetCrosshairType(optional bool bForceReadFromProfile = false)
{
    local int Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueInt(56, Value);        
    }
    else
    {
        Value = Eng.Crosshair;
    }
    return Value;
    //return ReturnValue;    
}

function float GetMasterVolume(optional bool bForceReadFromProfile = false)
{
    local float Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueFloat(57, Value);        
    }
    else
    {
        Value = Eng.MasterVolume;
    }
    return Value;
    //return ReturnValue;    
}

function float GetMusicVolume(optional bool bForceReadFromProfile = false)
{
    local float Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueFloat(58, Value);        
    }
    else
    {
        Value = Eng.MusicVolume;
    }
    return Value;
    //return ReturnValue;    
}

function float GetSFXVolume(optional bool bForceReadFromProfile = false)
{
    local float Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueFloat(59, Value);        
    }
    else
    {
        Value = Eng.EffectsVolume;
    }
    return Value;
    //return ReturnValue;    
}

function float GetVoiceVolume(optional bool bForceReadFromProfile = false)
{
    local float Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueFloat(68, Value);        
    }
    else
    {
        Value = Eng.VoiceVolume;
    }
    return Value;
    //return ReturnValue;    
}

function float GetGamma(optional bool bForceReadFromProfile = false)
{
    local float Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueFloat(63, Value);        
    }
    else
    {
        Value = Eng.Gamma;
    }
    return Value;
    //return ReturnValue;    
}

function bool GetAimZoomToggle(optional bool bForceReadFromProfile = false)
{
    local int Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueInt(49, Value);        
    }
    else
    {
        Value = Eng.AimZoomToggle;
    }
    return ((Value == 1) ? true : false);
    //return ReturnValue;    
}

function float GetFOV()
{
    local float Value;

    GetProfileSettingValueFloat(50, Value);
    return Value;
    //return ReturnValue;    
}

function int GetDynLightsSettings()
{
    local int Value;

    GetProfileSettingValueInt(61, Value);
    return Value;
    //return ReturnValue;    
}

function float GetSensitivity(optional bool bForceReadFromProfile = false)
{
    local float Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueFloat(66, Value);        
    }
    else
    {
        Value = Eng.Sensitivity;
    }
    return Value;
    //return ReturnValue;    
}

function float GetMouseSensitivity()
{
    local float Value;

    GetProfileSettingValueFloat(53, Value);
    return Value;
    //return ReturnValue;    
}

function bool GetMouseSmoothing()
{
    local int Value;

    GetProfileSettingValueInt(51, Value);
    return ((Value == 1) ? true : false);
    //return ReturnValue;    
}

function bool SetSelectedDeviceId(int InDeviceId)
{
    return SetProfileSettingValueInt(80, InDeviceId);
    //return ReturnValue;    
}

function bool GetSelectedDeviceId(out int OutDeviceId)
{
    return GetProfileSettingValueInt(80, OutDeviceId);
    //return ReturnValue;    
}

function bool HasControllerSensitivityPrefBeenRead()
{
    local int IsFresh;

    GetProfileSettingValueInt(84, IsFresh);
    return BitIsSet(IsFresh, 2);
    //return ReturnValue;    
}

function MarkControllerSensitivityAsRead()
{
    local int IsFresh;

    GetProfileSettingValueInt(84, IsFresh);
    SetProfileSettingValueInt(84, IsFresh | (1 << 2));
    //return;    
}

function bool GetControllerVibrationOption(optional bool bForceReadFromProfile = false)
{
    local bool Retval;
    local int Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6B
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueId(1, Value);        
    }
    else
    {
        Value = Eng.Vibration;
    }
    switch(Value)
    {
        // End:0xBA
        case 3:
            Retval = true;
            // End:0xDF
            break;
        // End:0xCD
        case 0:
            Retval = false;
            // End:0xDF
            break;
        // End:0xFFFF
        default:
            Retval = true;
            // End:0xDF
            break;
            break;
    }
    return Retval;
    //return ReturnValue;    
}

function bool GetInvertY(optional bool bForceReadFromProfile = false)
{
    local bool Retval;
    local int Value;
    local AdvEngine Eng;

    // End:0x127
    if(Class'Engine.WorldInfo'.static.GetWorldInfo().IsConsoleBuild(1))
    {
        Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
        // End:0xA6
        if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
        {
            GetProfileSettingValueId(2, Value);            
        }
        else
        {
            Value = Eng.LookInversion;
        }
        switch(Value)
        {
            // End:0xF4
            case 1:
                Retval = true;
                // End:0x119
                break;
            // End:0x107
            case 0:
                Retval = false;
                // End:0x119
                break;
            // End:0xFFFF
            default:
                Retval = false;
                // End:0x119
                break;
                break;
        }
        return Retval;        
    }
    else
    {
        GetProfileSettingValueInt(54, Value);
        return bool(Value);
    }
    //return ReturnValue;    
}

function UpdateControllerSensitivity()
{
    local int IntVal;
    local float RotValue;

    // End:0x9D
    if(!HasControllerSensitivityPrefBeenRead())
    {
        GetProfileSettingValueId(13, IntVal);
        switch(IntVal)
        {
            // End:0x4E
            case 1:
                RotValue = 0.6000000;
                // End:0x7E
                break;
            // End:0x65
            case 2:
                RotValue = 2.2000000;
                // End:0x7E
                break;
            // End:0x69
            case 0:
            // End:0xFFFF
            default:
                RotValue = 1.5000000;
                // End:0x7E
                break;
                break;
        }
        SetProfileSettingValueFloat(66, RotValue);
        MarkControllerSensitivityAsRead();
    }
    //return;    
}

function MarkStickConfigAsRead()
{
    local int IsFresh;

    GetProfileSettingValueInt(84, IsFresh);
    SetProfileSettingValueInt(84, IsFresh | (1 << 3));
    //return;    
}

function bool HasStickConfigPrefBeenRead()
{
    local int IsFresh;

    GetProfileSettingValueInt(84, IsFresh);
    return BitIsSet(IsFresh, 3);
    //return ReturnValue;    
}

function UpdateGearStickConfig()
{
    local int IntVal, OutVal;

    // End:0x62
    if(!HasStickConfigPrefBeenRead())
    {
        GetProfileSettingValueId(18, IntVal);
        OutVal = ((IntVal == 0) ? 0 : 2);
        SetProfileSettingValueId(67, OutVal);
        MarkStickConfigAsRead();
    }
    //return;    
}

function AdvProfileSettings.EStickConfigOpts GetStickConfigOption(optional bool bForceReadFromProfile = false)
{
    local AdvProfileSettings.EStickConfigOpts Retval;
    local int Value;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x6C
    if((IsPrimaryControllerLoggedIn()) || bForceReadFromProfile)
    {
        GetProfileSettingValueId(67, Value);        
    }
    else
    {
        Value = Eng.ButtonLayout;
    }
    switch(Value)
    {
        // End:0xBA
        case 1:
            Retval = 1;
            // End:0xF8
            break;
        // End:0xCE
        case 2:
            Retval = 2;
            // End:0xF8
            break;
        // End:0xE2
        case 3:
            Retval = 3;
            // End:0xF8
            break;
        // End:0xE6
        case 0:
        // End:0xFFFF
        default:
            Retval = 0;
            // End:0xF8
            break;
            break;
    }
    return Retval;
    //return ReturnValue;    
}

function AdvTypes.EPKPartyType GetPartyType()
{
    local int Value, ListIndex;

    // End:0x53
    if(GetProfileSettingValueId(88, Value))
    {
        // End:0x47
        if(Value == 2)
        {
            GetProfileSettingDefaultId(88, Value, ListIndex);
        }
        return byte(Value);
    }
    return 1;
    //return ReturnValue;    
}

function SetPartyType(AdvTypes.EPKPartyType PartyType)
{
    local int Value, ListIndex;

    // End:0x47
    if(int(PartyType) == int(2))
    {
        GetProfileSettingDefaultId(88, Value, ListIndex);
        PartyType = byte(Value);
    }
    SetProfileSettingValueId(88, int(PartyType));
    //return;    
}

simulated function bool IsLevelCompleted(AdvTypes.ELevelID inLevelID)
{
    local int UnlockMaskValue;

    UnlockMaskValue = 0;
    return BitIsSet(UnlockMaskValue, int(inLevelID));
    //return ReturnValue;    
}

final function int GetDaysInMonth(int Year, int Month)
{
    local int DaysInMonth;
    local bool bIsLeapYear, bIsDiv4, bIsDiv100, bIsDiv400;

    bIsDiv4 = (Year % 4) == 0;
    bIsDiv100 = (Year % 100) == 0;
    bIsDiv400 = (Year % 400) == 0;
    bIsLeapYear = (bIsDiv4 && !bIsDiv100) || bIsDiv400;
    DaysInMonth = 31;
    // End:0xD0
    if(Month == 2)
    {
        // End:0xC1
        if(bIsLeapYear)
        {
            DaysInMonth = 29;            
        }
        else
        {
            DaysInMonth = 28;
        }        
    }
    else
    {
        // End:0x122
        if((((Month == 4) || Month == 6) || Month == 9) || Month == 11)
        {
            DaysInMonth = 30;
        }
    }
    return DaysInMonth;
    //return ReturnValue;    
}

final function int GetElapsedMinutes(int Year, int Month, int Day, int Hour, int Min)
{
    local int MonthIdx, TotalDays;

    TotalDays = Clamp(Day, 0, GetDaysInMonth(Year, Month));
    MonthIdx = 1;
    J0x3D:

    // End:0x89 [Loop If]
    if(MonthIdx < Month)
    {
        TotalDays += GetDaysInMonth(Year, MonthIdx);
        MonthIdx++;
        // [Loop Continue]
        goto J0x3D;
    }
    return (((TotalDays * 24) + Hour) * 60) + Min;
    //return ReturnValue;    
}

final function ReadBandwidthHistory(out array<ConnectionBandwidthStats> BandwidthHistory, out int MinutesSinceLastTest)
{
    local int Year, Month, DayOfWeek, Day, Hour, Min,
	    Sec, MSec, MinutesSinceYear, MinutesSinceYearLast, UpstreamRate,
	    CurBandwidthHistorySize;

    GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
    MinutesSinceYear = GetElapsedMinutes(Year, Month, Day, Hour, Min);
    GetProfileSettingValueInt(98, MinutesSinceYearLast);
    // End:0xE8
    if(MinutesSinceYearLast > MinutesSinceYear)
    {
        MinutesSinceYear += GetElapsedMinutes(Year - 1, 12, 31, 23, 59);
    }
    MinutesSinceLastTest = MinutesSinceYear - MinutesSinceYearLast;
    GetProfileSettingValueInt(104, CurBandwidthHistorySize);
    BandwidthHistory.Length = 0;
    // End:0x19C
    if((CurBandwidthHistorySize > 0) && GetProfileSettingValueInt(99, UpstreamRate))
    {
        BandwidthHistory.Length = BandwidthHistory.Length + 1;
        BandwidthHistory[BandwidthHistory.Length - 1].UpstreamRate = UpstreamRate;
    }
    // End:0x211
    if((CurBandwidthHistorySize > 1) && GetProfileSettingValueInt(100, UpstreamRate))
    {
        BandwidthHistory.Length = BandwidthHistory.Length + 1;
        BandwidthHistory[BandwidthHistory.Length - 1].UpstreamRate = UpstreamRate;
    }
    // End:0x287
    if((CurBandwidthHistorySize > 2) && GetProfileSettingValueInt(101, UpstreamRate))
    {
        BandwidthHistory.Length = BandwidthHistory.Length + 1;
        BandwidthHistory[BandwidthHistory.Length - 1].UpstreamRate = UpstreamRate;
    }
    // End:0x2FD
    if((CurBandwidthHistorySize > 3) && GetProfileSettingValueInt(102, UpstreamRate))
    {
        BandwidthHistory.Length = BandwidthHistory.Length + 1;
        BandwidthHistory[BandwidthHistory.Length - 1].UpstreamRate = UpstreamRate;
    }
    // End:0x373
    if((CurBandwidthHistorySize > 4) && GetProfileSettingValueInt(103, UpstreamRate))
    {
        BandwidthHistory.Length = BandwidthHistory.Length + 1;
        BandwidthHistory[BandwidthHistory.Length - 1].UpstreamRate = UpstreamRate;
    }
    //return;    
}

function AdjustGoodHostRatio(float GoodHostDelta)
{
    local float CurGoodHostRatio;

    GetProfileSettingValueFloat(105, CurGoodHostRatio);
    CurGoodHostRatio = FClamp(CurGoodHostRatio + GoodHostDelta, 0.0000000, 1.0000000);
    SetProfileSettingValueFloat(105, CurGoodHostRatio);
    //return;    
}

function float GetGoodHostRatio()
{
    local float CurGoodHostRatio;

    GetProfileSettingValueFloat(105, CurGoodHostRatio);
    return CurGoodHostRatio;
    //return ReturnValue;    
}

function ResetGoodHostRatio()
{
    SetProfileSettingValueFloat(105, 1.0000000);
    //return;    
}

final function GetMPCustomClassInfo(int CustomClassIndex, out byte ClassData[4])
{
    local int Data;

    switch(CustomClassIndex)
    {
        // End:0x2F
        case 0:
            GetProfileSettingValueInt(37, Data);
            // End:0xA5
            break;
        // End:0x4B
        case 1:
            GetProfileSettingValueInt(38, Data);
            // End:0xA5
            break;
        // End:0x68
        case 2:
            GetProfileSettingValueInt(39, Data);
            // End:0xA5
            break;
        // End:0x85
        case 3:
            GetProfileSettingValueInt(40, Data);
            // End:0xA5
            break;
        // End:0xA2
        case 4:
            GetProfileSettingValueInt(41, Data);
            // End:0xA5
            break;
        // End:0xFFFF
        default:
            break;
    }
    GetBytesArrayFromInt(Data, ClassData);
    //return;    
}

final function SaveMPCustomClassInfo(int CustomClassIndex, byte ClassData[4])
{
    local int Data;

    SetBytesArrayIntoInt(ClassData, Data);
    switch(CustomClassIndex)
    {
        // End:0x4B
        case 0:
            SetProfileSettingValueInt(37, Data);
            // End:0xC1
            break;
        // End:0x67
        case 1:
            SetProfileSettingValueInt(38, Data);
            // End:0xC1
            break;
        // End:0x84
        case 2:
            SetProfileSettingValueInt(39, Data);
            // End:0xC1
            break;
        // End:0xA1
        case 3:
            SetProfileSettingValueInt(40, Data);
            // End:0xC1
            break;
        // End:0xBE
        case 4:
            SetProfileSettingValueInt(41, Data);
            // End:0xC1
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

final function SaveBandwidthHistory(const out array<ConnectionBandwidthStats> BandwidthHistory)
{
    local int Year, Month, DayOfWeek, Day, Hour, Min,
	    Sec, MSec, MinutesSinceYear;

    GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
    MinutesSinceYear = GetElapsedMinutes(Year, Month, Day, Hour, Min);
    SetProfileSettingValueInt(98, MinutesSinceYear);
    SetProfileSettingValueInt(104, BandwidthHistory.Length);
    SetProfileSettingValueInt(99, 0);
    SetProfileSettingValueInt(100, 0);
    SetProfileSettingValueInt(101, 0);
    SetProfileSettingValueInt(102, 0);
    SetProfileSettingValueInt(103, 0);
    // End:0x139
    if(BandwidthHistory.Length > 0)
    {
        SetProfileSettingValueInt(99, BandwidthHistory[0].UpstreamRate);
    }
    // End:0x173
    if(BandwidthHistory.Length > 1)
    {
        SetProfileSettingValueInt(100, BandwidthHistory[1].UpstreamRate);
    }
    // End:0x1AF
    if(BandwidthHistory.Length > 2)
    {
        SetProfileSettingValueInt(101, BandwidthHistory[2].UpstreamRate);
    }
    // End:0x1EB
    if(BandwidthHistory.Length > 3)
    {
        SetProfileSettingValueInt(102, BandwidthHistory[3].UpstreamRate);
    }
    // End:0x227
    if(BandwidthHistory.Length > 4)
    {
        SetProfileSettingValueInt(103, BandwidthHistory[4].UpstreamRate);
    }
    //return;    
}

final function SaveTreasuresSPData(byte TreasuresCollected[4], byte TreasuresAvailable[4])
{
    local byte Data[4];
    local int IntVal;

    Data[0] = TreasuresCollected[0];
    Data[1] = TreasuresAvailable[0];
    Data[2] = TreasuresCollected[1];
    Data[3] = TreasuresAvailable[1];
    SetBytesArrayIntoInt(Data, IntVal);
    SetProfileSettingValueInt(43, IntVal);
    Data[0] = TreasuresCollected[2];
    Data[1] = TreasuresAvailable[2];
    Data[2] = TreasuresCollected[3];
    Data[3] = TreasuresAvailable[3];
    SetBytesArrayIntoInt(Data, IntVal);
    SetProfileSettingValueInt(44, IntVal);
    //return;    
}

final function GetTreasuresSPData(out byte TreasuresCollected[4], out byte TreasuresAvailable[4])
{
    local byte Data[4];
    local int IntVal;

    GetProfileSettingValueInt(43, IntVal);
    GetBytesArrayFromInt(IntVal, Data);
    TreasuresCollected[0] = Data[0];
    TreasuresAvailable[0] = Data[1];
    TreasuresCollected[1] = Data[2];
    TreasuresAvailable[1] = Data[3];
    GetProfileSettingValueInt(44, IntVal);
    GetBytesArrayFromInt(IntVal, Data);
    TreasuresCollected[2] = Data[0];
    TreasuresAvailable[2] = Data[1];
    TreasuresCollected[3] = Data[2];
    TreasuresAvailable[3] = Data[3];
    //return;    
}

final function SaveUpgradesSPData(byte UpgradeLevels[8])
{
    local byte Data[4];
    local int I, IntVal;

    I = 0;
    J0x0B:

    // End:0x50 [Loop If]
    if(I < 4)
    {
        Data[I] = UpgradeLevels[I];
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    SetBytesArrayIntoInt(Data, IntVal);
    SetProfileSettingValueInt(45, IntVal);
    I = 0;
    J0x8C:

    // End:0xD5 [Loop If]
    if(I < 4)
    {
        Data[I] = UpgradeLevels[I + 4];
        I++;
        // [Loop Continue]
        goto J0x8C;
    }
    SetBytesArrayIntoInt(Data, IntVal);
    SetProfileSettingValueInt(46, IntVal);
    //return;    
}

final function GetUpgradesSPData(out byte UpgradeLevels[8])
{
    local byte Data[4];
    local int I, IntVal;

    GetProfileSettingValueInt(45, IntVal);
    GetBytesArrayFromInt(IntVal, Data);
    I = 0;
    J0x3C:

    // End:0x81 [Loop If]
    if(I < 4)
    {
        UpgradeLevels[I] = Data[I];
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    GetProfileSettingValueInt(46, IntVal);
    GetBytesArrayFromInt(IntVal, Data);
    I = 0;
    J0xBD:

    // End:0x106 [Loop If]
    if(I < 4)
    {
        UpgradeLevels[I + 4] = Data[I];
        I++;
        // [Loop Continue]
        goto J0xBD;
    }
    //return;    
}

function bool GetPreorderWeaponSelected()
{
    local int Value;

    GetProfileSettingValueInt(83, Value);
    return ((Value == 1) ? true : false);
    //return ReturnValue;    
}

defaultproperties
{
    FirstPersistentDataID=87
    LastPersistentDataID=137
    ProfileSettingIds=/* Array type was not detected. */
    DefaultSettings=/* Array type was not detected. */
    VersionNumber=91
    ProfileMappings=/* Array type was not detected. */
}