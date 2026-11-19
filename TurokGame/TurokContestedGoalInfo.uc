class TurokContestedGoalInfo extends TurokGoalInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

enum eCGTimeOutWinCondition
{
    keCGTimeOutWinCondition_Disabled,// 0
    keCGTimeOutWinCondition_AwardDominantTeam,// 1
    keCGTimeOutWinCondition_AwardCaptorTeam,// 2
    keCGTimeOutWinCondition_AwardTimeOutWinTeamIfNoOppContention,// 3
    keCGTimeOutWinCondition_AwardTimeOutWinTeamIfUnclaimed,// 4
    keCGTimeOutWinCondition_AwardTimeOutWinTeamIfTeamCaptor,// 5
    keCGTimeOutWinCondition_MAX     // 6
};

var(Objective) private const float mSubGoalWinLimitPercentage;
var(Objective) private const bool mLockedWhenClaimed;
var(Objective) private const bool mMustBeEnabledForTimeOutWin;
var(Objective) private const byte mTimeOutWinCondition[3];
var private repnotify byte mSubGoalState[16];
var private byte mWinnerTeam;
var(Objective) private const int mTimeOutWinTeam;
var private int mSubGoalsCompletedNum[2];
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
    super(Actor).ReplicatedEvent(VarName);
    // End:0x27
    if(VarName == 'mSubGoalState')
    {
        UpdateSubGoalsCompleted();        
    }
    else
    {
        // End:0x52
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
    local int tempTimeOutWinTeam, currTimeOutWinTeam, currTimeOutIndex;

    // End:0x18
    if(!mEnabled && mMustBeEnabledForTimeOutWin)
    {
        return;
    }
    currTimeOutWinTeam = 255;
    currTimeOutIndex = 0;
    J0x27:

    // End:0x14D [Loop If]
    if(currTimeOutIndex < 3)
    {
        switch(mTimeOutWinCondition[currTimeOutIndex])
        {
            // End:0x48
            case 0:
                // End:0x134
                break;
            // End:0x79
            case 1:
                // End:0x5E
                if(int(mWinnerTeam) != 255)
                {
                    // [Explicit Continue]
                    goto J0x134;
                }
                currTimeOutWinTeam = GetDominantTeam();
                // End:0x76
                if(currTimeOutWinTeam != 255)
                {
                }
                // End:0x134
                break;
            // End:0x99
            case 2:
                currTimeOutWinTeam = GetImplicitGoalCaptor();
                // End:0x96
                if(currTimeOutWinTeam != 255)
                {
                }
                // End:0x134
                break;
            // End:0xBA
            case 3:
                // End:0xAC
                if(!IsConditionMetTimeOutWinTeamIfNoOpposition())
                {
                    // [Explicit Continue]
                    goto J0x134;
                }
                currTimeOutWinTeam = mTimeOutWinTeam;
                // End:0x134
                break;
            // End:0xFC
            case 4:
                // End:0xDE
                if((int(mWinnerTeam) != 255) || mTimeOutWinTeam == 255)
                {
                    // [Explicit Continue]
                    goto J0x134;
                }
                // End:0xEE
                if(GetImplicitGoalCaptor() != 255)
                {
                    // [Explicit Continue]
                    goto J0x134;
                }
                currTimeOutWinTeam = mTimeOutWinTeam;
                // End:0x134
                break;
            // End:0x131
            case 5:
                // End:0x110
                if(mTimeOutWinTeam == 255)
                {
                    // [Explicit Continue]
                    goto J0x134;
                }
                // End:0x123
                if(GetImplicitGoalCaptor() != mTimeOutWinTeam)
                {
                    // [Explicit Continue]
                    goto J0x134;
                }
                currTimeOutWinTeam = mTimeOutWinTeam;
                // End:0x134
                break;
            // End:0xFFFF
            default:
                break;
        }
        J0x134:

        // End:0x143
        if(currTimeOutWinTeam != 255)
        {
            // [Explicit Break]
            goto J0x14D;
        }
        ++currTimeOutIndex;
        // [Loop Continue]
        goto J0x27;
    }
    J0x14D:

    // End:0x15B
    if(currTimeOutWinTeam == 255)
    {
        return;
    }
    tempTimeOutWinTeam = int(mWinnerTeam);
    mWinnerTeam = byte(currTimeOutWinTeam);
    // End:0x199
    if(ScoreGoal(currTimeOutWinTeam, none, false))
    {
        mWinnerTeam = byte(currTimeOutWinTeam);        
    }
    else
    {
        mWinnerTeam = byte(tempTimeOutWinTeam);
    }
    //return;    
}

