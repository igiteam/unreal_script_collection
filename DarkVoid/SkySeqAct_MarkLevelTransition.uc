class SkySeqAct_MarkLevelTransition extends SequenceAction;

var() bool bMarksStart;

event Activated()
{
    local GameUISceneClient GSC;

    GSC = Class'Engine.UIRoot'.static.GetSceneClient();
    // End:0x3E
    if(GSC != none)
    {
        GSC.bInLoadTransition = ((bMarksStart) ? 1 : 0);
    }
    super(SequenceOp).Activated();
    //return;    
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}
