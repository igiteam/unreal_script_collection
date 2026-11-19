class CCStimulusCriterionNationality extends CCStimulusCriterionBase
    native
    editinlinenew;

var(Criterion) CCChannelAudio.ENationality Nationality;

function bool StimulusMatches(CCPerformerNative Performer, CCStimulus Stimulus)
{
    // End:0x4F
    if(none != CCPerformerPawn(Stimulus.SourceActor))
    {
        return int(CCPerformerPawn(Stimulus.SourceActor).CCP.Nationality) == int(Nationality);        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

defaultproperties
{
    Nationality=1
}