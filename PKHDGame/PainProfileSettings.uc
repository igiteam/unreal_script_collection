class PainProfileSettings extends OnlineProfileSettings
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

// Export UPainProfileSettings::execGetProfileSettingValueBlob(FFrame&, void* const)
native function bool GetProfileSettingValueBlob(int ProfileSettingId, out array<byte> Value);

// Export UPainProfileSettings::execSetProfileSettingValueBlob(FFrame&, void* const)
native function bool SetProfileSettingValueBlob(int ProfileSettingId, array<byte> Value);

// Export UPainProfileSettings::execGetKeyBindings(FFrame&, void* const)
native function GetKeyBindings(int ProfileSettingId, out array<BindingInfo> outBindingData, out int BindingHash);

// Export UPainProfileSettings::execSetKeyBindings(FFrame&, void* const)
native function SetKeyBindings(int ProfileSettingId, out array<BindingInfo> BindingData);

// Export UPainProfileSettings::execGetCustomMessages(FFrame&, void* const)
native function GetCustomMessages(int ProfileSettingId, out array<string> outMessageData);

// Export UPainProfileSettings::execSetCustomMessages(FFrame&, void* const)
native function SetCustomMessages(int ProfileSettingId, out array<string> MessageData);

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

function SetGold(int Gold)
{
    SetProfileSettingValueInt(106, Gold);
    //return;    
}

function int GetGold()
{
    local int IntVal;

    GetProfileSettingValueInt(106, IntVal);
    return IntVal;
    //return ReturnValue;    
}

simulated function bool HasUnlockedSilverCard(PKTarotManager.ESilverTarrotCard card)
{
    local int UnlockMaskValue;
    local bool bResult;

    // End:0x3F
    if(GetProfileSettingValueInt(107, UnlockMaskValue))
    {
        bResult = (UnlockMaskValue & (1 << int(card))) != 0;
    }
    return bResult;
    //return ReturnValue;    
}

simulated function bool HasUnlockedGoldCard(PKTarotManager.EGoldenTarrotCard card)
{
    local int UnlockMaskValue;
    local bool bResult;

    // End:0x3F
    if(GetProfileSettingValueInt(108, UnlockMaskValue))
    {
        bResult = (UnlockMaskValue & (1 << int(card))) != 0;
    }
    return bResult;
    //return ReturnValue;    
}

simulated function int GetGoldCardUnlockMaskValue()
{
    local int UnlockMaskValue;

    GetProfileSettingValueInt(108, UnlockMaskValue);
    return UnlockMaskValue;
    //return ReturnValue;    
}

simulated function int GetSilverCardUnlockMaskValue()
{
    local int UnlockMaskValue;

    GetProfileSettingValueInt(107, UnlockMaskValue);
    return UnlockMaskValue;
    //return ReturnValue;    
}

simulated function bool MarkSilverCardAsUnlocked(PKTarotManager.ESilverTarrotCard card, PKPlayerController PC, optional bool bSaveProfile = true)
{
    local bool bResult;
    local int UnlockMaskValue;

    // End:0x91
    if(!HasUnlockedSilverCard(card))
    {
        GetProfileSettingValueInt(107, UnlockMaskValue);
        SetProfileSettingValueInt(107, UnlockMaskValue | (1 << int(card)));
        // End:0x85
        if(bSaveProfile)
        {
            PC.ClientSaveAllPlayerData();
        }
        bResult = true;
    }
    return bResult;
    //return ReturnValue;    
}

