class CCLookAtRulePlaced extends CCLookAtRuleBase
    native
    editinlinenew
    hidecategories(Object);

var(Placed) array<CCTarget> Targets;

// Export UCCLookAtRulePlaced::execEvaluateNative(FFrame&, void* const)
native function EvaluateNative(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl);

event Evaluate(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl)
{
    EvaluateNative(Performer, RulesControl, PAControl);
    //return;    
}

event bool EditTarget(CCTarget Target)
{
    local int Index;

    Index = Targets.Find('Id', Target.Id);
    // End:0x44
    if(Index >= 0)
    {
        Targets[Index] = Target;
        return true;
    }
    return false;
    //return ReturnValue;    
}
