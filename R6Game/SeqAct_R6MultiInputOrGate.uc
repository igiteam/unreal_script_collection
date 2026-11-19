class SeqAct_R6MultiInputOrGate extends SeqAct_Latent
    native
    hidecategories(Object);

var() int m_iNbInputs;

defaultproperties
{
    m_iNbInputs=1
    InputLinks[0]=(LinkDesc="Input 1",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Multi-Input OR Gate"
    ObjCategory="Misc"
}