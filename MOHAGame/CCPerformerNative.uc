class CCPerformerNative extends MOHAScriptTickComponent
    native
    hidecategories(Object);

enum EDeathState
{
    CC_DS_ALIVE,                    // 0
    CC_DS_DYING_PASSIVE,            // 1
    CC_DS_DYING_ACTIVE,             // 2
    CC_DS_DEAD,                     // 3
    CC_DS_MAX                       // 4
};

struct native CCBodyState
{
    var name oir;
    var name activity;
    var name Pose;
    var bool bInOIR;
    var bool bFiring;
    var CCIdleStimulus IdleStim;

    structdefaultproperties
    {
        oir="None"
        activity="None"
        Pose="None"
        bInOIR=false
        bFiring=false
        IdleStim=(StimulusType=none,RestrictionLevel=0,OptionalOneShotStimulusType=none,OIRIndex=-1,ActivityIndex=-1)
    }
};

var(Performer) int VoiceID;
var(Performer) bool bVoiceIDNeverExpires;
var bool bNoPA;
var bool bNoExpression;
var(Performer) CCChannelAudio.ENationality Nationality;
var(Performer) CCChannelAudio.EVocalState VocalState;
var protected export editinline CCStimulusType IdlePerformanceStimulusType;
var protected export editinline Actor IdlePerformanceActor;
var transient bool bDisabled;
var transient bool bVoiceIDHasExpired;
var protected transient CCPerformerNative.EDeathState DeathState;
var transient array<CCStimulus> StimulusQueue;
var transient array<CCStimulus> LastStimulusQueue;
var export editinline transient CCHistory StimulusHistory;
var export editinline transient CCPerformanceState PerformanceState;
var export editinline transient CCHistoryEventStimulus TestStimulusHistoryEvent;
var protected transient float TimeOfDeath_sec;
var protected transient CCBodyState BodyState;
var export transient name LastStimulusName;
var export transient float LastStimulusTime_sec;
var const name Name_Human;
var const name Name_Locomotion_Active;
var const name Name_Locomotion_Hip;
var const name Name_Locomotion_Passive;
var const name Name_Locomotion_Retreat;

// Export UCCPerformerNative::execGetCCDirector(FFrame&, void* const)
native final function CCDirectorNative GetCCDirector();

// Export UCCPerformerNative::execIsEnabled(FFrame&, void* const)
native final function bool IsEnabled();

// Export UCCPerformerNative::execCallFunctionOnPerformer(FFrame&, void* const)
native final function bool CallFunctionOnPerformer(Actor Performer, name FunctionName);

event int Owner_GetHealth()
{
    //return ReturnValue;    
}

// Export UCCPerformerNative::execTickWhileEnabled(FFrame&, void* const)
native function TickWhileEnabled(float DeltaTime_sec);

// Export UCCPerformerNative::execTickWhileDisabled(FFrame&, void* const)
native function TickWhileDisabled(float DeltaTime_sec);

// Export UCCPerformerNative::execGetEffectiveActivePerformancePriority(FFrame&, void* const)
protected native function int GetEffectiveActivePerformancePriority(optional int logLevel);

// Export UCCPerformerNative::execFindBestStimulusIndex(FFrame&, void* const)
private native final function int FindBestStimulusIndex();

// Export UCCPerformerNative::execProcessAllStimuli(FFrame&, void* const)
private native final function ProcessAllStimuli();

// Export UCCPerformerNative::execSaveLastStimulusQueue(FFrame&, void* const)
private native final function SaveLastStimulusQueue();

// Export UCCPerformerNative::execCheckRetireVoiceID(FFrame&, void* const)
private native final function CheckRetireVoiceID();

// Export UCCPerformerNative::execValidateVoiceID(FFrame&, void* const)
protected native function ValidateVoiceID();

// Export UCCPerformerNative::execGetVoiceID(FFrame&, void* const)
native function int GetVoiceID();

// Export UCCPerformerNative::execSetVoiceID(FFrame&, void* const)
native function SetVoiceID(int Id);

