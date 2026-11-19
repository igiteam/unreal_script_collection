class CCKeyOutputStim extends CCKey
    editinlinenew
    hidecategories(Object,Object);

var(output) CCStimulusType Stimulus;
var(output) array<Volume> Volumes;
var(output) float Radius;
var(output) bool bAllActorsInMap;
var(output) bool bUseActorCriterion;
var(output) export editinline CCActorCriterionBase ActorCriterion;
var(output) array<name> FilterFunctions;

function string GetDebugString()
{
    // End:0x3A
    if(none != Stimulus)
    {
        return (super.GetDebugString() $ ", StimulusType=") $ string(Stimulus.Name);        
    }
    else
    {
        return super.GetDebugString() $ ", StimulusType=none";
    }
    //return ReturnValue;    
}
