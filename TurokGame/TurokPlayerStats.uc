class TurokPlayerStats extends Object
    native
    config(Game);

const kFloatPrecision = 2;
const MAX_COMBO = 5;

struct native StatMetaData
{
    var byte mStatId;
    var name mName;
    var byte mType;
    var byte mOp;
    var int mTitleHash;
    var int mDescriptionHash;

    structdefaultproperties
    {
        mStatId=0
        mName="None"
        mType=0
        mOp=0
        mTitleHash=0
        mDescriptionHash=0
    }
};

struct native ComboTracker
{
    var int mTimeLimit;
    var float mFirstTimestamp;
    var int mCounter;

    structdefaultproperties
    {
        mTimeLimit=4
        mFirstTimestamp=0.0000000
        mCounter=0
    }
};

var array mStatMetaData;
var native const @NULL mStatValues;
var array mDerivedStatMetaData;
var const @NULL mReplicator;
var const @NULL mAchievementTracker;
var config float kAccuracyFactor;
var config float kSkillFactor;
var config float kEfficiencyFactor;
var config float kSurvivalFactor;
var config float kSurvivalMod;
var config float kMagicNumber;
var transient bool mbIsOwnerOfData;
var transient @NULL mLastHitWeapon;
var transient class<Class> mLastKillDamageType;
var transient @NULL mLastKilled;
var transient int mConsecutiveWeaponKills;
var transient int mConsecutiveVictimKills;
var transient int mConsecutiveHeadShots;
var transient int mKillStreak;
var transient int mDeathStreak;
var transient @NULL mKillCombo;
var transient @NULL mStunCombo;
var transient float mLastDeathTime;

// Export UTurokPlayerStats::execBindToReplicator(FFrame&, void* const)
native function BindToReplicator(@NULL SRI);

// Export UTurokPlayerStats::execClear(FFrame&, void* const)
native function Clear();

// Export UTurokPlayerStats::execSetAchievementTracker(FFrame&, void* const)
native function SetAchievementTracker(@NULL AchievementTracker);

// Export UTurokPlayerStats::execRecordStat(FFrame&, void* const)
native final function RecordStat(byte stat, int Value, byte Op);

// Export UTurokPlayerStats::execGetStat(FFrame&, void* const)
native final function bool GetStat(byte stat, out int Value, out @NULL MetaData);

// Export UTurokPlayerStats::execGetStatValue(FFrame&, void* const)
native final function int GetStatValue(byte stat);

// Export UTurokPlayerStats::execGetStatType(FFrame&, void* const)
native final function byte GetStatType(byte stat);

// Export UTurokPlayerStats::execGetDerivedStat(FFrame&, void* const)
native final function bool GetDerivedStat(byte stat, out int Value, out @NULL MetaData);

// Export UTurokPlayerStats::execGetDerivedStatValue(FFrame&, void* const)
native final function int GetDerivedStatValue(byte stat);

// Export UTurokPlayerStats::execGetDerivedStatType(FFrame&, void* const)
native final function byte GetDerivedStatType(byte stat);

// Export UTurokPlayerStats::execGetStatValueToFloat(FFrame&, void* const)
native final function float GetStatValueToFloat(int Value);

// Export UTurokPlayerStats::execGetStatTitleLocalized(FFrame&, void* const)
native final function string GetStatTitleLocalized(byte stat);

// Export UTurokPlayerStats::execGetStatValueLocalized(FFrame&, void* const)
native final function string GetStatValueLocalized(byte stat);

// Export UTurokPlayerStats::execGetStatDescriptionLocalized(FFrame&, void* const)
native final function string GetStatDescriptionLocalized(byte stat);

// Export UTurokPlayerStats::execMerge(FFrame&, void* const)
native final function Merge(@NULL Stats);

// Export UTurokPlayerStats::execStomp(FFrame&, void* const)
native final function Stomp(@NULL Stats);

// Export UTurokPlayerStats::execCalcBattleRating(FFrame&, void* const)
native function float CalcBattleRating();

// Export UTurokPlayerStats::execCalcAccuracyPercentage(FFrame&, void* const)
native function float CalcAccuracyPercentage();

// Export UTurokPlayerStats::execCalcVictoryPercentage(FFrame&, void* const)
native function float CalcVictoryPercentage();

