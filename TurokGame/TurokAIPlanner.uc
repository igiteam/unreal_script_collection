class TurokAIPlanner extends ActorComponent
    native
    hidecategories(Actor,Object,ActorComponent);

enum EPlannerPriority
{
    PLANNERPRIORITY_High,           // 0
    PLANNERPRIORITY_Normal,         // 1
    PLANNERPRIORITY_Low,            // 2
    PLANNERPRIORITY_Failsafe,       // 3
    PLANNERPRIORITY_MAX             // 4
};

struct native AIGoalInfo
{
    var() name mGoalName;
    var() array mAction;
    var() name mSteeringPreset;
    var() byte mPriority;
    var() byte mEmergentPriority;
    var() bool mRandomActionPriority;
    var array mRandomActionIndexes;

    structdefaultproperties
    {
        mGoalName="None"
        mAction=none
        mSteeringPreset="None"
        mPriority=1
        mEmergentPriority=0
        mRandomActionPriority=false
        mRandomActionIndexes=none
    }
};

var int mCurrentGoalIndex;
var int mCurrentActionIndex;
var() array mAIGoal;
var() bool mEmergentBehavior;
var bool mSortedGoals;

// Export UTurokAIPlanner::execIncrGoalIndex(FFrame&, void* const)
native final function IncrGoalIndex();

// Export UTurokAIPlanner::execResetGoalIndex(FFrame&, void* const)
native final function ResetGoalIndex();

// Export UTurokAIPlanner::execGetSteerPresetNameInCurrentGoal(FFrame&, void* const)
native final function name GetSteerPresetNameInCurrentGoal();

// Export UTurokAIPlanner::execSortGoals(FFrame&, void* const)
native final function SortGoals();

// Export UTurokAIPlanner::execEmergentBehavior(FFrame&, void* const)
native final function EmergentBehavior();

// Export UTurokAIPlanner::execResetActionIndex(FFrame&, void* const)
native final function ResetActionIndex();

// Export UTurokAIPlanner::execGetCurrentGoalName(FFrame&, void* const)
native final function name GetCurrentGoalName();

// Export UTurokAIPlanner::execGetNextActionInCurrentGoal(FFrame&, void* const)
native final function name GetNextActionInCurrentGoal();

// Export UTurokAIPlanner::execGetNextGoal(FFrame&, void* const)
native final function name GetNextGoal();

defaultproperties
{
    mCurrentGoalIndex=-1
    mCurrentActionIndex=-1
    TickGroup=3
}