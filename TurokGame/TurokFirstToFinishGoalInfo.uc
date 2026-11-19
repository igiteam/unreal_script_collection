class TurokFirstToFinishGoalInfo extends TurokGoalInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

const TUROKFIRSTTOFINISHGOALINFO_SUBGOALSARRAY_MAX = 64;

var(Objective) private const float mSubGoalWinLimitPercentage;
var(Objective) private const bool mTimeOutAwardDominantTeam;
var(Objective) private const bool mMustBeEnabledForTimeOutWin;
var private repnotify int mSubGoalState[64];
var private int mSubGoalsCompletedNum[2];
var private byte mWinnerTeam;
var private int mSubGoalWinLimitNum;

replication
{
    // Pos:0x000
    if(bNetDirty
        mSubGoalState, mWinnerTeam;
}

function PostBeginPlay()
{
    super.PostBeginPlay();
    mSubGoalWinLimitNum = GetSubGoalWinLimitNum(mSubGoalNum, int(mSubGoalWinLimitPercentage));
    InitGoalStatus();
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local int currTeamIndex, numTeams;

    super(Actor).ReplicatedEvent(VarName);
    // End:0x54
    if(VarName == 'mSubGoalState')
    {
        numTeams = 2;
        currTeamIndex = 0;
        J0x2D:

        // End:0x51 [Loop If]
        if(currTeamIndex < numTeams)
        {
            UpdateSubGoalsCompleted(currTeamIndex);
            ++currTeamIndex;
            // [Loop Continue]
            goto J0x2D;
        }        
    }
    else
    {
        // End:0x7F
        if(VarName == 'mSubGoalNum')
        {
            mSubGoalWinLimitNum = GetSubGoalWinLimitNum(mSubGoalNum, int(mSubGoalWinLimitPercentage));
        }
    }
    //return;    
}

simulated function Reset()
{
    super.Reset();
    InitGoalStatus();
    //return;    
}

event Destroyed()
{
    super(Actor).Destroyed();
    //return;    
}

function OnGameTimeOut()
{
    local int numTeams, currTeam, currTopTeamSubGoalCount, currTeamSubGoalCount, currTimeOutWinTeam;

    // End:0x1D
    if((int(mWinnerTeam) != 255) || !mTimeOutAwardDominantTeam)
    {
        return;
    }
    // End:0x35
    if(!mEnabled && mMustBeEnabledForTimeOutWin)
    {
        return;
    }
    numTeams = 2;
    currTimeOutWinTeam = 255;
    currTopTeamSubGoalCount = -1;
    currTeam = 0;
    J0x57:

    // End:0xC0 [Loop If]
    if(currTeam < numTeams)
    {
        currTeamSubGoalCount = mSubGoalsCompletedNum[currTeam];
        // End:0x9F
        if(currTopTeamSubGoalCount < currTeamSubGoalCount)
        {
            currTimeOutWinTeam = currTeam;
            currTopTeamSubGoalCount = currTeamSubGoalCount;
            // [Explicit Continue]
            goto J0xB6;
        }
        // End:0xB6
        if(currTopTeamSubGoalCount == currTeamSubGoalCount)
        {
            currTimeOutWinTeam = 255;
        }
        J0xB6:

        ++currTeam;
        // [Loop Continue]
        goto J0x57;
    }
    // End:0xCE
    if(currTimeOutWinTeam == 255)
    {
        return;
    }
    // End:0xEF
    if(ScoreGoal(currTimeOutWinTeam, none, false))
    {
        mWinnerTeam = byte(currTimeOutWinTeam);
    }
    //return;    
}

simulated function int GetLeadingTeam()
{
    local int numTeams, currTopScore, currTopTeam;
    local bool currTopTie;
    local int currTeam, currTeamScore;

    // End:0x16
    if(int(mWinnerTeam) != 255)
    {
        return int(mWinnerTeam);
    }
    // End:0x24
    if(!mEnabled)
    {
        return 255;
    }
    numTeams = 2;
    currTopTeam = 255;
    currTopScore = -1;
    currTeam = 0;
    J0x46:

    // End:0xBD [Loop If]
    if(currTeam < numTeams)
    {
        currTeamScore = mSubGoalsCompletedNum[currTeam];
        // End:0x9C
        if(currTopScore < currTeamScore)
        {
            currTopScore = mSubGoalsCompletedNum[currTeam];
            currTopTeam = currTeam;
            currTopTie = false;
            // [Explicit Continue]
            goto J0xB3;
        }
        // End:0xB3
        if(currTopScore == currTeamScore)
        {
            currTopTie = true;
        }
        J0xB3:

        ++currTeam;
        // [Loop Continue]
        goto J0x46;
    }
    // End:0xC9
    if(currTopTie)
    {
        return 255;
    }
    return currTopTeam;
    //return ReturnValue;    
}

simulated function int GetSubGoalOwnerStatus(int subGoalIndex, int queryTeamIndex)
{
    // DebugMode: 0
    assert((queryTeamIndex >= 0) && queryTeamIndex < 2);
    // DebugMode: 0
    assert((subGoalIndex >= 0) && subGoalIndex < 16);
    // End:0x56
    if(mSubGoalState[(queryTeamIndex * 16) + subGoalIndex] > 0)
    {
        return queryTeamIndex;
    }
    return 255;
    //return ReturnValue;    
}

protected function bool OnSubGoalCapture(int subGoalIndex, @NULL subgoal, @NULL captor, int captorTeamNum, bool isGoalRelevantToInitiator)
{
    local int subgoalArrayIndex, tempTeamNum;

    // End:0x1B
    if(!isGoalRelevantToInitiator || captorTeamNum == 255)
    {
        return false;
    }
    // End:0x28
    if(captor == none)
    {
        return false;
    }
    // End:0x38
    if(int(mWinnerTeam) != 255)
    {
        return false;
    }
    // DebugMode: 0
    assert((subGoalIndex >= 0) && subGoalIndex < mSubGoalNum);
    subgoalArrayIndex = (captorTeamNum * 16) + subGoalIndex;
    // End:0x7E
    if(mSubGoalState[subgoalArrayIndex] > 0)
    {
        return false;
    }
    mSubGoalState[subgoalArrayIndex] = 1;
    ++mSubGoalsCompletedNum[captorTeamNum];
    // End:0xFC
    if(mSubGoalsCompletedNum[captorTeamNum] >= mSubGoalWinLimitNum)
    {
        tempTeamNum = int(mWinnerTeam);
        mWinnerTeam = byte(captorTeamNum);
        // End:0xEF
        if(ScoreGoal(captorTeamNum, captor))
        {
            mWinnerTeam = byte(captorTeamNum);            
        }
        else
        {
            mWinnerTeam = byte(tempTeamNum);
        }
    }
    return true;
    //return ReturnValue;    
}

protected function bool OnSubGoalRelease(int subGoalIndex, @NULL subgoal, @NULL punisher, int punisherTeamNum, bool isGoalRelevantToInitiator)
{
    local int subgoalArrayIndex;

    // End:0x1B
    if(!isGoalRelevantToInitiator || punisherTeamNum == 255)
    {
        return false;
    }
    // End:0x2B
    if(int(mWinnerTeam) != 255)
    {
        return false;
    }
    // DebugMode: 0
    assert((subGoalIndex >= 0) && subGoalIndex < mSubGoalNum);
    subgoalArrayIndex = (punisherTeamNum * 16) + subGoalIndex;
    // End:0x71
    if(mSubGoalState[subgoalArrayIndex] == 0)
    {
        return false;
    }
    mSubGoalState[subgoalArrayIndex] = 0;
    --mSubGoalsCompletedNum[punisherTeamNum];
    return true;
    //return ReturnValue;    
}

private final simulated function UpdateSubGoalsCompleted(int TeamIndex)
{
    local int currSubGoal, completedSubGoals;

    // DebugMode: 0
    assert((TeamIndex >= 0) && TeamIndex < 2);
    currSubGoal = 0;
    J0x21:

    // End:0x5A [Loop If]
    if(currSubGoal < 16)
    {
        // End:0x50
        if(mSubGoalState[(TeamIndex * 16) + currSubGoal] > 0)
        {
            ++completedSubGoals;
        }
        ++currSubGoal;
        // [Loop Continue]
        goto J0x21;
    }
    mSubGoalsCompletedNum[TeamIndex] = completedSubGoals;
    //return;    
}

private final function InitGoalStatus()
{
    local int numTeams, currTeam, currSubGoal, maxSubGoalStateIndex;

    numTeams = 2;
    maxSubGoalStateIndex = numTeams * 16;
    currSubGoal = 0;
    J0x1E:

    // End:0x44 [Loop If]
    if(currSubGoal < maxSubGoalStateIndex)
    {
        mSubGoalState[currSubGoal] = 0;
        ++currSubGoal;
        // [Loop Continue]
        goto J0x1E;
    }
    currSubGoal = 0;
    J0x4B:

    // End:0xC4 [Loop If]
    if(currSubGoal < mSubGoalNum)
    {
        // DebugMode: 0
        assert(mSubGoals[currSubGoal] != none);
        currTeam = mSubGoals[currSubGoal].mInitialTeamOwner;
        // End:0xBA
        if((currTeam >= 0) && currTeam < numTeams)
        {
            mSubGoalState[(currTeam * 16) + currSubGoal] = 1;
        }
        ++currSubGoal;
        // [Loop Continue]
        goto J0x4B;
    }
    currTeam = 0;
    J0xCB:

    // End:0xEF [Loop If]
    if(currTeam < numTeams)
    {
        UpdateSubGoalsCompleted(currTeam);
        ++currTeam;
        // [Loop Continue]
        goto J0xCB;
    }
    mWinnerTeam = byte(255);
    //return;    
}

private final simulated function int GetSubGoalWinLimitNum(int NumGoals, int targetPct)
{
    local int targetGoals;

    // End:0x0D
    if(NumGoals <= 0)
    {
        return 0;
    }
    targetGoals = int((float(NumGoals * targetPct) / 100.0000000) + 0.5000000);
    // End:0x3E
    if(targetGoals <= 0)
    {
        return 1;
    }
    return targetGoals;
    //return ReturnValue;    
}

defaultproperties
{
    mSubGoalWinLimitPercentage=100.0000000
    mMustBeEnabledForTimeOutWin=true
    mWinnerTeam=255
    // Reference: SpriteComponent'Default__TurokFirstToFinishGoalInfo.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}