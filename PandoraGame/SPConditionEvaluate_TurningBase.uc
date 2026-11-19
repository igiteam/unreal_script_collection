class SPConditionEvaluate_TurningBase extends SPConditionEvaluate_Angle
    abstract
    editinlinenew
    collapsecategories;

function bool IsValid(int wAngle)
{
    return false;
    //return ReturnValue;    
}

function bool EvaluteWithActor(Actor Actor)
{
    return IsValid(AntYawRate(Actor));
    //return ReturnValue;    
}

function bool EvaluteWithSPAnimConditionalSwitchNode(SPAnimConditionalSwitchNode Node)
{
    return IsValid(NodeYawRate(Node));
    //return ReturnValue;    
}
