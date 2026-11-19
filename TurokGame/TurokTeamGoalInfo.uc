class TurokTeamGoalInfo extends TurokGoalInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision)
    autoexpandcategories(Objective);

enum eTGTimeOutWinCondition
{
    keTGTimeOutWinCondition_Disabled,// 0
    keTGTimeOutWinCondition_AwardOwnerTeamIfCaptor,// 1
    keTGTimeOutWinCondition_AwardTimeOutAltWinTeamIfUnclaimed,// 2
    keTGTimeOutWinCondition_MAX     // 3
};

enum eCoopTeamGoalType
{
    keCoopTeamGoalType_NotApplicable,// 0
    keCoopTeamGoalType_Assault,     // 1
    keCoopTeamGoalType_Defense,     // 2
    keCoopTeamGoalType_MAX          // 3
};

var(Objective) private const float mSubGoalWinLimitPercentage;
var(Objective) private const bool mMustBeEnabledForTimeOutWin;
var(Objective) private const bool mLockedWhenClaimed;
var(Objective) private const byte mTimeOutWinCondition;
var(Objective) private const byte mCoopTeamGoalType;
var private repnotify byte mSubGoalState[16];
var private byte mWinnerTeam;
var(Objective) private const int mOwnerTeamID;
var(Objective) private const int mTimeOutAltWinTeamID;
var(Objective) private const int mCoopTeamGoalID;
var(Objective) private const int mCoopDefendTime;
var(Objective) private const editinline @NULL mCoopMissionInf;
var private int mSubGoalsCompletedNum;
var private int mSubGoalWinLimitNum;
var private @NULL mIndicator;

