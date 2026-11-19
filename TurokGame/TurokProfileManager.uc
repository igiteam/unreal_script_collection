class TurokProfileManager extends ProfileManager
    transient
    native
    config(Game);

struct native TurokProfileInfo
{
    var init string mName;

    structdefaultproperties
    {
        mName=""
    }
};

struct native TurokAccountInfo
{
    var init string mName;
    var init string mEmail;
    var init string mPassword;

    structdefaultproperties
    {
        mName=""
        mEmail=""
        mPassword=""
    }
};

var globalconfig string SharedSettingsName;
var globalconfig string ProfileSettingsName;
var globalconfig string AccountSettingsName;
var globalconfig string TOCName;
var globalconfig string SaveExtension;
var init private array mDataBuffer;
var init private array mProfiles;
var private int mActiveProfile;
var private @NULL mAccount;
var private @NULL mGuestAccount;
var private int mStartProfile;
var init private string mStartFileName;
var private bool mLoadOnStart;
var private native @NULL mCriticalSection;

// Export UTurokProfileManager::execInstance(FFrame&, void* const)
native static final function @NULL Instance();

// Export UTurokProfileManager::execLoadOnStart(FFrame&, void* const)
native static function bool LoadOnStart();

// Export UTurokProfileManager::execStartFileName(FFrame&, void* const)
native static function string StartFileName();

// Export UTurokProfileManager::execStartProfile(FFrame&, void* const)
native static function int StartProfile();

// Export UTurokProfileManager::execSaveFileName(FFrame&, void* const)
native static function string SaveFileName(string baseName);

// Export UTurokProfileManager::execActiveProfile(FFrame&, void* const)
native static function int ActiveProfile();

// Export UTurokProfileManager::execActivateProfile(FFrame&, void* const)
native static function ActivateProfile(int Profile);

// Export UTurokProfileManager::execIsValidProfile(FFrame&, void* const)
native static function bool IsValidProfile(int Profile);

// Export UTurokProfileManager::execNumProfiles(FFrame&, void* const)
native static function int NumProfiles();

// Export UTurokProfileManager::execProfileName(FFrame&, void* const)
native static function string ProfileName(int Profile);

// Export UTurokProfileManager::execProfileDirectory(FFrame&, void* const)
native static function string ProfileDirectory(int Profile);

// Export UTurokProfileManager::execSave(FFrame&, void* const)
native static function Save(@NULL Profile);

// Export UTurokProfileManager::execLoad(FFrame&, void* const)
native static function Load(@NULL Profile);

// Export UTurokProfileManager::execGetDefaultProfileName(FFrame&, void* const)
native static function string GetDefaultProfileName();

// Export UTurokProfileManager::execCreateProfile(FFrame&, void* const)
native static function CreateProfile(string ProfileName);

// Export UTurokProfileManager::execDestroyProfile(FFrame&, void* const)
native static function DestroyProfile();

// Export UTurokProfileManager::execHasAccountInfo(FFrame&, void* const)
native static function bool HasAccountInfo(int Profile);

// Export UTurokProfileManager::execGetAccountInfo(FFrame&, void* const)
native static function @NULL GetAccountInfo(int Profile);

// Export UTurokProfileManager::execSetAccountInfo(FFrame&, void* const)
native static function SetAccountInfo(string accountName, string Email, string Password);

defaultproperties
{
    mActiveProfile=-1
    mStartProfile=-1
}