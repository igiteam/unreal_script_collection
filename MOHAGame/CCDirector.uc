class CCDirector extends CCDirectorNative
    notplaceable
    hidecategories(Navigation,Object,Object);

var(Debug) bool bDebugDrawAll;

function DeclareFaceFXRegisters(SkeletalMeshComponent MeshComp)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4D [Loop If]
    if(I < GlobalPerformanceSet.FaceFXRegisters.Length)
    {
        MeshComp.DeclareFaceFXRegister(GlobalPerformanceSet.FaceFXRegisters[I]);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function BroadcastStimulus(CCStimulus Stimulus, float Radius, optional CCChannelAudio.ENationality OnlyNationality = 0, optional bool bAllowGhostAudio = true, optional array<name> FilterFunctions)
{
    local Pawn PlayerPawn;
    local Actor ClosestToActor;
    local CCPerformerPawn PP;
    local int PIndex, SentToCount;
    local CCPerformance2 Performance;
    local Vector DeltaVec;
    local float RadiusSq, DeltaDistSq;
    local MOHASingleplayerPawn SingleplayerPawn;

    SentToCount = 0;
    Performance = FindPerformance(Stimulus.StimulusType, PIndex);
    // End:0x469
    if(none != Performance)
    {
        PlayerPawn = FindPlayerPawn();
        // End:0x469
        if(none != PlayerPawn)
        {
            // End:0x108
            if(bLogToCSV)
            {
                AnnotateCSVLog(string(Stimulus.StimulusType.Name), (((((("Broadcasting [" $ string(Stimulus.StimulusType.Name)) $ " ") $ string(Stimulus.SourceActor.Name)) $ "] Radius=") $ string(Radius)) $ " OnlyNationality=") $ string(OnlyNationality));
            }
            // End:0x121
            if(Radius <= 0.0000000)
            {
                ClosestToActor = none;                
            }
            else
            {
                switch(Performance.AudioChannel.ProximityPolicy)
                {
                    // End:0x149
                    case 0:
                        ClosestToActor = none;
                        // End:0x186
                        break;
                    // End:0x15C
                    case 1:
                        ClosestToActor = PlayerPawn;
                        // End:0x186
                        break;
                    // End:0x179
                    case 2:
                        ClosestToActor = Stimulus.SourceActor;
                        // End:0x186
                        break;
                    // End:0xFFFF
                    default:
                        ClosestToActor = none;
                        // End:0x186
                        break;
                        break;
                }
            }
            // End:0x26B
            if(none != ClosestToActor)
            {
                RadiusSq = Radius * Radius;
                // End:0x267
                foreach PlayerPawn.WorldInfo.AllPawns(Class'CCPerformerPawn', PP)
                {
                    // End:0x266
                    if(none != PP)
                    {
                        DeltaVec = ClosestToActor.Location - PP.Location;
                        DeltaDistSq = DeltaVec Dot DeltaVec;
                        // End:0x266
                        if(DeltaDistSq <= RadiusSq)
                        {
                            // End:0x266
                            if(PP.CCP.OnStimulusConditional(Stimulus, OnlyNationality, Performance.AudioChannel.VoicePolicy, FilterFunctions))
                            {
                                ++SentToCount;
                            }
                        }
                    }                    
                }                                
            }
            else
            {
                // End:0x2EA
                foreach PlayerPawn.WorldInfo.AllPawns(Class'CCPerformerPawn', PP)
                {
                    // End:0x2E9
                    if(none != PP)
                    {
                        // End:0x2E9
                        if(PP.CCP.OnStimulusConditional(Stimulus, OnlyNationality, Performance.AudioChannel.VoicePolicy, FilterFunctions))
                        {
                            ++SentToCount;
                        }
                    }                    
                }                
            }
            // End:0x37B
            if(((bAllowGhostAudio && SentToCount == 0) && Performance.AudioChannel.bGhostAudio) && (int(OnlyNationality) == int(0)) || int(OnlyNationality) == int(1))
            {
                SingleplayerPawn = MOHASingleplayerPawn(PlayerPawn);
                // End:0x37B
                if(none != SingleplayerPawn)
                {
                    SentToCount = SingleplayerPawn.BroadcastCCStimulusToGhostPerformers(Stimulus);
                }
            }
            // End:0x3F7
            if(SentToCount == 0)
            {
                // End:0x3F4
                if(bLogToCSV)
                {
                    AnnotateCSVLog(string(Stimulus.StimulusType.Name), ("No NPCs to broadcast to for [" $ string(Stimulus.StimulusType.Name)) $ "]");
                }                
            }
            else
            {
                // End:0x469
                if(bLogToCSV)
                {
                    AnnotateCSVLog(string(Stimulus.StimulusType.Name), ((("Broadcast [" $ string(Stimulus.StimulusType.Name)) $ "] to ") $ string(SentToCount)) $ " NPCs");
                }
            }
        }
    }
    //return;    
}

function BroadcastStimulusWithinVolume(CCStimulus Stimulus, Volume ActorVolume, optional CCChannelAudio.ENationality OnlyNationality = 0, optional array<name> FilterFunctions)
{
    local CCPerformerPawn PP;
    local int PIndex, SentToCount;
    local CCPerformance2 Performance;
    local MOHASingleplayerPawn SingleplayerPawn;

    // End:0x14
    if(none == ActorVolume)
    {
        return;
    }
    SentToCount = 0;
    Performance = FindPerformance(Stimulus.StimulusType, PIndex);
    // End:0x304
    if(none != Performance)
    {
        // End:0x10C
        if(bLogToCSV)
        {
            AnnotateCSVLog(string(Stimulus.StimulusType.Name), (((((("Broadcasting within volume [" $ string(Stimulus.StimulusType.Name)) $ " ") $ string(Stimulus.SourceActor.Name)) $ "] Volume=") $ string(ActorVolume.Name)) $ " OnlyNationality=") $ string(OnlyNationality));
        }
        // End:0x17D
        foreach ActorVolume.TouchingActors(Class'CCPerformerPawn', PP)
        {
            // End:0x17C
            if(none != PP)
            {
                // End:0x17C
                if(PP.CCP.OnStimulusConditional(Stimulus, OnlyNationality, Performance.AudioChannel.VoicePolicy, FilterFunctions))
                {
                    ++SentToCount;
                }
            }            
        }        
        // End:0x208
        if(((SentToCount == 0) && Performance.AudioChannel.bGhostAudio) && (int(OnlyNationality) == int(0)) || int(OnlyNationality) == int(1))
        {
            SingleplayerPawn = MOHASingleplayerPawn(FindPlayerPawn());
            // End:0x208
            if(none != SingleplayerPawn)
            {
                SentToCount = SingleplayerPawn.BroadcastCCStimulusToGhostPerformers(Stimulus);
            }
        }
        // End:0x28B
        if(SentToCount == 0)
        {
            // End:0x288
            if(bLogToCSV)
            {
                AnnotateCSVLog(string(Stimulus.StimulusType.Name), ("No NPCs to volume broadcast to for [" $ string(Stimulus.StimulusType.Name)) $ "]");
            }            
        }
        else
        {
            // End:0x304
            if(bLogToCSV)
            {
                AnnotateCSVLog(string(Stimulus.StimulusType.Name), ((("Volume broadcast [" $ string(Stimulus.StimulusType.Name)) $ "] to ") $ string(SentToCount)) $ " NPCs");
            }
        }
    }
    //return;    
}

event RequestPerformance(CCPerformerNative CCP, CCStimulus Stimulus)
{
    local int RSIndex, CCPIndex;

    RSIndex = FindRequestedStimulusIndex(Stimulus, true);
    CCPIndex = RequestedStimuli[RSIndex].PerformanceRequests.Length;
    RequestedStimuli[RSIndex].PerformanceRequests.Length = CCPIndex + 1;
    RequestedStimuli[RSIndex].PerformanceRequests[CCPIndex].CCP = CCP;
    //return;    
}

event PostBeginPlay()
{
    // End:0x1E
    if(none != GlobalPerformanceSet)
    {
        GlobalPerformanceSet.PostBeginPlay();
    }
    CurrentCCLevelInfo = none;
    bSearchedForCCLevelInfo = false;
    GetCCLevelInfo();
    EnabledStateRaw = 4;
    SetEnabledState(EnabledState);
    AudioDirector.PostBeginPlay(self);
    //return;    
}

function ToggleCCEnabled()
{
    EnabledState = byte(int(EnabledStateRaw) + 1);
    // End:0x2A
    if(int(EnabledState) == int(4))
    {
        EnabledState = 0;
    }
    SetEnabledState(EnabledState);
    //return;    
}

function DisableAID()
{
    EnabledState = 2;
    SetEnabledState(EnabledState);
    //return;    
}

function EnableAID()
{
    EnabledState = 1;
    SetEnabledState(EnabledState);
    //return;    
}

defaultproperties
{
    GlobalPerformanceSet=CCPerformanceSet2'MOHA_CC.Performances.DefaultPerformanceSet2'
    // Reference: CCDirectorAudio'Default__CCDirector.AudioDir'
    begin object name=AudioDir
    end object
    AudioDirector=AudioDir
    EnabledState=1
}