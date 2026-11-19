class SeqAct_Gate extends SequenceAction
    native
    hidecategories(Object);

var() bool bOpen;
var bool sbOpen;

defaultproperties
{
    bOpen=true
    InputLinks[0]=(LinkDesc="In",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Open",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Close",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[3]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Gate"
    ObjCategory="Misc"
}