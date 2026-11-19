class CCDirectorAudio extends Object
    native
    hidecategories(Object);

enum ESelectRandomAudioResult
{
    CC_SRAR_OK,                     // 0
    CC_SRAR_EXHAUSTION_OF_REPEATABLE_PERFORMANCES,// 1
    CC_SRAR_NO_PERFORMANCE,         // 2
    CC_SRAR_VOICE_POLICY_VIOLATION, // 3
    CC_SRAR_MAX                     // 4
};

struct native CCActiveAudioStimulus
{
    var CCStimulus Stimulus;
    var init export editinline array<init export editinline CCPerformerNative> ActivePerformers;

    structdefaultproperties
    {
        Stimulus=(StimulusType=none,SourceActor=none,SourceLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),bUseSourceLocation=false,bIsIdle=false)
        ActivePerformers=none
    }
};

var CCDirectorNative Director;
var array<CCActiveAudioStimulus> ActiveAudioStimuli;
var export editinline CCHistory SoundCueHistory;
var export editinline CCHistoryEventAudioPerformance TestAudioPerformanceEvent;
var array<int> VoiceIDUsed;

event int GenerateVoiceID(CCChannelAudio.ENationality Nationality, int PreferredVoiceID, array<int> OnlyVoiceIDs)
{
    local int OIndex, UIndex, XIndex, VoiceID, MaxVoices;

    MaxVoices = Director.GetEffectivePerformanceSet().GetMaxVoicesForNationality(Nationality);
    // End:0xE0
    if((PreferredVoiceID > 0) && (0 == OnlyVoiceIDs.Length) || -1 != OnlyVoiceIDs.Find(PreferredVoiceID))
    {
        OIndex = Class'CCChannelAudio'.static.VoiceID2Index(PreferredVoiceID);
        // End:0xE0
        if((OIndex >= 0) && OIndex < MaxVoices)
        {
            UIndex = OIndex + (int(Nationality) * 9);
            // End:0xE0
            if(0 == VoiceIDUsed[UIndex])
            {
                VoiceID = PreferredVoiceID;
                VoiceIDUsed[UIndex] += 1;
                return VoiceID;
            }
        }
    }
    OIndex = 0;
    J0xE7:

    // End:0x180 [Loop If]
    if(OIndex < MaxVoices)
    {
        UIndex = OIndex + (int(Nationality) * 9);
        // End:0x176
        if(0 == VoiceIDUsed[UIndex])
        {
            VoiceID = Class'CCChannelAudio'.static.Index2VoiceID(OIndex);
            // End:0x176
            if((0 == OnlyVoiceIDs.Length) || -1 != OnlyVoiceIDs.Find(VoiceID))
            {
                VoiceIDUsed[UIndex] += 1;
                return VoiceID;
            }
        }
        ++OIndex;
        // [Loop Continue]
        goto J0xE7;
    }
    // End:0x1BA
    if(OnlyVoiceIDs.Length == 0)
    {
        OIndex = Rand(MaxVoices);
        VoiceID = Class'CCChannelAudio'.static.Index2VoiceID(OIndex);        
    }
    else
    {
        XIndex = Rand(OnlyVoiceIDs.Length);
        VoiceID = OnlyVoiceIDs[XIndex];
        OIndex = Class'CCChannelAudio'.static.VoiceID2Index(VoiceID);
    }
    UIndex = OIndex + (int(Nationality) * 9);
    VoiceIDUsed[UIndex] += 1;
    return VoiceID;
    //return ReturnValue;    
}

event RetireVoiceID(CCChannelAudio.ENationality Nationality, int VoiceID)
{
    local int OIndex, UIndex;

    OIndex = Class'CCChannelAudio'.static.VoiceID2Index(VoiceID);
    // End:0x6E
    if((OIndex >= 0) && OIndex < 9)
    {
        UIndex = OIndex + (int(Nationality) * 9);
        // End:0x6E
        if(VoiceIDUsed[UIndex] > 0)
        {
            VoiceIDUsed[UIndex] -= 1;
        }
    }
    //return;    
}

// Export UCCDirectorAudio::execDetermineSoundCueAgeFactor(FFrame&, void* const)
native function float DetermineSoundCueAgeFactor(string AudioPerformanceID, float CurrentTime_sec, CCHistory.EAgeAttenuationFunction AgeAttenuationFunc, float AgeAttenuationMin_sec, float AgeAttenuationMax_sec);

// Export UCCDirectorAudio::execSelectRandomAlternate(FFrame&, void* const)
private native final function SelectRandomAlternate(CCChannelAudio AudioChannel, float CurrentTime_sec, out CCAudioPerformanceRequest APR);

// Export UCCDirectorAudio::execSortPerformanceRequests(FFrame&, void* const)
private native final function SortPerformanceRequests(out array<CCPerformanceRequest> PerformanceRequests, Actor ClosestToActor);

// Export UCCDirectorAudio::execSelectRandomAudioPerformance(FFrame&, void* const)
private native final function CCDirectorAudio.ESelectRandomAudioResult SelectRandomAudioPerformance(CCPerformerNative CCP, float CurrentTime_sec, CCChannelAudio AudioChannel, out CCAudioPerformanceRequest APR);

