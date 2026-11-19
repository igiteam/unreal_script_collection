class SPConditionEvaluate extends Object
    abstract
    native
    editinlinenew
    collapsecategories;

enum eRangeCondition
{
    eSPInBetweenMinMax,             // 0
    eSPLessThanMin,                 // 1
    eSPGreaterThanMax,              // 2
    eSPIsNegative,                  // 3
    eSPIsPositive,                  // 4
    eRangeCondition_MAX             // 5
};

function bool EvaluteWithActor(Actor Actor)
{
    return false;
    //return ReturnValue;    
}

function bool EvaluteWithSPAnimConditionalSwitchNode(SPAnimConditionalSwitchNode Node)
{
    return false;
    //return ReturnValue;    
}

event bool Evaluate(Actor Actor, optional Object anObject)
{
    local SPAnimConditionalSwitchNode Node;

    // End:0x1C
    if(Actor != none)
    {
        return EvaluteWithActor(Actor);
    }
    Node = SPAnimConditionalSwitchNode(anObject);
    // End:0x47
    if(Node != none)
    {
        return EvaluteWithSPAnimConditionalSwitchNode(Node);
    }
    return false;
    //return ReturnValue;    
}
