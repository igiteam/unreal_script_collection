class CCChannelStateOutputStim extends CCChannelState
    native
    hidecategories(Object,Object);

function PostBeginPlay(CCPerformanceState InPS, int TeamIndex)
{
    super.PostBeginPlay(InPS, TeamIndex);
    //return;    
}

function TickChannel(float PerformanceLocalTime_sec)
{
    // End:0x45
    if(!PS.Performance.bDeferOutputStim || PS.IsPerformanceFinished(PerformanceLocalTime_sec))
    {
        super.TickChannel(PerformanceLocalTime_sec);
    }
    //return;    
}

function BeginKey(int KeyIndex, float PerformanceLocalTime_sec)
{
    local CCKeyOutputStim Key;
    local CCPerformerPawn OwnerPawn;
    local int NumberOfNationalities, Index;
    local CCStimulus CCS;
    local CCDirectorNative Director;

    OwnerPawn = CCPerformerPawn(PS.CCP.Owner);
    // End:0x2B3
    if(OwnerPawn != none)
    {
        Key = CCKeyOutputStim(CurrentKeys[KeyIndex]);
        // End:0x2B3
        if((Key != none) && Key.Stimulus != none)
        {
            CCS.StimulusType = Key.Stimulus;
            CCS.SourceActor = OwnerPawn;
            Director = PS.CCP.GetCCDirector();
            // End:0x265
            if(Key.bUseActorCriterion)
            {
                // End:0x155
                if(ClassIsChildOf(Key.ActorCriterion.Class, Class'CCActorCriterionNationality'))
                {
                    Director.BroadcastStimulusGeneral(CCS, Key.Radius, Key.Volumes, Key.bAllActorsInMap, CCActorCriterionNationality(Key.ActorCriterion).Nationality, Key.FilterFunctions);                    
                }
                else
                {
                    // End:0x262
                    if(ClassIsChildOf(Key.ActorCriterion.Class, Class'CCActorCriterionAllegiance'))
                    {
                        NumberOfNationalities = CCActorCriterionAllegiance(Key.ActorCriterion).NumberOfMatchingNationalities(OwnerPawn.CCP.Nationality);
                        Index = 0;
                        J0x1BC:

                        // End:0x25F [Loop If]
                        if(Index < NumberOfNationalities)
                        {
                            Director.BroadcastStimulusGeneral(CCS, Key.Radius, Key.Volumes, Key.bAllActorsInMap, CCActorCriterionAllegiance(Key.ActorCriterion).MatchingNationality(OwnerPawn.CCP.Nationality, Index), Key.FilterFunctions);
                            Index++;
                            // [Loop Continue]
                            goto J0x1BC;
                        }                        
                    }
                }                
            }
            else
            {
                Director.BroadcastStimulusGeneral(CCS, Key.Radius, Key.Volumes, Key.bAllActorsInMap,, Key.FilterFunctions);
            }
        }
    }
    //return;    
}
