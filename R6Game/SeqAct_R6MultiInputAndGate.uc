class SeqAct_R6MultiInputAndGate extends SeqAct_Latent
    native
    hidecategories(Object);

struct TempStatus
{
    var bool bStatus;
    var bool bHack;

    structdefaultproperties
    {
        bStatus=false
        bHack=false
    }
};

var() int m_iNbInputs;
var array<TempStatus> m_arrInputStatus;

defaultproperties
{
    m_iNbInputs=1
    m_arrInputStatus[0]=(bStatus=false,bHack=true)
    InputLinks[0]=(LinkDesc="Input 1",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Multi-Input AND Gate"
    ObjCategory="Misc"
}