// Export UCCDirectorAudio::execCustomizePerformanceRequests(FFrame&, void* const)
native function CustomizePerformanceRequests(CCStimulus Stimulus, CCChannelAudio AudioChannel, float CurrentTime_sec, out array<CCPerformanceRequest> PerformanceRequests);

// Export UCCDirectorAudio::execFindActiveAudioStimulus(FFrame&, void* const)
private native final function int FindActiveAudioStimulus(CCStimulus Stimulus, bool bAddIfNotFound);

private final function DumpPerformanceRequests(array<CCPerformanceRequest> PerformanceRequests)
{
    local int I, Count;

    Count = PerformanceRequests.Length;
    I = 0;
    J0x13:

    // End:0x70 [Loop If]
    if(I < Count)
    {
        // End:0x66
        if((PerformanceRequests[I].CCP != none) && PerformanceRequests[I].CCP.Owner != none)
        {
            // [Explicit Continue]
        }
        ++I;
        // [Loop Continue]
        goto J0x13;
    }
    //return;    
}

function RegisterPerformer(CCPerformerNative CCP, CCStimulus Stimulus, CCChannelAudio AudioChannel, CCAudioPerformanceRequest APR, float StartTime_sec)
{
    local int AASIndex, PRIndex;
    local CCHistoryEventAudioPerformance AudioPerformanceEvent;

    AASIndex = FindActiveAudioStimulus(Stimulus, true);
    // End:0x1F
    if(AASIndex < 0)
    {
        return;
    }
    PRIndex = 0;
    J0x26:

    // End:0x78 [Loop If]
    if(PRIndex < ActiveAudioStimuli[AASIndex].ActivePerformers.Length)
    {
        // End:0x6E
        if(ActiveAudioStimuli[AASIndex].ActivePerformers[PRIndex] == CCP)
        {
            // [Explicit Break]
            goto J0x78;
        }
        ++PRIndex;
        // [Loop Continue]
        goto J0x26;
    }
    J0x78:

    // End:0xB9
    if(PRIndex == ActiveAudioStimuli[AASIndex].ActivePerformers.Length)
    {
        ActiveAudioStimuli[AASIndex].ActivePerformers[PRIndex] = CCP;
    }
    AudioPerformanceEvent = new Class'CCHistoryEventAudioPerformance';
    // End:0x10F
    if(AudioChannel.GetAudioPerformanceID(APR, AudioPerformanceEvent.AudioPerformanceID))
    {
        SoundCueHistory.RecordEvent(AudioPerformanceEvent, StartTime_sec);
    }
    //return;    
}

function UnregisterPerformer(CCPerformerNative CCP, CCStimulus Stimulus)
{
    local int AASIndex, PRIndex;

    AASIndex = FindActiveAudioStimulus(Stimulus, false);
    // End:0x1D
    if(AASIndex < 0)
    {
    }
    // End:0x9D
    if(AASIndex >= 0)
    {
        PRIndex = 0;
        J0x2F:

        // End:0x9D [Loop If]
        if(PRIndex < ActiveAudioStimuli[AASIndex].ActivePerformers.Length)
        {
            // End:0x93
            if(ActiveAudioStimuli[AASIndex].ActivePerformers[PRIndex] == CCP)
            {
                ActiveAudioStimuli[AASIndex].ActivePerformers.Remove(PRIndex, 1);
                // [Explicit Break]
                goto J0x9D;
            }
            ++PRIndex;
            // [Loop Continue]
            goto J0x2F;
        }
    }
    J0x9D:

    //return;    
}

private final function RetireInactiveStimuli()
{
    local int AASIndex;

    AASIndex = ActiveAudioStimuli.Length - 1;
    J0x0F:

    // End:0x4C [Loop If]
    if(AASIndex >= 0)
    {
        // End:0x42
        if(ActiveAudioStimuli[AASIndex].ActivePerformers.Length == 0)
        {
            ActiveAudioStimuli.Remove(AASIndex, 1);
        }
        --AASIndex;
        // [Loop Continue]
        goto J0x0F;
    }
    //return;    
}

function PostBeginPlay(CCDirector InDirector)
{
    local int UIndex;

    Director = InDirector;
    SoundCueHistory.Director = Director;
    VoiceIDUsed.Length = 13 * 9;
    UIndex = 0;
    J0x33:

    // End:0x5A [Loop If]
    if(UIndex < VoiceIDUsed.Length)
    {
        VoiceIDUsed[UIndex] = 0;
        ++UIndex;
        // [Loop Continue]
        goto J0x33;
    }
    //return;    
}

event Tick(float DeltaTime_UNUSED)
{
    RetireInactiveStimuli();
    //return;    
}

defaultproperties
{
    // Reference: CCHistory'Default__CCDirectorAudio.SoundCueHist'
    begin object name=SoundCueHist class=Class'CCHistory'
    end object
    SoundCueHistory=SoundCueHist
    // Reference: CCHistoryEventAudioPerformance'Default__CCDirectorAudio.HistEvent'
    begin object name=HistEvent class=Class'CCHistoryEventAudioPerformance'
    end object
    TestAudioPerformanceEvent=HistEvent
}