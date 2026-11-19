class TurokGoalInfo extends ReplicationInfo
    abstract
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

const TUROKGOALINFO_MAXTEAMS = 2;
const TUROKGOALINFO_MAXSUBGOALS = 16;

enum eGoalTeamSpecStatus
{
    keGoalTeamSpecStatus_NotRelevant,// 0
    keGoalTeamSpecStatus_NoScoreOnCapture,// 1
    keGoalTeamSpecStatus_ScoreOnCapture,// 2
    keGoalTeamSpecStatus_GameWinOnCapture,// 3
    keGoalTeamSpecStatus_MAX        // 4
};

enum eGoalTeamIndicatorStatus
{
    keGoalTeamIndicatorStatus_Enabled,// 0
    keGoalTeamIndicatorStatus_Disabled,// 1
    keGoalTeamIndicatorStatus_MAX   // 2
};

var(Objective) bool mEnabled;
var private bool mEnabledInitial;
var(Objective) const byte mTeamSpecs[2];
var(Objective) const @NULL mObjectiveLocation;
var protected @NULL mSubGoals[16];
var repnotify int mSubGoalNum;

replication
{
    // Pos:0x000
    if(bNetInitial
        mSubGoalNum;
}

function OnGameTimeOut()
{
    //return;    
}

simulated function int GetLeadingTeam()
{
    //return ReturnValue;    
}

simulated function int GetSubGoalOwnerStatus(int subGoalIndex, int queryTeamIndex)
{
    //return ReturnValue;    
}

simulated function @NULL GetIndicator()
{
    //return ReturnValue;    
}

protected function bool OnSubGoalCapture(int subGoalIndex, @NULL subgoal, @NULL captor, int captorTeamID, bool isGoalRelevantToInitiator)
{
    //return ReturnValue;    
}

protected function bool OnSubGoalRelease(int subGoalIndex, @NULL subgoal, @NULL punisher, int punisherTeamID, bool isGoalRelevantToInitiator)
{
    //return ReturnValue;    
}

protected function OnSubGoalStateChange(int subGoalIndex, @NULL subgoal)
{
    //return;    
}

simulated event PreBeginPlay()
{
    local @NULL currSubGoal;

    super(Actor).PreBeginPlay();
    // End:0x65
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x64
        foreach AllActors(Class'TurokSubGoal', currSubGoal)
        {
            // End:0x3E
            if(currSubGoal.mOwnerGoal != self)
            {
                continue;                
            }
            // DebugMode: 0
            assert(mSubGoalNum < 16);
            mSubGoals[mSubGoalNum] = currSubGoal;
            ++mSubGoalNum;            
        }        
    }
    //return;    
}

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    mEnabledInitial = mEnabled;
    //return;    
}

simulated function Reset()
{
    super(Actor).Reset();
    SetEnableState(mEnabledInitial);
    //return;    
}

final function bool SubGoalEvaluateCapture(@NULL subgoal, @NULL captor)
{
    local int subGoalIndex, captorTeamID;
    local bool isGoalRelevantToInitiator, retValue;

    // End:0x0D
    if(!mEnabled)
    {
        return false;
    }
    subGoalIndex = GetSubGoalIndex(subgoal);
    // End:0x2F
    if(subGoalIndex < 0)
    {
        return false;
    }
    // End:0x58
    if(captor != none)
    {
        captorTeamID = int(captor.GetTeamNum());        
    }
    else
    {
        captorTeamID = 255;
    }
    // End:0x93
    if((captorTeamID >= 0) && captorTeamID < 2)
    {
        isGoalRelevantToInitiator = int(mTeamSpecs[captorTeamID]) != int(0);
    }
    retValue = OnSubGoalCapture(subGoalIndex, subgoal, captor, captorTeamID, isGoalRelevantToInitiator);
    return retValue;
    //return ReturnValue;    
}

final function bool SubGoalEvaluateRelease(@NULL subgoal, @NULL punisher)
{
    local int subGoalIndex, punisherTeamID;
    local bool isGoalRelevantToInitiator;

    // End:0x0D
    if(!mEnabled)
    {
        return false;
    }
    subGoalIndex = GetSubGoalIndex(subgoal);
    // End:0x2F
    if(subGoalIndex < 0)
    {
        return false;
    }
    // End:0x58
    if(punisher != none)
    {
        punisherTeamID = int(punisher.GetTeamNum());        
    }
    else
    {
        punisherTeamID = 255;
    }
    // End:0x96
    if((punisherTeamID >= 0) && punisherTeamID < 2)
    {
        isGoalRelevantToInitiator = int(mTeamSpecs[punisherTeamID]) != int(0);        
    }
    else
    {
        isGoalRelevantToInitiator = false;
    }
    return OnSubGoalRelease(subGoalIndex, subgoal, punisher, punisherTeamID, isGoalRelevantToInitiator);
    //return ReturnValue;    
}

