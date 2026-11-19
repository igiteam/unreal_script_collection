class CCLookAtRuleStimuli extends CCLookAtRuleBase
    native
    editinlinenew
    hidecategories(Object);

var(Stimuli) CCStimulusType StimulusType;
var(Stimuli) export editinline array<export editinline CCStimulusCriterionBase> StimulusCriteria;
var(Stimuli) int MaximumMatches;
var array<CCTarget> EditorTargets;

function bool StimulusMatches(CCPerformerNative Performer, CCStimulus Stimulus)
{
    local int CriterionIndex;

    // End:0x1B
    if(StimulusType != Stimulus.StimulusType)
    {
        return false;
    }
    CriterionIndex = 0;
    J0x22:

    // End:0x66 [Loop If]
    if(CriterionIndex < StimulusCriteria.Length)
    {
        // End:0x5C
        if(!StimulusCriteria[CriterionIndex].StimulusMatches(Performer, Stimulus))
        {
            return false;
        }
        ++CriterionIndex;
        // [Loop Continue]
        goto J0x22;
    }
    return true;
    //return ReturnValue;    
}

event Evaluate(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl)
{
    local int StimIndex, TargetIndex, NumRuleMatches;
    local CCStimulus Stimulus;
    local Color StimulusEditColor;

    StimulusEditColor.R = byte(255);
    StimulusEditColor.G = 0;
    StimulusEditColor.B = 0;
    StimulusEditColor.A = byte(255);
    UpdateSatellites();
    // End:0x266
    if(Performer != none)
    {
        NumRuleMatches = 0;
        StimIndex = 0;
        J0x6F:

        // End:0x263 [Loop If]
        if(((StimIndex < Performer.GetStimulusQueueLength()) && RulesControl.Targets.Length < RulesControl.MaxTargets) && NumRuleMatches < MaximumMatches)
        {
            Stimulus = Performer.GetStimulusQueueAt(StimIndex);
            // End:0x259
            if(StimulusMatches(Performer, Stimulus))
            {
                ++NumRuleMatches;
                RulesControl.Targets.Insert(TargetIndex, 1);
                // End:0x156
                if(Stimulus.bUseSourceLocation)
                {
                    RulesControl.Targets[TargetIndex].Position = Stimulus.SourceLocation;                    
                }
                else
                {
                    RulesControl.Targets[TargetIndex].Position = Stimulus.SourceActor.Location;
                }
                RulesControl.Targets[TargetIndex].Space = 0;
                RulesControl.Targets[TargetIndex].Weight = Weight;
                RulesControl.Targets[TargetIndex].Id = GenerateTargetId_NameIndex(Stimulus.SourceActor.Name, false, StimIndex);
                RulesControl.Targets[TargetIndex].bIsEditable = false;
                AddSatellites(RulesControl.Targets[TargetIndex], RulesControl);
            }
            ++StimIndex;
            // [Loop Continue]
            goto J0x6F;
        }        
    }
    else
    {
        EditorTargets.Length = Min(MaximumMatches, RulesControl.MaxTargets);
        StimIndex = 0;
        J0x289:

        // End:0x3C5 [Loop If]
        if((StimIndex < MaximumMatches) && RulesControl.Targets.Length < RulesControl.MaxTargets)
        {
            EditorTargets[StimIndex].Space = 0;
            EditorTargets[StimIndex].Weight = Weight;
            EditorTargets[StimIndex].Id = GenerateTargetId_NameIndex(self.Name, false, StimIndex);
            EditorTargets[StimIndex].bIsEditable = true;
            EditorTargets[StimIndex].EditorColor = StimulusEditColor;
            TargetIndex = RulesControl.Targets.Length;
            RulesControl.Targets.Insert(TargetIndex, 1);
            RulesControl.Targets[TargetIndex] = EditorTargets[StimIndex];
            AddSatellites(RulesControl.Targets[TargetIndex], RulesControl);
            ++StimIndex;
            // [Loop Continue]
            goto J0x289;
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
    MaximumMatches=10
}