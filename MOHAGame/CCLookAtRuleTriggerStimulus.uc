class CCLookAtRuleTriggerStimulus extends CCLookAtRuleBase
    native
    editinlinenew
    hidecategories(Object,Object);

var(TriggerStimulus) CCTarget EditorTarget;

event Evaluate(CCPerformerNative Performer, SkelControlLookAtRules RulesControl, SkelControlPA PAControl)
{
    local CCStimulus Stimulus;
    local int TargetIndex;
    local Color TriggerEditColor;

    TriggerEditColor.R = byte(255);
    TriggerEditColor.G = byte(255);
    TriggerEditColor.B = 0;
    TriggerEditColor.A = byte(255);
    UpdateSatellites();
    // End:0x252
    if(Performer != none)
    {
        // End:0x24F
        if(Performer.PerformanceState.bInProgress)
        {
            Stimulus = Performer.PerformanceState.Stimulus;
            TargetIndex = RulesControl.Targets.Length;
            RulesControl.Targets.Insert(TargetIndex, 1);
            // End:0x109
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
            // End:0x1CC
            if(Stimulus.bUseSourceLocation)
            {
                RulesControl.Targets[TargetIndex].Id = GenerateTargetId_NameIndex(self.Name, false, 0);                
            }
            else
            {
                RulesControl.Targets[TargetIndex].Id = GenerateTargetId_NameIndex(Stimulus.SourceActor.Name, false, 0);
            }
            RulesControl.Targets[TargetIndex].bIsEditable = false;
            AddSatellites(RulesControl.Targets[TargetIndex], RulesControl);
        }        
    }
    else
    {
        EditorTarget.Space = 0;
        EditorTarget.Weight = Weight;
        EditorTarget.Id = self.Name;
        EditorTarget.bIsEditable = true;
        EditorTarget.EditorColor = TriggerEditColor;
        TargetIndex = RulesControl.Targets.Length;
        RulesControl.Targets.Insert(TargetIndex, 1);
        RulesControl.Targets[TargetIndex] = EditorTarget;
        AddSatellites(RulesControl.Targets[TargetIndex], RulesControl);
    }
    //return;    
}

event bool EditTarget(CCTarget Target)
{
    EditorTarget = Target;
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    EditorTarget=(Id="Undefined",Position=(X=0.0000000,Y=0.0000000,Z=0.0000000),Space=5,SpaceBoneName="Root",actorName="None",Weight=1.0000000,bIsEditable=true,EditorColor=(R=128,G=255,B=255,A=255))
}