class CCLookAtRuleActors extends CCLookAtRuleBase
    native
    editinlinenew
    hidecategories(Object);

var(Actors) float Radius;
var(Actors) bool bInViewCone;
var(Actors) float ViewConeDegrees;
var(Actors) class<Actor> ActorClass;
var(Actors) export editinline array<export editinline CCActorCriterionBase> ActorCriteria;
var(Actors) int MaximumMatches;
var array<CCTarget> EditorTargets;

event bool ActorMatches(CCPerformerNative Performer, Actor CurActor)
{
    local int CriterionIndex;
    local editinline CCPerformer localPerformer;

    localPerformer = CCPerformer(Performer);
    CriterionIndex = 0;
    J0x17:

    // End:0x6E [Loop If]
    if(CriterionIndex < ActorCriteria.Length)
    {
        // End:0x64
        if((ActorCriteria[CriterionIndex] != none) && !ActorCriteria[CriterionIndex].ActorMatches(localPerformer, CurActor))
        {
            return false;
        }
        ++CriterionIndex;
        // [Loop Continue]
        goto J0x17;
    }
    return true;
    //return ReturnValue;    
}

// Export UCCLookAtRuleActors::execEvaluateActor(FFrame&, void* const)
native function EvaluateActor(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl, Actor CurActor, Vector UnitDeltaVec, float CosViewConeHalfRad);

// Export UCCLookAtRuleActors::execEvaluateNative(FFrame&, void* const)
native function EvaluateNative(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl);

event Evaluate(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl)
{
    local int ActorIndex, TargetIndex;
    local Color ActorEditColor;

    UpdateSatellites();
    // End:0x47
    if((Performer != none) && Performer.Owner != none)
    {
        EvaluateNative(Performer, RulesControl, PAControl);        
    }
    else
    {
        ActorEditColor.R = byte(255);
        ActorEditColor.G = byte(255);
        ActorEditColor.B = 0;
        ActorEditColor.A = byte(255);
        EditorTargets.Length = Min(MaximumMatches, RulesControl.MaxTargets);
        ActorIndex = 0;
        J0xB8:

        // End:0x1F7 [Loop If]
        if((ActorIndex < MaximumMatches) && RulesControl.Targets.Length < RulesControl.MaxTargets)
        {
            EditorTargets[ActorIndex].Space = 0;
            EditorTargets[ActorIndex].Weight = Weight;
            EditorTargets[ActorIndex].Id = GenerateTargetId_NameIndex(self.Name, false, ActorIndex);
            EditorTargets[ActorIndex].bIsEditable = true;
            EditorTargets[ActorIndex].EditorColor = ActorEditColor;
            TargetIndex = RulesControl.Targets.Length;
            RulesControl.Targets.Length = TargetIndex + 1;
            RulesControl.Targets[TargetIndex] = EditorTargets[ActorIndex];
            AddSatellites(RulesControl.Targets[TargetIndex], RulesControl);
            ++ActorIndex;
            // [Loop Continue]
            goto J0xB8;
        }
    }
    //return;    
}

event bool EditTarget(CCTarget Target)
{
    local int Index;

    Index = EditorTargets.Find('Id', Target.Id);
    // End:0x44
    if(Index >= 0)
    {
        EditorTargets[Index] = Target;
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    Radius=1000.0000000
    bInViewCone=true
    ViewConeDegrees=200.0000000
    ActorClass=Class'CCPerformerPawn'
    MaximumMatches=10
}