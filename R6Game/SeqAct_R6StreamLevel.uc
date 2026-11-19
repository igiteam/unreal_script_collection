class SeqAct_R6StreamLevel extends SeqAct_Latent
    native
    hidecategories(Object);

var() name m_LevelFileName;
var transient LevelStreamingKismet m_StreamingLevel;
var transient bool m_bStreamingState;

defaultproperties
{
    InputLinks[0]=(LinkDesc="StreamIn",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="StreamOut",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Completed",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Stream Level Latent"
    ObjCategory="Level"
}