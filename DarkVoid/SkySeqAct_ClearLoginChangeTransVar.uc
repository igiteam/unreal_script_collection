class SkySeqAct_ClearLoginChangeTransVar extends SequenceAction;

event Activated()
{
    local GameUISceneClient GSC;

    GSC = Class'Engine.UIRoot'.static.GetSceneClient();
    // End:0x33
    if(GSC != none)
    {
        GSC.bDetectedSigninChangeInLoad = false;
    }
    super(SequenceOp).Activated();
    //return;    
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}
