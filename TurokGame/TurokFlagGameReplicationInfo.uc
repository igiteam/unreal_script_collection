class TurokFlagGameReplicationInfo extends TurokTeamGameReplicationInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

var bool mCurFlagAtHomeStatus0;
var bool mCurFlagAtHomeStatus1;
var byte mFlagState[2];
var @NULL mDroppedFlagLocation[2];

replication
{
    // Pos:0x000
    if(bNetDirty
        mCurFlagAtHomeStatus0, mCurFlagAtHomeStatus1;
}

function Reset()
{
    mCurFlagAtHomeStatus0 = default.mCurFlagAtHomeStatus0;
    mCurFlagAtHomeStatus1 = default.mCurFlagAtHomeStatus1;
    mFlagState[0] = default.mFlagState[0];
    mFlagState[1] = default.mFlagState[1];
    super(GameReplicationInfo).Reset();
    //return;    
}

simulated function SetCurFlagStatus(byte TeamIndex, byte NewStatus, @NULL Target)
{
    local bool flagAtHome;

    flagAtHome = ((int(NewStatus) == int(0)) ? true : false);
    mFlagState[int(TeamIndex)] = NewStatus;
    // End:0x5A
    if(int(NewStatus) == int(3))
    {
        mDroppedFlagLocation[int(TeamIndex)] = Target.Location;
    }
    // End:0x77
    if(int(TeamIndex) == 0)
    {
        mCurFlagAtHomeStatus0 = flagAtHome;        
    }
    else
    {
        // End:0x91
        if(int(TeamIndex) == 1)
        {
            mCurFlagAtHomeStatus1 = flagAtHome;
        }
    }
    //return;    
}

function bool IsTieBreaker()
{
    return int(Teams[0].Score) == int(Teams[1].Score);
    //return ReturnValue;    
}

protected simulated function bool TeamsInOrder()
{
    local int Difference;
    local class<Class> gameInfoClass;

    gameInfoClass = WorldInfo.GetGameClass();
    // End:0x59
    if((gameInfoClass == Class'TurokAssaultGame') && !bMatchIsOver)
    {
        // End:0x4E
        if(RemainingTime <= 0)
        {
            return int(mCurrPrimaryTeamIndex) == 0;            
        }
        else
        {
            return int(mCurrPrimaryTeamIndex) == 1;
        }
    }
    Difference = int(Teams[0].Score) - int(Teams[1].Score);
    // End:0x92
    if(Difference < 0)
    {
        return false;
    }
    // End:0x9F
    if(Difference > 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mAccScore - mTeamStats[1].mAccScore;
    // End:0xD6
    if(Difference < 0)
    {
        return false;
    }
    // End:0xE3
    if(Difference > 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mKills - mTeamStats[1].mKills;
    // End:0x11A
    if(Difference < 0)
    {
        return false;
    }
    // End:0x127
    if(Difference > 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mDeaths - mTeamStats[1].mDeaths;
    // End:0x15E
    if(Difference > 0)
    {
        return false;
    }
    // End:0x16B
    if(Difference < 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mAssists - mTeamStats[1].mAssists;
    // End:0x1A2
    if(Difference < 0)
    {
        return false;
    }
    // End:0x1AF
    if(Difference > 0)
    {
        return true;
    }
    return Teams[0].Size > Teams[1].Size;
    //return ReturnValue;    
}

defaultproperties
{
    mCurFlagAtHomeStatus0=true
    mCurFlagAtHomeStatus1=true
}