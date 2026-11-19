class SeqAct_SetAnimTree extends SeqAct_Latent
    native;

var() bool bResetToDefault;
var() AnimTree AnimTreeToSet;
var() float BlendTime;

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}
