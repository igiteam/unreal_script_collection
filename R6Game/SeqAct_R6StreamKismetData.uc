class SeqAct_R6StreamKismetData extends SeqAct_Latent
    native
    hidecategories(Object);

var bool m_bIsStreaming;
var bool m_bIsDeleting;
var bool m_bStreamingFinished;
var() string StreamName;
var transient string m_strFullStreamId;
var float m_fStreamTime;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Stream",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Delete",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Deleted",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Stream Kismet Data"
    ObjCategory="Streaming"
}