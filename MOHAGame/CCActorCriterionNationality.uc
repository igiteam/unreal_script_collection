class CCActorCriterionNationality extends CCActorCriterionBase
    native
    editinlinenew
    hidecategories(Object,Object);

var(Criterion) CCChannelAudio.ENationality Nationality;

function bool ActorMatches(CCPerformer Performer, Actor anActor)
{
    local editinline CCPerformer CCP;

    // End:0x2C
    if(none != CCPerformerPawn(anActor))
    {
        CCP = CCPerformerPawn(anActor).CCP;        
    }
    else
    {
        CCP = none;
    }
    return (CCP != none) && int(CCP.Nationality) == int(Nationality);
    //return ReturnValue;    
}

defaultproperties
{
    Nationality=1
}