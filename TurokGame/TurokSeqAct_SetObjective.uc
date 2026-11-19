class TurokSeqAct_SetObjective extends SequenceAction
    hidecategories(Object);

var() @NULL mObjectiveLocation;
var() string mStringID;
var() string mObjectiveName;
var() bool mbOnlyShowText;
var() bool mbOnlyUpdateLocation;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Give Objective",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    ObjName="Set Objective"
    ObjCategory="Turok Gameplay"
}