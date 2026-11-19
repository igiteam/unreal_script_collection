class SeqEvent_ShellSignInChange extends SequenceEvent
    native
    hidecategories(Object);

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=false
    ObjName="Sign In Change"
}