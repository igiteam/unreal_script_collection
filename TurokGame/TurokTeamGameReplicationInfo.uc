class TurokTeamGameReplicationInfo extends TurokMPGameReplicationInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

struct native SavedTeamInfo
{
    var native const int TeamLen;
    var native const array TeamData;
};

var protected transient @NULL mSavedTeams[2];
var int mMaxTeamLives;
var float mFriendlyFireScale;
var transient @NULL mTeamStats[2];
var protected transient int mBestTeamIndex;
var byte mCurrPrimaryTeamIndex;
var int mCurrRound;
var bool mCurrRoundOver;

replication
{
    // Pos:0x000
    if(bNetInitial
        mCurrPrimaryTeamIndex, mCurrRound, 
        mCurrRoundOver, mFriendlyFireScale, 
        mMaxTeamLives;
}

// Export UTurokTeamGameReplicationInfo::execIsFriendlyFireAllowed(FFrame&, void* const)
native function bool IsFriendlyFireAllowed();

simulated event @NULL GetBestTeam(@NULL bestPlayerStillStanding)
{
    // End:0x69
    if(mRecalcScores)
    {
        UpdateTeamStats();
        // End:0x40
        if(bestPlayerStillStanding != none)
        {
            mBestTeamIndex = int(bestPlayerStillStanding.Team.TeamIndex);            
        }
        else
        {
            mBestTeamIndex = ((TeamsInOrder()) ? 0 : 1);
        }
        mRecalcScores = false;
        SortTurokPRIs();
    }
    // DebugMode: 0
    assert((TurokTeamInfo(Teams[mBestTeamIndex]) != none) && int(Teams[mBestTeamIndex].TeamIndex) == mBestTeamIndex);
    return TurokTeamInfo(Teams[mBestTeamIndex]);
    //return ReturnValue;    
}

simulated event byte GetWinningTeam()
{
    // DebugMode: 0
    assert(int(mWinningTeam) != 255);
    return mWinningTeam;
    //return ReturnValue;    
}

protected simulated function UpdateTeamStats()
{
    local int I, J, maxTeams;
    local @NULL PRI, TeamInfo;

    maxTeams = ((self.IsA('TurokCoopGameReplicationInfo')) ? 1 : 2);
    I = 0;
    J0x25:

    // End:0x1FE [Loop If]
    if(I < maxTeams)
    {
        TeamInfo = TurokTeamInfo(Teams[I]);
        // DebugMode: 0
        assert(TeamInfo != none);
        mTeamStats[I].mKills = TeamInfo.mDisconnectedStats.mKills;
        mTeamStats[I].mDeaths = TeamInfo.mDisconnectedStats.mDeaths;
        mTeamStats[I].mAssists = TeamInfo.mDisconnectedStats.mAssists;
        mTeamStats[I].mSuicides = TeamInfo.mDisconnectedStats.mSuicides;
        mTeamStats[I].mFriendly = TeamInfo.mDisconnectedStats.mFriendly;
        mTeamStats[I].mAccScore = TeamInfo.mDisconnectedStats.mAccScore;
        mTeamStats[I].mFlagCaps = TeamInfo.mDisconnectedStats.mFlagCaps;
        mTeamStats[I].mActCount = TeamInfo.mDisconnectedStats.mActCount;
        mTeamStats[I].mActScore = TeamInfo.mDisconnectedStats.mActScore;
        ++I;
        // [Loop Continue]
        goto J0x25;
    }
    I = 0;
    J0x205:

    // End:0x40A [Loop If]
    if(I < PRIArray.Length)
    {
        PRI = TurokMPPlayerReplicationInfo(PRIArray[I]);
        // End:0x400
        if(((PRI != none) && PRI.Team != none) && (int(PRI.Team.TeamIndex) == 0) || int(PRI.Team.TeamIndex) == 1)
        {
            J = int(PRI.Team.TeamIndex);
            mTeamStats[J].mKills += PRI.Kills;
            mTeamStats[J].mDeaths += int(PRI.Deaths);
            mTeamStats[J].mAssists += PRI.mAssists;
            mTeamStats[J].mSuicides += PRI.mSuicides;
            mTeamStats[J].mFriendly += PRI.mFriendly;
            mTeamStats[J].mAccScore += int(PRI.Score);
            mTeamStats[J].mFlagCaps += int(PRI.mFlagCaps);
            mTeamStats[J].mActCount += PRI.mActCount;
            mTeamStats[J].mActScore += PRI.mActScore;
        }
        ++I;
        // [Loop Continue]
        goto J0x205;
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

    Difference = int(Teams[0].Score) - int(Teams[1].Score);
    // End:0x39
    if(Difference < 0)
    {
        return false;
    }
    // End:0x46
    if(Difference > 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mKills - mTeamStats[1].mKills;
    // End:0x7D
    if(Difference < 0)
    {
        return false;
    }
    // End:0x8A
    if(Difference > 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mDeaths - mTeamStats[1].mDeaths;
    // End:0xC1
    if(Difference > 0)
    {
        return false;
    }
    // End:0xCE
    if(Difference < 0)
    {
        return true;
    }
    Difference = mTeamStats[0].mAssists - mTeamStats[1].mAssists;
    // End:0x105
    if(Difference < 0)
    {
        return false;
    }
    // End:0x112
    if(Difference > 0)
    {
        return true;
    }
    return Teams[0].Size > Teams[1].Size;
    //return ReturnValue;    
}

simulated function string TeamScoreToString(int TeamID)
{
    local @NULL ts;

    ts = mTeamStats[TeamID];
    return (((((((("Team" $ string(TeamID)) @ "- S:") $ string(Teams[TeamID].Score)) @ "K:") $ string(ts.mKills)) @ "D:") $ string(ts.mDeaths)) @ "A:") $ string(ts.mAssists);
    //return ReturnValue;    
}

defaultproperties
{
    mCurrPrimaryTeamIndex=255
}