simulated function int GetLeadingTeam()
{
    local int currTopScore, currTopTeam;
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
    currTopTeam = 255;
    currTopScore = -1;
    currTeam = 0;
    J0x3E:

    // End:0xB2 [Loop If]
    if(currTeam < 2)
    {
        currTeamScore = mSubGoalsCompletedNum[currTeam];
        // End:0x91
        if(currTopScore < currTeamScore)
        {
            currTopScore = mSubGoalsCompletedNum[currTeam];
            currTopTeam = currTeam;
            currTopTie = false;
            // [Explicit Continue]
            goto J0xA8;
        }
        // End:0xA8
        if(currTopScore == currTeamScore)
        {
            currTopTie = true;
        }
        J0xA8:

        ++currTeam;
        // [Loop Continue]
        goto J0x3E;
    }
    // End:0xBE
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
    assert((subGoalIndex >= 0) && subGoalIndex < 16);
    return int(mSubGoalState[subGoalIndex]);
    //return ReturnValue;    
}

protected function bool OnSubGoalCapture(int subGoalIndex, @NULL subgoal, @NULL captor, int captorTeamNum, bool isGoalRelevantToInitiator)
{
    local int lastOwnerTeamNum;

    // End:0x1B
    if((captorTeamNum == 255) || !isGoalRelevantToInitiator)
    {
        return false;
    }
    // End:0x36
    if(mLockedWhenClaimed && int(mWinnerTeam) != 255)
    {
        return false;
    }
    // DebugMode: 0
    assert((subGoalIndex >= 0) && subGoalIndex < mSubGoalNum);
    lastOwnerTeamNum = int(mSubGoalState[subGoalIndex]);
    // End:0x77
    if(lastOwnerTeamNum == captorTeamNum)
    {
        return false;
    }
    mSubGoalState[subGoalIndex] = byte(captorTeamNum);
    ++mSubGoalsCompletedNum[captorTeamNum];
    // End:0xF7
    if(lastOwnerTeamNum != 255)
    {
        --mSubGoalsCompletedNum[lastOwnerTeamNum];
        // End:0xF7
        if((int(mWinnerTeam) == lastOwnerTeamNum) && mSubGoalsCompletedNum[lastOwnerTeamNum] < mSubGoalWinLimitNum)
        {
            mWinnerTeam = byte(255);
            LoseGoal(lastOwnerTeamNum, captor);
        }
    }
    // End:0x141
    if((int(mWinnerTeam) == 255) && mSubGoalsCompletedNum[captorTeamNum] >= mSubGoalWinLimitNum)
    {
        // End:0x141
        if(ScoreGoal(captorTeamNum, captor))
        {
            mWinnerTeam = byte(captorTeamNum);
        }
    }
    return true;
    //return ReturnValue;    
}

protected function bool OnSubGoalRelease(int subGoalIndex, @NULL subgoal, @NULL punisher, int punisherTeamNum, bool isGoalRelevantToInitiator)
{
    local int lastOwnerTeamNum;

    // End:0x1B
    if(mLockedWhenClaimed && int(mWinnerTeam) != 255)
    {
        return false;
    }
    // DebugMode: 0
    assert((subGoalIndex >= 0) && subGoalIndex < mSubGoalNum);
    lastOwnerTeamNum = int(mSubGoalState[subGoalIndex]);
    // End:0x6A
    if((lastOwnerTeamNum == 255) || lastOwnerTeamNum == punisherTeamNum)
    {
        return false;
    }
    mSubGoalState[subGoalIndex] = byte(255);
    --mSubGoalsCompletedNum[lastOwnerTeamNum];
    // End:0xCE
    if((int(mWinnerTeam) == lastOwnerTeamNum) && mSubGoalsCompletedNum[lastOwnerTeamNum] < mSubGoalWinLimitNum)
    {
        mWinnerTeam = byte(255);
        LoseGoal(lastOwnerTeamNum, punisher);
    }
    return true;
    //return ReturnValue;    
}

