class SeqAct_R6DeleteStreamedKismetData extends SeqAct_Latent
    native
    hidecategories(Object);

var() string StreamName;
var transient string m_strFullStreamId;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Delete",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Deleted",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Delete Streamed Data"
    ObjCategory="Streaming"
}