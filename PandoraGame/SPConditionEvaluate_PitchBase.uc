class SPConditionEvaluate_PitchBase extends SPConditionEvaluate_Angle
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
    return IsValid(Actor.Rotation.Pitch);
    //return ReturnValue;    
}

function bool EvaluteWithSPAnimConditionalSwitchNode(SPAnimConditionalSwitchNode Node)
{
    return IsValid(Node.EditorPreview.Rotation.Pitch);
    //return ReturnValue;    
}