private final simulated function UpdateSubGoalsCompleted()
{
    local int currSubGoal, currSubGoalOwner;

    currSubGoalOwner = 0;
    J0x07:

    // End:0x2A [Loop If]
    if(currSubGoalOwner < 2)
    {
        mSubGoalsCompletedNum[currSubGoalOwner] = 0;
        ++currSubGoalOwner;
        // [Loop Continue]
        goto J0x07;
    }
    currSubGoal = 0;
    J0x31:

    // End:0x90 [Loop If]
    if(currSubGoal < 16)
    {
        currSubGoalOwner = int(mSubGoalState[currSubGoal]);
        // End:0x5F
        if(currSubGoalOwner == 255)
        {
            // [Explicit Continue]
            goto J0x86;
        }
        // DebugMode: 0
        assert((currSubGoalOwner >= 0) && currSubGoalOwner < 2);
        ++mSubGoalsCompletedNum[currSubGoalOwner];
        J0x86:

        ++currSubGoal;
        // [Loop Continue]
        goto J0x31;
    }
    //return;    
}

private final function InitGoalStatus()
{
    local int currSubGoal, currTeam;

    mWinnerTeam = byte(255);
    currSubGoal = 0;
    J0x11:

    // End:0x37 [Loop If]
    if(currSubGoal < 16)
    {
        mSubGoalState[currSubGoal] = byte(255);
        ++currSubGoal;
        // [Loop Continue]
        goto J0x11;
    }
    currSubGoal = 0;
    J0x3E:

    // End:0xAF [Loop If]
    if(currSubGoal < mSubGoalNum)
    {
        // DebugMode: 0
        assert(mSubGoals[currSubGoal] != none);
        currTeam = mSubGoals[currSubGoal].mInitialTeamOwner;
        // End:0xA5
        if((currTeam >= 0) && currTeam < 2)
        {
            mSubGoalState[currSubGoal] = byte(currTeam);
        }
        ++currSubGoal;
        // [Loop Continue]
        goto J0x3E;
    }
    UpdateSubGoalsCompleted();
    //return;    
}

private final function int GetDominantTeam()
{
    local int dominantTeam, dominantTeamSubGoalCount, currTeamSubGoalCount, currTeam;

    dominantTeam = 255;
    dominantTeamSubGoalCount = -1;
    currTeam = 0;
    J0x1A:

    // End:0x80 [Loop If]
    if(currTeam < 2)
    {
        currTeamSubGoalCount = mSubGoalsCompletedNum[currTeam];
        // End:0x5F
        if(dominantTeamSubGoalCount < currTeamSubGoalCount)
        {
            dominantTeamSubGoalCount = currTeamSubGoalCount;
            dominantTeam = currTeam;
            // [Explicit Continue]
            goto J0x76;
        }
        // End:0x76
        if(dominantTeamSubGoalCount == currTeamSubGoalCount)
        {
            dominantTeam = 255;
        }
        J0x76:

        ++currTeam;
        // [Loop Continue]
        goto J0x1A;
    }
    return dominantTeam;
    //return ReturnValue;    
}

private final function int GetImplicitGoalCaptor()
{
    local int dominantTeam;

    // End:0x16
    if(int(mWinnerTeam) != 255)
    {
        return int(mWinnerTeam);
    }
    dominantTeam = GetDominantTeam();
    // End:0x31
    if(dominantTeam == 255)
    {
        return 255;
    }
    // End:0x4C
    if(mSubGoalsCompletedNum[dominantTeam] >= mSubGoalWinLimitNum)
    {
        return dominantTeam;
    }
    return 255;
    //return ReturnValue;    
}

private final function bool IsConditionMetTimeOutWinTeamIfNoOpposition()
{
    local int currTeam;

    // End:0x1E
    if((int(mWinnerTeam) != 255) || mTimeOutWinTeam == 255)
    {
        return false;
    }
    currTeam = 0;
    J0x25:

    // End:0x60 [Loop If]
    if(currTeam < 2)
    {
        // End:0x43
        if(currTeam == mTimeOutWinTeam)
        {
            // [Explicit Continue]
            goto J0x56;
        }
        // End:0x56
        if(mSubGoalsCompletedNum[currTeam] > 0)
        {
            return false;
        }
        J0x56:

        ++currTeam;
        // [Loop Continue]
        goto J0x25;
    }
    return true;
    //return ReturnValue;    
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
    mTimeOutWinTeam=255
    // Reference: SpriteComponent'Default__TurokContestedGoalInfo.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}