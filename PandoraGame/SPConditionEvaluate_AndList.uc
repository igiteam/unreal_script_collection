class SPConditionEvaluate_AndList extends SPConditionEvaluate
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

    // End:0x5B [Loop If]
    if(Idx < Condition.Length)
    {
        // End:0x51
        if(!Condition[Idx].Evaluate(Actor, anObject))
        {
            return false;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x16;
    }
    return true;
    //return ReturnValue;    
}
