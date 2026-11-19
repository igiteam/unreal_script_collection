class SkySeqAct_UnlockAchievement extends SequenceAction
    native;

var() SkySeqAct_TrophyBookkeeping.ETrophy AchievementId;
var() SkyPlayerControllerBase SPCB;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}
