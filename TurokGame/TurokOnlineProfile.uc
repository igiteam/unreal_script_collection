class TurokOnlineProfile extends OnlineProfileSettings
    transient
    native
    config(Game);

const PSI_SubTitles = 35;
const PSI_Brightness = 36;
const PSI_MPPreferences = 40;
const PSI_CommonLifetimeStats = 50;
const PSI_CommonSessionStats = 51;
const PSI_MPLifetimeStats = 52;
const PSI_MPSessionStats = 53;
const PSI_Achievements = 54;
const PSI_AutoSave = 60;
const PSI_FurthestLevelEasy = 61;
const PSI_FurthestLevelMedium = 62;
const PSI_FurthestLevelHard = 63;
const PSI_FinishedGameEasyMedium = 64;

struct native MPPreferences
{
    var byte GameMode;
    var byte GameSize;
    var byte GamePlayMode;
    var bool bRanked;
    var byte GameTeam;

    structdefaultproperties
    {
        GameMode=0
        GameSize=0
        GamePlayMode=0
        bRanked=false
        GameTeam=0
    }
};

var const config @NULL DefaultMPPreferences;
var @NULL Bindings;

// Export UTurokOnlineProfile::execSetToDefaults(FFrame&, void* const)
native function SetToDefaults();

// Export UTurokOnlineProfile::execGetMPPreferences(FFrame&, void* const)
native final function GetMPPreferences(out @NULL Prefs);

// Export UTurokOnlineProfile::execSetMPPreferences(FFrame&, void* const)
native final function SetMPPreferences(out @NULL Prefs);

// Export UTurokOnlineProfile::execGetSessionStats(FFrame&, void* const)
native final function GetSessionStats(@NULL Stats);

// Export UTurokOnlineProfile::execGetLifetimeStats(FFrame&, void* const)
native final function GetLifetimeStats(@NULL Stats);

// Export UTurokOnlineProfile::execGetCommonSessionStats(FFrame&, void* const)
native final function GetCommonSessionStats(@NULL Stats);

// Export UTurokOnlineProfile::execGetCommonLifetimeStats(FFrame&, void* const)
native final function GetCommonLifetimeStats(@NULL Stats);

// Export UTurokOnlineProfile::execGetMPSessionStats(FFrame&, void* const)
native final function GetMPSessionStats(@NULL Stats);

// Export UTurokOnlineProfile::execGetMPLifetimeStats(FFrame&, void* const)
native final function GetMPLifetimeStats(@NULL Stats);

// Export UTurokOnlineProfile::execSetCommonSessionStats(FFrame&, void* const)
native final function SetCommonSessionStats(@NULL Stats);

// Export UTurokOnlineProfile::execSetCommonLifetimeStats(FFrame&, void* const)
native final function SetCommonLifetimeStats(@NULL Stats);

// Export UTurokOnlineProfile::execSetMPSessionStats(FFrame&, void* const)
native final function SetMPSessionStats(@NULL Stats);

// Export UTurokOnlineProfile::execSetMPLifetimeStats(FFrame&, void* const)
native final function SetMPLifetimeStats(@NULL Stats);

// Export UTurokOnlineProfile::execGetAchievements(FFrame&, void* const)
native final function GetAchievements(@NULL Achvs);

// Export UTurokOnlineProfile::execSetAchievements(FFrame&, void* const)
native final function SetAchievements(@NULL Achvs);

// Export UTurokOnlineProfile::execMergeCommonStats(FFrame&, void* const)
native final function MergeCommonStats(@NULL Stats);

// Export UTurokOnlineProfile::execMergeMPStats(FFrame&, void* const)
native final function MergeMPStats(@NULL Stats);

// Export UTurokOnlineProfile::execGetFurthestReachedLevel(FFrame&, void* const)
native final function GetFurthestReachedLevel(byte difficulty, out int Level);

// Export UTurokOnlineProfile::execSetFurthestReachedLevel(FFrame&, void* const)
native final function bool SetFurthestReachedLevel(int Level);

// Export UTurokOnlineProfile::execGetControllerSensitivity(FFrame&, void* const)
native final function GetControllerSensitivity(out int Value);

// Export UTurokOnlineProfile::execSetControllerSensitivity(FFrame&, void* const)
native final function bool SetControllerSensitivity(int Value);

// Export UTurokOnlineProfile::execGetControllerInversion(FFrame&, void* const)
native final function GetControllerInversion(out int Value);

// Export UTurokOnlineProfile::execSetControllerInversion(FFrame&, void* const)
native final function bool SetControllerInversion(int Value);

// Export UTurokOnlineProfile::execGetControllerVibration(FFrame&, void* const)
native final function GetControllerVibration(out int Value);

// Export UTurokOnlineProfile::execSetControllerVibration(FFrame&, void* const)
native final function bool SetControllerVibration(int Value);

// Export UTurokOnlineProfile::execCurrentProfile(FFrame&, void* const)
native static function @NULL CurrentProfile();

// Export UTurokOnlineProfile::execDebugPrint(FFrame&, void* const)
native function DebugPrint(optional string Filter);

// Export UTurokOnlineProfile::execDebugTestSerialization(FFrame&, void* const)
native function DebugTestSerialization();

// Export UTurokOnlineProfile::execSetFurthestReachedLevel_AllDifficulties(FFrame&, void* const)
native function SetFurthestReachedLevel_AllDifficulties(int Level);

defaultproperties
{
    VersionNumber=64
    ProfileSettingIds=/* Array type was not detected. */
    DefaultSettings=/* Array type was not detected. */
    ProfileMappings=/* Array type was not detected. */
}