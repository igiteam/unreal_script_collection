class TurokAchievements extends Object
    native;

const MAX_NUM_ACHIEVEMENTS = 43;

enum eAchievementStatsSet
{
    ASS_Singleplayer,               // 0
    ASS_Multiplayer,                // 1
    ASS_Both,                       // 2
    ASS_MAX                         // 3
};

struct native AchievementMetaData
{
    var int Id;
    var bool ShowsProgress;
    var byte StatId;
    var byte StatSet;
    var int NameHash;
    var int LockedDescHash;
    var int UnlockedDescHash;
    var string IconString;

    structdefaultproperties
    {
        Id=0
        ShowsProgress=false
        StatId=0
        StatSet=0
        NameHash=0
        LockedDescHash=0
        UnlockedDescHash=0
        IconString=""
    }
};

var protected const @NULL kDummyMetaData;
var protected const @NULL kAchievementMetaData[43];
var array mAchievements;
var bool mbIsAchievementDataValid;
//var delegate<@NULL> __OnReadComplete__Delegate;

// Export UTurokAchievements::execUnlockAchievement(FFrame&, void* const)
native final function UnlockAchievement(int Id);

// Export UTurokAchievements::execReadFromProfile(FFrame&, void* const)
native function ReadFromProfile(@NULL Profile);

// Export UTurokAchievements::execReadFromOnlineSubsystem(FFrame&, void* const)
native function ReadFromOnlineSubsystem(delegate<@NULL> ReadCompleteDelegate);

delegate OnReadComplete(bool success)
{
    //return;    
}

// Export UTurokAchievements::execGetNumAchievements(FFrame&, void* const)
native final function int GetNumAchievements();

// Export UTurokAchievements::execGetNameAt(FFrame&, void* const)
native final function string GetNameAt(int Index);

// Export UTurokAchievements::execIsAchievementUnlocked(FFrame&, void* const)
native final function bool IsAchievementUnlocked(int Id);

// Export UTurokAchievements::execIsAchievementUnlockedAt(FFrame&, void* const)
native final function bool IsAchievementUnlockedAt(int Index);

// Export UTurokAchievements::execIsAchievementDataValid(FFrame&, void* const)
native final function bool IsAchievementDataValid();

// Export UTurokAchievements::execGetPointValueAt(FFrame&, void* const)
native final function int GetPointValueAt(int Index);

// Export UTurokAchievements::execGetIconStringAt(FFrame&, void* const)
native final function string GetIconStringAt(int Index, bool IsUnlocked);

// Export UTurokAchievements::execGetDescriptionAt(FFrame&, void* const)
native final function string GetDescriptionAt(int Index, @NULL SPStats, @NULL MPStats);

// Export UTurokAchievements::execInvalidate(FFrame&, void* const)
native final function Invalidate();

// Export UTurokAchievements::execGetMetaData(FFrame&, void* const)
protected native final function @NULL GetMetaData(int Id);

