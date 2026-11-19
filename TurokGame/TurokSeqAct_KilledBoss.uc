class TurokSeqAct_KilledBoss extends SequenceAction
    hidecategories(Object);

enum eBossType
{
    EBT_Scarface,                   // 0
    EBT_WaterBoss,                  // 1
    EBT_None,                       // 2
    EBT_MAX                         // 3
};

var() byte mBossType;

event Activated()
{
    // End:0x26
    if(int(mBossType) == int(0))
    {
        Class'TurokAchievementTracker'.static.FoughtOffMommaScarface();        
    }
    else
    {
        // End:0x49
        if(int(mBossType) == int(1))
        {
            Class'TurokAchievementTracker'.static.KilledWaterBoss();
        }
    }
    //return;    
}

defaultproperties
{
    mBossType=2
    ObjName="Killed Boss"
    ObjCategory="Turok Achievements"
}