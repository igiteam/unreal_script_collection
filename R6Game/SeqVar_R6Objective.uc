class SeqVar_R6Objective extends SeqVar_Object
    abstract
    native
    hidecategories(Object);

var class<R6Objective> ObjectiveClass;
var() bool m_bGameOverIfFailed;
var() bool m_bWaypointOnly;
var() bool m_bHiddenInManager;
var() string m_szDescription;
var() Actor m_UseObjectPosition;
var() R6MissionFailedInfo FailureInfo;

// Export USeqVar_R6Objective::execGetDescription(FFrame&, void* const)
native function GetDescription(out string Desc);

// Export USeqVar_R6Objective::execCreateObjective(FFrame&, void* const)
native function CreateObjective();

// Export USeqVar_R6Objective::execDestroyObjective(FFrame&, void* const)
native function DestroyObjective();

// Export USeqVar_R6Objective::execGetFailureReason(FFrame&, void* const)
native function bool GetFailureReason(out R6MissionFailedInfo out_Info);

event EnableObjective()
{
    R6Objective(ObjValue).EnableSelf();
    return;
}

event DisableObjective()
{
    R6Objective(ObjValue).DisableSelf();
    return;
}

defaultproperties
{
    ObjClassVersion=3
    ObjName="Objective"
    ObjColor=(R=0,G=255,B=255,A=255)
}