class CCStimulusCriterionPriority extends CCStimulusCriterionBase
    native
    editinlinenew;

var(Criterion) CCStimulusCriterionBase.ECCComparison Comparison;
var(Criterion) CCStimulusType.ECCPriority PriorityLevel;

function bool StimulusMatches(CCPerformerNative Performer, CCStimulus Stimulus)
{
    // End:0x37
    if(int(Comparison) == int(0))
    {
        return int(Stimulus.StimulusType.PriorityLevel) < int(PriorityLevel);        
    }
    else
    {
        // End:0x6E
        if(int(Comparison) == int(2))
        {
            return int(Stimulus.StimulusType.PriorityLevel) < int(PriorityLevel);            
        }
        else
        {
            return int(Stimulus.StimulusType.PriorityLevel) == int(PriorityLevel);
        }
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    PriorityLevel=4
}