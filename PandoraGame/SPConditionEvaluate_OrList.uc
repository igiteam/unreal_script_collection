class SPConditionEvaluate_OrList extends SPConditionEvaluate
    native
    editinlinenew
    collapsecategories;

/** STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() export editinline array<export editinline SPConditionEvaluate> Condition;

event bool Evaluate(Actor Actor, optional Object anObject)
{
    local int Idx;

    // End:0x0F
    if(Condition.Length <= 0)
    {
        return false;
    }
    Idx = 0;
    J0x16:

    // End:0x59 [Loop If]
    if(Idx < Condition.Length)
    {
        // End:0x4F
        if(Condition[Idx].Evaluate(Actor, anObject))
        {
            return true;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x16;
    }
    return false;
    //return ReturnValue;    
}
