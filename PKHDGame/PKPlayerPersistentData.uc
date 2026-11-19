class PKPlayerPersistentData extends OnlinePlayerStorage
    native;

var array<int> LevelIDToProfileID;
var array<int> COOPLevelIDToProfileID;
var const LevelStatistics BlankLevelStatistics;

// Export UPKPlayerPersistentData::execAddSettingBlob(FFrame&, void* const)
native function AddSettingBlob(int SettingId);

// Export UPKPlayerPersistentData::execGetBlob(FFrame&, void* const)
native function bool GetBlob(int ProfileSettingId, out array<byte> Blob);

// Export UPKPlayerPersistentData::execSetBlob(FFrame&, void* const)
native function bool SetBlob(int ProfileSettingId, out array<byte> Blob);

// Export UPKPlayerPersistentData::execGetProfileLevelStatistics(FFrame&, void* const)
native function bool GetProfileLevelStatistics(int ProfileSettingId, out LevelStatistics LStats);

// Export UPKPlayerPersistentData::execSetProfileLevelStatistics(FFrame&, void* const)
native function bool SetProfileLevelStatistics(int ProfileSettingId, out LevelStatistics LStats);

simulated function ClearData()
{
    ClearSingleLevelsStatistics();
    ClearCoopLevelsStatistics();
    SetValue(36, 0);
    SetValue(34, 0);
    SetValue(35, 0);
    SetValue(89, 0);
    SetValue(90, 0);
    //return;    
}

simulated function ClearDataOnSignThePact()
{
    //return;    
}

simulated function int GetValue(int PersistentDataID)
{
    local int Data;

    // End:0x29
    if(GetProfileSettingValueInt(PersistentDataID, Data))
    {
        return Data;
    }
    AddSettingInt(PersistentDataID);
    return 0;
    //return ReturnValue;    
}

simulated function SetValue(int PersistentDataID, int NewValue)
{
    local int OldValue;

    OldValue = GetValue(PersistentDataID);
    // End:0x50
    if(NewValue != OldValue)
    {
        SetProfileSettingValueInt(PersistentDataID, NewValue);
    }
    //return;    
}

simulated function bool GetBlobValue(int PersistentDataID, out array<byte> Blob)
{
    // End:0x21
    if(GetBlob(PersistentDataID, Blob))
    {
        return true;
    }
    AddSettingInt(PersistentDataID);
    return false;
    //return ReturnValue;    
}

simulated function SetBlobValue(int PersistentDataID, array<byte> Blob)
{
    SetBlob(PersistentDataID, Blob);
    //return;    
}

simulated function ClearSingleLevelsStatistics()
{
    local LevelStatistics ls;
    local int I;

    ls = BlankLevelStatistics;
    I = 0;
    J0x1E:

    // End:0x87 [Loop If]
    if(I < LevelIDToProfileID.Length)
    {
        // End:0x79
        if(LevelIDToProfileID[I] != -1)
        {
            SetProfileLevelStatistics(LevelIDToProfileID[I], ls);
        }
        I++;
        // [Loop Continue]
        goto J0x1E;
    }
    //return;    
}

simulated function ClearCoopLevelsStatistics()
{
    local LevelStatistics ls;
    local int I;

    ls = BlankLevelStatistics;
    I = 0;
    J0x1E:

    // End:0x87 [Loop If]
    if(I < COOPLevelIDToProfileID.Length)
    {
        // End:0x79
        if(COOPLevelIDToProfileID[I] != -1)
        {
            SetProfileLevelStatistics(COOPLevelIDToProfileID[I], ls);
        }
        I++;
        // [Loop Continue]
        goto J0x1E;
    }
    //return;    
}

static function DebugLogLevelStatistics(out LevelStatistics ls)
{
    //return;    
}