protected event RegisterDelegates(@NULL OS)
{
    // End:0xBD
    if(NotEqual_InterfaceInterface(OS.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        OS.PlayerInterfaceEx.SetReadAchievementsDelegate(0, NotifyReadAchievementsComplete);
        OS.PlayerInterfaceEx.SetReadAchievementsDelegate(1, NotifyReadAchievementsComplete);
        OS.PlayerInterfaceEx.SetReadAchievementsDelegate(2, NotifyReadAchievementsComplete);
        OS.PlayerInterfaceEx.SetReadAchievementsDelegate(3, NotifyReadAchievementsComplete);
    }
    //return;    
}

protected event UnregisterDelegates(@NULL OS)
{
    // End:0xBD
    if(NotEqual_InterfaceInterface(OS.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        OS.PlayerInterfaceEx.SetReadAchievementsDelegate(0, None);
        OS.PlayerInterfaceEx.SetReadAchievementsDelegate(1, None);
        OS.PlayerInterfaceEx.SetReadAchievementsDelegate(2, None);
        OS.PlayerInterfaceEx.SetReadAchievementsDelegate(3, None);
    }
    __OnReadComplete__Delegate = None;
    //return;    
}

// Export UTurokAchievements::execNotifyReadAchievementsComplete(FFrame&, void* const)
protected native final function NotifyReadAchievementsComplete(bool success);

// Export UTurokAchievements::execDebugPrint(FFrame&, void* const)
native final function DebugPrint();

defaultproperties
{
    kDummyMetaData=(Id=-1,ShowsProgress=false,StatId=0,StatSet=0,NameHash=0,LockedDescHash=0,UnlockedDescHash=0,IconString="")
    kAchievementMetaData[0]=(Id=10,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-761990793,LockedDescHash=-1495189003,UnlockedDescHash=144618216,IconString="")
    kAchievementMetaData[1]=(Id=11,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-171369606,LockedDescHash=1148551900,UnlockedDescHash=961761499,IconString="")
    kAchievementMetaData[2]=(Id=12,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-1175306143,LockedDescHash=-1595233435,UnlockedDescHash=2032950079,IconString="")
    kAchievementMetaData[3]=(Id=13,ShowsProgress=false,StatId=0,StatSet=0,NameHash=500072744,LockedDescHash=-435958843,UnlockedDescHash=1871851232,IconString="")
    kAchievementMetaData[4]=(Id=14,ShowsProgress=false,StatId=0,StatSet=0,NameHash=1610186296,LockedDescHash=102268422,UnlockedDescHash=983796063,IconString="")
    kAchievementMetaData[5]=(Id=20,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-1418072356,LockedDescHash=-1893830021,UnlockedDescHash=-886795764,IconString="")
    kAchievementMetaData[6]=(Id=21,ShowsProgress=false,StatId=0,StatSet=0,NameHash=494219213,LockedDescHash=-2065180904,UnlockedDescHash=1377311146,IconString="")
    kAchievementMetaData[7]=(Id=22,ShowsProgress=false,StatId=0,StatSet=0,NameHash=935191964,LockedDescHash=-1436637748,UnlockedDescHash=328737819,IconString="")
    kAchievementMetaData[8]=(Id=23,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-1827158752,LockedDescHash=644298720,UnlockedDescHash=-1765689986,IconString="")
    kAchievementMetaData[9]=(Id=24,ShowsProgress=false,StatId=0,StatSet=0,NameHash=1286275759,LockedDescHash=1536330416,UnlockedDescHash=26337105,IconString="")
    kAchievementMetaData[10]=(Id=25,ShowsProgress=false,StatId=0,StatSet=0,NameHash=939103278,LockedDescHash=798456135,UnlockedDescHash=-757935632,IconString="")
    kAchievementMetaData[11]=(Id=26,ShowsProgress=false,StatId=0,StatSet=0,NameHash=1368978694,LockedDescHash=-1452853249,UnlockedDescHash=-620309466,IconString="")
    kAchievementMetaData[12]=(Id=27,ShowsProgress=false,StatId=0,StatSet=0,NameHash=89335197,LockedDescHash=1291931552,UnlockedDescHash=349155159,IconString="")
    kAchievementMetaData[13]=(Id=28,ShowsProgress=false,StatId=0,StatSet=0,NameHash=1801848481,LockedDescHash=823887812,UnlockedDescHash=1856275256,IconString="")
    kAchievementMetaData[14]=(Id=29,ShowsProgress=false,StatId=0,StatSet=0,NameHash=162682199,LockedDescHash=-856500755,UnlockedDescHash=1484452913,IconString="")
    kAchievementMetaData[15]=(Id=30,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-1814435605,LockedDescHash=-274065892,UnlockedDescHash=1684848957,IconString="")
    kAchievementMetaData[16]=(Id=33,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-847356736,LockedDescHash=-1569706100,UnlockedDescHash=81479384,IconString="")
    kAchievementMetaData[17]=(Id=34,ShowsProgress=false,StatId=0,StatSet=0,NameHash=2029198855,LockedDescHash=-1136741176,UnlockedDescHash=792984379,IconString="")
    kAchievementMetaData[18]=(Id=36,ShowsProgress=false,StatId=0,StatSet=0,NameHash=1392851902,LockedDescHash=-471525006,UnlockedDescHash=-1560330785,IconString="")
    kAchievementMetaData[19]=(Id=37,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-1132097326,LockedDescHash=-578915971,UnlockedDescHash=854340539,IconString="")
    kAchievementMetaData[20]=(Id=38,ShowsProgress=true,StatId=42,StatSet=1,NameHash=196747699,LockedDescHash=448537779,UnlockedDescHash=-1357176566,IconString="")
    kAchievementMetaData[21]=(Id=39,ShowsProgress=true,StatId=42,StatSet=1,NameHash=1615527177,LockedDescHash=-483433702,UnlockedDescHash=-1060247399,IconString="")
    kAchievementMetaData[22]=(Id=42,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-591863402,LockedDescHash=2114654332,UnlockedDescHash=1287614707,IconString="")
    kAchievementMetaData[23]=(Id=43,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-2014918142,LockedDescHash=860597090,UnlockedDescHash=810128957,IconString="")
    kAchievementMetaData[24]=(Id=44,ShowsProgress=false,StatId=0,StatSet=0,NameHash=1780566115,LockedDescHash=1988491762,UnlockedDescHash=1720995662,IconString="")
    kAchievementMetaData[25]=(Id=45,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-1112161301,LockedDescHash=246407855,UnlockedDescHash=197131229,IconString="")
    kAchievementMetaData[26]=(Id=46,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-89618779,LockedDescHash=-649501608,UnlockedDescHash=1375498799,IconString="")
    kAchievementMetaData[27]=(Id=47,ShowsProgress=false,StatId=0,StatSet=0,NameHash=767205678,LockedDescHash=-1605241586,UnlockedDescHash=-598303696,IconString="")
    kAchievementMetaData[28]=(Id=48,ShowsProgress=false,StatId=0,StatSet=0,NameHash=652755538,LockedDescHash=-421812079,UnlockedDescHash=1965279946,IconString="")
    kAchievementMetaData[29]=(Id=51,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-1793498282,LockedDescHash=-1866607784,UnlockedDescHash=741418422,IconString="")
    kAchievementMetaData[30]=(Id=52,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-846032957,LockedDescHash=-374466038,UnlockedDescHash=970591404,IconString="")
    kAchievementMetaData[31]=(Id=57,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-1213292430,LockedDescHash=1129000217,UnlockedDescHash=986633619,IconString="")
    kAchievementMetaData[32]=(Id=58,ShowsProgress=true,StatId=26,StatSet=0,NameHash=203765141,LockedDescHash=1122878050,UnlockedDescHash=213286025,IconString="")
    kAchievementMetaData[33]=(Id=59,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-416322845,LockedDescHash=607321630,UnlockedDescHash=-1001289697,IconString="")
    kAchievementMetaData[34]=(Id=60,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-2115789793,LockedDescHash=1745635293,UnlockedDescHash=-243552896,IconString="")
    kAchievementMetaData[35]=(Id=61,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-1190887319,LockedDescHash=1885905154,UnlockedDescHash=1998804610,IconString="")
    kAchievementMetaData[36]=(Id=62,ShowsProgress=false,StatId=0,StatSet=0,NameHash=2122321652,LockedDescHash=-1923329810,UnlockedDescHash=1936835214,IconString="")
    kAchievementMetaData[37]=(Id=63,ShowsProgress=true,StatId=27,StatSet=0,NameHash=-372560451,LockedDescHash=617778337,UnlockedDescHash=-1544097650,IconString="")
    kAchievementMetaData[38]=(Id=64,ShowsProgress=true,StatId=28,StatSet=0,NameHash=34484741,LockedDescHash=1784285030,UnlockedDescHash=846339455,IconString="")
    kAchievementMetaData[39]=(Id=65,ShowsProgress=false,StatId=0,StatSet=0,NameHash=853717062,LockedDescHash=1340878358,UnlockedDescHash=990752437,IconString="")
    kAchievementMetaData[40]=(Id=66,ShowsProgress=false,StatId=0,StatSet=0,NameHash=-1359654080,LockedDescHash=944550003,UnlockedDescHash=1827683063,IconString="")
    kAchievementMetaData[41]=(Id=67,ShowsProgress=true,StatId=29,StatSet=0,NameHash=-1906730285,LockedDescHash=-1644901971,UnlockedDescHash=675868509,IconString="")
    kAchievementMetaData[42]=(Id=68,ShowsProgress=true,StatId=30,StatSet=0,NameHash=-2103726473,LockedDescHash=-1402410844,UnlockedDescHash=-55139883,IconString="")
}