class TurokSeqEvent_DoorStatus extends SequenceEvent
    hidecategories(Object);

var const int DoorIsOpenLink;
var const int DoorIsClosedLink;

event bool IsValidLevelSequenceObject()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    DoorIsClosedLink=1
    bPlayerOnly=false
    OutputLinks[0]=(Links=none,LinkDesc="FinishedOpen",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="FinishedClose",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Door Status"
}