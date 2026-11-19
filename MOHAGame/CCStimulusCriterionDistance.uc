class CCStimulusCriterionDistance extends CCStimulusCriterionBase
    native
    editinlinenew;

var(Criterion) CCStimulusCriterionBase.ECCComparison Comparison;
var(Criterion) float Distance;

function bool StimulusMatches(CCPerformerNative Performer, CCStimulus Stimulus)
{
    local Vector DeltaVec;
    local float Dist2;

    DeltaVec = Stimulus.SourceActor.Location - Performer.Owner_GetLocation();
    Dist2 = DeltaVec Dot DeltaVec;
    // End:0x6C
    if(int(Comparison) == int(0))
    {
        return (Distance * Distance) < Dist2;        
    }
    else
    {
        // End:0x93
        if(int(Comparison) == int(2))
        {
            return (Distance * Distance) > Dist2;            
        }
        else
        {
            return (Distance * Distance) == Dist2;
        }
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    Distance=1000.0000000
}