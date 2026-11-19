class SkySeqAct_ForceTargeting extends SequenceAction
    native;

enum EForceTargetMode
{
    EFTM_ForceOn,                   // 0
    EFTM_Clear,                     // 1
    EFTM_ForceOff,                  // 2
    EFTM_MAX                        // 3
};

var() SkySeqAct_ForceTargeting.EForceTargetMode TargetingMode;

static event int GetObjClassVersion()
{
    return 1;
    //return ReturnValue;    
}
