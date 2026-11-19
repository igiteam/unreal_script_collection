class UTSeqAct_StopCameraAnim extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bStopImmediately;

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 0;
    //return ReturnValue;    
}

defaultproperties
{
    ObjName="Stop Camera Animation"
}