replication
{
    // Pos:0x000
    if(bNetDirty
        mSubGoalState, mWinnerTeam;
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

function PostBeginPlay()
{
    super.PostBeginPlay();
    mSubGoalWinLimitNum = GetSubGoalWinLimitNum(mSubGoalNum, int(mSubGoalWinLimitPercentage));
    InitGoalStatus();
    // End:0x5C
    if(int(mCoopTeamGoalType) == int(1))
    {
        mIndicator = __NFUN_278__(Class'TurokGoalIndicator', self);
        mIndicator.Initialize(self);
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
    // End:0x17
    if(mIndicator != none)
    {
        mIndicator.Destroy();
    }
    super(Actor).Destroyed();
    //return;    
}

function OnGameTimeOut()
{
    // End:0x18
    if(!mEnabled && mMustBeEnabledForTimeOutWin)
    {
        return;
    }
    switch(mTimeOutWinCondition)
    {
        // End:0x29
        case 0:
            return;
            // End:0xDD
            break;
        // End:0x92
        case 1:
            // End:0x40
            if(int(mTimeOutWinCondition) == int(0))
            {
                return;
            }
            // DebugMode: 0
            assert((mOwnerTeamID >= 0) && mOwnerTeamID < 2);
            // End:0x6C
            if(GetImplicitGoalCaptor() != mOwnerTeamID)
            {
                return;
            }
            // End:0x8D
            if(ScoreGoal(mOwnerTeamID, none, false))
            {
                mWinnerTeam = byte(mOwnerTeamID);
            }
            return;
            // End:0xDD
            break;
        // End:0xDA
        case 2:
            // End:0xB4
            if((mTimeOutAltWinTeamID == 255) || GetImplicitGoalCaptor() != 255)
            {
                return;
            }
            // End:0xD5
            if(ScoreGoal(mTimeOutAltWinTeamID, none, false))
            {
                mWinnerTeam = byte(mTimeOutAltWinTeamID);
            }
            return;
            // End:0xDD
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

simulated function int GetLeadingTeam()
{
    return int(mWinnerTeam);
    //return ReturnValue;    
}

simulated function int GetSubGoalOwnerStatus(int subGoalIndex, int queryTeamIndex)
{
    // DebugMode: 0
    assert((subGoalIndex >= 0) && subGoalIndex < 16);
    return int(mSubGoalState[subGoalIndex]);
    //return ReturnValue;    
}

simulated function byte GetCoopTeamGoalType()
{
    return mCoopTeamGoalType;
    //return ReturnValue;    
}

simulated function int GetCoopTeamGoalID()
{
    return mCoopTeamGoalID;
    //return ReturnValue;    
}

simulated function int GetCoopDefendTime()
{
    return mCoopDefendTime;
    //return ReturnValue;    
}

function EnableTeamGoalInfo(bool F)
{
    SetEnableState(F);
    //return;    
}

protected function SetEnableState(bool Enable)
{
    super.SetEnableState(Enable);
    // End:0x49
    if(mIndicator != none)
    {
        // End:0x36
        if(Enable)
        {
            mIndicator.Activate();            
        }
        else
        {
            mIndicator.Deactivate();
        }
    }
    //return;    
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
    assert((mOwnerTeamID >= 0) && mOwnerTeamID < 2);
    // DebugMode: 0
    assert((subGoalIndex >= 0) && subGoalIndex < mSubGoalNum);
    captorTeamNum = mOwnerTeamID;
    lastOwnerTeamNum = int(mSubGoalState[subGoalIndex]);
    // End:0x9C
    if(lastOwnerTeamNum == captorTeamNum)
    {
        return false;
    }
    ++mSubGoalsCompletedNum;
    mSubGoalState[subGoalIndex] = byte(captorTeamNum);
    // End:0xFA
    if((int(mWinnerTeam) == 255) && mSubGoalsCompletedNum >= mSubGoalWinLimitNum)
    {
        // End:0xFA
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
    --mSubGoalsCompletedNum;
    // End:0xC2
    if((int(mWinnerTeam) == lastOwnerTeamNum) && mSubGoalsCompletedNum < mSubGoalWinLimitNum)
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

    mSubGoalsCompletedNum = 0;
    currSubGoal = 0;
    J0x0E:

    // End:0x6A [Loop If]
    if(currSubGoal < 16)
    {
        currSubGoalOwner = int(mSubGoalState[currSubGoal]);
        // End:0x3F
        if(currSubGoalOwner != mOwnerTeamID)
        {
            // [Explicit Continue]
            goto J0x60;
        }
        // DebugMode: 0
        assert((currSubGoalOwner >= 0) && currSubGoalOwner < 2);
        ++mSubGoalsCompletedNum;
        J0x60:

        ++currSubGoal;
        // [Loop Continue]
        goto J0x0E;
    }
    //return;    
}

private final function InitGoalStatus()
{
    local int currSubGoal;

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

    // End:0x9A [Loop If]
    if(currSubGoal < mSubGoalNum)
    {
        // DebugMode: 0
        assert(mSubGoals[currSubGoal] != none);
        // End:0x90
        if(mSubGoals[currSubGoal].mInitialTeamOwner == mOwnerTeamID)
        {
            mSubGoalState[currSubGoal] = byte(mOwnerTeamID);
        }
        ++currSubGoal;
        // [Loop Continue]
        goto J0x3E;
    }
    UpdateSubGoalsCompleted();
    //return;    
}

private final function int GetImplicitGoalCaptor()
{
    // End:0x16
    if(int(mWinnerTeam) != 255)
    {
        return int(mWinnerTeam);
    }
    // End:0x2B
    if(mSubGoalsCompletedNum >= mSubGoalWinLimitNum)
    {
        return mOwnerTeamID;
    }
    return 255;
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

simulated function OnCoopGoalActivated(@NULL TPC)
{
    local @NULL Localization, HUD;

    HUD = TurokHud(TPC.myHUD);
    // End:0x105
    if(((HUD != none) && mCoopMissionInf != none) && int(TPC.mWinReasonRoundOver) == int(0))
    {
        Localization = Class'TurokEngine.TurokUI'.static.GetEngine().GetLocalization();
        HUD.mObjectiveText.InitObjText(Localization.HashAHashString(mCoopMissionInf.ObjectiveText));
        // End:0x105
        if((mCoopMissionInf.ObjectiveSpeech != none) && HUD.mSoundController != none)
        {
            HUD.mSoundController.PlayQueuedSound(mCoopMissionInf.ObjectiveSpeech);
        }
    }
    //return;    
}

simulated function bool GetObjectiveStrings(out int TitleHashID, out int TextHashID)
{
    local @NULL Localization;

    // End:0x82
    if(mCoopMissionInf != none)
    {
        Localization = Class'TurokEngine.TurokUI'.static.GetEngine().GetLocalization();
        TitleHashID = Localization.HashAHashString(mCoopMissionInf.ObjectiveTitle);
        TextHashID = Localization.HashAHashString(mCoopMissionInf.ObjectiveText);
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool GetWinLossSpeech(byte WinningTeam, out @NULL SpeechCue)
{
    local @NULL GRI;

    GRI = TurokCoopGameReplicationInfo(WorldInfo.GRI);
    // End:0x6B
    if((mCoopMissionInf != none) && GRI != none)
    {
        // End:0x55
        if(int(WinningTeam) == 0)
        {
            SpeechCue = mCoopMissionInf.WinSpeech;            
        }
        else
        {
            SpeechCue = mCoopMissionInf.LossSpeech;
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    mSubGoalWinLimitPercentage=100.0000000
    mMustBeEnabledForTimeOutWin=true
    mWinnerTeam=255
    mOwnerTeamID=255
    mTimeOutAltWinTeamID=255
    mCoopTeamGoalID=-1
    mCoopDefendTime=300
    // Reference: SpriteComponent'Default__TurokTeamGoalInfo.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}