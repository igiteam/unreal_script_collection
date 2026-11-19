class SkySeqAct_Dangle extends SequenceAction
    native;

var() bool bAutoAbort;
var bool bTriggeredDangle;
var bool bDangleSuccess;
var bool bDangleFailure;
var() float ActiveTime;
var float TotalActiveTime;

static event int GetObjClassVersion()
{
    return 2;
    //return ReturnValue;    
}
