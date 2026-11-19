class TurokSeqAct_FE extends SequenceAction
    native
    hidecategories(Object);

var() string mScene;
var() byte mType;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Open",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Close",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Turok FE"
    ObjCategory="Turok"
}