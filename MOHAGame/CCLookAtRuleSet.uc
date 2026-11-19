class CCLookAtRuleSet extends CCLookAtRuleBase
    native
    editinlinenew
    hidecategories(Object,Object,Rule);

struct native CCWeightedRule
{
    var() CCLookAtRuleBase Rule;
    var() float Weight;

    structdefaultproperties
    {
        Rule=none
        Weight=1.0000000
    }
};

var(RuleSet) array<CCWeightedRule> LookAtRules;

// Export UCCLookAtRuleSet::execEvaluateNative(FFrame&, void* const)
native function EvaluateNative(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl);

event Evaluate(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl)
{
    EvaluateNative(Performer, RulesControl, PAControl);
    //return;    
}

event bool EditTarget(CCTarget Target)
{
    local int RuleIndex;

    RuleIndex = 0;
    J0x07:

    // End:0x4E [Loop If]
    if(RuleIndex < LookAtRules.Length)
    {
        // End:0x44
        if(LookAtRules[RuleIndex].Rule.EditTarget(Target))
        {
            return true;
        }
        ++RuleIndex;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}
