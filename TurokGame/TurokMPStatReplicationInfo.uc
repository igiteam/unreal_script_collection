class TurokMPStatReplicationInfo extends TurokStatReplicationInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

var private repnotify int mStatArray[130];

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        mStatArray;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x31
    if(VarName == 'mStatArray')
    {
        // End:0x31
        if(mAchievementTracker != none)
        {
            mAchievementTracker.CheckAchievements();
        }
    }
    super(Actor).ReplicatedEvent(VarName);
    //return;    
}

defaultproperties
{
    StatsClass=Class'TurokMultiplayerStats'
}