class TurokWarGameReplicationInfo extends TurokTeamGameReplicationInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

var private transient array mGoalInfos;
var private transient int mTeamPotentialScore[2];

simulated function PostBeginPlay()
{
    local @NULL G;

    super(TurokMPGameReplicationInfo).PostBeginPlay();
    // End:0x29
    foreach AllActors(Class'TurokGoalInfo', G)
    {
        mGoalInfos[mGoalInfos.Length] = G;        
    }    
    //return;    
}

protected simulated function UpdateTeamStats()
{
    local int I, J;

    super.UpdateTeamStats();
    mTeamPotentialScore[0] = 0;
    mTeamPotentialScore[1] = 0;
    I = 0;
    J0x1F:

    // End:0x80 [Loop If]
    if(I < mGoalInfos.Length)
    {
        J = mGoalInfos[I].GetLeadingTeam();
        // End:0x62
        if(J == 0)
        {
            ++mTeamPotentialScore[0];
        }
        // End:0x76
        if(J == 1)
        {
            ++mTeamPotentialScore[1];
        }
        ++I;
        // [Loop Continue]
        goto J0x1F;
    }
    //return;    
}

function bool IsTieBreaker()
{
    return mTeamPotentialScore[0] == mTeamPotentialScore[1];
    //return ReturnValue;    
}

protected simulated function bool TeamsInOrder()
{
    local int Difference;

    Difference = mTeamPotentialScore[0] - mTeamPotentialScore[1];
    // End:0x23
    if(Difference < 0)
    {
        return false;
    }
    // End:0x30
    if(Difference > 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mAccScore - mTeamStats[1].mAccScore;
    // End:0x67
    if(Difference < 0)
    {
        return false;
    }
    // End:0x74
    if(Difference > 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mKills - mTeamStats[1].mKills;
    // End:0xAB
    if(Difference < 0)
    {
        return false;
    }
    // End:0xB8
    if(Difference > 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mDeaths - mTeamStats[1].mDeaths;
    // End:0xEF
    if(Difference > 0)
    {
        return false;
    }
    // End:0xFC
    if(Difference < 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mAssists - mTeamStats[1].mAssists;
    // End:0x133
    if(Difference < 0)
    {
        return false;
    }
    // End:0x140
    if(Difference > 0)
    {
        return true;
    }
    return Teams[0].Size > Teams[1].Size;
    //return ReturnValue;    
}
