class TurokSeqAct_WindAmbient extends SeqAct_Latent
    native
    hidecategories(Object);

var() export editinline @NULL mWindAmbientObject;

defaultproperties
{
    bCallHandler=false
    InputLinks[0]=(LinkDesc="Start",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Abort",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    ObjName="Ambient Wind"
    ObjCategory="Turok Physics"
}