function DebugReadLevelStats()
{
    local LevelStatistics ls;
    local int I;

    I = 0;
    J0x0B:

    // End:0x8A [Loop If]
    if(I < LevelIDToProfileID.Length)
    {
        // End:0x43
        if(LevelIDToProfileID[I] == -1)
        {            
        }
        else
        {
            GetProfileLevelStatistics(LevelIDToProfileID[I], ls);
            DebugLogLevelStatistics(ls);
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x95:

    // End:0x114 [Loop If]
    if(I < COOPLevelIDToProfileID.Length)
    {
        // End:0xCD
        if(COOPLevelIDToProfileID[I] == -1)
        {            
        }
        else
        {
            GetProfileLevelStatistics(COOPLevelIDToProfileID[I], ls);
            DebugLogLevelStatistics(ls);
        }
        I++;
        // [Loop Continue]
        goto J0x95;
    }
    //return;    
}

simulated function LockAllSingleLevels()
{
    SetValue(34, 1);
    //return;    
}

simulated function bool IsLevelCompleted(PKTypes.ELevelID inLevelID, bool bIsCoop)
{
    local int UnlockMaskValue;

    // End:0x2D
    if(bIsCoop)
    {
        UnlockMaskValue = GetCOOPLevelsUnlockedMaskValue(inLevelID);        
    }
    else
    {
        UnlockMaskValue = GetLevelsUnlockedMaskValue(inLevelID);
    }
    return Class'PainProfileSettings'.static.BitIsSet(UnlockMaskValue, int(inLevelID) % int(32));
    //return ReturnValue;    
}

simulated function int GetLevelsUnlockedMaskValue(PKTypes.ELevelID inLevelID)
{
    local int UnlockMaskValue;

    // End:0x2D
    if(int(inLevelID) < int(32))
    {
        UnlockMaskValue = GetValue(34);        
    }
    else
    {
        UnlockMaskValue = GetValue(89);
    }
    return UnlockMaskValue;
    //return ReturnValue;    
}

function bool MarkSPSurvivalLevelAsCompleted(int LevelIndex)
{
    local int UnlockMaskValue;

    UnlockMaskValue = GetSPSurvivalLevelsUnlockedMaskValue(LevelIndex);
    // End:0x57
    if(LevelIndex < 32)
    {
        SetValue(95, UnlockMaskValue | (1 << (LevelIndex % 32)));        
    }
    else
    {
        SetValue(96, UnlockMaskValue | (1 << (LevelIndex % 32)));
    }
    return true;
    //return ReturnValue;    
}

simulated function bool IsSPSurvivalLevelCompleted(int LevelIndex)
{
    local int UnlockMaskValue;

    UnlockMaskValue = GetSPSurvivalLevelsUnlockedMaskValue(LevelIndex);
    return Class'PainProfileSettings'.static.BitIsSet(UnlockMaskValue, LevelIndex % 32);
    //return ReturnValue;    
}

simulated function int GetSPSurvivalLevelsUnlockedMaskValue(int LevelIndex)
{
    local int UnlockMaskValue;

    // End:0x29
    if(LevelIndex < 32)
    {
        UnlockMaskValue = GetValue(95);        
    }
    else
    {
        UnlockMaskValue = GetValue(96);
    }
    return UnlockMaskValue;
    //return ReturnValue;    
}

simulated function int GetCOOPLevelsUnlockedMaskValue(PKTypes.ELevelID inLevelID)
{
    local int UnlockMaskValue;

    // End:0x2D
    if(int(inLevelID) < int(32))
    {
        UnlockMaskValue = GetValue(35);        
    }
    else
    {
        UnlockMaskValue = GetValue(90);
    }
    return UnlockMaskValue;
    //return ReturnValue;    
}

simulated function int GetLastCompletedLevel()
{
    return GetValue(36);
    //return ReturnValue;    
}

function SetLastCompletedLevel(PKTypes.ELevelID inLevelID)
{
    SetValue(36, int(inLevelID));
    //return;    
}

function bool MarkLevelAsCompleted(PKTypes.ELevelID inLevelID)
{
    local int UnlockMaskValue;

    UnlockMaskValue = GetLevelsUnlockedMaskValue(inLevelID);
    // End:0x5F
    if(int(inLevelID) < int(32))
    {
        SetValue(34, UnlockMaskValue | (1 << (int(inLevelID) % int(32))));        
    }
    else
    {
        SetValue(89, UnlockMaskValue | (1 << (int(inLevelID) % int(32))));
    }
    return true;
    //return ReturnValue;    
}

function bool MarkCOOPLevelAsCompleted(PKTypes.ELevelID inLevelID)
{
    local int UnlockMaskValue;

    UnlockMaskValue = GetCOOPLevelsUnlockedMaskValue(inLevelID);
    // End:0x5F
    if(int(inLevelID) < int(32))
    {
        SetValue(35, UnlockMaskValue | (1 << (int(inLevelID) % int(32))));        
    }
    else
    {
        SetValue(90, UnlockMaskValue | (1 << (int(inLevelID) % int(32))));
    }
    return true;
    //return ReturnValue;    
}

simulated function WriteEndLevelStatistics(PKTypes.ELevelID inLevelID, out LevelStatistics ls, PainPRI PRI, bool IsCoopGame)
{
    local int ProfileId;
    local LevelStatistics Stats;

    ProfileId = TranslateLevelIDToProfileSettingID(inLevelID, IsCoopGame);
    // End:0x46
    if(ProfileId == -1)
    {
        ScriptTrace();
        return;
    }
    GetProfileLevelStatistics(ProfileId, Stats);
    // End:0x137
    if((Stats.GameplayTime == 0) || Stats.GameplayTime >= ls.GameplayTime)
    {
        Stats.GameplayTime = ls.GameplayTime;
        Stats.TimeDiff = int(ls.Difficulty);
    }
    // End:0x1B1
    if(int(Stats.Difficulty) <= int(ls.Difficulty))
    {
        Stats.Difficulty = ls.Difficulty;
    }
    // End:0x262
    if(Stats.MonstersKilled <= ls.MonstersKilled)
    {
        Stats.MonstersKilled = ls.MonstersKilled;
        Stats.MonstersDiff = int(ls.Difficulty);
    }
    // End:0x313
    if(Stats.SoulsCollected <= ls.SoulsCollected)
    {
        Stats.SoulsCollected = ls.SoulsCollected;
        Stats.SoulsDiff = int(ls.Difficulty);
    }
    // End:0x389
    if(Stats.ArmorsFound <= ls.ArmorsFound)
    {
        Stats.ArmorsFound = ls.ArmorsFound;
    }
    // End:0x4B2
    if(Stats.GoldFound < (ls.GoldFound - ls.BonusItems))
    {
        Stats.GoldFound = ls.GoldFound - ls.BonusItems;
        Stats.BonusItems = ls.BonusItems;
        Stats.GoldDiff = int(ls.Difficulty);        
    }
    else
    {
        // End:0x5C0
        if((Stats.GoldFound == (ls.GoldFound - ls.BonusItems)) && Stats.BonusItems < ls.BonusItems)
        {
            Stats.BonusItems = ls.BonusItems;
            Stats.GoldDiff = int(ls.Difficulty);
        }
    }
    // End:0x671
    if(Stats.HolyItemsFound <= ls.HolyItemsFound)
    {
        Stats.HolyItemsFound = ls.HolyItemsFound;
        Stats.HolyDiff = int(ls.Difficulty);
    }
    // End:0x722
    if(Stats.AmmoFound <= ls.AmmoFound)
    {
        Stats.AmmoFound = ls.AmmoFound;
        Stats.AmmoDiff = int(ls.Difficulty);
    }
    // End:0x7D3
    if(Stats.ObjectsDestroyed <= ls.ObjectsDestroyed)
    {
        Stats.ObjectsDestroyed = ls.ObjectsDestroyed;
        Stats.ObjectsDiff = int(ls.Difficulty);
    }
    // End:0x884
    if(Stats.SecretsFound <= ls.SecretsFound)
    {
        Stats.SecretsFound = ls.SecretsFound;
        Stats.SecretsDiff = int(ls.Difficulty);
    }
    Stats.TotalAmmo = ls.TotalAmmo;
    Stats.TotalArmors = ls.TotalArmors;
    Stats.TotalGold = ls.TotalGold;
    Stats.TotalHolyItems = ls.TotalHolyItems;
    Stats.TotalMonsters = ls.TotalMonsters;
    Stats.TotalObjects = ls.TotalObjects;
    Stats.TotalSecrets = ls.TotalSecrets;
    Stats.TotalSouls = ls.TotalSouls;
    // End:0xA6D
    if(!SetProfileLevelStatistics(ProfileId, Stats))
    {
    }
    //return;    
}

function PKTypes.EDifficultyLevel GetLowestDifficultyLevelFromCompletedLevels(bool IsCoopGame)
{
    local int I;
    local PKTypes.EDifficultyLevel LowestDiff;
    local LevelStatistics ls;

    LowestDiff = 3;
    I = 1;
    J0x17:

    // End:0xB1 [Loop If]
    if(I <= 13)
    {
        ReadEndLevelStatistics(byte(I), ls, IsCoopGame);
        // End:0xA3
        if(int(ls.Difficulty) <= int(LowestDiff))
        {
            LowestDiff = ls.Difficulty;
        }
        I++;
        // [Loop Continue]
        goto J0x17;
    }
    return LowestDiff;
    //return ReturnValue;    
}

static function int TranslateLevelIDToProfileSettingID(PKTypes.ELevelID inLevelID, bool IsCoopGame)
{
    // End:0x26
    if(IsCoopGame)
    {
        return default.COOPLevelIDToProfileID[int(inLevelID)];        
    }
    else
    {
        return default.LevelIDToProfileID[int(inLevelID)];
    }
    //return ReturnValue;    
}

simulated function ReadEndLevelStatistics(PKTypes.ELevelID inLevelID, out LevelStatistics ls, bool IsCoopGame)
{
    local int ProfileId;

    ProfileId = TranslateLevelIDToProfileSettingID(inLevelID, IsCoopGame);
    // End:0x56
    if(ProfileId != -1)
    {
        GetProfileLevelStatistics(ProfileId, ls);
    }
    //return;    
}

defaultproperties
{
    LevelIDToProfileID[0]=-1
    LevelIDToProfileID[1]=5
    LevelIDToProfileID[2]=4
    LevelIDToProfileID[3]=3
    LevelIDToProfileID[4]=8
    LevelIDToProfileID[5]=13
    LevelIDToProfileID[6]=17
    LevelIDToProfileID[7]=2
    LevelIDToProfileID[8]=14
    LevelIDToProfileID[9]=15
    LevelIDToProfileID[10]=16
    LevelIDToProfileID[11]=12
    LevelIDToProfileID[12]=7
    LevelIDToProfileID[13]=10
    LevelIDToProfileID[14]=6
    LevelIDToProfileID[15]=11
    LevelIDToProfileID[16]=9
    LevelIDToProfileID[17]=-1
    LevelIDToProfileID[18]=-1
    LevelIDToProfileID[19]=-1
    LevelIDToProfileID[20]=51
    LevelIDToProfileID[21]=73
    LevelIDToProfileID[22]=55
    LevelIDToProfileID[23]=54
    LevelIDToProfileID[24]=53
    LevelIDToProfileID[25]=57
    LevelIDToProfileID[26]=58
    LevelIDToProfileID[27]=56
    LevelIDToProfileID[28]=82
    LevelIDToProfileID[29]=79
    LevelIDToProfileID[30]=80
    LevelIDToProfileID[31]=83
    LevelIDToProfileID[32]=81
    LevelIDToProfileID[33]=59
    LevelIDToProfileID[34]=60
    LevelIDToProfileID[35]=61
    LevelIDToProfileID[36]=63
    LevelIDToProfileID[37]=62
    LevelIDToProfileID[38]=64
    LevelIDToProfileID[39]=91
    LevelIDToProfileID[40]=93
    COOPLevelIDToProfileID[0]=-1
    COOPLevelIDToProfileID[1]=21
    COOPLevelIDToProfileID[2]=20
    COOPLevelIDToProfileID[3]=19
    COOPLevelIDToProfileID[4]=24
    COOPLevelIDToProfileID[5]=29
    COOPLevelIDToProfileID[6]=33
    COOPLevelIDToProfileID[7]=18
    COOPLevelIDToProfileID[8]=30
    COOPLevelIDToProfileID[9]=31
    COOPLevelIDToProfileID[10]=32
    COOPLevelIDToProfileID[11]=28
    COOPLevelIDToProfileID[12]=23
    COOPLevelIDToProfileID[13]=26
    COOPLevelIDToProfileID[14]=22
    COOPLevelIDToProfileID[15]=27
    COOPLevelIDToProfileID[16]=25
    COOPLevelIDToProfileID[17]=-1
    COOPLevelIDToProfileID[18]=-1
    COOPLevelIDToProfileID[19]=-1
    COOPLevelIDToProfileID[20]=52
    COOPLevelIDToProfileID[21]=74
    COOPLevelIDToProfileID[22]=67
    COOPLevelIDToProfileID[23]=66
    COOPLevelIDToProfileID[24]=65
    COOPLevelIDToProfileID[25]=69
    COOPLevelIDToProfileID[26]=70
    COOPLevelIDToProfileID[27]=68
    COOPLevelIDToProfileID[28]=87
    COOPLevelIDToProfileID[29]=84
    COOPLevelIDToProfileID[30]=85
    COOPLevelIDToProfileID[31]=88
    COOPLevelIDToProfileID[32]=86
    COOPLevelIDToProfileID[33]=71
    COOPLevelIDToProfileID[34]=72
    COOPLevelIDToProfileID[35]=75
    COOPLevelIDToProfileID[36]=77
    COOPLevelIDToProfileID[37]=76
    COOPLevelIDToProfileID[38]=78
    COOPLevelIDToProfileID[39]=92
    COOPLevelIDToProfileID[40]=94
    VersionNumber=13
    ProfileMappings=/* Array type was not detected. */
}