simulated function bool MarkGoldCardAsUnlocked(PKTarotManager.EGoldenTarrotCard card, PKPlayerController PC, optional bool bSaveProfile = true)
{
    local bool bResult;
    local int UnlockMaskValue;

    // End:0x91
    if(!HasUnlockedGoldCard(card))
    {
        GetProfileSettingValueInt(108, UnlockMaskValue);
        SetProfileSettingValueInt(108, UnlockMaskValue | (1 << int(card)));
        // End:0x85
        if(bSaveProfile)
        {
            PC.ClientSaveAllPlayerData();
        }
        bResult = true;
    }
    return bResult;
    //return ReturnValue;    
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

simulated function int GetLevelsUnlockedMaskValueForAchiev()
{
    local int UnlockMaskValue;

    GetProfileSettingValueInt(104, UnlockMaskValue);
    return UnlockMaskValue;
    //return ReturnValue;    
}

simulated function bool MarkLevelAsCompletedForAchiev(PKTypes.ELevelID inLevelID)
{
    local bool bResult;
    local int UnlockMaskValue;

    UnlockMaskValue = GetLevelsUnlockedMaskValueForAchiev();
    bResult = SetProfileSettingValueInt(104, UnlockMaskValue | (1 << int(inLevelID)));
    return bResult;
    //return ReturnValue;    
}

simulated function int GetCOOPLevelsUnlockedMaskValueForAchiev()
{
    local int UnlockMaskValue;

    GetProfileSettingValueInt(112, UnlockMaskValue);
    return UnlockMaskValue;
    //return ReturnValue;    
}

function bool MarkCOOPLevelAsCompletedForAchiev(PKTypes.ELevelID inLevelID)
{
    local bool bResult;
    local int UnlockMaskValue;

    UnlockMaskValue = GetCOOPLevelsUnlockedMaskValueForAchiev();
    bResult = SetProfileSettingValueInt(112, UnlockMaskValue | (1 << int(inLevelID)));
    return bResult;
    //return ReturnValue;    
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

simulated function int GetAchievementMaskProfileIDPerAchievID(int AchievID)
{
    local int maskID;

    // End:0x1F
    if(AchievID < 32)
    {
        maskID = 109;        
    }
    else
    {
        // End:0x42
        if(AchievID < (32 * 2))
        {
            maskID = 110;            
        }
        else
        {
            maskID = 111;
        }
    }
    return maskID;
    //return ReturnValue;    
}

simulated function bool MarkAchievementAsUnlocked(int AchievID, PKPlayerController PC, optional bool bSaveProfile = false)
{
    local int maskID;
    local bool bResult;
    local int MaskValue;

    // End:0x92
    if(AchievID <= 95)
    {
        maskID = GetAchievementMaskProfileIDPerAchievID(AchievID);
        bResult = GetProfileSettingValueInt(maskID, MaskValue);
        bResult = SetProfileSettingValueInt(maskID, MaskValue | (1 << (AchievID % 32)));
    }
    // End:0xC0
    if(bSaveProfile)
    {
        PC.ClientSaveAllPlayerData();
    }
    return bResult;
    //return ReturnValue;    
}

function ResetAchievementsMasks()
{
    SetProfileSettingValueInt(109, 0);
    SetProfileSettingValueInt(110, 0);
    SetProfileSettingValueInt(111, 0);
    //return;    
}

simulated function bool IsAchievementUnlocked(int AchievID)
{
    local int maskID, MaskValue;
    local bool bResult;

    // End:0x12
    if(AchievID > 95)
    {
        return false;
    }
    maskID = GetAchievementMaskProfileIDPerAchievID(AchievID);
    GetProfileSettingValueInt(maskID, MaskValue);
    bResult = BitIsSet(MaskValue, AchievID % 32);
    return bResult;
    //return ReturnValue;    
}

function bool GetShowSubtitles()
{
    local int Value;

    GetProfileSettingValueInt(55, Value);
    return ((Value == 1) ? true : false);
    //return ReturnValue;    
}

function int GetCrosshairType()
{
    local int Value;

    GetProfileSettingValueInt(56, Value);
    return Value;
    //return ReturnValue;    
}

function float GetMasterVolume()
{
    local float Value;

    GetProfileSettingValueFloat(57, Value);
    return Value;
    //return ReturnValue;    
}

function float GetMusicVolume()
{
    local float Value;

    GetProfileSettingValueFloat(58, Value);
    return Value;
    //return ReturnValue;    
}

function float GetSFXVolume()
{
    local float Value;

    GetProfileSettingValueFloat(59, Value);
    return Value;
    //return ReturnValue;    
}

function float GetGamma()
{
    local float Value;

    GetProfileSettingValueFloat(63, Value);
    return Value;
    //return ReturnValue;    
}

function float GetFOV()
{
    local float Value;

    GetProfileSettingValueFloat(83, Value);
    return Value;
    //return ReturnValue;    
}

function float GetHUDScale()
{
    local float Value;

    GetProfileSettingValueFloat(89, Value);
    return Value;
    //return ReturnValue;    
}

function float GetHeadBob()
{
    local float Value;

    GetProfileSettingValueFloat(81, Value);
    return Value;
    //return ReturnValue;    
}

function float GetWeaponBobDamping()
{
    local float Value;

    GetProfileSettingValueFloat(82, Value);
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

function float GetSensitivity()
{
    local float Value;

    GetProfileSettingValueFloat(66, Value);
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

function bool GetControllerVibrationOption()
{
    local bool Retval;
    local int Value;

    GetProfileSettingValueId(1, Value);
    switch(Value)
    {
        // End:0x3C
        case 3:
            Retval = true;
            // End:0x61
            break;
        // End:0x4F
        case 0:
            Retval = false;
            // End:0x61
            break;
        // End:0xFFFF
        default:
            Retval = true;
            // End:0x61
            break;
            break;
    }
    return Retval;
    //return ReturnValue;    
}

function bool GetInvertY()
{
    local bool Retval;
    local int Value;

    // End:0xA9
    if(Class'Engine.WorldInfo'.static.GetWorldInfo().IsConsoleBuild(1))
    {
        GetProfileSettingValueId(2, Value);
        switch(Value)
        {
            // End:0x76
            case 1:
                Retval = true;
                // End:0x9B
                break;
            // End:0x89
            case 0:
                Retval = false;
                // End:0x9B
                break;
            // End:0xFFFF
            default:
                Retval = false;
                // End:0x9B
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
                RotValue = 0.5000000;
                // End:0x7E
                break;
            // End:0x65
            case 2:
                RotValue = 2.0000000;
                // End:0x7E
                break;
            // End:0x69
            case 0:
            // End:0xFFFF
            default:
                RotValue = 1.0000000;
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

function PainProfileSettings.EStickConfigOpts GetStickConfigOption()
{
    local PainProfileSettings.EStickConfigOpts Retval;
    local int Value;

    GetProfileSettingValueId(67, Value);
    switch(Value)
    {
        // End:0x3C
        case 1:
            Retval = 1;
            // End:0x7A
            break;
        // End:0x50
        case 2:
            Retval = 2;
            // End:0x7A
            break;
        // End:0x64
        case 3:
            Retval = 3;
            // End:0x7A
            break;
        // End:0x68
        case 0:
        // End:0xFFFF
        default:
            Retval = 0;
            // End:0x7A
            break;
            break;
    }
    return Retval;
    //return ReturnValue;    
}

defaultproperties
{
    FirstPersistentDataID=91
    LastPersistentDataID=128
    ProfileSettingIds=/* Array type was not detected. */
    DefaultSettings=/* Array type was not detected. */
    VersionNumber=66
    ProfileMappings=/* Array type was not detected. */
}