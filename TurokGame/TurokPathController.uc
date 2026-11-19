class TurokPathController extends ActorComponent
    native
    hidecategories(Object);

var @NULL mObjectives;
var @NULL mCurrentObjective;
var float mTotalObjectiveWeight;
var() @NULL mNodeGroup;
var() bool mNodeGroupEnabled;
var() bool mbStickToPaths;
var bool mReachedLastSeekPos;
var() name mNodeGroupStreamingAutoLinkName;
var @NULL mLastSeekPos;

event SetNodeGroup(@NULL nodeGroup)
{
    mNodeGroup = nodeGroup;
    //return;    
}

// Export UTurokPathController::execInNodeGroup(FFrame&, void* const)
native final function bool InNodeGroup(@NULL Nav);

// Export UTurokPathController::execFindPathToSeek(FFrame&, void* const)
native function @NULL FindPathToSeek(@NULL Goal, optional @NULL vpos, optional bool weightDetours, optional bool bSkipAheadFull);

// Export UTurokPathController::execReachedSeekToPos(FFrame&, void* const)
native function bool ReachedSeekToPos(@NULL vpos);

// Export UTurokPathController::execIsStickingToPaths(FFrame&, void* const)
native function bool IsStickingToPaths();

// Export UTurokPathController::execSetupSpecialPathAbilities(FFrame&, void* const)
native event SetupSpecialPathAbilities();

// Export UTurokPathController::execHasNodeGroup(FFrame&, void* const)
native function bool HasNodeGroup();

defaultproperties
{
    mNodeGroupEnabled=true
    TickGroup=3
}