class TurokSeqAct_SetWargameObjective extends SequenceAction
    hidecategories(Object);

var() @NULL mObjectiveTarget;
var() string mObjectiveHashID;
var() int mObjectiveTeamID;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Set",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    ObjName="Set Wargame Objective"
    ObjCategory="Turok Multiplayer"
}