class SeqAct_R6Nop extends SequenceAction
    native
    hidecategories(Object);

var() int m_iNbInputs;
var() int m_iNbOutputs;

defaultproperties
{
    m_iNbInputs=1
    m_iNbOutputs=1
    InputLinks[0]=(LinkDesc="Input 1",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Output 1",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="NOP"
    ObjCategory="Misc"
}