// Export UCCPerformerNative::execIsVoicePolicyAdheredTo(FFrame&, void* const)
native function bool IsVoicePolicyAdheredTo(CCChannelAudio.EVoicePolicy VoicePolicy);

// Export UCCPerformerNative::execDeliverPerformance(FFrame&, void* const)
native function DeliverPerformance(CCPerformance2 Performance, CCStimulus InResponseToStimulus, CCAudioPerformanceRequest APR);

// Export UCCPerformerNative::execOwner_GetDesiredLocomotionPosture(FFrame&, void* const)
native function int Owner_GetDesiredLocomotionPosture();

// Export UCCPerformerNative::execOwner_GetLocation(FFrame&, void* const)
native event Vector Owner_GetLocation();

// Export UCCPerformerNative::execOwner_GetRotation(FFrame&, void* const)
native function Rotator Owner_GetRotation();

// Export UCCPerformerNative::execOwner_GetSkeletalMeshComponent(FFrame&, void* const)
native function SkeletalMeshComponent Owner_GetSkeletalMeshComponent();

// Export UCCPerformerNative::execOwner_IsAIPauseable(FFrame&, void* const)
native event bool Owner_IsAIPauseable(int PauseImportance);

// Export UCCPerformerNative::execOwner_IsAIPaused(FFrame&, void* const)
native function bool Owner_IsAIPaused();

// Export UCCPerformerNative::execOwner_PauseAI(FFrame&, void* const)
native function bool Owner_PauseAI(int PauseImportance);

event Owner_OnCCPerformanceStarted(CCPerformance2 Performance, float performanceDuration)
{
    //return;    
}

event OnPerformanceComplete(CCStimulusType StimulusType, bool bStartingNewPerformance)
{
    //return;    
}

event AudioComponent Owner_GetFaceFXAudioComponent()
{
    // End:0x1F
    if(Owner != none)
    {
        return Owner.GetFaceFXAudioComponent();
    }
    return none;
    //return ReturnValue;    
}

function CCChannelAudio.ENationality Owner_GetNationality()
{
    return 1;
    //return ReturnValue;    
}

function PlayerController FindPlayerController()
{
    return GetCCDirector().FindPlayerController();
    //return ReturnValue;    
}

function int GetStimulusQueueLength()
{
    return StimulusQueue.Length;
    //return ReturnValue;    
}

function CCStimulus GetStimulusQueueAt(int Index)
{
    return StimulusQueue[Index];
    //return ReturnValue;    
}

function bool GetCurrentStimulus(CCStimulus Stimulus)
{
    // End:0x2B
    if(PerformanceState.bInProgress)
    {
        Stimulus = PerformanceState.Stimulus;
        return true;        
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
    bDisabled=true
    bVoiceIDHasExpired=true
    // Reference: CCHistory'Default__CCPerformerNative.StimHistNative'
    begin object name=StimHistNative class=Class'CCHistory'
    end object
    StimulusHistory=StimHistNative
    // Reference: CCPerformanceState'Default__CCPerformerNative.PerfStateNative'
    begin object name=PerfStateNative class=Class'CCPerformanceState'
    end object
    PerformanceState=PerfStateNative
    // Reference: CCHistoryEventStimulus'Default__CCPerformerNative.HistEvent'
    begin object name=HistEvent class=Class'CCHistoryEventStimulus'
    end object
    TestStimulusHistoryEvent=HistEvent
    TimeOfDeath_sec=-1.0000000
    BodyState=(oir="None",activity="None",Pose="None",bInOIR=false,bFiring=false,IdleStim=(StimulusType=none,RestrictionLevel=0,OptionalOneShotStimulusType=none,OIRIndex=-1,ActivityIndex=-1))
    Name_Human="Human"
    Name_Locomotion_Active="Locomotion_Active"
    Name_Locomotion_Hip="Locomotion_Hip"
    Name_Locomotion_Passive="Locomotion_Passive"
    Name_Locomotion_Retreat="Locomotion_Retreat"
}