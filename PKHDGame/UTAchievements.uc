class UTAchievements extends UTAchievementsBase within UTPlayerController;

enum EUTGameAchievements
{
    EUTA_EXPLORE_EveryMutator,      // 0
    EUTA_WEAPON_DontTaseMeBro,      // 1
    EUTA_WEAPON_StrongestLink,      // 2
    EUTA_WEAPON_HaveANiceDay,       // 3
    EUTA_VEHICLE_Armadillo,         // 4
    EUTA_POWERUP_DeliveringTheHurt, // 5
    EUTA_HUMILIATION_SerialKiller,  // 6
    EUTA_HUMILIATION_OffToAGoodStart,// 7
    EUTA_MAX                        // 8
};

function UpdateSpiceOfLife(int MutatorBitmask)
{
    local int CurrentMask, I, MutatorBit;

    // End:0xAC
    if(GetAchievementValue(0, CurrentMask))
    {
        I = 0;
        J0x22:

        // End:0xAC [Loop If]
        if(I < 31)
        {
            MutatorBit = 1 << I;
            // End:0x9E
            if(((MutatorBitmask & MutatorBit) == MutatorBit) && (CurrentMask & MutatorBit) == 0)
            {
                UpdateAchievement(0, MutatorBit);
                // [Explicit Break]
                goto J0xAC;
            }
            I++;
            // [Loop Continue]
            goto J0x22;
        }
    }
    J0xAC:

    //return;    
}

defaultproperties
{
    AchievementsArray[0]=(Id=0,UnlockType=EAchievementUnlockType.EAUT_Bitmask,UnlockCriteria=511,ProgressCriteria=3,bDoUnlock=true,bDoProgress=true)
    AchievementsArray[1]=(Id=1,UnlockType=EAchievementUnlockType.EAUT_Count,UnlockCriteria=4,ProgressCriteria=2,bDoUnlock=false,bDoProgress=false)
    AchievementsArray[2]=(Id=2,UnlockType=EAchievementUnlockType.EAUT_Count,UnlockCriteria=4,ProgressCriteria=2,bDoUnlock=false,bDoProgress=false)
    AchievementsArray[3]=(Id=3,UnlockType=EAchievementUnlockType.EAUT_Count,UnlockCriteria=4,ProgressCriteria=2,bDoUnlock=false,bDoProgress=false)
    AchievementsArray[4]=(Id=4,UnlockType=EAchievementUnlockType.EAUT_Count,UnlockCriteria=4,ProgressCriteria=2,bDoUnlock=false,bDoProgress=false)
    AchievementsArray[5]=(Id=5,UnlockType=EAchievementUnlockType.EAUT_Count,UnlockCriteria=60,ProgressCriteria=30,bDoUnlock=false,bDoProgress=false)
    AchievementsArray[6]=(Id=6,UnlockType=EAchievementUnlockType.EAUT_Count,UnlockCriteria=1,ProgressCriteria=0,bDoUnlock=false,bDoProgress=false)
    AchievementsArray[7]=(Id=7,UnlockType=EAchievementUnlockType.EAUT_Count,UnlockCriteria=1,ProgressCriteria=0,bDoUnlock=false,bDoProgress=false)
    AchievementStatsReadClass=Class'UTStatsReadAchievements'
    AchievementStatsWriteClass=Class'UTStatsWriteAchievements'
}