final function SubGoalStateChange(@NULL subgoal)
{
    local int subGoalIndex;

    subGoalIndex = GetSubGoalIndex(subgoal);
    // End:0x34
    if(subGoalIndex >= 0)
    {
        OnSubGoalStateChange(subGoalIndex, subgoal);
    }
    //return;    
}

function OnToggle(@NULL Action)
{
    // End:0x2C
    if(Action.InputLinks[0].bHasImpulse)
    {
        SetEnableState(true);        
    }
    else
    {
        // End:0x58
        if(Action.InputLinks[1].bHasImpulse)
        {
            SetEnableState(false);            
        }
        else
        {
            // End:0x89
            if(Action.InputLinks[2].bHasImpulse)
            {
                SetEnableState(!mEnabled);
            }
        }
    }
    //return;    
}

protected function int GetSubGoalIndex(@NULL subgoal)
{
    local int currIndex;

    // End:0x11
    if(subgoal == none)
    {
        return -1;
    }
    currIndex = 0;
    J0x18:

    // End:0x4C [Loop If]
    if(currIndex < mSubGoalNum)
    {
        // End:0x42
        if(mSubGoals[currIndex] == subgoal)
        {
            return currIndex;
        }
        ++currIndex;
        // [Loop Continue]
        goto J0x18;
    }
    return -1;
    //return ReturnValue;    
}

protected function SetEnableState(bool Enable)
{
    // End:0x13
    if(Enable == mEnabled)
    {
        return;
    }
    mEnabled = Enable;
    //return;    
}

protected function bool ScoreGoal(int TeamID, @NULL Effector, optional bool isCaptureScore = true)
{
    local @NULL warGameInfo, effectorController;

    // End:0x38
    if(((TeamID < 0) || TeamID >= 2) || int(mTeamSpecs[TeamID]) == int(0))
    {
        return false;
    }
    TriggerEventClass(Class'TurokSeqEvent_GoalGained', Effector);
    // End:0x87
    if(isCaptureScore)
    {
        // End:0x87
        if((int(mTeamSpecs[TeamID]) != int(2)) && int(mTeamSpecs[TeamID]) != int(3))
        {
            return true;
        }
    }
    warGameInfo = TurokWarGame(WorldInfo.Game);
    effectorController = none;
    // End:0xD0
    if(Pawn(Effector) != none)
    {
        effectorController = Pawn(Effector).Controller;
    }
    // End:0xF9
    if(warGameInfo != none)
    {
        warGameInfo.ScoreGoal(TeamID, effectorController, self);
    }
    // End:0x13E
    if(TurokCoopGame(WorldInfo.Game) != none)
    {
        TurokCoopGame(WorldInfo.Game).CaptureGoal(TeamID, effectorController, self);
    }
    return true;
    //return ReturnValue;    
}

protected function bool LoseGoal(int TeamID, @NULL Effector, optional bool isCaptureScore = true)
{
    local @NULL warGameInfo, effectorController;

    // End:0x38
    if(((TeamID < 0) || TeamID >= 2) || int(mTeamSpecs[TeamID]) == int(0))
    {
        return false;
    }
    TriggerEventClass(Class'TurokSeqEvent_GoalLost', Effector);
    // End:0x6F
    if(isCaptureScore)
    {
        // End:0x6F
        if(int(mTeamSpecs[TeamID]) != int(2))
        {
            return true;
        }
    }
    warGameInfo = TurokWarGame(WorldInfo.Game);
    effectorController = none;
    // End:0xB8
    if(Pawn(Effector) != none)
    {
        effectorController = Pawn(Effector).Controller;
    }
    // End:0xE0
    if(warGameInfo != none)
    {
        warGameInfo.LoseGoal(TeamID, effectorController);
    }
    // End:0x120
    if(TurokCoopGame(WorldInfo.Game) != none)
    {
        TurokCoopGame(WorldInfo.Game).ReleaseGoal(TeamID, self);
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    mEnabled=true
    mTeamSpecs[0]=2
    mTeamSpecs[1]=2
    bNoDelete=true
    bMovable=false
    // Reference: SpriteComponent'Default__TurokGoalInfo.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokGoal'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    TickGroup=1
    NetUpdateFrequency=1.0000000
    SupportedEvents=/* Array type was not detected. */
}