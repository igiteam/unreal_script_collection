class SkySeqCond_LevelUnlocked extends SequenceCondition
    native;

var() string LevelName;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}
