class CCActorCriterionAllegiance extends CCActorCriterionBase
    native
    editinlinenew
    hidecategories(Object,Object);

var(Criterion) bool bSameSide;
var transient CCChannelAudio.ENationality AlliedNations[2];
var transient CCChannelAudio.ENationality AxisNations[10];

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
    return (CCP != none) && (bSameSide && int(CCP.Nationality) == int(Performer.Nationality)) || !bSameSide && int(CCP.Nationality) != int(Performer.Nationality);
    //return ReturnValue;    
}

function int NumberOfMatchingNationalities(CCChannelAudio.ENationality Nationality)
{
    // End:0x33
    if(bSameSide && (int(Nationality) == int(1)) || int(Nationality) == int(1))
    {
        return 2;        
    }
    else
    {
        return 10;
    }
    //return ReturnValue;    
}

function CCChannelAudio.ENationality MatchingNationality(CCChannelAudio.ENationality Nationality, int Index)
{
    local int RealIndex;

    // End:0x4C
    if(bSameSide && (int(Nationality) == int(1)) || int(Nationality) == int(1))
    {
        RealIndex = Clamp(Index, 0, 2);
        return AlliedNations[RealIndex];        
    }
    else
    {
        RealIndex = Clamp(Index, 0, 10);
        return AxisNations[RealIndex];
    }
    //return ReturnValue;    
}

defaultproperties
{
    AlliedNations[0]=1
    AlliedNations[1]=2
    AxisNations[0]=3
    AxisNations[1]=4
    AxisNations[2]=5
    AxisNations[3]=6
    AxisNations[4]=7
    AxisNations[5]=8
    AxisNations[6]=9
    AxisNations[7]=10
    AxisNations[8]=11
    AxisNations[9]=12
}