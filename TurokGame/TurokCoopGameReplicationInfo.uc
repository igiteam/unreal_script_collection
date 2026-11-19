class TurokCoopGameReplicationInfo extends TurokTeamGameReplicationInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

var private int mFirstCoopGoalID;
var private int mFinalCoopGoalID;
var private @NULL mCoopTeamGoals[32];
var private int mCoopGoalCount;
var private repnotify int mCurrentCoopGoalID;
var private @NULL mCurrentCoopGoal;

replication
{
    // Pos:0x000
    if(bNetDirty
        mCurrentCoopGoalID;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x20
    if(VarName == 'mCurrentCoopGoalID')
    {
        SimulatedSetNextCurrentCoopGoalID();        
    }
    else
    {
        super(TurokMPGameReplicationInfo).ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local int I;
    local @NULL TTGI;

    super(TurokMPGameReplicationInfo).PostBeginPlay();
    mFirstCoopGoalID = 31 + 1;
    mFinalCoopGoalID = 0 - 1;
    mCoopGoalCount = 0;
    // End:0x13D
    foreach AllActors(Class'TurokTeamGoalInfo', TTGI)
    {
        switch(TTGI.GetCoopTeamGoalType())
        {
            // End:0x4C
            case 1:
            // End:0x139
            case 2:
                I = TTGI.GetCoopTeamGoalID();
                // End:0x86
                if((I < 0) || I > 31)
                {                    
                }
                else
                {
                    // End:0x9A
                    if(mCoopTeamGoals[I] != none)
                    {                        
                    }
                    else
                    {
                        // End:0xD6
                        if((TTGI.GetCoopDefendTime() < 1) && int(TTGI.GetCoopTeamGoalType()) == int(2))
                        {                            
                        }
                        else
                        {
                            TTGI.EnableTeamGoalInfo(false);
                            // End:0x104
                            if(mFirstCoopGoalID > I)
                            {
                                mFirstCoopGoalID = I;
                            }
                            // End:0x11E
                            if(mFinalCoopGoalID < I)
                            {
                                mFinalCoopGoalID = I;
                            }
                            mCoopTeamGoals[I] = TTGI;
                            mCoopGoalCount++;
                        }
                    }
                }
                // End:0x13C
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }    
    //return;    
}

function Reset()
{
    super(GameReplicationInfo).Reset();
    mCurrentCoopGoalID = -1;
    //return;    
}

function InitCurrentCoopGoalID()
{
    // End:0x36
    if((((mFirstCoopGoalID < 0) || mFirstCoopGoalID > 31) || mFinalCoopGoalID < 0) || mFinalCoopGoalID > 31)
    {
        return;
    }
    // End:0x60
    if(mCurrentCoopGoalID == -1)
    {
        mCurrentCoopGoalID = mFirstCoopGoalID - 1;
        SetNextCurrentCoopGoalID();        
    }
    else
    {
        // End:0x7F
        if(mCurrentCoopGoal != none)
        {
            mCurrentCoopGoal.EnableTeamGoalInfo(true);
        }
    }
    //return;    
}

simulated function int GetCurrentCoopGoalID()
{
    return mCurrentCoopGoalID;
    //return ReturnValue;    
}

simulated function @NULL GetCurrentCoopGoal()
{
    return mCurrentCoopGoal;
    //return ReturnValue;    
}

simulated function int GetFirstCoopGoalID()
{
    return mFirstCoopGoalID;
    //return ReturnValue;    
}

simulated function int GetFinalCoopGoalID()
{
    return mFinalCoopGoalID;
    //return ReturnValue;    
}

simulated function SimulatedSetNextCurrentCoopGoalID()
{
    local @NULL PC;

    // End:0x42
    if(mCurrentCoopGoal == none)
    {
        // End:0x3F
        if(mCurrentCoopGoalID != -1)
        {
            mCurrentCoopGoal = mCoopTeamGoals[mCurrentCoopGoalID];
            mCurrentCoopGoal.EnableTeamGoalInfo(true);
        }        
    }
    else
    {
        mCurrentCoopGoal.EnableTeamGoalInfo(false);
        mCurrentCoopGoal = none;
        // End:0xE4
        if(mCurrentCoopGoalID != -1)
        {
            mCurrentCoopGoal = mCoopTeamGoals[mCurrentCoopGoalID];
            mCurrentCoopGoal.EnableTeamGoalInfo(true);
            // End:0xD6
            if(int(mCurrentCoopGoal.GetCoopTeamGoalType()) == int(2))
            {
                RemainingMinute = mCurrentCoopGoal.GetCoopDefendTime();
                RemainingTime = RemainingMinute;                
            }
            else
            {
                RemainingMinute = 0;
                RemainingTime = 0;
            }
        }
    }
    // End:0x11F
    if(mCurrentCoopGoal != none)
    {
        // End:0x11E
        foreach LocalPlayerControllers(PC)
        {
            mCurrentCoopGoal.OnCoopGoalActivated(TurokPlayerController(PC));
            // End:0x11E
            break;            
        }        
    }
    //return;    
}

function SetNextCurrentCoopGoalID()
{
    local int I;
    local @NULL PC;

    // End:0x36
    if((((mFirstCoopGoalID < 0) || mFirstCoopGoalID > 31) || mFinalCoopGoalID < 0) || mFinalCoopGoalID > 31)
    {
        return;
    }
    // End:0x55
    if(mCurrentCoopGoal != none)
    {
        mCurrentCoopGoal.EnableTeamGoalInfo(false);
    }
    I = mCurrentCoopGoalID + 1;
    J0x63:

    // End:0x9B [Loop If]
    if(I <= mFinalCoopGoalID)
    {
        // End:0x91
        if(mCoopTeamGoals[I] != none)
        {
            mCurrentCoopGoalID = I;
            // [Explicit Break]
            goto J0x9B;
        }
        ++I;
        // [Loop Continue]
        goto J0x63;
    }
    J0x9B:

    // DebugMode: 0
    assert(mCurrentCoopGoalID == I);
    mCurrentCoopGoal = mCoopTeamGoals[mCurrentCoopGoalID];
    // DebugMode: 0
    assert(mCurrentCoopGoal != none);
    // End:0x115
    if(int(mCurrentCoopGoal.GetCoopTeamGoalType()) == int(2))
    {
        bStopCountDown = false;
        RemainingMinute = mCurrentCoopGoal.GetCoopDefendTime();
        RemainingTime = RemainingMinute;        
    }
    else
    {
        bStopCountDown = true;
        RemainingMinute = 0;
        RemainingTime = 0;
    }
    mCurrentCoopGoal.EnableTeamGoalInfo(true);
    // End:0x16E
    foreach LocalPlayerControllers(PC)
    {
        mCurrentCoopGoal.OnCoopGoalActivated(TurokPlayerController(PC));
        // End:0x16E
        break;        
    }    
    //return;    
}

function bool IsTieBreaker()
{
    return false;
    //return ReturnValue;    
}

simulated event @NULL GetBestTeam(@NULL Unused)
{
    // End:0x52
    if(mRecalcScores)
    {
        UpdateTeamStats();
        // End:0x39
        if(float(mCoopGoalCount) == Teams[0].Score)
        {
            mBestTeamIndex = 0;            
        }
        else
        {
            mBestTeamIndex = 1;
        }
        mRecalcScores = false;
        SortTurokPRIs();
    }
    // DebugMode: 0
    assert((TurokTeamInfo(Teams[mBestTeamIndex]) != none) && int(Teams[mBestTeamIndex].TeamIndex) == mBestTeamIndex);
    return TurokTeamInfo(Teams[mBestTeamIndex]);
    //return ReturnValue;    
}

simulated function PlayTimeWarning()
{
    //return;    
}

defaultproperties
{
    mFirstCoopGoalID=-1
    mFinalCoopGoalID=-1
    mCurrentCoopGoalID=-1
}