class SeqEvent_ObjectiveChanged extends SequenceEvent
    hidecategories(Object);

enum EObjectiveOutput
{
    OBJECTIVEOUTPUT_ADDED,          // 0
    OBJECTIVEOUTPUT_SUCCESS,        // 1
    OBJECTIVEOUTPUT_FAIL,           // 2
    OBJECTIVEOUTPUT_MAX             // 3
};

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    OutputLinks[0]=(Links=none,LinkDesc="Added",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Succeeded",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Objective Changed"
    ObjCategory="Objectives"
}