// Export UTurokPlayerStats::execCalcKillsPerDeath(FFrame&, void* const)
native function float CalcKillsPerDeath();

// Export UTurokPlayerStats::execCalcKillsPerMinute(FFrame&, void* const)
native function float CalcKillsPerMinute();

// Export UTurokPlayerStats::execCalcDeathsPerMinute(FFrame&, void* const)
native function float CalcDeathsPerMinute();

// Export UTurokPlayerStats::execCalcFavoriteWeaponAccuracy(FFrame&, void* const)
native function float CalcFavoriteWeaponAccuracy();

// Export UTurokPlayerStats::execCalcTotalCTFActPoints(FFrame&, void* const)
native function int CalcTotalCTFActPoints();

// Export UTurokPlayerStats::execCalcTotalWGActPoints(FFrame&, void* const)
native function int CalcTotalWGActPoints();

// Export UTurokPlayerStats::execGetFavoriteWeapon(FFrame&, void* const)
native function int GetFavoriteWeapon();

// Export UTurokPlayerStats::execGetFavoriteWeaponKills(FFrame&, void* const)
native function int GetFavoriteWeaponKills();

// Export UTurokPlayerStats::execGetFavoriteWeaponIndex(FFrame&, void* const)
native function int GetFavoriteWeaponIndex();

// Export UTurokPlayerStats::execGetStatId(FFrame&, void* const)
native final function byte GetStatId(name stat);

// Export UTurokPlayerStats::execGetNumStats(FFrame&, void* const)
native final function int GetNumStats();

// Export UTurokPlayerStats::execIsDerivedStat(FFrame&, void* const)
native final function bool IsDerivedStat(byte stat);

// Export UTurokPlayerStats::execGetNumDerivedStats(FFrame&, void* const)
native final function int GetNumDerivedStats();

// Export UTurokPlayerStats::execClearStat(FFrame&, void* const)
native final function ClearStat(byte stat);

// Export UTurokPlayerStats::execStatToString(FFrame&, void* const)
native final function string StatToString(byte stat);

// Export UTurokPlayerStats::execCalcCombo(FFrame&, void* const)
native function int CalcCombo(out @NULL combo, float Time);

event name GetStatTypeString(byte Type)
{
    return GetEnum(Enum'TurokStatEnumerations.eStatType', int(Type));
    //return ReturnValue;    
}

// Export UTurokPlayerStats::execWriteToFile(FFrame&, void* const)
native function WriteToFile(string PlayerName);

// Export UTurokPlayerStats::execDebugPrintAll(FFrame&, void* const)
native function DebugPrintAll();

reliable client simulated function ClientDebugPrintAll(@NULL clientController)
{
    local int I;

    // End:0x0D
    if(clientController == none)
    {
        return;
    }
    clientController.ClientAdminMessage("-- Stats --");
    I = 0;
    J0x34:

    // End:0x6E [Loop If]
    if(I < mStatMetaData.Length)
    {
        clientController.ClientAdminMessage(StatToString(byte(I)));
        I++;
        // [Loop Continue]
        goto J0x34;
    }
    //return;    
}

function DebugPrintStat(name stat, optional name subject)
{
    //return;    
}

reliable client simulated function ClientDebugPrintStat(@NULL clientController, name stat, optional name subject)
{
    // End:0x0E
    if(clientController == none)
    {
        return;
    }
    clientController.ClientAdminMessage(StatToString(GetStatId(stat)));
    //return;    
}

// Export UTurokPlayerStats::execGetBattleRating(FFrame&, void* const)
native static function float GetBattleRating(int shotsFired, int shotsHit, int Kills, int headShotKills, int stealthKills, int fragKills, int assists, int Deaths);

// Export UTurokPlayerStats::execFloatToStatValue(FFrame&, void* const)
native static function int FloatToStatValue(float Value);

// Export UTurokPlayerStats::execStatValueToFloat(FFrame&, void* const)
native static function float StatValueToFloat(int Value);

defaultproperties
{
    mStatMetaData=/* Array type was not detected. */
    mDerivedStatMetaData=/* Array type was not detected. */
    mbIsOwnerOfData=true
    mKillCombo=(mTimeLimit=4,mFirstTimestamp=0.0000000,mCounter=0)
    mStunCombo=(mTimeLimit=4,mFirstTimestamp=0.0000000,mCounter=0)
}